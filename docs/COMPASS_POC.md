# Compass POC: what was built, how it works, how to run it

Written 15 Oct 2026, after the POC went live for admins (pull request #55, merge commit `f68dd8d`). Read `docs/COMPASS_HANDOFF.md` first for where things stand and what to do next. The product plan is `docs/COMPASS_PRD.md`.

## 1. What this is

A working first version of Compass inside the existing ISB Academics app, at `/compass`. It lets someone search any idea taught in six courses, see where and when it was taught, see how ideas connect, and open the class material in Moodle. There is no chatbot and no AI at runtime. It exists so that ISB IT, operations, administration and the AAC can see what the product does and decide whether to commit to the full build described in the PRD.

**Access:** admins only (`users.is_admin`). Students cannot open the route, the sidebar item is hidden for them and in the recruiter demo, and the data file is readable only by admins at the database level. Testers must be given the admin flag to see it.

**Content:** derived data only. Every sentence shown was written by an AI from course material and is a summary, not a quote. No slide text, no transcripts and no files are stored or shown. Slides open in Moodle, which stamps each viewer's name on them, so ISB's own permissions still apply.

## 2. What the user sees

| Route | What it is |
|---|---|
| `/compass` | Search (the front door), four task tiles (prepare for interviews, revise a course, browse by topic, see how ideas connect), ideas that recur across courses, and 12 topics. A pilot-preview note links to the reviewer roadmap. |
| `/compass/c/:id` | Idea page: breadcrumb, definition, "What to know" block (what it is, when to use it, watch out, a self-test question), "How it connects" (learn first, leads to, taught in the same session), where ISB taught it (course, session, summary, Moodle link), an "In interviews" panel, "Mark as known", "See on the map". |
| `/compass/topics`, `/compass/topics/:id` | The 12 topics, then one topic's ideas grouped by the prep-graph module they came from. |
| `/compass/courses`, `/compass/course/:code` | Courses, then one course grouped by topic (default) or by session (`?by=session`), with Moodle links per session. |
| `/compass/prep`, `/compass/prep/:id` | Prep kits for Product roles and Consulting cases: ideas the interview graph asks for that appear in ISB courses, grouped by interview module, with progress. |
| `/compass/map` | The map. Group by topic or by course, "All" or one group, "Include ideas not covered in class", "Show only this chain". Details open in a slide-over panel. See section 6. |
| `/compass/compare` | "Across courses" table: which course teaches which idea and in which session. Filter by name or topic; "only ideas in 2+ courses" shows the bridges between courses. |
| `/compass/roadmap` | Reviewer-only pitch page: what exists, phases and gates, content protection, asks by owner, questions by audience. **Not in the tab bar.** Delete it (and the link in `Home.tsx`) before production. |

Global controls: a "Show" switch (All ideas, Product roles, Consulting cases) that filters everything, kept in the URL as `?lens=` and remembered in `localStorage` (`compass.lens`). "I know this" ticks are stored only in the browser (`compass.known`).

Names a student sees were chosen to be plain: "idea" instead of "concept", "Prep kits", "Across courses". Internally the code still says concept and lens.

## 3. The data

One JSON file with three keys, built offline and read at runtime.

```
meta      { built, counts }
courses   [ { code, name, sessions: [ { n, title, resources: [{name,type,url}], concepts: [{id, role}] } ] } ]
concepts  { <id>: { id, title, aliases[], lenses[], obj, q, module{product|consulting}, freq, level,
                    rel: [ { to, type, why, auto? } ],          // "this builds on <to>"
                    evidence: [ { course, session, kind, pages[2], role, why, summary, passage } ],
                    isNew?, definition?, know?: { what, use, trap, ask } } }
```

- `role` is teaches, applies or mentions. `kind` is slides, slides_md, transcript or outline. `passage` is an id only, never text.
- `rel.to` is the prerequisite. A link A to B means "A builds on B". `auto: true` marks a link proposed by AI and not reviewed by a person; the map panel labels these "suggested".
- A concept with `evidence` is "taught at ISB". Without evidence it comes from the prep graphs only.

### Counts at upload (15 Oct 2026)

| | |
|---|---|
| Concepts in the file | 1,515 |
| Taught at ISB | 440 (269 matched an existing graph idea, 171 are new ideas found in class) |
| Evidence rows | 1,025 (from 954 passages; 52 admin passages and 97 non-faculty passages set aside) |
| Links between ideas | 2,927 in total; 476 between two taught ideas; 191 AI-suggested |
| Ideas taught in 2+ courses | 45 |
| Ideas per course | FRNT 152, BANM 93, SWPM 92, MKTG 69, STRG 63, OPMG 22 |
| Prep graph size | Product 1,047 ideas, Consulting 343 (after merging near-duplicates) |
| Explainers ("What to know") | 440 of 440 |

Sources behind the graph: the Product Management Knowledge Graph by Professor Chandrashekhar V (1,025 topics, six relation types) and the Consulting Case Graph (345 topics), merged into one list with 18 hand-listed duplicate pairs (`MERGE_TITLES` in `scripts/compass/build_seed.py`). Written permission to use the PM graph is still an open ask.

### Topics

The prep graphs have 49 product modules and 41 consulting modules, too many and too uneven to browse. `src/compass/lib/topics.ts` folds them into 12 student-facing topics with ordered regex rules (first match wins). Ideas with no module (all 171 new ones) fall back to the topic of their first course: STRG strategy, MKTG customers and marketing, OPMG operations, BANM data, SWPM product, FRNT AI. This is a heuristic. It has not been hand-checked idea by idea.

## 4. The pipeline that makes the file

Everything runs on Eshan's Mac. Raw files and the build folder never go into git. The build folder is `~/Downloads/compass-build/` (about 10 MB). **It is the only copy of the tagging results, explainers and links.** Move it somewhere safe and private (not git) before cleaning Downloads.

| # | Step | Script or tool | Output |
|---|---|---|---|
| 1 | Fetch course structure (sessions, resources, Moodle links) | `scripts/compass/moodle_state.py`. Reuses a browser request saved as a cURL file; read-only; one allowed method; one request per course, 1 s apart. | `moodle/state_<COURSE>.json` |
| 2 | Extract text from official course files, strip identity watermarks, leak-scan | `scripts/compass/extract_slides.py` (PyMuPDF). Drops rotated lines and lines repeated on over half the pages; fails a file if `PGP20xx`, `[at]isb`, `@isb.edu`, `filewithwatermark` or any personal pattern from env `COMPASS_LEAK_PATTERNS` survives. | `extract/<COURSE>/*.json`, `manifest.csv` |
| 3 | Text that already exists as text (SWPM markdown slides, FRNT class transcripts) | `scripts/compass/extract_extra.py`. Emails become `[email]`, personal names `[student]`. | same folder |
| 4 | Merge the two prep graphs into one seed list | `scripts/compass/build_seed.py` (PM graph from a saved copy of its page; consulting graph path in env `COMPASS_CONSULTING_JS`) | `seed_concepts.json` |
| 5 | Group pages into passages, shortlist 20 candidate ideas per passage (hand-written TF-IDF) | `scripts/compass/build_passages.py` | `work/passages_<GROUP>.json` |
| 6 | Tag passages. Claude Code sub-agents read each passage and its candidates and write: a summary, up to 4 tags with role and reason, up to 2 new ideas, an admin flag. | Brief: `scripts/compass/prompts/tagging_brief.md`. One agent per group (STRG, MKTG, OPMG, BANM a and b, SWPM, FRNT a and b). | `work/tags_<GROUP>.jsonl` |
| 7 | Build the dataset: align tags to passages, create ids for new ideas, de-duplicate them, attach Moodle links, drop student-made notes | `scripts/compass/build_dataset.py` | `public/compass-dev.json` (gitignored) |
| 8 | Write "What to know" for each taught idea | Brief: `prompts/explainer_brief.md`; 5 agents; then `scripts/compass/merge_know.py public/compass-dev.json ~/Downloads/compass-build/work/know` | adds `know` |
| 9 | Propose prerequisite links for new ideas that have none | Brief: `prompts/links_brief.md`; 4 agents; then `scripts/compass/merge_links.py public/compass-dev.json ~/Downloads/compass-build/work/links` | adds `rel` with `auto: true` |
| 10 | Upload | `supabase --experimental storage cp public/compass-dev.json ss:///compass/compass.json --linked --content-type application/json --cache-control "max-age=60"` | production bucket |

Run order for a refresh is 1, 2, 3, 5, 6, 7, 8, 9, 10 (step 4 only when the prep graphs change). Steps 8 and 9 must run after 7 each time, because step 7 rebuilds the file from scratch.

Known weak points in the pipeline:

- Tagging agents read only the first part of each passage (about 350 to 1,100 characters), and tags are limited to the 20 shortlisted candidates. For operations content the shortlist was weak, which is why OPMG produced many new ideas.
- Passage ids can collide (the file stem is truncated to 14 characters). `build_dataset.py` aligns tags to passages by order using per-id queues to survive this.
- BANM sessions 7 to 10 are mostly image-only slides and yielded little text. FRNT slides 2 to 5, 7 and 10 are covered by transcripts instead. A vision pass over image-only pages is not done.
- Transcripts for MKTG, OPMG, BANM and SWPM are in Google Docs and are not loaded.
- A sibling agent once overwrote another agent's helper file in a shared temp folder. Agents were told to use their own scratch folder; results were re-checked by count.

## 5. Code map

All Compass code is under `src/compass/`. The section is lazy-loaded from `src/App.tsx` and uses the app's existing Supabase client and router.

| File | Job |
|---|---|
| `CompassSection.tsx` | Shell: title, tab bar, "Show" switch, routes. Scrolls to the top when the path changes (not when only the query changes). |
| `lib/data.ts` | Types, lens definitions, `loadStore()` (downloads the file, builds a MiniSearch index, builds reverse links), `runSearch()` (ranks by score times course breadth, filters by lens). In dev it reads `/compass-dev.json` first. |
| `lib/topics.ts` | The 12 topics, module-to-topic rules, `topicOf`, `oneLine` (first sentence of an explainer). |
| `lib/graph.ts` | `neighbours` (up, down, same session), `coTaught` (ideas taught together in a session), `sharedSlide` (ideas on the same slide, max 6 per slide), `treeLayout` (top-to-bottom layered layout with wrapped rows), `reach` (all ancestors and descendants). |
| `lib/known.ts` | "I know this" store (`useSyncExternalStore` over `localStorage`). |
| `components.tsx` | Shared pieces: page title, section label, idea card, course chips. |
| `ConceptGraph.tsx` | The "How it connects" block on idea pages (plain layout, not a drawing). |
| `pages/Home.tsx`, `TopicsPage.tsx`, `CoursePage.tsx`, `PrepPage.tsx`, `ConceptPage.tsx`, `ComparePage.tsx`, `RoadmapPage.tsx`, `MapPage.tsx` | One per route. |
| `compass.css` | All styles, scoped under `.compass` so nothing leaks into the rest of the app. Uses the app's colours and fonts (serif titles with an italic word, uppercase section labels, white cards). |

Other touched files: `src/App.tsx` (route inside the `RequireAdmin` group), `src/components/Sidebar.tsx` (item shown only to admins and not in demo), `package.json` (adds `minisearch`), `.gitignore` (`public/compass-dev.json`), `supabase/migrations/20261015120000_compass_private_bucket.sql`.

### How the map works

- **Grouping:** by topic or by course (`?by=course`). Each group is a coloured block with a header; clicking a header opens just that group. Ideas appear once, under their first course when grouped by course.
- **Layout:** `treeLayout` puts prerequisites on top and what they lead to below, wrapping wide layers into several rows (4 per row in "all", 9 in one group). Ideas with only weak links (shared slide) are placed beside the idea they were taught with. Ideas with no link at all sit in a "Not linked to other ideas yet" row inside their block.
- **Edges:** solid for prerequisites (`rel`), dashed for shared-slide links (drawn only for ideas that have no prerequisite link). Cross-group links are drawn across blocks.
- **Selecting an idea:** `reach()` over all links highlights everything it builds on (amber) and everything it leads to (blue) and dims the rest, including across groups. A slide-over panel shows the explainer line, courses and sessions, how many courses and topics it touches, learn first, leads to, often taught together (2+ shared sessions), and buttons for the full page and "I know this". Links to ideas in another group carry a small tag with that group's name. "Show only this chain" redraws the map with just the chain.
- **Moving around:** drag to pan, +, − and Fit buttons, Ctrl or Command plus scroll to zoom. Plain scroll still scrolls the page. Esc closes the panel.

Things tried and dropped: a force-directed layout (an unreadable blob), a left-to-right layout with a fixed right-hand panel (cut the map short), and a drawn mini-graph on idea pages (labels overlapped and were truncated; replaced with the plain layout).

## 6. Access, security and operations

**Who can see it:** `RequireAdmin` wraps the route (non-admins are redirected to `/tracker`). The sidebar item is hidden unless `user.is_admin` and not in demo mode. The storage policy `compass dataset readable by admins` lets only admin accounts read bucket `compass`. Nobody can write through the API; uploads use the CLI.

**Checked on 15 Oct:** a signed-out request to the file's public, plain and authenticated URLs returns "bucket not found" or "authorization header required". Not yet checked: an actual admin session in production, and a student session being redirected (see the handoff checklist).

**Give a tester access:** set `is_admin = true` on their row in `public.users`. This also grants every other admin feature, so prefer short-lived access.

**Open it to all students later:** change the policy to `to authenticated using (bucket_id = 'compass')` in a new migration, and move the `/compass/*` route out of the `RequireAdmin` group in `src/App.tsx`. Remove `RoadmapPage.tsx` first.

**Refresh the data:** rebuild the file (section 4), then upload with the same command. The app caches for 60 seconds. To roll back, upload the previous file (keep a dated copy of each upload), or revert the route.

**Rules that must keep holding:**

- Apply Supabase migrations only with the CLI (`supabase db push`), never in the dashboard.
- Never paste the Moodle cURL or key into chat. The cURL file holds a session cookie as powerful as a password. Log out of Moodle and delete `curl.txt` and any `.rtf` copy after fetching.
- Raw course files, extracted text, transcripts and the build folder stay out of git, logs, analytics and chat.
- Slides are never hosted or quoted. If quotes are ever added they need faculty approval and a setting to switch them off.

## 7. Quality: what has and has not been checked

Checked:

- Dataset integrity on the final file: no link points at a missing idea, no unknown course or session, no duplicate titles among taught ideas, every taught idea has an explainer, every session has Moodle links except one FRNT session. Two prerequisite loops exist; the layout caps them.
- Every route and about 40 idea pages open without console errors (the 401 and 404 messages in demo mode come from the demo's fake client).
- A sample of 24 evidence rows early on: mostly right, a few weak.
- Explainers were screened for banned words and for mentions of professors, slides or sessions. Four were read in full. They were not fact-checked one by one.

Not checked:

- **Formal tag accuracy.** Take a random 100 evidence rows, mark each correct, partly or wrong, and compare to the 90% target. Not done.
- The 191 AI-suggested links, the topic assignments and the 171 new ideas (merge near-duplicates, rename awkward titles).
- Explainer facts beyond a small sample.
- The map on a real wide desktop screen after the final changes, and on a phone (the PRD says desktop only; the panel covers the whole map on phones).
- Usage: nothing is logged. There are no PostHog events for Compass yet.

## 8. Known limits to tell reviewers

- Six courses from one cohort. Terms 5 to 7, other campuses and years are not loaded.
- Idea summaries are AI-written; some links are AI-suggested and unverified.
- "Frameworks" is not a field in the data, so you cannot yet filter by framework. Cross-linking works by topic and course.
- No sign-in design, viewer, reporting, privacy tooling or quality gates yet. Those are the PRD's must-haves for launch.
- Hosting is the existing Supabase project, not an ISB-owned tenant.

## 9. Backlog, in suggested order

1. Add PostHog events (search, idea open, map node click, group switch, "I know this", panel open) so reviewers' use can be measured. Follow how the rest of the app captures events.
2. Run the formal accuracy sample and fix the worst tag patterns.
3. Review and merge the 171 new ideas; verify or drop the 191 AI links; hand-check topic assignment.
4. Tag which ideas are frameworks so the map and tables can filter by framework.
5. Load the missing sources: transcripts for MKTG, OPMG, BANM and SWPM; a vision pass for image-only BANM sessions 7 to 10.
6. "My frontier": from the "I know this" ticks, show ideas whose prerequisites are all known (the professor's graph has this).
7. A report-a-problem button on every idea and link, writing to a table reviewers can read.
8. Decide the hosting path with ISB IT (see the PRD asks) and plan the move off the shared Supabase project.
9. Add demo data if Compass should appear in the recruiter demo.

## 10. Gotchas learned

- The main app's TypeScript is stricter than the prototype's: type imports need `import type`, unused variables fail the build.
- A sparse array spread into `Math.max` returns NaN, which silently collapsed the first map. `treeLayout` uses `Array.from` for this reason.
- The page scrolls on the window, and React Router does not reset scroll, so each page change needs an explicit scroll to top.
- The in-app preview pane is narrow (about 550 px), so it shows the phone layout. Resize it to see desktop. A pane resized to 1440 can render tiny until reloaded.
- Demo mode (`/demo`) swaps in a fake Supabase client, so Compass cannot load data there and is hidden.
- Dev data: put the built file at `public/compass-dev.json` (gitignored) and `npm run dev`; the loader uses it before trying the bucket. Port 5174 is pinned for Supabase login redirects.
- Use `supabase --experimental storage ...`; the storage commands refuse to run without the flag.
