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
