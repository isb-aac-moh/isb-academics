import { useEffect, useState } from "react";
import { createPortal } from "react-dom";
import { useLocation, useNavigate } from "react-router-dom";
import { ListChecks, ShieldCheck, LogOut, Menu, X, BookOpen, Megaphone, ExternalLink, Activity, GraduationCap, PanelLeftClose, PanelLeftOpen, Brain, LayoutGrid, Compass as CompassIcon } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { isDemoMode } from "../lib/demoMode";
import { useNavLinks } from "../hooks/useNavLinks";
import { NAV_LINK_ICONS, type NavLinkIconKey } from "../lib/navLinkIcons";
import type { User } from "../types";

interface Props {
  user: User;
  onSignOut: () => void;
}

export default function Sidebar({ user, onSignOut }: Props) {
  const [mobileOpen, setMobileOpen] = useState(false);
  const [collapsed, setCollapsed] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();
  const { navLinks } = useNavLinks();
  const signOutLabel = isDemoMode() ? "Exit demo" : "Sign out";

  function go(path: string) {
    navigate(path);
    setMobileOpen(false);
  }

  const isActive = (prefix: string) => location.pathname === prefix || location.pathname.startsWith(prefix + "/");

  // Learn is a full-bleed desktop with its own floating windows, so it wants the width. Collapse
  // to the icon rail on the way in and restore on the way out — still overridable by the toggle,
  // since this only fires when crossing the boundary, not on every render inside the section.
  const inLearn = isActive("/learn");
  useEffect(() => {
    setCollapsed(inLearn);
  }, [inLearn]);

  // Built as functions of (collapsed, onLight) rather than fixed elements, because the same nav
  // is rendered twice with different needs: the mobile drawer always wants full labels even while
  // the desktop rail is collapsed, and the collapsed rail is light-on-white while everything else
  // is white-on-navy.
  const primaryNav = (collapsed: boolean, onLight: boolean) => (
    <nav className="space-y-1">
      <NavItem icon={<Brain size={16} />} label="Learn" active={isActive("/learn")} onClick={() => go("/learn")} collapsed={collapsed} onLight={onLight} />
      {/* Admin-only pilot. Hidden for students and in the recruiter demo (the demo has no Compass data). */}
      {user.is_admin && !isDemoMode() && <NavItem icon={<CompassIcon size={16} />} label="Compass" active={isActive("/compass")} onClick={() => go("/compass")} preview collapsed={collapsed} onLight={onLight} />}
      <NavItem icon={<GraduationCap size={16} />} label="Credit Tracker" active={isActive("/tracker")} onClick={() => go("/tracker")} collapsed={collapsed} onLight={onLight} />
      <NavItem icon={<ListChecks size={16} />} label="Bidding Planner" active={isActive("/planner")} onClick={() => go("/planner/background")} collapsed={collapsed} onLight={onLight} />
      <NavItem icon={<Activity size={16} />} label="Bidding Pulse" active={isActive("/pulse-check")} onClick={() => go("/pulse-check")} collapsed={collapsed} onLight={onLight} />
      <NavItem icon={<BookOpen size={16} />} label="Course Resources" active={isActive("/resources")} onClick={() => go("/resources")} collapsed={collapsed} onLight={onLight} />
      <NavItem
        icon={<Megaphone size={16} />}
        label="Notice Board"
        active={isActive("/notices")}
        onClick={() => go("/notices")}
        disabled={!user.is_admin}
        soon={!user.is_admin}
        preview={user.is_admin}
        collapsed={collapsed}
        onLight={onLight}
      />
    </nav>
  );

  const visibleLinks = navLinks.filter((link) => link.visibility === "everyone" || user.is_admin);
  // Term after term, admins add more of these — cap what shows in the rail so
  // it doesn't grow unbounded, and point the rest at Course Resources, where
  // every link added here is already mirrored (see AdminPage's NavLinksAdmin).
  const visibleCap = 4;
  const shownLinks = visibleLinks.slice(0, visibleCap);
  const overflowCount = visibleLinks.length - shownLinks.length;
  const extraNav = (collapsed: boolean, onLight: boolean) => visibleLinks.length > 0 ? (
    <nav className="space-y-1" style={{ marginTop: 12, paddingTop: 12, borderTop: `1px solid ${onLight ? COLOR.border : "rgba(255,255,255,0.15)"}` }}>
      {shownLinks.map((link) => {
        const Icon = NAV_LINK_ICONS[link.icon as NavLinkIconKey];
        return link.link_type === "external" ? (
          <ExternalNavItem key={link.id} icon={<Icon size={16} />} label={link.label} href={link.href} collapsed={collapsed} onLight={onLight} />
        ) : (
          <NavItem key={link.id} icon={<Icon size={16} />} label={link.label} active={isActive(link.href)} onClick={() => go(link.href)} collapsed={collapsed} onLight={onLight} />
        );
      })}
      {overflowCount > 0 && (
        <NavItem
          icon={<LayoutGrid size={16} />}
          label={`${overflowCount} more in Resources`}
          active={false}
          onClick={() => go("/resources")}
          collapsed={collapsed}
          onLight={onLight}
        />
      )}
    </nav>
  ) : null;

  const bottomNav = (collapsed: boolean, onLight: boolean) => (
    <div>
      {user.is_admin && (
        <NavItem icon={<ShieldCheck size={16} />} label="Admin" active={isActive("/admin")} onClick={() => go("/admin/overview")} collapsed={collapsed} onLight={onLight} />
      )}
      <div style={{ borderTop: `1px solid ${onLight ? COLOR.border : "rgba(255,255,255,0.15)"}`, marginTop: 12, paddingTop: 12 }}>
        {!collapsed && (
          <p style={{ fontFamily: FONT.sans, fontSize: 12, color: onLight ? COLOR.ink2 : "rgba(255,255,255,0.85)", fontWeight: 600, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
            {user.name || user.email}
          </p>
        )}
        <WithRailLabel label={signOutLabel} enabled={collapsed}>
          <button
            onClick={onSignOut}
            aria-label={collapsed ? signOutLabel : undefined}
            style={{
              display: "flex", alignItems: "center", gap: 6, marginTop: collapsed ? 0 : 8, justifyContent: collapsed ? "center" : "flex-start",
              width: "100%", background: "none", border: "none", color: onLight ? COLOR.ink3 : "rgba(255,255,255,0.6)", fontFamily: FONT.sans, fontSize: 12, cursor: "pointer", padding: 0,
            }}
          >
            <LogOut size={13} /> {!collapsed && signOutLabel}
          </button>
        </WithRailLabel>
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
                  <p style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 12, color: COLOR.mint, marginTop: 1 }}>
                    Academics {isDemoMode() && <DemoBadge />}
                  </p>
                </div>
                <button onClick={() => setMobileOpen(false)} aria-label="Close menu" style={{ background: "none", border: "none", color: "#fff", cursor: "pointer" }}>
                  <X size={20} />
                </button>
              </div>
              {/* Always expanded: the drawer has the room, and hiding labels here because the
                  desktop rail happens to be collapsed left it as a column of unlabelled icons. */}
              {primaryNav(false, false)}
              {extraNav(false, false)}
            </div>
            {bottomNav(false, false)}
          </div>
        </div>
      )}

      {/* Desktop sidebar — visible at md and up. Collapsed it goes white with a hairline border:
          as a narrow navy column against a page it reads as a heavy stripe rather than a rail. */}
      <aside
        className="hidden md:flex flex-col justify-between"
        style={{
          width: collapsed ? 72 : 220, height: "100vh", position: "sticky", top: 0,
          background: collapsed ? COLOR.surface : COLOR.navyHero,
          borderRight: collapsed ? `1px solid ${COLOR.border}` : "none",
          flexShrink: 0,
          padding: "24px 12px", overflowY: "auto", overflowX: "hidden",
          transition: "width 0.2s ease, background 0.2s ease",
        }}
      >
        <div>
          <div className="flex items-center justify-between" style={{ paddingLeft: collapsed ? 0 : 4, justifyContent: collapsed ? "center" : "space-between" }}>
            {!collapsed && (
              <div>
                <p style={{ fontFamily: FONT.sans, fontWeight: 800, fontSize: 14, color: "#fff" }}>ISB</p>
                <p style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 12, color: COLOR.mint, marginTop: 1 }}>
                  Academics {isDemoMode() && <DemoBadge />}
                </p>
              </div>
            )}
            <WithRailLabel label="Expand sidebar" enabled={collapsed}>
              <button
                onClick={() => setCollapsed((c) => !c)}
                aria-label={collapsed ? "Expand sidebar" : "Collapse sidebar"}
                title={collapsed ? undefined : "Collapse sidebar"}
                style={{ background: "none", border: "none", color: collapsed ? COLOR.ink3 : "rgba(255,255,255,0.6)", padding: 4, cursor: "pointer", display: "flex" }}
              >
                {collapsed ? <PanelLeftOpen size={18} /> : <PanelLeftClose size={18} />}
              </button>
            </WithRailLabel>
          </div>
          <div className="mt-8">{primaryNav(collapsed, collapsed)}</div>
          {extraNav(collapsed, collapsed)}
        </div>
        {bottomNav(collapsed, collapsed)}
      </aside>
    </>
  );
}

/**
 * Hover/focus label for the collapsed rail, where every item is an icon with no text beside it.
 *
 * Two things force this to be `position: fixed` and measured from the trigger, rather than the
 * usual absolutely-positioned tooltip: the sidebar sets `overflowX: hidden` for the width
 * animation, which would slice a label off at the 72px edge, and it also scrolls vertically.
 *
 * The handlers live on a wrapper rather than the control itself because `disabled` buttons — Notice
 * Board, for non-admins — emit no pointer events, and that is exactly the item whose label a
 * student most needs.
 */
function useRailLabel(enabled: boolean) {
  const [pos, setPos] = useState<{ top: number; left: number } | null>(null);

  const open = (e: React.SyntheticEvent<HTMLElement>) => {
    const r = e.currentTarget.getBoundingClientRect();
    // Anchor to the rail's outer edge, not the item's: the rail is padded, so measuring from the
    // item put every label a few pixels back over the icons instead of clear of them. Anchoring to
    // the sidebar also lines all the labels up in one column.
    const rail = e.currentTarget.closest("aside");
    const anchorRight = rail ? rail.getBoundingClientRect().right : r.right;
    setPos({ top: Math.round(r.top + r.height / 2), left: Math.round(anchorRight + 8) });
  };
  const close = () => setPos(null);

  if (!enabled) return { pos: null, bind: {} as Record<string, never> };
  return { pos, bind: { onMouseEnter: open, onMouseLeave: close, onFocus: open, onBlur: close } };
}

function WithRailLabel({ label, enabled, children }: { label: string; enabled: boolean; children: React.ReactNode }) {
  const { pos, bind } = useRailLabel(enabled);
  return (
    <span style={{ display: "block" }} {...bind}>
      {children}
      {/* Portalled to body rather than rendered in place. The sidebar is position: sticky, which
          makes it a stacking context, so a z-index here could never rise above the Learn section —
          that element carries a transform and comes later in the DOM, so it painted over the label
          no matter how high the z-index went. */}
      {enabled && pos && createPortal(
        <span
          role="tooltip"
          style={{
            position: "fixed", top: pos.top, left: pos.left, transform: "translateY(-50%)",
            background: COLOR.navy, color: "#fff", fontFamily: FONT.sans, fontSize: 12, fontWeight: 600,
            padding: "5px 9px", borderRadius: 6, whiteSpace: "nowrap", pointerEvents: "none", zIndex: 60,
            boxShadow: "0 4px 14px -4px rgba(0,0,0,0.4)",
          }}
        >
          {label}
        </span>,
        document.body,
      )}
    </span>
  );
}

/** `onLight` switches the item onto the white collapsed rail; everywhere else it is on navy. */
function NavItem({
  icon, label, active, onClick, disabled, soon, preview, collapsed, onLight,
}: { icon: React.ReactNode; label: string; active: boolean; onClick: () => void; disabled?: boolean; soon?: boolean; preview?: boolean; collapsed?: boolean; onLight?: boolean }) {
  const activeBg = onLight ? COLOR.navyTint : "rgba(255,255,255,0.12)";
  const fg = disabled
    ? (onLight ? COLOR.ink3 : "rgba(255,255,255,0.35)")
    : active && onLight ? COLOR.navy
    : onLight ? COLOR.ink2
    : "#fff";
  const badge = onLight ? COLOR.amber : COLOR.mint;
  // Collapsing hides the SOON/PREVIEW badge too, so the hover label carries that state instead of
  // leaving a disabled icon with no explanation for why it does nothing.
  const hoverLabel = soon ? `${label} · coming soon` : preview ? `${label} · admin preview` : label;
  return (
    <WithRailLabel label={hoverLabel} enabled={!!collapsed}>
      <button
        onClick={onClick}
        disabled={disabled}
        aria-label={collapsed ? hoverLabel : undefined}
        style={{
          width: "100%", display: "flex", alignItems: "center", gap: 10, padding: collapsed ? "9px" : "9px 10px", borderRadius: 8,
          justifyContent: collapsed ? "center" : "flex-start",
          background: active ? activeBg : "transparent", border: "none", cursor: disabled ? "default" : "pointer",
          color: fg, fontFamily: FONT.sans, fontSize: 13, fontWeight: 600, textAlign: "left",
        }}
      >
        {icon}
        {!collapsed && (
          <>
            <span style={{ flex: 1 }}>{label}</span>
            {soon && <span style={{ fontSize: 9, fontWeight: 700, color: badge, letterSpacing: "0.04em" }}>SOON</span>}
            {preview && <span style={{ fontSize: 9, fontWeight: 700, color: badge, letterSpacing: "0.04em", border: `1px solid ${badge}`, borderRadius: 4, padding: "1px 5px" }}>PREVIEW</span>}
          </>
        )}
      </button>
    </WithRailLabel>
  );
}

/** Same look as NavItem, but an actual link that opens the tool in a new tab instead of routing internally. */
function ExternalNavItem({ icon, label, href, collapsed, onLight }: { icon: React.ReactNode; label: string; href: string; collapsed?: boolean; onLight?: boolean }) {
  return (
    <WithRailLabel label={`${label} · opens in a new tab`} enabled={!!collapsed}>
      <a
        href={href}
        target="_blank"
        rel="noopener noreferrer"
        aria-label={collapsed ? `${label} (opens in a new tab)` : undefined}
        style={{
          width: "100%", display: "flex", alignItems: "center", gap: 10, padding: collapsed ? "9px" : "9px 10px", borderRadius: 8,
          justifyContent: collapsed ? "center" : "flex-start",
          background: "transparent", color: onLight ? COLOR.ink2 : "#fff", fontFamily: FONT.sans, fontSize: 13, fontWeight: 600, textAlign: "left", textDecoration: "none",
        }}
      >
        {icon}
        {!collapsed && (
          <>
            <span style={{ flex: 1 }}>{label}</span>
            <ExternalLink size={12} color={onLight ? COLOR.ink3 : "rgba(255,255,255,0.5)"} />
          </>
        )}
      </a>
    </WithRailLabel>
  );
}

function DemoBadge() {
  return (
    <span
      style={{
        display: "inline-block", marginLeft: 4, fontSize: 9, fontWeight: 800, letterSpacing: "0.06em",
        color: COLOR.navyHero, background: COLOR.mint, borderRadius: 4, padding: "1px 5px", verticalAlign: "middle",
      }}
    >
      DEMO
    </span>
  );
}
