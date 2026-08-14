import { useState } from "react";
import { fmt, normalCdf, normalPdf, Slider, Stat, VizFrame } from "./util";

interface Props {
  lsl?: number;
  usl?: number;
  sigmaWide?: number;
  sigmaTight?: number;
  centerMean?: number;
  unit?: string;
}

/**
 * Same fixed spec window, two processes with different spread, one mean slider that drifts both at
 * once. The point isn't the snapshot at the centred mean (both can be ~0% defective there) — it's
 * how much drift each one can absorb before defects appear. That is what "six sigma" is actually
 * buying: margin against a shift that hasn't happened yet.
 */
export function SixSigmaDrift({
  lsl = 100,
  usl = 160,
  sigmaWide = 10,
  sigmaTight = 5,
  centerMean = 130,
  unit = "",
}: Props) {
  const [mean, setMean] = useState(centerMean);

  const center = (lsl + usl) / 2;
  const defective = (m: number, s: number) => {
    const pAbove = 1 - normalCdf(usl, m, s);
    const pBelow = normalCdf(lsl, m, s);
    return (pAbove + pBelow) * 100;
  };
  const sigmaCap = (m: number, s: number) => Math.min((usl - m) / s, (m - lsl) / s);

  const W = 420;
  const H = 170;
  const padB = 26;
  const lo = lsl - 2.5 * sigmaWide;
  const hi = usl + 2.5 * sigmaWide;
  const x = (v: number) => ((v - lo) / (hi - lo)) * W;
  const peak = normalPdf(center, center, sigmaTight);
  const y = (v: number, m: number, s: number) =>
    H - padB - Math.min(normalPdf(v, m, s) / peak, 1.05) * (H - padB - 18);

  function curve(m: number, s: number) {
    const pts: string[] = [];
    for (let i = 0; i <= 100; i++) {
      const v = lo + ((hi - lo) * i) / 100;
      pts.push(`${x(v).toFixed(1)},${y(v, m, s).toFixed(1)}`);
    }
    return `M ${pts.join(" L ")}`;
  }

  function tail(m: number, s: number, from: number, to: number) {
    const seg: string[] = [];
    for (let i = 0; i <= 40; i++) {
      const v = from + ((to - from) * i) / 40;
      seg.push(`${x(v).toFixed(1)},${y(v, m, s).toFixed(1)}`);
    }
    return `M ${x(from).toFixed(1)},${H - padB} L ${seg.join(" L ")} L ${x(to).toFixed(1)},${H - padB} Z`;
  }

  const driftFromCenter = mean - center;

  return (
    <VizFrame
      title="Six sigma is margin against tomorrow's drift"
      caption="Same spec window, two processes with different spread — one 3-sigma-capable at the centred mean (blue), one 6-sigma-capable (amber). Drag the mean to simulate drift and watch which one starts producing defects first."
      onReset={() => setMean(centerMean)}
      controls={
        <Slider label="Process mean (drifting)" value={mean} min={lsl - sigmaWide} max={usl + sigmaWide} step={1} unit={unit} onChange={setMean} />
      }
    >
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full" role="img"
        aria-label={`Wide sigma ${fmt(defective(mean, sigmaWide), 1)} percent defective, tight sigma ${fmt(defective(mean, sigmaTight), 2)} percent defective`}>
        <line x1="0" y1={H - padB} x2={W} y2={H - padB} className="stroke-line" strokeWidth="1" />

        <path d={tail(mean, sigmaWide, lo, lsl)} className="fill-bad/20" />
        <path d={tail(mean, sigmaWide, usl, hi)} className="fill-bad/20" />
        <path d={curve(mean, sigmaWide)} className="fill-none stroke-[#6fb7e0]" strokeWidth="2" />

        <path d={tail(mean, sigmaTight, lo, lsl)} className="fill-bad/35" />
        <path d={tail(mean, sigmaTight, usl, hi)} className="fill-bad/35" />
        <path d={curve(mean, sigmaTight)} className="fill-none stroke-accent" strokeWidth="2.5" />

        <line x1={x(usl)} y1="8" x2={x(usl)} y2={H - padB} className="stroke-bad" strokeWidth="2" strokeDasharray="5 3" />
        <line x1={x(lsl)} y1="8" x2={x(lsl)} y2={H - padB} className="stroke-bad" strokeWidth="2" strokeDasharray="5 3" />
        <text x={x(usl) + 4} y="16" className="fill-bad text-[10px] font-bold">USL</text>
        <text x={x(lsl) - 4} y="16" textAnchor="end" className="fill-bad text-[10px] font-bold">LSL</text>
      </svg>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat label="Drift from center" value={`${driftFromCenter >= 0 ? "+" : ""}${fmt(driftFromCenter, 0)}`} unit={unit} />
        <Stat label="Wide σ — defective" value={fmt(defective(mean, sigmaWide), 1)} unit="%"
          tone={defective(mean, sigmaWide) > 0.3 ? "bad" : "good"} hint={`≈ ${fmt(sigmaCap(mean, sigmaWide), 1)}σ capability`} />
        <Stat label="Tight σ — defective" value={fmt(defective(mean, sigmaTight), 3)} unit="%"
          tone={defective(mean, sigmaTight) > 0.3 ? "bad" : "good"} hint={`≈ ${fmt(sigmaCap(mean, sigmaTight), 1)}σ capability`} />
      </div>
    </VizFrame>
  );
}
