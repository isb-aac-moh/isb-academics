import { useRef, useState } from "react";
import type { ReactNode } from "react";
import { usePrefersReducedMotion } from "../lib/motion";

const MAX_TILT_DEG = 7;

interface Props {
  onClick?: () => void;
  className?: string;
  style?: React.CSSProperties;
  children: ReactNode;
}

/** A button that tilts toward the cursor in 3D — the "playful card" feel, skipped entirely under reduced-motion. */
export function TiltCard({ onClick, className = "", style, children }: Props) {
  const ref = useRef<HTMLButtonElement>(null);
  const reducedMotion = usePrefersReducedMotion();
  const [tilt, setTilt] = useState({ x: 0, y: 0, lift: 0 });

  function handleMove(e: React.MouseEvent<HTMLButtonElement>) {
    if (reducedMotion || !ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    const px = (e.clientX - rect.left) / rect.width - 0.5;
    const py = (e.clientY - rect.top) / rect.height - 0.5;
    setTilt({ x: py * -MAX_TILT_DEG, y: px * MAX_TILT_DEG, lift: 2 });
  }

  function handleLeave() {
    setTilt({ x: 0, y: 0, lift: 0 });
  }

  return (
    <button
      ref={ref}
      onClick={onClick}
      onMouseMove={handleMove}
      onMouseLeave={handleLeave}
      className={className}
      style={{
        ...style,
        transform: `perspective(700px) translateY(${-tilt.lift}px) rotateX(${tilt.x}deg) rotateY(${tilt.y}deg)`,
        transition: "transform 150ms ease-out",
        transformStyle: "preserve-3d",
      }}
    >
      {children}
    </button>
  );
}
