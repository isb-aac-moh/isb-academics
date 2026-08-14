import { useEffect, useState } from "react";

/**
 * KaTeX, loaded on demand. Formulas are the point of this app, and hand-rolled text like
 * "min[(30 - 21.38)/7.73, ...]" is genuinely hard to read — real fraction bars, proper radicals
 * and correct symbol spacing are what make an expression scannable.
 *
 * The import is dynamic so the ~280KB of KaTeX plus its fonts only load on a page that actually
 * contains a formula, keeping the main bundle where it was. Until it resolves (and if it fails)
 * the raw source renders in a monospace face, which stays readable rather than blank.
 */

type Renderer = (tex: string, opts: { displayMode: boolean; throwOnError: boolean; output: string }) => string;

let cached: Renderer | null = null;
let pending: Promise<Renderer> | null = null;

function loadKatex(): Promise<Renderer> {
  if (cached) return Promise.resolve(cached);
  if (!pending) {
    pending = Promise.all([import("katex"), import("katex/dist/katex.min.css")]).then(([mod]) => {
      cached = (mod.default ?? mod).renderToString as Renderer;
      return cached;
    });
  }
  return pending;
}

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
    void loadKatex().then((render) => {
      if (alive) setHtml(render(tex, { displayMode: display, throwOnError: false, output: "html" }));
    });
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
