/**
 * Once a student has courses in their bid plan for a term, this turns that
 * flat list into a picture of what the term actually looks like — grading
 * composition per course, exam tally, and a full brief. It describes the term
 * and does not score it: no workload number, tier or chart.
 * Keyed off course_grading_profiles, which is per-course (not per-term-4-only),
 * so this works unchanged for Term 5 onward as those profiles get added.
 */
import { useState } from "react";
import { COLOR, FONT } from "../../lib/theme";
import { avg } from "../../lib/workloadRadar";
import type { Course, CourseGradingProfile } from "../../types";
import type { BidPlanEntry } from "../../hooks/useBidPlan";

interface Props {
  term: string;
  entries: BidPlanEntry[];
  courses: Course[];
  profiles: Map<string, CourseGradingProfile>;
}

export default function TermGlance({ term, entries, courses, profiles }: Props) {
  const termCourses = entries
    .filter((e) => e.term === term && e.course_id)
    .map((e) => courses.find((c) => c.id === e.course_id))
    .filter((c): c is Course => !!c);
  const plannedIds = new Set(termCourses.map((c) => c.id));
  // Every course offered this term, planned ones first, so students can compare before adding.
  const rows = [...termCourses, ...courses.filter((c) => c.term === term && !plannedIds.has(c.id))];

  if (rows.length === 0) return null;

  const withProfile = termCourses
    .map((c) => ({ course: c, profile: profiles.get(c.id) }))
    .filter((x): x is { course: Course; profile: CourseGradingProfile } => !!x.profile);
  const missing = termCourses.length - withProfile.length;

  const profileList = withProfile.map((x) => x.profile);
  const midterms = profileList.reduce((s, p) => s + p.exam_midterm_count, 0);
  const endterms = profileList.reduce((s, p) => s + p.exam_endterm_count, 0);
  const quizzes = profileList.reduce((s, p) => s + p.exam_quiz_count, 0);
  const indiv = avg(profileList.map((p) => p.grade_participation_pct + p.grade_individual_pct + p.grade_exam_pct));
  const group = avg(profileList.map((p) => p.grade_group_pct));
  const indivPct = indiv + group > 0 ? Math.round((indiv / (indiv + group)) * 100) : 50;

  return (
    <div style={{ border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, padding: "18px 20px", background: COLOR.surface }}>
      <div className="mb-4">
        <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>
          {term} at a Glance
          <span style={{ marginLeft: 8, padding: "2px 8px", borderRadius: 10, fontSize: 10.5, fontWeight: 700, background: COLOR.greenTint, color: COLOR.green, verticalAlign: "middle" }}>
            Bidding live
          </span>
        </p>
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>
          {termCourses.length === 0
            ? `You haven't planned any ${term} courses yet. Here's how every ${term} course is graded.`
            : `What this term is made of, based on the ${termCourses.length} course${termCourses.length > 1 ? "s" : ""} in your plan. Every other ${term} course is listed below to compare.`}
          {missing > 0 && ` (${missing} course${missing > 1 ? "s" : ""} without a grading profile yet excluded from the numbers below.)`}
        </p>
      </div>

      {profileList.length > 0 && (
        <div className="flex flex-col lg:flex-row gap-6 mb-6">
          <div className="flex-1 grid grid-cols-2 sm:grid-cols-4 gap-3" style={{ alignContent: "flex-start" }}>
            <Stat label="Mid-terms" value={midterms} />
            <Stat label="End-terms" value={endterms} />
            <Stat label="Quizzes" value={quizzes} />
            <Stat label="Sit-down exams" value={midterms + endterms} />

            <div className="col-span-2 sm:col-span-4" style={{ marginTop: 4 }}>
              <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 6 }}>
                Individual vs. group weight
              </p>
              <div style={{ height: 22, borderRadius: 6, overflow: "hidden", display: "flex", border: `1px solid ${COLOR.border}` }}>
                <div style={{ width: `${indivPct}%`, background: COLOR.navyHero, display: "flex", alignItems: "center", justifyContent: "center" }}>
                  {indivPct >= 16 && <span style={{ fontSize: 10.5, fontWeight: 700, color: "#fff", fontFamily: FONT.sans }}>{indivPct}%</span>}
                </div>
                <div style={{ width: `${100 - indivPct}%`, background: COLOR.amber, display: "flex", alignItems: "center", justifyContent: "center" }}>
                  {100 - indivPct >= 16 && <span style={{ fontSize: 10.5, fontWeight: 700, color: "#fff", fontFamily: FONT.sans }}>{100 - indivPct}%</span>}
                </div>
              </div>
              <div className="flex justify-between mt-1">
                <span style={{ fontSize: 10.5, color: COLOR.navyHero, fontFamily: FONT.sans, fontWeight: 600 }}>Individual</span>
                <span style={{ fontSize: 10.5, color: COLOR.amber, fontFamily: FONT.sans, fontWeight: 600 }}>Group</span>
              </div>
            </div>
          </div>
        </div>
      )}

      <div className="space-y-2">
        {rows.map((course) => (
          <CourseGlanceRow key={course.id} course={course} profile={profiles.get(course.id)} inPlan={plannedIds.has(course.id)} />
        ))}
      </div>
    </div>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div style={{ padding: "10px 12px", borderRadius: 9, background: COLOR.navyTint }}>
      <p style={{ fontSize: 20, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.navyHero }}>{value}</p>
      <p style={{ fontSize: 10.5, color: COLOR.navyHero, fontFamily: FONT.sans, opacity: 0.85 }}>{label}</p>
    </div>
  );
}

function CourseGlanceRow({ course, profile, inPlan }: { course: Course; profile?: CourseGradingProfile; inPlan: boolean }) {
  const [open, setOpen] = useState(false);

  return (
    <div style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.bgSoft }}>
      <div className="flex items-center justify-between gap-2">
        <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>
          {course.code} <span style={{ fontWeight: 500, color: COLOR.ink2 }}>· {course.name}</span>
          {inPlan && (
            <span style={{ marginLeft: 8, padding: "1px 7px", borderRadius: 8, fontSize: 10, fontWeight: 700, background: COLOR.navyTint, color: COLOR.navyHero }}>
              In your plan
            </span>
          )}
        </p>
        {profile && (
          <button
            onClick={() => setOpen((o) => !o)}
            style={{ fontSize: 11, fontWeight: 700, color: COLOR.navyHero, background: "none", border: "none", cursor: "pointer", whiteSpace: "nowrap", flexShrink: 0 }}
          >
            {open ? "Hide details ▾" : "Every detail ▾"}
          </button>
        )}
      </div>

      {profile ? (
        <>
          <div className="flex mt-2" style={{ height: 18, borderRadius: 5, overflow: "hidden" }}>
            {profile.grade_participation_pct > 0 && (
              <Segment pct={profile.grade_participation_pct} color={COLOR.mint} label="Participation" />
            )}
            {profile.grade_individual_pct > 0 && (
              <Segment pct={profile.grade_individual_pct} color={COLOR.navyHero} label="Individual" />
            )}
            {profile.grade_group_pct > 0 && (
              <Segment pct={profile.grade_group_pct} color={COLOR.amber} label="Group" />
            )}
            {profile.grade_exam_pct > 0 && (
              <Segment pct={profile.grade_exam_pct} color={COLOR.ink2} label="Exam" />
            )}
          </div>
          <div className="flex flex-wrap gap-x-3 gap-y-0.5 mt-1.5">
            <Legend color={COLOR.mint} label={`Participation ${profile.grade_participation_pct}%`} />
            <Legend color={COLOR.navyHero} label={`Individual ${profile.grade_individual_pct}%`} />
            <Legend color={COLOR.amber} label={`Group ${profile.grade_group_pct}%`} />
            <Legend color={COLOR.ink2} label={`Exam ${profile.grade_exam_pct}%`} />
          </div>

          {open && (
            <ul className="mt-3 space-y-1.5" style={{ listStyle: "none" }}>
              {profile.brief.map((b) => (
                <li key={b.label} style={{ fontSize: 12, fontFamily: FONT.sans, color: COLOR.ink2, lineHeight: 1.5 }}>
                  <b style={{ color: COLOR.ink }}>{b.label}</b> — {b.text}
                </li>
              ))}
              <li style={{ fontSize: 11, fontFamily: FONT.sans, color: COLOR.ink3, lineHeight: 1.5 }}>
                Read from the official outline{profile.extracted_at && !isNaN(new Date(profile.extracted_at).getTime()) ? ` on ${new Date(profile.extracted_at).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" })}` : ""}.
                Professors can revise an outline, so confirm anything that matters to you in session 1.
              </li>
              {profile.source_url && (
                <li>
                  <a href={profile.source_url} target="_blank" rel="noopener noreferrer" style={{ fontSize: 11, color: COLOR.navyHero, fontWeight: 700, textDecoration: "underline" }}>
                    Read the full course outline ↗
                  </a>
                </li>
              )}
            </ul>
          )}
        </>
      ) : (
        <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 4 }}>
          No grading profile yet for this course — admin can add one from the Courses tab.
        </p>
      )}
    </div>
  );
}

function Segment({ pct, color, label }: { pct: number; color: string; label: string }) {
  return (
    <div style={{ width: `${pct}%`, background: color, display: "flex", alignItems: "center", justifyContent: "center" }} title={`${label} ${pct}%`}>
      {pct >= 12 && <span style={{ fontSize: 9.5, fontWeight: 700, color: "#fff", fontFamily: FONT.sans }}>{pct}%</span>}
    </div>
  );
}

function Legend({ color, label }: { color: string; label: string }) {
  return (
    <span className="flex items-center gap-1" style={{ fontSize: 10, color: COLOR.ink3, fontFamily: FONT.sans }}>
      <span style={{ width: 7, height: 7, borderRadius: 2, background: color, display: "inline-block" }} />
      {label}
    </span>
  );
}
