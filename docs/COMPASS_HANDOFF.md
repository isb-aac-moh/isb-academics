# Compass handoff: start here

Last updated Thu 15 Oct 2026, after the POC went live for admins. If you are picking this up later, read this file first, then the doc you need from the map below.

## What Compass is, in three lines

A searchable, connected memory of everything ISB teaches. A student types an idea ("newsvendor", "market sizing"), sees every course and session that taught it, how it connects to other ideas, and opens the class material in Moodle. No chatbot and no AI at runtime; AI is used only while building the dataset. Placement preparation is the first use, not the only one.

## Document map

| File | Read it for |
|---|---|
| `docs/COMPASS_HANDOFF.md` (this file) | Where things stand, where everything lives, what to do next, a starter prompt |
| `docs/COMPASS_POC.md` | What was built: routes, data format, pipeline commands, code map, access control, operations, quality status, backlog, gotchas |
| `docs/COMPASS_PRD.md` | The stakeholder PRD v2: scope, decisions, guardrails, costs, phases, risks, asks. Repo copy of the private artifact https://claude.ai/artifact/2DVUcVLqxoatKC4h2SHTKc |
| `docs/COMPASS_RESEARCH_PLAN.md` | How to test the POC with reviewers, data-quality checks with pass marks, usage measurement, timeline, go or stop criteria |
| `docs/COMPASS.md` | The earlier 740-line engineering spec (schema, RPCs, build pipeline, tests, rollout) for the full production build. **Partly superseded** by the PRD; still useful for the data model and runbook ideas |
| `docs/AAC_Compass_Blueprint.md` | The first idea bank. Not binding |

## Where things are

| Thing | Location |
|---|---|
| App code | `src/compass/` in the `isb-academics` repo (merged to `main` by pull request #55, merge commit `f68dd8d`, 15 Oct 2026) |
| Pipeline scripts and AI prompts | `scripts/compass/` and `scripts/compass/prompts/` |
| Production database and storage | Supabase project "Pulse of isb", ref `ujnrgvmbahbepdnahtle` (shared with the rest of the app). Private bucket `compass`, one object `compass.json` (about 1.5 MB), uploaded 15 Oct 2026 |
| Migration | `supabase/migrations/20261015120000_compass_private_bucket.sql`, applied to production with the CLI on 15 Oct |
| Built dataset (not in git) | `public/compass-dev.json` in a working copy, and the build inputs in `~/Downloads/compass-build/` on Eshan's Mac. **Move that folder to a safe private place; it holds the only copy of the tagging results, explainers and links** |
| Source course files | Eshan's OneDrive: `~/Library/CloudStorage/OneDrive-IndianSchoolofBusiness/ISB/Term1` to `Term4`, plus the Co'26 "PGP Gyaan Bhandaar" folder (1,316 files, 6.5 GB) which has not been used |
| Prep graphs | Product Management Knowledge Graph by Professor Chandrashekhar V (saved page in Downloads); Consulting Case Graph in `ISB/Placement Prep/Consulting Case KG/` |
| Assistant memory | `~/.claude/projects/-Users-eshan-Desktop-claude-ISB-isb-academics/memory/compass-project.md` |

## Status at 15 Oct 2026

| Item | State |
|---|---|
| POC built and merged to `main` | Done |
| Migration and dataset in production | Applied and uploaded; signed-out requests to the file get nothing |
| Admin-only | Route wrapped in `RequireAdmin`; sidebar item hidden for students and in demo; storage read policy is admins only |
| Verified as a real admin in production | **Not yet.** The build session could not sign in as an admin |
| Verified a student is redirected | **Not yet** |
| Content | 6 courses (STRG, MKTG, OPMG, BANM, SWPM, FRNT), 440 ideas taught, 1,515 ideas in the file, 2,927 links (191 AI-suggested), 45 ideas in 2+ courses |
| Tag accuracy sample | **Not done** |
| Usage logging | **None.** Add PostHog events before testers start |
| Reviewer roadmap page | Live at `/compass/roadmap`, not in the tab bar. Delete before production |
| Approvals and asks to ISB | Open. See the PRD asks table. Written permission to use the PM graph is outstanding |

## First thing to do: confirm production works (10 minutes)

1. Sign in to the live app as an admin. "Compass" appears in the sidebar with a Preview badge. Open `/compass`: the landing page loads with 440 ideas; search "newsvendor"; open an idea; open the Map and click an idea.
2. Sign in as a normal student (or ask a friend). There is no Compass in the sidebar and `/compass` sends them to the tracker.
3. If the data does not load for an admin, check the bucket object exists (`supabase --experimental storage ls ss:///compass --linked`) and that the admin's row in `public.users` has `is_admin = true`.
4. In the recruiter demo (`/demo`) Compass is hidden on purpose.

## Decisions that hold (do not reopen without new evidence)

The full locked list is in the PRD (D1 to D15). The ones that shaped the POC:

1. One graph with lenses, not separate Product and Consulting graphs. Lenses today: All ideas, Product roles, Consulting cases.
2. Retrieval, not a chatbot. No AI at runtime. AI only while building the dataset.
3. Derived data only in the POC: AI-written summaries, no slide text, no transcripts, no hosted files. Slides open in Moodle.
4. Raw files, extracted text, transcripts and the Moodle session never go into git, logs, analytics or chat.
5. Admin-only until Eshan says otherwise. Opening to students needs a policy change and a route change together (POC doc, section 6).
6. Production target is an ISB-owned cloud in an India region with ISB sign-in. The POC runs on the existing Supabase and Vercel setup as a stopgap.
7. Desktop-first. The map is not designed for phones.
8. Migrations only through the Supabase CLI. Never in the dashboard.

Where the POC differs from the old engineering spec (`COMPASS.md`): no `compass_*` database tables (one JSON file in a private bucket instead), search runs in the browser (MiniSearch, not Postgres full text), no pointer or quote settings, no reviewer console yet, no Moodle sync script (a one-off session-cookie fetch was used).

## What Eshan does next, in order

| # | Action | Needed for |
|---|---|---|
| 1 | Run the production check above | Knowing it works |
| 2 | Move `~/Downloads/compass-build/` to a private OneDrive folder (not shared, not in git) | Not losing the dataset's inputs |
| 3 | Export the MKTG, OPMG, BANM and SWPM transcript Google Docs as `.docx` or text into one local folder and tell the builder the path | Richer tags for four courses |
| 4 | Decide who gets admin access as testers, and for how long | Reviewer round |
| 5 | Send the ask list to ISB: cloud confirmation and sign-in app (IT, by 23 Oct and 6 Nov), faculty notice and licence (Dean's office, 30 Oct), rights and privacy (Legal, 30 Oct), role lists (Career Services, 6 Nov), PM graph permission and placement dates (AAC, 23 Oct) | PRD gates |
| 6 | Run the reviewer sessions in `COMPASS_RESEARCH_PLAN.md` | Go, change or stop decision |
| 7 | Never paste the Moodle cURL or key into chat. If it is used again, log out of Moodle and delete `curl.txt` and any `.rtf` copy afterwards | Account safety |

## What the builder does next, in order

1. **Preflight.** Merge `origin/main` into your branch with the `sync_with_base_branch` tool. Read `COMPASS_POC.md`.
2. **Usage events.** Add PostHog events (list in the research plan, section 6). Check they fire in the app's existing analytics setup. Small pull request, no migration.
3. **Quality pass.** Run the checks in research plan section 5 (tag accuracy sample first). Fix the worst patterns by re-tagging that slice and rebuilding (POC doc, section 4, steps 5 to 10). Record results.
4. **Review the new ideas and links.** Merge near-duplicates among the 171 new ideas, drop weak AI links, hand-check the topic rules.
5. **Frameworks flag.** Tag which ideas are frameworks so the map and tables can filter on it.
6. **More sources.** Load the four transcript sets and run a vision pass on image-only BANM sessions 7 to 10.
7. **"My frontier"** and a **report-a-problem** button, if reviewers ask for them.
8. **Before production:** remove `RoadmapPage.tsx`, its route and the link in `Home.tsx`; decide hosting with ISB IT; follow the PRD for sign-in, viewer, privacy tooling and quality gates.

Every production write goes through a reviewed migration or a CLI upload. Keep a dated copy of each uploaded file so you can roll back.

## Gotchas learned in this project

- Local dev points at the production Supabase project. For Compass data work use `public/compass-dev.json`, which the loader reads first in dev.
- `src/lib/demoClient.ts` is an in-memory fake used by the demo. Any new table or RPC needs demo data or the demo breaks. Compass is hidden in demo instead.
- `users.id` must equal `auth.uid()`; the admin check is `exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin)`.
- The phone bottom nav is full (5 items). Do not add a sixth.
- LMS downloads carry a name stamp (file names start `filewithwatermark`). The filter plus the leak scan must pass before any text is stored. Personal patterns come from env `COMPASS_LEAK_PATTERNS`, never the repo.
- Free Supabase plan: 500 MB database, 1 GB storage. The Compass file is about 1.5 MB.
- The in-app preview pane is narrow and shows the phone layout. Resize it to see desktop.
- Writing style for all copy and docs: plain English, no em dashes, no filler words (Eshan's standing rule).
- Supabase storage commands need `--experimental`.

## Verified facts (checked 15 Oct)

- 138 courses. "Course Outline" links exist for Term 1: 6 of 7, Term 2: 6 of 7, Term 3: 7 of 9, Term 4: 17 of 17, Term 5: 17 of 17, Block Week 1: 8 of 8, Block Week 2: 12 of 12; none yet for Block Weeks 3 and 4 or Terms 6 and 7.
- Transcripts exist for 7 courses (about 57 sessions): FRNT (no S6), ASDM (S1 to S5, S9), MKTG (S1 to S9), OPMG (S1 to S10), BANM (S1 to S10), SWPM (S1 to S7), SUET (S1 to S6). No timestamps anywhere. The other 12 courses have none.
- Moodle sessions found for the POC courses: OPMG 1 to 10, STRG 1 to 10, MKTG 1 to 9, SWPM 1 to 9, FRNT 1 to 5 and 8 to 10 (6 and 7 absent), BANM 1 to 10. Moodle course ids: OPMG 10846, STRG 10578, MKTG 10845, SWPM 10955, FRNT 10581, BANM 10849.
- Watermark filter that worked: drop non-horizontal lines, drop lines repeated on over half the pages, then fail on any surviving identity pattern.
- Learn content tables were restricted to signed-in users (migration `20260930150530`, live).

## Paste-ready starter prompt for the next chat

```
Continue Compass in isb-academics. Read docs/COMPASS_HANDOFF.md, then docs/COMPASS_POC.md.
Today is [date]. Status since 15 Oct: [what changed, for example "production check passed", "testers started", "ISB IT replied"].
I want to work on: [usage events | quality pass | new ideas and links review | frameworks flag | transcripts | something else].
Rules: use the Supabase CLI for migrations, never paste or commit the Moodle cURL or key, keep raw course files and the dataset out of git, ask me before committing, pushing or deploying.
```
