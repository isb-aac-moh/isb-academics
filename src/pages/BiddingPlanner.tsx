/**
 * Bidding Planner — a guided, step-by-step counselor flow, not a form dump.
 * Never recommends what to bid; it shows credit progress against a student's
 * own stated goals and what's currently live to bid on, so the decision stays theirs.
 */
import { useParams, useNavigate, Navigate, useOutletContext } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { useResources } from "../hooks/useResources";
import { useAcademicProfile } from "../hooks/useAcademicProfile";
import { useBidPlan, TOTAL_ELECTIVE_CREDITS_REQUIRED } from "../hooks/useBidPlan";
import { computeBidBudget, totalElectiveCreditsSecured } from "../lib/creditProgress";
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
  const { resources } = useResources();
  const { profile, save } = useAcademicProfile(user.id);
  const { entries, addEntry, removeEntry, pointsPlanned } = useBidPlan(user.id);

  const step = STEPS.findIndex((s) => s.key === stepKey);
  if (step === -1) return <Navigate to="/planner/background" replace />;

  if (coursesLoading || !profile) {
    return <div style={{ padding: 40, fontFamily: FONT.sans, color: COLOR.ink2 }}>Loading…</div>;
  }

  const creditsSecured = totalElectiveCreditsSecured(profile, courses, entries);
  const { reserved, exchangePointsUsed, pointsAvailable, remainingPoints } = computeBidBudget(profile, courses, entries, pointsPlanned);
  const overFullBudget = pointsAvailable < 0;
  const dippingIntoReserve = !overFullBudget && remainingPoints < 0;

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

        {/* Lean journey summary — elective credits + bid points, always visible */}
        <div className="flex flex-wrap gap-3 mt-6">
          <SummaryTile label="Elective credits" value={`${creditsSecured}/${TOTAL_ELECTIVE_CREDITS_REQUIRED}`} />
          <SummaryTile label="Bid points remaining" value={String(pointsAvailable)} warn={overFullBudget} />
        </div>
        <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 8, maxWidth: 520, lineHeight: 1.5 }}>
          Out of your full 4,500-point budget. ISB also asks you to hold back 100 points per elective credit you still need ({reserved} pts right now) so you don't run out before hitting your 18-credit requirement — you can bid past that, you'll just be warned.
        </p>
        {dippingIntoReserve && (
          <div style={{
            marginTop: 8, padding: "10px 14px", borderRadius: 9, background: COLOR.redTint,
            color: COLOR.red, fontFamily: FONT.sans, fontSize: 12.5, fontWeight: 600, maxWidth: 520,
          }}>
            You're {Math.abs(remainingPoints)} points into the reserve ISB holds back for your remaining required credits. Still allowed — but you may fall short of your 18-credit requirement later.
          </div>
        )}
      </header>

      <main className="px-6 md:px-12" style={{ maxWidth: 820 }}>
        {step === 0 && <StepBackground profile={profile} save={save} gatingCourses={gatingCourses} />}
        {step === 1 && <StepGoals profile={profile} save={save} />}
        {step === 2 && (
          <StepPlan
            profile={profile}
            save={save}
            courses={courses}
            gatingCourses={gatingCourses}
            resources={resources}
            bidEntries={entries}
            pointsAvailable={pointsAvailable}
            onAdd={(courseId, term, points) => addEntry({ course_id: courseId, term, planned_points: points })}
          />
        )}
        {step === 3 && (
          <StepBudget
            profile={profile}
            save={save}
            entries={entries}
            courses={courses}
            pointsPlanned={pointsPlanned}
            reserved={reserved}
            exchangePointsUsed={exchangePointsUsed}
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

function SummaryTile({ label, value, warn }: { label: string; value: string; warn?: boolean }) {
  return (
    <div style={{
      padding: "8px 14px", borderRadius: 9, background: warn ? COLOR.redTint : COLOR.navyTint,
      display: "flex", alignItems: "baseline", gap: 6,
    }}>
      <span style={{ fontSize: 15, fontWeight: 700, fontFamily: FONT.sans, color: warn ? COLOR.red : COLOR.navyHero }}>{value}</span>
      <span style={{ fontSize: 11.5, fontFamily: FONT.sans, color: warn ? COLOR.red : COLOR.navyHero, opacity: 0.8 }}>{label}</span>
    </div>
  );
}
