// Term date ranges for the Class of 2027 cohort, from ISB's official
// "Long Calendar PGP Co'27" (tentative academic calendar 2026-27).
// This is specific to one cohort/year — when a future batch's calendar is
// available, update these ranges (or replace with a per-cohort source) rather
// than assuming they roll forward automatically.
import type { TermCode } from "../types";

const TERM_DATE_RANGES: Record<TermCode, { start: string; end: string }> = {
  "Term 1": { start: "2026-04-20", end: "2026-05-31" },
  "Term 2": { start: "2026-06-01", end: "2026-07-12" },
  "Term 3": { start: "2026-07-13", end: "2026-08-23" },
  "Block Week 1": { start: "2026-08-24", end: "2026-08-30" },
  "Block Week 2": { start: "2026-08-31", end: "2026-09-06" },
  "Term 4": { start: "2026-09-07", end: "2026-10-18" },
  "Term 5": { start: "2026-10-19", end: "2026-11-29" },
  "Term 6": { start: "2026-12-21", end: "2027-01-31" },
  "Block Week 3": { start: "2027-02-01", end: "2027-02-07" },
  "Block Week 4": { start: "2027-02-08", end: "2027-02-14" },
  "Term 7": { start: "2027-02-15", end: "2027-03-28" },
};

// Returns the term code whose date range contains today, or null if today
// falls in a gap between terms (breaks, placement window, orientation).
export function getCurrentTermCode(today: Date = new Date()): TermCode | null {
  const todayStr = today.toISOString().slice(0, 10);
  for (const [term, range] of Object.entries(TERM_DATE_RANGES)) {
    if (todayStr >= range.start && todayStr <= range.end) return term as TermCode;
  }
  return null;
}
