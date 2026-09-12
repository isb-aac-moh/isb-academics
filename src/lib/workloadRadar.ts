/**
 * The six-axis workload radar, shared by the Bidding Planner's "Your Term at a
 * Glance" and the Term Dossier's "Build the Term". Both draw the same picture
 * from the same six load_* columns, so the drawing lives here rather than in
 * either page.
 */
import { COLOR } from "./theme";
import type { CourseGradingProfile } from "../types";

export type LoadKey = keyof Pick<
  CourseGradingProfile,
  "load_quant" | "load_assignments" | "load_participation" | "load_exam_pressure" | "load_group" | "load_reading"
>;

export const LOAD_AXES: { key: LoadKey; label: string }[] = [
  { key: "load_quant", label: "Quant" },
  { key: "load_assignments", label: "Assignments" },
  { key: "load_participation", label: "Participation" },
  { key: "load_exam_pressure", label: "Exam pressure" },
  { key: "load_group", label: "Group work" },
  { key: "load_reading", label: "Reading" },
];

export function avg(nums: number[]): number {
  return nums.length ? nums.reduce((s, n) => s + n, 0) / nums.length : 0;
}

export function buildRadar(profiles: CourseGradingProfile[]): string {
  const size = 260, cx = size / 2, cy = size / 2 + 4, R = 88, n = LOAD_AXES.length;
  const angle = (i: number) => -Math.PI / 2 + (i * 2 * Math.PI) / n;
  const pt = (i: number, v: number): [number, number] => [cx + Math.cos(angle(i)) * R * (v / 5), cy + Math.sin(angle(i)) * R * (v / 5)];

  let g = "";
  for (let r = 1; r <= 5; r++) {
    const pts = LOAD_AXES.map((_, i) => pt(i, r).join(",")).join(" ");
    g += `<polygon points="${pts}" fill="none" stroke="${r === 5 ? COLOR.ink : COLOR.borderLight}" stroke-width="${r === 5 ? 1.5 : 1}"/>`;
  }
  LOAD_AXES.forEach((ax, i) => {
    const [x, y] = pt(i, 5);
    g += `<line x1="${cx}" y1="${cy}" x2="${x}" y2="${y}" stroke="${COLOR.borderLight}" stroke-width="1"/>`;
    const [lx, ly] = pt(i, 5.85);
    g += `<text x="${lx}" y="${ly}" font-size="9.5" font-weight="700" fill="${COLOR.ink3}" text-anchor="middle" dominant-baseline="middle" font-family="Plus Jakarta Sans">${ax.label}</text>`;
  });

  const values = LOAD_AXES.map((ax) => avg(profiles.map((p) => p[ax.key])));
  const pts = LOAD_AXES.map((ax, i) => pt(i, avg(profiles.map((p) => p[ax.key]))).join(",")).join(" ");
  g += `<polygon points="${pts}" fill="${COLOR.navyHero}22" stroke="${COLOR.navyHero}" stroke-width="2.5"/>`;
  values.forEach((v, i) => {
    const [x, y] = pt(i, v);
    g += `<circle cx="${x}" cy="${y}" r="3" fill="${COLOR.navyHero}"/>`;
  });

  return `<svg viewBox="0 0 ${size} ${size + 12}" width="100%" style="max-width:280px">${g}</svg>`;
}

/**
 * A single 0-10 read of how heavy a course is: the plain mean of its six 0-5
 * workload scores, doubled. Deliberately unweighted -- there's no defensible
 * basis for saying reading load matters 0.8x as much as exam pressure, and a
 * made-up weighting would read as more precise than it is.
 */
export function pressureScore(p: CourseGradingProfile): number {
  return avg(LOAD_AXES.map((ax) => p[ax.key])) * 2;
}

export type PressureTier = "Chill" | "Moderate" | "Intense";

export function pressureTier(score: number): PressureTier {
  if (score <= 4) return "Chill";
  if (score <= 6.5) return "Moderate";
  return "Intense";
}

export const TIER_COLOR: Record<PressureTier, { fg: string; bg: string }> = {
  Chill: { fg: COLOR.green, bg: COLOR.greenTint },
  Moderate: { fg: COLOR.amber, bg: COLOR.amberTint },
  Intense: { fg: COLOR.red, bg: COLOR.redTint },
};
