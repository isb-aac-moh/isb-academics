#!/usr/bin/env python3
"""Read image-only pages of the Moodle PDFs with Tesseract (free, runs on this Mac) and add the text to moodle/extract.

Stamped identity text is removed from the page before it is turned into an image, so OCR can't read it back,
and any surviving match fails the file. Only files likely to become cards are read; held groups are left alone.
Safe to re-run: finished files are skipped. Prints counts only.

  COMPASS_LEAK_PATTERNS="..." python3 scripts/compass/moodle_ocr.py [--sample N]
"""
import argparse, collections, concurrent.futures as cf, csv, json, os, re, subprocess
import fitz
from moodle_extract import LEAK, OUT, SRC, no_email

USE = {"slides", "session notes", "unsure document", "moodle page"}
MIN_WORDS, DPI = 20, 200

def diagonal(line): return 0.05 < abs(line["dir"][1]) < 0.95

def own_text(page):
    """Real text on a sideways page, which the first extraction drops because it can't tell it from a watermark."""
    lines = ["".join(s["text"] for s in l["spans"]).strip() for b in page.get_text("dict")["blocks"] for l in b.get("lines", []) if not diagonal(l)]
    return [l for l in lines if l and not any(re.search(p, l, re.I) for p in LEAK)]

def strip_stamps(page):
    """Delete diagonal text and identity lines from the page itself. Pictures and sideways pages stay, so the content is kept."""
    found = False
    for block in page.get_text("dict")["blocks"]:
        for line in block.get("lines", []):
            text = "".join(s["text"] for s in line["spans"])
            if diagonal(line) or any(re.search(p, text, re.I) for p in LEAK):
                page.add_redact_annot(line["bbox"]); found = True
    if found: page.apply_redactions(images=fitz.PDF_REDACT_IMAGE_NONE, graphics=fitz.PDF_REDACT_LINE_ART_NONE)

def ocr(png):
    run = subprocess.run(["tesseract", "stdin", "stdout", "--psm", "3", "-l", "eng"], input=png, capture_output=True, env={**os.environ, "OMP_THREAD_LIMIT": "1"}, timeout=180)
    return run.stdout.decode("utf8", "ignore")

def one(row):
    course, name = row["course"], row["file"]; path = f"{OUT}/{course}/{name}.json"
    d = json.load(open(path))
    if d["meta"].get("ocr"): return course, name, "already done", 0
    doc = fitz.open(f"{SRC}/{course}/{name}"); read = 0
    for saved, page in zip(d["pages"], doc):
        if len(saved["text"].split()) >= MIN_WORDS: continue
        lines = own_text(page)
        if len(" ".join(lines).split()) < MIN_WORDS:
            strip_stamps(page)
            text = ocr(page.get_pixmap(dpi=DPI).tobytes("png"))
            lines = [l.strip() for l in text.splitlines() if len(l.strip()) > 1 and not any(re.search(p, l, re.I) for p in LEAK)]
        saved["text"] = no_email("\n".join(lines)); saved["heading"] = saved["heading"] or (lines[0][:120] if lines else ""); read += 1
    blob = "\n".join(p["text"] for p in d["pages"])
    if any(re.search(p, blob, re.I) for p in LEAK): return course, name, "identity trace: not saved", 0
    d["meta"]["ocr"] = True
    json.dump(d, open(path + ".tmp", "w")); os.replace(path + ".tmp", path)
    return course, name, "ok", len(blob.split())

def main():
    ap = argparse.ArgumentParser(); ap.add_argument("--sample", type=int); args = ap.parse_args()
    rows = list(csv.DictReader(open(f"{OUT}/sorted.csv")))
    todo = [r for r in rows if r["status"].startswith("mostly") and r["kind"] in USE and not r["duplicate_of"]]
    if args.sample: todo = sorted(todo, key=lambda r: int(r["pages"]))[:args.sample]
    print(f"{len(todo)} files, {sum(int(r['pages']) for r in todo)} pages", flush=True)
    results = {}
    with cf.ProcessPoolExecutor(max_workers=max(2, (os.cpu_count() or 4) - 2)) as pool:
        for job in cf.as_completed([pool.submit(one, r) for r in todo]):
            try: course, name, status, words = job.result()
            except Exception as e: print("  failed:", type(e).__name__, flush=True); continue
            results[(course, name)] = (status, words)
            print(f"  {len(results)}/{len(todo)} {course} {status} {words:,} words", flush=True)
    for r in rows:
        got = results.get((r["course"], r["file"]))
        if got and got[0] == "ok": r["status"], r["words"] = "ok (OCR)", got[1]
        elif got and got[0].startswith("identity"): r["status"] = got[0]
    with open(f"{OUT}/sorted.csv", "w", newline="") as o:
        w = csv.DictWriter(o, fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows)
    print("done", dict(collections.Counter(s for s, _ in results.values())), "| words", sum(w for _, w in results.values()))

if __name__ == "__main__": main()
