import { useState } from "react";
import { fmt, Slider, Stat, VizFrame } from "./util";

interface Props {
  price?: number;
  cost?: number;
  fixed?: number;
  currency?: string;
  unit?: string;
}

/**
 * Break-even plus the margin/markup distinction in one place, because they are confused constantly
 * and the confusion is always the same one: margin divides by price, markup divides by cost.
 */
export function BreakEven({ price = 1, cost = 0.7, fixed = 60, currency = "$", unit = "units" }: Props) {
  const [p, setP] = useState(price);
  const [c, setC] = useState(cost);
  const [f, setF] = useState(fixed);

  const contribution = p - c;
  const beVolume = contribution > 0 ? f / contribution : Infinity;
  const marginPct = p > 0 ? (contribution / p) * 100 : 0;
  const markupPct = c > 0 ? (contribution / c) * 100 : 0;

  const W = 420;
  const H = 150;
  const padB = 24;
  const qMax = isFinite(beVolume) ? beVolume * 2 : 100;
  const yMax = Math.max(p * qMax, f + c * qMax, 1);
  const x = (q: number) => (q / qMax) * W;
  const y = (v: number) => H - padB - (v / yMax) * (H - padB - 10);

  return (
    <VizFrame
      title="Break-even, margin and markup"
      caption="Revenue climbs from zero, total cost starts at the fixed cost. Where they cross is break-even. Drag the price and watch how fast that point moves."
      onReset={() => {
        setP(price);
        setC(cost);
        setF(fixed);
      }}
      controls={
        <>
          <Slider label="Price (p)" value={p} min={Math.max(cost + 0.05, 0.05)} max={Math.max(price * 4, cost * 3)} step={0.05} unit={currency} onChange={setP} />
          <Slider label="Unit cost (c)" value={c} min={0.05} max={Math.max(price - 0.05, 0.1)} step={0.05} unit={currency} onChange={setC} />
          <Slider label="Fixed cost (F)" value={f} min={0} max={Math.max(500, fixed * 5)} step={5} unit={currency} onChange={setF} />
        </>
      }
    >
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full" role="img"
        aria-label={`Break-even at ${fmt(beVolume, 0)} ${unit}`}>
        <line x1="0" y1={H - padB} x2={W} y2={H - padB} className="stroke-line" strokeWidth="1" />
        <path d={`M 0,${y(f)} L ${W},${y(f + c * qMax)}`} className="stroke-bad" strokeWidth="2" strokeDasharray="5 3" fill="none" />
        <path d={`M 0,${y(0)} L ${W},${y(p * qMax)}`} className="stroke-good" strokeWidth="2" fill="none" />
        {isFinite(beVolume) && (
          <>
            <circle cx={x(beVolume)} cy={y(p * beVolume)} r="4.5" className="fill-accent" />
            <line x1={x(beVolume)} y1={y(p * beVolume)} x2={x(beVolume)} y2={H - padB}
              className="stroke-accent" strokeWidth="1.5" strokeDasharray="3 3" />
            <text x={x(beVolume)} y={H - padB + 13} textAnchor="middle" className="fill-accent text-[10px] font-bold">
              {fmt(beVolume, 0)} {unit}
            </text>
          </>
        )}
        <text x={W - 4} y="14" textAnchor="end" className="fill-good text-[9px] font-semibold">revenue</text>
        <text x={W - 4} y={H - padB - 6} textAnchor="end" className="fill-bad text-[9px] font-semibold">total cost</text>
      </svg>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat label="Unit contribution" value={`${currency}${fmt(contribution, 2)}`} tone="accent" hint="p − c" />
        <Stat label="Break-even volume" value={fmt(beVolume, 0)} unit={unit} tone="good" hint="Fixed cost ÷ contribution" />
        <Stat label="Margin / markup" value={`${fmt(marginPct, 0)}% / ${fmt(markupPct, 0)}%`}
          hint="Margin ÷ price, markup ÷ cost" />
      </div>
    </VizFrame>
  );
}
