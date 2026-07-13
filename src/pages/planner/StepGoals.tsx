import { COLOR, FONT } from "../../lib/theme";
import { MAX_CONCENTRATIONS } from "../../lib/options";
import type { StudentAcademicProfile, ConcentrationArea, IndustrySpecialization } from "../../types";

const CONCENTRATIONS: ConcentrationArea[] = [
  "Entrepreneurship", "Finance", "Marketing", "Operations Management",
  "Information Technology Management", "Strategy and Leadership",
];
const SPECIALIZATIONS: IndustrySpecialization[] = ["Healthcare", "Manufacturing", "Public Policy", "Infrastructure"];

interface Props {
  profile: StudentAcademicProfile;
  save: (updates: Partial<StudentAcademicProfile>) => void;
}

export default function StepGoals({ profile, save }: Props) {
  const concentrations = profile.target_concentrations;
  const atMax = concentrations.length >= MAX_CONCENTRATIONS;

  function toggleConcentration(area: ConcentrationArea) {
    if (concentrations.includes(area)) {
      save({ target_concentrations: concentrations.filter((a) => a !== area) });
    } else if (!atMax) {
      save({ target_concentrations: [...concentrations, area] });
    }
  }

  return (
    <div className="space-y-10">
      <div>
        <p style={{ fontSize: 15, fontFamily: FONT.serif, color: COLOR.ink, marginBottom: 4 }}>
          Which concentration(s) are you aiming for?
        </p>
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 14 }}>
          ISB allows up to two. Pick none if you're not planning to major in one — plenty of students don't.
        </p>
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => save({ target_concentrations: [] })}
            style={pillStyle(concentrations.length === 0)}
          >
            None — not pursuing a concentration
          </button>
          {CONCENTRATIONS.map((c) => {
            const active = concentrations.includes(c);
            const disabled = !active && atMax;
            return (
              <button key={c} onClick={() => toggleConcentration(c)} disabled={disabled} style={{ ...pillStyle(active), opacity: disabled ? 0.4 : 1 }}>
                {c}
              </button>
            );
          })}
        </div>
        {atMax && <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 8 }}>You've picked 2 — that's the max. Remove one to swap.</p>}
      </div>

      <div>
        <p style={{ fontSize: 15, fontFamily: FONT.serif, color: COLOR.ink, marginBottom: 4 }}>
          Industry specialization?
        </p>
        <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 14 }}>
          Only one can be listed on your transcript.
        </p>
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => save({ target_specialization: "none" })}
            style={pillStyle(profile.target_specialization === "none" || !profile.target_specialization || profile.target_specialization === "undecided")}
          >
            None / undecided
          </button>
          {SPECIALIZATIONS.map((s) => (
            <button key={s} onClick={() => save({ target_specialization: s })} style={pillStyle(profile.target_specialization === s)}>
              {s}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

function pillStyle(active: boolean): React.CSSProperties {
  return {
    padding: "9px 16px", borderRadius: 9, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer",
    border: `1px solid ${active ? COLOR.navyHero : COLOR.border}`, background: active ? COLOR.navyHero : COLOR.surface, color: active ? "#fff" : COLOR.ink2,
  };
}
