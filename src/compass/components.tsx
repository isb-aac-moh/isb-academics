import { Link } from "react-router-dom";
import { type Concept, coursesOf, ROLE_LABEL, type Role } from "./lib/data";
export const Pill = ({ role }: { role: Role }) => <span className={"pill " + role}>{ROLE_LABEL[role]}</span>;
export function ConceptRow({ c, lens }: { c: Concept; lens: string }) {
  const cs = coursesOf(c); const ev = c.evidence.length;
  return <Link className="row" to={`/compass/c/${encodeURIComponent(c.id)}?lens=${lens}`}>
    <div className="rt"><b>{c.title}</b><span className="tags">{c.lenses.filter(l => l !== "general").map(l => <em key={l}>{l}</em>)}</span></div>
    <div className="rs">{c.obj || c.q || c.definition || ""}</div>
    <div className="rm">{ev ? `Taught in ${cs.join(", ")} · ${ev} ${ev === 1 ? "passage" : "passages"}` : "Not found in the courses loaded so far"}</div>
  </Link>;
}
