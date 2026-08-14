import { useState } from "react";
import { fmt, Slider, Stat, VizFrame } from "./util";

interface Props {
  serviceTime?: number;
  cva?: number;
  cvp?: number;
  servers?: number;
  unit?: string;
}

/**
 * The VUT curve. The lesson is not the algebra, it is the shape: waiting time is roughly linear
 * until utilisation gets high and then goes vertical. Seeing the wall is what stops people from
 * "just running the process at 95% to be efficient".
 */
export function Queuing({ serviceTime = 4, cva = 1, cvp = 1, servers = 1, unit = "min" }: Props) {
  const [rho, setRho] = useState(0.8);
  const [tp, setTp] = useState(serviceTime);
  const [ca, setCa] = useState(cva);
  const [m] = useState(servers);

  const vut = (u: number) =>
    ((ca * ca + cvp * cvp) / 2) * ((u ** (Math.sqrt(2 * (m + 1)) - 1)) / (m * (1 - u))) * tp;

  const wq = vut(rho);
  const flowTime = wq + tp;

  const W = 420;
  const H = 160;
  const padB = 26;
  const maxY = Math.max(vut(0.95), 1);
  const x = (u: number) => u * W;
  const y = (v: number) => H - padB - Math.min(v / maxY, 1) * (H - padB - 12);

  const pts: string[] = [];
  for (let i = 1; i <= 96; i++) {
    const u = i / 100;
    pts.push(`${x(u).toFixed(1)},${y(vut(u)).toFixed(1)}`);
  }

  return (
    <VizFrame
      title="Why the last 10% of utilisation costs the most"
      caption="Drag utilisation toward 100%. The queue does not grow steadily — it grows slowly, then vertically. That wall is why a busy process feels fine right up until it doesn't."
      onReset={() => {
        setRho(0.8);
        setTp(serviceTime);
        setCa(cva);
      }}
      controls={
        <>
          <Slider label="Utilisation (ρ)" value={rho} min={0.05} max={0.98} step={0.01} onChange={setRho} />
          <Slider label="Service time (Tp)" value={tp} min={0.5} max={20} step={0.5} unit={unit} onChange={setTp} />
          <Slider label="Arrival variability (CVa)" value={ca} min={0} max={2} step={0.1} onChange={setCa} />
        </>
      }
    >
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full" role="img"
        aria-label={`Waiting time curve against utilisation; at ${fmt(rho * 100, 0)} percent the wait is ${fmt(wq)} ${unit}`}>
        <line x1="0" y1={H - padB} x2={W} y2={H - padB} className="stroke-line" strokeWidth="1" />
        <path d={`M ${pts.join(" L ")}`} className="fill-none stroke-accent" strokeWidth="2" />

        <line x1={x(rho)} y1="8" x2={x(rho)} y2={H - padB} className="stroke-bad" strokeWidth="1.5" strokeDasharray="4 3" />
        <circle cx={x(rho)} cy={y(wq)} r="4.5" className="fill-bad" />
        <text x={x(rho) > W - 70 ? x(rho) - 6 : x(rho) + 6} y={Math.max(y(wq) - 8, 14)}
          textAnchor={x(rho) > W - 70 ? "end" : "start"} className="fill-bad text-[11px] font-bold">
          {fmt(wq)} {unit}
        </text>

        {[0.25, 0.5, 0.75, 1].map((u) => (
          <text key={u} x={x(u)} y={H - padB + 13} textAnchor={u === 1 ? "end" : "middle"}
            className="fill-ink-soft text-[10px]">
            {u * 100}%
          </text>
        ))}
      </svg>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat label="Time in queue (Wq)" value={fmt(wq)} unit={unit} tone={wq > tp * 2 ? "bad" : "good"}
          hint="Pure waiting, before service starts" />
        <Stat label="Total flow time (T)" value={fmt(flowTime)} unit={unit} tone="accent" hint="Wq + service time" />
        <Stat label="Cost of +5% load" value={fmt(vut(Math.min(rho + 0.05, 0.99)) - wq)} unit={unit}
          tone="bad" hint="Extra wait from a small demand bump" />
      </div>
    </VizFrame>
  );
}
