import { useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import type {
  Attempt,
  Concept,
  Course,
  MasteryLevel,
  Question,
  Scenario,
  SessionContent,
  Student,
  TopicMastery,
} from "../types";
import {
  awardXp,
  fetchAttempts,
  fetchConcepts,
  fetchCourses,
  fetchMastery,
  fetchQuestions,
  fetchScenarios,
  fetchSessionContent,
  recordAttempt,
  topicKey,
  upsertMastery,
} from "../lib/db";
import { pickNext, retryFitsInRound, type RetryEntry } from "../lib/adaptive";
import { applyAnswer, blankMastery, LEVEL_NAMES } from "../lib/mastery";
import { QuestionCard } from "../components/QuestionCard";
import { ConceptCard } from "../components/ConceptCard";
import { ScenarioSetup } from "../components/ScenarioSetup";
import { RemediationCard } from "../components/RemediationCard";
import { ProfileSummary } from "../components/ProfileSummary";
import { QuestionReview } from "../components/QuestionReview";
import { Confetti } from "../components/Confetti";
import { FormulaSheet } from "../components/FormulaSheet";

const STREAK_MILESTONES = new Set([3, 5, 8]);

/** Wide enough to stop the old 512px column from stranding most of the window, still short enough
    to keep prose at a readable measure. The Window around it already supplies the outer boundary,
    so nothing in here draws a second one. */
const COLUMN = "w-full max-w-3xl";

const ROUND_SIZE = 8;
/** A chain is never truncated, so a round can run past ROUND_SIZE. Only starting a new chain while
    under ROUND_SIZE caps the overshoot at one chain's length. */
const MAX_OVERSHOOT = 4;

type Stage = "loading" | "concept" | "playing" | "remediate" | "summary" | "error";

interface MissContext {
  question: Question;
  chosen: string;
  previousLevel: MasteryLevel;
  newLevel: MasteryLevel;
  willRetry: boolean;
}

interface Props {
  profile: Student;
  onXpChange: (xp: number) => void;
}

export function SessionPage({ profile, onXpChange }: Props) {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const topicFilter = searchParams.get("topic");
  const topicsFilter = searchParams.get("topics");
  const sessionFilter = searchParams.get("session");

  // A topic/session deep-link (from Sessions) already carries &course=..., so this is only ever
  // null when landing here fresh, e.g. from the Home desktop's Practice icon.
  const [course, setCourse] = useState<string | null>(searchParams.get("course"));
  const [courses, setCourses] = useState<Course[]>([]);

  const [stage, setStage] = useState<Stage>("loading");
  const [errorMsg, setErrorMsg] = useState("");

  const [pool, setPool] = useState<Question[]>([]);
  const [allQuestions, setAllQuestions] = useState<Question[]>([]);
  const [scenarios, setScenarios] = useState<Record<string, Scenario>>({});
  const [concepts, setConcepts] = useState<Record<string, Concept>>({});
  const [sessionContent, setSessionContent] = useState<Record<number, SessionContent>>({});
  const [mastery, setMastery] = useState<Record<string, TopicMastery>>({});
  const [startLevels, setStartLevels] = useState<Record<string, MasteryLevel>>({});

  /** The current chain, waiting to be served. Non-empty means a chain is mid-flight. */
  const [pending, setPending] = useState<Question[]>([]);
  const [chainTotal, setChainTotal] = useState(0);
  const [lastChainAnswer, setLastChainAnswer] = useState<string | null>(null);

  const [current, setCurrent] = useState<Question | null>(null);
  const [askedIds, setAskedIds] = useState<Set<string>>(new Set());
  const [answered, setAnswered] = useState<Question[]>([]);
  /** What the student picked, per question id. Null means skipped. Drives the review view; a
      skipped question is deliberately absent from `answered` so it costs no round slot. */
  const [answerLog, setAnswerLog] = useState<Record<string, string | null>>({});
  /** Index into `seenOrder` while reviewing an earlier question; null means playing the live one. */
  const [reviewIndex, setReviewIndex] = useState<number | null>(null);
  /** Every question already served this round, answered or skipped, in the order it was served. */
  const [seenOrder, setSeenOrder] = useState<Question[]>([]);
  const [seenTopics, setSeenTopics] = useState<Set<string>>(new Set());
  const [retryQueue, setRetryQueue] = useState<RetryEntry[]>([]);
  const [miss, setMiss] = useState<MissContext | null>(null);

  const [xp, setXp] = useState(profile.total_xp);
  const [score, setScore] = useState(0);
  const [streak, setStreak] = useState(0);
  const [bestStreak, setBestStreak] = useState(0);
  const [profileAttempts, setProfileAttempts] = useState<Attempt[] | null>(null);
  const [confettiTrigger, setConfettiTrigger] = useState(0);

  useEffect(() => {
    if (course) return;
    void fetchCourses().then(setCourses);
  }, [course]);

  useEffect(() => {
    if (!course) return;
    void initRound();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [course, topicFilter, topicsFilter, sessionFilter]);

  useEffect(() => {
    if (stage === "summary") {
      setProfileAttempts(null);
      void fetchAttempts(profile.id).then(setProfileAttempts);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [stage]);

  async function initRound() {
    if (!course) return;
    setStage("loading");
    try {
      const [all, cs, m, scs, sc] = await Promise.all([
        fetchQuestions(),
        fetchConcepts(),
        fetchMastery(profile.id),
        fetchScenarios(),
        fetchSessionContent(course),
      ]);
      const wanted = topicsFilter ? new Set(topicsFilter.split(",")) : null;
      const filtered = all.filter((q) => {
        if (q.course_id !== course) return false;
        // Short-answer questions have no choices to pick between — they are read in Sessions, not
        // played here. Courses made entirely of them never reach this screen (see the picker
        // below); this keeps a mixed course safe too.
        if (q.type === "short_answer") return false;
        if (wanted) return wanted.has(q.topic);
        if (topicFilter) return q.topic === topicFilter;
        if (sessionFilter) return q.session === Number(sessionFilter);
        return true;
      });

      const levels: Record<string, MasteryLevel> = {};
      for (const q of filtered) {
        const key = topicKey(q.course_id, q.topic);
        levels[key] = m[key]?.level ?? 0;
      }

      setPool(filtered);
      setAllQuestions(all);
      setConcepts(cs);
      setScenarios(scs);
      setSessionContent(sc);
      setMastery(m);
      setStartLevels(levels);
      setAskedIds(new Set());
      setAnswered([]);
      setSeenTopics(new Set());
      setRetryQueue([]);
      setSeenOrder([]);
      setAnswerLog({});
      setReviewIndex(null);
      setMiss(null);
      setPending([]);
      setLastChainAnswer(null);
      setScore(0);
      setStreak(0);
      setBestStreak(0);
      advance(filtered, m, new Set(), new Set(), cs, [], [], 0, null);
    } catch (err) {
      setErrorMsg(err instanceof Error ? err.message : "Something went wrong");
      setStage("error");
    }
  }

  /**
   * Serves the next question. Drains `pendingChain` first so a chain, once started, always finishes
   * — truncating one destroys the progression it exists to teach. Only when the buffer is empty does
   * it pick a new unit of work, and only while under ROUND_SIZE.
   */
  function advance(
    qs: Question[],
    m: Record<string, TopicMastery>,
    asked: Set<string>,
    seen: Set<string>,
    conceptMap: Record<string, Concept>,
    pendingChain: Question[],
    queue: RetryEntry[],
    answeredCount: number,
    chainAnswer: string | null,
  ) {
    let chain = pendingChain;
    // A fresh chain has no "previous answer" to show; only a continuing one does.
    let previous = chainAnswer;

    if (chain.length === 0) {
      if (answeredCount >= ROUND_SIZE) return finishRound();
      const capacity = ROUND_SIZE + MAX_OVERSHOOT - answeredCount;
      const picked = pickNext(qs, m, asked, queue, answeredCount, capacity);
      if (!picked || picked.length === 0) return finishRound();
      chain = picked;
      previous = null;
      setChainTotal(picked.length);
    }

    const [next, ...rest] = chain;
    setPending(rest);
    setCurrent(next);
    setLastChainAnswer(previous);

    // Teach before the first question on a topic only when it has never been attempted. A student
    // already at Familiar goes straight to the question.
    const unseen = !seen.has(next.topic) && Boolean(conceptMap[topicKey(next.course_id, next.topic)]);
    const neverAttempted = (m[topicKey(next.course_id, next.topic)]?.level ?? 0) === 0;
    setStage(unseen && neverAttempted ? "concept" : "playing");
  }

  function finishRound() {
    setConfettiTrigger((c) => c + 1);
    setStage("summary");
  }

  function handleConceptContinue() {
    if (!current) return;
    setSeenTopics((prev) => new Set(prev).add(current.topic));
    setStage("playing");
  }

  async function handleAnswerContinue(correct: boolean, chosen: string) {
    if (!current) return;

    const currentKey = topicKey(current.course_id, current.topic);
    const previous = mastery[currentKey] ?? blankMastery(profile.id, current.course_id, current.topic);
    const updated = applyAnswer(previous, correct);
    const newMastery = { ...mastery, [currentKey]: updated };
    setMastery(newMastery);

    const newAsked = new Set(askedIds).add(current.id);
    const newAnsweredCount = answered.length + 1;
    let newQueue = retryQueue;

    if (correct) {
      setScore((s) => s + 1);
      const newXp = await awardXp(profile.id, xp);
      setXp(newXp);
      onXpChange(newXp);
      setStreak((s) => {
        const next = s + 1;
        setBestStreak((b) => Math.max(b, next));
        if (STREAK_MILESTONES.has(next)) setConfettiTrigger((c) => c + 1);
        return next;
      });
    } else {
      setStreak(0);
      newQueue = [...retryQueue, { topic: current.topic, queuedAt: newAnsweredCount }];
      setRetryQueue(newQueue);
    }

    void recordAttempt(profile.id, current.id, correct);
    void upsertMastery(updated);

    setAskedIds(newAsked);
    setAnswered((prev) => [...prev, current]);
    setSeenOrder((prev) => [...prev, current]);
    setAnswerLog((prev) => ({ ...prev, [current.id]: chosen }));
    const newSeenTopics = new Set(seenTopics).add(current.topic);
    setSeenTopics(newSeenTopics);

    if (!correct) {
      const willRetry =
        pool.some((q) => q.topic === current.topic && !newAsked.has(q.id)) &&
        retryFitsInRound(newAnsweredCount, ROUND_SIZE);
      setMiss({
        question: current,
        chosen,
        previousLevel: previous.level,
        newLevel: updated.level,
        willRetry,
      });
      setStage("remediate");
      return;
    }

    advance(
      pool,
      newMastery,
      newAsked,
      newSeenTopics,
      concepts,
      pending,
      newQueue,
      newAnsweredCount,
      current.correct_answer,
    );
  }

  /**
   * Passes on the current question without answering it.
   *
   * Nothing is recorded: no attempt, no XP, no mastery change, and `answered` is untouched so a
   * skip does not consume one of the round's ROUND_SIZE slots — skipping shortens nothing, it just
   * moves past a question the student does not want right now. The id does go into `askedIds`, so
   * the same question is not served again later in this round.
   */
  function handleSkip() {
    if (!current) return;
    const newAsked = new Set(askedIds).add(current.id);
    setAskedIds(newAsked);
    setSeenOrder((prev) => [...prev, current]);
    setAnswerLog((prev) => ({ ...prev, [current.id]: null }));
    advance(pool, mastery, newAsked, seenTopics, concepts, pending, retryQueue, answered.length, null);
  }

  function handleRemediationContinue() {
    setMiss(null);
    advance(
      pool,
      mastery,
      askedIds,
      seenTopics,
      concepts,
      pending,
      retryQueue,
      answered.length,
      current?.correct_answer ?? null,
    );
  }

  if (!course) {
    // Reference-only courses (all short-answer, nothing to pick between) are left out rather than
    // shown and then dead-ending in an empty round.
    const playable = courses.filter((c) => c.has_practice);
    const readOnly = courses.filter((c) => c.enabled && !c.has_practice);
    return (
      <div className="px-6 py-10 md:px-10">
        <h2 className="text-2xl font-bold mb-2">Which course?</h2>
        <p className="text-ink-soft mb-8 max-w-2xl">
          Smart Practice adapts within one course at a time — pick which one to mix questions from.
        </p>
        <div className="grid gap-3 sm:grid-cols-2 max-w-xl">
          {playable.map((c) =>
            c.enabled ? (
              <button key={c.id} onClick={() => setCourse(c.id)} className="card card-hover text-left p-5">
                <div className="font-semibold mb-1">{c.name}</div>
                <div className="text-sm text-ink-soft">{c.code ? `${c.code} — live now` : "Live now"}</div>
              </button>
            ) : (
              <div key={c.id} className="card text-left p-5 opacity-50 cursor-default">
                <div className="font-semibold mb-1">{c.name}</div>
                <div className="text-sm text-ink-soft">Coming soon</div>
              </div>
            ),
          )}
        </div>
        {readOnly.length > 0 && (
          <p className="text-sm text-ink-soft mt-6 max-w-2xl">
            {readOnly.map((c) => c.name).join(", ")}{" "}
            {readOnly.length === 1 ? "is" : "are"} written-answer only, so there is nothing to play
            here —{" "}
            <button
              onClick={() => navigate(`/learn/sessions/${readOnly[0].id}`)}
              className="text-accent font-medium hover:underline"
            >
              read the question bank instead
            </button>
            .
          </p>
        )}
      </div>
    );
  }

  if (stage === "loading") {
    return <div className="flex items-center justify-center min-h-[70vh] text-ink-soft">Loading…</div>;
  }

  if (stage === "error") {
    return (
      <div className="flex items-center justify-center min-h-[70vh] text-bad text-sm px-4 text-center">
        {errorMsg}
      </div>
    );
  }

  if (stage === "concept" && current) {
    const concept = concepts[topicKey(current.course_id, current.topic)];
    if (!concept) return null; // guaranteed non-null by advance's hasConcept check
    return (
      // Top-aligned, not vertically centred: a concept note can now run long enough to carry an
      // embedded simulator, and centring those makes the top of the note start below the fold.
      <div className="flex flex-col items-center px-5 sm:px-8 py-8">
        <Confetti trigger={confettiTrigger} />
        <div className={COLUMN}>
          <ConceptCard concept={concept} onContinue={handleConceptContinue} />
        </div>
      </div>
    );
  }

  if (stage === "remediate" && miss) {
    return (
      <div className="flex flex-col items-center px-5 sm:px-8 py-8">
        <RemediationCard
          question={miss.question}
          chosen={miss.chosen}
          concept={concepts[topicKey(miss.question.course_id, miss.question.topic)]}
          previousLevel={miss.previousLevel}
          newLevel={miss.newLevel}
          willRetry={miss.willRetry}
          onContinue={handleRemediationContinue}
        />
      </div>
    );
  }

  if (stage === "summary") {
    return (
      <div className="flex flex-col items-center min-h-[70vh] px-4 py-10 text-center">
        <Confetti trigger={confettiTrigger} count={40} />
        <h2 className="text-xl font-bold mb-2 rise-in">Round complete</h2>
        <p className="text-3xl font-bold mb-1 tabular rise-in" style={{ animationDelay: "60ms" }}>
          {score} / {answered.length}
        </p>
        <p className="text-ink-soft text-sm mb-8 rise-in" style={{ animationDelay: "100ms" }}>
          Best streak this round: {bestStreak}
        </p>

        {profileAttempts === null ? (
          <div className="text-sm text-ink-soft mb-8">Loading your progress…</div>
        ) : (
          <div className="mb-8 rise-in" style={{ animationDelay: "160ms" }}>
            <ProfileSummary
              profile={{ ...profile, total_xp: xp }}
              attempts={profileAttempts}
              questions={allQuestions}
              concepts={concepts}
            />
          </div>
        )}

        {(() => {
          // Keyed by course+topic, so the map key is not displayable — the row's own topic is.
          const moved = Object.entries(mastery)
            .filter(([key]) => startLevels[key] !== undefined)
            .map(([key, m]) => ({ key, topic: m.topic, from: startLevels[key], to: m.level }))
            .filter((r) => r.from !== r.to);
          if (moved.length === 0) return null;
          return (
            <div className="w-full max-w-sm mb-8 text-left rise-in" style={{ animationDelay: "200ms" }}>
              <div className="text-[10px] uppercase tracking-wide text-ink-soft font-bold mb-2">
                What moved
              </div>
              {moved.map((r) => (
                <div
                  key={r.key}
                  className="flex justify-between gap-3 text-sm py-1.5 border-b border-line last:border-0"
                >
                  <span className="text-ink-soft">{r.topic.replace(/_/g, " ")}</span>
                  <span className={`font-semibold shrink-0 ${r.to > r.from ? "text-good" : "text-bad"}`}>
                    {LEVEL_NAMES[r.from]} → {LEVEL_NAMES[r.to]}
                  </span>
                </div>
              ))}
            </div>
          );
        })()}

        <button onClick={() => void initRound()} className="btn btn-primary mb-3">
          Practice again
        </button>
        <button onClick={() => navigate("/learn")} className="text-xs text-ink-soft hover:text-ink transition-colors">
          Back to home
        </button>
      </div>
    );
  }

  if (!current) return null;

  // Reviewing an earlier question. Read-only by design — see QuestionReview for why re-answering
  // is not offered.
  if (reviewIndex !== null && seenOrder[reviewIndex]) {
    const reviewed = seenOrder[reviewIndex];
    const atEnd = reviewIndex >= seenOrder.length - 1;
    return (
      <div className="flex flex-col items-center px-5 sm:px-8 py-8">
        <div className={COLUMN}>
          <QuestionReview
            key={reviewed.id}
            question={reviewed}
            chosen={answerLog[reviewed.id] ?? null}
            position={reviewIndex + 1}
            total={seenOrder.length}
            canGoBack={reviewIndex > 0}
            onBack={() => setReviewIndex(reviewIndex - 1)}
            forwardLabel={atEnd ? "Back to current question" : "Next"}
            onForward={() => setReviewIndex(atEnd ? null : reviewIndex + 1)}
          />
        </div>
      </div>
    );
  }

  const sheet = sessionContent[current.session];
  return (
    <div className="flex flex-col items-center px-5 sm:px-8 py-8">
      <Confetti trigger={confettiTrigger} />
      <div className={COLUMN}>
        <div className="flex justify-between text-sm text-ink-soft mb-2 tabular">
          <span>
            Question {answered.length + 1} / {Math.max(ROUND_SIZE, answered.length + 1 + pending.length)}
          </span>
          <span>
            Score {score} · Streak {streak}
          </span>
        </div>
        <div className="h-1 rounded-full bg-surface-2 overflow-hidden mb-5">
          <div
            className="h-full bg-accent transition-all duration-300"
            style={{ width: `${Math.min(100, (answered.length / ROUND_SIZE) * 100)}%` }}
          />
        </div>
        {current.scenario_id && scenarios[current.scenario_id] && (
          <ScenarioSetup
            scenario={scenarios[current.scenario_id]}
            part={chainTotal - pending.length}
            total={chainTotal}
            previousAnswer={lastChainAnswer}
          />
        )}
        <QuestionCard key={current.id} question={current} onContinue={handleAnswerContinue} />
        <div className="mt-5 flex items-center justify-between gap-3 border-t border-line pt-4">
          <button
            onClick={() => setReviewIndex(seenOrder.length - 1)}
            disabled={seenOrder.length === 0}
            className="text-sm text-ink-soft hover:text-ink transition-colors disabled:opacity-40 disabled:hover:text-ink-soft"
          >
            ← Review previous
          </button>
          <button
            onClick={handleSkip}
            className="text-sm text-ink-soft hover:text-ink transition-colors"
            title="Move on without answering — this does not count against your score"
          >
            Skip this one →
          </button>
        </div>
      </div>
      {sheet?.formula_sheet && (
        <FormulaSheet sheet={sheet.formula_sheet} session={current.session} title={sheet.title} />
      )}
    </div>
  );
}
