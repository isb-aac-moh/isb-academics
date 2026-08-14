import type { Question, TopicMastery } from "../types";
import { masteryWeight } from "./mastery";

/** Questions that must be answered after a miss before that topic is re-asked. Two keeps the retry
    inside the same round without making it feel like an immediate repeat of the same question. */
export const RETRY_GAP = 2;

export interface RetryEntry {
  topic: string;
  /** Number of questions answered at the moment the miss happened. */
  queuedAt: number;
}

/** Every unasked question in the same scenario, in order. A standalone question returns just itself. */
export function chainFor(question: Question, pool: Question[], askedIds: Set<string>): Question[] {
  if (!question.scenario_id) return [question];
  return pool
    .filter((q) => q.scenario_id === question.scenario_id && !askedIds.has(q.id))
    .sort((a, b) => (a.scenario_order ?? 0) - (b.scenario_order ?? 0));
}

/** The first queued topic whose retry gap has elapsed and which still has an unasked question. */
export function dueRetryTopic(
  queue: RetryEntry[],
  answeredCount: number,
  pool: Question[],
  askedIds: Set<string>,
): string | null {
  for (const entry of queue) {
    if (answeredCount - entry.queuedAt < RETRY_GAP) continue;
    const hasUnasked = pool.some((q) => q.topic === entry.topic && !askedIds.has(q.id));
    if (hasUnasked) return entry.topic;
  }
  return null;
}

/** Whether a topic missed at `answeredCount` questions into the round could still have its retry gap
    elapse before the round's hard end at `roundSize` — i.e. whether promising a retry to the student
    would actually be honored, or the round will end first. */
export function retryFitsInRound(answeredCount: number, roundSize: number): boolean {
  return answeredCount + RETRY_GAP < roundSize;
}

/**
 * The next unit of work: one standalone question, or a whole scenario chain.
 *
 * Priority is (1) a due retry, then (2) a mastery-weighted sample. A chain longer than `capacity`
 * is never started, because truncating a chain destroys the progression that makes it worth having.
 */
export function pickNext(
  pool: Question[],
  mastery: Record<string, TopicMastery>,
  askedIds: Set<string>,
  retryQueue: RetryEntry[],
  answeredCount: number,
  capacity: number,
): Question[] | null {
  if (capacity <= 0) return null;

  const fits = (q: Question) => {
    const len = chainFor(q, pool, askedIds).length;
    return len > 0 && len <= capacity;
  };

  const available = pool.filter((q) => !askedIds.has(q.id) && fits(q));
  if (available.length === 0) return null;

  const retryTopic = dueRetryTopic(retryQueue, answeredCount, pool, askedIds);
  if (retryTopic) {
    const match = available.find((q) => q.topic === retryTopic);
    if (match) return chainFor(match, pool, askedIds);
  }

  // One weighted candidate per distinct pickable unit (chain or standalone question) — otherwise a
  // long chain's members each count as a separate roll, inflating that chain's odds by its length.
  const seen = new Set<string>();
  const candidates: Question[] = [];
  for (const q of available) {
    const key = q.scenario_id ?? q.id;
    if (seen.has(key)) continue;
    seen.add(key);
    candidates.push(q);
  }

  const weighted = candidates.map((q) => ({ q, w: masteryWeight(mastery[q.topic]) }));
  const total = weighted.reduce((sum, item) => sum + item.w, 0);

  let roll = Math.random() * total;
  for (const item of weighted) {
    roll -= item.w;
    if (roll <= 0) return chainFor(item.q, pool, askedIds);
  }
  return chainFor(weighted[weighted.length - 1].q, pool, askedIds);
}
