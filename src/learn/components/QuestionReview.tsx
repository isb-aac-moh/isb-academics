import type { Question } from "../types";
import { Markdown } from "./Markdown";

interface Props {
  question: Question;
  /** What the student picked. Null when the question was skipped rather than answered. */
  chosen: string | null;
  position: number;
  total: number;
  onBack: () => void;
  onForward: () => void;
  /** Label for the forward control — "Next" mid-history, "Back to question" at the end. */
  forwardLabel: string;
  canGoBack: boolean;
}

/**
 * A question the student has already seen, rendered read-only.
 *
 * Deliberately not a second QuestionCard: revisiting a question must never produce another attempt.
 * The original answer is already recorded against accuracy, XP and mastery, so re-answering here
 * would either double-count or silently overwrite a result the student earned. Review shows what
 * they picked, what was right, and why — the explanation is the point of coming back.
 */
export function QuestionReview({
  question,
  chosen,
  position,
  total,
  onBack,
  onForward,
  forwardLabel,
  canGoBack,
}: Props) {
  const wasCorrect = chosen !== null && chosen === question.correct_answer;

  return (
    <div className="w-full rise-in">
      <div className="flex items-center justify-between gap-3 mb-3">
        <div className="text-xs uppercase tracking-wide text-ink-soft font-semibold">
          Reviewing {position} of {total}
        </div>
        <div className={`text-xs font-semibold ${chosen === null ? "text-ink-soft" : wasCorrect ? "text-good" : "text-bad"}`}>
          {chosen === null ? "Skipped" : wasCorrect ? "You got this right" : "You missed this"}
        </div>
      </div>

      <Markdown text={question.prompt} className="text-lg font-medium mb-5" />

      <div className="grid gap-2">
        {question.choices.map((choice) => {
          const isCorrect = choice === question.correct_answer;
          const isChosen = choice === chosen;
          return (
            <div
              key={choice}
              className={[
                "text-left px-4 py-3 rounded-xl border",
                isCorrect && "border-good bg-good-soft",
                isChosen && !isCorrect && "border-bad bg-bad-soft",
                !isChosen && !isCorrect && "border-line opacity-50",
              ]
                .filter(Boolean)
                .join(" ")}
            >
              {choice}
              {isChosen && <span className="ml-2 text-xs text-ink-soft">· your answer</span>}
            </div>
          );
        })}
      </div>

      <div className="mt-5 border-t border-line pt-4">
        <Markdown text={question.explanation} className="text-sm text-ink-soft mb-4 leading-relaxed" />
        <div className="flex items-center gap-3">
          <button onClick={onBack} disabled={!canGoBack} className="btn btn-ghost">
            Previous
          </button>
          <button onClick={onForward} className="btn btn-primary">
            {forwardLabel}
          </button>
        </div>
      </div>
    </div>
  );
}
