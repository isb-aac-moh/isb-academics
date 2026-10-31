import { useModalA11y } from "../hooks/useModalA11y";
import { COLOR } from "../lib/theme";

/** The centred card popup used for notices, confirmations and the demo explainer: dark backdrop,
    Escape or a backdrop click closes it, and it behaves as a proper dialog for keyboard and
    screen-reader users. Mount it only while open. */
export function ModalCard({ label, onClose, onBackdrop = onClose, role = "dialog", zIndex = 60, children }: {
  label: string; onClose: () => void; onBackdrop?: () => void; role?: "dialog" | "alertdialog"; zIndex?: number; children: React.ReactNode;
}) {
  const cardRef = useModalA11y<HTMLDivElement>(onClose);
  return (
    <div style={{ position: "fixed", inset: 0, zIndex, display: "flex", alignItems: "center", justifyContent: "center", padding: 20 }}>
      <div aria-hidden="true" onClick={onBackdrop} style={{ position: "absolute", inset: 0, background: "rgba(0,0,0,0.45)" }} />
      <div
        ref={cardRef}
        role={role}
        aria-modal="true"
        aria-label={label}
        tabIndex={-1}
        style={{ position: "relative", background: COLOR.surface, borderRadius: 14, padding: 24, maxWidth: 380, width: "100%" }}
      >
        {children}
      </div>
    </div>
  );
}
