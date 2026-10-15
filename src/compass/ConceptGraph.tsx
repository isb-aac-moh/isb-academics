import { useNavigate } from "react-router-dom";
import { type Concept, type Store, coursesOf } from "./lib/data";
import { neighbours } from "./lib/graph";

const W = 760, ROW = 40;
const trim = (t: string) => t.length > 26 ? t.slice(0, 25) + "…" : t;

export default function ConceptGraph({ store, c, lens }: { store: Store; c: Concept; lens: string }) {
  const nav = useNavigate(); const n = neighbours(store, c);
  if (!n.up.length && !n.down.length && !n.with.length) return <p className="note">No connections found yet for this idea.</p>;
  const rows = Math.max(n.up.length, n.down.length, 1);
  const midY = 30 + rows * ROW / 2, withY = 30 + rows * ROW + 50;
  const H = n.with.length ? withY + 70 : 30 + rows * ROW + 20;
  const go = (id: string) => nav(`/compass/c/${encodeURIComponent(id)}?lens=${lens}`);
  const node = (x: number, y: number, k: Concept, cls: string, onTaught = coursesOf(k).length > 0) =>
    <g key={k.id + cls} className={`gn ${cls} ${onTaught ? "taught" : ""}`} transform={`translate(${x},${y})`} onClick={() => go(k.id)} tabIndex={0} role="link" aria-label={k.title} onKeyDown={e => e.key === "Enter" && go(k.id)}>
      <rect x={-92} y={-15} width={184} height={30} rx={15} /><text textAnchor="middle" dy="4">{trim(k.title)}</text><title>{k.title}</title></g>;
  const curve = (x1: number, y1: number, x2: number, y2: number, dash = false) => <path key={`${x1}${y1}${x2}${y2}`} className={dash ? "ge dash" : "ge"} d={`M${x1},${y1} C${(x1 + x2) / 2},${y1} ${(x1 + x2) / 2},${y2} ${x2},${y2}`} />;
  const upY = (i: number) => 30 + (i + 0.5) * ROW * rows / n.up.length, dnY = (i: number) => 30 + (i + 0.5) * ROW * rows / n.down.length;
  return <figure className="graph"><svg viewBox={`0 0 ${W} ${H}`} role="group" aria-label={`Connections for ${c.title}`}>
    <text className="gl" x={110} y={16} textAnchor="middle">Learn first</text><text className="gl" x={W / 2} y={16} textAnchor="middle">This idea</text><text className="gl" x={W - 110} y={16} textAnchor="middle">Leads to</text>
    {n.up.map((_k, i) => curve(202, upY(i), W / 2 - 92, midY))}{n.down.map((_k, i) => curve(W / 2 + 92, midY, W - 202, dnY(i)))}
    {n.with.map((_w, i) => curve(W / 2, midY + 15, 70 + i * ((W - 140) / Math.max(n.with.length - 1, 1)), withY - 15, true))}
    {n.up.map((k, i) => node(110, upY(i), k, "up"))}{n.down.map((k, i) => node(W - 110, dnY(i), k, "down"))}
    <g className="gn center" transform={`translate(${W / 2},${midY})`}><rect x={-92} y={-17} width={184} height={34} rx={17} /><text textAnchor="middle" dy="4">{trim(c.title)}</text></g>
    {n.with.length > 0 && <text className="gl" x={W / 2} y={withY - 28} textAnchor="middle">Taught in the same session</text>}
    {n.with.map((w, i) => node(70 + i * ((W - 140) / Math.max(n.with.length - 1, 1)), withY + 8, w.c, "with"))}
  </svg>
  <figcaption>Filled outline = taught at ISB. Click any idea to move there. Dashed lines mean "covered in the same class session", solid lines mean "builds on".</figcaption></figure>;
}
