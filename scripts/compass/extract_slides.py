#!/usr/bin/env python3
"""Inventory and extract text from official course files for the POC courses.

  --manifest-only   list what would be read (no download, no extraction)
Writes one JSON per file under OUT/<COURSE>/ plus manifest.csv. Identity stamps are removed
before anything is written, then a leak scan fails the file if any pattern survives.
Personal leak patterns come from the COMPASS_LEAK_PATTERNS env var (comma separated), never the repo.
"""
import argparse, csv, json, os, re, sys, zipfile, collections
import fitz  # PyMuPDF

ISB = os.path.expanduser("~/Library/CloudStorage/OneDrive-IndianSchoolofBusiness/ISB")
OUT = os.path.expanduser("~/Downloads/compass-build/extract")
COURSES = {"STRG": "Term2/T2-STRG", "FRNT": "Term2/T2-FRNT", "OPMG": "Term3/OPMG",
           "BANM": "Term3/BANM", "MKTG": "Term3/MKTG", "SWPM": "Term4/SWPM"}
SKIP_DIR = re.compile(r"claude|ishu|trishala|my-notes|explainer|written notes|assignments?|presentation|"
                      r"final project|group project|datasets|pre-?reads|quiz-cheatsheet|week1|^isb$|markdown|"
                      r"practice|questions|sample|interviews|case$", re.I)
SKIP_FILE = re.compile(r"cheat|study ?guide|summary|notes? -|master notes|report|writeup|draft|submission|"
                       r"filewithwatermark|flow_summary|annotated 2|~\$|\.md$|\.html$|reimburs|invoice|receipt|reflection|"
                       r"assignment|nano|proposed_ideas|good_product|session1&2", re.I)
GENERIC_LEAK = [r"PGP\s?20\d\d", r"\[at\]\s?isb", r"@isb\.edu", r"filewithwatermark"]

def classify(rel):
    n = os.path.basename(rel)
    kind = "slides"
    if re.search(r"(_27\d|_26\d)\b.*\.pdf$|outline", n, re.I): kind = "outline"
    elif re.search(r"course ?pack|coursepack", n, re.I): kind = "coursepack"
    m = re.search(r"(?:session|slides?|class|lecture|\bS)[ _-]*0?(\d{1,2})\b", n, re.I) or \
        re.search(r"(?:^|/)S0?(\d{1,2})(?:/|$)", rel) or re.search(r"\bS0?(\d{1,2})\b", n)
    return kind, (int(m.group(1)) if m else None)

def inventory(course):
    base = os.path.join(ISB, COURSES[course]); rows = []
    for r, ds, fs in os.walk(base):
        ds[:] = [d for d in ds if not SKIP_DIR.search(d)]
        for f in fs:
            if f.startswith(".") or not f.lower().endswith((".pdf", ".pptx")): continue
            rel = os.path.relpath(os.path.join(r, f), base)
            kind, sess = classify(rel)
            inc = not SKIP_FILE.search(rel)
            if course == "SWPM" and "/" not in rel and kind == "slides": inc = False   # root duplicates of Session Slides/
            if kind == "coursepack": inc = False        # third-party cases inside; link-only for now
            rows.append(dict(course=course, file=rel, kind=kind, session=sess, include=inc,
                             mb=round(os.path.getsize(os.path.join(base, rel)) / 1e6, 1)))
    return rows

def clean_pdf(path, leak):
    d = fitz.open(path); pages = []; line_pages = collections.Counter()
    raw = []
    for pg in d:
        lines = []
        for b in pg.get_text("dict")["blocks"]:
            for l in b.get("lines", []):
                dx, dy = l["dir"]
                t = "".join(s["text"] for s in l["spans"]).strip()
                if not t or abs(dy) > 0.05: continue            # rotated = watermark
                size = max((s["size"] for s in l["spans"]), default=0)
                lines.append((l["bbox"][1], size, t))
        raw.append(lines)
        for t in {x[2] for x in lines}: line_pages[t] += 1
    n = max(len(raw), 1)
    for i, lines in enumerate(raw, 1):
        keep = [(y, s, t) for y, s, t in lines
                if not (n >= 4 and line_pages[t] > n * 0.5) and not any(re.search(p, t, re.I) for p in leak)]
        keep.sort()
        head = max(keep[:8], key=lambda x: x[1])[2] if keep else ""
        pages.append(dict(n=i, heading=head[:120], text="\n".join(t for _, _, t in keep)))
    return pages

def clean_pptx(path, leak):
    z = zipfile.ZipFile(path); out = []
    names = sorted((x for x in z.namelist() if re.match(r"ppt/slides/slide\d+\.xml$", x)),
                   key=lambda x: int(re.findall(r"\d+", x)[-1]))
    for i, nme in enumerate(names, 1):
        t = re.findall(r"<a:t>([^<]*)</a:t>", z.read(nme).decode("utf8", "ignore"))
        t = [x for x in t if not any(re.search(p, x, re.I) for p in leak)]
        out.append(dict(n=i, heading=(t[0] if t else "")[:120], text="\n".join(t)))
    return out

def main():
    ap = argparse.ArgumentParser(); ap.add_argument("--manifest-only", action="store_true"); a = ap.parse_args()
    personal = [p.strip() for p in os.environ.get("COMPASS_LEAK_PATTERNS", "").split(",") if p.strip()]
    leak = GENERIC_LEAK + personal
    rows = [r for c in COURSES for r in inventory(c)]
    os.makedirs(OUT, exist_ok=True)
    if a.manifest_only:
        for c in COURSES:
            inc = [r for r in rows if r["course"] == c and r["include"]]
            print(f"{c}: {len(inc)} files to read ({sum(r['mb'] for r in inc):.0f} MB), skipped {sum(1 for r in rows if r['course']==c and not r['include'])}")
        w = csv.DictWriter(open(os.path.join(OUT, "manifest.csv"), "w"), fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows); return
    for r in rows:
        if not r["include"]: continue
        p = os.path.join(ISB, COURSES[r["course"]], r["file"])
        try: pages = clean_pdf(p, leak) if p.lower().endswith(".pdf") else clean_pptx(p, leak)
        except Exception as e: r["status"] = f"error:{type(e).__name__}"; print("ERR", r["course"], r["file"], r["status"]); continue
        blob = "\n".join(x["text"] for x in pages)
        hits = [pt for pt in leak if re.search(pt, blob, re.I)]
        low = sum(1 for x in pages if len(x["text"].split()) < 8)
        r.update(pages=len(pages), words=len(blob.split()), low_text_pages=low,
                 needs_vision=bool(pages) and low > 0.6 * len(pages), leak_hits=len(hits),
                 status="LEAK" if hits else "ok")
        if hits: print("LEAK", r["course"], r["file"], hits); continue
        d = os.path.join(OUT, r["course"]); os.makedirs(d, exist_ok=True)
        json.dump(dict(meta={k: r[k] for k in ("course", "file", "kind", "session")}, pages=pages),
                  open(os.path.join(d, re.sub(r"[^\w.-]+", "_", r["file"]) + ".json"), "w"))
    keys = sorted({k for r in rows for k in r})
    w = csv.DictWriter(open(os.path.join(OUT, "manifest.csv"), "w"), fieldnames=keys); w.writeheader(); w.writerows(rows)
    s = collections.Counter(r.get("status", "skipped") for r in rows); print(dict(s))

if __name__ == "__main__": main()
