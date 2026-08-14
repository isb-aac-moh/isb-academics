import { useEffect, useState } from "react";
import type { CSSProperties } from "react";
import { usePrefersReducedMotion } from "../lib/motion";

const COLORS = ["var(--c-accent)", "var(--c-good)", "#d9a441", "var(--c-ink-soft)"];

interface Particle {
  id: number;
  left: number;
  top: number;
  color: string;
  dx: number;
  dy: number;
  rot: number;
  delay: number;
  size: number;
}

function makeParticles(count: number): Particle[] {
  return Array.from({ length: count }, (_, i) => ({
    id: i,
    left: 10 + Math.random() * 80,
    top: 15 + Math.random() * 20,
    color: COLORS[i % COLORS.length],
    dx: (Math.random() - 0.5) * 260,
    dy: 160 + Math.random() * 260,
    rot: 180 + Math.random() * 540,
    delay: Math.random() * 150,
    size: 6 + Math.random() * 6,
  }));
}

/** Fires a burst of particles whenever `trigger` changes (increment a counter to fire again). Silent under reduced-motion. */
export function Confetti({ trigger, count = 26 }: { trigger: number; count?: number }) {
  const reducedMotion = usePrefersReducedMotion();
  const [particles, setParticles] = useState<Particle[]>([]);

  useEffect(() => {
    if (trigger === 0 || reducedMotion) return;
    setParticles(makeParticles(count));
    const t = setTimeout(() => setParticles([]), 1300);
    return () => clearTimeout(t);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trigger, reducedMotion]);

  if (particles.length === 0) return null;

  return (
    <div className="fixed inset-0 pointer-events-none z-[9999] overflow-hidden" aria-hidden="true">
      {particles.map((p) => (
        <div
          key={p.id}
          style={
            {
              position: "absolute",
              left: `${p.left}%`,
              top: `${p.top}%`,
              width: p.size,
              height: p.size * 0.4,
              background: p.color,
              borderRadius: 1,
              animation: `confetti-fall 1.1s cubic-bezier(0.2,0.7,0.3,1) ${p.delay}ms forwards`,
              "--dx": `${p.dx}px`,
              "--dy": `${p.dy}px`,
              "--rot": `${p.rot}deg`,
            } as CSSProperties
          }
        />
      ))}
    </div>
  );
}
