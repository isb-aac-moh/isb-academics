# Compass handoff: start here

Last updated 5 Nov 2026. This file says where things stand and what's next. Everything else is in [COMPASS.md](COMPASS.md).

## Document map

| File | Read it for |
|---|---|
| `docs/COMPASS_HANDOFF.md` (this file) | Current status, what's left, a starter prompt |
| `docs/COMPASS.md` | The full guide: product, rules, architecture, how to run it, results, decisions, gotchas |
| `docs/COMPASS_PRD.md` | The October stakeholder PRD. Partly superseded, but still the reference for the long-term plan, costs and ISB asks |
| [Private product map](https://claude.ai/artifact/4zecPFHu66FJsNwthtebDu) | The whole product on one page. Its hosting section still describes the later server option |

## Status

**The MVP is live for admins.** Pull requests [#64](https://github.com/isb-aac-moh/isb-academics/pull/64) and [#65](https://github.com/isb-aac-moh/isb-academics/pull/65) are merged, and the card file is in the bucket. A real admin sign-in produced 4 `compass_ask` events on 5 Nov, one of them a decline.

**7 Nov: search and connector changes** ([#76](https://github.com/isb-aac-moh/isb-academics/pull/76), merged and deployed). Search indexes course names. The connector returns labelled closest matches, accepts `also_try` rewordings, and logs `outcome` and `phrasings` (weekly query in [COMPASS.md section 10](COMPASS.md#10-claude-connector-pilot)). Still to do by hand: re-upload `skills/compass` and reconnect the connector in Claude. 94 acronym aliases ("Modigliani Miller" for the MM cards, "NPV" and the rest) are built by `scripts/compass/add_acronym_aliases.py` and live in the bucket since 7 Nov (rollback copy `compass-backup-2026-11-07.json`). Eighteen questions that were labelled unanswerable now have cards and moved into `questions_moodle.csv`. The decline formula was refit on all 162 test questions and with extra signals, with no gain, so it stays as it is. It hides about 16 of 89 correct first cards and shows 13 wrong ones on that set. The next lever is meaning-based ranking, or showing closest matches on the Ask page too, as the connector now does.

**6 Nov, later: 22 courses, 1,163 cards** ([#73](https://github.com/isb-aac-moh/isb-academics/pull/73)). 816 come from Moodle, with 153 held back. Previous file: `compass-backup-2026-11-06b.json`. Nobody has read a sample of the new cards yet.

**6 Nov: 10 courses, 590 cards.** Statistical Methods, Managerial Economics, Foundations of Finance and Financial Accounting were added from Moodle ([#71](https://github.com/isb-aac-moh/isb-academics/pull/71)), with 243 new cards. The live file was replaced on 6 Nov, and the previous one is `compass-backup-2026-11-06.json` in the bucket. Nobody has yet read a sample of the second card batch.

| Phase | Goal | Status |
|---|---|---|
| A. Prove it | Find out if this can work on 6 courses | Mostly done. Real student questions outstanding |
| B. MVP online | Testers use it behind ISB login | Live, with admins as the only testers |
| C. Full library | All 138 courses, transcripts, course packs | 22 courses, which is every downloaded course with usable material. 24 of Eshan's courses are downloaded and extracted (`moodle/`), so the other 14 can follow without another download. Pipeline in [COMPASS.md section 11](COMPASS.md#11-adding-courses-from-moodle) |
| D. Connections | Checked links across courses | Not started |
| E. Launch | Limits, watermark, takedown tool, paywall | Report button and usage events only |

## What's left for the MVP

Eshan called the MVP good on 5 Nov. Admins are the only testers for now, so no separate tester access is needed yet. He also reported the card review and ASA's written confirmation as done.

**One check left:** a real admin clicks **Report a problem** and a Moodle link on an answer card, then the builder confirms `compass_report` and `compass_source_click` in PostHog. Both fired in local testing, but neither has been seen in production.

**Eshan's cleanup:**

- Delete `~/Downloads/DELETE-ME-moodle-cookie-curl.txt` and log out of Moodle.
- Confirm `Compass-build-private` shows at onedrive.com, then delete `~/Downloads/compass-build-old-remove-after-sync`.

**In parallel, feeding accuracy work:** collect about 50 real questions from 10 students, including some near course topics that aren't actually covered.

**Before anyone other than admins gets access:** build Compass-only access, because the admin flag also opens every other admin feature.

**Before opening to all students:** remove the reviewer roadmap page and the pilot note, build the takedown tool, get written permission for the Product Management graph, and decide hosting with ISB IT.

## Claude connector pilot

For admins only. On 5 Nov the migration and the function went live, and connector tokens were confirmed refused on tables and storage. A real Claude sign-in worked, along with search, declines, the log and the 100-a-day limit. [#70](https://github.com/isb-aac-moh/isb-academics/pull/70) (ask before searching, labelled answers, `/compass`) is merged and deployed on 6 Nov. Whether Claude lists `/compass` is still to be checked in a new chat. Steps are in [COMPASS.md section 10](COMPASS.md#10-claude-connector-pilot). Before anyone beyond admins uses it: ASA's written OK, and the database rule that refuses connector tokens must apply automatically to new tables.

## Accounts

- **GitHub:** use `isb-aac-moh` for commits, pushes and pull requests. Until 6 Nov the GitHub CLI's active account was a personal one, so pull requests up to #71 show that account as their author. Check with `gh auth status`.
- **Vercel:** deploys come from the `isb-aac-moh` repository through the ISB AAC team.
- **Supabase:** the project "Pulse of isb" sits in a personal Supabase organisation, not an ISB AAC one, so migrations, uploads and function deploys run under that account. Moving it needs an ISB AAC Supabase organisation and a project transfer. That's a decision for Eshan, and it should be done before handing over.

## What comes after the MVP

1. Use real questions and tester reports to decide what to fix. Better stemming comes first, and embeddings only if that isn't enough.
2. Export the four transcript sets and retry the 77 held-back cards. Moodle had no transcripts.
3. Write cards for the next downloaded courses, Term 1 and 2 first. Relabel the old test questions on WACC, CAPM and double-entry, which are now answerable.
4. Search misses to fix: "customers who never pay" still finds willingness-to-pay cards, because the card says "allowance for bad debt". Aliases don't fix wording gaps like this, `also_try` does. "Modigliani Miller" is fixed by the acronym aliases.

## Starter prompt for the next chat

```
Continue Compass in isb-academics. Read docs/COMPASS_HANDOFF.md, then docs/COMPASS.md.
Status since 5 Nov: [what changed].
I want to work on: [real questions | more courses | wider access | something else].
Rules: no AI writing at question time, keep course files and data out of git, use the Supabase CLI for migrations, never paste a Moodle cookie or key, ask before committing, pushing or changing production.
```
