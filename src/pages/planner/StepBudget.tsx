import { COLOR, FONT } from "../../lib/theme";
import { TOTAL_BID_POINTS } from "../../hooks/useBidPlan";
import type { BidPlanEntry } from "../../hooks/useBidPlan";
import { TERM_CREDIT_LIMITS } from "../../lib/creditProgress";
import type { Course, StudentAcademicProfile } from "../../types";

interface Props {
  profile: StudentAcademicProfile;
  save: (updates: Partial<StudentAcademicProfile>) => void;
  entries: BidPlanEntry[];
  courses: Course[];
  pointsPlanned: number;
  reserved: number;
  exchangePointsUsed: number;
  remainingPoints: number;
  onRemove: (id: string) => void;
}

// Term order for the per-term boxes — matches ISB's bidding sequence.
const TERM_ORDER = Object.keys(TERM_CREDIT_LIMITS);

export default function StepBudget({ profile, save, entries, courses, pointsPlanned, reserved, exchangePointsUsed, remainingPoints, onRemove }: Props) {
  return (
    <div>
      <p style={{ fontFamily: FONT.serif, fontSize: 15, color: COLOR.ink2, marginBottom: 20, lineHeight: 1.6 }}>
        This is your own ledger — a running check against the 4,500-point budget as you decide what to bid. Nothing here is submitted to Registro.
      </p>
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 mb-4">
        <Stat label="Total points" value={TOTAL_BID_POINTS} />
        <Stat label="Planned so far" value={pointsPlanned} />
        <Stat label="Reserved for remaining credits" value={reserved} />
      </div>
      <div style={{
        padding: "12px 16px", borderRadius: 10, fontFamily: FONT.sans, fontSize: 14, fontWeight: 700,
        background: remainingPoints < 0 ? COLOR.redTint : COLOR.greenTint,
        color: remainingPoints < 0 ? COLOR.red : COLOR.green,
      }}>
        {remainingPoints < 0
          ? `Over budget by ${Math.abs(remainingPoints)} points — this plan won't clear the automatic reserve.`
          : `${remainingPoints} points free to allocate beyond what's planned + reserved.`}
      </div>

      <div className="mt-6">
        <p style={{ fontSize: 13, fontWeight: 700, color: COLOR.ink, fontFamily: FONT.sans, marginBottom: 4 }}>
          Already bid for Exchange?
        </p>
        <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 10 }}>
          International and Inter-Campus Exchange draw from the same 4,500-point pool as regular bidding. Log what you've already spent so your remaining budget above stays accurate.
        </p>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <ExchangePointsInput
            label="International Exchange points used"
            value={profile.international_exchange_points_used}
            onChange={(n) => save({ international_exchange_points_used: n })}
          />
          <ExchangePointsInput
            label="Inter-Campus Exchange points used"
            value={profile.inter_campus_exchange_points_used}
            onChange={(n) => save({ inter_campus_exchange_points_used: n })}
          />
        </div>
        {exchangePointsUsed > 0 && (
          <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 6 }}>
            {exchangePointsUsed} points already deducted from your remaining budget above.
          </p>
        )}
      </div>

      {entries.length > 0 ? (
        <div className="mt-8 space-y-5">
          {TERM_ORDER.map((term) => {
            const termEntries = entries.filter((e) => e.term === term);
            if (termEntries.length === 0) return null;
            const limit = TERM_CREDIT_LIMITS[term];
            const creditsInTerm = termEntries.reduce((sum, e) => {
              const course = courses.find((c) => c.id === e.course_id);
              return sum + (course ? Number(course.credits) : 0);
            }, 0);
            const underMin = creditsInTerm < limit.min;
            return (
              <div key={term} style={{ border: `1px solid ${COLOR.borderLight}`, borderRadius: 10, padding: "12px 14px", background: COLOR.surface }}>
                <div className="flex items-center justify-between mb-2">
                  <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>{term}</p>
                  <p style={{ fontSize: 11.5, fontFamily: FONT.sans, color: underMin ? COLOR.red : COLOR.ink3 }}>
                    {creditsInTerm} credit{creditsInTerm === 1 ? "" : "s"} · ISB requires {limit.min === limit.max ? limit.min : `${limit.min}-${limit.max}`}
                  </p>
                </div>
                <div className="space-y-2">
                  {termEntries.map((e) => {
                    const course = courses.find((c) => c.id === e.course_id);
                    return (
                      <div key={e.id} className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.bgSoft }}>
                        <span style={{ fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, minWidth: 0 }}>
                          {course?.name ?? "Unknown course"} <span style={{ color: COLOR.ink3 }}>· {e.planned_points} pts</span>
                        </span>
                        <button onClick={() => onRemove(e.id)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer", flexShrink: 0, textAlign: "left" }}>Remove</button>
                      </div>
                    );
                  })}
                </div>
              </div>
            );
          })}
          {(() => {
            // Entries in a term outside ISB's biddable range (e.g. left over from before
            // Term 1-3 was excluded from the course picker) still count in the totals above —
            // never hide them here, or the ledger silently disagrees with what's on screen.
            const strayEntries = entries.filter((e) => !TERM_ORDER.includes(e.term));
            if (strayEntries.length === 0) return null;
            return (
              <div style={{ border: `1px solid ${COLOR.red}`, borderRadius: 10, padding: "12px 14px", background: COLOR.redTint }}>
                <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.red, marginBottom: 2 }}>
                  Not a biddable term — still counted in your totals above
                </p>
                <p style={{ fontSize: 11.5, fontFamily: FONT.sans, color: COLOR.red, opacity: 0.85, marginBottom: 10 }}>
                  ISB doesn't bid points on these terms. This is likely left over from earlier testing — remove it if it doesn't belong.
                </p>
                <div className="space-y-2">
                  {strayEntries.map((e) => {
                    const course = courses.find((c) => c.id === e.course_id);
                    return (
                      <div key={e.id} className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface }}>
                        <span style={{ fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, minWidth: 0 }}>
                          {course?.name ?? "Unknown course"} <span style={{ color: COLOR.ink3 }}>· {e.term} · {e.planned_points} pts</span>
                        </span>
                        <button onClick={() => onRemove(e.id)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer", flexShrink: 0, textAlign: "left" }}>Remove</button>
                      </div>
                    );
                  })}
                </div>
              </div>
            );
          })()}
        </div>
      ) : (
        <p style={{ fontSize: 13, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 20 }}>
          Nothing in your plan yet — go back to "Your Plan" and add courses that count toward your goals.
        </p>
      )}
    </div>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div style={{ padding: "12px 14px", borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
      <p style={{ fontSize: 20, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>{value}</p>
      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans }}>{label}</p>
    </div>
  );
}

function ExchangePointsInput({ label, value, onChange }: { label: string; value: number | null; onChange: (n: number | null) => void }) {
  return (
    <div>
      <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 4 }}>{label}</p>
      <input
        type="number" min={0} placeholder="0"
        value={value ?? ""}
        onChange={(e) => onChange(e.target.value === "" ? null : Number(e.target.value))}
        style={{ width: "100%", padding: "8px 12px", borderRadius: 8, border: `1px solid ${COLOR.border}`, fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, background: COLOR.surface, outline: "none" }}
      />
    </div>
  );
}
