// Fixed option lists — dropdowns instead of free text, so profile data stays
// clean and comparable across the cohort instead of one-off phrasing per student.

export const UNDERGRAD_FIELDS = [
  "Engineering — Computer Science / IT",
  "Engineering — Mechanical",
  "Engineering — Electrical / Electronics",
  "Engineering — Civil",
  "Engineering — Chemical",
  "Engineering — Other",
  "Commerce / B.Com / BBA",
  "Economics",
  "Science (Physics / Chemistry / Math / Other)",
  "Arts / Humanities / Social Sciences",
  "Law",
  "Medicine / Pharmacy / Life Sciences",
  "Architecture / Design",
  "Other",
] as const;

export const WORK_EX_DOMAINS = [
  "IT / Technology / Software",
  "Management Consulting",
  "Banking / Financial Services",
  "FMCG / Consumer Goods",
  "Manufacturing / Engineering",
  "Healthcare / Pharma",
  "E-commerce / Retail",
  "Startups / Entrepreneurship",
  "Public Sector / Government / Defence",
  "Media / Marketing / Advertising",
  "Education",
  "Non-profit / Social Sector",
  "Other",
] as const;

// The function/role within a work-ex domain — a domain alone conflates very
// different skill sets (an engineer, a PM, and a category manager can all
// say "IT / Technology / Software" but need different electives).
export const WORK_EX_ROLES = [
  "Engineering / Technical",
  "Product Management",
  "Marketing / Brand",
  "Sales / Business Development",
  "Consulting / Strategy",
  "Operations / Supply Chain",
  "Finance / Accounting",
  "General Management / Leadership",
  "HR / People",
  "Design / UX",
  "Other",
] as const;

// Term 2 Flexi Core — pick min 2, max 3 (course codes match the `courses` table).
export const TERM2_FLEXI_OPTIONS = [
  { code: "BSNS2", label: "Business, Society & Non-Market Strategies" },
  { code: "FRNT3", label: "Frontier Technologies" },
  { code: "NMEU2", label: "Navigating Macro-economic Uncertainty" },
] as const;

// Term 3 Flexi Core — pick min 2, max 3. Only one Business Analytics variant
// is realistic (ISB only allows one), noted as helper text in the UI.
export const TERM3_FLEXI_OPTIONS = [
  { code: "BACF2", label: "Business Analytics for Corporate Finance" },
  { code: "BANM2", label: "Business Analytics for Marketing and Growth" },
  { code: "MADM2", label: "Managerial Accounting in Decision Making" },
  { code: "PADM2", label: "Prescriptive Analytics for Business Decision Making" },
  { code: "ASMD2", label: "The Art and Science of Managerial Decision-Making" },
] as const;

export const MAX_CONCENTRATIONS = 2;

export const ALL_TERMS = [
  "Term 1", "Term 2", "Term 3", "Term 4", "Term 5", "Term 6", "Term 7",
  "Block Week 1", "Block Week 2", "Block Week 3", "Block Week 4",
] as const;

// Course-scoped resource types, grouped into at most 4 tabs per course (per
// Eshan: don't let this sprawl past 4). Platform Directory and General sit
// outside this — they're not tied to a specific course.
export const RESOURCE_TABS = [
  { key: "course_details", label: "Course Details", types: ["Course Outline", "Professor Profile"] },
  { key: "session_resources", label: "Session Resources", types: ["Slides", "Session Transcript", "Summary"] },
  { key: "exam_resources", label: "Exam Resources", types: ["PYQP", "Custom GPT", "Cheatsheet", "Student Notes"] },
  { key: "others", label: "Others", types: ["Other"] },
] as const;

export const COURSE_RESOURCE_TYPES = RESOURCE_TABS.flatMap((t) => t.types);
export const RESOURCE_TYPES = [...COURSE_RESOURCE_TYPES, "Platform Directory", "General"] as const;

export function tabForResourceType(type: string) {
  return RESOURCE_TABS.find((t) => (t.types as readonly string[]).includes(type));
}

export const NOTIFICATION_TAGS = ["Urgent", "Important", "Info", "General"] as const;
