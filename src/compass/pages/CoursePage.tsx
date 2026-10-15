import { Link, useParams, useSearchParams } from "react-router-dom";
import { inLens, type Store } from "../lib/data";
import { TOPICS, oneLine, topicOf } from "../lib/topics";
import { ideaPath, SectionLabel } from "../components";

export function CoursesPage({ store, lens }: { store: Store; lens: string }) {
  return <section><SectionLabel>Pick a course to revise</SectionLabel>
    <div className="tiles">{store.data.courses.map(c => { const ids = new Set(c.sessions.flatMap(s => s.concepts.map(k => k.id))); const n = c.sessions.filter(s => s.concepts.length).length;
      return <Link key={c.code} className="tile" to={`/compass/course/${c.code}?lens=${lens}`}><b>{c.name}</b><span>{c.code}</span><small className="small">{n} sessions · {ids.size} ideas</small><i>Revise →</i></Link>; })}</div></section>;
}

export function CoursePage({ store, lens }: { store: Store; lens: string }) {
  const course = store.byCourse[useParams().code || ""]; const [sp, setSp] = useSearchParams(); const by = sp.get("by") === "session" ? "session" : "topic";
  if (!course) return <p className="note" style={{ marginTop: 24 }}>Course not found. <Link to="/compass/courses">All courses</Link></p>;
  const seen: Record<string, { sessions: number[]; role: string }> = {};
  course.sessions.forEach(s => s.concepts.forEach(k => { const e = (seen[k.id] ||= { sessions: [], role: k.role }); if (!e.sessions.includes(s.n)) e.sessions.push(s.n); if (k.role === "teaches") e.role = "teaches"; }));
  const ideas = Object.keys(seen).map(i => store.data.concepts[i]).filter(c => c && inLens(c, lens));
  const setBy = (v: string) => { const n = new URLSearchParams(sp); n.set("by", v); setSp(n, { replace: true }); };
  return <section><div className="crumbs"><Link to={`/compass/courses?lens=${lens}`}>Courses</Link> › {course.code}</div>
    <div className="ph"><h1>{course.name}</h1><p className="sub">{ideas.length} ideas taught across {course.sessions.filter(s => s.concepts.length).length} sessions.</p></div>
    <div className="toggle" role="group" aria-label="Group by"><button className={by === "topic" ? "on" : ""} onClick={() => setBy("topic")}>By topic</button><button className={by === "session" ? "on" : ""} onClick={() => setBy("session")}>By session</button></div>
    {by === "topic" ? TOPICS.map(t => { const list = ideas.filter(c => topicOf(c) === t.id); if (!list.length) return null;
      return <div className="grp" key={t.id}><h2>{t.name}</h2><p className="gs">{list.length} ideas</p>
        <div className="rowlist">{list.sort((a, b) => Math.min(...seen[a.id].sessions) - Math.min(...seen[b.id].sessions)).map(c => <Link key={c.id} className="rowi" to={ideaPath(c.id, lens)}><b>{c.title}</b><p>{oneLine(c)}</p><span className="ss">Session {seen[c.id].sessions.sort((a, b) => a - b).join(", ")}</span></Link>)}</div></div>; })
    : course.sessions.map(s => <div className="grp" key={s.n}><h2>Session {s.n}{s.title && s.title !== `Session ${s.n}` ? ` · ${s.title}` : ""}</h2>
      {s.concepts.length ? <div className="chips" style={{ marginTop: 8 }}>{s.concepts.slice(0, 20).map(k => { const c = store.data.concepts[k.id]; return c ? <Link key={k.id} className="chip2" to={ideaPath(c.id, lens)}>{c.title}</Link> : null; })}</div> : <p className="gs">No ideas mapped for this session yet.</p>}
      <div className="links">{s.resources.filter(r => ["filewithwatermark", "resource", "folder"].includes(r.type)).slice(0, 4).map(l => <a key={l.url} href={l.url} target="_blank" rel="noreferrer">Open in Moodle: {l.name}</a>)}</div></div>)}
  </section>;
}
