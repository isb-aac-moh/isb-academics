import MiniSearch from "minisearch";
import { supabase } from "../../lib/supabase";

export type Role = "teaches" | "applies" | "mentions";
export interface Evidence { course: string; session: number | null; kind: string; pages: [number, number]; role: Role; why: string; summary: string; passage: string }
export interface Concept {
  id: string; title: string; aliases: string[]; lenses: string[]; obj: string; q: string; module: Record<string, string>;
  freq: number; level: number | null; rel: { to: string; type: string; why?: string }[]; evidence: Evidence[]; isNew?: boolean; definition?: string;
  know?: { what: string; use: string; trap: string; ask: string };
}
export interface Resource { name: string; type: string; url: string }
export interface Session { n: number; title: string; resources: Resource[]; concepts: { id: string; role: Role }[] }
export interface Course { code: string; name: string; professor?: string; sessions: Session[] }
export interface Dataset { meta: { built: string; counts: Record<string, number> }; courses: Course[]; concepts: Record<string, Concept> }

export const LENSES = [
  { id: "all", name: "Everything", blurb: "All ideas across your courses" },
  { id: "product", name: "Product", blurb: "What product interviews test, and where ISB taught it" },
  { id: "consulting", name: "Consulting", blurb: "What case interviews test, and where ISB taught it" },
  { id: "revision", name: "Revision", blurb: "Revise by course and session" },
] as const;

export const ROLE_LABEL: Record<Role, string> = { teaches: "Taught", applies: "Applied", mentions: "Mentioned" };
export const KIND_LABEL: Record<string, string> = { slides: "Slides", slides_md: "Slides", transcript: "Class discussion", outline: "Course outline" };

export interface Store {
  data: Dataset; search: MiniSearch<Concept>; reverse: Record<string, string[]>; byCourse: Record<string, Course>;
}
// Production reads the private "compass" bucket (signed-in students only). Local dev can drop the
// file at public/compass-dev.json (gitignored) so the section works without touching Supabase.
async function fetchDataset(): Promise<Dataset> {
  if (import.meta.env.DEV) { const r = await fetch("/compass-dev.json"); if (r.ok) return r.json(); }
  const { data: blob, error } = await supabase.storage.from("compass").download("compass.json");
  if (error || !blob) throw new Error("data");
  return JSON.parse(await blob.text());
}
let cache: Promise<Store> | null = null;
export function loadStore(): Promise<Store> {
  if (!cache) cache = fetchDataset().then((data: Dataset) => {
    const list = Object.values(data.concepts);
    const search = new MiniSearch<Concept>({
      fields: ["title", "aliasText", "obj", "q", "summaryText"], storeFields: ["id"],
      extractField: (c, f) => f === "aliasText" ? c.aliases.join(" ") : f === "summaryText" ? c.evidence.map(e => e.summary).join(" ") : (c as unknown as Record<string, string>)[f] ?? "",
      searchOptions: { boost: { title: 4, aliasText: 3, obj: 1, q: 1, summaryText: 1 }, prefix: true, fuzzy: 0.2, combineWith: "AND" },
    });
    search.addAll(list);
    const reverse: Record<string, string[]> = {};
    for (const c of list) for (const r of c.rel) if (data.concepts[r.to]) (reverse[r.to] ||= []).push(c.id);
    return { data, search, reverse, byCourse: Object.fromEntries(data.courses.map(c => [c.code, c])) };
  });
  return cache;
}
export const coursesOf = (c: Concept) => [...new Set(c.evidence.map(e => e.course))];
export const inLens = (c: Concept, lens: string) => lens === "all" || lens === "revision" || c.lenses.includes(lens) || c.lenses.includes("general");
export function runSearch(s: Store, q: string, lens: string): Concept[] {
  const hits = s.search.search(q).map(h => ({ c: s.data.concepts[h.id as string], score: h.score })).filter(x => x.c && inLens(x.c, lens));
  hits.sort((a, b) => (b.score * (1 + 0.35 * Math.min(coursesOf(b.c).length, 3))) - (a.score * (1 + 0.35 * Math.min(coursesOf(a.c).length, 3))));
  return hits.slice(0, 40).map(h => h.c);
}
