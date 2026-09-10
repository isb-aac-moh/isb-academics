import { useLocation, useNavigate } from "react-router-dom";
import { Brain, GraduationCap, ListChecks, Activity, BookOpen } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";

const ITEMS = [
  { icon: Brain, label: "Learn", prefix: "/learn", to: "/learn" },
  { icon: GraduationCap, label: "Tracker", prefix: "/tracker", to: "/tracker" },
  { icon: ListChecks, label: "Planner", prefix: "/planner", to: "/planner/background" },
  { icon: Activity, label: "Pulse", prefix: "/pulse-check", to: "/pulse-check" },
  { icon: BookOpen, label: "Resources", prefix: "/resources", to: "/resources" },
] as const;

/**
 * App-wide mobile bottom tab bar, mirroring the desktop sidebar's primary nav. Hidden on
 * /learn/*, which already renders its own bottom nav with different destinations
 * (see learn/components/MobileNav.tsx) — two bars would fight for the same strip.
 */
export default function BottomNav() {
  const location = useLocation();
  const navigate = useNavigate();

  if (location.pathname.startsWith("/learn")) return null;

  const isActive = (prefix: string) => location.pathname === prefix || location.pathname.startsWith(prefix + "/");

  return (
    <nav
      aria-label="Main"
      className="md:hidden fixed bottom-0 inset-x-0 z-40"
      style={{
        background: "rgba(255,255,255,0.97)",
        borderTop: `1px solid ${COLOR.border}`,
        paddingBottom: "env(safe-area-inset-bottom)",
        boxShadow: "0 -4px 20px -8px rgba(30,46,122,0.2)",
      }}
    >
      <ul className="flex items-stretch" style={{ margin: 0, padding: 0, listStyle: "none" }}>
        {ITEMS.map((item) => {
          const active = isActive(item.prefix);
          return (
            <li key={item.prefix} style={{ flex: 1 }}>
              <button
                onClick={() => navigate(item.to)}
                aria-current={active ? "page" : undefined}
                className="w-full flex flex-col items-center justify-center gap-0.5"
                style={{
                  minHeight: "3.25rem", padding: "6px 2px", background: "none", border: "none", cursor: "pointer",
                  color: active ? COLOR.navyHero : COLOR.ink3,
                }}
              >
                <item.icon size={20} />
                <span style={{ fontSize: 10, fontFamily: FONT.sans, fontWeight: 700, lineHeight: 1.1 }}>{item.label}</span>
              </button>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
