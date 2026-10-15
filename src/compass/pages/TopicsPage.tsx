import { Link, useParams } from "react-router-dom";
import { coursesOf, inLens, type Store } from "../lib/data";
import { TOPICS, moduleOf, topicById, topicOf } from "../lib/topics";
import { useKnown } from "../lib/known";
import { CourseChips, ideaPath, SectionLabel } from "../components";
import { oneLine } from "../lib/topics";

export function TopicsPage({ store, lens }: { store: Store; lens: string }) {
  const taught = Object.values(store.data.concepts).filter(c => coursesOf(c).length && inLens(c, lens));
  return <section><SectionLabel>Topics across all your courses</SectionLabel>
    <p className="note" style={{ marginBottom: 14 }}>Each topic gathers every idea taught on it, whichever course it came from. Open one to see the ideas and where each was covered.</p>
    <div className="tiles">{TOPICS.map(t => { const cs = taught.filter(c => topicOf(c) === t.id); const courses = new Set(cs.flatMap(coursesOf));
      return <Link key={t.id} className="tile topic" to={`/compass/topics/${t.id}?lens=${lens}`}><b>{t.name}</b><span>{t.blurb}</span><small>{cs.length} ideas · {courses.size} {courses.size === 1 ? "course" : "courses"}</small></Link>; })}</div></section>;
}

export function TopicPage({ store, lens }: { store: Store; lens: string }) {
  const id = useParams().id || ""; const topic = topicById(id); const [known] = useKnown();
  if (!topic) return <p className="note" style={{ marginTop: 24 }}>Topic not found. <Link to="/compass/topics">All topics</Link></p>;
  const cs = Object.values(store.data.concepts).filter(c => coursesOf(c).length && topicOf(c) === id && inLens(c, lens));
  const groups: Record<string, typeof cs> = {}; cs.forEach(c => (groups[moduleOf(c) || "Taught in class"] ||= []).push(c));
  const order = Object.entries(groups).sort((a, b) => (a[0] === "Taught in class" ? 1 : 0) - (b[0] === "Taught in class" ? 1 : 0) || b[1].length - a[1].length);
  return <section><div className="crumbs"><Link to={`/compass/topics?lens=${lens}`}>Topics</Link> › {topic.name}</div>
    <div className="ph"><h1>{topic.name}</h1><p className="sub">{topic.blurb}. {cs.length} ideas taught across {new Set(cs.flatMap(coursesOf)).size} courses.</p></div>
    <p style={{ marginTop: 12 }}><Link className="btn" to={`/compass/map?topic=${id}&lens=${lens}`}>See these ideas on the map</Link></p>
    {!cs.length && <p className="note" style={{ marginTop: 16 }}>Nothing in this topic for the selected view. Switch to All ideas.</p>}
    {order.map(([m, list]) => <div className="grp" key={m}><h2>{m}</h2><p className="gs">{list.length} ideas</p>
      <div className="rowlist">{list.sort((a, b) => coursesOf(b).length - coursesOf(a).length || b.evidence.length - a.evidence.length).map(c => <Link key={c.id} className={"rowi" + (known.has(c.id) ? " known" : "")} to={ideaPath(c.id, lens)}><b>{c.title}{known.has(c.id) ? " ✓" : ""}</b><p>{oneLine(c)}</p><CourseChips c={c} /></Link>)}</div></div>)}
  </section>;
}
