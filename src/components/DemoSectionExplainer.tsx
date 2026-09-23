/** Demo-only: a short explainer at the top of a section the first time a recruiter navigates into
    it from the sidebar — what the section is, and what a student actually does there. Replaces a
    single always-on banner with something scoped to wherever they actually clicked (see
    lib/demoExplainers.ts for the copy, one entry per sidebar item). */
import { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import { Info, X } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { isDemoMode } from "../lib/demoMode";
import { findExplainer } from "../lib/demoExplainers";

function seenKey(id: string) {
  return `demo_explainer_seen_${id}`;
}

export default function DemoSectionExplainer() {
  const location = useLocation();
  const explainer = isDemoMode() ? findExplainer(location.pathname) : undefined;
  const [dismissedId, setDismissedId] = useState<string | null>(null);

  useEffect(() => {
    if (!explainer) return;
    try {
      if (sessionStorage.getItem(seenKey(explainer.id)) === "1") setDismissedId(explainer.id);
    } catch {
      // ignore
    }
    // Only re-check when the matched section changes, not on every keystroke-level route update.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [explainer?.id]);

  if (!explainer || dismissedId === explainer.id) return null;

  function dismiss() {
    if (!explainer) return;
    setDismissedId(explainer.id);
    try {
      sessionStorage.setItem(seenKey(explainer.id), "1");
    } catch {
      // ignore
    }
  }

  return (
    <div style={{ background: COLOR.navyTint, borderBottom: `1px solid ${COLOR.border}`, padding: "14px 20px" }}>
      <div className="flex items-start gap-3" style={{ maxWidth: 900, margin: "0 auto" }}>
        <div style={{ flexShrink: 0, width: 26, height: 26, borderRadius: 8, background: COLOR.navyHero, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", marginTop: 1 }}>
          <Info size={14} />
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <p style={{ fontFamily: FONT.sans, fontSize: 13, fontWeight: 700, color: COLOR.ink }}>{explainer.title}</p>
          <p style={{ fontFamily: FONT.sans, fontSize: 12.5, color: COLOR.ink2, marginTop: 3, lineHeight: 1.5 }}>{explainer.whatItIs}</p>
          <p style={{ fontFamily: FONT.sans, fontSize: 12.5, color: COLOR.ink2, marginTop: 4, lineHeight: 1.5 }}>
            <span style={{ fontWeight: 700, color: COLOR.ink }}>What students do here — </span>
            {explainer.whatStudentsDo}
          </p>
        </div>
        <button
          onClick={dismiss}
          aria-label="Dismiss"
          style={{ flexShrink: 0, background: "none", border: "none", color: COLOR.ink3, cursor: "pointer", padding: 4 }}
        >
          <X size={15} />
        </button>
      </div>
    </div>
  );
}
