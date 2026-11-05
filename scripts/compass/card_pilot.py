#!/usr/bin/env python3
"""Pilot of source-only idea cards. Writing and sentence checks are done by Claude agents following prompts/card_brief.md; this script prepares their inputs,
runs the software checks and builds the review page. Everything stays in $COMPASS_BUILD_DIR/phase_a/pilot (outside git). Prints counts and titles only.
Usage: card_pilot.py prepare | check | clarity | rewrite | report | final | search2 | decline | mvp | intent | export | browser_rule"""
import glob, html, json, os, random, re, sqlite3, sys, collections
from search_baseline import B, DB, DEV, NAMES, REVIEW_PAGE, STOP, tidy
BASE = os.path.join(os.path.dirname(DB), "pilot"); WAVE = os.environ.get("COMPASS_WAVE", "")  # later batches live in pilot/wave_N
P = os.path.join(BASE, f"wave_{WAVE}") if WAVE else BASE; WAVE_SIZE = 40
KNOWN = ["Newsvendor critical ratio", "The Hook model", "BCG matrix", "Cheap talk", "CAC, LTV and payback", "Network effects"]
PER_COURSE = 4; MAX_PASSAGES = 6; WORDS_WHAT = 35; WORDS_OTHER = 30

def ideas():
    return sorted((c for c in json.load(open(DEV))["concepts"].values() if c.get("evidence") and c.get("know")), key=lambda c: c["id"])

def prepare():
    os.makedirs(P, exist_ok=True); rng = random.Random(27); all_ideas = ideas()
    if WAVE:
        done = {x["id"] for f in glob.glob(f"{BASE}/**/in_*.json", recursive=True) for x in json.load(open(f))}
        left = [c for c in all_ideas if c["id"] not in done]; rng.shuffle(left); chosen = left[:WAVE_SIZE]; print(len(left), "ideas left before this batch")
    else:
        chosen = [c for c in all_ideas if c["title"] in KNOWN]
        for code in NAMES:
            pool = [c for c in all_ideas if c not in chosen and any(e["course"] == code and e["role"] == "teaches" for e in c["evidence"])]
            chosen += rng.sample(pool, PER_COURSE)
    src = {}
    for f in glob.glob(f"{B}/work/passages_*.json"):
        for p in json.load(open(f)): src.setdefault(p["id"], p)
    db = sqlite3.connect(DB); out = []
    for c in chosen:
        passages, seen = [], set()
        def add(course, session, kind, text):
            key = re.sub(r"\W+", "", text.lower())[:300]
            if key in seen or len(passages) >= MAX_PASSAGES or not text: return
            seen.add(key); passages.append(dict(id=f"p{len(passages) + 1}", course=course, session=session, kind=kind, text=text))
        for e in sorted(c["evidence"], key=lambda e: e["role"] != "teaches"):
            if len(passages) >= 4: break
            if e["passage"] in src: add(e["course"], e["session"], e["kind"], tidy(src[e["passage"]]["text"]))
        terms = [t for t in re.findall(r"[a-z0-9]+", c["title"].lower()) if t not in STOP]; courses = {e["course"] for e in c["evidence"]}
        if terms:  # also pull what the index finds for the title, in the same courses, so transcripts get a chance
            for course, session, kind, body in db.execute("select p.course, p.session, p.kind, fts.body from fts join passages p on p.id = fts.rowid where fts match ? order by bm25(fts, 4.0, 1.0, 3.0) limit 20", (" AND ".join(f'"{t}"' for t in terms),)):
                if course in courses: add(course, session, kind, tidy(body))
        out.append(dict(id=c["id"], title=c["title"], aliases=c["aliases"], passages=passages))
    rng.shuffle(out)
    for n in range(2 if WAVE else 3): json.dump(out[n::2 if WAVE else 3], open(f"{P}/in_{n}.json", "w"), separators=(",", ":"))
    print(len(out), "ideas |", sum(len(x["passages"]) for x in out), "passages | about", round(sum(len(p["text"].split()) for x in out for p in x["passages"]) * 1.3 / 1000), "thousand tokens | none found:", [x["title"] for x in out if not x["passages"]])

def load():
    inputs = {x["id"]: x for f in glob.glob(f"{P}/in_*.json") for x in json.load(open(f))}
    cards = {}
    for f in sorted(glob.glob(f"{P}/out_*.jsonl")):
        for line in open(f):
            if line.strip(): r = json.loads(line); cards[r["id"]] = r
    return inputs, cards

def software(s, cite, passages, limit):
    if not cite: return "no citation"
    if any(i not in passages for i in cite): return "citation not in input"
    if len(s.split()) > limit: return "too long"
    text = " ".join(passages[i]["text"] for i in cite).lower()
    words = s.split()
    names = [m.group() for w in words[1:] for m in [re.match(r"[A-Z][a-zA-Z]+", w)] if m]
    if words and re.match(r"[A-Z]\w*[A-Z]", words[0]): names.append(re.match(r"\w+", words[0]).group())
    for tok in re.findall(r"\d[\d.,]*%?", s) + names:
        if tok.rstrip(".,").lower() not in text: return f"not in source: {tok}"
    return ""

def check():
    inputs, cards = load(); batch = []; fails = collections.Counter(); kept = 0
    for cid, c in cards.items():
        passages = {p["id"]: p for p in inputs[cid]["passages"]}
        for f in ("what", "use", "trap"):
            for n, x in enumerate(c.get(f) or []):
                why = software(x["s"], x.get("cite") or [], passages, WORDS_WHAT if f == "what" else WORDS_OTHER)
                x["software"] = why
                if why: fails[why.split(":")[0]] += 1
                else: kept += 1; batch.append(dict(key=f"{cid}|{f}|{n}", sentence=x["s"], text="\n\n".join(passages[i]["text"] for i in x["cite"])))
    json.dump(cards, open(f"{P}/cards_checked.json", "w"), indent=0)
    redo = {json.loads(l)["id"] for l in open(f"{P}/out_3.jsonl") if l.strip()} if os.path.exists(f"{P}/out_3.jsonl") else None
    rng = random.Random(27)
    if redo is None and len(batch) > 8:  # hidden tripwires: a sentence from one card against another card's text must not pass
        for _ in range(6):
            x, y = rng.sample(batch, 2)
            if x["key"].split("|")[0] != y["key"].split("|")[0]: batch.insert(rng.randrange(len(batch)), dict(key=f"z{rng.randrange(10**6)}|{x['key'].split('|')[1]}|0", sentence=x["sentence"], text=y["text"]))
    if redo is not None: batch = [b for b in batch if b["key"].split("|")[0] in redo]; json.dump(batch, open(f"{P}/check_in_2.json", "w"), indent=0)
    else:
        for n in range(2): json.dump(batch[n::2], open(f"{P}/check_in_{n}.json", "w"), indent=0)
    print(len(cards), "cards |", dict(collections.Counter(c.get("status") for c in cards.values())), "|", kept, "sentences pass software |", dict(fails))

def surviving(cards, verdict, f, cid, c):
    return [x for n, x in enumerate(c.get(f) or []) if not x.get("software") and verdict.get(f"{cid}|{f}|{n}") == "yes"]

def verdicts():
    v = {}
    for f in sorted(glob.glob(f"{P}/check_out_*.jsonl")):
        for line in open(f):
            if line.strip(): r = json.loads(line); v[r["key"]] = r["verdict"]
    return v

def clarity():
    """Input for the readability check: the finished card only, never its source."""
    inputs, _ = load(); cards = json.load(open(f"{P}/cards_checked.json")); v = verdicts(); out = []
    for cid, c in cards.items():
        out.append(dict(id=cid, title=inputs[cid]["title"], **{f: " ".join(x["s"] for x in surviving(cards, v, f, cid, c)) for f in ("what", "use", "trap")}))
    out = [x for x in out if x["what"]]  # no "what" left means the card is already held back
    json.dump(out, open(f"{P}/clarity_in.json", "w"), indent=0); print(len(out), "cards ready for the clarity check")

def rewrite():
    """Input for rewriting: only the cards marked unclear, with their passages and the named problem."""
    inputs, _ = load(); rows = [json.loads(l) for l in open(f"{P}/clarity_out.jsonl") if l.strip()]; bad = [r for r in rows if r["verdict"] != "clear"]
    cards = {x["id"]: x for x in json.load(open(f"{P}/clarity_in.json"))}
    json.dump([dict(inputs[r["id"]], current=cards[r["id"]], problem=r.get("problem", "")) for r in bad], open(f"{P}/rewrite_in.json", "w"), indent=0)
    print(len(rows) - len(bad), "clear |", len(bad), "unclear |", dict(collections.Counter(r.get("problem", "") for r in bad)), "|", [inputs[r["id"]]["title"] for r in bad])

def report():
    inputs, _ = load(); cards = json.load(open(f"{P}/cards_checked.json")); verdict = {}
    for f in sorted(glob.glob(f"{P}/check_out_*.jsonl")):
        for line in open(f):
            if line.strip(): r = json.loads(line); verdict[r["key"]] = r["verdict"]
    final = f"{P}/clarity_out_2.jsonl"; still_unclear = {json.loads(l)["id"]: json.loads(l).get("problem", "") for l in open(final) if l.strip() and json.loads(l)["verdict"] != "clear"} if os.path.exists(final) else {}
    old = {c["id"]: c for c in ideas()}; tally = collections.Counter(); parts = []; held = []; e = html.escape; fields = collections.Counter(); words = []
    for cid, c in cards.items():
        good = {}
        for f in ("what", "use", "trap"):
            good[f] = []
            for n, x in enumerate(c.get(f) or []):
                v = "software" if x.get("software") else verdict.get(f"{cid}|{f}|{n}", "missing"); tally[v] += 1
                if v == "yes": good[f].append(x)
        if not good["what"]: held.append(inputs[cid]["title"] + (" (not taught)" if c.get("status") == "insufficient" else " (failed checks)")); continue
        if cid in still_unclear: held.append(inputs[cid]["title"] + " (still unclear)"); continue
        for f in good: fields[f] += bool(good[f])
        words.append(sum(len(x["s"].split()) for f in good for x in good[f]))
        used = {i for f in good for x in good[f] for i in x["cite"]}; ps = {p["id"]: p for p in inputs[cid]["passages"]}
        body = "".join(f"<p>{e(' '.join(x['s'] for x in good['what']))}</p>" if f == "what" else (f"<h4>{t}</h4><p>{e(' '.join(x['s'] for x in good[f]))}</p>" if good[f] else "") for f, t in (("what", ""), ("use", "When to use it"), ("trap", "Watch out for")))
        where = "; ".join(sorted({f"{NAMES.get(ps[i]['course'], ps[i]['course'])} session {ps[i]['session']}" for i in used if ps[i]["session"]}))
        k = old[cid]["know"]; before = f"{k['what']} When to use it: {k['use']} Watch out for: {k['trap']}"
        source = "".join(f'<p class="txt">{e(ps[i]["text"])}</p>' for i in sorted(used))
        marks = "".join(f'<label><input type="radio" name="{e(cid)}" value="{v}">{t}</label>' for v, t in (("clear", "Clear and useful"), ("ok", "Okay"), ("no", "Not useful")))
        parts.append(f'<section data-q="{e(cid)}"><article><h3>{e(inputs[cid]["title"])}</h3>{body}<p class="meta">Taught in {e(where)}.</p><details><summary>See what the class material says</summary>{source}</details><details><summary>Compare with today\'s unchecked card</summary><p class="txt">{e(before)}</p></details><fieldset><legend>Could you use this at a glance?</legend>{marks}<label><input type="checkbox">Says something wrong</label></fieldset></article></section>')
    page = REVIEW_PAGE.replace("For each question, is this something you could take away and use at a glance? About 5 minutes.", "These cards were written only from class material, and every sentence passed a check against its source. Could you use each one at a glance?").replace("Draft: these cards are AI-written and not yet checked against the slides. This page", "Pilot of 30 ideas. This page").replace("compass.cards", "compass.pilot").replace("wrong-topic", "wrong")
    if held: parts.append(f'<section><h3>Held back</h3><p class="mut">No card shown, because class material didn\'t teach the idea or the sentences failed their checks: {e(", ".join(held))}.</p></section>')
    open(f"{P}/pilot.html", "w").write(page.replace("__BODY__", "".join(parts)))
    trip = [v for k, v in verdict.items() if k.startswith("z")]
    if trip: print("tripwires caught", sum(v != "yes" for v in trip), "of", len(trip))
    print(len(parts) - bool(held), "cards shown |", len(held), "held:", held)
    print("sentence outcomes", dict(tally), "| cards with use", fields["use"], "with trap", fields["trap"], "| median words", sorted(words)[len(words) // 2] if words else 0)

def render(rows, found, cut):
    """Build the review page from the top cards found for each test question."""
    from search_baseline import REVIEW
    e = html.escape; parts = []
    for r in rows:
        if r["id"] not in REVIEW: continue
        top, sim = found[r["id"]]; c = top[0]; name = r["id"]
        print(name, "NONE" if sim < cut else "card", f"{sim:.2f}", "|", c["title"][:40], "|", r["question"][:54])
        if sim < cut: body = f'<article class="none"><h3>Not in our material yet</h3><p>We have loaded 6 of 138 courses so far.</p><p class="meta">Closest ideas: {e(", ".join(x["title"] for x in top))}</p>'
        else:
            where = "; ".join(f"{NAMES.get(k, k)} session {', '.join(str(s) for cc, s in c['where'] if cc == k and s)}" for k in dict.fromkeys(cc for cc, _ in c["where"]))
            more = "".join(f"<h4>{t}</h4><p>{e(c[f])}</p>" for t, f in (("When to use it", "use"), ("Watch out for", "trap")) if c[f])
            src = "".join(f'<p class="txt">{e(t)}</p>' for t in c["source"])
            body = f'<article><h3>{e(c["title"])}</h3><p>{e(c["what"])}</p>{more}<p class="meta">Taught in {e(where)}.</p><details><summary>See what the class material says</summary>{src}</details>'
        marks = "".join(f'<label><input type="radio" name="{name}" value="{v}">{t}</label>' for v, t in (("clear", "Clear and useful"), ("ok", "Okay"), ("no", "Not useful")))
        parts.append(f'<section data-q="{name}"><h2>{e(r["question"])}</h2>{body}<fieldset><legend>Could you use this at a glance?</legend>{marks}<label><input type="checkbox">Wrong topic</label></fieldset></article></section>')
    page = REVIEW_PAGE.replace("Draft: these cards are AI-written and not yet checked against the slides. This page", "These cards are written only from class material, and every sentence passed a check against its source. This page").replace("compass.cards", "compass.final")
    open(f"{BASE}/final.html", "w").write(page.replace("__BODY__", "".join(parts))); print("cut-off", round(cut, 3))

def final():
    """Combine every batch into one set of shown cards, score search against them on the test questions, and build the review page. Prints counts and titles only."""
    import csv, numpy as np
    from sentence_transformers import SentenceTransformer
    from search_baseline import EMBED, QUESTIONS, REVIEW, decline, judge
    shown, held = [], []; fields = collections.Counter()
    for d in [BASE] + sorted(glob.glob(f"{BASE}/wave_*")):
        if not os.path.exists(f"{d}/cards_checked.json"): continue
        inputs = {x["id"]: x for f in glob.glob(f"{d}/in_*.json") for x in json.load(open(f))}; cards = json.load(open(f"{d}/cards_checked.json")); v = {}
        for f in sorted(glob.glob(f"{d}/check_out_*.jsonl")):
            for line in open(f):
                if line.strip(): r = json.loads(line); v[r["key"]] = r["verdict"]
        unclear = {json.loads(l)["id"] for l in open(f"{d}/clarity_out_2.jsonl") if l.strip() and json.loads(l)["verdict"] != "clear"} if os.path.exists(f"{d}/clarity_out_2.jsonl") else set()
        for cid, c in cards.items():
            good = {f: [x for n, x in enumerate(c.get(f) or []) if not x.get("software") and v.get(f"{cid}|{f}|{n}") == "yes"] for f in ("what", "use", "trap")}
            title = inputs[cid]["title"]
            if c.get("status") == "insufficient": held.append((title, "not enough material")); continue
            if not good["what"]: held.append((title, "failed checks")); continue
            if cid in unclear: held.append((title, "still unclear")); continue
            ps = {p["id"]: p for p in inputs[cid]["passages"]}; used = sorted({i for f in good for x in good[f] for i in x["cite"]})
            for f in good: fields[f] += bool(good[f])
            shown.append(dict(id=cid, title=title, aliases=inputs[cid]["aliases"], **{f: " ".join(x["s"] for x in good[f]) for f in good}, where=sorted({(ps[i]["course"], ps[i]["session"]) for i in used}, key=str), source=[ps[i]["text"] for i in used]))
    json.dump(shown, open(f"{BASE}/cards_final.json", "w")); json.dump(held, open(f"{BASE}/held_back.json", "w"))
    by = collections.Counter(c for x in shown for c in {w[0] for w in x["where"]})
    print(len(shown), "cards shown |", len(held), "held", dict(collections.Counter(r for _, r in held)), "| with use", fields["use"], "with trap", fields["trap"], "| by course", dict(by))
    m = SentenceTransformer(EMBED, device="cpu"); m.max_seq_length = 512
    IV = m.encode([f"{c['title']}. {' '.join(c['aliases'])}. {c['what']} {c['use']} {c['trap']}" for c in shown], batch_size=16, normalize_embeddings=True)
    db = sqlite3.connect(":memory:"); db.execute("create virtual table f using fts5(title, aliases, body, tokenize='porter unicode61')")
    db.executemany("insert into f(rowid, title, aliases, body) values(?,?,?,?)", [(i + 1, c["title"], " ".join(c["aliases"]), f"{c['what']} {c['use']} {c['trap']}") for i, c in enumerate(shown)])
    def find(q):
        e = IV @ m.encode(q, normalize_embeddings=True); rrf = collections.Counter(); terms = [x for x in re.findall(r"[a-z0-9]+", q.lower()) if x not in STOP]
        for pos, (i,) in enumerate(db.execute("select rowid from f where f match ? order by bm25(f, 6.0, 4.0, 1.0) limit 30", (" OR ".join(f'"{x}"' for x in terms),))): rrf[i - 1] += 1 / (60 + pos)
        for pos, i in enumerate(np.argsort(-e)[:30]): rrf[int(i)] += 1 / (60 + pos)
        return [shown[i] for i, _ in rrf.most_common(3)], float(e.max())
    rows = list(csv.DictReader(open(QUESTIONS))); res = []; found = {}
    for r in rows:
        top, sim = find(r["question"]); found[r["id"]] = (top, sim); ev = lambda cs: [(c, s, 0) for x in cs for c, s in x["where"]]
        res.append(dict(id=r["id"], intent=r["intent"], top=sim, hit=r["mode"] != "none" and judge(r, ev(top)), first=r["mode"] != "none" and judge(r, ev(top[:1]))))
    a = [x for x in res if x["intent"] != "none"]; d, k = decline(res)
    print(f"Right session in top 3 cards {sum(x['hit'] for x in a)}/{len(a)} | first card {sum(x['first'] for x in a)}/{len(a)} | declines {d}/10 | still answers {k}/{len(a)}")
    print("By type:", {i: f"{sum(x['hit'] for x in a if x['intent'] == i)}/{sum(x['intent'] == i for x in a)}" for i in sorted({x['intent'] for x in a})})
    cut = max(sorted({x["top"] for x in res}), key=lambda c: sum(x["top"] < c for x in res if x["intent"] == "none") / 10 + sum(x["top"] >= c for x in a) / len(a))
    render(rows, found, cut)

COURSE_WORDS = {"OPMG": r"opmg|operations", "STRG": r"strg|strategy", "MKTG": r"mktg|marketing", "BANM": r"banm|business analytics", "SWPM": r"swpm|software product management", "FRNT": r"frnt|frontier"}
def scope(q):
    """If a question names exactly one course and asks about a session, class or coverage, return (course, session or None). A plain rule, no AI."""
    low = q.lower()
    if "across" in low or not re.search(r"\b(session|class|cover|covered)\b", low): return None
    named = [c for c, w in COURSE_WORDS.items() if re.search(rf"\b({w})\b", low)]
    if len(named) != 1: return None
    n = re.search(r"\b(?:session|class)\s+(\d+)", low)
    return named[0], int(n.group(1)) if n else None

def engine():
    """Load the cards, their questions and the models. Returns (cards, questions, text, embedder, re-scorer, find)."""
    import numpy as np, torch
    from sentence_transformers import SentenceTransformer, CrossEncoder
    from search_baseline import EMBED, RESCORERS
    torch.set_num_threads(2)
    cards = json.load(open(f"{BASE}/cards_final.json")); qs = {}
    for f in glob.glob(f"{BASE}/intent/out_*.jsonl"):
        for line in open(f):
            if line.strip(): r = json.loads(line); qs[r["id"]] = r["questions"]
    cards = [c for c in cards if c["id"] in qs]; text = lambda c: f"{c['title']}. {c['what']} {c['use']} {c['trap']}"
    m = SentenceTransformer(EMBED, device="cpu"); m.max_seq_length = 512; ce = CrossEncoder(RESCORERS["mini"], device="cpu", max_length=512)
    CV = m.encode([f"{c['title']}. {' '.join(c['aliases'])}. {c['what']} {c['use']} {c['trap']}" for c in cards], batch_size=16, normalize_embeddings=True)
    owner = [i for i, c in enumerate(cards) for _ in qs[c["id"]]]; QV = m.encode([q for c in cards for q in qs[c["id"]]], batch_size=32, normalize_embeddings=True); owner = np.array(owner)
    db = sqlite3.connect(":memory:"); db.execute("create virtual table f using fts5(title, aliases, body, questions, tokenize='porter unicode61')")
    db.executemany("insert into f(rowid, title, aliases, body, questions) values(?,?,?,?,?)", [(i + 1, c["title"], " ".join(c["aliases"]), f"{c['what']} {c['use']} {c['trap']}", " ".join(qs[c["id"]])) for i, c in enumerate(cards)])
    def find(q, use_questions):
        e = m.encode(q, normalize_embeddings=True); v = CV @ e
        if use_questions:
            best = np.zeros(len(cards)); np.maximum.at(best, owner, QV @ e); v = np.maximum(v, best)
        terms = [x for x in re.findall(r"[a-z0-9]+", q.lower()) if x not in STOP]; rrf = collections.Counter(); w = (6.0, 4.0, 1.0, 2.0 if use_questions else 0.0)
        for pos, (i,) in enumerate(db.execute("select rowid from f where f match ? order by bm25(f, ?, ?, ?, ?) limit 30", (" OR ".join(f'"{x}"' for x in terms), *w))): rrf[i - 1] += 1 / (60 + pos)
        for pos, i in enumerate(np.argsort(-v)[:30]): rrf[int(i)] += 1 / (60 + pos)
        ranked = [i for i, _ in rrf.most_common(40)]
        sc = scope(q) if use_questions == "scoped" else None
        if sc:
            keep = [i for i in ranked if any(c == sc[0] and (sc[1] is None or s == sc[1]) for c, s in cards[i]["where"])]
            if not keep: keep = [i for i, c in enumerate(cards) if any(cc == sc[0] and (sc[1] is None or s == sc[1]) for cc, s in c["where"])]
            ranked = keep or ranked
        return ranked[:20], float(v.max())
    return cards, qs, text, m, ce, find

def search2():
    """Compare card search with and without the questions each card answers, then with the small re-scorer. Prints scores and titles only."""
    import csv, numpy as np, time
    from search_baseline import QUESTIONS, decline, judge
    cards, qs, text, m, ce, find = engine()
    rows = list(csv.DictReader(open(QUESTIONS))); names = ["cards only", "cards + questions", "cards + questions + course rule", "same + re-score"]; res = {n: [] for n in names}; ms = []; firsts = {}; found = {}
    for r in rows:
        ids0, s0 = find(r["question"], False); ids1, s1 = find(r["question"], True); ids2, s2 = find(r["question"], "scoped")
        t = time.perf_counter(); sc = ce.predict([(r["question"], text(cards[i])) for i in ids2]); ms.append((time.perf_counter() - t) * 1000); order = [ids2[int(i)] for i in np.argsort(-sc)]
        for n, ids, top in ((names[0], ids0, s0), (names[1], ids1, s1), (names[2], ids2, s2), (names[3], order, float(sc.max()))):
            ev = lambda k: [(c, s, 0) for i in ids[:k] for c, s in cards[i]["where"]]
            res[n].append(dict(id=r["id"], intent=r["intent"], top=top, hit=r["mode"] != "none" and judge(r, ev(3)), first=r["mode"] != "none" and judge(r, ev(1))))
        firsts[r["id"]] = (cards[ids2[0]]["title"][:40] if ids2 else "-", r["question"][:50]); found[r["id"]] = ([cards[i] for i in ids2[:3]], s2)
    types = sorted({r["intent"] for r in rows} - {"none"})
    print("variant                        top3   first  " + " ".join(f"{t[:7]:7}" for t in types) + " declines answers")
    for n in names:
        a = [x for x in res[n] if x["intent"] != "none"]; d, k = decline(res[n])
        print(f"{n:30} {sum(x['hit'] for x in a):2}/{len(a)} {sum(x['first'] for x in a):2}/{len(a)}  " + " ".join(f"{sum(x['first'] for x in a if x['intent'] == t):2}/{sum(x['intent'] == t for x in a):<4}" for t in types) + f" {d}/10   {k}/{len(a)}")
    ms.sort(); print(f"re-score 20 cards: median {ms[len(ms) // 2]:.0f} ms, slowest {ms[-1]:.0f} ms, 2 threads")
    for q in "q13 q14 q18 q20 q25 q26 q29 q31 q33 q41 q42 q43 q44 q45 q46".split(): print(q, firsts[q])
    json.dump(res, open(f"{BASE}/search2.json", "w"), indent=0)
    best = res[names[2]]; ans = [x for x in best if x["intent"] != "none"]
    cut = max(sorted({x["top"] for x in best}), key=lambda c: sum(x["top"] < c for x in best if x["intent"] == "none") / 10 + sum(x["top"] >= c for x in ans) / len(ans))
    render(rows, found, cut); print("page rebuilt, cut-off", round(cut, 3))
    print("Still wrong first card:", " ".join(x["id"] for x in ans if not x["first"]))

def decline_test():
    """Test signals for declining on 50 answerable and 40 unanswerable questions, using cross-validation so no score grades what trained it."""
    import csv, numpy as np
    from sklearn.linear_model import LogisticRegression
    from sklearn.model_selection import StratifiedKFold
    from search_baseline import QUESTIONS, judge
    cards, qs, text, m, ce, find = engine()
    extra = os.path.join(os.path.dirname(QUESTIONS), "decline_questions.csv"); rows = list(csv.DictReader(open(QUESTIONS))) + [dict(id=r["id"], intent="none", question=r["question"], expected="", mode="none", kind=r["kind"]) for r in csv.DictReader(open(extra))]
    pdb = sqlite3.connect(DB); tok = lambda t: re.findall(r"[a-z0-9]+", t.lower()); stem = lambda w: re.sub(r"(ing|es|s|ed)$", "", w)
    def df_absent(t):
        return pdb.execute("select count(*) from fts where fts match ?", (f'"{t}"',)).fetchone()[0] == 0
    corpus = {stem(w) for c in cards for w in tok(text(c) + " " + " ".join(c["aliases"]) + " " + " ".join(qs[c["id"]]))}
    X, y, info, found = [], [], [], {}
    for r in rows:
        ids, sim = find(r["question"], "scoped"); sc = ce.predict([(r["question"], text(cards[i])) for i in ids]) if ids else np.array([-12.0])
        terms = [t for t in tok(r["question"]) if t not in STOP and len(t) > 2]; top = cards[ids[0]] if ids else None
        absent = sum(stem(t) not in corpus and df_absent(t) for t in terms)
        tw = {stem(w) for w in tok(text(top) + " " + " ".join(qs[top["id"]]))} if top else set()
        cover = sum(stem(t) in tw for t in terms) / max(len(terms), 1)
        right = r["mode"] != "none" and judge(r, [(c, s, 0) for c, s in top["where"]]) if top else False
        X.append([sim, float(sc.max()), absent, cover, 1.0 if scope(r["question"]) else 0.0]); y.append(1 if right else 0); info.append((r["id"], r["intent"], right, r.get("kind", ""))); found[r["id"]] = ([cards[i] for i in ids[:3]], r["question"])
    X = np.array(X); y = np.array(y); names = ["similarity", "re-scorer", "absent terms", "word cover", "course rule"]
    def cv(cols):
        p = np.zeros(len(y))
        for seed in range(10):
            for tr, te in StratifiedKFold(5, shuffle=True, random_state=seed).split(X, y):
                mu, sd = X[tr][:, cols].mean(0), X[tr][:, cols].std(0) + 1e-9
                p[te] += LogisticRegression(class_weight="balanced", max_iter=1000).fit((X[tr][:, cols] - mu) / sd, y[tr]).predict_proba((X[te][:, cols] - mu) / sd)[:, 1] / 10
        return p
    neg = [i for i, x in enumerate(info) if x[1] == "none"]; rightq = [i for i, x in enumerate(info) if x[2]]; wrongq = [i for i, x in enumerate(info) if x[1] != "none" and not x[2]]
    print(f"{len(neg)} unanswerable, {len(rightq)} answerable with right first card, {len(wrongq)} answerable with wrong first card")
    print("signals                         declines  shows right  shows wrong card")
    for label, cols in (("similarity only", [0]), ("re-scorer only", [1]), ("similarity + re-scorer", [0, 1]), ("absent terms + similarity", [0, 2]), ("all signals", [0, 1, 2, 3, 4]), ("all except absent terms", [0, 1, 3, 4])):
        p = cv(cols); print(f"{label:30} {sum(p[i] < .5 for i in neg):2}/{len(neg)}     {sum(p[i] >= .5 for i in rightq):2}/{len(rightq)}        {sum(p[i] >= .5 for i in wrongq):2}/{len(wrongq)}")
    p = cv([0, 1, 3, 4])
    print("Unanswerable still answered:", " ".join(info[i][0] for i in neg if p[i] >= .5)); print("Right answers wrongly declined:", " ".join(info[i][0] for i in rightq if p[i] < .5))
    print("By kind declined:", {k: f"{sum(p[i] < .5 for i in neg if info[i][3] == k)}/{sum(info[i][3] == k for i in neg)}" for k in {info[i][3] for i in neg}})
    cols = [0, 1, 3, 4]; mu, sd = X[:, cols].mean(0), X[:, cols].std(0) + 1e-9; lr = LogisticRegression(class_weight="balanced", max_iter=1000).fit((X[:, cols] - mu) / sd, y)
    print("Weights:", {n: round(float(w), 2) for n, w in zip([names[c] for c in cols], lr.coef_[0])})
    json.dump(dict(names=[names[c] for c in cols], mean=mu.tolist(), sd=sd.tolist(), coef=lr.coef_[0].tolist(), intercept=float(lr.intercept_[0])), open(f"{BASE}/decline_rule.json", "w"))
    pg = {info[i][0]: (found[info[i][0]][0], float(p[i])) for i in range(len(info))}
    render([r for r in rows if r["id"] in pg], pg, 0.5)

def mvp_test():
    """Can the first release run with keyword search only, in the browser, with no server? Compare keyword only with keyword + meaning, each with its own decline formula."""
    import csv, numpy as np
    from sklearn.linear_model import LogisticRegression
    from sklearn.model_selection import StratifiedKFold
    from search_baseline import QUESTIONS, judge
    cards, qs, text, m, ce, find = engine()
    extra = os.path.join(os.path.dirname(QUESTIONS), "decline_questions.csv"); rows = list(csv.DictReader(open(QUESTIONS))) + [dict(id=r["id"], intent="none", question=r["question"], expected="", mode="none") for r in csv.DictReader(open(extra))]
    tok = lambda t: re.findall(r"[a-z0-9]+", t.lower()); stem = lambda w: re.sub(r"(ing|es|s|ed)$", "", w)
    db = sqlite3.connect(":memory:"); db.execute("create virtual table f using fts5(title, aliases, body, questions, tokenize='porter unicode61')")
    db.executemany("insert into f(rowid, title, aliases, body, questions) values(?,?,?,?,?)", [(i + 1, c["title"], " ".join(c["aliases"]), f"{c['what']} {c['use']} {c['trap']}", " ".join(qs[c["id"]])) for i, c in enumerate(cards)])
    def keyword(q):
        terms = [t for t in tok(q) if t not in STOP]; got = db.execute("select rowid, -bm25(f, 6.0, 4.0, 1.0, 2.0) from f where f match ? order by bm25(f, 6.0, 4.0, 1.0, 2.0) limit 40", (" OR ".join(f'"{t}"' for t in terms),)).fetchall() if terms else []
        ranked = [i - 1 for i, _ in got]; sc = scope(q)
        if sc:
            keep = [i for i in ranked if any(a == sc[0] and (sc[1] is None or b == sc[1]) for a, b in cards[i]["where"])] or [i for i, c in enumerate(cards) if any(a == sc[0] and (sc[1] is None or b == sc[1]) for a, b in c["where"])]
            ranked = keep or ranked
        return ranked, (got[0][1] if got else 0.0)
    def cv(X, y):
        p = np.zeros(len(y))
        for seed in range(10):
            for tr, te in StratifiedKFold(5, shuffle=True, random_state=seed).split(X, y):
                mu, sd = X[tr].mean(0), X[tr].std(0) + 1e-9; p[te] += LogisticRegression(class_weight="balanced", max_iter=1000).fit((X[tr] - mu) / sd, y[tr]).predict_proba((X[te] - mu) / sd)[:, 1] / 10
        return p
    def cover(q, c):
        terms = [t for t in tok(q) if t not in STOP and len(t) > 2]; tw = {stem(w) for w in tok(text(c) + " " + " ".join(qs[c["id"]]))}
        return sum(stem(t) in tw for t in terms) / max(len(terms), 1)
    for label, search, withsim in (("keyword only, in the browser", keyword, False), ("keyword + meaning, needs a server or API", lambda q: find(q, "scoped"), True)):
        X, y, firsts, top3s, kinds = [], [], [], [], []
        for r in rows:
            ids, score = search(r["question"]); top = cards[ids[0]] if ids else None; ans = r["mode"] != "none"
            ev = lambda k: [(a, b, 0) for i in ids[:k] for a, b in cards[i]["where"]]
            f = ans and bool(ids) and judge(r, ev(1)); firsts.append(f); top3s.append(ans and bool(ids) and judge(r, ev(3))); kinds.append(ans)
            X.append([score, cover(r["question"], top) if top else 0.0, 1.0 if scope(r["question"]) else 0.0]); y.append(1 if f else 0)
        X = np.array(X); y = np.array(y); p = cv(X, y); na = sum(kinds)
        print(f"{label}: first card {sum(firsts)}/{na} | top 3 {sum(top3s)}/{na} | declines {sum(p[i] < .5 for i in range(len(y)) if not kinds[i])}/{len(y) - na} | shows right {sum(p[i] >= .5 for i in range(len(y)) if firsts[i])}/{sum(firsts)} | shows wrong {sum(p[i] >= .5 for i in range(len(y)) if kinds[i] and not firsts[i])}/{na - sum(firsts)}")
        print("  first card by type:", {t: f"{sum(firsts[i] for i, r in enumerate(rows) if r['intent'] == t)}/{sum(r['intent'] == t for r in rows)}" for t in sorted({r['intent'] for r in rows} - {'none'})})

def intent():
    """Write inputs for the INTENT agents: only cards that have no questions yet, and only the card text, never its source."""
    cards = json.load(open(f"{BASE}/cards_final.json")); have = set(); os.makedirs(f"{BASE}/intent", exist_ok=True)
    for f in glob.glob(f"{BASE}/intent/out_*.jsonl"):
        have |= {json.loads(l)["id"] for l in open(f) if l.strip()}
    todo = [dict(id=c["id"], title=c["title"], what=c["what"], use=c["use"], trap=c["trap"]) for c in cards if c["id"] not in have]
    start = len(glob.glob(f"{BASE}/intent/in_*.json"))
    for n in range(4):
        if todo[n::4]: json.dump(todo[n::4], open(f"{BASE}/intent/in_{start + n}.json", "w"), separators=(",", ":"))
    print(len(todo), "cards need questions")

def export():
    """Write the app's data file holding only checked cards: no unchecked explainers, AI summaries or AI-suggested links. Derived data only, no slide text."""
    data = json.load(open(DEV)); cards = json.load(open(f"{BASE}/cards_final.json")); qs = {}
    for f in glob.glob(f"{BASE}/intent/out_*.jsonl"):
        for line in open(f):
            if line.strip(): r = json.loads(line); qs[r["id"]] = r["questions"]
    out = [dict(id=c["id"], title=c["title"], aliases=c["aliases"], what=c["what"], use=c["use"], trap=c["trap"], where=c["where"], questions=qs[c["id"]]) for c in cards if c["id"] in qs]
    have = {c["id"]: c for c in out}; dropped = 0
    for c in data["concepts"].values():
        card = have.get(c["id"]); c.pop("know", None); c.pop("definition", None)
        if card: c["know"] = dict(what=card["what"], use=card["use"], trap=card["trap"])
        before = len(c["rel"]); c["rel"] = [r for r in c["rel"] if not r.get("auto")]; dropped += before - len(c["rel"])
        for e in c["evidence"]: e["summary"] = ""; e["why"] = ""
    data["cards"] = out; data["meta"]["counts"].update(cards=len(out), held=len(data["concepts"]) and sum(1 for c in data["concepts"].values() if c["evidence"] and c["id"] not in have)); data["meta"]["built"] = __import__("datetime").datetime.now().isoformat(timespec="seconds")
    target = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "public", "compass-dev.json")
    for path in (target, f"{BASE}/compass-v2.json"): json.dump(data, open(path, "w"), separators=(",", ":"))
    print(len(out), "cards |", dropped, "AI links removed |", round(os.path.getsize(target) / 1e6, 2), "MB")

def browser_rule():
    """Score the app's real browser search on 90 questions with cross-validation, fit the decline formula and write it into the data file."""
    import csv, subprocess, numpy as np
    from sklearn.linear_model import LogisticRegression
    from sklearn.model_selection import StratifiedKFold
    from search_baseline import QUESTIONS, judge
    here = os.path.dirname(os.path.abspath(__file__)); target = os.path.join(here, "..", "..", "public", "compass-dev.json")
    rows = list(csv.DictReader(open(QUESTIONS))) + [dict(id=r["id"], intent="none", question=r["question"], expected="", mode="none") for r in csv.DictReader(open(os.path.join(here, "eval", "decline_questions.csv")))]
    run = subprocess.run(["node", os.path.join(here, "eval_ask.mjs"), target], input=json.dumps([r["question"] for r in rows]), capture_output=True, text=True, check=True)
    print(run.stderr.strip().splitlines()[-1]); got = json.loads(run.stdout); data = json.load(open(target)); cards = {c["id"]: c for c in data["cards"]}
    wh = lambda ids: [(a, b, 0) for i in ids for a, b in cards[i]["where"]]
    first = [r["mode"] != "none" and bool(g["ids"]) and judge(r, wh(g["ids"][:1])) for r, g in zip(rows, got)]; top3 = [r["mode"] != "none" and bool(g["ids"]) and judge(r, wh(g["ids"])) for r, g in zip(rows, got)]
    X = np.array([g["features"] for g in got]); y = np.array(first, dtype=int); p = np.zeros(len(y)); ans = np.array([r["mode"] != "none" for r in rows])
    for seed in range(10):
        for tr, te in StratifiedKFold(5, shuffle=True, random_state=seed).split(X, y):
            mu, sd = X[tr].mean(0), X[tr].std(0) + 1e-9; p[te] += LogisticRegression(class_weight="balanced", max_iter=1000).fit((X[tr] - mu) / sd, y[tr]).predict_proba((X[te] - mu) / sd)[:, 1] / 10
    print(f"first card {sum(first)}/{ans.sum()} | top 3 {sum(top3)}/{ans.sum()} | declines {((p < .5) & ~ans).sum()}/{(~ans).sum()} | shows right {((p >= .5) & (y == 1)).sum()}/{y.sum()} | shows wrong {((p >= .5) & ans & (y == 0)).sum()}/{(ans & (y == 0)).sum()}")
    print("first card by type:", {t: f"{sum(f for f, r in zip(first, rows) if r['intent'] == t)}/{sum(r['intent'] == t for r in rows)}" for t in sorted({r['intent'] for r in rows} - {'none'})})
    print("unanswerable it still answers:", [r["question"][:42] for r, q in zip(rows, p) if r["mode"] == "none" and q >= .5])
    mu, sd = X.mean(0), X.std(0) + 1e-9; lr = LogisticRegression(class_weight="balanced", max_iter=1000).fit((X - mu) / sd, y)
    data["declineRule"] = dict(mean=mu.tolist(), sd=sd.tolist(), coef=lr.coef_[0].tolist(), intercept=float(lr.intercept_[0]))
    for path in (target, f"{BASE}/compass-v2.json"): json.dump(data, open(path, "w"), separators=(",", ":"))
    print("rule written", {k: round(float(v), 2) for k, v in zip(["score", "cover", "course rule"], lr.coef_[0])})

if __name__ == "__main__": {"prepare": prepare, "check": check, "clarity": clarity, "rewrite": rewrite, "report": report, "final": final, "search2": search2, "decline": decline_test, "mvp": mvp_test, "intent": intent, "export": export, "browser_rule": browser_rule}[sys.argv[1]]()
