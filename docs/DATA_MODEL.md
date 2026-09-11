# Data Model

All tables live in the Supabase project shared with `isb-explorer`. Every schema change is a numbered file in `supabase/migrations/` — that's the actual source of truth; this doc is a human-readable summary of it, current as of migration `20260803090000_actual_enrollments.sql`.

To apply migrations: `supabase db push` (requires the Supabase CLI linked to the project — `supabase link --project-ref <ref>`).

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
| `is_admin` | boolean | **The only access-control flag in the whole app.** Gates Admin panel, Course Resources, Notice Board. See [ADMIN_GUIDE.md](ADMIN_GUIDE.md#granting-admin-access) for how to set it. |

## `courses`

The full catalog: 132 rows as of writing — 121 electives/Flexi Core + 11 mandatory core courses.

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
| `cross_listed_concentration_choices` | jsonb, default `{}` | Course code → concentration area. Which single concentration a cross-listed course counts toward (FAQ Q45), student's choice — only meaningful when a course maps to 2+ of the student's `target_concentrations`. |

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
| `created_at` | timestamptz | |

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

A student's voluntary, one-time-per-Block-Week submission of which course they're seriously bidding on and an estimated bid-point amount — the Cohort Bidding Pulse Check. Deliberately isolated from `bid_plan_entries`, which is real personal planning data never shared with anyone else.

| Column | Type | Notes |
|---|---|---|
| `id` | uuid PK | |
| `user_id` | uuid, FK → `users.id` | |
| `course_id` | uuid, FK → `courses.id`, **not nullable**, `on delete cascade` | Unlike `bid_plan_entries`, a submission with no course doesn't mean anything, so there's no "keep the row, drop the reference" case to support. |
| `term` | text | Denormalized from the course's term at submit time, same pattern as `bid_plan_entries.term`. |
| `bid_points_estimate` | integer, `check (>= 100 and <= 4500)` | Mirrors the real bidding mechanics' min/max (`MIN_BID_PER_COURSE` / `TOTAL_BID_POINTS` in `hooks/useBidPlan.ts`). |
| `edited` | boolean, default `false` | Flips to `true` on the one allowed edit (see below); a submission is fully locked once this is `true`. |
| `created_at` | timestamptz | |

**Unique constraint on (`user_id`, `term`)** — one submission per student per Block Week, regardless of which course. This is intentionally not scoped to `course_id`: the feature's premise is "one voice per Block Week," and a per-course constraint would let a student submit two different courses for the same Block Week, double-counting their vote across two courses' aggregates.

**RLS is the whole safety design here**, not an afterthought:
- **Own-row select only.** No admin-read policy, no other-student-read policy. Raw per-student estimates are never meant to be visible to anyone but the submitter.
- **Insert, then exactly one edit, both time-bound.** Originally fully immutable (insert-only, no update policy at all); relaxed once, deliberately, to allow one edit — see below. Both the insert and update policies require `now() < app_settings.pulse_check_cutoff`.
- **The one-edit cap is enforced by Postgres, not the UI.** The update policy's `using` clause only matches rows where `edited = false`; its `with check` clause requires the updated row to have `edited = true`. A second edit attempt finds no existing row matching `using` (since `edited` is already `true`) and is denied the same way a delete always has been — there's no client-side bypass.
- **The only way to read the aggregate** is `pulse_check_results_by_term(p_term)`, a `security definer` function that returns `(course_id, respondent_count, min_points, p25_points, median_points, p75_points, max_points)` per course — a 5-number summary, not just a median, since in a second-price auction the shape of the distribution (especially the lower end) matters more than its center. All five stat columns stay `null` until `respondent_count >= 5`. A direct select policy broad enough for students to compute this aggregate client-side would also let them read every other student's exact bid-point number — worse than not building this feature at all.
- **A second function, `pulse_check_histogram_by_term(p_term)`**, returns a real per-course histogram: 5 adaptive-width buckets via Postgres's `width_bucket()`, `(course_id, bucket_index, bucket_start, bucket_end, bucket_count)` per row, same `security definer` + `>=5` threshold pattern. This is a coarser aggregate than the 5-number summary above (a bucket count only says "N people fell in this range"), not a new privacy exposure. The UI (`PulseCheck.tsx`) renders this as a small bar chart per course rather than a smoothed curve — a smoothed density plot would oversell how much data 5-20 respondents actually is.

**Why this exists despite an earlier, similar idea being cut:** see ROADMAP.md — a "bidding-risk/points recommendation layer" was cut earlier for the same self-report bias reasoning that applies here. This feature was built anyway, as a deliberate, informed decision to accept that risk in exchange for a richer signal than a plain interest toggle. The immutability and threshold-gating above are the guardrails that decision was conditioned on, not incidental details.

## `app_settings.pulse_check_cutoff`

Added alongside the table above (see `supabase/migrations/20260730090000_pulse_check.sql`). A `timestamptz`, admin-editable only via direct SQL for now (no Admin UI yet — see ROADMAP), defaulting to this cycle's real Phase 1 close (`2026-07-20 08:00:00+05:30`). Both the RLS insert policy and the frontend (`PulseCheck.tsx`) check against this same value, so update it here each cycle rather than hardcoding a new date in a future migration.

## `nav_links`

Admin-managed extra links, rendered in the sidebar below the locked core pages (Bidding Planner / Course Resources / Notice Board — those stay hardcoded in `Sidebar.tsx`, not in this table).

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

Later migrations aren't all listed here yet. One that changes the course model:

- `20260911124637_faculty_profiles_and_ratings` adds the three faculty tables above and three `courses` columns, and refreshes the catalog from ASA's 2026-27 Mohali lineup. That covers named professors on 52 courses, term moves (BLAW to Term 7, CMGT and CTFI to Term 6), BPEX re-enabled in Term 6, DMKT tagged IT Management, three new courses (BBMK, REMA, VIVC), and outline links for FRNT4, GEBU and SUET. ELP was left out because ASA lists no faculty, credits or concentration for it. Thirteen courses missing from the new lineup were left active on purpose (Eshan's call).
- `faculty_ratings_campus` adds `campus` and `term_label` to `faculty_ratings`, both parsed from ASA's offering labels. It also fills course codes the first load missed: labels ending in a bare code ("Term 4 2024-25 ENVC"), plus labels naming a course by title when exactly one course matches.

If you're debugging something that references an older shape (e.g. `resources.category`), check this list — it was real, then removed.
