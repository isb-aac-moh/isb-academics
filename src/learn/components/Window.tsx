import { useEffect } from "react";
import { CloseIcon } from "./icons";

interface Props {
  title: string;
  onClose: () => void;
  children: React.ReactNode;
}

/** Floating "window" that opens on top of the Home desktop — Home stays mounted and visible
    behind it (peeking around the edges on desktop), matching the icons-stay-visible pattern
    approved during design. Full-screen on mobile, where there's no room for edges to peek. */
export function Window({ title, onClose, children }: Props) {
  useEffect(() => {
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") onClose();
    }
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  return (
    <div
      className="fixed inset-0 md:inset-x-[6%] md:top-20 md:bottom-6 md:max-w-[1180px] md:mx-auto z-30
        bg-base md:rounded-2xl md:shadow-[0_24px_60px_-16px_rgba(33,28,21,0.45)] overflow-hidden
        flex flex-col rise-in"
    >
      <div className="flex items-center justify-between px-4 py-2.5 border-b border-line bg-surface shrink-0">
        <span className="text-sm font-medium text-ink-soft">{title}</span>
        <button
          onClick={onClose}
          aria-label="Close"
          className="p-1 rounded-lg text-ink-soft hover:text-ink hover:bg-surface-2 transition-colors"
        >
          <CloseIcon className="w-4 h-4" />
        </button>
      </div>
      {/* Reserve room for the mobile tab bar so the last line of content is never trapped behind it. */}
      <div className="flex-1 min-h-0 overflow-y-auto pb-[calc(3.25rem+env(safe-area-inset-bottom))] md:pb-0">
        {children}
      </div>
    </div>
  );
}
