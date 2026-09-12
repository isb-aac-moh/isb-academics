import type { Course, ConcentrationArea, StudentAcademicProfile } from "../types";
import { chosenConcentrationFor } from "../lib/creditProgress";
import { COLOR, FONT } from "../lib/theme";

/**
 * The "which concentration does this count toward?" control for a cross-listed
 * course — Elective Bidding FAQ Q45: a course listed under several concentration
 * areas counts toward exactly one, and it's the student's call which.
 *
 * Shown for every course carrying 2+ areas, whether or not it's in the plan yet,
 * so the choice is part of deciding what to bid on rather than an afterthought.
 * Areas outside the student's two targets are still offered — a student weighing
 * a switch needs to see where a course could land — but picking one is called out,
 * since it means the course stops counting toward either declared target.
 */
export default function ConcentrationChoice({
  course, profile, save,
}: {
  course: Course; profile: StudentAcademicProfile;
  save: (updates: Partial<StudentAcademicProfile>) => void;
}) {
  if (course.concentration_areas.length < 2) return null;

  const chosen = chosenConcentrationFor(course, profile);
  const chosenIsTarget = !!chosen && profile.target_concentrations.includes(chosen);

  function pick(area: ConcentrationArea) {
    save({ cross_listed_concentration_choices: { ...profile.cross_listed_concentration_choices, [course.code]: area } });
  }

  return (
    <div className="mt-2">
      <div className="flex flex-wrap items-center gap-1.5">
        <span style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.04em" }}>
          Counts toward
        </span>
        {course.concentration_areas.map((a) => {
          const active = chosen === a;
          const isTarget = profile.target_concentrations.includes(a);
          return (
            <button
              key={a}
              onClick={() => pick(a)}
              aria-pressed={active}
              title={isTarget ? `Count this course toward ${a}` : `${a} isn't one of your target concentrations`}
              style={{
                padding: "3px 9px", borderRadius: 6, fontSize: 10.5, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer",
                border: `1px solid ${active ? COLOR.navyHero : COLOR.border}`,
                background: active ? COLOR.navyHero : isTarget ? COLOR.navyTint : COLOR.surface,
                color: active ? "#fff" : isTarget ? COLOR.navyHero : COLOR.ink3,
              }}
            >
              {a}
            </button>
          );
        })}
      </div>
      {!chosenIsTarget && profile.target_concentrations.length > 0 && (
        <p style={{ fontSize: 10.5, color: "#8B5E00", fontFamily: FONT.sans, marginTop: 5 }}>
          {chosen} isn't one of your target concentrations, so this course isn't adding credits toward {profile.target_concentrations.join(" or ")}.
        </p>
      )}
    </div>
  );
}
