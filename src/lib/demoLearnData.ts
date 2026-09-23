// Fictional Smart Practice content for the recruiter demo — two courses' worth of questions,
// concepts, and a bit of practice history for the demo student, so the Learn section isn't empty.
// Raw DB column names (course_code, not course_id) — see learn/lib/db.ts for why.
import { DEMO_USER_ID } from "./demoMode";
import type { CohortStats, TopicStat, FlaggedQuestion } from "../learn/types";

export const DEMO_LEARN_COURSES = [
  { course_code: "MKTG4", total_sessions: 6, enabled: true, sort_order: 1 },
  { course_code: "OPMG4", total_sessions: 6, enabled: true, sort_order: 2 },
];

export const DEMO_LEARN_QUESTIONS = [
  {
    id: "lq-1", course_code: "MKTG4", type: "formula", topic: "Break-even Analysis", session: 1,
    prompt: "A product has a fixed cost of ₹4,00,000, sells for ₹500, and has a variable cost of ₹300 per unit. What is the break-even quantity?",
    choices: ["800 units", "1,333 units", "2,000 units", "4,000 units"], correct_answer: "2,000 units",
    explanation: "Break-even quantity = Fixed cost / (Price - Variable cost) = 4,00,000 / (500 - 300) = 2,000 units.",
    source: "Session 1 case", scenario_id: null, scenario_order: null, difficulty: 2, provenance: "authored", hint: "Divide fixed cost by the contribution margin per unit.",
  },
  {
    id: "lq-2", course_code: "MKTG4", type: "case_fact", topic: "Customer Lifetime Value", session: 2,
    prompt: "In the session 2 case, what discount rate did the team use to compute CLV?",
    choices: ["8%", "10%", "12%", "15%"], correct_answer: "10%", explanation: "The case specifies a 10% annual discount rate for CLV computation.",
    source: "Session 2 case", scenario_id: "ls-1", scenario_order: 1, difficulty: 1, provenance: "prof_verbatim", hint: null,
  },
  {
    id: "lq-3", course_code: "MKTG4", type: "formula", topic: "Customer Lifetime Value", session: 2,
    prompt: "A customer generates ₹5,000 profit/year, retention rate is 80%, and the discount rate is 10%. Approximate CLV?",
    choices: ["₹10,000", "₹16,667", "₹25,000", "₹50,000"], correct_answer: "₹16,667",
    explanation: "CLV ≈ margin / (1 + discount rate - retention rate) = 5,000 / (1 + 0.10 - 0.80) = 5,000 / 0.30 ≈ ₹16,667.",
    source: "Session 2 formula sheet", scenario_id: "ls-1", scenario_order: 2, difficulty: 3, provenance: "authored", hint: "Use the simplified CLV formula from the formula sheet.",
  },
  {
    id: "lq-4", course_code: "OPMG4", type: "formula", topic: "Economic Order Quantity", session: 1,
    prompt: "Annual demand is 10,000 units, ordering cost is ₹200/order, and holding cost is ₹4/unit/year. What is the EOQ?",
    choices: ["500", "707", "1,000", "1,414"], correct_answer: "1,000",
    explanation: "EOQ = sqrt(2 * D * S / H) = sqrt(2 * 10,000 * 200 / 4) = sqrt(1,000,000) = 1,000.",
    source: "Session 1 formula sheet", scenario_id: null, scenario_order: null, difficulty: 2, provenance: "authored", hint: "Plug into the standard EOQ formula.",
  },
  {
    id: "lq-5", course_code: "OPMG4", type: "case_fact", topic: "Newsvendor Model", session: 2,
    prompt: "In the session 2 newsvendor case, what was the critical fractile used to set the order quantity?",
    choices: ["0.4", "0.6", "0.7", "0.9"], correct_answer: "0.7", explanation: "Critical fractile = Cu / (Cu + Co), given as 0.7 in the case.",
    source: "Session 2 case", scenario_id: "ls-2", scenario_order: 1, difficulty: 2, provenance: "prof_adapted", hint: null,
  },
  {
    id: "lq-6", course_code: "OPMG4", type: "formula", topic: "Little's Law", session: 3,
    prompt: "Average inventory is 300 units and throughput is 60 units/day. What is the average flow time?",
    choices: ["2 days", "5 days", "6 days", "18,000 days"], correct_answer: "5 days",
    explanation: "Flow time = Inventory / Throughput = 300 / 60 = 5 days (Little's Law).",
    source: "Session 3 formula sheet", scenario_id: null, scenario_order: null, difficulty: 1, provenance: "authored", hint: "Little's Law: Inventory = Throughput × Flow time.",
  },
];

export const DEMO_LEARN_CONCEPTS = [
  { course_code: "MKTG4", topic: "Break-even Analysis", title: "Break-even Analysis", note: "Break-even quantity = Fixed cost / (Price - Variable cost). Used to size a launch before committing marketing spend.", resource_url: null },
  { course_code: "MKTG4", topic: "Customer Lifetime Value", title: "Customer Lifetime Value (CLV)", note: "CLV estimates the total profit a customer generates over the relationship, discounted for time and adjusted for churn.", resource_url: null },
  { course_code: "OPMG4", topic: "Economic Order Quantity", title: "Economic Order Quantity (EOQ)", note: "EOQ balances ordering cost against holding cost to minimize total inventory cost.", resource_url: null },
  { course_code: "OPMG4", topic: "Newsvendor Model", title: "Newsvendor Model", note: "Sets order quantity for perishable/seasonal goods using the critical fractile of underage vs. overage cost.", resource_url: null },
  { course_code: "OPMG4", topic: "Little's Law", title: "Little's Law", note: "Relates average inventory, throughput, and flow time in any stable process: Inventory = Throughput × Flow time.", resource_url: null },
];

export const DEMO_LEARN_SESSION_CONTENT = [
  { course_code: "MKTG4", session: 1, title: "Pricing & Break-even", summary: "How pricing decisions interact with fixed and variable cost structure.", resource_url: null, formula_sheet: "Break-even qty = Fixed cost / (Price - Variable cost)" },
  { course_code: "MKTG4", session: 2, title: "Customer Value", summary: "Estimating and using customer lifetime value in segmentation decisions.", resource_url: null, formula_sheet: "CLV ≈ Margin / (1 + r - retention)" },
  { course_code: "OPMG4", session: 1, title: "Inventory Fundamentals", summary: "Ordering and holding cost trade-offs behind the EOQ model.", resource_url: null, formula_sheet: "EOQ = sqrt(2DS/H)" },
  { course_code: "OPMG4", session: 2, title: "Demand Uncertainty", summary: "Setting order quantities under uncertain, one-shot demand.", resource_url: null, formula_sheet: "Critical fractile = Cu / (Cu + Co)" },
];

export const DEMO_LEARN_SCENARIOS = [
  { id: "ls-1", course_code: "MKTG4", session: 2, title: "Streaming subscription CLV", setup: "A streaming service wants to decide how much to spend acquiring a new subscriber, given their observed retention and margin.", source: "Session 2 case" },
  { id: "ls-2", course_code: "OPMG4", session: 2, title: "Seasonal apparel newsvendor", setup: "A retailer must place one pre-season order for a seasonal jacket with uncertain demand.", source: "Session 2 case" },
];

export const DEMO_LEARN_MATERIALS = [
  { id: "lm-1", course_code: "MKTG4", session: null, title: "Course Slides — Full Deck", kind: "slides", storage_path: "MKTG4/course/demo-slides.pdf", sort_order: 1 },
  { id: "lm-2", course_code: "OPMG4", session: 1, title: "Session 1 Case — Inventory Basics", kind: "case", storage_path: "OPMG4/1/demo-case.pdf", sort_order: 1 },
];

export const DEMO_LEARN_COURSE_CONTENT = [
  { course_code: "MKTG4", outline: "Six sessions covering pricing, customer value, segmentation, and brand strategy.", announcements: "Practice questions for sessions 1-3 are live.", cheatsheet_url: null, exam_samples_url: null, feedback_form_url: null },
  { course_code: "OPMG4", outline: "Six sessions covering inventory, queuing, and process capability.", announcements: "New questions added for Little's Law.", cheatsheet_url: null, exam_samples_url: null, feedback_form_url: null },
];

export const DEMO_LEARN_PROFILE = { user_id: DEMO_USER_ID, total_xp: 340, day_streak: 4, last_active_date: new Date().toISOString().slice(0, 10) };

export const DEMO_LEARN_MASTERY = [
  { user_id: DEMO_USER_ID, course_code: "MKTG4", topic: "Break-even Analysis", level: 3, consecutive_correct: 3, total_correct: 7, total_attempts: 8, last_seen_at: "2026-09-15T10:00:00Z" },
  { user_id: DEMO_USER_ID, course_code: "MKTG4", topic: "Customer Lifetime Value", level: 2, consecutive_correct: 1, total_correct: 3, total_attempts: 5, last_seen_at: "2026-09-16T10:00:00Z" },
  { user_id: DEMO_USER_ID, course_code: "OPMG4", topic: "Economic Order Quantity", level: 4, consecutive_correct: 5, total_correct: 9, total_attempts: 9, last_seen_at: "2026-09-14T10:00:00Z" },
  { user_id: DEMO_USER_ID, course_code: "OPMG4", topic: "Newsvendor Model", level: 1, consecutive_correct: 0, total_correct: 1, total_attempts: 3, last_seen_at: "2026-09-17T10:00:00Z" },
];

export const DEMO_LEARN_ATTEMPTS = [
  { id: "la-1", user_id: DEMO_USER_ID, question_id: "lq-1", correct: true, created_at: "2026-09-15T09:00:00Z" },
  { id: "la-2", user_id: DEMO_USER_ID, question_id: "lq-1", correct: true, created_at: "2026-09-15T09:05:00Z" },
  { id: "la-3", user_id: DEMO_USER_ID, question_id: "lq-2", correct: false, created_at: "2026-09-16T09:00:00Z" },
  { id: "la-4", user_id: DEMO_USER_ID, question_id: "lq-4", correct: true, created_at: "2026-09-14T09:00:00Z" },
  { id: "la-5", user_id: DEMO_USER_ID, question_id: "lq-5", correct: false, created_at: "2026-09-17T09:00:00Z" },
];

export const DEMO_COHORT_STATS: CohortStats = {
  total_students: 128,
  active_today: 34,
  active_this_week: 96,
  total_answered: 3542,
  total_correct: 2611,
};

export const DEMO_TOPIC_STATS: TopicStat[] = [
  { course_code: "MKTG4", topic: "Break-even Analysis", total: 410, accuracy: 0.78 },
  { course_code: "MKTG4", topic: "Customer Lifetime Value", total: 305, accuracy: 0.61 },
  { course_code: "OPMG4", topic: "Economic Order Quantity", total: 388, accuracy: 0.82 },
  { course_code: "OPMG4", topic: "Newsvendor Model", total: 260, accuracy: 0.55 },
];

export const DEMO_FLAGGED_QUESTIONS: FlaggedQuestion[] = [
  { question_id: "lq-5", prompt: "In the session 2 newsvendor case, what was the critical fractile used to set the order quantity?", topic: "Newsvendor Model", session: 2, total: 40, accuracy: 0.42 },
];
