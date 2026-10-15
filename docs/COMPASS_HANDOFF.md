# Compass handoff: start here

Written Thu 15 Oct 2026 at the end of the planning chat. Read this, then `docs/COMPASS.md` (the full product requirements, architecture and roadmap). Nothing for Compass has been built yet; everything so far is planning and verification.

## What Compass is, in three lines

A "where was this taught" index for ISB students. They type an idea ("NPV", "newsvendor"), and see every course, session and slide range that covered it, with a link to open the real deck in the LMS. No chatbot, no AI at runtime, $0 a month extra. AI is used only at build time, in Claude Code sessions on Eshan's Mac, to tag slides and outlines with topics.

## Where things are

| Thing | Location |
|---|---|
| Full PRD, architecture, schema, RPCs, pipeline, tests, roadmap | `docs/COMPASS.md` (742 lines, sections 1 to 21) |
| This handoff | `docs/COMPASS_HANDOFF.md` |
| Old blueprint (idea bank only, not binding) | `/Users/eshan/Desktop/claude/ISB/isb-academics/docs/AAC_Compass_Blueprint.md` (main checkout) |
| Branch and worktree | `claude/aac-compass-blueprint-review-e1ffd5` in `.claude/worktrees/whatsapp-tom5-dashboard-message-edecb8` |
| Git state | **Both docs are untracked and uncommitted.** The worktree is behind `origin/main` (f002209). If the worktree is cleaned up, the docs are lost; commit them first |
| Source material | Eshan's OneDrive `ISB/Term1` to `Term4` (770 files, mostly cloud-only PDFs) |
| Build output (to be created) | `~/compass-build/` outside the repo; never committed |
| Supabase project | ref `ujnrgvmbahbepdnahtle` (shared with isb-explorer; free plan; no branches) |

## Status at 15 Oct

| Step | State |
|---|---|
| Problem, scope, requirements (FR-01 to FR-18), UX, schema, pipeline, roadmap | Written and approved by Eshan |
| Faculty and AAC approvals | Reported in place by Eshan on 15 Oct; written record link still to be added (`COMPASS.md` section 18, A1 to A3) |
| Moodle API access | Offered by Eshan on 15 Oct; not yet tested (probe is milestone M-1) |
| Learn content tables restricted to signed-in users | Done and live in production (migration `20260930150530`, checked 15 Oct) |
| Database objects for Compass | None. 0 `compass_*` tables; no extensions installed |
| Code, scripts, migration | None written |
| Current milestone | **M-1 Moodle probe (Fri 16 Oct)**, then M0 Foundations |

## Decisions already made (do not reopen without new evidence)

Full table: `COMPASS.md` section 0. The ones that shape everything:

1. Own route family `/compass` in the main app, not inside Learn (D1). Sidebar says "Compass"; page subtitle "Where was this taught?"; phone gets a search icon in the top bar, no new bottom tab (D2).
2. Text only. No slide images, thumbnails or hosted files, ever in v1 (D3).
3. Pointer mode (course, session, slide range, heading) by default; short quotes (max 200 characters) behind one setting that Eshan flips (D4).
4. Lists, not graphs (D7). Search is Postgres full-text plus trigram plus an alias list; no embeddings (D9).
5. "Also taught in" appears only for concepts a human marked reviewed (D8).
6. Faculty text never goes into git; it loads from Eshan's Mac straight into Supabase (D10).
7. Moodle sync is the preferred source if the probe passes; OneDrive is the fallback; nothing after step 1 changes (D11).
8. Search logs are linked to the signed-in user (D6); builder recommends a one-line notice on the page (Q5).
9. Rejected options and the reasons are in `COMPASS.md` section 20. The five-specialist debate (product, data, tech, visual design, UX) ended with agreement on all of the above.

## Eshan: what to do next, in order

| # | Action | Time | Needed for |
|---|---|---|---|
| 1 | Tell the builder the exact dates of the Term 4 end-terms (Q1) | 2 min | Whether R0 goes public Tue 27 Oct or after the exams |
| 2 | Tell the builder the LMS web address (the address is not secret) and whether Preferences, then User account, then Security keys exists | 5 min | Moodle probe |
| 3 | After the builder creates `scripts/compass/` and its `.env.example` (first task of the next chat), create `scripts/compass/.env` yourself with two lines: `MOODLE_BASE_URL=<address>` and `MOODLE_TOKEN=<your key>`. **Never paste the key into chat.** The key is the long string next to "Moodle mobile web service" on the Security keys page | 10 min | Moodle probe |
| 4 | Run the probe yourself in the terminal pane: `python3 scripts/compass/moodle_sync.py --probe`. It prints pass or fail for four checks and never prints the key. Paste only that output into chat | 5 min | Decision D11 |
| 5 | Paste the link to the faculty and AAC approval message into `COMPASS.md` section 18 (A1) | 5 min | Switching quotes on |
| 6 | One line to confirm the Moodle approval covers pulling files by API (A3) | 5 min | The bulk pull |
| 7 | Wed 21 Oct: about one hour reviewing multi-course concepts in a Claude Code session | 1 hr | G1 |
| 8 | Find your testers for Sat 24 to Mon 26 Oct | n/a | G3 |

If the Security keys page is missing or the probe fails on check 1, say so; the builder writes the browser sign-in helper, or you stay on OneDrive. Do not spend more than a day on this.

## Builder: what to do next, in order

Work in this order. Each step has a check; do not start the next until it passes.

1. **Preflight.** Run the `sync_with_base_branch` tool (or merge `origin/main`) so the worktree has the current main. Commit the two docs on this branch (ask Eshan first) so they are not lost. Re-confirm that the files cited in `COMPASS.md` section 2 are unchanged (`git diff HEAD origin/main -- <files>`); update line references if not.
2. **Create `scripts/compass/`** with `.env.example`, a `.gitignore` rule for `scripts/compass/.env`, and `compass_lib.py` (watermark filter, leak scan, id builders, validators, `--selftest`). Check: `python3 scripts/compass/compass_lib.py --selftest` passes, including a fixture with a watermarked line.
3. **Write `moodle_sync.py --probe` first** (FR-17, FR-18): read-only function allowlist, token redaction, 1 second between calls. Check: a run with a fake token prints no token anywhere. Eshan runs it with the real key. Record the result in `COMPASS.md` section 18 and confirm D11.
4. **M0 Foundations:** local Supabase in Docker (`supabase start`, schema-only dump of production `public`, stub admin user, `.env.development.local` pointing the app at it). Write migration `supabase/migrations/<timestamp>_compass_v1.sql` from `COMPASS.md` section 6 using the Supabase CLI. Write `supabase/tests/compass_rls.sql`. Check gate G0.
5. **M1 and M2 in parallel** as described in `COMPASS.md` section 14. Build the app against demo fixtures first (`src/lib/demoCompassData.ts` and handlers in `src/lib/demoSeed.ts`).
6. **Dogfood, load to production, launch** per the checklist in section 14.

Every production write goes through a reviewed migration or `load.py --target prod`. Never develop against production.

## Gotchas learned in this project

- Local dev points at the **production** Supabase project. Use Docker for Compass work.
- Migrations only through the Supabase CLI, never the dashboard (otherwise migration histories diverge).
- `src/lib/demoClient.ts` is an in-memory fake used by the homepage demo. Every new table or RPC needs demo data and a handler, or the demo breaks (FR-13).
- `users.id` must equal `auth.uid()`; the admin check is `exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin)`.
- The phone bottom nav is full (5 items). Do not add a sixth. Learn hides the main bottom nav; Compass sits outside Learn.
- LMS downloads carry a name stamp (file names start `filewithwatermark`). The filter plus the leak scan must pass before any text is stored. Text from decks must never reach git, logs, PostHog or any chat message.
- `app_settings` is a single row (`id = true`); Compass adds `compass_public` and `compass_quotes_enabled`.
- Course Resources already puts search state in the URL (`q`, `course`); Compass follows the same rule.
- Free Supabase plan: 500 MB database. Compass is expected to use 20 to 30 MB.
- Writing style for all copy and docs: plain English, no em dashes, no filler words (Eshan's standing rule).

## Verified facts (checked 15 Oct)

- 138 courses. "Course Outline" links exist for Term 1: 6 of 7, Term 2: 6 of 7, Term 3: 7 of 9, Term 4: 17 of 17, Term 5: 17 of 17, Block Week 1: 8 of 8, Block Week 2: 12 of 12; none yet for Block Weeks 3 and 4 or Terms 6 and 7.
- 99 Learn concepts (MADM2 30, BANM2 27, MKTG 23, OPMG 19); `learn_questions` pairs each topic with a session, which is the answer key for the tagging check (FR-03).
- Transcripts exist for 7 courses (about 57 sessions): FRNT (no S6), ASDM (S1 to S5, S9), MKTG (S1 to S9), OPMG (S1 to S10), BANM (S1 to S10), SWPM (S1 to S7), SUET (S1 to S6). No timestamps anywhere; they align to slide passages by order in release R2. The other 12 courses have none.
- Slide text layers: good for OPMG, MKTG (Subhranshu), BANM, MADM handouts, SWPM; MGEC decks (S3 confirmed, S1, S2, S4, S5 likely) are images with no text and need reading from page images (R2).
- Watermark filter that worked on OPMG S2, MKTG S4 and MGEC S8: drop non-horizontal lines, then drop lines that still spell the owner's name or `PGP2027` once stray "I" characters and punctuation are removed.
- Supabase free plan, 24 MB used at 30 Sep, no branches, no `compass_*` tables.

## Paste-ready starter prompt for the next chat

```
Continue the Compass build in isb-academics. Read docs/COMPASS_HANDOFF.md, then docs/COMPASS.md.
Today is [date]. Term 4 end-terms run [dates]. The LMS address is [address]. The faculty/AAC approval is recorded at [link].
Start at "Builder: what to do next", step 1. First commit the two docs if they are still uncommitted, then build scripts/compass/ and the Moodle probe so I can run it.
I will put the Moodle key in scripts/compass/.env myself and will not paste it here.
```

## Update, 15 Oct 2026 (later): PRD v2 written, scope and hosting changed

Read the PRD first: https://claude.ai/artifact/2DVUcVLqxoatKC4h2SHTKc (private artifact; share from its Share menu). It supersedes parts of `docs/COMPASS.md`.

What changed since the sections above:

- **Scope cut by Eshan:** only search, concept page, role kits (Prep kit by role) and the map. No weekly plan, drills or mocks, company brief, story bank, or student tracking.
- **Purpose-agnostic:** placement is the first lens, not the schema. A "lens" is a saved view stored as data.
- **Hosting:** target is an ISB-owned Azure subscription, India region (D1; confirm ISB IT runs on Microsoft). Cloudflare R2 and the shared Supabase project are for the pilot only, and the pilot holds derived data only (outlines, concept names, pointers). No files or transcripts load until the ISB tenant is live.
- **Files:** hosted only as official clean originals through a secure viewer (per-user mark, no downloads, rate limits). We do not strip student watermarks from copies.
- **AI:** build-time only, in ISB's cloud tenant. Runtime v1 needs one embedding call per search. No LangChain or LangGraph in v1. Jev or an open decision model only if free-text goals appear. In-app agent is a later decision.
- **Own-AI connector:** read-only MCP server returning Tier 1 content (our concept cards, links, pointers). Never whole files.
- **Cost:** about ₹5.4 to 7.6 lakh a year core (cloud and AI). People are internal (AAC, faculty).
- **Dates (re-baselined):** pilot by Tue 10 Nov; full launch by mid-Jan 2027; placement calendar still unknown.

Co'26 folder (`~/Library/CloudStorage/OneDrive-IndianSchoolofBusiness/ISB/Co'26 - PGP Gyaan Bhandaar`): 4 download parts of one tree; part 4 duplicates part 2; 1,316 unique files, about 6.5 GB, 93 course folders, both campuses, all terms. Every file carries another student's name and ISB email as a watermark, so the cleaner must match name patterns, not a fixed list. **Waiting on Eshan's yes to download batch 1** (Mohali Terms 1 to 4 PDF, PowerPoint and Word files: about 370 files, 2.2 GB; disk has about 21 GB free).

Still open: ISB IT cloud confirmation, Moodle service account or key, professor's written OK for the PM graph (author shown as Chandrashekhar V), placement dates, faculty and legal sign-offs listed in the PRD asks table.
