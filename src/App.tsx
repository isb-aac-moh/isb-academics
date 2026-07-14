import { useState } from "react";
import { COLOR, FONT } from "./lib/theme";
import { useAuth } from "./hooks/useAuth";
import Login from "./pages/Login";
import BiddingPlanner from "./pages/BiddingPlanner";
import AdminPage from "./pages/AdminPage";
import CourseResources from "./pages/CourseResources";
import NoticeBoard from "./pages/NoticeBoard";
import Sidebar, { type AppSection } from "./components/Sidebar";

// Sections still in admin-only preview — not yet released to students.
// Hiding the nav item (Sidebar) is a UX affordance; this is the real gate.
const ADMIN_ONLY_SECTIONS: AppSection[] = ["resources", "noticeboard"];

export default function App() {
  const { user, loading, signOut } = useAuth();
  const [section, setSection] = useState<AppSection>("planner");

  if (loading) {
    return <div style={{ minHeight: "100vh", background: COLOR.bg }} />;
  }

  if (!user) {
    return <Login />;
  }

  const canView = (s: AppSection) => user.is_admin || !ADMIN_ONLY_SECTIONS.includes(s);
  const effectiveSection = canView(section) ? section : "planner";

  return (
    <div className="flex flex-col md:flex-row">
      <Sidebar user={user} active={effectiveSection} onNavigate={setSection} onSignOut={signOut} />
      <div style={{ flex: 1, minWidth: 0 }}>
        {ADMIN_ONLY_SECTIONS.includes(effectiveSection) && <PreviewBanner />}
        {effectiveSection === "admin" && user.is_admin && <AdminPage />}
        {effectiveSection === "resources" && <CourseResources />}
        {effectiveSection === "noticeboard" && <NoticeBoard />}
        {effectiveSection === "planner" && <BiddingPlanner user={user} />}
      </div>
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
