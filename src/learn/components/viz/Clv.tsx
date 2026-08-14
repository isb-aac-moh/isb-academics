import { useState } from "react";
import { fmt, Slider, Stat, VizFrame } from "./util";

interface Props {
  margin?: number;
  retention?: number;
  discount?: number;
  acquisition?: number;
  currency?: string;
}

/**
 * CLV drawn as the stream it actually is. The closed-form m·[r/(1+d−r)] is easy to memorise and
 * hard to feel; watching the bars shrink as retention drops is what makes it obvious why a few
 * points of churn are worth more than a big acquisition discount.
 */
export function Clv({ margin = 250, retention = 0.8, discount = 0.1, acquisition = 400, currency = "$" }: Props) {
  const [m, setM] = useState(margin);
  const [r, setR] = useState(retention);
  const [d, setD] = useState(discount);
  const [ac, setAc] = useState(acquisition);

  const perpetuity = m * (r / (1 + d - r));
  const net = perpetuity - ac;

  const YEARS = 10;
  const bars = Array.from({ length: YEARS }, (_, t) => (m * Math.pow(r, t + 1)) / Math.pow(1 + d, t + 1));
  const maxBar = Math.max(...bars, 1);

  return (
    <VizFrame
      title="Customer lifetime value"
      caption="Each bar is one year's expected contribution, shrunk by the odds the customer is still around and by the time value of money. CLV is the whole stack, minus what you paid to acquire them."
      onReset={() => {
        setM(margin);
        setR(retention);
        setD(discount);
        setAc(acquisition);
      }}
      controls={
        <>
          <Slider label="Annual margin (m)" value={m} min={10} max={1000} step={10} unit={currency} onChange={setM} />
          <Slider label="Retention rate (r)" value={r} min={0.3} max={0.98} step={0.01} onChange={setR} />
          <Slider label="Discount rate (d)" value={d} min={0} max={0.3} step={0.01} onChange={setD} />
          <Slider label="Acquisition cost (AC)" value={ac} min={0} max={2000} step={25} unit={currency} onChange={setAc} />
        </>
      }
    >
      <div className="flex items-end gap-1 h-28 mb-1">
        {bars.map((v, i) => (
          <div key={i} className="flex-1 flex flex-col items-center justify-end h-full">
            <div
              className="w-full rounded-t bg-accent/40 border-t-2 border-accent transition-all duration-200"
              style={{ height: `${Math.max((v / maxBar) * 100, 2)}%` }}
              title={`Year ${i + 1}: ${currency}${fmt(v, 0)}`}
            />
          </div>
        ))}
      </div>
      <div className="flex justify-between text-[10px] text-ink-soft mb-3">
        <span>Year 1</span>
        <span>Year {YEARS}</span>
      </div>

      <div className="grid gap-2 sm:grid-cols-3">
        <Stat label="CLV of an existing customer" value={`${currency}${fmt(perpetuity, 0)}`} tone="accent"
          hint="m × [r ÷ (1 + d − r)]" />
        <Stat label="CLV net of acquisition" value={`${currency}${fmt(net, 0)}`} tone={net > 0 ? "good" : "bad"}
          hint={net > 0 ? "Worth acquiring" : "You lose money on this customer"} />
        <Stat label="Value of +5pp retention" value={`${currency}${fmt(m * (Math.min(r + 0.05, 0.99) / (1 + d - Math.min(r + 0.05, 0.99))) - perpetuity, 0)}`}
          tone="good" hint="Why churn work beats discounting" />
      </div>
    </VizFrame>
  );
}
