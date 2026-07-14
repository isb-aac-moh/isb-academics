import type { Course, ConcentrationArea, IndustrySpecialization, StudentAcademicProfile } from "../types";
import type { BidPlanEntry } from "../hooks/useBidPlan";

export const REQUIRED_CREDITS_PER_AREA = 6;

/** Courses a student already has "in hand" toward an area: completed Flexi Core picks + planned bid entries. */
export function coursesCountingToward(
  area: ConcentrationArea | IndustrySpecialization,
  kind: "concentration" | "specialization",
  profile: StudentAcademicProfile,
  courses: Course[],
  bidEntries: BidPlanEntry[]
): Course[] {
  const matches = (c: Course) =>
    kind === "concentration"
      ? c.concentration_areas.includes(area as ConcentrationArea)
      : c.industry_specializations.includes(area as IndustrySpecialization);

  const completedCodes = new Set([...profile.completed_term2_flexi, ...profile.completed_term3_flexi]);
  const plannedCourseIds = new Set(bidEntries.map((e) => e.course_id));

  return courses.filter((c) => matches(c) && (completedCodes.has(c.code) || plannedCourseIds.has(c.id)));
}

export function creditsCountingToward(
  area: ConcentrationArea | IndustrySpecialization,
  kind: "concentration" | "specialization",
  profile: StudentAcademicProfile,
  courses: Course[],
  bidEntries: BidPlanEntry[]
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

export const LIVE_NOW_TERMS = ["Block Week 1", "Block Week 2"];
export function isLiveNow(term: string) {
  return LIVE_NOW_TERMS.includes(term);
}
