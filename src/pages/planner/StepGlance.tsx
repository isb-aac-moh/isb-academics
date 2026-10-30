/**
 * A dedicated step, not folded into "Your Plan" — the "what does my term
 * actually look like" view: grading DNA, exam load, workload profile, and the
 * full brief per course.
 *
 * Shows only the current term, i.e. the admin's "Live bidding round" setting
 * (app_settings.live_bidding_terms), with every course offered in it listed so
 * students can compare before adding. Other terms never show here.
 */
import { COLOR, FONT } from "../../lib/theme";
import { BIDDABLE_TERM_ORDER } from "../../lib/creditProgress";
import type { Course, CourseGradingProfile } from "../../types";
import type { BidPlanEntry } from "../../hooks/useBidPlan";
import TermGlance from "./TermGlance";

const TERM_ORDER = BIDDABLE_TERM_ORDER;

interface Props {
  courses: Course[];
  bidEntries: BidPlanEntry[];
  gradingProfiles: Map<string, CourseGradingProfile>;
  liveBiddingTerms: string[];
}

export default function StepGlance({ courses, bidEntries, gradingProfiles, liveBiddingTerms }: Props) {
  const liveTerms = TERM_ORDER.filter((term) => liveBiddingTerms.includes(term));

  return (
    <div className="space-y-6">
      <p style={{ fontFamily: FONT.serif, fontSize: 15, color: COLOR.ink2, lineHeight: 1.6 }}>
        {liveTerms.length > 0
          ? `How every ${liveTerms.join(" & ")} course is graded, and what the outline says about exams, groups and attendance. The summary at the top covers the courses in your plan.`
          : "No bidding round is open right now. This page will show the current term as soon as it opens."}
      </p>
      {liveTerms.map((term) => (
        <TermGlance key={term} term={term} entries={bidEntries} courses={courses} profiles={gradingProfiles} />
      ))}
    </div>
  );
}
