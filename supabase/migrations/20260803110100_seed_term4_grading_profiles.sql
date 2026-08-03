-- Term 4 grading profiles, extracted from the official 2026-27 ISB course outlines
-- (ISB SharePoint, PGP_Mohali/2026-2027/Course_Outlines/Term 4). Grading composition
-- and exam counts are read directly off each outline's evaluation table; the 0-5
-- workload scores are a judgment call, admin-editable via the Courses admin tab.
-- SUET and CMGT have no outline uploaded yet as of this migration — skipped.

insert into public.course_grading_profiles
  (course_id, grade_participation_pct, grade_individual_pct, grade_group_pct, grade_exam_pct,
   exam_midterm_count, exam_endterm_count, exam_quiz_count,
   load_quant, load_assignments, load_participation, load_exam_pressure, load_group, load_reading,
   brief, source_url, extracted_at)
select c.id, v.p, v.i, v.g, v.e, v.mid, v.endt, v.quiz, v.q, v.a, v.lp, v.le, v.lg, v.r, v.brief::jsonb, v.url, now()
from (values

  ('CAMS', 20, 50, 30, 0, 0, 0, 0, 2, 4, 4, 0, 3, 3, $b$[
    {"label":"About","text":"Builds one integrated framework for market access — GTM, channels, partnerships, omnichannel, and platforms — across 10 sessions culminating in a real-company Market Access Strategy."},
    {"label":"Exams","text":"None — grading is all coursework (memos, challenge, project)."},
    {"label":"Groups","text":"Up to 5, can span sections; may include peer evaluation."},
    {"label":"Work","text":"Individual executive decision memos plus a decision challenge, and one cumulative group strategy project with a final boardroom presentation."},
    {"label":"Notes","text":"Case-and-discussion heavy; light on quant, marketing/strategy oriented."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/CAMS_274.pdf'),

  ('CCMA', 0, 0, 50, 50, 0, 1, 4, 5, 4, 2, 4, 4, 3, $b$[
    {"label":"About","text":"Hands-on M&A — valuation, synergy, financing structure, and deal recommendations, built incrementally through a semester-long team deal."},
    {"label":"Exams","text":"One final exam plus four in-class quizzes (best 3 of 4 count)."},
    {"label":"Groups","text":"Up to 4, self-register on LMS (randomly assigned if you don't)."},
    {"label":"Work","text":"Individual quizzes and final exam; group deal-analysis project in 4 milestones plus a peer evaluation component."},
    {"label":"Notes","text":"Heavy Excel/financial modeling; no finance prerequisite assumed, workload pitched as light-to-moderate."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/CCMA_274.pdf'),

  ('ENTR', 25, 10, 50, 15, 0, 0, 1, 1, 3, 5, 1, 4, 3, $b$[
    {"label":"About","text":"Entrepreneurial mindset across startups, corporate ventures, and social impact — not limited to new-venture creation (that's covered later in ENVC)."},
    {"label":"Exams","text":"No formal exam; assessed via quizzes, a survey, participation, and group work."},
    {"label":"Groups","text":"4-5 members, self-selected by students."},
    {"label":"Work","text":"A short survey, in-class quizzes, and two-to-three group assignments culminating in team presentations."},
    {"label":"Notes","text":"Case-and-discussion heavy; minimal quant (basic algebra level)."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/ENTR_274.pdf'),

  ('FSAN', 10, 0, 50, 40, 0, 1, 0, 4, 4, 2, 4, 4, 3, $b$[
    {"label":"About","text":"Reading and using financial statements to judge a firm's strategy, risk, and reporting quality — includes real accounting-fraud cases (Enron, WorldCom, Satyam)."},
    {"label":"Exams","text":"One 3-hour open-book, open-notes final exam on laptop, no makeups."},
    {"label":"Groups","text":"Self-formed groups of 5, cannot mix across sections."},
    {"label":"Work","text":"Four group case assignments plus a group company-analysis project."},
    {"label":"Notes","text":"Accounting-standards focus; moderate quant/ratio analysis."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/FSAN_274.pdf'),

  ('GPMK', 20, 30, 50, 0, 0, 0, 0, 3, 4, 5, 0, 4, 3, $b$[
    {"label":"About","text":"Growth and performance marketing as an integrated discipline — acquisition, measurement/attribution, retention, advocacy, trust, and platform/AI strategy — via live cases with InMobi, CleverTap, and Adfactors."},
    {"label":"Exams","text":"None — assessed on judgement in decision briefs, live cases, and a simulation."},
    {"label":"Groups","text":"Up to 5, can span sections; may include peer evaluation."},
    {"label":"Work","text":"Individual decision briefs, group live-case exercises and workshops, an Adobe DDOM growth simulation, and a final group growth-strategy presentation."},
    {"label":"Notes","text":"Participation-heavy — assessment leans on in-class judgement over mechanical correctness."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/GPMK_274.pdf'),

  ('GSMT', 10, 40, 0, 50, 0, 1, 0, 2, 4, 2, 5, 1, 4, $b$[
    {"label":"About","text":"Competing across borders — global expansion, institutional environment, corporate governance — through 10 cases (AmorePacific, Emirates, Satyam, Alibaba, and more)."},
    {"label":"Exams","text":"One closed-book final exam, three hours, applying frameworks to case questions."},
    {"label":"Groups","text":"None — every deliverable is individual."},
    {"label":"Work","text":"Five individual assignments (pick one per week, plus an optional 6th to drop your lowest)."},
    {"label":"Notes","text":"Reading and framework heavy."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/GSMT_274.pdf'),

  ('GENAI', 10, 40, 50, 0, 0, 0, 0, 1, 4, 3, 0, 4, 2, $b$[
    {"label":"About","text":"Hands-on generative AI — LLM fundamentals, prompting, AI agents/MCPs, monetization, and ethics — with an in-class exercise almost every session."},
    {"label":"Exams","text":"None — end-term is a group ad-campaign project plus a group essay."},
    {"label":"Groups","text":"Small, self-chosen; pick their own product to campaign for."},
    {"label":"Work","text":"Individual case write-ups and a prompting/reflective essay; group ad-campaign project and a group essay on AI leadership."},
    {"label":"Notes","text":"Practical and tool-driven; students get a GPT-4 subscription for the course."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/GenAI_274.pdf'),

  ('INEC', 0, 30, 30, 40, 1, 0, 8, 3, 4, 2, 4, 3, 4, $b$[
    {"label":"About","text":"Strategic decisions under imperfect information — signalling, screening, search, social learning, and auctions — taught through in-class online games (veconlab.com)."},
    {"label":"Exams","text":"One closed-book midterm plus eight reading quizzes (best 6 of 8 count)."},
    {"label":"Groups","text":"Self-formed, up to 5, confirmed before Session 8."},
    {"label":"Work","text":"A homework assignment, quizzes, the midterm, and a team project report."},
    {"label":"Notes","text":"Attendance is mandatory for the in-class games; moderate quant (game theory, Class-12 math)."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/INEC_274.pdf'),

  ('INVT', 0, 0, 40, 60, 0, 1, 2, 5, 3, 1, 5, 3, 3, $b$[
    {"label":"About","text":"Portfolio management and asset allocation — risk/return, CAPM and factor models, active management, market efficiency — through two cases (AQR, Yale) and a “Manage a Mandate” group project."},
    {"label":"Exams","text":"One end-term final exam plus in-class quizzes (Sessions 4 and 7)."},
    {"label":"Groups","text":"Formed within your own section (needed for Session 10 in-class presentations)."},
    {"label":"Work","text":"Two group case write-ups, a group portfolio-mandate project, individual quizzes, and the final exam."},
    {"label":"Notes","text":"Finance- and Excel-heavy; 60% individual / 40% group by weight; 100%-attendance policy with automatic grade drops for misses."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/INVT_274.pdf'),

  ('LPFW', 10, 40, 50, 0, 0, 0, 0, 1, 5, 3, 0, 4, 2, $b$[
    {"label":"About","text":"Future-of-work themes — AI and work models, careers, people analytics, coaching, talent — built around your own career-transition plan."},
    {"label":"Exams","text":"None."},
    {"label":"Groups","text":"5-6, mixed across streams (not across sections)."},
    {"label":"Work","text":"One individual “dream job” pitch (video or write-up) and one group future-readiness assessment of a company."},
    {"label":"Notes","text":"Reflective and applied; minimal quant, heavy self-analysis."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/LPFW_274.pdf'),

  ('LSCM', 10, 0, 50, 40, 0, 1, 0, 5, 4, 2, 4, 4, 3, $b$[
    {"label":"About","text":"Supply chain strategy and design — networks, transportation, inventory, coordination, the Bullwhip effect — via a facility-location simulation and an e-Beer Game."},
    {"label":"Exams","text":"One end-term final exam, multiple-choice with short justifications."},
    {"label":"Groups","text":"Pre-set case groups; discussing assignments across groups is prohibited."},
    {"label":"Work","text":"Two group assignments (transportation/distribution, inventory), a group project comparing supply chains across firms, plus 1-page case write-ups that count toward participation."},
    {"label":"Notes","text":"Quantitative and modelling-heavy; Excel/Solver expected."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/LSCM_274.pdf'),

  ('MGSP', 15, 40, 45, 0, 0, 0, 0, 2, 5, 3, 0, 4, 3, $b$[
    {"label":"About","text":"Alliances, joint ventures, corporate venturing, and outsourcing — build vs. borrow vs. buy — through 10 cases including Microsoft-OpenAI, Geely-Volvo, and Honda-Rover; uses an LLM to aid learning."},
    {"label":"Exams","text":"None."},
    {"label":"Groups","text":"Small teams for case reports and the final project; peer evaluation can differentiate individual grades."},
    {"label":"Work","text":"Two individual assignments, two AI-assisted individual assignments, two group case reports, and a group project on a real/proposed alliance."},
    {"label":"Notes","text":"Discussion-driven; participation matters, light-to-moderate quant."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/MGSP_274.pdf'),

  ('MKTR', 15, 0, 60, 25, 0, 1, 0, 3, 4, 3, 3, 5, 3, $b$[
    {"label":"About","text":"Consumer research methods mapped to the product life cycle — ethnography, conjoint/MaxDiff, eye-tracking, social listening, AI-assisted analysis — hands-on with Qualtrics, Sawtooth, and RealEye."},
    {"label":"Exams","text":"One open-book, open-notes final exam."},
    {"label":"Groups","text":"Self-formed, 5 members, mixed."},
    {"label":"Work","text":"In-class group exercises, two group case discussions, a group final PLC-roadmap project, plus the final exam."},
    {"label":"Notes","text":"Research-methods and analytical; most weight (60%) is group-based."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/MKTR_274.pdf'),

  ('OPFR', 25, 0, 20, 55, 1, 1, 0, 5, 3, 4, 5, 2, 3, $b$[
    {"label":"About","text":"How derivatives work, are valued, and are used to trade and hedge — futures, swaps, options, Black-Scholes — via short, mostly India-relevant cases."},
    {"label":"Exams","text":"A midterm and an end-term, both individual."},
    {"label":"Groups","text":"Two Excel-based “Equity Levers” group assignments using real market data."},
    {"label":"Work","text":"Group assignments, class participation (graded on case/article discussion), midterm, and end-term."},
    {"label":"Notes","text":"Excel required; grades curved across all sections."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/OPFR_274.pdf'),

  ('PRCG', 15, 30, 40, 15, 0, 0, 1, 3, 4, 3, 1, 3, 2, $b$[
    {"label":"About","text":"A systematic framework for pricing decisions — costs/margins, price sensitivity, product-line and competitive pricing, psychological pricing — through 4 case write-ups."},
    {"label":"Exams","text":"No final exam — one in-class scheduled quiz instead (Session 8)."},
    {"label":"Groups","text":"4-5, can be formed across sections."},
    {"label":"Work","text":"One individual case write-up (Singapore Metals), three group case write-ups, two individual problem sets, and the scheduled quiz."},
    {"label":"Notes","text":"No mandatory-attendance grade penalty, but participation is still 15% of the grade."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/PRCG_274.pdf'),

  ('SWPM', 10, 40, 50, 0, 0, 0, 0, 2, 5, 3, 0, 4, 2, $b$[
    {"label":"About","text":"The full PM lifecycle in one term — customer discovery through a shipped, measured product — using AI build tools (Lovable, v0, Cursor, Claude Code) toward a live Demo Day."},
    {"label":"Exams","text":"None — a Final Demo replaces a sit-down exam."},
    {"label":"Groups","text":"4-5, self-selected; groups build one real product together across the term."},
    {"label":"Work","text":"A group discovery-hypothesis doc, individual MVP-prioritization rationale and product-strategy docs, a group metrics dashboard, an individual reflection essay, and a group Final Demo."},
    {"label":"Notes","text":"Field-based and build-heavy; explicitly leans on AI tools as part of the PM workflow."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/SWPM_274.pdf')

) as v(code, p, i, g, e, mid, endt, quiz, q, a, lp, le, lg, r, brief, url)
join public.courses c on c.code = v.code and c.term = 'Term 4'
on conflict (course_id) do nothing;
