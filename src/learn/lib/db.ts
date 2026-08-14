import { supabase } from "./supabase";
import type {
  Attempt,
  CohortStats,
  Concept,
  Course,
  CourseContent,
  FlaggedQuestion,
  Material,
  MaterialKind,
  Provenance,
  Question,
  QuestionType,
  Scenario,
  SessionContent,
  Student,
  TopicMastery,
  TopicStat,
} from "../types";

/**
 * The learning app's data layer, repointed at the merged database.
 *
 * Three things changed when this moved out of its own Supabase project, and this file is the
 * only place that knows about any of them — every component and page above it still sees the
 * same field names it always did:
 *
 *   tables      `questions` -> `learn_questions`, and so on. Prefixed because this database is
 *               shared with isb-explorer and names like questions/concepts/materials are too
 *               generic to sit unqualified beside another app's tables.
 *   courses     There is no separate learning `courses` table. The two courses were already in
 *               this database's bidding catalogue (MKTG, OPMG, Term 3 core), so content keys on
 *               courses(code) and `learn_courses` holds only the practice-specific columns.
 *               `Course.id` is therefore a course code — 'MKTG', not a uuid.
 *   identity    `students` is gone. Names and admin rights come from `users`, XP and streaks
 *               from `learn_profiles`, and `Student.id` is the auth user id.
 *
 * Column renames (course_id -> course_code, student_id -> user_id) are handled with PostgREST
 * select aliases on the way out and explicit mapping on the way in, which is why nothing above
 * this file had to be touched.
 */

const XP_PER_CORRECT = 10;

// Aliases that present the new columns under the names the UI already uses.
const QUESTION_COLS =
  "id, course_id:course_code, type, topic, session, prompt, choices, correct_answer, explanation, source, scenario_id, scenario_order, difficulty, provenance, hint";
const CONCEPT_COLS = "course_id:course_code, topic, title, note, resource_url";
const SESSION_COLS = "course_id:course_code, session, title, summary, resource_url, formula_sheet";
const SCENARIO_COLS = "id, course_id:course_code, session, title, setup, source";
const MASTERY_COLS =
  "student_id:user_id, course_id:course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at";
const MATERIAL_COLS = "id, course_id:course_code, session, title, kind, storage_path, sort_order";

/** Every course with practice content, including disabled ones — admin needs to see those too.
    Name and code come from the shared bidding catalogue rather than being duplicated here.
    `has_practice` is derived from the questions rather than stored, so it can never disagree with
    the content: a course whose questions are all `short_answer` has nothing Smart Practice can
    play, and every screen that offers practice reads this one field to decide. */
export async function fetchCourses(): Promise<Course[]> {
  const [courses, playable] = await Promise.all([
    supabase
      .from("learn_courses")
      .select("course_code, total_sessions, enabled, sort_order, courses!inner(name, code)")
      .order("sort_order"),
    supabase.from("learn_questions").select("course_code").neq("type", "short_answer"),
  ]);
  if (courses.error) throw courses.error;
  if (playable.error) throw playable.error;

  const withPractice = new Set((playable.data ?? []).map((row) => row.course_code as string));
  return (courses.data ?? []).map((row) => {
    const course = row.courses as unknown as { name: string; code: string | null };
    return {
      id: row.course_code as string,
      name: course.name,
      code: course.code,
      total_sessions: row.total_sessions as number,
      enabled: row.enabled as boolean,
      sort_order: row.sort_order as number,
      has_practice: withPractice.has(row.course_code as string),
    };
  });
}

/** Only the practice-specific columns are writable here. A course's name, code and term belong
    to the bidding catalogue and are edited there, not from the learning admin. */
export async function upsertCourse(course: Course): Promise<void> {
  const { error } = await supabase.from("learn_courses").upsert(
    {
      course_code: course.id,
      total_sessions: course.total_sessions,
      enabled: course.enabled,
      sort_order: course.sort_order,
    },
    { onConflict: "course_code" },
  );
  if (error) throw error;
}

/** Omit courseId for a global fetch (e.g. the cross-course progress rollup in ProfileSummary);
    pass it to scope to one course (e.g. building that course's session list or practice pool). */
export async function fetchQuestions(courseId?: string): Promise<Question[]> {
  let query = supabase.from("learn_questions").select(QUESTION_COLS);
  if (courseId) query = query.eq("course_code", courseId);
  const { data, error } = await query;
  if (error) throw error;
  return data as unknown as Question[];
}

export async function fetchConcepts(courseId?: string): Promise<Record<string, Concept>> {
  let query = supabase.from("learn_concepts").select(CONCEPT_COLS);
  if (courseId) query = query.eq("course_code", courseId);
  const { data, error } = await query;
  if (error) throw error;
  const map: Record<string, Concept> = {};
  for (const c of (data ?? []) as unknown as Concept[]) map[c.topic] = c;
  return map;
}

export async function upsertConcept(concept: Concept): Promise<void> {
  const { course_id, ...rest } = concept;
  const { error } = await supabase
    .from("learn_concepts")
    .upsert({ ...rest, course_code: course_id }, { onConflict: "course_code,topic" });
  if (error) throw error;
}

export async function deleteConcept(courseId: string, topic: string): Promise<void> {
  const { error } = await supabase
    .from("learn_concepts")
    .delete()
    .eq("course_code", courseId)
    .eq("topic", topic);
  if (error) throw error;
}

/** Admin question authoring. Lives here rather than in the page so the page never has to know
    the table is `learn_questions` or that course_id is stored as course_code. */
export async function insertQuestion(question: {
  id: string;
  course_id: string;
  type: QuestionType;
  topic: string;
  session: number;
  prompt: string;
  choices: string[];
  correct_answer: string;
  source: string;
  scenario_id: string | null;
  scenario_order: number | null;
  difficulty: number;
  provenance: Provenance;
}): Promise<void> {
  const { course_id, ...rest } = question;
  const { error } = await supabase.from("learn_questions").insert({ ...rest, course_code: course_id });
  if (error) throw error;
}

export async function deleteQuestion(id: string): Promise<void> {
  const { error } = await supabase.from("learn_questions").delete().eq("id", id);
  if (error) throw error;
}

export async function fetchSessionContent(courseId: string): Promise<Record<number, SessionContent>> {
  const { data, error } = await supabase
    .from("learn_session_content")
    .select(SESSION_COLS)
    .eq("course_code", courseId);
  if (error) throw error;
  const map: Record<number, SessionContent> = {};
  for (const s of (data ?? []) as unknown as SessionContent[]) map[s.session] = s;
  return map;
}

export async function upsertSessionContent(content: SessionContent): Promise<void> {
  const { course_id, ...rest } = content;
  const { error } = await supabase
    .from("learn_session_content")
    .upsert({ ...rest, course_code: course_id }, { onConflict: "course_code,session" });
  if (error) throw error;
}

export async function fetchCourseContent(courseId: string): Promise<CourseContent | null> {
  const { data, error } = await supabase
    .from("learn_course_content")
    .select("course_id:course_code, outline, announcements, cheatsheet_url, exam_samples_url, feedback_form_url")
    .eq("course_code", courseId)
    .maybeSingle();
  if (error) throw error;
  return data as unknown as CourseContent | null;
}

export async function upsertCourseContent(content: CourseContent): Promise<void> {
  const { course_id, ...rest } = content;
  const { error } = await supabase
    .from("learn_course_content")
    .upsert({ ...rest, course_code: course_id }, { onConflict: "course_code" });
  if (error) throw error;
}

/**
 * Cohort-wide monitoring reads. These call security-definer Postgres functions (never a raw
 * `select *` on profiles/attempts) — each function checks admin status itself and returns only
 * aggregates, so a non-admin caller gets a permission error rather than every student's rows.
 * Execute is granted to `authenticated` only; anon cannot reach them at all.
 */
export async function fetchCohortStats(): Promise<CohortStats> {
  const { data, error } = await supabase.rpc("learn_admin_cohort_stats").single();
  if (error) throw error;
  return data as CohortStats;
}

export async function fetchTopicStats(): Promise<TopicStat[]> {
  const { data, error } = await supabase.rpc("learn_admin_topic_stats");
  if (error) throw error;
  return data as TopicStat[];
}

export async function fetchFlaggedQuestions(): Promise<FlaggedQuestion[]> {
  const { data, error } = await supabase.rpc("learn_admin_flagged_questions");
  if (error) throw error;
  return data as FlaggedQuestion[];
}

function todayISO(): string {
  return new Date().toISOString().slice(0, 10);
}

function daysBetween(a: string, b: string): number {
  const diffMs = new Date(b).getTime() - new Date(a).getTime();
  return Math.round(diffMs / (1000 * 60 * 60 * 24));
}

/**
 * Loads or creates the caller's own learning profile and rolls the day-streak forward.
 *
 * Identity is not created here any more. The app's own auth already provisioned the `users`
 * row, so name, email and is_admin are passed in from there and this only owns XP and streak.
 * That is what stops a student being an admin of one half and not the other.
 */
export async function getOrCreateProfile(
  userId: string,
  name: string,
  email: string,
  isAdmin: boolean,
): Promise<Student> {
  const { data: existing } = await supabase
    .from("learn_profiles")
    .select("total_xp, day_streak, last_active_date")
    .eq("user_id", userId)
    .maybeSingle();

  const today = todayISO();
  const shape = (row: { total_xp: number; day_streak: number; last_active_date: string | null }): Student => ({
    id: userId,
    name,
    email,
    is_admin: isAdmin,
    total_xp: row.total_xp,
    day_streak: row.day_streak,
    last_active_date: row.last_active_date,
  });

  if (!existing) {
    const { data, error } = await supabase
      .from("learn_profiles")
      .insert({ user_id: userId, day_streak: 1, last_active_date: today })
      .select("total_xp, day_streak, last_active_date")
      .single();
    if (error) throw error;
    return shape(data);
  }

  const last = existing.last_active_date as string | null;
  let day_streak = existing.day_streak as number;
  if (!last) {
    day_streak = 1;
  } else {
    const gap = daysBetween(last, today);
    if (gap === 0) {
      // already active today, streak unchanged
    } else if (gap === 1) {
      day_streak += 1;
    } else {
      day_streak = 1;
    }
  }

  const { data, error } = await supabase
    .from("learn_profiles")
    .update({ day_streak, last_active_date: today })
    .eq("user_id", userId)
    .select("total_xp, day_streak, last_active_date")
    .single();
  if (error) throw error;
  return shape(data);
}

export async function fetchScenarios(courseId?: string): Promise<Record<string, Scenario>> {
  let query = supabase.from("learn_scenarios").select(SCENARIO_COLS);
  if (courseId) query = query.eq("course_code", courseId);
  const { data, error } = await query;
  if (error) throw error;
  const map: Record<string, Scenario> = {};
  for (const s of (data ?? []) as unknown as Scenario[]) map[s.id] = s;
  return map;
}

export async function upsertScenario(scenario: Scenario): Promise<void> {
  const { course_id, ...rest } = scenario;
  const { error } = await supabase
    .from("learn_scenarios")
    .upsert({ ...rest, course_code: course_id }, { onConflict: "id" });
  if (error) throw error;
}

export async function deleteScenario(id: string): Promise<void> {
  const { error } = await supabase.from("learn_scenarios").delete().eq("id", id);
  if (error) throw error;
}

/**
 * Keyed by topic. The stored key is (user, course, topic) — the course is part of it now, so two
 * courses sharing a topic name can no longer overwrite each other's rows the way they could in
 * the source project. This map still flattens to topic alone, which is fine while topic names
 * stay distinct across courses; pass courseId to scope it if that ever stops being true.
 */
export async function fetchMastery(userId: string, courseId?: string): Promise<Record<string, TopicMastery>> {
  let query = supabase.from("learn_topic_mastery").select(MASTERY_COLS).eq("user_id", userId);
  if (courseId) query = query.eq("course_code", courseId);
  const { data, error } = await query;
  if (error) throw error;
  const map: Record<string, TopicMastery> = {};
  for (const row of (data ?? []) as unknown as TopicMastery[]) map[row.topic] = row;
  return map;
}

export async function upsertMastery(mastery: TopicMastery): Promise<void> {
  const { student_id, course_id, ...rest } = mastery;
  const { error } = await supabase
    .from("learn_topic_mastery")
    .upsert(
      { ...rest, user_id: student_id, course_code: course_id },
      { onConflict: "user_id,course_code,topic" },
    );
  if (error) throw error;
}

export async function recordAttempt(userId: string, questionId: string, correct: boolean): Promise<void> {
  const { error } = await supabase
    .from("learn_attempts")
    .insert({ user_id: userId, question_id: questionId, correct });
  if (error) throw error;
}

/** Awards XP for a correct answer and returns the student's new total. */
export async function awardXp(userId: string, currentXp: number): Promise<number> {
  const next = currentXp + XP_PER_CORRECT;
  const { error } = await supabase.from("learn_profiles").update({ total_xp: next }).eq("user_id", userId);
  if (error) throw error;
  return next;
}

/** Clears topic mastery so every topic starts fresh again. Does not touch XP, streak, or attempt history. */
export async function resetProgress(userId: string): Promise<void> {
  const { error } = await supabase.from("learn_topic_mastery").delete().eq("user_id", userId);
  if (error) throw error;
}

/** Full attempt history for a student, across every round they've ever played — the basis for profile stats. */
export async function fetchAttempts(userId: string): Promise<Attempt[]> {
  const { data, error } = await supabase
    .from("learn_attempts")
    .select("id, student_id:user_id, question_id, correct, created_at")
    .eq("user_id", userId);
  if (error) throw error;
  return data as unknown as Attempt[];
}

const MATERIALS_BUCKET = "course-materials";

export async function fetchMaterials(courseId?: string): Promise<Material[]> {
  let query = supabase.from("learn_materials").select(MATERIAL_COLS).order("session").order("sort_order");
  if (courseId) query = query.eq("course_code", courseId);
  const { data, error } = await query;
  if (error) throw error;
  return data as unknown as Material[];
}

/** The bucket is private, so students never get a raw path — every view is a short-lived signed URL. */
export async function materialUrl(storagePath: string): Promise<string> {
  const { data, error } = await supabase.storage
    .from(MATERIALS_BUCKET)
    .createSignedUrl(storagePath, 60 * 60);
  if (error) throw error;
  return data.signedUrl;
}

export async function uploadMaterial(
  file: File,
  courseId: string,
  session: number | null,
  title: string,
  kind: MaterialKind,
): Promise<void> {
  const safeName = file.name.replace(/[^a-zA-Z0-9._-]/g, "_");
  const path = `${courseId}/${session ?? "course"}/${Date.now()}-${safeName}`;

  const { error: uploadError } = await supabase.storage
    .from(MATERIALS_BUCKET)
    .upload(path, file, { contentType: file.type, upsert: false });
  if (uploadError) throw uploadError;

  const { error } = await supabase
    .from("learn_materials")
    .insert({ course_code: courseId, session, title, kind, storage_path: path });
  // Leaving an orphaned object behind would silently eat the storage quota, so undo the upload.
  if (error) {
    await supabase.storage.from(MATERIALS_BUCKET).remove([path]);
    throw error;
  }
}

export async function deleteMaterial(id: string, storagePath: string): Promise<void> {
  const { error } = await supabase.from("learn_materials").delete().eq("id", id);
  if (error) throw error;
  await supabase.storage.from(MATERIALS_BUCKET).remove([storagePath]);
}
