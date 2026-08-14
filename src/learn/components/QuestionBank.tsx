import type { Question } from "../types";
import { Markdown } from "./Markdown";

interface Props {
  questions: Question[];
  className?: string;
}

/**
 * The read-through question bank for courses the exam tests in writing rather than in options.
 *
 * Native `<details>`, closed by default, so the page costs nothing to render and the browser keeps
 * the open/closed state itself. Closed-first is the point: the prompt alone is the self-test, and
 * the answer is one click away when you want to check yourself against it.
 */
export function QuestionBank({ questions, className }: Props) {
  if (questions.length === 0) return null;

  return (
    <div className={className}>
      <div className="text-[10px] uppercase tracking-[0.08em] text-ink-soft font-bold mb-2">
        {questions.length} question{questions.length === 1 ? "" : "s"} on this
      </div>
      <div className="flex flex-col gap-2">
        {questions.map((q, i) => (
          <details key={q.id} className="card overflow-hidden group">
            {/* list-none covers Firefox/Chrome; Safari still draws its own triangle without the
                ::-webkit-details-marker rule. */}
            <summary className="cursor-pointer list-none [&::-webkit-details-marker]:hidden px-4 py-3 flex gap-3 items-baseline hover:bg-surface-2/60 transition-colors">
              <span className="text-xs font-bold text-accent tabular shrink-0 mt-px">
                Q{i + 1}
              </span>
              <span className="text-sm font-medium leading-[1.55] flex-1 min-w-0">{q.prompt}</span>
              <span className="text-[11px] text-ink-soft shrink-0 group-open:hidden">Answer</span>
            </summary>
            <div className="px-4 pb-4 pt-1 border-t border-line">
              <Markdown text={q.correct_answer} className="text-sm text-ink leading-relaxed mt-3" />
              {q.explanation && (
                <div className="mt-3 pt-3 border-t border-line/70">
                  <Markdown text={q.explanation} className="text-sm text-ink-soft leading-relaxed" />
                </div>
              )}
            </div>
          </details>
        ))}
      </div>
    </div>
  );
}
