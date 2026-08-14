import { useState } from "react";
import { fmt, normalCdf, normalPdf, Slider, Stat, VizFrame } from "./util";

interface Props {
  mean?: number;
  sd?: number;
  lsl?: number;
  usl?: number;
  unit?: string;
  label?: string;
}

/**
 * The process-capability picture: where the process actually sits versus where the promise sits.
 * Sigma capability is deliberately computed off the CLOSEST spec limit — the whole point of the
 * min() in the formula is that the near side is the side that hurts you.
 */
export function Capability({
  mean = 21.38,
  sd = 7.73,
  lsl,
  usl = 30,
  unit = "min",
  label = "Delivery time",
}: Props) {
  const [m, setM] = useState(mean);
  const [s, setS] = useState(sd);

  const hasL = typeof lsl === "number";
  const hasU = typeof usl === "number";

  /**
   * Slider bounds come from the *initial* parameters and the spec limits, never from live state.
   * Deriving them from the current mean made each drag move the slider's own domain, so the mean
   * could run away to arbitrary values and the curve would drift off the chart forever.
   */
  const anchorLo = Math.min(mean - 3 * sd, hasL ? lsl! : Infinity);
  const anchorHi = Math.max(mean + 3 * sd, hasU ? usl! : -Infinity);
  const meanMin = Math.floor(anchorLo);
  const meanMax = Math.ceil(anchorHi);
  const sdMax = Math.ceil(Math.max(sd * 2.5, (anchorHi - anchorLo) / 4));

  const zU = hasU ? (usl! - m) / s : Infinity;
  const zL = hasL ? (m - lsl!) / s : Infinity;
  const sigma = Math.min(zU, zL);

  const pAbove = hasU ? 1 - normalCdf(usl!, m, s) : 0;
  const pBelow = hasL ? normalCdf(lsl!, m, s) : 0;
  const defective = (pAbove + pBelow) * 100;

  const cp = hasL && hasU ? (usl! - lsl!) / (6 * s) : NaN;
  const cpk = sigma / 3;

  const W = 420;
  const H = 170;
  const padB = 26;
  // A fixed viewport anchored on the spec limits. If it tracked the mean, dragging the mean would
  // slide the whole axis with it and the curve would look stationary -- hiding the one relationship
  // this chart exists to show.
  const lo = meanMin - 2 * sd;
  const hi = meanMax + 2 * sd;
  const x = (v: number) => ((v - lo) / (hi - lo)) * W;
  // Scaled against the starting spread, so widening sigma visibly flattens the curve instead of
  // renormalising it back to full height.
  const peak = normalPdf(mean, mean, sd);
  const y = (v: number) =>
    H - padB - Math.min(normalPdf(v, m, s) / peak, 1.15) * (H - padB - 18);

  const pts: string[] = [];
  const N = 120;
  for (let i = 0; i <= N; i++) {
    const v = lo + ((hi - lo) * i) / N;
    pts.push(`${x(v).toFixed(1)},${y(v).toFixed(1)}`);
  }
  const curve = `M ${pts.join(" L ")}`;

  /** Shaded out-of-spec area, drawn as a closed path down to the baseline. */
  function tail(from: number, to: number) {
    const seg: string[] = [];
    for (let i = 0; i <= 40; i++) {
      const v = from + ((to - from) * i) / 40;
      seg.push(`${x(v).toFixed(1)},${y(v).toFixed(1)}`);
    }
    return `M ${x(from).toFixed(1)},${H - padB} L ${seg.join(" L ")} L ${x(to).toFixed(1)},${H - padB} Z`;
  }

  return (
    <VizFrame
      title="Process capability: the promise vs. the process"
      caption="The curve is what your process actually does. The dashed lines are what you promised. Everything shaded red broke the promise — drag the mean or the spread and watch that area move."
      onReset={() => {
        setM(mean);
        setS(sd);
      }}
      controls={
        <>
          <Slider label="Process mean" value={m} min={meanMin} max={meanMax} step={0.1} unit={unit} onChange={setM} />
          <Slider label="Standard deviation" value={s} min={0.5} max={sdMax} step={0.1} unit={unit} onChange={setS} />
        </>
      }
    >
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full" role="img"
        aria-label={`Normal curve, mean ${fmt(m)}, sd ${fmt(s)}, ${fmt(defective)} percent out of spec`}>
        <line x1="0" y1={H - padB} x2={W} y2={H - padB} className="stroke-line" strokeWidth="1" />

        {hasU && zU < 4 && <path d={tail(usl!, hi)} className="fill-bad/25" />}
        {hasL && zL < 4 && <path d={tail(lo, lsl!)} className="fill-bad/25" />}

        <path d={curve} className="fill-none stroke-accent" strokeWidth="2" />

        <line x1={x(m)} y1={y(m)} x2={x(m)} y2={H - padB} className="stroke-accent" strokeWidth="1.5" strokeDasharray="3 3" />
        <text x={x(m)} y={H - padB + 13} textAnchor="middle" className="fill-accent text-[10px] font-semibold">
          mean {fmt(m, 1)}
        </text>

        {hasU && (
          <>
            <line x1={x(usl!)} y1="8" x2={x(usl!)} y2={H - padB} className="stroke-bad" strokeWidth="2" strokeDasharray="5 3" />
            <text x={Math.min(x(usl!) + 4, W - 4)} y="16" textAnchor={x(usl!) > W - 60 ? "end" : "start"}
              className="fill-bad text-[10px] font-bold">
              USL {fmt(usl!, 0)}
            </text>
          </>
        )}
        {hasL && (
          <>
            <line x1={x(lsl!)} y1="8" x2={x(lsl!)} y2={H - padB} className="stroke-bad" strokeWidth="2" strokeDasharray="5 3" />
            <text x={Math.max(x(lsl!) - 4, 4)} y="16" textAnchor="end" className="fill-bad text-[10px] font-bold">
              LSL {fmt(lsl!, 0)}
            </text>
          </>
        )}
      </svg>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat
          label="Out of spec"
          value={fmt(defective, 1)}
          unit="%"
          tone={defective > 5 ? "bad" : "good"}
          hint={`${label} misses the promise this often`}
        />
        <Stat
          label="Sigma capability"
          value={fmt(sigma, 2)}
          unit="σ"
          tone={sigma >= 3 ? "good" : "bad"}
          hint="Distance to the nearest spec limit"
        />
        <Stat
          label={hasL && hasU ? "Cp / Cpk" : "Cpk"}
          value={hasL && hasU ? `${fmt(cp, 2)} / ${fmt(cpk, 2)}` : fmt(cpk, 2)}
          tone={cpk >= 1 ? "good" : "bad"}
          hint={hasL && hasU ? "Cp ignores centring, Cpk does not" : "Sigma ÷ 3"}
        />
      </div>
    </VizFrame>
  );
}
