import { useMemo, useState } from "react";
import { COLOR, FONT } from "../../lib/theme";
import { REQUIRED_CREDITS_PER_AREA, creditsCountingToward, coursesCountingToward, allCoursesForArea, isLiveNow } from "../../lib/creditProgress";
import { relevanceTags } from "../../lib/relevance";
import type { StudentAcademicProfile, Course, GatingCoreCourse } from "../../types";
import type { BidPlanEntry } from "../../hooks/useBidPlan";
import { MIN_BID_PER_COURSE } from "../../hooks/useBidPlan";

interface Props {
  profile: StudentAcademicProfile;
  courses: Course[];
  gatingCourses: GatingCoreCourse[];
  bidEntries: BidPlanEntry[];
  onAdd: (courseId: string, term: string, points: number) => void;
}

export default function StepPlan({ profile, courses, gatingCourses, bidEntries, onAdd }: Props) {
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

  if (areas.length === 0) {
    return (
      <div style={{ padding: "24px 0", fontFamily: FONT.sans, color: COLOR.ink3, fontSize: 14 }}>
        You haven't picked a concentration or specialization yet — go back a step to set a goal, or skip ahead to the bid budget if you're keeping options open for now.
      </div>
    );
  }

  return (
    <div className="space-y-10">
      <p style={{ fontFamily: FONT.serif, fontSize: 15, color: COLOR.ink2, lineHeight: 1.6 }}>
        Here's where you stand, and what's worth looking at right now.
      </p>
      {areas.map((area) => (
        <AreaCard
          key={area.name}
          area={area.name}
          kind={area.kind}
          blocked={area.kind === "concentration" && blockedConcentrations.has(area.name as never)}
          profile={profile}
          courses={courses}
          bidEntries={bidEntries}
          onAdd={onAdd}
        />
      ))}
    </div>
  );
}

function AreaCard({
  area, kind, blocked, profile, courses, bidEntries, onAdd,
}: {
  area: string; kind: "concentration" | "specialization"; blocked: boolean;
  profile: StudentAcademicProfile; courses: Course[]; bidEntries: BidPlanEntry[];
  onAdd: (courseId: string, term: string, points: number) => void;
}) {
  const credits = creditsCountingToward(area as never, kind, profile, courses, bidEntries);
  const pct = Math.min(100, (credits / REQUIRED_CREDITS_PER_AREA) * 100);
  const alreadyIds = new Set(coursesCountingToward(area as never, kind, profile, courses, bidEntries).map((c) => c.id));
  const all = allCoursesForArea(area as never, kind, courses);
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
              <CourseRow key={c.id} course={c} profile={profile} allCourses={courses} alreadyAdded={alreadyIds.has(c.id)} onAdd={(pts) => onAdd(c.id, c.term, pts)} />
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
              <CourseRow key={c.id} course={c} profile={profile} allCourses={courses} alreadyAdded={alreadyIds.has(c.id)} onAdd={(pts) => onAdd(c.id, c.term, pts)} />
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
  course, profile, allCourses, alreadyAdded, onAdd,
}: { course: Course; profile: StudentAcademicProfile; allCourses: Course[]; alreadyAdded: boolean; onAdd: (points: number) => void }) {
  const [points, setPoints] = useState(MIN_BID_PER_COURSE);
  const areaTags = [...course.concentration_areas, ...course.industry_specializations];
  const softTags = relevanceTags(course, profile, allCourses);

  return (
    <div style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.bgSoft }}>
      <div className="flex items-center justify-between">
        <div>
          <p style={{ fontSize: 13.5, fontWeight: 600, fontFamily: FONT.sans, color: COLOR.ink }}>{course.name}</p>
          <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans }}>{course.professor} · {course.term} · {course.credits}cr</p>
        </div>
        {alreadyAdded ? (
          <span style={{ fontSize: 12, color: COLOR.green, fontWeight: 700, fontFamily: FONT.sans, whiteSpace: "nowrap" }}>✓ In your plan</span>
        ) : (
          <div style={{ display: "flex", gap: 6, alignItems: "center", flexShrink: 0 }}>
            <input
              type="number" min={MIN_BID_PER_COURSE} value={points} onChange={(e) => setPoints(Number(e.target.value))}
              style={{ width: 64, padding: "5px 7px", borderRadius: 6, border: `1px solid ${COLOR.border}`, fontSize: 12, fontFamily: FONT.sans }}
            />
            <button
              onClick={() => onAdd(points)}
              style={{ padding: "6px 11px", borderRadius: 7, background: COLOR.navyHero, color: "#fff", border: "none", fontSize: 12, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer" }}
            >
              Add
            </button>
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
    </div>
  );
}
