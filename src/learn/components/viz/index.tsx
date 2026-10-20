import type { ComponentType } from "react";
import { lazyWithReload } from "../../../lib/lazyWithReload";

/* Each widget is its own chunk. A note embeds at most one or two of these, and most notes embed
   none, so pulling all thirteen (plus their SVG/plot helpers) into the Learn bundle made every
   reader pay for widgets they never scroll past. Markdown renders them inside a Suspense
   boundary, so the surrounding note paints immediately and the widget fills in. Like the routes,
   each goes through lazyWithReload so a tab left open across a deploy recovers its stale chunk. */

/* eslint-disable @typescript-eslint/no-explicit-any */
export const VIZ: Record<string, ComponentType<any>> = {
  // Operations
  "littles-law": lazyWithReload(() => import("./LittlesLaw").then((m) => ({ default: m.LittlesLaw }))),
  capability: lazyWithReload(() => import("./Capability").then((m) => ({ default: m.Capability }))),
  queuing: lazyWithReload(() => import("./Queuing").then((m) => ({ default: m.Queuing }))),
  newsvendor: lazyWithReload(() => import("./Newsvendor").then((m) => ({ default: m.Newsvendor }))),
  eoq: lazyWithReload(() => import("./Eoq").then((m) => ({ default: m.Eoq }))),
  "process-flow": lazyWithReload(() => import("./ProcessFlow").then((m) => ({ default: m.ProcessFlow }))),
  "control-limit-width": lazyWithReload(() => import("./ControlLimitWidth").then((m) => ({ default: m.ControlLimitWidth }))),
  "six-sigma-drift": lazyWithReload(() => import("./SixSigmaDrift").then((m) => ({ default: m.SixSigmaDrift }))),
  "kanban-loop": lazyWithReload(() => import("./KanbanLoop").then((m) => ({ default: m.KanbanLoop }))),
  "safety-stock": lazyWithReload(() => import("./SafetyStock").then((m) => ({ default: m.SafetyStock }))),
  // Marketing
  clv: lazyWithReload(() => import("./Clv").then((m) => ({ default: m.Clv }))),
  evc: lazyWithReload(() => import("./Evc").then((m) => ({ default: m.Evc }))),
  "break-even": lazyWithReload(() => import("./BreakEven").then((m) => ({ default: m.BreakEven }))),
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
