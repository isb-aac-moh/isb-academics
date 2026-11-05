import { useState } from "react";
import { Link } from "react-router-dom";
import { usePostHog } from "@posthog/react";
import { ideaPath, SectionLabel } from "../components";
import type { Answer, Card } from "../lib/ask";
import type { Store } from "../lib/data";

const REASONS = ["Wrong topic", "Something is wrong", "Hard to understand"];
const firstSentence = (t: string) => (t.match(/^.*?[.!?](\s|$)/)?.[0] ?? t).trim();

/** Ask for the problem in two taps. Reports go to PostHog as events, so no new table is needed yet. */
function Report({ card, q }: { card: Card; q: string }) {
  const posthog = usePostHog(); const [open, setOpen] = useState(false); const [sent, setSent] = useState(false);
  if (sent) return <p className="small" role="status">Thanks. We'll check this.</p>;
  if (!open) return <button className="link" onClick={() => setOpen(true)}>Report a problem</button>;
  return <div className="reasons" role="group" aria-label="What's wrong?">{REASONS.map(r => <button key={r} className="btn" onClick={() => { posthog?.capture("compass_report", { card: card.id, reason: r, q: q.slice(0, 60) }); setSent(true); }}>{r}</button>)}</div>;
}

function Where({ store, card }: { store: Store; card: Card }) {
  const posthog = usePostHog(); const courses = [...new Set(card.where.map(([c]) => c))];
  return <div className="where">
    <SectionLabel>Where ISB taught it</SectionLabel>
    {courses.map(code => { const course = store.byCourse[code]; const sessions = card.where.filter(([c, s]) => c === code && s).map(([, s]) => s as number);
      const link = sessions.flatMap(s => (course?.sessions.find(x => x.n === s)?.resources ?? []).filter(r => ["filewithwatermark", "resource", "folder"].includes(r.type)).slice(0, 1).map(r => ({ s, url: r.url })));
      return <p key={code}><b>{course?.name || code}</b>{sessions.length > 0 && `, session ${sessions.join(", ")}`}{link.map(l => <a key={l.url} href={l.url} target="_blank" rel="noreferrer" onClick={() => posthog?.capture("compass_source_click", { card: card.id, course: code, session: l.s })}>Open session {l.s} in Moodle</a>)}</p>; })}
  </div>;
}

/** The answer to a question: one card written from class material, or a plain "not in our material". */
export default function AskAnswer({ store, q, answer, lens }: { store: Store; q: string; answer: Answer; lens: string }) {
  const [top, ...rest] = answer.cards;
  if (answer.declined || !top) return <section className="answer none" aria-live="polite">
    <h2>Not in our material yet</h2>
    <p>We've loaded {store.data.courses.length} of 138 courses so far, so this may be taught somewhere we haven't reached.</p>
    {top && <p className="small">Closest ideas: {answer.cards.map((c, i) => <span key={c.id}>{i > 0 && ", "}<Link to={ideaPath(c.id, lens)}>{c.title}</Link></span>)}</p>}
  </section>;
  return <>
    <article className="answer" aria-live="polite">
      <h2>{top.title}</h2>
      <p className="what">{top.what}</p>
      {top.use && <><SectionLabel>When to use it</SectionLabel><p>{top.use}</p></>}
      {top.trap && <><SectionLabel>Watch out for</SectionLabel><p>{top.trap}</p></>}
      <Where store={store} card={top} />
      <div className="foot"><Link to={ideaPath(top.id, lens)}>See how it connects →</Link><Report card={top} q={q} /></div>
    </article>
    {rest.length > 0 && <section><SectionLabel>Not quite it? Try these</SectionLabel>
      <div className="ideas">{rest.map(c => <Link className="idea" key={c.id} to={ideaPath(c.id, lens)}><div className="it"><b>{c.title}</b></div><p>{firstSentence(c.what)}</p></Link>)}</div></section>}
    <p className="small" style={{ marginTop: 18 }}>Written from class material and checked against it. Open the session to see the original.</p>
  </>;
}
