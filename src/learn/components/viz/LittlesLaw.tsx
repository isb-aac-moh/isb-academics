import { useState } from "react";
import { fmt, Slider, Stat, VizFrame } from "./util";

interface Props {
  rate?: number;
  time?: number;
  rateUnit?: string;
  timeUnit?: string;
  unitName?: string;
}

/**
 * I = R x T drawn as an actual rectangle, because that is what the law says: inventory is the
 * area under flow rate held for flow time. Students who only see the formula memorise it; students
 * who watch the box grow when they drag either edge stop needing to.
 */
export function LittlesLaw({
  rate = 20,
  time = 3,
  rateUnit = "per hour",
  timeUnit = "hours",
  unitName = "customers",
}: Props) {
  const [r, setR] = useState(rate);
  const [t, setT] = useState(time);
  const inventory = r * t;

  const W = 320;
  const H = 150;
  const maxR = 50;
  const maxT = 8;
  const boxW = (t / maxT) * (W - 60);
  const boxH = (r / maxR) * (H - 40);

  return (
    <VizFrame
      title="Little's Law: I = R × T"
      caption="Inventory is the area of the rectangle. Drag either edge and watch the third number follow — that is the whole law."
      onReset={() => {
        setR(rate);
        setT(time);
      }}
      controls={
        <>
          <Slider label="Flow rate (R)" value={r} min={1} max={maxR} unit={rateUnit} onChange={setR} />
          <Slider label="Flow time (T)" value={t} min={0.5} max={maxT} step={0.5} unit={timeUnit} onChange={setT} />
        </>
      }
    >
      <div className="grid gap-4 sm:grid-cols-[auto_1fr] sm:items-center">
        <svg viewBox={`0 0 ${W} ${H}`} className="w-full max-w-[340px] mx-auto" role="img"
          aria-label={`Rectangle ${fmt(t)} ${timeUnit} wide by ${fmt(r)} ${rateUnit} tall, area ${fmt(inventory)} ${unitName}`}>
          <line x1="40" y1={H - 24} x2={W - 8} y2={H - 24} className="stroke-line" strokeWidth="1" />
          <line x1="40" y1="8" x2="40" y2={H - 24} className="stroke-line" strokeWidth="1" />
          <rect
            x="40"
            y={H - 24 - boxH}
            width={boxW}
            height={boxH}
            className="fill-accent/20 stroke-accent transition-all duration-200"
            strokeWidth="2"
            rx="2"
          />
          <text x={40 + boxW / 2} y={H - 24 - boxH / 2} textAnchor="middle" dominantBaseline="middle"
            className="fill-ink text-[13px] font-bold">
            {fmt(inventory)}
          </text>
          <text x={40 + boxW / 2} y={H - 10} textAnchor="middle" className="fill-ink-soft text-[10px]">
            T = {fmt(t)} {timeUnit}
          </text>
          <text x="34" y={H - 24 - boxH / 2} textAnchor="end" dominantBaseline="middle"
            className="fill-ink-soft text-[10px]">
            R = {fmt(r)}
          </text>
        </svg>

        <div className="grid gap-2">
          <Stat
            label="Inventory (I)"
            value={fmt(inventory)}
            unit={unitName}
            tone="accent"
            hint={`${fmt(r)} ${rateUnit} × ${fmt(t)} ${timeUnit}`}
          />
          <Stat
            label="Flow time if you halve inventory"
            value={fmt(t / 2)}
            unit={timeUnit}
            hint="Same rate, half the WIP — the queue in front of you is the wait."
          />
        </div>
      </div>
    </VizFrame>
  );
}
