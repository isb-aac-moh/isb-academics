import { useState } from "react";
import { COLOR } from "./lib/theme";
import { useAuth } from "./hooks/useAuth";
import Login from "./pages/Login";
import BiddingPlanner from "./pages/BiddingPlanner";
import AdminPage from "./pages/AdminPage";
import Sidebar, { type AppSection } from "./components/Sidebar";

export default function App() {
  const { user, loading, signOut } = useAuth();
  const [section, setSection] = useState<AppSection>("planner");

  if (loading) {
    return <div style={{ minHeight: "100vh", background: COLOR.bg }} />;
  }

  if (!user) {
    return <Login />;
  }

  return (
    <div className="flex flex-col md:flex-row">
      <Sidebar user={user} active={section} onNavigate={setSection} onSignOut={signOut} />
      <div style={{ flex: 1, minWidth: 0 }}>
        {section === "admin" && user.is_admin ? <AdminPage /> : <BiddingPlanner user={user} />}
      </div>
    </div>
  );
}
