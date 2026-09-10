import { useEffect, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { usePostHog } from "@posthog/react";
import { X } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useDashboardPopups } from "../hooks/useDashboardPopups";
import { POPUP_ICONS, type PopupIconKey } from "../lib/popupIcons";
import type { DashboardPopup } from "../types";

function storageKey(popup: DashboardPopup) {
  return `popup_dismissed_${popup.slug}`;
}

function isDismissed(popup: DashboardPopup): boolean {
  if (popup.frequency === "always") return false;
  try {
    const store = popup.frequency === "once" ? localStorage : sessionStorage;
    return store.getItem(storageKey(popup)) === "1";
  } catch {
    return false;
  }
}

function markDismissed(popup: DashboardPopup) {
  if (popup.frequency === "always") return;
  try {
    const store = popup.frequency === "once" ? localStorage : sessionStorage;
    store.setItem(storageKey(popup), "1");
  } catch {
    // Storage unavailable (private mode, etc.) — the popup just reappears next visit.
  }
}

// Mounted once in Layout.tsx so it can show on any route. Renders at most one popup at a
// time — the first enabled popup whose `page` prefix matches the current route and hasn't
// already been dismissed per its frequency setting.
export default function PopupManager() {
  const { popups, loading } = useDashboardPopups();
  const location = useLocation();
  const navigate = useNavigate();
  const posthog = usePostHog();
  const [closedSlug, setClosedSlug] = useState<string | null>(null);

  // "always"-frequency popups have no storage record, so closing one only suppresses it for the
  // rest of the current page — arriving fresh (a real navigation, mirroring the old per-page
  // useState(true) behavior) should let it show again.
  useEffect(() => {
    setClosedSlug(null);
  }, [location.pathname]);

  const candidate = loading
    ? null
    : popups.find(
        (p) =>
          p.enabled &&
          p.slug !== closedSlug &&
          location.pathname.startsWith(p.page) &&
          !isDismissed(p)
      ) ?? null;

  useEffect(() => {
    if (candidate) posthog?.capture("popup_shown", { slug: candidate.slug, title: candidate.title });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [candidate?.slug]);

  if (!candidate) return null;

  function dismiss(method: "secondary" | "backdrop" | "close") {
    posthog?.capture("popup_dismissed", { slug: candidate!.slug, method });
    markDismissed(candidate!);
    setClosedSlug(candidate!.slug);
  }

  function handlePrimary() {
    posthog?.capture("popup_cta_clicked", { slug: candidate!.slug, action: candidate!.primary_action });
    markDismissed(candidate!);
    setClosedSlug(candidate!.slug);
    if (candidate!.primary_action === "internal" && candidate!.primary_target) {
      navigate(candidate!.primary_target);
    } else if (candidate!.primary_action === "external" && candidate!.primary_target) {
      window.open(candidate!.primary_target, "_blank", "noopener,noreferrer");
    }
  }

  const Icon = candidate.icon ? POPUP_ICONS[candidate.icon as PopupIconKey] : null;

  return (
    <div style={{ position: "fixed", inset: 0, zIndex: 60, display: "flex", alignItems: "center", justifyContent: "center", padding: 20 }}>
      <div onClick={() => dismiss("backdrop")} style={{ position: "absolute", inset: 0, background: "rgba(0,0,0,0.45)" }} />
      <div style={{ position: "relative", background: COLOR.surface, borderRadius: 14, padding: 24, maxWidth: 380, width: "100%" }}>
        <button
          onClick={() => dismiss("close")}
          aria-label="Dismiss"
          style={{ position: "absolute", top: 14, right: 14, background: "none", border: "none", cursor: "pointer", color: COLOR.ink3 }}
        >
          <X size={16} />
        </button>
        {Icon && (
          <div
            style={{
              width: 40, height: 40, borderRadius: 10, background: COLOR.navyTint,
              color: COLOR.navyHero, display: "flex", alignItems: "center", justifyContent: "center", marginBottom: 14,
            }}
          >
            <Icon size={20} />
          </div>
        )}
        <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 8 }}>
          {candidate.title}
        </p>
        <p style={{ fontSize: 13.5, color: COLOR.ink2, fontFamily: FONT.sans, lineHeight: 1.5, marginBottom: 20 }}>
          {candidate.body}
        </p>
        <div className="flex justify-end gap-2">
          {candidate.secondary_label && (
            <button
              onClick={() => dismiss("secondary")}
              style={{ padding: "8px 14px", borderRadius: 7, border: `1px solid ${COLOR.border}`, background: COLOR.surface, color: COLOR.ink2, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer" }}
            >
              {candidate.secondary_label}
            </button>
          )}
          <button
            onClick={handlePrimary}
            style={{ padding: "8px 14px", borderRadius: 7, border: "none", background: COLOR.navyHero, color: "#fff", fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer" }}
          >
            {candidate.primary_label}
          </button>
        </div>
      </div>
    </div>
  );
}
