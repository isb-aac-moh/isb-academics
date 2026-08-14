import { useState } from "react";
import { fmt, normalCdf, normalPdf, Slider, Stat, VizFrame } from "./util";

interface Props {
  mean?: number;
  sd?: number;
  n?: number;
  k?: number;
  shift?: number;
  unit?: string;
}

/**
 * The trade-off in choosing control-limit width: narrower limits catch a real shift sooner (lower
 * Type II) at the cost of more false alarms on an unchanged process (higher Type I). Both rates are
 * computed off the sampling distribution of the mean (sd/sqrt(n)), not the raw process spread — the
 * same distinction the surrounding concept note keeps insisting on.
 */
export function ControlLimitWidth({
  mean = 19.32,
  sd = 7.73,
  n = 50,
  k = 3,
  shift = 3,
  unit = "min",
}: Props) {
  const [kk, setKk] = useState(k);
  const [sh, setSh] = useState(shift);

  const se = sd / Math.sqrt(n);
  const ucl = mean + kk * se;
  const lcl = mean - kk * se;
  const shiftedMean = mean + sh;

  // Type I: probability an UNCHANGED process still trips the alarm. Symmetric in standard errors,
  // so it depends only on k, never on the shift slider.
  const typeI = 2 * (1 - normalCdf(kk, 0, 1));
  // Type II: probability a process that HAS shifted by `sh` still lands inside the band.
  const typeII = normalCdf(ucl, shiftedMean, se) - normalCdf(lcl, shiftedMean, se);
  const power = 1 - typeII;

  const W = 420;
  const H = 170;
  const padB = 26;
  const lo = Math.min(mean - 4.5 * se, shiftedMean - 4.5 * se);
  const hi = Math.max(mean + 4.5 * se, shiftedMean + 4.5 * se);
  const x = (v: number) => ((v - lo) / (hi - lo)) * W;
  const peak = normalPdf(mean, mean, se);
  const y = (v: number, m: number, s: number) =>
    H - padB - Math.min(normalPdf(v, m, s) / peak, 1.05) * (H - padB - 18);

  function curve(m: number, s: number) {
    const pts: string[] = [];
    const N = 100;
    for (let i = 0; i <= N; i++) {
      const v = lo + ((hi - lo) * i) / N;
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

  return (
    <VizFrame
      title="Type I vs. Type II: how wide should the control band be?"
      caption="Thin dashed curve: the sampling distribution if nothing changed — its tails outside the band (red) are false alarms. Solid curve: the sampling distribution if the process really did shift — the part of it still inside the band (amber) is a miss. Narrow the band and false alarms rise but misses fall; widen it and the trade reverses."
      onReset={() => {
        setKk(k);
        setSh(shift);
      }}
      controls={
        <>
          <Slider label="Control limit width (k × σ/√n)" value={kk} min={1} max={4.5} step={0.25} onChange={setKk} />
          <Slider label="If the process actually shifted by" value={sh} min={-3 * se * 3} max={3 * se * 3} step={0.25} unit={unit} onChange={setSh} />
        </>
      }
    >
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full" role="img"
        aria-label={`Type I ${fmt(typeI * 100, 1)} percent, Type II ${fmt(typeII * 100, 1)} percent at k=${fmt(kk)}`}>
        <line x1="0" y1={H - padB} x2={W} y2={H - padB} className="stroke-line" strokeWidth="1" />

        {/* Type I: null curve's tails outside the band */}
        <path d={tail(mean, se, lo, lcl)} className="fill-bad/25" />
        <path d={tail(mean, se, ucl, hi)} className="fill-bad/25" />
        <path d={curve(mean, se)} className="fill-none stroke-ink-soft" strokeWidth="1.5" strokeDasharray="4 3" />

        {/* Type II: shifted curve's mass still inside the band */}
        <path d={tail(shiftedMean, se, Math.max(lo, lcl), Math.min(hi, ucl))} className="fill-[#f2b705]/30" />
        <path d={curve(shiftedMean, se)} className="fill-none stroke-accent" strokeWidth="2.5" />

        <line x1={x(ucl)} y1="8" x2={x(ucl)} y2={H - padB} className="stroke-ink" strokeWidth="1.5" strokeDasharray="3 3" />
        <line x1={x(lcl)} y1="8" x2={x(lcl)} y2={H - padB} className="stroke-ink" strokeWidth="1.5" strokeDasharray="3 3" />
        <text x={x(ucl)} y="16" textAnchor="middle" className="fill-ink text-[9px] font-bold">UCL</text>
        <text x={x(lcl)} y="16" textAnchor="middle" className="fill-ink text-[9px] font-bold">LCL</text>
      </svg>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat label="Type I (false alarm)" value={fmt(typeI * 100, 2)} unit="%"
          tone={typeI > 0.05 ? "bad" : "good"} hint="Alarms when nothing changed" />
        <Stat label="Type II (missed signal)" value={fmt(typeII * 100, 1)} unit="%"
          tone={typeII > 0.2 ? "bad" : "good"} hint={`At a real shift of ${fmt(sh, 1)} ${unit}`} />
        <Stat label="Power" value={fmt(power * 100, 1)} unit="%" tone="accent" hint="Catches that shift this often" />
      </div>
    </VizFrame>
  );
}
