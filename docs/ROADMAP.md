# Roadmap: the plan, what's built, what's next, what's broken

Written to be read honestly. If something below looks half-finished, it is, and it's listed so the next person doesn't have to rediscover it. Current as of 2026-09-15.

## The plan

**Goal:** one place where an ISB PGP student handles the academic side of the year: planning electives and bids, tracking where they stand, choosing between courses with real information, finding material, and preparing for exams. Run by AAC, built for Co'27, and structured so later batches can reuse it.

It grew out of one recurring AAC complaint, that students were guessing at electives and concentrations, and then took on the next things students asked for. AAC's original "one-stop platform" idea (course material, professor profiles, a noticeboard, per-course AI help) is the longer arc; the Notion-based resource repo AAC already runs is meant to be absorbed gradually, not replaced overnight.

**Principles that haven't changed:** never recommend what to pick; never submit anything anywhere; show aggregates only above a threshold; say "not stated" instead of guessing. See [PRODUCT.md](PRODUCT.md#product-rules-that-apply-everywhere).

## How it got here

| When | Phase | What shipped |
|---|---|---|
| 2026-07-14 | Bidding planner | Four-step planner (Background, Goals, Plan, Budget), full course catalogue, gating-course rules, Course Resources, Notice Board (preview), admin panel. |
| 2026-07-15 to 07-30 | Getting the rules right | Flexi Core conversion rules, term-wise credit limits, exchange points, cross-listed course exclusivity, resource pinning, admin-managed sidebar links, live bidding round setting, Bidding Pulse (2026-07-18) with threshold-gated stats and histograms. |
| 2026-08-03 to 08-04 | From plan to result | Credit Tracker becomes the home page (enrolments, reconciliation, grades, GPA). Grading profiles and the "Your Term" step. Term 4 Dossier page from Vidhi Agarwal (the Term 4 Bidding Q&A page followed on 08-13). Admin-editable credit limits. Pulse moves to per-course, 3 edits, gated on the live round. |
| 2026-08-13 | Engineering hygiene | CI on every pull request. |
| 2026-08-14 to 08-18 | Learn | The separate mktg-rep learning app merged in as Learn. End-term content for BANM2, OPMG, MKTG and MADM2; revision guides; 8 questions per topic. Every route code-split. |
| 2026-09-06 | Measurement | PostHog events, session replay and error tracking. Vercel Analytics and Speed Insights had been added in August. |
| 2026-09-10 | Mobile and admin control | Installable PWA, mobile bottom nav, admin-managed popups, Term 5 catalogue corrected, Term 4 tools moved into Resources. |
| 2026-09-11 to 09-12 | Term 5 round | Faculty profiles and campus-tagged ASA ratings, database-driven Term Dossier for Term 5 with group, attendance and student-feedback data, "Your Term" follows the live round, students choose which concentration a cross-listed course counts toward. |

The full list of what each tool does today is in [PRODUCT.md](PRODUCT.md).

## What's next

Candidates, not a committed order. Eshan sets priorities; this is the list to choose from.

**Keeping the current year running**

- **Term Dossiers for Term 6, Term 7 and the remaining Block Weeks.** The page already handles any term; each needs grading profiles extracted from outlines, faculty checks and a Platform Directory link.
- **Fix the bugs below that students can hit**, starting with the Credit Tracker's reconciliation timing and core courses counting as electives.
- **Launch the Notice Board** when AAC is ready to post ([how](ADMIN_GUIDE.md#notice-board-is-still-in-preview)).
- **More Learn courses** for later core terms, through the content pipeline.
- **Refresh faculty ratings** after each term; nothing does this automatically.

**Making it reusable for the next batch**

- **Move the term calendar into the database** (it's hardcoded for Co'27 in `src/lib/termCalendar.ts`) so a new cohort doesn't need a code change.
- **Cohort awareness.** Everything assumes one batch. A second batch would need a cohort on users, courses and settings.
- **Handover:** who at AAC owns admin access, the Supabase project and the Vercel team after Co'27 graduates.

**Bigger ideas still open**

- **Full International Exchange flow** (49 partner schools, Preference Round, Bidding Round, allocation). Today students can only self-report exchange points so their budget stays honest. Eshan's call was to build the full page after the lighter version had been used.
- **Deadlines and notices on the home page.** The Credit Tracker is the dashboard AAC asked for; deadlines were left out when it was built.
- **Semantic or AI search** over resources ("find me last year's FSAN mid-term").
- **Custom GPT per course.** "Custom GPT" is already a resource type, so linking one is an admin task, not a schema change.
- **Student contributions** (submit PYQPs or notes, admin approves), like AAC's Notion repo. Needs a moderation queue.
- **Historical bidding data** (see below).

## Decisions worth knowing about

**No recommendation or risk layer.** A "risk tier per elective based on historical bid demand" was seriously considered early on and cut: this cohort had no bidding history yet, and self-reported data was judged likely to be biased (only big winners and losers bother reporting).

**Bidding Pulse shipped anyway, knowingly.** Pulse carries the same self-report risk, and worse: in a sealed-bid auction a student has a reason to under-report interest in a course they want, to discourage other bidders. An `/office-hours` design session walked through this. The decision was to accept it in exchange for a better signal than hearsay, on the condition that statistics stay hidden below 5 respondents and nobody can read anyone else's raw estimate. The rules have since loosened from "immutable" to "3 edits and removable", because preferences genuinely shift during a live round. Whether Pulse numbers track real clearing prices hasn't been checked against a real round yet.

**No embedding of resource links.** SharePoint, Google Drive and Notion block being shown in frames, and there's no reliable way to detect that before showing a student a blank box. Links open in a new tab.

**Admin access stays manual.** Granting admin is done in the Supabase dashboard, not in the app.

**Two design systems.** Learn kept its own look when merged, rather than being restyled. See [DESIGN.md](DESIGN.md).

**Faculty ratings are never averaged.** One real, labelled offering is shown, because averaging across courses, campuses, years and two different scales produces a number that describes nothing.

## Known bugs and rough edges

Found in a code review for this documentation update on 2026-09-15. None have been fixed yet.

**Planner and Credit Tracker**

- **Reconciliation waits for the calendar, not the round.** "Did you get these?" appears only after a term's calendar end date (Term 4: 2026-10-18), even though the admin has already closed bidding. Students who won Term 4 courses won't be prompted until then. The unused `app_settings.closed_bidding_terms` column was meant for this.
- **Core courses in bidding terms can count as electives.** SUET (Sustainability and Ethics) is a Term 4 core course. The Credit Tracker's "Log a confirmed course" list and the Planner's General Electives list filter by term only, not by `is_core`, so SUET can be added and counted toward the 18 elective credits.
- **The 100-point minimum bid isn't enforced when adding a course.** The input suggests 100 but 0 can be saved.
- **Goals doesn't stop a student targeting a concentration they've already been locked out of** by a failed gating course. Only the Plan step shows the warning.
- **Points in the confirmed-courses list save on every keystroke.**
- **Removing a course from Bid Budget doesn't send the `bid_entry_removed` event**, so PostHog undercounts removals.

**Bidding Pulse**

- **The 3-edit limit can be bypassed** by a hand-crafted request, because the database only checks the counter is at most 3, not that it increased. Removing and resubmitting also resets it. Fix: require the new `edit_count` to equal the old one plus one (a trigger), or track edits in a separate table.
- **Empty-state text says "No Block Week bidding is live right now"**, though Terms 4 and 5 use this page too.
- Changing an existing submission to a course already submitted shows a generic error.
- Quartiles are fetched but not displayed.

**Course Resources and popups**

- Platform Directory and pinned links to in-app pages (`/term4`, `/dossier/term-5`) open in a new tab and don't send `resource_opened`.
- Popups have no page option for `/dossier`. Page matching is by prefix, so a popup for `/term4` also shows on `/term4-bidding-qa`.

**Analytics**

- `user_signed_in` fires on every page load with an existing session, not only on real sign-ins, so it overstates sign-ins.
- `magic_link_requested` also fires for Microsoft SSO clicks (with `method: azure_sso`), so the name is misleading.
- The Term Dossier, Notice Board and Course Resources filters send no events.

**Learn**

- **"Add a new course" and the name and code fields in Learn admin don't work.** The new-course form writes a code made from the name, which fails unless it matches an existing `courses.code`, and name and code edits are ignored on save.
- **Admin-added questions have no explanation or hint** (the form lacks those fields), can't be written-answer type, and can't be edited.
- **Learn content is readable without signing in.** The content tables' read policies have no role restriction, although the migration comment says "everyone signed in". Low risk (it's study material), but it doesn't match the intent.
- **Switching a course off only hides it in the menus.** A student with the link `/learn/sessions/<code>` or `/learn/practice?course=<code>` can still open it.
- **The "Sign out" button on Learn's profile page goes back to the Learn home** instead of signing out.
- **No link to Learn admin on mobile.**
- XP and streaks are calculated in the browser and could be edited by a determined student. It only affects their own numbers.
- Some early OPMG and MKTG content migrations name generator scripts that were never committed; the SQL is the only copy.
- BANM2's content was regenerated in full twice, so three large copies of it sit in the migration history.

**Housekeeping**

- `app_settings.pulse_check_cutoff`, `current_terms` and `closed_bidding_terms` exist but nothing uses them.
- Several code comments cite migration file names that don't exist or describe older behaviour (the `AppSettings` and Pulse types in `src/types/index.ts`, `TermGlance.tsx`'s header, `devFixtures.ts`, `AdminMaterials.tsx`).
- `Term 4 Course Comparison.html` at the repo root isn't linked from anywhere. `public/course-outlines/` (16 Term 4 PDFs) is only used by the static Term 4 Dossier.
- `StepGoals.tsx` hardcodes the concentration and specialization lists instead of using the shared types.
- There is no automated test suite. The credit, budget and GPA maths in `src/lib/creditProgress.ts` and the mastery logic in `src/learn/lib/` would be the first things worth covering.

## Known data gaps

- **Some electives still show "TBD" for faculty.** That's accurate: ASA hadn't named anyone. 16 active electives as of 2026-09-11.
- **A few course codes differ between ISB's own documents** (e.g. "CDMA" vs "CDMA2", "CSOD" vs "CDOS"). One form was picked for each. Worth checking against Registro.
- **International exchange bid-point figures conflict** between two ISB documents (250 points vs 400 to 1,200 within the main pool). Unresolved, and moot while exchange isn't modelled.
- **`prerequisite_course_ids` is essentially empty**, because the outlines checked listed almost no real prerequisites.
- **`is_strategy_ob_course`** exists for Strategy and Leadership's 2+2+2 split rule, but nothing enforces the split. The app just counts total credits tagged to the concentration.
- **Core course credits for Terms 2 to 4 are unverified.** Term 1's are confirmed against a real grade report.
- **GPA points for A+, B+, B-, C+ and C- follow the confirmed step pattern** but haven't been checked against a transcript containing them.
- **SEED1/2/3's professor-to-outline mapping is inferred** from the order the names appeared, not checked inside the PDFs.
- **Pass/Fail conversion of a Flexi-to-elective course isn't modelled.** Under ISB rules it would stop counting toward the 18 credits.
- **Grading profile gaps are real, not missing work.** For Term 5, how groups form is stated in only 6 of 17 outlines, cross-section rules in 12, and two outlines (MSTC, NSDL) have no group information at all.
- **Student feedback covers 6 Term 5 electives**, from one Hyderabad-campus thread. It's anecdotal by design.
- **Faculty ratings before AY 2025-26 rarely state a campus**, so many rows show "campus not stated".
- **Course outline links point at ISB SharePoint.** Whether every student account can open them hasn't been checked cohort-wide.

## Historical bidding data: the bigger unlock

ISB holds roughly 25 years of bidding and enrolment data. Access needs a formal pitch to the administration. It was scoped out of v1 as valuable but not needed, since a rules-based tool works without it. If it becomes available, it would allow two things: a real, evidence-based view of how competitive each course is (in place of the cut risk layer), and a check of whether Bidding Pulse estimates track actual clearing prices.

## If you're picking this up cold

Read [PRODUCT.md](PRODUCT.md), then [ARCHITECTURE.md](ARCHITECTURE.md) and [DATA_MODEL.md](DATA_MODEL.md). Then skim the git log: commit messages on this repo carry the reasoning behind fixes, scope cuts and UX calls.
