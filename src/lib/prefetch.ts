import { startEarly } from "./queryCache";
import { loadCourses } from "../hooks/useCourses";
import { loadNavLinks } from "../hooks/useNavLinks";
import { loadDashboardPopups } from "../hooks/useDashboardPopups";
import { academicProfileKey, fetchAcademicProfile } from "../hooks/useAcademicProfile";
import { bidPlanKey, fetchBidPlan } from "../hooks/useBidPlan";
import { enrollmentsKey, fetchEnrollments } from "../hooks/useActualEnrollments";

/** Called the moment we know who is signed in, side by side with the `users` lookup rather than
    after it. Until now the page's own requests only started once that lookup came back and the
    page had mounted, so the three waits (profile, page code, page data) ran one after another.
    Only the pages most students open first are covered; any other URL just loads as before. */
export function prefetchForSignedIn(userId: string) {
  const path = window.location.pathname;
  const onTracker = path === "/" || path.startsWith("/tracker");
  const onPlanner = path.startsWith("/planner");

  void loadNavLinks();
  void loadDashboardPopups();
  if (onTracker || onPlanner) {
    void loadCourses();
    startEarly(academicProfileKey(userId), () => fetchAcademicProfile(userId));
    startEarly(bidPlanKey(userId), () => fetchBidPlan(userId));
  }
  if (onTracker) startEarly(enrollmentsKey(userId), () => fetchEnrollments(userId));
}
