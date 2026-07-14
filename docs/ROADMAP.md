# Roadmap — What's Built, What's Deferred, What's a Known Gap

Written to be read honestly. If something looks half-finished below, it's because it genuinely is, and it's listed here on purpose so the next person doesn't have to rediscover it.

## Built and live

- **Bidding Planner** — 4-step guided flow (Background → Goals → Your Plan → Bid Budget). Never recommends what to bid; shows credit progress against the student's own stated goals plus a personal bid-points ledger.
- **Multi-concentration support** (up to 2, per ISB's actual rule), single specialization + none/undecided.
- **Gating-course F-grade blocking** — 5 core courses whose F grade permanently closes a concentration, surfaced as a warning in the planner.
- **Term 2/3 Flexi Core tracking** — captures what a student already completed, since it counts toward concentration credit and wasn't being asked before.
- **Soft relevance tags** — "Matches your role (Product Management)" style badges based on work-ex domain/role and prior Flexi Core picks. Explicitly not a ranking or recommendation — informational only, per direct instruction.
- **Full course catalog** — 132 courses: 121 electives/Flexi Core (from ISB's official Concentration & Industry Specialisation doc) + 11 mandatory core courses (Term 1–4).
- **Admin panel** — Overview dashboard, course CRUD with soft-disable (never hard-delete), structured resource management (4-tab taxonomy), notice management (tags + pinning).
- **Course Resources** — single-page searchable/filterable gallery (not paginated per-term), course detail panel with dynamic tabs (only populated ones shown, max 4), full-screen toggle, admin-written descriptions so students don't have to click through blind.
- **Notice Board** — pinned-first feed, tagged (Urgent/Important/Info/General), text badges not color-only.
- **Real URL routing** for every page and sub-state — back/forward works, refresh doesn't reset your place, links are shareable.
- **Mobile-responsive** throughout — sidebar collapses to a drawer, long labels wrap instead of overflowing, rows stack instead of squeezing.
- **Admin-only preview gating** for Resources/Notices — real route guards, not just a hidden button (see [ADMIN_GUIDE.md](ADMIN_GUIDE.md) for how to launch these to everyone when ready).

## Deliberately deferred (discussed and cut, not forgotten)

- **A bidding-risk/points recommendation layer.** Early in this project's design phase, a "risk tier per elective based on historical bid demand" feature was seriously considered. Cut once it became clear no bidding has actually happened yet for this cohort — there's no real data to base it on, and self-reported crowdsourced data was judged likely to be structurally biased (only strong winners/losers bother reporting). Worth revisiting once real bidding cycles produce real data — see "Historical bidding data" below.
- **Semantic/AI-assisted search.** Current search on the Resources page is simple case-insensitive text matching across titles, course names/codes, and professors. An NLP chatbot that finds resources by natural-language question was explicitly named as a future direction, not built.
- **Custom GPT per course.** The original AAC vision (from the meeting that kicked off the "one-stop platform" idea) included per-course custom GPTs. Not built — but "Custom GPT" is now a resource type in the taxonomy, so once such a thing exists, linking it in is a 30-second admin task, not a schema change.
- **Student-submitted content / Contribute flow.** The Notion repo has a moderated "students submit PYQPs/notes" form. Not replicated here — would need a submission queue + admin approval step, genuinely separate scope from what's been built.
- **iframe embedding of resource links.** Suggested, considered, explicitly rejected: most real sources here (SharePoint/Atrium, Google Drive, Notion) send `X-Frame-Options`/CSP headers that block embedding, and there's no reliable client-side way to detect that failure before rendering a blank frame to a student. Links open in a new tab instead.

## Known data gaps — real, not hidden

- **Most Term 4+ elective professors show "TBD."** This is accurate, not a placeholder bug — ISB hadn't assigned faculty for most electives at the time the catalog was loaded.
- **A handful of course codes were ambiguous across ISB's own source documents** (e.g. "CDMA" vs "CDMA2", "CSOD" vs "CDOS" for the same course). One form was picked for each; flagged as worth a spot-check against Registro before this becomes the system of record students fully trust.
- **International exchange bid-point figures conflict between two ISB source documents** (one says 250 points, another says 400–1200 within the main pool). Never resolved — and moot for now, since **international exchange isn't modeled in the app at all.** Bidding Planner only covers regular elective/block-week bidding.
- **`prerequisite_course_ids` is essentially empty.** A pass through every Block Week 1 & 2 course outline found almost no real prerequisites — mostly "None" or informal text like "an open mind and a willingness to be challenged." The field exists in the schema for when/if that changes; it isn't populated because there was nothing real to put there.
- **`is_strategy_ob_course`** (for the Strategy & Leadership concentration's 2+2+2 split rule) is a schema field with no consuming logic yet — the credit-progress calculation doesn't currently enforce the split, it just counts total STLD-tagged credits.
- **Core course credit values beyond the two fractional ones (Written Analysis 0.6, Verbal Communication 0.4) are placeholder `1`** — not independently verified against an official credit-weighting document, since none was available at build time.
- **`bid_plan_entries.actual_points`** exists in the schema for a "log what actually happened after a real bidding round" feature. Never written to — no such logging flow was built.

## Historical bidding data — the bigger unlock, not yet pursued

ISB holds roughly 25 years of institutional bidding/enrollment data. Getting access requires a formal pitch to administration; this was scoped out during design (see the original design doc in `~/.gstack/projects/ISB/` if you have access to that machine) as valuable but not v1-critical, since a rules-based matcher works fine without it. If that data ever becomes available, it would meaningfully upgrade two things: (1) a real bid-risk-tier layer instead of the deferred idea above, and (2) validation of the hand-authored course-to-concentration tagging against what actually happened historically.

## If you're picking this up cold

Read `docs/ARCHITECTURE.md` and `docs/DATA_MODEL.md` first — they cover *why* things are shaped the way they are, not just what exists. Then check recent git log entries; commit messages on this repo were written to carry decision context (a fix, an explicit scope cut, a UX call and its reasoning), not just a summary of the diff.
