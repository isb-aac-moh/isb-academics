#!/usr/bin/env python3
"""Phase A baseline: file inventory, passages and a keyword index of the extracted course text, scored against the test questions.
Everything is written to $COMPASS_BUILD_DIR/phase_a (outside git). Prints counts, ids and scores only, never course text.
Usage: search_baseline.py inventory | index | eval"""
import csv, glob, hashlib, json, os, re, sqlite3, sys, time, collections
B = os.environ.get("COMPASS_BUILD_DIR", os.path.expanduser("~/Downloads/compass-build"))
OUT = f"{B}/phase_a"; INV = f"{OUT}/inventory.csv"; DB = f"{OUT}/index.sqlite"
QUESTIONS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "eval", "questions.csv")
NAMES = {"STRG": "Strategy", "MKTG": "Marketing Management", "OPMG": "Operations Management", "BANM": "Business Analytics for Marketing", "SWPM": "Software Product Management", "FRNT": "Frontier Technologies"}
# Student-made notes and team work, same rule as build_dataset.py
NON_FACULTY = re.compile(r"Reference_BW|FormulaSheet|Theory_and_Formula|Team_.*Malwa|Master_Notes|S1_Notes|S2-notes|Notes03_ANN|Text_Mining|Unsupervised_ML_for_Marketing|Advanced_Performance|^Notes\.pdf|Quiz2|standardnormal", re.I)
LEAKS = re.compile("|".join(["pgp20", r"\[at\]isb", "@isb", "filewithwatermark"] + [re.escape(p) for p in os.environ.get("COMPASS_LEAK_PATTERNS", "").split(",") if p]), re.I)
TARGET_WORDS = 300  # about 400 tokens, at roughly 1.3 tokens a word
STOP = set("a an the of and or to in on for with by is are was were be do does did how what which where when who why i my we our me you your it its this that at as from about should can could would not no but into than then there their they them have has had if so".split())

def inventory():
    os.makedirs(OUT, exist_ok=True); seen = {}; rows = []
    for f in sorted(glob.glob(f"{B}/extract/*/*.json")):
        d = json.load(open(f)); m = d["meta"]; name = os.path.basename(m["file"])
        words = sum(len(p["text"].split()) for p in d["pages"]); pages = len(d["pages"])
        fingerprint = hashlib.sha256(re.sub(r"\s+", " ", " ".join(p["text"] for p in d["pages"])).lower().encode()).hexdigest()[:16]
        source = os.path.relpath(f, f"{B}/extract")
        rows.append(dict(source=source, course=m["course"], session=m["session"] or "", kind=m["kind"], file=name, pages=pages, words=words, est_tokens=round(words * 1.3),
                         low_text=int(pages > 0 and words / pages < 20), non_faculty=int(bool(NON_FACULTY.search(name))), duplicate_of=seen.get(fingerprint, ""), fingerprint=fingerprint, rights="not confirmed"))
        seen.setdefault(fingerprint, source)
    with open(INV, "w", newline="") as o:
        w = csv.DictWriter(o, fieldnames=rows[0].keys()); w.writeheader(); w.writerows(rows)
    print(len(rows), "files |", sum(r["est_tokens"] for r in rows), "tokens (estimate) |", sum(r["non_faculty"] for r in rows), "student-made |", sum(1 for r in rows if r["duplicate_of"]), "exact duplicates |", sum(r["low_text"] for r in rows), "low text")
    print("tokens by kind", {k: sum(r["est_tokens"] for r in rows if r["kind"] == k) for k in {r["kind"] for r in rows}})

def units(pages):
    """(page number, text) pieces no longer than the target, cut at sentence ends where a page runs long."""
    for p in pages:
        if len(p["text"].split()) <= TARGET_WORDS: yield p["n"], p["text"]; continue
        buf, n = [], 0
        for s in re.split(r"(?<=[.!?])\s+", p["text"]):
            ws = s.split()
            for i in range(0, len(ws), TARGET_WORDS):  # transcripts can run on with no full stops
                chunk = ws[i:i + TARGET_WORDS]
                if n + len(chunk) > TARGET_WORDS and buf: yield p["n"], " ".join(buf); buf, n = [], 0
                buf += chunk; n += len(chunk)
        if buf: yield p["n"], " ".join(buf)

def index():
    if os.path.exists(DB): os.remove(DB)
    db = sqlite3.connect(DB)
    db.executescript("""create table passages(id integer primary key, source text, course text, session int, kind text, page_from int, page_to int, words int);
      create virtual table fts using fts5(heading, body, place, tokenize='porter unicode61');""")
    seen, leaks, n = set(), [], 0
    for r in csv.DictReader(open(INV)):
        if int(r["non_faculty"]) or r["duplicate_of"]: continue
        d = json.load(open(f"{B}/extract/{r['source']}")); pages = d["pages"]; heads = {p["n"]: p.get("heading") or "" for p in pages}
        s = r["session"]; place = f"{r['course']} {NAMES.get(r['course'], '')} " + (f"session {s} S{s} class {s}" if s else "course outline")
        def flush(buf, words):
            nonlocal n
            if words < 12: return
            text = "\n".join(t for _, t in buf); key = hashlib.sha256(re.sub(r"\s+", " ", text).lower().encode()).hexdigest()
            if key in seen: return
            seen.add(key)
            if LEAKS.search(text): leaks.append(r["source"])
            n += 1; db.execute("insert into passages values(?,?,?,?,?,?,?,?)", (n, r["source"], r["course"], int(s) if s else None, r["kind"], buf[0][0], buf[-1][0], words))
            db.execute("insert into fts(rowid, heading, body, place) values(?,?,?,?)", (n, heads.get(buf[0][0], ""), text, place))
        buf, words = [], 0
        for pn, t in units(pages):
            w = len(t.split())
            if words + w > TARGET_WORDS and buf: flush(buf, words); buf, words = [], 0
            buf.append((pn, t)); words += w
        if buf: flush(buf, words)
    db.commit()
    if leaks: print("LEAK SCAN FAILED in", sorted(set(leaks))); os.remove(DB); sys.exit(1)
    w = [x[0] for x in db.execute("select words from passages")]
    print(n, "passages | average words", round(sum(w) / max(n, 1)), "| leak scan clean |", dict(db.execute("select course, count(*) from passages group by course")))

def search(db, q, k=5):
    terms = [t for t in re.findall(r"[a-z0-9]+", q.lower()) if t not in STOP] or re.findall(r"[a-z0-9]+", q.lower())
    match = " OR ".join(f'"{t}"' for t in terms)
    return db.execute("select p.course, p.session, -bm25(fts, 4.0, 1.0, 3.0) from fts join passages p on p.id = fts.rowid where fts match ? order by bm25(fts, 4.0, 1.0, 3.0) limit ?", (match, k)).fetchall()

def judge(row, got):
    want = row["expected"].split("|")
    match = lambda w, c, s: (c == w) if ":" not in w else (c == w.split(":")[0] and s == int(w.split(":")[1]))
    if row["mode"] == "all": return all(any(match(w, c, s) for c, s, _ in got) for w in want)
    return any(match(w, c, s) for w in want for c, s, _ in got)

def evaluate():
    db = sqlite3.connect(DB); rows = list(csv.DictReader(open(QUESTIONS))); res = []
    for r in rows:
        t = time.perf_counter(); got = search(db, r["question"]); ms = (time.perf_counter() - t) * 1000
        res.append(dict(id=r["id"], intent=r["intent"], top=got[0][2] if got else 0.0, hit=(r["mode"] != "none" and judge(r, got)), ms=ms, got=[f"{c}:{s}" for c, s, _ in got]))
    ans = [x for x in res if x["intent"] != "none"]; none = [x for x in res if x["intent"] == "none"]
    print(f"Right session in top 5: {sum(x['hit'] for x in ans)}/{len(ans)} = {100 * sum(x['hit'] for x in ans) / len(ans):.0f}% (pass mark 85%)")
    for intent in sorted({x["intent"] for x in ans}):
        g = [x for x in ans if x["intent"] == intent]; print(f"  {intent:10} {sum(x['hit'] for x in g)}/{len(g)}")
    # Cut-off chosen on odd-numbered questions, judged on even-numbered ones, so it isn't graded on what tuned it.
    num = lambda x: int(x["id"][1:]); tune = [x for x in res if num(x) % 2]; test = [x for x in res if not num(x) % 2]
    def acc(xs, cut):
        a = [x for x in xs if x["intent"] != "none"]; n = [x for x in xs if x["intent"] == "none"]
        return sum(x["top"] < cut for x in n) / max(len(n), 1), sum(x["top"] >= cut for x in a) / max(len(a), 1)
    cut = max(sorted({x["top"] for x in tune}), key=lambda c: sum(acc(tune, c)))
    dec, keep = acc(test, cut)
    print(f"Decline test on held-out questions: declines {100 * dec:.0f}% of unanswerable (pass mark 95%), still answers {100 * keep:.0f}% of answerable")
    lat = sorted(x["ms"] for x in res); print(f"Search time: median {lat[len(lat) // 2]:.1f} ms, slowest {lat[-1]:.1f} ms")
    print("Missed:", " ".join(f"{x['id']}[{','.join(x['got'][:3])}]" for x in ans if not x["hit"]))
    print("Unanswerable top scores vs answerable median:", [round(x["top"], 1) for x in none], "vs", round(sorted(x["top"] for x in ans)[len(ans) // 2], 1))
    json.dump(res, open(f"{OUT}/eval_keyword.json", "w"), indent=0)

EMBED = "BAAI/bge-m3"; RESCORERS = {"mini": "cross-encoder/ms-marco-MiniLM-L-6-v2", "bge": "BAAI/bge-reranker-v2-m3"}
VEC = f"{OUT}/vectors.npy"

def embed():
    import numpy as np
    from sentence_transformers import SentenceTransformer
    rows = sqlite3.connect(DB).execute("select place, heading, body from fts order by rowid").fetchall()
    m = SentenceTransformer(EMBED, device="cpu"); m.max_seq_length = 512
    t = time.perf_counter(); v = m.encode([f"{p}. {h}\n{b}" for p, h, b in rows], batch_size=16, normalize_embeddings=True)
    np.save(VEC, v.astype("float32")); s = time.perf_counter() - t
    print(f"{len(rows)} passages in {s:.0f} s = {len(rows) / s:.1f} a second | {v.shape[1]} numbers each | {os.path.getsize(VEC) / 1e6:.1f} MB")

def decline(res):
    """Pick a cut-off on one half of the questions and judge it on the other, both ways round, so no score grades what tuned it."""
    half = lambda x, k: int(x["id"][1:]) % 2 == k; dec = keep = 0
    def rates(xs, cut): return sum(x["top"] < cut for x in xs if x["intent"] == "none"), sum(x["top"] >= cut for x in xs if x["intent"] != "none")
    for k in (0, 1):
        tune, test = [x for x in res if half(x, k)], [x for x in res if not half(x, k)]
        cut = max(sorted({x["top"] for x in tune}), key=lambda c: sum(a / b for a, b in zip(rates(tune, c), (max(sum(x["intent"] == "none" for x in tune), 1), max(sum(x["intent"] != "none" for x in tune), 1)))))
        d, a = rates(test, cut); dec += d; keep += a
    return dec, keep

def compare():
    import numpy as np, torch
    from sentence_transformers import SentenceTransformer, CrossEncoder
    torch.set_num_threads(2)  # the planned free server has 2 cores
    db = sqlite3.connect(DB); V = np.load(VEC); rows = list(csv.DictReader(open(QUESTIONS)))
    meta = {i: (c, s) for i, c, s in db.execute("select id, course, session from passages")}; body = dict(db.execute("select rowid, body from fts"))
    m = SentenceTransformer(EMBED, device="cpu"); m.max_seq_length = 512
    ce = {k: CrossEncoder(n, device="cpu", max_length=512) for k, n in RESCORERS.items()}
    names = ["keyword", "meaning", "hybrid", "hybrid+mini", "hybrid+bge"]; res = {n: [] for n in names}; ms = collections.defaultdict(list)
    for pass_no in (0, 1):  # the first pass warms the models up; only the second is timed and scored
        for n in names: res[n] = []
        for name in ms: ms[name] = []
        for r in rows:
            t = time.perf_counter(); q = m.encode(r["question"], normalize_embeddings=True); ms["question to vector"].append((time.perf_counter() - t) * 1000)
            t = time.perf_counter(); sim = V @ q; vec = [int(i) + 1 for i in np.argsort(-sim)[:50]]; ms["meaning search"].append((time.perf_counter() - t) * 1000)
            terms = [x for x in re.findall(r"[a-z0-9]+", r["question"].lower()) if x not in STOP]
            t = time.perf_counter(); kw = [(i, -b) for i, b in db.execute("select rowid, bm25(fts, 4.0, 1.0, 3.0) from fts where fts match ? order by bm25(fts, 4.0, 1.0, 3.0) limit 50", (" OR ".join(f'"{x}"' for x in terms),))]; ms["keyword search"].append((time.perf_counter() - t) * 1000)
            ids = [i for i, _ in kw]; rrf = collections.Counter()
            for ranked in (ids, vec):
                for pos, i in enumerate(ranked): rrf[i] += 1 / (60 + pos)
            hyb = [i for i, _ in rrf.most_common(50)]; ranked = {"keyword": (ids, kw[0][1] if kw else 0.0), "meaning": (vec, float(sim.max())), "hybrid": (hyb, float(sim.max()))}
            for k, enc in ce.items():
                t = time.perf_counter(); sc = enc.predict([(r["question"], body[i]) for i in hyb[:20]]); ms[f"re-score 20 ({k})"].append((time.perf_counter() - t) * 1000)
                order = np.argsort(-sc); ranked[f"hybrid+{k}"] = ([hyb[int(i)] for i in order], float(sc.max()))
            for n, (lst, top) in ranked.items():
                got = [(*meta[i], 0) for i in lst[:5]]
                res[n].append(dict(id=r["id"], intent=r["intent"], top=top, hit=(r["mode"] != "none" and judge(r, got)), first=(r["mode"] != "none" and judge(r, got[:1])), got=[f"{c}:{s}" for c, s, _ in got]))
    intents = sorted({r["intent"] for r in rows} - {"none"})
    print("variant        top5  top1  " + "  ".join(f"{i[:7]:7}" for i in intents) + "  declines  answers")
    for n in names:
        a = [x for x in res[n] if x["intent"] != "none"]; d, k = decline(res[n])
        print(f"{n:13} {sum(x['hit'] for x in a):3}/{len(a)} {sum(x['first'] for x in a):3}/{len(a)}  " + "  ".join(f"{sum(x['hit'] for x in a if x['intent'] == i):3}/{sum(x['intent'] == i for x in a):<3}" for i in intents) + f"  {d}/10     {k}/{len(a)}")
    print("\nTime in ms, 2 threads on this Mac:")
    for name, v in ms.items(): v = sorted(v); print(f"  {name:22} median {v[len(v) // 2]:7.1f}  slowest {v[-1]:7.1f}")
    for n in names: print(f"Missed by {n}:", " ".join(x["id"] for x in res[n] if x["intent"] != "none" and not x["hit"]))
    json.dump(res, open(f"{OUT}/eval_compare.json", "w"), indent=0)

# A spread of question types, including two the library should not be able to answer.
REVIEW = "q01 q06 q10 q12 q13 q14 q16 q18 q20 q25 q26 q29 q31 q33 q36 q39 q47 q49 q51 q58".split()
DEV = f"{OUT}/compass-dev.json"; IDEA_VEC = f"{OUT}/idea_vectors.npy"; REVIEW_HTML = f"{OUT}/review.html"
REVIEW_PAGE = """<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; script-src 'unsafe-inline'"><title>Compass answer review</title><style>
:root{--bg:#FAFAF8;--surface:#FFF;--line:#E2E2DC;--ink:#16181D;--ink2:#50545C;--navy:#1C3A6E;--tint:#EAF0FA;color-scheme:light}
@media (prefers-color-scheme:dark){:root{--bg:#12141A;--surface:#1A1D25;--line:#2E333E;--ink:#F0F0EC;--ink2:#B9BCC3;--navy:#9DBBEE;--tint:#1E2A42;color-scheme:dark}}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:400 16px/1.55 system-ui,-apple-system,sans-serif}
main{max-width:720px;margin:0 auto;padding-block:28px 48px;padding-inline:max(16px,env(safe-area-inset-left,0px)) max(16px,env(safe-area-inset-right,0px))}
h1{font:600 30px/1.15 Georgia,serif;margin:0 0 8px}h2{font:400 15px/1.4 system-ui,sans-serif;color:var(--ink2);margin:0 0 8px}h3{font:600 22px/1.25 Georgia,serif;margin:0 0 12px}h4{font:600 12px/1.3 system-ui,sans-serif;letter-spacing:.06em;text-transform:uppercase;color:var(--ink2);margin:14px 0 2px}p{margin:0 0 10px}.mut{color:var(--ink2)}.sm{font-size:14px}
.bar{position:sticky;top:0;background:var(--bg);border-block:1px solid var(--line);padding:8px 0;margin:16px 0 24px;font-weight:600;font-variant-numeric:tabular-nums}
section{margin-bottom:32px}article{background:var(--surface);border:1px solid var(--line);border-radius:6px;padding:16px}.none h3{color:var(--ink2)}
.meta{font-size:14px;color:var(--ink2);margin-top:14px}details{margin-top:12px;font-size:14px;border-top:1px solid var(--line);padding-top:10px}summary{cursor:pointer;color:var(--navy);font-weight:600;min-height:28px}.txt{white-space:pre-wrap;overflow-wrap:anywhere;margin:8px 0 0}
fieldset{border:0;padding:0;margin:14px 0 0;display:flex;flex-wrap:wrap;gap:8px}legend{position:absolute;width:1px;height:1px;overflow:hidden;clip-path:inset(50%)}
label{display:inline-flex;align-items:center;gap:6px;min-height:44px;padding:0 12px;border:1px solid var(--line);border-radius:6px;cursor:pointer}label:has(input:checked){background:var(--tint);border-color:var(--navy);font-weight:600}
input:focus-visible,button:focus-visible,textarea:focus-visible,summary:focus-visible{outline:2px solid var(--navy);outline-offset:2px}button{font:600 15px system-ui,sans-serif;min-height:44px;padding:0 16px;border:1px solid var(--navy);border-radius:6px;background:var(--navy);color:var(--bg);cursor:pointer}
textarea{width:100%;height:150px;margin-top:12px;font:13px ui-monospace,Menlo,monospace;background:var(--surface);color:var(--ink);border:1px solid var(--line);border-radius:6px;padding:8px}</style></head><body><main>
<h1>Compass answer review</h1><p>For each question, is this something you could take away and use at a glance? About 5 minutes.</p>
<p class="mut sm">Draft: these cards are AI-written and not yet checked against the slides. This page holds course material, so show it on your own screen and don't send the file.</p>
<div class="bar" id="bar" role="status">0 marked</div>__BODY__
<section><p>When you've finished, copy your results and paste them into the chat with Claude. They contain only question numbers and your marks.</p><button type="button" id="copy">Copy results</button> <span id="said" role="status" class="mut"></span><textarea id="out" readonly aria-label="Your results"></textarea></section>
</main><script>
const K='compass.cards',form=document.querySelectorAll('section[data-q]');let saved={};try{saved=JSON.parse(localStorage.getItem(K)||'{}')}catch(e){}
function read(a){const v=a.querySelector('input[type=radio]:checked');return{v:v?v.value:'',w:a.querySelector('input[type=checkbox]').checked}}
function sync(){const m={},lines=[];let n=0;form.forEach(a=>{const r=read(a);m[a.dataset.q]=r;if(r.v){n++;lines.push(a.dataset.q+' '+r.v+(r.w?' wrong-topic':''))}});try{localStorage.setItem(K,JSON.stringify(m))}catch(e){}document.getElementById('bar').textContent=n+' of '+form.length+' marked';document.getElementById('out').value=lines.join('\\n')}
form.forEach(a=>{const r=saved[a.dataset.q];if(!r)return;if(r.v){const i=a.querySelector('input[value="'+r.v+'"]');if(i)i.checked=true}a.querySelector('input[type=checkbox]').checked=!!r.w});
document.addEventListener('change',sync);sync();
document.getElementById('copy').addEventListener('click',async()=>{const o=document.getElementById('out'),s=document.getElementById('said');try{await navigator.clipboard.writeText(o.value);s.textContent='Copied.'}catch(e){o.focus();o.select();s.textContent='Press Command+C to copy the selected text.'}});
</script></body></html>"""

def tidy(t):
    """Strip leftover markdown and slide furniture so source text reads cleanly."""
    t = re.sub(r"^\s*#{1,6}\s*", "", t, flags=re.M); t = re.sub(r"\*\*|__|`", "", t)
    t = re.sub(r"^\s*[-*•▪◦·‣]+\s+", "• ", t, flags=re.M); t = re.sub(r"^\s*\|?[-:| ]{3,}\|?\s*$", "", t, flags=re.M); t = t.replace("|", " · ")
    t = re.sub(r"^\s*\d{1,3}\s*$", "", t, flags=re.M); t = re.sub(r"[ \t]+", " ", t)
    return re.sub(r"\n\s*\n+", "\n", t).strip()

def cards():
    import html, numpy as np
    from sentence_transformers import SentenceTransformer
    data = json.load(open(DEV)); C = data["concepts"]; ideas = sorted((c for c in C.values() if c.get("evidence") and c.get("know")), key=lambda c: c["id"])
    docs = [f"{c['title']}. {' '.join(c['aliases'])}. {c['know']['what']} {c['know']['use']}" for c in ideas]
    m = SentenceTransformer(EMBED, device="cpu"); m.max_seq_length = 512
    if os.path.exists(IDEA_VEC) and len(np.load(IDEA_VEC)) == len(ideas): IV = np.load(IDEA_VEC)
    else: IV = m.encode(docs, batch_size=16, normalize_embeddings=True); np.save(IDEA_VEC, IV)
    db = sqlite3.connect(":memory:"); db.execute("create virtual table f using fts5(title, aliases, body, tokenize='porter unicode61')")
    db.executemany("insert into f(rowid, title, aliases, body) values(?,?,?,?)", [(i + 1, c["title"], " ".join(c["aliases"]), f"{c['know']['what']} {c['know']['use']} {c['know']['trap']}") for i, c in enumerate(ideas)])
    def find(q):
        v = IV @ m.encode(q, normalize_embeddings=True); terms = [x for x in re.findall(r"[a-z0-9]+", q.lower()) if x not in STOP]; rrf = collections.Counter()
        for pos, (i,) in enumerate(db.execute("select rowid from f where f match ? order by bm25(f, 6.0, 4.0, 1.0) limit 30", (" OR ".join(f'"{x}"' for x in terms),))): rrf[i - 1] += 1 / (60 + pos)
        for pos, i in enumerate(np.argsort(-v)[:30]): rrf[int(i)] += 1 / (60 + pos)
        return [ideas[i] for i, _ in rrf.most_common(3)], float(v.max())
    rows = list(csv.DictReader(open(QUESTIONS))); res = []; found = {}
    for r in rows:
        top, sim = find(r["question"]); found[r["id"]] = (top, sim)
        ev = lambda cs: [(e["course"], e["session"], 0) for c in cs for e in c["evidence"]]
        res.append(dict(id=r["id"], intent=r["intent"], top=sim, hit=r["mode"] != "none" and judge(r, ev(top)), first=r["mode"] != "none" and judge(r, ev(top[:1]))))
    a = [x for x in res if x["intent"] != "none"]; d, k = decline(res); print(f"Idea cards: right session in top 3 ideas {sum(x['hit'] for x in a)}/{len(a)} | first idea {sum(x['first'] for x in a)}/{len(a)} | declines {d}/10 | answers {k}/{len(a)}")
    print("By type:", {i: f"{sum(x['hit'] for x in a if x['intent'] == i)}/{sum(x['intent'] == i for x in a)}" for i in sorted({x['intent'] for x in a})})
    cut = max(sorted({x["top"] for x in res}), key=lambda c: sum(x["top"] < c for x in res if x["intent"] == "none") / 10 + sum(x["top"] >= c for x in a) / len(a))
    src = {}
    for f in glob.glob(f"{B}/work/passages_*.json"):
        for p in json.load(open(f)): src.setdefault(p["id"], p["text"])
    parts = []
    for r in rows:
        if r["id"] not in REVIEW: continue
        top, sim = found[r["id"]]; e = html.escape; c = top[0]; name = r["id"]
        closest = ", ".join(e(x["title"]) for x in top)
        if sim < cut: body = f'<article class="none"><h3>Not in our material yet</h3><p>We have loaded 6 of 138 courses so far.</p><p class="meta">Closest ideas: {closest}</p>'
        else:
            where = sorted({(x["course"], x["session"]) for x in c["evidence"] if x["session"]}, key=str)
            taught = "; ".join(f"{NAMES.get(k, k)} session {', '.join(str(s) for cc, s in where if cc == k)}" for k in dict.fromkeys(cc for cc, _ in where))
            know = c["know"]; ev = next((x for x in sorted(c["evidence"], key=lambda x: x["role"] != "teaches") if x["passage"] in src), None)
            more = "".join(f"<h4>{t}</h4><p>{e(tidy(know[k]))}</p>" for t, k in (("When to use it", "use"), ("Watch out for", "trap")))
            source = f'<details><summary>See what the class material says</summary><p class="txt">{e(tidy(src[ev["passage"]]))}</p></details>' if ev else ""
            body = f'<article><h3>{e(c["title"])}</h3><p>{e(tidy(know["what"]))}</p>{more}<p class="meta">Taught in {e(taught)}.</p>{source}'
        marks = "".join(f'<label><input type="radio" name="{name}" value="{v}">{t}</label>' for v, t in (("clear", "Clear and useful"), ("ok", "Okay"), ("no", "Not useful")))
        parts.append(f'<section data-q="{name}"><h2>{e(r["question"])}</h2>{body}<fieldset><legend>Could you use this at a glance?</legend>{marks}<label><input type="checkbox">Wrong topic</label></fieldset></article></section>')
        print(name, "NONE" if sim < cut else "card", f"{sim:.2f}", "|", top[0]["title"][:42], "|", r["question"][:58])
    open(REVIEW_HTML, "w").write(REVIEW_PAGE.replace("__BODY__", "".join(parts)))
    print(len(parts), "questions | cut-off", round(cut, 3))

def audit():
    """Triage only: is each card sentence closer to the idea's own sessions than to the same number of passages from unrelated courses? Prints titles and counts, no course text."""
    import random, numpy as np
    from sentence_transformers import SentenceTransformer
    data = json.load(open(DEV)); ideas = sorted((c for c in data["concepts"].values() if c.get("evidence") and c.get("know")), key=lambda c: c["id"])
    db = sqlite3.connect(DB); V = np.load(VEC); rows = db.execute("select id, course, session from passages").fetchall(); rng = random.Random(27)
    by = collections.defaultdict(list); byc = collections.defaultdict(list)
    for i, c, s in rows: by[(c, s)].append(i - 1); byc[c].append(i - 1)
    sents = [(c, f, x.strip()) for c in ideas for f in ("what", "use", "trap") for x in re.split(r"(?<=[.!?])\s+", c["know"][f]) if x.strip()]
    m = SentenceTransformer(EMBED, device="cpu"); m.max_seq_length = 512; E = m.encode([x for _, _, x in sents], batch_size=32, normalize_embeddings=True)
    out = []
    for (c, f, x), e in zip(sents, E):
        keys = {(a["course"], a["session"]) for a in c["evidence"]}; own = sorted({i for k in keys for i in by.get(k, [])}); courses = {k[0] for k in keys}
        other = [i for k, v in byc.items() if k not in courses for i in v]
        if not own: out.append(dict(id=c["id"], title=c["title"], field=f, own=-1.0, other=-1.0, courses=sorted(courses))); continue
        out.append(dict(id=c["id"], title=c["title"], field=f, own=float((V[own] @ e).max()), other=float((V[rng.sample(other, min(len(own), len(other)))] @ e).max()), courses=sorted(courses)))
    cut = float(np.percentile([x["other"] for x in out if x["other"] >= 0], 95))
    for x in out: x["near"] = x["own"] >= cut
    print(f"{len(ideas)} cards | {len(out)} sentences | near their sessions {sum(x['near'] for x in out)}/{len(out)} = {100 * sum(x['near'] for x in out) / len(out):.0f}% | bar {cut:.2f} (95th percentile of unrelated passages)")
    print("By field:", {f: f"{100 * sum(x['near'] for x in out if x['field'] == f) / sum(x['field'] == f for x in out):.0f}%" for f in ("what", "use", "trap")})
    print("By course:", {k: f"{100 * sum(x['near'] for x in out if k in x['courses']) / sum(k in x['courses'] for x in out):.0f}%" for k in NAMES})
    cs = collections.defaultdict(list)
    for x in out: cs[x["title"]].append(x)
    print("Cards with every sentence near:", sum(all(x["near"] for x in v) for v in cs.values()), "| none near:", sum(not any(x["near"] for x in v) for v in cs.values()), "| no passages in their sessions:", sum(all(x["own"] < 0 for x in v) for v in cs.values()))
    print("Weakest:", "; ".join(sorted(cs, key=lambda t: max(x["own"] for x in cs[t]))[:14]))
    b = cs.get("BCG matrix"); print("BCG matrix own-session best:", round(max(x["own"] for x in b), 2) if b else "no card")
    json.dump(out, open(f"{OUT}/card_audit.json", "w"), indent=0)

if __name__ == "__main__": {"inventory": inventory, "index": index, "eval": evaluate, "embed": embed, "compare": compare, "cards": cards, "audit": audit}[sys.argv[1] if len(sys.argv) > 1 else "eval"]()
