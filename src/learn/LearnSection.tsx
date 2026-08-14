import { lazy, Suspense, useState } from "react";
import { Routes, Route, useLocation, useNavigate } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import { Window } from "./components/Window";
import { RequireAdmin } from "./components/RequireAdmin";
import { HomePage } from "./pages/HomePage";
import { HomeGuide } from "./pages/HomeGuide";
import { SessionsPage } from "./pages/SessionsPage";
import { SessionPage } from "./pages/SessionPage";
import { ProfilePage } from "./pages/ProfilePage";
import { useLearnProfile } from "./useLearnProfile";
import type { User } from "../types";

const AdminPage = lazy(() => import("./pages/AdminPage").then((m) => ({ default: m.AdminPage })));

const WINDOW_TITLES: Record<string, string> = {
  "": "Home",
  sessions: "Sessions",
  practice: "Smart practice",
  profile: "Profile",
  admin: "Admin",
};

/**
 * The Learn section: the campus "desktop" stays mounted and everything else opens as a floating
 * window on top of it, the same shape the standalone app had.
 *
 * Two changes from that app. It no longer mounts its own BrowserRouter — these are descendant
 * routes under the app's single router, so the paths here are relative to /learn. And the
 * section index is read from segment 2 rather than 1, since every path now starts with /learn.
 *
 * Sign-out is deliberately not surfaced inside the window; the sidebar owns it for the whole app.
 */
export default function LearnSection({ user }: { user: User }) {
  const location = useLocation();
  const navigate = useNavigate();
  const [homeGuideOpen, setHomeGuideOpen] = useState(true);
  const { profile, error, setProfile } = useLearnProfile(user);

  if (error) return <LearnMessage title="Practice is unavailable" detail={error} />;
  if (!profile) return <div style={{ minHeight: "100dvh", background: "var(--c-base)" }} />;

  const section = location.pathname.split("/")[2] ?? "";
  const atHome = section === "";
  const title = atHome ? (homeGuideOpen ? WINDOW_TITLES[""] : null) : WINDOW_TITLES[section];
  const closeWindow = atHome ? () => setHomeGuideOpen(false) : () => navigate("/learn");
  const goHome = () => {
    navigate("/learn");
    setHomeGuideOpen(true);
  };

  return (
    <>
      <HomePage profile={profile} onGoHome={goHome} />
      {title && (
        <Window title={title} onClose={closeWindow}>
          <Routes>
            <Route path="" element={<HomeGuide profile={profile} />} />
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
            <Route path="profile" element={<ProfilePage profile={profile} onSignOut={() => navigate("/learn")} />} />
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
    </>
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
