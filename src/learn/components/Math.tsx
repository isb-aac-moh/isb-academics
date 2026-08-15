import { useEffect, useState } from "react";

/**
 * KaTeX, loaded as a separate chunk. Formulas are the point of this app, and hand-rolled text like
 * "min[(30 - 21.38)/7.73, ...]" is genuinely hard to read — real fraction bars, proper radicals
 * and correct symbol spacing are what make an expression scannable.
 *
 * The import stays dynamic to keep KaTeX's ~280KB out of the main bundle, but it is kicked off when
 * this module is evaluated rather than when the first <Math> mounts. Waiting for the mount meant the
 * download only started *after* the content had been fetched and painted, so every equation on the
 * page sat there as raw TeX for the length of that download — which reads as broken rather than as
 * loading. Starting here overlaps it with the data fetch instead.
 *
 * Until it resolves, and if it ultimately fails, the raw source renders in a monospace face, which
 * stays readable rather than blank.
 */

type Renderer = (tex: string, opts: { displayMode: boolean; throwOnError: boolean; output: string }) => string;

let cached: Renderer | null = null;
let pending: Promise<Renderer> | null = null;

function loadKatex(): Promise<Renderer> {
  if (cached) return Promise.resolve(cached);
  if (!pending) {
    pending = Promise.all([import("katex"), import("katex/dist/katex.min.css")])
      .then(([mod]) => {
        cached = (mod.default ?? mod).renderToString as Renderer;
        return cached;
      })
      .catch((err: unknown) => {
        // Clearing `pending` is the point: a rejected promise left cached here would be handed to
        // every future <Math> for the rest of the session, so one flaky chunk fetch would turn all
        // maths on every page into raw TeX until a full reload. Dropping it lets the next mount retry.
        pending = null;
        throw err;
      });
  }
  return pending;
}

// Warm the chunk as early as the module graph allows. The rejection is swallowed because this call
// is only a head start — the real load, and its error handling, belong to the component below.
void loadKatex().catch(() => {});

interface Props {
  tex: string;
  display?: boolean;
}

export function Math({ tex, display = false }: Props) {
  const [html, setHtml] = useState<string | null>(() =>
    cached ? cached(tex, { displayMode: display, throwOnError: false, output: "html" }) : null,
  );

  useEffect(() => {
    let alive = true;
    void loadKatex().then(
      (render) => {
        if (alive) setHtml(render(tex, { displayMode: display, throwOnError: false, output: "html" }));
      },
      () => {
        // Deliberately left null so the raw-source fallback stands in. loadKatex has already dropped
        // its cached promise, so the next <Math> to mount starts a fresh attempt.
      },
    );
    return () => {
      alive = false;
    };
  }, [tex, display]);

  if (html === null) {
    return (
      <span className={`font-mono text-[0.9em] text-ink-soft ${display ? "block my-4" : ""}`}>{tex}</span>
    );
  }

  return display ? (
    <div
      className="my-5 overflow-x-auto overflow-y-hidden py-1 text-ink"
      dangerouslySetInnerHTML={{ __html: html }}
    />
  ) : (
    <span className="text-ink" dangerouslySetInnerHTML={{ __html: html }} />
  );
}
