import { useEffect, useRef } from "react";

const FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), iframe, [tabindex]:not([tabindex="-1"])';

// Open modals, innermost last. Only the top one reacts to keys, so Escape inside a sheet that
// sits in another modal closes the sheet and leaves the one underneath open.
const openModals: object[] = [];
let scrollLocks = 0;
let overflowBeforeLock = "";

/**
 * Keyboard behaviour every modal needs: Escape closes, Tab stays inside, focus moves in
 * on open and back to whatever opened it on close, and the page behind stops scrolling.
 * Attach the returned ref to the dialog panel (give it tabIndex={-1}).
 */
export function useModalA11y<T extends HTMLElement>(onClose: () => void) {
  const panelRef = useRef<T>(null);
  // Latest onClose without re-running the effect (and re-stealing focus) on every parent render.
  const onCloseRef = useRef(onClose);
  useEffect(() => { onCloseRef.current = onClose; });

  useEffect(() => {
    const panel = panelRef.current;
    const opener = document.activeElement as HTMLElement | null;
    const me = {};
    openModals.push(me);
    if (scrollLocks++ === 0) {
      overflowBeforeLock = document.body.style.overflow;
      document.body.style.overflow = "hidden";
    }
    panel?.focus();

    function onKeyDown(e: KeyboardEvent) {
      if (openModals[openModals.length - 1] !== me) return;
      if (e.key === "Escape") {
        e.preventDefault();
        onCloseRef.current();
        return;
      }
      if (e.key !== "Tab" || !panel) return;
      const items = Array.from(panel.querySelectorAll<HTMLElement>(FOCUSABLE));
      if (items.length === 0) { e.preventDefault(); return; }
      const first = items[0];
      const last = items[items.length - 1];
      const active = document.activeElement;
      if (e.shiftKey && (active === first || active === panel)) { e.preventDefault(); last.focus(); }
      else if (!e.shiftKey && active === last) { e.preventDefault(); first.focus(); }
      else if (!panel.contains(active)) { e.preventDefault(); first.focus(); }
    }

    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.removeEventListener("keydown", onKeyDown);
      openModals.splice(openModals.indexOf(me), 1);
      if (--scrollLocks === 0) document.body.style.overflow = overflowBeforeLock;
      if (opener?.isConnected) opener.focus();
    };
  }, []);

  return panelRef;
}
