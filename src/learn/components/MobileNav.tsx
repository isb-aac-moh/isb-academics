import { useLocation, useNavigate } from "react-router-dom";
import { HomeIcon, BookIcon, BoltIcon, UserIcon } from "./icons";

interface Props {
  onGoHome: () => void;
}

/**
 * Mobile-only bottom navigation. The desktop icon rail sits behind the Window, which is full-screen
 * at mobile widths — without this, opening any section trapped you there with no way back.
 *
 * Four fixed destinations, deliberately not one per course: a tab per subject stops fitting as soon
 * as a third course lands, so "Learn" is a subject picker instead. Admin lives on the Profile page
 * rather than in the bar, since it is one person's tab and would cost everyone else the space.
 */
export function MobileNav({ onGoHome }: Props) {
  const navigate = useNavigate();
  const path = useLocation().pathname;

  // Paths are all under /learn now that this is a section of the wider app rather than its own
  // application, so "home" is /learn itself and the subject picker moved to /learn/subjects
  // (plain /learn/learn would have read as a mistake).
  const items = [
    { key: "home", icon: HomeIcon, label: "Home", active: path === "/learn", onClick: onGoHome },
    {
      key: "learn",
      icon: BookIcon,
      label: "Learn",
      active: path.startsWith("/learn/subjects") || path.startsWith("/learn/sessions"),
      onClick: () => navigate("/learn/subjects"),
    },
    {
      key: "practice",
      icon: BoltIcon,
      label: "Practice",
      active: path.startsWith("/learn/practice"),
      onClick: () => navigate("/learn/practice"),
    },
    {
      key: "profile",
      icon: UserIcon,
      label: "You",
      active: path.startsWith("/learn/profile") || path.startsWith("/learn/admin"),
      onClick: () => navigate("/learn/profile"),
    },
  ];

  return (
    <nav
      aria-label="Main"
      className="md:hidden fixed bottom-0 inset-x-0 z-40 bg-surface/95 backdrop-blur-md border-t border-line
        pb-[env(safe-area-inset-bottom)] shadow-[0_-4px_20px_-8px_rgba(46,59,66,0.25)]"
    >
      <ul className="flex items-stretch">
        {items.map((item) => (
          <li key={item.key} className="flex-1">
            <button
              onClick={item.onClick}
              aria-current={item.active ? "page" : undefined}
              className={`w-full min-h-[3.25rem] flex flex-col items-center justify-center gap-0.5 py-1.5
                transition-colors active:bg-surface-2 ${item.active ? "text-accent" : "text-ink-soft"}`}
            >
              <item.icon className="w-[1.375rem] h-[1.375rem]" />
              <span className="text-[10px] font-semibold leading-tight">{item.label}</span>
            </button>
          </li>
        ))}
      </ul>
    </nav>
  );
}
