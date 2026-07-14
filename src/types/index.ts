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
