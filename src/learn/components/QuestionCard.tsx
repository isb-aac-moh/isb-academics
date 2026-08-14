import { useState } from "react";
import type { Question } from "../types";

interface Props {
  question: Question;
  onContinue: (correct: boolean, chosen: string) => void;
}

export function QuestionCard({ question, onContinue }: Props) {
  const [selected, setSelected] = useState<string | null>(null);

  function choose(choice: string) {
    if (selected) return;
    setSelected(choice);
  }

  const answered = selected !== null;
  const wasCorrect = selected === question.correct_answer;

  return (
    <div className="w-full max-w-lg card p-6 rise-in">
      <div className="text-xs uppercase tracking-wide text-accent font-semibold mb-2">
        {question.type === "formula" ? "Compute it" : "Case recall"} · Session {question.session}
      </div>
      <p className="text-lg font-medium mb-5">{question.prompt}</p>
      <div className="grid gap-2">
        {question.choices.map((choice) => {
          const isCorrect = choice === question.correct_answer;
          const isSelected = choice === selected;
          return (
            <button
              key={choice}
              onClick={() => choose(choice)}
              disabled={answered}
              className={[
                "text-left px-4 py-3 rounded-xl border transition-all duration-150",
                !answered && "border-line hover:border-accent/60 active:scale-[0.99]",
                answered && isCorrect && "border-good bg-good-soft",
                answered && isSelected && !isCorrect && "border-bad bg-bad-soft",
                answered && !isSelected && !isCorrect && "border-line opacity-50",
              ]
                .filter(Boolean)
                .join(" ")}
            >
              {choice}
            </button>
          );
        })}
      </div>

      {answered && (
        <div className="mt-5 border-t border-line pt-4 rise-in">
          <div className={`text-sm font-semibold mb-1 ${wasCorrect ? "text-good" : "text-bad"}`}>
            {wasCorrect ? "Correct" : "Not quite"}
          </div>
          {/* On a miss the remediation screen carries the explanation, the concept refresher, and
              the retry promise — repeating the explanation here would show it twice. */}
          {wasCorrect && (
            <p className="text-sm text-ink-soft mb-4 leading-relaxed">{question.explanation}</p>
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
