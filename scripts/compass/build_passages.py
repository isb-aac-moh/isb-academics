#!/usr/bin/env python3
"""Group extracted pages into passages and shortlist candidate concepts for each (TF-IDF over concept text)."""
import json, glob, os, re, collections
import math
B = os.path.expanduser("~/Downloads/compass-build"); EX = f"{B}/extract"; W = f"{B}/work"; os.makedirs(W, exist_ok=True)
concepts = json.load(open(f"{B}/seed_concepts.json"))
docs = [" ".join([c["title"]] * 3 + c["aliases"] * 2 + [c["obj"], c["q"]]) for c in concepts]
STOP = set("the a an of and for to in on with by vs versus how what is are your you use using as at from or be it this that we they can will not do does into more most".split())
def toks(t):
    w = [re.sub(r"(ing|es|s|ed)$", "", x) for x in re.findall(r"[a-z0-9]+", t.lower()) if x not in STOP and len(x) > 2]
    return w + [a + "_" + b for a, b in zip(w, w[1:])]
D = [collections.Counter(toks(d)) for d in docs]
df = collections.Counter(t for d in D for t in d)
N = len(D); idf = lambda t: math.log((N + 1) / (df.get(t, 0) + 1)) + 1
def vecof(c):
    v = {t: (1 + math.log(n)) * idf(t) for t, n in c.items() if t in df}
    nrm = math.sqrt(sum(x * x for x in v.values())) or 1
    return {t: x / nrm for t, x in v.items()}
V = [vecof(d) for d in D]
def sims_for(text):
    q = vecof(collections.Counter(toks(text)))
    return [sum(x * v.get(t, 0) for t, x in q.items()) for v in V]
GROUPS = {"STRG": ["STRG"], "MKTG": ["MKTG"], "OPMG": ["OPMG"], "BANM_a": ("BANM", range(1, 6)), "BANM_b": ("BANM", range(6, 11)),
          "SWPM": ["SWPM"], "FRNT_a": ("FRNT", range(1, 6)), "FRNT_b": ("FRNT", range(6, 11))}
def passages(course):
    out = []
    for f in sorted(glob.glob(f"{EX}/{course}/*.json")):
        d = json.load(open(f)); m = d["meta"]; buf, words, start = [], 0, None
        def flush(end):
            nonlocal buf, words, start
            if buf and words > 12:
                out.append(dict(course=course, session=m["session"], kind=m["kind"], file=m["file"], pages=[start, end], heading=buf[0][1] or "", text="\n".join(x[2] for x in buf)))
            buf, words, start = [], 0, None
        for pg in d["pages"]:
            w = len(pg["text"].split())
            if start is None: start = pg["n"]
            buf.append((pg["n"], pg["heading"], pg["text"])); words += w
            if words >= 260 or len(buf) >= 8: flush(pg["n"])
        if buf: flush(buf[-1][0])
    return out
n = 0
for g, spec in GROUPS.items():
    course, sess = (spec[0], set(spec[1])) if isinstance(spec, tuple) else (spec[0], None)
    ps = [p for p in passages(course) if sess is None or p["session"] in sess or p["kind"] == "outline" and g.endswith("a") or (p["kind"] == "outline" and sess is None)]
    if not ps: continue
    sims = [sims_for(p["text"][:3000]) for p in ps]
    for i, p in enumerate(ps):
        top = sorted(range(N), key=lambda j: -sims[i][j])[:20]
        p["id"] = f'{p["course"]}-{"S"+str(p["session"]) if p["session"] else "outline"}-{re.sub(r"[^A-Za-z0-9]+","",os.path.splitext(os.path.basename(p["file"]))[0])[:14]}-{p["pages"][0]}-{p["pages"][1]}'
        p["candidates"] = [dict(id=concepts[j]["id"], title=concepts[j]["title"], lenses=concepts[j]["lenses"], hint=(concepts[j]["obj"] or concepts[j]["q"])[:110]) for j in top if sims[i][j] > 0.02]
        p["text"] = p["text"][:2600]
    json.dump(ps, open(f"{W}/passages_{g}.json", "w")); n += len(ps)
    print(g, len(ps), "passages", sum(len(p["text"].split()) for p in ps), "words")
print("total", n)
