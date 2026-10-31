import { useEffect, useState } from "react";
import { TextSkeleton } from "../../../components/Skeleton";
import type { CohortStats, Concept, FlaggedQuestion, TopicStat } from "../../types";
import { fetchCohortStats, fetchConcepts, fetchFlaggedQuestions, fetchTopicStats, topicKey } from "../../lib/db";

const LOW_ACCURACY = 0.4;

export function AdminMonitoring() {
  const [stats, setStats] = useState<CohortStats | null>(null);
  const [topicStats, setTopicStats] = useState<TopicStat[]>([]);
  const [flaggedQuestions, setFlaggedQuestions] = useState<FlaggedQuestion[]>([]);
  const [concepts, setConcepts] = useState<Record<string, Concept>>({});

  useEffect(() => {
    void load();
  }, []);

  async function load() {
    const [cs, ts, fq, concepts] = await Promise.all([
      fetchCohortStats(),
      fetchTopicStats(),
      fetchFlaggedQuestions(),
      fetchConcepts(),
    ]);
    setStats(cs);
    setTopicStats(ts);
    setFlaggedQuestions(fq);
    setConcepts(concepts);
  }

  if (!stats) {
    return <TextSkeleton lines={6} />;
  }

  const overallAccuracy =
    stats.total_answered > 0 ? Math.round((stats.total_correct / stats.total_answered) * 100) : null;

  return (
    <div>
      <div className="grid grid-cols-2 sm:grid-cols-5 gap-3 mb-8 text-center">
        <div className="card py-3">
          <div className="text-lg font-bold tabular">{stats.total_students}</div>
          <div className="text-xs text-ink-soft">Students</div>
        </div>
        <div className="card py-3">
          <div className="text-lg font-bold tabular">{stats.active_today}</div>
          <div className="text-xs text-ink-soft">Active today</div>
        </div>
        <div className="card py-3">
          <div className="text-lg font-bold tabular">{stats.active_this_week}</div>
          <div className="text-xs text-ink-soft">Active this week</div>
        </div>
        <div className="card py-3">
          <div className="text-lg font-bold tabular">{stats.total_answered}</div>
          <div className="text-xs text-ink-soft">Questions answered</div>
        </div>
        <div className="card py-3">
          <div className="text-lg font-bold tabular">{overallAccuracy !== null ? `${overallAccuracy}%` : "—"}</div>
          <div className="text-xs text-ink-soft">Overall accuracy</div>
        </div>
      </div>

      <h2 className="text-sm uppercase tracking-wide text-ink-soft mb-3 font-medium">
        Weakest topics across the cohort
      </h2>
      {topicStats.length === 0 ? (
        <p className="text-sm text-ink-soft mb-8">Not enough attempts yet to rank topics.</p>
      ) : (
        <div className="flex flex-col gap-1.5 mb-8">
          {topicStats.slice(0, 8).map((t) => (
            <div
              key={topicKey(t.course_code, t.topic)}
              className="card p-3 text-sm flex justify-between items-baseline gap-3"
            >
              <span className="flex items-baseline gap-2 min-w-0">
                <span className="truncate">
                  {concepts[topicKey(t.course_code, t.topic)]?.title ?? t.topic.replace(/_/g, " ")}
                </span>
                <span className="shrink-0 text-[10px] uppercase tracking-wide text-ink-soft font-semibold">
                  {t.course_code}
                </span>
              </span>
              <span className="text-bad font-medium tabular shrink-0">
                {Math.round(Number(t.accuracy) * 100)}% · {t.total} attempts
              </span>
            </div>
          ))}
        </div>
      )}

      <h2 className="text-sm uppercase tracking-wide text-ink-soft mb-3 font-medium">
        Questions that might need a look
      </h2>
      {flaggedQuestions.length === 0 ? (
        <p className="text-sm text-ink-soft">
          Nothing flagged — no question is scoring under 40% or over 95% with at least 3 attempts.
        </p>
      ) : (
        <div className="flex flex-col gap-2">
          {flaggedQuestions.map((q) => (
            <div key={q.question_id} className="card p-3 text-sm">
              <div className="text-ink-soft mb-1">
                S{q.session} · {q.topic} · {q.total} attempts
              </div>
              <div className="flex justify-between gap-3">
                <span>{q.prompt}</span>
                <span
                  className={`font-medium tabular shrink-0 ${
                    Number(q.accuracy) < LOW_ACCURACY ? "text-bad" : "text-good"
                  }`}
                >
                  {Math.round(Number(q.accuracy) * 100)}%
                </span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
