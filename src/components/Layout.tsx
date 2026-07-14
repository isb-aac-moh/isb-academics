import { Outlet, useLocation } from "react-router-dom";
import { COLOR, FONT } from "../lib/theme";
import Sidebar from "./Sidebar";
import type { User } from "../types";

const ADMIN_PREVIEW_PREFIXES = ["/resources", "/notices"];

export default function Layout({ user, onSignOut }: { user: User; onSignOut: () => void }) {
  const location = useLocation();
  const showPreviewBanner = ADMIN_PREVIEW_PREFIXES.some((p) => location.pathname.startsWith(p));

  return (
    <div className="flex flex-col md:flex-row">
      <Sidebar user={user} onSignOut={onSignOut} />
      <div style={{ flex: 1, minWidth: 0 }}>
        {showPreviewBanner && <PreviewBanner />}
        <Outlet context={{ user }} />
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
