import { lazy } from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import { COLOR } from "./lib/theme";
import { useAuth } from "./hooks/useAuth";
import Login from "./pages/Login";
import Layout from "./components/Layout";
import RequireAdmin from "./components/RequireAdmin";

/* Every route below the shell is code-split. The shell (Layout + Sidebar) and Login stay in the
   entry chunk because one of the two always paints first; everything else is fetched while the
   auth/profile query is still in flight, so the extra request costs no wall-clock time on a cold
   load but keeps ~2/3 of the JS out of it. Layout renders the Suspense boundary, so the sidebar
   stays on screen while a page chunk arrives. */
const BiddingPlanner = lazy(() => import("./pages/BiddingPlanner"));
const CreditTracker = lazy(() => import("./pages/CreditTracker"));
const AdminPage = lazy(() => import("./pages/AdminPage"));
const CourseResources = lazy(() => import("./pages/CourseResources"));
const TermFourDossier = lazy(() => import("./pages/TermFourDossier"));
const TermFourBiddingQA = lazy(() => import("./pages/TermFourBiddingQA"));
const NoticeBoard = lazy(() => import("./pages/NoticeBoard"));
const PulseCheck = lazy(() => import("./pages/PulseCheck"));
const LearnSection = lazy(() => import("./learn/LearnSection"));

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

        {/* Trailing splat: the Learn section renders its own descendant routes (its window
            content) rather than being a single page. */}
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
