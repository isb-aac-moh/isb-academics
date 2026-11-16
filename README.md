# ISB Academics

The academic home for ISB PGP students (Co'27, Mohali). It started in July 2026 as a bidding planner. It now covers the whole academic year: tracking credits and grades, planning and sanity-checking elective bids, comparing courses before a bidding round, finding course material, revising for end-terms, and (in preview) asking Compass what ISB taught on a real problem.

**Mission:** learn it once, use it for life. See [docs/VISION.md](docs/VISION.md).

**Live:** https://isb-academics.vercel.app
**Repo:** https://github.com/isb-aac-moh/isb-academics (moved from `jain-eshan/isb-academics`; the old URL redirects)
**Owner:** Academic Affairs Council (AAC), Co'27. Built by Eshan Jain with Claude Code, with the Term 4 Dossier and Term 4 Bidding Q&A pages contributed by Vidhi Agarwal.

## The tools

| Tool | Route | What it does for a student | Who sees it |
|---|---|---|---|
| **Learn** | `/learn` | Study space for core courses: session notes, concept explainers, interactive widgets, adaptive "Smart practice" quizzes with mastery tracking, question banks and end-term revision guides. Live for MKTG, OPMG, BANM2 and MADM2. | Everyone |
| **Credit Tracker** | `/tracker` (home page) | What you actually got: elective credits secured out of 18, bid points left, concentration progress, grades and GPA. Asks "did you get this?" about planned bids once a term ends. | Everyone |
| **Bidding Planner** | `/planner/:step` | Five steps: Background, Goals, Plan, Your Term, Bid Budget. Shows courses against your chosen concentrations, workload and grading for the live round, and whether your points and credits add up. Never recommends what to bid. | Everyone |
| **Bidding Pulse** | `/pulse-check` | Students anonymously share a bid estimate per course during a live round. Everyone sees ranges and a small histogram once 5 or more people have answered. | Everyone |
| **Term Dossier** | `/dossier/term-5` | Every elective in a term side by side: grade split, exams, group rules, attendance, workload radar, faculty ratings, overview video, student feedback. Filter, compare up to 4, build a sample term. | Everyone |
| **Course Resources** | `/resources` | Searchable gallery of outlines, slides, PYQPs, notes and links per course, plus a directory of ISB platforms and AAC tools. | Everyone |
| **Term 4 Dossier / Bidding Q&A** | `/term4`, `/term4-bidding-qa` | Standalone pages from the Term 4 round, kept for reference. Linked from Course Resources. | Everyone |
| **Compass** | `/compass` | Ask a question in your own words and get short, checked cards on what ISB taught about it, from every loaded course, each linked to the class in Moodle. 22 courses so far. A Claude connector puts the same cards inside Claude. | Admins only (preview) |
| **Notice Board** | `/notices` | Pinned, tagged announcements from AAC. Built, not yet launched. | Admins only (preview) |
| **Admin** | `/admin/:tab`, `/learn/admin` | Manage courses, grading profiles, resources, notices, sidebar links, popups, the live bidding round and credit limits. Learn has its own admin for questions and study content. | Admins only |

Detail on each tool: [docs/PRODUCT.md](docs/PRODUCT.md). Learn in depth: [docs/LEARN.md](docs/LEARN.md).

## Why it exists

ISB runs elective bidding as a sealed-bid points auction: 4,500 points for the whole programme, a reserve rule of 100 points per credit still needed, term-wise credit limits, and concentrations that close permanently if you fail certain core courses. Before this app, students pieced decisions together from alums, WhatsApp threads and PDFs scattered across Atrium and SharePoint. AAC logged the same complaint every term.

The app puts a student's own goals, history and the live options on one screen so they can decide for themselves. It deliberately never tells anyone what to pick, and it never submits anything to Registro. Over time it absorbed the other things students kept asking AAC for: course material in one place, grading and workload information before bidding, and revision help before end-terms.

The wider problem is that a student's academic life is spread across about ten places, a class moves at one pace for people from very different backgrounds, and what was taught fades after the exam. Learn and Compass take on those last two. The full framing, adoption numbers and the gaps between the pitch and what's built are in [docs/VISION.md](docs/VISION.md).

## Quick start (local development)

```bash
npm install
cp .env.example .env.local
npm run dev
```

The dev server runs on http://localhost:5174. The port is fixed on purpose: it is the only localhost address allowed in Supabase's login redirect list.

Fill in `.env.local`. Ask Eshan for the values, or copy them from the Vercel project's environment variables:

| Variable | What it is |
|---|---|
| `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY` | The Supabase project. It is shared with `isb-explorer`, so the values are identical to that app's. |
| `VITE_PUBLIC_POSTHOG_PROJECT_TOKEN` | Product analytics. Required: the dev server throws an error at startup if it is missing. Any placeholder string works locally if you don't need events. |
| `VITE_PUBLIC_POSTHOG_HOST` | Optional. Defaults to `https://us.i.posthog.com`. |

Other commands:

```bash
npm run build     # typecheck (tsc -b) and production build
npm run lint      # eslint
```

There is no automated test suite. CI (GitHub Actions) runs lint and build on every pull request. Verification has been manual: a passing build, direct database queries, and checking the change in a browser. Commit messages record what was checked.

Local development talks to the **production** database. There is no staging project, so anything you save locally is real data.

## Tech stack, in one breath

React 19 + TypeScript + Vite, React Router 7, Tailwind CSS v4, Supabase (Postgres, Auth with Microsoft SSO, Row Level Security, Storage), deployed on Vercel with automatic deploys from `main`. Installable as a PWA. PostHog plus Vercel Analytics and Speed Insights for analytics. KaTeX for maths in Learn. No component library and no global state library.

Full picture: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Documentation map

| I want to... | Read |
|---|---|
| Know why it exists, who it's for, how it should sound and what we can prove | [docs/VISION.md](docs/VISION.md) |
| Understand every tool and the product rules behind them | [docs/PRODUCT.md](docs/PRODUCT.md) |
| Work on Compass | [docs/COMPASS_HANDOFF.md](docs/COMPASS_HANDOFF.md), then [docs/COMPASS.md](docs/COMPASS.md) |
| Understand the Learn section, its learning model and how content gets in | [docs/LEARN.md](docs/LEARN.md) |
| See the visual design, navigation and UI conventions | [docs/DESIGN.md](docs/DESIGN.md) |
| Understand how it is built: hosting, auth, routing, data flow, deploys | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |
| Look up a table, column, security policy or database function | [docs/DATA_MODEL.md](docs/DATA_MODEL.md) |
| Run the admin panel as a non-technical AAC member | [docs/ADMIN_GUIDE.md](docs/ADMIN_GUIDE.md) |
| Know what's been built, what's next, known bugs and data gaps | [docs/ROADMAP.md](docs/ROADMAP.md) |

`context-docs/` holds ISB's own source documents (Block Week bidding FAQ, the ASA bidding presentation, Programme Structure 2026-27) that the bidding rules in the app are based on.

## A note on how this was built

Built end to end with Claude Code, directed by Eshan Jain (ISB PGP Co'27, Academic Council). Every database change is a timestamped migration in `supabase/migrations/`, applied with the Supabase CLI to the shared production database. Commit messages explain why a change was made, and they are worth reading when a decision looks odd out of context.
