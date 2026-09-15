# Data Model

All tables live in the Supabase project shared with `isb-explorer`. Every schema change is a timestamped file in `supabase/migrations/`, and those files are the source of truth. This doc is a readable summary, current as of `20260912090400_seed_term5_student_feedback.sql` (2026-09-12).

To apply migrations: `supabase db push`, with the CLI linked via `supabase link --project-ref ujnrgvmbahbepdnahtle`. Always use the CLI, never the dashboard's SQL editor, or the migration history drifts. See [ARCHITECTURE.md](ARCHITECTURE.md#database-changes).

## All tables at a glance

| Area | Table | Purpose | Who can read / write |
|---|---|---|---|
| Identity | `users` | Shared account row, `is_admin` flag. Owned by isb-explorer. | See isb-explorer |
| Catalogue | `courses` | Every core, Flexi Core and elective course | Everyone / admins |
| Catalogue | `gating_core_courses` | 5 core courses whose F grade closes a concentration | Everyone / fixed seed |
| Catalogue | `course_grading_profiles` | Grading, exams, workload, group and attendance rules, student feedback, per course | Everyone / admins |
| Catalogue | `faculty`, `course_faculty`, `faculty_ratings` | Professor profiles, who teaches what, ASA ratings | Signed-in users / admins |
| Planning | `student_academic_profiles` | A student's background, goals, Flexi picks, exchange points | Own row |
| Planning | `bid_plan_entries` | Personal bid ledger (intent) | Own rows |
| Planning | `actual_enrollments` | Courses actually won, points paid, grades (result) | Own rows |
| Planning | `pulse_check_submissions` | Anonymous bid estimates for Bidding Pulse | Own rows only; aggregates via functions |
| Content | `resources` | Links for Course Resources | Everyone / admins |
| Content | `notifications` | Notice Board posts | Everyone / admins |
| Content | `nav_links` | Admin-managed extra sidebar links | By visibility / admins |
| Content | `dashboard_popups` | Admin-authored popups | Everyone / admins |
| Settings | `app_settings` | Single row: live bidding round, term credit limits | Everyone / admins |
| Learn | `learn_*` (10 tables) + `course-materials` bucket | Study content and per-student progress | See [Learn tables](#learn-tables) |

## Source of truth for course/programme data

`courses` rows (term, credits, `concentration_areas`, `industry_specializations`, core vs. elective, etc.) were seeded by hand and have no citation trail in this repo. When a tag looks wrong or you're adding/editing a course, verify against ISB's own SharePoint pages (require an ISB login):

- [PGP Home page](https://isbhydmoh.sharepoint.com/sites/atrium/Programmes/PGP/ASA-PGP-2026-27/Pages/Atrium-%E2%80%93-Index-.aspx)
- [Calendar](https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FCourseDetails%2FShared%20Documents%2FGeneral%2FPGP%5FMohali%2F2026%2D2027%2FAcademic%20Calendar%2FLong%20Calendar%20PGP%20Co%2727%2Epdf&parent=%2Fsites%2FCourseDetails%2FShared%20Documents%2FGeneral%2FPGP%5FMohali%2F2026%2D2027%2FAcademic%20Calendar)
- [Course Details](https://isbhydmoh.sharepoint.com/sites/atrium/Programmes/PGP/ASA-PGP-2026-27/Mohali-2026-27/Pages/default.aspx)
- [Mandatory courses](https://isbhydmoh.sharepoint.com/sites/atrium/Programmes/PGP/ASA-PGP-2026-27/StudentManual/Pages/Programme%20Administration/Core_Courses_2026-27.aspx)
- [Flexi Core courses](https://isbhydmoh.sharepoint.com/sites/atrium/Programmes/PGP/ASA-PGP-2026-27/StudentManual/Pages/Programme%20Administration/Flexi-Core-Courses.aspx)
- [Course lineup, Mohali 2026-27](https://isbhydmoh.sharepoint.com/sites/atrium/Programmes/PGP/ASA-PGP-2026-27/Mohali-2026-27/Pages/Lineup_Mohalil_2026-27_Core_and_Elective.aspx): faculty, academic area, associates, outline and overview video per course.
- Atrium Faculty list (`/sites/atrium/Lists/Faculty`) and ASA's FacultyRatings pages (`/teams/Atrium2/ASA/FacultyRatings`): professor profiles and ratings.

## `users` (owned by isb-explorer, not this app)

isb-academics reads and updates this table but doesn't own its schema. Relevant columns:

| Column | Type | Notes |
|---|---|---|
| `id` | uuid | Matches `auth.users.id` |
| `name`, `email` | text | |
| `is_admin` | boolean | **The only access-control flag in the whole app.** Gates the Admin panel, Learn admin, Notice Board, admin-only sidebar links, and every admin write policy. See [ADMIN_GUIDE.md](ADMIN_GUIDE.md#granting-admin-access) for how to set it. |

## `courses`

The full catalogue. First seeded in July 2026 with 132 rows (121 electives and Flexi Core, 11 mandatory core courses), then corrected for Term 5 on 2026-09-10 and refreshed from ASA's 2026-27 Mohali lineup on 2026-09-11 (see the migration history below).

| Column | Type | Notes |
|---|---|---|
| `id` | uuid PK | |
| `code` | text, **unique** | e.g. `FSAN`, `FCRV`. Unique constraint added specifically to support `on conflict (code) do update` upserts when re-loading catalog data. |
| `name` | text | |
| `professor` | text | Display string, e.g. `"Ashwini Chhatre / Pankaj Kumar"`. The structured version (per-person sessions, affiliation, ratings) lives in `course_faculty` and `faculty` below. `"TBD"` means ASA hasn't named anyone yet: 16 active electives as of 2026-09-11. |
| `term` | text | One of `Term 1`–`Term 7`, `Block Week 1`–`Block Week 4`. Not a Postgres enum — validated only in the TypeScript `TermCode` type. |
| `credits` | **numeric**, not integer | Widened from `integer` because two core courses have fractional credits: Written Analysis and Communication (0.6) and Mastering Verbal Communication (0.4). If you ever see credits behaving oddly, check whether something upstream coerced this back to an int. |
| `concentration_areas` | text[] | Zero or more of the 6 ISB concentrations. A cross-listed elective can belong to more than one. **Empty for all core courses** — that's what keeps core courses invisible to Bidding Planner's area-matching logic; no special "exclude core" filter was needed. |
| `industry_specializations` | text[] | Zero or more of the 4 ISB industry specializations. Same cross-listing behavior. |
| `is_strategy_ob_course` | boolean | For the Strategy & Leadership concentration's 2+2+2 split rule (2 STLD + 2 OB + 2 either). **Defined in schema but not yet consumed anywhere in the app logic** — flagged in [ROADMAP.md](ROADMAP.md). |
| `prerequisite_course_ids` | uuid[] | **Present in schema, essentially unused in data.** A pass through Block Week 1 & 2 course outlines found real prerequisites on almost none of them — mostly "None" or informal text like "an open mind." Not populated because there was nothing real to populate. |
| `is_active` | boolean, default `true` | Soft-disable flag. `false` = dropped/hidden from students, but the row and all its history stays. Toggled from Admin, never hard-deleted. |
| `is_core` | boolean, default `false` | Mandatory course vs. elective/Flexi Core. Exposed in the Admin form, not just a DB-only flag. |
| `academic_area` | text, nullable | ASA's academic-area code (`FINC`, `ORBH`, …), straight from the lineup. |
| `academic_associates` | text[] | Names from the lineup's Academic Associate(s) column. A core course lists the associates of every section. |
| `overview_video_url` | text, nullable | ASA's course overview video, where the lineup has one (11 courses as of 2026-09-11). |

**`useCourses(showAll = false)`** is the only place `is_active` filtering happens — students only ever see `is_active = true`; Admin passes `showAll = true` to see everything including disabled rows.

## `gating_core_courses`

Fixed reference table, 5 rows, seeded once and not expected to change:

| id | name | term | blocks_concentration |
|---|---|---|---|
| `leadership_core` | Leading Self and Teams | Term 1 | Strategy and Leadership |
| `fcrv` | FCRV | Term 2 | Finance |
| `strategy_core` | Strategy | Term 2 | Strategy and Leadership |
| `marketing_mgmt` | Marketing Management | Term 3 | Marketing |
| `opmt_core` | Operations Management | Term 3 | Operations Management |

An F grade in any of these permanently blocks the matching concentration — this is a real ISB rule, not a guess, sourced from the Elective Bidding FAQ.

## `student_academic_profiles`

One row per student, keyed on `user_id`. This is the Bidding Planner's core input state.

| Column | Type | Notes |
|---|---|---|
| `user_id` | uuid PK, FK → `users.id` | |
| `undergrad_field` | text | Dropdown-constrained in the UI (`UNDERGRAD_FIELDS` in `lib/options.ts`), stored as free text — nothing in the DB enforces the constraint. |
| `work_ex_domain` | text | Same pattern — dropdown UI, unconstrained DB. |
| `work_ex_role` | text | Added after domain alone was judged too broad — an engineer and a PM in "IT/Tech" need different electives. Feeds the soft relevance tags. |
| `work_ex_years` | numeric | |
| `failed_gating_courses` | text[] | IDs from `gating_core_courses`. |
| `target_concentrations` | text[], **max 2 enforced client-side** | ISB allows "at most two" concentrations. Nothing in the DB enforces the 2-item cap — it's a `MAX_CONCENTRATIONS` constant checked in `StepGoals.tsx`. |
| `target_specialization` | text, nullable | Single value (ISB only allows one specialization on the transcript) or `"none"`/`"undecided"`. |
| `completed_term2_flexi` | text[] | Course codes from `TERM2_FLEXI_OPTIONS`. Min 2 (required, no credit), max 3. |
| `completed_term3_flexi` | text[] | Course codes from `TERM3_FLEXI_OPTIONS`. Min 2 (required, no credit), max 3. |
| `term2_converted_elective` | text, nullable | Which `completed_term2_flexi` code (if any) is the mandatory 3rd-course conversion to elective — per ISB's "Flexi Core Courses" doc, the first 2 picks never count toward credit; only this one does. Null unless exactly 3 were picked. |
| `term3_converted_elective` | text, nullable | Same, for Term 3. |
| `international_exchange_points_used` | integer, nullable | Self-reported — International Exchange draws from the same 4,500-point pool as regular bidding but isn't modeled as a full flow yet (see ROADMAP). |
| `inter_campus_exchange_points_used` | integer, nullable | Self-reported, same reasoning. |
| `cross_listed_concentration_choices` | jsonb, default `{}` | Course code → concentration area. Which single concentration a cross-listed course counts toward (FAQ Q45). Set from the chips in `ConcentrationChoice.tsx` for any course tagged to 2+ concentrations, and the student may pick an area that isn't one of their targets (the course then counts toward neither target). With no entry, `chosenConcentrationFor` in `lib/creditProgress.ts` uses the first target the course matches, then the course's first area. |

**RLS:** `auth.uid() = user_id` for all operations — students can only ever see/edit their own row.

## `bid_plan_entries`

The student's own bid-points ledger — never submitted anywhere, purely a personal planning aid.

| Column | Type | Notes |
|---|---|---|
| `id` | uuid PK | |
| `user_id` | uuid, FK → `users.id` | |
| `course_id` | uuid, FK → `courses.id`, nullable | Nullable via `on delete set null` — if a course is ever hard-deleted, existing plan entries survive with a dangling reference rather than cascading away. |
| `term` | text | Denormalized copy of the course's term at time of adding — not re-derived live. |
| `planned_points` | integer | |
| `actual_points` | integer, nullable | `null` = unresolved. Written by the Credit Tracker's reconciliation queue (`resolveEntry` in `useBidPlan.ts`) once a term's bidding round has ended (per `termCalendar.ts` real dates): a positive number is what was actually paid, `0` is the sentinel for "resolved, didn't get it" (a real winning bid is always ≥ `MIN_BID_PER_COURSE`). See `pendingReconciliations()` in `lib/creditProgress.ts`. |

Credit math (`lib/creditProgress.ts`) sums real `courses.credits` for both planned bid entries and the mandatorily-converted Flexi elective (`totalElectiveCreditsSecured`) — the earlier "1 entry = 1 credit" approximation was corrected once it became clear it fed directly into the bid-points reserve rule (`computeBidBudget`).

**RLS:** `auth.uid() = user_id`, same pattern as the profile table.

## `resources`

| Column | Type | Notes |
|---|---|---|
| `id` | uuid PK | |
| `title` | text | |
| `url` | text | |
| `description` | text, nullable | Admin-written blurb, shown to students so they don't have to click through to know what a resource contains. |
| `resource_type` | text | See taxonomy below. |
| `term` | text, nullable | Only meaningful for course-scoped types; `null` for Platform Directory/General. |
| `course_id` | uuid, FK → `courses.id`, nullable | `on delete set null`. |
| `pinned` | boolean | Sorts first within its list. |
| `pinned_global` | boolean | Also shown in the pinned banner at the top of Course Resources. |
| `created_at` | timestamptz | |

**Unique on (`course_id`, `url`)**, so the same link can't be filed twice under one course.

**Resource type taxonomy** (`RESOURCE_TABS` in `lib/options.ts`) — grouped into exactly 4 tabs per course in the UI, per an explicit instruction not to let this sprawl:

| Tab | Types |
|---|---|
| Course Details | Course Outline, Professor Profile |
| Session Resources | Slides, Session Transcript, Summary |
| Exam Resources | PYQP, Custom GPT, Cheatsheet, Student Notes |
| Others | Other |
| *(not tied to a course)* | Platform Directory, General |

The course detail panel only renders a tab if that course has ≥1 resource in it — never an empty tab. `tabForResourceType()` in `lib/options.ts` maps a raw type back to its tab.

**RLS:** world-readable (`for select using (true)`). Writes require `is_admin = true` on the caller's `users` row, enforced via an `exists (select 1 from users ...)` subquery in the policy — not just a client-side check.

## `notifications`

The Notice Board feed.

| Column | Type | Notes |
|---|---|---|
| `id` | uuid PK | |
| `title`, `body` | text | |
| `tag` | text, default `'General'` | One of `Urgent`, `Important`, `Info`, `General`. Always shown as a text badge — never color alone, for accessibility. |
| `pinned` | boolean, default `false` | Pinned items sort first (`useNotifications` orders `pinned desc, created_at desc`). |
| `created_at` | timestamptz | |

**RLS:** same world-readable / admin-write pattern as `resources`.

## `pulse_check_submissions`

Bidding Pulse: a student's voluntary estimate of how many points they'll bid on a course during a live round. Kept apart from `bid_plan_entries`, which is private planning data never shared in any form.

| Column | Type | Notes |
|---|---|---|
| `id` | uuid PK | |
| `user_id` | uuid, FK → `users.id` | |
| `course_id` | uuid, FK → `courses.id`, **not nullable**, `on delete cascade` | A submission with no course means nothing, so there's no reason to keep it. |
| `term` | text | Copied from the course's term at submit time. |
| `bid_points_estimate` | integer, `check (>= 100 and <= 4500)` | Mirrors the real bidding minimum and total. |
| `edit_count` | integer, default `0`, `check (0 to 3)` | How many times the submission has been edited. |
| `created_at` | timestamptz | |

**Unique on (`user_id`, `course_id`)**: one submission per student per course. This replaced the original (`user_id`, `term`) constraint in `20260804155637` once Term 4 made it clear students weigh several courses per round.

**RLS is the safety design**, not an afterthought:

- **Students can only select their own rows.** There is no admin read policy and no way for anyone else to read another student's estimate.
- **Insert, update and delete are allowed only while the row's `term` is in `app_settings.live_bidding_terms`.** This replaced a separate `pulse_check_cutoff` date in `20260804131655`: that date had to be kept in sync by hand, went stale when Term 4 went live, and blocked every submission. The live-round toggle is now the single signal for both the UI and the database.
- **Inserts must have `edit_count = 0`. Updates are allowed while `edit_count < 3`.** Known gap: the update policy only checks the new value is at most 3, not that it went up, so a hand-crafted request could reset the counter, and remove-then-resubmit also starts again at 0. The app always increments, so this only matters against someone deliberately bypassing the UI. See [ROADMAP.md](ROADMAP.md#known-bugs-and-rough-edges).
- **Removing a submission** is allowed while the term is live.

**Reading the aggregate** only happens through two `security definer` functions, both callable by signed-in users only (execute revoked from `public` and `anon`):

- `pulse_check_results_by_term(p_term)` returns per course: `course_id, respondent_count, min_points, p25_points, median_points, p75_points, max_points`. All five statistics are `null` until `respondent_count >= 5`. A select policy broad enough to compute this in the browser would expose every student's exact number.
- `pulse_check_histogram_by_term(p_term)` returns `course_id, bucket_index, bucket_start, bucket_end, bucket_count`: 5 buckets per course via `width_bucket()`, only for courses with at least 5 submissions. The UI draws it as a small bar chart, not a smooth curve, because 5 to 20 answers don't support one.

The UI currently shows the min-max range, count and histogram; the quartiles are fetched but not displayed.

**Why this exists despite a similar idea being cut:** see [ROADMAP.md](ROADMAP.md#decisions-worth-knowing-about). The threshold and own-rows-only reading are the conditions that decision was made on.

## `app_settings`

A single-row table (`id boolean primary key`, must be `true`). Readable by everyone, writable by admins. Read by `useAppSettings`.

| Column | Type | Used? | Notes |
|---|---|---|---|
| `live_bidding_terms` | text[] | **Yes** | Which terms or Block Weeks are in a live bidding round. Set from Admin → Overview. Drives the Planner's "Live now" grouping, the Your Term step, which sections Bidding Pulse shows, and the Pulse RLS policies. |
| `term_credit_limits` | jsonb | **Yes** | Min and max elective credits per term, e.g. `{"Term 4": {"min": 3, "max": 4}}`. Seeded from FAQ Q9: Term 4 and 6 3-4, Term 5 and 7 3-5, Block Weeks 0-1. Admin → Overview edits it. The Planner blocks adding a course past a term's max; Bid Budget flags a term under its min. |
| `updated_at` | timestamptz | | |
| `pulse_check_cutoff` | timestamptz | No | Obsolete since `20260804131655`. Still present in the table and the TypeScript `AppSettings` type. |
| `current_terms`, `closed_bidding_terms` | text[] | No | Added in `20260803111854` for a planned "which bids are closed" flow. Nothing reads them. The Credit Tracker's reconciliation uses calendar dates from `termCalendar.ts` instead. |

## `dashboard_popups`

Admin-authored dialogs, shown by `PopupManager.tsx` (mounted once in `Layout`). Created in `20260803111854`, made generic in `20260910084958`. Readable by everyone, writable by admins.

| Column | Type | Notes |
|---|---|---|
| `slug` | text PK | New popups made in Admin get a random UUID. |
| `enabled` | boolean | |
| `title`, `body` | text | |
| `icon` | text, nullable | Key into `POPUP_ICONS` (`src/lib/popupIcons.ts`). |
| `page` | text, default `''` | Route prefix it shows on, e.g. `/tracker`. Empty means every page. Matching is by prefix, so `/term4` also matches `/term4-bidding-qa`. |
| `frequency` | text, check `always` / `session` / `once` | `always` shows on every visit; `session` stays dismissed for the browser tab (sessionStorage); `once` stays dismissed for good (localStorage). Dismissal is stored in the browser, not the database. |
| `primary_label` | text, default `'Got it'` | |
| `primary_action` | text, check `dismiss` / `internal` / `external` | What the main button does. |
| `primary_target` | text, nullable | Route or URL for `internal` / `external`. |
| `secondary_label` | text, nullable | Optional second button that dismisses. |
| `updated_at` | timestamptz | The newest enabled matching popup wins; only one shows at a time. |

Seeded rows: `bidding_reconciliation` (disabled, left over from before the UI existed) and `learn-tab-promo` (on `/tracker`, links to `/learn/practice`).

## `nav_links`

Admin-managed extra links, rendered in the sidebar below the fixed primary pages (Learn, Credit Tracker, Bidding Planner, Bidding Pulse, Course Resources, Notice Board, all hardcoded in `Sidebar.tsx`). The sidebar shows at most 4 of these and folds the rest into an "N more in Resources" row.

| Column | Type | Notes |
|---|---|---|
| `id` | uuid PK | |
| `label` | text | |
| `icon` | text | Key into `NAV_LINK_ICONS` (`src/lib/navLinkIcons.ts`) — a curated ~18-icon subset of lucide-react, picked from a dropdown in the admin form. |
| `link_type` | text | `internal` (in-app route, opens in same tab, gets active-state highlighting) or `external` (full URL, opens in a new tab). |
| `href` | text | Relative path for `internal`, full URL for `external`. |
| `visibility` | text, default `'everyone'` | `everyone` or `admin` — mirrors the `RequireAdmin` gate; non-admins never see `admin`-only links. |
| `sort_order` | integer, default `0` | Reordered via up/down buttons in the admin form (two rows swap `sort_order`). |
| `created_at` | timestamptz | |

**RLS:** same world-readable / admin-write pattern as `resources`.

**App-level behavior, not a DB constraint:** creating a new `nav_links` row (not editing an existing one) also inserts a matching `resources` row (`resource_type: "Platform Directory"`, same `title`/`url`) — see `handleSave` in `AdminPage.tsx`'s `NavLinksAdmin`. Deliberately **no FK between the two tables** — deleting a nav link must not take its resource down with it (Eshan's explicit call), so this is a one-way, fire-and-forget insert at creation time only, not a maintained relationship.

## `actual_enrollments`

What a student actually ended up enrolled in — separate from `bid_plan_entries` (their bid *intentions*), since bidding results can diverge from a plan and grades don't belong on a "plan" table at all. Powers the Credit Tracker (`CreditTracker.tsx`).

| Column | Type | Notes |
|---|---|---|
| `id` | uuid PK | |
| `user_id` | uuid, FK → `users.id`, `on delete cascade` | |
| `course_id` | uuid, FK → `courses.id`, nullable, `on delete set null` | Same dangling-reference-survives pattern as `bid_plan_entries.course_id`. |
| `term` | text | Denormalized from the course's term, same pattern as `bid_plan_entries.term`. |
| `points_paid` | integer, default `0` | What was actually paid to win the bid. `0` for courses that were never bid on at all (Term 1-3 core and Flexi Core — see below). |
| `grade` | text, nullable | Free-text letter grade (`A+` … `F`, or `Pass`/`Fail`). Not DB-constrained to a fixed set; the UI's `GRADE_OPTIONS` (`CreditTracker.tsx`) is the only enforcement. |
| `created_at` | timestamptz | |

**Unique constraint on (`user_id`, `course_id`, `term`)** — one row per student per course per term, same pattern as `bid_plan_entries`.

**Two ways a row gets created**, both from `CreditTracker.tsx`:
1. **Electives (Term 4+/Block Weeks)** — either logged manually via the "Log a confirmed course" form, or created by the reconciliation queue when a student confirms they got a planned course (`points_paid` copied from what they say they actually paid).
2. **Term 1-3 core + Flexi Core** — these never go through bidding, so there's no "add" step; every mandatory core course (`courses.is_core = true`) for Term 1-3 is listed automatically, plus whichever Flexi Core codes the student recorded in their `student_academic_profiles.completed_term2_flexi`/`completed_term3_flexi`. Picking a grade for one of these calls `upsertGrade` (`useActualEnrollments.ts`), which creates the row on first use with `points_paid: 0`.

**GPA** (`computeGPA` in `CreditTracker.tsx`) is a credit-weighted average of `grade` across every row here with a recognized letter grade, on ISB's real scale — confirmed against an actual `elearn.isb.edu` letter-grade report (whole letters on integers: A=4, B=3, C=2, D=1, F=0; `+`/`-` shifts by 0.5, capped at 4.0). Rows with `grade` set to `Pass`/`Fail` are excluded from the average, matching the Programme Structure doc's rule that Pass/Fail courses don't count toward GPA/CGPA. Only C, B, and A- are directly verified against a real transcript; the rest follow that same confirmed step pattern.

**RLS:** `auth.uid() = user_id`, same pattern as `bid_plan_entries`.

## `faculty`, `course_faculty`, `faculty_ratings`

Professor profiles and ASA's faculty ratings, taken from two ISB SharePoint sources (login required): the Atrium Faculty list and ASA's FacultyRatings pages. They were loaded once from the 2026-27 Mohali lineup. Nothing in the app refreshes them.

`faculty` has one row per professor in the lineup (106 as of 2026-09-11): `name` (unique, spelled as in the lineup), `designation`, `faculty_type`, `academic_area`, `affiliation`, `profile_url` (the Atrium list item), `bio_url`, `photo_url`, `ratings_url` (the AY 2025-26 onwards page), `ratings_legacy_url` (the older page) and `sharepoint_id`. Five visiting faculty have no Atrium record yet, so only `name` and `affiliation` are set for them.

`course_faculty` says who teaches what. The primary key is `(course_id, faculty_id)`. `sessions` holds "Sessions 1-5" for split courses, and the sections a core-course instructor takes (e.g. "Sections G,K,L · Sessions 1-10"). `affiliation` is what the lineup lists for that course.

`faculty_ratings` has one row per past offering, from AY 2021-22 on. `scale` is 7 before AY 2025-26 and 5 after, so **never average across scales**. The 1-7 rows also carry `difficulty`, `workload`, `pace`, `feedback`, `enrollments` and `respondents`. The 1-5 rows only have course and instructor scores. `course_code` is parsed from the offering label and is null when the label doesn't name one. `sort_key` orders offerings newest first. `campus` is `Mohali`, `Hyderabad` or null. The 2025-26 pages give each campus its own column, so those rows carry it. Older pages almost never say, and null means "not stated", not a guess. `term_label` is `T4`, `BW2` and so on.

**Display rule: nothing is ever averaged.** The badge on a course shows one real offering, always labelled with campus and year: this course at Mohali first, then Hyderabad, then campus not stated, then the professor's other courses (labelled "other course"). Ratings with fewer than 5 responses are flagged "few" wherever they appear.

**RLS:** unlike `courses`, all three are readable only by signed-in users (`to authenticated`), because the ratings are ISB-internal. Admins can write. Checked on the live API: a logged-out request gets an empty list.

## `course_grading_profiles`

One row per course, extracted from that course's official outline PDF: how the grade splits
(`grade_participation_pct` / `grade_individual_pct` / `grade_group_pct` / `grade_exam_pct`), the exam
structure (`exam_midterm_count` / `exam_endterm_count` / `exam_quiz_count`), six 0-5 workload scores
(`load_quant`, `load_assignments`, `load_participation`, `load_exam_pressure`, `load_group`,
`load_reading`), and a `brief` jsonb of labelled bullets (About / Exams / Groups / Work / Notes).
The table is deliberately per-course, not per-term: Term 4 was seeded first, Term 5 in September 2026,
and any later term drops in the same way.

`20260912090000` added five more, read off the standard blocks every ISB outline carries -- the
"Group Information" table, the "Peer Evaluation Component" line, and "Attendance & Punctuality":

- `group_size` -- free text, because outlines phrase it every possible way ("4-6", "Up to 3",
  "Announced after bidding").
- `cross_section` -- can groups span sections?
- `group_formation` -- `Self-select`, `Instructor-assigned` or `ASA-assigned`, check-constrained so
  the dossier's filters stay stable as later terms are seeded.
- `peer_eval` -- is there a peer evaluation that moves individual grades?
- `attendance` -- `Not mandatory`, `ISB policy`, `Participation-linked` or `Stricter than ISB policy`,
  also check-constrained. Note `ISB policy` is not the lenient option: under it one missed session
  already costs a letter grade. The other three are course-specific departures from that default.

**All five are nullable and null means "the outline doesn't say", never a guess.** For Term 5 that's
real: `group_formation` is stated in only 6 of 17 outlines, `cross_section` in 12, and MSTC and NSDL
carry no Group Information table at all. The UI renders null as "Not stated in the outline" and the
filters exclude those rows rather than assuming a default.

Two more columns:

- `student_feedback` -- jsonb array of strings, default `[]` (added in `20260912090300`). Word of mouth
  from students who took the course, kept apart from `brief` because it can be wrong or contradict
  itself. Empty array means "no feedback yet". Seeded for 6 Term 5 electives from a Hyderabad-campus
  WhatsApp thread, names removed. Shown in the Term Dossier with a disclaimer.
- `source_url` -- the outline PDF the profile was extracted from, for traceability.

Consumers: the Term Dossier (`/dossier/:term`) and the Bidding Planner's "Your Term" step.
Admin-editable from the Courses tab's grading editor. Readable by everyone; admins write.

## Learn tables

All created in `20260813201640_learning_agent_schema.sql` when the separate learning app was merged in.
How they're used: [LEARN.md](LEARN.md#data).

**Content** -- readable by everyone (`using (true)`, no role restriction, so this includes signed-out
requests), writable by admins:

| Table | Key | What it holds |
|---|---|---|
| `learn_courses` | `course_code` (FK → `courses.code`) | `total_sessions`, `enabled` (release switch), `sort_order` |
| `learn_course_content` | `course_code` | `outline`, `announcements`, cheatsheet / sample exam / feedback URLs |
| `learn_session_content` | (`course_code`, `session`) | `title`, `summary`, `resource_url` (slides), `formula_sheet` |
| `learn_concepts` | (`course_code`, `topic`) | `title`, `note` (markdown), `resource_url` |
| `learn_questions` | `id` text | `type` (`formula` / `case_fact` / `short_answer`), `topic`, `session`, `prompt`, `choices` jsonb, `correct_answer`, `explanation`, `hint`, `scenario_id` + `scenario_order`, `difficulty` 1-3, `provenance` (`prof_verbatim` / `prof_adapted` / `authored`) |
| `learn_scenarios` | `id` text | `course_code`, `session`, `title`, `setup`, `source` |
| `learn_materials` | uuid | `course_code`, nullable `session`, `title`, `kind`, `storage_path`, `sort_order` |

**Per student** -- `to authenticated`, each user reads and writes only their own rows:

| Table | Key | What it holds |
|---|---|---|
| `learn_profiles` | `user_id` | `total_xp`, `day_streak`, `last_active_date`. Written from the browser, so XP and streak are not tamper-proof. |
| `learn_attempts` | uuid | `user_id`, `question_id`, `correct`, `created_at`. Insert and select only. |
| `learn_topic_mastery` | (`user_id`, `course_code`, `topic`) | `level` 0-4, run and attempt counters, `last_seen_at` |

**Storage:** private bucket `course-materials`, 50 MB per file, PDF and Office types only. Signed-in users
can read (the app issues 1-hour signed URLs); admins upload and delete.

## Database functions

| Function | Returns | Access |
|---|---|---|
| `pulse_check_results_by_term(p_term)` | Per course: respondent count and min / p25 / median / p75 / max, nulls below 5 respondents | `security definer`; signed-in users |
| `pulse_check_histogram_by_term(p_term)` | Per course: 5 buckets with start, end, count; only courses with 5+ submissions | `security definer`; signed-in users |
| `learn_admin_cohort_stats()` | total students, active today, active this week, answered, correct | `security definer`; raises an error unless the caller is admin |
| `learn_admin_topic_stats()` | `course_code, topic, total, accuracy` | Same |
| `learn_admin_flagged_questions()` | Questions with 3+ attempts and accuracy under 40% or over 95% | Same |

Every one has execute revoked from `public` and `anon`. Do the same for any new `security definer` function.

## Migration history (chronological, for context on *why*)

1. `academics_schema` — initial tables.
2. `academics_seed_placeholder` → later fully deleted — placeholder rows used during early UI testing, replaced by `real_course_data`.
3. `real_course_data` — 121 electives/Flexi Core, transcribed from ISB's Concentration & Industry Specialisation doc.
4. `profile_and_gating_updates` — multi-concentration support, gating course terms.
5. `drop_batm_course` — a Flexi Core option ("Business Analytics for Technology Management") was discontinued by ISB mid-build; removed.
6. `role_and_course_status` — `work_ex_role`, `is_active`.
7. `resources_notifications_structure` — first version of the resources/notifications schema.
8. `drop_resources_category` — removed a superseded free-text `category` column (tables were empty, safe to drop outright).
9. `core_courses` — the 11 mandatory courses, plus widening `credits` to numeric.
10. `resource_description` — the description field.
11. `flexi_conversion_and_exchange_points` — `term2/3_converted_elective` (which Flexi pick, if any, is the mandatory conversion to elective — corrected an earlier assumption that all completed Flexi Core counted toward credit) and `international/inter_campus_exchange_points_used` (self-reported, since Exchange bidding shares the same 4,500-point pool but isn't a modeled flow yet).
12. `cross_listed_concentration_choice` — `cross_listed_concentration_choices` jsonb, so a cross-listed course only counts toward the one concentration the student picked (FAQ Q45) instead of both.
13. `resource_pinning` — `pinned` / `pinned_global` on `resources`.
14. `nav_links` — new table for admin-managed extra sidebar links; seeded with the Custom GPT link that used to be hardcoded in `Sidebar.tsx`.
15. `pulse_check` — `pulse_check_submissions` table (one voluntary bid-point estimate per student per Block Week, immutable once submitted) plus `app_settings.pulse_check_cutoff` and the `pulse_check_results_by_term()` security-definer RPC that's the only sanctioned way to read the threshold-gated aggregate back.
16. `pulse_check_revoke_anon_execute` — follow-up fix, same day. Live testing found that Supabase's default privileges on this project auto-grant `EXECUTE` on new `public`-schema functions to `anon` (separately from the `PUBLIC` pseudo-role the prior migration revoked from), so the pulse-check RPC was callable by anyone holding the public anon key, not just logged-in students. No raw data was ever exposed by this (the function only ever returns the same threshold-gated aggregate a real student would see), but it's fixed here — worth remembering for any future `security definer` function in this schema: revoke from `anon` explicitly, not just `public`.
17. `pulse_check_allow_one_edit` — relaxes `pulse_check_submissions` from fully immutable to "editable exactly once," per Eshan's product call after using the feature. Adds the `edited` boolean and an update policy scoped so a second edit is denied at the RLS layer, the same way any edit was denied before this migration.
18. `pulse_check_range_stats` — replaces the single `median_points` return column with a 5-number summary (`min_points`, `p25_points`, `median_points`, `p75_points`, `max_points`), per feedback that a median hides the spread a student actually needs (second-price clearing depends on where the marginal bid sits, not the average). Same `>=5` threshold, drop-and-recreate since Postgres can't `CREATE OR REPLACE` a function's return columns.
19. `pulse_check_histogram` — adds `pulse_check_histogram_by_term()`, a real 5-bucket histogram per course via `width_bucket()`, replacing a range-meter-behind-a-dropdown UI with a card-per-course grid, each with its own small bar chart. Same `>=5` threshold and anon-execute revoke, both inline this time.
20. `split_seed_study_trek_sections` — the "SEED" course (Sustainable Empowerment through Emerging Digitization, Study Trek, Block Week 2) was seeded as one row with three faculty jammed into a single `professor` string. `resources` already independently held three separately-numbered outline PDFs for it (SEED1/2/3_BW2.pdf) — a clean signal these are three separately-bid faculty-course combinations (per ISB's own rule), not one co-taught course. Split into three course rows (SEED1/SEED2/SEED3), one per professor, each keeping its own outline PDF. **The professor-to-PDF-number mapping is an inferred assumption** (matched by stated order — Chhatre/Ramachandran/Dutta to SEED1/2/3), not verified against the PDFs themselves; worth a spot-check. Checked the rest of the catalog for the same pattern (`professor` containing `/`): the other Block Week 1 hits (`HCEN`, `PFCA`, `TISE`) each have exactly one, non-numbered outline PDF — genuinely co-taught single courses, correctly left as-is, not split.
21. `seed_study_trek_locations` — appends each SEED section's real trip location (Sikkim/Tamil Nadu/Madhya Pradesh, per Eshan directly) to `courses.name` so the three read as obviously distinct wherever the name is shown, not just via `professor`.
22. `actual_enrollments` — new table for the Credit Tracker (`CreditTracker.tsx`), separate from `bid_plan_entries` since a bid plan is intent and this is result. Purely additive (new table + RLS policy, no changes to existing tables) — see the `actual_enrollments` section above for the full shape.
23. `seed_term4_course_outlines` (two runs), `course_grading_profiles`, `seed_term4_grading_profiles` (2026-08-03) -- outline links for Term 4 and the per-course grading profiles behind "Your Term".
24. `bidding_closed_terms_and_popups` (2026-08-03) -- `app_settings.current_terms` and `closed_bidding_terms` (never wired up) and the first `dashboard_popups` table.
25. `pulse_check_live_term_gate` (2026-08-04) -- Pulse RLS gated on `live_bidding_terms` instead of the cutoff date, which had gone stale and blocked all submissions.
26. `term_credit_limits` (2026-08-04) -- admin-editable min/max credits per term in `app_settings`.
27. `pulse_check_per_course` and `pulse_check_edit_cap_and_delete` (2026-08-04) -- unique per course instead of per term; `edited` boolean becomes `edit_count` up to 3; submissions removable while live.
28. **Learn merge, 2026-08-13/14:** `learning_agent_schema` (10 `learn_*` tables, storage bucket, admin functions), `learning_agent_revoke_anon_execute`, `learning_agent_data` (the original app's rows), `learning_agent_fix_mojibake` (repaired garbled characters with a temporary function, then dropped it).
29. **Learn content, 2026-08-14 to 08-18:** BANM2 (`banm2_end_term_content`, `banm2_hold_until_deploy`, `banm2_enable`, `banm2_expansion`, `banm2_content_depth`, `banm2_session7_ordering`), OPMG (`opmg_lean_process_control_deepen`, `opmg_session10_*`, `opmg_eoq_katex_fix`, `opmg_additional_set`, `opmg_expansion`), MKTG (`mktg_expansion`, `mktg_slide_coverage`, `mktg_channel_choice_resolution`, `mktg_peer_quiz_import`, `mktg_peer_quiz_second_pass`, `mktg_numerical_practice_set`), MADM2 (`madm_end_term_content`, `madm_practice_bank`), and `topic_stats_per_course` (admin topic stats grouped by course).
30. `term5_catalog_correction` and `seed_term5_course_outline_resources` (2026-09-10) -- Term 5 electives and outlines corrected from ASA's official spreadsheet.
31. `remove_term4_navlinks_add_resources` (2026-09-10) -- Term 4 Dossier and Q&A moved from the sidebar into Course Resources' Platform Directory.
32. `dashboard_popups_generic` (2026-09-10) -- popups get page, frequency, icon and button actions; the hardcoded Learn promo becomes a row.
33. `seed_term5_grading_profiles` (2026-09-11) -- grading profiles for all 17 Term 5 electives.
34. `faculty_profiles_and_ratings` (2026-09-11) -- the three faculty tables and three new `courses` columns, and a catalogue refresh from ASA's 2026-27 Mohali lineup: named professors on 52 courses, term moves (BLAW to Term 7, CMGT and CTFI to Term 6), BPEX re-enabled in Term 6, DMKT tagged IT Management, three new courses (BBMK, REMA, VIVC), outline links for FRNT4, GEBU and SUET. ELP was left out because ASA lists no faculty, credits or concentration for it. Thirteen courses missing from the new lineup were left active on purpose.
35. `faculty_ratings_campus` (2026-09-11) -- `campus` and `term_label` on ratings, parsed from ASA's labels, plus course codes the first load missed.
36. `grading_profile_group_and_attendance` + `seed_term5_group_and_attendance` (2026-09-12) -- the five group, peer-evaluation and attendance columns, filled for Term 5.
37. `term5_dossier_resource_link` (2026-09-12) -- Term 5 Dossier added to the Platform Directory.
38. `term5_student_feedback_column` + `seed_term5_student_feedback` (2026-09-12) -- `student_feedback` on grading profiles, seeded for 6 Term 5 electives.

If you're debugging something that references an older shape (e.g. `resources.category`), check this list — it was real, then removed.
