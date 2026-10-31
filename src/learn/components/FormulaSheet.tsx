import { useState } from "react";
import { Markdown } from "./Markdown";
import { useModalA11y } from "../../hooks/useModalA11y";

interface Props {
  /** Markdown formula reference for the session the current question belongs to. */
  sheet: string;
  session: number;
  title?: string | null;
}

/**
 * Formulas stay open during practice on purpose. The exam is open-notes, so testing recall of
 * "what is the formula" measures the wrong thing — what is worth practising is picking the right
 * one and applying it under time pressure.
 */
export function FormulaSheet({ sheet, session, title }: Props) {
  const [open, setOpen] = useState(false);

  return (
    <>
      {/* Sits clear of the mobile tab bar (3.25rem + safe area) rather than behind it. */}
      <button
        onClick={() => setOpen(true)}
        className="fixed right-5 z-30 btn btn-primary shadow-[0_6px_20px_-6px_rgba(36,91,255,0.6)]
          bottom-[calc(4.5rem+env(safe-area-inset-bottom))] md:bottom-5"
        aria-haspopup="dialog"
      >
        <span aria-hidden="true">∑</span> Formula sheet
      </button>

      {open && <FormulaSheetDialog sheet={sheet} session={session} title={title} onClose={() => setOpen(false)} />}
    </>
  );
}

function FormulaSheetDialog({ sheet, session, title, onClose }: Props & { onClose: () => void }) {
  const dialogRef = useModalA11y<HTMLDivElement>(onClose);
  return (
        <div ref={dialogRef} tabIndex={-1} className="fixed inset-0 z-40 flex justify-end" role="dialog" aria-modal="true"
          aria-label={`Formula sheet for session ${session}`}>
          {/* Mouse-only target: Escape and the Close button are the keyboard routes, so this
              stays out of the Tab order rather than being the first stop in the dialog. */}
          <button
            className="absolute inset-0 bg-ink/30 backdrop-blur-[2px]"
            onClick={onClose}
            tabIndex={-1}
            aria-label="Close formula sheet"
          />
          <div className="relative w-full sm:max-w-md bg-surface border-l border-line h-full overflow-y-auto
            shadow-[-8px_0_32px_-12px_rgba(0,0,0,0.25)] slide-in-right">
            <div className="sticky top-0 bg-surface border-b border-line px-5 py-3.5 flex items-center justify-between gap-3">
              <div className="min-w-0">
                <div className="text-[10px] uppercase tracking-wide text-accent font-bold">
                  Session {session} formulas
                </div>
                {title && <div className="font-semibold text-sm truncate">{title}</div>}
              </div>
              <button onClick={onClose} className="btn btn-ghost px-2.5 py-1.5 shrink-0">
                Close
              </button>
            </div>
            <div className="px-5 py-4">
              <Markdown text={sheet} className="text-sm leading-relaxed" />
            </div>
          </div>
        </div>
  );
}
