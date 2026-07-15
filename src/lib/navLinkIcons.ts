import {
  Bot, Link2, BookOpen, Megaphone, Star, Rocket, FileText, Globe, Calendar,
  GraduationCap, Briefcase, MessageSquare, Video, Newspaper, Trophy, Users, Bell, Compass,
} from "lucide-react";

// Curated subset of lucide-react icons admins can pick from when adding a nav
// link — keeps the picker a simple dropdown instead of the full icon library.
export const NAV_LINK_ICONS = {
  Bot, Link2, BookOpen, Megaphone, Star, Rocket, FileText, Globe, Calendar,
  GraduationCap, Briefcase, MessageSquare, Video, Newspaper, Trophy, Users, Bell, Compass,
} as const;

export type NavLinkIconKey = keyof typeof NAV_LINK_ICONS;
