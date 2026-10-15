# Compass: research and validation plan

Written 15 Oct 2026. Purpose: decide whether Compass is worth the effort of a full build, and collect what ISB IT, operations, administration, faculty and the AAC each need to say yes. The POC (`docs/COMPASS_POC.md`) is the thing being tested. The product plan is `docs/COMPASS_PRD.md`.

## 1. The decision this research serves

Eshan will show the POC to a small group (students, AAC members, and people in ISB IT, operations and administration), collect feedback, and then decide whether to commit and start the prerequisites with ISB. The three approvals the PRD asks for are: an ISB-owned cloud environment in an India region, official access to course files and transcripts, and a faculty notice with opt-out.

Compass is worth committing to if all of these hold:

| Test | Evidence we want |
|---|---|
| Students would use it | Most testers say they would open it before an exam, case or interview, and can name what they used it for. |
| It is correct enough to trust | Sampled tags and links meet the accuracy thresholds in section 5. |
| It finds things faster than today | Testers reach the right session faster than by searching their own files or asking a friend. |
| ISB can allow it | IT, legal and faculty see no blocker that cannot be solved with the planned controls. |
| It is affordable and maintainable | ISB's own cloud quote is near the PRD estimate (₹5.4 to 7.6 lakh a year) and AAC can run the yearly refresh. |

If students do not care, or accuracy cannot reach the thresholds, stop or re-scope before any cloud commitment.

## 2. What has already been learned

| Area | Finding |
|---|---|
| Demand | Last year's cohort built a shared drive by hand: 1,316 unique files (about 6.5 GB) in 93 course folders, both campuses. Every file carries another student's name and ISB email as a watermark. This shows need and a content-rights risk. |
| Source material | Terms 1 to 4: about 770 files, mostly cloud-only PDFs. Slide text layers are good for OPMG, MKTG, BANM, MADM handouts and SWPM. Some decks are images with no text (parts of BANM and the MGEC decks) and would need a vision pass. Transcripts exist for 7 courses (about 57 sessions) with no timestamps; they would align to slide passages by order. 12 other courses have none. |
| LMS access | The official Moodle web service functions exist but need an ISB-issued key. A browser-session route (`core_courseformat_get_state` through the site's AJAX endpoint) worked for six courses and returned sessions, titles and file links with no key. It is not an official API and depends on a logged-in session, so it is fine for a POC and not for production. A service account from ISB IT is the clean path. |
| Hosting files | ISB's file module stamps each viewer's name on the PDF. So hosting copies is unnecessary for a POC (links open in Moodle) and, for production, the PRD requires official clean originals behind a secure viewer, not student-downloaded copies. |
| Cost | Pilot on the existing Supabase and Vercel setup costs about ₹2,200 a month. Free plan limits checked: 500 MB database, 1 GB storage, 5 GB transfer, pauses after inactivity. Production estimate in the PRD is ₹5.4 to 7.6 lakh a year, to be replaced by ISB's own quote. |
| Prior art | The Product Management Knowledge Graph (Professor Chandrashekhar V) and the Consulting Case Graph show what a good graph UI does: topics grouped into modules, layered layouts, a trace of what comes before and after, a table of where each idea appears, "I know this" ticks and a "what to learn next" view. Compass borrows these. Eshan also shared a Math Academy-style knowledge-graph architecture note and a research paper as reference; they are not summarised here. |
| Chatbot or not | A chatbot was rejected for v1: runtime cost, trust (it can invent), and rights (it would repeat slide text). Retrieval with sources was chosen. |

## 3. Questions to answer, by audience

| Audience | Questions |
|---|---|
| Students | Would you open this the night before an exam or an interview? What did you look for that it could not find? Which view helped most: search, topics, prep kit, map or across-courses table? Did anything look wrong? |
| Faculty and AAC | Is each idea explained fairly for how you teach it? Which cross-course links are wrong or missing? What would you need to see before agreeing to a pilot with your course in it? Who reviews each term? |
| ISB IT and security | Does the proposed ISB-owned cloud, sign-in and logging design meet your bar? Is Azure the right cloud? What review steps and lead times should be planned? Can we get a read-only Moodle service account? |
| Operations and administration | Who owns the yearly refresh of course material? Who owns the alias list and the report-a-problem queue? Is there a calendar for content updates? |
| Legal and Dean's office | What is the rights position on course packs and transcripts? What should the faculty notice and student privacy notice say? |

The same questions are on the reviewer roadmap page (`/compass/roadmap`).

## 4. Tester sessions

Give each tester admin access for the session (see the POC doc), then remove it. Run 20 to 30 minutes each, one person at a time if possible, and watch without helping.

**Tasks (read aloud, one at a time):**

1. "You have a pricing question in an interview tomorrow. Find what ISB taught about pricing." (search or topics)
2. "You remember something about a newsvendor from operations. Which session was it, and open the slides." (search, idea page, Moodle link)
3. "Prepare for a Product interview. Where would you start?" (prep kit)
4. "Revise Marketing Management for the end-term. Where would you go?" (courses, by topic or by session)
5. "Pick any idea. What should you know before it, and where does it lead?" (idea page, map, side panel)
6. "Which ideas are taught in more than one course?" (across courses table)

**Record for each task:** did they finish (yes, with help, no), time taken, where they hesitated, what they said aloud, anything they expected that was missing.

**End of session:** usefulness 1 to 5; "would you use it before an exam or interview" (yes, maybe, no) and why; one thing to remove; one thing to add; "would you trust a link to a slide without checking it" (yes, no).

**Targets for the pilot to count as a success (from the PRD, applied to the POC):** at least 60% of tasks finished unaided within a minute; no result found for fewer than 10% of searches; at least 70% of testers say yes or maybe to using it before an exam or interview.

Recruit testers who differ: a Product-leaning student, a Consulting-leaning student, someone who rarely uses the shared drive, and at least one person from another section or campus if possible. Eshan recruits testers himself.

## 5. Data-quality checks (do these before or alongside testers)

All are quick, repeatable, and should be recorded in a sheet with the date, who checked, and the result.

| Check | How | Pass mark |
|---|---|---|
| Tag accuracy | Draw 100 random evidence rows (fixed random seed, spread across courses). For each, read the idea, the one-line reason and the source session title in Moodle. Mark correct, partly correct or wrong. | At least 90% correct or partly correct; fewer than 5% wrong. If lower, find the pattern (course, source type, kind of idea) and re-tag that slice. |
| Search success | Write 60 realistic queries (ideas, nicknames, formula names, "how much to order for seasonal demand"). Mark whether the right idea is in the top 3. | At least 85% (PRD M4). |
| AI-suggested links | Review all 191 (each has a one-line reason) or a random 60. Mark right, wrong or unclear. | At least 90% right; drop the rest. |
| Cross-course claims | List the 45 ideas taught in 2+ courses. Check each is truly the same idea in both courses. | 95% (PRD M3). |
| Explainers | Draw 30. Check what it is, when to use it, the watch-out. Ask a faculty member or a strong student for 10 of them. | No factual errors; flag and fix any that over-claim. |
| Topic assignment | Draw 50 ideas. Is the topic the one a student would expect? | At least 85%. Adjust rules in `lib/topics.ts`. |
| Leak scan | Search the dataset text for `@isb`, `PGP20`, student names, "filewithwatermark". | Zero hits. |

## 6. Measuring use

The POC records nothing about use. Add PostHog events before testers start, following how the rest of the app captures them, with no search text beyond the first 60 characters:

`compass_search` (query length, result count, lens), `compass_idea_open` (idea id, from: search, topic, course, map, prep, compare), `compass_source_click` (course, session), `compass_map_group` (by, group), `compass_map_node` (idea id, focus), `compass_known_toggle`, `compass_no_result` (query).

Metrics to compute: searches that end in a source click within 60 seconds; zero-result rate; which views are used (search, topics, courses, prep, map, compare); which ideas are opened most; repeat visits per tester.

## 7. Timeline

Dates are from the PRD and move with ISB's response. Today is 15 Oct 2026.

| When | Step |
|---|---|
| By 20 Oct | Add usage events; run the accuracy and search checks; fix the worst findings; move the build folder to a safe private place. |
| 20 to 23 Oct | Show the POC to a first small group (2 to 3 students, 1 AAC member). Confirm ISB's cloud with IT (needed by 23 Oct). Get written permission to use the PM graph (23 Oct). |
| 23 to 30 Oct | Wider reviewer round: Career Services, faculty volunteers, IT, operations. Dean's office content licence and faculty notice; legal rights position (30 Oct). |
| By 6 Nov | Sign-in app registered and security review scheduled; official access to course files and transcripts; role and task lists and reviewers named. |
| 10 Nov | PRD pilot gate: 60% search success, zero incidents, up to 50 students. |
| Mid-Jan 2027 | Full launch if the gates in the PRD pass. |

## 8. Go, change or stop

After the review round, put the results in one page and decide:

- **Go:** students would use it, accuracy passes, IT and legal see no blocker. Start the prerequisites with ISB and plan phase 1.
- **Change:** value is clear but one gate fails (accuracy, rights, hosting). Fix that first and re-test with a smaller group.
- **Stop or shrink:** students would not use it, or ISB will not provide official access to course files. Fall back to a smaller offer (for example the prep kits only) or stop.

## 9. Open research questions

- Which of Product and Consulting students use it more, and does the "Show" switch matter?
- Do students want to see slide text in the product, or are summaries and links enough? (Faculty approval is needed for any quotes.)
- How many courses per term must be loaded before it feels complete? The POC has six.
- Is a map useful to students, or mainly to reviewers? Compare map use to search and topics.
- What does a yearly refresh really cost in AAC time? Time one full refresh of one new course end to end.
- Does ISB want Compass tied to Moodle (a plugin) or kept as a separate app?
