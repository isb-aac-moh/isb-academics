import { useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { coursesOf, inLens, type Store } from "../lib/data";
import { TOPICS, topicById, topicOf } from "../lib/topics";
import { ideaPath, SectionLabel } from "../components";

const PAGE = 120;

/** Which course teaches which idea, and in which session. The quickest way to see how courses overlap. */
export default function ComparePage({ store, lens }: { store: Store; lens: string }) {
  const [q, setQ] = useState(""); const [topic, setTopic] = useState(""); const [bridges, setBridges] = useState(true); const [limit, setLimit] = useState(PAGE);
  const courses = store.data.courses;
  const rows = useMemo(() => Object.values(store.data.concepts).filter(c => coursesOf(c).length && inLens(c, lens)).map(c => {
    const cells: Record<string, number[]> = {}; c.evidence.forEach(e => { if (e.session) { const a = (cells[e.course] ||= []); if (!a.includes(e.session)) a.push(e.session); } else cells[e.course] ||= []; });
    Object.values(cells).forEach(a => a.sort((x, y) => x - y)); return { c, cells, n: Object.keys(cells).length };
  }), [store, lens]);
  const bridgeCount = rows.filter(r => r.n >= 2).length;
  const shown = rows.filter(r => (!bridges || r.n >= 2) && (!topic || topicOf(r.c) === topic) && (!q.trim() || r.c.title.toLowerCase().includes(q.trim().toLowerCase())))
    .sort((a, b) => b.n - a.n || b.c.evidence.length - a.c.evidence.length);
  return <section><SectionLabel>Across courses</SectionLabel>
    <p className="note" style={{ marginBottom: 14 }}>{bridgeCount} of {rows.length} ideas are taught in two or more courses. These are the bridges between courses. Each cell shows the sessions that covered the idea; click it to open that course.</p>
    <div className="filters">
      <input type="search" placeholder="Filter by idea name" aria-label="Filter by idea name" value={q} onChange={e => { setQ(e.target.value); setLimit(PAGE); }} />
      <select aria-label="Topic" value={topic} onChange={e => { setTopic(e.target.value); setLimit(PAGE); }}><option value="">All topics</option>{TOPICS.map(t => <option key={t.id} value={t.id}>{t.name}</option>)}</select>
      <label><input type="checkbox" checked={bridges} onChange={e => { setBridges(e.target.checked); setLimit(PAGE); }} /> Only ideas taught in 2+ courses</label></div>
    <div className="tablewrap"><table className="cmp"><thead><tr><th>Idea</th>{courses.map(c => <th key={c.code} title={c.name}><Link to={`/compass/course/${c.code}?lens=${lens}`}>{c.code}</Link></th>)}</tr></thead>
      <tbody>{shown.slice(0, limit).map(({ c, cells }) => <tr key={c.id}><td><Link to={ideaPath(c.id, lens)}><b>{c.title}</b></Link><span className="xt">{topicById(topicOf(c))?.name}</span></td>
        {courses.map(k => <td key={k.code} className={cells[k.code] ? "hit" : ""}>{cells[k.code] ? <Link to={`/compass/course/${k.code}?by=session&lens=${lens}`}>{cells[k.code].length ? "S" + cells[k.code].join(", S") : "outline"}</Link> : ""}</td>)}</tr>)}</tbody></table></div>
    {shown.length === 0 && <p className="note" style={{ marginTop: 14 }}>No ideas match these filters.</p>}
    {shown.length > limit && <p style={{ marginTop: 14 }}><button className="btn" onClick={() => setLimit(l => l + PAGE)}>Show {Math.min(PAGE, shown.length - limit)} more ({shown.length - limit} left)</button></p>}
    <p className="small" style={{ marginTop: 12 }}>{shown.length} ideas shown.</p></section>;
}
