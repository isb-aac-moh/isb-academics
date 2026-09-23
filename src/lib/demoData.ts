// Fictional dataset for the recruiter demo (see demoMode.ts / demoClient.ts). Every id, name,
// course, and rating below is made up — none of it is real ISB curriculum or student data — but
// it's shaped exactly like the real tables so every screen in the app renders as it would for a
// real student.
import { DEMO_USER_ID } from "./demoMode";
import { fakePulseResults, fakePulseHistograms } from "./devFixtures";
import type {
  Course, GatingCoreCourse, Faculty, CourseFaculty, FacultyRating, CourseGradingProfile,
  Resource, Notification, User, StudentAcademicProfile, AppSettings, PulseCheckSubmission,
} from "../types";
import type { BidPlanEntry } from "../hooks/useBidPlan";
import type { ActualEnrollment } from "../hooks/useActualEnrollments";

export const DEMO_USER: User = {
  id: DEMO_USER_ID,
  name: "Demo Student",
  email: "demo.student@isb.edu",
  is_admin: true,
};

export const DEMO_COURSES: Course[] = [
  // Core, Term 1-3 — not bid on.
  { id: "c-core-t1-1", code: "MGEC1", name: "Managerial Economics", professor: "Prof. R. Iyer", term: "Term 1", credits: 1, concentration_areas: [], industry_specializations: [], is_active: true, is_core: true, academic_area: "ECON", academic_associates: [], overview_video_url: null },
  { id: "c-core-t1-2", code: "FRAC1", name: "Financial Reporting & Analysis", professor: "Prof. S. Menon", term: "Term 1", credits: 1, concentration_areas: [], industry_specializations: [], is_active: true, is_core: true, academic_area: "FINC", academic_associates: [], overview_video_url: null },
  { id: "c-core-t2-1", code: "STLD2", name: "Strategic Leadership", professor: "Prof. A. Kapoor", term: "Term 2", credits: 1, concentration_areas: [], industry_specializations: [], is_strategy_ob_course: true, is_active: true, is_core: true, academic_area: "ORBH", academic_associates: [], overview_video_url: null },
  { id: "c-core-t3-1", code: "OPMG1", name: "Operations Management", professor: "Prof. V. Rao", term: "Term 3", credits: 1, concentration_areas: [], industry_specializations: [], is_active: true, is_core: true, academic_area: "OPMG", academic_associates: [], overview_video_url: null },
  // Flexi Core — Term 2 / Term 3.
  { id: "c-flexi-t2-1", code: "BSNS2", name: "Business, Society & Non-Market Strategies", professor: "Prof. N. Sharma", term: "Term 2", credits: 0.5, concentration_areas: [], industry_specializations: [], is_active: true, is_core: false, academic_area: "STRA", academic_associates: [], overview_video_url: null },
  { id: "c-flexi-t3-1", code: "BANM2", name: "Business Analytics for Marketing and Growth", professor: "Prof. K. Das", term: "Term 3", credits: 0.5, concentration_areas: [], industry_specializations: [], is_active: true, is_core: false, academic_area: "MKTG", academic_associates: [], overview_video_url: null },
  // Term 4 electives — already bid + resolved.
  { id: "c-t4-fin", code: "FINC4", name: "Corporate Valuation", professor: "Prof. D. Chatterjee", term: "Term 4", credits: 1, concentration_areas: ["Finance"], industry_specializations: [], is_active: true, is_core: false, academic_area: "FINC", academic_associates: ["R. Bose"], overview_video_url: null },
  { id: "c-t4-mktg", code: "MKTG4", name: "Marketing Strategy", professor: "Prof. P. Nair", term: "Term 4", credits: 1, concentration_areas: ["Marketing"], industry_specializations: ["Healthcare"], is_active: true, is_core: false, academic_area: "MKTG", academic_associates: [], overview_video_url: null },
  { id: "c-t4-opmg", code: "OPMG4", name: "Supply Chain Analytics", professor: "Prof. V. Rao", term: "Term 4", credits: 1, concentration_areas: ["Operations Management"], industry_specializations: ["Manufacturing"], is_active: true, is_core: false, academic_area: "OPMG", academic_associates: [], overview_video_url: null },
  { id: "c-t4-strat", code: "STLD4", name: "Competitive Strategy", professor: "Prof. A. Kapoor", term: "Term 4", credits: 1, concentration_areas: ["Strategy and Leadership"], industry_specializations: [], is_strategy_ob_course: true, is_active: true, is_core: false, academic_area: "STRA", academic_associates: [], overview_video_url: null },
  // Term 5 electives — live bidding now.
  { id: "c-t5-fin1", code: "FINC5", name: "Private Equity & Venture Capital", professor: "Prof. D. Chatterjee", term: "Term 5", credits: 1, concentration_areas: ["Finance"], industry_specializations: [], is_active: true, is_core: false, academic_area: "FINC", academic_associates: [], overview_video_url: "https://video.isb.edu/overview/finc5-pe-vc" },
  { id: "c-t5-fin2", code: "FINC5B", name: "Fixed Income Markets", professor: "Prof. R. Bose", term: "Term 5", credits: 1, concentration_areas: ["Finance"], industry_specializations: [], is_active: true, is_core: false, academic_area: "FINC", academic_associates: [], overview_video_url: null },
  { id: "c-t5-strat", code: "STLD5", name: "Strategy in Emerging Markets", professor: "Prof. A. Kapoor", term: "Term 5", credits: 1, concentration_areas: ["Strategy and Leadership"], industry_specializations: ["Public Policy"], is_strategy_ob_course: true, is_active: true, is_core: false, academic_area: "STRA", academic_associates: [], overview_video_url: null },
  { id: "c-t5-itm", code: "ITMG5", name: "Digital Transformation", professor: "Prof. S. Verma", term: "Term 5", credits: 1, concentration_areas: ["Information Technology Management"], industry_specializations: [], is_active: true, is_core: false, academic_area: "ITMG", academic_associates: [], overview_video_url: null },
  { id: "c-t5-mktg", code: "MKTG5", name: "Consumer Behaviour Analytics", professor: "Prof. P. Nair", term: "Term 5", credits: 1, concentration_areas: ["Marketing"], industry_specializations: ["Healthcare"], is_active: true, is_core: false, academic_area: "MKTG", academic_associates: [], overview_video_url: null },
  { id: "c-t5-ent", code: "ENTR5", name: "New Venture Financing", professor: "Prof. M. Iqbal", term: "Term 5", credits: 1, concentration_areas: ["Entrepreneurship"], industry_specializations: [], is_active: true, is_core: false, academic_area: "ENTR", academic_associates: [], overview_video_url: null },
  // Term 6 — a smaller preview so the planner's future terms aren't empty.
  { id: "c-t6-fin", code: "FINC6", name: "Mergers & Acquisitions", professor: "Prof. D. Chatterjee", term: "Term 6", credits: 1, concentration_areas: ["Finance"], industry_specializations: [], is_active: true, is_core: false, academic_area: "FINC", academic_associates: [], overview_video_url: null },
  { id: "c-t6-strat", code: "STLD6", name: "Strategic Alliances", professor: "Prof. A. Kapoor", term: "Term 6", credits: 1, concentration_areas: ["Strategy and Leadership"], industry_specializations: [], is_active: true, is_core: false, academic_area: "STRA", academic_associates: [], overview_video_url: null },
];

export const DEMO_GATING_COURSES: GatingCoreCourse[] = [
  { id: "c-core-t1-2", name: "Financial Reporting & Analysis", term: "Term 1", blocks_concentration: "Finance" },
];

export const DEMO_FACULTY: Faculty[] = [
  { id: "f-chatterjee", name: "D. Chatterjee", designation: "Professor of Finance", faculty_type: "Full-time", academic_area: "FINC", affiliation: "ISB Mohali", profile_url: null, bio_url: null, photo_url: null, ratings_url: null, ratings_legacy_url: null },
  { id: "f-nair", name: "P. Nair", designation: "Associate Professor of Marketing", faculty_type: "Full-time", academic_area: "MKTG", affiliation: "ISB Mohali", profile_url: null, bio_url: null, photo_url: null, ratings_url: null, ratings_legacy_url: null },
  { id: "f-rao", name: "V. Rao", designation: "Professor of Operations", faculty_type: "Full-time", academic_area: "OPMG", affiliation: "ISB Hyderabad", profile_url: null, bio_url: null, photo_url: null, ratings_url: null, ratings_legacy_url: null },
  { id: "f-kapoor", name: "A. Kapoor", designation: "Adjunct Professor of Strategy", faculty_type: "Adjunct", academic_area: "STRA", affiliation: "ISB Mohali", profile_url: null, bio_url: null, photo_url: null, ratings_url: null, ratings_legacy_url: null },
  { id: "f-verma", name: "S. Verma", designation: "Associate Professor of IT Management", faculty_type: "Full-time", academic_area: "ITMG", affiliation: "ISB Mohali", profile_url: null, bio_url: null, photo_url: null, ratings_url: null, ratings_legacy_url: null },
  { id: "f-bose", name: "R. Bose", designation: "Adjunct Professor of Finance", faculty_type: "Adjunct", academic_area: "FINC", affiliation: "ISB Hyderabad", profile_url: null, bio_url: null, photo_url: null, ratings_url: null, ratings_legacy_url: null },
];

export const DEMO_COURSE_FACULTY: CourseFaculty[] = [
  { course_id: "c-t4-fin", faculty_id: "f-chatterjee", sessions: "Sessions 1-5", affiliation: "ISB Mohali", sort_order: 1 },
  { course_id: "c-t4-mktg", faculty_id: "f-nair", sessions: "Sessions 1-5", affiliation: "ISB Mohali", sort_order: 1 },
  { course_id: "c-t4-opmg", faculty_id: "f-rao", sessions: "Sessions 1-5", affiliation: "ISB Hyderabad", sort_order: 1 },
  { course_id: "c-t4-strat", faculty_id: "f-kapoor", sessions: "Sessions 1-5", affiliation: "ISB Mohali", sort_order: 1 },
  { course_id: "c-t5-fin1", faculty_id: "f-chatterjee", sessions: "Sessions 1-5", affiliation: "ISB Mohali", sort_order: 1 },
  { course_id: "c-t5-fin2", faculty_id: "f-bose", sessions: "Sessions 1-5", affiliation: "ISB Hyderabad", sort_order: 1 },
  { course_id: "c-t5-strat", faculty_id: "f-kapoor", sessions: "Sessions 1-5", affiliation: "ISB Mohali", sort_order: 1 },
  { course_id: "c-t5-itm", faculty_id: "f-verma", sessions: "Sessions 1-5", affiliation: "ISB Mohali", sort_order: 1 },
  { course_id: "c-t5-mktg", faculty_id: "f-nair", sessions: "Sessions 1-5", affiliation: "ISB Mohali", sort_order: 1 },
];

export const DEMO_FACULTY_RATINGS: FacultyRating[] = [
  { id: "fr-1", faculty_id: "f-chatterjee", course_code: "FINC4", offering: "AY 2025-26", academic_year: "2025-26", campus: "Mohali", term_label: "T4", sort_key: 5, scale: 5, instructor_rating: 4.6, course_rating: 4.4, difficulty: 3.8, workload: 3.5, pace: 3.6, feedback: 4.2, enrollments: 62, respondents: 51 },
  { id: "fr-2", faculty_id: "f-nair", course_code: "MKTG4", offering: "AY 2025-26", academic_year: "2025-26", campus: "Mohali", term_label: "T4", sort_key: 5, scale: 5, instructor_rating: 4.8, course_rating: 4.7, difficulty: 3.0, workload: 3.1, pace: 3.4, feedback: 4.5, enrollments: 58, respondents: 49 },
  { id: "fr-3", faculty_id: "f-rao", course_code: "OPMG4", offering: "AY 2025-26", academic_year: "2025-26", campus: "Hyderabad", term_label: "T4", sort_key: 5, scale: 5, instructor_rating: 4.1, course_rating: 4.0, difficulty: 4.2, workload: 4.0, pace: 3.9, feedback: 3.9, enrollments: 40, respondents: 33 },
  { id: "fr-4", faculty_id: "f-kapoor", course_code: "STLD4", offering: "AY 2025-26", academic_year: "2025-26", campus: "Mohali", term_label: "T4", sort_key: 5, scale: 5, instructor_rating: 4.3, course_rating: 4.2, difficulty: 3.6, workload: 3.4, pace: 3.5, feedback: 4.0, enrollments: 55, respondents: 44 },
  { id: "fr-5", faculty_id: "f-chatterjee", course_code: "FINC5", offering: "AY 2024-25", academic_year: "2024-25", campus: "Mohali", term_label: "T5", sort_key: 3, scale: 7, instructor_rating: 6.1, course_rating: 5.9, difficulty: 5.2, workload: 4.8, pace: 4.9, feedback: 5.5, enrollments: 45, respondents: 38 },
  { id: "fr-6", faculty_id: "f-verma", course_code: "ITMG5", offering: "AY 2025-26", academic_year: "2025-26", campus: "Mohali", term_label: "T5", sort_key: 4, scale: 5, instructor_rating: 4.5, course_rating: 4.3, difficulty: 3.3, workload: 3.0, pace: 3.2, feedback: 4.1, enrollments: 48, respondents: 40 },
];

export const DEMO_GRADING_PROFILES: CourseGradingProfile[] = [
  {
    course_id: "c-t4-fin", grade_participation_pct: 10, grade_individual_pct: 30, grade_group_pct: 30, grade_exam_pct: 30,
    exam_midterm_count: 1, exam_endterm_count: 1, exam_quiz_count: 2, load_quant: 4, load_assignments: 3, load_participation: 2, load_exam_pressure: 4, load_group: 3, load_reading: 3,
    brief: [{ label: "Grading", text: "Exam-heavy with a graded valuation model as the group project." }],
    student_feedback: ["Cold-calling is frequent — come having read the case.", "The Excel model from the group project is reused across sessions, so build it well early."],
    group_size: "4-5", cross_section: false, group_formation: "Self-select", peer_eval: true, attendance: "ISB policy", source_url: null, extracted_at: "2026-08-01",
  },
  {
    course_id: "c-t4-mktg", grade_participation_pct: 20, grade_individual_pct: 20, grade_group_pct: 40, grade_exam_pct: 20,
    exam_midterm_count: 0, exam_endterm_count: 1, exam_quiz_count: 1, load_quant: 2, load_assignments: 3, load_participation: 4, load_exam_pressure: 2, load_group: 4, load_reading: 3,
    brief: [{ label: "Grading", text: "Participation-heavy; the group brand strategy pitch carries the most weight." }],
    student_feedback: ["Very discussion-driven — participation is tracked closely.", "The final pitch deck matters more than the exam."],
    group_size: "5-6", cross_section: true, group_formation: "Instructor-assigned", peer_eval: true, attendance: "Participation-linked", source_url: null, extracted_at: "2026-08-01",
  },
  {
    course_id: "c-t5-fin1", grade_participation_pct: 10, grade_individual_pct: 40, grade_group_pct: 20, grade_exam_pct: 30,
    exam_midterm_count: 1, exam_endterm_count: 1, exam_quiz_count: 0, load_quant: 5, load_assignments: 4, load_participation: 2, load_exam_pressure: 5, load_group: 2, load_reading: 3,
    brief: [{ label: "Grading", text: "The most quant-heavy Finance elective this term — two exams." }],
    student_feedback: ["Bring a financial calculator; the exams are timed tightly.", "Office hours are worth it before the mid-term."],
    group_size: "3-4", cross_section: false, group_formation: "Self-select", peer_eval: false, attendance: "ISB policy", source_url: null, extracted_at: "2026-08-15",
  },
  {
    course_id: "c-t5-strat", grade_participation_pct: 25, grade_individual_pct: 15, grade_group_pct: 35, grade_exam_pct: 25,
    exam_midterm_count: 0, exam_endterm_count: 1, exam_quiz_count: 0, load_quant: 2, load_assignments: 2, load_participation: 4, load_exam_pressure: 3, load_group: 4, load_reading: 4,
    brief: [{ label: "Grading", text: "Heavy on case discussion and a country-market group project." }],
    student_feedback: ["Reading load is high but discussions are engaging."],
    group_size: "5", cross_section: false, group_formation: "ASA-assigned", peer_eval: true, attendance: "Stricter than ISB policy", source_url: null, extracted_at: "2026-08-15",
  },
];

// Real-looking external URLs on purpose — lib/demoLinkGuard.ts intercepts every click on an
// off-origin link in demo mode and explains why it doesn't go anywhere, rather than the links
// being dead or missing. That shows the real feature instead of hiding it.
export const DEMO_RESOURCES: Resource[] = [
  { id: "r-1", title: "ISB Academics Platform Guide", url: "https://example.com/platform-guide", description: "How to use bidding, tracker, and resources.", resource_type: "Platform Directory", term: null, course_id: null, created_at: "2026-06-01T10:00:00Z", pinned: false, pinned_global: true },
  { id: "r-2", title: "FINC4 Course Outline", url: "https://example.com/finc4-outline", description: null, resource_type: "Course Outline", term: "Term 4", course_id: "c-t4-fin", created_at: "2026-07-01T10:00:00Z", pinned: true, pinned_global: false },
  { id: "r-3", title: "MKTG4 Slides — Session 3", url: "https://example.com/mktg4-s3", description: "Brand positioning framework.", resource_type: "Slides", term: "Term 4", course_id: "c-t4-mktg", created_at: "2026-07-05T10:00:00Z", pinned: false, pinned_global: false },
  { id: "r-4", title: "FINC5 Past Year Question Paper", url: "https://example.com/finc5-pyqp", description: null, resource_type: "PYQP", term: "Term 5", course_id: "c-t5-fin1", created_at: "2026-08-10T10:00:00Z", pinned: false, pinned_global: false },
  { id: "r-5", title: "Cohort Placement Handbook", url: "https://example.com/placement-handbook", description: "General reference, not tied to one course.", resource_type: "General", term: null, course_id: null, created_at: "2026-06-15T10:00:00Z", pinned: false, pinned_global: false },
];

export const DEMO_NOTIFICATIONS: Notification[] = [
  { id: "n-1", title: "Term 5 bidding opens Monday", body: "Bidding for Term 5 electives opens at 9 AM. Review your plan in the Bidding Planner before points reset.", tag: "Urgent", pinned: true, created_at: "2026-09-10T09:00:00Z" },
  { id: "n-2", title: "Pulse Check now live for Term 5", body: "Submit your bid-point estimate for any Term 5 course to see the cohort's range.", tag: "Important", pinned: false, created_at: "2026-09-08T09:00:00Z" },
  { id: "n-3", title: "Faculty ratings updated", body: "AY 2025-26 faculty ratings have been added to Course Resources.", tag: "Info", pinned: false, created_at: "2026-08-20T09:00:00Z" },
];

export const DEMO_APP_SETTINGS: AppSettings = {
  id: true,
  live_bidding_terms: ["Term 5"],
  pulse_check_cutoff: "2026-09-20T00:00:00Z",
  term_credit_limits: {},
  updated_at: "2026-09-01T00:00:00Z",
};

export const DEMO_ACADEMIC_PROFILE: StudentAcademicProfile = {
  user_id: DEMO_USER_ID,
  undergrad_field: "Engineering — Computer Science / IT",
  work_ex_domain: "IT / Technology / Software",
  work_ex_role: "Product Management",
  work_ex_years: 4,
  failed_gating_courses: [],
  target_concentrations: ["Finance", "Strategy and Leadership"],
  target_specialization: "Healthcare",
  completed_term2_flexi: ["BSNS2"],
  completed_term3_flexi: ["BANM2"],
  term2_converted_elective: null,
  term3_converted_elective: "BANM2",
  international_exchange_points_used: null,
  inter_campus_exchange_points_used: null,
  cross_listed_concentration_choices: {},
};

// One Term 4 entry left unresolved on purpose, so the Credit Tracker's reconciliation
// prompt has something to show off.
export const DEMO_BID_PLAN_ENTRIES: BidPlanEntry[] = [
  { id: "bp-1", user_id: DEMO_USER_ID, course_id: "c-t4-fin", term: "Term 4", planned_points: 900, actual_points: 950 },
  { id: "bp-2", user_id: DEMO_USER_ID, course_id: "c-t4-mktg", term: "Term 4", planned_points: 700, actual_points: 620 },
  { id: "bp-3", user_id: DEMO_USER_ID, course_id: "c-t4-strat", term: "Term 4", planned_points: 500, actual_points: null },
  { id: "bp-4", user_id: DEMO_USER_ID, course_id: "c-t5-fin1", term: "Term 5", planned_points: 1100, actual_points: null },
  { id: "bp-5", user_id: DEMO_USER_ID, course_id: "c-t5-itm", term: "Term 5", planned_points: 650, actual_points: null },
];

export const DEMO_ACTUAL_ENROLLMENTS: ActualEnrollment[] = [
  { id: "ae-1", user_id: DEMO_USER_ID, course_id: "c-core-t1-1", term: "Term 1", points_paid: 0, grade: "A" },
  { id: "ae-2", user_id: DEMO_USER_ID, course_id: "c-core-t1-2", term: "Term 1", points_paid: 0, grade: "A-" },
  { id: "ae-3", user_id: DEMO_USER_ID, course_id: "c-core-t2-1", term: "Term 2", points_paid: 0, grade: "B+" },
  { id: "ae-4", user_id: DEMO_USER_ID, course_id: "c-flexi-t2-1", term: "Term 2", points_paid: 0, grade: "A-" },
  { id: "ae-5", user_id: DEMO_USER_ID, course_id: "c-core-t3-1", term: "Term 3", points_paid: 0, grade: "A" },
  { id: "ae-6", user_id: DEMO_USER_ID, course_id: "c-flexi-t3-1", term: "Term 3", points_paid: 0, grade: "A" },
  { id: "ae-7", user_id: DEMO_USER_ID, course_id: "c-t4-fin", term: "Term 4", points_paid: 950, grade: "A-" },
  { id: "ae-8", user_id: DEMO_USER_ID, course_id: "c-t4-mktg", term: "Term 4", points_paid: 620, grade: "B+" },
];

export const DEMO_PULSE_SUBMISSIONS: PulseCheckSubmission[] = [
  { id: "pc-1", user_id: DEMO_USER_ID, course_id: "c-t5-fin1", term: "Term 5", bid_points_estimate: 1100, edit_count: 0, created_at: "2026-09-09T12:00:00Z" },
];

export function pulseResultsForTerm(term: string) {
  const ids = DEMO_COURSES.filter((c) => c.term === term && !c.is_core).map((c) => c.id);
  return ids.length ? fakePulseResults(ids) : [];
}

export function pulseHistogramsForTerm(term: string) {
  const ids = DEMO_COURSES.filter((c) => c.term === term && !c.is_core).map((c) => c.id);
  return ids.length ? fakePulseHistograms(ids) : [];
}
