import { Link } from "react-router-dom";
import { coursesOf, type Store } from "../lib/data";
import { SectionLabel } from "../components";

type Status = "live" | "pilot" | "launch" | "reach" | "later" | "no";
const STATUS: Record<Status, string> = { live: "In this preview", pilot: "Pilot", launch: "Launch", reach: "Reach", later: "Later", no: "Not planned" };
const Chip = ({ s }: { s: Status }) => <span className={"st " + s}>{STATUS[s]}</span>;

const FEATURES: { name: string; what: string; s: Status; to?: string }[] = [
  { name: "Search any idea", what: "Typo and nickname tolerant. Finds the idea, then every course and session that taught it.", s: "live", to: "/compass" },
  { name: "Idea page", what: "Plain-English explainer, where it was taught, how it connects, a link to the class slides in Moodle.", s: "live" },
  { name: "Topics and course revision", what: "Everything taught grouped by topic, or one course grouped by topic or by session.", s: "live", to: "/compass/topics" },
  { name: "Role prep kits", what: "Product and Consulting interview ideas, with the ISB class that covered each.", s: "live", to: "/compass/prep" },
  { name: "Map of ideas", what: "Every topic or course as a block. Click an idea to see what to learn first and what it leads to, across topics and courses.", s: "live", to: "/compass/map" },
  { name: "Across courses table", what: "Which course teaches which idea, in which session, and where courses overlap.", s: "live", to: "/compass/compare" },
  { name: "Personal progress", what: "Mark ideas you know. Stays in your own browser.", s: "live" },
  { name: "ISB Microsoft sign-in, roles, audit log", what: "Only ISB accounts. Every access recorded.", s: "pilot" },
  { name: "Official course feed", what: "Slides, outlines, ISB-authored course packs and transcripts for Terms 1 to 4, with course, campus, year and professor on each.", s: "launch" },
  { name: "Human-verified links with reasons", what: "Cross-course “also taught in” claims go live only after a person checks them.", s: "launch" },
  { name: "Secure source viewer", what: "Page-level view with a per-user mark. No downloads, daily limits.", s: "launch" },
  { name: "Report a problem, reviewer console, one-click unpublish", what: "A wrong link reaches a reviewer the same day. A faculty member can withdraw a course in minutes.", s: "launch" },
  { name: "Privacy notice and quality gates", what: "Minimal logging, deletion on request, citation and search accuracy measured every release.", s: "launch" },
  { name: "Connector for your own AI", what: "Read-only, returns idea cards and pointers only, never files.", s: "reach" },
  { name: "Faculty console", what: "Faculty see how their course feeds others, correct errors, withdraw content.", s: "reach" },
  { name: "Compare a course across campuses and years", what: "Same course, different cohorts.", s: "reach" },
  { name: "Remaining role kits, Terms 5 to 7", what: "More roles and later terms.", s: "reach" },
  { name: "In-app AI helper", what: "Only after eight weeks of usage data, funded by ISB.", s: "later" },
  { name: "Assessment mode, lens builder for clubs, alumni, practice questions, Teams and Moodle plugin", what: "Extensions once the base is trusted.", s: "later" },
  { name: "Elective rankings, placement prediction, student uploads, individual dashboards, audio and video", what: "Out of scope on purpose.", s: "no" },
];
const PHASES = [
  { n: "0", name: "Pilot", when: "Now to 10 Nov 2026", what: "Search, idea pages and a role kit on outlines, idea names and pointers only. No files or transcripts. Up to 50 students.", gate: "60% of searches reach a source; zero incidents" },
  { n: "1", name: "ISB tenant and full load", when: "Nov to mid-Jan", what: "ISB-owned cloud live. Terms 1 to 4 loaded, links verified, secure viewer, three role kits, cohort launch.", gate: "95% citation precision; right result in top 3 for 85% of searches; security review passed; faculty opt-out window closed" },
  { n: "2", name: "Reach", when: "Jan to Mar 2027", what: "Map for everyone, connector, faculty console, course pages, remaining role kits, Terms 5 to 7.", gate: "Steady weekly use; half the courses verified by faculty" },
  { n: "3", name: "Decide and extend", when: "Apr to Jul 2027", what: "Go or no-go on an AI helper, alumni access, next cohort loaded at orientation.", gate: "Steering group review" },
];
const GUARDS = [
  "Sign-in restricted to ISB Microsoft accounts. No public data endpoints.",
  "Content stays in an ISB-owned cloud in India, encrypted with ISB-held keys.",
  "No file downloads. Source pages open in a viewer with a per-user mark, with daily limits.",
  "No slide text or transcripts are sent to an AI model when someone uses Compass. AI is used while building the knowledge base.",
  "Any course can be withdrawn by faculty in under five minutes. Every access is logged.",
  "Search logs are short, linked to the user for 12 months, and staff only see groups of 10 or more.",
];
const ASKS = [
  ["Confirm ISB's cloud (Azure assumed) and open an India-region subscription", "ISB IT", "23 Oct"],
  ["Register the sign-in app; schedule the security review", "ISB IT", "6 Nov"],
  ["Content licence and faculty notice with a two-week opt-out", "Dean's office", "30 Oct"],
  ["Official read-only access to course files and transcripts", "ISB IT, AAC", "6 Nov"],
  ["Rights position on course packs and transcripts; student privacy notice", "Legal", "30 Oct"],
  ["Role and task lists for three roles; name the reviewers", "Career Services, clubs, AAC", "6 Nov"],
  ["Placement calendar; written permission to use the Product Management graph", "AAC", "23 Oct"],
];
const QUESTIONS: [string, string[]][] = [
  ["Students", ["Would you open this the night before an exam or an interview?", "What did you look for that it could not find?", "Which view helped most: search, topics, prep kit, map or the across-courses table?"]],
  ["Faculty and AAC", ["Is the explanation of each idea fair to how you teach it?", "Which links between courses are wrong or missing?", "What would you need to see before agreeing to a pilot with your course in it?"]],
  ["IT and security", ["Does the proposed ISB-owned cloud, sign-in and logging design meet your bar?", "Which review steps and lead times should we plan for?"]],
  ["Operations and administration", ["Who owns the yearly refresh of course material?", "Who owns the alias list and the report-a-problem queue?"]],
];

export default function RoadmapPage({ store }: { store: Store; lens: string }) {
  const all = Object.values(store.data.concepts); const taught = all.filter(c => coursesOf(c).length);
  const ids = new Set(taught.map(c => c.id)); const links = taught.reduce((n, c) => n + c.rel.filter(r => ids.has(r.to)).length, 0);
  const sessions = store.data.courses.reduce((n, c) => n + c.sessions.filter(s => s.concepts.length).length, 0);
  const bridges = taught.filter(c => coursesOf(c).length >= 2).length;
  return <section className="road">
    <div className="ph" style={{ marginTop: 26 }}><h1>Compass <em>roadmap</em></h1><p className="sub">One searchable, connected memory of everything ISB teaches, built from ISB's own course material. Placement preparation is the first use. This page shows what exists today, what comes next, and what we need from ISB to get there.</p></div>
    <div className="note" style={{ marginTop: 16 }}><b>This is a pilot preview.</b> It covers {store.data.courses.length} courses from one cohort. Idea summaries are written by AI from course material, and some links between ideas are AI suggestions that a person has not yet verified. It shows what the product will do, not the final content.</div>
    <div className="stats" style={{ maxWidth: 900 }}>
      <div className="stat"><small>Courses loaded</small><b>{store.data.courses.length}</b></div><div className="stat"><small>Ideas taught</small><b>{taught.length}</b></div>
      <div className="stat"><small>Ideas in 2+ courses</small><b>{bridges}</b></div><div className="stat"><small>Links between ideas</small><b>{links}</b></div><div className="stat"><small>Sessions mapped</small><b>{sessions}</b></div></div>

    <SectionLabel>The problem and the idea</SectionLabel>
    <div className="two"><div className="panel"><p><b>The problem.</b> ISB has about 138 courses and 1,300 class sessions a year. The material is spread across Moodle, SharePoint, personal drives and WhatsApp. Students forget what was taught, cannot see how ideas connect across courses, and cannot find the right slide when they need it.</p></div>
      <div className="panel"><p><b>The idea.</b> When I need to use something I was taught for an interview, an exam, a case or a project, help me find it and see how it connects, so I can use it with confidence. No chatbot: a search box, an idea page with sources, and a map.</p></div></div>

    <SectionLabel>Everything Compass will do, and when</SectionLabel>
    <div className="feat">{FEATURES.map(f => <div key={f.name} className="fcard"><div className="ft"><b>{f.name}</b><Chip s={f.s} /></div><p>{f.what}</p>{f.to && <Link to={f.to} className="try-it">Try it →</Link>}</div>)}</div>

    <SectionLabel>Phases and the gate to move on</SectionLabel>
    <div className="phases">{PHASES.map(p => <div key={p.n} className="phase"><div className="pn">{p.n}</div><div><b>{p.name}</b> <span className="small">· {p.when}</span><p>{p.what}</p><p className="small"><b>To proceed:</b> {p.gate}</p></div></div>)}</div>

    <SectionLabel>How Compass protects ISB's content</SectionLabel>
    <ul className="plain">{GUARDS.map(g => <li key={g}>{g}</li>)}</ul>
    <p className="small">What it cannot do: stop a student photographing a screen. The per-user mark deters and traces it.</p>

    <SectionLabel>What we need from ISB</SectionLabel>
    <div className="tablewrap"><table className="cmp asks"><thead><tr><th>Decision or action</th><th>Owner</th><th>Needed by</th></tr></thead><tbody>{ASKS.map(a => <tr key={a[0]}><td>{a[0]}</td><td>{a[1]}</td><td>{a[2]}</td></tr>)}</tbody></table></div>
    <p className="small" style={{ marginTop: 8 }}>Approval requested: (1) an ISB-owned cloud environment in an India region, (2) official access to course files and transcripts, (3) a faculty notice with opt-out. Estimated cloud and AI cost: ₹5.4 to 7.6 lakh a year. People time is internal.</p>

    <SectionLabel>What we want your view on</SectionLabel>
    <div className="two">{QUESTIONS.map(([who, qs]) => <div key={who} className="panel"><b>{who}</b><ul className="plain">{qs.map(x => <li key={x}>{x}</li>)}</ul></div>)}</div>
  </section>;
}
