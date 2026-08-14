import { useState } from "react";
import type { Scenario } from "../types";
import { Markdown } from "./Markdown";

interface Props {
  scenario: Scenario;
  part: number;
  total: number;
  /** The previous answer in this chain, so the student can see which change moved the number. */
  previousAnswer: string | null;
}

/** Collapsed to a couple of lines by default so it does not eat a phone screen, but always
    reachable — the setup is shared across the whole chain and gets referred back to. */
export function ScenarioSetup({ scenario, part, total, previousAnswer }: Props) {
  const [open, setOpen] = useState(false);

  return (
    <div className="w-full bg-surface border border-line rounded-xl px-4 py-3 mb-3">
      <div className="flex items-center justify-between gap-3 mb-1">
        <span className="font-semibold text-sm">{scenario.title}</span>
        <span className="text-[10px] font-bold uppercase tracking-wide bg-accent text-white rounded-full px-2 py-0.5 shrink-0">
          Part {part} of {total}
        </span>
      </div>

      <div className={open ? "" : "line-clamp-2"}>
        <Markdown text={scenario.setup} className="text-sm text-ink-soft leading-relaxed" />
      </div>

      <button
        onClick={() => setOpen((v) => !v)}
        className="text-xs text-accent font-semibold mt-1 hover:underline"
      >
        {open ? "Hide setup" : "Show full setup"}
      </button>

      {previousAnswer && (
        <p className="text-xs text-ink-soft mt-2 pt-2 border-t border-line">
          ↑ Previously: <span className="font-medium text-ink">{previousAnswer}</span>
        </p>
      )}
    </div>
  );
}
