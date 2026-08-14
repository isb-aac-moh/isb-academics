import { useEffect, useRef, useState } from "react";
import { usePrefersReducedMotion } from "./motion";

const DURATION_MS = 600;

function easeOutCubic(t: number): number {
  return 1 - Math.pow(1 - t, 3);
}

/** Animates a displayed number toward `value` whenever it changes, instead of jumping instantly. */
export function useCountUp(value: number): number {
  const reducedMotion = usePrefersReducedMotion();
  const [displayed, setDisplayed] = useState(value);
  const fromRef = useRef(value);
  const rafRef = useRef<number | undefined>(undefined);

  useEffect(() => {
    if (reducedMotion) {
      setDisplayed(value);
      return;
    }
    const from = fromRef.current;
    if (from === value) return;

    const start = performance.now();
    function tick(now: number) {
      const t = Math.min(1, (now - start) / DURATION_MS);
      const eased = easeOutCubic(t);
      setDisplayed(Math.round(from + (value - from) * eased));
      if (t < 1) {
        rafRef.current = requestAnimationFrame(tick);
      } else {
        fromRef.current = value;
      }
    }
    rafRef.current = requestAnimationFrame(tick);
    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [value, reducedMotion]);

  return displayed;
}
