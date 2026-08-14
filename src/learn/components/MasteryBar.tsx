import type { MasteryLevel } from "../types";
import { LEVEL_NAMES } from "../lib/mastery";

const SEGMENTS = 4;

const FILL_CLASS: Record<MasteryLevel, string> = {
  0: "bg-surface-2",
  1: "bg-bad",
  2: "bg-highlight",
  3: "bg-good",
  4: "bg-good",
};

interface Props {
  label?: string;
  level: MasteryLevel;
  showName?: boolean;
}

/** Four discrete rungs rather than a continuous bar — a student can name where they are, which a
    percentage does not give them. */
export function MasteryBar({ label, level, showName = true }: Props) {
  return (
    <div className="text-left">
      {label && (
        <div className="flex justify-between text-xs text-ink-soft mb-1">
          <span>{label.replace(/_/g, " ")}</span>
        </div>
      )}
      <div className="flex items-center gap-2">
        <div className="flex gap-0.5 flex-1 min-w-0">
          {Array.from({ length: SEGMENTS }, (_, i) => (
            <span
              key={i}
              className={`h-1.5 flex-1 rounded-full transition-colors duration-500 ${
                i < level ? FILL_CLASS[level] : "bg-surface-2"
              }`}
            />
          ))}
        </div>
        {showName && (
          <span className="text-[10px] font-semibold uppercase tracking-wide text-ink-soft shrink-0">
            {LEVEL_NAMES[level]}
          </span>
        )}
      </div>
    </div>
  );
}
