/** `short_answer` questions have no `choices`: the exam asks for a written answer, so
    `correct_answer` holds the model answer and the question is read, not played. */
export type QuestionType = "formula" | "case_fact" | "short_answer";

/** Where a question came from. `authored` content is the only content the professor never touched,
    which makes it filterable and reversible if the real exam turns out narrower than expected. */
export type Provenance = "prof_verbatim" | "prof_adapted" | "authored";

/** 0 Not started · 1 Attempted · 2 Familiar · 3 Proficient · 4 Mastered */
export type MasteryLevel = 0 | 1 | 2 | 3 | 4;

export interface Scenario {
  id: string;
  course_id: string;
  session: number;
  title: string;
  setup: string;
  source: string | null;
}

export interface TopicMastery {
  student_id: string;
  course_id: string;
  topic: string;
  level: MasteryLevel;
  consecutive_correct: number;
  total_correct: number;
  total_attempts: number;
  last_seen_at: string | null;
}

export interface Course {
  id: string;
  name: string;
  code: string | null;
  /** From the bidding catalogue, e.g. "Term 3". Groups the desktop rail into term folders. */
  term: string | null;
  total_sessions: number;
  enabled: boolean;
  sort_order: number;
  /** Derived, not stored: false when every question in the course is `short_answer`, i.e. the
      course is a Q&A reference rather than something Smart Practice can play. */
  has_practice: boolean;
}

export interface Question {
  id: string;
  course_id: string;
  type: QuestionType;
  topic: string;
  session: number;
  prompt: string;
  choices: string[];
  correct_answer: string;
  explanation: string;
  source: string;
  scenario_id: string | null;
  scenario_order: number | null;
  difficulty: number;
  provenance: Provenance;
  /** Optional nudge, revealed on demand before the answer. */
  hint: string | null;
}

export interface Concept {
  course_id: string;
  topic: string;
  title: string;
  note: string;
  resource_url: string | null;
}

export interface SessionContent {
  course_id: string;
  session: number;
  title: string | null;
  summary: string | null;
  resource_url: string | null;
  /** Markdown formula reference, shown in a drawer during practice. */
  formula_sheet: string | null;
}

export type MaterialKind = "slides" | "case" | "solution" | "coursepack" | "other";

export interface Material {
  id: string;
  course_id: string;
  /** Null means the file belongs to the course as a whole, not one session. */
  session: number | null;
  title: string;
  kind: MaterialKind;
  storage_path: string;
  sort_order: number;
}

export interface CourseContent {
  course_id: string;
  outline: string | null;
  announcements: string | null;
  cheatsheet_url: string | null;
  exam_samples_url: string | null;
  feedback_form_url: string | null;
}

export interface Student {
  id: string;
  name: string;
  email: string;
  total_xp: number;
  day_streak: number;
  last_active_date: string | null;
  is_admin: boolean;
}

export interface Attempt {
  id: string;
  student_id: string;
  question_id: string;
  correct: boolean;
  created_at: string;
}

export interface CohortStats {
  total_students: number;
  active_today: number;
  active_this_week: number;
  total_answered: number;
  total_correct: number;
}

export interface TopicStat {
  /** Topic names are unique only within a course, so cohort stats carry the course too. */
  course_code: string;
  topic: string;
  total: number;
  accuracy: number;
}

export interface FlaggedQuestion {
  question_id: string;
  prompt: string;
  topic: string;
  session: number;
  total: number;
  accuracy: number;
}
