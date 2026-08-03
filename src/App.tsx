import { Routes, Route, Navigate } from "react-router-dom";
import { COLOR } from "./lib/theme";
import { useAuth } from "./hooks/useAuth";
import Login from "./pages/Login";
import BiddingPlanner from "./pages/BiddingPlanner";
import CreditTracker from "./pages/CreditTracker";
import AdminPage from "./pages/AdminPage";
import CourseResources from "./pages/CourseResources";
import NoticeBoard from "./pages/NoticeBoard";
import PulseCheck from "./pages/PulseCheck";
import Layout from "./components/Layout";
import RequireAdmin from "./components/RequireAdmin";

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
