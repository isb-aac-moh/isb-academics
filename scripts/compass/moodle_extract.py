#!/usr/bin/env python3
"""Extract text from the Moodle download and sort every file by what it is. Nothing here reaches the app.

Identity stamps are removed before anything is written, and a file fails if any trace survives.
Personal patterns come from COMPASS_LEAK_PATTERNS (comma separated), never the repo. Prints counts only.
Sorting is a first pass from file names, shape and publisher wording: check it before relying on it.

  COMPASS_LEAK_PATTERNS="..." python3 scripts/compass/moodle_extract.py

Reads moodle/files/<COURSE>/. Writes moodle/extract/<COURSE>/<cmid...>.json and moodle/extract/sorted.csv.
"""
import collections, csv, glob, hashlib, html.parser, json, os, re, zipfile
import fitz
from extract_slides import GENERIC_LEAK, clean_pdf, clean_pptx

B = os.path.expanduser("~/Downloads/compass-build")
SRC, OUT = f"{B}/moodle/files", f"{B}/moodle/extract"
# Moodle's stamp scatters extra letters through the text to dodge searches (E-s-h-I-a-n style), so plain words also match with an "I" or symbol between letters.
def stamped(word): return r"[^a-z0-9]*i?[^a-z0-9]*".join(map(re.escape, word))
LEAK = GENERIC_LEAK + [stamped("pgp20"), stamped("isbedu")]
LEAK += [stamped(p.strip()) if p.strip().isalnum() else p.strip() for p in os.environ.get("COMPASS_LEAK_PATTERNS", "").split(",") if p.strip()]
DATA = {".xlsx", ".xls", ".csv", ".r", ".ipynb", ".zip", ".png", ".jpg", ".jpeg", ".rmd", ".py", ".sav", ".twbx"}
PUBLISHER = re.compile(r"harvard business|hbs ?(no|case)|hbr\.org|hbsp\.|reprint r\d|ivey (business|publishing)|richard ivey|darden business|kellogg school of management|"
                       r"stanford graduate school of business|insead|no part of this (publication|book)|isbn[ :-]*\d|doi\.org|\bdoi:|elsevier|springer|wiley|jstor|sage publications|"
                       r"sloan management review|mcgraw|pearson education|oxford university press|cambridge university press|journal of \w+|mckinsey quarterly", re.I)
# Checked before anything else: these have their own handling whatever else the file looks like.
FIRST = [("student list", r"study ?groups?|group ?list|group ?allocation|class ?list|roster|\bsgs?\b|\bgroups\b|new microsoft excel"),
         ("coursepack", r"course ?pack|\bcp\b"),
         ("company report", r"annual.?report|\b20-?f\b|\bbrsr\b|\bar\b.*abridged|\bf.s excerpts\b")]
NAMES = [("outline", r"outline|syllabus|course ?plan|course ?handout"),
         ("assessment", r"assignment|quiz|exam|midterm|end ?term|question|answer|solution|sol\b|practice|problem ?set|\bps\d|rubric|submission|deliverable|peer|grading"),
         ("case or reading", r"\bcase\b|_case_|reading|pre-?read|article|chapter|\bch\d|hbr|hbs|harvard|journal|paper\b|textbook"),
         ("admin", r"schedule|timetable|attendance|announcement|guideline|instructions|policy|faculty profile|group list|feedback"),
         ("session notes", r"\bnotes?\b|summary"),
         ("slides", r"slide|session|deck|lecture|class|\bs\d{1,2}\b|module|ppt|week")]

class Text(html.parser.HTMLParser):
    def __init__(self): super().__init__(); self.parts, self.skip = [], 0
    def handle_starttag(self, tag, attrs):
        if tag in ("script", "style", "nav", "header", "footer"): self.skip += 1
    def handle_endtag(self, tag):
        if tag in ("script", "style", "nav", "header", "footer"): self.skip = max(0, self.skip - 1)
        elif tag in ("p", "div", "li", "tr", "h1", "h2", "h3", "br"): self.parts.append("\n")
    def handle_data(self, data):
        if not self.skip: self.parts.append(data)

def no_email(text): return re.sub(r"[\w.+-]+@[\w-]+\.[\w.]+", "[email]", text)

def drop_leaks(text): return "\n".join(l for l in text.splitlines() if l.strip() and not any(re.search(p, l, re.I) for p in LEAK))

def read_html(path):
    page = open(path, errors="ignore").read()
    main = re.search(r'role="main"(.*?)(<footer|id="page-footer"|$)', page, re.S)  # Moodle pages: skip menus
    parser = Text(); parser.feed(main.group(1) if main else page)
    return [dict(n=1, heading="", text=drop_leaks(re.sub(r"[ \t]+", " ", "".join(parser.parts))))]

def read_docx(path):
    xml = zipfile.ZipFile(path).read("word/document.xml").decode("utf8", "ignore")
    paras = ["".join(re.findall(r"<w:t(?: [^>]*)?>([^<]*)</w:t>", p)) for p in re.findall(r"<w:p[ >].*?</w:p>", xml, re.S)]
    return [dict(n=1, heading="", text=drop_leaks("\n".join(paras)))]

def shape(path):
    """Share of pages wider than tall: decks are landscape, cases and papers are portrait."""
    with fitz.open(path) as d: return sum(p.rect.width > p.rect.height for p in d) / max(len(d), 1)

def sort(ext, name, title, module, pages, wide):
    label = f"{name} {title}".replace("_", " ").replace("-", " ")
    first = next((k for k, pattern in FIRST if re.search(pattern, label, re.I)), None)
    if first: return first, "file name"
    head = " ".join(p["text"] for p in pages[:2] + pages[-1:])[:12000]
    if ext in DATA: return "data or code", ""
    named = next((k for k, pattern in NAMES if re.search(pattern, label, re.I)), None)
    words = sum(len(p["text"].split()) for p in pages); dense = words / max(len(pages), 1) > 220
    publisher = bool(PUBLISHER.search(head))
    if module in ("page", "book"): return named if named in ("assessment", "admin", "outline") else "moodle page", ""
    if named in ("outline", "assessment", "admin", "session notes"): return named, "publisher wording" if publisher else ""
    if len(pages) >= 60 and wide is not None and wide < 0.5 and dense: return "coursepack", "long portrait file"
    if publisher and (wide is None or wide < 0.5): return "case or reading", "publisher wording"
    if named == "case or reading": return named, "file name"
    if wide is not None and wide >= 0.5 or ext == ".pptx": return "slides", ""
    if dense: return "unsure document", "long portrait file, no publisher wording"
    return named or "unsure document", ""

def main():
    rows, seen = [], {}
    old = set()
    for f in glob.glob(f"{B}/extract/*/*.json"):  # What Compass already has, to count what's new.
        old.add(hashlib.sha256(re.sub(r"\s+", " ", " ".join(p["text"] for p in json.load(open(f))["pages"])).lower().encode()).hexdigest())
    for manifest in sorted(glob.glob(f"{SRC}/*/manifest.json")):
        course = os.path.basename(os.path.dirname(manifest)); os.makedirs(f"{OUT}/{course}", exist_ok=True)
        for e in json.load(open(manifest)):
            for f in e["files"]:
                path = f"{SRC}/{course}/{f['path']}"; ext = os.path.splitext(f["path"])[1].lower(); pages, wide, status = [], None, "ok"
                try:
                    if ext == ".pdf": pages, wide = clean_pdf(path, LEAK), shape(path)
                    elif ext == ".pptx": pages = clean_pptx(path, LEAK)
                    elif ext == ".docx": pages = read_docx(path)
                    elif ext == ".html": pages = read_html(path)
                    elif ext not in DATA: status = "no text reader"
                except Exception as x: status = f"error: {type(x).__name__}"
                for p in pages: p["text"], p["heading"] = no_email(p["text"]), no_email(p["heading"])
                blob = "\n".join(p["text"] for p in pages); words = len(blob.split())
                if any(re.search(p, blob, re.I) for p in LEAK): status, pages = "identity trace: not saved", []
                elif status == "ok" and ext not in DATA and words < 20 * max(len(pages), 1) and ext == ".pdf": status = "mostly images: needs OCR"
                elif status == "ok" and ext not in DATA and words < 20: status = "almost no text"
                print_key = hashlib.sha256(re.sub(r"\s+", " ", " ".join(p["text"] for p in pages)).lower().encode()).hexdigest()
                file_hash = hashlib.sha256(open(path, "rb").read()).hexdigest()
                dup = seen.get(file_hash, "") or (seen.get(print_key, "") if words >= 20 else "")
                seen.setdefault(file_hash, f"{course}/{f['path']}"); seen.setdefault(print_key, f"{course}/{f['path']}")
                kind, why = sort(ext, f["path"], e.get("name") or "", e["module"], pages, wide)
                n = re.search(r"(?:session|class|lecture|\bS)[ _-]*0?(\d{1,2})\b", f"{e.get('section_title') or ''} {e.get('name') or ''}", re.I)
                if kind not in ("coursepack", "company report", "case or reading") and len(re.findall(r"\b\d{8}\b", blob)) >= 8: kind, why = "student list", "many roll numbers"
                if kind == "student list": status, pages = "other students' names: text not kept", []
                if pages and not status.startswith(("identity", "error")):
                    meta = dict(course=course, file=f["path"], kind=kind, why=why, session=int(n.group(1)) if n else None, section_title=e.get("section_title"), item=e.get("name"), moodle_url=e.get("moodle_url"), cmid=e["cmid"])
                    json.dump(dict(meta=meta, pages=pages), open(f"{OUT}/{course}/{f['path']}.json", "w"))
                rows.append(dict(course=course, kind=kind, why=why, status=status, ext=ext, pages=len(pages), words=words, mb=round(f.get("bytes", 0) / 1e6, 1), session=int(n.group(1)) if n else "", duplicate_of=dup, in_compass="yes" if print_key in old and words else "", item=e.get("name"), section=e.get("section_title"), file=f["path"], moodle_url=e.get("moodle_url")))
    with open(f"{OUT}/sorted.csv", "w", newline="") as o:
        w = csv.DictWriter(o, fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows)
    print(len(rows), "files | status", dict(collections.Counter(r["status"].split(":")[0] for r in rows)))
    unique = [r for r in rows if not r["duplicate_of"]]
    for k, n in collections.Counter(r["kind"] for r in unique).most_common(): print(f"  {k}: {n} files, {sum(r['words'] for r in unique if r['kind'] == k):,} words, {sum(r['status'].startswith('mostly') for r in unique if r['kind'] == k)} need OCR")
    print("duplicates", sum(bool(r["duplicate_of"]) for r in rows), "| already in Compass", sum(r["in_compass"] == "yes" for r in rows), "| words", sum(r["words"] for r in rows if not r["duplicate_of"]))
    for c in sorted({r["course"] for r in rows}):
        rs = [r for r in rows if r["course"] == c and not r["duplicate_of"]]
        print(f"  {c}: {len(rs)} files, {sum(r['words'] for r in rs):,} words | " + ", ".join(f"{k} {v}" for k, v in collections.Counter(r["kind"] for r in rs).most_common()))

if __name__ == "__main__": main()
