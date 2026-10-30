# Admin guide

For AAC members running the app day to day. No coding knowledge assumed.

There are two admin areas:

- **Admin panel** at `/admin` (sidebar → Admin, at the bottom): courses, grading profiles, resources, notices, sidebar links, popups, and the bidding round settings.
- **Learn admin** at `/learn/admin` (inside Learn, the admin icon on the desktop): study content, questions and student progress statistics.

Changes save straight to the live database. Students see them the next time they load a page. Nothing needs deploying.

## Granting admin access

There's no button for this in the app. It's done by hand in the Supabase dashboard, on purpose: letting admins create other admins from inside a tool students also use is one click too close to casual.

1. **The person signs in once first** (Microsoft SSO, at isb-academics.vercel.app or isb-explorer; it's the same login). This creates their row in the shared `users` table.
2. Open the [Supabase dashboard](https://supabase.com/dashboard) → the project → **Table Editor** → `users`.
3. Find their row by email.
4. Set `is_admin` to `true` and save.
5. They see the Admin link, Notice Board and Learn admin on their next page load.

To remove access, set it back to `false`.

## A bidding round checklist

What to do in the admin panel when a round opens and closes.

**Before the round**

1. **Courses tab:** check the term's electives are active, with the right professor, credits and concentration tags. Compare against ASA's course lineup (links in [DATA_MODEL.md](DATA_MODEL.md#source-of-truth-for-courseprogramme-data)).
2. **Courses tab → grading profile** for each elective, so "Your Term" and the Term Dossier have data. For a new term's Dossier, profiles are usually loaded in bulk by a migration; use the editor for corrections.
3. **Resources tab:** file each course outline as a Course Outline resource under its course.
4. **Overview tab → Term elective credit limits:** confirm the min and max for the term.

**When the round opens**

5. **Overview tab → Live bidding round:** switch the term on. This opens the Planner's "Live now" section and the Your Term step, and opens Bidding Pulse for that term.
6. Optionally, **Popups tab:** add a popup pointing students to the Planner, Term Dossier or Bidding Pulse.

**When the round closes**

7. **Overview tab → Live bidding round:** switch the term off. Bidding Pulse stops accepting and editing submissions for it straight away.
8. Switch off any round-specific popup.

The Credit Tracker's "Did you get these?" prompt appears by itself once a term's calendar end date passes. There's nothing to switch on for it.

## Overview tab

- **Stat tiles:** courses, resources, notices, and **Missing faculty** (courses whose professor is blank or "TBD"). Click a tile to jump to that section.
- **Live bidding round:** one chip per term (Term 4 to 7, Block Week 1 to 4). Tap to switch a term on or off. More than one can be live at once.
- **Term elective credit limits:** min and max elective credits per term, with Save. Defaults come from the Elective Bidding FAQ (Q9): Term 4 and 6 3-4, Term 5 and 7 3-5, Block Weeks up to 1. The Planner won't let a student add a course that pushes a term over its max, and Bid Budget flags a term under its min.
- Resource counts by type and the 3 latest notices.

## Courses tab

- **Add:** code, name, professor, term, credits, whether it's a Core course, and which concentrations and specializations it counts toward. Tag every one that applies; cross-listed courses get a picker for students automatically.
- **Edit:** click Edit on a row; it loads into the form. Save updates it.
- **Disable, never delete.** There's no delete button. Disable hides the course from students everywhere but keeps it and everything attached to it. Enable brings it back. ISB has dropped and then restored courses before.
- The Term dropdown covers Term 1 to 7 and all four Block Weeks. If one is missing, that's a bug.

### Grading profile editor

Each course has a grading profile editor. It powers "Your Term" in the Planner and the Term Dossier.

- **Grade split:** participation, individual, group and exam percentages. It warns if they don't add up to 100.
- **Exams:** number of mid-terms, end-terms and quizzes.
- **Workload scores**, 0 to 5 each: quant, assignments, participation, exam pressure, group work, reading. Kept for the record; no student page shows them since 2026-10-30, so there's no need to fill them in for a new term.
- **Brief:** labelled bullet points (About, Exams, Groups, Work, Notes) summarising the outline.
- **Student feedback:** short notes from seniors who took the course. Not shown to students since 2026-10-30, so there's no need to fill it in.
- **Group and attendance rules:** group size, whether groups can cross sections, how groups form, peer evaluation, attendance policy.
- **Source URL:** the outline PDF you took this from.

**Leave a field blank if the outline doesn't say.** Blank shows students "Not stated in the outline", which is honest. Filling in ISB's default is a guess and can mislead someone choosing a course because of it. Note that "ISB policy" for attendance is strict: one missed session can already cost a letter grade.

## Resources tab

Every resource needs a **Type** first. The type decides which other fields appear:

- **Course-scoped types** (Course Outline, Professor Profile, Slides, Session Transcript, Summary, PYQP, Custom GPT, Cheatsheet, Student Notes, Other): pick a Term, then optionally a Course. Leaving Course blank files it for the whole term.
- **Platform Directory:** links to ISB platforms and AAC tools (Atrium, LMS, the Term Dossiers). These show as cards near the top of Course Resources.
- **General:** anything cohort-wide that isn't a platform link.

Also:

- **Always write a description.** "Covers TVM, WACC and capital budgeting, 12 slides from Session 3" saves every student a click.
- **Pinned** sorts a resource first in its list. **Pinned globally** also puts it in the banner at the top of Course Resources. Use this sparingly.
- Links without `https://` get it added automatically.
- Resources can be edited and deleted. A wrong link is just wrong: delete it and add it again.

## Notice Board tab

- **Tag** every notice: Urgent, Important, Info or General. Tags always show as a labelled badge.
- **Pin** deadlines and major announcements to keep them at the top.
- Edit and delete are available.

Students can't see notices yet; see [below](#notice-board-is-still-in-preview).

## Nav Links tab (extra sidebar links)

The main sidebar pages (Learn, Credit Tracker, Bidding Planner, Bidding Pulse, Course Resources, Notice Board) are fixed. This tab manages extra links shown below them.

- **Label, icon, type:** an **External URL** opens in a new tab; an **Internal page** is a path in this app (like `/dossier/term-5`), opens in the same tab and highlights when active.
- **Visible to:** Everyone, or Admins only (useful for trying a link before the cohort sees it).
- **Reorder** with the up and down arrows.
- **Only 4 extra links show in the sidebar.** Any more collapse into one "N more in Resources" row. Keep the most important four at the top.
- **Creating a link also files it as a Platform Directory resource.** Deleting the link later does not delete that resource. Remove it from the Resources tab separately if you want it gone from both.

## Popups tab

A popup is a dialog shown to students when they open a page.

- **Title and body:** keep the body to a sentence or two.
- **Icon:** optional, from a set of 10.
- **Page:** all pages, or one section (Tracker, Planner, Resources, Pulse, Term 4 pages, Learn, Notices). It matches the start of the address, so choosing Planner covers every planner step.
- **Frequency:**
  - **Always:** every time the student opens that page. Use for short campaigns only; it gets annoying fast.
  - **Session:** once until they close the browser tab.
  - **Once:** once ever, per browser.
- **Primary button:** a label and an action. Dismiss closes it, Internal goes to a page in the app (e.g. `/learn/practice`), External opens a link in a new tab.
- **Secondary button:** optional; it just closes the popup.
- **Enable / Disable** to switch it on or off without deleting it.

Only one popup shows at a time. If several match, the most recently updated one wins. "Once" and "Session" are remembered in the student's browser, so a student on a new device sees the popup again.

There's no page option for the Term Dossiers (`/dossier`) yet; use "All pages" or ask for it to be added.

## Learn admin (`/learn/admin`)

- **Monitoring:** how many students are using Learn, accuracy overall and per topic, and **flagged questions**: 3 or more attempts with accuracy under 40% (the answer key might be wrong, or the question is unclear) or over 95% (probably too easy or giving the answer away). Check flagged questions before an end-term.
- **Questions:** add a Compute or Case recall question with 2 to 4 choices. The correct answer must match one choice exactly. List and delete. There's no edit, and the form has no explanation or hint fields, so a question added here shows no explanation after answering. Bulk content and anything needing explanations should go through the content pipeline in [LEARN.md](LEARN.md#adding-content-the-generator-pipeline).
- **Scenarios:** case setups that several questions share.
- **Concepts:** the notes students read before practising a topic.
- **Sessions:** number of sessions for the course, and each session's title, summary, formula sheet and slides link.
- **Materials:** upload PDFs and Office files (up to 50 MB) to a session.
- **Course:** switch a course on or off for students, and edit its announcements, outline and links. Switched-off courses show "coming soon" to students; admins can still open them to check content. The "Add a new course" and name/code fields on this tab don't currently save; see [ROADMAP.md](ROADMAP.md#known-bugs-and-rough-edges).

On a phone, Learn admin is only reachable by typing `/learn/admin`; there's no link to it in Learn's mobile navigation.

## Things that still need a developer

These have no admin screen:

- Faculty profiles and ratings (loaded from ASA's pages by migration).
- The term calendar dates the Credit Tracker uses (`src/lib/termCalendar.ts`), which must be updated for the next cohort.
- Bulk course or grading-profile loads for a new term, and a new Term Dossier's data.
- New Learn courses and bulk question content.
- Launching the Notice Board.

## Notice Board is still in preview

The page is built but only admins can open it. Students see it greyed out with a "SOON" badge. This is Eshan's call: it opens when Eshan gives the go-ahead.

Opening it to everyone is a small code change:

1. In `src/App.tsx`, move the `/notices` route out from inside the `<Route element={<RequireAdmin user={user} />}>` block.
2. In `src/components/Sidebar.tsx`, remove the `disabled={!user.is_admin}`, `soon={!user.is_admin}` and `preview={user.is_admin}` props from the Notice Board item.
3. In `src/components/Layout.tsx`, remove the "Admin preview" banner for `/notices`.
4. Open a pull request and merge it. Vercel deploys `main` automatically.

## What the app will never do

**It never recommends what to bid, and it never submits anything to Registro.** Every number and course shown is for information. A student's bid plan is a personal notebook, not connected to ISB's bidding system. If someone asks for "just tell me what to pick", that's a deliberate product boundary, not a missing feature.
