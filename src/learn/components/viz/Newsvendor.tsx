import { useState } from "react";
import { fmt, normalCdf, normalInv, normalPdf, Slider, Stat, VizFrame } from "./util";

interface Props {
  mean?: number;
  sd?: number;
  price?: number;
  cost?: number;
  salvage?: number;
  unit?: string;
}

/**
 * Newsvendor as a asymmetry-of-regret picture rather than a formula. The critical ratio is just
 * "how much worse is running out than being left over" — once that lands, the z-lookup is clerical.
 */
export function Newsvendor({ mean = 100, sd = 30, price = 50, cost = 20, salvage = 5, unit = "units" }: Props) {
  const [p, setP] = useState(price);
  const [c, setC] = useState(cost);
  const [sv, setSv] = useState(salvage);
  const [sigma, setSigma] = useState(sd);

  const cu = Math.max(p - c, 0);
  const co = Math.max(c - sv, 0);
  const cr = cu + co > 0 ? cu / (cu + co) : 0.5;
  const z = normalInv(Math.min(Math.max(cr, 0.0001), 0.9999));
  const qStar = mean + z * sigma;
  const serviceLevel = cr * 100;

  const W = 420;
  const H = 155;
  const padB = 26;
  const lo = mean - 4 * sigma;
  const hi = mean + 4 * sigma;
  const x = (v: number) => ((v - lo) / (hi - lo)) * W;
  const peak = normalPdf(mean, mean, sigma);
  const y = (v: number) => H - padB - (normalPdf(v, mean, sigma) / peak) * (H - padB - 12);

  const pts: string[] = [];
  for (let i = 0; i <= 120; i++) {
    const v = lo + ((hi - lo) * i) / 120;
    pts.push(`${x(v).toFixed(1)},${y(v).toFixed(1)}`);
  }

  function area(from: number, to: number) {
    const seg: string[] = [];
    for (let i = 0; i <= 50; i++) {
      const v = from + ((to - from) * i) / 50;
      seg.push(`${x(v).toFixed(1)},${y(v).toFixed(1)}`);
    }
    return `M ${x(from).toFixed(1)},${H - padB} L ${seg.join(" L ")} L ${x(to).toFixed(1)},${H - padB} Z`;
  }

  const pStockout = (1 - normalCdf(qStar, mean, sigma)) * 100;

  return (
    <VizFrame
      title="Newsvendor: how much regret is on each side?"
      caption="Green is demand you can serve, red is demand you turn away. Raise the price and the red shrinks — losing a sale hurts more than eating a leftover, so you stock more."
      onReset={() => {
        setP(price);
        setC(cost);
        setSv(salvage);
        setSigma(sd);
      }}
      controls={
        <>
          <Slider label="Selling price" value={p} min={Math.ceil(cost) + 1} max={Math.ceil(price * 3)} unit="₹" onChange={setP} />
          <Slider label="Unit cost" value={c} min={1} max={Math.max(Math.floor(price) - 1, 2)} unit="₹" onChange={setC} />
          <Slider label="Salvage value" value={sv} min={0} max={Math.max(Math.floor(cost) - 1, 1)} unit="₹" onChange={setSv} />
          <Slider label="Demand std dev" value={sigma} min={5} max={80} unit={unit} onChange={setSigma} />
        </>
      }
    >
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full" role="img"
        aria-label={`Demand distribution with optimal order quantity ${fmt(qStar, 0)} ${unit}`}>
        <line x1="0" y1={H - padB} x2={W} y2={H - padB} className="stroke-line" strokeWidth="1" />
        <path d={area(lo, Math.min(qStar, hi))} className="fill-good/25" />
        <path d={area(Math.min(qStar, hi), hi)} className="fill-bad/25" />
        <path d={`M ${pts.join(" L ")}`} className="fill-none stroke-accent" strokeWidth="2" />

        <line x1={x(qStar)} y1="8" x2={x(qStar)} y2={H - padB} className="stroke-ink" strokeWidth="2" />
        <text x={Math.min(Math.max(x(qStar), 30), W - 30)} y="15" textAnchor="middle"
          className="fill-ink text-[10px] font-bold">
          Q* = {fmt(qStar, 0)}
        </text>
        <text x={x(mean)} y={H - padB + 13} textAnchor="middle" className="fill-ink-soft text-[10px]">
          mean {fmt(mean, 0)}
        </text>
      </svg>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat label="Critical ratio" value={fmt(cr, 3)} tone="accent"
          hint={`Cu ${fmt(cu, 0)} ÷ (Cu ${fmt(cu, 0)} + Co ${fmt(co, 0)})`} />
        <Stat label="Order quantity Q*" value={fmt(qStar, 0)} unit={unit} tone="good"
          hint={`mean + ${fmt(z, 2)} × σ`} />
        <Stat label="Chance you still run out" value={fmt(pStockout, 1)} unit="%"
          hint={`Target service level ${fmt(serviceLevel, 1)}%`} />
      </div>
    </VizFrame>
  );
}
