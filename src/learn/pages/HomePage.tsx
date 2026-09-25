import { useEffect, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import type { Course, Student } from "../types";
import { fetchCourses } from "../lib/db";
import { REVISION_GUIDES } from "../lib/revisionGuides";
import { HomeIcon, BookIcon, BoltIcon, CompassIcon, FolderIcon, UserIcon, ShieldIcon } from "../components/icons";

interface Props {
  profile: Student;
  onGoHome: () => void;
}

interface DesktopIconProps {
  icon: React.ComponentType<{ className?: string }>;
  label: string;
  onClick?: () => void;
  badge?: string;
  /** Smaller icon, used for the subjects inside an open term folder so a full term still fits. */
  small?: boolean;
  /** Set on a term folder: true while its subjects are showing. */
  expanded?: boolean;
}

function DesktopIcon({ icon: Icon, label, onClick, badge, small, expanded }: DesktopIconProps) {
  const disabled = !onClick;
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      aria-expanded={expanded}
      className={`flex flex-col items-center gap-1.5 w-16 shrink-0 rounded-xl py-1 transition-colors group ${
        expanded ? "bg-white/15 backdrop-blur-sm" : ""
      } ${
        disabled ? "text-white/60 cursor-default" : "text-white/95 hover:text-white"
      }`}
    >
      <Icon
        className={`${small ? "w-5 h-5" : "w-7 h-7"} drop-shadow-[0_2px_5px_rgba(0,0,0,0.55)] transition-transform ${!disabled ? "group-hover:scale-110" : ""}`}
      />
      <span className={`${small ? "text-[10px]" : "text-[11px]"} font-semibold text-center leading-tight drop-shadow-[0_1px_3px_rgba(0,0,0,0.65)]`}>
        {label}
      </span>
      {badge && (
        <span className="text-[9px] font-bold uppercase tracking-wide bg-white/20 rounded-full px-1.5 py-0.5 backdrop-blur-sm">
          {badge}
        </span>
      )}
    </button>
  );
}

/** A desktop icon is a narrow fixed-width tile, so a long course name wraps into a tall unreadable
    column of two- and three-letter lines. Courses whose name does not fit get a short label here;
    every other course falls back to its full name, which is what reads correctly in the prose that
    uses it elsewhere (HomeGuide's "... are live today", SessionPage's read-only note). */
const SHORT_LABELS: Record<string, string> = {
  BANM2: "BANM",
  MADM2: "MADM",
};

/** The post-login "desktop" — a scene with icons as the primary way to get anywhere else in the
    app. Stays mounted behind every Window (see App.tsx), so it must not assume it's the only
    thing on screen. Course entry points come from the courses table — enabled courses are
    clickable, disabled ones (e.g. Operations before its content lands) show a "Soon" badge.
    Courses are grouped into one folder per term; a folder opens to show its courses and their
    end-term revision guides, and only one folder is open at a time. */
export function HomePage({ profile, onGoHome }: Props) {
  const navigate = useNavigate();
  const [courses, setCourses] = useState<Course[]>([]);

  useEffect(() => {
    void fetchCourses().then(setCourses);
  }, []);

  // A guide is only offered once its course is (a course nobody can open yet shouldn't have a
  // revision guide sitting open next to it); admins see it early, same as they do the courses.
  const revisionGuides = Object.values(REVISION_GUIDES).filter((g) =>
    courses.some((c) => c.id === g.course && (c.enabled || profile.is_admin)),
  );

  // Close an open term folder when the user clicks anywhere outside the rail.
  const [openTerm, setOpenTerm] = useState<string | null>(null);
  const railRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    if (!openTerm) return;
    const close = (e: PointerEvent) => {
      if (!railRef.current?.contains(e.target as Node)) setOpenTerm(null);
    };
    document.addEventListener("pointerdown", close);
    return () => document.removeEventListener("pointerdown", close);
  }, [openTerm]);

  // Picking a subject also folds the term back up, so the rail is short again behind the window.
  const go = (path: string) => () => {
    setOpenTerm(null);
    navigate(path);
  };

  // One folder per term, in term order. Each holds that term's course books followed by their
  // revision guides. Revision guides get their own compass icon rather than another book: they sit
  // right beside the course books, and are a different kind of thing — a frozen end-term document,
  // not the course's live session content.
  const terms = [...new Set(courses.map((c) => c.term ?? "Other"))].sort((a, b) =>
    a.localeCompare(b, undefined, { numeric: true }),
  );
  const folders = terms.map((term) => {
    const inTerm = courses.filter((c) => (c.term ?? "Other") === term);
    const items: DesktopIconProps[] = [
      ...inTerm.map((c) => ({
        icon: BookIcon,
        label: SHORT_LABELS[c.id] ?? c.name,
        onClick: c.enabled || profile.is_admin ? go(`/learn/sessions/${c.id}`) : undefined,
        badge: c.enabled ? undefined : profile.is_admin ? "Preview" : "Soon",
      })),
      ...revisionGuides
        .filter((g) => inTerm.some((c) => c.id === g.course))
        .map((g) => ({
          icon: CompassIcon,
          label: `${SHORT_LABELS[g.course] ?? g.course} Revision`,
          onClick: go(`/learn/revision/${g.course}`),
        })),
    ];
    return { term, items };
  });

  const rightIcons: DesktopIconProps[] = profile.is_admin
    ? [{ icon: ShieldIcon, label: "Admin", onClick: () => navigate("/learn/admin") }]
    : [];

  return (
    <div className="relative min-h-dvh overflow-hidden">
      {/* Same ISB campus photo as Login, shown full-strength — icons are white with a drop
          shadow so they stay legible against the photo's own light/dark regions, rather than
          washing the photo out to suit dark icons. */}
      <div className="absolute inset-0 bg-[url('/login-bg.webp')] bg-cover bg-center" />

      <header className="relative z-20 flex items-center justify-between mx-3 mt-3 md:mx-4 md:mt-4 px-3.5 py-2.5 rounded-2xl bg-base/85 backdrop-blur-sm shadow-[0_4px_20px_-6px_rgba(46,59,66,0.35)]">
        <button onClick={onGoHome} className="flex items-center">
          <img src="/isb-logo.png" alt="ISB" className="h-5 w-auto" />
        </button>
        <button
          onClick={() => navigate("/learn/profile")}
          aria-label="Profile"
          className="w-7 h-7 rounded-full bg-surface-2 border border-line flex items-center justify-center text-ink-soft hover:text-ink hover:border-accent/50 transition-colors"
        >
          <UserIcon className="w-3.5 h-3.5" />
        </button>
      </header>

      {/* Hidden on mobile — MobileNav carries these same destinations there, and showing both
          would give the phone two competing navigations. */}
      {/* Capped to the screen height and scrollable, so a long rail never runs off the bottom. */}
      <div
        ref={railRef}
        className="fixed left-4 md:left-6 top-20 z-10 hidden md:flex flex-col gap-6 max-h-[calc(100dvh-6rem)] overflow-y-auto [scrollbar-width:none] pb-4 rise-in"
        style={{ animationDelay: "60ms" }}
      >
        <DesktopIcon icon={HomeIcon} label="Home" onClick={onGoHome} />
        {folders.map(({ term, items }) => {
          const open = openTerm === term;
          return (
            <div key={term} className="flex flex-col items-center">
              <DesktopIcon
                icon={FolderIcon}
                label={term}
                expanded={open}
                onClick={() => setOpenTerm(open ? null : term)}
              />
              {/* grid-rows 0fr -> 1fr animates the folder open to its natural height. `inert` keeps
                  the hidden subjects out of the tab order while the folder is closed. */}
              <div
                inert={!open}
                className={`grid transition-[grid-template-rows,opacity] duration-200 ease-out ${
                  open ? "grid-rows-[1fr] opacity-100" : "grid-rows-[0fr] opacity-0"
                }`}
              >
                <div className="overflow-hidden">
                  <div className="mt-2 flex flex-col items-center gap-3 rounded-2xl bg-black/30 backdrop-blur-sm py-3">
                    {items.map((item) => (
                      <DesktopIcon key={item.label} {...item} small />
                    ))}
                  </div>
                </div>
              </div>
            </div>
          );
        })}
        <DesktopIcon icon={BoltIcon} label="Practice" onClick={() => navigate("/learn/practice")} />
      </div>
      {rightIcons.length > 0 && (
        <div className="fixed right-4 md:right-6 top-20 z-10 hidden md:flex flex-col gap-7 rise-in" style={{ animationDelay: "100ms" }}>
          {rightIcons.map((item) => (
            <DesktopIcon key={item.label} {...item} />
          ))}
        </div>
      )}
    </div>
  );
}
