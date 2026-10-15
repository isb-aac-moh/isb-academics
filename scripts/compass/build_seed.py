#!/usr/bin/env python3
"""Merge the Product and Consulting demand graphs into one seed concept list (one graph, many lenses)."""
import json, re, os, collections
OUT = os.path.expanduser("~/Downloads/compass-build/seed_concepts.json")
PM_HTML = os.path.expanduser("~/Downloads/The Product Management Knowledge Graph_files/saved_resource.html")
CONS_JS = os.environ.get("COMPASS_CONSULTING_JS", "practitioner.js")  # path to the consulting graph data file
REL = {"B": "builds_on", "A": "applies", "I": "takes_input_from", "C": "constrained_by", "M": "motivated_by", "E": "encompasses"}

def load_pm():
    s = open(PM_HTML, errors="ignore").read(); i = s.index("const DATA"); j = s.index("{", i)
    d, _ = json.JSONDecoder().raw_decode(s[j:]); return d
def load_cons():
    s = open(CONS_JS, errors="ignore").read(); d, _ = json.JSONDecoder().raw_decode(s[s.index("{"):]); return d
def norm(t): return re.sub(r"[^a-z0-9]+", " ", t.lower()).strip()

pm, cons = load_pm(), load_cons()
mod_pm = {m["key"]: m["name"] for m in pm["modules"]}; mod_c = {m["key"]: m["name"] for m in cons["modules"]}
freq = cons["lenses"]["frequency"]["values"]
items = []
for t in pm["topics"]:
    items.append(dict(id="pm:" + t["id"], graph="product", title=t["title"], aliases=[], obj=t.get("obj", ""), q=t.get("q", ""),
        module=mod_pm.get(t["module"], t["module"]), level=t.get("level"),
        rel=[dict(to="pm:" + r["p"], type=REL.get(r["t"], r["t"]), why=r.get("why", "")) for r in t.get("rel", [])],
        isb_sessions=t.get("sessions", [])))
for t in cons["topics"]:
    items.append(dict(id="co:" + t["id"], graph="consulting", title=t["title"], aliases=t.get("aliases", []), obj=t.get("obj", ""), q=t.get("q", ""),
        module=mod_c.get(t["module"], t["module"]), level=t.get("level"),
        rel=[dict(to="co:" + (r["p"] if isinstance(r, dict) else r), type=REL.get(r.get("t"), r.get("t")) if isinstance(r, dict) else "builds_on", why=(r.get("why", "") if isinstance(r, dict) else "")) for r in t.get("rel", [])],
        freq=freq.get(t["id"], 0)))
# one graph: merge concepts whose title (or an alias) matches across the two graphs
by_key = collections.defaultdict(list)
for it in items:
    for k in {norm(it["title"])} | {norm(a) for a in it["aliases"] if len(norm(a)) > 3}: by_key[k].append(it)
parent = {it["id"]: it["id"] for it in items}
def find(x):
    while parent[x] != x: parent[x] = parent[parent[x]]; x = parent[x]
    return x
for k, grp in by_key.items():
    gs = {g["graph"] for g in grp}
    if len(gs) > 1 and len(grp) <= 3:                     # skip generic labels shared by many topics
        for g in grp[1:]: parent[find(g["id"])] = find(grp[0]["id"])

# Reviewed equivalents across the two graphs (product title, consulting title). One concept, both lenses.
MERGE_TITLES = [
 ("Product-led growth","Product growth"),("Usage-based and consumption models","Usage and consumption based"),
 ("Business Model and Lean Canvas","Business model canvas"),("Product lifecycle models","Product lifecycle"),
 ("Willingness-to-pay research","Willingness to pay"),("Dynamic pricing and surge","Dynamic pricing"),
 ("Market entry strategy","Market entry"),("Market entry strategy","Market entry framework"),
 ("Customer journey mapping","Customer journey"),("Switching costs and lock-in","Switching costs"),
 ("Network effects","Network effects and flywheels"),("Stakeholder mapping and management","Stakeholder mapping"),
 ("Market sizing (TAM / SAM / SOM)","TAM, SAM, SOM"),("B2B vs B2C strategy","B2B vs B2C entry"),
 ("Competitive response and war-gaming","Competitive response"),("Capacity planning","Capacity"),
 ("Positioning","Brand and positioning"),("Blue Ocean and category creation","Blue and red ocean"),
 ("Professional services and packaged services","Professional services"),
 ("Quick-commerce and e-commerce for goods","Quick commerce"),
]
_title_ids = collections.defaultdict(list)
for it in items: _title_ids[(it["graph"], it["title"])].append(it["id"])
for pt, ct in MERGE_TITLES:
    for a in _title_ids.get(("product", pt), []):
        for b in _title_ids.get(("consulting", ct), []):
            parent[find(b)] = find(a)
groups = collections.defaultdict(list)
for it in items: groups[find(it["id"])].append(it)
concepts = []
for root, grp in groups.items():
    g0 = sorted(grp, key=lambda x: (x["graph"] != "product", x["id"]))[0]
    concepts.append(dict(id=g0["id"], title=g0["title"], lenses=sorted({g["graph"] for g in grp}),
        aliases=sorted({a for g in grp for a in g["aliases"]} | {g["title"] for g in grp if g["title"] != g0["title"]}),
        obj=g0["obj"], q=g0["q"], module={g["graph"]: g["module"] for g in grp}, merged_ids=[g["id"] for g in grp],
        rel=[r for g in grp for r in g["rel"]], freq=max((g.get("freq", 0) for g in grp), default=0),
        isb_sessions=sorted({s for g in grp for s in g.get("isb_sessions", [])})))
json.dump(concepts, open(OUT, "w"), indent=0)
both = sum(1 for c in concepts if len(c["lenses"]) > 1)
print(f"{len(items)} topics -> {len(concepts)} concepts | in both lenses: {both} | product only {sum(1 for c in concepts if c['lenses']==['product'])} | consulting only {sum(1 for c in concepts if c['lenses']==['consulting'])}")
print("shared examples:", [c["title"] for c in concepts if len(c["lenses"]) > 1][:25])
