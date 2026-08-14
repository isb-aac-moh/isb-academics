import type { Attempt, Concept, Question, Student } from "../types";
import { useCountUp } from "../lib/useCountUp";
import { StreakFlame } from "./StreakFlame";

const XP_PER_LEVEL = 100;
const MIN_ATTEMPTS_TO_RANK = 2;

interface TopicAccuracy {
  topic: string;
  title: string;
  correct: number;
  total: number;
  accuracy: number;
}

function computeTopicAccuracy(
  attempts: Attempt[],
  questions: Question[],
  concepts: Record<string, Concept>,
): TopicAccuracy[] {
  const topicOf: Record<string, string> = {};
  for (const q of questions) topicOf[q.id] = q.topic;

  const stats: Record<string, { correct: number; total: number }> = {};
  for (const a of attempts) {
    const topic = topicOf[a.question_id];
    if (!topic) continue;
    stats[topic] ??= { correct: 0, total: 0 };
    stats[topic].total += 1;
    if (a.correct) stats[topic].correct += 1;
  }

  return Object.entries(stats).map(([topic, s]) => ({
    topic,
    title: concepts[topic]?.title ?? topic.replace(/_/g, " "),
    correct: s.correct,
    total: s.total,
    accuracy: s.correct / s.total,
  }));
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
                  <div key={t.topic} className="flex justify-between text-sm">
                    <span>{t.title}</span>
                    <span className="text-good font-medium tabular">{Math.round(t.accuracy * 100)}%</span>
                  </div>
                ))}
              </div>
            </div>
          )}
          {weakest.length > 0 && (
            <div>
              <h3 className="text-xs uppercase tracking-wide text-ink-soft mb-2 font-medium">Needs more practice</h3>
              <div className="flex flex-col gap-1.5">
                {weakest.map((t) => (
                  <div key={t.topic} className="flex justify-between text-sm">
                    <span>{t.title}</span>
                    <span className="text-bad font-medium tabular">{Math.round(t.accuracy * 100)}%</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
