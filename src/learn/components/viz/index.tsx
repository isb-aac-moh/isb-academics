import { lazy } from "react";
import type { ComponentType } from "react";

/* Each widget is its own chunk. A note embeds at most one or two of these, and most notes embed
   none, so pulling all thirteen (plus their SVG/plot helpers) into the Learn bundle made every
   reader pay for widgets they never scroll past. Markdown renders them inside a Suspense
   boundary, so the surrounding note paints immediately and the widget fills in. */

/* eslint-disable @typescript-eslint/no-explicit-any */
export const VIZ: Record<string, ComponentType<any>> = {
  // Operations
  "littles-law": lazy(() => import("./LittlesLaw").then((m) => ({ default: m.LittlesLaw }))),
  capability: lazy(() => import("./Capability").then((m) => ({ default: m.Capability }))),
  queuing: lazy(() => import("./Queuing").then((m) => ({ default: m.Queuing }))),
  newsvendor: lazy(() => import("./Newsvendor").then((m) => ({ default: m.Newsvendor }))),
  eoq: lazy(() => import("./Eoq").then((m) => ({ default: m.Eoq }))),
  "process-flow": lazy(() => import("./ProcessFlow").then((m) => ({ default: m.ProcessFlow }))),
  "control-limit-width": lazy(() => import("./ControlLimitWidth").then((m) => ({ default: m.ControlLimitWidth }))),
  "six-sigma-drift": lazy(() => import("./SixSigmaDrift").then((m) => ({ default: m.SixSigmaDrift }))),
  "kanban-loop": lazy(() => import("./KanbanLoop").then((m) => ({ default: m.KanbanLoop }))),
  "safety-stock": lazy(() => import("./SafetyStock").then((m) => ({ default: m.SafetyStock }))),
  // Marketing
  clv: lazy(() => import("./Clv").then((m) => ({ default: m.Clv }))),
  evc: lazy(() => import("./Evc").then((m) => ({ default: m.Evc }))),
  "break-even": lazy(() => import("./BreakEven").then((m) => ({ default: m.BreakEven }))),
};

export const VIZ_NAMES = Object.keys(VIZ);

/** `key=value` pairs, quoted when the value has spaces. Numbers are coerced so widgets get numbers. */
export function parseVizProps(rest: string): Record<string, string | number> {
  const props: Record<string, string | number> = {};
  const re = /(\w+)=(?:"([^"]*)"|'([^']*)'|(\S+))/g;
  let m: RegExpExecArray | null;
  while ((m = re.exec(rest)) !== null) {
    const raw = m[2] ?? m[3] ?? m[4] ?? "";
    const num = Number(raw);
    props[m[1]] = raw !== "" && isFinite(num) ? num : raw;
  }
  return props;
}
