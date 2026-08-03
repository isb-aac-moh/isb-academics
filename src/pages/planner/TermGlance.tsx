/**
 * Once a student has courses in their bid plan for a term, this turns that
 * flat list into a picture of what the term actually looks like — grading
 * composition per course, workload profile, exam tally, and a full brief.
 * Keyed off course_grading_profiles, which is per-course (not per-term-4-only),
 * so this works unchanged for Term 5 onward as those profiles get added.
 */
import { useState } from "react";
import { COLOR, FONT } from "../../lib/theme";
import type { Course, CourseGradingProfile } from "../../types";
import type { BidPlanEntry } from "../../hooks/useBidPlan";

const LOAD_AXES: { key: keyof Pick<CourseGradingProfile, "load_quant" | "load_assignments" | "load_participation" | "load_exam_pressure" | "load_group" | "load_reading">; label: string }[] = [
  { key: "load_quant", label: "Quant" },
  { key: "load_assignments", label: "Assignments" },
  { key: "load_participation", label: "Participation" },
  { key: "load_exam_pressure", label: "Exam pressure" },
  { key: "load_group", label: "Group work" },
  { key: "load_reading", label: "Reading" },
];

function avg(nums: number[]): number {
  return nums.length ? nums.reduce((s, n) => s + n, 0) / nums.length : 0;
}

function buildRadar(profiles: CourseGradingProfile[]): string {
  const size = 260, cx = size / 2, cy = size / 2 + 4, R = 88, n = LOAD_AXES.length;
  const angle = (i: number) => -Math.PI / 2 + (i * 2 * Math.PI) / n;
  const pt = (i: number, v: number): [number, number] => [cx + Math.cos(angle(i)) * R * (v / 5), cy + Math.sin(angle(i)) * R * (v / 5)];

  let g = "";
  for (let r = 1; r <= 5; r++) {
    const pts = LOAD_AXES.map((_, i) => pt(i, r).join(",")).join(" ");
    g += `<polygon points="${pts}" fill="none" stroke="${r === 5 ? COLOR.ink : COLOR.borderLight}" stroke-width="${r === 5 ? 1.5 : 1}"/>`;
  }
  LOAD_AXES.forEach((ax, i) => {
    const [x, y] = pt(i, 5);
    g += `<line x1="${cx}" y1="${cy}" x2="${x}" y2="${y}" stroke="${COLOR.borderLight}" stroke-width="1"/>`;
    const [lx, ly] = pt(i, 5.85);
    g += `<text x="${lx}" y="${ly}" font-size="9.5" font-weight="700" fill="${COLOR.ink3}" text-anchor="middle" dominant-baseline="middle" font-family="Plus Jakarta Sans">${ax.label}</text>`;
  });

  const values = LOAD_AXES.map((ax) => avg(profiles.map((p) => p[ax.key])));
  const pts = LOAD_AXES.map((ax, i) => pt(i, avg(profiles.map((p) => p[ax.key]))).join(",")).join(" ");
  g += `<polygon points="${pts}" fill="${COLOR.navyHero}22" stroke="${COLOR.navyHero}" stroke-width="2.5"/>`;
  values.forEach((v, i) => {
    const [x, y] = pt(i, v);
    g += `<circle cx="${x}" cy="${y}" r="3" fill="${COLOR.navyHero}"/>`;
  });

  return `<svg viewBox="0 0 ${size} ${size + 12}" width="100%" style="max-width:280px">${g}</svg>`;
}

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

  if (termCourses.length === 0) return null;

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
        <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>{term} at a Glance</p>
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>
          What this term actually looks like, based on the {termCourses.length} course{termCourses.length > 1 ? "s" : ""} in your plan.
          {missing > 0 && ` (${missing} course${missing > 1 ? "s" : ""} without a grading profile yet excluded from the numbers below.)`}
        </p>
      </div>

      {profileList.length > 0 && (
        <div className="flex flex-col lg:flex-row gap-6 mb-6">
          <div className="flex flex-col items-center" style={{ flexShrink: 0 }}>
            <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 6 }}>
              Workload profile
            </p>
            <div dangerouslySetInnerHTML={{ __html: buildRadar(profileList) }} />
          </div>

          <div className="flex-1 grid grid-cols-2 sm:grid-cols-4 gap-3" style={{ alignContent: "flex-start" }}>
            <Stat label="Mid-terms" value={midterms} tint={COLOR.amberTint} color={COLOR.amber} />
            <Stat label="End-terms" value={endterms} tint={COLOR.redTint} color={COLOR.red} />
            <Stat label="Quizzes" value={quizzes} tint={COLOR.navyTint} color={COLOR.navyHero} />
            <Stat label="Sit-down exams" value={midterms + endterms} tint={COLOR.greenTint} color={COLOR.green} />

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
        {termCourses.map((course) => (
          <CourseGlanceRow key={course.id} course={course} profile={profiles.get(course.id)} />
        ))}
      </div>
    </div>
  );
}

function Stat({ label, value, tint, color }: { label: string; value: number; tint: string; color: string }) {
  return (
    <div style={{ padding: "10px 12px", borderRadius: 9, background: tint }}>
      <p style={{ fontSize: 20, fontWeight: 700, fontFamily: FONT.sans, color }}>{value}</p>
      <p style={{ fontSize: 10.5, color, fontFamily: FONT.sans, opacity: 0.85 }}>{label}</p>
    </div>
  );
}

function CourseGlanceRow({ course, profile }: { course: Course; profile?: CourseGradingProfile }) {
  const [open, setOpen] = useState(false);

  return (
    <div style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.bgSoft }}>
      <div className="flex items-center justify-between gap-2">
        <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>
          {course.code} <span style={{ fontWeight: 500, color: COLOR.ink2 }}>· {course.name}</span>
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
              <Segment pct={profile.grade_exam_pct} color={COLOR.red} label="Exam" />
            )}
          </div>
          <div className="flex flex-wrap gap-x-3 gap-y-0.5 mt-1.5">
            <Legend color={COLOR.mint} label={`Participation ${profile.grade_participation_pct}%`} />
            <Legend color={COLOR.navyHero} label={`Individual ${profile.grade_individual_pct}%`} />
            <Legend color={COLOR.amber} label={`Group ${profile.grade_group_pct}%`} />
            <Legend color={COLOR.red} label={`Exam ${profile.grade_exam_pct}%`} />
          </div>

          {open && (
            <ul className="mt-3 space-y-1.5" style={{ listStyle: "none" }}>
              {profile.brief.map((b) => (
                <li key={b.label} style={{ fontSize: 12, fontFamily: FONT.sans, color: COLOR.ink2, lineHeight: 1.5 }}>
                  <b style={{ color: COLOR.ink }}>{b.label}</b> — {b.text}
                </li>
              ))}
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
