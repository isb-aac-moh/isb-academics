import { useState } from "react";
import { ListChecks, ShieldCheck, LogOut, Menu, X, BookOpen, Megaphone } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import type { User } from "../types";

export type AppSection = "planner" | "resources" | "noticeboard" | "admin";

interface Props {
  user: User;
  active: AppSection;
  onNavigate: (section: AppSection) => void;
  onSignOut: () => void;
}

export default function Sidebar({ user, active, onNavigate, onSignOut }: Props) {
  const [mobileOpen, setMobileOpen] = useState(false);

  function navigate(section: AppSection) {
    onNavigate(section);
    setMobileOpen(false);
  }

  const primaryNav = (
    <nav className="space-y-1">
      <NavItem icon={<ListChecks size={16} />} label="Bidding Planner" active={active === "planner"} onClick={() => navigate("planner")} />
      <NavItem
        icon={<BookOpen size={16} />}
        label="Course Resources"
        active={active === "resources"}
        onClick={() => navigate("resources")}
        disabled={!user.is_admin}
        soon={!user.is_admin}
        preview={user.is_admin}
      />
      <NavItem
        icon={<Megaphone size={16} />}
        label="Notice Board"
        active={active === "noticeboard"}
        onClick={() => navigate("noticeboard")}
        disabled={!user.is_admin}
        soon={!user.is_admin}
        preview={user.is_admin}
      />
    </nav>
  );

  const bottomNav = (
    <div>
      {user.is_admin && (
        <NavItem icon={<ShieldCheck size={16} />} label="Admin" active={active === "admin"} onClick={() => navigate("admin")} />
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
  );

  return (
    <>
      {/* Mobile top bar — visible below md */}
      <header
        className="flex md:hidden items-center justify-between"
        style={{ position: "sticky", top: 0, zIndex: 40, background: COLOR.navyHero, padding: "14px 16px" }}
      >
        <div>
          <span style={{ fontFamily: FONT.sans, fontWeight: 800, fontSize: 13, color: "#fff" }}>ISB </span>
          <span style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 13, color: COLOR.mint }}>Academics</span>
        </div>
        <button
          onClick={() => setMobileOpen(true)}
          aria-label="Open menu"
          style={{ background: "none", border: "none", color: "#fff", padding: 6, cursor: "pointer" }}
        >
          <Menu size={22} />
        </button>
      </header>

      {/* Mobile drawer */}
      {mobileOpen && (
        <div className="md:hidden" style={{ position: "fixed", inset: 0, zIndex: 50 }}>
          <div onClick={() => setMobileOpen(false)} style={{ position: "absolute", inset: 0, background: "rgba(0,0,0,0.4)" }} />
          <div
            className="flex flex-col justify-between"
            style={{ position: "absolute", top: 0, left: 0, bottom: 0, width: "min(280px, 85vw)", background: COLOR.navyHero, padding: "20px 16px", overflowY: "auto" }}
          >
            <div>
              <div className="flex items-center justify-between mb-8">
                <div>
                  <p style={{ fontFamily: FONT.sans, fontWeight: 800, fontSize: 14, color: "#fff" }}>ISB</p>
                  <p style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 12, color: COLOR.mint, marginTop: 1 }}>Academics</p>
                </div>
                <button onClick={() => setMobileOpen(false)} aria-label="Close menu" style={{ background: "none", border: "none", color: "#fff", cursor: "pointer" }}>
                  <X size={20} />
                </button>
              </div>
              {primaryNav}
            </div>
            {bottomNav}
          </div>
        </div>
      )}

      {/* Desktop sidebar — visible at md and up */}
      <aside
        className="hidden md:flex flex-col justify-between"
        style={{ width: 220, height: "100vh", position: "sticky", top: 0, background: COLOR.navyHero, flexShrink: 0, padding: "24px 16px", overflowY: "auto" }}
      >
        <div>
          <p style={{ fontFamily: FONT.sans, fontWeight: 800, fontSize: 14, color: "#fff" }}>ISB</p>
          <p style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 12, color: COLOR.mint, marginTop: 1 }}>Academics</p>
          <div className="mt-8">{primaryNav}</div>
        </div>
        {bottomNav}
      </aside>
    </>
  );
}

function NavItem({
  icon, label, active, onClick, disabled, soon, preview,
}: { icon: React.ReactNode; label: string; active: boolean; onClick: () => void; disabled?: boolean; soon?: boolean; preview?: boolean }) {
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
      {preview && <span style={{ fontSize: 9, fontWeight: 700, color: COLOR.mint, letterSpacing: "0.04em", border: `1px solid ${COLOR.mint}`, borderRadius: 4, padding: "1px 5px" }}>PREVIEW</span>}
    </button>
  );
}
