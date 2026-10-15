import type { Concept, Store } from "./data";

export interface Nbrs { up: Concept[]; down: Concept[]; with: { c: Concept; n: number }[] }
const cache = new WeakMap<Store, Record<string, Record<string, number>>>();

// Concepts taught in the same session of the same course, counted by how many sessions they share.
export function coTaught(s: Store): Record<string, Record<string, number>> {
  let m = cache.get(s); if (m) return m; m = {};
  for (const course of s.data.courses) for (const ses of course.sessions) {
    const ids = ses.concepts.filter(x => x.role === "teaches" && s.data.concepts[x.id]).map(x => x.id).slice(0, 25);
    for (const a of ids) for (const b of ids) if (a !== b) { (m[a] ||= {}); m[a][b] = (m[a][b] || 0) + 1; }
  }
  cache.set(s, m); return m;
}
export function neighbours(s: Store, c: Concept, max = 6): Nbrs {
  const up = c.rel.map(r => s.data.concepts[r.to]).filter(Boolean).slice(0, max);
  const down = (s.reverse[c.id] || []).map(i => s.data.concepts[i]).slice(0, max);
  const co = Object.entries(coTaught(s)[c.id] || {}).sort((a, b) => b[1] - a[1]).slice(0, 8)
    .filter(([i]) => !up.some(u => u.id === i) && !down.some(d => d.id === i)).map(([i, n]) => ({ c: s.data.concepts[i], n }));
  return { up, down, with: co };
}

export const NW = 168, NH = 46;
export interface Placed { id: string; x: number; y: number }
export interface Tree { nodes: Placed[]; loose: Placed[]; w: number; h: number; looseY: number }

/** Ideas that sit on the same slide as another idea. A weaker link than a prerequisite, used so ideas
    nobody has linked yet still land next to the ideas they were taught with. Capped so a catch-all slide adds nothing. */
export function sharedSlide(s: Store): Record<string, Set<string>> {
  const byPassage: Record<string, string[]> = {}; const out: Record<string, Set<string>> = {};
  for (const c of Object.values(s.data.concepts)) for (const e of c.evidence) if (e.passage) (byPassage[e.passage] ||= []).push(c.id);
  for (const ids of Object.values(byPassage)) if (ids.length > 1 && ids.length <= 6) for (const a of ids) for (const b of ids) if (a !== b) (out[a] ||= new Set()).add(b);
  return out;
}

/** Top to bottom: what you learn first on top, what it unlocks below. Wide layers wrap onto extra
    rows so a topic stays compact. `dEdges` are [prerequisite, dependent]; `uEdges` are weaker, undirected links. */
export function treeLayout(ids: string[], dEdges: [string, string][], uEdges: [string, string][], perRow: number, gx = 14, gy = 22): Tree {
  const set = new Set(ids); const de = dEdges.filter(([a, b]) => set.has(a) && set.has(b) && a !== b); const ue = uEdges.filter(([a, b]) => set.has(a) && set.has(b) && a !== b);
  const linked = new Set([...de, ...ue].flat()); const nodes = ids.filter(i => linked.has(i)); const loose = ids.filter(i => !linked.has(i));
  const layer: Record<string, number> = Object.fromEntries(nodes.map(i => [i, 0]));
  for (let pass = 0; pass < 8; pass++) { let moved = false; for (const [a, b] of de) if (layer[b] < layer[a] + 1 && layer[a] + 1 <= 6) { layer[b] = layer[a] + 1; moved = true; } if (!moved) break; }
  const hasD = new Set(de.flat());
  for (const [a, b] of ue) { if (!hasD.has(a) && hasD.has(b)) layer[a] = layer[b]; else if (!hasD.has(b) && hasD.has(a)) layer[b] = layer[a]; }
  const rows: string[][] = []; nodes.forEach(i => (rows[layer[i]] ||= []).push(i));
  const adj: Record<string, string[]> = {}; for (const [a, b] of [...de, ...ue]) { (adj[a] ||= []).push(b); (adj[b] ||= []).push(a); }
  const pos: Record<string, number> = {}; rows.forEach(r => r && r.forEach((id, k) => (pos[id] = k)));
  for (let sweep = 0; sweep < 4; sweep++) for (let k = 0; k < rows.length; k++) { const r = rows[sweep % 2 ? rows.length - 1 - k : k]; if (!r) continue;
    const bary = (id: string) => { const n = (adj[id] || []).filter(x => layer[x] !== layer[id]); return n.length ? n.reduce((t, x) => t + pos[x], 0) / n.length : pos[id]; };
    r.sort((x, y) => bary(x) - bary(y)); r.forEach((id, j) => (pos[id] = j)); }
  const widest = Math.min(perRow, Math.max(1, ...Array.from(rows, r => (r ? r.length : 0)), loose.length ? Math.min(loose.length, perRow) : 0));
  const w = widest * (NW + gx) - gx; const placed: Placed[] = []; let y = 0;
  const lay = (list: string[], out: Placed[]) => { for (let i = 0; i < list.length; i += perRow) { const chunk = list.slice(i, i + perRow); const x0 = (w - (chunk.length * (NW + gx) - gx)) / 2; chunk.forEach((id, j) => out.push({ id, x: x0 + j * (NW + gx), y })); y += NH + gy; } };
  rows.forEach(r => { if (r) { lay(r, placed); y += 8; } });
  const looseP: Placed[] = []; let looseY = y; if (loose.length) { y += 22; looseY = y - 18; lay(loose, looseP); }
  return { nodes: placed, loose: looseP, w, h: Math.max(0, y - gy), looseY };
}
/** Everything upstream (learn first) and downstream (leads to) of one idea. edges are [prerequisite, dependent]. */
export function reach(id: string, edges: [string, string][]) {
  const walk = (dir: 0 | 1) => { const seen = new Set<string>(); const st = [id]; while (st.length) { const u = st.pop()!; for (const e of edges) if (e[dir === 0 ? 1 : 0] === u && !seen.has(e[dir])) { seen.add(e[dir]); st.push(e[dir]); } } return seen; };
  return { up: walk(0), down: walk(1) };
}
