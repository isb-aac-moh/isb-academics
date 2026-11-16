# Vision and platform brief

Why ISB Academics exists, who it serves, how it should sound, and what we can prove. Written 16 Nov 2026, from the positioning work behind the recruiter film and the LinkedIn cut. [PRODUCT.md](PRODUCT.md) says what each tool does; [COMPASS_PRD.md](COMPASS_PRD.md) is the long-term plan for Compass. This file sits above both.

## Mission

**Learn it once. Use it for life.**

ISB Academics rebuilds the academic year around the student: one home for choosing courses, learning them at your own pace, and keeping what you learned after ISB.

## The problem

Four things go wrong for a PGP student, and each tool exists to fix one of them.

1. **Everyone starts from a different line.** About 800 people join ISB each year across both campuses (420 in the Mohali Co'27 batch this app was built for): engineers, doctors, bankers, founders. A class moves at one speed for all of them.
2. **Everything lives in ten places.** Moodle, SharePoint, Outlook, Atrium, WhatsApp, PDFs shared at midnight. Finding one line, such as how an elective is graded, means opening five of them.
3. **Real problems cross courses; teaching doesn't.** A falling repeat-order rate needs marketing, finance and product thinking at once, but each was taught in a different course, term and folder.
4. **Most of it is gone a week after the exam.** Nothing helps a student find what they were taught when they need it a year later, at work.

## Who it's for

| Who | What they need from it |
|---|---|
| Students (primary) | One place to plan, learn and look things up, without asking around |
| AAC | Fewer repeat questions every term; a way to publish material and settings without code |
| ISB (faculty, ASA, IT) | Their material used with permission, linked back to Moodle, never copied out |
| Recruiters and ISB leadership | Proof that a student found a real problem and shipped a product people use |

## The product in four layers

| Layer | Job | In the app today | Problem it fixes |
|---|---|---|---|
| **One home** | Replace the ten tabs | Credit Tracker, Bidding Planner, Term Dossier, Bidding Pulse, Course Resources | 2 |
| **Learn** (called "LearnKit" in the films) | A tutor that works at your pace: a short concept, then practice that brings back what you got wrong | 4 core courses, 845 questions | 1 |
| **Compass** | Ask a real problem in your own words and get what ISB taught on it, from every course, linked to the class | 22 courses, 1,163 checked idea cards; admins only | 3 |
| **Compass in Claude** | Take it with you: the same cards inside the AI a student already uses, during and after ISB | Connector pilot, admins only | 4 |

The connector is the first of several form factors. The product is the checked knowledge; the website is one way in.

## How we build it

These came out of the film work and sit alongside the product rules in [PRODUCT.md](PRODUCT.md#product-rules-that-apply-everywhere).

- **Problem first.** Lead with what a student is stuck on, then show the product. A feature tour doesn't persuade anyone.
- **Test with real questions, not textbook terms.** Students ask "Our D2C brand's repeat orders are falling. Where do I start?", not "explain price discrimination". Compass evaluation and demos should use questions of the first kind. This extends Compass rule 8 ([COMPASS.md](COMPASS.md#2-the-rules)).
- **Every answer shows its source.** If we can't link it to the class it came from, we don't show it.
- **Pitch the whole platform.** Compass is the most striking part but not the whole story. The home, the tutor and the knowledge work together.
- **Still never recommend.** The app shows where a student stands; it doesn't tell them what to pick.

## Voice and look

For anything students or outsiders see: the app, announcements, films, posts.

- **Tone:** brisk, specific, warm and confident. Never dejected, never hype. The film voice-over runs at about 157 words a minute; slower read as tired.
- **Say:** one home, at your own pace, across courses, linked to the class, the entire batch.
- **Don't say:** AI-powered, revolutionise, next-gen, or a textbook term where a real situation would do.
- **Look:** the app's own palette and type ([DESIGN.md](DESIGN.md)): ISB navy, warm paper `#F4F2EC`, mint as the one highlight, Playfair Display for statements, Plus Jakarta Sans for everything else. Real product screens are the hero. No glows, gradients, stock icons or particles.
- **Sound:** real library or licensed music. AI-composed scores were tried for the film and rejected.

## Proof so far

From PostHog (project 596443, test accounts excluded) and Supabase Auth, 10 Sep to 15 Nov 2026.

| Claim | Number | Source and caveat |
|---|---|---|
| The entire batch signed up | 423 accounts against a batch of about 420 | Supabase Auth. Includes a few admin accounts |
| Students come back | 81% (258 of 317 tracked students returned) | PostHog. 317 is students PostHog saw, not all 420 |
| Peak week, 5 to 11 Oct | 275 active students, 1,918 pageviews, 675 sessions | PostHog |
| Peak day, 10 Oct | 227 students, 202 of them in Learn | PostHog |
| Bidding week, 26 Oct | 197 students in the bidding tools | PostHog |

External material may quote the best period, as the films do. Two things to keep in mind internally:

- The labels "end-term weeks" (21 Sep, 5 Oct) and "bidding round" (26 Oct) are inferred from usage spikes, not checked against the calendar. Confirm before quoting them as fact.
- Median session time is about 8 seconds, because many visits are quick lookups. Don't quote average session time.

## What the films show that isn't built yet

The films present the plan as finished. Each of these is a real gap until it ships, listed in [ROADMAP.md](ROADMAP.md#whats-next) under "Close what the film promises".

| The film shows | Reality on 16 Nov 2026 |
|---|---|
| Compass for every student | Admins only. Needs Compass-only access, a takedown tool and ISB IT's hosting decision ([COMPASS_HANDOFF.md](COMPASS_HANDOFF.md)) |
| Ideas connected across courses, "what to learn first, and where it leads" | Phase D (checked cross-course links) hasn't started. Today Compass returns separate cards from different courses |
| Compass in Claude for everyone | Admin pilot. Needs ASA's written OK |
| Still useful "years from now, at work" | Sign-in only accepts `@isb.edu`, which lapses after graduation. There is no alumni access |
| The Dossier shows "what last year's batch said" | Student feedback was taken off student pages after ASA's feedback on 30 Oct. Either bring it back with ASA's agreement or drop the line from future cuts |
| "LearnKit" | The app calls it Learn. Pick one name |

## The pitch in three lengths

**One line:** ISB Academics is one home for the MBA year. Learn it once. Use it for life.

**One paragraph:** Every year, hundreds of students from different backgrounds start the MBA, and everything they need lives in ten places. ISB Academics puts it in one: every elective side by side, credits always current, a tutor that brings back what you got wrong, and Compass, which answers a real business problem with what several courses taught, each linked to the class. The entire Mohali batch has signed up, and usage peaks at end-terms and bidding rounds.

**The films:** a 2-minute recruiter film and a 41-second LinkedIn cut (first person, 4:5). Their sources are in `videos/` on the `claude/product-demo-video-61e294` branch, including the design rules for motion work in `videos/isb-academics-film/frame.md`. The rendered videos are not in git.
