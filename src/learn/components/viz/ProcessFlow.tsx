import { useState } from "react";
import { fmt, Slider, Stat, VizFrame } from "./util";

interface Props {
  /** "Mix:12,Bake:8,Decorate:15" — name:capacity per station, in flow order. */
  stations?: string;
  demand?: number;
  unit?: string;
}

function parseStations(spec: string): { name: string; cap: number }[] {
  return spec
    .split(",")
    .map((s) => {
      const [name, cap] = s.split(":");
      return { name: (name ?? "").trim(), cap: Number(cap) };
    })
    .filter((s) => s.name && isFinite(s.cap) && s.cap > 0);
}

/**
 * The bottleneck picture. Capacity of the line is the capacity of its worst station — not the
 * average, not the sum. Speeding up a non-bottleneck changes nothing, and the bar chart makes that
 * obvious in a way the sentence never does.
 */
export function ProcessFlow({ stations = "Mix:12,Bake:8,Decorate:15", demand = 10, unit = "/hr" }: Props) {
  const initial = parseStations(stations);
  const [caps, setCaps] = useState<number[]>(initial.map((s) => s.cap));
  const [d, setD] = useState(demand);

  const names = initial.map((s) => s.name);
  const capacity = caps.length ? Math.min(...caps) : 0;
  const bottleneck = caps.indexOf(capacity);
  const flowRate = Math.min(d, capacity);
  const maxCap = Math.max(...caps, d, 1);

  return (
    <VizFrame
      title="Find the bottleneck"
      caption="The whole line runs at the speed of its slowest station. Try speeding up a station that isn't the bottleneck — the flow rate won't move."
      onReset={() => {
        setCaps(initial.map((s) => s.cap));
        setD(demand);
      }}
      controls={
        <>
          {names.map((name, i) => (
            <Slider
              key={name}
              label={name}
              value={caps[i]}
              min={1}
              max={30}
              unit={unit}
              onChange={(v) => setCaps((prev) => prev.map((c, j) => (j === i ? v : c)))}
            />
          ))}
          <Slider label="Demand" value={d} min={1} max={30} unit={unit} onChange={setD} />
        </>
      }
    >
      <div className="flex items-end gap-2 sm:gap-3">
        {names.map((name, i) => {
          const isBottleneck = i === bottleneck;
          const h = (caps[i] / maxCap) * 100;
          return (
            <div key={name} className="flex-1 flex flex-col items-center gap-1.5 min-w-0">
              <span className={`text-sm font-bold tabular ${isBottleneck ? "text-bad" : "text-ink"}`}>
                {fmt(caps[i], 0)}
              </span>
              <div className="w-full h-24 flex items-end">
                <div
                  className={`w-full rounded-t-lg transition-all duration-200 ${
                    isBottleneck ? "bg-bad/70 border-2 border-bad" : "bg-accent/30 border-2 border-accent/40"
                  }`}
                  style={{ height: `${Math.max(h, 4)}%` }}
                />
              </div>
              <span className="text-[11px] text-ink-soft text-center truncate w-full" title={name}>
                {name}
              </span>
              {isBottleneck && (
                <span className="text-[9px] font-bold uppercase tracking-wide text-bad">Bottleneck</span>
              )}
            </div>
          );
        })}
      </div>

      <div className="grid gap-2 sm:grid-cols-3 mt-4">
        <Stat label="Process capacity" value={fmt(capacity, 1)} unit={unit} tone="bad"
          hint={`Set by ${names[bottleneck] ?? "—"}`} />
        <Stat label="Flow rate" value={fmt(flowRate, 1)} unit={unit} tone="accent"
          hint={d > capacity ? "Capacity-constrained" : "Demand-constrained"} />
        <Stat label="Bottleneck utilisation" value={fmt(Math.min(d / capacity, 1) * 100, 0)} unit="%"
          tone={d >= capacity ? "bad" : "good"} hint={`Implied ${fmt((d / capacity) * 100, 0)}%`} />
      </div>
    </VizFrame>
  );
}
