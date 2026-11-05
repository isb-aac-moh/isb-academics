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

| Phase | Goal | Status |
|---|---|---|
| A. Prove it | Find out if this can work on 6 courses | Mostly done. Real student questions outstanding |
| B. MVP online | Testers use it behind ISB login | Live, with admins as the only testers |
| C. Full library | All 138 courses, transcripts, course packs | Not started beyond the 6 courses |
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

## What comes after the MVP

1. Use real questions and tester reports to decide what to fix. Better stemming comes first, and embeddings only if that isn't enough.
2. Export the four transcript sets and retry the 77 held-back cards.
3. Load more courses, which is the biggest gap to the end goal.

## Starter prompt for the next chat

```
Continue Compass in isb-academics. Read docs/COMPASS_HANDOFF.md, then docs/COMPASS.md.
Status since 5 Nov: [what changed].
I want to work on: [real questions | more courses | wider access | something else].
Rules: no AI writing at question time, keep course files and data out of git, use the Supabase CLI for migrations, never paste a Moodle cookie or key, ask before committing, pushing or changing production.
```
