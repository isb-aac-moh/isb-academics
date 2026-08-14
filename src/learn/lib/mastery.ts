import type { MasteryLevel, TopicMastery } from "../types";

export const LEVEL_NAMES = ["Not started", "Attempted", "Familiar", "Proficient", "Mastered"] as const;

/** Selection weight by level. Weak topics dominate; mastered topics keep a weight of 1 so they
    still resurface occasionally rather than rotting. */
const WEIGHT_BY_LEVEL = [5, 4, 3, 2, 1] as const;

const FAMILIAR_STREAK = 2;
const PROFICIENT_STREAK = 4;
const MASTERED_STREAK = 6;
const MASTERED_MIN_ATTEMPTS = 6;

export function blankMastery(studentId: string, courseId: string, topic: string): TopicMastery {
  return {
    student_id: studentId,
    course_id: courseId,
    topic,
    level: 0,
    consecutive_correct: 0,
    total_correct: 0,
    total_attempts: 0,
    last_seen_at: null,
  };
}

/** The level a streak earns. Never returns 0 — reaching here means at least one attempt happened. */
export function levelFor(consecutiveCorrect: number, totalAttempts: number): MasteryLevel {
  if (consecutiveCorrect >= MASTERED_STREAK && totalAttempts >= MASTERED_MIN_ATTEMPTS) return 4;
  if (consecutiveCorrect >= PROFICIENT_STREAK) return 3;
  if (consecutiveCorrect >= FAMILIAR_STREAK) return 2;
  return 1;
}

/** A correct answer can only raise the level; a miss drops exactly one rung, floored at Attempted.
    A student who has missed something is never sent back to "Not started" — they have demonstrably
    attempted it. */
export function applyAnswer(mastery: TopicMastery, correct: boolean): TopicMastery {
  const total_attempts = mastery.total_attempts + 1;
  const last_seen_at = new Date().toISOString();

  if (!correct) {
    return {
      ...mastery,
      total_attempts,
      last_seen_at,
      consecutive_correct: 0,
      level: Math.max(1, mastery.level - 1) as MasteryLevel,
    };
  }

  const consecutive_correct = mastery.consecutive_correct + 1;
  const total_correct = mastery.total_correct + 1;
  return {
    ...mastery,
    total_attempts,
    total_correct,
    consecutive_correct,
    last_seen_at,
    level: Math.max(mastery.level, levelFor(consecutive_correct, total_attempts)) as MasteryLevel,
  };
}

export function masteryWeight(mastery: TopicMastery | undefined): number {
  const level = mastery?.level ?? 0;
  if (level < 0 || level > 4) throw new Error(`Invalid mastery level: ${level}`);
  return WEIGHT_BY_LEVEL[level];
}
