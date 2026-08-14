interface Props {
  streak: number;
  className?: string;
}

/** Small flame glyph that grows and pulses faster the longer the streak runs. Renders nothing below 3 days. */
export function StreakFlame({ streak, className = "" }: Props) {
  if (streak < 3) return null;

  const tier = streak >= 8 ? 2 : streak >= 5 ? 1 : 0;
  const size = [16, 19, 22][tier];
  const duration = [2.2, 1.7, 1.2][tier];

  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      className={className}
      style={{
        display: "inline-block",
        verticalAlign: "-3px",
        animation: `streak-pulse ${duration}s ease-in-out infinite`,
      }}
      aria-hidden="true"
    >
      <path
        d="M12 2c0 3-2.5 4.5-2.5 7.5 0-1.3-1-2-1-2C7 9.5 6 11.5 6 13.5 6 17.6 8.7 21 12 21s6-3.4 6-7.5c0-3.3-2-5.7-3.2-7.1.1 1.4-.4 2.6-1.2 3.1C13.9 6.5 13 4.5 12 2z"
        fill="var(--c-accent)"
      />
      <path
        d="M12 12c.6 1-.2 1.8-.9 2.1-1 .4-1.6 1.4-1.1 2.5.4 1 1.6 1.6 2.7 1.2 1.6-.6 2.6-2.2 2.3-3.9-.2-1.1-1.4-2.7-3-1.9z"
        fill="var(--c-accent-ink)"
        opacity="0.85"
      />
    </svg>
  );
}
