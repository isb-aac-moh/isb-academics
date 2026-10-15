import { Link } from "react-router-dom";
import { type Concept, type Store, coursesOf } from "./lib/data";
import { neighbours } from "./lib/graph";
import { ideaPath } from "./components";
import { topicOf } from "./lib/topics";

const SHOW = 6;

/** What comes before, what comes after, and what was taught alongside. Plain page layout, so names
    wrap instead of being cut off and the block fits any width. The Map is where to explore further. */
export default function ConceptGraph({ store, c, lens }: { store: Store; c: Concept; lens: string }) {
  const n = neighbours(store, c, 40);
  if (!n.up.length && !n.down.length && !n.with.length) return <p className="note">No connections found yet for this idea.</p>;
  const mapLink = `/compass/map?topic=${topicOf(c)}&node=${encodeURIComponent(c.id)}&lens=${lens}`;
  const list = (items: Concept[], kind: "u" | "d", empty: string) => items.length === 0 ? <p className="small">{empty}</p> : <>
    <ul>{items.slice(0, SHOW).map(k => <li key={k.id}><Link className={"cn " + kind + (coursesOf(k).length ? " taught" : "")} to={ideaPath(k.id, lens)}>{k.title}{coursesOf(k).length ? "" : <small> · not covered in class yet</small>}</Link></li>)}</ul>
    {items.length > SHOW && <Link className="more" to={mapLink}>+{items.length - SHOW} more on the map</Link>}</>;
  return <figure className="flow">
    <div className="flowrow">
      <div><p className="fl">Learn first</p>{list(n.up, "u", "Nothing to learn first. This is a starting point.")}</div>
      <div className="mid"><span className="arrow" aria-hidden>→</span><div className="me2">{c.title}</div><span className="arrow" aria-hidden>→</span></div>
      <div><p className="fl">Leads to</p>{list(n.down, "d", "Nothing builds directly on this yet.")}</div>
    </div>
    {n.with.length > 0 && <div className="alongside"><p className="fl">Taught in the same session</p>
      <div className="chips">{n.with.map(w => <Link key={w.c.id} className="chip2" to={ideaPath(w.c.id, lens)}>{w.c.title}</Link>)}</div></div>}
    <figcaption>Outlined ideas were taught at ISB. <Link to={mapLink} style={{ color: "var(--hero)", fontWeight: 600 }}>Explore this on the map →</Link></figcaption>
  </figure>;
}
