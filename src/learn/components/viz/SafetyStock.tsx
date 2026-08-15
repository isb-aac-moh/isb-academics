import { useState } from "react";
import { fmt, normalCdf, normalInv, normalPdf, Slider, Stat, VizFrame } from "./util";

interface Props {
  meanDemand?: number;
  sdDemand?: number;
  leadTime?: number;
  serviceLevel?: number;
  unit?: string;
  timeUnit?: string;
}

/**
 * The reorder point is cycle stock (mean demand over the lead time) plus safety stock (the cushion
 * that pushes the line up). Drawn as one normal curve over lead-time demand, with a dashed line at
 * the mean (what you'd order to if demand were deterministic) and a solid line at the reorder point
 * (what you actually order to) — the gap between the two IS the safety stock, visually.
 */
export function SafetyStock({
  meanDemand = 100,
  sdDemand = 20,
  leadTime = 1.5,
  serviceLevel = 99,
  unit = "units",
  timeUnit = "week",
}: Props) {
  const [m, setM] = useState(meanDemand);
  const [s, setS] = useState(sdDemand);
  const [l, setL] = useState(leadTime);
  const [sl, setSl] = useState(serviceLevel);

  const ltdMean = m * l;
  const ltdSd = s * Math.sqrt(l);
  const z = normalInv(Math.min(Math.max(sl / 100, 0.0001), 0.9999));
  const safetyStock = z * ltdSd;
  const rop = ltdMean + safetyStock;
  const stockoutRisk = (1 - normalCdf(rop, ltdMean, ltdSd)) * 100;

  const W = 420;
  const H = 165;
  const padB = 26;
  const lo = ltdMean - 4 * ltdSd;
  const hi = ltdMean + 4 * ltdSd;
  const x = (v: number) => ((v - lo) / (hi - lo)) * W;
  const peak = normalPdf(ltdMean, ltdMean, ltdSd);
  const y = (v: number) => H - padB - (normalPdf(v, ltdMean, ltdSd) / peak) * (H - padB - 12);

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

  return (
    <VizFrame
      title="Reorder point = cycle stock + safety stock"
      caption="The curve is demand over the lead time. The dashed line is the mean — order only to there and half your lead times end in a stockout. The solid line is the reorder point: push it right until only the target sliver (red) is left outside."
      onReset={() => {
        setM(meanDemand);
        setS(sdDemand);
        setL(leadTime);
        setSl(serviceLevel);
      }}
      controls={
        <>
          <Slider label={`Mean demand / ${timeUnit}`} value={m} min={10} max={300} unit={unit} onChange={setM} />
          <Slider label={`Demand std dev / ${timeUnit}`} value={s} min={1} max={80} unit={unit} onChange={setS} />
          <Slider label="Lead time" value={l} min={0.5} max={6} step={0.5} unit={timeUnit + "s"} onChange={setL} />
          <Slider label="Target service level" value={sl} min={50} max={99.9} step={0.1} unit="%" onChange={setSl} />
        </>
      }
    >
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full" role="img"
        aria-label={`Lead-time demand distribution, reorder point ${fmt(rop, 0)} ${unit}`}>
        <line x1="0" y1={H - padB} x2={W} y2={H - padB} className="stroke-line" strokeWidth="1" />
        <path d={area(lo, Math.min(rop, hi))} className="fill-good/20" />
        <path d={area(Math.min(rop, hi), hi)} className="fill-bad/30" />
        <path d={`M ${pts.join(" L ")}`} className="fill-none stroke-accent" strokeWidth="2" />

        <line x1={x(ltdMean)} y1="20" x2={x(ltdMean)} y2={H - padB} className="stroke-ink-soft" strokeWidth="1.5" strokeDasharray="3 3" />
        <text x={x(ltdMean)} y="14" textAnchor="middle" className="fill-ink-soft text-[9px] font-semibold">
          mean {fmt(ltdMean, 0)}
        </text>

        <line x1={x(rop)} y1="8" x2={x(rop)} y2={H - padB} className="stroke-ink" strokeWidth="2" />
        <text x={Math.min(Math.max(x(rop), 30), W - 20)} y="8" dy="8" textAnchor="middle"
          className="fill-ink text-[10px] font-bold">
          ROP {fmt(rop, 0)}
        </text>
      </svg>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat label="Safety stock" value={fmt(safetyStock, 0)} unit={unit} tone="accent"
          hint={`z(${fmt(sl, 1)}%) × σ√L = ${fmt(z, 2)} × ${fmt(ltdSd, 1)}`} />
        <Stat label="Reorder point" value={fmt(rop, 0)} unit={unit} tone="good"
          hint={`Mean ${fmt(ltdMean, 0)} + safety stock`} />
        <Stat label="Stockout risk at ROP" value={fmt(stockoutRisk, 2)} unit="%"
          tone={stockoutRisk > 100 - sl + 0.5 ? "bad" : "good"} hint="Should match 100% − service level" />
      </div>
    </VizFrame>
  );
}
