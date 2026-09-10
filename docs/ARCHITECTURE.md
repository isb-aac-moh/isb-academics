# Architecture

## The big decision: shared backend, separate app

`isb-academics` is a **separate codebase and a separate Vercel deployment** from `isb-explorer` (the campus-life/Pulse app), but they **share one Supabase project**. This was a deliberate call made early on, not an accident:

- Two products with genuinely different scope (campus-life discovery vs. academic planning) shouldn't share one commit history — harder to hand off, harder to scope access for people who should only touch one.
- But standing up a second Supabase project, a second Azure AD app registration, and a second auth flow would have been pure overhead for zero benefit — students only need to log in once.

So: one Supabase project, one `users` table, one Microsoft SSO configuration, two independent frontends pointed at it. `src/lib/supabase.ts` uses the literal string `"pulse-isb-auth"` as its `storageKey` — that's intentional, it's the same key isb-explorer's client uses, which is what makes one login work for both apps in the same browser.

## Repos and deployments

| | isb-academics | isb-explorer |
|---|---|---|
| GitHub | `jain-eshan/isb-academics` (private) | `jain-eshan/pulse-isb` |
| Vercel project | `isb-academics` | `pulse-isb` |
| Live URL | isb-academics.vercel.app | pulse-isb.vercel.app |
| Supabase project | **same one** | **same one** |

**isb-academics *is* connected to GitHub for auto-deploy** (re-confirmed 2026-09-10 — this reverses the 2026-08-03 finding above; the connection was made sometime in between, not on this date). Merging a PR to `main` triggers an automatic Vercel deployment via the `vercel[bot]` GitHub App: open PRs get a `Vercel` status check (a preview deploy) and merging creates a new Production deployment. (isb-explorer's own deploy wiring wasn't re-verified — don't assume it matches.) There is still no staging/preview gate in front of production — once a PR merges to `main`, the auto-deploy is live within about a minute. Treat `main` accordingly.

Two gotchas worth knowing before manually running `vercel` from a fresh git worktree (both hit during the PWA ship on 2026-09-10):

- **Hobby-plan concurrent-build limit.** If another deploy is already building — likely with several Claude sessions/worktrees active on this repo at once — the new one can come back `"Deployment was blocked"` (check via `gh api repos/isb-aac-moh/isb-academics/deployments/<id>/statuses`), and `vercel redeploy <url>` refuses to retry it ("This deployment can not be redeployed. Please try again from a fresh commit."). Fix: run `vercel --prod --yes --scope isb-aac` from a worktree whose files match `origin/main` exactly (verify with `git diff HEAD origin/main --stat` — no output means safe to deploy).
- **A fresh worktree has no `.vercel/project.json`.** Running `vercel --prod` there with no existing link auto-creates and links a **new, separate Vercel project** named after the worktree's folder — not the real `isb-academics` project. Before deploying from a worktree, first link it to the correct project: copy `.vercel/project.json` from the main checkout (project `isb-academics`, id `prj_1CEHXg86TM1vFpNnS6v8emTsPJDR`, org `team_ZDdSkByf3msgL94G2uleKOOY`) into the worktree's `.vercel/` directory.

## Auth flow

1. `useAuth` (`src/hooks/useAuth.ts`) wraps Supabase Auth. Two sign-in paths: `signInWithAzure()` (Microsoft SSO) and `sendMagicLink(email)` (email OTP fallback).
2. On any successful sign-in, `gateAndLoadProfile` checks the email domain — anything not `@isb.edu` gets immediately signed back out. This is the only domain gate; there's no separate allowlist.
3. A matching row in `public.users` is expected to exist (or get created — isb-explorer's onboarding flow handles first-time row creation; isb-academics assumes the row exists since most users will have used isb-explorer first). `is_admin` lives on this shared table.
4. **Redirect URLs are a Supabase Dashboard setting**, not code — `Authentication → URL Configuration → Redirect URLs`. Both `http://localhost:5174/**` (for local dev) and `https://isb-academics.vercel.app/**` need to be in that list, or Supabase falls back to whatever the default Site URL is (which was originally set to isb-explorer's production URL — the exact bug that caused login to bounce to the wrong app during development, twice, once for localhost and once for the new production URL).

## Route map

Every page and every meaningful sub-state has a real URL — this was a deliberate fix partway through the build (previously navigation was pure client-state, no URL change, no back/forward, refresh reset everything).

```
/                          → redirects to /tracker
/tracker                   → Credit Tracker — the default landing page
/planner/:step             → Bidding Planner, step ∈ {background, goals, plan, budget}
/resources                 → Course Resources (live to everyone, not admin-gated)
/notices                   → Notice Board (admin-only preview)
/admin/:tab                → Admin panel, tab ∈ {overview, courses, resources, notifications}
*                          → redirects to /
```

Two different state-encoding strategies were used deliberately, not interchangeably:

- **Bidding Planner and Admin use path segments** (`/planner/goals`, `/admin/courses`) — these are genuinely distinct sequential steps/screens, and a path segment is the right level of URL "weight" for that.
- **Course Resources uses query params** (`/resources?term=Term+4&kind=core&q=finance&course=FSAN&view=full`) — this was an explicit product decision (see git log for the commit "Rebuild Course Resources as a single-page searchable gallery"). It replaced an earlier version that used path segments per term/course; that was reverted because Eshan asked for filters instead of "different pages for each term." Query params keep the single-page filtering UX while staying shareable and refresh-safe.

**Route guards:** `RequireAdmin` (`src/components/RequireAdmin.tsx`) wraps `/notices` and `/admin/*` (`/resources` moved out of this group once Course Resources went live to everyone). It's a real redirect-based guard (`<Navigate>` to `/tracker` for non-admins), not just a hidden sidebar button — `App.tsx` enforces this independent of whatever the Sidebar shows, so a non-admin typing the URL directly still gets redirected.

**Unauthenticated state:** `App.tsx` renders `<Login />` for *any* path when there's no user — it never touches the URL. This means a bookmarked deep link works correctly post-login: the browser's URL bar already has the right path, and once `user` becomes truthy, the same render picks up the `<Routes>` tree against whatever URL is already there. No explicit "redirect back after login" logic was needed or built.

## Why `vercel.json` matters

```json
{ "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }] }
```

Client-side routing only works if the server hands every path back to `index.html` and lets React Router take over. Without this, Vercel would try to find a literal file at e.g. `/admin/courses`, fail, and 404 — meaning every refresh or shared link to anything but the root would break in production even though it works fine in local dev (Vite's dev server does this rewrite automatically, which is exactly why this class of bug is easy to miss until it's live).

## Design system

No component library. Two files carry the whole visual language:

- `src/lib/theme.ts` — `COLOR` and `FONT` constant objects. Navy (`navyHero: #1E2E7A`) + mint (`#8FE8D8`) as the primary brand pair, matching ISB's Tutor Portal reference. Playfair Display (serif, headings) + Plus Jakarta Sans (sans, everything else) — same font pairing isb-explorer uses.
- `src/lib/options.ts` — every fixed dropdown/chip list lives here (undergrad fields, work-ex domains/roles, terms, resource types, notification tags), so option sets are defined once and can't drift between the form that writes them and the filter that reads them.

Every component uses inline `style={{ ... }}` objects referencing `COLOR`/`FONT`, with Tailwind utility classes (`flex`, `grid-cols-*`, `gap-*`, responsive prefixes) for layout only. This is a deliberate, consistent pattern across the whole codebase — don't introduce a component library or a CSS-in-JS library partway through; it would fragment the styling approach for no real benefit at this scale.

## Data fetching pattern

No global state library, no React Query. Every piece of server data has a small custom hook (`useCourses`, `useResources`, `useNotifications`, `useAcademicProfile`, `useBidPlan`) that owns its own `useState` + `useEffect` fetch + a `reload()` function components call after a mutation. This is intentionally simple — the data volumes here (hundreds of rows, not thousands) don't justify a caching layer, and the "just refetch after you write" pattern is easy for a non-specialist to reason about if they're picking this codebase up cold.
