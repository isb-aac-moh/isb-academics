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

export interface Laid { id: string; x: number; y: number; layer: number }
export const NODE_W = 196, NODE_H = 50;
/** Columns left to right: what you learn first on the left, what it unlocks on the right.
    edges are [prerequisite, dependent]. Ideas with no link inside the set come back as `loose`. */
export function layered(ids: string[], edges: [string, string][]) {
  const set = new Set(ids); const es = edges.filter(([a, b]) => set.has(a) && set.has(b) && a !== b);
  const linked = new Set(es.flat()); const nodes = ids.filter(i => linked.has(i)); const loose = ids.filter(i => !linked.has(i));
  const layer: Record<string, number> = Object.fromEntries(nodes.map(i => [i, 0]));
  for (let pass = 0; pass < 8; pass++) { let moved = false; for (const [a, b] of es) if (layer[b] < layer[a] + 1 && layer[a] + 1 <= 6) { layer[b] = layer[a] + 1; moved = true; } if (!moved) break; }
  const cols: string[][] = []; nodes.forEach(i => (cols[layer[i]] ||= []).push(i));
  const pos: Record<string, number> = {};
  cols.forEach(c => c && c.forEach((id, i) => (pos[id] = i)));
  const nb = (id: string, dir: 1 | -1) => es.filter(([a, b]) => (dir === 1 ? b === id : a === id)).map(([a, b]) => (dir === 1 ? a : b));
  for (let sweep = 0; sweep < 4; sweep++) for (let k = 0; k < cols.length; k++) { const c = cols[sweep % 2 ? cols.length - 1 - k : k]; if (!c) continue;
    const dir = sweep % 2 ? -1 : 1; const bary = (id: string) => { const n = nb(id, dir); return n.length ? n.reduce((s, x) => s + pos[x], 0) / n.length : pos[id]; };
    c.sort((x, y) => bary(x) - bary(y)); c.forEach((id, i) => (pos[id] = i)); }
  const GX = 64, GY = 12, tallest = Math.max(1, ...cols.map(c => (c ? c.length : 0)));
  const laid: Laid[] = []; cols.forEach((c, l) => c && c.forEach((id, i) => laid.push({ id, layer: l, x: l * (NODE_W + GX), y: i * (NODE_H + GY) + ((tallest - c.length) * (NODE_H + GY)) / 2 })));
  const width = Math.max(0, cols.length * (NODE_W + GX) - GX), height = tallest * (NODE_H + GY) - GY;
  return { laid, loose, edges: es, width, height };
}
/** Everything upstream (learn first) and downstream (leads to) of one idea, within the given edges. */
export function reach(id: string, edges: [string, string][]) {
  const walk = (dir: 0 | 1) => { const seen = new Set<string>(); const st = [id]; while (st.length) { const u = st.pop()!; for (const e of edges) if (e[dir === 0 ? 1 : 0] === u && !seen.has(e[dir])) { seen.add(e[dir]); st.push(e[dir]); } } return seen; };
  return { up: walk(0), down: walk(1) };
}
