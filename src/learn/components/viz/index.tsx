import type { ComponentType } from "react";
import { BreakEven } from "./BreakEven";
import { Capability } from "./Capability";
import { Clv } from "./Clv";
import { ControlLimitWidth } from "./ControlLimitWidth";
import { Eoq } from "./Eoq";
import { Evc } from "./Evc";
import { LittlesLaw } from "./LittlesLaw";
import { Newsvendor } from "./Newsvendor";
import { ProcessFlow } from "./ProcessFlow";
import { Queuing } from "./Queuing";
import { SixSigmaDrift } from "./SixSigmaDrift";

/* eslint-disable @typescript-eslint/no-explicit-any */
export const VIZ: Record<string, ComponentType<any>> = {
  // Operations
  "littles-law": LittlesLaw,
  capability: Capability,
  queuing: Queuing,
  newsvendor: Newsvendor,
  eoq: Eoq,
  "process-flow": ProcessFlow,
  "control-limit-width": ControlLimitWidth,
  "six-sigma-drift": SixSigmaDrift,
  // Marketing
  clv: Clv,
  evc: Evc,
  "break-even": BreakEven,
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
