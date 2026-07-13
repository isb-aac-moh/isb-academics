import { ListChecks, ShieldCheck, LogOut } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import type { User } from "../types";

export type AppSection = "planner" | "admin";

interface Props {
  user: User;
  active: AppSection;
  onNavigate: (section: AppSection) => void;
  onSignOut: () => void;
}

export default function Sidebar({ user, active, onNavigate, onSignOut }: Props) {
  return (
    <aside
      className="hidden md:flex flex-col justify-between"
      style={{ width: 220, minHeight: "100vh", background: COLOR.navyHero, flexShrink: 0, padding: "24px 16px" }}
    >
      <div>
        <p style={{ fontFamily: FONT.sans, fontWeight: 800, fontSize: 14, color: "#fff" }}>ISB</p>
        <p style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 12, color: COLOR.mint, marginTop: 1 }}>Academics</p>

        <nav className="mt-8 space-y-1">
          <NavItem
            icon={<ListChecks size={16} />}
            label="Bidding Planner"
            active={active === "planner"}
            onClick={() => onNavigate("planner")}
          />
          <NavItem icon={<ListChecks size={16} />} label="Course Resources" active={false} onClick={() => {}} disabled soon />
          <NavItem icon={<ListChecks size={16} />} label="Notice Board" active={false} onClick={() => {}} disabled soon />
        </nav>
      </div>

      <div>
        {user.is_admin && (
          <NavItem
            icon={<ShieldCheck size={16} />}
            label="Admin"
            active={active === "admin"}
            onClick={() => onNavigate("admin")}
          />
        )}
        <div style={{ borderTop: "1px solid rgba(255,255,255,0.15)", marginTop: 12, paddingTop: 12 }}>
          <p style={{ fontFamily: FONT.sans, fontSize: 12, color: "rgba(255,255,255,0.85)", fontWeight: 600, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
            {user.name || user.email}
          </p>
          <button
            onClick={onSignOut}
            style={{ display: "flex", alignItems: "center", gap: 6, marginTop: 8, background: "none", border: "none", color: "rgba(255,255,255,0.6)", fontFamily: FONT.sans, fontSize: 12, cursor: "pointer", padding: 0 }}
          >
            <LogOut size={13} /> Sign out
          </button>
        </div>
      </div>
    </aside>
  );
}

function NavItem({
  icon, label, active, onClick, disabled, soon,
}: { icon: React.ReactNode; label: string; active: boolean; onClick: () => void; disabled?: boolean; soon?: boolean }) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      style={{
        width: "100%", display: "flex", alignItems: "center", gap: 10, padding: "9px 10px", borderRadius: 8,
        background: active ? "rgba(255,255,255,0.12)" : "transparent", border: "none", cursor: disabled ? "default" : "pointer",
        color: disabled ? "rgba(255,255,255,0.35)" : "#fff", fontFamily: FONT.sans, fontSize: 13, fontWeight: 600, textAlign: "left",
      }}
    >
      {icon}
      <span style={{ flex: 1 }}>{label}</span>
      {soon && <span style={{ fontSize: 9, fontWeight: 700, color: COLOR.mint, letterSpacing: "0.04em" }}>SOON</span>}
    </button>
  );
}
