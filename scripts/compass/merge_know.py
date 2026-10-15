"""Merge the AI-written "What to know" blocks (out_<N>.jsonl) into the Compass dataset JSON.
Usage: merge_know.py <dataset.json> <know_dir>"""
import glob, json, sys
ds, kdir = sys.argv[1], sys.argv[2]
d = json.load(open(ds)); n = 0
for f in sorted(glob.glob(kdir + "/out_*.jsonl")):
    for line in open(f):
        r = json.loads(line); c = d["concepts"].get(r["id"])
        if c and all(r.get(k) for k in ("what", "use", "trap", "ask")):
            c["know"] = {k: r[k] for k in ("what", "use", "trap", "ask")}; n += 1
json.dump(d, open(ds, "w"), ensure_ascii=False, separators=(",", ":"))
print("merged", n, "of", sum(1 for c in d["concepts"].values() if c["evidence"]))
