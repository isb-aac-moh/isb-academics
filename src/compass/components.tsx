import { Link } from "react-router-dom";
import { type Concept, coursesOf, ROLE_LABEL, type Role } from "./lib/data";
import { oneLine, topicById, topicOf } from "./lib/topics";
import { useKnown } from "./lib/known";

export const Pill = ({ role }: { role: Role }) => <span className={"pill " + role}>{ROLE_LABEL[role]}</span>;
export const SectionLabel = ({ children }: { children: React.ReactNode }) => <p className="sl">{children}</p>;
export const ideaPath = (id: string, lens: string) => `/compass/c/${encodeURIComponent(id)}?lens=${lens}`;

/** The page title style used across the product: serif, with the last word in italics. */
export function PageTitle({ lead, accent, sub }: { lead: string; accent: string; sub?: string }) {
  return <header className="ph"><h1>{lead} <em>{accent}</em></h1>{sub && <p className="sub">{sub}</p>}</header>;
}
export const CourseChips = ({ c }: { c: Concept }) => {
  const cs = coursesOf(c);
  return cs.length ? <span className="cc">{cs.map(x => <b key={x}>{x}</b>)}</span> : <span className="cc none">Not in your courses yet</span>;
};

/** One idea as a card: name, plain-English one-liner, topic, and the courses that taught it. */
export function IdeaCard({ c, lens }: { c: Concept; lens: string }) {
  const [known] = useKnown();
  return <Link className={"idea" + (known.has(c.id) ? " known" : "")} to={ideaPath(c.id, lens)}>
    <div className="it"><b>{c.title}</b>{known.has(c.id) && <span className="tick" title="You marked this as known">✓</span>}</div>
    <p>{oneLine(c)}</p>
    <div className="im"><CourseChips c={c} /><span className="topic">{topicById(topicOf(c))?.name}</span></div>
  </Link>;
}
