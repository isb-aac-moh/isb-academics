import { useEffect, useRef, useState } from "react";
import type { Question, QuestionType } from "../types";
import { Markdown } from "./Markdown";

/** Keyed by QuestionType rather than branched on, so adding a type fails the build here instead
    of silently mislabelling. `short_answer` questions are read in Sessions, not played, so this
    card only sees one if a course ever mixes them with multiple-choice. */
const TYPE_LABEL: Record<QuestionType, string> = {
  formula: "Compute it",
  case_fact: "Case recall",
  short_answer: "Write it",
};

interface Props {
  question: Question;
  onContinue: (correct: boolean, chosen: string) => void;
}

/** Counts up from mount. Pace awareness is the point — the exam is timed, so "how long did that
    take me" is information students currently have no way to get. */
function useElapsed(stopped: boolean) {
  const [seconds, setSeconds] = useState(0);
  const start = useRef(Date.now());
  useEffect(() => {
    if (stopped) return;
    const id = setInterval(() => setSeconds(Math.floor((Date.now() - start.current) / 1000)), 1000);
    return () => clearInterval(id);
  }, [stopped]);
  return seconds;
}

function formatClock(s: number): string {
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
}

export function QuestionCard({ question, onContinue }: Props) {
  const [selected, setSelected] = useState<string | null>(null);
  // Picking an option is not the same as committing to it — students reconsider, and locking in the
  // first tap turns a moment of thought into a wrong answer and a mastery penalty.
  const [submitted, setSubmitted] = useState(false);
  const [hintOpen, setHintOpen] = useState(false);
  const elapsed = useElapsed(submitted);

  function choose(choice: string) {
    if (submitted) return;
    setSelected((current) => (current === choice ? null : choice));
  }

  const wasCorrect = selected === question.correct_answer;
  const slow = elapsed >= 90;

  return (
    <div className="w-full rise-in">
      <div className="flex items-center justify-between gap-3 mb-3">
        <div className="text-xs uppercase tracking-wide text-accent font-semibold">
          {TYPE_LABEL[question.type]} · Session {question.session}
        </div>
        <div
          className={`text-xs font-semibold tabular tracking-tight ${slow && !submitted ? "text-bad" : "text-ink-soft"}`}
          aria-label={`Time on this question: ${elapsed} seconds`}
        >
          {formatClock(elapsed)}
        </div>
      </div>

      <Markdown text={question.prompt} className="text-lg font-medium mb-5" />

      <div className="grid gap-2">
        {question.choices.map((choice) => {
          const isCorrect = choice === question.correct_answer;
          const isSelected = choice === selected;
          return (
            <button
              key={choice}
              onClick={() => choose(choice)}
              disabled={submitted}
              aria-pressed={!submitted ? isSelected : undefined}
              className={[
                "text-left px-4 py-3 rounded-xl border transition-all duration-150",
                !submitted && !isSelected && "border-line hover:border-accent/60 active:scale-[0.99]",
                !submitted && isSelected && "border-accent bg-accent/10 ring-1 ring-accent/30",
                submitted && isCorrect && "border-good bg-good-soft",
                submitted && isSelected && !isCorrect && "border-bad bg-bad-soft",
                submitted && !isSelected && !isCorrect && "border-line opacity-50",
              ]
                .filter(Boolean)
                .join(" ")}
            >
              {choice}
            </button>
          );
        })}
      </div>

      {!submitted && (
        <div className="mt-5 flex items-center gap-3">
          <button
            onClick={() => setSubmitted(true)}
            disabled={selected === null}
            className="btn btn-primary"
          >
            Submit answer
          </button>
          <span className="text-xs text-ink-soft">
            {selected === null ? "Pick an option" : "You can still change your mind"}
          </span>
        </div>
      )}

      {question.hint && !submitted && (
        <div className="mt-4">
          {hintOpen ? (
            <div className="border-l-4 border-accent/40 bg-accent/5 rounded-r-lg px-4 py-3 text-sm rise-in">
              <span className="font-semibold text-accent">Hint · </span>
              <Markdown text={question.hint} className="inline text-ink-soft" />
            </div>
          ) : (
            <button
              onClick={() => setHintOpen(true)}
              className="text-sm text-accent font-semibold hover:underline"
            >
              Stuck? Show a hint
            </button>
          )}
        </div>
      )}

      {submitted && (
        <div className="mt-5 border-t border-line pt-4 rise-in">
          <div className="flex items-baseline justify-between gap-3 mb-1">
            <span className={`text-sm font-semibold ${wasCorrect ? "text-good" : "text-bad"}`}>
              {wasCorrect ? "Correct" : "Not quite"}
            </span>
            <span className="text-xs text-ink-soft tabular">{formatClock(elapsed)} on this one</span>
          </div>
          {/* On a miss the remediation screen carries the explanation, the concept refresher, and
              the retry promise — repeating the explanation here would show it twice. */}
          {wasCorrect && (
            <Markdown text={question.explanation} className="text-sm text-ink-soft mb-4 leading-relaxed" />
          )}
          <button
            onClick={() => onContinue(wasCorrect, selected!)}
            className={`btn btn-primary ${wasCorrect ? "" : "mt-3"}`}
          >
            Continue
          </button>
        </div>
      )}
    </div>
  );
}
