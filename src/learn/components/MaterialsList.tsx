import { useState } from "react";
import type { Material } from "../types";
import { materialUrl } from "../lib/db";

const KIND_LABEL: Record<string, string> = {
  slides: "Slides",
  case: "Case",
  solution: "Solutions",
  coursepack: "Coursepack",
  other: "File",
};

interface Props {
  materials: Material[];
  heading?: string;
}

/** The bucket is private, so a link is minted on click rather than rendered up front — signed URLs
    expire, and pre-signing every file on page load would waste most of them. */
export function MaterialsList({ materials, heading = "Files from class" }: Props) {
  const [pending, setPending] = useState<string | null>(null);
  const [error, setError] = useState("");

  if (materials.length === 0) return null;

  async function open(m: Material) {
    setPending(m.id);
    setError("");
    try {
      window.open(await materialUrl(m.storage_path), "_blank", "noopener");
    } catch {
      setError("Could not open that file. Try again in a moment.");
    } finally {
      setPending(null);
    }
  }

  return (
    <div className="mb-8">
      <div className="text-[10px] uppercase tracking-wide text-ink-soft font-bold mb-2">{heading}</div>
      <div className="grid gap-2 sm:grid-cols-2">
        {materials.map((m) => (
          <button
            key={m.id}
            onClick={() => void open(m)}
            disabled={pending === m.id}
            className="card card-hover text-left px-4 py-3 flex items-center gap-3 disabled:opacity-60"
          >
            <span aria-hidden="true" className="text-accent shrink-0">
              ↗
            </span>
            <span className="min-w-0 flex-1">
              <span className="block text-sm font-medium truncate">{m.title}</span>
              <span className="block text-xs text-ink-soft">
                {KIND_LABEL[m.kind] ?? m.kind}
                {m.session === null ? " · whole course" : ""}
              </span>
            </span>
            {pending === m.id && <span className="text-xs text-ink-soft shrink-0">Opening…</span>}
          </button>
        ))}
      </div>
      {error && <p className="text-sm text-bad mt-2">{error}</p>}
    </div>
  );
}
