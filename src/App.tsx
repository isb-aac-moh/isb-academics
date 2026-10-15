import { Routes, Route, Navigate } from "react-router-dom";
import { COLOR } from "./lib/theme";
import { useAuth } from "./hooks/useAuth";
import { lazyWithReload } from "./lib/lazyWithReload";
import Login from "./pages/Login";
import Layout from "./components/Layout";
import RequireAdmin from "./components/RequireAdmin";

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
const LearnSection = lazyWithReload(() => import("./learn/LearnSection"));

export default function App() {
  const { user, loading, notProvisioned, signOut } = useAuth();

  if (loading) {
    return <div style={{ minHeight: "100vh", background: COLOR.bg }} />;
  }

  if (!user) {
    return <Login notProvisioned={notProvisioned} onSignOut={signOut} />;
  }

  return (
    <Routes>
      <Route element={<Layout user={user} onSignOut={signOut} />}>
        <Route path="/" element={<Navigate to="/tracker" replace />} />
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
        {/* Compass: search + map of everything ISB taught. Descendant routes live in the section. */}
        <Route path="/compass/*" element={<CompassSection />} />
        <Route path="/learn/*" element={<LearnSection user={user} />} />

        <Route element={<RequireAdmin user={user} />}>
          <Route path="/notices" element={<NoticeBoard />} />
          <Route path="/admin" element={<Navigate to="/admin/overview" replace />} />
          <Route path="/admin/:tab" element={<AdminPage />} />
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </Routes>
  );
}
