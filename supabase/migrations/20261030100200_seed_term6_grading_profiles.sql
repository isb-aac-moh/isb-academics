-- Term 6 grading profiles, extracted from the official 2026-27 ISB course outlines
-- (ISB SharePoint, PGP_Mohali/2026-2027/Course_Outlines/Term 6), same method and shape
-- as 20260911123542_seed_term5_grading_profiles.sql plus the group / peer-evaluation /
-- attendance columns from 20260912090000. All 21 Term 6 electives have an outline, so
-- all 21 are covered. Grading composition and exam counts are read off each outline's
-- evaluation table; the 0-5 workload scores are a judgment call, admin-editable via the
-- Courses admin tab. Nulls mean "the outline doesn't say".
--
-- Judgment calls worth knowing about:
-- - DMKT and MCAP set their grading by a die roll in Lecture 2: on 1-4 there is no exam,
--   on 5-6 there is one MCQ midterm worth 25%. The percentages stored are the no-exam
--   outcome (2 in 3 odds); each brief describes both.
-- - CEOP's reflection paper and group project are 37.5% each; stored as 38 / 37 to stay
--   in whole numbers.
-- - Quizzes are counted as exam weight. TAAM and TATU hold 8 quizzes and count the best
--   5 at 12% each. MSDW's 15% "in-class assessments" give no count or format, so
--   quiz = 2 is a guess.
-- - NEGA2: the peer-evaluation text and the evaluation table disagree (15% vs 20%); the
--   table sums to 100, so its numbers are used.
-- - STRI's evaluation table is garbled in the PDF; weights come from its section headings.
-- - TAAM's 4% Personal Finance homework is group work submitted individually, stored as
--   individual.
-- - Attendance: where attendance is itself a graded component (CTFI, IDTF, RDFV, MKSV,
--   DMKT, MCAP) the bucket is Participation-linked. FINB is ISB policy because its text
--   says the standard policy applies, even though its graded item is "Attendance and
--   Class Participation".

insert into public.course_grading_profiles
  (course_id, grade_participation_pct, grade_individual_pct, grade_group_pct, grade_exam_pct,
   exam_midterm_count, exam_endterm_count, exam_quiz_count,
   load_quant, load_assignments, load_participation, load_exam_pressure, load_group, load_reading,
   brief, source_url, group_size, cross_section, group_formation, peer_eval, attendance, extracted_at)
select c.id, v.p, v.i, v.g, v.e, v.mid, v.endt, v.quiz, v.q, v.a, v.lp, v.le, v.lg, v.r, v.brief::jsonb, v.url,
       v.gsize, v.xsec, v.form, v.peer, v.att, now()
from (values
  ('AMCS', 15, 20, 45, 20, 0, 1, 0, 1, 3, 4, 3, 3, 2, $b$[
    {
        "label": "About",
        "text": "How marketing communication works in a digital world: consumer insight, media choice, brand positioning, message strategy, measuring return on investment and building a communication plan. Taught by a UCLA marketing professor (sessions 1-5) and a former US advertising agency president (sessions 6-10), so it mixes theory and practice."
    },
    {
        "label": "Exams",
        "text": "One in-class final exam after session 10 worth 20%, under the strict 4N code. The outline says the format is still to be discussed."
    },
    {
        "label": "Groups",
        "text": "5-6 students per group, formed within the same section or campus."
    },
    {
        "label": "Work",
        "text": "An individual case analysis on Nike's direct-to-consumer strategy due before session 4 (20%, 2 pages), a group creative brief due before session 7 (15%), and a group advertising plan for an Indian brand presented in session 10 (30%). Class participation is 15%."
    },
    {
        "label": "Notes",
        "text": "Cold calls on case days, and laptops and phones are meant to stay away during class. Missing sessions also lowers the participation grade. The schedule is tentative and the outline says it may change."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/AMCS_276.pdf',
   '5-6', false, null, false, 'ISB policy'),

  ('ARDA', 15, 40, 45, 0, 0, 0, 0, 1, 4, 3, 1, 4, 3, $b$[
    {
        "label": "About",
        "text": "How digital businesses are built, scaled, monetised and defended, in four modules: business models and technology inflection points, products to platforms and cloud economics, AI monetisation and digital as complement or substitute, then leading transformation, cyber crises and agentic AI. Cases include Nvidia, ElasticRun, Qihoo, Cloud Wars (AWS, Azure, GCP), AWS SageMaker, Chegg, Domino's, Stitch Fix and Anthropic 2025, with a platform-adoption simulation in session 5 and a ransomware case handed out in session 9."
    },
    {
        "label": "Exams",
        "text": "None — grading is a group project, individual case write-ups, one live in-class group case, a simulation write-up and participation."
    },
    {
        "label": "Groups",
        "text": "Teams of 5 for the group project, who pick one of five pre-defined digital opportunity spaces given at the start of the term. The in-class case is also done in groups (30 minutes to prepare, then present and defend), but the outline gives no size, formation or section rules."
    },
    {
        "label": "Work",
        "text": "A group project (30%) with a business model, platform or product strategy, AI-era monetisation model and a risk analysis including cyber, applying at least 3 course frameworks; three individual case write-ups due before their sessions (30% total); one group case assigned and defended in class on the day (15%); and an individual simulation write-up applying session 5 to a real company of your choice (10%)."
    },
    {
        "label": "Notes",
        "text": "Participation is 15%, quality over quantity, and opening each class with a current digital news item counts toward it. The ISB attendance policy applies and all work is coded 1N. Taught by Subodha Kumar and Sunil Wattal; office hours, sessions and sections are listed as TBD. The outline lists no textbook, software or prerequisites."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/ARDA_276.pdf',
   '5', null, null, false, 'ISB policy'),

  ('BPEX', 20, 40, 40, 0, 0, 0, 0, 1, 4, 3, 0, 4, 2, $b$[
    {
        "label": "About",
        "text": "Business processes as the basis of how organisations succeed or fail, covering volume, variety and variability, purchasing, sustainability, vulnerability, viability and visibility, brainstorming, B2B pricing, supply chain collaboration, the digital factory and business models. Cases include SER, Portugal Telecom (A), InterfaceRaise, Tetra Tech EC, IDEO Service Design (A), JD.com, Siemens digital manufacturing and Michelin Fleet Solutions."
    },
    {
        "label": "Exams",
        "text": "None — the 'midterm' and 'last week' entries in the schedule are take-home submission deadlines, not sit-down exams."
    },
    {
        "label": "Groups",
        "text": "Three students per group, from different educational backgrounds, formed within your section only (cross-section groups are not allowed)."
    },
    {
        "label": "Work",
        "text": "Individual coursework (40%): map an organisation's processes with purposes and metrics and propose a roadmap to process excellence, with a 2-3 page interim at midterm (10%) and a 6-8 page final in the last week (30%). Group coursework (40%): pick a sector with 3-4 companies, find leaders and laggards, and build a catch-up roadmap, with a 4-5 page interim at midterm (10%) and a 15-20 page final in the last week (30%). All are Word documents, 1.5 spacing, 12-point Times, coded 0N."
    },
    {
        "label": "Notes",
        "text": "Class participation is 20%. You may miss two classes; each further miss costs 5% points regardless of reason. Generative AI is allowed if used critically, with an appendix table of your main queries and what you did with the answers. This is not a quantitative course, there is no textbook or prerequisite, and only MS Office or equivalent is needed. Taught by Prof ManMohan Sodhi (Bayes Business School, City St. George's, University of London)."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/BPEX_276.pdf',
   '3', false, null, false, 'Stricter than ISB policy'),

  ('CEOP', 25, 38, 37, 0, 0, 0, 0, 1, 2, 4, 0, 3, 2, $b$[
    {
        "label": "About",
        "text": "Lessons from a CEO's seat across the value chain, with a lean toward FMCG but also startups and tech: strategy in disruptive times, executing strategy, business model innovation, leadership, crisis management, culture, sales and distribution channels, branding, managing your career and a VC's view of startups. Material includes the HBS cases on Nestlé and the Maggi recall, J&J Tylenol, the instructor's own Nespresso case and the film '13 Days'."
    },
    {
        "label": "Exams",
        "text": "None — the reflection paper and the project are both take-home and open book."
    },
    {
        "label": "Groups",
        "text": "5-6 members per team, formed within your section (cross-section teams are not allowed), working on how AI and shifting trade barriers could disrupt a job one of your team members will take after graduation."
    },
    {
        "label": "Work",
        "text": "An individual reflection paper (37.5%, max 2 A4 pages, PDF) applying something from class to an incident in your own career, and a group project (37.5%, max 4 A4 pages, PDF) on how to anticipate and prepare for AI or trade-barrier disruption to that job. Both are coded 0N and double-spaced in 11 or 12 point."
    },
    {
        "label": "Notes",
        "text": "Participation is 25%. Ten two-hour sessions, all in class with no recordings, and some guest sessions are planned but not confirmed. Core courses must be completed first, marketing in particular for sessions 3, 7 and 8. No textbook or software, and the ISB attendance policy applies. Taught by Doreswamy Nandkishore, who describes himself as a former Global CEO of Nestlé Nutrition."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/CEOP_276.pdf',
   '5-6', false, null, false, 'ISB policy'),

  ('COEN', 20, 60, 20, 0, 0, 0, 0, 1, 4, 4, 0, 2, 3, $b$[
    {
        "label": "About",
        "text": "How established companies build new businesses: hierarchy and new business building, the Innovator's DNA, internal entrepreneurship, corporate venture capital, working with startups, professional entrepreneurs and managerial networks, taught with short lectures, case discussion and a LiveCase simulation. Cases include Applied Research Technology, 3M Optical System, Dow Chemical, Intel Capital, Unilever's Foundry, Niantic Labs, Heidi Roizen and the First Global Bank simulation."
    },
    {
        "label": "Exams",
        "text": "None in the grading table. The teaching-methods paragraph mentions a sit-in essay exam, but no exam weight is listed, so this profile treats the course as exam-free."
    },
    {
        "label": "Groups",
        "text": "Team assignment groups are 3-5 members depending on enrolment, and both teams and cases are randomly allocated and shared after final bidding. The interview is done in pairs."
    },
    {
        "label": "Work",
        "text": "A team assignment (20%): written answers on two assigned cases due 8 AM on the case day plus an intro presentation of up to 5 slides for 15-20 minutes. An Innovator's DNA journal (30%): three short activities (questioning, associating, and observing, networking or experimenting), 3-5 pages, graded on effort. A corporate entrepreneur interview (30%): interview someone who led a venture inside a firm, max 1500 words with your own takeaways."
    },
    {
        "label": "Notes",
        "text": "Participation is 20% and covers attendance, in-class quizzes, two polls (answer plus a 50-word justification by 9 PM the day before) and an iDNA survey. Attendance is not compulsory except for simulation, group presentation and guest speaker sessions, where each miss costs 10%. Video must be on for Zoom attendance or points are cut. Assumes core corporate finance and valuation, no textbook or software, and you should contact an interviewee right after session 1."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/COEN_276.pdf',
   '3-5', null, 'Instructor-assigned', false, 'Participation-linked'),

  ('CTFI', 25, 0, 50, 25, 0, 0, 1, 1, 3, 3, 2, 4, 2, $b$[
    {
        "label": "About",
        "text": "A management view of the film business, mostly Indian, following a film's life: storytelling and pre-production, production planning and control, cinema technology, post-production and CGI, film finance and risk, digital disruption and OTT, film marketing, and careers for MBAs in entertainment. Examples include the Golden Studios (A) case, Avatar, Gravity, Bahubali, Muthu and RRR; the instructor has about 30 years in the sector."
    },
    {
        "label": "Exams",
        "text": "One individual in-class quiz worth 25% in session 10 (the date is listed as not yet fixed); no mid-term or end-term."
    },
    {
        "label": "Groups",
        "text": "5-6 students, preferably including one person with an arts or social studies background, formed within your section only."
    },
    {
        "label": "Work",
        "text": "A group Virtual Movie Business workshop worth 50%: marketing strategy and plan (10%), detailed marketing budget (10%), social media strategy (15%) and a 90-second trailer (15%). The brief is explained in session 1."
    },
    {
        "label": "Notes",
        "text": "Attendance and class participation together are 25%, with the ISB attendance policy linked. The guest speaker session is mandatory. Adobe Premiere at entry level is handy for the trailer but not required. No prerequisites; the recommended textbook is This Business of Film (Greenwald and Landry), and the e-course pack is on LMS."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/CTFI_267.pdf',
   '5-6', false, null, false, 'Participation-linked'),

  ('DMKT', 10, 75, 15, 0, 0, 0, 0, 3, 3, 2, 1, 1, 1, $b$[
    {
        "label": "About",
        "text": "How markets are designed: auctions (first-price, second-price, optimal, eBay, VCG, Google and Meta ad auctions), markets without money (tokens, blockchains), matching, school choice, kidney exchange, plus carbon markets, Uber surge pricing, the IPL player auction and concert-ticket resale. Taught by Aditya Kuvalekar of ISB, loosely following the optional book Market Design by Haeringer."
    },
    {
        "label": "Exams",
        "text": "A public die roll at the end of Lecture 2 sets the scheme: on 1-4 (2 in 3 odds) there is no exam, and on 5-6 there is one MCQ midterm worth 25% that the outline says is significantly easier than MGEC. The weights above assume the no-exam outcome."
    },
    {
        "label": "Groups",
        "text": "4-5 students per group for one 10-minute in-class presentation in the final session, designing a new market, improving an existing one or pitching a startup (15%). The outline does not say how groups are formed or whether they can cross sections."
    },
    {
        "label": "Work",
        "text": "No-exam case: three individual homeworks at 25% each (you may discuss with friends but submit your own work, and one may have a 24-hour deadline). Exam case: two homeworks at 25% each, one before and one after the midterm."
    },
    {
        "label": "Notes",
        "text": "Attendance is 10% (one point per session), and you still get the point if you miss but more than 70% of your section is present. All components use the open 1N code, the book is optional, and the outline lists no prerequisite or software."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/DMKT_276.pdf',
   '4-5', null, null, false, 'Participation-linked'),

  ('FINB', 20, 0, 40, 40, 0, 0, 2, 1, 2, 3, 3, 3, 4, $b$[
    {
        "label": "About",
        "text": "Financial services for low-income customers: microfinance, microsavings and behavioural biases, microinsurance, government schemes, digital finance, AI, women's empowerment and impact evaluation, using the books Poor Economics and Portfolios of the Poor and cases like Grameen Bank, M-Pesa, UPI and CreditVidya. Taught by Shagata Mukherjee (University of Southampton, Delhi), with office hours by appointment on Tuesday to Thursday."
    },
    {
        "label": "Exams",
        "text": "No midterm; two pre-announced in-class quizzes on the topics covered up to the previous class make up 40% (4N code)."
    },
    {
        "label": "Groups",
        "text": "2-3 members depending on class size, no composition requirement, and groups may be formed across sections. The outline does not say who forms them."
    },
    {
        "label": "Work",
        "text": "One group project report of 2500-5000 words (40%, 0N code) due one week after the last class: a business or policy proposal on financial inclusion with a literature review, hypotheses, a test design and a scale-up plan. Marks come out within 10 days of submission."
    },
    {
        "label": "Notes",
        "text": "Attendance and class participation is 20%, scored on contributions that move the discussion forward, and the course follows the standard ISB attendance policy. Both books are required, the e-course pack is on LMS, and no prerequisite or software is listed."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/FINB_276.pdf',
   '2-3 (depending on class size)', true, null, false, 'ISB policy'),

  ('IDTF', 10, 0, 50, 40, 0, 0, 2, 2, 3, 2, 3, 4, 4, $b$[
    {
        "label": "About",
        "text": "Fintech from a finance and economics angle: payments and open finance, shadow banking and P2P lending, robo-advisors and social investing, blockchain and tokenization, DeFi, CBDCs and stablecoins, ML and GenAI in finance, and perpetuals and prediction markets. It does not go deep into coding. Taught by Gopi Krishna Suvanam of G-Square Solutions; office hours and sections are listed as TBD."
    },
    {
        "label": "Exams",
        "text": "No midterm or final; two individual quizzes at 20% each (4N code), with no dates in the outline."
    },
    {
        "label": "Groups",
        "text": "The outline has no Group Information table, so group size, formation and cross-section rules are not stated. Every lecture opens with a 15-minute group presentation summarising the readings."
    },
    {
        "label": "Work",
        "text": "Group class presentations (10%, 4N), attendance plus class participation (10%, individual, 0N), and a final group presentation plus whitepaper designing a Finance 3.0 product, covering market size, tech architecture, licences and risks (40%, 0N). Labs include creating a wallet on a test network, swapping tokens on a DEX and simulating an AMM in Excel or Python."
    },
    {
        "label": "Notes",
        "text": "The course follows the ISB attendance policy, but attendance sits inside the 10% participation component. It is described as intensive and reading-heavy (BIS, FSB and RBI papers, plus the Bitcoin and Ethereum whitepapers), and no prerequisite or required software is listed."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/IDTF_276.pdf',
   null, null, null, false, 'Participation-linked'),

  ('MCAP', 10, 75, 15, 0, 0, 0, 0, 3, 3, 2, 1, 2, 1, $b$[
    {
        "label": "About",
        "text": "Economics of market competition and antitrust: a game theory refresher (Bertrand, Cournot, Stackelberg), then collusion, exclusive deals and bundling, horizontal and vertical mergers, antitrust for tech companies and an optional session on intellectual property, with recent cases like Qualcomm v Apple, EU cases against Amazon, US v Google and Epic Games v Apple and Google."
    },
    {
        "label": "Exams",
        "text": "The weighting is set by a die roll in class at the end of Lecture 2: on 1-4 (2 in 3 chance) there is no exam, and on 5-6 there is one MCQ midterm worth 25% that the instructor says will be significantly easier than MGEC. The percentages shown here are the no-exam outcome."
    },
    {
        "label": "Groups",
        "text": "Groups of 4-5 give one 10-minute in-class presentation in the final session (15%), analysing a real market or industry for an antitrust issue; past students picked EA Sports and the PVR-INOX merger. The outline does not say how groups are formed."
    },
    {
        "label": "Work",
        "text": "No-exam outcome: three individual homework assignments at 25% each plus the group presentation at 15%. Exam outcome: two homeworks at 25% each (one before the midterm, one after), the 25% midterm and the presentation; you may discuss homework with friends but each submission must be your own, and one assignment may carry a 24-hour deadline."
    },
    {
        "label": "Notes",
        "text": "Attendance is graded at 10 points, one per session, and you still get the point when absent if more than 70% of your section is present. MGEC is the prerequisite, the pace is slower than MGEC with a recap of its concepts, there is no required textbook (slides are self-contained), sessions are in person with no recordings, and the instructor is Aditya Kuvalekar of ISB."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/MCAP_276.pdf',
   '4-5', null, null, false, 'Participation-linked'),

  ('MKSV', 20, 50, 30, 0, 0, 0, 0, 1, 4, 4, 0, 3, 4, $b$[
    {
        "label": "About",
        "text": "Strategy and marketing of service firms, pitched as a contrarian mini-MBA: service models, the marketing-operations interface, frontline management, service brands, quality and satisfaction, technology-led change, professional services and leadership. Ten cases, one per session: Progressive Insurance, Apollo Hospitals, Benihana, Fairfield Inn, Au Bon Pain, Starbucks, SBI SMS Unhappy, Everdream, Lehman Brothers and Taco Bell."
    },
    {
        "label": "Exams",
        "text": "None — grading is participation, a group project, a service simulation or short paper, and case submissions."
    },
    {
        "label": "Groups",
        "text": "Five students per group from diverse backgrounds, for one group project (30%) due on the last day of class: a 10-page report plus exhibits."
    },
    {
        "label": "Work",
        "text": "Individual take-home case submissions in PDF (35%), an individual service simulation or a short customer experience paper (15%, due date TBD, credentials shared later), the group project (30%) and class participation (20%)."
    },
    {
        "label": "Notes",
        "text": "Core Marketing (or an exemption) is a prerequisite and the software is VB-Service-Video from precisedonline.com. Participation marks are tied to attendance and the quality of case discussion; the instructor, Dr. Piyush Kumar (University of Georgia), lists over 25 Professor of the Year awards at ISB."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/MKSV_276.pdf',
   '5', null, null, false, 'Participation-linked'),

  ('MSDW', 20, 10, 55, 15, 0, 0, 2, 2, 3, 4, 2, 4, 3, $b$[
    {
        "label": "About",
        "text": "How services are designed, priced and run in a digital setting: service strategy and trade-offs, platforms and two-sided pricing, capacity and demand, customer-induced variability, ML analytics for customer experience and workforce scheduling, with cases on Southwest Airlines, Michelin, University Health Services Walk-In, Uber, Shouldice Hospital and Belk. The Mohali instructor is Prof. Sandeep Rath of ISB (office hours TBD)."
    },
    {
        "label": "Exams",
        "text": "No midterm or final; individual in-class assessments are worth 15%, and the outline does not say how many there are or what format they take."
    },
    {
        "label": "Groups",
        "text": "4-5 members (preferably 4) from diverse educational or professional backgrounds, formed within a section only. The outline does not say who forms them."
    },
    {
        "label": "Work",
        "text": "A group simulation or interactive activities (20%), individual post-class reflection notes (10%), a group final project presented in session 10 (30%), a group-based peer evaluation worth 5% submitted online before the end of class, and class participation (20%). A Staff.AI pricing case is also in the course pack for a case write-up."
    },
    {
        "label": "Notes",
        "text": "The course pack is required (e-pack on LMS), with no other textbook, no software and no prerequisites. Graded work uses coding scheme 3N-b, the outline is marked Tentative, and the assignment schedule is still TBD."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/MSDW_276.pdf',
   '4-5 (preferably 4)', false, null, true, 'ISB policy'),

  ('NEGA2', 20, 20, 30, 30, 0, 0, 3, 0, 2, 5, 3, 3, 2, $b$[
    {
        "label": "About",
        "text": "A hands-on negotiation course with a simulated negotiation in every one of the 10 sessions, moving from two-party single-issue and multi-issue deals to negotiating in teams, agents and ethics, disputes, and multi-party negotiations. Exercises get harder each session and readings come from Lax and Sebenius, Raiffa, Medvec and Galinsky, and others."
    },
    {
        "label": "Exams",
        "text": "No midterm or final. Preparation is tested by in-class paper quizzes before 2-3 randomly chosen exercises, worth 30% in total, and the session plan lists them in classes 3, 7 and 8."
    },
    {
        "label": "Groups",
        "text": "Group presentations are based on three simulations the instructor announces in class. For each one, only some teams are picked to give a 10-minute talk plus 5-minute Q&A, and if you are picked more than once your best grade counts. The outline gives no group size or formation rule."
    },
    {
        "label": "Work",
        "text": "Participation and professionalism 20% (5% from the instructor and the rest from counterpart peer ratings), preparation quizzes 30%, individual post-negotiation debrief surveys 20%, and group presentations 30%, graded on the oral analysis and Q&A and not on the slides."
    },
    {
        "label": "Notes",
        "text": "Role materials are confidential and sharing or asking about another role before the exercise is an honour code violation. You must read your role and prepare before class, late work is penalised at the instructor's discretion, ISB attendance policy applies, and the instructor is Abhishek Gupte of ISB (sections and office hours still to be confirmed)."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/NEGA 2_276.pdf',
   null, null, null, true, 'ISB policy'),

  ('PMGT', 5, 50, 0, 45, 0, 1, 3, 4, 4, 1, 4, 0, 2, $b$[
    {
        "label": "About",
        "text": "Project management from scoping and the critical path method to Microsoft Project, @RISK Monte Carlo simulation of project risk, resource levelling, earned value analysis, contracting, Agile and portfolio valuation. Cases are BAE Automated Systems (Denver airport baggage system), the New York transit rebuild after the World Trade Center collapse, the Dragonfly Project, Salesforce.com and Novartis."
    },
    {
        "label": "Exams",
        "text": "One in-class final exam worth 30% in the end-term window (format not given), plus three in-class quizzes of 5 multiple-choice questions each at 5% apiece, held in sessions 5, 8 and 10 and based on the case assignment you just submitted."
    },
    {
        "label": "Groups",
        "text": "Nothing graded is done in groups. The Group Information table lists a size of 5 with no cross-section groups, but no group assignment appears in the evaluation."
    },
    {
        "label": "Work",
        "text": "Three take-home case assignments at 15% each (a write-up with supporting MS Project and Excel files, due a week after it is set), small software tasks worth 2%, 2% and 1% (MS Project install, @RISK install with an e-commerce assignment, and a Chuck-a-Luck simulation exercise), and 5% for case discussion participation."
    },
    {
        "label": "Notes",
        "text": "You need unhindered access to a Windows machine because MS Project Professional 2019 and @RISK do not run on a Mac, and you should be comfortable with probability and statistics. AI tools are allowed for learning but not on any individual assignment or the final exam, ISB attendance policy applies, and the instructor is Nitin Bakshi of the University of Utah."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/PMGT_276.pdf',
   '5', false, null, false, 'ISB policy'),

  ('RDFV', 20, 40, 40, 0, 0, 0, 0, 3, 4, 3, 0, 3, 3, $b$[
    {
        "label": "About",
        "text": "Real estate development and finance in India: capital sources, market trends and underwriting, development proformas and valuation, LP and GP interests, ESG, affordable housing (HBS Dharavi), risk and return, mortgages and leases, and CMBS and RMBS. Cases include Peninsula Business Park, 1500 Broadway, Charleston, Akash City and Rising Sun Towers, with guest speakers from Colliers, Nestle and a PE fund."
    },
    {
        "label": "Exams",
        "text": "None. Grading is four case write-ups plus attendance and participation."
    },
    {
        "label": "Groups",
        "text": "The first two write-ups are team work, in teams of four per the assignment table (the Group Information table says 4-5), and the last two are individual. Group composition just says 'refer to outline', which gives no rule."
    },
    {
        "label": "Work",
        "text": "Four case write-ups at 20% each: team write-ups on innovations in Indian real estate and on the affordable housing crisis (2N-b), then individual write-ups on Akash City and Rising Sun Towers (3N-b), and attendance and participation at 20%. Team write-ups are due the Sunday after the case is discussed."
    },
    {
        "label": "Notes",
        "text": "Two UTSA instructors split the course: Tony Ciochetti for sessions 1-6 and Karan Bhanot for sessions 7-10, and you are called on in class. There is no required textbook, ISB attendance policy applies, and the session 7 readings are still to be announced."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/RDFV_276.pdf',
   '4-5', null, null, false, 'Participation-linked'),

  ('REMA', 10, 10, 20, 60, 0, 1, 1, 4, 3, 2, 4, 2, 2, $b$[
    {
        "label": "About",
        "text": "Pricing and revenue management: willingness to pay, price elasticity, segmentation, seat-inventory heuristics like EMSR, network revenue management with linear programming, and demand estimation with multinomial logit. Cases are Cambridge Software, American Airlines, Container Transportation Company, Personal Training at New York Health Club and Flashion, and the instructor is Ankur Garg, Director at Optivara Solutions."
    },
    {
        "label": "Exams",
        "text": "One end-term worth 40% and one quiz worth 20% planned for session 7, with no make-up quiz for anyone who misses it. The outline gives no date or format for the end-term."
    },
    {
        "label": "Groups",
        "text": "The class is split into 10 equal groups within your section, cross-section groups are not allowed, and member names are due by session 2. The instructor assigns each group an industry such as hospitality, car rentals, cruises, utilities, retail, railways or cargo and logistics."
    },
    {
        "label": "Work",
        "text": "A group assignment (20%) on how dynamic pricing and revenue management is used in your assigned industry, presented and submitted in session 9. An individual pricing simulation exercise on Universal Car Rental in session 10 (10%) and class participation (10%)."
    },
    {
        "label": "Notes",
        "text": "Excel is the only software and you bring a laptop to every class for in-class exercises. Standard ISB attendance policy applies. Honour codes are 4N for the quiz and end-term, 0N for participation and the group assignment, and 2N-b for the simulation; the recommended text is Phillips, Pricing and Revenue Optimization."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/REMA_276.pdf',
   null, false, null, false, 'ISB policy'),

  ('RMPL', 15, 55, 30, 0, 0, 0, 0, 1, 3, 3, 0, 3, 2, $b$[
    {
        "label": "About",
        "text": "Marketing in rural markets of India and other emerging economies: the rural economy, rural consumer behaviour, rural market research, segmentation and positioning, product, pricing, below-the-line promotion and distribution, backed by a real rural market visit."
    },
    {
        "label": "Exams",
        "text": "None. The outline says there is no end-term test, and session 9 is a project presentation with a round-table discussion."
    },
    {
        "label": "Groups",
        "text": "One group project from the rural market visit, worth 30% under the open 0N code. The outline gives no group size or formation rule."
    },
    {
        "label": "Work",
        "text": "A 5-mark individual PPTX assignment in week 2, class participation 15%, a 'Teach a concept' (TAC) presentation 30%, and individual understanding interviews from the visit 20%. The visit report is due 10 days after it is announced, timed to session 9."
    },
    {
        "label": "Notes",
        "text": "From session 2 to 10, four students per session volunteer to give a TAC presentation, and everyone else does a written project announced in session 7 and due in session 8. ISB attendance policy applies, participation norms are announced in session 1, and the instructor is Harish Bijoor of Harish Bijoor Consults Inc."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/RMPL_276.pdf',
   null, null, null, false, 'ISB policy'),

  ('STRI', 20, 30, 50, 0, 0, 0, 0, 0, 3, 4, 0, 3, 3, $b$[
    {
        "label": "About",
        "text": "Why good strategies fail in execution, covering structure, incentives, culture, networks, market entry and exploration versus exploitation, taught through HBS cases on Appex Corp, P&G Organization 2005, Marshal & Gordon, Iggy's, Jerry Sanders, Levendary Cafe and IBM Emerging Business Opportunities, ending with Valve and Zappos. The instructor is Anusha Sirigiri of ISB."
    },
    {
        "label": "Exams",
        "text": "None. Grading is class contribution plus case write-ups and a group presentation."
    },
    {
        "label": "Groups",
        "text": "Groups form within your section (8 groups, no cross-section groups) and must send names by 11:55 pm on the Friday of Week 1. Group size is listed as TBD, and the outline prefers gender and functional diversity."
    },
    {
        "label": "Work",
        "text": "Two individual 2-page case write-ups chosen from three due dates (30% total) and one group 2-page write-up chosen from two (20%), each due 11:59 pm the day before the case is discussed. A 5-minute group presentation in session 10 on San Francisco Science, defending an assigned business model (VC firm, consultant, broker or accelerator), is worth 30%."
    },
    {
        "label": "Notes",
        "text": "Class contribution is 20% and attendance alone earns nothing, though attendance is not compulsory and no grade is cut for missing class. Late write-ups lose 15% in the first 24 hours, then 35% and 50% in later 24-hour blocks, and the late rule does not apply to the group project. There are no textbooks, only a custom course pack."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/STRI_276.pdf',
   null, false, 'Self-select', false, 'Not mandatory'),

  ('TAAM', 0, 4, 36, 60, 0, 0, 8, 3, 3, 0, 4, 4, 2, $b$[
    {
        "label": "About",
        "text": "Hands-on Excel financial modeling for people heading into consulting, entrepreneurship, tech, marketing or other non-finance roles: reading annual reports, comparable companies, a three-statement model, DCF, real estate, precedent transactions and M&A, and an LBO. Ten two-hour in-person classes from 21 Dec 2026 to 31 Jan 2027, with Professor Ashish Kohli of NYU Tandon building a model with the class in each session."
    },
    {
        "label": "Exams",
        "text": "No midterm or final. Eight in-class quizzes, one in each class from Class 3 to Class 10, and the best 5 count at 12% each (60%); quizzes are closed book with no AI, a missed quiz scores zero, and there are no make-ups."
    },
    {
        "label": "Groups",
        "text": "Five to eight students, self-formed, with a mix of backgrounds encouraged, and cross-section groups are allowed. The same group does all three homeworks and presents them to the professor in person or on Zoom."
    },
    {
        "label": "Work",
        "text": "A Personal Finance homework (4%) built with your group but submitted individually, a Real Estate homework (18%) evaluating a property purchase, and a Lenskart Private Equity homework (18%) giving an investment recommendation with valuation and LBO models. Homework deadlines are listed as TBD and will be posted on LMS."
    },
    {
        "label": "Notes",
        "text": "No prerequisites and no prior Excel or finance needed, but bring a laptop with Excel and a charger to every class. Attendance is not mandatory or graded and there are no participation points, though you lose the quiz held in any class you miss. AI is encouraged for homework and banned in quizzes, late homework penalties are set by the professor, and optional ungraded treks run to Mohali, Delhi and Goa."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/TAAM_276.pdf',
   '5-8', true, 'Self-select', false, 'Not mandatory'),

  ('TATU', 0, 0, 40, 60, 0, 0, 8, 4, 3, 0, 4, 4, 2, $b$[
    {
        "label": "About",
        "text": "The deeper, faster version of TAAM for students aiming at investment banking, private equity, real estate, research or consulting: all TAAM models plus accretion-dilution M&A and more advanced valuation and deal modeling (comparable companies, three-statement, DCF, precedent transactions, LBO). Ten two-hour in-person classes from 21 Dec 2026 to 31 Jan 2027 with Professor Ashish Kohli of NYU Tandon."
    },
    {
        "label": "Exams",
        "text": "No midterm or final. Eight in-class quizzes, one in each class from Class 3 to Class 10, and the best 5 count at 12% each (60%); quizzes are closed book with no AI, a missed quiz scores zero, and there are no make-ups."
    },
    {
        "label": "Groups",
        "text": "Five to eight students, self-formed, with a mix of backgrounds encouraged, and cross-section groups are allowed. The same group does both homeworks and presents them to the professor in person or on Zoom."
    },
    {
        "label": "Work",
        "text": "A Real Estate homework (20%) evaluating a property purchase and a Lenskart Private Equity homework (20%) giving an investment recommendation with valuation, M&A and LBO models, both submitted as a group. Deadlines are listed as TBD (Real Estate in Week 4, Lenskart after Class 10) and will be posted on LMS."
    },
    {
        "label": "Notes",
        "text": "Prior finance or accounting, or an ISB finance elective, is recommended but not required, and you should be comfortable with very basic Excel; bring a laptop with Excel and a charger to every class. Attendance is not mandatory or graded and there are no participation points, though you lose the quiz held in any class you miss. AI is encouraged for homework and banned in quizzes, and optional ungraded treks run to Mohali, Delhi and Goa."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/TATU_276.pdf',
   '5-8', true, 'Self-select', false, 'Not mandatory'),

  ('TSFL', 20, 30, 50, 0, 0, 0, 0, 0, 3, 3, 0, 3, 2, $b$[
    {
        "label": "About",
        "text": "Why tech startups fail, one HBS case per session: Jibo, Quincy Apparel, Triangulate, Baroo, Dot & Bo, Fab.com, Theranos, Better Place, Moz and Poppy. It groups failures into early-stage, late-stage and 'failing well' patterns, and the instructor is Vishal Karungulam of ISB."
    },
    {
        "label": "Exams",
        "text": "None. Grading is a founder journal, a group pivot pitch, a group case write-up and participation."
    },
    {
        "label": "Groups",
        "text": "Groups of 5, and cross-section groups are allowed. The outline does not say how groups are formed."
    },
    {
        "label": "Work",
        "text": "Three 2-page individual Founder's Failure Journal entries due at the start of sessions 3, 5 and 7, with your best 2 counting for 30%. A group pivot pitch (20%) as a 2-3 minute video plus slide deck before session 9, and a group end-term case write-up (30%) after session 10 on an Indian tech startup failure."
    },
    {
        "label": "Notes",
        "text": "Participation is 20% and the outline gives no scoring detail. The best group draft is turned into a published case with the faculty, with the team credited as co-authors. ISB attendance policy applies (miss 1 session and your grade drops one level, 2 drops two, 3 or more is an F), and there is no textbook, software or prerequisite."
    }
]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/TSFL_276.pdf',
   '5', true, null, false, 'ISB policy')
) as v(code, p, i, g, e, mid, endt, quiz, q, a, lp, le, lg, r, brief, url, gsize, xsec, form, peer, att)
join public.courses c on c.code = v.code and c.term = 'Term 6';
