import { Link, useParams } from "react-router-dom";
import { type Store, coursesOf, LENSES } from "../lib/data";
import { ConceptRow } from "../components";
export default function LensPage({ store }: { store: Store }) {
  const id = useParams().id || "product"; const info = LENSES.find(l => l.id === id);
  const all = Object.values(store.data.concepts).filter(c => c.lenses.includes(id));
  const covered = all.filter(c => coursesOf(c).length > 0), gap = all.filter(c => !coursesOf(c).length);
  const groups: Record<string, typeof covered> = {}; covered.forEach(c => (groups[c.module[id] || "Other"] ||= []).push(c));
  const order = Object.entries(groups).sort((a, b) => b[1].length - a[1].length);
  return <article><div className="kicker">Prep kit</div><h1>{info?.name || id}</h1><p className="def">{info?.blurb}. {covered.length} of {all.length} ideas in this lens already show up in your courses.</p>
    {order.map(([m, cs]) => <div key={m} className="block"><div className="bh">{m} <span className="count">{cs.length}</span></div>
      <div className="list">{cs.sort((a, b) => (b.freq - a.freq) || coursesOf(b).length - coursesOf(a).length).slice(0, 12).map(c => <ConceptRow key={c.id} c={c} lens={id} />)}</div></div>)}
    <p className="small">{gap.length} ideas have no match in the courses loaded so far. <Link to="/compass">Search</Link> for any of them.</p></article>;
}
