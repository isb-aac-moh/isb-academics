import { useMemo, useState } from "react";
import { COLOR, FONT } from "../../lib/theme";
import { REQUIRED_CREDITS_PER_AREA, creditsCountingToward, coursesCountingToward, allCoursesForArea, isLiveNow, isBiddableTerm, chosenConcentrationFor } from "../../lib/creditProgress";
import { relevanceTags } from "../../lib/relevance";
import type { StudentAcademicProfile, Course, GatingCoreCourse, Resource } from "../../types";
import type { BidPlanEntry } from "../../hooks/useBidPlan";
import { MIN_BID_PER_COURSE } from "../../hooks/useBidPlan";

interface Props {
  profile: StudentAcademicProfile;
  save: (updates: Partial<StudentAcademicProfile>) => void;
  courses: Course[];
  gatingCourses: GatingCoreCourse[];
  resources: Resource[];
  bidEntries: BidPlanEntry[];
  pointsAvailable: number;
  onAdd: (courseId: string, term: string, points: number) => void;
}

export default function StepPlan({ profile, save, courses, gatingCourses, resources, bidEntries, pointsAvailable, onAdd }: Props) {
  const blockedConcentrations = useMemo(() => {
    const failed = new Set(profile.failed_gating_courses);
    return new Set(gatingCourses.filter((g) => failed.has(g.id)).map((g) => g.blocks_concentration));
  }, [profile, gatingCourses]);

  const areas: { name: string; kind: "concentration" | "specialization" }[] = [
    ...profile.target_concentrations.map((c) => ({ name: c, kind: "concentration" as const })),
    ...(profile.target_specialization && !["none", "undecided"].includes(profile.target_specialization)
      ? [{ name: profile.target_specialization, kind: "specialization" as const }]
      : []),
  ];

  // Courses outside every chosen area — the only way to browse/bid when a student
  // has no concentration or specialization, and still available as electives
  // alongside a chosen area for students who do.
  const chosenAreaNames = new Set(areas.map((a) => a.name));
  const generalCourses = courses
    .filter((c) => isBiddableTerm(c.term))
    .filter((c) => !c.concentration_areas.some((a) => chosenAreaNames.has(a)) && !c.industry_specializations.some((s) => chosenAreaNames.has(s)));

  return (
    <div className="space-y-10">
      <p style={{ fontFamily: FONT.serif, fontSize: 15, color: COLOR.ink2, lineHeight: 1.6 }}>
        {areas.length > 0
          ? "Here's where you stand, and what's worth looking at right now."
          : "You haven't picked a concentration or specialization — browse general electives below, or go back a step to set a goal."}
      </p>
      {areas.map((area) => (
        <AreaCard
          key={area.name}
          area={area.name}
          kind={area.kind}
          blocked={area.kind === "concentration" && blockedConcentrations.has(area.name as never)}
          profile={profile}
          save={save}
          courses={courses}
          resources={resources}
          bidEntries={bidEntries}
          pointsAvailable={pointsAvailable}
          onAdd={onAdd}
        />
      ))}
      <GeneralElectivesCard
        courses={generalCourses}
        profile={profile}
        save={save}
        resources={resources}
        bidEntries={bidEntries}
        pointsAvailable={pointsAvailable}
        onAdd={onAdd}
      />
    </div>
  );
}

function GeneralElectivesCard({
  courses, profile, save, resources, bidEntries, pointsAvailable, onAdd,
}: {
  courses: Course[]; profile: StudentAcademicProfile; save: (updates: Partial<StudentAcademicProfile>) => void;
  resources: Resource[]; bidEntries: BidPlanEntry[]; pointsAvailable: number; onAdd: (courseId: string, term: string, points: number) => void;
}) {
  const alreadyIds = new Set(bidEntries.map((e) => e.course_id));
  const liveNow = courses.filter((c) => isLiveNow(c.term));
  const later = courses.filter((c) => !isLiveNow(c.term));

  return (
    <div style={{ border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, padding: "18px 20px", background: COLOR.surface }}>
      <div className="mb-4">
        <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>General Electives</p>
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>
          Courses outside your concentration/specialization picks — still count toward your overall 18-credit requirement.
        </p>
      </div>

      {liveNow.length > 0 && (
        <div className="mb-4">
          <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.green, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 8 }}>
            Live now — Block Week 1 &amp; 2 bidding
          </p>
          <div className="space-y-2">
            {liveNow.map((c) => (
              <CourseRow key={c.id} course={c} profile={profile} save={save} allCourses={courses} resources={resources} alreadyAdded={alreadyIds.has(c.id)} pointsAvailable={pointsAvailable} onAdd={(pts) => onAdd(c.id, c.term, pts)} />
            ))}
          </div>
        </div>
      )}

      {later.length > 0 && (
        <details>
          <summary style={{ fontSize: 12, fontWeight: 600, color: COLOR.ink3, fontFamily: FONT.sans, cursor: "pointer" }}>
            {later.length} more course{later.length > 1 ? "s" : ""} in later terms
          </summary>
          <div className="space-y-2 mt-2">
            {later.map((c) => (
              <CourseRow key={c.id} course={c} profile={profile} save={save} allCourses={courses} resources={resources} alreadyAdded={alreadyIds.has(c.id)} pointsAvailable={pointsAvailable} onAdd={(pts) => onAdd(c.id, c.term, pts)} />
            ))}
          </div>
        </details>
      )}

      {courses.length === 0 && (
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>No general electives found in the catalog.</p>
      )}
    </div>
  );
}

function AreaCard({
  area, kind, blocked, profile, save, courses, resources, bidEntries, pointsAvailable, onAdd,
}: {
  area: string; kind: "concentration" | "specialization"; blocked: boolean;
  profile: StudentAcademicProfile; save: (updates: Partial<StudentAcademicProfile>) => void;
  courses: Course[]; resources: Resource[]; bidEntries: BidPlanEntry[]; pointsAvailable: number;
  onAdd: (courseId: string, term: string, points: number) => void;
}) {
  const credits = creditsCountingToward(area as never, kind, profile, courses, bidEntries);
  const pct = Math.min(100, (credits / REQUIRED_CREDITS_PER_AREA) * 100);
  const alreadyIds = new Set(coursesCountingToward(area as never, kind, profile, courses, bidEntries).map((c) => c.id));
  // Bidding only exists from Term 4 onward — Flexi Core (Term 2/3) is never bid on
  // (tracked separately in "Your Background") and core courses aren't electives.
  const all = allCoursesForArea(area as never, kind, courses).filter((c) => isBiddableTerm(c.term));
  const liveNow = all.filter((c) => isLiveNow(c.term));
  const later = all.filter((c) => !isLiveNow(c.term));

  return (
    <div style={{ border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, padding: "18px 20px", background: COLOR.surface }}>
      <div className="flex items-center justify-between mb-2">
        <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>{area}</p>
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>{credits}/{REQUIRED_CREDITS_PER_AREA} credits</p>
      </div>
      <div style={{ height: 8, borderRadius: 4, background: COLOR.borderLight, overflow: "hidden", marginBottom: blocked ? 8 : 16 }}>
        <div style={{ height: "100%", width: `${pct}%`, background: blocked ? COLOR.red : COLOR.navyHero, borderRadius: 4 }} />
      </div>
      {blocked && (
        <p style={{ fontSize: 12.5, color: COLOR.red, fontFamily: FONT.sans, marginBottom: 16 }}>
          A failed core course has permanently closed this concentration off — no amount of electives here will fix it. Worth reconsidering this pick.
        </p>
      )}

      {liveNow.length > 0 && (
        <div className="mb-4">
          <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.green, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 8 }}>
            Live now — Block Week 1 &amp; 2 bidding
          </p>
          <div className="space-y-2">
            {liveNow.map((c) => (
              <CourseRow key={c.id} course={c} profile={profile} save={save} allCourses={courses} resources={resources} alreadyAdded={alreadyIds.has(c.id)} pointsAvailable={pointsAvailable} onAdd={(pts) => onAdd(c.id, c.term, pts)} />
            ))}
          </div>
        </div>
      )}

      {later.length > 0 && (
        <details>
          <summary style={{ fontSize: 12, fontWeight: 600, color: COLOR.ink3, fontFamily: FONT.sans, cursor: "pointer" }}>
            {later.length} more course{later.length > 1 ? "s" : ""} in later terms
          </summary>
          <div className="space-y-2 mt-2">
            {later.map((c) => (
              <CourseRow key={c.id} course={c} profile={profile} save={save} allCourses={courses} resources={resources} alreadyAdded={alreadyIds.has(c.id)} pointsAvailable={pointsAvailable} onAdd={(pts) => onAdd(c.id, c.term, pts)} />
            ))}
          </div>
        </details>
      )}

      {all.length === 0 && (
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>No courses found for this area yet in the catalog.</p>
      )}
    </div>
  );
}

function CourseRow({
  course, profile, save, allCourses, resources, alreadyAdded, pointsAvailable, onAdd,
}: {
  course: Course; profile: StudentAcademicProfile; save: (updates: Partial<StudentAcademicProfile>) => void;
  allCourses: Course[]; resources: Resource[]; alreadyAdded: boolean; pointsAvailable: number; onAdd: (points: number) => void;
}) {
  const [points, setPoints] = useState(MIN_BID_PER_COURSE);
  const exceedsBudget = points > pointsAvailable;
  // Cross-listed across both target concentrations — FAQ Q45: only one counts, student's choice.
  // Only matters once the course is actually in the plan; browsing shows both areas plainly.
  const overlappingConcentrations = profile.target_concentrations.filter((a) => course.concentration_areas.includes(a));
  const showCrossListedPicker = alreadyAdded && overlappingConcentrations.length > 1;
  const areaTags = showCrossListedPicker
    ? course.industry_specializations
    : [...course.concentration_areas, ...course.industry_specializations];
  const softTags = relevanceTags(course, profile, allCourses);
  const outline = resources.find((r) => r.course_id === course.id && r.resource_type === "Course Outline");

  return (
    <div style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.bgSoft }}>
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
        <div style={{ minWidth: 0, flex: 1 }}>
          <p style={{ fontSize: 13.5, fontWeight: 600, fontFamily: FONT.sans, color: COLOR.ink }}>{course.name}</p>
          <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans }}>
            {course.professor} · {course.term} · {course.credits}cr
            {outline && (
              <>
                {" · "}
                <a href={outline.url} target="_blank" rel="noopener noreferrer" style={{ color: COLOR.navyHero, fontWeight: 700, textDecoration: "underline" }}>
                  Course outline ↗
                </a>
              </>
            )}
          </p>
        </div>
        {alreadyAdded ? (
          <span style={{ fontSize: 12, color: COLOR.green, fontWeight: 700, fontFamily: FONT.sans, whiteSpace: "nowrap" }}>✓ In your plan</span>
        ) : (
          <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: 4, flexShrink: 0 }}>
            <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
              <input
                type="number" min={MIN_BID_PER_COURSE} value={points} onChange={(e) => setPoints(Number(e.target.value))}
                style={{ width: 64, padding: "5px 7px", borderRadius: 6, border: `1px solid ${COLOR.border}`, fontSize: 12, fontFamily: FONT.sans }}
              />
              <button
                onClick={() => onAdd(points)}
                disabled={exceedsBudget}
                style={{
                  padding: "6px 11px", borderRadius: 7, border: "none", fontSize: 12, fontWeight: 700, fontFamily: FONT.sans,
                  background: exceedsBudget ? COLOR.border : COLOR.navyHero, color: exceedsBudget ? COLOR.ink3 : "#fff",
                  cursor: exceedsBudget ? "not-allowed" : "pointer",
                }}
              >
                Add
              </button>
            </div>
            {exceedsBudget && (
              <p style={{ fontSize: 10.5, color: COLOR.red, fontFamily: FONT.sans, textAlign: "right", maxWidth: 160 }}>
                Only {pointsAvailable} pts left of your 4,500 budget — lower your bid to add this.
              </p>
            )}
          </div>
        )}
      </div>
      {(areaTags.length > 0 || softTags.length > 0) && (
        <div className="flex flex-wrap gap-1.5 mt-2">
          {areaTags.map((t) => (
            <span key={t} style={{ fontSize: 10.5, fontWeight: 700, padding: "2px 8px", borderRadius: 6, background: COLOR.navyTint, color: COLOR.navyHero, fontFamily: FONT.sans }}>
              Counts toward {t}
            </span>
          ))}
          {softTags.map((t) => (
            <span key={t} style={{ fontSize: 10.5, fontWeight: 600, padding: "2px 8px", borderRadius: 6, background: COLOR.amberTint, color: "#8B5E00", fontFamily: FONT.sans }}>
              {t}
            </span>
          ))}
        </div>
      )}
      {showCrossListedPicker && (
        <div className="mt-2" style={{ padding: "8px 10px", borderRadius: 8, background: COLOR.amberTint }}>
          <p style={{ fontSize: 11, fontWeight: 700, color: "#8B5E00", fontFamily: FONT.sans, marginBottom: 6 }}>
            Cross-listed — ISB only lets this count toward one concentration. Which?
          </p>
          <div className="flex flex-wrap gap-1.5">
            {overlappingConcentrations.map((a) => {
              const active = chosenConcentrationFor(course, profile) === a;
              return (
                <button
                  key={a}
                  onClick={() => save({ cross_listed_concentration_choices: { ...profile.cross_listed_concentration_choices, [course.code]: a } })}
                  style={{
                    padding: "4px 10px", borderRadius: 6, fontSize: 10.5, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer",
                    border: `1px solid ${active ? COLOR.navyHero : COLOR.border}`, background: active ? COLOR.navyHero : COLOR.surface,
                    color: active ? "#fff" : COLOR.ink2,
                  }}
                >
                  {a}
                </button>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}
