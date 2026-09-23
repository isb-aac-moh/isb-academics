// Demo mode keeps every real external link and "view file" button in place — the point is to show
// the feature, not hide it — but following one would just land a recruiter on a login wall or a
// domain that doesn't exist. So in demo mode only, this intercepts the two ways the app leaves the
// page (an <a target="_blank"> to another origin, and window.open() for a signed file URL) and
// explains why instead of navigating. DemoExternalLinkModal.tsx renders the explanation.
import { isDemoMode } from "./demoMode";

export const DEMO_BLOCKED_LINK_EVENT = "demo:blocked-external-link";

let installed = false;

export function installDemoLinkGuard(): void {
  if (installed || !isDemoMode() || typeof window === "undefined") return;
  installed = true;

  function announce() {
    window.dispatchEvent(new CustomEvent(DEMO_BLOCKED_LINK_EVENT));
  }

  window.open = (() => {
    announce();
    return null;
  }) as typeof window.open;

  // Capture phase, so this runs before the anchor's own default navigation.
  document.addEventListener(
    "click",
    (e) => {
      if (!(e.target instanceof Element)) return;
      const anchor = e.target.closest("a[href]");
      if (!anchor) return;
      const href = anchor.getAttribute("href") ?? "";
      if (!/^https?:\/\//i.test(href)) return; // relative/in-app links are never touched
      let isExternal = true;
      try {
        isExternal = new URL(href, window.location.href).origin !== window.location.origin;
      } catch {
        isExternal = true;
      }
      if (!isExternal) return;
      e.preventDefault();
      e.stopPropagation();
      announce();
    },
    true,
  );
}
