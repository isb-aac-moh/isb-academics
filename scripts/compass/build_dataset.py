#!/usr/bin/env python3
"""Build public/data/compass.json (derived data only: no slide text, no files) from tags, passages, seed graph and the Moodle map."""
import json, glob, os, re, collections, datetime
B = os.path.expanduser("~/Downloads/compass-build"); W = f"{B}/work"; MD = f"{B}/moodle"
OUT = os.path.join(os.path.dirname(__file__), "..", "public", "data", "compass.json")
NAMES = {"STRG": "Strategy", "MKTG": "Marketing Management", "OPMG": "Operations Management", "BANM": "Business Analytics for Marketing", "SWPM": "Software Product Management", "FRNT": "Frontier Technologies"}
norm = lambda t: re.sub(r"[^a-z0-9]+", " ", t.lower()).strip()

seed = json.load(open(f"{B}/seed_concepts.json"))
alias_to_id = {}
concepts = {}
for c in seed:
    for m in c["merged_ids"]: alias_to_id[m] = c["id"]
for c in seed:
    concepts[c["id"]] = dict(id=c["id"], title=c["title"], aliases=c["aliases"], lenses=c["lenses"], obj=c["obj"], q=c["q"], module=c["module"], freq=c["freq"], level=c.get("level"),
        rel=[], evidence=[], _rel=c["rel"])
for c in concepts.values():
    seen = set()
    for r in c.pop("_rel"):
        t = alias_to_id.get(r["to"]); 
        if t and t != c["id"] and (t, r["type"]) not in seen: seen.add((t, r["type"])); c["rel"].append(dict(to=t, type=r["type"], why=r.get("why", "")))
title_index = {}
for c in concepts.values():
    for k in {norm(c["title"])} | {norm(a) for a in c["aliases"]}: title_index.setdefault(k, c["id"])

DROP = re.compile(r"Reference_BW|FormulaSheet|Theory_and_Formula|Team_.*Malwa|Master_Notes|S1_Notes|S2-notes|Notes03_ANN|Text_Mining|Unsupervised_ML_for_Marketing|Advanced_Performance|/Notes\\.pdf|^Notes\\.pdf|Quiz2|standardnormal", re.I)
n_tags = n_new = n_admin = n_dropped = n_mis = 0
for pf in sorted(glob.glob(f"{W}/passages_*.json")):
    g = os.path.basename(pf)[len("passages_"):-5]; tf = f"{W}/tags_{g}.jsonl"
    if not os.path.exists(tf): continue
    queue = collections.defaultdict(list)
    for p in json.load(open(pf)): queue[p["id"]].append(p)
    for line in open(tf):
        try: r = json.loads(line)
        except ValueError: continue
        q = queue.get(r.get("passage_id"))
        if not q: n_mis += 1; continue
        p = q.pop(0)
        if DROP.search(p["file"]): n_dropped += 1; continue
        if r.get("admin"): n_admin += 1; continue
        base = dict(course=p["course"], session=p["session"], kind=p["kind"], pages=p["pages"], summary=(r.get("summary") or "")[:200], passage=p["id"])
        for t in r.get("tags", []):
            cid = alias_to_id.get(t["concept_id"], t["concept_id"])
            if cid in concepts and t.get("role") in ("teaches", "applies", "mentions"):
                concepts[cid]["evidence"].append(dict(base, role=t["role"], why=(t.get("why") or "")[:120])); n_tags += 1
        for nc in r.get("new_concepts", []):
            title = (nc.get("title") or "").strip()
            if not title: continue
            cid = title_index.get(norm(title))
            if not cid:
                cid = "new:" + re.sub(r"[^a-z0-9]+", "-", title.lower()).strip("-")
                lens = nc.get("lens") if nc.get("lens") in ("product", "consulting") else "general"
                concepts[cid] = dict(id=cid, title=title, aliases=[], lenses=[lens], obj="", q="", module={}, freq=0, level=None, rel=[], evidence=[], isNew=True, definition=(nc.get("definition") or "")[:200])
                title_index[norm(title)] = cid; n_new += 1
            concepts[cid]["evidence"].append(dict(base, role=nc.get("role", "teaches"), why="Introduced in this course")); n_tags += 1
passages = {}
for f in glob.glob(f"{W}/passages_*.json"):
    for p in json.load(open(f)): passages[p["id"]] = p
# sessions + Moodle links
courses = []
for code, name in NAMES.items():
    st = json.load(open(f"{MD}/state_{code}.json")); st = st[0].get("data", st[0]); st = json.loads(st) if isinstance(st, str) else st
    titles = {}
    for s in st["section"]:
        m = re.search(r"(?:session|class|s)\s*[-_ ]?(\d+)", s.get("title") or "", re.I)
        if m: titles.setdefault(int(m.group(1)), s["title"])
    mm = json.load(open(f"{MD}/moodle_session_map.json"))[code]["sessions"]
    nums = sorted({int(k) for k in mm} | {e["session"] for c in concepts.values() for e in c["evidence"] if e["course"] == code and e["session"]})
    sessions = []
    for n in nums:
        res = [dict(name=i["name"], type=i["type"], url=i["url"]) for i in mm.get(str(n), []) if i.get("url") and i["type"] in ("filewithwatermark", "resource", "folder")]
        con = {}
        for c in concepts.values():
            for e in c["evidence"]:
                if e["course"] == code and e["session"] == n:
                    rank = {"teaches": 0, "applies": 1, "mentions": 2}[e["role"]]
                    if c["id"] not in con or rank < con[c["id"]][0]: con[c["id"]] = (rank, e["role"])
        top = sorted(con.items(), key=lambda kv: (kv[1][0], concepts[kv[0]]["title"]))[:20]
        sessions.append(dict(n=n, title=titles.get(n, f"Session {n}"), resources=res, concepts=[dict(id=k, role=v[1]) for k, v in top]))
    courses.append(dict(code=code, name=name, sessions=sessions))
meta = dict(built=datetime.datetime.now().isoformat(timespec="seconds"), counts=dict(concepts=len(concepts), with_isb=sum(1 for c in concepts.values() if c["evidence"]), evidence=n_tags, new=n_new, admin_passages=n_admin, passages=len(passages), dropped_non_faculty=n_dropped, unmatched=n_mis))
os.makedirs(os.path.dirname(OUT), exist_ok=True)
json.dump(dict(meta=meta, courses=courses, concepts=concepts), open(OUT, "w"), separators=(",", ":"))
print(meta["counts"], "| size KB", os.path.getsize(OUT) // 1024)
