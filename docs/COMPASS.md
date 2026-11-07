# Compass: the complete guide

Last updated 5 Nov 2026, when the MVP went live for admins. This file replaces the earlier engineering spec, the POC guide and the research plan, which remain in git history. For the current status and next steps, read [COMPASS_HANDOFF.md](COMPASS_HANDOFF.md).

## 1. What Compass is

Compass is an ISB-only tool that answers from what ISB taught. A student asks in plain words and gets a short card: what the idea is, when to use it, what to watch out for, where it was taught, and a link to that class in Moodle. If the material doesn't cover the question, the page says "Not in our material yet".

**The long-term goal:** a gated thinking partner that students can come back to for anything they learned at ISB, including after they leave. Exams and interviews are the first uses, not the only ones.

**The MVP today:** an Ask page inside the existing app at `/compass`, covering 6 of 138 courses. Admins are the only testers for now.

| What | Status |
|---|---|
| Courses loaded | 6: Strategy, Marketing Management, Operations Management, Business Analytics for Marketing, Software Product Management, Frontier Technologies |
| Cards shown | 347 of 440 ideas |
| Who can open it | Admins only (`users.is_admin`) |
| AI at question time | None. Search and the decline decision run in the browser |
| Running cost | Nothing beyond the existing Supabase and Vercel setup |

## 2. The rules

These came from product decisions and should hold unless Eshan changes them.

1. **No AI writes anything when a student asks.** A card is written once at build time, and every student sees the same one.
2. **Every card sentence is written only from class material.** It cites its source passages and has to pass a check against them. No outside knowledge is allowed, even if it's true.
3. **A card that can't pass is held back.** A missing card is better than a thin or wrong one. Empty "When to use it" and "Watch out for" sections are fine.
4. **No slide text reaches students in the MVP.** Slides open in Moodle, where ISB's own permissions and name stamp apply.
5. **Raw files, extracted text, transcripts and the build folder never go into git, logs or analytics.**
6. **A Moodle session cookie or key is as powerful as a password.** Never paste one into chat, commit it or sync it.
7. **Supabase migrations go through the CLI only**, never the dashboard.
8. **Accuracy work starts from real student questions or tester reports**, not from the self-written test set. That rule exists because tuning against our own questions stopped moving the product forward.

**The honest limit:** cards are AI-written and machine-checked, so a small number of mistakes can still get through (section 6). Each card can be corrected once for everyone, and the source is one click away.

## 3. What the user sees

| Route | What it is |
|---|---|
| `/compass` | The Ask box. With a question, it shows the answer card, then up to 2 "Not quite it? Try these" cards. With none, it shows the browse options |
| `/compass/c/:id` | Idea page: the checked card, how it connects, where it was taught. Held-back ideas show no card text |
| `/compass/topics`, `/compass/courses`, `/compass/prep`, `/compass/map`, `/compass/compare` | Browse by topic or course, Product and Consulting prep kits, the map, and the across-courses table |
| `/compass/roadmap` | Reviewer-only pitch page, not in the tab bar. It's out of date. Remove it and the "Pilot preview" note in `Home.tsx` before opening to students |

The Report a problem button takes two taps: "Wrong topic", "Something is wrong" or "Hard to understand".

## 4. How it works

**At build time, per course:**

```
Moodle and course files -> extract and clean -> passages -> AI tags ideas
    -> Sonnet writes cards -> software check -> Haiku fact check -> Haiku clarity check
    -> one rewrite of unclear cards -> re-check -> Haiku writes likely questions per card
    -> data file -> private Supabase bucket
```

**When a student asks, all in the browser:**

1. If the question names one course and asks about a session, class or coverage, results are limited to that course. For example: "What did OPMG session 10 cover?"
2. MiniSearch, a small keyword search library, searches each card's title, other names, text and likely questions, with light word-stemming. It uses typo-tolerant matching only when exact matching finds nothing.
3. A small formula decides whether to answer or decline. It uses the match score, how many of the question's words are on the card, and whether the course rule applied. Its numbers are fitted at build time and stored in the data file.
4. The page shows the top card, or the decline message with the closest ideas.

### Where things live

| Thing | Location |
|---|---|
| App code | `src/compass/`. The answer flow is `lib/ask.ts` and `pages/AskAnswer.tsx`, and the data loader is `lib/data.ts` |
| Pipeline | `scripts/compass/`: `card_pilot.py` (cards), `search_baseline.py` (inventory, index, search tests), `eval_ask.mjs` (runs the app's real search), plus the older extraction and tagging scripts |
| Agent instructions | `scripts/compass/prompts/`: `card_brief.md`, `agent_steps.md`, and the older tagging brief |
| Test questions | `scripts/compass/eval/questions.csv` (60) and `decline_questions.csv` (30) |
| Live data | Supabase project "Pulse of isb", private bucket `compass`, object `compass.json`, about 1.5 MB. Rollback copy: `compass-backup-2026-11-05.json` |
| Build folder | `Compass-build-private` at the top of Eshan's ISB OneDrive. `~/Downloads/compass-build` is a shortcut to it, so scripts use that path |
| Python tools | `~/.local/share/compass-venv` on Eshan's Mac, outside OneDrive. To rebuild: `uv venv --python 3.12 <path>`, then `uv pip install --python <path>/bin/python torch sentence-transformers numpy` |

### The data file

`compass.json` has `meta`, `courses` (sessions and Moodle links), `concepts` (the idea graph), `cards` and `declineRule`. Each card has `id`, `title`, `aliases`, `what`, `use`, `trap`, `where` and `questions`.

It deliberately excludes slide text, the old unchecked explainers, the old AI summaries and the 191 AI-suggested links. `concepts` still carries two things that aren't card-checked: the AI session tags behind "where taught" on idea pages, and text from the Product and Consulting prep graphs.

### Usage events (PostHog project 596443)

| Event | Properties | When |
|---|---|---|
| `compass_ask` | `q` (first 60 characters), `declined`, `card` | 0.8 seconds after typing stops |
| `compass_source_click` | `card`, `course`, `session` | Moodle link on the answer card |
| `compass_report` | `card`, `reason`, `q` | Report a problem |

Reports go to PostHog because that needed no new database table. Look there for them.

**Question privacy:** the question is kept in browser history, not the page address, because PostHog records addresses automatically. Only the first 60 characters go to PostHog, through these events. The trade-off is that a question can't be shared as a link. A few events from before this fix, on 5 Nov and earlier, still hold full question text in their page addresses.

## 5. How to run it

Run commands from the repo root. Commands that use models or fit the rule need `~/.local/share/compass-venv/bin/python`. Everything else works with plain `python3`.

### Check the app's search

```bash
~/.local/share/compass-venv/bin/python scripts/compass/card_pilot.py browser_rule
```

This runs `src/compass/lib/ask.ts` on `questions.csv` (60) and `decline_questions.csv` (21), not the Moodle sets, prints the scores and refits the decline formula. On 7 Nov the formula was also refit on all 162 questions (126 answerable in `questions*.csv`, 36 unanswerable in `decline*.csv`), and again with extra signals such as the gap between the top two scores. Neither beat the live formula, so it was left alone. Keyword scores are the limit. When a question's wording is far from the card, the top score is low whether or not the card is right. It also rewrites `public/compass-dev.json` (gitignored) and `compass-v2.json`, which the app reads in local dev.

### Replace the live data file

The storage tool can't overwrite a file, so rename the old one first. Run this from the main checkout, which is the one linked to Supabase, and use today's date. It's a production change, so get Eshan's yes.

```bash
supabase --experimental storage mv ss:///compass/compass.json ss:///compass/compass-backup-YYYY-MM-DD.json --linked
```

```bash
supabase --experimental storage cp ~/Downloads/compass-build/phase_a/pilot/compass-v2.json ss:///compass/compass.json --linked --content-type application/json --cache-control "max-age=60"
```

Check that the upload output doesn't show an error, because the tool can fail without stopping a script. Admins may see "could not load" for a few seconds during the swap. Merge code changes before uploading data that depends on them.

### Roll back

Rename the bad file aside, then copy the backup into place:

```bash
supabase --experimental storage mv ss:///compass/compass.json ss:///compass/compass-bad-YYYY-MM-DD.json --linked
```

```bash
supabase --experimental storage cp ~/Downloads/compass-build/phase_a/pilot/compass-prod-backup-2026-11-05.json ss:///compass/compass.json --linked --content-type application/json --cache-control "max-age=60"
```

That backup holds the old October data, so only use it if nothing newer works. Reverting the merge undoes code changes, and Vercel redeploys.

### Add a course or refresh content

This works in small batches. Labelling 40 ideas took about 2% of the 5-hour limit on the Max plan.

| # | Step | How |
|---|---|---|
| 1 | Get files and extract text | `moodle_state.py`, `extract_slides.py`, `extract_extra.py`. Files with leak hits fail |
| 2 | Make passages and tag ideas | `build_passages.py`, then agents with `prompts/tagging_brief.md`, then `build_dataset.py` |
| 3 | Set the idea base | Copy the file `build_dataset.py` wrote to `~/Downloads/compass-build/phase_a/compass-dev.json` |
| 4 | Build the search index | `search_baseline.py inventory`, then `search_baseline.py index` |
| 5 | Prepare a batch | `COMPASS_WAVE=N python3 scripts/compass/card_pilot.py prepare`. Use a new N each time. It picks 40 ideas with no card yet |
| 6 | Write | Agents follow WRITE in `agent_steps.md` for parts 0 and 1 |
| 7 | Software check | `COMPASS_WAVE=N ... check`. It adds hidden test sentences to the fact check |
| 8 | Fact check | Agents follow FACT for parts 0 and 1 |
| 9 | Clarity check | `COMPASS_WAVE=N ... clarity`, then agents follow CLARITY |
| 10 | Rewrite unclear cards | `COMPASS_WAVE=N ... rewrite`, then REWRITE, then `check` again, then FACT with N=2 |
| 11 | Combine | `card_pilot.py final` |
| 12 | Add likely questions | `card_pilot.py intent`, then agents follow INTENT |
| 13 | Build the data file | `card_pilot.py export`, then `add_acronym_aliases.py in.json out.json` (adds "NPV" for "net present value" and the reverse, and drops nothing; export would erase them otherwise), then `browser_rule` |
| 14 | Review and upload | People sample the cards, then replace the live data file as above |

Agents must report counts only and never print course text. Keep the Moodle file (`curl.txt`) out of OneDrive, and log out of Moodle and delete it after fetching.

### Access

**Give someone access today:** set `is_admin = true` on their row in `public.users`. This also opens every other admin feature.

**Open it to all students later:** widen the read policy in a new migration to `to authenticated using (bucket_id = 'compass')`, move the `/compass/*` route out of the `RequireAdmin` group in `src/App.tsx`, change the sidebar item in `src/components/Sidebar.tsx`, and remove the reviewer page.

### Take down a course

There's no tool for this yet. A takedown today means rebuilding the data file without that course and replacing the live file, or rolling back. The plan promises under 5 minutes, so this needs building before any wide launch.

## 6. Results so far

All of these use self-written test questions, so treat them as an upper bound. Real student questions haven't been tested yet.

**The app's live search, on 50 answerable and 40 unanswerable questions:**

| Measure | Result |
|---|---|
| Right session on the first card | 35 of 50 |
| Right session in the top 3 cards | 43 of 50 |
| Unanswerable questions declined | 38 of 40 (cross-validated) |
| What students would see for the 50 answerable | 28 right, 8 wrong, 14 declined |

"Right" means the card comes from the expected course and session. It doesn't prove the card answers the question.

**Card quality:**

| Measure | Result |
|---|---|
| Cards shown | 347 of 440 |
| Held back | 93: 77 not enough material, 11 failed checks, 5 still unclear |
| Cards by course (a card can count twice) | Frontier 90, Business Analytics 86, Software Product 77, Marketing 48, Strategy 41, Operations 16 |
| Planted false sentences caught by the Haiku checker | 71 of 73 |
| Real sentences the checker reversed on a second read | 2 of 40 |
| Review by people | Eshan reported the review done on 5 Nov. Its sample size and error rate aren't recorded |

The clarity check is less reliable than the fact check. It holds back some good cards and hasn't been tested with planted examples. The final clarity pass was dropped after the pilot for that reason, so rewritten cards from batches 1 to 11 weren't clarity-checked a second time.

## 7. What we tried, and why it went this way

| Tried | Result | Decision |
|---|---|---|
| Show exact slide passages | Eshan found them unusable: weird language, stray symbols, nothing to take away | Write cards at build time. This changed the rule from "word for word from source" |
| The 440 October explainers | Written partly from general textbook knowledge, with no citations. In a rough check, 33% of sentences sat close to their own sessions | Rewrite from source only |
| Embeddings (BGE-M3) | On a slide-passage test, no overall gain over keywords. On cards, keyword search in SQLite scored 40 of 50 first card, against 41 with embeddings | Not in the MVP. Retest on real questions |
| Questions per card | First card rose from 30 to 36 of 50 | Kept |
| Course and session rule | "Find a session" questions rose from 1 to 6 of 6 | Kept. It was added after seeing failures, so it may flatter the test |
| Re-scorers | The large one took 7.3 seconds on 2 threads. The small one lowered ranking but helped declining | Neither is in the MVP |
| "Absent terms" decline signal | Added nothing | Dropped |
| A server (Oracle Always Free or a VM) | Not needed for this search | Later, only if embeddings earn it |
| Paid API for writing cards | About ₹150 to ₹500 estimated, but the subscription handled it, using 11% to 39% of the 5-hour limit and 53% to 57% of the weekly limit | Subscription for the 6 courses. Revisit at full scale |

**Worth knowing:** the app's MiniSearch scores lower than SQLite's search did, at 35 against 40 of 50 first card. The likely causes are stemming and scoring differences. If real questions show the same gap, try better stemming before bringing back embeddings.

**Why no chatbot:** students need answers they can trust and check. Written answers at question time can invent things and cost money per question, and they would risk repeating faculty text.

## 8. Limits to tell reviewers

- Only 6 of 138 courses, from one cohort and mostly one section.
- Cards are AI-written and machine-checked, with one review by people so far. Repeat the review for each release.
- Wrong first cards are common for how-to and situation questions, which matters most for the thinking-partner goal.
- Moodle links only open for students enrolled in that course.
- Thin source material leaves gaps. Operations has few cards, and some taught ideas are held back as "not enough material", partly because transcripts for MKTG, OPMG, BANM and SWPM aren't loaded.
- Written permission to use the Product Management graph in prep kits is still outstanding.
- Hosting is the shared Supabase project, not an ISB-owned one.

## 9. Gotchas

- The app caches itself. After a deploy, an open tab or installed app can keep showing the old version until it's fully closed and reopened. PostHog showed the first admin test ran on the old page.
- `git fetch` can print a lock error when worktrees share refs. Check the ref before assuming it failed.
- A shell script's `tail` can hide a failed upload. Read the tool's output.
- Local dev needs an environment file. For demo mode, placeholder values work: open `/demo`, then `/compass`. Compass is hidden from the demo sidebar, but the route loads `public/compass-dev.json` in dev. Use real typing when testing inputs, because an earlier spacebar bug didn't show up when questions were put straight into the address. The demo's guard on outside links also blocks real Moodle clicks, so `compass_source_click` can't fire from a normal click in demo mode.
- `src/lib/demoClient.ts` fakes the database for the recruiter demo, so any new table or RPC needs demo data.
- The phone bottom nav is full, so don't add a sixth item.
- The map isn't designed for phones.
- Writing style for all copy and docs: plain English and no filler.

## 10. Claude connector pilot

Admins can add Compass to their own Claude as a custom connector. Claude calls one read-only tool, `search_compass`, and writes the reply from what comes back. Their Claude plan pays for the AI. We pay only for the function, and ISB's data stays behind the same login and admin check.

**What's different from the app:** Claude writes the final words, so the "no AI writing at question time" rule can't be enforced here. The tool returns only checked cards and Moodle links, and tells Claude to cite them and to say when nothing matched. Claude can still blend in its own knowledge, so the app remains the strict version. Cards also enter the admin's Claude account, where we don't control retention or training settings. Get ASA's written OK for this before opening it past admins.

**How it fits together:**

| Piece | File | Job |
|---|---|---|
| Function | `supabase/functions/compass-mcp/index.ts` | Checks the token and admin flag, applies 100 searches a day, loads the card file, logs |
| Search | `supabase/functions/compass-mcp/compass.ts` | Runs the same `ask.ts` as the Ask page, so the ranking matches. Where the Ask page declines, the tool returns the nearest cards with `match: "closest"` and Claude filters them, because the decline formula throws away broad questions like "how to build a healthcare product" even when the right course is in the top 3. The tool also takes `also_try` (up to 3 other wordings); each is searched alone and the rankings are merged (`askMany` in `ask.ts`), up to 5 cards. Defines the tool |
| Approval page | `src/pages/OAuthConsent.tsx` | Approves only Claude's two callback addresses, and only for admins |
| Database | `supabase/migrations/20261105150000_compass_connector.sql` | Search log (first 60 characters only) and the token block below |

**The miss log:** each search row also records `outcome` (`good`, `closest` or `none`) and `phrasings` (how many `also_try` rewordings Claude passed). Only the function can read the table, so run this in the Supabase SQL editor or through the CLI once a week, then turn the repeats into aliases, new cards or test questions:

```sql
select question, outcome, count(*) as times
from compass_connector_log
where at > now() - interval '7 days' and outcome in ('closest', 'none')
group by question, outcome order by times desc;
```

Questions are cut at 60 characters. The rewordings are not stored. Searches Claude never sent to the connector are invisible here.

**The token block:** a Supabase connector token carries the user's normal database rights, and its scopes don't limit that. So every public table and all file storage has a restrictive rule refusing any token with a `client_id`. Normal logins have none and aren't affected. **Any table added later needs the same rule**, and this must be automated before students get access. What the rule can't cover: database functions that run with their own rights (admin stats and pulse results), and the user's own auth profile. Only Claude's callbacks can obtain a token, and Claude holds it outside the chat, so this is acceptable for admins. Review it before students.

**Setup, in this order** (the block must be live before sign-in is switched on):

1. `npx supabase@latest db push` for the migration, after checking `supabase db push --dry-run` lists only this one.
2. `npx supabase@latest functions deploy compass-mcp --no-verify-jwt --use-api`. The flag is needed because the function checks tokens itself and must answer the first signed-out request. Then confirm `https://ujnrgvmbahbepdnahtle.supabase.co/functions/v1/compass-mcp/oauth-protected-resource` reports that same address, not a doubled path.
3. Merge the pull request so the approval page is live.
4. In the Supabase dashboard, under Authentication > OAuth Server: turn it on, set the path to `/oauth/consent`, and allow dynamic registration. Set Authentication > URL Configuration > Site URL to `https://isb-academics.vercel.app`, because Supabase sends the approval request to the Site URL plus that path.
5. In Claude: Customize > Connectors > Add > Custom > Web, with `https://ujnrgvmbahbepdnahtle.supabase.co/functions/v1/compass-mcp`. Under OAuth client, choose Register automatically. That's the option tested so far. Then turn it on in a chat from + > Connectors.

Don't use `supabase config push` from Supabase's guide. This repo has no `config.toml`, and a partial one could overwrite live auth settings.

**How people invoke it:** `/compass` if Claude lists the connector's prompt, or typing "Compass:" before a question. The tool's instructions tell Claude to search only then, or when someone names Compass or asks what ISB taught, and to answer in two labelled sections: "From ISB coursework" and "Beyond the course (Claude's own thinking)". These are instructions, not guarantees.

**The `/compass` skill:** the connector's prompt doesn't show in the Claude app's `/` menu (the connector page lists tools only), so `skills/compass/SKILL.md` is a skill that does. It checks that the connector is added, walks the user through adding it if not, then searches and answers in the two labelled sections with the Moodle, idea page and map links the connector returns. Each card result carries `idea_url` (`/compass/c/<id>`) and `map_url` (`/compass/map?node=<id>&focus=1`). To build the upload file: `cd skills && zip -r compass.zip compass`, then add it under Customize > Skills. A skill can't add a connector by itself.

**Merging doesn't deploy the function.** Vercel only ships the website, so re-run step 2 after any change to `supabase/functions/compass-mcp` or `ask.ts`.

**To switch it off:** turn off the OAuth Server in the dashboard, then delete the function. The block can stay.

**Not done, on purpose:** embeddings (start with keywords, since Claude can reword and search again; compare on real questions), a separate open-card tool (search already returns the whole card, and a lookup by ID would make copying easier), and access for non-admins.

## 11. Adding courses from Moodle

This is how Statistical Methods, Managerial Economics, Foundations of Finance and Financial Accounting were added in Nov 2026, from the 24 courses Eshan took. Eshan reports that ASA and ISB IT both approved bulk downloading from Moodle. Everything here stays in `Compass-build-private/moodle/`, outside git.

| Step | Script | Notes |
|---|---|---|
| 1. Download | `moodle_receiver.py <token>` plus `moodle_pull.js`, run inside a Chrome tab signed in to Moodle | No cookie file. The receiver only accepts requests from elearn.isb.edu with the token. The built-in browser pane blocks this, so use Chrome, in its own window. Re-running skips finished files |
| 2. Extract and sort | `COMPASS_LEAK_PATTERNS="<first name>" python3 moodle_extract.py` | Writes `moodle/extract/sorted.csv`. Sorting is a first pass. Course packs, company reports, cases, assessments and student lists stay out of cards |
| 3. OCR | `moodle_ocr.py`, same variable | For image-only slides. Strips the watermark before reading |
| 4. Passages | `COMPASS_PASSAGE_COURSES="SMDM,MGEC" python3 build_passages.py` | Writes to `moodle/work`, apart from the live build |
| 5. Tag | Agents follow `prompts/tagging_brief.md` | They must read full text: every agent cut corners until told not to |
| 6. Merge ideas | `moodle_cards.py ideas`, then an agent writes `merge_out.json` | Same idea in different words merges, sub-ideas stay apart |
| 7. Cards | `moodle_cards.py prepare N SIZE PARTS`, then the card_pilot steps with `COMPASS_PILOT_DIR=<build>/moodle/cards`, `COMPASS_WAVE=N` and `COMPASS_FACT_PARTS` | Don't run `card_pilot.py final` there, because it scores the live search |
| 8. Assemble | `moodle_cards.py assemble` | Applies people's edits in `manual_edits.json` and writes `cards_final.json` |

**The watermark:** Moodle stamps each file with the student's name, email and PGP batch, with extra letters scattered through to dodge searches. The extract step matches past those letters and fails any file with a trace left. Check the saved text again after any change to it.

**Other students' material:** never collect their cookies or logins. Each student runs the download on their own machine, or ISB provides a service account.
