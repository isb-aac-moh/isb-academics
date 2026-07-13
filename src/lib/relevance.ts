import type { Course, StudentAcademicProfile } from "../types";

// Soft, informational tags only — never a ranking or a "you should pick this."
// Just context: does this line up with something the student already told us.
export const WORK_EX_AREA_HINTS: Record<string, string[]> = {
  "IT / Technology / Software": ["Information Technology Management"],
  "Management Consulting": ["Strategy and Leadership"],
  "Banking / Financial Services": ["Finance"],
  "FMCG / Consumer Goods": ["Marketing"],
  "Manufacturing / Engineering": ["Operations Management", "Manufacturing"],
  "Healthcare / Pharma": ["Healthcare"],
  "E-commerce / Retail": ["Marketing"],
  "Startups / Entrepreneurship": ["Entrepreneurship"],
  "Public Sector / Government / Defence": ["Public Policy"],
  "Media / Marketing / Advertising": ["Marketing"],
  "Non-profit / Social Sector": ["Public Policy"],
};

// Role/function cuts across domain — a "Product Management" role in an IT
// domain points somewhere different than an "Engineering" role in the same
// domain, which is exactly the gap a domain-only tag can't see.
export const WORK_EX_ROLE_AREA_HINTS: Record<string, string[]> = {
  "Engineering / Technical": ["Information Technology Management"],
  "Product Management": ["Information Technology Management", "Marketing"],
  "Marketing / Brand": ["Marketing"],
  "Sales / Business Development": ["Marketing", "Entrepreneurship"],
  "Consulting / Strategy": ["Strategy and Leadership"],
  "Operations / Supply Chain": ["Operations Management", "Manufacturing"],
  "Finance / Accounting": ["Finance"],
  "General Management / Leadership": ["Strategy and Leadership"],
  "HR / People": ["Strategy and Leadership"],
  "Design / UX": ["Marketing", "Information Technology Management"],
};

export function relevanceTags(course: Course, profile: StudentAcademicProfile, allCourses: Course[]): string[] {
  const tags: string[] = [];
  const courseAreas = [...course.concentration_areas, ...course.industry_specializations];

  const domainAreas = WORK_EX_AREA_HINTS[profile.work_ex_domain] ?? [];
  const roleAreas = WORK_EX_ROLE_AREA_HINTS[profile.work_ex_role] ?? [];

  if (profile.work_ex_role && roleAreas.some((a) => courseAreas.includes(a as never))) {
    tags.push(`Matches your role (${profile.work_ex_role})`);
  } else if (domainAreas.some((a) => courseAreas.includes(a as never))) {
    tags.push(`Matches your work-ex (${profile.work_ex_domain})`);
  }

  const completedCodes = [...profile.completed_term2_flexi, ...profile.completed_term3_flexi];
  const completedAreas = new Set(
    allCourses.filter((c) => completedCodes.includes(c.code)).flatMap((c) => [...c.concentration_areas, ...c.industry_specializations])
  );
  if (courseAreas.some((a) => completedAreas.has(a))) {
    tags.push("Builds on a Term 2/3 course you already took");
  }

  return tags;
}
