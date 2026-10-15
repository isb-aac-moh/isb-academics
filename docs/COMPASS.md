# Compass v1: product requirements, architecture and roadmap

> **Partly superseded, 15 Oct 2026.** The stakeholder PRD v2 (https://claude.ai/artifact/2DVUcVLqxoatKC4h2SHTKc) is now the product source of truth. Where this engineering draft differs, PRD v2 wins: hosting in an ISB-owned Azure tenant (India region) instead of the shared Supabase project and Cloudflare R2; hosted files through a secure per-user-marked viewer instead of pointer-only; an own-AI connector (read-only, Tier 1 content); no learner model, plan, drills or story bank; the map and role kits as the main views. Rewrite this file as technical spec v2 after PRD sign-off.

Status: approved for build. Spec written 30 Sep 2026, re-baselined 15 Oct 2026 (nothing was built in between; see section 14). Supersedes `docs/AAC_Compass_Blueprint.md` (kept in the main checkout as an idea bank; nothing in it is binding unless repeated here).

Owner: Eshan (product decisions, reviews, sign-off). Builder: Claude Code sessions. Testers: a handful of people Eshan recruits himself (names not needed).

Reading order for a new chat: `docs/COMPASS_HANDOFF.md` first (state, next steps, a paste-ready starter prompt), then this file.

## Changelog

| Date | Change |
|---|---|
| 30 Sep 2026 | First full spec after a five-specialist debate (product, data, tech, visual design, UX). |
| 15 Oct 2026 | Approvals reported in place (D4). Moodle sync added as the preferred content source (section 7.0, D11). Roadmap re-baselined from a 27 Oct public launch (section 14). Added personas, non-functional requirements, open questions, rejected options and glossary (sections 17 to 21). Verified current state against production and `origin/main` (section 2). |

## Contents

1. Why (problem, jobs, why not a chatbot) · 2. Verified current state · 3. Scope · 4. Product requirements (FR-01 to FR-18) · 5. UX specification · 6. Data model · 7. Build pipeline (7.0 Moodle sync) · 8. RPCs · 9. Security and privacy · 10. Analytics · 11. Frontend files · 12. Testing · 13. Rollback · 14. Roadmap · 15. Transcript layer · 16. Runbook · 17. Personas and user stories · 18. Approvals and open questions · 19. Non-functional requirements · 20. Rejected options · 21. Glossary

## In one paragraph

Compass is a "where was this taught" index for ISB. A student types an idea ("newsvendor", "NPV", "Porter") and sees every course, session and slide range that covered it, with a link to open their own copy of the deck. There is no chatbot and no AI running while students use it. AI is used only at build time, in Claude Code sessions on Eshan's Mac, to tag slides and outlines with topics. Running cost on top of today's bill: $0 a month.

## 0. Decisions log

| # | Decision | Answer | Date |
|---|---|---|---|
| D1 | Where it lives | Own route family `/compass` in the main app shell, main app tokens (`src/lib/theme.ts`). Not inside Learn. | 30 Sep |
| D2 | Name | Sidebar: "Compass". Page header subtitle: "Where was this taught?". Phone top-bar icon label: "Search". | 30 Sep |
| D3 | Slide images | Never in v1. No page images or files of the decks are stored or served by us. | 30 Sep |
| D4 | Slide text shown to students | Pointer mode by default (course, session, slide range, slide heading). Short quoted lines (max 200 chars) controlled by one setting (`app_settings.compass_quotes_enabled`). Eshan reported all approvals in place on 15 Oct, so quotes may be switched on at launch. The setting ships defaulted off and stays as a kill switch; Eshan flips it after the tester check. Record where the approval lives in section 18 before flipping. | 15 Oct |
| D5 | Timeline | Original target (public Mon 12 Oct) was missed: the spec sat unreviewed and no build work started. Re-baselined: build starts Fri 16 Oct, tester week Sat 24 to Mon 26 Oct, public R0 Tue 27 Oct. Exact Term 4 end-term dates still to be confirmed by Eshan (section 18). | 15 Oct |
| D6 | Search logging | Query text (cut to 60 chars) logged to PostHog tied to the signed-in user, like other events. | 30 Sep |
| D7 | Map visual | Lists only. Course page is an ordered session list drawn with a CSS left rule. No graph library, no overlap matrix. | 30 Sep |
| D8 | Cross-course claims | A concept may appear live in two or more courses only after a human marks it `reviewed`. The loader enforces this. | 30 Sep |
| D9 | Search engine | Postgres full-text search + `pg_trgm` + an alias list. No embeddings, no pgvector in v1. Revisit if zero-result rate stays above 15% for 4 weeks. | 30 Sep |
| D10 | Faculty text in git | Never. Slide and outline text load straight from Eshan's machine into Supabase. Git holds only our own wording (concept names, aliases) and code. | 30 Sep |
| D11 | Content source | Moodle sync (read-only, Eshan's own token) is the preferred source if the four-point probe in section 7.0 passes. OneDrive folders stay as the fallback. Everything after the "get files" step is identical either way. | 15 Oct |
| D12 | Testers | Eshan recruits them himself; no names needed in the repo. | 15 Oct |
| D13 | Faculty and AAC approvals | Reported in place by Eshan on 15 Oct. Not independently verified by the builder; the written record is to be linked in section 18. | 15 Oct |

## 1. Why

### Problem

- 138 courses, roughly 1,300 sessions a year. Slides sit in LMS downloads and OneDrive folders, one file per session, per student.
- Nothing answers "where did we do X?" today. Course Resources search matches only course title, code, professor and resource title (`src/pages/CourseResources.tsx:5`, `:85`).
- The same idea is taught in several courses (NPV in FADM, FCRV, MGEC; capacity in OPMG and ASDM) and nobody connects them.

### Who and what jobs

| Job | When | What Compass gives |
|---|---|---|
| J1 "Where did we do X?" | Exam week | Course, session, slide range in under a second on a phone |
| J2 "What was session 6 about?" | During term | Session topics, readings and cases from the outline, plus the topics tagged in that session's slides |
| J3 "Where else does X show up?" | Revision, placements | The same concept across courses and terms |
| J4 "What does this elective cover?" | Before bidding | Session-by-session map from the outline (information only, product rule 1) |
| J5 "Refresh Term 1 before case interviews" | Nov to Jan | Browse by term and course, jump to the right deck |

The aha moment: type "newsvendor", see OPMG S9 slides 4 to 11 and every other place it appears, with "Practise this in Learn" when a Learn topic exists.

### Why not a chatbot

Answers can be checked (course, session, slide number), results appear while typing, it says "not in our material" instead of guessing, every page has a shareable URL, and each query costs nothing.

## 2. Verified current state (30 Sep 2026)

| Thing | State | Evidence |
|---|---|---|
| Routes | React Router 7, lazy pages via `lazyWithReload`, admin routes wrapped in `<RequireAdmin>` | `src/App.tsx:14-65` |
| Learn hides main bottom nav | `inLearn` check | `src/components/Layout.tsx:18`, `src/components/Sidebar.tsx:34` |
| Sidebar items | Hard-coded `NavItem`s, Learn is first | `src/components/Sidebar.tsx:45-49` |
| Phone header | Rendered in Sidebar, `md:hidden` block with Menu button | `src/components/Sidebar.tsx:125-137` |
| Phone bottom nav | 5 items, full | `src/components/BottomNav.tsx:6-10` |
| Resources URL params | `q`, `course`, and filters live in the URL | `src/pages/CourseResources.tsx:31,35` |
| Analytics | `posthog?.capture(...)` inline | `src/components/CourseDetailModal.tsx:88` |
| Demo mode | In-memory client with seed tables and RPC handlers; every new table and RPC needs demo data or the homepage demo breaks | `src/lib/supabase.ts:17`, `src/lib/demoClient.ts:234`, `src/lib/demoSeed.ts:48` |
| Settings row | Single row `app_settings` (`id = true`), read by `useAppSettings` | `src/hooks/useAppSettings.ts:13` |
| Admin check in SQL | `exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin)` | existing migrations |
| Supabase | Free plan, 24 MB used, no branches; pgvector, pg_trgm available not installed; local dev points at PRODUCTION | Tech review, `docs/ARCHITECTURE.md` |
| Courses | 138 rows. With "Course Outline" links: T1 6/7, T2 6/7, T3 7/9, T4 17/17, T5 17/17, BW1 8/8, BW2 12/12, BW3/4 and T6/7 none yet | live DB query 30 Sep |
| Learn concepts | 99 (MADM2 30, BANM2 27, MKTG 23, OPMG 19); `learn_questions` pairs topic with session | live DB |
| Learn tables readable while logged out | Fixed. Migration `20260930150530_learn_content_authenticated_read.sql` is applied in production; all 10 `learn_*` SELECT policies are `authenticated` | live DB check 15 Oct, PR merged as 1ab4e41 |
| Compass objects in production | None yet: 0 `compass_*` tables; no extensions installed (`pg_trgm`, `vector`, `unaccent` available) | live DB check 15 Oct |
| Repo state | `origin/main` at f002209 (15 Oct). Every file cited in this spec is unchanged on main since 30 Sep except `docs/ROADMAP.md`; line references still valid | `git diff HEAD origin/main` 15 Oct |
| Local tools | Python 3 + PyMuPDF 1.27, Docker, Supabase CLI 2.109 | checked 30 Sep |

Source material (Eshan's OneDrive, Mohali, mostly Section G), text-layer status from the Data review:

| Course | Slides held | Text layer | R0? |
|---|---|---|---|
| OPMG | S1 to S10 | good | yes |
| MKTG | S1 to S9 (two profs) | good | yes |
| BANM | S1 to S5, S7 to S10 | good (check S1 notes watermark) | yes |
| MADM | S6 to S10 handouts | good | yes |
| SWPM | S1 to S6 (clean markdown exists) | good | yes |
| LSAT, SMDM, FADM, STRG, FCRV, FRNT, ASDM | most sessions | assumed good, check per deck | R1 |
| MGEC | S1 to S10 | S3 has none; S1, S2, S4, S5 likely none | R2 (vision) |
| WACM, MVCM, BSNS, SUET, ENTR, MKTR | no decks | n/a | outline only |

## 3. Scope

### In v1 (R0 + R1)

1. Canonical concept list with aliases, seeded from the 99 Learn concepts.
2. Session maps from outlines (title, topics line, readings, cases).
3. Slide pointers: concept to course, session, slide range, slide heading.
4. One search box: concepts, sessions, slide pages. Typo and alias tolerant.
5. Pages: Compass home, search results, topic page, course page, session page, evidence panel, report sheet.
6. Coverage labels everywhere ("Outline only", "Slides: S1 to S5, S7 to S10, Section G").
7. "Report a problem" on every citation.
8. Entry points: sidebar item, phone top-bar search icon, Course Resources search row (R0); Learn "Also taught in" chips and Dossier "Topics covered" block (R1).
9. PostHog events.
10. Admin-only until `app_settings.compass_public = true`.

### Out of scope (do not build)

- Any runtime LLM, chatbot, generated explanations, cheat sheets, definitions written by AI shown on screen.
- Slide images, thumbnails, hosted PDFs, "open at page N" deep links.
- Demand side (roles, companies, interview questions), learner model (diagnostic, plans, mastery colours).
- Graph drawings, force layouts, overlap matrix, sankey.
- "Recommended", "Suggested for you", "Your course" badges, anything ranking electives (rule 1).
- Reviewer roles, faculty views, an admin review UI. Reviews happen in a Claude Code session editing `concepts.json`.
- Embeddings / pgvector (D9).

## 4. Product requirements and acceptance

| ID | Requirement | Acceptance check (pass/fail) |
|---|---|---|
| FR-01 | Concept list | Every Learn concept maps to exactly one Compass concept (`learn_course_code`, `learn_topic` set). No alias is shared by two concepts (validator). |
| FR-02 | Session maps | For every course with an outline in the release, session count equals the count stated in the outline. Spot check 10 courses by hand: titles match. |
| FR-03 | Slide pointers | 50 random `covers` rows checked by hand: at least 45 correct (90%). Recovery test: at least 80% of (topic, session) pairs from `learn_questions` for OPMG, MKTG, BANM2, MADM2 found by the pipeline. |
| FR-04 | Search | 60-query eval set (`scripts/compass/data/search_eval.csv`): expected result in top 3 for at least 51 queries (85%). `compass_search` under 100 ms server time on production (`explain analyze`). Type-ahead results render within 150 ms of a keystroke on a mid-range phone. |
| FR-05 | Topic page | At 375 px width, first screen shows title, one alias line, "Taught in N courses, M sessions", and the first citation, without scrolling. Every citation has course, session, slide range, section. |
| FR-06 | Course and session pages | Sessions in order; sessions with no slides still listed with "Outline only". Session page lists readings, cases, tagged concepts, slide groups. |
| FR-07 | Pointer vs quote mode | With `compass_quotes_enabled = false`, no RPC response contains `quote` or `snippet` values for non-admins (check in network tab). Flipping it to true shows quotes with no deploy. |
| FR-08 | Coverage honesty | Every course header shows a coverage line. Zero-result search shows: "Not in the slides or outlines we have (X of Y courses have slides)" and a link to `/compass/coverage`. |
| FR-09 | Report a problem | 2 taps from any citation. Row lands in `compass_reports`. Admin sees it in the Supabase table (no UI in v1). |
| FR-10 | Access | Logged-out request to any `compass_*` RPC returns an error. Non-admin gets nothing while `compass_public = false`. Non-admin never sees rows with `live = false`. Direct `select` on `compass_*` content tables returns 0 rows for non-admins. |
| FR-11 | Leak safety | Scan of every loaded text field for the leak patterns (section 7.4) returns 0 matches. Loader refuses to run otherwise. |
| FR-12 | Cross-course rule (D8) | `load.py --publish` exits non-zero if any concept with live covers in 2 or more courses has `status != 'reviewed'`. |
| FR-13 | Demo mode | `/compass` renders and searches on the homepage demo with fixture data; no network calls to Supabase. |
| FR-14 | Entry points | Topic page reachable from: sidebar, phone top bar, Resources search (R0); Learn concept note, Dossier course detail (R1). |
| FR-15 | Analytics | All events in section 10 appear in PostHog within 5 minutes of a test session. |
| FR-16 | Performance budget | Compass route chunk under 60 KB gzipped. No new npm dependency. |
| FR-17 | Moodle probe | `moodle_sync.py --probe` prints pass/fail for the four checks in section 7.0 and exits non-zero on any fail. Result recorded in section 18 before any bulk download. |
| FR-18 | Moodle token handling | Token appears only in `scripts/compass/.env` (gitignored). A test run with a fake token proves it is redacted from logs, error messages and printed URLs. Script calls only functions on the read-only allowlist. |

## 5. UX specification

### 5.1 Routes (all state in the URL)

| Route | Screen |
|---|---|
| `/compass` | Home: search box, "Browse by term" (Term 1 to 4, collapsible `<details>`, each "Term 2 · 7 courses · 3 with slides"), recently viewed (browser `localStorage`, try/catch) |
| `/compass?q=npv&type=concept` | Results. `type` = `all` (default), `concept`, `session`, `slide` |
| `/compass/topic/:conceptId` | Topic page |
| `/compass/course/:code` | Course page |
| `/compass/course/:code/:sessionNo` | Session page |
| `?cite=<passageId>` on any of the above | Evidence panel open (bottom sheet on phone, right panel at `md` and up) |
| `/compass/coverage` | What is indexed: table of courses with outline yes/no, slide sessions, section |

`/compass/*` is added inside the main `<Layout>` in `src/App.tsx`, lazy-loaded, wrapped by `<RequireCompass>` (admin, or anyone when `compass_public`).

### 5.2 Entry points

- Sidebar: `NavItem` "Compass" with lucide `Compass` icon, directly under Learn (`src/components/Sidebar.tsx:45`). Hidden for non-admins until `compass_public`.
- Phone header: search icon button next to Menu (`src/components/Sidebar.tsx:125-137`), `aria-label="Search"`, goes to `/compass`, and focuses the input.
- Course Resources: when `q` is non-empty and Compass is visible to the user, show one row above the course grid: "Topics matching 'npv' in Compass (3)" linking to `/compass?q=npv`. Uses the client topic index; no extra request if the index is cached.
- R1: Learn concept note gets "Also taught in: FCRV S4, MGEC S7" chips (reviewed concepts only). Dossier course detail gets "Topics covered, session by session" linking to `/compass/course/:code`.

### 5.3 Search behaviour

1. On first open, fetch `compass_topic_index()` once (about 1,000 rows, cache in memory for the session).
2. Normalise the query: lowercase, trim, strip leading "what is", "what are", "define", "explain", "how to calculate", "meaning of", strip punctuation.
3. Client type-ahead on every keystroke: exact alias or name match first, then prefix, then substring. Show up to 8 concepts instantly.
4. After 250 ms without typing (or Enter), call `compass_search(q)` for sessions and slide pages and for typo matches (trigram). Merge; do not duplicate concepts.
5. Results layout: one "Top match" card (best concept: name, "Taught in N courses", first citation), then groups Concepts / Sessions / Slides / Courses with counts. Tapping a group header sets `type=`.
6. Zero results: "Did you mean X?" from the nearest trigram concept if similarity at least 0.3, then the honest coverage line (FR-08).
7. A name that maps to several concepts (e.g. "porter") shows all of them as the Concepts group; no auto-redirect.

### 5.4 Topic page, top to bottom

1. Title, aliases on one line (truncate with "+2 more"), kind chip ("Framework").
2. "Taught in 3 courses, 5 sessions". If the concept is not reviewed and spans only one course: nothing extra. (Unreviewed multi-course concepts never go live, D8.)
3. "Where it was taught": grouped Term, then Course (header shows course name, section, professor, coverage), then session rows: "S9 · slides 4 to 11 · The newsvendor model". Role shown as text: "Taught", "Applied", "Mentioned". Tapping a row opens the evidence panel.
4. "Practise this in Learn" button when `learn_course_code` is set, linking to `/learn/practice?course=<code>&topic=<topic>` (verify Learn route shape during build; if absent, link to the Learn course).
5. "Taught in the same session" and "Taught earlier" chip lists (derived, section 6). Never the word "prerequisite".
6. Footer: "Slide matches are automatic. Report a wrong one." with the report button.

### 5.5 Evidence panel (`?cite=`)

Shows: course, session, section, professor, slide range, slide heading, role. If quotes are enabled: up to two quoted lines (max 200 chars total) in quote style with "From the slide". Table-only slides say "Table on slide 14" instead. Buttons: "Open your deck" (`open_url`, else `/resources?course=<code>`), "Report a problem". No image, ever.

### 5.6 Course page

Header: name, code, term, professor(s), coverage line ("Slides: S1 to S5, S7 to S10 · Section G deck · Prof X" or "Outline only"). Body: ordered session list, each row: "S3 · Title from outline", topics line (from outline), 3 to 6 concept chips (top by role then confidence), "also in MGEC S2" chip for reviewed concepts that appear elsewhere. Left border line in the course's area colour with the area code printed as text (colour never the only signal, product rule 7).

### 5.7 Copy (exact strings)

| Where | Text |
|---|---|
| Home header | "Compass" / subtitle "Where was this taught?" |
| Search placeholder | "Search any topic, like NPV or newsvendor" |
| Outline-only course | "Outline only. We don't have slides for this course yet." |
| Pointer mode note (panel) | "Open your own copy of the deck to see this slide." |
| Zero result | "Not in the slides or outlines we have ({x} of {y} courses have slides)." |
| Report sheet title | "What's wrong?" options: "Wrong topic", "Wrong session", "Something's missing", "Other" + optional note (500 chars) |
| Report thanks | "Thanks. AAC will check this." |
| Not public yet (non-admin hitting URL) | "Compass isn't open yet." + link home |

## 6. Data model

One additive migration: `supabase/migrations/<timestamp>_compass_v1.sql`. Nothing existing is altered except two new columns on `app_settings`.

```sql
create extension if not exists pg_trgm with schema extensions;

create or replace function public.compass_join(text[]) returns text
language sql immutable parallel safe as $$ select array_to_string($1, ' ') $$;

create or replace function public.compass_is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin)
$$;

alter table public.app_settings
  add column if not exists compass_public boolean not null default false,
  add column if not exists compass_quotes_enabled boolean not null default false;

-- One ingested file (a deck or an outline)
create table public.compass_sources (
  id text primary key,                 -- 'OPMG-G-slides-S02-1' / 'OPMG-outline'
  course_id uuid not null references public.courses(id),
  course_code text not null,
  cohort text not null default '2026-27',
  section text,                        -- 'G'; null for outlines
  kind text not null check (kind in ('outline','slides','transcript')),
  session_no int,                      -- null for outlines and multi-session decks
  professor text,
  title text not null,
  page_count int not null check (page_count > 0),
  text_hash text not null,             -- sha256 of cleaned text; change detection only
  open_url text,
  release_id text not null,
  live boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.compass_sessions (
  id text primary key,                 -- 'OPMG-2026-27-S02'
  course_id uuid not null references public.courses(id),
  course_code text not null,
  cohort text not null default '2026-27',
  session_no int not null check (session_no between 1 and 40),
  title text,
  topics text,                         -- outline session line, verbatim
  readings text[] not null default '{}',
  cases text[] not null default '{}',
  outline_source_id text references public.compass_sources(id) on delete set null,
  release_id text not null,
  live boolean not null default false,
  fts tsvector generated always as (
    to_tsvector('english', coalesce(title,'') || ' ' || coalesce(topics,'') || ' ' ||
      public.compass_join(readings) || ' ' || public.compass_join(cases))) stored,
  unique (course_code, cohort, session_no)
);

-- A run of slides on one topic (or one outline session block)
create table public.compass_passages (
  id text primary key,                 -- '<source_id>-p03'
  source_id text not null references public.compass_sources(id) on delete cascade,
  session_id text references public.compass_sessions(id) on delete set null,
  seq int not null,
  slide_from int, slide_to int,
  heading text not null,
  quote text check (char_length(quote) <= 200),
  is_table boolean not null default false,
  release_id text not null,
  live boolean not null default false,
  unique (source_id, seq),
  check (slide_from is null or slide_to >= slide_from)
);

create table public.compass_pages (
  id text primary key,                 -- '<source_id>-007'
  source_id text not null references public.compass_sources(id) on delete cascade,
  passage_id text references public.compass_passages(id) on delete cascade,
  page_no int not null,
  heading text,
  body text not null,
  release_id text not null,
  live boolean not null default false,
  fts tsvector generated always as (
    setweight(to_tsvector('english', coalesce(heading,'')), 'A') ||
    setweight(to_tsvector('english', body), 'C')) stored,
  unique (source_id, page_no)
);

create table public.compass_concepts (
  id text primary key check (id ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  name text not null,
  aliases text[] not null default '{}',
  kind text not null check (kind in ('idea','framework','formula','method','case')),
  area text,
  status text not null default 'machine' check (status in ('machine','reviewed')),
  learn_course_code text,
  learn_topic text,
  release_id text not null,
  live boolean not null default false,
  check ((learn_course_code is null) = (learn_topic is null)),
  foreign key (learn_course_code, learn_topic) references public.learn_concepts(course_code, topic)
);

create table public.compass_covers (
  passage_id text not null references public.compass_passages(id) on delete cascade,
  concept_id text not null references public.compass_concepts(id) on delete cascade,
  role text not null check (role in ('teaches','applies','mentions')),
  confidence real not null check (confidence between 0 and 1),
  release_id text not null,
  live boolean not null default false,
  primary key (passage_id, concept_id)
);

create table public.compass_reports (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references public.users(id) on delete cascade,
  target_type text not null check (target_type in ('cover','concept','session','search')),
  target_id text not null,
  reason text not null check (reason in ('wrong_topic','wrong_session','missing','other')),
  note text check (char_length(note) <= 500),
  status text not null default 'open' check (status in ('open','fixed','dismissed')),
  created_at timestamptz not null default now()
);

create index on public.compass_sessions using gin (fts);
create index on public.compass_pages using gin (fts);
create index on public.compass_pages (passage_id);
create index on public.compass_passages (session_id);
create index on public.compass_covers (concept_id);
create index on public.compass_concepts using gin (name extensions.gin_trgm_ops);
create index on public.compass_concepts using gin (public.compass_join(aliases) extensions.gin_trgm_ops);

-- RLS: content tables are admin-only for direct access; students read through RPCs.
alter table public.compass_sources  enable row level security;
alter table public.compass_sessions enable row level security;
alter table public.compass_passages enable row level security;
alter table public.compass_pages    enable row level security;
alter table public.compass_concepts enable row level security;
alter table public.compass_covers   enable row level security;
alter table public.compass_reports  enable row level security;

create policy compass_sources_admin  on public.compass_sources  for all to authenticated using (public.compass_is_admin()) with check (public.compass_is_admin());
-- same admin policy for compass_sessions, compass_passages, compass_pages, compass_concepts, compass_covers

create policy compass_reports_insert on public.compass_reports for insert to authenticated with check (user_id = auth.uid());
create policy compass_reports_read   on public.compass_reports for select to authenticated using (user_id = auth.uid() or public.compass_is_admin());
create policy compass_reports_admin  on public.compass_reports for update to authenticated using (public.compass_is_admin());
```

Why content goes through RPCs only: pointer mode (D4) must be enforced on the server. If students could `select` from `compass_pages`, the full slide text would reach the browser whatever the setting says.

### Derived relations (no tables)

- "Also taught in": other courses with live covers for the same concept (reviewed concepts only).
- "Taught in the same session": concepts covered by passages in the same `session_id`.
- "Taught earlier": concepts covered in an earlier term, or an earlier session of the same course, that co-occur with this concept in at least one passage. Plain fact from timetable order, never labelled as a prerequisite.

## 7. Build pipeline (runs on Eshan's Mac)

### 7.0 Getting the files: Moodle sync (preferred) or OneDrive (fallback)

Eshan offered Moodle API access on 15 Oct. It is worth trying because it fixes four problems the OneDrive route has: files are cloud-only in OneDrive (about 2 GB of PDFs to pull down), session numbers are guessed from folder names, there is no stable link students can open, and change detection relies on hashing text.

**What a Moodle token gives** (standard Moodle web service functions; confirm each exists on ISB's site):

| Function | Use |
|---|---|
| `core_webservice_get_site_info` | Who the token belongs to and which functions the site allows. The first thing the probe calls. |
| `core_enrol_get_users_courses` | Eshan's enrolled courses, with Moodle course id and short name. Map to `public.courses.code` through `data/moodle_map.csv`. |
| `core_course_get_contents` | Per course: sections (usually one per session or week), modules (files, folders, links, pages) and, for each file, name, size, `timemodified` and `fileurl`. |
| `mod_url_get_urls_by_courses`, `mod_page_get_pages_by_courses`, `mod_folder_get_folders_by_courses` | Links (for example recordings), reading pages, folders. Recordings come back as links only, never as files or captions. |
| File download | `fileurl` with the token appended, saved under `$COMPASS_BUILD_DIR/raw/` on Eshan's Mac. Never served to students. |

**How it plugs into the pipeline.** `moodle_sync.py` replaces step 1 (the OneDrive walk). It writes the same `manifest.csv` plus the raw files, with three extra columns: `moodle_course_id`, `moodle_cmid`, `timemodified`. Steps 2 to 10 do not change. Three gains:

1. `open_url` becomes `<LMS>/mod/resource/view.php?id=<cmid>`, a stable link that opens for any student enrolled in that course. "Open your deck" then lands on the real file instead of a folder.
2. Session numbers come from the Moodle section order and names, checked against the outline's session count (FR-02). Any mismatch goes in `data/moodle_map.csv` by hand.
3. Re-runs download only files whose `timemodified` or size changed.

**The four-point probe (Eshan about 30 minutes, then one command).** Do this before any bulk download:

| # | Check | Pass | If it fails |
|---|---|---|---|
| 1 | Token works: `core_webservice_get_site_info` returns Eshan's name and a function list that includes the ones above | Yes | ISB's site has student web service access switched off, or ISB's Microsoft sign-in blocks the password route. Try the mobile-app sign-in route below. If still blocked, stop and use OneDrive. Ask ISB IT for a read-only service account limited to the PGP 2026-27 courses; that is also the better long-term answer. |
| 2 | `core_course_get_contents` lists files with `timemodified` for OPMG and SWPM | Yes | Files may be behind plugin pages. Fall back to OneDrive for that course. |
| 3 | One downloaded deck (OPMG S2) goes through `extract.py` and the watermark filter and the leak scan comes out clean | Clean | OneDrive copies carried a name stamp added by the LMS at download (`filewithwatermark...` file names). If the API download carries a stamp the filter cannot remove, use OneDrive for that course. If the API file has no stamp at all, say so in section 18: that is a clean source. |
| 4 | Course and section coverage matches Eshan's enrolments (Section G) | Yes | Anything missing is simply not Eshan's course; ask AAC for other sections' decks in R1. |

**Getting a token when the site uses Microsoft sign-in.** The plain username and password route usually fails on single-sign-on sites. Two routes to try, in this order: (a) in the LMS, Preferences, then User account, then Security keys, where many sites list a "Moodle mobile web service" key that is the token; (b) the Moodle mobile app's sign-in launch page (`/admin/tool/mobile/launch.php`), which completes the Microsoft sign-in in a browser and hands back a token. The builder will write the small helper for (b) if (a) is not available. Eshan does the sign-in step himself.

**Token rules (hard).** The token reads everything Eshan can read in the LMS, so treat it like a password.

- It lives only in `scripts/compass/.env` (gitignored) as `MOODLE_BASE_URL` and `MOODLE_TOKEN`. Eshan creates that file himself. It is never pasted into chat, a commit, a ticket or a message, and Claude sessions never print it.
- `moodle_sync.py` has an allowlist of read-only function names; a write function raises an error. It redacts the token from logs, errors and any printed URL, and sleeps at least 1 second between requests. Run at most once a day.
- Eshan runs the sync command himself (one line, given in `COMPASS_HANDOFF.md`); the builder works from the downloaded files and never needs the token value.
- Rotate the token after the R0 load: reset the Security key in the LMS.
- Confirm with ISB that the approvals cover pulling course files by API for this project, not only using the content (section 18, A3). Eshan reported approvals in place; this one line is the check that they reach this far.

**Not changing.** No file, image or page from the LMS is ever stored in Supabase or shown to students (D3). Only cleaned text for search and pointers load, as before (D10).

### 7.1 Files

```
scripts/compass/
  moodle_sync.py     # --probe first; then read-only pull of enrolled courses -> $COMPASS_BUILD_DIR/raw/ + manifest.csv (section 7.0)
  manifest.py        # fallback: walk OneDrive + outline texts -> $COMPASS_BUILD_DIR/manifest.csv
  extract.py         # PDF/markdown -> cleaned pages JSON per source (PyMuPDF)
  segment.py         # pages -> passages (title changes, agenda and divider slides)
  compass_lib.py     # shared: ids, watermark filter, leak scan, validators, --selftest
  load.py            # upsert to Supabase; --target local|prod --release r0 [--publish|--unpublish] [--course X]
  eval.py            # recovery vs learn_questions, spot-check sampler, search eval
  prompts/tag_course.md      # instructions for the Claude Code tagging session
  prompts/parse_outline.md   # instructions for turning outline text into sessions JSON
  data/concepts.json         # canonical concepts (our wording, in git)
  data/search_eval.csv       # 60 queries with expected concept or session id
  .env.example               # SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, COMPASS_LEAK_PATTERNS, MOODLE_BASE_URL, MOODLE_TOKEN (real .env is gitignored)
```

`$COMPASS_BUILD_DIR` defaults to `~/compass-build/` (outside the repo, never committed). All faculty text lives there and in Supabase only.

### 7.2 Steps

| # | Step | Input | Output | Who runs | Check |
|---|---|---|---|---|---|
| 1 | Manifest | Moodle sync (7.0) or, as fallback, OneDrive term folders; outline PDFs (local copies, or SharePoint via the Microsoft MCP path in memory note `isb-course-outline-pdfs`) | `manifest.csv`: path, course_code, kind, session_no, section, professor | `manifest.py` + Eshan eyeballs once | Every row's course_code exists in `courses` exactly once |
| 2 | Extract | manifest rows | `pages/<source_id>.json`: page_no, heading, body | `extract.py` | Leak scan clean; decks with under 20 words per page on average are flagged `needs_vision` and skipped until R2 |
| 3 | Parse outlines | outline text | `sessions/<course>.json` | Claude Code session using `prompts/parse_outline.md` | Session count equals outline's stated count |
| 4 | Segment | pages | `passages/<source_id>.json` | `segment.py` | Every page belongs to exactly one passage |
| 5 | Tag | one course's passages + sessions + current `concepts.json` | `tags/<course>.json` (passage_id, concept_id, role, confidence) + proposed new concepts | Claude Code session using `prompts/tag_course.md`, one course per session | Validator: ids exist, roles valid, confidence 0 to 1, 3 to 8 concepts per session on average |
| 6 | Canonicalise | proposed concepts | updated `concepts.json` | Claude Code session: exact name/alias match, then close-spelling shortlist, then judgement | No alias shared by two concepts |
| 7 | Review | concepts appearing in 2+ courses | `status: reviewed` or split | Eshan in a Claude Code session, about 30 to 60 min per batch | D8 check passes |
| 8 | Eval | tags + `learn_questions` | report | `eval.py` | FR-03 thresholds |
| 9 | Load | all of the above | rows with `live = false`, `release_id` | `load.py --target local`, then `--target prod` | Idempotent: second run changes 0 rows |
| 10 | Publish | release id | `live = true` | `load.py --publish --release r0` | D8 and leak checks re-run before flipping |

### 7.3 IDs (stable across re-runs)

- Source: `{COURSE}-{section or 'outline'}-{kind}-S{nn}-{k}`, e.g. `OPMG-G-slides-S02-1`, `OPMG-outline`. Never derived from the file hash (LMS downloads change bytes without changing content).
- Session: `{COURSE}-{cohort}-S{nn}`.
- Passage: `{source_id}-p{nn}`. Page: `{source_id}-{nnn}`.
- Concept: lowercase slug; renaming a concept keeps the id and adds the old name to aliases.

### 7.4 Watermark filter and leak scan

Filter (from the Data review, tested on OPMG S2, MKTG S4, MGEC S8): drop text lines whose direction is not horizontal; drop lines that, after removing stray single "I" characters and punctuation, contain the student name, the student email, or "PGP2027"; drop lines repeating on more than half the pages (footers, page numbers).

Leak scan patterns (case-insensitive), run on every text field before any write: the fixed set `pgp2027`, `[at]isb`, `@isb.edu`, `filewithwatermark`, plus the personal set from `COMPASS_LEAK_PATTERNS` in the gitignored `scripts/compass/.env` (the deck owner's first name, surname and student ID; never written in the repo). Any hit stops the run and prints the source id and page. `compass_lib.py --selftest` includes a fixture with a watermarked line that must be removed.

## 8. RPCs

All in `public`, `language sql` or `plpgsql`, `security definer`, `set search_path = public, extensions`, `stable` except `compass_report`. Every one starts with the gate:

```sql
if auth.uid() is null then raise exception 'not signed in'; end if;
if not public.compass_is_admin() and not (select compass_public from app_settings where id) then
  raise exception 'compass not public';
end if;
```

Visibility inside: `live or compass_is_admin()`. Quotes: `compass_quotes_enabled or compass_is_admin()`; otherwise return `null` for `quote` and `snippet`.

| RPC | Returns |
|---|---|
| `compass_topic_index()` | `setof (id text, name text, aliases text[], kind text, course_codes text[])` for live concepts |
| `compass_search(p_q text, p_course text default null, p_limit int default 30)` | `setof (kind text, id text, title text, course_code text, session_no int, page_no int, passage_id text, snippet text, rank real)`. Concepts by `similarity(name)` and alias similarity at least 0.3; sessions and pages by `websearch_to_tsquery('english', p_q)` with `ts_rank`; `snippet` = `ts_headline` on page body (null in pointer mode). Pages collapse to their passage (one row per passage). |
| `compass_topic(p_id text)` | `jsonb`: `{concept, where_taught:[{term, course_code, course_name, section, professor, coverage, sessions:[{session_no, session_title, passages:[{id, slide_from, slide_to, heading, role, quote}]}]}], same_session:[{id,name}], taught_earlier:[{id,name}], learn:{course_code, topic} }` |
| `compass_course(p_code text)` | `jsonb`: `{course, coverage:{outline bool, slide_sessions int[], section, professors text[]}, sessions:[{session_no, title, topics, readings, cases, concepts:[{id,name,role,also_in:[{course_code, session_no}]}]}]}` (`also_in` only for reviewed concepts) |
| `compass_session(p_code text, p_no int)` | `jsonb`: session row + passages with concepts |
| `compass_passage(p_id text)` | `jsonb` for the evidence panel |
| `compass_coverage()` | `setof (course_code, course_name, term, has_outline bool, slide_sessions int[], section text)` |
| `compass_report(p_target_type text, p_target_id text, p_reason text, p_note text)` | `bigint` id; volatile |

Each RPC gets a matching handler in `src/lib/demoSeed.ts` returning fixture data from a new `src/lib/demoCompassData.ts` (3 courses, 12 concepts, pointer mode).

## 9. Security and privacy

- Logged-in ISB users only, enforced in every RPC (FR-10).
- Service-role key only in `scripts/compass/.env` on Eshan's Mac. Never `VITE_`-prefixed, never in the repo.
- No slide text in git, migrations, PostHog events or logs.
- Per-course kill switch: `load.py --unpublish --course X` sets `live = false` for that course's rows. Use it the same day a faculty member objects.
- Search queries are logged with the user id (D6). Add Compass events to the "What we measure" list in `docs/PRODUCT.md` when R0 ships.

## 10. Analytics (PostHog, `posthog?.capture`)

| Event | Properties | When |
|---|---|---|
| `compass_search` | `q` (first 60 chars), `result_count`, `zero_result`, `entry` (`compass`, `resources`, `topbar`) | 800 ms after typing stops, or Enter. Not every keystroke. |
| `compass_result_opened` | `kind`, `id`, `rank` | Tap on a result |
| `compass_topic_viewed` | `concept_id`, `from` (`search`, `resources`, `learn`, `dossier`, `link`) | Topic page mount |
| `compass_citation_opened` | `course_code`, `session_no`, `passage_id` | Evidence panel opens |
| `compass_open_deck` | `course_code`, `session_no` | "Open your deck" tap |
| `compass_learn_handoff` | `concept_id` | "Practise this in Learn" tap |
| `compass_report_submitted` | `target_type`, `reason` | Report saved |

Targets for R0 (first 4 weeks): at least 100 weekly users in Term 4 end-term week; zero-result rate under 10% by week 2; at least 60% of searches lead to a result tap within 60 seconds; at least 20% of topic views open a citation from a second course (after R1).

## 11. Frontend files

| File | Change |
|---|---|
| `src/App.tsx` | Add `const CompassSection = lazyWithReload(() => import("./compass/CompassSection"))` and `<Route path="/compass/*" element={<RequireCompass user={user}><CompassSection /></RequireCompass>} />` inside the main `<Layout>` route |
| `src/compass/CompassSection.tsx` | Nested routes for section 5.1 |
| `src/compass/pages/{Home,Topic,Course,Session,Coverage}.tsx` | Screens (Results render inside Home when `q` is set) |
| `src/compass/components/{SearchBox,ResultGroups,CitationRow,EvidencePanel,ReportSheet,CoverageLine,ConceptChip}.tsx` | UI pieces; chip style copies `Tag` from `src/pages/TermDossier.tsx:315`; panel follows `src/components/CourseDetailModal.tsx` |
| `src/compass/lib/{api.ts,normalise.ts,topicIndex.ts}` | RPC wrappers, query normaliser, in-memory index and matcher |
| `src/compass/RequireCompass.tsx` | Admin or `compass_public`; otherwise "Compass isn't open yet." |
| `src/components/Sidebar.tsx:45` | Add Compass `NavItem` under Learn (visibility rule above); phone header search icon at `:125-137` |
| `src/pages/CourseResources.tsx` | "Topics matching" row when `q` is set |
| `src/hooks/useAppSettings.ts`, `src/types/index.ts` | Read `compass_public`, `compass_quotes_enabled` |
| `src/lib/demoSeed.ts`, new `src/lib/demoCompassData.ts` | Demo fixtures and RPC handlers |
| `docs/COMPASS.md` | This file; keep in sync |
| R1: `src/learn/components/ConceptCard.tsx`, `src/pages/TermDossier.tsx` | "Also taught in" chips; "Topics covered" block |

No new npm packages. Main app tokens from `src/lib/theme.ts`. Light theme only.

## 12. Testing

| Layer | What | How | Count |
|---|---|---|---|
| Pipeline unit | watermark filter, leak scan, id builders, validators | `python3 scripts/compass/compass_lib.py --selftest` | 12 cases |
| Data quality | recovery vs `learn_questions`; 50-row spot check; outline session counts | `python3 scripts/compass/eval.py` | 3 reports |
| SQL / RLS | anon denied; non-admin denied while not public; non-admin cannot see `live=false`; pointer mode hides quote/snippet; direct table select returns 0 rows; report insert only as self | `supabase/tests/compass_rls.sql` run with `psql` against local Supabase, each case `raise exception` on failure | 8 cases |
| Search | 60-query eval, top-3 hit rate | `eval.py --search --target local` | 60 queries |
| App build | types, lint, bundle size | `npm run build && npm run lint`; check `dist/assets/CompassSection-*.js` gzipped size | 3 |
| Browser QA | 20 scripted tasks at 375 px and desktop, demo mode, pointer vs quote mode | preview browser + `/qa`; then 5 AAC testers on production (admin preview) | 20 tasks |

## 13. Rollback

| Problem | Action | Time |
|---|---|---|
| Anything wrong for students | `update app_settings set compass_public = false where id;` | 1 min, no deploy |
| Quotes need to go | `update app_settings set compass_quotes_enabled = false where id;` | 1 min |
| One course must come down | `python3 scripts/compass/load.py --target prod --unpublish --course X` | 2 min |
| Bad content release | `load.py --target prod --unpublish --release r1`, then republish previous | 5 min |
| Code bug | Revert the PR; Vercel redeploys | 5 min |
| Abandon Compass | Down migration (drop the 7 tables, 2 columns, 3 functions). Written in the PR, not run unless decided | 10 min |

## 14. Roadmap

Re-baselined 15 Oct 2026 (Thursday). Today's date and weekdays below were checked against the system clock. **Assumption to confirm:** Term 4 end-terms start on or after Tue 27 Oct. If they start earlier, R0 stays admin-only through the exams and goes public the day after the last one (Eshan, section 18, Q1).

### Dependency graph

```
M-1 Moodle probe ──> M0 Foundations ──┬──> M1 Content R0 ──┐
(Fri 16 Oct)        (16 to 17 Oct)    └──> M2 App R0 ──────┴──> M3 Prod + dogfood ──> R0 public (Tue 27 Oct)
                                                                                          │
                                                                  R1 build (Oct 28 to Nov 8) ──> R1 (Tue 10 Nov) ──> R2 (Tue 8 Dec) ──> R3 (Jan 2027)
```

M1 and M2 run in parallel: the app is built against demo fixtures and local data, so it never waits for the full content run. The Moodle probe decides only where files come from; nothing after step 1 of the pipeline depends on the answer.

### Milestones

| Milestone | Dates | Work | Gate (all must pass) |
|---|---|---|---|
| M-1 Moodle probe | Fri 16 Oct | Eshan puts `MOODLE_BASE_URL` and `MOODLE_TOKEN` in `scripts/compass/.env` (about 30 min, section 7.0) and runs `moodle_sync.py --probe`. Builder writes the probe first, before anything else. | **G-1:** four-point probe result recorded in section 18, and D11 confirmed as "Moodle" or "OneDrive fallback" |
| M0 Foundations | Fri 16 to Sat 17 Oct | Local Supabase in Docker (schema-only dump of `public`, stub admin user, `.env.development.local`); migration `compass_v1` applied locally; `compass_lib.py` (filter, leak scan, ids, validators, selftest); `manifest.py` or `moodle_sync.py`; `extract.py` | **G0 (Sat 17 Oct):** selftest green; leak scan clean on OPMG S2, MKTG S4, MGEC S8, SWPM S1; RLS tests green locally |
| M1 Content R0 | Sat 17 to Thu 22 Oct | **Scope A (probe passes):** outlines for all 36 Term 1 to 4 courses that have an outline link, plus slides for every Term 1 to 4 course Eshan is enrolled in whose decks have a text layer. **Scope B (OneDrive):** outlines for the same 36, slides for OPMG, MKTG, BANM, MADM, SWPM. Concepts seeded from the 99 Learn concepts; tagging one course per session; Eshan reviews multi-course concepts on Wed 21 Oct (about 1 hour). | **G1 (Thu 22 Oct):** FR-01, FR-02, FR-03, FR-11, FR-12 pass locally |
| M2 App R0 | Sat 17 to Fri 23 Oct | RPCs final; all section 5 screens; sidebar item, phone top-bar icon, Resources "Topics matching" row; demo fixtures; analytics | **G2 (Fri 23 Oct):** FR-04 to FR-10, FR-13, FR-15, FR-16 pass locally; `npm run build` and `npm run lint` clean |
| M3 Prod + dogfood | Sat 24 to Mon 26 Oct | Apply migration to production (additive only); load release `r0` hidden; testers Eshan recruits run 20 scripted tasks as admins; fix P0s; rehearse rollback once (flip `compass_public`, unpublish and republish one course); rotate the Moodle token | **G3 (Mon 26 Oct, evening):** zero open P0 bugs; production leak scan 0; rollback rehearsal done; Eshan says go |
| **R0 public** | **Tue 27 Oct** | `compass_public = true`; announcement with 3 example links; watch PostHog and `compass_reports` for 72 hours. Quotes on at launch only if the tester pass is clean and section 18 A1 has a link to the approval. | Launch checklist below |
| R0 hold | 28 Oct to the last Term 4 end-term | Bug fixes and alias additions from zero-result searches only. No new features during exams. | |
| R1 build | 28 Oct to Sun 8 Nov | Remaining Term 1 to 3 decks (LSAT, SMDM, FADM, STRG, FCRV, FRNT, ASDM) if not already in R0; Term 5 and Block Week 1 and 2 outlines (37 courses); Learn "Also taught in"; Dossier "Topics covered"; alias pass from zero-result logs; quotes on if not already | **G4 (Sat 7 Nov):** all FR checks re-run on the new content |
| **R1 public** | **Tue 10 Nov** | Publish release `r1` | G4 plus section 18 A1 |
| R2 | by Tue 8 Dec | MGEC and any `needs_vision` decks read from page images in Claude Code; transcripts layer for the 7 courses that have them (section 15); Term 6 and 7 outlines when published | G5: FR checks on new sources |
| R3 | Jan 2027 | Term 5 decks collected by AAC; runbook handover so someone other than Eshan can run a term; season retrospective from PostHog | |

### Cut lines (decided in advance, so nobody improvises under pressure)

1. **Moodle probe fails or is blocked:** switch to the OneDrive path (scope B). No other change. Do not spend more than one day on Moodle workarounds; ask ISB IT for a read-only service account instead.
2. **G1 missed on Thu 22 Oct:** R0 ships with outlines only (sessions and outline-derived concepts for all 36 Term 1 to 4 courses). Slide pointers move to R1. The app does not change.
3. **G2 missed on Fri 23 Oct:** drop in this order until it passes: Resources search row, `/compass/coverage` page, recently viewed, "Taught earlier" list. Search, topic, course and session pages and the report button are never dropped.
4. **G3 missed on Mon 26 Oct:** slip public to Fri 30 Oct. If still not green, do not launch during exams; R0 merges into R1 on 10 Nov.
5. **Hard stops, no exceptions:** any leak scan hit, any failing RLS test, or the D8 check failing blocks launch.

### R0 launch checklist (Tue 27 Oct)

- [ ] Production leak scan: 0 hits
- [ ] RLS test file run against production with a test student account: all pass
- [ ] `compass_quotes_enabled` state decided and noted (default off; on only per the rule above)
- [ ] 10 random topic pages opened as a non-admin test account on a phone
- [ ] Demo mode homepage still works
- [ ] PostHog shows `compass_search` from the test account
- [ ] Rollback SQL for `compass_public` saved in the AAC admin notes
- [ ] Moodle token rotated
- [ ] Announcement text approved by Eshan

### Owners

| Area | Owner |
|---|---|
| Decisions, Moodle token setup and sync command, concept reviews, tester recruiting, launch go/no-go, Term 4 end-term dates | Eshan |
| Pipeline, migration, RPCs, UI, tests, runbooks | Claude Code sessions (PRs reviewed by Eshan) |
| Faculty and AAC approvals | Eshan (reported in place; record to be linked) |

### Risk register

| Risk | Likelihood | Impact | Early signal | Response |
|---|---|---|---|---|
| ISB blocks student API access or API downloads carry a stamp the filter cannot remove | Medium | Medium | Probe check 1 or 3 fails | Cut line 1: OneDrive path; ask IT for a read-only service account |
| Moodle token leaks | Low | High | Token in a commit, chat or log | Hard rule in 7.0; redaction test (FR-18); reset the Security key at once; rotate after R0 load |
| API pull is outside what ISB approved | Low | High | ISB IT or faculty objects | Confirm A3 in section 18 before the bulk pull; stop and use OneDrive if unclear |
| Faculty or academic office objects after launch | Medium | High | Complaint or reply to approval thread | Pointer mode only (quotes off); unpublish named courses the same day |
| Watermark text slips through | Low | High | Leak scan hit | Hard stop; fix filter; add pattern to selftest |
| Tagging quality below 90% | Medium | Medium | G1 spot check | Tighten prompt, re-tag that course; ship outline-only for it (cut line 2) |
| Only one section's decks (Section G) | Certain | Medium | Reports of "wrong slide number" | Cite slide heading with the number; label the section; ask AAC reps for other sections' decks in R1 |
| Students do not find it | Medium | High | Under 50 weekly users in week 1 | Resources search row, WhatsApp links to specific topic pages, R1 Learn entry point |
| Term 4 slide coverage thin (SWPM only held locally) | Certain | Medium | Zero-result searches on Term 4 topics | Outline session maps for all 17 Term 4 courses make every one findable at session level; Moodle may add more decks |
| Production database touched during development | Low | High | Any dev write to production | All dev against local Docker; production only through a reviewed migration and `load.py --target prod` |
| Schedule slips again (the 12 Oct date was missed) | Medium | Medium | A gate missed by more than one day | Cut lines above; Eshan sees gate status in the handoff doc status table |
| Eshan unavailable around exams | Medium | Medium | No review by Wed 21 Oct | Unreviewed multi-course concepts stay single-course (D8 keeps it safe) |

## 15. Later: transcript layer (R2)

Transcripts load as `compass_sources.kind = 'transcript'`, chunked by topic shift into `compass_passages` with `slide_from/slide_to` null. With no timestamps, each chunk is aligned by order to the slide passages of the same session (class follows the deck): an order-preserving match on shared words and shared concepts. The topic page gets a "Said in class" line under a citation (quote mode only) and search gets a "Class discussion" group. No schema change is needed; the stable passage ids and `seq` are what make this work.

## 16. Runbook: adding a new term's content

1. Put decks in the term folder; run `manifest.py`, check the new rows.
2. `extract.py` for new sources only (unchanged `text_hash` is skipped).
3. Parse new outlines, then tag one course per Claude Code session.
4. Canonicalise; Eshan reviews new multi-course concepts.
5. `eval.py`; `load.py --target local --release rN`; check in the local app.
6. `load.py --target prod --release rN`; admin check on production; `load.py --publish --release rN`.

## 17. Personas and user stories

### Personas

| ID | Who | When they use Compass | What they care about |
|---|---|---|---|
| P1 | Term 4 exam crammer: a Co'27 student the week before an end-term | Oct to Dec | Find the right session and slides in seconds on a phone; trust that the pointer is right |
| P2 | Placement preparer: same student, Nov to Jan | Case and interview prep | Refresh Term 1 to 3 ideas; see where an idea was taught in more than one course |
| P3 | Bidder: student choosing Term 5 and 6 electives | Bidding rounds | See what an elective covers, session by session. Information only; never a recommendation (product rule 1) |
| P4 | AAC member who reviews | Weekly | Review multi-course concepts; read reports; check zero-result searches; add aliases |
| P5 | Tester | Tester week | Run the scripted tasks and report what is confusing or wrong |

### User stories (each maps to requirements)

| ID | Story | Requirements |
|---|---|---|
| US-01 | As P1, I type "newsvendor" and see the course, session and slide range where it was taught, in under a second | FR-04, FR-05 |
| US-02 | As P1, I misspell "elastisity" and still get Price elasticity | FR-04 |
| US-03 | As P1, I open a result and tap "Open your deck" to land on the real file in the LMS | FR-05, 7.0 |
| US-04 | As P2, I open a concept and see every course and term that taught it, with the same-session and taught-earlier concepts | FR-05 |
| US-05 | As P3, I open a course I have not taken and see its sessions, readings and cases from the outline, clearly marked "Outline only" where there are no slides | FR-06, FR-08 |
| US-06 | As any student, I search for something not covered and am told honestly how much is covered, not given a guess | FR-08 |
| US-07 | As any student, I report a wrong link in two taps | FR-09 |
| US-08 | As any student, I share a topic link on WhatsApp and a classmate lands on the same page after signing in | 5.1, section 18 Q7 |
| US-09 | As P4, I see which multi-course concepts are still `machine` and approve them in one Claude Code session | FR-12, 7.2 step 7 |
| US-10 | As P4, I take one course offline the same day a faculty member objects | FR-10, section 13 |

## 18. Approvals and open questions

### Approvals

| ID | Approval | Status | Evidence |
|---|---|---|---|
| A1 | Faculty and AAC OK to show short slide quotes (max 200 characters) behind ISB login | Reported in place by Eshan, 15 Oct | Link to the message or email: **to be added by Eshan** |
| A2 | Academic office OK to publish pointers (course, session, slide range, heading) to students | Reported in place by Eshan, 15 Oct | Same record as A1 |
| A3 | The approval covers pulling course files from the LMS through the API for this project, not only using the content | **Not yet confirmed**: one-line check with Eshan or AAC before the bulk pull | |
| A4 | Search text is logged against the signed-in user (D6) | Eshan's choice, 30 Sep | Builder recommends a one-line notice on the Compass home: "Searches are recorded with your account to improve Compass." Eshan to confirm (Q5) |

### Open questions

| # | Question | Owner | Needed by | Why it matters |
|---|---|---|---|---|
| Q1 | Exact dates of the Term 4 end-terms | Eshan | Fri 16 Oct | Decides whether R0 goes public on 27 Oct or after the exams |
| Q2 | The LMS web address, and whether Preferences shows a Security keys page | Eshan | Fri 16 Oct | The Moodle probe (7.0) cannot start without it |
| Q3 | Where the A1 and A2 approvals are recorded | Eshan | Before quotes are switched on | Audit trail if a faculty member asks |
| Q4 | Who owns the alias list and the weekly review of zero-result searches (builder suggests Eshan plus one AAC member, 15 minutes a week) | Eshan | R0 launch | Search quality depends on this loop |
| Q5 | Add the search-logging footer notice (A4)? | Eshan | M2 | Privacy hygiene for linked logs |
| Q6 | Who runs the pipeline next year | Eshan and AAC | R3 | Single-builder risk; the runbook in section 16 is written for this |
| Q7 | Does a shared link survive the Microsoft sign-in round trip (the app returns to the original URL)? | Builder tests it | M2 | Deep links are a core promise |
| Q8 | The Google Docs for transcripts that were not shared with the Drive connector (two of nine on 30 Sep) | Eshan | R2 | Only needed for the transcript layer |
| Q9 | Other sections' decks (Sections other than G) | AAC reps | R1 onwards | Slide numbers differ between sections; label the section until then |

## 19. Non-functional requirements

| Area | Requirement |
|---|---|
| Performance | Type-ahead results within 150 ms of a keystroke after the first load; `compass_search` under 100 ms server time; route chunk under 60 KB gzipped (FR-04, FR-16) |
| Devices | Phone first. iOS Safari 16 and later, Chrome on Android, current desktop Chrome, Safari, Edge. Works as an installed PWA. 375 px is the design width |
| Accessibility | WCAG 2.1 AA contrast; 44 px tap targets; full keyboard use; visible focus; screen-reader labels on icon buttons (the phone search icon says "Search"); animation respects reduced motion; meaning never carried by colour alone (product rule 7); area colour always printed with its code |
| Theme | Light only, matching the main app |
| Availability | No new servers or services. If the database is down, the rest of the app is down too; Compass adds no new failure point |
| Privacy | Signed-in users only; no slide text in git, logs or analytics; query text capped at 60 characters; reports store only what the student types (section 9) |
| Cost | $0 a month extra. Expected data size 20 to 30 MB of the 500 MB free-plan limit. No images, so no storage or bandwidth growth. No runtime AI calls |
| Maintainability | One migration, one Python folder, one lazy route. No new npm dependency. Runbook in section 16. IDs are stable so re-runs change nothing unless content changed |
| Observability | PostHog events (section 10); `compass_reports` table; zero-result list reviewed weekly |
| Content safety | Leak scan blocks any run containing the deck owner's identity; every cross-course claim is reviewed (D8); per-course unpublish in minutes (section 13) |

## 20. Rejected options (so nobody reopens them without new evidence)

| Option | Raised by | Why it was rejected |
|---|---|---|
| Chatbot or any runtime AI | Original blueprint | Per-query cost, can invent "ISB taught X", slower than search, no shareable URLs. Eshan chose retrieval over a chatbot |
| Force-directed graph, atlas, sankey | Original blueprint | At about 20 courses and a few hundred concepts it is a hairball; positions mean nothing; poor on phones; 370 KB or more of library. A list answers "where was this taught" faster |
| Per-course "metro line" SVG and course-overlap matrix | Visual design (round 1) | Conceded in round 2: no student job needs them; the session list with a CSS left rule does the same job. Matrix counts are noise until concepts are reviewed |
| Slide thumbnails and an image evidence panel | Visual design (round 1) | Every page carries the deck owner's name; rendering them redistributes faculty decks to the cohort; storage and bandwidth cost. Text pointers instead (D3) |
| Storing `same_as`, `contrasts`, `related` link rows | Tech (round 1) | Duplicates merge through aliases; "taught earlier" and "same session" are computed. Fewer tables, nothing to review. `builds_on` deferred until a person writes it |
| pgvector and embeddings | Original blueprint | A small jargon-heavy corpus; aliases plus trigram plus full-text cover real queries; a runtime embedding adds a cold start and a deploy surface. Revisit if zero results stay above 15% for 4 weeks (D9) |
| Putting Compass inside Learn | Visual design (round 1) | Learn hides the main bottom nav and runs in windows; entry points from Resources, Dossier and WhatsApp land in the main app (D1) |
| A separate Postgres schema | Original blueprint | PostgREST only exposes `public` without a shared dashboard setting that isb-explorer also relies on |
| Seeding content through migration SQL | Existing Learn pattern | Would put faculty text in git history for good; a 6 MB migration is unreviewable (D10) |
| Supabase branching for safe dev | Tech | Needs the paid plan ($25 a month). Local Docker instead |
| "Your course" badges and "Suggested for you" | UX and Product | Term 1 to 3 core is identical for everyone; "suggested" edges toward recommending courses (product rule 1) |
| Reviewer, faculty and Career Services roles and a review UI | Original blueprint | Reviews happen in a Claude Code session editing `concepts.json`; roles can wait until there is more than one reviewer |
| Demand-side graph (roles, companies, interview questions) and learner model | Original blueprint | A second product. Compass v1 is the base layer they would sit on |

## 21. Glossary

| Term | Meaning |
|---|---|
| Concept | A canonical, lesson-sized idea (Price elasticity, DCF, Newsvendor). One id, a name, aliases, and a kind. Seeded from the 99 Learn concepts |
| Alias | Another name for a concept (NPV, net present value). The list Eshan owns |
| Source | One ingested file: a deck or an outline |
| Session | One class meeting of a course offering, with title, outline topics line, readings and cases |
| Passage | A run of slides in one deck on one topic (for example OPMG S6, slides 12 to 18). The unit that carries tags and, later, transcript alignment |
| Page | One slide page. What search matches and what an exact slide number points to |
| Cover | The link "this passage covers this concept", with a role (teaches, applies, mentions) and a confidence |
| Pointer mode | Students see course, session, slide range and slide heading only. No slide text |
| Quote mode | Pointer mode plus up to 200 characters of slide text, switched by `app_settings.compass_quotes_enabled` |
| Reviewed | A human has checked this concept's merge across courses. Only reviewed concepts may show "Also taught in" |
| Release | One load of content, tagged `r0`, `r1`. Rows load hidden (`live = false`) and are published together, or unpublished together |
| Outline only | A course Compass knows from its outline but has no slides for |
| Section G | The class section Eshan attends; all deck content in v1 comes from it. Other sections number slides differently |
| Probe | The four checks that decide whether the Moodle route is usable (section 7.0) |
| Watermark | A stamp carrying the deck owner's identity that the LMS adds to downloaded files. Filtered out before anything is stored |
| Leak scan | The check that stops a run if any identity pattern survives in cleaned text |
