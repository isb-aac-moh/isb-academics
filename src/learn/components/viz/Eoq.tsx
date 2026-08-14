import { useState } from "react";
import { fmt, Slider, Stat, VizFrame } from "./util";

interface Props {
  demand?: number;
  orderCost?: number;
  holdingCost?: number;
  unit?: string;
}

/**
 * EOQ as two costs pulling in opposite directions. The flat bottom matters as much as the minimum:
 * being 20% off the optimal order size barely costs anything, which is why the exact number is
 * less interesting than the shape.
 */
export function Eoq({ demand = 12000, orderCost = 500, holdingCost = 12, unit = "units" }: Props) {
  const [d, setD] = useState(demand);
  const [s, setS] = useState(orderCost);
  const [h, setH] = useState(holdingCost);

  const qStar = Math.sqrt((2 * d * s) / h);
  const ordering = (q: number) => (d / q) * s;
  const holding = (q: number) => (q / 2) * h;
  const total = (q: number) => ordering(q) + holding(q);
  const minCost = total(qStar);

  const W = 420;
  const H = 165;
  const padB = 26;
  const qMax = qStar * 3;
  const yMax = total(qStar * 0.25);
  const x = (q: number) => (q / qMax) * W;
  const y = (v: number) => H - padB - Math.min(v / yMax, 1) * (H - padB - 12);

  function path(f: (q: number) => number) {
    const pts: string[] = [];
    for (let i = 1; i <= 100; i++) {
      const q = (qMax * i) / 100;
      pts.push(`${x(q).toFixed(1)},${y(f(q)).toFixed(1)}`);
    }
    return `M ${pts.join(" L ")}`;
  }

  return (
    <VizFrame
      title="EOQ: two costs pulling against each other"
      caption="Order in big batches and holding cost climbs. Order in small ones and you pay the ordering cost over and over. Notice how flat the bottom is — close to right is good enough."
      onReset={() => {
        setD(demand);
        setS(orderCost);
        setH(holdingCost);
      }}
      controls={
        <>
          <Slider label="Annual demand (D)" value={d} min={1000} max={50000} step={500} unit={unit} onChange={setD} />
          <Slider label="Cost per order (S)" value={s} min={50} max={2000} step={50} unit="₹" onChange={setS} />
          <Slider label="Holding cost/unit/yr (H)" value={h} min={1} max={60} unit="₹" onChange={setH} />
        </>
      }
    >
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full" role="img"
        aria-label={`Cost curves; economic order quantity ${fmt(qStar, 0)} ${unit}`}>
        <line x1="0" y1={H - padB} x2={W} y2={H - padB} className="stroke-line" strokeWidth="1" />
        <path d={path(ordering)} className="fill-none stroke-bad/60" strokeWidth="1.5" strokeDasharray="4 3" />
        <path d={path(holding)} className="fill-none stroke-good/70" strokeWidth="1.5" strokeDasharray="4 3" />
        <path d={path(total)} className="fill-none stroke-accent" strokeWidth="2.5" />

        <line x1={x(qStar)} y1={y(minCost)} x2={x(qStar)} y2={H - padB} className="stroke-ink" strokeWidth="1.5" strokeDasharray="3 3" />
        <circle cx={x(qStar)} cy={y(minCost)} r="4.5" className="fill-accent" />
        <text x={x(qStar)} y={H - padB + 13} textAnchor="middle" className="fill-ink text-[10px] font-bold">
          Q* = {fmt(qStar, 0)}
        </text>

        <text x={W - 4} y="18" textAnchor="end" className="fill-bad/80 text-[9px] font-semibold">ordering</text>
        <text x={W - 4} y={H - padB - 6} textAnchor="end" className="fill-good text-[9px] font-semibold">holding</text>
      </svg>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat label="Economic order qty" value={fmt(qStar, 0)} unit={unit} tone="accent" hint="√(2DS ÷ H)" />
        <Stat label="Total annual cost" value={`₹${fmt(minCost, 0)}`} tone="good" hint="Ordering + holding, at Q*" />
        <Stat label="Cost if you order 50% more" value={`+₹${fmt(total(qStar * 1.5) - minCost, 0)}`}
          hint="Barely worse — the curve is flat here" />
      </div>
    </VizFrame>
  );
}
