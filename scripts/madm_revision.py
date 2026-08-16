"""Builds the five MADM end-term revision guides into public/madm-revision/.

    python3 scripts/madm_revision.py

The guides are standalone HTML "field manuals", the same artefact OPMG already has in
public/opmg-revision/ and shown the same way (an iframe, registered in
src/learn/lib/revisionGuides.ts). They are deliberately not Learn database content: a guide is one
finished document per session with its own typography and in-page interactions, and splitting it
into learn_session_content markdown would throw all of that away.

Unlike the OPMG guides, which were hand-written one file at a time, these five are generated from
one template. Five near-identical 1,000-line documents diverge the moment one of them is edited,
and the design system — the CSS in STYLE below — is lifted verbatim from public/opmg-revision so
the two courses' guides look like the same product.

Each guide is a set of "stations": prose sections, one or two interactive widgets, an MCQ set and
a cheat sheet. The widgets are the part worth having — a variance splitter that recomputes the
three columns as you drag actual volume is worth more than another table of the same numbers.
"""

import html
import pathlib

OUT = pathlib.Path(__file__).resolve().parent.parent / "public" / "madm-revision"

STYLE = r"""  :root{
    --navy-deep:#0A1B33;
    --navy-panel:#0F2745;
    --navy-panel-2:#14304F;
    --grid-line: rgba(150,205,235,0.07);
    --blue-line:#6FB7E0;
    --blue-bright:#BFE6F7;
    --paper:#EDE6D3;
    --paper-2:#E4DBC4;
    --ink:#1D1B14;
    --ink-soft:#4A4636;
    --amber:#F2B705;
    --stop-red:#D6544F;
    --go-green:#4E9A6E;
    --violet:#9C8FD6;
    --font-display:'Big Shoulders Display', sans-serif;
    --font-body:'IBM Plex Sans', sans-serif;
    --font-mono:'IBM Plex Mono', monospace;
  }
  *{box-sizing:border-box;}
  html{scroll-behavior:smooth;}
  body{
    margin:0;
    background:
      radial-gradient(ellipse at 15% 0%, rgba(111,183,224,0.10), transparent 55%),
      radial-gradient(ellipse at 85% 100%, rgba(111,183,224,0.08), transparent 55%),
      var(--navy-deep);
    background-attachment:fixed;
    color:var(--blue-bright);
    font-family:var(--font-body);
    line-height:1.5;
    -webkit-font-smoothing:antialiased;
  }
  body::before{
    content:"";
    position:fixed; inset:0; pointer-events:none;
    background-image:
      linear-gradient(var(--grid-line) 1px, transparent 1px),
      linear-gradient(90deg, var(--grid-line) 1px, transparent 1px);
    background-size:34px 34px;
    z-index:0;
  }
  a{color:inherit;}
  ::selection{background:var(--amber); color:var(--ink);}
  :focus-visible{outline:2px solid var(--amber); outline-offset:2px;}

  .masthead{position:relative; z-index:1; max-width:1180px; margin:0 auto; padding:38px 24px 18px;}
  .masthead-top{display:flex; align-items:flex-end; justify-content:space-between; gap:20px; flex-wrap:wrap; border-bottom:1px solid rgba(191,230,247,0.25); padding-bottom:16px;}
  .doc-code{font-family:var(--font-mono); font-size:11px; letter-spacing:.14em; color:var(--blue-line); text-transform:uppercase;}
  h1.title{font-family:var(--font-display); font-weight:800; font-size:clamp(30px, 5.6vw, 64px); line-height:0.94; margin:6px 0 0; letter-spacing:0.3px; color:#fff; text-transform:uppercase;}
  .title .accent{color:var(--amber);}
  .subtitle{font-family:var(--font-body); font-size:15px; color:var(--blue-bright); opacity:0.85; max-width:560px; margin-top:6px;}
  .stamp{font-family:var(--font-mono); font-size:11px; text-align:right; color:var(--blue-line); letter-spacing:.08em; line-height:1.7;}
  .stamp b{color:var(--blue-bright);}

  .panel{position:relative; max-width:1180px; margin:0 auto; padding:0 24px 100px; z-index:1;}
  .switchboard{display:flex; flex-wrap:wrap; gap:8px; margin:26px 0 28px; padding:10px; background:rgba(10,27,51,0.55); border:1px solid rgba(191,230,247,0.18); border-radius:10px;}
  .stn{appearance:none; border:1px solid rgba(191,230,247,0.22); background:var(--navy-panel); color:var(--blue-bright); font-family:var(--font-mono); font-size:12px; letter-spacing:.05em; padding:10px 14px; border-radius:6px; cursor:pointer; display:flex; align-items:center; gap:8px; transition:background .15s ease, border-color .15s ease, transform .1s ease;}
  .stn:hover{border-color:var(--blue-line); transform:translateY(-1px);}
  .stn .lamp{width:7px; height:7px; border-radius:50%; background:rgba(191,230,247,0.3); transition:background .15s ease, box-shadow .15s ease; flex-shrink:0;}
  .stn.active{background:var(--paper); color:var(--ink); border-color:var(--paper);}
  .stn.active .lamp{background:var(--amber); box-shadow:0 0 8px 1px var(--amber);}
  .stn .num{opacity:0.6;}
  .stn.active .num{opacity:0.9;}

  .sheet{background:var(--paper); color:var(--ink); border-radius:10px; padding:clamp(20px, 4vw, 48px); position:relative; box-shadow:0 24px 60px -20px rgba(0,0,0,0.55);}
  .sheet::before{content:""; position:absolute; inset:10px; border:1px dashed rgba(29,27,20,0.14); border-radius:6px; pointer-events:none;}
  .tab-panel{display:none; animation:fadeIn .35s ease;}
  .tab-panel.show{display:block;}
  @keyframes fadeIn{from{opacity:0; transform:translateY(6px);} to{opacity:1; transform:translateY(0);}}

  .eyebrow{font-family:var(--font-mono); font-size:11px; letter-spacing:.16em; text-transform:uppercase; color:var(--ink-soft); margin-bottom:8px;}
  h2.head{font-family:var(--font-display); font-weight:800; font-size:clamp(26px,3.8vw,42px); text-transform:uppercase; letter-spacing:.3px; margin:0 0 6px; line-height:0.98;}
  .dek{font-size:16px; max-width:700px; color:var(--ink-soft); margin-bottom:26px;}
  h3.sub{font-family:var(--font-display); font-weight:700; font-size:21px; text-transform:uppercase; letter-spacing:.3px; margin:30px 0 10px;}
  p{margin:0 0 12px;}
  .lead{font-size:15.5px;}

  .note{background:var(--paper-2); border-left:3px solid var(--amber); border-radius:4px; padding:14px 16px; margin:16px 0; font-size:14.5px;}
  .note b{font-family:var(--font-mono); text-transform:uppercase; font-size:11px; letter-spacing:.08em; display:block; margin-bottom:4px; color:var(--ink-soft);}
  .note.stop{border-left-color:var(--stop-red);}
  .note.go{border-left-color:var(--go-green);}
  .note.violet{border-left-color:var(--violet);}

  .grid2{display:grid; grid-template-columns:1.05fr 1fr; gap:26px; align-items:start;}
  @media(max-width:860px){.grid2{grid-template-columns:1fr;}}

  .diagram-frame{background:var(--navy-panel); border-radius:8px; padding:18px; border:1px solid rgba(191,230,247,0.15);}
  .diagram-frame svg{width:100%; height:auto; display:block;}
  .diagram-cap{font-family:var(--font-mono); font-size:10.5px; color:var(--blue-line); text-align:center; margin-top:8px; letter-spacing:.05em;}

  ul.tidy{padding-left:18px; margin:10px 0;}
  ul.tidy li{margin-bottom:6px;}

  .btnrow{display:flex; gap:10px; flex-wrap:wrap; margin:14px 0;}
  .btn{font-family:var(--font-mono); font-size:12px; letter-spacing:.04em; text-transform:uppercase; background:var(--ink); color:var(--paper); border:none; padding:10px 16px; border-radius:5px; cursor:pointer; transition:transform .1s ease, background .15s ease;}
  .btn:hover{transform:translateY(-1px); background:#332f21;}
  .btn.secondary{background:transparent; color:var(--ink); border:1px solid var(--ink);}

  .toggle-wrap{display:flex; gap:0; margin:14px 0 20px; border:1px solid var(--ink); border-radius:6px; overflow:hidden; width:fit-content; flex-wrap:wrap;}
  .toggle-wrap button{font-family:var(--font-mono); font-size:11.5px; text-transform:uppercase; letter-spacing:.04em; padding:9px 16px; border:none; background:transparent; color:var(--ink); cursor:pointer;}
  .toggle-wrap button.active{background:var(--ink); color:var(--paper);}

  .ctrl-block{margin:12px 0;}
  .ctrl-block label{display:flex; justify-content:space-between; font-family:var(--font-mono); font-size:11.5px; text-transform:uppercase; letter-spacing:.04em; margin-bottom:4px;}
  .ctrl-block label .live{color:var(--stop-red); font-weight:700;}
  .ctrl-block input[type=range]{width:100%; accent-color:var(--stop-red);}

  .readout-row{display:grid; grid-template-columns:repeat(auto-fit,minmax(120px,1fr)); gap:10px; margin:16px 0;}
  .readout-card{background:var(--ink); color:var(--paper); border-radius:8px; padding:12px; text-align:center;}
  .readout-card .val{font-family:var(--font-mono); font-weight:700; font-size:22px; color:var(--amber);}
  .readout-card .lbl{font-family:var(--font-mono); font-size:9.5px; letter-spacing:.06em; text-transform:uppercase; opacity:.75; margin-top:4px;}
  .readout-card.blue .val{color:var(--blue-bright);}
  .readout-card.violet .val{color:var(--violet);}
  .readout-card.green .val{color:var(--go-green);}
  .readout-card.red .val{color:var(--stop-red);}

  .formula-box{background:var(--ink); color:var(--paper); border-radius:6px; padding:12px 16px; font-family:var(--font-mono); font-size:14px; text-align:center; margin:14px 0;}

  .cheat-grid{display:grid; grid-template-columns:repeat(auto-fit,minmax(230px,1fr)); gap:16px; margin-top:12px;}
  .cheat-card{background:var(--navy-panel); border-radius:8px; padding:16px; border:1px solid rgba(191,230,247,0.15);}
  .cheat-card h4{font-family:var(--font-mono); font-size:12px; text-transform:uppercase; letter-spacing:.06em; color:var(--amber); margin:0 0 8px;}
  .cheat-card ul{margin:0; padding-left:16px; font-size:13px; color:var(--blue-bright);}
  .cheat-card li{margin-bottom:5px;}
  .cheat-card .f{font-family:var(--font-mono); font-size:12px; background:rgba(0,0,0,0.25); padding:6px 8px; border-radius:4px; margin-top:6px;}

  .app-grid{display:grid; grid-template-columns:repeat(auto-fit,minmax(230px,1fr)); gap:14px; margin-top:16px;}
  .app-card{background:var(--navy-panel); border-radius:8px; padding:16px; border:1px solid rgba(191,230,247,0.15);}
  .app-card h4{font-family:var(--font-mono); font-size:12px; text-transform:uppercase; letter-spacing:.05em; color:var(--blue-bright); margin:0 0 6px;}
  .app-card p{font-size:13px; color:var(--blue-line); margin:0;}

  .errtable{width:100%; border-collapse:collapse; margin-top:10px; font-size:13px;}
  .errtable th{font-family:var(--font-mono); font-size:11px; text-transform:uppercase; letter-spacing:.05em; text-align:left; padding:8px 10px; background:var(--ink); color:var(--paper);}
  .errtable td{padding:10px; border-bottom:1px solid rgba(29,27,20,0.12); vertical-align:top;}
  .errtable tr:last-child td{border-bottom:none;}

  .quiz-top{display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:18px;}
  .score-pill{font-family:var(--font-mono); font-size:12px; background:var(--ink); color:var(--paper); padding:8px 14px; border-radius:20px;}
  .qcard{display:none;}
  .qcard.show{display:block; animation:fadeIn .3s ease;}
  .qnum{font-family:var(--font-mono); font-size:11px; color:var(--ink-soft); letter-spacing:.08em; text-transform:uppercase; margin-bottom:6px;}
  .qtext{font-family:var(--font-body); font-weight:600; font-size:17.5px; margin-bottom:16px;}
  .opt{display:block; width:100%; text-align:left; background:var(--paper-2); border:1px solid rgba(29,27,20,0.15); border-radius:6px; padding:12px 14px; margin-bottom:9px; font-family:var(--font-body); font-size:14.5px; color:var(--ink); cursor:pointer; transition:border-color .15s ease, background .15s ease;}
  .opt:hover{border-color:var(--ink);}
  .opt.correct{background:rgba(78,154,110,0.18); border-color:var(--go-green);}
  .opt.wrong{background:rgba(214,84,79,0.16); border-color:var(--stop-red);}
  .opt[disabled]{cursor:default;}
  .feedback{display:none; margin-top:6px;}
  .feedback.show{display:block;}
  .quiz-nav{display:flex; justify-content:space-between; margin-top:20px;}
  .quiz-summary{display:none; text-align:center; padding:20px 0;}
  .quiz-summary.show{display:block;}
  .quiz-summary .big{font-family:var(--font-display); font-size:52px; color:var(--ink); font-weight:800;}

  .footer-strip{max-width:1180px; margin:0 auto; padding:0 24px 50px; font-family:var(--font-mono); font-size:11px; color:var(--blue-line); letter-spacing:.06em; text-align:center; opacity:.6;}

  table.simple{width:100%; border-collapse:collapse; font-size:13px; margin-top:6px;}
  table.simple th{text-align:left; padding:7px 6px; font-family:var(--font-mono); font-weight:600; font-size:11px; text-transform:uppercase; letter-spacing:.04em; border-bottom:2px solid var(--ink);}
  table.simple td{padding:7px 6px; border-bottom:1px solid rgba(29,27,20,0.12);}

  @media (prefers-reduced-motion: reduce){ *{animation-duration:0.01ms !important; transition-duration:0.01ms !important;} }
"""

# The quiz engine, tab switching and the shared number formatter. Lifted from the OPMG guides so
# the two courses behave identically; per-guide widget code is appended after this.
CORE_JS = r"""
const stns = document.querySelectorAll('.stn');
const panels = document.querySelectorAll('.tab-panel');
stns.forEach(btn=>{
  btn.addEventListener('click', ()=>{
    stns.forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
    panels.forEach(p=>p.classList.remove('show'));
    document.getElementById('tab-'+btn.dataset.tab).classList.add('show');
    document.querySelector('.sheet').scrollIntoView({behavior:'smooth', block:'start'});
  });
});

function money(n, dp){
  if(dp===undefined) dp = 0;
  const s = Math.abs(n).toLocaleString('en-US', {minimumFractionDigits:dp, maximumFractionDigits:dp});
  return (n<0?'-$':'$') + s;
}
function fu(n){ return n===0 ? '0' : money(Math.abs(n)) + (n<0 ? ' U' : ' F'); }

function initQuiz(questions, ids){
  let qIdx=0, score=0, answered=[];
  const quizHost = document.getElementById(ids.host);
  const scorePill = document.getElementById(ids.scorePill);
  const progPill = document.getElementById(ids.progPill);
  const quizSummary = document.getElementById(ids.summary);

  function renderQuiz(){
    quizHost.innerHTML='';
    quizSummary.classList.remove('show');
    questions.forEach((item, idx)=>{
      const card = document.createElement('div');
      card.className='qcard'+(idx===qIdx?' show':'');
      card.dataset.idx = idx;
      card.innerHTML = `
        <div class="qnum">Question ${idx+1} of ${questions.length}</div>
        <div class="qtext">${item.q}</div>
        <div class="opts"></div>
        <div class="feedback note"></div>
        <div class="quiz-nav">
          <button class="btn secondary prevQ" ${idx===0?'disabled':''}>&larr; Back</button>
          <button class="btn nextQ">${idx===questions.length-1?'Finish':'Next &rarr;'}</button>
        </div>
      `;
      const optsWrap = card.querySelector('.opts');
      item.opts.forEach((optText, oIdx)=>{
        const b = document.createElement('button');
        b.className='opt';
        b.textContent = optText;
        b.addEventListener('click', ()=>selectAnswer(idx,oIdx));
        optsWrap.appendChild(b);
      });
      card.querySelector('.prevQ').addEventListener('click', ()=>goTo(idx-1));
      card.querySelector('.nextQ').addEventListener('click', ()=>{
        if(idx===questions.length-1){ showSummary(); } else { goTo(idx+1); }
      });
      quizHost.appendChild(card);
    });
    updateProgress();
  }
  function goTo(i){
    qIdx=i;
    quizHost.querySelectorAll('.qcard').forEach(c=>c.classList.toggle('show', parseInt(c.dataset.idx,10)===i));
    updateProgress();
  }
  function updateProgress(){
    progPill.textContent = `Question ${qIdx+1} of ${questions.length}`;
    scorePill.textContent = `Score: ${score} / ${answered.filter(Boolean).length}`;
  }
  function selectAnswer(idx, oIdx){
    if(answered[idx]!==undefined) return;
    answered[idx]=true;
    const item = questions[idx];
    const card = quizHost.querySelector(`.qcard[data-idx="${idx}"]`);
    card.querySelectorAll('.opt').forEach((b,i)=>{
      b.disabled=true;
      if(i===item.correct) b.classList.add('correct');
      if(i===oIdx && oIdx!==item.correct) b.classList.add('wrong');
    });
    if(oIdx===item.correct) score++;
    const fb = card.querySelector('.feedback');
    fb.classList.add('show', oIdx===item.correct?'go':'stop');
    fb.innerHTML = `<b>${oIdx===item.correct?'Correct':'Not quite'}</b>${item.exp}`;
    updateProgress();
  }
  function showSummary(){
    quizHost.querySelectorAll('.qcard').forEach(c=>c.classList.remove('show'));
    quizSummary.classList.add('show');
    document.getElementById(ids.finalScore).textContent = `${score} / ${questions.length}`;
    const pct = score/questions.length;
    let msg;
    if(pct===1) msg="Every question. You are done with this session.";
    else if(pct>=0.75) msg="Solid. Re-read the stations behind the ones you missed and move on.";
    else if(pct>=0.5) msg="Halfway. Work the interactive stations again before the exam.";
    else msg="Worth another full pass through the stations before the exam.";
    document.getElementById(ids.finalMsg).textContent = msg;
  }
  document.getElementById(ids.retake).addEventListener('click', ()=>{
    score=0; answered=[]; qIdx=0; renderQuiz();
  });
  renderQuiz();
}
"""


def esc(text: str) -> str:
    return html.escape(text, quote=False)


def build(slug, doc_code, title_html, subtitle, instructor, stations, questions, cheat, widget_js):
    """One guide. `stations` is a list of (key, nav_label, section_html); the exam and cheat-sheet
    stations are appended here so every guide carries them in the same place."""
    nav = []
    for i, (key, label, _body) in enumerate(stations):
        nav.append(
            f'<button class="stn{" active" if i == 0 else ""}" data-tab="{key}">'
            f'<span class="lamp"></span><span class="num">{i:02d}</span> {esc(label)}</button>'
        )
    nav.append('<button class="stn" data-tab="quiz"><span class="lamp"></span>EXAM</button>')
    nav.append('<button class="stn" data-tab="cheat"><span class="lamp"></span>Cheat Sheet</button>')

    sections = []
    for i, (key, label, body) in enumerate(stations):
        sections.append(
            f'<section class="tab-panel{" show" if i == 0 else ""}" id="tab-{key}">\n'
            f'  <div class="eyebrow">Station {i:02d}</div>\n{body}\n</section>'
        )

    sections.append(f"""<section class="tab-panel" id="tab-quiz">
  <div class="eyebrow">Exam simulation</div>
  <h2 class="head">Timed-Style MCQ Set</h2>
  <div class="dek">{len(questions)} questions in the format the end-term uses. Pick an answer to see whether it is right and why, then move on.</div>
  <div class="quiz-top">
    <div class="score-pill" id="scorePill">Score: 0 / 0</div>
    <div class="score-pill" id="progPill">Question 1 of {len(questions)}</div>
  </div>
  <div id="quizHost"></div>
  <div class="quiz-summary" id="quizSummary">
    <div style="font-family:var(--font-mono); font-size:12px; text-transform:uppercase; letter-spacing:.1em; color:var(--ink-soft);">Final score</div>
    <div class="big" id="finalScore">0 / {len(questions)}</div>
    <p id="finalMsg" class="lead" style="max-width:480px; margin:8px auto 18px;"></p>
    <button class="btn" id="retakeQuiz">Retake the set</button>
  </div>
</section>""")

    cheat_cards = "".join(
        f'<div class="cheat-card"><h4>{esc(h)}</h4>{b}</div>' for h, b in cheat
    )
    sections.append(f"""<section class="tab-panel" id="tab-cheat">
  <div class="eyebrow">Quick reference</div>
  <h2 class="head">Cheat Sheet</h2>
  <div class="dek">Everything this session can be examined on, compressed to what fits on one screen.</div>
  <div class="cheat-grid">{cheat_cards}</div>
</section>""")

    quiz_js = "const QUESTIONS = [\n" + "".join(
        "  {q:%s,\n   opts:%s, correct:%d,\n   exp:%s},\n"
        % (js_str(q), "[" + ", ".join(js_str(o) for o in opts) + "]", correct, js_str(exp))
        for q, opts, correct, exp in questions
    ) + "];\ninitQuiz(QUESTIONS, {host:'quizHost', scorePill:'scorePill', progPill:'progPill', summary:'quizSummary', finalScore:'finalScore', finalMsg:'finalMsg', retake:'retakeQuiz'});"

    doc = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{esc(strip_tags(title_html))} — Field Manual</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Big+Shoulders+Display:wght@600;700;800&family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
{STYLE}
</style>
</head>
<body>

<header class="masthead">
  <div class="masthead-top">
    <div>
      <div class="doc-code">{esc(doc_code)}</div>
      <h1 class="title">{title_html}</h1>
      <div class="subtitle">{esc(subtitle)}</div>
    </div>
    <div class="stamp">
      INSTRUCTOR: <b>{esc(instructor)}</b><br>
      REV: <b>2026-08</b><br>
      STATIONS: <b>{len(stations) + 2}</b>
    </div>
  </div>
</header>

<main class="panel">
  <nav class="switchboard" id="switchboard">
{chr(10).join("    " + n for n in nav)}
  </nav>

  <div class="sheet">
{chr(10).join(sections)}
  </div>
</main>

<div class="footer-strip">{esc(doc_code)} · BUILT FOR REVISION, NOT FOR PRINT</div>

<script>
{CORE_JS}
{widget_js}
{quiz_js}
</script>
</body>
</html>
"""
    (OUT / f"{slug}.html").write_text(doc)
    return len(doc)


def js_str(s: str) -> str:
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ") + '"'


def strip_tags(s: str) -> str:
    out, depth = [], 0
    for ch in s:
        if ch == "<":
            depth += 1
        elif ch == ">":
            depth -= 1
        elif depth == 0:
            out.append(ch)
    return "".join(out)


# ===========================================================================
# Session 6 — Cost Allocation and Activity-Based Costing
# ===========================================================================

S6_ALLOCATOR = """
<div class="grid2">
  <div>
    <div class="ctrl-block">
      <label>Orders placed by Product B <span class="live" id="s6bOrders">50</span></label>
      <input type="range" min="5" max="80" step="1" value="50" id="s6bOrdersIn">
    </div>
    <div class="ctrl-block">
      <label>Share of overhead that is batch-driven <span class="live" id="s6batchPct">65%</span></label>
      <input type="range" min="0" max="90" step="5" value="65" id="s6batchIn">
    </div>
    <p style="font-size:13.5px; color:var(--ink-soft);">Product A: 15,000 units at $10, direct cost $6, 0.5 labour hours each, 15 orders. Product B: 5,000 units at $14, direct cost $7, 0.6 labour hours each. Overhead is $100,000, and whatever is not batch-driven splits into $5,000 of product-level cost and the rest at unit level.</p>
  </div>
  <div>
    <table class="simple">
      <tr><th></th><th>Product A</th><th>Product B</th></tr>
      <tr><td>Traditional margin</td><td id="s6tradA"></td><td id="s6tradB"></td></tr>
      <tr><td>ABC margin</td><td id="s6abcA"></td><td id="s6abcB"></td></tr>
      <tr><td>Swing per unit</td><td id="s6swingA"></td><td id="s6swingB"></td></tr>
    </table>
    <div class="readout-row" style="margin-top:14px;">
      <div class="readout-card"><div class="val" id="s6batchRate"></div><div class="lbl">per order</div></div>
      <div class="readout-card blue"><div class="val" id="s6tradRate"></div><div class="lbl">traditional rate / LH</div></div>
    </div>
    <div class="note" id="s6verdict"><b>Verdict</b></div>
  </div>
</div>
"""

S6_JS = r"""
(function(){
  const bOrdersIn = document.getElementById('s6bOrdersIn');
  const batchIn = document.getElementById('s6batchIn');
  function render(){
    const bOrders = +bOrdersIn.value, batchPct = +batchIn.value/100;
    document.getElementById('s6bOrders').textContent = bOrders;
    document.getElementById('s6batchPct').textContent = (batchPct*100).toFixed(0)+'%';

    const OH = 100000, aUnits = 15000, bUnits = 5000;
    const aLH = aUnits*0.5, bLH = bUnits*0.6, totLH = aLH + bLH;
    const aOrders = 15, totOrders = aOrders + bOrders;

    const tradRate = OH/totLH;
    const tradA = 10 - 6 - tradRate*0.5;
    const tradB = 14 - 7 - tradRate*0.6;

    const batchPool = OH*batchPct, productPool = 5000;
    const unitPool = Math.max(OH - batchPool - productPool, 0);
    const unitRate = unitPool/totLH, batchRate = batchPool/totOrders;
    const abcAoh = (unitRate*aLH + batchRate*aOrders + productPool/2)/aUnits;
    const abcBoh = (unitRate*bLH + batchRate*bOrders + productPool/2)/bUnits;
    const abcA = 10 - 6 - abcAoh, abcB = 14 - 7 - abcBoh;

    const set = (id,v,dp)=>document.getElementById(id).textContent = money(v, dp===undefined?2:dp);
    set('s6tradA', tradA); set('s6tradB', tradB);
    set('s6abcA', abcA);   set('s6abcB', abcB);
    set('s6swingA', abcA-tradA); set('s6swingB', abcB-tradB);
    document.getElementById('s6batchRate').textContent = money(batchRate, 0);
    document.getElementById('s6tradRate').textContent = money(tradRate, 2);

    const flipped = (tradA<0) !== (abcA<0) || (tradB<0) !== (abcB<0);
    document.getElementById('s6verdict').innerHTML = '<b>Verdict</b>' + (
      flipped
        ? 'The two systems disagree about which product is losing money. Whichever one the firm believes decides which product gets dropped.'
        : (Math.abs(batchPct)<0.01
            ? 'With no batch-driven overhead, ABC and the labour-hour rate agree almost exactly. Diversity in batch consumption is what creates the distortion.'
            : 'Both systems rank the products the same way here, but the margins differ. Drag B’s order count up and watch the ranking break.')
    );
  }
  bOrdersIn.addEventListener('input', render);
  batchIn.addEventListener('input', render);
  render();
})();
"""

S6_STATIONS = [
    ("relevant", "Which Cost Matters", """
  <h2 class="head">Which Cost <span style="color:var(--stop-red)">Matters</span></h2>
  <div class="dek">The session opens on something deliberately small — a copying machine — because it makes one point that runs through the whole of Prof. Dutta's half: the right cost number depends on the decision.</div>

  <h3 class="sub">The facts</h3>
  <ul class="tidy">
    <li>Copier costs $4,000 and lasts four years, so $1,000 a year</li>
    <li>Ink cartridge costs $400 and lasts 40,000 pages, so $0.01 a page</li>
    <li>Paper costs $0.01 a page</li>
    <li>Wages and benefits $10,000 a year; other overhead $1,000 a year</li>
    <li>Volume 600,000 pages a year</li>
  </ul>

  <div class="grid2">
    <div>
      <h3 class="sub">Two answers, both right</h3>
      <div class="formula-box">Variable cost = $0.01 + $0.01 = $0.02 per page</div>
      <div class="formula-box">Full cost = $0.02 + $12,000 / 600,000 = $0.04 per page</div>
      <p>The $12,000 is depreciation plus wages plus other overhead. Neither number is an estimate of the other; they answer different questions.</p>
    </div>
    <div>
      <table class="simple">
        <tr><th>Decision</th><th>Relevant cost</th></tr>
        <tr><td>One more page</td><td>$0.02</td></tr>
        <tr><td>One-off 10,000-page order into spare capacity</td><td>$0.02</td></tr>
        <tr><td>Should we run this function at all?</td><td>$0.04</td></tr>
        <tr><td>Outsource for five years at $0.03?</td><td>$0.04 &mdash; so yes, outsource</td></tr>
      </table>
    </div>
  </div>

  <div class="note go"><b>The rule</b>Short run, capacity already in place &rarr; variable cost. Long run, capacity itself is a choice &rarr; full cost including capacity.</div>
  <div class="note stop"><b>Trap</b>The distinction is not one-off versus repeat. It is whether the commitment puts capacity back in play. A standing order for a third of the machine's annual volume, for five years, is a long-run decision even though each page is still just a page.</div>
"""),
    ("distortion", "The Distortion", """
  <h2 class="head">Something Is Wrong &mdash; But <span style="color:var(--stop-red)">What?</span></h2>
  <div class="dek">Two products share a plant and $100,000 of overhead. The business loses $5,000. The cost system names a culprit, and it names the wrong one.</div>

  <table class="simple">
    <tr><th></th><th>Product A</th><th>Product B</th><th>Total</th></tr>
    <tr><td>Price</td><td>$10</td><td>$14</td><td></td></tr>
    <tr><td>Units sold</td><td>15,000</td><td>5,000</td><td>20,000</td></tr>
    <tr><td>Revenue</td><td>$150,000</td><td>$70,000</td><td>$220,000</td></tr>
    <tr><td>Direct cost per unit</td><td>$6</td><td>$7</td><td>$125,000</td></tr>
    <tr><td>Labour hours per unit</td><td>0.5</td><td>0.6</td><td>10,500 LH</td></tr>
    <tr><td>Orders placed</td><td>15</td><td>50</td><td>65</td></tr>
    <tr><td>Overhead</td><td>?</td><td>?</td><td>$100,000</td></tr>
    <tr><td>Gross profit</td><td>?</td><td>?</td><td>&minus;$5,000</td></tr>
  </table>

  <h3 class="sub">What a single labour-hour rate says</h3>
  <div class="formula-box">Rate = $100,000 &divide; 10,500 LH = $9.52 per labour hour</div>
  <table class="simple">
    <tr><th></th><th>Product A</th><th>Product B</th></tr>
    <tr><td>Direct cost</td><td>$6.00</td><td>$7.00</td></tr>
    <tr><td>Allocated overhead</td><td>$4.76</td><td>$5.71</td></tr>
    <tr><td>Unit cost</td><td>$10.76</td><td>$12.71</td></tr>
    <tr><td>Gross margin</td><td style="color:var(--stop-red)">&minus;$0.76</td><td style="color:var(--go-green)">$1.29</td></tr>
  </table>
  <div class="note stop"><b>The verdict it produces</b>Drop Product A; it is losing money. Station 03 shows that A is in fact earning $1.40 a unit and B is losing $5.21.</div>

  <h3 class="sub">Where the rate cannot see</h3>
  <p>Product B is 25% of the volume and places 50 of the 65 orders. Overhead in this business is largely triggered by how many separate times somebody has to schedule a run, process an order and ship it. A labour-hour rate has no way to represent order count at all.</p>
  <div class="note"><b>Complexity, not volume</b>Order processing, production scheduling, shipping paperwork, design changes, special tooling, quality testing, custom specifications, customer support and returns. None of these scale with units.</div>
"""),
    ("hierarchy", "The Cost Hierarchy", """
  <h2 class="head">The Cost <span style="color:var(--amber)">Hierarchy</span></h2>
  <div class="dek">Four levels, sorted by what actually makes a cost happen one more time. This is the most reliably examined idea in the session.</div>

  <table class="errtable">
    <tr><th>Level</th><th>Happens once per&hellip;</th><th>Typical costs</th><th>Driver</th></tr>
    <tr><td><b>Unit</b></td><td>unit produced</td><td>Energy, machining, consumables</td><td>Units, machine hours, labour hours</td></tr>
    <tr><td><b>Batch</b></td><td>run, order or shipment</td><td>Machine setup, scheduling, order processing, shipping</td><td>Number of setups, orders, shipments</td></tr>
    <tr><td><b>Product</b></td><td>product line kept alive</td><td>Design specs and updates, product-specific tooling</td><td>Number of products, often split equally</td></tr>
    <tr><td><b>Facility</b></td><td>year in business</td><td>Rent, plant insurance, general administration</td><td>None &mdash; usually left unallocated</td></tr>
  </table>

  <h3 class="sub">How to classify anything</h3>
  <p class="lead">Ask what has to happen one more time for the cost to be incurred again. One more unit, one more run, one more product line, or one more year in business.</p>
  <div class="note"><b>Worked</b>A furniture maker re-programs its CNC machines at the start of every production run of a chair model. A run of ten and a run of a thousand each need it once, so the trigger is the run: <b>batch level</b>. Designing the chair model itself would be product level, because it happens once for the model however many runs follow.</div>
  <div class="note violet"><b>Why it matters</b>Low-volume products consume batch- and product-level resources out of all proportion to their volume. A specialty product made in fifty small runs consumes fifty setups; a commodity product made in five large runs consumes five. A volume-based rate charges them by units and gets it exactly backwards.</div>
  <div class="note go"><b>Facility level</b>Left unallocated for decision-making, because no driver reflects causation and no product manager controls them. Allocating them anyway loads every product with an arbitrary charge that can flip a ranking without carrying information.</div>
"""),
    ("abc", "ABC Rebuilt", """
  <h2 class="head">ABC <span style="color:var(--go-green)">Rebuilt</span></h2>
  <div class="dek">Products do not consume resources. They consume activities, and activities consume resources. So the assignment runs in two stages.</div>

  <h3 class="sub">Three steps</h3>
  <ul class="tidy">
    <li><b>Identify activities</b> &mdash; what work actually gets done</li>
    <li><b>Trace cost to activities</b> &mdash; a separate pool per activity, not one bucket</li>
    <li><b>Assign pools to cost objects</b> &mdash; by a driver that causally moves the pool</li>
  </ul>
  <div class="formula-box">Activity rate = pool &divide; total driver units &nbsp;&nbsp;|&nbsp;&nbsp; Assigned = &Sigma; (rate &times; units consumed)</div>

  <h3 class="sub">The same two products, reallocated</h3>
  <p>Unit level $30,000 driven by labour hours; batch level $65,000 driven by orders; product level $5,000 split equally. Drag the sliders to see what makes the ranking flip.</p>
"""
     + S6_ALLOCATOR + """
  <div class="note stop"><b>Trap</b>Total overhead never changes. ABC reassigns the same $100,000 &mdash; it does not find money. What changes is which product looks profitable, and therefore which decisions get made.</div>
  <div class="note go"><b>The baseline answer</b>At 50 orders and a 65% batch share: A earns $1.40 a unit and B loses $5.21. B's fifty small orders consume $50,000 of batch cost against A's fifteen large orders at $15,000.</div>
"""),
    ("subsidy", "Cross-Subsidy", """
  <h2 class="head">The Cross-Subsidy <span style="color:var(--stop-red)">Problem</span></h2>
  <div class="dek">Under a volume-based system, high-volume standard products are overcosted and low-volume custom products are undercosted. Two names for the same error, and both are dangerous.</div>

  <div class="grid2">
    <div>
      <h3 class="sub">Overcosted</h3>
      <p>High volume, standard, large routine orders. They appear <b>less</b> profitable than they are.</p>
      <div class="note stop"><b>Risk</b>Managers cut or over-price the product that is actually subsidising the rest.</div>
    </div>
    <div>
      <h3 class="sub">Undercosted</h3>
      <p>Low volume, custom, small special orders. They appear <b>more</b> profitable than they are.</p>
      <div class="note stop"><b>Risk</b>Unprofitable products and customers proliferate.</div>
    </div>
  </div>

  <h3 class="sub">Greg's lawns</h3>
  <p class="lead">Greg charges every customer the same price to mow a lawn. That is a volume-based allocation in disguise: it assumes every lawn takes the same work, when size, terrain and landscaping vary the time enormously.</p>
  <ul class="tidy">
    <li>Difficult lawns are underpriced, easy lawns overpriced</li>
    <li>Easy-lawn owners get better quotes elsewhere and leave</li>
    <li>Difficult-lawn owners find Greg cheap and arrive</li>
    <li>The mix drifts toward the jobs that take longest, and average cost climbs while the price stays flat</li>
  </ul>
  <div class="note violet"><b>The manufacturing version</b>A firm pricing from volume-based costs watches its mix shift away from easy-to-make high-volume products toward difficult low-volume ones &mdash; one rational customer decision at a time.</div>

  <h3 class="sub">The death spiral</h3>
  <p>Drop the overcosted high-volume product and most of the allocation base leaves while the overhead largely stays. The rate rises, the remaining product's reported cost rises with it, and it starts to look unprofitable too.</p>
  <div class="note stop"><b>Strategic danger</b>Companies accumulate unprofitable products and customers while believing they are growing. Revenue rises, margins erode, and the cost system reports nothing wrong &mdash; because it was never measuring the thing that changed.</div>
"""),
    ("build", "When to Build It", """
  <h2 class="head">When ABC Is <span style="color:var(--amber)">Worth It</span></h2>
  <div class="dek">ABC produces better numbers and costs real money to build and maintain. The judgement is about where the gain justifies the cost.</div>

  <div class="grid2">
    <div>
      <h3 class="sub">Where it pays</h3>
      <ul class="tidy">
        <li>Products or customers differ a lot in volume, batch size or support consumption</li>
        <li>Overhead is large relative to direct cost</li>
        <li>The firm is actively deciding what to keep, drop or reprice</li>
        <li>Service businesses with several customer segments &mdash; a bank, a hospital, a hotel</li>
      </ul>
    </div>
    <div>
      <h3 class="sub">Where it adds little</h3>
      <ul class="tidy">
        <li>A cement plant with one commodity product &mdash; nothing to reallocate</li>
        <li>A single-product contract manufacturer</li>
        <li>Overhead that is a very small share of total cost</li>
      </ul>
      <div class="note"><b>Diversity is the precondition</b>Without it, every allocation method gives the same answer.</div>
    </div>
  </div>

  <h3 class="sub">His implementation guidance, verbatim</h3>
  <ul class="tidy">
    <li>Consider the costs and benefits of incremental precision</li>
    <li>Focus on the low-hanging fruit first</li>
    <li>Do not let the best become the enemy of the good</li>
    <li>Better to be approximately right than grossly wrong</li>
    <li>Start simple and look for scalability</li>
  </ul>

  <h3 class="sub">A caution on the rates</h3>
  <div class="note violet"><b>Long-run average, not short-run incremental</b>An activity rate is the long-run average cost of the capacity an activity consumes. It answers "what does this product line or customer segment cost us" well, and "what happens if ten more customers use a teller tomorrow" badly. In the short run that capacity is already paid for.</div>

  <h3 class="sub">How AI may reshape the hierarchy</h3>
  <div class="app-grid">
    <div class="app-card"><h4>Batch level</h4><p>Automated order intake, scheduling and documents make a small order nearly as cheap to process as a large one.</p></div>
    <div class="app-card"><h4>Product level</h4><p>Generated design variants and automated compliance testing make a wider product range far cheaper to support.</p></div>
    <div class="app-card"><h4>Customer level</h4><p>AI handling inquiries and personalising at scale makes the long tail of small customers viable.</p></div>
    <div class="app-card"><h4>New pools</h4><p>Compute cost, model licensing, hallucination risk, data governance. ABC has to be extended to capture them.</p></div>
  </div>
"""),
]

S6_QUESTIONS = [
    ("A copier's variable cost is two cents a page and its full cost four cents. A one-off order of 10,000 pages arrives and the machine has spare capacity. What is the minimum acceptable price per page?",
     ["Full cost, four cents", "Variable cost, two cents", "Three cents, splitting the difference", "Whatever the outside vendor charges"], 1,
     "Capacity is already in place and already paid for. Only ink and paper change, so anything above two cents adds profit."),
    ("The same copying function can be outsourced for five years at three cents a page. Should it be?",
     ["No, because three cents exceeds the two-cent variable cost", "Yes, because over five years capacity costs are avoidable too, so the comparison is four cents against three", "No, because the copier's depreciation is sunk", "Only if the copier can be sold"], 1,
     "A five-year commitment puts the machine, the wages and the overhead in play. All four cents become avoidable."),
    ("Total overhead is $100,000, total labour hours are 10,500. What is the traditional plantwide rate?",
     ["$9.52 per labour hour", "$5.00 per labour hour", "$10.00 per labour hour", "$4.76 per labour hour"], 0,
     "100,000 divided by 10,500 hours. The $4.76 distractor is Product A's overhead per unit, which is the rate times its 0.5 hours."),
    ("A firm re-programs a CNC machine at the start of every production run. That cost is:",
     ["Unit level", "Batch level", "Product level", "Facility level"], 1,
     "The trigger is starting a run, not making a unit and not keeping the model in the catalogue. Designing the model would be product level."),
    ("Under ABC with a batch rate of $1,000 per order, Product B's 50 orders are consolidated into 10. How much batch cost does B shed?",
     ["$8,000", "$40,000", "$50,000", "Nothing, because batch costs are fixed"], 1,
     "50 orders cost $50,000, 10 cost $10,000. The reduction is $40,000, which is most of the $5.21 per unit loss."),
    ("Under a volume-based system, a low-volume specialty product is:",
     ["Overcosted", "Undercosted", "Costed accurately", "Cannot be determined"], 1,
     "It consumes batch- and product-level resources out of proportion to volume, and a unit-based rate cannot see that. It is undercosted, and the high-volume product is overcosted by the same amount."),
    ("What happens to total overhead when a firm switches from a plantwide rate to activity-based costing?",
     ["It falls, because ABC identifies waste", "It rises, because more pools capture more cost", "It is unchanged; only the split between products moves", "It depends on the drivers chosen"], 2,
     "Allocation divides a pool; it does not change its size. What changes is which product carries which share, and therefore which decisions get made."),
    ("Which company would benefit least from implementing ABC?",
     ["A job shop making hundreds of custom orders", "A bank serving several customer segments", "A cement plant producing a single commodity product", "An electronics firm with high- and low-volume lines"], 2,
     "ABC corrects distortions caused by diversity. With one product every allocation method assigns 100% of overhead to the same place."),
    ("A firm drops the high-volume product that a volume-based system reported as unprofitable. What happens to the remaining product's reported cost?",
     ["It falls, because total overhead falls with the dropped product", "It rises, because the same overhead is spread over a smaller base", "It is unchanged", "It falls, because the remaining product uses fewer hours"], 1,
     "Most of the base leaves and most of the overhead stays, so the rate rises. That is the death spiral, and it can trigger another cut."),
    ("Facility-level costs are usually left unallocated for decision-making because:",
     ["They are immaterial", "Accounting standards prohibit allocating them", "No driver reflects causation, so allocating them changes rankings without carrying information", "They are variable and belong in contribution margin"], 2,
     "Rent, insurance and general administration are consumed by being in business. Any driver is a convention, and the charge can flip a product's apparent profitability as a function of that convention."),
    ("Pema's overhead is $390,000 and her total labour cost is $325,000. A deluxe print carries $75 of labour. How much overhead does one deluxe print absorb?",
     ["$75", "$90", "$60", "$120"], 1,
     "Rate is 390,000 / 325,000 = $1.20 per labour dollar, so 75 x 1.20 = $90. The activity-based rebuild reverses the apparent profitability of the deluxe line."),
    ("An ABC rate of $6.00 per teller transaction is used to forecast the cost of 5,000 extra transactions next month. What is the problem?",
     ["The rate should be higher", "The rate is a long-run average capacity cost, so it overstates the short-run incremental cost", "The rate was computed from the wrong pool", "There is no problem"], 1,
     "The pool is salaries and depreciation, both committed. Extra transactions absorbed by staff already scheduled cost very little in the month they happen."),
]

S6_CHEAT = [
    ("Which cost is relevant", "<ul><li>Short run, capacity in place &rarr; variable cost</li><li>Long run, capacity is a choice &rarr; full cost</li></ul><div class='f'>Full cost = VC + FC / units</div>"),
    ("Traditional allocation", "<div class='f'>Rate = total overhead &divide; total base units</div><ul><li>Base is a volume measure: LH, MH, labour $, units</li><li>Assumes overhead is proportional to that base</li></ul>"),
    ("ABC", "<div class='f'>Activity rate = pool &divide; driver units</div><div class='f'>Assigned = &Sigma; (rate &times; units consumed)</div><ul><li>Resources &rarr; activities &rarr; cost objects</li></ul>"),
    ("The four levels", "<ul><li><b>Unit</b> &mdash; per unit</li><li><b>Batch</b> &mdash; per run, order, shipment</li><li><b>Product</b> &mdash; per product line</li><li><b>Facility</b> &mdash; per year in business</li></ul>"),
    ("Cross-subsidy", "<ul><li>High volume, standard &rarr; <b>overcosted</b></li><li>Low volume, custom &rarr; <b>undercosted</b></li><li>Mix drifts toward the complex work</li></ul>"),
    ("Worked numbers to know", "<ul><li>Traditional rate $9.52/LH &rarr; A &minus;$0.76, B $1.29</li><li>ABC &rarr; A $1.40, B &minus;$5.21</li><li>Batch rate $1,000/order; B's 50 orders = $50,000</li></ul>"),
    ("When ABC pays", "<ul><li>Diverse volumes and batch sizes</li><li>Large overhead share</li><li>Service firms with segments</li><li>Not: single-product commodity plants</li></ul>"),
    ("His guidance", "<ul><li>Weigh incremental precision against its cost</li><li>Low-hanging fruit first</li><li>Approximately right beats grossly wrong</li><li>Start simple, look for scalability</li></ul>"),
]


# ===========================================================================
# Session 7 — ABM, customer profitability, control and budgeting
# ===========================================================================

S7_COST_TO_SERVE = """
<div class="grid2">
  <div>
    <div class="ctrl-block">
      <label>Orders placed per year <span class="live" id="s7ordersL">50</span></label>
      <input type="range" min="5" max="300" step="5" value="50" id="s7orders">
    </div>
    <div class="ctrl-block">
      <label>Deliveries taken per year <span class="live" id="s7delsL">40</span></label>
      <input type="range" min="5" max="200" step="5" value="40" id="s7dels">
    </div>
    <div class="ctrl-block">
      <label>Contribution margin ratio <span class="live" id="s7cmrL">25%</span></label>
      <input type="range" min="5" max="45" step="1" value="25" id="s7cmr">
    </div>
    <p style="font-size:13.5px; color:var(--ink-soft);">Annual sales fixed at $400,000. Order processing costs $450 each, a delivery $100, and volume-related cost runs at 27 cents per sales dollar.</p>
  </div>
  <div>
    <div class="readout-row">
      <div class="readout-card blue"><div class="val" id="s7cm"></div><div class="lbl">contribution margin</div></div>
      <div class="readout-card"><div class="val" id="s7cts"></div><div class="lbl">cost to serve</div></div>
    </div>
    <div class="readout-row">
      <div class="readout-card green"><div class="val" id="s7profit"></div><div class="lbl">customer profit</div></div>
    </div>
    <div class="note" id="s7note"><b>Reading</b></div>
  </div>
</div>
"""

S7_JS = r"""
(function(){
  const ids = ['s7orders','s7dels','s7cmr'].map(i=>document.getElementById(i));
  function render(){
    const orders=+ids[0].value, dels=+ids[1].value, cmr=+ids[2].value/100;
    document.getElementById('s7ordersL').textContent = orders;
    document.getElementById('s7delsL').textContent = dels;
    document.getElementById('s7cmrL').textContent = (cmr*100).toFixed(0)+'%';
    const sales = 400000;
    const cm = sales*cmr;
    const cts = sales*0.27 + orders*450 + dels*100;
    const profit = cm - cts;
    document.getElementById('s7cm').textContent = money(cm);
    document.getElementById('s7cts').textContent = money(cts);
    document.getElementById('s7profit').textContent = money(profit);
    const card = document.getElementById('s7profit').parentElement;
    card.className = 'readout-card ' + (profit>=0 ? 'green' : 'red');
    document.getElementById('s7note').innerHTML = '<b>Reading</b>' + (
      profit < 0
        ? 'This customer destroys value at these settings. Before terminating: can the order count fall, can a minimum-order fee be charged, can the account move to a cheaper channel?'
        : 'Profitable here. Drag the order count up without touching the margin and watch how quickly a good-looking customer stops being one.'
    );
  }
  ids.forEach(i=>i.addEventListener('input', render));
  render();
})();
"""

S7_STATIONS = [
    ("customers", "Not All Customers Are Equal", """
  <h2 class="head">Not All Customers Are <span style="color:var(--amber)">Equal</span></h2>
  <div class="dek">The same ABC logic, pointed at customers instead of products. The result is a whale curve: cumulative profit rises steeply, peaks well above 100%, then falls back as the unprofitable tail eats into it.</div>

  <h3 class="sub">What makes a customer expensive to serve</h3>
  <ul class="tidy">
    <li>Many small orders rather than a few large ones</li>
    <li>Order changes after placement, and expedited deliveries</li>
    <li>Heavy support and inquiry usage</li>
    <li>Custom specifications and returns</li>
    <li>Long payment terms and discounts taken</li>
  </ul>
  <div class="formula-box">Customer profit = revenue &minus; variable cost &minus; &Sigma; (activity rate &times; units consumed)</div>

  <h3 class="sub">Ryan and Wilson</h3>
  <p class="lead">Two construction customers, both buying $400,000. Ryan generates $120,000 of contribution margin against Wilson's $100,000 &mdash; and Wilson is the more profitable customer.</p>
  <table class="simple">
    <tr><th></th><th>Ryan</th><th>Wilson</th></tr>
    <tr><td>Contribution margin</td><td>$120,000</td><td>$100,000</td></tr>
    <tr><td>Volume-related cost</td><td>$108,000</td><td>$108,000</td></tr>
    <tr><td>Orders at $450</td><td>50 &rarr; $22,500</td><td>20 &rarr; $9,000</td></tr>
    <tr><td>Deliveries at $100</td><td>150 &rarr; $15,000</td><td>40 &rarr; $4,000</td></tr>
    <tr><td>Customer profit</td><td style="color:var(--stop-red)">&minus;$25,500</td><td style="color:var(--stop-red)">&minus;$21,000</td></tr>
  </table>
  <div class="note stop"><b>Trap</b>Contribution margin ranks revenue quality. Customer profitability ranks it net of what it cost to earn. A customer can be top of one list and bottom of the other.</div>

  <h3 class="sub">Try it</h3>
""" + S7_COST_TO_SERVE + """
"""),
    ("tail", "The Unprofitable Tail", """
  <h2 class="head">Managing the <span style="color:var(--stop-red)">Tail</span></h2>
  <div class="dek">A quarter of customers generate nearly all the profit and the bottom fifteen per cent destroy a fifth of it. "Fire them" is the answer the numbers seem to shout, and it is rarely the right first move.</div>

  <h3 class="sub">The menu, in the order to try it</h3>
  <ul class="tidy">
    <li><b>Reprice.</b> Service fees, order minimums, menu pricing that charges for the activities the customer consumes. This converts a cost problem into a customer decision.</li>
    <li><b>Change how you serve them.</b> Self-service, digital channels, standard catalogue items. Cost-to-serve falls without the revenue leaving.</li>
    <li><b>Change how they order.</b> Work with them on their ordering pattern, and share how the profitable customer runs purchasing.</li>
    <li><b>Change nothing, and ask what the numbers are missing.</b> Referrals, reference value, a loss-leading product that pulls a profitable one, an account being deliberately developed.</li>
  </ul>

  <div class="note stop"><b>Why firing is the last resort</b>The revenue and contribution leave immediately. Much of the assigned cost is capacity cost that stays &mdash; and it is then spread across fewer customers, which makes the next tranche look unprofitable and invites another cut.</div>
  <div class="note go"><b>Tiering</b>ABC-based customer profitability lets a firm tailor service levels and prices by tier, and answer three questions with evidence: which customers to acquire, which to support and retain, which to let go.</div>

  <h3 class="sub">From costing to managing</h3>
  <p class="lead">Activity-based management is what you do with the visibility. Six questions, in order:</p>
  <table class="errtable">
    <tr><th>#</th><th>Question</th><th>What it buys</th></tr>
    <tr><td>1</td><td>What are our high-cost activities?</td><td>Visibility into where the money goes</td></tr>
    <tr><td>2</td><td>Do they add value for the customer?</td><td>Separates value-add from waste</td></tr>
    <tr><td>3</td><td>Can we eliminate or simplify them?</td><td>Process redesign</td></tr>
    <tr><td>4</td><td>Can we do them more efficiently?</td><td>Continuous improvement</td></tr>
    <tr><td>5</td><td>Should someone else do them?</td><td>Outsourcing and partnerships</td></tr>
    <tr><td>6</td><td>Can technology eliminate them?</td><td>Automation and digital channels</td></tr>
  </table>
  <div class="note violet"><b>Cutting cost vs removing its cause</b>Cutting a department's budget cuts capacity while the demand for the work stays. Removing an activity, or halving how often it is triggered, removes the demand &mdash; which is the only version that holds.</div>
"""),
    ("control", "Decentralisation and Control", """
  <h2 class="head">Decentralisation and <span style="color:var(--blue-line)">Control</span></h2>
  <div class="dek">Decision rights get distributed as firms grow. Everything that follows in this course is a response to what that costs.</div>

  <div class="grid2">
    <div>
      <h3 class="sub">Benefits</h3>
      <ul class="tidy">
        <li>Quicker decisions by people with local expertise</li>
        <li>Better adaptation to local conditions</li>
        <li>Higher morale from empowerment</li>
        <li>Frees top management for strategy</li>
        <li>Develops the future leadership bench</li>
      </ul>
    </div>
    <div>
      <h3 class="sub">Costs</h3>
      <ul class="tidy">
        <li>Coordination failures across units</li>
        <li>Duplication of activities and expertise</li>
        <li>Goal incongruence</li>
        <li>Silo behaviour</li>
      </ul>
    </div>
  </div>

  <h3 class="sub">Management control systems</h3>
  <p class="lead">Processes and structures that keep activity pointed at the firm's goals. The objective is <b>goal congruence</b>: making the choice that is best for the manager also the choice that is best for the firm.</p>
  <ul class="tidy">
    <li><b>Allocation of decision rights</b> &mdash; who decides what</li>
    <li><b>Choice of performance measures</b> &mdash; are the metrics consistent with those rights?</li>
    <li><b>Choice of reward systems</b> &mdash; how measured performance is paid</li>
  </ul>
  <div class="note"><b>Controllability principle</b>To the extent possible, hold employees accountable only for outcomes they control. It is a guideline rather than a law &mdash; almost nothing is entirely within one person's control &mdash; and it is what motivates the flexible budget in Session 8.</div>

  <h3 class="sub">Responsibility centres</h3>
  <table class="errtable">
    <tr><th>Centre</th><th>Decision rights</th><th>Measure</th><th>Example</th></tr>
    <tr><td>Cost</td><td>Controls inputs</td><td>Cost, cost per unit</td><td>Amazon warehouse</td></tr>
    <tr><td>Revenue</td><td>Pricing and sales</td><td>Revenue, bookings</td><td>Salesforce regional office</td></tr>
    <tr><td>Profit</td><td>Cost, pricing and sales</td><td>Divisional profit &mdash; a P&amp;L</td><td>Apple's iPhone division</td></tr>
    <tr><td>Investment</td><td>All of the above plus capex</td><td>ROI &mdash; a P&amp;L and a balance sheet</td><td>GE Aviation</td></tr>
  </table>
  <div class="note stop"><b>Trap</b>A university's executive-education arm sets its own fees, hires its own staff and picks its own programmes, while buildings and IT are provided centrally. It is a <b>profit centre</b>, not an investment centre &mdash; it does not control the asset base it would be measured on.</div>
"""),
    ("budget", "Building the Budget", """
  <h2 class="head">Building the <span style="color:var(--amber)">Budget</span></h2>
  <div class="dek">A quantified plan that allocates resources and sets expectations. It is three things at once, and that overlap causes everything in the next station.</div>

  <div class="grid2">
    <div>
      <h3 class="sub">Three things at once</h3>
      <ul class="tidy">
        <li>A <b>forecast</b> &mdash; the best guess of what will happen</li>
        <li>A <b>contract</b> &mdash; the resources committed</li>
        <li>A <b>target</b> &mdash; the number you are judged against</li>
      </ul>
    </div>
    <div>
      <h3 class="sub">Three roles</h3>
      <ul class="tidy">
        <li><b>Planning</b> &mdash; decide what to do, commit resources</li>
        <li><b>Coordination</b> &mdash; align functions, communicate expectations</li>
        <li><b>Performance evaluation</b> &mdash; hold managers to the plan</li>
      </ul>
    </div>
  </div>
  <div class="note violet"><b>The tension</b>A good forecast and a tough target are rarely the same number.</div>

  <h3 class="sub">The build order</h3>
  <ul class="tidy">
    <li><b>Revenue budget</b> &mdash; by customer, region and product. Triangulate: local knowledge, macro and industry trends, market research. Every downstream number inherits its error.</li>
    <li><b>Production budget</b> &mdash; the inventory equation, in units</li>
    <li><b>Input budgets</b> &mdash; materials from the bill of materials, labour from the routing sheet, overhead from the cost of capacity</li>
    <li><b>COGM then COGS</b> &mdash; the inventory equation again, in money</li>
    <li><b>Period costs</b> &mdash; selling and admin flow straight to the income statement</li>
    <li><b>Budgeted income statement</b>, then taxes</li>
  </ul>

  <div class="formula-box">Production = sales + ending inventory &minus; beginning inventory</div>
  <div class="formula-box">Purchases = production &times; input per unit + ending RM &minus; beginning RM</div>
  <div class="formula-box">COGS = beginning FG + COGM &minus; ending FG</div>

  <div class="note go"><b>Worked</b>BuildIT: 8,000 lots to sell, 90 wanted at the end, 75 on hand &rarr; 8,015 to produce. Producing 15 more than are sold means inventory rises, so variable COGS comes in <b>lower</b> than variable COGM.</div>
  <div class="note"><b>Meridian, from the practice final</b>Sales 20,000, opening FG 1,500, closing FG 2,500 &rarr; production 21,000. At 2 kg each that is 42,000 kg. Opening RM 2,000, closing RM 5,000 &rarr; purchases 45,000 kg. At $4 a kg, <b>$180,000</b>. The equation runs twice.</div>

  <h3 class="sub">The cash budget</h3>
  <div class="formula-box">Ending cash = opening cash + collections &minus; payments</div>
  <p>Collections split the current period's sales from prior periods' receivables by the stated pattern; payments do the same for purchases. A profitable month can still need a loan.</p>
"""),
    ("games", "Games People Play", """
  <h2 class="head">The Games People <span style="color:var(--stop-red)">Play</span></h2>
  <div class="dek">The moment a budget is used to evaluate people, behaviour changes &mdash; because the same number now sets pay, status and next year's resources.</div>

  <h3 class="sub">The ratchet effect</h3>
  <p class="lead">Most firms anchor next year's target on this year's actual. Beat your target and next year's is harder. So managers learn not to look too good, and there is a ceiling on how much anyone will over-deliver.</p>

  <h3 class="sub">Participative budgeting: cure or cause?</h3>
  <div class="grid2">
    <div><div class="note go"><b>Benefits</b>Taps local knowledge, builds buy-in and commitment.</div></div>
    <div><div class="note stop"><b>Costs</b>Information asymmetry invites misrepresentation. The people closest to the numbers also benefit from shading them.</div></div>
  </div>
  <p>Most firms land on a mix of top-down and bottom-up, with goals set &ldquo;tight but attainable&rdquo;.</p>

  <h3 class="sub">The four games</h3>
  <table class="errtable">
    <tr><th>Game</th><th>What is shaded</th><th>When it happens</th></tr>
    <tr><td><b>Sandbagging</b></td><td>The output or revenue target</td><td>When the target is negotiated</td></tr>
    <tr><td><b>Padding</b></td><td>The resources requested</td><td>When the budget is built</td></tr>
    <tr><td><b>Spending to avoid lapsing</b></td><td>Nothing &mdash; unspent budget gets used</td><td>End of the financial year</td></tr>
    <tr><td><b>Timing games</b></td><td>Which period a transaction lands in</td><td>Around the period boundary</td></tr>
  </table>
  <div class="note violet"><b>His framing</b>These are rational responses to how the budget is used, not bad apples. The fix is in the system, not in the individuals.</div>

  <h3 class="sub">Design exercise: pay for accuracy?</h3>
  <p>Scrap budget-attainment bonuses and pay managers for forecast accuracy instead.</p>
  <div class="grid2">
    <div><div class="note go"><b>What it buys</b>Honest numbers. No reason to sandbag or pad, because a low forecast is now one you have to hit exactly rather than a target you want to beat.</div></div>
    <div><div class="note stop"><b>What it loses</b>Any reason to stretch. And a manager heading for 110 against a forecast of 100 now has a reason to slow down.</div></div>
  </div>
"""),
]

S7_QUESTIONS = [
    ("Two customers each buy $400,000. Ryan generates $120,000 of contribution margin on 50 orders and 150 deliveries; Wilson generates $100,000 on 20 orders and 40 deliveries. Orders cost $450 and deliveries $100. Who is more profitable?",
     ["Ryan, because the contribution margin is higher", "Wilson, despite the lower contribution margin", "They are identical", "Cannot tell without payment terms"], 1,
     "Ryan: 120,000 − 108,000 − 22,500 − 15,000 = −$25,500. Wilson: 100,000 − 108,000 − 9,000 − 4,000 = −$21,000. Cost-to-serve reverses the margin ranking."),
    ("Which customer characteristic most reliably signals high cost-to-serve?",
     ["A low contribution margin ratio", "Many small orders rather than a few large ones", "A long relationship with the firm", "Purchasing across many product lines"], 1,
     "Order count is the customer-level version of batch size. Each order triggers processing, scheduling, picking, shipping and invoicing regardless of size."),
    ("An ABC study shows the bottom 15% of customers destroy a fifth of profit. What is the weakest reason to terminate them?",
     ["The reported loss per customer is large", "Their ordering behaviour cannot be changed", "They occupy capacity profitable customers are waiting for", "Their revenue is small and shrinking"], 0,
     "The reported loss is a trigger for investigation. Much of the assigned cost is capacity cost that does not leave with the customer."),
    ("A firm shifts small accounts to a self-service portal. In ABC terms, what has changed?",
     ["The activity rate", "The driver quantity", "The cost pool, immediately", "The cost object"], 1,
     "Self-service does not make a call cheaper; it means fewer calls happen. Whether the pool falls depends on whether the freed capacity is released."),
    ("Which is a cost of decentralisation rather than a benefit?",
     ["Quicker local decisions", "Duplication of activities and expertise", "Better adaptation to local conditions", "Development of a talent pool"], 1,
     "Every unit that builds its own version of a shared function pays for the same expertise repeatedly. The other three are benefits."),
    ("What are the three components of a management control system?",
     ["Planning, coordination and evaluation", "Allocation of decision rights, choice of performance measures, choice of reward systems", "Budgeting, variance analysis and transfer pricing", "Cost, profit and investment centres"], 1,
     "Who decides, how that is measured, how it is rewarded. Planning, coordination and evaluation are the three roles of a budget, which is a different list."),
    ("A university's executive-education arm sets its own fees, hires its own staff and chooses its programmes; buildings and IT are provided centrally. It is a:",
     ["Cost centre", "Revenue centre", "Profit centre", "Investment centre"], 2,
     "It controls revenue and cost, so it is responsible for a P&L. It does not control the asset base, so it cannot fairly be measured on ROI."),
    ("Which responsibility centre has the greatest autonomy?",
     ["Cost centre", "Revenue centre", "Profit centre", "Investment centre"], 3,
     "Autonomy accumulates through the four forms, and the investment centre adds authority over capital expenditure on top of everything a profit centre has."),
    ("A company budgets to produce 8,015 lots and sell 8,000. Compared with variable COGM, variable COGS will be:",
     ["Higher", "Lower", "The same", "Cannot tell"], 1,
     "Finished-goods inventory rises by 15 lots, so that cost stays on the balance sheet. COGS = beginning FG + COGM − ending FG."),
    ("Sales are 20,000 units, opening FG 1,500 and closing FG 2,500. Each unit needs 2 kg of resin at $4. Opening resin is 2,000 kg and closing 5,000 kg. What is the budgeted cost of purchases?",
     ["$168,000", "$172,000", "$180,000", "$156,000"], 2,
     "Production 21,000 units → 42,000 kg needed → purchases 42,000 + 5,000 − 2,000 = 45,000 kg → $180,000. The inventory equation runs twice."),
    ("A manager negotiates a cost budget she privately believes is 10% higher than she needs. This is:",
     ["The ratchet effect", "Padding, exploiting her information advantage in a participative process", "A timing game", "Spending to avoid lapsing"], 1,
     "Padding inflates the resources requested. It works because she knows what the division really needs and headquarters does not."),
    ("A department books courses in the last three weeks of the year to use up an unspent training budget. This is:",
     ["Spending to avoid lapsing", "Sandbagging", "A timing game", "The ratchet effect"], 0,
     "Use it or lose it. Next year's allocation is anchored on this year's spending, so handing money back is expensive."),
]

S7_CHEAT = [
    ("Customer profit", "<div class='f'>Revenue &minus; VC &minus; &Sigma;(rate &times; units)</div><ul><li>Drivers: orders, deliveries, visits, changes, expedites, returns, support calls</li></ul>"),
    ("The tail, in order", "<ul><li>Reprice &mdash; fees, minimums, menu pricing</li><li>Re-channel &mdash; self-service, digital</li><li>Change their ordering pattern</li><li>Ask what the numbers miss</li><li>Terminate last</li></ul>"),
    ("ABM's six questions", "<ul><li>High-cost activities?</li><li>Value-adding?</li><li>Eliminate or simplify?</li><li>More efficient?</li><li>Someone else?</li><li>Technology?</li></ul>"),
    ("Decentralisation", "<ul><li>Benefits: speed, local fit, morale, HQ focus, talent</li><li>Costs: coordination, duplication, goal incongruence, silos</li></ul>"),
    ("Control system", "<ul><li>Decision rights</li><li>Performance measures</li><li>Reward systems</li></ul><div class='f'>Objective: goal congruence</div>"),
    ("Responsibility centres", "<ul><li>Cost &rarr; inputs</li><li>Revenue &rarr; price and sales</li><li>Profit &rarr; a P&amp;L</li><li>Investment &rarr; a P&amp;L and a balance sheet</li></ul>"),
    ("Budget", "<ul><li>Forecast, contract, target</li><li>Roles: planning, coordination, evaluation</li></ul><div class='f'>Production = sales + end &minus; begin</div><div class='f'>COGS = begin FG + COGM &minus; end FG</div>"),
    ("The games", "<ul><li><b>Sandbagging</b> &mdash; low-ball the target</li><li><b>Padding</b> &mdash; inflate the request</li><li><b>Lapsing</b> &mdash; use it or lose it</li><li><b>Timing</b> &mdash; move it across the line</li><li><b>Ratchet</b> &mdash; HQ raises the target</li></ul>"),
]


# ===========================================================================
# Session 8 — Variance analysis and Buckeye
# ===========================================================================

S8_SPLITTER = """
<div class="grid2">
  <div>
    <div class="ctrl-block">
      <label>Units actually sold <span class="live" id="s8unitsL">8,000</span></label>
      <input type="range" min="5000" max="13000" step="250" value="8000" id="s8units">
    </div>
    <div class="ctrl-block">
      <label>Actual selling price <span class="live" id="s8priceL">$11.00</span></label>
      <input type="range" min="900" max="1400" step="10" value="1100" id="s8price">
    </div>
    <div class="ctrl-block">
      <label>Actual labour hours used <span class="live" id="s8hoursL">4,400</span></label>
      <input type="range" min="2000" max="6500" step="50" value="4400" id="s8hours">
    </div>
    <div class="ctrl-block">
      <label>Actual labour cost <span class="live" id="s8labcostL">$34,000</span></label>
      <input type="range" min="20000" max="60000" step="500" value="34000" id="s8labcost">
    </div>
    <p style="font-size:13.5px; color:var(--ink-soft);">Budget: 10,000 units at $12, labour 0.4 hours at $10, material 0.5 kg at $6, variable overhead $1.25 per labour hour, fixed overhead $14,000. Material, variable overhead and fixed cost are held at the class values.</p>
  </div>
  <div>
    <table class="simple">
      <tr><th></th><th>Static</th><th>Flexible</th><th>Actual</th></tr>
      <tr><td>Units</td><td>10,000</td><td id="s8fu"></td><td id="s8au"></td></tr>
      <tr><td>Revenue</td><td>$120,000</td><td id="s8fr"></td><td id="s8ar"></td></tr>
      <tr><td>Labour</td><td>$40,000</td><td id="s8fl"></td><td id="s8al"></td></tr>
      <tr><td>Profit</td><td>$31,000</td><td id="s8fp"></td><td id="s8ap"></td></tr>
    </table>
    <div class="readout-row" style="margin-top:14px;">
      <div class="readout-card"><div class="val" id="s8vol"></div><div class="lbl">sales volume var.</div></div>
      <div class="readout-card blue"><div class="val" id="s8flex"></div><div class="lbl">flexible budget var.</div></div>
    </div>
    <div class="readout-row">
      <div class="readout-card violet"><div class="val" id="s8sp"></div><div class="lbl">sales price var.</div></div>
      <div class="readout-card"><div class="val" id="s8lq"></div><div class="lbl">labour quantity</div></div>
      <div class="readout-card"><div class="val" id="s8lp"></div><div class="lbl">labour price</div></div>
    </div>
    <div class="note" id="s8note"><b>Reading</b></div>
  </div>
</div>
"""

S8_JS = r"""
(function(){
  const ids = ['s8units','s8price','s8hours','s8labcost'].map(i=>document.getElementById(i));
  function render(){
    const units=+ids[0].value, price=+ids[1].value/100, hours=+ids[2].value, labcost=+ids[3].value;
    document.getElementById('s8unitsL').textContent = units.toLocaleString('en-US');
    document.getElementById('s8priceL').textContent = money(price,2);
    document.getElementById('s8hoursL').textContent = hours.toLocaleString('en-US');
    document.getElementById('s8labcostL').textContent = money(labcost);

    // Static budget
    const staticProfit = 31000;
    // Flexible budget at actual units
    const fRev = units*12, fLab = units*0.4*10, fMat = units*0.5*6, fVoh = units*0.4*1.25;
    const fProfit = fRev - fLab - fMat - fVoh - 14000;
    // Actual: material, variable OH and fixed held at the class values
    const aRev = units*price, aMat = 25500, aVoh = 3800, aFix = 15100;
    const aProfit = aRev - labcost - aMat - aVoh - aFix;

    const set=(id,v,dp)=>document.getElementById(id).textContent = money(v, dp||0);
    document.getElementById('s8fu').textContent = units.toLocaleString('en-US');
    document.getElementById('s8au').textContent = units.toLocaleString('en-US');
    set('s8fr', fRev); set('s8ar', aRev);
    set('s8fl', fLab); set('s8al', labcost);
    set('s8fp', fProfit); set('s8ap', aProfit);

    const vol = fProfit - staticProfit, flex = aProfit - fProfit;
    const salesPrice = aRev - fRev;
    const bq = units*0.4;
    const labQty = -( (hours - bq) * 10 );          // cost overrun is unfavourable
    const labPrice = -( labcost - hours*10 );
    document.getElementById('s8vol').textContent = fu(vol);
    document.getElementById('s8flex').textContent = fu(flex);
    document.getElementById('s8sp').textContent = fu(salesPrice);
    document.getElementById('s8lq').textContent = fu(labQty);
    document.getElementById('s8lp').textContent = fu(labPrice);

    document.getElementById('s8note').innerHTML = '<b>Reading</b>' +
      'Total profit variance ' + fu(aProfit - staticProfit) + ' = sales volume ' + fu(vol) +
      ' + flexible budget ' + fu(flex) + '. ' +
      (labQty < 0 && labPrice > 0
        ? 'Favourable labour price alongside unfavourable labour quantity is the cheaper-and-slower pattern &mdash; investigate it as one story.'
        : 'Watch what happens to the split when you move volume alone: the flexible budget variance should not move at all.');
  }
  ids.forEach(i=>i.addEventListener('input', render));
  render();
})();
"""

S8_STATIONS = [
    ("trap", "The Trap", """
  <h2 class="head">Did Operations Save <span style="color:var(--stop-red)">$10,600?</span></h2>
  <div class="dek">Target's gross margin fell from about 30% to 21.5% in two quarters while inventory ran 40% above the prior year. Was that a demand failure, a pricing failure or an execution failure? Variance analysis is the machinery for answering exactly that.</div>

  <h3 class="sub">Glass Vessels</h3>
  <table class="simple">
    <tr><th>Budget assumption</th><th></th></tr>
    <tr><td>Sales forecast</td><td>10,000 units</td></tr>
    <tr><td>Price</td><td>$12 per unit</td></tr>
    <tr><td>Labour</td><td>0.4 hour per unit at $10</td></tr>
    <tr><td>Material</td><td>0.5 kg per unit at $6</td></tr>
    <tr><td>Variable overhead</td><td>$1.25 per labour hour</td></tr>
    <tr><td>Fixed overhead</td><td>$14,000</td></tr>
  </table>

  <table class="simple" style="margin-top:14px;">
    <tr><th></th><th>Static budget</th><th>Actual</th></tr>
    <tr><td>Units</td><td>10,000</td><td>8,000</td></tr>
    <tr><td>Revenue</td><td>$120,000</td><td>$88,000</td></tr>
    <tr><td>Labour</td><td>$40,000</td><td>$34,000</td></tr>
    <tr><td>Material</td><td>$30,000</td><td>$25,500</td></tr>
    <tr><td>Variable overhead</td><td>$5,000</td><td>$3,800</td></tr>
    <tr><td>Fixed costs</td><td>$14,000</td><td>$15,100</td></tr>
    <tr><td>Total costs</td><td>$89,000</td><td>$78,400</td></tr>
    <tr><td>Operating profit</td><td>$31,000</td><td>$9,600</td></tr>
  </table>

  <div class="note stop"><b>The claim to reject</b>"Total costs came in at $78,400 against a budget of $89,000 &mdash; production saved us $10,600. Great execution." Volume was 20% below plan. Of course costs were lower.</div>
  <div class="note go"><b>What actually happened</b>Against a flexible budget of $74,000 at 8,000 units, the plant <b>overspent by $4,400</b>. The saving was an artefact of the comparison.</div>

  <h3 class="sub">Vocabulary</h3>
  <ul class="tidy">
    <li>A <b>variance</b> is actual minus budget</li>
    <li><b>Favourable (F)</b> means better than budget; <b>unfavourable (U)</b> means worse</li>
    <li>Variances are always in money, never in kilograms or hours &mdash; money makes their relative importance comparable</li>
  </ul>
"""),
    ("flexible", "The Flexible Budget", """
  <h2 class="head">The Flexible <span style="color:var(--go-green)">Budget</span></h2>
  <div class="dek">The budget re-computed at the actual output volume: what would revenue and costs have been at the volume achieved, if everything else had gone as planned?</div>

  <div class="formula-box">Static budget &rarr; Flexible budget &rarr; Actual results</div>
  <table class="errtable">
    <tr><th>Column</th><th>Volume</th><th>Prices and standards</th></tr>
    <tr><td>Static (master) budget</td><td>Budgeted</td><td>Budgeted</td></tr>
    <tr><td>Flexible budget</td><td><b>Actual</b></td><td>Budgeted</td></tr>
    <tr><td>Actual results</td><td>Actual</td><td>Actual</td></tr>
  </table>
  <div class="note"><b>One input from reality</b>The flexible budget takes exactly one number from the actual results &mdash; the volume. Everything else comes from the original standards. Contaminating it with an actual price destroys the separation it exists to create.</div>

  <h3 class="sub">Glass Vessels at 8,000 units</h3>
  <table class="simple">
    <tr><th></th><th>Static</th><th>Flexible</th><th>Actual</th></tr>
    <tr><td>Units</td><td>10,000</td><td>8,000</td><td>8,000</td></tr>
    <tr><td>Revenue</td><td>$120,000</td><td>$96,000</td><td>$88,000</td></tr>
    <tr><td>Labour</td><td>$40,000</td><td>$32,000</td><td>$34,000</td></tr>
    <tr><td>Material</td><td>$30,000</td><td>$24,000</td><td>$25,500</td></tr>
    <tr><td>Variable OH</td><td>$5,000</td><td>$4,000</td><td>$3,800</td></tr>
    <tr><td>Fixed costs</td><td>$14,000</td><td>$14,000</td><td>$15,100</td></tr>
    <tr><td>Profit</td><td>$31,000</td><td>$22,000</td><td>$9,600</td></tr>
  </table>

  <div class="formula-box">Sales volume variance = $22,000 &minus; $31,000 = $9,000 U</div>
  <div class="formula-box">Flexible budget variance = $9,600 &minus; $22,000 = $12,400 U</div>
  <div class="note go"><b>Whose number is whose</b>The $9,000 U belongs to sales and marketing &mdash; profit given up by selling 2,000 fewer units. The $12,400 U belongs to the plant &mdash; everything that went wrong at the volume actually run.</div>

  <h3 class="sub">Drag it</h3>
""" + S8_SPLITTER + """
"""),
    ("tree", "The Decomposition Tree", """
  <h2 class="head">The Decomposition <span style="color:var(--amber)">Tree</span></h2>
  <div class="dek">Every variance question is somewhere on this tree. Draw it before answering anything.</div>

  <div class="diagram-frame">
    <svg viewBox="0 0 620 260" xmlns="http://www.w3.org/2000/svg">
      <g font-family="IBM Plex Mono" font-size="11" fill="#BFE6F7" text-anchor="middle">
        <rect x="220" y="10" width="180" height="34" rx="4" fill="#14304F" stroke="#6FB7E0"/>
        <text x="310" y="31">Total Profit Variance</text>

        <line x1="310" y1="44" x2="150" y2="72" stroke="#6FB7E0"/>
        <line x1="310" y1="44" x2="470" y2="72" stroke="#6FB7E0"/>
        <rect x="60" y="72" width="180" height="34" rx="4" fill="#14304F" stroke="#6FB7E0"/>
        <text x="150" y="93">Sales Volume Variance</text>
        <rect x="380" y="72" width="180" height="34" rx="4" fill="#14304F" stroke="#F2B705"/>
        <text x="470" y="93">Flexible Budget Variance</text>

        <line x1="470" y1="106" x2="340" y2="134" stroke="#F2B705"/>
        <line x1="470" y1="106" x2="470" y2="134" stroke="#F2B705"/>
        <line x1="470" y1="106" x2="590" y2="134" stroke="#F2B705"/>
        <rect x="270" y="134" width="140" height="32" rx="4" fill="#0F2745" stroke="#F2B705"/>
        <text x="340" y="154">Sales Price</text>
        <rect x="415" y="134" width="110" height="32" rx="4" fill="#0F2745" stroke="#F2B705"/>
        <text x="470" y="154">Variable Cost</text>
        <rect x="530" y="134" width="86" height="32" rx="4" fill="#0F2745" stroke="#F2B705"/>
        <text x="573" y="154">Fixed Cost</text>

        <line x1="470" y1="166" x2="410" y2="196" stroke="#D6544F"/>
        <line x1="470" y1="166" x2="540" y2="196" stroke="#D6544F"/>
        <rect x="336" y="196" width="150" height="32" rx="4" fill="#0F2745" stroke="#D6544F"/>
        <text x="411" y="216">Quantity (efficiency)</text>
        <rect x="492" y="196" width="130" height="32" rx="4" fill="#0F2745" stroke="#D6544F"/>
        <text x="557" y="216">Price (spending)</text>
      </g>
    </svg>
    <div class="diagram-cap">Every named variance sits somewhere on this tree</div>
  </div>

  <div class="formula-box">Total profit variance = sales volume variance + flexible budget variance</div>
  <div class="formula-box">Sales volume variance = flexible budget profit &minus; master budget profit</div>
  <div class="formula-box">Sales price variance = actual revenue &minus; flexible budget revenue</div>
  <div class="formula-box">Fixed cost spending variance = budgeted fixed cost &minus; actual fixed cost</div>

  <h3 class="sub">Reading the split as a diagnosis</h3>
  <p class="lead">Glass Vessels' revenue shortfall of $32,000 against the static budget splits $24,000 to volume and $8,000 to price. Both sit with the revenue centre and mean different things: one is a forecasting or market problem, the other is discounting discipline or pricing power.</p>
  <div class="note"><b>Back-solving</b>Exam questions often give you all but one component and ask for the missing one. Write the identity, sign every term with F positive and U negative, and solve.</div>
"""),
    ("inputs", "Price and Quantity", """
  <h2 class="head">Splitting a Variable Cost <span style="color:var(--stop-red)">Variance</span></h2>
  <div class="dek">Labour cost came in over budget. Two possible reasons: more input was used than the standard allows, or each unit of input cost more. Three columns separate them.</div>

  <table class="errtable">
    <tr><th>Column</th><th>What it is</th><th>Name</th></tr>
    <tr><td>BQ &times; BP</td><td>Standard input <b>for the actual output</b>, at standard price</td><td>Flexible budget</td></tr>
    <tr><td>AQ &times; BP</td><td>Actual input used, at standard price</td><td>The "as if" budget</td></tr>
    <tr><td>AQ &times; AP</td><td>Actual input, at actual price</td><td>Actual</td></tr>
  </table>
  <div class="formula-box">Quantity (efficiency) variance = (AQ &minus; BQ) &times; BP</div>
  <div class="formula-box">Price (spending) variance = (AP &minus; BP) &times; AQ</div>
  <div class="formula-box">BQ = actual output &times; standard input per unit of output</div>

  <div class="note go"><b>Worked: Glass Vessels labour</b>Standard 0.4 hours at $10; output 8,000 units; actual 4,400 hours costing $34,000. BQ = 3,200 hours, so the flexible budget is $32,000. As-if = 4,400 &times; $10 = $44,000. Quantity variance $12,000 U, price variance $10,000 F, netting to the $2,000 U on the line.</div>
  <div class="note go"><b>Worked: material</b>Standard 0.5 kg at $6; output 8,000; actual 4,500 kg costing $25,500. BQ = 4,000 kg &rarr; flexible $24,000; as-if $27,000. Quantity $3,000 U, price $1,500 F, total $1,500 U.</div>

  <h3 class="sub">Running it backwards</h3>
  <p class="lead">Given the variances and asked for AQ and AP, fill the three columns in order.</p>
  <ul class="tidy">
    <li>Flexible budget is computable from the standards and the actual output</li>
    <li>Step to the as-if column using the quantity variance, then divide by BP to recover AQ</li>
    <li>Step to actual using the price variance, then divide by AQ to recover AP</li>
  </ul>
  <div class="note"><b>Worked: problem 8.42</b>Price variance $3,150 U, quantity variance $4,500 F, flexible quantity 18,000 kg at $1.50. Flexible = $27,000. As-if = 27,000 &minus; 4,500 = $22,500 &rarr; AQ = 15,000 kg. Actual = 22,500 + 3,150 = $25,650 &rarr; AP = $1.71. Total material variance $1,350 F.</div>
  <div class="note stop"><b>Trap</b>BQ is not the original budget's input quantity. It is the input the standard allows <b>for the output actually produced</b>. Using the master budget's quantity here is the most common error in the topic.</div>
"""),
    ("signals", "Signals, Not Verdicts", """
  <h2 class="head">Signals, Not <span style="color:var(--stop-red)">Verdicts</span></h2>
  <div class="dek">A favourable variance is not automatically good news, and four numbers on one page usually tell one story rather than four.</div>

  <h3 class="sub">One story, three variances</h3>
  <table class="simple">
    <tr><th>Variance</th><th>Glass Vessels</th></tr>
    <tr><td>Material price</td><td style="color:var(--go-green)">$1,500 F</td></tr>
    <tr><td>Material quantity</td><td style="color:var(--stop-red)">$3,000 U</td></tr>
    <tr><td>Labour price</td><td style="color:var(--go-green)">$10,000 F</td></tr>
    <tr><td>Labour quantity</td><td style="color:var(--stop-red)">$12,000 U</td></tr>
  </table>
  <div class="note stop"><b>Read separately</b>Purchasing looks excellent and production looks incompetent.</div>
  <div class="note go"><b>Read together</b>Cheaper, lower-grade material and cheaper, less experienced labour generated waste and took longer. Investigate the purchasing decision first, not the plant.</div>

  <h3 class="sub">What each variance points at</h3>
  <table class="errtable">
    <tr><th>Variance</th><th>Question it raises</th></tr>
    <tr><td>Sales price</td><td>Pricing power? Competitive pressure? Discounting discipline?</td></tr>
    <tr><td>Sales volume</td><td>Forecasting failure? Market shift?</td></tr>
    <tr><td>Labour efficiency</td><td>Process improvement? Automation? Training?</td></tr>
    <tr><td>Material price</td><td>Supplier negotiation? A quality trade-off?</td></tr>
    <tr><td>Fixed cost</td><td>Capacity discipline? A structural change?</td></tr>
  </table>

  <h3 class="sub">Gaming</h3>
  <ul class="tidy">
    <li><b>Cheap inputs</b> &mdash; buy lower quality for a favourable price variance</li>
    <li><b>Deferred maintenance</b> &mdash; postpone spending to hit a short-term target</li>
    <li><b>Budget slack</b> &mdash; pad so the standard is soft</li>
    <li><b>Short-termism</b> &mdash; sacrifice long-term investment for this period's number</li>
  </ul>
  <div class="note violet"><b>Unfavourable can be right</b>Jason's putter: a $50,000 U fixed cost variance from renting a milling machine bought $100,800 F of material quantity and $56,000 F of labour quantity &mdash; a net gain of $106,800.</div>

  <h3 class="sub">When variance analysis is less useful</h3>
  <ul class="tidy">
    <li><b>High fixed-cost environments</b> &mdash; software, semiconductors. Variable cost variances are immaterial.</li>
    <li><b>Rapidly shifting demand</b> &mdash; the budget is obsolete before the period ends</li>
    <li><b>Innovation-driven firms</b> &mdash; variance discipline discourages experimentation</li>
    <li><b>Service and knowledge work</b> &mdash; honest quantity standards are hard to define</li>
  </ul>
"""),
    ("buckeye", "Case: Buckeye", """
  <h2 class="head">Buckeye National <span style="color:var(--blue-line)">Bank</span></h2>
  <div class="dek">The service-sector version of Session 6. Buckeye chased retail accounts, paid branch managers for account growth, hit the targets, and watched profits fall for three straight years.</div>

  <h3 class="sub">The old system</h3>
  <p class="lead">All $2,850 thousand of indirect cost allocated on one base: the dollar value of checks processed. Retail wrote $9.5 million of the $95 million total; business wrote $85.5 million.</p>
  <table class="simple">
    <tr><th></th><th>Retail</th><th>Business</th></tr>
    <tr><td>Indirect cost assigned</td><td>$285</td><td>$2,565</td></tr>
    <tr><td>Accounts</td><td>150,000</td><td>50,000</td></tr>
    <tr><td>Cost per account</td><td>$1.90</td><td>$51.30</td></tr>
    <tr><td>Revenue per account</td><td>$10.00</td><td>$40.00</td></tr>
    <tr><td>Profit per account</td><td style="color:var(--go-green)">$8.10</td><td style="color:var(--stop-red)">&minus;$11.30</td></tr>
  </table>
  <div class="note stop"><b>What the base assumes</b>That indirect cost is proportional to the dollar value of checks. Nothing about processing a check depends on the amount written on it.</div>

  <h3 class="sub">The ABC pilot</h3>
  <table class="errtable">
    <tr><th>Activity</th><th>Pool</th><th>Driver</th><th>Rate</th></tr>
    <tr><td>Paying checks</td><td>$1,140</td><td>2,850k checks</td><td>$0.40 per check</td></tr>
    <tr><td>Providing teller services</td><td>$1,200</td><td>200k transactions</td><td>$6.00 per transaction</td></tr>
    <tr><td>Responding to inquiries</td><td>$510</td><td>100k calls</td><td>$5.10 per call</td></tr>
  </table>
  <table class="simple" style="margin-top:14px;">
    <tr><th></th><th>Retail</th><th>Business</th></tr>
    <tr><td>Paying checks</td><td>570k &rarr; $228.0</td><td>2,280k &rarr; $912.0</td></tr>
    <tr><td>Teller services</td><td>160k &rarr; $960.0</td><td>40k &rarr; $240.0</td></tr>
    <tr><td>Inquiries</td><td>95k &rarr; $484.5</td><td>5k &rarr; $25.5</td></tr>
    <tr><td>Total</td><td>$1,672.5</td><td>$1,177.5</td></tr>
    <tr><td>Cost per account</td><td>$11.15</td><td>$23.55</td></tr>
    <tr><td>Profit per account</td><td style="color:var(--stop-red)">&minus;$1.15</td><td style="color:var(--go-green)">$16.45</td></tr>
  </table>

  <div class="note violet"><b>Why the numbers move</b>Business customers write four times the check value, which the old base charged them for. What actually costs money is walking into a branch and telephoning &mdash; and retail does 80% of the teller transactions and 95% of the calls.</div>
  <div class="note go"><b>What Buckeye should do</b>Not stop serving retail. Fix the bonus plan first &mdash; paying for account count with no view of cost-to-serve pays managers to add loss-making accounts. Then: minimum balances and per-transaction fees, push routine activity to ATM and online channels, and target the retail segments that behave like the profitable accounts.</div>
  <div class="note stop"><b>Caution on the rates</b>Ten more teller customers will not add $60 of cost tomorrow. The rates are long-run average capacity costs &mdash; right for a strategic question, wrong for a short-run incremental one.</div>
"""),
]

S8_QUESTIONS = [
    ("Actual total costs came in below the static budget while output was well below plan. Why is that not evidence of cost control?",
     ["Fixed costs are uncontrollable", "The static budget was built for a higher volume; the comparison should be against a flexible budget at actual output", "Cost variances need a price-quantity split to mean anything", "Favourable cost variances are always offset by revenue variances"], 1,
     "Producing less costs less. The comparison will show a saving whenever volume falls short, regardless of how the plant ran."),
    ("Glass Vessels: static profit $31,000, flexible profit $22,000, actual profit $9,600. What is the sales volume variance?",
     ["$21,400 U", "$12,400 U", "$9,000 U", "$9,000 F"], 2,
     "Flexible minus master: 22,000 − 31,000 = $9,000 U. That is the profit given up by selling 2,000 fewer units, and it belongs to the revenue centre."),
    ("Using the same numbers, which variance belongs to the plant, and what is it?",
     ["Sales volume variance, $9,000 U", "Flexible budget variance, $12,400 U", "Total profit variance, $21,400 U", "Flexible budget variance, $10,600 F"], 1,
     "Actual minus flexible: 9,600 − 22,000 = $12,400 U. Everything that went differently at the volume actually produced."),
    ("Budgeted revenue was $120,000 at 10,000 units and $12; actual revenue was $88,000 on 8,000 units. How does the $32,000 shortfall split?",
     ["All volume", "$24,000 volume, $8,000 price", "$8,000 volume, $24,000 price", "Cannot tell"], 1,
     "The flexible budget at 8,000 units and $12 is $96,000. Static to flexible is the volume effect, flexible to actual is the price effect."),
    ("Standard material is 0.5 kg per unit at $6. Output was 8,000 units and 4,500 kg were used at a total cost of $25,500. What is the quantity variance?",
     ["$1,500 U", "$3,000 U", "$1,500 F", "$3,000 F"], 1,
     "BQ = 8,000 × 0.5 = 4,000 kg. (4,500 − 4,000) × $6 = $3,000 U. The price variance is $1,500 F, so the total is $1,500 U."),
    ("A price variance of $3,150 U, a quantity variance of $4,500 F, a flexible quantity of 18,000 kg and a budgeted price of $1.50. What were the actual quantity and price?",
     ["15,000 kg at $1.71", "21,000 kg at $1.29", "18,000 kg at $1.71", "15,000 kg at $1.50"], 0,
     "Flexible $27,000; as-if 27,000 − 4,500 = $22,500 → 15,000 kg; actual 22,500 + 3,150 = $25,650 → $1.71 per kg."),
    ("Material price F, material quantity U, labour price F, labour quantity U. Which single story would you investigate first?",
     ["Unrelated events, investigate separately", "Purchasing bought cheaper, lower-grade material that generated waste", "Workers underperformed because they were lower skilled", "The labour standard was set too tight"], 1,
     "Favourable prices with unfavourable quantities in two different inputs is the signature of a quality trade-off, and it starts with a purchasing decision."),
    ("A plant manager behind on cost targets defers maintenance and switches to a discount supplier in December. What shows up, and when?",
     ["Fixed cost F and material price F now; downtime, material quantity U and labour efficiency U later", "Fixed cost U now, favourable later", "No effect; total spending is unchanged", "Material quantity F now, material price U later"], 0,
     "Both moves buy favourable variances immediately and send the bill to the next quarter. Favourable variances at the end of a measurement cycle deserve more scrutiny, not less."),
    ("Hempstead planned 8,000 units at $150 with budgeted costs of $990,000, and made 7,200. Actual profit was $163,900. What is the total profit variance?",
     ["$46,100 U", "$4,900 F", "$51,000 U", "$1,900 F"], 0,
     "Master budget profit is 1,200,000 − 990,000 = $210,000. 163,900 − 210,000 = $46,100 U, even though actual total cost came in under the static budget."),
    ("Hempstead budgeted labour at $10 an hour and 0.75 hours per unit, made 7,200 units and paid for 6,200 hours. What is the labour quantity variance?",
     ["$2,000 U", "$8,000 U", "$4,500 U", "$3,300 F"], 1,
     "BQ = 7,200 × 0.75 = 5,400 hours. (6,200 − 5,400) × $10 = $8,000 U. Using the master budget's 6,000 hours gives the $2,000 distractor."),
    ("Under Buckeye's old system, what is the indirect cost per business account?",
     ["$23.55", "$51.30", "$1.90", "$11.15"], 1,
     "Business wrote 90% of check value, so $2,565 thousand over 50,000 accounts. Under ABC it falls to $23.55 and the profitability ranking inverts."),
    ("Why did Buckeye's old base get retail costs so badly wrong?",
     ["The pool total was understated", "The base measured transaction size while the real drivers were how often customers used branch and call-centre capacity", "Retail costs should have been traced directly", "The base was applied to the wrong pool"], 1,
     "Retail wrote small checks and made 80% of teller transactions and 95% of calls. The base measured size; the activity drivers measure work."),
]

S8_CHEAT = [
    ("Three columns", "<ul><li>Static: budgeted volume, budgeted standards</li><li>Flexible: <b>actual</b> volume, budgeted standards</li><li>Actual: everything actual</li></ul>"),
    ("Top of the tree", "<div class='f'>Total = sales volume + flexible budget</div><div class='f'>Volume = flexible profit &minus; master profit</div><div class='f'>Flex = actual profit &minus; flexible profit</div>"),
    ("Inside the flex variance", "<div class='f'>Sales price = actual rev &minus; flexible rev</div><div class='f'>Fixed = budgeted FC &minus; actual FC</div><ul><li>Plus one variance per variable input</li></ul>"),
    ("Input split", "<div class='f'>Quantity = (AQ &minus; BQ) &times; BP</div><div class='f'>Price = (AP &minus; BP) &times; AQ</div><div class='f'>BQ = actual output &times; standard per unit</div>"),
    ("Glass Vessels numbers", "<ul><li>Static $31,000, flexible $22,000, actual $9,600</li><li>Volume $9,000 U, flex $12,400 U</li><li>Labour: qty $12,000 U, price $10,000 F</li><li>Material: qty $3,000 U, price $1,500 F</li></ul>"),
    ("Running it backwards", "<ul><li>Flexible from the standards</li><li>Step by the quantity variance &rarr; as-if &rarr; &divide; BP = AQ</li><li>Step by the price variance &rarr; actual &rarr; &divide; AQ = AP</li></ul>"),
    ("Buckeye", "<ul><li>Old: retail $1.90, business $51.30</li><li>ABC: retail $11.15, business $23.55</li><li>Rates: $0.40 check, $6.00 teller, $5.10 call</li><li>Profit: retail &minus;$1.15, business $16.45</li></ul>"),
    ("When it is less useful", "<ul><li>High fixed-cost environments</li><li>Rapidly shifting demand</li><li>Innovation-driven firms</li><li>Service and knowledge work</li></ul>"),
]


# ===========================================================================
# Session 9 — Divisional performance and transfer pricing
# ===========================================================================

S9_ZONE = """
<div class="grid2">
  <div>
    <div class="ctrl-block">
      <label>Seller's variable cost <span class="live" id="s9vcL">$1,800</span></label>
      <input type="range" min="500" max="4000" step="50" value="1800" id="s9vc">
    </div>
    <div class="ctrl-block">
      <label>Seller's external price <span class="live" id="s9extL">$4,000</span></label>
      <input type="range" min="1000" max="6000" step="50" value="4000" id="s9ext">
    </div>
    <div class="ctrl-block">
      <label>Units displaced per unit transferred <span class="live" id="s9dispL">1.00</span></label>
      <input type="range" min="0" max="100" step="5" value="100" id="s9disp">
    </div>
    <div class="ctrl-block">
      <label>Buyer's external purchase price <span class="live" id="s9buyL">$4,400</span></label>
      <input type="range" min="1000" max="7000" step="50" value="4400" id="s9buy">
    </div>
    <div class="ctrl-block">
      <label>Extra variable cost to modify for the buyer <span class="live" id="s9modL">$0</span></label>
      <input type="range" min="0" max="1500" step="50" value="0" id="s9mod">
    </div>
    <p style="font-size:13.5px; color:var(--ink-soft);">A displacement of 1.00 is full capacity &mdash; every internal unit costs an external sale. Zero is genuine excess capacity. Anything between is partial capacity.</p>
  </div>
  <div>
    <div class="readout-row">
      <div class="readout-card red"><div class="val" id="s9min"></div><div class="lbl">min TP (seller)</div></div>
      <div class="readout-card green"><div class="val" id="s9max"></div><div class="lbl">max TP (buyer)</div></div>
    </div>
    <div class="diagram-frame" style="margin-top:12px;">
      <svg viewBox="0 0 460 90" id="s9svg" xmlns="http://www.w3.org/2000/svg"></svg>
      <div class="diagram-cap" id="s9cap"></div>
    </div>
    <div class="note" id="s9note"><b>Corporate decision</b></div>
  </div>
</div>
"""

S9_JS = r"""
(function(){
  const ids = ['s9vc','s9ext','s9disp','s9buy','s9mod'].map(i=>document.getElementById(i));
  function render(){
    const vc=+ids[0].value, ext=+ids[1].value, disp=+ids[2].value/100, buy=+ids[3].value, mod=+ids[4].value;
    document.getElementById('s9vcL').textContent = money(vc);
    document.getElementById('s9extL').textContent = money(ext);
    document.getElementById('s9dispL').textContent = disp.toFixed(2);
    document.getElementById('s9buyL').textContent = money(buy);
    document.getElementById('s9modL').textContent = money(mod);

    const opp = Math.max(ext - vc, 0) * disp;
    const minTP = vc + mod + opp;
    const maxTP = buy;
    document.getElementById('s9min').textContent = money(minTP);
    document.getElementById('s9max').textContent = money(maxTP);

    const lo = Math.min(minTP, maxTP), hi = Math.max(minTP, maxTP);
    const span = Math.max(hi - lo, 1);
    const padL = lo - span*0.6, padR = hi + span*0.6;
    const X = v => 20 + (v - padL)/(padR - padL) * 420;
    const exists = minTP < maxTP;
    let s = '';
    s += '<line x1="20" y1="46" x2="440" y2="46" stroke="#6FB7E0" stroke-width="1.5"/>';
    if(exists){
      s += '<rect x="'+X(minTP).toFixed(1)+'" y="36" width="'+(X(maxTP)-X(minTP)).toFixed(1)+'" height="20" fill="#4E9A6E" opacity="0.5" rx="3"/>';
    }
    [[minTP,'#D6544F','min'],[maxTP,'#4E9A6E','max']].forEach(([v,c,l])=>{
      s += '<line x1="'+X(v).toFixed(1)+'" y1="28" x2="'+X(v).toFixed(1)+'" y2="64" stroke="'+c+'" stroke-width="2"/>';
      s += '<text x="'+X(v).toFixed(1)+'" y="22" text-anchor="middle" fill="'+c+'" font-family="IBM Plex Mono" font-size="9">'+l+' '+money(v)+'</text>';
    });
    document.getElementById('s9svg').innerHTML = s;
    document.getElementById('s9cap').textContent = exists
      ? 'Transfer zone: any price in the shaded band is goal-congruent'
      : 'No transfer zone — the seller’s floor is above the buyer’s ceiling';

    const gain = maxTP - minTP;
    document.getElementById('s9note').innerHTML = '<b>Corporate decision</b>' + (exists
      ? 'Make internally. Cost of making inside is the seller’s floor of ' + money(minTP) +
        '; cost of buying outside is ' + money(maxTP) + '. The transfer creates ' + money(gain) + ' a unit.'
      : 'Buy outside. Making it inside costs ' + money(minTP) + ' of real resources against ' + money(maxTP) +
        ' to buy it, so the firm saves ' + money(-gain) + ' a unit by not transferring. That is the right answer, not a negotiation failure.');
  }
  ids.forEach(i=>i.addEventListener('input', render));
  render();
})();
"""

S9_STATIONS = [
    ("measures", "ROI, RI and EVA", """
  <h2 class="head">Measuring a Division That Owns <span style="color:var(--amber)">Assets</span></h2>
  <div class="dek">How an investment centre is scored, and why the choice of measure changes what its manager does. This never got its own deck, and it is in the assigned reading and four assigned problems.</div>

  <div class="formula-box">ROI = operating income &divide; assets employed</div>
  <div class="formula-box">Residual income = operating income &minus; (required return &times; assets)</div>
  <div class="formula-box">EVA = operating income &times; (1 &minus; t) &minus; WACC &times; (assets &minus; current liabilities)</div>
  <div class="formula-box">WACC = (1 &minus; t) &times; w<sub>d</sub> &times; r<sub>d</sub> + w<sub>e</sub> &times; r<sub>e</sub></div>

  <h3 class="sub">Two opposite distortions</h3>
  <table class="errtable">
    <tr><th>Measure</th><th>Distortion</th><th>Worked example</th></tr>
    <tr><td><b>Profit alone</b></td><td>Over-investment &mdash; the manager gets the benefit without being charged for the capital</td><td>A 12% project is accepted against a 15% cost of capital</td></tr>
    <tr><td><b>ROI</b></td><td>Under-investment &mdash; any project below the current ROI dilutes the ratio</td><td>26% on $300,000, plus $5,000 income on $50,000 of assets &rarr; ROI falls to 23.71%, so she declines</td></tr>
    <tr><td><b>Residual income</b></td><td>Not comparable across sizes &mdash; a big division has a big number by construction</td><td>Every project above the charge raises it, so the incentive is right</td></tr>
    <tr><td><b>EVA</b></td><td>Complex to implement, particularly the GAAP adjustments</td><td>After-tax income, WACC charge, assets net of current liabilities</td></tr>
  </table>

  <div class="note stop"><b>Trap</b>A high ROI can mean a small denominator. A business relying on personal service rather than modern facilities has old, heavily depreciated assets, so its book asset base is small and its ROI flattering &mdash; 35.71% in the textbook case.</div>
  <div class="note violet"><b>Owner versus manager</b>Owners take the long view and accept a project that dilutes this year's ROI. A hired manager evaluated on year-over-year ROI does not. That gap is goal incongruence, and performance measures narrow it without ever closing it.</div>
"""),
    ("basics", "What a Transfer Price Is", """
  <h2 class="head">What a Transfer Price <span style="color:var(--blue-line)">Is</span></h2>
  <div class="dek">When one division sells to another inside the same firm, the internal price is the transfer price. It is revenue to the seller, cost to the buyer, and exactly zero-sum for the group.</div>

  <div class="grid2">
    <div><div class="note"><b>For the selling division</b>The transfer price is <b>revenue</b>. A higher price raises its reported profit.</div></div>
    <div><div class="note"><b>For the buying division</b>The transfer price is a <b>cost</b>. A higher price lowers its reported profit.</div></div>
  </div>
  <div class="note go"><b>The consequence</b>Internal transfer prices do not change corporate pre-tax profit. They shift profit between divisions.</div>

  <h3 class="sub">So why the heat?</h3>
  <ul class="tidy">
    <li><b>Bonuses and promotions</b> &mdash; divisional profit is the primary metric for evaluating a division manager</li>
    <li><b>Capital allocation</b> &mdash; profitable divisions get investment, unprofitable ones get cut</li>
    <li><b>Sourcing decisions</b> &mdash; make or buy hinges on the price the buying manager faces</li>
    <li><b>Divisional survival</b> &mdash; a persistently unprofitable division gets shut or sold</li>
  </ul>

  <h3 class="sub">Three questions in every problem</h3>
  <ul class="tidy">
    <li><b>Decision rights</b> &mdash; may divisions source externally when internal supply exists, and who sets the price?</li>
    <li><b>Goal congruence</b> &mdash; what price leads autonomous managers, each maximising their own profit, to do what is best for the firm?</li>
    <li><b>Sourcing choice</b> &mdash; from the corporate perspective, is an internal transfer better than an external purchase at all?</li>
  </ul>
  <div class="note violet"><b>Three objectives, in tension</b>Goal alignment, divisional autonomy, fair performance measurement. No system achieves all three.</div>
  <div class="note stop"><b>Trap</b>The zero-sum property holds for pre-tax profit within one tax jurisdiction. Cross borders and the price starts moving the group's tax bill.</div>
"""),
    ("rule", "The Min/Max Rule", """
  <h2 class="head">The Minimum and Maximum <span style="color:var(--go-green)">Rule</span></h2>
  <div class="dek">Almost every transfer pricing question reduces to two numbers.</div>

  <div class="formula-box">Min TP (seller) = incremental cost + opportunity cost of the transfer</div>
  <div class="formula-box">Max TP (buyer) = external purchase price &plusmn; costs saved or incurred by buying internally</div>

  <div class="note go"><b>The corporate test is the same two numbers</b>The seller's minimum <b>is</b> the true cost of making in-house. The buyer's maximum <b>is</b> the true cost of buying. Compare them and the sourcing decision follows.</div>
  <div class="note"><b>No zone is an answer</b>If the minimum exceeds the maximum, no price exists that both divisions accept &mdash; and that is the correct signal that the firm should buy outside, not a negotiation failure.</div>

  <h3 class="sub">Adjustments on each side</h3>
  <table class="errtable">
    <tr><th>Change</th><th>Effect</th><th>Example</th></tr>
    <tr><td>Extra work to make the transferred unit</td><td>Raises the seller's floor</td><td>Tesla's $600 modification: $4,000 &rarr; $4,600</td></tr>
    <tr><td>Costs the buyer avoids by sourcing inside</td><td>Raises the buyer's ceiling</td><td>$60 of inspection and freight: $1,000 &rarr; $1,060</td></tr>
    <tr><td>Extra costs the buyer incurs on an internal part</td><td>Lowers the buyer's ceiling</td><td>$12 of rework on a $140 external price &rarr; $128</td></tr>
  </table>

  <div class="note stop"><b>Trap</b>Unitised fixed cost is never in the minimum transfer price. It is sunk with respect to the transfer decision, and it enters only when a corporate policy forces it in &mdash; which is Session 10's cautionary tale.</div>
  <div class="note violet"><b>Caveat</b>This framework is for short-run decisions. Divisions will not sign long-term commitments at a price covering only incremental and opportunity cost, because over the long run capacity itself is a choice.</div>
"""),
    ("capacity", "Capacity Is the Story", """
  <h2 class="head">Capacity Is the Whole <span style="color:var(--stop-red)">Story</span></h2>
  <div class="dek">The seller's opportunity cost is the entire content of the transfer price, and capacity determines it.</div>

  <table class="errtable">
    <tr><th>Situation</th><th>Opportunity cost per unit</th><th>Minimum TP</th></tr>
    <tr><td>Excess capacity</td><td>Zero &mdash; nothing is displaced</td><td>Variable cost</td></tr>
    <tr><td>Full capacity</td><td>Contribution lost on the displaced external sale</td><td>Variable cost + lost CM = the market price</td></tr>
    <tr><td>Partial capacity</td><td>Only displacing units carry it, spread over all transferred units</td><td>VC + weighted opportunity cost</td></tr>
    <tr><td>Constrained resource</td><td>CM per constraint unit &times; constraint units used</td><td>VC + that amount</td></tr>
  </table>

  <h3 class="sub">Drag it</h3>
""" + S9_ZONE + """

  <h3 class="sub">Walker Inc., all three scenarios</h3>
  <p class="lead">Circuit 222: standard variable cost $140, modified $155, capacity 100,000, Satellite's external price $180.</p>
  <table class="simple">
    <tr><th>Scenario</th><th>Opp. cost</th><th>Min TP</th><th>Max TP</th><th>Decision</th></tr>
    <tr><td>100,000 external at $170</td><td>$30</td><td>$185</td><td>$180</td><td style="color:var(--stop-red)">No transfer</td></tr>
    <tr><td>50,000 external at $170</td><td>zero</td><td>$155</td><td>$180</td><td style="color:var(--go-green)">Transfer</td></tr>
    <tr><td>50,000 at $170 + one-time 50,000 at $160</td><td>$20</td><td>$175</td><td>$180</td><td style="color:var(--go-green)">Transfer</td></tr>
  </table>
  <div class="note stop"><b>The one worth studying</b>In the third case what gets displaced is the <b>marginal</b> external order &mdash; the $160 one &mdash; not the best one.</div>

  <h3 class="sub">A constrained resource</h3>
  <p>Division A runs two products on one machine with 600 hours a month. Product 1: demand 300 units, price $10, variable cost $4, one hour each. Product 2: unlimited demand, price $15, variable cost $7, two hours each.</p>
  <ul class="tidy">
    <li>Rank by contribution per <b>machine hour</b>: Product 1 earns $6, Product 2 earns $4</li>
    <li>Optimal mix: Product 1 at 300 units (300 hours), then Product 2 at 150 units (300 hours)</li>
    <li>Transferring 50 units of Product 1 uses 50 hours &rarr; displaces 25 units of Product 2 &rarr; 25 &times; $8 = $200, or $4 per transferred unit</li>
    <li>Min TP = $4 + $4 = <b>$8</b> against Division B's external price of $9</li>
  </ul>
  <div class="note stop"><b>Trap</b>Rank by contribution per unit of the constraint, not per unit of product. Product 2 has the higher margin per unit and the lower margin per machine hour, and the machine is what is scarce. The unitised fixed costs of $2 and $6 are there to be ignored.</div>
"""),
]

S9_QUESTIONS = [
    ("A division earning 26% on $300,000 is offered a project adding $5,000 of income on $50,000 of assets. What happens under ROI?",
     ["ROI rises to 27.6%, so she accepts", "ROI falls to 23.71%, so she likely rejects a project that may well be worth taking", "ROI is unchanged", "ROI falls, and rejecting is right for the firm"], 1,
     "83,000 / 350,000 = 23.71%. The project earns 10%, which may beat the cost of capital — the underinvestment problem residual income fixes."),
    ("A division earns $1,200,000 on assets of $6,000,000 with a required return of 12%. What is residual income?",
     ["$720,000", "$480,000", "20%", "$1,200,000"], 1,
     "1,200,000 − 0.12 × 6,000,000 = $480,000. The $720,000 distractor is the capital charge itself."),
    ("A firm is 30% debt at a pre-tax cost of 8% and 70% equity at 12%, with a 30% tax rate. What is WACC?",
     ["10.80%", "10.08%", "11.28%", "9.24%"], 1,
     "(0.70 × 0.30 × 0.08) + (0.70 × 0.12) = 0.0168 + 0.084 = 10.08%. Only the debt term carries the tax shield."),
    ("Raising a transfer price from $80 to $95 on 10,000 internal units does what to corporate pre-tax profit?",
     ["Raises it by $150,000", "Lowers it by $150,000", "Leaves it unchanged", "Depends on the seller's variable cost"], 2,
     "One division's revenue is the other's cost. $150,000 moves between divisions and the group total does not change."),
    ("Division A is at capacity: variable cost $20, external price $50, variable selling cost $5 avoided on internal transfers. What is the minimum transfer price?",
     ["$50", "$45", "$24", "$20"], 1,
     "Incremental cost $20 plus the contribution given up, 50 − 20 − 5 = $25. Minimum is $45. The $4 unitised fixed cost never enters."),
    ("Division B currently buys the part outside at $32. What is its maximum transfer price?",
     ["$45", "$32", "$25", "The seller's variable cost"], 1,
     "The buyer's ceiling comes from the buyer's alternative. The seller's costs set the floor, not the cap."),
    ("With a seller's minimum of $45 and a buyer's maximum of $32, what should the firm do?",
     ["Mandate a transfer at $38", "Procure externally", "Produce internally", "It makes no difference"], 1,
     "Making it inside costs $45 of real resources against $32 to buy it. No zone exists, and that is the correct signal."),
    ("Now Division A's demand falls to 8,000 against capacity of 10,000. What is the change in corporate profit if B buys 1,000 units internally rather than at $32?",
     ["$12,000 increase", "$7,000 increase", "$3,000 increase", "$3,000 decrease"], 0,
     "Spare capacity means zero opportunity cost, so the corporate cost of making is the $20 variable cost. Saving of $12 on 1,000 units."),
    ("Tesla's battery division is at capacity with variable cost $1,800 and external price $4,000. Modifying for the vehicle division adds $600. What is the minimum transfer price?",
     ["$4,000", "$4,600", "$2,400", "$1,800"], 1,
     "Incremental cost rises to $2,400; the opportunity cost of $2,200 is unchanged. Against a $4,400 outside quote, the correct decision flips to buying."),
    ("A buyer's external supplier charges $1,000; sourcing internally would avoid $60 of inspection and freight. What is the maximum transfer price?",
     ["$940", "$1,000", "$1,060", "The seller's variable cost"], 2,
     "Buying outside costs $1,060 all-in. Savings raise the ceiling; extra costs of buying inside would lower it."),
    ("Walker has 100,000 of capacity, external demand of 50,000 at $170 plus a one-time 50,000 at $160, and a modified variable cost of $155. What is the minimum transfer price?",
     ["$155", "$175", "$185", "$170"], 1,
     "The transfer displaces the marginal order at $160, so the opportunity cost is 160 − 140 = $20. Min TP = $175 against Satellite's $180."),
    ("Division A's machine gives 600 hours. Product 1 earns $6 of contribution per hour, Product 2 earns $4. What is the optimal mix, given Product 1's demand is 300 units at one hour each?",
     ["300 units of Product 1 and 150 of Product 2", "300 units of Product 2 only", "150 of Product 1 and 225 of Product 2", "600 units of Product 1"], 0,
     "Fill Product 1's demand first at $6 an hour, using 300 hours, then run Product 2 for 150 units with the remaining 300 hours."),
]

S9_CHEAT = [
    ("Divisional measures", "<div class='f'>ROI = income &divide; assets</div><div class='f'>RI = income &minus; r &times; assets</div><div class='f'>EVA = income(1&minus;t) &minus; WACC &times; (assets &minus; CL)</div>"),
    ("Which distortion", "<ul><li>Profit alone &rarr; over-investment</li><li>ROI &rarr; under-investment</li><li>RI &rarr; right incentive, not comparable</li><li>EVA &rarr; soundest, hardest</li></ul>"),
    ("WACC", "<div class='f'>(1&minus;t) w<sub>d</sub> r<sub>d</sub> + w<sub>e</sub> r<sub>e</sub></div><ul><li>Tax shield on the debt term only</li></ul>"),
    ("The rule", "<div class='f'>Min = incremental + opportunity</div><div class='f'>Max = external price &plusmn; costs saved/incurred</div><ul><li>Min &lt; Max &rarr; transfer zone exists</li></ul>"),
    ("Opportunity cost by capacity", "<ul><li>Excess &rarr; zero, min = VC</li><li>Full &rarr; lost CM, min = market price</li><li>Partial &rarr; the <b>marginal</b> sale displaced</li><li>Constrained &rarr; CM per constraint unit</li></ul>"),
    ("Never in the min TP", "<ul><li>Unitised or allocated fixed cost</li><li>Any mark-up over cost</li><li>Sunk design or development spend</li></ul>"),
    ("Walker", "<ul><li>Full capacity: min $185 &gt; max $180 &rarr; no transfer</li><li>Excess: min $155, max $180</li><li>Marginal order: min $175, max $180</li></ul>"),
    ("Constrained resource", "<div class='f'>Rank by CM &divide; constraint units</div><ul><li>P1 $6/hr beats P2 $4/hr</li><li>50 units transferred &rarr; 25 of P2 displaced &rarr; $4/unit</li><li>Min TP $8, buyer's max $9</li></ul>"),
]


# ===========================================================================
# Session 10 — Transfer pricing in practice
# ===========================================================================

S10_TAX = """
<div class="grid2">
  <div>
    <div class="ctrl-block">
      <label>Transfer price <span class="live" id="s10tpL">$60</span></label>
      <input type="range" min="40" max="80" step="1" value="60" id="s10tp">
    </div>
    <div class="ctrl-block">
      <label>Assembly jurisdiction tax rate <span class="live" id="s10rateL">12.5%</span></label>
      <input type="range" min="0" max="350" step="25" value="125" id="s10rate">
    </div>
    <div class="ctrl-block">
      <label>Apply the 15% global minimum top-up <span class="live" id="s10p2L">off</span></label>
      <input type="range" min="0" max="1" step="1" value="0" id="s10p2">
    </div>
    <p style="font-size:13.5px; color:var(--ink-soft);">Parts cost $40 in the US at 21%; assembly costs $20; the product sells for $100. The transfer price is the price at which the US entity sells the part to the assembly subsidiary.</p>
  </div>
  <div>
    <table class="simple">
      <tr><th></th><th>United States</th><th>Assembly country</th></tr>
      <tr><td>Taxable income</td><td id="s10usInc"></td><td id="s10ieInc"></td></tr>
      <tr><td>Tax</td><td id="s10usTax"></td><td id="s10ieTax"></td></tr>
    </table>
    <div class="readout-row" style="margin-top:14px;">
      <div class="readout-card"><div class="val" id="s10tot"></div><div class="lbl">total tax</div></div>
      <div class="readout-card violet"><div class="val" id="s10eff"></div><div class="lbl">effective rate</div></div>
    </div>
    <div class="note" id="s10note"><b>Reading</b></div>
  </div>
</div>
"""

S10_JS = r"""
(function(){
  const ids = ['s10tp','s10rate','s10p2'].map(i=>document.getElementById(i));
  function render(){
    const tp=+ids[0].value, rate=+ids[1].value/1000, p2=+ids[2].value===1;
    document.getElementById('s10tpL').textContent = money(tp);
    document.getElementById('s10rateL').textContent = (rate*100).toFixed(1)+'%';
    document.getElementById('s10p2L').textContent = p2 ? 'on' : 'off';

    const usInc = tp - 40, ieInc = 100 - tp - 20;
    const usTax = usInc*0.21;
    let ieRate = rate;
    if(p2 && rate < 0.15) ieRate = 0.15;
    const ieTax = ieInc*ieRate;
    const total = usTax + ieTax, profit = 40;
    const set=(id,v)=>document.getElementById(id).textContent = money(v,2);
    set('s10usInc', usInc); set('s10ieInc', ieInc);
    set('s10usTax', usTax); set('s10ieTax', ieTax);
    document.getElementById('s10tot').textContent = money(total,2);
    document.getElementById('s10eff').textContent = (total/profit*100).toFixed(2)+'%';

    let msg;
    if(p2 && rate < 0.15) msg = 'Pillar Two tops the assembly country up to 15%, so pushing the transfer price down stops paying for itself below that floor.';
    else if(tp <= 40) msg = 'All the profit is booked in the low-tax country. This is the arrangement arm’s-length rules exist to prevent — an unrelated party would not sell at cost.';
    else if(rate > 0.21) msg = 'The assembly country is the high-tax jurisdiction here, so the incentive reverses: a <b>higher</b> transfer price moves profit back to the US.';
    else msg = 'Every dollar shifted out of the 21% jurisdiction into the lower-rate one cuts the group’s bill. The constraint is arm’s-length pricing, not arithmetic.';
    document.getElementById('s10note').innerHTML = '<b>Reading</b>' + msg;
  }
  ids.forEach(i=>i.addEventListener('input', render));
  render();
})();
"""

S10_STATIONS = [
    ("policy", "Choosing a Policy", """
  <h2 class="head">Choosing a <span style="color:var(--amber)">Policy</span></h2>
  <div class="dek">Why have a policy at all? Because resolving disputes case by case pulls top management in constantly, undermines the decentralisation the firm chose, eats executive time, and asks the centre to arbitrate with local information it does not have.</div>

  <table class="errtable">
    <tr><th>Policy</th><th>Strength</th><th>Weakness</th><th>Share of firms</th></tr>
    <tr><td><b>Market-based</b></td><td>Objective, and equals the right answer at full capacity</td><td>Needs a competitive external market to exist</td><td>~30%</td></tr>
    <tr><td><b>Negotiated</b></td><td>Preserves autonomy; uses the divisions' own information</td><td>Haggling, conflict, bargaining-power outcomes</td><td>~24%</td></tr>
    <tr><td><b>Cost-based</b></td><td>Simple to administer, always available</td><td>Distorts sourcing whenever sourcing is delegated</td><td>~46%</td></tr>
  </table>
  <p style="font-size:13.5px; color:var(--ink-soft);">Cost-based splits into variable cost 5%, full cost 24% and cost-plus 17%.</p>

  <div class="note go"><b>The rule that falls out</b>Cost-based policies are workable when sourcing is <b>mandated</b> internally, because then the price only moves reported profit and cannot change a decision. Once sourcing is delegated, negotiated prices are the better default.</div>
"""),
    ("fullcost", "The Full-Cost-Plus Trap", """
  <h2 class="head">The Full-Cost-Plus <span style="color:var(--stop-red)">Trap</span></h2>
  <div class="dek">The worked example the session turns on, and the practice final tests it directly.</div>

  <h3 class="sub">The setup</h3>
  <ul class="tidy">
    <li>Divisions may source where they like; internal transfers are priced at the seller's budgeted full cost plus 10%</li>
    <li>Division A's budgeted full cost is $350 &mdash; $150 variable, $200 fixed unitised over budgeted volume</li>
    <li>A's capacity is 100,000 units and it can sell only 70,000 externally</li>
    <li>Division B needs 20,000 units and can buy outside at $300</li>
  </ul>

  <div class="grid2">
    <div>
      <h3 class="sub">What Division B sees</h3>
      <table class="simple">
        <tr><th></th><th>Internal</th><th>External</th></tr>
        <tr><td>Cost per unit</td><td>$385</td><td>$300</td></tr>
        <tr><td>Total for 20,000</td><td>$7.7M</td><td>$6.0M</td></tr>
      </table>
      <div class="note stop"><b>B's choice</b>Buy external. Any manager evaluated on divisional profit would.</div>
    </div>
    <div>
      <h3 class="sub">What the company sees</h3>
      <ul class="tidy">
        <li>A has idle capacity, so the true incremental cost of internal supply is <b>$150</b></li>
        <li>Buying outside spends $300 to avoid a $150 cost</li>
        <li>Loss = $150 a unit &times; 20,000 = <b>$3 million</b></li>
      </ul>
      <div class="note go"><b>Diagnosis</b>The manager is rational. The policy is at fault.</div>
    </div>
  </div>

  <div class="note violet"><b>Two features caused it</b>Unitised fixed cost that is not incremental, and a mark-up that is pure internal profit. The buying division treats the sum of both as its real cost of internal supply.</div>
"""),
    ("negotiation", "Negotiation and Holdup", """
  <h2 class="head">Seth, Brenda and <span style="color:var(--stop-red)">Holdup</span></h2>
  <div class="dek">Seth's components division designed a custom part with Brenda's refrigerator division, spending $240,000 on design and mock-ups on nothing firmer than an understanding that he would be the front-runner in the bidding.</div>

  <h3 class="sub">The positions</h3>
  <div class="grid2">
    <div><div class="note"><b>Seth</b>Bid $230 for 20,000 units a year &mdash; full cost plus about 15%. Variable cost $125, allocated overhead $75. Running at 70% capacity, missed bonus last year.</div></div>
    <div><div class="note"><b>Brenda</b>Outside bids around $170. Offers $200 to preserve the relationship and Seth's engineering support. Values his quality.</div></div>
  </div>

  <h3 class="sub">The arithmetic, per unit, against buying outside at $170</h3>
  <table class="simple">
    <tr><th>Transfer price</th><th>$170</th><th>$200</th><th>$230</th></tr>
    <tr><td>Change in Seth's profit</td><td>$45</td><td>$75</td><td>$105</td></tr>
    <tr><td>Change in Brenda's profit</td><td>$0</td><td>&minus;$30</td><td>&minus;$60</td></tr>
    <tr><td>Change in corporate profit</td><td style="color:var(--go-green)">$45</td><td style="color:var(--go-green)">$45</td><td style="color:var(--go-green)">$45</td></tr>
  </table>
  <div class="note go"><b>The only thing that matters to corporate</b>$45 a unit &mdash; $900,000 a year on 20,000 units &mdash; at every transfer price. The value comes from making the part at $125 rather than buying at $170. The price only decides who gets credit.</div>
  <div class="note stop"><b>And the zone</b>Floor is Seth's variable cost of $125 (he has spare capacity, so nothing is displaced). Ceiling is Brenda's $170. His $230 bid is outside any range she would rationally accept.</div>

  <h3 class="sub">Should corporate intervene?</h3>
  <div class="grid2">
    <div><div class="note go"><b>For</b>Resolves the conflict quickly. Ensures the value-creating transfer actually happens.</div></div>
    <div><div class="note stop"><b>Against</b>Undermines decentralisation. Time-consuming, and HQ lacks the local information. Sets a precedent that every future dispute gets escalated.</div></div>
  </div>

  <h3 class="sub">The holdup problem</h3>
  <p class="lead">Seth's real grievance is not the price. He sank $240,000 into an asset with value only in this relationship, on a vague promise, and Brenda now holds the bargaining power. <b>Relationship-specific investment + incomplete commitment = holdup.</b></p>
  <div class="note violet"><b>Apple and GT Advanced, 2014</b>GT invested hundreds of millions in sapphire capacity for Apple. Apple pulled back. GT went bankrupt.</div>
  <div class="note"><b>The remedies are all ex ante</b>A long-term purchase commitment or take-or-pay clause; cost sharing so the buyer co-funds the investment; pre-agreed formula pricing or arbitration; vertical integration or an internal sourcing mandate. Nothing works after the money is sunk.</div>
"""),
    ("international", "Tax and Arm's Length", """
  <h2 class="head">International Transfer <span style="color:var(--blue-line)">Pricing</span></h2>
  <div class="dek">Once divisions sit in different tax jurisdictions the price stops being zero-sum for the group, because subsidiaries are taxed where they earn income.</div>

  <h3 class="sub">The two levers</h3>
  <ul class="tidy">
    <li>Shift profits to low-tax countries by setting <b>low</b> transfer prices on goods sold <b>to</b> those subsidiaries</li>
    <li>Load costs into high-tax countries by purchasing <b>from</b> low-tax affiliates at inflated prices</li>
  </ul>

  <h3 class="sub">Drag it</h3>
""" + S10_TAX + """

  <h3 class="sub">What stops it</h3>
  <div class="note"><b>Arm's-length pricing</b>Most jurisdictions &mdash; the US, India, the OECD countries &mdash; require the transfer price to reflect what unrelated parties would charge. Acceptable methods: comparable uncontrolled price, cost-plus, profit-split, and advance pricing agreements negotiated with the authority in advance.</div>
  <div class="note go"><b>OECD Pillar Two</b>A 15% global minimum corporate tax from 2024 for groups above &euro;750 million of revenue. If a subsidiary's effective rate falls below 15%, the parent's jurisdiction imposes a top-up. It caps the gain from profit shifting without ending transfer pricing disputes.</div>
  <div class="note violet"><b>Why intangibles</b>A factory cannot be moved to a tax haven; a patent portfolio or a brand can be transferred with a signature. The royalty then runs from the operating country, which takes the deduction, to the haven, which books the income &mdash; and there is rarely a comparable market price to benchmark against.</div>

  <h3 class="sub">Apple and the Double Irish</h3>
  <ul class="tidy">
    <li>IP licensing income routed through two Irish entities with different tax residencies</li>
    <li>Non-US profits flowed to entities with minimal taxable presence; effective rates on some Irish profits reached 0.005%</li>
    <li>2016: the European Commission ruled Ireland had granted illegal state aid, ordering &euro;13 billion in back taxes</li>
    <li>2024: the Court of Justice upheld it. Ireland closed the structure to new entrants in 2015</li>
  </ul>
  <p style="font-size:13.5px; color:var(--ink-soft);">Google's Bermuda arrangement, Starbucks' Dutch royalty structure, Amazon's Luxembourg operations, and the IRS disputes with Coca-Cola and Medtronic are all versions of the same argument. All involve intangibles.</p>
"""),
    ("close", "Closing the Course", """
  <h2 class="head">Closing the <span style="color:var(--amber)">Course</span></h2>
  <div class="dek">What the transfer pricing module adds up to, and the four things he asked the class to remember from the whole of his half.</div>

  <h3 class="sub">Transfer pricing summary</h3>
  <ul class="tidy">
    <li><b>Transfer prices drive behaviour.</b> They set divisional profit, which drives bonuses, capital allocation and survival.</li>
    <li><b>The right price depends on context</b>, and opportunity cost is what context means. Full capacity points to market price; excess capacity points to variable cost.</li>
    <li><b>No policy is perfect.</b> Match the policy to the situation &mdash; mandated sourcing tolerates cost-based prices, delegated sourcing needs negotiation or market prices.</li>
    <li><b>Relationship-specific investment creates holdup risk</b>, and the remedy is contractual and comes first.</li>
    <li><b>International transfer pricing is a tax question</b> bounded by arm's-length rules and the global minimum tax.</li>
  </ul>

  <h3 class="sub">The four parting thoughts</h3>
  <div class="cheat-grid">
    <div class="cheat-card"><h4>01</h4><ul><li>There is no such thing as <b>the</b> cost of something.</li></ul></div>
    <div class="cheat-card"><h4>02</h4><ul><li>Numbers make people do things.</li></ul></div>
    <div class="cheat-card"><h4>03</h4><ul><li>Opportunity cost is real.</li></ul></div>
    <div class="cheat-card"><h4>04</h4><ul><li>Never stop at the headline number.</li></ul></div>
  </div>

  <h3 class="sub">Where each one showed up</h3>
  <table class="errtable">
    <tr><th>Thought</th><th>Session 6-7</th><th>Session 8</th><th>Session 9-10</th></tr>
    <tr><td>No single cost</td><td>Two cents or four cents, depending on the decision</td><td>Static cost or flexible cost</td><td>Variable cost or market price, depending on capacity</td></tr>
    <tr><td>Numbers make people do things</td><td>Buckeye's account-growth bonus</td><td>Deferred maintenance in December</td><td>Divisions outsourcing under full-cost-plus</td></tr>
    <tr><td>Opportunity cost is real</td><td>Capacity cost in the outsourcing decision</td><td>What a favourable price variance really bought</td><td>The entire minimum transfer price</td></tr>
    <tr><td>Never stop at the headline</td><td>The $5,000 loss hid A's profitability</td><td>The $10,600 "saving" was $4,400 of overspend</td><td>$45 a unit created, whatever the price says</td></tr>
  </table>
"""),
]

S10_QUESTIONS = [
    ("Roughly what share of firms use some form of cost-based transfer price?",
     ["About 24%", "About 30%", "About 46%", "About 70%"], 2,
     "Variable cost 5%, full cost 24% and cost-plus 17%. Market price is about 30% and negotiated about 24%."),
    ("Division S has excess capacity, corporate policy mandates full cost plus a markup, and both managers choose their own sourcing. What is the fundamental problem?",
     ["S recovers its fixed costs twice", "The transfer price overstates the true incremental cost, so B may rationally outsource when internal supply is cheaper for the firm", "The markup inflates combined income", "B loses any incentive to negotiate"], 1,
     "With excess capacity the true incremental cost is variable cost. Full cost plus a markup adds unitised fixed cost and internal profit, and B outsources on the inflated number."),
    ("Division A's budgeted full cost is $350, the policy is cost plus 10%, and B can buy outside at $300 for 20,000 units. A has idle capacity and a variable cost of $150. What does the policy cost the firm?",
     ["$1.7 million", "$3 million", "Nothing, because the transfer price is internal", "$1.7 million gained"], 1,
     "B buys outside at $300 to avoid a real cost of $150. The loss is $150 a unit on 20,000 units."),
    ("When is a cost-based policy defensible despite its distortions?",
     ["When sourcing is mandated internally, so the price cannot change the make-or-buy decision", "When the seller has excess capacity", "When both divisions are profit centres", "When a competitive external market exists"], 0,
     "A distorted price only does damage when it changes a decision. Excess capacity makes cost-based pricing more dangerous, not less."),
    ("Relative to buying outside at $170, what is the change in corporate profit if Brenda buys from Seth at $230 for 20,000 units, with Seth's variable cost at $125 and spare capacity?",
     ["$2,100,000 increase", "$1,200,000 decrease", "$900,000 increase", "No change"], 2,
     "$45 a unit of real saving, independent of the transfer price. $2.1 million is Seth's division's gain and $1.2 million is Brenda's loss — both distribution."),
    ("What is the transfer zone in the Seth and Brenda dispute?",
     ["$170 to $230", "$125 to $170", "$200 to $230", "$125 to $200"], 1,
     "Floor is Seth's variable cost of $125 with spare capacity; ceiling is Brenda's external alternative of $170. His $230 bid is outside any rational range."),
    ("Seth spent $240,000 on design against a vague promise and now finds Brenda holding the power. This is:",
     ["Goal incongruence", "Holdup, preventable only before the investment", "Adverse selection", "The ratchet effect"], 1,
     "Relationship-specific investment plus incomplete commitment. The remedies — take-or-pay, cost sharing, formula pricing, arbitration, integration — all have to be in place beforehand."),
    ("What is the strongest argument against corporate intervening in a transfer pricing dispute?",
     ["Intervention is prohibited by arm's-length rules", "It sets a precedent that every future dispute gets escalated, and HQ lacks the local information", "The centre cannot compute the transfer zone", "Divisions could not enforce the ruling"], 1,
     "Once escalation works, managers stop negotiating and start lobbying, and the centre acquires a workload it cannot discharge well."),
    ("Parts cost $40 in the US at 21%, assembly costs $20 in Ireland at 12.5%, and the product sells for $100. At a transfer price of $60, what is the effective tax rate?",
     ["21.0%", "16.75%", "12.5%", "18.5%"], 1,
     "US income $20 taxed at 21% is $4.20; Irish income $20 at 12.5% is $2.50. Total $6.70 on $40 of profit."),
    ("Dropping that transfer price to $40 would give an effective rate of 12.5%. Why do firms not simply do it?",
     ["The arm's-length principle requires the price to reflect what unrelated parties would charge", "Transfer prices below cost are illegal in every jurisdiction", "It would raise the US tax bill", "Consolidation would eliminate the benefit"], 0,
     "An unrelated party would not sell at cost. Acceptable methods include comparable price, cost-plus, profit-split and advance pricing agreements."),
    ("Under OECD Pillar Two, what happens when a large group's subsidiary pays below 15%?",
     ["The transfer price is restated to an arm's-length benchmark", "The home jurisdiction imposes a top-up tax", "The subsidiary loses its royalty deductions", "The group cannot consolidate that subsidiary"], 1,
     "A top-up in the parent's jurisdiction, for groups above €750 million of revenue, from 2024. It caps the gain from profit shifting without touching the price."),
    ("Why are intangibles the focus of most international transfer pricing disputes?",
     ["They are taxed at higher rates", "They can be relocated with a signature and rarely have a comparable market price", "Arm's-length rules do not apply to them", "Royalties are not deductible"], 1,
     "A factory cannot move to a tax haven; a patent portfolio can. And with no comparable transaction between unrelated parties, the arm's-length benchmark has little to anchor on."),
]

S10_CHEAT = [
    ("Three policies", "<ul><li><b>Market</b> &mdash; needs a competitive market (~30%)</li><li><b>Negotiated</b> &mdash; autonomy, conflict (~24%)</li><li><b>Cost-based</b> &mdash; simple, distorting (~46%)</li></ul>"),
    ("When cost-based is safe", "<ul><li>Sourcing mandated internally &rarr; price cannot change the decision</li><li>Sourcing delegated &rarr; negotiate instead</li></ul>"),
    ("The $3 million example", "<ul><li>Full cost $350, TP $385</li><li>External $300, true incremental $150</li><li>B outsources; firm loses $150 &times; 20,000</li></ul>"),
    ("Seth &amp; Brenda", "<ul><li>Corporate gains $45/unit at every TP</li><li>Zone $125 to $170</li><li>$900,000 a year on 20,000 units</li></ul>"),
    ("Holdup", "<div class='f'>Specific investment + weak commitment</div><ul><li>Take-or-pay, cost sharing, formula pricing, arbitration, integration</li><li>All ex ante. Apple / GT Advanced 2014</li></ul>"),
    ("International levers", "<ul><li>Low TP <b>to</b> low-tax subsidiaries</li><li>High TP <b>from</b> low-tax affiliates</li></ul><div class='f'>TP $60 &rarr; 16.75%; TP $40 &rarr; 12.5%</div>"),
    ("Constraints", "<ul><li>Arm's length: comparable price, cost-plus, profit-split, APAs</li><li>Pillar Two: 15% minimum, &euro;750m threshold, 2024, top-up at the parent</li></ul>"),
    ("The four thoughts", "<ul><li>No such thing as <b>the</b> cost</li><li>Numbers make people do things</li><li>Opportunity cost is real</li><li>Never stop at the headline number</li></ul>"),
]


# ===========================================================================
# Build
# ===========================================================================

GUIDES = [
    ("session-06", "MADM2 // SESSION 06 // FIELD MANUAL",
     'Activity-Based <span class="accent">Costing</span>',
     "Why a firm's own cost system misleads it about which products make money, and what activity-based costing does about it. Traditional allocation, the cost hierarchy, cross-subsidy, and when ABC is worth building.",
     "S. DUTTA", S6_STATIONS, S6_QUESTIONS, S6_CHEAT, S6_JS),
    ("session-07", "MADM2 // SESSION 07 // FIELD MANUAL",
     'Customers, Control and <span class="accent">Budgets</span>',
     "ABC pointed at customers rather than products, the structure that decides who is measured on what, and the budget as forecast, contract and target at once.",
     "S. DUTTA", S7_STATIONS, S7_QUESTIONS, S7_CHEAT, S7_JS),
    ("session-08", "MADM2 // SESSION 08 // FIELD MANUAL",
     'Variance <span class="accent">Analysis</span>',
     "Why actual profit differed from the budget, and how to separate what the sales team owns from what the plant owns. The flexible budget, the decomposition tree, price and quantity, and the Buckeye National Bank case.",
     "S. DUTTA", S8_STATIONS, S8_QUESTIONS, S8_CHEAT, S8_JS),
    ("session-09", "MADM2 // SESSION 09 // FIELD MANUAL",
     'Transfer <span class="accent">Pricing</span> I',
     "How an investment centre is scored, and the rule that determines what one division should charge another: incremental cost plus opportunity cost, against the buyer's external alternative.",
     "S. DUTTA", S9_STATIONS, S9_QUESTIONS, S9_CHEAT, S9_JS),
    ("session-10", "MADM2 // SESSION 10 // FIELD MANUAL",
     'Transfer <span class="accent">Pricing</span> II',
     "Transfer pricing in practice: which policy to set, what a mandated full-cost formula costs, how negotiations turn into holdup, and how the whole apparatus becomes a tax question across borders.",
     "S. DUTTA", S10_STATIONS, S10_QUESTIONS, S10_CHEAT, S10_JS),
]


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for slug, code, title, subtitle, instructor, stations, questions, cheat, js in GUIDES:
        size = build(slug, code, title, subtitle, instructor, stations, questions, cheat, js)
        print(f"{slug}.html  {size:,} bytes  {len(stations) + 2} stations  {len(questions)} questions")


if __name__ == "__main__":
    main()
