#!/usr/bin/env python3
"""Turn tagged Moodle passages into card-writing batches for the existing checks in card_pilot.py. Prints counts and titles only.

  moodle_cards.py ideas           # write moodle/cards/merge_in.json: every tagged idea, for the merge step
  moodle_cards.py prepare N SIZE [PARTS]  # after merging: pick SIZE ideas for batch N, split into PARTS writer inputs
  moodle_cards.py assemble        # every batch's passed sentences, minus people's edits in manual_edits.json -> cards_final.json
Then run card_pilot.py with COMPASS_PILOT_DIR=<B>/moodle/cards and COMPASS_WAVE=N.
"""
import collections, glob, json, os, random, re, sys
from search_baseline import tidy

B = os.path.expanduser("~/Downloads/compass-build"); W = f"{B}/moodle/work"; C = f"{B}/moodle/cards"
NAMES = {"SMDM": "Statistical Methods", "MGEC": "Managerial Economics", "FCRV": "Foundations of Finance", "FADM": "Financial Accounting"}
MAX_PASSAGES = 6
norm = lambda t: re.sub(r"[^a-z0-9]+", " ", t.lower()).strip()

def tagged():
    """Every idea with where it appears: key -> title, definition, and passages teaching first."""
    seed = {s["id"]: s for s in json.load(open(f"{B}/seed_concepts.json"))}; out = {}
    for f in sorted(glob.glob(f"{W}/tags_*.jsonl")):
        for line in open(f):
            r = json.loads(line)
            if r.get("admin"): continue
            for n in r.get("new_concepts", []):
                k = norm(n.get("title") or "")
                if k: x = out.setdefault(k, dict(key=k, title=n["title"].strip(), definition=n.get("definition", ""), kind=n.get("kind"), ev=[])); x["ev"].append((r["passage_id"], n.get("role", "teaches")))
            for t in r.get("tags", []):
                s = seed.get(t["concept_id"])
                if s and t.get("role") in ("teaches", "applies"): x = out.setdefault("seed " + t["concept_id"], dict(key="seed " + t["concept_id"], title=s["title"], definition=(s.get("obj") or s.get("q") or "")[:150], kind="existing", ev=[])); x["ev"].append((r["passage_id"], t["role"]))
    return out

def ideas():
    os.makedirs(C, exist_ok=True); items = tagged(); course = lambda pid: pid.split("-")[0]
    rows = [dict(key=x["key"], title=x["title"], definition=x["definition"], courses=sorted({course(p) for p, _ in x["ev"]}), passages=len(x["ev"])) for x in items.values()]
    live = sorted(c["title"] for c in json.load(open(f"{B}/phase_a/pilot/cards_final.json")))
    json.dump(dict(ideas=sorted(rows, key=lambda r: r["title"].lower()), live_cards=live), open(f"{C}/merge_in.json", "w"), indent=0)
    print(len(rows), "ideas |", len(live), "live card titles")

def prepare(n, size, parts=2):
    items = tagged(); merge = json.load(open(f"{C}/merge_out.json")); src = {}
    for f in glob.glob(f"{W}/passages_*.json"):
        for p in json.load(open(f)): src[p["id"]] = p
    done = {x["id"] for f in glob.glob(f"{C}/wave_*/in_*.json") for x in json.load(open(f))}; pool = []
    for g in merge:
        if g.get("live_card"): continue
        ev = [e for k in g["members"] for e in items[k]["ev"]]
        teaches = [p for p, role in ev if role == "teaches"]
        cid = "new:" + re.sub(r"[^a-z0-9]+", "-", g["title"].lower()).strip("-")
        if cid in done or not teaches: continue
        order = list(dict.fromkeys(teaches + [p for p, _ in ev]))
        pool.append(dict(id=cid, title=g["title"], aliases=[items[k]["title"] for k in g["members"] if items[k]["title"] != g["title"]][:5], order=order, teaches=len(set(teaches)), courses=sorted({p.split("-")[0] for p in order})))
    # Most-taught ideas first, taken evenly across courses, so the first batches are the ideas with the most material.
    by = collections.defaultdict(list)
    for x in sorted(pool, key=lambda x: (-x["teaches"], x["id"])): by[x["courses"][0]].append(x)
    chosen = []
    while len(chosen) < size and any(by.values()):
        for c in sorted(by):
            if by[c] and len(chosen) < size: chosen.append(by[c].pop(0))
    out = []
    for x in chosen:
        passages, seen = [], set()
        for pid in x["order"]:
            p = src[pid]; text = tidy(p["text"]); key = re.sub(r"\W+", "", text.lower())[:300]
            if key in seen or len(passages) >= MAX_PASSAGES: continue
            seen.add(key); passages.append(dict(id=f"p{len(passages) + 1}", course=p["course"], session=p["session"], kind=p["kind"], text=text))
        out.append(dict(id=x["id"], title=x["title"], aliases=x["aliases"], passages=passages))
    random.Random(27).shuffle(out); P = f"{C}/wave_{n}"; os.makedirs(P, exist_ok=True)
    for i in range(parts): json.dump(out[i::parts], open(f"{P}/in_{i}.json", "w"), separators=(",", ":"))
    print(len(pool), "ideas could get cards |", len(out), "chosen |", dict(collections.Counter(x["courses"][0] for x in chosen)), "|", sum(len(x["passages"]) for x in out), "passages | about", round(sum(len(p["text"].split()) for x in out for p in x["passages"]) * 1.3 / 1000), "thousand tokens")
    print([x["title"] for x in chosen])

def assemble():
    """Only sentences that passed the software check and the fact check, after the edits people asked for."""
    edits = json.load(open(f"{C}/manual_edits.json")) if os.path.exists(f"{C}/manual_edits.json") else {}; shown, held = [], []
    for d in sorted(glob.glob(f"{C}/wave_*")):
        if not os.path.exists(f"{d}/cards_checked.json"): continue
        inputs = {x["id"]: x for f in glob.glob(f"{d}/in_*.json") for x in json.load(open(f))}; cards = json.load(open(f"{d}/cards_checked.json")); v = {}
        for f in sorted(glob.glob(f"{d}/check_out_*.jsonl")):
            for line in open(f):
                if line.strip(): r = json.loads(line); v[r["key"]] = r["verdict"]
        for cid, c in cards.items():
            title, e = inputs[cid]["title"], edits.get(cid, {})
            good = {f: [x for k, x in enumerate(c.get(f) or []) if not x.get("software") and v.get(f"{cid}|{f}|{k}") == "yes" and f not in e.get("drop", [])] for f in ("what", "use", "trap")}
            reason = e.get("hold") or ("not enough material" if c.get("status") == "insufficient" else "failed checks" if not good["what"] else "")
            if reason: held.append(dict(id=cid, title=title, why=reason)); continue
            ps = {p["id"]: p for p in inputs[cid]["passages"]}; used = sorted({i for f in good for x in good[f] for i in x["cite"]})
            shown.append(dict(id=cid, title=title, aliases=inputs[cid]["aliases"], **{f: " ".join(x["s"] for x in good[f]) for f in good}, where=sorted({(ps[i]["course"], ps[i]["session"]) for i in used}, key=str), source=[ps[i]["text"] for i in used], batch=os.path.basename(d)))
    json.dump(shown, open(f"{C}/cards_final.json", "w")); json.dump(held, open(f"{C}/held_back.json", "w"))
    print(len(shown), "cards |", len(held), "held", dict(collections.Counter(h["why"] for h in held)), "| by course", dict(collections.Counter(w[0] for x in shown for w in {(y[0],) for y in x["where"]})))

if __name__ == "__main__":
    {"ideas": ideas, "assemble": assemble}.get(sys.argv[1], lambda: prepare(sys.argv[2], int(sys.argv[3]), int(sys.argv[4]) if len(sys.argv) > 4 else 2))()
