import { COLOR, FONT } from "../../lib/theme";
import { TOTAL_BID_POINTS } from "../../hooks/useBidPlan";
import type { BidPlanEntry } from "../../hooks/useBidPlan";
import type { Course } from "../../types";

interface Props {
  entries: BidPlanEntry[];
  courses: Course[];
  pointsPlanned: number;
  reserved: number;
  remainingPoints: number;
  onRemove: (id: string) => void;
}

export default function StepBudget({ entries, courses, pointsPlanned, reserved, remainingPoints, onRemove }: Props) {
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

      {entries.length > 0 ? (
        <div className="mt-5 space-y-2">
          {entries.map((e) => {
            const course = courses.find((c) => c.id === e.course_id);
            return (
              <div key={e.id} className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
                <span style={{ fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, minWidth: 0 }}>
                  {course?.name ?? "Unknown course"} <span style={{ color: COLOR.ink3 }}>· {e.term} · {e.planned_points} pts</span>
                </span>
                <button onClick={() => onRemove(e.id)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer", flexShrink: 0, textAlign: "left" }}>Remove</button>
              </div>
            );
          })}
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
