import { Suspense, useEffect } from "react";
import { Outlet, useLocation } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import Sidebar from "./Sidebar";
import BottomNav from "./BottomNav";
import PopupManager from "./PopupManager";
import DemoSectionExplainer from "./DemoSectionExplainer";
import DemoExternalLinkModal from "./DemoExternalLinkModal";
import type { User } from "../types";

const ADMIN_PREVIEW_PREFIXES = ["/notices"];

const PAGE_TITLES: [prefix: string, title: string][] = [
  ["/tracker", "Credit Tracker"],
  ["/planner", "Bidding Planner"],
  ["/pulse-check", "Bidding Pulse"],
  ["/resources", "Course Resources"],
  ["/term4", "Term 4 Dossier"],
  ["/notices", "Notice Board"],
  ["/admin", "Admin"],
  ["/learn", "Learn"],
  ["/compass", "Compass"],
];

/** "/dossier/term-6" -> "Term 6 Dossier"; unknown paths keep the plain app name. */
function pageTitle(pathname: string): string {
  const dossier = pathname.match(/^\/dossier\/([^/]+)/);
  if (dossier) {
    const term = dossier[1].replace(/-/g, " ");
    return `${term.charAt(0).toUpperCase()}${term.slice(1)} Dossier · ISB Academics`;
  }
  const hit = PAGE_TITLES.find(([prefix]) => pathname === prefix || pathname.startsWith(`${prefix}/`));
  return hit ? `${hit[1]} · ISB Academics` : "ISB Academics";
}

export default function Layout({ user, onSignOut }: { user: User; onSignOut: () => void }) {
  const location = useLocation();
  // The tab title is what browser history, bookmarks and screen readers announce for a page, and
  // the router swaps pages without a reload, so each route has to set it. Scroll resets for the
  // same reason: a new page should start at the top, not wherever the last one was left.
  useEffect(() => {
    document.title = pageTitle(location.pathname);
    window.scrollTo(0, 0);
  }, [location.pathname]);
  const showPreviewBanner = ADMIN_PREVIEW_PREFIXES.some((p) => location.pathname.startsWith(p));
  // /learn renders its own bottom nav and already reserves space for it; everywhere else needs
  // room at the bottom on mobile so the new app-wide bar doesn't cover the page's last content.
  const inLearn = location.pathname.startsWith("/learn");

  return (
    <div className="flex flex-col md:flex-row">
      <PopupManager />
      <DemoExternalLinkModal />
      <Sidebar user={user} onSignOut={onSignOut} />
      <div style={{ flex: 1, minWidth: 0 }} className={inLearn ? "" : "pb-[calc(3.25rem+env(safe-area-inset-bottom))] md:pb-0"}>
        <DemoSectionExplainer />
        {showPreviewBanner && <PreviewBanner />}
        {/* Holds the shell steady while a lazily-fetched page chunk arrives. The fallback is a
            blank block of the page background rather than a spinner: chunks are small and usually
            land within a frame or two, and a spinner that flashes for 30ms reads as jank. */}
        <Suspense fallback={<div style={{ minHeight: "100vh", background: COLOR.bg }} />}>
          <Outlet context={{ user }} />
        </Suspense>
      </div>
      <BottomNav />
    </div>
  );
}

function PreviewBanner() {
  return (
    <div style={{ background: COLOR.amberTint, borderBottom: `1px solid #E9C77B`, padding: "9px 24px", textAlign: "center" }}>
      <span style={{ fontFamily: FONT.sans, fontSize: 12.5, fontWeight: 700, color: "#8B5E00" }}>
        Admin preview — not visible to students yet
      </span>
    </div>
  );
}
