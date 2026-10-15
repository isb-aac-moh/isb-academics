import { Link, useSearchParams } from "react-router-dom";
import { coursesOf, inLens, runSearch, type Store, LENSES } from "../lib/data";
import { ConceptRow } from "../components";

export default function Home({ store, lens }: { store: Store; lens: string }) {
  const [sp] = useSearchParams(); const q = (sp.get("q") || "").trim();
  if (q.length > 1) {
    const hits = runSearch(store, q, lens);
    return <section><h2 className="h2">{hits.length ? `${hits.length} ideas for "${q}"` : `Nothing found for "${q}"`}</h2>
      {!hits.length && <p className="note">Not in the {store.data.courses.length} courses loaded so far. Try a shorter word, or a different name for the idea.</p>}
      <div className="list">{hits.map(c => <ConceptRow key={c.id} c={c} lens={lens} />)}</div></section>;
  }
  const multi = Object.values(store.data.concepts).filter(c => coursesOf(c).length >= 2 && inLens(c, lens))
    .sort((a, b) => coursesOf(b).length - coursesOf(a).length || b.evidence.length - a.evidence.length).slice(0, 12);
  const lensInfo = LENSES.find(l => l.id === lens)!;
  return <>
    <section className="hero"><h1>Find where ISB taught it</h1><p>Search any idea. See every course and session that covered it, how it connects, and open the slides in Moodle.</p></section>
    {(lens === "product" || lens === "consulting") && <Link className="lenscard" to={`/compass/lens/${lens}`}><b>{lensInfo.name} prep kit</b><span>{lensInfo.blurb}</span><i>Open the kit →</i></Link>}
    <section><h2 className="h2">Taught across several courses</h2>
      <div className="list">{multi.map(c => <ConceptRow key={c.id} c={c} lens={lens} />)}</div></section>
    <section><h2 className="h2">Browse by course</h2>
      <div className="grid">{store.data.courses.map(c => { const n = c.sessions.filter(s => s.concepts.length).length; return <Link key={c.code} className="card" to={`/compass/course/${c.code}?lens=${lens}`}><b>{c.name}</b><span>{c.code} · {n} sessions mapped</span></Link>; })}</div></section>
  </>;
}
