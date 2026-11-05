import { Suspense } from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import { useAuth } from "./hooks/useAuth";
import { isDemoMode } from "./lib/demoMode";
import { AUTH_STORAGE_KEY, CONSENT_RETURN_KEY } from "./lib/supabase";
import { lazyWithReload } from "./lib/lazyWithReload";
import Login from "./pages/Login";
import Layout from "./components/Layout";
import RequireAdmin from "./components/RequireAdmin";
import { AppShellSkeleton } from "./components/Skeleton";

/* Every route below the shell is code-split. The shell (Layout + Sidebar) and Login stay in the
   entry chunk because one of the two always paints first; everything else is fetched while the
   auth/profile query is still in flight, so the extra request costs no wall-clock time on a cold
   load but keeps ~2/3 of the JS out of it. Layout renders the Suspense boundary, so the sidebar
   stays on screen while a page chunk arrives. */
const BiddingPlanner = lazyWithReload(() => import("./pages/BiddingPlanner"));
const CreditTracker = lazyWithReload(() => import("./pages/CreditTracker"));
const AdminPage = lazyWithReload(() => import("./pages/AdminPage"));
const CourseResources = lazyWithReload(() => import("./pages/CourseResources"));
const TermFourDossier = lazyWithReload(() => import("./pages/TermFourDossier"));
const TermFourBiddingQA = lazyWithReload(() => import("./pages/TermFourBiddingQA"));
const TermDossier = lazyWithReload(() => import("./pages/TermDossier"));
const NoticeBoard = lazyWithReload(() => import("./pages/NoticeBoard"));
const PulseCheck = lazyWithReload(() => import("./pages/PulseCheck"));
const CompassSection = lazyWithReload(() => import("./compass/CompassSection"));
const OAuthConsent = lazyWithReload(() => import("./pages/OAuthConsent"));
const LearnSection = lazyWithReload(() => import("./learn/LearnSection"));

/* Fetching a page's code only once it renders put the download after the sign-in check, in series.
   For someone who looks signed in (a stored session, or the demo), start the download for the
   page the URL points at right now, in parallel with the check. A signed-out visitor is not asked
   to fetch app code they are about to be turned away from. */
const PRELOAD_BY_PATH: [string, { preload: () => Promise<unknown> }][] = [
  ["/tracker", CreditTracker],
  ["/planner", BiddingPlanner],
  ["/pulse-check", PulseCheck],
  ["/resources", CourseResources],
  ["/dossier", TermDossier],
  ["/learn", LearnSection],
];
function preloadCurrentPage() {
  let looksSignedIn = isDemoMode();
  try {
    looksSignedIn ||= localStorage.getItem(AUTH_STORAGE_KEY) !== null;
  } catch {
    // Storage blocked: nothing to preload from, the normal path still works.
  }
  if (!looksSignedIn) return;
  const path = window.location.pathname === "/" ? "/tracker" : window.location.pathname;
  PRELOAD_BY_PATH.find(([prefix]) => path.startsWith(prefix))?.[1].preload();
}
preloadCurrentPage();

// Microsoft sign-in always returns to "/", so remember the connector approval page across it.
function consentReturn(): string | null {
  try {
    if (window.location.pathname === "/oauth/consent") localStorage.setItem(CONSENT_RETURN_KEY, window.location.pathname + window.location.search);
    return localStorage.getItem(CONSENT_RETURN_KEY);
  } catch {
    return null;
  }
}
consentReturn();

export default function App() {
  const { user, loading, notProvisioned, signOut } = useAuth();

  if (loading) {
    return <AppShellSkeleton />;
  }

  if (!user) {
    return <Login notProvisioned={notProvisioned} onSignOut={signOut} />;
  }

  return (
    <Routes>
      <Route path="/oauth/consent" element={<Suspense fallback={<AppShellSkeleton />}><OAuthConsent user={user} /></Suspense>} />
      <Route element={<Layout user={user} onSignOut={signOut} />}>
        <Route path="/" element={<Navigate to={consentReturn() ?? "/tracker"} replace />} />
        <Route path="/planner" element={<Navigate to="/planner/background" replace />} />
        <Route path="/planner/:step" element={<BiddingPlanner />} />
        <Route path="/tracker" element={<CreditTracker />} />
        <Route path="/pulse-check" element={<PulseCheck />} />
        <Route path="/resources" element={<CourseResources />} />
        <Route path="/term4" element={<TermFourDossier />} />
        <Route path="/term4-bidding-qa" element={<TermFourBiddingQA />} />

        {/* One page per term, driven by course_grading_profiles — a new term needs a
            seed, not a route. /term5 is the guessable URL students will type. */}
        <Route path="/dossier/:term" element={<TermDossier />} />
        <Route path="/term5" element={<Navigate to="/dossier/term-5" replace />} />

        {/* Trailing splat: the Learn section renders its own descendant routes (its window
            content) rather than being a single page. */}
        <Route path="/learn/*" element={<LearnSection user={user} />} />

        <Route element={<RequireAdmin user={user} />}>
          {/* Compass (search + map of everything ISB taught) is admin-only during the pilot. Remove this
              wrapper to open it to students; the dataset bucket policy must be widened to match. */}
          <Route path="/compass/*" element={<CompassSection />} />
          <Route path="/notices" element={<NoticeBoard />} />
          <Route path="/admin" element={<Navigate to="/admin/overview" replace />} />
          <Route path="/admin/:tab" element={<AdminPage />} />
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </Routes>
  );
}
