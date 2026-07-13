/**
 * Shared visual tokens — matches isb-explorer's Pulse design system
 * (Playfair Display + Plus Jakarta Sans, ISB navy/amber) until real
 * ISB brand assets replace these.
 */

export const COLOR = {
  bg: "#FAFAFA",
  bgSoft: "#F5F5F3",
  surface: "#FFFFFF",
  border: "#E5E5E3",
  borderLight: "#F0F0EE",

  navy: "#1C3A6E",
  navyDeep: "#122850",
  navyTint: "#EEF2FA",

  amber: "#C47D0E",
  amberTint: "#FDF4E0",

  ink: "#111111",
  ink2: "#555555",
  ink3: "#999999",

  green: "#059669",
  greenTint: "#ECFDF5",
  red: "#DC2626",
  redTint: "#FEF2F2",

  // ISB Tutor Portal reference — deep navy hero + mint accent
  navyHero: "#1E2E7A",
  mint: "#8FE8D8",
} as const;

export const FONT = {
  serif: "'Playfair Display', Georgia, serif",
  sans: "'Plus Jakarta Sans', system-ui, sans-serif",
} as const;
