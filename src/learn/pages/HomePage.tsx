import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import type { Course, Student } from "../types";
import { fetchCourses } from "../lib/db";
import { REVISION_GUIDES } from "../lib/revisionGuides";
import { HomeIcon, BookIcon, BoltIcon, CompassIcon, UserIcon, ShieldIcon } from "../components/icons";

interface Props {
  profile: Student;
  onGoHome: () => void;
}

interface DesktopIconProps {
  icon: React.ComponentType<{ className?: string }>;
  label: string;
  onClick?: () => void;
  badge?: string;
}

function DesktopIcon({ icon: Icon, label, onClick, badge }: DesktopIconProps) {
  const disabled = !onClick;
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`flex flex-col items-center gap-1.5 w-16 shrink-0 transition-colors group ${
        disabled ? "text-white/60 cursor-default" : "text-white/95 hover:text-white"
      }`}
    >
      <Icon
        className={`w-7 h-7 drop-shadow-[0_2px_5px_rgba(0,0,0,0.55)] transition-transform ${!disabled ? "group-hover:scale-110" : ""}`}
      />
      <span className="text-[11px] font-semibold text-center leading-tight drop-shadow-[0_1px_3px_rgba(0,0,0,0.65)]">
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
    End-term revision guides follow the courses, one icon each. */
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

  const leftIcons: DesktopIconProps[] = [
    { icon: HomeIcon, label: "Home", onClick: onGoHome },
    ...courses.map((c) => ({
      icon: BookIcon,
      label: SHORT_LABELS[c.id] ?? c.name,
      onClick: c.enabled || profile.is_admin ? () => navigate(`/learn/sessions/${c.id}`) : undefined,
      badge: c.enabled ? undefined : profile.is_admin ? "Preview" : "Soon",
    })),
    // Revision guides get their own compass icon rather than another book: they sit right beside the
    // course books here, and are a different kind of thing — a frozen end-term document, not the
    // course's live session content.
    ...revisionGuides.map((g) => ({
      icon: CompassIcon,
      label: `${g.course} Revision`,
      onClick: () => navigate(`/learn/revision/${g.course}`),
    })),
    { icon: BoltIcon, label: "Practice", onClick: () => navigate("/learn/practice") },
  ];
  const rightIcons: DesktopIconProps[] = profile.is_admin
    ? [{ icon: ShieldIcon, label: "Admin", onClick: () => navigate("/learn/admin") }]
    : [];

  return (
    <div className="relative min-h-dvh overflow-hidden">
      {/* Same ISB campus photo as Login, shown full-strength — icons are white with a drop
          shadow so they stay legible against the photo's own light/dark regions, rather than
          washing the photo out to suit dark icons. */}
      <div className="absolute inset-0 bg-[url('/login-bg.jpg')] bg-cover bg-center" />

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
      <div className="fixed left-4 md:left-6 top-20 z-10 hidden md:flex flex-col gap-7 rise-in" style={{ animationDelay: "60ms" }}>
        {leftIcons.map((item) => (
          <DesktopIcon key={item.label} {...item} />
        ))}
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
