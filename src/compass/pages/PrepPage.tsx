import { Link, useParams } from "react-router-dom";
import { coursesOf, LENSES, type Store } from "../lib/data";
import { moduleOf, oneLine } from "../lib/topics";
import { useKnown } from "../lib/known";
import { CourseChips, ideaPath, SectionLabel } from "../components";

export function PrepPage({ store }: { store: Store }) {
  const kits = LENSES.filter(l => l.id !== "all");
  return <section><SectionLabel>Choose your prep kit</SectionLabel>
    <div className="tiles" style={{ gridTemplateColumns: "repeat(auto-fill,minmax(300px,1fr))" }}>{kits.map(k => { const all = Object.values(store.data.concepts).filter(c => c.lenses.includes(k.id)); const cov = all.filter(c => coursesOf(c).length).length;
      return <Link key={k.id} className="tile" to={`/compass/prep/${k.id}?lens=${k.id}`}><b style={{ fontSize: 17 }}>{k.name}</b><span>{k.blurb}.</span><div className="bar"><i style={{ width: `${(cov / all.length) * 100}%` }} /></div><small className="small">{cov} of {all.length} ideas already appear in your courses</small><i>Open the kit →</i></Link>; })}</div></section>;
}

export function PrepKitPage({ store }: { store: Store; lens: string }) {
  const id = useParams().id || "product"; const info = LENSES.find(l => l.id === id); const [known] = useKnown();
  const all = Object.values(store.data.concepts).filter(c => c.lenses.includes(id));
  const covered = all.filter(c => coursesOf(c).length), gap = all.filter(c => !coursesOf(c).length); const done = covered.filter(c => known.has(c.id)).length;
  const groups: Record<string, typeof covered> = {}; covered.forEach(c => (groups[c.module[id] || moduleOf(c) || "Also taught in class"] ||= []).push(c));
  const order = Object.entries(groups).sort((a, b) => (a[0] === "Also taught in class" ? 1 : 0) - (b[0] === "Also taught in class" ? 1 : 0) || b[1].length - a[1].length);
  return <section><div className="crumbs"><Link to="/compass/prep">Prep kits</Link> › {info?.name}</div>
    <div className="ph"><h1>{info?.name} <em>prep kit</em></h1><p className="sub">{info?.blurb}. Each topic below lists the interview ideas you have already met in class. Tick “I know this” on an idea page to track what is left.</p></div>
    <div className="stats"><div className="stat"><small>In your courses</small><b>{covered.length}<span>/{all.length}</span></b><div className="bar"><i style={{ width: `${(covered.length / all.length) * 100}%` }} /></div></div>
      <div className="stat"><small>You know</small><b>{done}<span>/{covered.length}</span></b><div className="bar"><i style={{ width: `${covered.length ? (done / covered.length) * 100 : 0}%` }} /></div></div></div>
    {order.map(([m, cs]) => <div className="grp" key={m}><h2>{m}</h2><p className="gs">{cs.length} ideas · {cs.filter(c => known.has(c.id)).length} known</p>
      <div className="rowlist">{cs.sort((a, b) => b.freq - a.freq || coursesOf(b).length - coursesOf(a).length).slice(0, 14).map(c => <Link key={c.id} className={"rowi" + (known.has(c.id) ? " known" : "")} to={ideaPath(c.id, id)}><b>{c.title}{known.has(c.id) ? " ✓" : ""}</b><p>{oneLine(c)}</p><CourseChips c={c} /></Link>)}</div></div>)}
    <p className="small" style={{ marginTop: 24 }}>{gap.length} interview ideas in this kit are not in the courses loaded so far. <Link to="/compass" style={{ color: "var(--hero)", fontWeight: 600 }}>Search</Link> for any of them.</p></section>;
}
