import type { Concept } from "../types";

interface Props {
  concept: Concept;
  onContinue: () => void;
}

export function ConceptCard({ concept, onContinue }: Props) {
  return (
    <div className="w-full max-w-lg card p-6 rise-in">
      <div className="text-xs uppercase tracking-wide text-accent font-semibold mb-2">Concept</div>
      <h2 className="text-xl font-bold mb-3">{concept.title}</h2>
      <p className="text-ink-soft leading-relaxed mb-6">{concept.note}</p>
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
        Got it, let's practice
      </button>
    </div>
  );
}
