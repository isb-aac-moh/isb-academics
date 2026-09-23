/** Shown whenever demoLinkGuard.ts intercepts a click that would leave the demo — explains that
    the button is real, it's just pointed at ISB-internal course material behind an @isb.edu login. */
import { useEffect, useState } from "react";
import { DEMO_BLOCKED_LINK_EVENT } from "../lib/demoLinkGuard";
import { COLOR, FONT } from "../lib/theme";

export default function DemoExternalLinkModal() {
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const handler = () => setOpen(true);
    window.addEventListener(DEMO_BLOCKED_LINK_EVENT, handler);
    return () => window.removeEventListener(DEMO_BLOCKED_LINK_EVENT, handler);
  }, []);

  if (!open) return null;

  return (
    <div style={{ position: "fixed", inset: 0, zIndex: 80, display: "flex", alignItems: "center", justifyContent: "center", padding: 20 }}>
      <div onClick={() => setOpen(false)} style={{ position: "absolute", inset: 0, background: "rgba(0,0,0,0.45)" }} />
      <div style={{ position: "relative", background: COLOR.surface, borderRadius: 14, padding: 24, maxWidth: 380, width: "100%" }}>
        <p style={{ fontSize: 16, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 8 }}>
          This button is real — the file is the part that's gated
        </p>
        <p style={{ fontSize: 13.5, color: COLOR.ink2, fontFamily: FONT.sans, lineHeight: 1.5, marginBottom: 20 }}>
          In the live product this opens actual course material — hosted on ISB's systems and
          restricted to signed-in @isb.edu accounts. This demo runs standalone with no ISB login
          behind it, so following the link would just land on a sign-in wall. Everything else on
          this page works exactly as it does for a real student.
        </p>
        <div className="flex justify-end">
          <button
            onClick={() => setOpen(false)}
            style={{ padding: "8px 14px", borderRadius: 7, border: "none", background: COLOR.navyHero, color: "#fff", fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer" }}
          >
            Got it
          </button>
        </div>
      </div>
    </div>
  );
}
