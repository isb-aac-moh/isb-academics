#!/usr/bin/env python3
"""Text sources that already exist as text: SWPM slide markdown and FRNT class transcripts.
Same output format as extract_slides.py. Personal names in transcripts are replaced with [student]."""
import json, os, re, subprocess
ISB = os.path.expanduser("~/Library/CloudStorage/OneDrive-IndianSchoolofBusiness/ISB")
OUT = os.path.expanduser("~/Downloads/compass-build/extract")
PERSONAL = [p.strip() for p in os.environ.get("COMPASS_LEAK_PATTERNS", "").split(",") if p.strip()]
GENERIC = [r"PGP\s?20\d\d", r"\[at\]\s?isb", r"@isb\.edu", r"filewithwatermark"]

def scrub(t):
    t = re.sub(r"[\w.+-]+@[\w-]+\.[\w.]+", "[email]", t)      # any email (faculty or student) is removed
    for p in PERSONAL: t = re.sub(p, "[student]", t, flags=re.I)
    return t
def check(t): return [p for p in GENERIC if re.search(p, t, re.I)]
def save(course, name, kind, session, pages):
    blob = "\n".join(p["text"] for p in pages)
    if check(blob): print("LEAK", name, check(blob)); return
    d = os.path.join(OUT, course); os.makedirs(d, exist_ok=True)
    json.dump(dict(meta=dict(course=course, file=name, kind=kind, session=session), pages=pages), open(os.path.join(d, "x_" + re.sub(r"[^\w.-]+", "_", name) + ".json"), "w"))
    print(f"{course} {kind} S{session}: {len(pages)} chunks, {len(blob.split()):,} words")

def md_slides(path, course, session):
    t = scrub(open(path, errors="ignore").read()); parts = re.split(r"\n## (Slide[^\n]*)\n", t); pages = []
    for i in range(1, len(parts), 2):
        head = parts[i]; body = parts[i + 1].replace("\n---", "").strip()
        n = re.search(r"Slide\s+(\d+)", head); pages.append(dict(n=int(n.group(1)) if n else len(pages) + 1, heading=head.split(":", 1)[-1].strip()[:120], text=head + "\n" + body))
    if not pages:                                              # no "## Slide" headings: chunk by words
        w = t.split(); pages = [dict(n=len(pages) + 1, heading="", text=" ".join(w[i:i + 300])) for i in range(0, len(w), 300)]
    save(course, os.path.basename(path), "slides_md", session, pages)

def transcript(path, course, session):
    txt = scrub(subprocess.run(["textutil", "-convert", "txt", "-stdout", path], capture_output=True, text=True).stdout)
    words = txt.split(); pages = []
    for i in range(0, len(words), 350):
        chunk = " ".join(words[i:i + 350]); pages.append(dict(n=len(pages) + 1, heading="", text=chunk))
    save(course, os.path.basename(path), "transcript", session, pages)

for n in range(1, 7): md_slides(f"{ISB}/Term4/SWPM/Session Slides/Markdown/S{n}.md", "SWPM", n)
F = f"{ISB}/Term2/T2-FRNT"
for s, f in {1: "S1/FRNT S1 Transcription.docx", 2: "S2/FRNT S2 Transcription.docx", 3: "S3/FRNT S3 Transcription.docx", 4: "S4/FRNT S4 Transcription.docx",
             5: "S5/FRNT Transcription.docx", 7: "S7/FRNT Transcription (1).docx", 8: "S8/FRNT Transcription.docx", 9: "S9/FRNT Transcription.docx", 10: "S10/FRNT Transcription (5).docx"}.items():
    transcript(f"{F}/{f}", "FRNT", s)
md_slides(f"{F}/S5/Session 5 Slides.md", "FRNT", 5); md_slides(f"{F}/S7/S7-Slides.md", "FRNT", 7)
