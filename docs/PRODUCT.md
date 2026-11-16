# Product guide

What each tool does, from a student's point of view, and the rules behind it. For why the product exists and how it should sound, see [VISION.md](VISION.md). For how it is built, see [ARCHITECTURE.md](ARCHITECTURE.md). For the Learn section in depth, see [LEARN.md](LEARN.md).

## Who it's for

PGP students at ISB Mohali, Co'27, during their programme year (July 2026 to mid 2027). Anyone with an `@isb.edu` Microsoft account can sign in. AAC members with the admin flag also run the content and settings.

The app is shaped around the programme's calendar:

- **Terms 1 to 3** are core courses plus Flexi Core picks in Terms 2 and 3. No bidding. Students mostly use Learn and Course Resources here, and log grades in the Credit Tracker.
- **Terms 4 to 7 and Block Weeks 1 to 4** are electives, won by bidding. This is where the Bidding Planner, Term Dossier and Bidding Pulse matter.
- **All year**, the Credit Tracker is the home page and the running record.

## Product rules that apply everywhere

These were explicit decisions, and they show up in several tools.

1. **Never recommend what to bid or which course to take.** The app shows where a student stands against goals they set themselves. "Matches your role" style tags are informational and never used to rank courses. The Dossier's "Build the term" describes a mix of courses without scoring it.
2. **Nothing is submitted anywhere.** The bid plan is a personal notebook. It is not connected to Registro.
3. **Never average things that shouldn't be averaged.** Faculty ratings always show one real, labelled offering (course, campus, year), never a blended score. Ratings on the old 7-point scale and new 5-point scale are never mixed.
4. **Cohort data is only shown in aggregate, and only above a threshold.** Bidding Pulse hides every statistic until 5 students have answered, and no one, including admins, can read another student's raw estimate.
5. **"Not stated" is not a guess.** If a course outline doesn't say whether attendance is mandatory, the app says "Not stated in the outline" rather than assuming ISB's default.
6. **Soft-disable, don't delete.** Courses are hidden with a switch, never deleted, because ISB has brought dropped courses back before.
7. **Colour is never the only signal.** Tags, warnings and statuses always carry text.

## Credit Tracker (`/tracker`, the home page)

The record of what actually happened, kept separate from what a student planned.

What the student sees, top to bottom:

1. **Four stat cards:** elective credits secured (out of 18), bid points remaining, points paid so far, overall GPA (out of 4.0). A red banner appears if the student has spent into their reserve.
2. **"Did you get these?"** Once a term's dates have passed, every planned bid for that term that hasn't been resolved shows up here. The student enters what they actually paid and taps "Got it", or taps "Didn't get it".
3. **Concentration and specialization progress:** credits toward each target, out of the 6 needed.
4. **Term 1 to 3 grades:** core courses and the student's Flexi Core picks are listed automatically. Picking a grade saves it.
5. **Log a confirmed course:** add an elective by hand with points paid and an optional grade.
6. **Your confirmed courses:** grouped by term, collapsed by default, with editable points and grades and a Remove button. Cross-listed courses show a picker for which concentration they count toward.

Rules:

- **GPA** uses ISB's grade points (A=4, A-=3.5, B=3, B-=2.5, C=2, C-=1.5, D=1, F=0), weighted by credits. Pass/Fail courses are left out. C, B and A- were checked against a real transcript; the others follow the same step.
- **Bid points remaining** = 4,500 − points spent − exchange points − reserve. The reserve is 100 points for each credit still needed to reach 18. Going negative is a warning, not a block.
- **Elective credits** count the Flexi Core course a student converted to an elective (only the third pick in a term converts) plus courses in biddable terms.
- **Term end dates** come from ISB's Co'27 calendar, hardcoded in `src/lib/termCalendar.ts`.

## Bidding Planner (`/planner/:step`)

A guided flow in five steps. Any step can be opened directly. Two tiles stay visible at the top throughout: elective credits (X of 18) and bid points remaining. On a phone, Back and Continue stick above the bottom navigation bar.

### 1. Your Background

- Undergraduate field, work-ex domain and role (used only for the soft relevance tags).
- Flexi Core courses taken in Terms 2 and 3 (minimum 2, maximum 3 per term; only one of BACF2 and BANM2). Picking a third asks which one converts to an elective.
- Any failed "gating" core course. Failing one of five specific core courses permanently closes a concentration (from the Elective Bidding FAQ).

Every change saves immediately. If a save fails, the change is rolled back and an error is shown.

### 2. Your Goals

Up to two concentrations (or none) and one industry specialization (or none/undecided). ISB allows at most two concentrations and one specialization on a transcript.

Concentrations: Entrepreneurship, Finance, Marketing, Operations Management, Information Technology Management, Strategy and Leadership.
Specializations: Healthcare, Manufacturing, Public Policy, Infrastructure.

### 3. Your Plan

- **One card per target concentration or specialization**, with a progress bar out of 6 credits. If a failed gating course has closed it, the card turns red and says so.
- **Courses grouped by term.** Terms the admin has marked as the live bidding round are open at the top under "Live now". Other terms are collapsed, with the next one pre-opened.
- **A General Electives card** for courses outside all chosen areas.
- **Each course row** shows the name, faculty rating badge, professor, term, credits, links to the outline and overview video, a "Profile" link to a side panel with faculty details and resources, "counts toward" tags, and soft relevance tags ("Matches your role", "Connects to your undergrad", "Builds on a Term 2/3 course you already took").
- **Adding a course** takes a points amount. It is blocked if the points exceed what's available, or if the term would go over its admin-set maximum credits.
- **Cross-listed courses** (tagged to two or more concentrations) show chips to pick which concentration they count toward. ISB's FAQ Q45 says a course counts toward only one. The default is the first of the student's targets that the course matches.

### 4. Your Term

Only shows the terms the admin has marked live. If nothing is live, it says so.

For each live term:

- For courses already in the plan that have a grading profile: total mid-terms, end-terms and quizzes, and the split between individual and group grades.
- Every course in the term, planned ones first, each with a grade-split bar and an expandable "Every detail" section from its outline.

### 5. Bid Budget

- Total points (4,500), planned so far, and the reserve.
- Self-reported points already spent on International or Inter-Campus Exchange, which draw from the same pool (FAQ Q4). The full exchange flow is not modelled.
- One box per term, showing planned credits against ISB's limits (Term 4 and 6: 3 to 4 credits; Term 5 and 7: 3 to 5; Block Weeks: up to 1). Admins can change these limits.
- "Nothing here is submitted to Registro."

## Bidding Pulse (`/pulse-check`)

A structured alternative to guessing from WhatsApp. During a live round, students can share how many points they expect to bid on a course.

1. The page shows one section per live term.
2. The student picks a course, enters an estimate (100 to 4,500 points), and confirms in a dialog. They can add more courses, one submission per course.
3. Each submission can be edited up to 3 times or removed while the round is live.
4. **The cohort view only unlocks after the student has submitted at least once for that term.** This stops people reading without contributing.
5. Each course card shows "Not enough data yet (n/5)" until 5 students have answered. After that it shows the min to max range, the number of responses, and a 5-bar histogram. Cards stay in catalogue order, never sorted by popularity.

Why it was built despite the risk: in a sealed-bid auction, students have a reason to under-report interest in courses they want. That was discussed and accepted in exchange for a better signal than hearsay. Only aggregates above the threshold are shown, and raw estimates are unreadable by anyone else; those limits were part of the decision. See [ROADMAP.md](ROADMAP.md#decisions-worth-knowing-about).

## Term Dossier (`/dossier/:term`)

One page per term that compares every elective using data taken from the official course outlines. It is live for Term 5 at `/dossier/term-5`, and `/term5` redirects there. A new term needs data in the database, not new code.

- **Headline stats:** electives on record, how many have a mid- or end-term, average group weight.
- **Browse tab:** sorted A to Z by default; also by code, professor, exam weight, group weight or individual weight. Filter by things students actually ask about: no sit-down exam, cross-section groups allowed, self-selected groups, peer evaluation, attendance not mandatory, group work of 25% or less, plus a concentration filter. Each card shows what the course counts toward.
- **Side by side tab:** up to 4 pinned courses in a comparison table.
- **Build the term tab:** pick up to 4 courses and see the combined credits, exam count and a plain description of the mix.
- **Course detail:** what you learn, what it counts toward, grade split, "Good to know before you bid" (exams, group size, cross-section groups, how groups are formed, peer evaluation, attendance), the rest of the brief, faculty cards with ratings and the overview video, a line saying when the outline was read and that professors can revise it, and the outline link.

The Dossier and Your Term describe courses and do not rank them. There is no workload score, tier, chart or "heaviest first" sort, and no student feedback, because outlines change when students talk to professors and a number would outlive the outline (feedback from ASA, 2026-10-30). The six 0-5 load scores and `student_feedback` are still stored and editable in Admin, but no student page reads them. Faculty ratings are not shown on course cards in the Planner; they sit on the professor's card inside the course detail.

**Faculty ratings** come from ASA's FacultyRatings pages. The badge picks one real past offering in this order: this course at Mohali, this course at another stated campus, this course with no campus stated, then the professor's most recent other course (labelled "other course"). Ratings with fewer than 5 responses are marked.

### Term 4 Dossier and Bidding Q&A (`/term4`, `/term4-bidding-qa`)

Two standalone HTML pages built for the Term 4 round by Vidhi Agarwal and credited to AAC and the AI Native SIG. They are shown inside the app in a full-height frame and are not connected to the database. The Q&A page links to a ChatGPT-based "Term 4 Bidding Assistant". Both are kept for reference and listed in Course Resources' Platform Directory. The database-driven Term Dossier replaces this approach for Term 5 onward.

## Course Resources (`/resources`)

One searchable page for all course material.

- **Filters live in the URL** (search, term, core or elective, resource type, open course), so a filtered view can be shared as a link.
- The term filter defaults to the current term by calendar date.
- **Pinned banner** at the top for cohort-wide highlights.
- **Platform Directory:** cards linking to ISB platforms (Atrium, LMS and so on) and AAC tools like the Term Dossiers.
- **General Resources:** material not tied to one course.
- **Course grid:** each card opens a side panel (expandable to full screen) with faculty information and up to four tabs of resources: Course Details (outline, professor profile), Session Resources (slides, transcripts, summaries), Exam Resources (PYQPs, custom GPTs, cheatsheets, notes) and Others. Empty tabs are hidden.

Links open in a new tab. Embedding was rejected because SharePoint, Drive and Notion block being framed.

## Learn (`/learn`)

A study space for Term 1 to 3 core courses, merged in from a separate "mktg-rep" learning app in August 2026. Summary:

- A course picker, then sessions and concept notes with worked examples, maths and interactive widgets.
- **Smart practice:** 8-question rounds that favour the student's weakest topics and bring missed topics back after two more questions. Mastery has five levels per topic.
- XP, a day streak and a round summary showing which topics moved up or down.
- Read-only question banks with model answers for courses graded on written answers (BANM2).
- End-term revision guides for OPMG and MADM2.

Live courses: Marketing Management (MKTG), Operations Management (OPMG), Business Analytics for Marketing and Growth (BANM2), Managerial Accounting (MADM2). Full detail in [LEARN.md](LEARN.md).

## Compass (`/compass`, admins only for now)

Ask about anything from the loaded courses in your own words and get a short card: what the idea is, when to use it, what to watch out for, where it was taught, and a Moodle link. If the material doesn't cover it, the page says so. Cards are written once from class material and checked against it, and no AI writes anything when you ask. As of 7 Nov 2026 it covers 22 of 138 courses with 1,163 cards. Admins can also use the same cards inside Claude through a connector. Full guide: [COMPASS.md](COMPASS.md); current status: [COMPASS_HANDOFF.md](COMPASS_HANDOFF.md).

## Notice Board (`/notices`)

A feed of AAC announcements, pinned ones first, each tagged Urgent, Important, Info or General. It is fully built but only admins can open it. Students see it greyed out with a "SOON" badge. Launching it is a small code change described in [ADMIN_GUIDE.md](ADMIN_GUIDE.md#notice-board-is-still-in-preview).

## Popups

Admins can show a one-off dialog on any page, for example to point students at Learn before end-terms. Each popup picks a page (or all pages), how often it appears (every visit, once per browser session, or once ever), and an optional button that dismisses, goes to a page in the app, or opens an external link. Only one popup shows at a time.

## Signing in

- **Sign in with Microsoft SSO** (the normal path) or **email me a magic link**. Both only accept `@isb.edu` addresses; anything else is signed straight back out.
- The login is shared with `isb-explorer`, the campus-life app. Signing in to one signs you in to the other in the same browser.
- A student who has signed in but has no account row yet sees "Account not set up yet" and is asked to sign in to isb-explorer first or contact AAC.

## Installing on a phone

The app is a Progressive Web App. On iOS (Safari, Share, Add to Home Screen) or Android it installs with the ISB icon and runs without browser bars. On phones, a bottom bar gives one-tap access to Learn, Tracker, Planner, Pulse and Resources.

## Who can do what

| | Student (`@isb.edu`) | Admin (`users.is_admin = true`) |
|---|---|---|
| Learn, Credit Tracker, Bidding Planner, Bidding Pulse, Term Dossiers, Course Resources | Yes | Yes |
| Notice Board | Greyed out | Yes, marked PREVIEW |
| Admin panel (`/admin`) and Learn admin (`/learn/admin`) | No | Yes |
| Learn courses switched off | "Coming soon" | Can open them, marked Preview |
| Sidebar links marked admin-only | Hidden | Shown |

Admin access is granted by hand in the Supabase dashboard, never from inside the app. See [ADMIN_GUIDE.md](ADMIN_GUIDE.md#granting-admin-access).

## What we measure

Compass adds `compass_ask` (first 60 characters of the question), `compass_source_click` and `compass_report`.

PostHog records these events: sign-in, planner step changes, bids added and removed, course profile opened, bids reconciled, grades logged, enrollments added and removed, Pulse submissions/edits/removals, resource opened, popup shown/dismissed/clicked, and Learn practice started. Session replay and error tracking are on. The Term Dossier, Notice Board and Course Resources filters don't send events yet.

Adoption as of mid-November (sign-ups, return rate, peak weeks) is in [VISION.md](VISION.md#proof-so-far), with the caveats on each number.
