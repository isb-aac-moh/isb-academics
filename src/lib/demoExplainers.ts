// Copy for the per-section demo explainer (see DemoSectionExplainer.tsx) — one entry per item in
// the sidebar. Each has two parts on purpose: what the section is (for someone outside ISB sizing
// up the product) and what a student actually does here (the real, everyday use).
export interface DemoExplainer {
  id: string;
  prefix: string;
  title: string;
  whatItIs: string;
  whatStudentsDo: string;
}

export const DEMO_EXPLAINERS: DemoExplainer[] = [
  {
    id: "learn",
    prefix: "/learn",
    title: "Learn — Smart Practice",
    whatItIs: "Adaptive practice questions generated from real course material, with XP, streaks, and per-topic mastery tracking.",
    whatStudentsDo: "Students use it between classes to drill their weakest topics until an exam question stops feeling like a guess.",
  },
  {
    id: "tracker",
    prefix: "/tracker",
    title: "Credit Tracker",
    whatItIs: "The single source of truth for \"am I on track to graduate\" — credit progress and GPA across every term.",
    whatStudentsDo: "Students use it to see concentration/specialization progress at a glance, and to reconcile what they actually got against what they planned to bid.",
  },
  {
    id: "planner",
    prefix: "/planner",
    title: "Bidding Planner",
    whatItIs: "ISB allocates electives through a real points auction, not first-come-first-served — students spend a fixed 4,500-point budget across terms.",
    whatStudentsDo: "Students use this 5-step planner to budget those points ahead of time, so they don't run out before hitting their credit requirements.",
  },
  {
    id: "pulse-check",
    prefix: "/pulse-check",
    title: "Bidding Pulse",
    whatItIs: "A crowdsourced, anonymous signal of what the rest of the cohort is planning to bid.",
    whatStudentsDo: "Students submit their own planned bid to see the cohort's range — a sanity check before real bidding opens.",
  },
  {
    id: "resources",
    prefix: "/resources",
    title: "Course Resources",
    whatItIs: "A searchable, crowdsourced library of everything tied to a course.",
    whatStudentsDo: "Students use it to find outlines, slides, past papers, and cheat sheets for any course, any term, in one place.",
  },
  {
    id: "notices",
    prefix: "/notices",
    title: "Notice Board",
    whatItIs: "Where ISB's Academic Council posts binding announcements — bidding windows, deadlines, policy changes.",
    whatStudentsDo: "This one's normally admin-only; you're seeing it because the demo account is an admin. Students get a read-only feed of the same notices.",
  },
  {
    id: "admin",
    prefix: "/admin",
    title: "Admin",
    whatItIs: "Behind-the-scenes tooling for the Academic Council — restricted to admins in the real product.",
    whatStudentsDo: "Manages the course catalog, resources, notices, nav links, and cohort-wide settings that everything else on this site reads from.",
  },
];

export function findExplainer(pathname: string): DemoExplainer | undefined {
  return DEMO_EXPLAINERS.find((e) => pathname.startsWith(e.prefix));
}
