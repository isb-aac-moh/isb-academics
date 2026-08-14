import type { Concept } from "../types";
import { Markdown } from "./Markdown";

interface Props {
  concept: Concept;
  onContinue: () => void;
}

export function ConceptCard({ concept, onContinue }: Props) {
  return (
    <div className="w-full rise-in">
      <div className="text-xs uppercase tracking-wide text-accent font-semibold mb-2">Concept</div>
      <h2 className="text-2xl font-bold mb-4">{concept.title}</h2>
      <Markdown text={concept.note} className="text-ink-soft leading-relaxed mb-6" />
      {concept.resource_url && (
        <a
          href={concept.resource_url}
          target="_blank"
          rel="noreferrer"
          className="text-sm text-accent font-medium hover:underline block mb-4"
        >
          View slides / resource →
        </a>
      )}
      <button onClick={onContinue} className="btn btn-primary">
        Got it, let&apos;s practice
      </button>
    </div>
  );
}
