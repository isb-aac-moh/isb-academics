import type { Concept, MasteryLevel, Question } from "../types";
import { LEVEL_NAMES } from "../lib/mastery";
import { Markdown } from "./Markdown";

interface Props {
  question: Question;
  chosen: string;
  concept: Concept | undefined;
  previousLevel: MasteryLevel;
  newLevel: MasteryLevel;
  /** False when the pool has no other question on this topic, so we do not promise what we cannot keep. */
  willRetry: boolean;
  onContinue: () => void;
}

/** Shown after a miss. Names the specific mistake, re-teaches, and states the retry out loud —
    the engine now guarantees it, so saying it is honest rather than decorative. */
export function RemediationCard({
  question,
  chosen,
  concept,
  previousLevel,
  newLevel,
  willRetry,
  onContinue,
}: Props) {
  return (
    <div className="w-full max-w-3xl">
      <div className="card p-5 mb-3">
        <p className="text-sm font-medium mb-3">{question.prompt}</p>
        <div className="flex flex-col gap-2">
          <div className="border-2 border-bad bg-bad/5 rounded-lg px-3 py-2 text-sm">
            <span className="font-semibold text-bad">Your answer · </span>
            {chosen}
          </div>
          <div className="border-2 border-good bg-good/5 rounded-lg px-3 py-2 text-sm">
            <span className="font-semibold text-good">Correct · </span>
            {question.correct_answer}
          </div>
        </div>
      </div>

      <div className="border-l-4 border-bad bg-bad/5 rounded-r-lg px-4 py-3 mb-3">
        <Markdown text={question.explanation} className="text-sm leading-relaxed" />
      </div>

      {concept && (
        <div className="card p-4 mb-3">
          <div className="text-[10px] uppercase tracking-wide text-accent font-bold mb-1.5">
            Refresher · {concept.title}
          </div>
          <Markdown text={concept.note} className="text-sm text-ink-soft leading-relaxed" />
        </div>
      )}

      <div className="flex items-start gap-2 bg-highlight/15 border border-highlight/40 rounded-lg px-4 py-3 mb-4 text-sm">
        <span aria-hidden="true">↻</span>
        <span>
          {willRetry && <strong>You&apos;ll see another question on this shortly. </strong>}
          {newLevel < previousLevel ? (
            <>
              Moved from {LEVEL_NAMES[previousLevel]} back to {LEVEL_NAMES[newLevel]}.
            </>
          ) : (
            <>Still at {LEVEL_NAMES[newLevel]}.</>
          )}
        </span>
      </div>

      <button onClick={onContinue} className="btn btn-primary w-full">
        Continue
      </button>
    </div>
  );
}
