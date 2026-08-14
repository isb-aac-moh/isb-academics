import { lazy, Suspense, useState } from "react";
import { Routes, Route, useLocation, useNavigate } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import { Window } from "./components/Window";
import { MobileNav } from "./components/MobileNav";
import { RequireAdmin } from "./components/RequireAdmin";
import { HomePage } from "./pages/HomePage";
import { HomeGuide } from "./pages/HomeGuide";
import { LearnPage } from "./pages/LearnPage";
import { SessionsPage } from "./pages/SessionsPage";
import { SessionPage } from "./pages/SessionPage";
import { ProfilePage } from "./pages/ProfilePage";
import { useLearnProfile } from "./useLearnProfile";
import type { User } from "../types";

const AdminPage = lazy(() => import("./pages/AdminPage").then((m) => ({ default: m.AdminPage })));

const WINDOW_TITLES: Record<string, string> = {
  "": "Home",
  subjects: "Learn",
  sessions: "Sessions",
  practice: "Smart practice",
  profile: "Profile",
  admin: "Admin",
};

/**
 * The Learn section: the campus "desktop" stays mounted and everything else opens as a floating
 * window on top of it, the same shape the standalone app had.
 *
 * Three changes from that app:
 *
 * - No nested BrowserRouter. These are descendant routes under the app's single router, so paths
 *   are relative to /learn and the section index reads segment 2 rather than 1.
 * - The subject picker lives at /learn/subjects. It was /learn in the standalone app, which would
 *   have nested into /learn/learn here and read as a mistake.
 * - `learn-root` is not just a style hook. It carries a transform, which makes it the containing
 *   block for the `position: fixed` descendants inside — the desktop icon rail and the Window
 *   itself. Without it both measure from the viewport edge and sit on top of the app sidebar,
 *   which is exactly what they did the first time this was wired up.
 *
 * Sign-out is deliberately not surfaced inside the window; the sidebar owns it for the whole app.
 */
export default function LearnSection({ user }: { user: User }) {
  const location = useLocation();
  const navigate = useNavigate();
  const [homeGuideOpen, setHomeGuideOpen] = useState(true);
  const { profile, error, setProfile } = useLearnProfile(user);

  if (error) return <LearnMessage title="Practice is unavailable" detail={error} />;
  if (!profile) return <div className="learn-root" />;

  const section = location.pathname.split("/")[2] ?? "";
  const atHome = section === "";
  const title = atHome ? (homeGuideOpen ? WINDOW_TITLES[""] : null) : WINDOW_TITLES[section];
  const closeWindow = atHome ? () => setHomeGuideOpen(false) : () => navigate("/learn");
  const goHome = () => {
    navigate("/learn");
    setHomeGuideOpen(true);
  };

  return (
    <div className="learn-root">
      <HomePage profile={profile} onGoHome={goHome} />
      {title && (
        <Window title={title} onClose={closeWindow}>
          <Routes>
            <Route path="" element={<HomeGuide profile={profile} />} />
            <Route path="subjects" element={<LearnPage profile={profile} />} />
            <Route path="sessions/:course" element={<SessionsPage profile={profile} />} />
            <Route path="sessions/:course/:session" element={<SessionsPage profile={profile} />} />
            <Route path="sessions/:course/:session/:topic" element={<SessionsPage profile={profile} />} />
            <Route
              path="practice"
              element={
                <SessionPage
                  profile={profile}
                  onXpChange={(xp) => setProfile({ ...profile, total_xp: xp })}
                />
              }
            />
            <Route path="profile" element={<ProfilePage profile={profile} onSignOut={goHome} />} />
            <Route element={<RequireAdmin profile={profile} />}>
              <Route
                path="admin"
                element={
                  <Suspense fallback={null}>
                    <AdminPage />
                  </Suspense>
                }
              />
            </Route>
          </Routes>
        </Window>
      )}
      <MobileNav onGoHome={goHome} />
    </div>
  );
}

function LearnMessage({ title, detail }: { title: string; detail: string }) {
  return (
    <div style={{ padding: "48px 24px", textAlign: "center" }}>
      <p style={{ fontFamily: FONT.serif, fontSize: 20, color: COLOR.ink, marginBottom: 8 }}>{title}</p>
      <p style={{ fontFamily: FONT.sans, fontSize: 13.5, color: COLOR.ink2 }}>{detail}</p>
    </div>
  );
}
