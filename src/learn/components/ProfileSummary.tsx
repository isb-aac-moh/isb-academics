import type { Attempt, Concept, Question, Student } from "../types";
import { topicKey } from "../lib/db";
import { useCountUp } from "../lib/useCountUp";
import { StreakFlame } from "./StreakFlame";

const XP_PER_LEVEL = 100;
const MIN_ATTEMPTS_TO_RANK = 2;

interface TopicAccuracy {
  key: string;
  courseId: string;
  topic: string;
  title: string;
  correct: number;
  total: number;
  accuracy: number;
}

/**
 * Accuracy per topic, rolled up across every course the student has practised.
 *
 * Keyed on course + topic rather than topic alone. This panel is fed by unscoped fetches, and
 * topic names are only unique *within* a course — MKTG and OPMG happen not to collide today, but
 * nothing stops a future course from also calling something `break_even`. Keyed on the bare name,
 * two courses' attempts would silently merge into one row carrying whichever course's title was
 * read last.
 */
function computeTopicAccuracy(
  attempts: Attempt[],
  questions: Question[],
  concepts: Record<string, Concept>,
): TopicAccuracy[] {
  const questionById: Record<string, Question> = {};
  for (const q of questions) questionById[q.id] = q;

  const stats: Record<string, { courseId: string; topic: string; correct: number; total: number }> = {};
  for (const a of attempts) {
    const q = questionById[a.question_id];
    if (!q) continue;
    const key = topicKey(q.course_id, q.topic);
    stats[key] ??= { courseId: q.course_id, topic: q.topic, correct: 0, total: 0 };
    stats[key].total += 1;
    if (a.correct) stats[key].correct += 1;
  }

  return Object.entries(stats).map(([key, s]) => ({
    key,
    courseId: s.courseId,
    topic: s.topic,
    title: concepts[key]?.title ?? s.topic.replace(/_/g, " "),
    correct: s.correct,
    total: s.total,
    accuracy: s.correct / s.total,
  }));
}

/** One row of the strongest/weakest lists. The course chip is what keeps a cross-course list
    readable — "Break-Even Volume" alone does not say which exam it belongs to. */
function TopicRow({ item, tone }: { item: TopicAccuracy; tone: "good" | "bad" }) {
  return (
    <div className="flex justify-between items-baseline gap-3 text-sm">
      <span className="flex items-baseline gap-2 min-w-0">
        <span className="truncate">{item.title}</span>
        <span className="shrink-0 text-[10px] uppercase tracking-wide text-ink-soft font-semibold">
          {item.courseId}
        </span>
      </span>
      <span className={`${tone === "good" ? "text-good" : "text-bad"} font-medium tabular shrink-0`}>
        {Math.round(item.accuracy * 100)}%
      </span>
    </div>
  );
}

interface Props {
  profile: Student;
  attempts: Attempt[];
  questions: Question[];
  concepts: Record<string, Concept>;
}

export function ProfileSummary({ profile, attempts, questions, concepts }: Props) {
  const displayedXp = useCountUp(profile.total_xp);
  const level = Math.floor(profile.total_xp / XP_PER_LEVEL) + 1;
  const xpIntoLevel = profile.total_xp % XP_PER_LEVEL;

  const totalAnswered = attempts.length;
  const totalCorrect = attempts.filter((a) => a.correct).length;
  const overallAccuracy = totalAnswered > 0 ? Math.round((totalCorrect / totalAnswered) * 100) : null;

  const ranked = computeTopicAccuracy(attempts, questions, concepts)
    .filter((t) => t.total >= MIN_ATTEMPTS_TO_RANK)
    .sort((a, b) => b.accuracy - a.accuracy);

  // Strongest/weakest must be disjoint. With few ranked topics, "top 3" can't be allowed to
  // swallow the whole list — cap each side at half of what's ranked so a single weak topic
  // never gets shown off as a strength just because nothing worse exists to compare it to.
  let strongest: TopicAccuracy[] = [];
  let weakest: TopicAccuracy[] = [];
  if (ranked.length === 1) {
    if (ranked[0].accuracy >= 0.5) strongest = ranked;
    else weakest = ranked;
  } else if (ranked.length > 1) {
    const n = Math.min(3, Math.floor(ranked.length / 2));
    strongest = ranked.slice(0, n);
    weakest = ranked.slice(-n).reverse();
  }

  return (
    <div className="w-full max-w-md text-left">
      <div className="flex items-center justify-between mb-1">
        <span className="text-sm font-semibold">Level {level}</span>
        <span className="text-xs text-ink-soft tabular">
          {xpIntoLevel} / {XP_PER_LEVEL} XP to next level
        </span>
      </div>
      <div className="h-2 rounded-full bg-surface-2 overflow-hidden mb-6">
        <div
          className="h-full bg-accent transition-all duration-500"
          style={{ width: `${(xpIntoLevel / XP_PER_LEVEL) * 100}%` }}
        />
      </div>

      <div className="grid grid-cols-3 gap-3 mb-6 text-center">
        <div className="card py-3">
          <div className="text-lg font-bold tabular">{displayedXp}</div>
          <div className="text-xs text-ink-soft">Total XP</div>
        </div>
        <div className="card py-3">
          <div className="text-lg font-bold tabular">
            {profile.day_streak} <StreakFlame streak={profile.day_streak} />
          </div>
          <div className="text-xs text-ink-soft">Day streak</div>
        </div>
        <div className="card py-3">
          <div className="text-lg font-bold tabular">{overallAccuracy !== null ? `${overallAccuracy}%` : "—"}</div>
          <div className="text-xs text-ink-soft">Accuracy · {totalAnswered} answered</div>
        </div>
      </div>

      {ranked.length === 0 ? (
        <p className="text-sm text-ink-soft">
          Answer a few more questions across different topics and this'll show you exactly what you're good
          at and what needs work.
        </p>
      ) : (
        <div className="flex flex-col gap-5">
          {strongest.length > 0 && (
            <div>
              <h3 className="text-xs uppercase tracking-wide text-ink-soft mb-2 font-medium">Doing well on</h3>
              <div className="flex flex-col gap-1.5">
                {strongest.map((t) => (
                  <TopicRow key={t.key} item={t} tone="good" />
                ))}
              </div>
            </div>
          )}
          {weakest.length > 0 && (
            <div>
              <h3 className="text-xs uppercase tracking-wide text-ink-soft mb-2 font-medium">Needs more practice</h3>
              <div className="flex flex-col gap-1.5">
                {weakest.map((t) => (
                  <TopicRow key={t.key} item={t} tone="bad" />
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
