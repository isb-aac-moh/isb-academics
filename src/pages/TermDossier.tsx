/**
 * The Term Dossier — every elective in a term as its official course outline
 * describes it: how the grade splits, what the exams are, how groups work, how
 * strict attendance is, and how heavy the whole thing feels.
 *
 * The route is /dossier/:term rather than /term5 so next term needs no new page:
 * seed course_grading_profiles for that term's courses and its dossier appears.
 * Term 4 predates this and stays as its own static file at /term4.
 */
import { useMemo, useState } from "react";
import { useParams } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { useCourseGradingProfiles } from "../hooks/useCourseGradingProfiles";
import { LOAD_AXES, avg, buildRadar, pressureScore, pressureTier, TIER_COLOR } from "../lib/workloadRadar";
import type { AttendancePolicy, ConcentrationArea, Course, CourseGradingProfile } from "../types";

type Entry = { course: Course; profile: CourseGradingProfile };
type Tab = "browse" | "compare" | "build";

const MAX_COMPARE = 4;

/** "term-5" -> "Term 5". Anything else falls through and simply matches no courses. */
function slugToTerm(slug: string | undefined): string {
  if (!slug) return "";
  return slug.replace(/-/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
}

function examCount(p: CourseGradingProfile): number {
  return p.exam_midterm_count + p.exam_endterm_count;
}

function examSummary(p: CourseGradingProfile): string {
  const parts: string[] = [];
  if (p.exam_midterm_count) parts.push(`${p.exam_midterm_count} mid-term`);
  if (p.exam_endterm_count) parts.push(`${p.exam_endterm_count} end-term`);
  if (p.exam_quiz_count) parts.push(`${p.exam_quiz_count} quiz${p.exam_quiz_count > 1 ? "zes" : ""}`);
  return parts.length ? parts.join(" · ") : "No exams or quizzes";
}

/** Short, scannable claims — each one has to be true of the outline, or it isn't shown. */
function tagsFor(p: CourseGradingProfile): string[] {
  const tags: string[] = [];
  if (examCount(p) === 0) tags.push("No sit-down exam");
  else if (p.grade_exam_pct >= 50) tags.push("Exam-heavy");
  if (p.cross_section === true) tags.push("Cross-section groups");
  if (p.cross_section === false) tags.push("Same section only");
  if (p.peer_eval === true) tags.push("Peer evaluated");
  if (p.attendance === "Not mandatory") tags.push("Attendance optional");
  if (p.attendance === "Participation-linked") tags.push("Attendance is graded");
  if (p.attendance === "Stricter than ISB policy") tags.push("Strict attendance");
  if (p.grade_group_pct >= 40) tags.push("Group-heavy");
  if (p.load_quant >= 4) tags.push("Quant-heavy");
  return tags;
}

const FILTERS: { value: string; label: string; test: (p: CourseGradingProfile) => boolean }[] = [
  { value: "all", label: "All courses", test: () => true },
  { value: "noexam", label: "No sit-down exam", test: (p) => examCount(p) === 0 },
  { value: "exam", label: "Has a mid/end-term", test: (p) => examCount(p) > 0 },
  { value: "cross", label: "Groups can cross sections", test: (p) => p.cross_section === true },
  { value: "same", label: "Same-section groups only", test: (p) => p.cross_section === false },
  { value: "self", label: "Self-selected groups", test: (p) => p.group_formation === "Self-select" },
  { value: "peer", label: "Has peer evaluation", test: (p) => p.peer_eval === true },
  { value: "attend-free", label: "Attendance not mandatory", test: (p) => p.attendance === "Not mandatory" },
  { value: "attend-strict", label: "Attendance affects your grade", test: (p) => p.attendance === "Participation-linked" || p.attendance === "Stricter than ISB policy" },
  { value: "group-light", label: "Light on group work", test: (p) => p.grade_group_pct <= 25 },
  { value: "chill", label: "Chill workload", test: (p) => pressureTier(pressureScore(p)) === "Chill" },
  { value: "intense", label: "Intense workload", test: (p) => pressureTier(pressureScore(p)) === "Intense" },
];

const SORTS: { value: string; label: string; cmp: (a: Entry, b: Entry) => number }[] = [
  { value: "pressure-desc", label: "Workload, heavy → light", cmp: (a, b) => pressureScore(b.profile) - pressureScore(a.profile) },
  { value: "pressure-asc", label: "Workload, light → heavy", cmp: (a, b) => pressureScore(a.profile) - pressureScore(b.profile) },
  { value: "exam-desc", label: "Exam weight, high → low", cmp: (a, b) => b.profile.grade_exam_pct - a.profile.grade_exam_pct },
  { value: "group-desc", label: "Group weight, high → low", cmp: (a, b) => b.profile.grade_group_pct - a.profile.grade_group_pct },
  { value: "indiv-desc", label: "Individual weight, high → low", cmp: (a, b) => b.profile.grade_individual_pct - a.profile.grade_individual_pct },
  { value: "az", label: "Course name, A–Z", cmp: (a, b) => a.course.name.localeCompare(b.course.name) },
];

export default function TermDossier() {
  const { term: termSlug } = useParams();
  const term = slugToTerm(termSlug);

  const { courses, loading: coursesLoading } = useCourses();
  const { profiles, loading: profilesLoading } = useCourseGradingProfiles();
  const loading = coursesLoading || profilesLoading;

  const [tab, setTab] = useState<Tab>("browse");
  const [sort, setSort] = useState("pressure-desc");
  const [filter, setFilter] = useState("all");
  const [conc, setConc] = useState("all");
  const [pinned, setPinned] = useState<string[]>([]);
  const [openId, setOpenId] = useState<string | null>(null);

  // Electives only: core courses aren't bid on, so they don't belong in a bidding aid.
  const termCourses = useMemo(
    () => courses.filter((c) => c.term === term && !c.is_core),
    [courses, term],
  );

  const entries = useMemo<Entry[]>(
    () =>
      termCourses
        .map((course) => ({ course, profile: profiles.get(course.id) }))
        .filter((e): e is Entry => !!e.profile),
    [termCourses, profiles],
  );
  const missingProfile = termCourses.length - entries.length;

  const concentrations = useMemo(
    () => [...new Set(entries.flatMap((e) => e.course.concentration_areas))].sort(),
    [entries],
  );

  const visible = useMemo(() => {
    const f = FILTERS.find((x) => x.value === filter) ?? FILTERS[0];
    const s = SORTS.find((x) => x.value === sort) ?? SORTS[0];
    return entries
      .filter((e) => f.test(e.profile))
      .filter((e) => conc === "all" || e.course.concentration_areas.includes(conc as ConcentrationArea))
      .sort(s.cmp);
  }, [entries, filter, sort, conc]);

  const pinnedEntries = pinned
    .map((id) => entries.find((e) => e.course.id === id))
    .filter((e): e is Entry => !!e);

  function togglePin(id: string) {
    setPinned((p) => (p.includes(id) ? p.filter((x) => x !== id) : p.length >= MAX_COMPARE ? p : [...p, id]));
  }

  const open = openId ? entries.find((e) => e.course.id === openId) ?? null : null;

  if (loading) {
    return <div style={{ minHeight: "100vh", background: COLOR.bg }} />;
  }

  return (
    <div style={{ background: COLOR.bg, minHeight: "100vh", fontFamily: FONT.sans }}>
      <div className="px-5 md:px-8 py-7" style={{ maxWidth: 1200, margin: "0 auto" }}>
        <header className="mb-6">
          <h1 style={{ fontFamily: FONT.serif, fontSize: 34, fontWeight: 700, color: COLOR.ink, lineHeight: 1.1 }}>
            The {term} Dossier
          </h1>
          <p style={{ fontSize: 13.5, color: COLOR.ink2, marginTop: 8, maxWidth: 620, lineHeight: 1.55 }}>
            Every {term} elective as its official course outline describes it — grade split, exams, group rules,
            attendance, and workload. Read this before you spend a point.
          </p>
        </header>

        {entries.length === 0 ? (
          <EmptyState term={term} termCourseCount={termCourses.length} />
        ) : (
          <>
            <div className="flex flex-wrap gap-3 mb-6">
              <HeadlineStat label="Electives on record" value={String(entries.length)} />
              <HeadlineStat label="With a mid or end-term" value={String(entries.filter((e) => examCount(e.profile) > 0).length)} />
              <HeadlineStat label="Avg. group weight" value={`${Math.round(avg(entries.map((e) => e.profile.grade_group_pct)))}%`} />
              <HeadlineStat label="Avg. workload" value={`${avg(entries.map((e) => pressureScore(e.profile))).toFixed(1)}/10`} />
            </div>

            <div className="flex gap-1 mb-5 overflow-x-auto" style={{ borderBottom: `1px solid ${COLOR.border}` }}>
              <TabButton active={tab === "browse"} onClick={() => setTab("browse")} label="Browse" />
              <TabButton active={tab === "compare"} onClick={() => setTab("compare")} label={`Side by side${pinned.length ? ` (${pinned.length})` : ""}`} />
              <TabButton active={tab === "build"} onClick={() => setTab("build")} label="Build the term" />
            </div>

            {tab === "browse" && (
              <>
                <div className="flex flex-wrap gap-3 mb-5">
                  <Select label="Sort" value={sort} onChange={setSort} options={SORTS.map((s) => ({ value: s.value, label: s.label }))} />
                  <Select label="Filter" value={filter} onChange={setFilter} options={FILTERS.map((f) => ({ value: f.value, label: f.label }))} />
                  <Select
                    label="Concentration"
                    value={conc}
                    onChange={setConc}
                    options={[{ value: "all", label: "All areas" }, ...concentrations.map((c) => ({ value: c, label: c }))]}
                  />
                </div>

                <p style={{ fontSize: 12, color: COLOR.ink3, marginBottom: 12 }}>
                  Showing {visible.length} of {entries.length}. Tap a card for the full read; pin up to {MAX_COMPARE} to compare.
                  {missingProfile > 0 && ` ${missingProfile} course${missingProfile > 1 ? "s have" : " has"} no outline profile yet and ${missingProfile > 1 ? "are" : "is"} not listed.`}
                </p>

                {visible.length === 0 ? (
                  <p style={{ fontSize: 13, color: COLOR.ink2, padding: "28px 0" }}>
                    No {term} elective matches that combination.
                  </p>
                ) : (
                  <div className="grid gap-4" style={{ gridTemplateColumns: "repeat(auto-fill, minmax(290px, 1fr))" }}>
                    {visible.map((e) => (
                      <CourseCard
                        key={e.course.id}
                        entry={e}
                        pinned={pinned.includes(e.course.id)}
                        pinFull={pinned.length >= MAX_COMPARE}
                        onOpen={() => setOpenId(e.course.id)}
                        onPin={() => togglePin(e.course.id)}
                      />
                    ))}
                  </div>
                )}
              </>
            )}

            {tab === "compare" && <CompareTable entries={pinnedEntries} onUnpin={togglePin} />}
            {tab === "build" && <BuildTerm entries={entries} pinned={pinnedEntries} onToggle={togglePin} pinFull={pinned.length >= MAX_COMPARE} />}
          </>
        )}

        <p style={{ fontSize: 11.5, color: COLOR.ink3, marginTop: 32, lineHeight: 1.6, maxWidth: 700 }}>
          Everything here is read off the official ISB course outlines on SharePoint. Workload scores are a judgment
          call, not an ISB rating, and "not stated" means the outline is silent — not that the rule doesn't exist.
          Confirm against the live outline on LMS before you register.
        </p>
      </div>

      {open && <CourseModal entry={open} onClose={() => setOpenId(null)} />}
    </div>
  );
}

function EmptyState({ term, termCourseCount }: { term: string; termCourseCount: number }) {
  return (
    <div style={{ background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, padding: "34px 26px" }}>
      <p style={{ fontSize: 15, fontWeight: 700, color: COLOR.ink }}>No dossier for {term} yet</p>
      <p style={{ fontSize: 13, color: COLOR.ink2, marginTop: 6, lineHeight: 1.6, maxWidth: 560 }}>
        {termCourseCount > 0
          ? `${term} has ${termCourseCount} elective${termCourseCount > 1 ? "s" : ""} in the catalog, but none has a grading profile yet. An admin can add them from the Courses tab once the outlines are published, and this page fills in on its own.`
          : `No electives are in the catalog for ${term}. Check the term in the URL.`}
      </p>
    </div>
  );
}

function HeadlineStat({ label, value }: { label: string; value: string }) {
  return (
    <div style={{ background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, borderRadius: 10, padding: "10px 16px", minWidth: 130 }}>
      <p style={{ fontSize: 21, fontWeight: 700, color: COLOR.navyHero, fontFamily: FONT.sans }}>{value}</p>
      <p style={{ fontSize: 10.5, color: COLOR.ink3, marginTop: 1 }}>{label}</p>
    </div>
  );
}

function TabButton({ active, onClick, label }: { active: boolean; onClick: () => void; label: string }) {
  return (
    <button
      onClick={onClick}
      style={{
        padding: "9px 16px", fontSize: 13, fontWeight: active ? 700 : 500, fontFamily: FONT.sans,
        color: active ? COLOR.navyHero : COLOR.ink2, background: "none", border: "none", cursor: "pointer",
        borderBottom: `2px solid ${active ? COLOR.navyHero : "transparent"}`, marginBottom: -1, whiteSpace: "nowrap",
      }}
    >
      {label}
    </button>
  );
}

function Select({ label, value, onChange, options }: { label: string; value: string; onChange: (v: string) => void; options: { value: string; label: string }[] }) {
  return (
    <label style={{ display: "flex", flexDirection: "column", gap: 4 }}>
      <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.ink3, textTransform: "uppercase", letterSpacing: "0.05em" }}>{label}</span>
      <select
        value={value}
        onChange={(e) => onChange(e.target.value)}
        style={{
          fontSize: 12.5, fontFamily: FONT.sans, color: COLOR.ink, background: COLOR.surface,
          border: `1px solid ${COLOR.border}`, borderRadius: 8, padding: "7px 10px", cursor: "pointer", minWidth: 180,
        }}
      >
        {options.map((o) => (
          <option key={o.value} value={o.value}>{o.label}</option>
        ))}
      </select>
    </label>
  );
}

function GradeBar({ p, height = 18 }: { p: CourseGradingProfile; height?: number }) {
  const segs = [
    { pct: p.grade_participation_pct, color: COLOR.mint, label: "Participation" },
    { pct: p.grade_individual_pct, color: COLOR.navyHero, label: "Individual" },
    { pct: p.grade_group_pct, color: COLOR.amber, label: "Group" },
    { pct: p.grade_exam_pct, color: COLOR.red, label: "Exam" },
  ].filter((s) => s.pct > 0);

  return (
    <div className="flex" style={{ height, borderRadius: 5, overflow: "hidden" }}>
      {segs.map((s) => (
        <div
          key={s.label}
          title={`${s.label} ${s.pct}%`}
          style={{ width: `${s.pct}%`, background: s.color, display: "flex", alignItems: "center", justifyContent: "center" }}
        >
          {s.pct >= 12 && <span style={{ fontSize: 9.5, fontWeight: 700, color: "#fff" }}>{s.pct}%</span>}
        </div>
      ))}
    </div>
  );
}

function Tag({ children }: { children: React.ReactNode }) {
  return (
    <span style={{ fontSize: 10.5, fontWeight: 600, color: COLOR.ink2, background: COLOR.bgSoft, border: `1px solid ${COLOR.borderLight}`, borderRadius: 20, padding: "3px 9px" }}>
      {children}
    </span>
  );
}

function PressurePill({ score }: { score: number }) {
  const tier = pressureTier(score);
  const { fg, bg } = TIER_COLOR[tier];
  return (
    <span style={{ fontSize: 10.5, fontWeight: 700, color: fg, background: bg, borderRadius: 20, padding: "3px 10px", whiteSpace: "nowrap" }}>
      {tier} · {score.toFixed(1)}
    </span>
  );
}

function CourseCard({ entry, pinned, pinFull, onOpen, onPin }: { entry: Entry; pinned: boolean; pinFull: boolean; onOpen: () => void; onPin: () => void }) {
  const { course, profile } = entry;
  const score = pressureScore(profile);

  return (
    <div style={{ background: COLOR.surface, border: `1px solid ${pinned ? COLOR.navyHero : COLOR.borderLight}`, borderRadius: 12, padding: "15px 16px", display: "flex", flexDirection: "column", gap: 10 }}>
      <button onClick={onOpen} style={{ textAlign: "left", background: "none", border: "none", padding: 0, cursor: "pointer", display: "flex", flexDirection: "column", gap: 8 }}>
        <div className="flex items-start justify-between gap-2">
          <div>
            <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.navyHero, letterSpacing: "0.06em" }}>{course.code}</p>
            <p style={{ fontSize: 14.5, fontWeight: 700, color: COLOR.ink, lineHeight: 1.3, marginTop: 2, fontFamily: FONT.sans }}>{course.name}</p>
            <p style={{ fontSize: 11.5, color: COLOR.ink3, marginTop: 3 }}>{course.professor}</p>
          </div>
          <PressurePill score={score} />
        </div>

        <div style={{ width: "100%" }}>
          <GradeBar p={profile} />
          <p style={{ fontSize: 11, color: COLOR.ink3, marginTop: 5 }}>{examSummary(profile)}</p>
        </div>

        <div className="flex flex-wrap gap-1.5">
          {tagsFor(profile).slice(0, 4).map((t) => <Tag key={t}>{t}</Tag>)}
        </div>
      </button>

      <div className="flex items-center justify-between gap-2" style={{ marginTop: "auto", paddingTop: 8, borderTop: `1px solid ${COLOR.borderLight}` }}>
        <button onClick={onOpen} style={{ fontSize: 11.5, fontWeight: 700, color: COLOR.navyHero, background: "none", border: "none", cursor: "pointer", padding: 0 }}>
          Full read →
        </button>
        <button
          onClick={onPin}
          disabled={!pinned && pinFull}
          style={{
            fontSize: 11.5, fontWeight: 700, background: "none", border: "none", padding: 0,
            color: pinned ? COLOR.amber : !pinned && pinFull ? COLOR.ink3 : COLOR.ink2,
            cursor: !pinned && pinFull ? "not-allowed" : "pointer",
          }}
        >
          {pinned ? "Pinned ✓" : "+ Compare"}
        </button>
      </div>
    </div>
  );
}

/** null/undefined never becomes a claim — it says the outline is silent. */
function factValue(v: string | boolean | null | undefined, yes: string, no: string): string {
  if (v === null || v === undefined || v === "") return "Not stated in the outline";
  if (v === true) return yes;
  if (v === false) return no;
  return v;
}

// The stored attendance values are short enough to filter on but too terse to
// read; this is what a student actually needs to know about each one.
const ATTENDANCE_TEXT: Record<AttendancePolicy, string> = {
  "Not mandatory": "Not mandatory — the outline says so explicitly",
  "ISB policy": "Standard ISB policy — one missed session already costs you a letter grade",
  "Participation-linked": "Standard ISB policy, and showing up feeds your participation marks on top",
  "Stricter than ISB policy": "Stricter than the ISB default — this course adds penalties of its own",
};

function factsFor(p: CourseGradingProfile): { label: string; value: string }[] {
  return [
    { label: "Exams", value: examSummary(p) },
    { label: "Group size", value: factValue(p.group_size, "", "") },
    { label: "Groups across sections", value: factValue(p.cross_section, "Allowed", "Same section only") },
    { label: "How groups form", value: factValue(p.group_formation, "", "") },
    { label: "Peer evaluation", value: factValue(p.peer_eval, "Yes — it moves your individual grade", "No peer evaluation component") },
    { label: "Attendance", value: p.attendance ? ATTENDANCE_TEXT[p.attendance] : factValue(null, "", "") },
  ];
}

function CourseModal({ entry, onClose }: { entry: Entry; onClose: () => void }) {
  const { course, profile } = entry;
  const score = pressureScore(profile);

  return (
    <div
      onClick={onClose}
      style={{ position: "fixed", inset: 0, background: "rgba(17,17,17,.45)", zIndex: 60, display: "flex", alignItems: "flex-start", justifyContent: "center", padding: "5vh 16px", overflowY: "auto" }}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        style={{ background: COLOR.surface, borderRadius: 14, maxWidth: 680, width: "100%", padding: "22px 24px 26px" }}
      >
        <div className="flex items-start justify-between gap-3 mb-4">
          <div>
            <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.navyHero, letterSpacing: "0.06em" }}>{course.code}</p>
            <h2 style={{ fontFamily: FONT.serif, fontSize: 22, fontWeight: 700, color: COLOR.ink, lineHeight: 1.2, marginTop: 3 }}>{course.name}</h2>
            <p style={{ fontSize: 12.5, color: COLOR.ink2, marginTop: 4 }}>
              {course.professor} · {course.concentration_areas.join(", ") || "No concentration area"}
            </p>
          </div>
          <button onClick={onClose} aria-label="Close" style={{ fontSize: 18, color: COLOR.ink3, background: "none", border: "none", cursor: "pointer", lineHeight: 1, flexShrink: 0 }}>✕</button>
        </div>

        <div className="flex items-center gap-2 mb-4">
          <PressurePill score={score} />
          <span style={{ fontSize: 11, color: COLOR.ink3 }}>average of the six workload scores below, on a 10-point scale</span>
        </div>

        <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.ink3, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 6 }}>How the grade splits</p>
        <GradeBar p={profile} height={22} />
        <div className="flex flex-wrap gap-x-3 gap-y-1 mt-2 mb-5">
          <Legend color={COLOR.mint} label={`Participation ${profile.grade_participation_pct}%`} />
          <Legend color={COLOR.navyHero} label={`Individual ${profile.grade_individual_pct}%`} />
          <Legend color={COLOR.amber} label={`Group ${profile.grade_group_pct}%`} />
          <Legend color={COLOR.red} label={`Exam ${profile.grade_exam_pct}%`} />
        </div>

        <div className="flex flex-col sm:flex-row gap-5 mb-5">
          <div style={{ flexShrink: 0 }}>
            <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.ink3, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 4 }}>Workload profile</p>
            <div dangerouslySetInnerHTML={{ __html: buildRadar([profile]) }} />
          </div>
          <div className="flex-1">
            <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.ink3, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 6 }}>Rules that bite</p>
            <dl className="space-y-2">
              {factsFor(profile).map((f) => (
                <div key={f.label}>
                  <dt style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink }}>{f.label}</dt>
                  <dd style={{ fontSize: 12, color: COLOR.ink2, lineHeight: 1.45 }}>{f.value}</dd>
                </div>
              ))}
            </dl>
          </div>
        </div>

        {profile.brief.length > 0 && (
          <>
            <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.ink3, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 6 }}>The full read</p>
            <ul className="space-y-2 mb-5" style={{ listStyle: "none" }}>
              {profile.brief.map((b) => (
                <li key={b.label} style={{ fontSize: 12.5, color: COLOR.ink2, lineHeight: 1.55 }}>
                  <b style={{ color: COLOR.ink }}>{b.label}</b> — {b.text}
                </li>
              ))}
            </ul>
          </>
        )}

        {profile.source_url && (
          <a href={profile.source_url} target="_blank" rel="noopener noreferrer" style={{ fontSize: 12, fontWeight: 700, color: COLOR.navyHero, textDecoration: "underline" }}>
            Read the official course outline ↗
          </a>
        )}
      </div>
    </div>
  );
}

function Legend({ color, label }: { color: string; label: string }) {
  return (
    <span className="flex items-center gap-1" style={{ fontSize: 10.5, color: COLOR.ink3 }}>
      <span style={{ width: 7, height: 7, borderRadius: 2, background: color, display: "inline-block" }} />
      {label}
    </span>
  );
}

function CompareTable({ entries, onUnpin }: { entries: Entry[]; onUnpin: (id: string) => void }) {
  if (entries.length === 0) {
    return (
      <div style={{ background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, padding: "34px 26px", textAlign: "center" }}>
        <p style={{ fontSize: 14, fontWeight: 700, color: COLOR.ink }}>Nothing pinned yet</p>
        <p style={{ fontSize: 12.5, color: COLOR.ink2, marginTop: 5 }}>
          Pin 2–{MAX_COMPARE} courses from Browse to lay them side by side.
        </p>
      </div>
    );
  }

  const rows: { label: string; get: (e: Entry) => string }[] = [
    { label: "Professor", get: (e) => e.course.professor },
    { label: "Concentration", get: (e) => e.course.concentration_areas.join(", ") || "—" },
    { label: "Workload", get: (e) => `${pressureTier(pressureScore(e.profile))} · ${pressureScore(e.profile).toFixed(1)}/10` },
    { label: "Participation", get: (e) => `${e.profile.grade_participation_pct}%` },
    { label: "Individual", get: (e) => `${e.profile.grade_individual_pct}%` },
    { label: "Group", get: (e) => `${e.profile.grade_group_pct}%` },
    { label: "Exam", get: (e) => `${e.profile.grade_exam_pct}%` },
    ...factsFor(entries[0].profile).map((f, i) => ({ label: f.label, get: (e: Entry) => factsFor(e.profile)[i].value })),
    ...LOAD_AXES.map((ax) => ({ label: ax.label, get: (e: Entry) => `${e.profile[ax.key]}/5` })),
  ];

  return (
    <div style={{ overflowX: "auto", border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, background: COLOR.surface }}>
      <table style={{ borderCollapse: "collapse", width: "100%", minWidth: 520 }}>
        <thead>
          <tr>
            <th style={{ ...thStyle, minWidth: 140 }} />
            {entries.map((e) => (
              <th key={e.course.id} style={{ ...thStyle, minWidth: 170 }}>
                <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.navyHero }}>{e.course.code}</p>
                <p style={{ fontSize: 13, fontWeight: 700, color: COLOR.ink, lineHeight: 1.3, marginTop: 2 }}>{e.course.name}</p>
                <button onClick={() => onUnpin(e.course.id)} style={{ fontSize: 10.5, color: COLOR.ink3, background: "none", border: "none", cursor: "pointer", padding: "4px 0 0" }}>
                  Unpin
                </button>
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.label}>
              <td style={{ ...tdStyle, fontWeight: 700, color: COLOR.ink, background: COLOR.bgSoft }}>{r.label}</td>
              {entries.map((e) => (
                <td key={e.course.id} style={tdStyle}>{r.get(e)}</td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

const thStyle: React.CSSProperties = {
  textAlign: "left", padding: "12px 14px", borderBottom: `1px solid ${COLOR.border}`, verticalAlign: "top", fontFamily: FONT.sans,
};

const tdStyle: React.CSSProperties = {
  padding: "9px 14px", borderBottom: `1px solid ${COLOR.borderLight}`, fontSize: 12, color: COLOR.ink2, verticalAlign: "top", fontFamily: FONT.sans, lineHeight: 1.45,
};

function BuildTerm({ entries, pinned, onToggle, pinFull }: { entries: Entry[]; pinned: Entry[]; onToggle: (id: string) => void; pinFull: boolean }) {
  const profileList = pinned.map((e) => e.profile);
  const midterms = profileList.reduce((s, p) => s + p.exam_midterm_count, 0);
  const endterms = profileList.reduce((s, p) => s + p.exam_endterm_count, 0);
  const quizzes = profileList.reduce((s, p) => s + p.exam_quiz_count, 0);
  const meanPressure = avg(profileList.map(pressureScore));
  const meanGroup = avg(profileList.map((p) => p.grade_group_pct));

  return (
    <div className="flex flex-col lg:flex-row gap-5">
      <div style={{ flex: 1, minWidth: 0 }}>
        <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.ink3, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 8 }}>
          Pick up to {MAX_COMPARE}
        </p>
        <div className="space-y-1.5">
          {entries.map((e) => {
            const on = pinned.some((p) => p.course.id === e.course.id);
            return (
              <button
                key={e.course.id}
                onClick={() => onToggle(e.course.id)}
                disabled={!on && pinFull}
                className="w-full flex items-center justify-between gap-3"
                style={{
                  textAlign: "left", padding: "9px 13px", borderRadius: 9, cursor: !on && pinFull ? "not-allowed" : "pointer",
                  background: on ? COLOR.navyTint : COLOR.surface,
                  border: `1px solid ${on ? COLOR.navyHero : COLOR.borderLight}`,
                  opacity: !on && pinFull ? 0.5 : 1,
                }}
              >
                <span style={{ fontSize: 12.5, fontWeight: 600, color: COLOR.ink, fontFamily: FONT.sans }}>
                  <b>{e.course.code}</b> · {e.course.name}
                </span>
                <PressurePill score={pressureScore(e.profile)} />
              </button>
            );
          })}
        </div>
      </div>

      <div style={{ width: "100%", maxWidth: 360, flexShrink: 0 }}>
        <div style={{ background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, padding: "18px 18px 20px", position: "sticky", top: 16 }}>
          <p style={{ fontSize: 15, fontWeight: 700, color: COLOR.ink, fontFamily: FONT.sans }}>Your working term</p>

          {pinned.length === 0 ? (
            <p style={{ fontSize: 12.5, color: COLOR.ink2, marginTop: 6, lineHeight: 1.55 }}>
              Pick courses on the left to see the combined load.
            </p>
          ) : (
            <>
              <p style={{ fontSize: 12, color: COLOR.ink3, marginTop: 3, marginBottom: 12 }}>
                {pinned.length} course{pinned.length > 1 ? "s" : ""} · {meanPressure.toFixed(1)}/10 average workload
              </p>

              <div dangerouslySetInnerHTML={{ __html: buildRadar(profileList) }} />

              <div className="grid grid-cols-3 gap-2 mt-4">
                <MiniStat label="Mid-terms" value={midterms} tint={COLOR.amberTint} color={COLOR.amber} />
                <MiniStat label="End-terms" value={endterms} tint={COLOR.redTint} color={COLOR.red} />
                <MiniStat label="Quizzes" value={quizzes} tint={COLOR.navyTint} color={COLOR.navyHero} />
              </div>

              <p style={{ fontSize: 12.5, color: COLOR.ink2, marginTop: 14, lineHeight: 1.55 }}>
                {verdict(meanPressure, midterms + endterms, meanGroup)}
              </p>
            </>
          )}
        </div>
      </div>
    </div>
  );
}

/** Describes the shape of the selection rather than scoring it — the trade-off is the student's to make. */
function verdict(meanPressure: number, sitDownExams: number, meanGroup: number): string {
  const load =
    meanPressure <= 4 ? "This is a light term on paper."
      : meanPressure <= 6.5 ? "This is a middling term on paper."
        : "This is a heavy term on paper.";
  const exams =
    sitDownExams === 0 ? " No sit-down exams at all, so the pressure sits in deadlines rather than exam weeks."
      : sitDownExams <= 2 ? ` ${sitDownExams} sit-down exam${sitDownExams > 1 ? "s" : ""} to schedule around.`
        : ` ${sitDownExams} sit-down exams — check they don't land in the same week.`;
  const group =
    meanGroup >= 40 ? " Group work carries most of the grade, so your teams matter more than your own effort."
      : meanGroup <= 20 ? " Very little rides on group work; this is mostly on you."
        : "";
  return load + exams + group;
}

function MiniStat({ label, value, tint, color }: { label: string; value: number; tint: string; color: string }) {
  return (
    <div style={{ padding: "8px 10px", borderRadius: 8, background: tint }}>
      <p style={{ fontSize: 18, fontWeight: 700, color, fontFamily: FONT.sans }}>{value}</p>
      <p style={{ fontSize: 10, color, opacity: 0.85 }}>{label}</p>
    </div>
  );
}
