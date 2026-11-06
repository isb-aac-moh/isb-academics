import { type Concept, coursesOf } from "./data";

export interface Topic { id: string; name: string; blurb: string }
export const TOPICS: Topic[] = [
  { id: "strategy", name: "Strategy & competition", blurb: "Where to play, how to win, and how rivals respond" },
  { id: "marketing", name: "Customers & marketing", blurb: "Segments, positioning, brands and research" },
  { id: "pricing", name: "Pricing & business models", blurb: "How a business charges and makes money" },
  { id: "growth", name: "Growth & go-to-market", blurb: "Launching, selling and scaling a product" },
  { id: "ops", name: "Operations & supply chain", blurb: "Capacity, inventory, process and flow" },
  { id: "data", name: "Data, analytics & experiments", blurb: "Metrics, models, tests and reading evidence" },
  { id: "ai", name: "AI & technology", blurb: "How AI and software work, and what they change" },
  { id: "product", name: "Product management", blurb: "The PM role, discovery, design and delivery" },
  { id: "finance", name: "Finance & profitability", blurb: "Unit economics, profit, cost and deals" },
  { id: "people", name: "People, leadership & ethics", blurb: "Teams, stakeholders, trust and responsibility" },
  { id: "cases", name: "Case interview toolkit", blurb: "Structuring, case maths, guesstimates and exhibits" },
  { id: "industries", name: "Industries & contexts", blurb: "How the playbook changes by sector" },
];
export const topicById = (id: string) => TOPICS.find(t => t.id === id);

// Prep-graph module names -> one student-facing topic. First match wins, so order matters.
const RULES: [RegExp, string][] = [
  [/^Communication$|Guesstimate|Case maths: core|Case flow|Structuring|Framing|Exhibits|Interview wrapper|Hypothesis|^Analysis$|^Execution$|Unconventional|Core frameworks|Extended frameworks/, "cases"],
  [/^Product Strategy|PM Role|Product Thinking|Problem &|Discovery|Solution Design|Requirements|Prioritisation|Roadmapping|Delivery|UX|Quality|Product Organisation|Qualitative/, "product"],
  [/Pricing|Business Models/, "pricing"],
  [/Positioning|Customer and marketing|Customer Modelling|Consumer Products/, "marketing"],
  [/Growth|Go-to-Market|^Sales|New product launch/, "growth"],
  [/Industrials|Mobility|Technology, media|Public sector|^Health$|Sustainability|Financial services|B2B|Physical Goods|^Consumer$|Hardware|Digital and technology/, "industries"],
  [/Finance|Financial|Profitability|Cost reduction|M&A|Corporate, finance/, "finance"],
  [/Experimentation|Analytics|Metrics/, "data"],
  [/\bAI\b|LLM|Agentic|Technical Fluency/, "ai"],
  [/^Operations/, "ops"],
  [/Leadership|Organisation|Ethics|Privacy|Stakeholder|^Team|people/, "people"],
  [/Strategy|Moats|Platforms|Market entry|Competitive|Turnaround/, "strategy"],
];
const COURSE_TOPIC: Record<string, string> = { STRG: "strategy", MKTG: "marketing", OPMG: "ops", BANM: "data", SWPM: "product", FRNT: "ai", FADM: "finance", FCRV: "finance", MGEC: "strategy", SMDM: "data",
  LSAT: "people", ASMD: "people", HCEN: "industries", SUET: "people", ENTR: "growth", BSNS: "strategy", MKTR: "marketing", ABTE: "data", CDMA: "finance", WACM: "people", ELP: "people", MKTS: "marketing" };

export function topicOf(c: Concept): string {
  for (const m of Object.values(c.module)) for (const [re, t] of RULES) if (re.test(m)) return t;
  const first = coursesOf(c)[0];
  return (first && COURSE_TOPIC[first]) || "product";
}
export const moduleOf = (c: Concept) => Object.values(c.module)[0] || "";
/** First sentence of the plain-English explainer, falling back to the one-line definition. */
export function oneLine(c: Concept): string {
  const t = c.know?.what || c.obj || c.definition || c.q || "";
  const m = t.match(/^.*?[.!?](\s|$)/); return (m ? m[0] : t).trim();
}
