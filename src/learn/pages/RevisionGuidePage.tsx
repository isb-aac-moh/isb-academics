import { useState } from "react";
import { createPortal } from "react-dom";
import { useNavigate, useParams } from "react-router-dom";
import { getRevisionGuide } from "../lib/revisionGuides";
import { ChevronRightIcon, CompassIcon } from "../components/icons";

/**
 * End-term revision guides, one session at a time.
 *
 * The landing view lists the guide's sessions; picking one swaps in that session's document. Each
 * document is a finished standalone HTML page (see lib/revisionGuides.ts), so it is shown in an
 * iframe exactly as written rather than being re-styled into the app's design system — the same
 * treatment the Term 4 Dossier gets. The tab rail above it stays put so switching sessions never
 * means going back first. "Open full screen" is there for the phone, where the guide's own layout
 * wants the whole viewport — it expands the iframe in place (rather than a new tab, which some
 * embedded/mobile contexts can't navigate back out of) and leaves a pinned exit button over the
 * iframe so shrinking back down never depends on the guide's own UI. It's portalled to
 * document.body because this page is always mounted inside Window (components/Window.tsx), whose
 * entrance animation leaves a permanent `transform` on that floating frame — a `position: fixed`
 * child of it is contained and clipped to that frame's box, not the real viewport.
 */
export function RevisionGuidePage() {
  const navigate = useNavigate();
  const params = useParams<{ course: string; session?: string }>();
  const guide = getRevisionGuide(params.course);
  const [fullscreen, setFullscreen] = useState(false);

  if (!guide) {
    return (
      <div className="px-5 py-8 md:px-8 md:py-10">
        <h1 className="text-2xl font-bold mb-1.5">No guide here</h1>
        <p className="text-ink-soft">There is no revision guide for that course yet.</p>
      </div>
    );
  }

  const active = params.session ? guide.sessions.find((s) => s.slug === params.session) : undefined;
  const base = `/learn/revision/${guide.course}`;

  if (!active) {
    return (
      <div className="px-5 py-8 md:px-8 md:py-10 max-w-3xl rise-in">
        <div className="flex items-center gap-2.5 mb-1.5">
          <CompassIcon className="w-6 h-6 text-accent shrink-0" />
          <h1 className="text-2xl font-bold tracking-[-0.02em]">{guide.title}</h1>
        </div>
        <p className="text-ink-soft mb-7 max-w-2xl leading-relaxed">{guide.subtitle}</p>

        <div className="grid gap-3">
          {guide.sessions.map((s) => (
            <button
              key={s.slug}
              onClick={() => navigate(`${base}/${s.slug}`)}
              className="card card-hover text-left p-5 flex items-start justify-between gap-4"
            >
              <span className="min-w-0">
                <span className="block text-[10px] uppercase tracking-wide text-accent font-bold mb-1">
                  {s.label}
                </span>
                <span className="block font-semibold mb-1">{s.title}</span>
                <span className="block text-sm text-ink-soft leading-relaxed">{s.blurb}</span>
              </span>
              <ChevronRightIcon className="shrink-0 text-ink-soft mt-0.5" />
            </button>
          ))}
        </div>
      </div>
    );
  }

  if (fullscreen) {
    return createPortal(
      <div className="fixed inset-0 z-[200] bg-surface flex flex-col">
        <button
          onClick={() => setFullscreen(false)}
          className="fixed top-3 right-3 z-[210] text-xs font-semibold text-white bg-ink/80 backdrop-blur px-3 py-1.5 rounded-full shadow-lg hover:bg-ink"
        >
          ✕ Exit full screen
        </button>
        <iframe
          key={active.slug}
          src={active.file}
          title={`${active.label} — ${active.title}`}
          className="flex-1 min-h-0 w-full border-0 block"
        />
      </div>,
      document.body,
    );
  }

  return (
    <div className="flex flex-col h-full">
      <div className="shrink-0 border-b border-line bg-surface px-3 py-2 flex items-center gap-2 overflow-x-auto">
        <button
          onClick={() => navigate(base)}
          className="shrink-0 text-xs font-semibold text-ink-soft hover:text-ink px-2 py-1.5 rounded-lg hover:bg-surface-2 transition-colors"
        >
          ← All sessions
        </button>
        <span className="shrink-0 w-px h-4 bg-line" aria-hidden="true" />
        {guide.sessions.map((s) => (
          <button
            key={s.slug}
            onClick={() => navigate(`${base}/${s.slug}`)}
            aria-current={s.slug === active.slug ? "page" : undefined}
            className={[
              "shrink-0 text-xs font-semibold px-2.5 py-1.5 rounded-lg transition-colors",
              s.slug === active.slug
                ? "bg-accent text-accent-ink"
                : "text-ink-soft hover:text-ink hover:bg-surface-2",
            ].join(" ")}
          >
            {s.label}
          </button>
        ))}
        <button
          onClick={() => setFullscreen(true)}
          className="shrink-0 ml-auto text-xs font-semibold text-accent hover:underline px-2 py-1.5"
        >
          Open full screen ↗
        </button>
      </div>
      <iframe
        key={active.slug}
        src={active.file}
        title={`${active.label} — ${active.title}`}
        className="flex-1 min-h-0 w-full border-0 block"
      />
    </div>
  );
}
