import { useState } from "react";
import { fmt, Slider, Stat, VizFrame } from "./util";

interface Props {
  reference?: number;
  extraBenefit?: number;
  extraCost?: number;
  unitCost?: number;
  currency?: string;
  period?: string;
}

/**
 * EVC as a stack, because that is how the formula is built: what the alternative costs, plus what
 * you add, minus what you take away. The bar makes the key point visible — EVC is the ceiling, not
 * the price, and the gap between the reference value and the ceiling is what gets split.
 */
export function Evc({
  reference = 1800,
  extraBenefit = 500,
  extraCost = 100,
  unitCost = 400,
  currency = "₹",
  period = "/month",
}: Props) {
  const [ref, setRef] = useState(reference);
  const [plus, setPlus] = useState(extraBenefit);
  const [minus, setMinus] = useState(extraCost);
  const [split, setSplit] = useState(0.5);

  const netDifferential = plus - minus;
  const evc = ref + netDifferential;
  const price = ref + netDifferential * split;
  const total = Math.max(evc, ref) * 1.1;
  const pct = (v: number) => `${(Math.max(v, 0) / total) * 100}%`;

  return (
    <VizFrame
      title="Economic value to the customer"
      caption="Start from what the next-best alternative costs them, add what you save them, subtract what you cost them. That total is the most they could rationally pay — the ceiling, not the price."
      onReset={() => {
        setRef(reference);
        setPlus(extraBenefit);
        setMinus(extraCost);
        setSplit(0.5);
      }}
      controls={
        <>
          <Slider label="Reference value (next-best alternative)" value={ref} min={100} max={5000} step={50} unit={currency} onChange={setRef} />
          <Slider label="Extra benefit you provide" value={plus} min={0} max={2000} step={25} unit={currency} onChange={setPlus} />
          <Slider label="Extra cost you impose" value={minus} min={0} max={1000} step={25} unit={currency} onChange={setMinus} />
          <Slider label="Share of extra value you keep" value={split} min={0} max={1} step={0.05} onChange={setSplit} />
        </>
      }
    >
      <div className="w-full h-14 rounded-lg overflow-hidden flex mb-2 border border-line">
        <div className="bg-accent/30 border-r border-accent/50 flex items-center justify-center min-w-0"
          style={{ width: pct(ref) }} title="Reference value">
          <span className="text-[10px] font-semibold text-ink truncate px-1">Reference {currency}{fmt(ref, 0)}</span>
        </div>
        {netDifferential > 0 && (
          <div className="bg-good/30 border-r border-good/60 flex items-center justify-center min-w-0"
            style={{ width: pct(netDifferential) }} title="Net differential value">
            <span className="text-[10px] font-semibold text-ink truncate px-1">+{fmt(netDifferential, 0)}</span>
          </div>
        )}
        {netDifferential < 0 && (
          <div className="bg-bad/30 border-r border-bad/60 flex items-center justify-center min-w-0"
            style={{ width: pct(-netDifferential) }} title="Net differential value is negative">
            <span className="text-[10px] font-semibold text-ink truncate px-1">{fmt(netDifferential, 0)}</span>
          </div>
        )}
      </div>
      <div className="text-[11px] text-ink-soft mb-3">
        Suggested price at a {fmt(split * 100, 0)}% split of the extra value:{" "}
        <strong className="text-ink">{currency}{fmt(price, 0)}{period}</strong>
      </div>

      <div className="grid gap-2 sm:grid-cols-3">
        <Stat label="Reference value" value={`${currency}${fmt(ref, 0)}`} hint="What the alternative costs them" />
        <Stat label="Net differential value" value={`${netDifferential >= 0 ? "+" : ""}${currency}${fmt(netDifferential, 0)}`}
          tone={netDifferential >= 0 ? "good" : "bad"} hint={`+${fmt(plus, 0)} benefit − ${fmt(minus, 0)} cost`} />
        <Stat label="Total EVC (price ceiling)" value={`${currency}${fmt(evc, 0)}`} tone="accent"
          hint={`Unit cost ${currency}${fmt(unitCost, 0)} is the floor`} />
      </div>
    </VizFrame>
  );
}
