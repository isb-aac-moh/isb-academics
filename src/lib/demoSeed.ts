// Assembles the fixture data from demoData.ts / demoLearnData.ts into the shape demoClient.ts
// expects: one in-memory table per real Supabase table, plus handlers for the few RPCs the app
// calls. Kept separate from demoClient.ts so the generic client never has to know what a
// "course" or a "pulse check" is.
import {
  DEMO_COURSES, DEMO_GATING_COURSES, DEMO_FACULTY, DEMO_COURSE_FACULTY, DEMO_FACULTY_RATINGS,
  DEMO_GRADING_PROFILES, DEMO_RESOURCES, DEMO_NOTIFICATIONS, DEMO_APP_SETTINGS,
  DEMO_ACADEMIC_PROFILE, DEMO_BID_PLAN_ENTRIES, DEMO_ACTUAL_ENROLLMENTS, DEMO_PULSE_SUBMISSIONS,
  pulseResultsForTerm, pulseHistogramsForTerm,
} from "./demoData";
import {
  DEMO_LEARN_COURSES, DEMO_LEARN_QUESTIONS, DEMO_LEARN_CONCEPTS, DEMO_LEARN_SESSION_CONTENT,
  DEMO_LEARN_SCENARIOS, DEMO_LEARN_MATERIALS, DEMO_LEARN_COURSE_CONTENT, DEMO_LEARN_PROFILE,
  DEMO_LEARN_MASTERY, DEMO_LEARN_ATTEMPTS, DEMO_COHORT_STATS, DEMO_TOPIC_STATS, DEMO_FLAGGED_QUESTIONS,
} from "./demoLearnData";

export function buildDemoSeed(): Record<string, unknown[]> {
  return {
    courses: DEMO_COURSES,
    gating_core_courses: DEMO_GATING_COURSES,
    faculty: DEMO_FACULTY,
    course_faculty: DEMO_COURSE_FACULTY,
    faculty_ratings: DEMO_FACULTY_RATINGS,
    course_grading_profiles: DEMO_GRADING_PROFILES,
    resources: DEMO_RESOURCES,
    notifications: DEMO_NOTIFICATIONS,
    nav_links: [],
    dashboard_popups: [],
    app_settings: [DEMO_APP_SETTINGS],
    student_academic_profiles: [DEMO_ACADEMIC_PROFILE],
    bid_plan_entries: DEMO_BID_PLAN_ENTRIES,
    actual_enrollments: DEMO_ACTUAL_ENROLLMENTS,
    pulse_check_submissions: DEMO_PULSE_SUBMISSIONS,
    learn_courses: DEMO_LEARN_COURSES,
    learn_questions: DEMO_LEARN_QUESTIONS,
    learn_concepts: DEMO_LEARN_CONCEPTS,
    learn_session_content: DEMO_LEARN_SESSION_CONTENT,
    learn_scenarios: DEMO_LEARN_SCENARIOS,
    learn_materials: DEMO_LEARN_MATERIALS,
    learn_course_content: DEMO_LEARN_COURSE_CONTENT,
    learn_profiles: [DEMO_LEARN_PROFILE],
    learn_topic_mastery: DEMO_LEARN_MASTERY,
    learn_attempts: DEMO_LEARN_ATTEMPTS,
  };
}

export const demoRpcHandlers = {
  pulse_check_results_by_term: (params?: Record<string, unknown>) => pulseResultsForTerm(params?.p_term as string),
  pulse_check_histogram_by_term: (params?: Record<string, unknown>) => pulseHistogramsForTerm(params?.p_term as string),
  learn_admin_cohort_stats: () => DEMO_COHORT_STATS,
  learn_admin_topic_stats: () => DEMO_TOPIC_STATS,
  learn_admin_flagged_questions: () => DEMO_FLAGGED_QUESTIONS,
};
