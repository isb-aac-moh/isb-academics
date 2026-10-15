import { Link, useParams } from "react-router-dom";
import { type Store } from "../lib/data";
export default function CoursePage({ store, lens }: { store: Store; lens: string }) {
  const course = store.byCourse[useParams().code || ""];
  if (!course) return <p className="note">Course not found. <Link to="/compass">Back</Link></p>;
  return <article><div className="kicker">{course.code}</div><h1>{course.name}</h1>
    {course.sessions.map(s => <div key={s.n} className="block"><div className="bh">Session {s.n}{s.title && s.title !== `Session ${s.n}` ? ` · ${s.title}` : ""}</div>
      {s.concepts.length ? <div className="chips">{s.concepts.slice(0, 14).map(k => { const c = store.data.concepts[k.id]; return c ? <Link key={k.id} className={"chip2 " + k.role} to={`/compass/c/${encodeURIComponent(c.id)}?lens=${lens}`}>{c.title}</Link> : null; })}</div> : <p className="small">No ideas mapped for this session yet.</p>}
      <div className="links">{s.resources.filter(r => ["filewithwatermark", "resource", "folder"].includes(r.type)).slice(0, 4).map(l => <a key={l.url} href={l.url} target="_blank" rel="noreferrer">Open in Moodle: {l.name}</a>)}</div></div>)}
  </article>;
}
