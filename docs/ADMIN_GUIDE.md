# Admin Guide

For AAC members running the Admin panel day-to-day — no coding knowledge assumed.

## Granting admin access

There's no button for this in the app — it's deliberately a manual step, done directly in the Supabase dashboard. This was a conscious choice: letting admins grant other admins from inside the app is a privilege-escalation feature, and those are worth keeping one step removed from casual use.

1. **The person needs to sign in once first** (Microsoft SSO, at isb-academics.vercel.app or isb-explorer — same login). This creates their row in the shared `users` table. You can't grant access to someone who's never logged in.
2. Go to the [Supabase dashboard](https://supabase.com/dashboard) → your project → **Table Editor** → `users` table.
3. Find their row by email.
4. Set `is_admin` to `true`. Save.
5. They'll see the Admin link (and Course Resources / Notice Board, marked PREVIEW) next time they load the sidebar — no redeploy needed.

## The Overview tab

Landing tab in Admin. Stat tiles for courses/resources/notices (click any tile to jump to that section), a resource-by-category breakdown bar, a count of courses still missing a professor ("TBD"), and the 3 most recent notices. It's meant to answer "what's the state of things" before you dive into a specific task.

## Managing courses

- **Add**: fill in code, name, professor, term, credits, whether it's a Core course, and which concentration(s)/specialization(s) it counts toward (a cross-listed elective can have more than one — tag all that apply).
- **Edit**: click "Edit" on any course row — it loads back into the form above. Save updates it in place.
- **Removing a course from view: use Disable, not delete.** There's no delete button by design. "Disable" flips `is_active` to false — the course disappears from students' Bidding Planner and Course Resources, but the row and everything tied to it (any resources filed under it) stays intact. "Enable" brings it right back. This matters because a course ISB drops mid-year (this already happened once — a Flexi Core option was discontinued for low enrollment) might need to come back, and re-entering it from scratch would be wasted work.
- **Term dropdown covers everything** — Term 1 through Term 7, all four Block Weeks. If you don't see the term you need, that's a bug, not a missing option — flag it.

## Managing resources

Every resource needs a **Type** first — pick from the grouped list (Course Details / Session Resources / Exam Resources / Others / not-tied-to-a-course). The type you pick determines whether Term and Course fields appear:

- **Course-scoped types** (everything except Platform Directory and General): pick a Term, then optionally a specific Course within that term. Leaving Course blank files it as a term-wide resource (shows up for that term generally, not one specific course).
- **Platform Directory**: for links to ISB's own tools — Atrium, LMS, VMock, Nworx, the Alumni portal, etc. Shows as a card at the top of the Resources page, always visible.
- **General**: anything cohort-wide that isn't a specific tool link.

**Always write a description.** It's optional in the form but shouldn't be skipped — it's the one-line reason a student doesn't have to click through and open the file just to check what's in it. Something like *"Covers TVM, WACC, and capital budgeting — 12 slides from Session 3"* is far more useful than a blank field.

**Editing and deleting** both exist here (unlike courses, there's no soft-disable for resources — a wrong link is just wrong, delete it and re-add).

## Managing notices (Notice Board)

- **Tag** every notice — Urgent, Important, Info, or General. Tags are always shown as a labeled badge, never color alone.
- **Pin** anything that should stay at the top regardless of when it was posted (deadlines, major announcements). Pinned items always sort before unpinned ones, newest-first within each group.

## Course Resources and Notice Board are still in preview

Both pages are fully built but gated to admins only — students see them grayed out in the sidebar with a "SOON" badge. This is intentional (Eshan's call: "I do not want to open it up for everyone before I tell you to"), not a bug.

**Opening them to everyone is a code change, not a setting.** In `src/App.tsx`, the `/resources` and `/notices` routes currently sit inside a `<Route element={<RequireAdmin user={user} />}>` wrapper. To launch:
1. Move those two `<Route>` lines out from under `RequireAdmin`.
2. In `src/components/Sidebar.tsx`, remove the `disabled={!user.is_admin}` / `soon={!user.is_admin}` / `preview={user.is_admin}` props on those two `NavItem`s so they're always enabled for everyone.
3. Deploy.

Whoever's doing engineering work on this repo should make this change when Eshan gives the go-ahead — it's a five-minute change, deliberately left as a clear, single decision point rather than something that could accidentally ship early.

## What the app will never do

Worth knowing so you don't get asked for it and wonder if it's missing: **the app never recommends what to bid, and it never submits anything to Registro.** Every number and course shown is informational — the student's own bid-points ledger inside the app is a personal planning aid, not connected to ISB's actual bidding system in any way. This is a deliberate product boundary, not a limitation to work around.
