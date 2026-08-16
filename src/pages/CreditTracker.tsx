/**
 * Credit Tracker — a record of what a student actually ended up enrolled in,
 * separate from the Bidding Planner's forward-looking plan. Bidding results
 * (and grades) can differ from intentions, so this reads against its own
 * actual_enrollments table rather than bid_plan_entries.
 *
 * Once a bidding round's term has ended, its planned entries surface here as a
 * reconciliation queue ("did you get it, for how much?") before falling back to
 * a blank picker — reusing what the student already told the Planner rather
 * than asking them to re-enter it.
 */
import { useMemo, useState } from "react";
import { useNavigate, useOutletContext } from "react-router-dom";
import { GraduationCap, Wallet, Receipt, Award, CheckCircle2, X, ChevronDown, Brain } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { useAcademicProfile } from "../hooks/useAcademicProfile";
import { useActualEnrollments, type ActualEnrollment } from "../hooks/useActualEnrollments";
import { useBidPlan, TOTAL_BID_POINTS, TOTAL_ELECTIVE_CREDITS_REQUIRED } from "../hooks/useBidPlan";
import type { BidPlanEntry } from "../hooks/useBidPlan";
import { TERM_SEQUENCE } from "../lib/termCalendar";
import {
  REQUIRED_CREDITS_PER_AREA, isBiddableTerm, pendingReconciliations,
  totalElectiveCreditsSecured, computeBidBudget, creditsCountingToward,
} from "../lib/creditProgress";
import Dropdown, { type DropdownGroup } from "../components/Dropdown";
import type { Course, StudentAcademicProfile, User } from "../types";

const TERM_ORDER = TERM_SEQUENCE.filter(isBiddableTerm);
const EARLIER_TERMS = ["Term 1", "Term 2", "Term 3"];
const GRADE_OPTIONS = ["A", "A-", "B", "B-", "C", "C-", "D", "F", "Pass", "Fail"];
const GRADE_GROUPS: DropdownGroup[] = [{ label: "Grade", options: GRADE_OPTIONS.map((g) => ({ value: g, label: g })) }];

// ISB's actual scale, confirmed against a real elearn.isb.edu letter grade
// report (Eshan's own Term 1: C=2, B=3, A-=3.5, credit-weighted average
// reproduced that report's GPA of 3.18 exactly). Whole letters sit on integers
// (A=4, B=3, C=2, D=1, F=0); the "-" grades shift down by 0.5. ISB has no "+"
// grades. Only C/B/A- are directly confirmed — the rest follow that same
// confirmed step pattern, not independently verified.
// Pass/Fail-designated courses are excluded from GPA per the Programme
// Structure doc; the letter grade "F" (a real failing grade, not a Pass/Fail
// course) still counts.
const GRADE_POINTS: Record<string, number> = {
  "A": 4.0, "A-": 3.5,
  "B": 3.0, "B-": 2.5,
  "C": 2.0, "C-": 1.5,
  "D": 1.0, "F": 0.0,
};

function computeGPA(entries: ActualEnrollment[], courses: Course[]): number | null {
  let creditSum = 0;
  let pointSum = 0;
  for (const e of entries) {
    const points = e.grade ? GRADE_POINTS[e.grade] : undefined;
    if (points === undefined) continue;
    const course = courses.find((c) => c.id === e.course_id);
    const credits = course ? Number(course.credits) : 0;
    creditSum += credits;
    pointSum += credits * points;
  }
  return creditSum > 0 ? pointSum / creditSum : null;
}

export default function CreditTracker() {
  const { user } = useOutletContext<{ user: User }>();
  const { courses, loading: coursesLoading } = useCourses();
  const { profile } = useAcademicProfile(user.id);
  const { entries: bidEntries, resolveEntry } = useBidPlan(user.id);
  const { entries, addEntry, updateEntry, removeEntry, upsertGrade, pointsPaid } = useActualEnrollments(user.id);
  const [showLearnPromo, setShowLearnPromo] = useState(true);

  if (coursesLoading || !profile) {
    return <div style={{ padding: 40, fontFamily: FONT.sans, color: COLOR.ink2 }}>Loading…</div>;
  }

  const creditsSecured = totalElectiveCreditsSecured(profile, courses, entries);
  const gpa = computeGPA(entries, courses);
  const { reserved, exchangePointsUsed, pointsAvailable, remainingPoints } = computeBidBudget(profile, courses, entries, pointsPaid);
  const overFullBudget = pointsAvailable < 0;
  const dippingIntoReserve = !overFullBudget && remainingPoints < 0;
  const pending = pendingReconciliations(bidEntries);

  const areas: { name: string; kind: "concentration" | "specialization" }[] = [
    ...profile.target_concentrations.map((c) => ({ name: c, kind: "concentration" as const })),
    ...(profile.target_specialization && !["none", "undecided"].includes(profile.target_specialization)
      ? [{ name: profile.target_specialization, kind: "specialization" as const }]
      : []),
  ];

  async function handleResolve(entry: BidPlanEntry, gotIt: boolean, points: number) {
    if (gotIt) {
      await resolveEntry(entry.id, points);
      if (entry.course_id) await addEntry({ course_id: entry.course_id, term: entry.term, points_paid: points, grade: null });
    } else {
      await resolveEntry(entry.id, 0);
    }
  }

  return (
    <div className="min-h-screen pb-24" style={{ background: COLOR.bg }}>
      {showLearnPromo && <LearnPromoPopup onDismiss={() => setShowLearnPromo(false)} />}
      <header className="px-6 md:px-12 pt-10 pb-6">
        <h1 style={{ fontFamily: FONT.serif, fontSize: 26, fontWeight: 500, color: COLOR.ink }}>
          Credit <em>Tracker</em>
        </h1>
        <p style={{ fontFamily: FONT.serif, fontSize: 15, color: COLOR.ink2, marginTop: 10, maxWidth: 620, lineHeight: 1.6 }}>
          What you actually ended up with — bidding results don't always match a plan, so this is logged separately from your Bidding Planner.
        </p>

        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 mt-6" style={{ maxWidth: 920 }}>
          <StatCard
            icon={<GraduationCap size={17} />}
            label="Elective credits secured"
            value={creditsSecured}
            total={TOTAL_ELECTIVE_CREDITS_REQUIRED}
          />
          <StatCard
            icon={<Wallet size={17} />}
            label="Bid points remaining"
            value={pointsAvailable}
            warn={overFullBudget}
          />
          <StatCard
            icon={<Receipt size={17} />}
            label="Points paid so far"
            value={pointsPaid}
          />
          <StatCard
            icon={<Award size={17} />}
            label="Overall GPA"
            value={gpa}
            total={gpa !== null ? 4.0 : undefined}
            decimals={2}
          />
        </div>
        <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 10, maxWidth: 560, lineHeight: 1.5 }}>
          Out of your full {TOTAL_BID_POINTS.toLocaleString()}-point budget, minus {exchangePointsUsed} exchange points already
          spent (edit that in the Bidding Planner's Bid Budget step). ISB also asks you to hold back 100 points per elective
          credit you still need ({reserved} pts right now). GPA uses ISB's own scale (A=4.0, B=3.0, C=2.0, D=1.0, F=0,
          +/- shifts by 0.5), credit-weighted across every graded course.
        </p>
        {dippingIntoReserve && (
          <div style={{
            marginTop: 8, padding: "10px 14px", borderRadius: 9, background: COLOR.redTint,
            color: COLOR.red, fontFamily: FONT.sans, fontSize: 12.5, fontWeight: 600, maxWidth: 560,
          }}>
            You're {Math.abs(remainingPoints)} points into the reserve ISB holds back for your remaining required credits.
          </div>
        )}
      </header>

      <main className="px-6 md:px-12 space-y-8" style={{ maxWidth: 1000 }}>
        {pending.length > 0 && (
          <ReconciliationQueue pending={pending} courses={courses} onResolve={handleResolve} />
        )}

        {areas.length > 0 && (
          <div>
            <SectionLabel>Concentration & specialization progress</SectionLabel>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
              {areas.map((area) => (
                <AreaProgress key={area.name} area={area.name} kind={area.kind} profile={profile} courses={courses} entries={entries} />
              ))}
            </div>
          </div>
        )}

        <div>
          <SectionLabel>Term 1–3 grades</SectionLabel>
          <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 10, maxWidth: 560 }}>
            Core courses and the Flexi Core you told the Bidding Planner you completed — not bid on, but still worth logging a grade for your own GPA tracking.
          </p>
          <EarlierTermsGrades courses={courses} profile={profile} entries={entries} onSetGrade={upsertGrade} />
        </div>

        <div>
          <SectionLabel>Log a confirmed course</SectionLabel>
          <AddEntryForm courses={courses} entries={entries} onAdd={addEntry} />
        </div>

        <div>
          <SectionLabel>Your confirmed courses</SectionLabel>
          <TermLedger entries={entries} courses={courses} onUpdate={updateEntry} onRemove={removeEntry} />
        </div>
      </main>
    </div>
  );
}

function LearnPromoPopup({ onDismiss }: { onDismiss: () => void }) {
  const navigate = useNavigate();

  return (
    <div style={{ position: "fixed", inset: 0, zIndex: 60, display: "flex", alignItems: "center", justifyContent: "center", padding: 20 }}>
      <div onClick={onDismiss} style={{ position: "absolute", inset: 0, background: "rgba(0,0,0,0.45)" }} />
      <div style={{ position: "relative", background: COLOR.surface, borderRadius: 14, padding: 24, maxWidth: 380, width: "100%" }}>
        <button
          onClick={onDismiss}
          aria-label="Dismiss"
          style={{ position: "absolute", top: 14, right: 14, background: "none", border: "none", cursor: "pointer", color: COLOR.ink3 }}
        >
          <X size={16} />
        </button>
        <div
          style={{
            width: 40, height: 40, borderRadius: 10, background: COLOR.navyTint,
            color: COLOR.navyHero, display: "flex", alignItems: "center", justifyContent: "center", marginBottom: 14,
          }}
        >
          <Brain size={20} />
        </div>
        <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 8 }}>
          Check out the Learn tab
        </p>
        <p style={{ fontSize: 13.5, color: COLOR.ink2, fontFamily: FONT.sans, lineHeight: 1.5, marginBottom: 20 }}>
          Adaptive practice quizzes pulled straight from your course material — a quick way to prep before bidding.
        </p>
        <div className="flex justify-end gap-2">
          <button
            onClick={onDismiss}
            style={{ padding: "8px 14px", borderRadius: 7, border: `1px solid ${COLOR.border}`, background: COLOR.surface, color: COLOR.ink2, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer" }}
          >
            Maybe later
          </button>
          <button
            onClick={() => {
              onDismiss();
              navigate("/learn/practice");
            }}
            style={{ padding: "8px 14px", borderRadius: 7, border: "none", background: COLOR.navyHero, color: "#fff", fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer" }}
          >
            Attempt a quiz
          </button>
        </div>
      </div>
    </div>
  );
}

function SectionLabel({ children }: { children: React.ReactNode }) {
  return (
    <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 10 }}>
      {children}
    </p>
  );
}

/** Collapsed by default — a term's worth of course rows is the biggest single
 * contributor to page length, and most of the time a student only needs one
 * term open at once. The summary line carries the useful bit either way. */
function TermGroup({ term, summary, children }: { term: string; summary: string; children: React.ReactNode }) {
  return (
    <details className="term-group">
      <summary className="flex items-center justify-between" style={{ padding: "8px 2px" }}>
        <span style={{ fontSize: 12, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink2 }}>{term}</span>
        <span className="flex items-center gap-1.5">
          <span style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans }}>{summary}</span>
          <ChevronDown className="chevron" size={14} color={COLOR.ink3} />
        </span>
      </summary>
      <div className="space-y-2 mt-2">{children}</div>
    </details>
  );
}

function StatCard({
  icon, label, value, total, warn, decimals,
}: { icon: React.ReactNode; label: string; value: number | null; total?: number; warn?: boolean; decimals?: number }) {
  const pct = total && value !== null ? Math.min(100, (value / total) * 100) : null;
  const fmt = (n: number) => (decimals !== undefined ? n.toFixed(decimals) : n);
  return (
    <div style={{ padding: "14px 16px", borderRadius: 12, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
      <div className="flex items-center gap-2 mb-1.5" style={{ color: warn ? COLOR.red : COLOR.navyHero }}>
        {icon}
        <span style={{ fontSize: 11, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink3, textTransform: "uppercase", letterSpacing: "0.04em" }}>{label}</span>
      </div>
      <p style={{ fontSize: 24, fontWeight: 700, fontFamily: FONT.sans, color: warn ? COLOR.red : COLOR.ink }}>
        {value !== null ? fmt(value) : "—"}
        {total !== undefined && value !== null && <span style={{ fontSize: 14, color: COLOR.ink3, fontWeight: 600 }}>/{fmt(total)}</span>}
      </p>
      {pct !== null && (
        <div style={{ height: 5, borderRadius: 3, background: COLOR.borderLight, overflow: "hidden", marginTop: 8 }}>
          <div style={{ height: "100%", width: `${pct}%`, background: COLOR.navyHero, borderRadius: 3, transition: "width 400ms ease-out" }} />
        </div>
      )}
    </div>
  );
}

function ReconciliationQueue({
  pending, courses, onResolve,
}: {
  pending: BidPlanEntry[]; courses: Course[];
  onResolve: (entry: BidPlanEntry, gotIt: boolean, points: number) => Promise<void>;
}) {
  return (
    <div>
      <SectionLabel>Did you get these?</SectionLabel>
      <div className="space-y-2">
        {pending.map((entry, i) => (
          <ReconciliationCard key={entry.id} entry={entry} course={courses.find((c) => c.id === entry.course_id)} onResolve={onResolve} delay={i * 40} />
        ))}
      </div>
    </div>
  );
}

function ReconciliationCard({
  entry, course, onResolve, delay,
}: {
  entry: BidPlanEntry; course: Course | undefined; onResolve: (entry: BidPlanEntry, gotIt: boolean, points: number) => Promise<void>; delay: number;
}) {
  const [points, setPoints] = useState(entry.planned_points);
  const [submitting, setSubmitting] = useState<"yes" | "no" | null>(null);

  async function handle(gotIt: boolean) {
    setSubmitting(gotIt ? "yes" : "no");
    try {
      await onResolve(entry, gotIt, points);
    } finally {
      setSubmitting(null);
    }
  }

  return (
    <div
      className="row-enter flex flex-col sm:flex-row sm:items-center gap-3"
      style={{ animationDelay: `${delay}ms`, padding: "14px 16px", borderRadius: 10, background: COLOR.amberTint, border: `1px solid #F0DBA8` }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <p style={{ fontSize: 13.5, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>{course?.name ?? "Unknown course"}</p>
        <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans }}>{entry.term} · You bid {entry.planned_points} pts</p>
      </div>
      <div className="flex items-center gap-2 flex-shrink-0">
        <input
          type="number" min={0} value={points} onChange={(e) => setPoints(Number(e.target.value) || 0)}
          aria-label="Points actually paid"
          style={{ width: 84, padding: "7px 9px", borderRadius: 7, border: `1px solid ${COLOR.border}`, fontSize: 12.5, fontFamily: FONT.sans, background: COLOR.surface }}
        />
        <button
          onClick={() => handle(true)}
          disabled={submitting !== null}
          style={{
            display: "flex", alignItems: "center", gap: 5, padding: "7px 12px", borderRadius: 7, border: "none",
            background: COLOR.navyHero, color: "#fff", fontSize: 12, fontWeight: 700, fontFamily: FONT.sans,
            cursor: submitting !== null ? "default" : "pointer", opacity: submitting !== null ? 0.6 : 1, whiteSpace: "nowrap",
          }}
        >
          <CheckCircle2 size={13} /> {submitting === "yes" ? "Saving…" : "Got it"}
        </button>
        <button
          onClick={() => handle(false)}
          disabled={submitting !== null}
          style={{
            display: "flex", alignItems: "center", gap: 5, padding: "7px 12px", borderRadius: 7, border: `1px solid ${COLOR.border}`,
            background: COLOR.surface, color: COLOR.ink2, fontSize: 12, fontWeight: 700, fontFamily: FONT.sans,
            cursor: submitting !== null ? "default" : "pointer", opacity: submitting !== null ? 0.6 : 1, whiteSpace: "nowrap",
          }}
        >
          <X size={13} /> {submitting === "no" ? "Saving…" : "Didn't get it"}
        </button>
      </div>
    </div>
  );
}

function AreaProgress({
  area, kind, profile, courses, entries,
}: {
  area: string; kind: "concentration" | "specialization";
  profile: StudentAcademicProfile; courses: Course[]; entries: ActualEnrollment[];
}) {
  const credits = creditsCountingToward(area as never, kind, profile, courses, entries);
  const pct = Math.min(100, (credits / REQUIRED_CREDITS_PER_AREA) * 100);
  const complete = credits >= REQUIRED_CREDITS_PER_AREA;

  return (
    <div style={{ padding: "12px 14px", borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
      <div className="flex items-center justify-between mb-1.5">
        <p style={{ fontSize: 12.5, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{area}</p>
        <p style={{ fontSize: 11.5, color: complete ? COLOR.green : COLOR.ink3, fontFamily: FONT.sans, fontWeight: 700, flexShrink: 0, marginLeft: 8 }}>
          {credits}/{REQUIRED_CREDITS_PER_AREA}
        </p>
      </div>
      <div style={{ height: 6, borderRadius: 3, background: COLOR.borderLight, overflow: "hidden" }}>
        <div style={{ height: "100%", width: `${pct}%`, background: complete ? COLOR.green : COLOR.navyHero, borderRadius: 3, transition: "width 400ms ease-out" }} />
      </div>
    </div>
  );
}

/** Term 1-3 core (mandatory, same for everyone) plus whichever Flexi Core the
 * student told the Planner they completed — the courses that never went through
 * bidding, so they'd otherwise have no grade-tracking home at all. */
function earlierTermCourses(courses: Course[], profile: StudentAcademicProfile): Course[] {
  const core = courses.filter((c) => c.is_core && EARLIER_TERMS.includes(c.term));
  const flexiCodes = new Set([...profile.completed_term2_flexi, ...profile.completed_term3_flexi]);
  const flexi = courses.filter((c) => flexiCodes.has(c.code));
  return [...core, ...flexi];
}

function EarlierTermsGrades({
  courses, profile, entries, onSetGrade,
}: {
  courses: Course[]; profile: StudentAcademicProfile; entries: ActualEnrollment[];
  onSetGrade: (courseId: string, term: string, grade: string | null) => Promise<void>;
}) {
  const items = earlierTermCourses(courses, profile);
  const grouped = EARLIER_TERMS
    .map((term) => ({ term, items: items.filter((c) => c.term === term) }))
    .filter((g) => g.items.length > 0);

  if (grouped.length === 0) {
    return <p style={{ fontSize: 13, color: COLOR.ink3, fontFamily: FONT.sans }}>Nothing here yet — Term 1's core courses will show up once the catalog has them.</p>;
  }

  return (
    <div className="space-y-2">
      {grouped.map(({ term, items }) => {
        const gradedCount = items.filter((c) => entries.find((e) => e.course_id === c.id && e.term === term)?.grade).length;
        const termGpa = computeGPA(entries.filter((e) => e.term === term), courses);
        const summary = `${items.length} course${items.length === 1 ? "" : "s"} · ${gradedCount} graded` + (termGpa !== null ? ` · GPA ${termGpa.toFixed(2)}` : "");
        return (
          <TermGroup key={term} term={term} summary={summary}>
            {items.map((course) => {
              const entry = entries.find((e) => e.course_id === course.id && e.term === term);
              return (
                <div key={course.id} className="flex flex-col sm:flex-row sm:items-center gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
                  <span style={{ fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, flex: 1, minWidth: 0 }}>
                    {course.name} <span style={{ color: COLOR.ink3 }}>· {course.credits}cr</span>
                  </span>
                  <div style={{ width: 120, flexShrink: 0 }}>
                    <Dropdown placeholder="Grade" value={entry?.grade ?? ""} onChange={(g) => onSetGrade(course.id, term, g || null)} groups={GRADE_GROUPS} clearable />
                  </div>
                </div>
              );
            })}
          </TermGroup>
        );
      })}
    </div>
  );
}

function courseGroups(courses: Course[]): DropdownGroup[] {
  return TERM_ORDER
    .map((term) => ({ label: term, options: courses.filter((c) => c.term === term).map((c) => ({ value: c.id, label: c.name, sublabel: `${c.credits}cr` })) }))
    .filter((g) => g.options.length > 0);
}

function AddEntryForm({
  courses, entries, onAdd,
}: {
  courses: Course[]; entries: ActualEnrollment[];
  onAdd: (entry: { course_id: string; term: string; points_paid: number; grade: string | null }) => Promise<void>;
}) {
  const [courseId, setCourseId] = useState("");
  const [points, setPoints] = useState(0);
  const [grade, setGrade] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const alreadyAddedIds = useMemo(() => new Set(entries.map((e) => e.course_id)), [entries]);
  const available = useMemo(() => courses.filter((c) => isBiddableTerm(c.term) && !alreadyAddedIds.has(c.id)), [courses, alreadyAddedIds]);
  const groups = useMemo(() => courseGroups(available), [available]);

  async function handleAdd() {
    if (!courseId) return;
    const course = courses.find((c) => c.id === courseId);
    if (!course) return;
    setSubmitting(true);
    try {
      await onAdd({ course_id: courseId, term: course.term, points_paid: points, grade: grade || null });
      setCourseId("");
      setPoints(0);
      setGrade("");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div style={{ border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, padding: "16px", background: COLOR.surface }}>
      <div className="grid grid-cols-1 sm:grid-cols-[2fr_1fr_1fr_auto] gap-3 sm:items-end">
        <Dropdown label="Course" placeholder="Select course…" value={courseId} onChange={setCourseId} groups={groups} searchable />
        <div>
          <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 5 }}>
            Points paid
          </p>
          <input
            type="number" min={0} value={points || ""} placeholder="0" onChange={(e) => setPoints(Number(e.target.value) || 0)}
            style={inputStyle}
          />
        </div>
        <Dropdown label="Grade" placeholder="Optional" value={grade} onChange={setGrade} groups={GRADE_GROUPS} clearable />
        <button
          onClick={handleAdd}
          disabled={!courseId || submitting}
          style={{
            padding: "9px 18px", borderRadius: 9, border: "none", fontSize: 13, fontWeight: 700, fontFamily: FONT.sans,
            background: !courseId || submitting ? COLOR.border : COLOR.navyHero, color: !courseId || submitting ? COLOR.ink3 : "#fff",
            cursor: !courseId || submitting ? "not-allowed" : "pointer", whiteSpace: "nowrap", height: 38,
            transition: "background 120ms ease-out",
          }}
        >
          {submitting ? "Adding…" : "Add"}
        </button>
      </div>
    </div>
  );
}

function TermLedger({
  entries, courses, onUpdate, onRemove,
}: {
  entries: ActualEnrollment[]; courses: Course[];
  onUpdate: (id: string, updates: Partial<Pick<ActualEnrollment, "points_paid" | "grade">>) => Promise<void>;
  onRemove: (id: string) => Promise<void>;
}) {
  if (entries.length === 0) {
    return <p style={{ fontSize: 13, color: COLOR.ink3, fontFamily: FONT.sans }}>Nothing logged yet — add a confirmed course above.</p>;
  }

  return (
    <div className="space-y-2">
      {TERM_ORDER.map((term) => {
        const termEntries = entries.filter((e) => e.term === term);
        if (termEntries.length === 0) return null;
        const credits = termEntries.reduce((sum, e) => sum + (courses.find((c) => c.id === e.course_id)?.credits ?? 0), 0);
        const termGpa = computeGPA(termEntries, courses);
        const summary = `${termEntries.length} course${termEntries.length === 1 ? "" : "s"} · ${credits}cr` + (termGpa !== null ? ` · GPA ${termGpa.toFixed(2)}` : "");
        return (
          <TermGroup key={term} term={term} summary={summary}>
            {termEntries.map((e) => (
              <LedgerRow key={e.id} entry={e} course={courses.find((c) => c.id === e.course_id)} onUpdate={onUpdate} onRemove={onRemove} />
            ))}
          </TermGroup>
        );
      })}
    </div>
  );
}

function LedgerRow({
  entry, course, onUpdate, onRemove,
}: {
  entry: ActualEnrollment; course: Course | undefined;
  onUpdate: (id: string, updates: Partial<Pick<ActualEnrollment, "points_paid" | "grade">>) => Promise<void>;
  onRemove: (id: string) => Promise<void>;
}) {
  return (
    <div className="row-enter flex flex-col sm:flex-row sm:items-center gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
      <span style={{ fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, flex: 1, minWidth: 0 }}>
        {course?.name ?? "Unknown course"} <span style={{ color: COLOR.ink3 }}>· {course?.credits ?? 0}cr</span>
      </span>
      <div className="flex items-center gap-2 flex-shrink-0">
        <input
          type="number" min={0} value={entry.points_paid} aria-label="Points paid"
          onChange={(ev) => onUpdate(entry.id, { points_paid: Number(ev.target.value) || 0 })}
          style={{ ...inputStyle, width: 84, padding: "7px 9px" }}
        />
        <div style={{ width: 120 }}>
          <Dropdown placeholder="Grade" value={entry.grade ?? ""} onChange={(g) => onUpdate(entry.id, { grade: g || null })} groups={GRADE_GROUPS} clearable />
        </div>
        <button onClick={() => onRemove(entry.id)} aria-label="Remove" style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer", padding: "6px 4px" }}>
          Remove
        </button>
      </div>
    </div>
  );
}

const inputStyle: React.CSSProperties = {
  padding: "8px 12px", borderRadius: 8, border: `1px solid ${COLOR.border}`, width: "100%",
  fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, background: COLOR.surface, outline: "none",
};
