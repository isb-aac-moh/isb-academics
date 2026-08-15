import type { Concept, MasteryLevel, Question, SessionContent, TopicMastery } from "../types";
import { topicKey } from "./db";

export interface SessionTopic {
  topic: string;
  title: string;
  level: MasteryLevel;
  questionCount: number;
}

export interface SessionGroup {
  session: number;
  title: string;
  topics: SessionTopic[];
}

/** Groups topics by the session their questions belong to. Session titles and count come from the
    course's own data (courses.total_sessions, session_content.title) — not a hardcoded map, since
    every course has its own session numbering and titles.

    `courseId` is what the concept and mastery maps are keyed on alongside the topic; those maps may
    be fetched unscoped, so a bare topic name is not enough to look a row up unambiguously. */
export function groupBySession(
  courseId: string,
  questions: Question[],
  concepts: Record<string, Concept>,
  mastery: Record<string, TopicMastery>,
  totalSessions: number,
  sessionContent: Record<number, SessionContent>,
): SessionGroup[] {
  const bySession = new Map<number, Map<string, number>>();

  for (const q of questions) {
    if (!bySession.has(q.session)) bySession.set(q.session, new Map());
    const topics = bySession.get(q.session)!;
    topics.set(q.topic, (topics.get(q.topic) ?? 0) + 1);
  }

  const groups: SessionGroup[] = [];
  for (let session = 1; session <= totalSessions; session++) {
    const topicCounts = bySession.get(session);
    const topics: SessionTopic[] = topicCounts
      ? Array.from(topicCounts.entries()).map(([topic, questionCount]) => ({
          topic,
          title: concepts[topicKey(courseId, topic)]?.title ?? topic.replace(/_/g, " "),
          level: mastery[topicKey(courseId, topic)]?.level ?? 0,
          questionCount,
        }))
      : [];
    groups.push({ session, title: sessionContent[session]?.title ?? `Session ${session}`, topics });
  }
  return groups;
}
