import { Link, useParams } from "react-router-dom";
import { type Evidence, KIND_LABEL, type Store, coursesOf } from "../lib/data";
import { Pill } from "../components";
import ConceptGraph from "../ConceptGraph";

export default function ConceptPage({ store, lens }: { store: Store; lens: string }) {
  const id = decodeURIComponent(useParams().id || ""); const c = store.data.concepts[id];
  if (!c) return <p className="note">That idea isn't in Compass. <Link to="/compass">Back to search</Link></p>;
  const up = c.rel.map(r => ({ ...r, c: store.data.concepts[r.to] })).filter(r => r.c);
  const down = (store.reverse[c.id] || []).map(i => store.data.concepts[i]);
  const byCourse: Record<string, Evidence[]> = {}; c.evidence.forEach(e => (byCourse[e.course] ||= []).push(e));
  const nCourses = coursesOf(c).length;
  return <article className="concept">
    <div className="kicker">{c.lenses.filter(l => l !== "general").join(" · ") || "Idea"}{c.module && Object.values(c.module)[0] ? ` · ${Object.values(c.module)[0]}` : ""}</div>
    <h1>{c.title}</h1>
    {c.aliases.length > 0 && <p className="aliases">Also called: {c.aliases.slice(0, 6).join(", ")}</p>}
    <p className="def">{c.obj || c.definition || c.q}</p>
    {c.know && <div className="know"><h2 className="h3">What to know</h2>
      <p>{c.know.what}</p><p><b>When to use it.</b> {c.know.use}</p><p><b>Watch out.</b> {c.know.trap}</p>
      <details><summary>Test yourself</summary><p>{c.know.ask}</p></details></div>}
    <h2 className="h3">How it connects</h2>
    <ConceptGraph store={store} c={c} lens={lens} />
    <div className="cols">
      <div>
        <h2 className="h3">Where ISB taught it</h2>
        {nCourses === 0 && <p className="note">Not found in the {store.data.courses.length} courses loaded so far. That doesn't mean it wasn't taught.</p>}
        {Object.entries(byCourse).map(([code, evs]) => { const course = store.byCourse[code]; const bySess: Record<string, Evidence[]> = {}; evs.forEach(e => (bySess[e.session ?? 0] ||= []).push(e));
          return <div key={code} className="block"><div className="bh"><Link to={`/compass/course/${code}?lens=${lens}`}>{course?.name || code}</Link></div>
            {Object.entries(bySess).sort((a, b) => +a[0] - +b[0]).map(([s, es]) => { const sess = course?.sessions.find(x => x.n === +s); const links = (sess?.resources || []).filter(r => ["filewithwatermark", "resource", "folder"].includes(r.type)).slice(0, 3);
              return <div key={s} className="srow"><div className="sh"><b>{+s ? `Session ${s}` : "Course outline"}</b>{sess?.title && sess.title !== `Session ${s}` ? <span> · {sess.title}</span> : null}</div>
                {es.slice(0, 3).map((e, i) => <div key={i} className="ev">{e.kind === "outline" ? <span className="pill mentions">In outline</span> : <Pill role={e.role} />}<span className="src">{KIND_LABEL[e.kind] || e.kind}{e.kind.startsWith("slides") ? ` ${e.pages[0] === e.pages[1] ? e.pages[0] : e.pages.join("–")}` : ""}</span><span className="sum">{e.summary}</span></div>)}
                {links.length > 0 && <div className="links">{links.map(l => <a key={l.url} href={l.url} target="_blank" rel="noreferrer">Open in Moodle: {l.name}</a>)}</div>}
              </div>; })}</div>; })}
      </div>
      <aside>
        <h2 className="h3">{lens === "revision" ? "Revise" : "How it comes up"}</h2>
        <div className="panel">
          {c.q && <p><b>The question behind it</b><br />{c.q}</p>}
          {lens !== "revision" && c.freq > 0 && <p>Used in {c.freq} casebook cases.</p>}
          {!c.q && !c.freq && lens !== "revision" && <p className="small">This idea comes from your course material and is not mapped to an interview topic yet.</p>}
          {lens === "revision" && <p>{nCourses ? `Revise in: ${[...new Set(c.evidence.map(e => `${e.course} S${e.session ?? "-"}`))].slice(0, 8).join(", ")}` : "No ISB sessions found yet."}</p>}
        </div>
        {up.length > 0 && <><h2 className="h3">Builds on</h2><div className="chips">{up.slice(0, 10).map(r => <Link key={r.to} to={`/compass/c/${encodeURIComponent(r.to)}?lens=${lens}`} className="chip2" title={r.why}>{r.c.title}</Link>)}</div></>}
        {down.length > 0 && <><h2 className="h3">Leads to</h2><div className="chips">{down.slice(0, 10).map(d => <Link key={d.id} to={`/compass/c/${encodeURIComponent(d.id)}?lens=${lens}`} className="chip2">{d.title}</Link>)}</div></>}
        <h2 className="h3">Sources</h2><p className="small">ISB course material, plus our own synthesis. Interview framing comes from the Product and Consulting graphs.</p>
      </aside>
    </div>
  </article>;
}
