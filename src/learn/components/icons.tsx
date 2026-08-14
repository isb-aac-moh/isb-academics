interface IconProps {
  className?: string;
}

const common = {
  width: 20,
  height: 20,
  viewBox: "0 0 24 24",
  fill: "none",
  stroke: "currentColor",
  strokeWidth: 1.75,
  strokeLinecap: "round" as const,
  strokeLinejoin: "round" as const,
};

/** Filled/weighted desktop icons — used on the Home icon-grid and in Window headers.
    Solid currentColor fill (not outline) so they read as substantial at small sizes,
    matching PostHog's filled icon treatment rather than thin line icons. */
const filled = { width: 22, height: 22, viewBox: "0 0 24 24", fill: "currentColor" };

export function HomeIcon({ className }: IconProps) {
  return (
    <svg {...filled} className={className}>
      <path d="M12 3.2 2.5 11h2.3v8.5A1.2 1.2 0 0 0 6 20.7h3.3a1.2 1.2 0 0 0 1.2-1.2v-4.3a1.5 1.5 0 0 1 1.5-1.5 1.5 1.5 0 0 1 1.5 1.5v4.3a1.2 1.2 0 0 0 1.2 1.2H18a1.2 1.2 0 0 0 1.2-1.2V11h2.3z" />
    </svg>
  );
}

export function BookIcon({ className }: IconProps) {
  return (
    <svg {...filled} className={className}>
      <path d="M5.5 3A2.5 2.5 0 0 0 3 5.5v13A2.5 2.5 0 0 1 5.5 16H20V3z" />
      <path d="M5.5 18a1.5 1.5 0 0 0 0 3H20v-3z" opacity="0.55" />
    </svg>
  );
}

export function BoltIcon({ className }: IconProps) {
  return (
    <svg {...filled} className={className}>
      <path d="M13 2 4 14.5h6l-1.5 7.5L20 9.5h-6.5z" />
    </svg>
  );
}

export function UserIcon({ className }: IconProps) {
  return (
    <svg {...filled} className={className}>
      <circle cx="12" cy="7.8" r="4" />
      <path d="M3.8 20.2C5.1 16 8.2 13.8 12 13.8s6.9 2.2 8.2 6.4a1 1 0 0 1-.95 1.3H4.75a1 1 0 0 1-.95-1.3z" />
    </svg>
  );
}

export function ShieldIcon({ className }: IconProps) {
  return (
    <svg {...filled} className={className}>
      <path d="M12 2.5 4.5 5.5V11c0 5 3.1 8.6 7.5 10 4.4-1.4 7.5-5 7.5-10V5.5z" />
      <path
        d="m8.7 12.1 2.1 2.1 4.3-4.5"
        fill="none"
        stroke="var(--c-accent-ink)"
        strokeWidth="1.6"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export function CloseIcon({ className }: IconProps) {
  return (
    <svg {...common} strokeWidth="2" className={className}>
      <path d="M6 6l12 12M18 6 6 18" />
    </svg>
  );
}

export function CheckIcon({ className }: IconProps) {
  return (
    <svg {...common} strokeWidth="2.5" className={className}>
      <path d="M4 12.5 9.5 18 20 6" />
    </svg>
  );
}

export function SearchIcon({ className }: IconProps) {
  return (
    <svg {...common} className={className}>
      <circle cx="10.5" cy="10.5" r="6.5" />
      <path d="m20 20-4.3-4.3" />
    </svg>
  );
}

export function LogOutIcon({ className }: IconProps) {
  return (
    <svg {...common} className={className}>
      <path d="M9 20H5.5A1.5 1.5 0 0 1 4 18.5v-13A1.5 1.5 0 0 1 5.5 4H9" />
      <path d="M15.5 16 20 12l-4.5-4" />
      <path d="M20 12H9" />
    </svg>
  );
}

export function ChevronRightIcon({ className }: IconProps) {
  return (
    <svg {...common} className={className}>
      <path d="m9 6 6 6-6 6" />
    </svg>
  );
}
