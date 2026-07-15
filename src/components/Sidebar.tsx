import { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { ListChecks, ShieldCheck, LogOut, Menu, X, BookOpen, Megaphone, ExternalLink } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useNavLinks } from "../hooks/useNavLinks";
import { NAV_LINK_ICONS, type NavLinkIconKey } from "../lib/navLinkIcons";
import type { User } from "../types";

interface Props {
  user: User;
  onSignOut: () => void;
}

export default function Sidebar({ user, onSignOut }: Props) {
  const [mobileOpen, setMobileOpen] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();
  const { navLinks } = useNavLinks();

  function go(path: string) {
    navigate(path);
    setMobileOpen(false);
  }

  const isActive = (prefix: string) => location.pathname.startsWith(prefix);

  const primaryNav = (
    <nav className="space-y-1">
      <NavItem icon={<ListChecks size={16} />} label="Bidding Planner" active={isActive("/planner")} onClick={() => go("/planner/background")} />
      <NavItem
        icon={<BookOpen size={16} />}
        label="Course Resources"
        active={isActive("/resources")}
        onClick={() => go("/resources")}
        disabled={!user.is_admin}
        soon={!user.is_admin}
        preview={user.is_admin}
      />
      <NavItem
        icon={<Megaphone size={16} />}
        label="Notice Board"
        active={isActive("/notices")}
        onClick={() => go("/notices")}
        disabled={!user.is_admin}
        soon={!user.is_admin}
        preview={user.is_admin}
      />
    </nav>
  );

  const visibleLinks = navLinks.filter((link) => link.visibility === "everyone" || user.is_admin);
  const extraNav = visibleLinks.length > 0 ? (
    <nav className="space-y-1" style={{ marginTop: 12, paddingTop: 12, borderTop: "1px solid rgba(255,255,255,0.15)" }}>
      {visibleLinks.map((link) => {
        const Icon = NAV_LINK_ICONS[link.icon as NavLinkIconKey];
        return link.link_type === "external" ? (
          <ExternalNavItem key={link.id} icon={<Icon size={16} />} label={link.label} href={link.href} />
        ) : (
          <NavItem key={link.id} icon={<Icon size={16} />} label={link.label} active={isActive(link.href)} onClick={() => go(link.href)} />
        );
      })}
    </nav>
  ) : null;

  const bottomNav = (
    <div>
      {user.is_admin && (
        <NavItem icon={<ShieldCheck size={16} />} label="Admin" active={isActive("/admin")} onClick={() => go("/admin/overview")} />
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
              {extraNav}
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
          {extraNav}
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

/** Same look as NavItem, but an actual link that opens the tool in a new tab instead of routing internally. */
function ExternalNavItem({ icon, label, href }: { icon: React.ReactNode; label: string; href: string }) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      style={{
        width: "100%", display: "flex", alignItems: "center", gap: 10, padding: "9px 10px", borderRadius: 8,
        background: "transparent", color: "#fff", fontFamily: FONT.sans, fontSize: 13, fontWeight: 600, textAlign: "left", textDecoration: "none",
      }}
    >
      {icon}
      <span style={{ flex: 1 }}>{label}</span>
      <ExternalLink size={12} color="rgba(255,255,255,0.5)" />
    </a>
  );
}
