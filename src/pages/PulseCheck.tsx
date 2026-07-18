/**
 * Cohort Bidding Pulse Check — students voluntarily submit which course
 * they're seriously bidding on for a live Block Week and an estimated
 * bid-point amount, so everyone gets an aggregated demand read instead of
 * relying on scattered WhatsApp chatter. A submission can be edited exactly
 * once (RLS-enforced, not just this UI), then it's locked for good. Results
 * only ever show a threshold-gated median, never raw per-student numbers.
 * See docs/ROADMAP.md for why an earlier, similar feature was cut, and why
 * this one proceeds anyway with tighter guardrails.
 */
import { useState } from "react";
import { useOutletContext } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { useAppSettings } from "../hooks/useAppSettings";
import { usePulseCheck, PULSE_CHECK_MIN_RESPONDENTS } from "../hooks/usePulseCheck";
import { MIN_BID_PER_COURSE, TOTAL_BID_POINTS } from "../hooks/useBidPlan";
import type { User, Course, PulseCheckSubmission, PulseCheckResult } from "../types";

const FAIR_USE_NOTE =
  "Please bid what you actually plan to — this only helps the cohort if it reflects real intentions, not a guess at what others might do.";

export default function PulseCheck() {
  const { user } = useOutletContext<{ user: User }>();
  const { courses, loading: coursesLoading } = useCourses();
  const { liveBiddingTerms, pulseCheckCutoff, loading: settingsLoading } = useAppSettings();
  const { ownSubmissions, results, loading: pulseLoading, submitError, submit, edit } = usePulseCheck(user.id, liveBiddingTerms);

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
        <p style={{ fontFamily: FONT.sans, fontSize: 13, color: COLOR.ink2, marginTop: 4, maxWidth: 640, lineHeight: 1.5 }}>
          Voluntarily share which Block Week course you're seriously bidding on and roughly how many points — then see
          what the rest of the cohort submitted. Unofficial and peer-estimated, not ISB data — it may not reflect real
          bidding outcomes. You can change your answer once if you change your mind; after that it's locked. {FAIR_USE_NOTE}
        </p>
        {submitError && (
          <p style={{ fontFamily: FONT.sans, fontSize: 12.5, color: COLOR.red, marginTop: 10 }}>{submitError}</p>
        )}
      </header>

      <main className="px-6 md:px-12 space-y-8" style={{ maxWidth: 760 }}>
        {liveBiddingTerms.length === 0 ? (
          <p style={{ fontSize: 13, color: COLOR.ink3, fontFamily: FONT.sans }}>No Block Week bidding is live right now.</p>
        ) : (
          liveBiddingTerms.map((term) => (
            <TermSection
              key={term}
              term={term}
              courses={courses.filter((c) => c.term === term)}
              ownSubmission={ownSubmissions.find((s) => s.term === term)}
              results={results[term] ?? []}
              cutoffPassed={cutoffPassed}
              onSubmit={(courseId, points) => submit({ course_id: courseId, term, bid_points_estimate: points })}
              onEdit={(courseId, points) => edit(term, { course_id: courseId, bid_points_estimate: points })}
            />
          ))
        )}
      </main>
    </div>
  );
}

function TermSection({
  term, courses, ownSubmission, results, cutoffPassed, onSubmit, onEdit,
}: {
  term: string;
  courses: Course[];
  ownSubmission: PulseCheckSubmission | undefined;
  results: PulseCheckResult[];
  cutoffPassed: boolean;
  onSubmit: (courseId: string, points: number) => void;
  onEdit: (courseId: string, points: number) => void;
}) {
  const resultByCourse = new Map(results.map((r) => [r.course_id, r]));
  const [editing, setEditing] = useState(false);
  const canEdit = !!ownSubmission && !ownSubmission.edited && !cutoffPassed;

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
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>
          Submissions closed — Phase 1 bidding has ended for this Block Week.
        </p>
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
        <div className="mt-5">
          <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 8 }}>
            Cohort pulse
          </p>
          <div className="space-y-1.5">
            {courses.map((c) => {
              const r = resultByCourse.get(c.id);
              const count = r?.respondent_count ?? 0;
              const enough = count >= PULSE_CHECK_MIN_RESPONDENTS && r?.median_points != null;
              return (
                <div key={c.id} className="flex items-center justify-between gap-3" style={{ padding: "8px 10px", borderRadius: 8, background: COLOR.bgSoft }}>
                  <span style={{ fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink }}>{c.name}</span>
                  <span style={{ fontSize: 12, fontFamily: FONT.sans, color: enough ? COLOR.ink2 : COLOR.ink3, fontWeight: enough ? 700 : 400, whiteSpace: "nowrap" }}>
                    {enough ? `~${Math.round(r!.median_points as number)} pts · ${count} responses` : `Not enough data yet (${count}/${PULSE_CHECK_MIN_RESPONDENTS})`}
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </section>
  );
}

function SubmittedState({
  course, points, edited, canEdit, onEditClick,
}: { course: Course | undefined; points: number; edited: boolean; canEdit: boolean; onEditClick: () => void }) {
  return (
    <div style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.greenTint, marginBottom: 4 }}>
      <div className="flex items-center justify-between gap-3 flex-wrap">
        <p style={{ fontSize: 13, fontWeight: 700, color: COLOR.green, fontFamily: FONT.sans }}>
          ✓ Submitted: {course?.name ?? "Unknown course"} — {points} pts{edited ? " (edited)" : ""}
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
      <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>
        {edited ? "This has already been edited once — it's locked for good." : "You can edit this once if you change your mind. After that, it's locked."}
      </p>
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
          <option value="">Which course are you bidding on?</option>
          {courses.map((c) => (
            <option key={c.id} value={c.id}>{c.name}</option>
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
      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 6, lineHeight: 1.5 }}>
        {mode === "edit"
          ? "This is your one allowed edit — after saving, it's locked for good."
          : `One course per Block Week, min ${MIN_BID_PER_COURSE} pts. You can edit this once later if you change your mind.`}
        {" "}{FAIR_USE_NOTE}
      </p>

      {confirming && selectedCourse && (
        <ConfirmModal
          mode={mode}
          courseName={selectedCourse.name}
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
          {mode === "edit" ? "Save this as your final answer?" : "Is this final?"}
        </p>
        <p style={{ fontSize: 13.5, color: COLOR.ink2, fontFamily: FONT.sans, lineHeight: 1.5, marginBottom: 6 }}>
          <strong>{courseName}</strong> — {points} pts
        </p>
        <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, lineHeight: 1.5, marginBottom: 20 }}>
          {mode === "edit"
            ? "This is your one allowed edit. Once saved, it can't be changed again."
            : "You can edit this once later if you change your mind — after that, it's locked for good."}
          {" "}It's an unofficial, peer-estimated number, not your actual Registro bid. {FAIR_USE_NOTE}
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
            {submitting ? "Saving…" : mode === "edit" ? "Confirm edit" : "Confirm, this is final"}
          </button>
        </div>
      </div>
    </div>
  );
}
