/**
 * A dedicated step, not folded into "Your Plan" — once courses are picked,
 * this is the "what does my term actually look like" view: grading DNA, exam
 * load, workload profile, and the full brief per course, per planned term.
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
}

export default function StepGlance({ courses, bidEntries, gradingProfiles }: Props) {
  const plannedTerms = TERM_ORDER.filter((term) => bidEntries.some((e) => e.term === term));

  return (
    <div className="space-y-6">
      <p style={{ fontFamily: FONT.serif, fontSize: 15, color: COLOR.ink2, lineHeight: 1.6 }}>
        {plannedTerms.length > 0
          ? "What each term in your plan actually looks like — how it's graded, how heavy it runs, and every detail from the outline."
          : "Add courses to your plan in the previous step to see this — grading composition, workload, exam load, and the full brief for each term."}
      </p>
      {plannedTerms.map((term) => (
        <TermGlance key={term} term={term} entries={bidEntries} courses={courses} profiles={gradingProfiles} />
      ))}
    </div>
  );
}
