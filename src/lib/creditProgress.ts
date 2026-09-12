import type { Course, ConcentrationArea, IndustrySpecialization, StudentAcademicProfile } from "../types";
import type { BidPlanEntry } from "../hooks/useBidPlan";
import { TOTAL_BID_POINTS, RESERVE_PER_REMAINING_CREDIT, TOTAL_ELECTIVE_CREDITS_REQUIRED } from "../hooks/useBidPlan";
import { isTermComplete } from "./termCalendar";

export const REQUIRED_CREDITS_PER_AREA = 6;

// A course a student has "secured" toward credit — satisfied by both a planned
// bid (BidPlanEntry) and a confirmed result (ActualEnrollment), so this math
// runs unchanged against either the Bidding Planner or the Credit Tracker.
export interface SecuredCourseEntry {
  course_id: string | null;
  term: string;
}

// Which terms/block weeks are ever biddable, and the order they display in —
// structural (ISB's bidding calendar shape), unlike the min/max credit values
// below, which are admin-editable via app_settings.term_credit_limits since
// ISB can change those term to term without a code change + redeploy.
export const BIDDABLE_TERM_ORDER = [
  "Term 4", "Term 5", "Term 6", "Term 7",
  "Block Week 1", "Block Week 2", "Block Week 3", "Block Week 4",
];

// Fallback used until app_settings.term_credit_limits loads, and to fill in
// any term the admin-edited value is missing — see useAppSettings.
export const DEFAULT_TERM_CREDIT_LIMITS: Record<string, { min: number; max: number }> = {
  "Term 4": { min: 3, max: 4 },
  "Term 5": { min: 3, max: 5 },
  "Term 6": { min: 3, max: 4 },
  "Term 7": { min: 3, max: 5 },
  "Block Week 1": { min: 0, max: 1 },
  "Block Week 2": { min: 0, max: 1 },
  "Block Week 3": { min: 0, max: 1 },
  "Block Week 4": { min: 0, max: 1 },
};

// Bidding only exists from Term 4 onward — Flexi Core (Term 2/3) and core
// courses (Term 1-4) are never bid on (Elective Bidding FAQ, Flexi Core doc:
// "there is no bidding involved in this process").
export function isBiddableTerm(term: string) {
  return BIDDABLE_TERM_ORDER.includes(term);
}

/**
 * Planned bids whose term has finished but whose outcome hasn't been logged yet
 * (BidPlanEntry.actual_points is null) — the Credit Tracker prompts these first,
 * before falling back to a blank "log a confirmed course" picker, since the plan
 * is usually right and re-typing it is wasted effort. `actual_points = 0` means
 * "resolved, didn't get it"; a real winning bid is always >= MIN_BID_PER_COURSE.
 */
export function pendingReconciliations(bidEntries: BidPlanEntry[], today: Date = new Date()): BidPlanEntry[] {
  return bidEntries.filter((e) => e.course_id && isBiddableTerm(e.term) && isTermComplete(e.term, today) && e.actual_points === null);
}

/** A student's mandatorily-converted Flexi Core courses — the only Flexi picks that count toward credit. */
function convertedFlexiCourses(profile: StudentAcademicProfile, courses: Course[]): Course[] {
  const codes = [profile.term2_converted_elective, profile.term3_converted_elective].filter((c): c is string => !!c);
  return courses.filter((c) => codes.includes(c.code));
}

/**
 * Which single concentration a cross-listed course counts toward
 * (Elective Bidding FAQ Q45: only one, student's choice — DATA_MODEL.md).
 *
 * An explicit choice wins, and may name any area the course is listed under —
 * not only the student's two targets — so a student weighing a switch can see
 * where a course would land. Picking a non-target area does mean the course
 * stops counting toward either target; ConcentrationChoice says so on screen.
 *
 * With no explicit choice, the fallback is unchanged: whichever target
 * concentration the course overlaps, in the order the student listed them.
 */
export function chosenConcentrationFor(course: Course, profile: StudentAcademicProfile): ConcentrationArea | null {
  const chosen = profile.cross_listed_concentration_choices[course.code];
  if (chosen && course.concentration_areas.includes(chosen)) return chosen;
  const overlapping = profile.target_concentrations.filter((a) => course.concentration_areas.includes(a));
  return overlapping[0] ?? course.concentration_areas[0] ?? null;
}

/** Courses a student already has "in hand" toward an area: a converted Flexi elective + planned bid entries. */
export function coursesCountingToward(
  area: ConcentrationArea | IndustrySpecialization,
  kind: "concentration" | "specialization",
  profile: StudentAcademicProfile,
  courses: Course[],
  bidEntries: SecuredCourseEntry[]
): Course[] {
  // Specialization overlap with a concentration is explicitly allowed (up to 3
  // credits, FAQ Q47) — only concentration-vs-concentration cross-listing is exclusive.
  const matches = (c: Course) =>
    kind === "concentration"
      ? chosenConcentrationFor(c, profile) === area
      : c.industry_specializations.includes(area as IndustrySpecialization);

  const convertedCodes = new Set(convertedFlexiCourses(profile, courses).map((c) => c.code));
  const plannedCourseIds = new Set(bidEntries.filter((e) => isBiddableTerm(e.term)).map((e) => e.course_id));

  return courses.filter((c) => matches(c) && (convertedCodes.has(c.code) || plannedCourseIds.has(c.id)));
}

/** Total elective credits secured toward the 18-credit graduation requirement: converted Flexi + planned bid entries. */
export function totalElectiveCreditsSecured(profile: StudentAcademicProfile, courses: Course[], bidEntries: SecuredCourseEntry[]): number {
  const convertedCredits = convertedFlexiCourses(profile, courses).reduce((sum, c) => sum + Number(c.credits), 0);
  const plannedCredits = bidEntries
    .filter((e) => isBiddableTerm(e.term))
    .reduce((sum, e) => {
      const course = courses.find((c) => c.id === e.course_id);
      return sum + (course ? Number(course.credits) : 0);
    }, 0);
  return convertedCredits + plannedCredits;
}

/**
 * The bid-points budget ledger: reserve rule (100 pts/remaining elective credit,
 * FAQ Q5/Elective Course Registration doc) computed against real secured credits
 * rather than a 1-entry-=-1-credit approximation, plus Exchange points already
 * spent — International/Inter-Campus Exchange draw from the same 4,500-point
 * pool as regular elective bidding (FAQ Q4, Exchange PPT "Bid Points").
 *
 * `pointsAvailable` tracks the full 4,500 pool directly (total minus what's
 * actually spent) so it moves with every planned course. `remainingPoints`
 * nets the reserve out too — it goes negative once a plan dips into the
 * points ISB wants held back for still-unsecured credits, which is a soft
 * warning, not a hard cap (a student can still submit that plan).
 */
export function computeBidBudget(profile: StudentAcademicProfile, courses: Course[], bidEntries: SecuredCourseEntry[], pointsPlanned: number) {
  const creditsSecured = totalElectiveCreditsSecured(profile, courses, bidEntries);
  const reserved = Math.max(0, TOTAL_ELECTIVE_CREDITS_REQUIRED - creditsSecured) * RESERVE_PER_REMAINING_CREDIT;
  const exchangePointsUsed = (profile.international_exchange_points_used ?? 0) + (profile.inter_campus_exchange_points_used ?? 0);
  const pointsAvailable = TOTAL_BID_POINTS - pointsPlanned - exchangePointsUsed;
  const remainingPoints = pointsAvailable - reserved;
  return { creditsSecured, reserved, exchangePointsUsed, pointsAvailable, remainingPoints };
}

export function creditsCountingToward(
  area: ConcentrationArea | IndustrySpecialization,
  kind: "concentration" | "specialization",
  profile: StudentAcademicProfile,
  courses: Course[],
  bidEntries: SecuredCourseEntry[]
): number {
  // credits is numeric in Postgres — PostgREST may serialize it as a string, so coerce explicitly.
  return coursesCountingToward(area, kind, profile, courses, bidEntries).reduce((sum, c) => sum + Number(c.credits), 0);
}

/** Every course matching an area — added-to-plan ones included, never hidden once picked. */
export function allCoursesForArea(
  area: ConcentrationArea | IndustrySpecialization,
  kind: "concentration" | "specialization",
  courses: Course[]
): Course[] {
  const matches = (c: Course) =>
    kind === "concentration"
      ? c.concentration_areas.includes(area as ConcentrationArea)
      : c.industry_specializations.includes(area as IndustrySpecialization);
  return courses.filter(matches);
}

// Which term(s)/block week(s) are the current bidding round — admin-editable via
// app_settings (see useAppSettings) rather than hardcoded, since the round changes
// on ISB's own schedule and shouldn't require a code change + redeploy to update.
export function isLiveNow(term: string, liveBiddingTerms: string[]) {
  return liveBiddingTerms.includes(term);
}
