-- Term 5 grading profiles, extracted from the official 2026-27 ISB course outlines
-- (ISB SharePoint, PGP_Mohali/2026-2027/Course_Outlines/Term 5), same method and
-- shape as 20260803153949_seed_term4_grading_profiles.sql. Grading composition and
-- exam counts are read off each outline's evaluation table; the 0-5 workload scores
-- are a judgment call, admin-editable via the Courses admin tab. All 17 Term 5
-- electives have an outline, so all 17 are covered.
--
-- Judgment calls worth knowing about:
-- - DTME1 is a 2-credit course run across Terms 5-7; only the Term 5 grading block
--   (which sums to 100 on its own) is profiled here.
-- - ENVC, MSTC, NSDL and PEVF grade "quizzes" without stating how many. exam_quiz_count
--   is set to 2, the minimum the plural implies, and each brief says the count isn't given.
-- - SMTD's 8 in-class "data-prompt papers" (5-minute, closed, best 6 of 8) are counted
--   as quizzes and bucketed as exam weight.
-- - LOES and LWPM outlines carry deadlines copied from a previous year; those dates
--   are left out of the briefs.

insert into public.course_grading_profiles
  (course_id, grade_participation_pct, grade_individual_pct, grade_group_pct, grade_exam_pct,
   exam_midterm_count, exam_endterm_count, exam_quiz_count,
   load_quant, load_assignments, load_participation, load_exam_pressure, load_group, load_reading,
   brief, source_url, extracted_at)
select c.id, v.p, v.i, v.g, v.e, v.mid, v.endt, v.quiz, v.q, v.a, v.lp, v.le, v.lg, v.r, v.brief::jsonb, v.url, now()
from (values

  ('ABTE', 0, 50, 50, 0, 0, 0, 0, 3, 3, 1, 0, 4, 2, $b$[
    {"label":"About","text":"How to design and analyse A/B tests for regular software, ML products and generative AI, with HBS cases on Booking.com, Rocket Fuel and Uber Express POOL plus hands-on Python sessions on MovieLens and simulated search data."},
    {"label":"Exams","text":"None — grading is two individual pieces and a group project."},
    {"label":"Groups","text":"Groups of 4-5 for the final project, with every member's role spelled out in the submission."},
    {"label":"Work","text":"In-class Python notebook exercises in sessions 8 and 9, an individual Uber case write-up with no AI tools allowed, and a group experiment on two or more LLM or learning products that you demo in session 10."},
    {"label":"Notes","text":"You need basic Python in Google Colab (an AI assistant is allowed if you understand its output), there is no participation grade, and the instructor is a PayPal product and AI executive."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/ABTE_275.pdf'),

  ('BVFS', 10, 40, 50, 0, 0, 0, 0, 5, 4, 2, 0, 4, 2, $b$[
    {"label":"About","text":"Building pro forma financial statements and valuing firms with DCF, residual operating income and market multiples, using cases on Dollar Tree and Dollar General and Walmart's cost of capital."},
    {"label":"Exams","text":"None — grading is participation, assignments and a group valuation project."},
    {"label":"Groups","text":"Up to 5, self-formed within your section, and you can switch groups between assignments."},
    {"label":"Work","text":"Two individual cases at 20% each, two group cases (basic forecasting, relative valuation) at 15% each, and a group final valuation project with an Excel model, a write-up and a buy or sell call worth 20%."},
    {"label":"Notes","text":"Heavy Excel and accounting-based modelling, attendance is not mandatory, participation is graded on quality over quantity, and late work without prior notice is not accepted."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/BVFS_275.pdf'),

  ('CDMA2', 25, 50, 25, 0, 0, 0, 0, 1, 3, 5, 0, 2, 4, $b$[
    {"label":"About","text":"Corporate development through M&A, alliances and post-deal integration, taught through HBS cases including Crown Equipment, Disney-Pixar, Danaher, Newell, Kraft General Foods and Bharti Airtel in Africa."},
    {"label":"Exams","text":"None — grading is participation plus case write-ups."},
    {"label":"Groups","text":"Up to 3, within your section and ideally from different functional backgrounds, and the instructor assigns anyone left without a group."},
    {"label":"Work","text":"Two individual 2-page case write-ups chosen from four cases (25% each) and two group 2-page write-ups chosen from three cases (12.5% each), all under the strict 4N code."},
    {"label":"Notes","text":"Discussion-led with cold calls and no credit for just attending, late work loses 15% in the first 24 hours and then scores zero, and sitting in another section earns 0 participation for that session."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/CDMA_275.pdf'),

  ('COBE', 25, 35, 40, 0, 0, 0, 0, 1, 2, 4, 0, 3, 3, $b$[
    {"label":"About","text":"Consumer psychology and behavioural economics across buying, using and disposing, covering customer journeys, research methods and experiments, privacy, fairness and sustainable consumption, ending in a behavioural hackathon."},
    {"label":"Exams","text":"None — grading is participation plus two take-home assignments."},
    {"label":"Groups","text":"Groups of 5, formed within your section."},
    {"label":"Work","text":"An individual 500-word 'Consumer Behaviour in the Wild: Mohali Edition' piece due 8 November and a group 10-slide 'Marketing Sandbox' deck due 22 November, both under the open 0N code."},
    {"label":"Notes","text":"Strict attendance rule where each missed session drops your grade one step and three misses means an F, a mandatory guest lecture from Aditya Birla Group's Sudip Mitra, light quant, and Qualtrics is the only software."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/COBE_275.pdf'),

  ('DTME1', 25, 20, 30, 25, 0, 0, 1, 2, 3, 4, 2, 5, 3, $b$[
    {"label":"About","text":"Industry 4.0 and digital transformation in manufacturing through cases on Schneider Electric, Ashok Leyland's digital twin, Tetra Pak and Ayana Renewable, the Fashion Forward and DigiStrat simulations, and a three-term Action Learning Project with a real company."},
    {"label":"Exams","text":"One individual in-class test worth 25% of the Term 5 grade, with another in Term 7."},
    {"label":"Groups","text":"Teams of 5 to 6 with mixed backgrounds, each on a faculty-sourced client project with a company mentor."},
    {"label":"Work","text":"The Term 5 grade is class participation, a count of your individual meetings with the client company, an in-class test, and a group project-plan deck sent to the client and faculty."},
    {"label":"Notes","text":"A 2-credit course spread over Terms 5 to 7 with only five in-person sessions in Term 5 and none in Term 6; this profile covers only the Term 5 grade, and you should expect 3 to 4 client mentor meetings each term."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/DTME_275.pdf'),
  ('ENVC', 25, 10, 50, 15, 0, 0, 2, 1, 2, 4, 2, 4, 3, $b$[
    {"label":"About","text":"Starting and funding a new venture: opportunity evaluation, business models, unit economics, founder equity splits, and the venture capital ecosystem, taught through cases like Ashta Chamma, NephroPlus, Luckin Coffee, UpDown, and Surya Tutoring."},
    {"label":"Exams","text":"No midterm or final; quizzes are worth 15% in total, but the outline does not say how many or when."},
    {"label":"Groups","text":"4-5 members, self-formed, with a peer evaluation that adjusts each person's share of the group grade."},
    {"label":"Work","text":"An in-class group assignment on the Luckin Coffee case (20%), a group new-venture pitch in the last session (30%), quizzes (15%), a survey component (10%), and class contribution (25%)."},
    {"label":"Notes","text":"Math stays at middle-school level with no prerequisite, every component is graded on the curve, and about 30% of the course covers venture finance and term sheets."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/ENVC_275.pdf'),

  ('LOES', 25, 55, 20, 0, 0, 0, 0, 2, 3, 3, 0, 2, 3, $b$[
    {"label":"About","text":"How operations decisions affect the environment and society, organised along a product's life cycle (design and sourcing, processing, customer use, post-use), with cases on IKEA, Levi Strauss, Greenturn, Tetra Pak, and Mihocko."},
    {"label":"Exams","text":"None; there are no sit-down exams."},
    {"label":"Groups","text":"3-5 per group within your section, with size set after enrolment, and each group leads one media-article discussion."},
    {"label":"Work","text":"Four individual case-prep answer sets on LMS due 10 AM on case days (best 3 count, 30%), a group article-discussion deck of 7-10 slides (20%), a 750-1000 word personal reflection (25%), and participation (25%)."},
    {"label":"Notes","text":"Participation is scored on attendance, punctuality, and in-class polls, basic Excel is expected, and the instructor is visiting from Darden (UVA)."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/LOES_275.pdf'),

  ('LWPM', 16, 54, 30, 0, 0, 0, 0, 0, 3, 4, 0, 2, 2, $b$[
    {"label":"About","text":"Self-leadership through the instructor's 'beingful leadership' approach, covering purpose, meaning, job crafting, growth mindsets, and AI, with cases on Stork Home Fernandez, LVPEI, and Microsoft."},
    {"label":"Exams","text":"None; there are no sit-down exams."},
    {"label":"Groups","text":"Students form their own project groups within a section, with size announced after bidding; one in-class exercise uses randomly formed groups."},
    {"label":"Work","text":"Five class exercises including a take-home video (best 4 count, 24%), an 8-10 page individual write-up (30%), a group startup pitch deck and presentation (30%), and session-by-session participation (16%)."},
    {"label":"Notes","text":"Reflective and experiential with no quant, missing any session costs that day's participation and exercise points whatever the reason, and late work loses 10% (write-up) or 20% (pitch deck) per day."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/LWPM_275.pdf'),

  ('MKTS', 15, 60, 25, 0, 0, 0, 0, 3, 4, 3, 0, 2, 4, $b$[
    {"label":"About","text":"A case-based capstone on marketing and sales strategy with an Indian-company focus, using cases like Black & Decker, P&G India, Mountain Man Brewing, Netflix, Sephora, and Flipkart plus two simulations."},
    {"label":"Exams","text":"None; the outline states no exams, though short in-class quizzes on cases may be given without a separate weight."},
    {"label":"Groups","text":"5-6 members within your section, formed by the instructor, and each group analyzes one case."},
    {"label":"Work","text":"Four individual one-page case reports (40%), two in-class simulations (20%), a group case project (25%), and participation (15%)."},
    {"label":"Notes","text":"The instructor stresses quantitative analysis such as customer lifetime value and marketing ROI."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/MKTS_275.pdf'),

  ('MSTC', 0, 30, 50, 20, 0, 0, 2, 2, 4, 2, 2, 5, 3, $b$[
    {"label":"About","text":"Consulting craft for an AI-shaped industry: problem framing, hypothesis building, executive storytelling and change management, capped by a live Global Venture Lab engagement (sessions 4-10) with a founder from Africa, Latin America or the Middle East."},
    {"label":"Exams","text":"No final exam; surprise individual quizzes at the start of class or after the break make up 20%, the outline does not say how many, and latecomers take them with a heavy penalty."},
    {"label":"Groups","text":"Group size is not stated; your grade on group work depends on your individual contribution as judged by the faculty in team coaching sessions."},
    {"label":"Work","text":"Two individual case assignments (Deloitte responsible GenAI, Sewell's Group) worth 30%, and three group deliverables for the founder (CEO brief, diagnostic clinic, final steering committee presentation) worth 50%."},
    {"label":"Notes","text":"Competitive Strategy is a prerequisite, you may need a ChatGPT or Gemini subscription, class participation is not graded, and arriving five minutes late can get you marked absent."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/MSTC_275.pdf'),

  ('MTCC', 10, 0, 30, 60, 1, 1, 0, 3, 3, 2, 5, 3, 2, $b$[
    {"label":"About","text":"How software, platform, cloud, data and GenAI products make money: freemium and trials, SaaS unit economics, usage-based and token pricing, open source and IP, with cases like VidMorph, SafeGraph and QuantumBlack."},
    {"label":"Exams","text":"An individual midterm (20%) and an individual end-term (40%), both scheduled by ASA with no AI allowed."},
    {"label":"Groups","text":"Five students per group with no composition rules, and groups can be formed across sections."},
    {"label":"Work","text":"Three group take-home assignments due in sessions 3, 5 and 9 (9% each), a 3% peer evaluation, 10% class participation, plus the midterm and end-term."},
    {"label":"Notes","text":"Exams carry 60% of the grade, there is no prerequisite and no pass/fail option, and AI use on take-homes is restricted as specified in each assignment."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/MTCC_275.pdf'),

  ('NEGA1', 20, 45, 20, 15, 0, 0, 10, 1, 4, 5, 2, 2, 3, $b$[
    {"label":"About","text":"Experiential negotiation course with a live exercise every session, moving from single-issue deals to team, agent, dispute and multi-party cases (New Recruit, Moms.com, Cascade Manor, Bullard Houses, Viking, Harborco), including sessions negotiating against an AI bot."},
    {"label":"Exams","text":"No midterm or final; a 5-10 minute quiz on your role materials opens each of the 10 sessions, and the best 7 count (15%)."},
    {"label":"Groups","text":"Five per group with diverse backgrounds, and groups cannot be formed across sections."},
    {"label":"Work","text":"Three individual planning documents of 2-4 pages (Moms.com, Bullard Houses, Viking, 5% each), a group deck plus 5-10 minute video on a practitioner interview, real negotiation or public deal (20%), and an individual 1500-1800 word end-term reflection report (30%)."},
    {"label":"Notes","text":"Participation is earned at 1% per session plus 10% for preparation and etiquette, so a missed session costs you points and leaves your counterpart without a partner; section swaps are not allowed."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/NEGA_275.pdf'),

  ('NSDL', 10, 20, 40, 30, 0, 0, 2, 3, 3, 2, 3, 4, 3, $b$[
    {"label":"About","text":"Strategic marketing for new products and services: opportunity identification, STP and positioning, concept testing, preference analysis and launch, with cases like Prozac and Paxil and Aqualisa Quartz and a guest session from an industry executive."},
    {"label":"Exams","text":"No midterm or final; in-class quizzes and exercises make up 30%, and the outline does not say how many there are."},
    {"label":"Groups","text":"Team size and formation rules are not stated in the outline."},
    {"label":"Work","text":"A group new product or service development project (40%), two individual case write-ups of up to 10 pages on Prozac/Paxil and Aqualisa Quartz (10% each), in-class quizzes and exercises (30%) and class participation (10%)."},
    {"label":"Notes","text":"Uses formal models such as perceptual maps, preference analysis and marketing math at a moderate quant level, case write-ups may not use any outside sources, and missing the guest session costs participation marks."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/NSDL_275.pdf'),
  ('PEVF', 10, 30, 35, 25, 0, 0, 2, 4, 4, 4, 2, 3, 4, $b$[
    {"label":"About","text":"Corporate finance across a firm's life cycle: PE fund structure, VC term sheets and cap tables, LBOs, and IPOs, through cases like Altoona/Bain Capital Fund XI, Lovepop, H-Soft Mumbai, Blackstone, Kimly, and an Avani Capital PE mini-case sprint."},
    {"label":"Exams","text":"No final exam; unannounced 5-15 minute in-class pop quizzes (multiple choice or short answer), best n of n+1 count, and the outline does not say how many."},
    {"label":"Groups","text":"3-4 students, declared by the first Sunday, same section only, fixed for the whole term."},
    {"label":"Work","text":"Two individual post-class case write-ups (Altoona, Lovepop), one group write-up (Blackstone), a group real-world funding assignment (report plus short deck or recording), pop quizzes, and case participation."},
    {"label":"Notes","text":"Valuation work throughout (DCF, cap tables, LBO model) with FCRV as prerequisite; AI use is encouraged but you must append prompts and outputs, no late submissions are accepted, and lateness to class costs participation marks."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/PEVF_275.pdf'),

  ('RTLG', 15, 35, 50, 0, 0, 0, 0, 2, 2, 3, 0, 4, 2, $b$[
    {"label":"About","text":"Retail strategy, e-commerce, omni-channel and channel management, taught through the Zara case, in-class debates, and a retail store management simulation."},
    {"label":"Exams","text":"None — there is no final exam, midterm, or quiz."},
    {"label":"Groups","text":"The class forms 9 groups (listed as 5-8 students each), and each group runs one trend presentation or debate and competes in the simulation."},
    {"label":"Work","text":"One individual Zara case memo (max 1500 words), one group presentation or debate, a group simulation with a practice round, 4 competitive rounds, and a Session 10 PPT defence, plus class participation."},
    {"label":"Notes","text":"Light quant (margins, inventory turnover, GMROI); the single memo is worth 35%, half the simulation grade comes from simulated profit, and late memos get no credit."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/RTLG_275.pdf'),

  ('SMTD', 0, 45, 40, 15, 0, 0, 8, 4, 4, 1, 1, 3, 2, $b$[
    {"label":"About","text":"Market microstructure and trade execution (order books, call vs continuous markets, transaction costs and implementation shortfall, VWAP and TWAP algorithms), then FX and fixed income markets in India (NDS-OM, offshore rupee NDF)."},
    {"label":"Exams","text":"No midterm or final; eight 5-minute in-class data-prompt papers on LMS, best 6 of 8 count, and any attempt made outside the classroom scores zero."},
    {"label":"Groups","text":"4-6 per group, same section only, with a peer evaluation that scales each member's group score."},
    {"label":"Work","text":"Eight data-prompt papers, two individual take-home trading decision memos, an individual market microstructure audit of one NSE stock (report plus recorded video), and a group Excel trading simulation with a report and Session 10 presentation."},
    {"label":"Notes","text":"Excel-based and moderately quant with FCRV as prerequisite; there is no participation grade, attendance is optional except Session 10 (missing it zeroes the presentation), and AI is allowed only for concept clarification or grammar, with disclosure."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/SMTD_275.pdf'),

  ('STAR', 0, 50, 50, 0, 0, 0, 0, 5, 5, 1, 0, 4, 2, $b$[
    {"label":"About","text":"Quantitative trading strategies on Indian equities: charts, trend-following, mean reversion and pairs trading, volume and sentiment, regime detection, options, Kelly position sizing, and performance metrics, with backtests on AlgoTest and live paper trading on Neostox."},
    {"label":"Exams","text":"None — all assessment is take-home assignments and a group project."},
    {"label":"Groups","text":"4-6 per group, same section only, with a peer evaluation that scales each member's group score."},
    {"label":"Work","text":"Five individual session assignments on NSE data (best 4 of 5), an individual strategy audit that replicates a published strategy on AlgoTest, and a group original-strategy project with a historical backtest, a live paper trade from Session 5 to 10, a report, and a Session 10 presentation."},
    {"label":"Notes","text":"Heavy quant (statistics, cointegration, Black-Scholes, Sharpe and Sortino) with FCRV as prerequisite and required AlgoTest and Neostox subscriptions (cost not stated); there is no participation grade, and attendance is optional except the mandatory Session 10."}
  ]$b$, 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/STAR_275.pdf')

) as v(code, p, i, g, e, mid, endt, quiz, q, a, lp, le, lg, r, brief, url)
join public.courses c on c.code = v.code and c.term = 'Term 5'
on conflict (course_id) do nothing;
