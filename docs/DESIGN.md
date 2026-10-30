# Design and UI

How the app looks and behaves, and the conventions to follow when adding to it.

## Two visual systems, on purpose

The app has two design systems side by side. This is a result of Learn being merged in from a separate app, and it was kept deliberately so neither half had to be restyled.

| | Main app (everything except Learn) | Learn (`/learn/*`) |
|---|---|---|
| Fonts | Playfair Display (headings), Plus Jakarta Sans (everything else), from Google Fonts | Inter, bundled via `@fontsource/inter` |
| Colours | ISB navy with amber and mint accents | ISB brand guideline: Innovation Blue, Future Green, slate greys |
| How styles are written | Inline `style={{ }}` objects using `COLOR` and `FONT` from `src/lib/theme.ts`; Tailwind classes for layout only | Tailwind utility classes against `@theme` tokens in `src/index.css`, plus `.btn`, `.card`, `.input` component classes |
| Scope | Global | Everything under a `.learn-root` wrapper |
| Theme | Light only | Light only (the original app's dark mode was dropped so it wouldn't clash with the light shell) |

**Rule of thumb:** in the main app, reach for `COLOR`/`FONT` and don't introduce a component library or CSS-in-JS. Inside `src/learn`, use its Tailwind tokens. Don't mix the two within one screen.

The Term 4 Dossier and Q&A pages and the revision guides are self-contained HTML files with their own styling. They are shown in frames and should be left alone.

## Main app tokens (`src/lib/theme.ts`)

| Token | Value | Used for |
|---|---|---|
| `bg` / `bgSoft` / `surface` | `#FAFAFA` / `#F5F5F3` / `#FFFFFF` | Page, soft panels, cards |
| `border` / `borderLight` | `#E5E5E3` / `#F0F0EE` | Card and row dividers |
| `navy` / `navyDeep` / `navyTint` | `#1C3A6E` / `#122850` / `#EEF2FA` | Primary actions, sidebar, selected states |
| `navyHero` / `mint` | `#1E2E7A` / `#8FE8D8` | Login hero and highlight pairing, from ISB's Tutor Portal |
| `amber` / `amberTint` | `#C47D0E` / `#FDF4E0` | Soft relevance tags, warnings, admin preview banner |
| `ink` / `ink2` / `ink3` | `#111` / `#555` / `#999` | Text: primary, secondary, muted |
| `green` / `greenTint` | `#059669` / `#ECFDF5` | Success, "In your plan", progress complete |
| `red` / `redTint` | `#DC2626` / `#FEF2F2` | Errors, closed concentrations, over-budget |

The page background behind everything is `#F4F2EC` (set on `body`, also the PWA theme colour).

Fixed option lists (terms, undergrad fields, work-ex roles, resource types, notice tags, popup pages) all live in `src/lib/options.ts`, so the form that writes a value and the filter that reads it can't drift apart.

## Learn tokens (`src/index.css`)

| Token | Value |
|---|---|
| `base` / `surface` / `surface-2` | `#f4f8fa` / `#ffffff` / `#e6ebee` |
| `ink` / `ink-soft` / `line` | `#2e3b42` / `#5d6f7a` / `#d6e0e5` |
| `accent` (Innovation Blue) | `#245bff` |
| `good` / `good-soft` | `#12947e` / `#e1fff9` |
| `bad` / `bad-soft` | `#c0453a` / `#f8e7e5` |
| `highlight` (Future Green) | `#80edd9`, used as a highlighter stroke behind key words |

## Layout and navigation

### Desktop (768px and wider)

- **Sidebar** on the left, navy, 220px wide. It collapses to a 72px white icon rail with hover labels. It collapses automatically when you enter Learn and expands again when you leave. The collapsed state isn't remembered between visits.
- **Primary items, in order:** Learn, Credit Tracker, Bidding Planner, Bidding Pulse, Course Resources, Notice Board. These are hardcoded in `src/components/Sidebar.tsx`.
- **Extra links** from the admin-managed `nav_links` table appear below. At most 4 are shown; the rest collapse into one "N more in Resources" row, so the sidebar can't grow without limit.
- **Footer:** Admin (admins only), the user's name, Sign out.
- **Badges:** Notice Board shows "SOON" (disabled) to students and "PREVIEW" to admins. Pages that are admin-only previews also show an amber banner at the top.

### Mobile (under 768px)

- A sticky navy top bar with a menu button that opens the sidebar as a drawer, always with full labels.
- A **bottom tab bar** (`src/components/BottomNav.tsx`) with Learn, Tracker, Planner, Pulse and Resources. It respects the iPhone home-indicator safe area. Notice Board and Admin are only in the drawer.
- Inside Learn the app's bottom bar hides and Learn's own (Home, Learn, Practice, You) takes its place, so two bars never stack.
- The Bidding Planner's Back and Continue buttons stick just above the bottom bar.
- Rows stack instead of squeezing; long labels wrap instead of overflowing.

### Learn's desktop metaphor

Learn is a campus-photo "desktop" with a column of white icons, and each screen opens as a floating window (`src/learn/components/Window.tsx`): rounded and inset on desktop, full screen on mobile. A CSS transform on `.learn-root` makes those fixed-position windows measure from the content column instead of the whole browser window, so they sit beside the sidebar. That transform is desktop-only because on mobile it would push Learn's bottom bar off screen.

### Loading

Each page is a separate download. While one arrives, the sidebar stays on screen and the content area is blank rather than showing a spinner; on a normal connection this takes a fraction of a second and a spinner would only flash.

## Installable app (PWA)

- Configured in `vite.config.ts` with `vite-plugin-pwa`: name "ISB Academics", standalone display, `#F4F2EC` theme, 192px and 512px icons (including a maskable one for Android).
- `index.html` adds the iOS tags: `apple-touch-icon`, `apple-mobile-web-app-capable`, and `viewport-fit=cover` so the layout can use the full screen around the notch.
- The service worker caches the app's code and icons so it opens quickly. Database calls are never cached, so login and data are always live.
- Updates install automatically on the next visit.

## Conventions

These come from explicit product decisions. Follow them when adding screens.

- **Every meaningful state has a URL.** Steps and tabs are path segments (`/planner/goals`, `/admin/courses`). Filters are query parameters (`/resources?term=Term+5&q=finance`). One artefact per term is a path segment (`/dossier/term-5`). Back, forward, refresh and shared links must all work.
- **Text, not just colour.** Status and tags always include a word ("Urgent", "In your plan", "Not enough data yet").
- **Say when data is missing.** "Not stated in the outline", "No grading profile yet", "Not enough data yet (3/5)". Never fill a gap with a default.
- **Informational tags look soft.** Relevance tags are small amber tags, never styled like a recommendation or ranking.
- **Keep catalogue order.** Lists of courses are not re-sorted by popularity or by cohort data.
- **Charts should look as uncertain as the data is.** Bidding Pulse uses a coarse 5-bar histogram, not a smooth curve, because 5 to 20 answers don't justify one.
- **Warnings don't block** unless an ISB rule is hard. Spending into the reserve shows red but is allowed; going over a term's credit maximum or the points available does block adding a course.
- **Confirm the irreversible.** Pulse submissions and removals go through a confirmation dialog.
- **Open external material in a new tab.** Don't embed SharePoint, Drive or Notion; they block framing and a blank frame gives no clue why.
- **Searchable dropdowns for long lists.** `src/components/Dropdown.tsx` replaces the native select for the ~130-course pickers.
- **Collapse long lists** with a native `<details>` element whose summary line carries the counts, as the Credit Tracker's per-term groups do.
- **Respect reduced motion.** Learn's confetti and entrance animations switch off when the device asks.
- **Copy is plain and specific.** Say what happens ("Nothing here is submitted to Registro"), name ISB rules and where they come from (FAQ question numbers in comments), and avoid hype.

## Page patterns worth reusing

| Pattern | Where | File |
|---|---|---|
| Side panel that expands to full screen, state in `?course=CODE&view=full` | Course Resources, Planner | `src/components/CourseDetailModal.tsx` |
| Faculty card with one labelled rating and an offerings table | Planner, Resources, Dossier | `src/components/FacultySection.tsx` |
| Chip picker saved straight to the profile | Cross-listed concentration choice | `src/components/ConcentrationChoice.tsx` |
| Admin-driven dialog with page targeting and frequency | Any page | `src/components/PopupManager.tsx` |
| Step bar with persistent summary tiles | Bidding Planner | `src/pages/BiddingPlanner.tsx` |
| Threshold-gated stat card with mini histogram | Bidding Pulse | `src/pages/PulseCheck.tsx` |

## Icons

`lucide-react` throughout. Admins choose sidebar link icons from a curated set of 18 (`src/lib/navLinkIcons.ts`) and popup icons from a set of 10 (`src/lib/popupIcons.ts`), so admin-created items stay visually consistent.
