"""Merge AI-proposed prerequisite links (out_<G>.jsonl) for newly found ideas into the Compass dataset.
Usage: merge_links.py <dataset.json> <links_dir>. Links are flagged auto=true so the app can say they are suggestions."""
import glob, json, sys
ds, ldir = sys.argv[1], sys.argv[2]
d = json.load(open(ds)); cs = d["concepts"]; added = 0
for f in sorted(glob.glob(ldir + "/out_*.jsonl")):
    for line in open(f):
        r = json.loads(line); c = cs.get(r["id"])
        if not c: continue
        have = {x["to"] for x in c["rel"]}
        for b in r.get("builds_on", []):
            if b["to"] in cs and b["to"] != c["id"] and b["to"] not in have:
                c["rel"].append({"to": b["to"], "type": "builds_on", "why": b.get("why", ""), "auto": True}); added += 1
json.dump(d, open(ds, "w"), ensure_ascii=False, separators=(",", ":"))
print("links added", added)
