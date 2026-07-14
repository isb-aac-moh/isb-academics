import { ALL_TERMS } from "./options";

// URL-safe slugs for term names — "Term 4" <-> "term-4", "Block Week 1" <-> "block-week-1".
// Looked up against the fixed ALL_TERMS list rather than reversed algorithmically,
// since that's the only source of truth for what a valid term string looks like.
export function termToSlug(term: string): string {
  return term.toLowerCase().replace(/\s+/g, "-");
}

export function slugToTerm(slug: string): string | undefined {
  return ALL_TERMS.find((t) => termToSlug(t) === slug);
}
