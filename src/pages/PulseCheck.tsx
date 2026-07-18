/**
 * Cohort Bidding Pulse Check — students voluntarily submit which course
 * they're seriously bidding on for a live Block Week and an estimated
 * bid-point amount, so everyone gets an aggregated demand read instead of
 * relying on scattered WhatsApp chatter. A submission can be edited exactly
 * once (RLS-enforced, not just this UI), then it's locked for good. Each
 * course gets its own card with a real bucketed histogram of submitted bid
 * points — never a smoothed curve, which would oversell how much data a
 * handful of respondents actually is. Cards stay in catalog order, never
 * sorted by response count or bid points, so this can't become a popularity
 * leaderboard. See docs/ROADMAP.md for why an earlier, similar feature was
 * cut, and why this one proceeds anyway with tighter guardrails.
 */
import { useState } from "react";
import { useOutletContext } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { useAppSettings } from "../hooks/useAppSettings";
import { usePulseCheck, PULSE_CHECK_MIN_RESPONDENTS } from "../hooks/usePulseCheck";
import { MIN_BID_PER_COURSE, TOTAL_BID_POINTS } from "../hooks/useBidPlan";
import { fakePulseResults, fakePulseHistograms } from "../lib/devFixtures";
import type { User, Course, PulseCheckSubmission, PulseCheckResult, PulseCheckHistogramBucket } from "../types";

const FAIR_USE_NOTE = "Bid what you'd actually pay — it only works if it's real.";

export default function PulseCheck() {
  const { user } = useOutletContext<{ user: User }>();
  const { courses, loading: coursesLoading } = useCourses();
  const { liveBiddingTerms, pulseCheckCutoff, loading: settingsLoading } = useAppSettings();
  const { ownSubmissions, results, histograms, loading: pulseLoading, submitError, submit, edit } = usePulseCheck(user.id, liveBiddingTerms);

  if (coursesLoading || settingsLoading || pulseLoading) {
    return <div style={{ padding: 40, fontFamily: FONT.sans, color: COLOR.ink2 }}>Loading…</div>;
  }

  const cutoffPassed = pulseCheckCutoff ? new Date() >= new Date(pulseCheckCutoff) : false;

  return (
    <div className="min-h-screen pb-24" style={{ background: COLOR.bg }}>
      <header className="px-6 md:px-12 pt-10 pb-6">
        <h1 style={{ fontFamily: FONT.serif, fontSize: 26, fontWeight: 500, color: COLOR.ink }}>
          Cohort Bidding <em>Pulse Check</em>
        </h1>
        <p style={{ fontFamily: FONT.sans, fontSize: 13, color: COLOR.ink2, marginTop: 4, maxWidth: 600 }}>
          Share your Block Week bid, see the cohort's range. Unofficial, editable once. {FAIR_USE_NOTE}
        </p>
        {submitError && (
          <p style={{ fontFamily: FONT.sans, fontSize: 12.5, color: COLOR.red, marginTop: 10 }}>{submitError}</p>
        )}
        {import.meta.env.DEV && (
          <p style={{ fontFamily: FONT.sans, fontSize: 11.5, fontWeight: 700, color: "#8B5E00", background: COLOR.amberTint, display: "inline-block", padding: "3px 9px", borderRadius: 6, marginTop: 10 }}>
            DEV PREVIEW — fake stats below, not real submissions
          </p>
        )}
      </header>

      <main className="px-6 md:px-12 space-y-8" style={{ maxWidth: 900 }}>
        {liveBiddingTerms.length === 0 ? (
          <p style={{ fontSize: 13, color: COLOR.ink3, fontFamily: FONT.sans }}>No Block Week bidding is live right now.</p>
        ) : (
          liveBiddingTerms.map((term) => {
            const termCourses = courses.filter((c) => c.term === term);
            const courseIds = termCourses.map((c) => c.id);
            // Dev-build-only preview data — see src/lib/devFixtures.ts. Never
            // runs in production; real cohort numbers are never touched.
            const displayResults = import.meta.env.DEV ? fakePulseResults(courseIds) : (results[term] ?? []);
            const displayHistograms = import.meta.env.DEV ? fakePulseHistograms(courseIds) : (histograms[term] ?? []);
            return (
              <TermSection
                key={term}
                term={term}
                courses={termCourses}
                ownSubmission={ownSubmissions.find((s) => s.term === term)}
                results={displayResults}
                histograms={displayHistograms}
                cutoffPassed={cutoffPassed}
                onSubmit={(courseId, points) => submit({ course_id: courseId, term, bid_points_estimate: points })}
                onEdit={(courseId, points) => edit(term, { course_id: courseId, bid_points_estimate: points })}
              />
            );
          })
        )}
      </main>
    </div>
  );
}

function TermSection({
  term, courses, ownSubmission, results, histograms, cutoffPassed, onSubmit, onEdit,
}: {
  term: string;
  courses: Course[];
  ownSubmission: PulseCheckSubmission | undefined;
  results: PulseCheckResult[];
  histograms: PulseCheckHistogramBucket[];
  cutoffPassed: boolean;
  onSubmit: (courseId: string, points: number) => void;
  onEdit: (courseId: string, points: number) => void;
}) {
  const [editing, setEditing] = useState(false);
  const canEdit = !!ownSubmission && !ownSubmission.edited && !cutoffPassed;
  const resultByCourse = new Map(results.map((r) => [r.course_id, r]));
  const histogramByCourse = new Map<string, PulseCheckHistogramBucket[]>();
  histograms.forEach((b) => {
    const list = histogramByCourse.get(b.course_id) ?? [];
    list.push(b);
    histogramByCourse.set(b.course_id, list);
  });

  return (
    <section style={{ border: `1px solid ${COLOR.borderLight}`, borderRadius: 12, padding: "18px 20px", background: COLOR.surface }}>
      <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 12 }}>{term}</p>

      {ownSubmission && !editing ? (
        <SubmittedState
          course={courses.find((c) => c.id === ownSubmission.course_id)}
          points={ownSubmission.bid_points_estimate}
          edited={ownSubmission.edited}
          canEdit={canEdit}
          onEditClick={() => setEditing(true)}
        />
      ) : !ownSubmission && cutoffPassed ? (
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>Submissions closed for this Block Week.</p>
      ) : (
        <SubmitForm
          courses={courses}
          mode={ownSubmission ? "edit" : "submit"}
          initialCourseId={ownSubmission?.course_id}
          initialPoints={ownSubmission?.bid_points_estimate}
          onConfirm={(courseId, points) => {
            if (ownSubmission) {
              onEdit(courseId, points);
              setEditing(false);
            } else {
              onSubmit(courseId, points);
            }
          }}
          onCancel={ownSubmission ? () => setEditing(false) : undefined}
        />
      )}

      {courses.length > 0 && (
        ownSubmission ? (
          <div className="mt-5">
            <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 2 }}>
              Cohort pulse
            </p>
            <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 8 }}>
              Bar + top number = responses. Bottom number = bid points at that point.
            </p>
            {/* Fixed catalog order — never sorted by response count or bid points, so this can't read as a popularity leaderboard. */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
              {courses.map((c) => (
                <CourseCard key={c.id} course={c} result={resultByCourse.get(c.id)} histogram={histogramByCourse.get(c.id) ?? []} />
              ))}
            </div>
          </div>
        ) : (
          <div className="mt-5" style={{ padding: "16px", borderRadius: 10, border: `1px dashed ${COLOR.border}`, textAlign: "center" }}>
            <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>Submit your {term} bid above to see the cohort's pulse.</p>
          </div>
        )
      )}
    </section>
  );
}

function CourseCard({ course, result, histogram }: { course: Course; result: PulseCheckResult | undefined; histogram: PulseCheckHistogramBucket[] }) {
  const count = result?.respondent_count ?? 0;
  const enough = !!result && count >= PULSE_CHECK_MIN_RESPONDENTS && result.median_points != null;

  return (
    <div style={{ border: `1px solid ${COLOR.border}`, borderRadius: 10, padding: "12px 14px", background: COLOR.surface }}>
      <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }} title={course.name}>
        {course.name}
      </p>
      <p style={{ fontSize: 11, color: COLOR.navyHero, fontFamily: FONT.sans, fontWeight: 700, marginTop: 1, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
        {course.professor}
      </p>
      <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>
        {enough
          ? `${Math.round(result!.min_points as number)}–${Math.round(result!.max_points as number)} pts · ${count} responses`
          : `Not enough data yet (${count}/${PULSE_CHECK_MIN_RESPONDENTS})`}
      </p>
      {enough && <MiniHistogram buckets={histogram} />}
    </div>
  );
}

function MiniHistogram({ buckets }: { buckets: PulseCheckHistogramBucket[] }) {
  const [activeIndex, setActiveIndex] = useState<number | null>(null);
  if (buckets.length === 0) return null;
  const maxCount = Math.max(...buckets.map((b) => b.bucket_count), 1);
  const active = buckets.find((b) => b.bucket_index === activeIndex);

  return (
    <div style={{ position: "relative", marginTop: 10 }}>
      {active && (
        <div
          style={{
            position: "absolute", bottom: "100%", left: 0, right: 0, marginBottom: 4, textAlign: "center",
            fontSize: 11, fontFamily: FONT.sans, color: COLOR.ink, background: COLOR.surface,
            border: `1px solid ${COLOR.border}`, borderRadius: 6, padding: "3px 6px", pointerEvents: "none",
          }}
        >
          {Math.round(active.bucket_start)}–{Math.round(active.bucket_end)} pts · {active.bucket_count} {active.bucket_count === 1 ? "response" : "responses"}
        </div>
      )}
      <div className="flex items-end gap-1" style={{ height: 52 }}>
        {buckets.map((b) => (
          <div
            key={b.bucket_index}
            onMouseEnter={() => setActiveIndex(b.bucket_index)}
            onMouseLeave={() => setActiveIndex(null)}
            onClick={() => setActiveIndex(b.bucket_index)}
            className="flex flex-col items-center justify-end"
            style={{ flex: 1, height: "100%", cursor: "pointer" }}
          >
            <span style={{ fontSize: 10, fontWeight: 700, color: b.bucket_count === 0 ? COLOR.ink3 : COLOR.ink, fontFamily: FONT.sans, marginBottom: 2, lineHeight: 1 }}>
              {b.bucket_count}
            </span>
            <div
              style={{
                width: "100%",
                height: `${b.bucket_count === 0 ? 3 : Math.max((b.bucket_count / maxCount) * 100, 10)}%`,
                background: activeIndex === b.bucket_index ? COLOR.amber : COLOR.navyHero,
                opacity: b.bucket_count === 0 ? 0.25 : 1,
                borderRadius: "3px 3px 0 0",
              }}
            />
          </div>
        ))}
      </div>
      <div className="flex gap-1" style={{ marginTop: 3 }}>
        {buckets.map((b) => (
          <span key={b.bucket_index} style={{ flex: 1, textAlign: "center", fontSize: 9.5, color: COLOR.ink3, fontFamily: FONT.sans, lineHeight: 1 }}>
            {Math.round(b.bucket_start)}
          </span>
        ))}
      </div>
    </div>
  );
}

function SubmittedState({
  course, points, edited, canEdit, onEditClick,
}: { course: Course | undefined; points: number; edited: boolean; canEdit: boolean; onEditClick: () => void }) {
  return (
    <div style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.greenTint, marginBottom: 4 }}>
      <div className="flex items-center justify-between gap-3 flex-wrap">
        <p style={{ fontSize: 13, fontWeight: 700, color: COLOR.green, fontFamily: FONT.sans }}>
          ✓ {course?.name ?? "Unknown course"}{course?.professor ? ` (${course.professor})` : ""} — {points} pts{edited ? " (edited)" : ""}
        </p>
        {canEdit && (
          <button
            onClick={onEditClick}
            style={{ fontSize: 12, fontWeight: 700, color: COLOR.navyHero, background: "none", border: "none", cursor: "pointer", padding: 0, textDecoration: "underline" }}
          >
            Edit (once)
          </button>
        )}
      </div>
      {edited && <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>Locked — already edited once.</p>}
    </div>
  );
}

function SubmitForm({
  courses, mode, initialCourseId, initialPoints, onConfirm, onCancel,
}: {
  courses: Course[];
  mode: "submit" | "edit";
  initialCourseId?: string;
  initialPoints?: number;
  onConfirm: (courseId: string, points: number) => void;
  onCancel?: () => void;
}) {
  const [courseId, setCourseId] = useState(initialCourseId ?? "");
  const [points, setPoints] = useState(initialPoints ?? MIN_BID_PER_COURSE);
  const [confirming, setConfirming] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  const selectedCourse = courses.find((c) => c.id === courseId);
  const valid = courseId !== "" && points >= MIN_BID_PER_COURSE && points <= TOTAL_BID_POINTS;

  async function handleConfirm() {
    setSubmitting(true);
    try {
      onConfirm(courseId, points);
    } finally {
      setSubmitting(false);
      setConfirming(false);
    }
  }

  return (
    <div>
      <div className="flex flex-col sm:flex-row gap-2">
        <select
          value={courseId}
          onChange={(e) => setCourseId(e.target.value)}
          style={{ flex: 1, padding: "8px 10px", borderRadius: 7, border: `1px solid ${COLOR.border}`, fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink }}
        >
          <option value="">Which course?</option>
          {courses.map((c) => (
            <option key={c.id} value={c.id}>{c.name} — {c.professor}</option>
          ))}
        </select>
        <input
          type="number"
          min={MIN_BID_PER_COURSE}
          max={TOTAL_BID_POINTS}
          value={points}
          onChange={(e) => setPoints(Number(e.target.value))}
          style={{ width: 90, padding: "8px 10px", borderRadius: 7, border: `1px solid ${COLOR.border}`, fontSize: 13, fontFamily: FONT.sans }}
        />
        <button
          onClick={() => setConfirming(true)}
          disabled={!valid}
          style={{
            padding: "8px 16px", borderRadius: 7, border: "none", fontSize: 13, fontWeight: 700, fontFamily: FONT.sans,
            background: valid ? COLOR.navyHero : COLOR.border, color: valid ? "#fff" : COLOR.ink3, cursor: valid ? "pointer" : "not-allowed",
          }}
        >
          {mode === "edit" ? "Save edit" : "Submit"}
        </button>
        {onCancel && (
          <button
            onClick={onCancel}
            style={{ padding: "8px 14px", borderRadius: 7, border: `1px solid ${COLOR.border}`, background: COLOR.surface, color: COLOR.ink2, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer" }}
          >
            Cancel
          </button>
        )}
      </div>
      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 6 }}>
        One course per Block Week, min {MIN_BID_PER_COURSE} pts. Editable once.
      </p>

      {confirming && selectedCourse && (
        <ConfirmModal
          mode={mode}
          courseName={`${selectedCourse.name} (${selectedCourse.professor})`}
          points={points}
          submitting={submitting}
          onCancel={() => setConfirming(false)}
          onConfirm={handleConfirm}
        />
      )}
    </div>
  );
}

function ConfirmModal({
  mode, courseName, points, submitting, onCancel, onConfirm,
}: { mode: "submit" | "edit"; courseName: string; points: number; submitting: boolean; onCancel: () => void; onConfirm: () => void }) {
  return (
    <div style={{ position: "fixed", inset: 0, zIndex: 60, display: "flex", alignItems: "center", justifyContent: "center", padding: 20 }}>
      <div onClick={onCancel} style={{ position: "absolute", inset: 0, background: "rgba(0,0,0,0.45)" }} />
      <div style={{ position: "relative", background: COLOR.surface, borderRadius: 14, padding: 24, maxWidth: 380, width: "100%" }}>
        <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 8 }}>
          {mode === "edit" ? "Save this as your final answer?" : "Confirm your bid?"}
        </p>
        <p style={{ fontSize: 13.5, color: COLOR.ink2, fontFamily: FONT.sans, lineHeight: 1.5, marginBottom: 10 }}>
          <strong>{courseName}</strong> — {points} pts
        </p>
        <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, lineHeight: 1.5, marginBottom: 20 }}>
          {mode === "edit" ? "This is your one allowed edit — locked after this." : "Editable once later, then locked."} {FAIR_USE_NOTE}
        </p>
        <div className="flex justify-end gap-2">
          <button
            onClick={onCancel}
            style={{ padding: "8px 14px", borderRadius: 7, border: `1px solid ${COLOR.border}`, background: COLOR.surface, color: COLOR.ink2, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer" }}
          >
            Cancel
          </button>
          <button
            onClick={onConfirm}
            disabled={submitting}
            style={{ padding: "8px 14px", borderRadius: 7, border: "none", background: COLOR.navyHero, color: "#fff", fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, cursor: submitting ? "not-allowed" : "pointer" }}
          >
            {submitting ? "Saving…" : mode === "edit" ? "Confirm edit" : "Confirm"}
          </button>
        </div>
      </div>
    </div>
  );
}
