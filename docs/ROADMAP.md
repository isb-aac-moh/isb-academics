# Roadmap — What's Built, What's Deferred, What's a Known Gap

Written to be read honestly. If something looks half-finished below, it's because it genuinely is, and it's listed here on purpose so the next person doesn't have to rediscover it.

## Built and live

- **Bidding Planner** — 4-step guided flow (Background → Goals → Your Plan → Bid Budget). Never recommends what to bid; shows credit progress against the student's own stated goals plus a personal bid-points ledger.
- **Multi-concentration support** (up to 2, per ISB's actual rule), single specialization + none/undecided.
- **Gating-course F-grade blocking** — 5 core courses whose F grade permanently closes a concentration, surfaced as a warning in the planner.
- **Term 2/3 Flexi Core tracking** — captures what a student took (min 2, max 3 per term) and, if 3 were picked, which one is the mandatory conversion to elective. Corrected from an earlier version of this app that (wrongly) counted every completed Flexi pick toward credit — per ISB's "Flexi Core Courses" doc, only the mandatorily-converted 3rd course counts toward the 18 elective credits / concentration; the required 2 never do.
- **Term 1-3 excluded from bidding** — the "Your Plan" course picker only shows Term 4+ courses now; Flexi Core (Term 2/3) and core courses were never meant to be biddable ("there is no bidding involved in this process" — Flexi Core doc), but the picker used to let a student add a Flexi course to their bid-points plan.
- **Term-wise bid budget** — the Bid Budget step groups planned courses into per-term boxes against ISB's actual term-wise credit limits (Term 4/6: 3-4, Term 5/7: 3-5, Block Weeks: 1 each — Elective Bidding FAQ Q9), instead of one flat list. Requested by AAC.
- **Exchange bid-points self-report** — International/Inter-Campus Exchange draw from the same 4,500-point pool as regular bidding (FAQ Q4). The full Exchange flow isn't built (see below), but a student can log points already spent so the remaining-budget number stays honest. Requested by AAC — some students had already bid before Term 4 bidding opens.
- **Bid-points reserve math uses real credits** — the 100-pts-per-remaining-credit reserve rule now sums actual `courses.credits` (converted Flexi elective + planned bid entries) instead of a 1-entry-=-1-credit approximation.
- **Credit/points summary strip** — a compact "X/18 elective credits, Y points remaining" header, always visible across all 4 planner steps. A lean v1 of the "homepage dashboard" AAC asked for — see Deliberately deferred below for the fuller version.
- **Course outline links in "Your Plan"** — each course row checks the existing `resources` table for a `Course Outline`-type entry and shows a link if one exists. Populated for Term 1-3 and Block Weeks 1-2 (40 courses) from ISB's official ASA SharePoint (`CourseDetails/.../Course_Outlines`), per Eshan's preference over his personal OneDrive mirror — see `seed_course_outline_resources` migration. **Not yet verified**: whether a regular student login (not an ASA/Council account) can actually open these SharePoint links — worth a spot-check before trusting this cohort-wide. Term 4+ outlines aren't populated yet (weren't asked for).
- **Cross-listed course exclusivity** — per FAQ Q45, a course cross-listed across 2 of a student's target concentrations now only counts toward one. Defaults to whichever target concentration the student listed first; a picker appears on that course row once it's in the plan so they can override.
- **Soft relevance tags** — "Matches your role (Product Management)" style badges based on work-ex domain/role and prior Flexi Core picks. Explicitly not a ranking or recommendation — informational only, per direct instruction.
- **Full course catalog** — 132 courses: 121 electives/Flexi Core (from ISB's official Concentration & Industry Specialisation doc) + 11 mandatory core courses (Term 1–4).
- **Admin panel** — Overview dashboard, course CRUD with soft-disable (never hard-delete), structured resource management (4-tab taxonomy), notice management (tags + pinning).
- **Course Resources** — single-page searchable/filterable gallery (not paginated per-term), course detail panel with dynamic tabs (only populated ones shown, max 4), full-screen toggle, admin-written descriptions so students don't have to click through blind.
- **Notice Board** — pinned-first feed, tagged (Urgent/Important/Info/General), text badges not color-only.
- **Real URL routing** for every page and sub-state — back/forward works, refresh doesn't reset your place, links are shareable.
- **Mobile-responsive** throughout — sidebar collapses to a drawer, long labels wrap instead of overflowing, rows stack instead of squeezing.
- **Admin-only preview gating** for Resources/Notices — real route guards, not just a hidden button (see [ADMIN_GUIDE.md](ADMIN_GUIDE.md) for how to launch these to everyone when ready).

## Deliberately deferred (discussed and cut, not forgotten)

- **Full International Exchange page.** AAC asked for a dedicated page covering the actual exchange flow (49 partner schools, Preference Round, Bidding Round, allocation) — scoped out for now in favor of the lighter self-report fields above (see "Exchange bid-points self-report"). Eshan's own call: build the full page once the lighter version is live and tested.
- **Full "ISB journey" homepage.** AAC's ask was "a dashboard kind of structure... where they can see the progress and take decisions based on the overview." A lean credits/points summary strip shipped (see above), but the fuller vision — what decisions it should actually surface, whether it pulls in notices/deadlines, whether it becomes the new `/` route — needs real product thought, not a rushed build under bidding-window time pressure. Eshan's own words: "this is something we can do on a broader level."

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
- **Converting a Flexi-to-elective course further to Pass/Fail isn't modeled.** Per the Flexi Core doc, a student can convert their mandatory Flexi-to-elective conversion to Pass/Fail (subject to faculty permission, ~10% cap) — and once they do, "P/F course will not count to your elective credits (min 18)." The app has no notion of Pass/Fail at all right now, so `term2/3_converted_elective` is assumed to always count. A small edge case, not worth a schema field until someone actually hits it.

## Historical bidding data — the bigger unlock, not yet pursued

ISB holds roughly 25 years of institutional bidding/enrollment data. Getting access requires a formal pitch to administration; this was scoped out during design (see the original design doc in `~/.gstack/projects/ISB/` if you have access to that machine) as valuable but not v1-critical, since a rules-based matcher works fine without it. If that data ever becomes available, it would meaningfully upgrade two things: (1) a real bid-risk-tier layer instead of the deferred idea above, and (2) validation of the hand-authored course-to-concentration tagging against what actually happened historically.

## If you're picking this up cold

Read `docs/ARCHITECTURE.md` and `docs/DATA_MODEL.md` first — they cover *why* things are shaped the way they are, not just what exists. Then check recent git log entries; commit messages on this repo were written to carry decision context (a fix, an explicit scope cut, a UX call and its reasoning), not just a summary of the diff.
