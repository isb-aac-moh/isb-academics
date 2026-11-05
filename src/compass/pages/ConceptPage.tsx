import { Link, useParams } from "react-router-dom";
import { type Evidence, KIND_LABEL, type Store, coursesOf } from "../lib/data";
import { moduleOf, topicById, topicOf } from "../lib/topics";
import { useKnown } from "../lib/known";
import { Pill, SectionLabel } from "../components";
import ConceptGraph from "../ConceptGraph";

export default function ConceptPage({ store, lens }: { store: Store; lens: string }) {
  const id = decodeURIComponent(useParams().id || ""); const c = store.data.concepts[id]; const [known, toggle] = useKnown();
  if (!c) return <p className="note" style={{ marginTop: 24 }}>That idea isn't in Compass. <Link to="/compass">Back to search</Link></p>;
  const byCourse: Record<string, Evidence[]> = {}; c.evidence.forEach(e => (byCourse[e.course] ||= []).push(e));
  const nCourses = coursesOf(c).length; const topic = topicById(topicOf(c)); const mod = moduleOf(c);
  const interview = c.lenses.filter(l => l !== "general");
  return <article className="concept" style={{ marginTop: 24 }}>
    <div className="crumbs"><Link to={`/compass/topics?lens=${lens}`}>Topics</Link> › <Link to={`/compass/topics/${topic?.id}?lens=${lens}`}>{topic?.name}</Link>{mod && mod !== topic?.name ? ` › ${mod}` : ""}</div>
    <h1>{c.title}</h1>
    {c.aliases.length > 0 && <p className="aliases">Also called: {c.aliases.slice(0, 6).join(", ")}</p>}
    <p className="def">{c.obj || c.definition || c.q}</p>
    <div style={{ display: "flex", gap: 8, marginTop: 14, flexWrap: "wrap" }}>
      <button className={"btn" + (known.has(c.id) ? " on" : "")} onClick={() => toggle(c.id)} aria-pressed={known.has(c.id)}>{known.has(c.id) ? "✓ I know this" : "Mark as known"}</button>
      <Link className="btn" to={`/compass/map?topic=${topic?.id}&node=${encodeURIComponent(c.id)}&lens=${lens}`}>See on the map</Link></div>
    {c.know && <div className="know"><SectionLabel>What to know</SectionLabel>
      <p>{c.know.what}</p>{c.know.use && <p><b>When to use it.</b> {c.know.use}</p>}{c.know.trap && <p><b>Watch out.</b> {c.know.trap}</p>}
      {c.know.ask && <details><summary>Test yourself</summary><p>{c.know.ask}</p></details>}</div>}
    <section style={{ marginTop: 28 }}><SectionLabel>How it connects</SectionLabel><ConceptGraph store={store} c={c} lens={lens} /></section>
    <div className="cols">
      <div>
        <SectionLabel>Where ISB taught it</SectionLabel>
        {nCourses === 0 && <p className="note">Not found in the {store.data.courses.length} courses loaded so far. That doesn't mean it wasn't taught.</p>}
        {Object.entries(byCourse).map(([code, evs]) => { const course = store.byCourse[code]; const bySess: Record<string, Evidence[]> = {}; evs.forEach(e => (bySess[e.session ?? 0] ||= []).push(e));
          return <div key={code} className="block"><div className="bh"><Link to={`/compass/course/${code}?lens=${lens}`}>{course?.name || code}</Link></div>
            {Object.entries(bySess).sort((a, b) => +a[0] - +b[0]).map(([s, es]) => { const sess = course?.sessions.find(x => x.n === +s); const links = (sess?.resources || []).filter(r => ["filewithwatermark", "resource", "folder"].includes(r.type)).slice(0, 3);
              return <div key={s} className="srow"><div className="sh"><b>{+s ? `Session ${s}` : "Course outline"}</b>{sess?.title && sess.title !== `Session ${s}` ? <span> · {sess.title}</span> : null}</div>
                {es.slice(0, 3).map((e, i) => <div key={i} className="ev">{e.kind === "outline" ? <span className="pill mentions">In outline</span> : <Pill role={e.role} />}<span className="src">{KIND_LABEL[e.kind] || e.kind}{e.kind.startsWith("slides") ? ` ${e.pages[0] === e.pages[1] ? e.pages[0] : e.pages.join("–")}` : ""}</span><span>{e.summary}</span></div>)}
                {links.length > 0 && <div className="links">{links.map(l => <a key={l.url} href={l.url} target="_blank" rel="noreferrer">Open in Moodle: {l.name}</a>)}</div>}
              </div>; })}</div>; })}
      </div>
      <aside>
        <SectionLabel>In interviews</SectionLabel>
        <div className="panel">
          {c.q && <p><b>The question behind it</b><br />{c.q}</p>}
          {c.freq > 0 && <p>Used in {c.freq} casebook cases.</p>}
          {interview.length > 0 && <p className="small">Part of the {interview.map(l => l === "product" ? "Product roles" : "Consulting cases").join(" and ")} prep {interview.length > 1 ? "kits" : "kit"}.</p>}
          {!c.q && !c.freq && !interview.length && <p className="small">This idea comes from your course material and is not mapped to an interview topic yet.</p>}
        </div>
        <p className="small" style={{ marginTop: 16 }}>Sources: ISB course material, plus our own synthesis. Interview framing comes from the Product and Consulting graphs.</p>
      </aside>
    </div>
  </article>;
}
