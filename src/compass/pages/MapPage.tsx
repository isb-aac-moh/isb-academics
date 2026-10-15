import { useMemo, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { type Store, coursesOf, inLens } from "../lib/data";
import { coTaught } from "../lib/graph";

const W = 1000, H = 640, PAL = ["#1C3A6E", "#C47D0E", "#2E7D5B", "#8A3FA0", "#B23A48", "#2A7FA8"];

// Small force layout: repel everything, pull linked ideas together, keep inside the frame.
function layout(ids: string[], edges: [number, number][]) {
  const n = ids.length, x = new Float32Array(n), y = new Float32Array(n), vx = new Float32Array(n), vy = new Float32Array(n);
  for (let i = 0; i < n; i++) { const a = i * 2.399963; const r = 18 * Math.sqrt(i + 1); x[i] = W / 2 + r * Math.cos(a); y[i] = H / 2 + r * Math.sin(a); }
  for (let it = 0; it < 260; it++) {
    const cool = 1 - it / 260;
    for (let i = 0; i < n; i++) for (let j = i + 1; j < n; j++) {
      const dx = x[i] - x[j], dy = y[i] - y[j], d2 = dx * dx + dy * dy + 0.01; if (d2 > 40000) continue;
      const f = 1800 / d2, d = Math.sqrt(d2); vx[i] += dx / d * f; vy[i] += dy / d * f; vx[j] -= dx / d * f; vy[j] -= dy / d * f;
    }
    for (const [a, b] of edges) { const dx = x[b] - x[a], dy = y[b] - y[a], d = Math.sqrt(dx * dx + dy * dy) + 0.01, f = (d - 30) * 0.03; vx[a] += dx / d * f; vy[a] += dy / d * f; vx[b] -= dx / d * f; vy[b] -= dy / d * f; }
    for (let i = 0; i < n; i++) { vx[i] += (W / 2 - x[i]) * 0.006; vy[i] += (H / 2 - y[i]) * 0.006 * 1.5; x[i] = Math.min(W - 14, Math.max(14, x[i] + vx[i] * 0.6 * cool)); y[i] = Math.min(H - 14, Math.max(14, y[i] + vy[i] * 0.6 * cool)); vx[i] *= 0.6; vy[i] *= 0.6; }
  }
  return { x, y };
}

export default function MapPage({ store, lens }: { store: Store; lens: string }) {
  const nav = useNavigate(); const [hover, setHover] = useState<string | null>(null); const [course, setCourse] = useState("all");
  const g = useMemo(() => {
    const list = Object.values(store.data.concepts).filter(c => coursesOf(c).length && inLens(c, lens) && (course === "all" || coursesOf(c).includes(course)));
    const ids = list.map(c => c.id), idx = new Map(ids.map((id, i) => [id, i])); const co = coTaught(store); const seen = new Set<string>(); const edges: [number, number][] = []; const kinds: boolean[] = [];
    const add = (a: string, b: string) => { const i = idx.get(a), j = idx.get(b); if (i === undefined || j === undefined) return; const k = i < j ? `${i}-${j}` : `${j}-${i}`; if (!seen.has(k)) { seen.add(k); edges.push([i, j]); } };
    for (const c of list) { for (const r of c.rel) add(c.id, r.to); Object.entries(co[c.id] || {}).sort((a, b) => b[1] - a[1]).slice(0, 3).forEach(([o]) => add(c.id, o)); }
    const deg = new Map<number, number>(); edges.forEach(([a, b]) => { deg.set(a, 1); deg.set(b, 1); });
    const keep = list.map((_, i) => i).filter(i => deg.has(i)); const remap = new Map(keep.map((o, n) => [o, n]));
    const e2 = edges.map(([a, b]) => [remap.get(a)!, remap.get(b)!] as [number, number]); const l2 = keep.map(i => list[i]);
    const { x, y } = layout(l2.map(c => c.id), e2); return { list: l2, idx, edges: e2, x, y, kinds, hidden: list.length - l2.length };
  }, [store, lens, course]);
  const codes = store.data.courses.map(c => c.code); const colour = (c: typeof g.list[number]) => PAL[codes.indexOf(coursesOf(c)[0]) % PAL.length];
  const hot = hover ? new Set([hover, ...g.edges.flatMap(([a, b]) => g.list[a].id === hover ? [g.list[b].id] : g.list[b].id === hover ? [g.list[a].id] : [])]) : null;
  return <section><h1 className="h2">Map of everything taught</h1>
    <p className="note">Each dot is an idea taught in your courses. Lines join ideas that build on each other or were covered in the same session. Big dots are taught in several courses. Hover to see neighbours, click to open.</p>
    <div className="chips" style={{ padding: "0 0 10px" }}><button className={"chip2 " + (course === "all" ? "teaches" : "")} onClick={() => setCourse("all")}>All courses</button>
      {codes.map((c, i) => <button key={c} className={"chip2 " + (course === c ? "teaches" : "")} onClick={() => setCourse(c)}><span className="dot" style={{ background: PAL[i % PAL.length] }} />{c}</button>)}</div>
    <svg className="map" viewBox={`0 0 ${W} ${H}`} role="img" aria-label="Map of ideas">
      {g.edges.map(([a, b], i) => { const on = !hot || (hot.has(g.list[a].id) && hot.has(g.list[b].id) && (g.list[a].id === hover || g.list[b].id === hover)); return <line key={i} x1={g.x[a]} y1={g.y[a]} x2={g.x[b]} y2={g.y[b]} className={"me " + (hot ? (on ? "hi" : "lo") : "")} />; })}
      {g.list.map((c, i) => { const nc = coursesOf(c).length; const dim = hot && !hot.has(c.id); const label = hover === c.id || nc >= 3 || (hot && hot.has(c.id));
        return <g key={c.id} opacity={dim ? 0.15 : 1} onMouseEnter={() => setHover(c.id)} onMouseLeave={() => setHover(null)} onClick={() => nav(`/compass/c/${encodeURIComponent(c.id)}?lens=${lens}`)} style={{ cursor: "pointer" }}>
          <circle cx={g.x[i]} cy={g.y[i]} r={4 + nc * 2.2} fill={colour(c)} stroke="var(--surface)" strokeWidth={1.5} />
          {label && <text x={g.x[i] + 8 + nc * 2} y={g.y[i] + 4} className="ml">{c.title.length > 30 ? c.title.slice(0, 29) + "…" : c.title}</text>}</g>; })}
    </svg>
    <p className="small">{g.list.length} connected ideas, {g.edges.length} connections. {g.hidden} more ideas were taught but have no links yet; find them with search. <Link to={`/compass?lens=${lens}`}>Back to search</Link></p></section>;
}
