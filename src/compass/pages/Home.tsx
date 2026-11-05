import { useEffect, useMemo } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import { usePostHog } from "@posthog/react";
import { coursesOf, inLens, runSearch, type Store } from "../lib/data";
import { TOPICS, topicOf } from "../lib/topics";
import { useKnown } from "../lib/known";
import { IdeaCard, SectionLabel } from "../components";
import { ask } from "../lib/ask";
import AskAnswer from "./AskAnswer";

const TRY = ["How much stock should I order?", "What is the Hook model?", "Freemium or free trial?", "How do I test an idea before building it?", "network effects"];

export default function Home({ store, lens }: { store: Store; lens: string }) {
  const [sp] = useSearchParams(); const nav = useNavigate(); const raw = sp.get("q") || ""; const q = raw.trim(); const [known] = useKnown();
  const setQ = (v: string) => { const n = new URLSearchParams(); n.set("lens", lens); if (v) n.set("q", v); nav("/compass?" + n.toString(), { replace: !!q }); };
  const all = Object.values(store.data.concepts); const taught = all.filter(c => coursesOf(c).length);
  const answer = useMemo(() => (store.ask && q.length > 1 ? ask(store.ask, q) : null), [store.ask, q]);
  const hits = !store.ask && q.length > 1 ? runSearch(store, q, lens) : [];
  const posthog = usePostHog();
  // Log when typing stops, not on every keystroke. Only the first 60 characters of the question are kept.
  useEffect(() => { if (!answer) return; const t = setTimeout(() => posthog?.capture("compass_ask", { q: q.slice(0, 60), declined: answer.declined, card: answer.declined ? null : answer.cards[0]?.id ?? null }), 800); return () => clearTimeout(t); }, [answer, q, posthog]);
  const recurring = taught.filter(c => inLens(c, lens)).sort((a, b) => coursesOf(b).length - coursesOf(a).length || b.evidence.length - a.evidence.length).slice(0, 8);
  const topicCount = (id: string) => taught.filter(c => topicOf(c) === id && inLens(c, lens)).length;
  const knownTaught = taught.filter(c => known.has(c.id)).length;
  return <>
    <p className="note" style={{ marginTop: 14 }}>Pilot preview: a first look at what Compass will do. <Link to="/compass/roadmap" style={{ color: "var(--hero)", fontWeight: 600 }}>See the roadmap →</Link></p>
    <p className="sub" style={{ font: "15px/1.6 var(--serif)", color: "var(--ink2)", maxWidth: 620, margin: "14px 0 0" }}>Ask about anything from your courses, in your own words. Get a clear answer, see how it connects, and jump straight to the class where it was taught.</p>
    <div className="searchbox"><input type="search" autoFocus placeholder="Ask anything taught at ISB, like how much stock to order" aria-label="Ask anything taught at ISB" value={raw} onChange={e => setQ(e.target.value)} /></div>
    {answer ? <AskAnswer store={store} q={q} answer={answer} lens={lens} /> : q.length > 1 ? <section>
      <SectionLabel>{hits.length ? `${hits.length} ideas for "${q}"` : `Nothing found for "${q}"`}</SectionLabel>
      {!hits.length && <p className="note">Not in the {store.data.courses.length} courses loaded so far. Try a shorter word, or another name for the idea.</p>}
      <div className="ideas">{hits.map(c => <IdeaCard key={c.id} c={c} lens={lens} />)}</div></section> : <>
      <div className="try"><span>Try</span>{TRY.map(t => <a key={t} href="#" onClick={e => { e.preventDefault(); setQ(t); }}>{t}</a>)}</div>
      <section><SectionLabel>What do you want to do?</SectionLabel>
        <div className="tiles four">
          <Link className="tile" to={`/compass/prep?lens=${lens}`}><div className="ic">◎</div><b>Prepare for interviews</b><span>The ideas Product and Consulting interviews test, and where you already learned each one.</span><i>Open a prep kit →</i></Link>
          <Link className="tile" to={`/compass/courses?lens=${lens}`}><div className="ic">▤</div><b>Revise a course</b><span>Every framework a course covered, grouped by topic, with links to the class slides in Moodle.</span><i>Pick a course →</i></Link>
          <Link className="tile" to={`/compass/topics?lens=${lens}`}><div className="ic">▦</div><b>Browse by topic</b><span>See everything taught on pricing, operations, AI and more, across all your courses.</span><i>See topics →</i></Link>
          <Link className="tile" to={`/compass/map?lens=${lens}`}><div className="ic">⌁</div><b>See how ideas connect</b><span>Pick a topic and follow what to learn first and what each idea leads to.</span><i>Open the map →</i></Link>
        </div>
        {knownTaught > 0 && <p className="small" style={{ marginTop: 10 }}>You have marked {knownTaught} of {taught.length} ideas as known.</p>}
      </section>
      <section><SectionLabel>Ideas you will meet again and again</SectionLabel>
        <div className="ideas">{recurring.map(c => <IdeaCard key={c.id} c={c} lens={lens} />)}</div></section>
      <section><SectionLabel>Browse by topic</SectionLabel>
        <div className="tiles">{TOPICS.map(t => <Link key={t.id} className="tile topic" to={`/compass/topics/${t.id}?lens=${lens}`}><b>{t.name}</b><span>{t.blurb}</span><small>{topicCount(t.id)} ideas taught</small></Link>)}</div></section>
    </>}
  </>;
}
