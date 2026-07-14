/**
 * Bidding Planner — a guided, step-by-step counselor flow, not a form dump.
 * Never recommends what to bid; it shows credit progress against a student's
 * own stated goals and what's currently live to bid on, so the decision stays theirs.
 */
import { useParams, useNavigate, Navigate, useOutletContext } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { useAcademicProfile } from "../hooks/useAcademicProfile";
import { useBidPlan } from "../hooks/useBidPlan";
import type { User } from "../types";
import StepBackground from "./planner/StepBackground";
import StepGoals from "./planner/StepGoals";
import StepPlan from "./planner/StepPlan";
import StepBudget from "./planner/StepBudget";

const STEPS = [
  { key: "background", label: "Your Background" },
  { key: "goals", label: "Your Goals" },
  { key: "plan", label: "Your Plan" },
  { key: "budget", label: "Bid Budget" },
] as const;

export default function BiddingPlanner() {
  const { user } = useOutletContext<{ user: User }>();
  const { step: stepKey } = useParams<{ step: string }>();
  const navigate = useNavigate();

  const { courses, gatingCourses, loading: coursesLoading } = useCourses();
  const { profile, save } = useAcademicProfile(user.id);
  const { entries, addEntry, removeEntry, pointsPlanned, reserved, remainingPoints } = useBidPlan(user.id);

  const step = STEPS.findIndex((s) => s.key === stepKey);
  if (step === -1) return <Navigate to="/planner/background" replace />;

  if (coursesLoading || !profile) {
    return <div style={{ padding: 40, fontFamily: FONT.sans, color: COLOR.ink2 }}>Loading…</div>;
  }

  function goToStep(i: number) {
    navigate(`/planner/${STEPS[i].key}`);
  }

  return (
    <div className="min-h-screen pb-24" style={{ background: COLOR.bg }}>
      <header className="px-6 md:px-12 pt-10 pb-6">
        <h1 style={{ fontFamily: FONT.serif, fontSize: 26, fontWeight: 500, color: COLOR.ink }}>
          Bidding <em>Planner</em>
        </h1>

        {/* Step progress */}
        <div className="flex items-center gap-2 mt-6 flex-wrap">
          {STEPS.map((s, i) => (
            <button
              key={s.key}
              onClick={() => goToStep(i)}
              style={{
                display: "flex", alignItems: "center", gap: 8, padding: "7px 14px", borderRadius: 20,
                border: "none", cursor: "pointer", fontFamily: FONT.sans, fontSize: 12.5, fontWeight: 700,
                background: i === step ? COLOR.navyHero : i < step ? COLOR.navyTint : COLOR.bgSoft,
                color: i === step ? "#fff" : i < step ? COLOR.navyHero : COLOR.ink3,
              }}
            >
              <span style={{
                width: 18, height: 18, borderRadius: "50%", display: "flex", alignItems: "center", justifyContent: "center",
                fontSize: 10, background: i === step ? "rgba(255,255,255,0.25)" : i < step ? COLOR.navyHero : COLOR.border,
                color: i === step ? "#fff" : i < step ? "#fff" : COLOR.ink3,
              }}>
                {i + 1}
              </span>
              {s.label}
            </button>
          ))}
        </div>
      </header>

      <main className="px-6 md:px-12" style={{ maxWidth: 820 }}>
        {step === 0 && <StepBackground profile={profile} save={save} gatingCourses={gatingCourses} />}
        {step === 1 && <StepGoals profile={profile} save={save} />}
        {step === 2 && (
          <StepPlan
            profile={profile}
            courses={courses}
            gatingCourses={gatingCourses}
            bidEntries={entries}
            onAdd={(courseId, term, points) => addEntry({ course_id: courseId, term, planned_points: points })}
          />
        )}
        {step === 3 && (
          <StepBudget
            entries={entries}
            courses={courses}
            pointsPlanned={pointsPlanned}
            reserved={reserved}
            remainingPoints={remainingPoints}
            onRemove={removeEntry}
          />
        )}

        {/* Nav buttons */}
        <div className="flex justify-between mt-12 pb-8">
          <button
            onClick={() => goToStep(Math.max(0, step - 1))}
            disabled={step === 0}
            style={{
              padding: "10px 20px", borderRadius: 9, border: `1px solid ${COLOR.border}`, background: COLOR.surface,
              color: COLOR.ink2, fontFamily: FONT.sans, fontSize: 13, fontWeight: 600, cursor: step === 0 ? "default" : "pointer",
              opacity: step === 0 ? 0.4 : 1,
            }}
          >
            Back
          </button>
          {step < STEPS.length - 1 && (
            <button
              onClick={() => goToStep(Math.min(STEPS.length - 1, step + 1))}
              style={{ padding: "10px 22px", borderRadius: 9, border: "none", background: COLOR.navyHero, color: "#fff", fontFamily: FONT.sans, fontSize: 13, fontWeight: 700, cursor: "pointer" }}
            >
              Continue
            </button>
          )}
        </div>
      </main>
    </div>
  );
}
