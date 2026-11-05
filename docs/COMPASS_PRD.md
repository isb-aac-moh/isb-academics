# Compass: product requirements (PRD v2)

Version 2.0, 15 October 2026. Product owner: Eshan Jain, Academic Affairs Council (AAC). Status: for approval.

**Partly superseded, 5 Nov 2026.** The goal and long-term plan still stand, but the first release changed: cards written at build time, keyword search in the browser, no server and no hosted files. See [COMPASS.md](COMPASS.md) and [COMPASS_HANDOFF.md](COMPASS_HANDOFF.md) first.

This is a repo copy of the stakeholder PRD so it does not depend on a private link. The original is the private artifact https://claude.ai/artifact/2DVUcVLqxoatKC4h2SHTKc. 

## Summary

| | |
|---|---|
| What | One searchable, connected, cited memory of everything taught at ISB, built from ISB's own course material. Placement preparation is the first use; the design serves any purpose. |
| Cost | About ₹5.4 to 7.6 lakh a year for cloud and AI. People time is internal (AAC, faculty). |
| Timeline | Pilot by 10 Nov 2026. Full launch by mid-Jan 2027. Dates move with ISB IT turnaround and the placement calendar. |
| Proposed targets | 60% of searches reach a source within a minute. 95% of cited links verified correct. Zero content leaks. |
| Decision requested | Approve (1) an ISB-owned cloud environment in an India region, (2) official access to course files and transcripts, and (3) a faculty notice with opt-out. Everything else follows from these three. |

## Problem and opportunity

ISB has 138 courses and about 1,300 class sessions a year (estimate). The material lives in Moodle, SharePoint, personal drives and WhatsApp. Students forget what they were taught, cannot see how ideas connect across courses, and cannot find the right slide when they need it.

**Job to be done:** when I need to use something I was taught (an interview, an exam, a case, a project), help me find it and see how it connects, so I can use it with confidence.

**Demand signal:** last year's cohort built a shared drive by hand. It holds 1,316 unique files (about 6.5 GB) across 93 course folders on both campuses. That is proof of need, and a content-rights risk to replace with an official channel.

| User | What they need |
|---|---|
| Students (primary) | Find any taught idea fast, see where else it appears, open the source, prepare for a goal such as a role. |
| Faculty | See how their course feeds others; correct errors; withdraw content at any time. |
| AAC and Career Services | Build role kits; see which concepts are thin; aggregate view only. |
| ISB IT and legal | Content stays in ISB's control; every access is logged. |

## Scope

**Goals:** find any idea in under 10 seconds with its source; show human-verified links across courses; serve other purposes through saved views (lenses) without new code; protect ISB content; run with almost no upkeep once loaded.

| Priority | Requirement | Release |
|---|---|---|
| Must | M1 Sign-in with ISB Microsoft account only; roles; full audit log | 1 |
| Must | M2 Load of slides, outlines, ISB-authored course packs and transcripts for Terms 1 to 4, with provenance (course, campus, year, professor) | 1 |
| Must | M3 Concept graph with human-verified cross-course links, each with a one-line reason | 1 |
| Must | M4 Search: instant suggestions, typo and alias tolerant, words plus meaning | 1 |
| Must | M5 Concept page: where taught, connections, sources | 1 |
| Must | M6 Secure source viewer (no downloads, per-user mark), rate limits | 1 |
| Must | M7 Role kits for three roles: the tasks a role faces, the frameworks taught for each, where, and how they link | 1 |
| Must | M8 Report-a-problem, reviewer console, one-click unpublish per course | 1 |
| Must | M9 Privacy notice, minimal logging, deletion on request | 1 |
| Must | M10 Quality gates: sampled citation precision and search accuracy measured every release | 1 |
| Should | S1 Map of the whole graph (desktop) | 2 |
| Should | S2 Connector so a student's own ChatGPT or Claude can query Compass (read-only) | 2 |
| Should | S3 Faculty console: view, correct, withdraw | 2 |
| Should | S4 Course and session pages; compare the same course across campuses and years | 2 |
| Should | S5 Remaining role kits; Terms 5 to 7 and block weeks | 2 |
| Could | C1 In-app AI agent funded by ISB, grounded and cited, after usage data | 3 |
| Could | C2 Assessment mode: withhold a course's solutions during live graded work | 3 |
| Could | C3 No-code lens builder for clubs; alumni access; practice questions; Teams and Moodle plugin | 3+ |
| Won't | Elective recommendations or rankings; placement-outcome prediction; student uploads into the shared graph; individual-level dashboards for staff; audio or video hosting; a phone-friendly map | Not planned |

## Modules: what runs, with which tool

Where AI is used: almost all of it happens once, while building the knowledge base, and again for each new term. At runtime, version 1 needs one small embedding call per search and nothing else. Answers are assembled from stored, human-verified content with templates, so there is no generated text and no per-question cost.

| Function | Method | Tool or model | When |
|---|---|---|---|
| Read slides, PDFs, Word | Text extraction | PyMuPDF, python-pptx, python-docx | Load |
| Image-only slides, diagrams | Vision model on failing pages only | Multimodal model in ISB's cloud | Load |
| Clean transcripts | Fix errors, label speakers, anonymise students | Mid-tier language model, batch mode | Load |
| Split into passages | Slide boundaries, topic shifts; transcripts aligned to slides by order (no timestamps exist) | Embedding model plus simple rules | Load |
| Extract ideas | Concepts, frameworks, formulas, claims, with a fixed schema | Mid-tier language model, batch mode | Load |
| Merge duplicates across courses | Nearest-neighbour search, then a judge model, then a person | Embeddings, top-tier model, AAC reviewers | Load |
| Typed links with reasons | Judge model reads evidence, writes the one-line reason | Top-tier model, reviewer sample | Load |
| Verify | Second model of a different family checks each card against its sources; people check a sample | Top-tier model, AAC and faculty | Each release |
| Role kits | AAC and clubs define tasks; models suggest frameworks; reviewers confirm | Top-tier model, club coordinators | Load |
| Search | Keyword and meaning search combined; typo and alias tolerance | PostgreSQL full text, pgvector, trigram; one embedding call | Live |
| Concept page, role kit | Template over stored content | Application code, no model | Live |
| Map | Layout computed once, drawn in the browser | d3 and dagre libraries | Build, then live |
| Own-AI connector | Read-only tools over our API | MCP server; the student's AI does the talking | Live |
| Quality checks | Golden question sets, model judge plus human audit | Evaluation scripts | Each release |

### Acceptance criteria for the Must items

- **M1** A non-ISB account, and a signed-out request, receive nothing from any endpoint.
- **M2** Every passage shows course, campus, year and professor. Zero identity watermarks remain in stored text (automated scan).
- **M3** No cross-course "also taught in" claim is live unless a person verified it. Sampled link precision is at least 95%.
- **M4** On 60 real student queries, the right result is in the top 3 for at least 85%. Suggestions appear within 150 ms.
- **M5** At phone width, the first screen shows the title, a one-line definition, the count of courses and sessions, and the first source.
- **M6** No endpoint returns a whole file. A student cannot open more than 300 source pages a day.
- **M7** Each of three role kits lists at least 10 tasks, each with at least one framework, where it was taught, and a verified link.
- **M8** A reported problem reaches a reviewer the same day. Unpublishing a course takes under five minutes.
- **M9** A student can export and delete their activity from the app.
- **M10** A release cannot ship if either measure falls below target.

### Data model (eight objects)

| Object | Meaning |
|---|---|
| Source | A file or transcript, with course, campus, year, professor, rights status and a content hash. |
| Passage | A run of slides or transcript on one topic, in order, with its text. |
| Concept | A named idea, framework, formula or case, with aliases. |
| Relation | A typed link between concepts (builds on, applies, part of, contrasts, variant of), a one-line reason, evidence and a verified flag. |
| Cover | Which passage teaches which concept, and how deeply. |
| Lens | A saved view such as a role kit, defined as data. |
| Release | A versioned load that can be published or withdrawn as a unit. |
| User, role, audit event | Who did what, when. |

## Architecture

1. **Sources:** official feeds (Moodle, faculty files, transcripts).
2. **Load:** parse, clean, split. One time, then per term.
3. **Compile:** models extract and link; people verify.
4. **Core:** PostgreSQL and private storage in ISB's tenant.
5. **API:** search, concept, role kit, viewer.
6. **Doors:** web app, own-AI connector, later an agent.

Steps 1 to 3 use AI. Steps 4 to 6 run all year with no model except one embedding call per search. Loading is mostly one-time: a first full load, then a top-up each term. The volume is small (about 100,000 passages, a few thousand concepts), so one database handles search and graph together and no specialist graph or vector database is needed.

## Decisions (locked)

| # | Decision | Why | Not chosen |
|---|---|---|---|
| D1 | Hosting: an ISB-owned Azure subscription, Central India region, once ISB IT confirms it runs on Microsoft. | ISB's content needs ISB-held encryption keys, India data residency, audit and IT sign-off. ISB already uses Microsoft sign-in, SharePoint and Teams, so one tenant means fewer vendors and a faster review. Replaces the earlier Cloudflare R2 idea, which suits a pilot but not proprietary content. | Cloudflare R2 and Supabase for production content. AWS Mumbai only if ISB IT already runs there; the design ports. |
| D2 | Database: PostgreSQL (managed) with full-text, trigram and pgvector. | Search, graph and permissions in one place; scale is small. | A separate vector database; Neo4j; a managed search service. |
| D3 | Files in private storage with ISB-held keys; shown only through the viewer. | Stops casual leaks; every view is logged and marked. | Public links; downloads. |
| D4 | Sign-in with Microsoft Entra, ISB accounts only. | Same login students already use. | A separate password system. |
| D5 | Web app in React and TypeScript; API in containers that scale to zero; Python jobs for loading. | Matches the existing AAC app and skills; cheap when idle. | New frameworks. |
| D6 | Search: keyword plus meaning, merged by rank; one embedding call per query. | Covers "NPV" and "how much to order for seasonal demand" alike. | Keyword only; a language model per query. |
| D7 | Build AI: frontier models inside ISB's cloud, batch mode, no retention or training on ISB data. | Best quality for extraction and linking at about ₹1 to 3 lakh a year; content stays in the contract. | Public consumer APIs; training our own model. |
| D8 | No LangChain or LangGraph in version 1. Plain staged jobs with a status table and a review pause. | Ten sequential steps need no framework. Revisit if a live multi-step agent is added. | Agent frameworks. |
| D9 | No decision-model service at runtime (Jev or open-source). | Roles are picked from a list and search is a box, so nothing needs interpreting. Revisit if free-text goals appear. | Adding a model for its own sake. |
| D10 | Graph stored in tables; map layout precomputed; desktop only. | No graph database upkeep; the map loads fast. | Force-directed layouts; a phone map. |
| D11 | Own-AI connector is read-only and returns Tier 1 only: our concept cards, links and pointers. Never whole files; short quotes only with faculty approval. | Students' AI vendors sit outside ISB's contract. | Exposing files or bulk lists. |
| D12 | No in-app agent in version 1. Decide after eight weeks of usage data. | Cost and risk are real; value is unproven. | Building it first. |
| D13 | Official clean originals only. We do not strip student watermarks from copies. | The mark exists to trace leaks; removing it is not ours to do. | Hosting student-downloaded copies. |
| D14 | Course packs: host ISB-authored parts; third-party cases and readings link out. | Third-party publishers license cases to enrolled students only. | Hosting whole packs. |
| D15 | Transcripts: text only, student speakers anonymised, faculty consent first. | No audio means no re-run; text is enough for search and links. | Hosting audio. |

## Guardrails for proprietary content

What we promise: no leak beyond what a signed-in student could already see, no bulk copying, and every access traceable. We cannot stop a student photographing a screen, and an AI company a student chooses will see what that student's AI retrieves. That is why the connector returns Tier 1 only.

| Threat | Control |
|---|---|
| Anyone outside ISB | Microsoft sign-in restricted to ISB accounts; no public data endpoints; private network links to storage and database; web firewall. |
| A student copying at scale | Per-user daily limits; no download or list-everything endpoint; small page-level responses; anomaly alerts; honeytoken records that trace a copy to an account. |
| Screenshots of the viewer | A per-user mark (name, ID, time) on every page. This deters and traces; it cannot prevent. |
| Data at rest | Encryption with ISB-held keys; raw files kept immutable; backups with a tested restore. |
| AI vendor exposure | Models run in ISB's cloud tenant under enterprise terms; no retention, no training. Runtime sends no slide content to any model in version 1. |
| Prompt injection from source text | Concept cards are written and verified by us; source text is treated as data and never as instructions. |
| Student privacy | India's DPDP Act: notice, purpose limits, consent where needed. Search text is cut to 60 characters and linked to the user for 12 months, then deleted. Staff see aggregates of 10 or more students only. |
| Faculty withdrawal | Per-course unpublish in under five minutes, action logged. |
| Administrator misuse | Separate roles; admin actions logged; no raw export tool; quarterly access review. |
| Incident | Written runbook with a named contact at ISB IT and legal, and breach notification as the law requires. |

## Financials

People are internal, so cash cost is cloud and AI. Figures are estimates at ₹88 to the dollar; ISB should replace the cloud lines with its own quote.

| Item (per year) | US dollars | Rupees |
|---|---|---|
| Cloud run: database, containers, storage, firewall, keys, monitoring (about $285 a month) | 3,400 | ₹3.0 lakh |
| Build AI: one full compile plus two term refreshes | 1,500 to 3,300 | ₹1.3 to 2.9 lakh |
| Vision pages and transcript cleaning | 250 to 450 | ₹0.2 to 0.4 lakh |
| Search embeddings | under 50 | negligible |
| Contingency (20%) | 1,000 to 1,400 | ₹0.9 to 1.3 lakh |
| **Core total** | **6,200 to 8,600** | **₹5.4 to 7.6 lakh** |

| Optional or later | Cost |
|---|---|
| Independent security test (recommended before launch; ISB IT may do this in-house) | ₹4 to 9 lakh, once |
| In-app AI agent for about 800 students (decision after eight weeks of usage) | ₹3 to 10 lakh a year |
| Pilot phase on the existing AAC stack (no files, no transcripts) | about ₹2,200 a month |

Non-cash effort: AAC reviewers about 60 hours per release; faculty about 30 minutes per course to verify their page; ISB IT for the tenant, sign-in app and security review.

## Plan and gates

| Phase | When | Deliverable | Gate to proceed |
|---|---|---|---|
| 0. Pilot | Now to 10 Nov | Search, concept page and one role kit on outlines, concept names and pointers only. No files, no transcripts. Up to 50 students. | 60% search success; zero incidents |
| 1. ISB tenant and full load | Nov to mid-Jan | Tenant live; Terms 1 to 4 loaded; links verified; viewer; three role kits; cohort launch. | 95% citation precision; search top-3 at 85%; security review passed; faculty opt-out window closed |
| 2. Reach | Jan to Mar | Map, connector, faculty console, course pages, remaining role kits, Terms 5 to 7. | Weekly use steady; faculty-verified courses at 50% |
| 3. Decide and extend | Apr to Jul | Agent go or no-go; alumni access; next cohort loaded at orientation in July 2027. | Steering committee review |

Roles: AAC builds, reviews and runs; Dean's office sponsors and grants the content licence; faculty verify and may opt out; ISB IT provides the tenant, sign-in app and security review; Career Services supplies role and task input. A steering group meets quarterly.

## Metrics

| Type | Measure | Target |
|---|---|---|
| North Star | Students who open at least one source through Compass each week | 40% of the cohort in exam and placement weeks |
| Input | Searches that reach a source within 60 seconds | 60% or more |
| Input | Searches with no result | Under 10% |
| Quality | Sampled citation precision | 95% or more |
| Coverage | Term 1 to 4 courses with verified concept pages | 100% by January |
| Guardrail | Content leak incidents; time to unpublish; cost per active student | 0; under 5 minutes; under ₹1,000 a year |

## Risks

| Risk | Response |
|---|---|
| Faculty or publisher rights (course packs, transcripts) | Opt-out window; ISB-authored parts only; consent for transcripts; kill switch. |
| ISB IT lead time delays the tenant | Pilot on derived data only; no proprietary files outside ISB's tenant. |
| A wrong cross-course claim | Verified-only rule; sampled audits; report button on every link. |
| Transcripts are noisy and have no timestamps | Clean pass; align by order to slides; show passage, not time. |
| Source bias toward one section or campus | Every citation shows campus, year and professor; add more sources each term. |
| Low adoption | Links from Course Resources and Learn; example links in the launch note; fix zero-result searches weekly. |
| Key-person dependency in a student body | Runbook, documented pipeline, AAC handover each July. |

## Open items and asks

| Item | Owner | Needed by |
|---|---|---|
| Confirm ISB's cloud (Azure assumed) and open a subscription in an India region | ISB IT | 23 Oct |
| Register the sign-in app; schedule the security review | ISB IT | 6 Nov |
| Content licence and faculty notice with a two-week opt-out | Dean's office | 30 Oct |
| Official access to course files (read-only service account preferred) and transcripts | ISB IT, AAC | 6 Nov |
| Rights position on course packs and transcripts; student privacy notice | Legal | 30 Oct |
| Role and task lists for three roles; reviewers named | Career Services, clubs, AAC | 6 Nov |
| Placement calendar; written permission to use the Product Management graph | AAC | 23 Oct |

## How the POC relates to this PRD

The POC that is live for admins (see `docs/COMPASS.md`) is Phase 0 in spirit but built differently from the plan above: it already includes the map (S1) and a cross-course table, uses AI-written summaries instead of hosted files, runs on the existing Supabase project instead of an ISB tenant, and has none of M1 (Microsoft sign-in), M6 (viewer), M8 (reporting), M9 (privacy tooling) or M10 (quality gates). Its job is to let ISB IT, operations, administration and the AAC judge whether the full build is worth committing to.
