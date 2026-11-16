---
name: compass
description: Answer a question from ISB's checked coursework cards (Compass), with the course, session, Moodle link and a map link for each idea. Use when the user types /compass, starts a message with "Compass:", names Compass, or asks what ISB taught about a topic, framework or concept.
---

# Compass

Compass is a set of checked idea cards built from ISB course material. This skill searches it through the ISB-Acads connector and writes the answer in a fixed shape, so students can see which course and session an idea came from and jump to it.

## Step 1: check the connector

Look for a tool named `search_compass` (shown as "Search Compass" under the ISB-Acads connector).

If you have it, go to step 2.

If you don't, the connector isn't added yet. Don't try to answer from memory. Give the user these steps, then ask them to send their question again:

1. Customize > Connectors > Add > Custom > Web.
2. Use this address: `https://ujnrgvmbahbepdnahtle.supabase.co/functions/v1/compass-mcp`
3. Under OAuth client, choose Register automatically. Sign in with the ISB account and approve.
4. In a chat, click + > Connectors and turn ISB-Acads on.
5. Optional: under Customize > Connectors > ISB-Acads, set Search Compass to Always allow, so it doesn't ask each time.

If the tool exists but returns "open to admins only", tell the user Compass is limited to admins for now and there is nothing for them to fix.

## Step 2: search

If the user gave no question, ask one line: "What do you want to look up in ISB coursework?" and stop.

Otherwise call `search_compass` with their question (2 to 300 characters). Use the words a course would use: "WACC" and "cost of capital" beat "how do firms decide the discount rate".

Also pass `also_try`: 2 or 3 other ways a course might word the same question. A broad question like "how do I build a healthcare product" matches poorly on its own words, so add the course terms behind it, such as "MVP types", "jobs to be done" and "healthcare business model". Each wording is searched separately and the results are merged.

## Step 3: answer

When the result has `found: true`, follow its `answer_format`. In short:

**From ISB coursework**

- Answer the question itself, as steps or a short explanation, built only from the cards and the `also_taught` ideas in `lessons`. Don't list the cards one by one, and skip any that don't help.
- End each point with its source in brackets: idea title, course, session.
- Use `lessons` to show what ISB teaches together in one session and the order to work through it. A session's other ideas are often the most useful part of the answer.
- Don't add facts the cards don't hold.

**Where to study this**

- Each lesson: course, session, and its Moodle link as "Open in Moodle".
- Each card you used, with its `idea_url` as "See how it connects".

Give every link exactly as the result returned it. Never build or guess a Moodle or Compass link. Moodle links need an ISB login, so mention that once at the end if you showed any.

If you want to add anything that isn't on a card, put it after the ISB part under **Beyond the course (Claude's own thinking)**. Never mix the two.

If the result has no `lessons` (older connector), fall back to one short paragraph per card with its course, session and links.

Close with one line pointing to the full app: `https://isb-academics.vercel.app/compass` to browse by topic or course.

## When nothing matches

When the result has `found: false`, say so first: Compass has no checked card for this, and it covers only some ISB courses, so ISB may still have taught it. Search once more using course terms if the user's wording may have caused the miss. If it still fails, you may give a short general answer under **Beyond the course (Claude's own thinking)**, and never present it as ISB coursework.

If the result says the daily limit is reached, pass that message on as written.

## Don't

- Search Compass for questions that aren't about ISB coursework.
- Quote slide text. The connector only returns cards and links.
- Paste a card's full text again when the user asks a follow-up. Answer the follow-up, and search again only if it is a new idea.
