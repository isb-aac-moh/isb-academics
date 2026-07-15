# Data Model

All tables live in the Supabase project shared with `isb-explorer`. Every schema change is a numbered file in `supabase/migrations/` — that's the actual source of truth; this doc is a human-readable summary of it, current as of migration `20260719090000_resource_description.sql`.

To apply migrations: `supabase db push` (requires the Supabase CLI linked to the project — `supabase link --project-ref <ref>`).

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
| `professor` | text | Many electives still show `"TBD"` — ISB hadn't assigned faculty yet at data-entry time. Not a bug. |
| `term` | text | One of `Term 1`–`Term 7`, `Block Week 1`–`Block Week 4`. Not a Postgres enum — validated only in the TypeScript `TermCode` type. |
| `credits` | **numeric**, not integer | Widened from `integer` because two core courses have fractional credits: Written Analysis and Communication (0.6) and Mastering Verbal Communication (0.4). If you ever see credits behaving oddly, check whether something upstream coerced this back to an int. |
| `concentration_areas` | text[] | Zero or more of the 6 ISB concentrations. A cross-listed elective can belong to more than one. **Empty for all core courses** — that's what keeps core courses invisible to Bidding Planner's area-matching logic; no special "exclude core" filter was needed. |
| `industry_specializations` | text[] | Zero or more of the 4 ISB industry specializations. Same cross-listing behavior. |
| `is_strategy_ob_course` | boolean | For the Strategy & Leadership concentration's 2+2+2 split rule (2 STLD + 2 OB + 2 either). **Defined in schema but not yet consumed anywhere in the app logic** — flagged in [ROADMAP.md](ROADMAP.md). |
| `prerequisite_course_ids` | uuid[] | **Present in schema, essentially unused in data.** A pass through Block Week 1 & 2 course outlines found real prerequisites on almost none of them — mostly "None" or informal text like "an open mind." Not populated because there was nothing real to populate. |
| `is_active` | boolean, default `true` | Soft-disable flag. `false` = dropped/hidden from students, but the row and all its history stays. Toggled from Admin, never hard-deleted. |
| `is_core` | boolean, default `false` | Mandatory course vs. elective/Flexi Core. Exposed in the Admin form, not just a DB-only flag. |

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
| `actual_points` | integer, nullable | Field exists for a future "log what actually happened" feature; **not currently written anywhere in the app**. |

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

If you're debugging something that references an older shape (e.g. `resources.category`), check this list — it was real, then removed.
