import type { ReactNode } from "react";

/** Abramowitz & Stegun 7.1.26 — plenty accurate for reading defect rates off a curve. */
export function erf(x: number): number {
  const sign = x < 0 ? -1 : 1;
  const a = Math.abs(x);
  const t = 1 / (1 + 0.3275911 * a);
  const y =
    1 -
    ((((1.061405429 * t - 1.453152027) * t + 1.421413741) * t - 0.284496736) * t + 0.254829592) *
      t *
      Math.exp(-a * a);
  return sign * y;
}

export function normalCdf(x: number, mean: number, sd: number): number {
  if (sd <= 0) return x < mean ? 0 : 1;
  return 0.5 * (1 + erf((x - mean) / (sd * Math.SQRT2)));
}

export function normalPdf(x: number, mean: number, sd: number): number {
  if (sd <= 0) return 0;
  const z = (x - mean) / sd;
  return Math.exp(-0.5 * z * z) / (sd * Math.sqrt(2 * Math.PI));
}

/** Inverse standard normal (Acklam's rational approximation), for z-values from a service level. */
export function normalInv(p: number): number {
  if (p <= 0) return -Infinity;
  if (p >= 1) return Infinity;
  const a = [-3.969683028665376e1, 2.209460984245205e2, -2.759285104469687e2, 1.38357751867269e2, -3.066479806614716e1, 2.506628277459239];
  const b = [-5.447609879822406e1, 1.615858368580409e2, -1.556989798598866e2, 6.680131188771972e1, -1.328068155288572e1];
  const c = [-7.784894002430293e-3, -3.223964580411365e-1, -2.400758277161838, -2.549732539343734, 4.374664141464968, 2.938163982698783];
  const d = [7.784695709041462e-3, 3.224671290700398e-1, 2.445134137142996, 3.754408661907416];
  const pLow = 0.02425;
  let q: number, r: number;
  if (p < pLow) {
    q = Math.sqrt(-2 * Math.log(p));
    return (((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) / ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1);
  }
  if (p <= 1 - pLow) {
    q = p - 0.5;
    r = q * q;
    return ((((((a[0] * r + a[1]) * r + a[2]) * r + a[3]) * r + a[4]) * r + a[5]) * q) / (((((b[0] * r + b[1]) * r + b[2]) * r + b[3]) * r + b[4]) * r + 1);
  }
  q = Math.sqrt(-2 * Math.log(1 - p));
  return -(((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) / ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1);
}

export function fmt(n: number, digits = 2): string {
  if (!isFinite(n)) return "—";
  const r = Number(n.toFixed(digits));
  return r.toLocaleString(undefined, { maximumFractionDigits: digits });
}

interface SliderProps {
  label: string;
  value: number;
  min: number;
  max: number;
  step?: number;
  unit?: string;
  onChange: (v: number) => void;
}

export function Slider({ label, value, min, max, step = 1, unit, onChange }: SliderProps) {
  return (
    <label className="block">
      <span className="flex items-baseline justify-between gap-2 mb-1">
        <span className="text-xs font-medium text-ink-soft">{label}</span>
        <span className="text-sm font-bold tabular text-ink">
          {fmt(value)}
          {unit ? <span className="text-ink-soft font-medium"> {unit}</span> : null}
        </span>
      </span>
      <input
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={(e) => onChange(Number(e.target.value))}
        className="viz-slider"
      />
    </label>
  );
}

export function Stat({
  label,
  value,
  unit,
  tone = "ink",
  hint,
}: {
  label: string;
  value: string;
  unit?: string;
  tone?: "ink" | "good" | "bad" | "accent";
  hint?: string;
}) {
  const toneClass = { ink: "text-ink", good: "text-good", bad: "text-bad", accent: "text-accent" }[tone];
  return (
    <div className="bg-surface-2 rounded-xl px-3 py-2.5">
      <div className="text-[10px] uppercase tracking-wide text-ink-soft font-bold mb-0.5">{label}</div>
      <div className={`text-xl font-bold tabular leading-tight ${toneClass}`}>
        {value}
        {unit ? <span className="text-sm font-semibold text-ink-soft"> {unit}</span> : null}
      </div>
      {hint ? <div className="text-[11px] text-ink-soft mt-0.5 leading-snug">{hint}</div> : null}
    </div>
  );
}

/**
 * Shared chrome so every embedded widget reads as the same kind of object on the page: a thing you
 * are invited to touch, visually distinct from the prose around it without shouting over it. The
 * controls sit on a tinted footer so the "inputs" and the "reading" halves stay legible as separate
 * jobs even at a glance.
 */
export function VizFrame({
  title,
  caption,
  children,
  controls,
  onReset,
}: {
  title: string;
  caption?: string;
  children: ReactNode;
  controls?: ReactNode;
  /** Restores the widget to the worked example it started from. */
  onReset?: () => void;
}) {
  return (
    <figure
      className="not-prose my-7 rounded-2xl overflow-hidden bg-surface ring-1 ring-line
        shadow-[0_1px_2px_rgba(46,59,66,0.04),0_12px_28px_-18px_rgba(46,59,66,0.28)]"
    >
      <figcaption className="px-5 pt-4 pb-3 bg-gradient-to-b from-accent/[0.045] to-transparent">
        <div className="flex items-center gap-2.5">
          <span
            className="inline-flex items-center gap-1 text-[10px] font-bold uppercase tracking-[0.08em]
              text-accent bg-accent/10 rounded-full pl-1.5 pr-2 py-0.5"
          >
            <span className="w-1.5 h-1.5 rounded-full bg-accent" aria-hidden="true" />
            Try it
          </span>
          <span className="font-semibold text-[0.9375rem] text-ink tracking-[-0.01em] min-w-0 flex-1">
            {title}
          </span>
          {onReset && (
            <button
              onClick={onReset}
              className="shrink-0 text-[11px] font-semibold text-ink-soft hover:text-accent
                border border-line hover:border-accent/40 rounded-full px-2.5 py-1 transition-colors"
            >
              Reset
            </button>
          )}
        </div>
        {caption ? (
          <p className="text-[0.8125rem] text-ink-soft mt-2 leading-[1.6] max-w-[62ch]">{caption}</p>
        ) : null}
      </figcaption>
      <div className="px-5 pb-5">{children}</div>
      {controls ? (
        <div className="px-5 py-4 grid gap-x-6 gap-y-3.5 sm:grid-cols-2 border-t border-line bg-surface-2/40">
          {controls}
        </div>
      ) : null}
    </figure>
  );
}
