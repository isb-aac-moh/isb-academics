export interface User {
  id: string;
  name: string;
  email: string;
  is_admin?: boolean;
}

// The six ISB concentration areas + four industry specializations.
// Source: Elective Courses and Concentration Areas_2026-27, Bidding Session Summary.
export type ConcentrationArea =
  | "Entrepreneurship"
  | "Finance"
  | "Marketing"
  | "Operations Management"
  | "Information Technology Management"
  | "Strategy and Leadership";

export type IndustrySpecialization =
  | "Healthcare"
  | "Manufacturing"
  | "Public Policy"
  | "Infrastructure";

export type TermCode = "Term 1" | "Term 2" | "Term 3" | "Term 4" | "Term 5" | "Term 6" | "Term 7" | "Block Week 1" | "Block Week 2" | "Block Week 3" | "Block Week 4";

export interface Course {
  id: string;
  code: string;
  name: string;
  professor: string;
  term: TermCode;
  credits: number;
  concentration_areas: ConcentrationArea[]; // cross-listed courses can map to more than one; student picks ONE at bid time
  industry_specializations: IndustrySpecialization[];
  is_strategy_ob_course?: boolean; // for the STLD 2+2+2 split rule
  prerequisite_course_ids?: string[];
  is_active: boolean; // soft-disable instead of delete — false means dropped/hidden from students
  is_core: boolean; // mandatory core course — not bid on, doesn't count toward elective/concentration credits
}

// Per-course grading DNA — extracted from official course outlines, admin-editable
// after that. Not every course has one yet (only Term 4 as of this writing); the
// planner should degrade gracefully when a course_id has no matching row.
export interface CourseGradingProfile {
  course_id: string;
  grade_participation_pct: number;
  grade_individual_pct: number;
  grade_group_pct: number;
  grade_exam_pct: number;
  exam_midterm_count: number;
  exam_endterm_count: number;
  exam_quiz_count: number;
  load_quant: number;
  load_assignments: number;
  load_participation: number;
  load_exam_pressure: number;
  load_group: number;
  load_reading: number;
  brief: { label: string; text: string }[];
  source_url: string | null;
  extracted_at: string | null;
}

// The five core courses whose F grade blocks a specific concentration.
export interface GatingCoreCourse {
  id: string;
  name: string;
  term: string;
  blocks_concentration: ConcentrationArea;
}

export interface StudentAcademicProfile {
  user_id: string;
  undergrad_field: string;
  work_ex_domain: string;
  work_ex_role: string;
  work_ex_years: number;
  failed_gating_courses: string[]; // ids of GatingCoreCourse the student failed, if any
  target_concentrations: ConcentrationArea[]; // 0-2 per ISB's "at most two" rule; empty = not pursuing one
  target_specialization?: IndustrySpecialization | "none" | "undecided";
  completed_term2_flexi: string[]; // course codes from TERM2_FLEXI_OPTIONS
  completed_term3_flexi: string[]; // course codes from TERM3_FLEXI_OPTIONS
  // Flexi Core doesn't count toward credit on its own — only if a student picks a
  // 3rd course beyond the required 2 does ISB mandatorily convert that extra one
  // into an elective. These track which completed_term*_flexi code (if any) is
  // that conversion; that's the only one credit math should count.
  term2_converted_elective: string | null;
  term3_converted_elective: string | null;
  // Self-reported — Exchange bidding draws from the same 4,500-point pool as
  // regular elective bidding but isn't modeled as a full flow yet (ROADMAP).
  international_exchange_points_used: number | null;
  inter_campus_exchange_points_used: number | null;
  // A cross-listed course only counts toward ONE concentration (Elective Bidding
  // FAQ Q45), student's choice. Keyed by course code; only meaningful when a
  // course maps to 2+ of this student's target_concentrations.
  cross_listed_concentration_choices: Record<string, ConcentrationArea>;
}

// Grouped into 4 tabs per course in the UI — see RESOURCE_TABS in lib/options.ts.
export type ResourceType =
  | "Course Outline"
  | "Professor Profile"
  | "Slides"
  | "Session Transcript"
  | "Summary"
  | "PYQP"
  | "Custom GPT"
  | "Cheatsheet"
  | "Student Notes"
  | "Other"
  | "Platform Directory"
  | "General";

// Types that make sense tied to a term/course. Platform Directory and General are cohort-wide.
export const COURSE_SCOPED_RESOURCE_TYPES: ResourceType[] = [
  "Course Outline", "Professor Profile", "Slides", "Session Transcript", "Summary",
  "PYQP", "Custom GPT", "Cheatsheet", "Student Notes", "Other",
];

export interface Resource {
  id: string;
  title: string;
  url: string;
  description: string | null;
  resource_type: ResourceType;
  term: string | null;
  course_id: string | null;
  created_at: string;
  pinned: boolean; // sorts first within its own section/tab (e.g. top of a course's "Other" tab)
  pinned_global: boolean; // shows in a sticky banner at the top of Course Resources regardless of filters
}

export type NotificationTag = "Urgent" | "Important" | "Info" | "General";

export interface Notification {
  id: string;
  title: string;
  body: string;
  tag: NotificationTag;
  pinned: boolean;
  created_at: string;
}

export type NavLinkType = "internal" | "external";
export type NavLinkVisibility = "everyone" | "admin";

// Admin-managed extra sidebar links, rendered below the locked core pages.
export interface NavLink {
  id: string;
  label: string;
  icon: string; // key into NAV_LINK_ICONS (src/lib/navLinkIcons.ts)
  link_type: NavLinkType;
  href: string;
  visibility: NavLinkVisibility;
  sort_order: number;
  created_at: string;
}

// Singleton settings row — see supabase/migrations/20260728090000_app_settings.sql.
export interface AppSettings {
  id: true;
  live_bidding_terms: string[];
  pulse_check_cutoff: string;
  term_credit_limits: Record<string, { min: number; max: number }>;
  updated_at: string;
}

// Cohort Bidding Pulse Check — see supabase/migrations/20260730090000_pulse_check.sql
// and 20260804160000_pulse_check_edit_cap_and_delete.sql. A student's own
// submission can be edited up to 3 times and removed outright at any point
// (both RLS-enforced via edit_count / a delete policy, not just a UI
// restriction) and is never readable by other students as a raw row — only
// through the threshold-gated pulse_check_results_by_term() RPC below.
export interface PulseCheckSubmission {
  id: string;
  user_id: string;
  course_id: string;
  term: string; // denormalized from courses.term at submit time
  bid_points_estimate: number;
  edit_count: number; // 0-3; no further edits possible once it hits 3
  created_at: string;
}

// Shape returned by the pulse_check_results_by_term RPC — a 5-number summary
// (min/P25/median/P75/max), all null until respondent_count clears the
// in-DB threshold (5) — never a partial number standing in for real signal.
export interface PulseCheckResult {
  course_id: string;
  respondent_count: number;
  min_points: number | null;
  p25_points: number | null;
  median_points: number | null;
  p75_points: number | null;
  max_points: number | null;
}

// Shape returned by pulse_check_histogram_by_term — 5 adaptive-width buckets
// per course (via Postgres's width_bucket()), only present for courses that
// clear the >=5 respondent threshold. A coarser aggregate than the 5-number
// summary above, not a new privacy exposure.
export interface PulseCheckHistogramBucket {
  course_id: string;
  bucket_index: number;
  bucket_start: number;
  bucket_end: number;
  bucket_count: number;
}
