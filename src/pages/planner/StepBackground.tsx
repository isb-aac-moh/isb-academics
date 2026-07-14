import { COLOR, FONT } from "../../lib/theme";
import { UNDERGRAD_FIELDS, WORK_EX_DOMAINS, WORK_EX_ROLES, TERM2_FLEXI_OPTIONS, TERM3_FLEXI_OPTIONS } from "../../lib/options";
import type { StudentAcademicProfile, GatingCoreCourse } from "../../types";

interface Props {
  profile: StudentAcademicProfile;
  save: (updates: Partial<StudentAcademicProfile>) => void;
  gatingCourses: GatingCoreCourse[];
}

export default function StepBackground({ profile, save, gatingCourses }: Props) {
  function toggle(list: string[], code: string, field: "completed_term2_flexi" | "completed_term3_flexi") {
    const next = list.includes(code) ? list.filter((c) => c !== code) : [...list, code];
    save({ [field]: next } as Partial<StudentAcademicProfile>);
  }

  return (
    <div className="space-y-8">
      <div>
        <p style={{ fontFamily: FONT.serif, fontSize: 15, color: COLOR.ink2, marginBottom: 20, lineHeight: 1.6 }}>
          A little about you first — this shapes how we read your credit progress later, nothing more.
        </p>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Field label="Undergrad field">
            <select style={inputStyle} value={profile.undergrad_field} onChange={(e) => save({ undergrad_field: e.target.value })}>
              <option value="">Select…</option>
              {UNDERGRAD_FIELDS.map((f) => <option key={f} value={f}>{f}</option>)}
            </select>
          </Field>
          <Field label="Pre-ISB work-ex domain">
            <select style={inputStyle} value={profile.work_ex_domain} onChange={(e) => save({ work_ex_domain: e.target.value })}>
              <option value="">Select…</option>
              {WORK_EX_DOMAINS.map((f) => <option key={f} value={f}>{f}</option>)}
            </select>
          </Field>
          <Field label="Your role / function in that domain">
            <select style={inputStyle} value={profile.work_ex_role} onChange={(e) => save({ work_ex_role: e.target.value })}>
              <option value="">Select…</option>
              {WORK_EX_ROLES.map((r) => <option key={r} value={r}>{r}</option>)}
            </select>
          </Field>
          <Field label="Years of work-ex">
            <input
              type="number" min={0} step={0.5} style={inputStyle}
              value={profile.work_ex_years || ""}
              onChange={(e) => save({ work_ex_years: Number(e.target.value) })}
            />
          </Field>
        </div>
      </div>

      <div>
        <p style={{ fontSize: 13, fontWeight: 700, color: COLOR.ink, fontFamily: FONT.sans, marginBottom: 4 }}>
          Term 2 Flexi Core — which did you take?
        </p>
        <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 10 }}>Pick 2-3 — these already count toward your concentration credits if they match.</p>
        <div className="flex flex-wrap gap-2">
          {TERM2_FLEXI_OPTIONS.map((o) => (
            <Chip key={o.code} active={profile.completed_term2_flexi.includes(o.code)} onClick={() => toggle(profile.completed_term2_flexi, o.code, "completed_term2_flexi")} label={o.label} />
          ))}
        </div>
      </div>

      <div>
        <p style={{ fontSize: 13, fontWeight: 700, color: COLOR.ink, fontFamily: FONT.sans, marginBottom: 4 }}>
          Term 3 Flexi Core — which did you take?
        </p>
        <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 10 }}>
          Pick 2-3. Only one Business Analytics variant is realistic — ISB only lets you take one of the two.
        </p>
        <div className="flex flex-wrap gap-2">
          {TERM3_FLEXI_OPTIONS.map((o) => (
            <Chip key={o.code} active={profile.completed_term3_flexi.includes(o.code)} onClick={() => toggle(profile.completed_term3_flexi, o.code, "completed_term3_flexi")} label={o.label} />
          ))}
        </div>
      </div>

      <div>
        <p style={{ fontSize: 13, fontWeight: 700, color: COLOR.ink, fontFamily: FONT.sans, marginBottom: 4 }}>
          Failed any of these core courses?
        </p>
        <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 10 }}>
          An F here permanently blocks the matching concentration — worth knowing before you pick a target.
        </p>
        <div className="flex flex-wrap gap-2">
          {gatingCourses.map((g) => {
            const checked = profile.failed_gating_courses.includes(g.id);
            return (
              <button
                key={g.id}
                onClick={() => {
                  const next = checked ? profile.failed_gating_courses.filter((id) => id !== g.id) : [...profile.failed_gating_courses, g.id];
                  save({ failed_gating_courses: next });
                }}
                style={{
                  padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600, fontFamily: FONT.sans,
                  border: `1px solid ${checked ? COLOR.red : COLOR.border}`,
                  background: checked ? COLOR.redTint : COLOR.surface,
                  color: checked ? COLOR.red : COLOR.ink2, cursor: "pointer",
                }}
              >
                {g.name} <span style={{ opacity: 0.7 }}>({g.term})</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 6 }}>{label}</p>
      {children}
    </div>
  );
}

function Chip({ active, onClick, label }: { active: boolean; onClick: () => void; label: string }) {
  return (
    <button
      onClick={onClick}
      style={{
        padding: "7px 13px", borderRadius: 8, fontSize: 12.5, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer",
        border: `1px solid ${active ? COLOR.navyHero : COLOR.border}`, background: active ? COLOR.navyHero : COLOR.surface, color: active ? "#fff" : COLOR.ink2,
        maxWidth: "100%", whiteSpace: "normal", textAlign: "left", wordBreak: "break-word",
      }}
    >
      {label}
    </button>
  );
}

const inputStyle: React.CSSProperties = {
  width: "100%", padding: "10px 12px", borderRadius: 9, border: `1px solid ${COLOR.border}`,
  fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, background: COLOR.surface, outline: "none",
};
