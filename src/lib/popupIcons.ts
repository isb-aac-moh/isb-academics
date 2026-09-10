import { Brain, Megaphone, Sparkles, Rocket, Bell, GraduationCap, Star, Info, PartyPopper, CheckCircle2 } from "lucide-react";

// Curated subset of lucide-react icons admins can pick from when adding a dashboard
// popup — keeps the picker a simple dropdown instead of the full icon library.
export const POPUP_ICONS = {
  Brain, Megaphone, Sparkles, Rocket, Bell, GraduationCap, Star, Info, PartyPopper, CheckCircle2,
} as const;

export type PopupIconKey = keyof typeof POPUP_ICONS;
