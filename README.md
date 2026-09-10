# ISB Academics

A web app for ISB PGP students to plan electives, Areas of Concentration, and bidding strategy — and, as it grows, a shared home for course resources and Academic Council announcements.

**Live:** https://isb-academics.vercel.app
**Repo:** https://github.com/jain-eshan/isb-academics
**Status:** Credit Tracker (default landing page), Bidding Planner, and Course Resources are all live to every student. Notice Board is still built but in **admin-only preview**. See [docs/ROADMAP.md](docs/ROADMAP.md) for what's next.

## What this is, in one paragraph

ISB runs elective bidding as a closed, sealed-bid, points-based auction (4,500 points, six phases, clearing-price rules) with real consequences: miss Phase 1 and you're locked out of that term entirely. Students were picking electives by asking alums and cross-referencing scattered PDFs on Atrium. This tool doesn't recommend what to bid — it never tells a student what to pick — it shows them where they stand against their own stated goals (which concentration/specialization they're targeting, what they've already completed, what's live to bid on right now) so the decision stays theirs, informed instead of guessed. Built for the Academic Council (AAC), initially to serve the current cohort's live bidding cycle, architected to serve future batches too.

## Why it exists (the actual context, not just the pitch)

- The Council has fielded a recurring, formally-logged complaint every term: students guessing at concentration/elective choices with no personalized guidance.
- Bidding is real-money-equivalent: 4,500 points, a hard reserve rule (100 pts/remaining credit), and Phase-1-or-you're-out stakes. Getting this wrong costs a term.
- AAC already runs a Notion-based resource repo (course outlines, PYQPs, professor profiles, a noticeboard) — this app is meant to eventually absorb and improve on that, not replace it overnight.

## Quick start (local dev)

```bash
npm install
cp .env.example .env.local   # fill in Supabase URL + anon key — see below
npm run dev                   # http://localhost:5174 (or whatever Vite picks)
```

**Where to get the env values:** this app shares a Supabase project with `isb-explorer` (the campus-life app, same cohort, same login). Ask Eshan for the project URL and anon key, or find them in `isb-explorer/.env.local` if you have access to that repo — they're the same values.

```bash
npm run build     # type-check + production build
```

There is no test suite yet — verification has been manual (build passing + direct Supabase REST queries + browser checks), documented per-change in git commit messages.

## Tech stack

- **React 19 + Vite + TypeScript**, no component library — Tailwind utility classes for layout, inline `style` objects with shared `COLOR`/`FONT` tokens (`src/lib/theme.ts`) for everything visual.
- **React Router v7** — real URL routing for every page (see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the route map).
- **Supabase** — Postgres + Auth + RLS. **Shared with `isb-explorer`**, not a separate project. One login covers both apps (`storageKey: "pulse-isb-auth"` in `src/lib/supabase.ts` is intentionally the same key isb-explorer uses).
- **Microsoft SSO** via Supabase Auth's Azure provider, gated to `@isb.edu` emails, with an email magic-link fallback.
- **Vercel** — **connected to GitHub for auto-deploy** (re-confirmed 2026-09-10 — this reverses the 2026-08-03 finding below; the connection was made sometime in between). Merging a PR to `main` triggers an automatic Production deployment via the `vercel[bot]` GitHub App — no manual `vercel --prod` needed on the normal path. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for two gotchas when you do need to deploy manually from a worktree. `vercel.json` has a catch-all SPA rewrite — without it, every route except `/` would 404 on refresh or direct load.
- **Installable as a PWA** — `vite-plugin-pwa` generates a manifest + service worker, so iOS/Android users can Add to Home Screen and get the ISB icon with no browser chrome. The service worker precaches the app shell (JS/CSS/HTML); Supabase API calls are never cached, so auth and live data are unaffected.

## Who can do what

- **Any `@isb.edu` login** → Credit Tracker (home page), Bidding Planner, Bidding Pulse, and Course Resources — everything except Notice Board and Admin.
- **`users.is_admin = true`** → also gets the Admin panel and Notice Board (still in preview — visible to admins only, marked with a "Admin preview" banner and a PREVIEW badge in the sidebar).
- **Granting admin access is a manual, deliberate step** — not self-service in the app. See [docs/ADMIN_GUIDE.md](docs/ADMIN_GUIDE.md#granting-admin-access). This was a conscious choice: privilege escalation shouldn't be one click away in a tool students also use.

## Where to go next

| I want to... | Read |
|---|---|
| Understand the routes, auth flow, and how this fits with isb-explorer | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |
| Look up what's in the database — every table, column, and RLS policy | [docs/DATA_MODEL.md](docs/DATA_MODEL.md) |
| Add courses, resources, or notices as a non-technical admin | [docs/ADMIN_GUIDE.md](docs/ADMIN_GUIDE.md) |
| Know what's built, what's deferred, and what's a known data gap | [docs/ROADMAP.md](docs/ROADMAP.md) |

## A note on how this was built

This was built end-to-end by Claude Code, directed by Eshan Jain (ISB PGP, Academic Council). Every schema change is a numbered migration in `supabase/migrations/`, applied directly to the shared production database as the project went — there is no separate staging environment. Git commit messages are written to explain *why* a change happened, not just what changed; they're worth reading if you're trying to understand a decision that looks odd out of context (e.g., why `credits` is `numeric` not `integer`, why there's no iframe embedding, why the resource taxonomy has exactly 4 tabs).
