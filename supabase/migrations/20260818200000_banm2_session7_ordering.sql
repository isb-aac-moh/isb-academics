-- Session 7 re-sequenced so the notes follow the two decks in the order they were taught.
--
-- Session 7 staples two handouts together: a short marketing-analytics overview deck, then a long
-- product-price optimisation deck. The notes did not read that way. The summary opened with all
-- five formulas -- every one of them from the second deck -- and only reached the mug market and
-- the research table those formulas operate on afterwards, so the symbols arrived before their
-- referents. Below the summary, the compensatory concept carried the ten-customer aggregation and
-- the 20/40/40 shares, which made the non-compensatory concept read as a step backwards and left
-- the logit concept reprinting the same table.
--
-- Nothing is added or dropped; the same material is resequenced, and the through-line is split
-- into a Deck 1 half and a Deck 2 half so the boundary is visible. Concept order itself is
-- untouched -- it comes from question order in learn_questions and already matched the decks.
--
-- Regenerated in full from supabase/banm2-content.py, per that file's instructions: every
-- statement upserts, so replaying sessions 8-10 unchanged is a no-op. The learn_courses insert is
-- stripped, as it would reset `enabled`.

-- BANM2 (Business Analytics for Marketing and Growth) end-term content, sessions 7-10.
--
-- GENERATED FILE. Do not hand-edit — 150KB of quoted prose is not editable by hand, and the
-- generator is what checks the Markdown and the SQL quoting. Edit supabase/banm2-content.py
-- and regenerate. Every statement upserts, so re-running this on a loaded database is safe.
--
-- Prof. Bodapati's half of the course. He told the class the final is written short answers
-- and that multiple-choice is very unlikely, so this course carries no playable questions:
-- every row below is type 'short_answer' with an empty `choices` array and the model answer
-- in `correct_answer`. The app reads that (Course.has_practice in src/learn/lib/db.ts) and
-- shows the question bank instead of the practice loop.
--
-- Sources: the S7-S10 slide decks (overview, product-price optimisation, affinity
-- segmentation + mugs workbook, preliminary ad assessment, ad evaluation and MMM), the
-- BANM_273 course outline, and a cohort study guide covering the same four sessions.
--
-- Sessions 1-6 are Prof. Kolluru's half and the mid-term's scope. They get titles here so
-- the session list reads as deliberately empty rather than broken.

begin;

-- Short-answer questions carry no choices, so the type check has to admit them.
alter table public.learn_questions drop constraint learn_questions_type_check;
alter table public.learn_questions add constraint learn_questions_type_check
  check (type = any (array['formula'::text, 'case_fact'::text, 'short_answer'::text]));

insert into public.learn_course_content (course_code, outline, announcements) values
  ('BANM2', '## What this covers

The end-term is Prof. Anand Bodapati''s four sessions, 7 through 10. Sessions 1-6 are Prof. Kolluru''s half and were the mid-term''s scope; they are listed here for completeness but have no content yet.

The four sessions are one connected argument, so they are worth reading in order:

- **Session 7** turns "what product should we launch?" into an optimisation. Enumerate every candidate product, forecast each one''s share from individual customer preferences, price it against cost, and pick the winner under a stated objective.
- **Session 8** asks who actually buys the winning product. Affinity segmentation weights every customer descriptor by that customer''s probability of buying, which produces a persona and then a positioning statement.
- **Session 9** asks whether an advertisement works, and spends its time on why a before-and-after difference is usually not the answer.
- **Session 10** closes the loop in the field: how much to spend on advertising in total, how to split it, and when to run it.

## How to use this

Each session opens with a walkthrough of that session''s deck. Under it, every concept carries the short-answer questions the exam could ask on it, with a model answer behind each one. Read the concept, try the question in your head, then open the answer.

Everything on the slides is reproduced here — every data table, every worked number, every formula. You should not need the handouts open alongside this. The handouts are still what you carry into the exam, because it is open-handouts; this guide is what you use to understand them.

There are no practice quizzes here on purpose. The professor said the exam is written short answers, so the questions are written to be answered in bullets, the way he asked for.

## How deep to actually go

This is an MBA marketing course, not a statistics course. The exam is written short answers in bullet points. What gets tested is whether you can explain *what a method is for, what it assumes, and what would go wrong* — not whether you can compute.

So treat the material in three tiers:

- **Know cold.** The reasoning. Why share cannot be regressed on features. Why the model is called compensatory. Why a control group works. Why price elasticity sits in the denominator. Why pulsing beats even scheduling. This is where nearly all the marks are.
- **Be able to do slowly, with the handout open.** One customer''s utility as a weighted sum. One logit probability from given utilities. Share times margin. A difference in differences. Dorfman-Steiner with the numbers handed to you. Each is a few lines of arithmetic and he demonstrated each in class as an example of a quantitative short answer.
- **Reference only — do not memorise.** The full ten-customer dataset, the 27-candidate table, the affinity output table, the Robyn adstock equation. They are printed here in full so you can follow any worked example without hunting through the deck, and so you can see the patterns they contain. Nobody is going to ask you to reproduce a 27-row table.

> Prof: His own words on the last session — "I''m not expecting that you will take away all the formulas and calculations. You''ll forget it one hour after the exam, I forecast. But I hope that these other larger ideas is what will stay with you." He also said the exam needs no separate study if you were mentally present and took notes. Read this guide for the ideas; let the tables be tables.

## If the maths notation is unfamiliar

This half of the course has about a dozen formulas. None of them need maths beyond multiplication, division and averaging — but they are written in a notation that assumes you have seen it before. If you have not, this is the whole of it. Every formula in this guide also carries a plain-English reading directly underneath it, so you never have to decode one on your own.

- **Σ (capital sigma)** means "add up". $\sum_i X_i$ is "add up X for every customer i". It is a loop instruction, not an operation — it says *go down the column and total it*.
- **Subscripts** are labels, not multiplication. $u_P$ is "the utility of product P". $Ad_{A,t}$ is "spend on campaign A in week t". The small letter just says *which one*.
- **exp(x)**, sometimes written $e^x$, means "take the number 2.718 and raise it to the power x". Its only job in this course is to turn any number, including a negative one, into a positive one, and to stretch gaps: a slightly bigger x becomes a much bigger exp(x). That is what makes the logit formula turn "somewhat preferred" into "much more likely to be bought".
- **log** is the reverse of raising to a power, and in this course it is always **base 10**. log(10) = 1, log(100) = 2, log(1) = 0. Its job is to make ratios symmetric: twice the average and half the average come out as +0.30 and −0.30, equal-sized deviations in opposite directions, instead of 2 and 0.5, which look nothing alike.
- **A probability** is a number between 0 and 1 that reads as a share of chances. 0.40 means a 40% chance. When you average probabilities across people you get a market share, which is the single most-used step in this half of the course.
- **An elasticity** is a percentage-for-a-percentage. "Advertising elasticity is 0.1" means a 1% increase in advertising spend produces a 0.1% increase in sales. It is a unit-free sensitivity, which is why it can be compared across campaigns of very different sizes.
- **∝ (proportional to)** means "moves in step with, up to some common multiplier". $Ad_A \propto \text{Elasticity}_{Ad_A}$ says split the money in the same ratio as the elasticities, without saying what the total is.

> Prof: He said explicitly that he does not expect the formulas to be what you take away — "you''ll forget it one hour after the exam". What he wants is the reasoning each formula encodes. So if you are short of time, learn what each formula is *for* and what would change if its assumption broke; the arithmetic is the easy part to reconstruct.', 'End-term covers Sessions 7-10 only (Prof. Bodapati''s half). Final exam is 35% of the grade.
Format announced in class: short answers, qualitative and quantitative, and he said multiple-choice is very unlikely — the course outline''s older "short answers and MCQs" wording is superseded.
Closed book, open handouts: the slide printouts you were given, with your own annotations on them. He said the very first handout was not distributed in hard copy, so one handwritten sheet is allowed for that material.
Answers may be asked in "one, two or three sentences", by which he meant bullet points, not prose.')
on conflict (course_code) do update set outline = excluded.outline, announcements = excluded.announcements;

-- learn_session_content: 10 rows
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 1, 'Introduction to Business Analytics and Machine Learning', 'Prof. Kolluru''s half of the course, and the mid-term''s scope. Not covered by this end-term guide, which starts at Session 7.')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 2, 'Predictive Models and How to Trust Them', 'Prof. Kolluru''s half of the course, and the mid-term''s scope. Not covered by this end-term guide, which starts at Session 7.')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 3, 'Unstructured Data: Text and Images', 'Prof. Kolluru''s half of the course, and the mid-term''s scope. Not covered by this end-term guide, which starts at Session 7.')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 4, 'Similarity, Segmentation, Recommendations and Positioning', 'Prof. Kolluru''s half of the course, and the mid-term''s scope. Not covered by this end-term guide, which starts at Session 7.')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 5, 'Agentic and Generative Analytics', 'Prof. Kolluru''s half of the course, and the mid-term''s scope. Not covered by this end-term guide, which starts at Session 7.')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 6, 'From Analytics to Action: Decision Design with Rules and Guardrails', 'Prof. Kolluru''s half of the course, and the mid-term''s scope. Not covered by this end-term guide, which starts at Session 7.')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 7, 'Marketing Analytics Overview and Product-Price Optimisation', '## Where this session sits

This is the start of Prof. Bodapati''s half, and it deliberately changes altitude. Sessions 1-6 sat with the analyst: build a model, check whether it can be trusted. Sessions 7-10 sit with the manager who has to decide something. His opening illustration was a Fire Stick team proposing exclusive behind-the-scenes football interviews as a differentiator: the product manager supplies the idea, the analyst estimates what it would do to profit, the data engineer scales whatever gets chosen.

Two decks are stapled together here, and they are meant to be taken in that order. A short overview deck maps the whole of marketing analytics and says what makes it a discipline of its own. A long product-price optimisation deck then takes one region of that map — the value creation pod — and works it end to end on a single example. The concepts below follow the same sequence.

## The one-sentence version

Marketing analytics is disciplined decision-making. You are given a set of possible actions and you have to say which one is best — not produce an accurate forecast of every possible outcome.

## The through-line of the session

**Deck 1, the overview — what kind of discipline this is.**

- Marketing analytics splits into four pods; this half of the course lives in the first two.
- A marketing decision is $R = f(A)$: pick the action A with the best outcome R. Estimating R accurately for every A is not the goal.
- Firms answer that question three ways — evolved best practice, theory, empirical analytics — and this course does the third.
- The f should be **structural**, built from how customers actually choose, not a flexible curve fitted to history.
- The inference has to be **causal**, which is what Sessions 9 and 10 go on to do.

**Deck 2, product-price optimisation — the value creation pod, worked end to end.**

- The decision becomes an algorithm: enumerate every candidate product, forecast each one''s share customer by customer, cost it, and rank under a stated objective.
- Individual choice can be modelled compensatorily (utility as a weighted sum) or non-compensatorily (cutoffs and eliminations).
- The deterministic "highest utility wins" prediction is then softened into logit probabilities, and the average probability across customers is the predicted share.
- Share times margin is expected profit per prospect, and the whole 27-candidate table can be ranked on it.
- Which candidate wins depends entirely on which objective the firm names.
- The algorithm settles the core attributes and nothing more; QFD and the market-driven / market-driving contrast are what sits past it.

## The mug market, once, so the numbers stay straight

Every number in Deck 2 comes out of one example, set up here so the concepts below can simply use it.

Attributes and levels: Price 30 / 10 / 5 dollars. Capacity 12 / 20 / 32 oz. Cleanability Difficult (7 min) / Fair (5 min) / Easy (2 min). Brand A / B / C.

Two incumbents are fixed. Incumbent 1 is priced at 30 dollars, 20 oz, Easy to clean, Brand A. Incumbent 2 is priced at 10 dollars, 20 oz, Fair, Brand B. Our brand is fixed at C, so we have 3 x 3 x 3 = 27 candidates.

> Trap: The deck reuses the label "Product 3" for two different candidates. Early on, "Product 3" is the 5-dollar, 12 oz, Easy candidate, which is candidate 21 in the full table. From the affinity work onward, "Product 3" is the profit-optimal candidate 6: 30 dollars, 20 oz, Easy. Their purchase probabilities are completely different, so never carry numbers between the two.

## The full market research data

Reference table — printed so you can follow any worked example without the deck, not to be memorised. Read the shape of it, not the cells.

Ten customers, the whole dataset the session runs on. Columns 1 to 12 are that customer''s 1-to-7 rating of each level; the last four are their importances, which sum to 100 across the row. Everything else in Session 7 is computed from this table.

| Cust | P30 | P10 | P5 | 12oz | 20oz | 32oz | Diff | Fair | Easy | BrA | BrB | BrC | IPr | ICp | ICl | IBr |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | 3 | 7 | 1 | 7 | 6 | 1 | 2 | 7 | 7 | 5 | 1 | 9 | 55 | 12 | 24 |
| 2 | 1 | 6 | 7 | 1 | 7 | 6 | 1 | 6 | 7 | 7 | 5 | 1 | 12 | 35 | 21 | 31 |
| 3 | 1 | 6 | 7 | 7 | 4 | 1 | 1 | 3 | 7 | 1 | 3 | 7 | 71 | 6 | 10 | 12 |
| 4 | 1 | 6 | 7 | 7 | 1 | 3 | 1 | 5 | 7 | 7 | 1 | 5 | 17 | 4 | 56 | 23 |
| 5 | 1 | 4 | 7 | 1 | 7 | 2 | 1 | 3 | 7 | 3 | 1 | 7 | 59 | 20 | 9 | 12 |
| 6 | 1 | 5 | 7 | 1 | 7 | 7 | 1 | 4 | 7 | 3 | 1 | 7 | 11 | 0 | 70 | 19 |
| 7 | 1 | 7 | 7 | 1 | 7 | 7 | 1 | 3 | 7 | 3 | 7 | 1 | 57 | 16 | 10 | 17 |
| 8 | 1 | 6 | 7 | 1 | 7 | 2 | 1 | 6 | 7 | 5 | 7 | 1 | 41 | 15 | 31 | 12 |
| 9 | 1 | 5 | 7 | 1 | 5 | 7 | 1 | 6 | 7 | 7 | 4 | 1 | 26 | 32 | 17 | 25 |
| 10 | 1 | 7 | 7 | 6 | 7 | 1 | 1 | 5 | 7 | 3 | 7 | 1 | 53 | 13 | 13 | 20 |

Two features of the table are worth noticing before any arithmetic. Every customer rates the 5-dollar price at 7 and the 30-dollar price at 1 — nobody prefers paying more. And every customer rates Easy cleaning at 7 and Difficult at 1. So price and cleanability have an agreed direction, and what separates customers is how much they *care*, which lives in the importance columns. Capacity and brand are where customers genuinely disagree about which level they want.

> Note: In the real study this is 400 respondents. Ten is a teaching simplification, which is why the shares come out as round-ish numbers.

## Formulas from this session

All five belong to Deck 2, and they are listed in the order the algorithm uses them: build the ratings, score a product, turn scores into probabilities, calibrate the one free parameter, then price the result. Each is followed by what it says in words. If you read nothing else in this section, read the italic lines.

**Rescaling ratings** into a common 1 to 7 band — the step that turns raw research output into the table above.

$$\text{Rescaled} = \text{TargetMin} + (\text{TargetMax} - \text{TargetMin}) \times \frac{r - r_{\min}}{r_{\max} - r_{\min}}$$

*Standard "convert one scale to another" arithmetic. The fraction asks how far along its own range this rating sits, as a number from 0 to 1. Multiply that by the width of the new scale and add the new scale''s floor. It is exactly how you would convert a mark out of 30 into a mark out of 7.*

**Compensatory utility** — scores how much one customer likes one product.

$$U(P) = \sum_{a \in \text{Attributes}} \text{Importance}_a \times \text{Rating}(\text{Level}_a(P))$$

*For each attribute in turn — price, capacity, cleanability, brand — multiply how much this customer cares about that attribute by how well this product scores on it. Add the four answers together. That total is the customer''s utility for that product. It is a weighted marks-total: the attribute weights are the importances, the marks are the 1-to-7 ratings.*

**Logit choice probability** — turns those utility scores into a chance of buying.

$$\Pr(\text{buy } P) = \frac{\exp(c\,u_P)}{\exp(c\,u_P) + \sum_j \exp(c\,u_{I_j})}$$

*Take our product''s utility and every competitor''s utility, multiply each by c, and exponentiate each one so they all become positive. Our product''s share of that total is its probability of being bought. It is "our score divided by everybody''s scores", with the exponential applied first so that a modest lead in utility becomes a large lead in probability. c controls how aggressively that happens.*

**Practical value for c**, based on past studies:

$$c = \frac{100}{12 \times \text{range of utilities over the product space}}$$

*A rule of thumb for how confident to be. Work out the best utility any product could score and the worst, subtract to get the range, multiply by 12, and divide 100 by it. Wider possible spread of utilities means a smaller c, which keeps the predicted probabilities from collapsing onto one product.*

**Profit**, with market size constant across candidates:

$$\text{Profit}(P) = \text{MarketSize} \times s(P) \times [\text{Price}(P) - \text{Cost}(P)]$$

*How many people are in the market, times the fraction of them who buy this product, times the money made per unit sold. The first two multiply to units sold; the bracket is the margin. Because market size is the same number for all 27 candidates, it cannot change which one wins, so it gets divided out and the ranking is done on share times margin alone.*')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 8, 'Affinity Segmentation, Personas and Positioning', '## Where this session sits

Session 7 chose a product. An advertising agency cannot do anything with a product specification alone, so the product team owes it an **advertising brief**, and the brief has exactly two parts: a persona of the people likely to buy, and a positioning statement. This session derives both from the same purchase probabilities that produced the market share.

That is also why "communication" and "delivery" are one pod rather than two. Advertising and channel look like different jobs, but both signal the same brand identity. Bodapati''s counterexample was premium creative paired with a kirana-store channel: the two contradict each other.

## The one-sentence version

Weight every customer descriptor by that customer''s probability of buying our product, compare the result to the market average, and the descriptors that stand out become the persona and the positioning claim.

## The through-line of the session

- The affinity output table is one row per product plus a market row, one column per descriptor. Every cell is a probability-weighted average.
- A persona should only mention what makes the group **different**, which is what lift and log lift measure.
- Big positive and big negative log lifts are both interesting. Near-zero is the boring one.
- The persona feeds two decisions directly: who and what situations to depict in the creative, and where to sell.
- The positioning statement needs a competitor, and "competitor" has three different operational meanings that can point at different products.
- The claim itself is whichever attribute gives us the largest utility advantage over the chosen competitor.

## Formulas from this session

**Affinity weighted mean** of descriptor X for likely buyers of P — the average value of some customer characteristic, among the people likely to buy our product.

$$\bar{X}_P = \frac{\sum_i X_i \Pr_i(P)}{\sum_i \Pr_i(P)}$$

*This is an ordinary average with one twist: instead of counting every customer equally, each customer counts in proportion to how likely they are to buy our product. Top line: for each customer, multiply their value of the characteristic (their age, their income, their price-importance) by their probability of buying P, and add those up. Bottom line: add up the probabilities on their own. Divide. Someone with a 0.9 chance of buying pulls the average nine times as hard as someone with a 0.1 chance, which is exactly what "what are our buyers like?" should mean. The bottom line is what keeps it a genuine average rather than a total.*

**Lift and log lift** against the whole market — how unusual that average is.

$$\text{Lift} = \frac{\text{segment mean}}{\text{overall mean}}, \qquad \text{Log lift} = \log_{10}(\text{Lift})$$

*Lift divides our buyers'' average by the market''s average. Above 1 means our buyers are higher on that characteristic than the market, below 1 means lower, exactly 1 means identical. Log lift then takes the base-10 log of that ratio, purely so the scale is symmetric: twice the market average becomes +0.30 and half the market average becomes −0.30, which are visibly equal-and-opposite. Zero means "same as the market". A log lift of about +0.3 is roughly double, about −0.3 is roughly half.*

> Trap: The logs here are base 10, not natural logs. Using ln would give −0.486 for price importance instead of the −0.211 in the table. The conclusions are identical either way — only the numbers move — but if you are recomputing a value to check it, use log base 10.

**Utility contribution of one attribute**, used to pick the positioning claim:

$$\text{Importance}_a \times \text{Rating}(\text{Level}_a(P))$$

*One term out of the utility sum from Session 7, pulled out on its own. It measures how much a single attribute contributes to the customer''s overall liking of the product: how much they care about it, times how well we score on it. Compute it for us and for the competitor, on the same attribute, and the gap is our advantage on that attribute.*

## The affinity output table for the mug data

The candidate here is the profit winner: 30 dollars, 20 oz, Easy, Brand C. IPr, ICp, ICl and IBr are the importance weights for price, capacity, cleanability and brand.

| Segment | IPr | ICp | ICl | IBr | Income | Age | Sports | Grad school |
|---|---|---|---|---|---|---|---|---|
| Product 1 buyers | 17.55 | 28.24 | 29.96 | 24.03 | 62.17 | 49.09 | .36 | .10 |
| Product 2 buyers | 48.10 | 18.06 | 15.92 | 17.35 | 49.96 | 42.77 | .30 | .17 |
| Product 3 buyers | 21.90 | 9.86 | 48.85 | 19.34 | 61.36 | 45.91 | .84 | .49 |
| Overall market | 35.6 | 19.6 | 24.9 | 19.5 | 55.1 | 45 | .4 | .2 |

Read every cell conditionally. 61.36 is the average income among likely buyers of our product; .49 says roughly 49% of that buyer mass has been to graduate school.

> Trap: Low capacity importance (9.86) does not mean these buyers want a small mug. Their highest mean capacity rating is still 20 oz at 5.63. Importance says how much the attribute moves the decision; the level ratings say which level they like.')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 9, 'Preliminary Advertising Assessment and Causal Design', '## Where this session sits

The brief has been translated into creatives and there may be twenty or thirty creative-by-outlet combinations on the table. Preliminary evaluation is the cheap, controlled step that cuts them to three or five before anyone buys field media. Almost the whole session is about one question: when you measure a change after showing an ad, how much of that change was the ad?

## The one-sentence version

An observed before-and-after change is the true effect plus whatever else moved in the meantime, so the design''s whole job is to produce a second measurement that isolates the "whatever else" and subtracts it.

## The through-line of the session

- Preliminary metrics run in a hierarchy: attention, then recall, then persuasion, then behaviour.
- Observational assessment compares different people under different actions. Causal assessment wants the same people under both actions, which is impossible, so designs approximate it.
- The before-after design gives $R_2 - R_1$, which contains the effect plus contemporaneous drift plus measurement non-equivalence.
- A control group estimates that bias directly, because its own true effect is zero by construction.
- Drop the pre-measures and you get the after-only design, which works only if the groups were equivalent to begin with.
- A control group is only a control if two things hold: equivalence, and no leakage between the groups.
- If you cannot have a second group, alternate treatment and no-treatment periods on the same group instead.

## Formulas from this session

Everything here is subtraction. There is no hard maths in this session at all — the difficulty is entirely in knowing which two numbers to subtract and what assumption makes that subtraction legitimate. R with a number after it just labels a measurement: R1 is the first reading, R2 the second, and so on.

**Before-after, decomposed.** E is the true effect, D is contemporaneous drift, MNE is measurement non-equivalence, and B is the two biases added together:

$$R_2 - R_1 = E + D + \text{MNE} = E + B$$

*The movement you actually observe is not the effect of the advertisement. It is the effect of the advertisement plus everything else that changed in the meantime. D covers real attitude changes caused by something other than the advertisement; MNE covers apparent changes that are artifacts of how you measured. Rearranged, E = (R2 − R1) − B: to recover the true effect you must subtract the bias, so the entire design problem is finding a way to measure B.*

**Before-after with a control group**, which is a difference in differences:

$$E = (R_2 - R_1) - (R_4 - R_3)$$

*How much the treated group moved, minus how much the untreated group moved. The control group got no advertisement, so its true effect is zero and everything it moved by is bias. If the two groups are alike, that is the same bias the treated group suffered, so subtracting it leaves the advertisement''s effect alone. The name says it: a difference (before-to-after in one group) minus a difference (before-to-after in the other).*

**After-only with a control group**, once baseline equivalence gives $R_1 = R_3$:

$$E = R_2 - R_4$$

*Just compare the two groups'' final readings. This is A/B testing. It follows from the line above: rearrange it to (R2 − R4) + (R3 − R1), and if the two groups genuinely started level then R3 − R1 is zero and drops out. The pre-measurements were not needed because they would have cancelled — but that is only true when the groups really are equivalent, which needs very large samples.*

**Time series on one group**, alternating treatment and no treatment:

$$E = (R_2 - R_1) - (R_3 - R_2) = 2R_2 - (R_1 + R_3)$$

*The same difference-in-differences idea with time playing the role of the second group. Instead of comparing a treated group against an untreated group, compare the interval when the treatment was on against the adjacent interval when it was off, in the same people. The right-hand form is just the left one tidied up: how far R2 sits above the average of the two readings on either side of it.*

**Many alternating periods**, estimated by regression:

$$\text{Response} = b_0 + b_{ti}\,\text{Time index} + b_{tr}\,\text{Treatment}$$

*Build a table with one row per period: the period number, a 0 or 1 for whether the advertisement ran, and the response. Fit a straight line. Treatment is a 0/1 switch, so its coefficient b_tr is literally "how much higher the response is in periods when the advertisement ran", which is the estimate of E. The time-index term is there to soak up any steady upward or downward trend, so the trend does not get mistaken for the advertisement.*

## The Toyota study the whole session hangs on

Around 500 visitors to a Kmart in Wisconsin on 26 December are invited to preview a new streaming show at a market-research firm. 120 turn up. An interviewer measures their attitude to Toyota face to face on a 7-point scale. They watch an hour-long pilot with Toyota commercials and unrelated ones cut into it. A week later the same questionnaire is mailed to them at home with a 20-dollar Amazon gift card. 80 come back.

Every design in the session is a modification of this one study, so it is worth being able to redraw it: R1, then X, then R2, and the population funnel above it that goes from "potential Toyota buyers" to "Kmart invitees, self-selected" to "the sample that showed up".')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;
insert into public.learn_session_content (course_code, session, title, summary) values
  ('BANM2', 10, 'Field Evaluation and Media Mix Modelling', '## Where this session sits

The last session does two things. It closes the course''s argument about what analytics is actually for, and it answers the three money questions of field advertising: how much in total, split how, and run when.

## The one-sentence version

Once advertising is in the field you rarely know who saw what, so you model aggregate sales against aggregate campaign intensities, and then either optimise that model or fall back on the elasticity ratio that Dorfman-Steiner gives you.

## The through-line of the session

- The immediate value of analytics is not the number. It is that producing the number forces the team to be concrete about the objective, the customer, and who the competitor is.
- Exhaustive structural search is not always available. Where the preference, feature, competitor and cost data do not exist, STP and the 3Cs and 4Ps are still the right tools, and he put that at roughly 70% of situations today.
- Advertising assessment varies on four context factors, giving a micro extreme and a macro extreme. Most large budgets sit near the macro extreme.
- MMM makes three decisions: total spend, split across campaigns, and pattern over time. The first two are macro scheduling, the third is micro scheduling.
- A realistic response function needs adstock carryover and saturation, which makes it nonlinear and data-hungry.
- Dorfman-Steiner replaces all that with a ratio of elasticities.
- The micro schedule matters because repeated identical exposure wears out, which is the argument for going dark.

## Formulas from this session

**Advertising volume:**

$$\text{GRP} = \text{Reach percent} \times \text{Frequency}$$

*How much advertising pressure a plan delivers. Reach is the percentage of the target population who see it at all; frequency is how many times the average person among them sees it. Multiply for total exposure pressure. 20% of the population seeing it 5 times and 50% seeing it twice are both 100 GRPs, which is precisely why reach and frequency stay separate decisions — the same GRP number can describe two very different plans.*

**The general MMM problem, unconstrained:**

$$\text{Profit} = \text{Sales}(Ad_{A,t}, Ad_{B,t}, \ldots) \times \text{Margin} - \text{Cost}(Ad_{A,t}, Ad_{B,t}, \ldots)$$

*Choose how much to spend on each campaign in each week so that profit is as large as possible. Sales are written as a function of all the campaign spends because that is the thing you have to estimate; multiply the resulting sales by margin to get gross profit, then subtract what the advertising cost. Nothing subtle in the statement — the difficulty is entirely in knowing the sales function.*

**The Robyn-style channel response**, saturation on top of carryover:

$$\text{Sales}_A(Ad_{A,t}) = \beta_{0,A} + \beta_{1,A}\,\frac{(\text{Adstock}_A)^{\gamma}}{\alpha^{\gamma} + (\text{Adstock}_A)^{\gamma}}$$

$$\text{Adstock}_{A,t} = Ad_{A,t} + \delta Ad_{A,t-1} + \delta^2 Ad_{A,t-2} + \delta^3 Ad_{A,t-3} + \ldots$$

*Read the second line first. Adstock is advertising memory: this week''s spend, plus a fraction δ of last week''s, plus δ² of the week before, and so on. δ sits between 0 and 1, so each older week counts for less — with δ = 0.5, last week counts half, the week before a quarter. That is carryover: advertising you paid for weeks ago is still working.*

*The first line then converts accumulated memory into sales. The fraction is a saturation curve: when adstock is small it sits near 0, when adstock is very large it approaches 1, and it can never exceed 1. So the first rupees of advertising buy a lot of response and later ones buy progressively less. α sets where the curve bends, γ sets how sharply. The beta-zero term is the sales you would get with no advertising and the beta-one term is the most that this channel could ever add.*

> Prof: You are not expected to derive, estimate or reproduce this. He put it up to make a managerial point — that it looks complicated, has five or more parameters per channel, and would be fitted on roughly 156 weekly observations. That mismatch is the argument for the much simpler rule below.

**Dorfman-Steiner**, for the total, then for each campaign:

$$\text{Advertising} = \frac{\text{Advertising elasticity}}{-\text{Price elasticity}} \times \text{Sales}, \qquad Ad_A \propto \text{Elasticity}_{Ad_A}$$

*Advertising spend should be a fraction of your sales, and that fraction is the ratio of the two elasticities. Read it one piece at a time. Bigger sales means a bigger company and a bigger advertising budget. A higher advertising elasticity means advertising works well here — it is effectively the return on advertising — so spend more. The price elasticity in the denominator is the piece that surprises people; the two separate reasons it belongs there are worked through in the Dorfman-Steiner concept below. The minus sign is bookkeeping: price elasticity is a negative number by convention, and the minus turns it positive so the whole fraction is positive.*

*The second half says the split between campaigns follows the ratio of their individual elasticities — the campaign that converts spend into sales twice as efficiently gets twice the money.*

## Where the classic frameworks live inside the algorithm

| Classic construct | Where it actually sits |
|---|---|
| Product | The candidate feature vector P chosen by the optimisation |
| Price | One of the candidate''s attribute levels, optimised with the rest |
| Promotion | Persona plus positioning, becoming the advertising brief and then the creative |
| Place | Channel choice driven by the persona |
| Customer (C) | Customer **needs**, held concretely as the preference parameters. Not demographics |
| Competition (C) | The incumbent products, entering the utility comparison directly. There is no white-space analysis |
| Company (C) | Capabilities and core competence, showing up concretely in the cost structure |
| S and T of STP | Deliberately not done. The algorithm searches the whole customer and product space instead of pre-selecting a target |

## Why no segmentation — the Tata Nano point

A student in Session 9 asked why the log lift benchmarks against the overall market rather than against the segment we want to target. The answer is that in this framework **there is no segment we decided to target**, and that is the entire departure from STP.

- The product is not chosen by first picking a tier — premium, value, economy — and then designing for it. It is chosen by evaluating every candidate product against every customer and ranking on the stated objective.
- Segmentation enters only afterwards, and only for **advertising**: once a product wins, affinity segmentation asks who is actually likely to buy it.
- So the two uses of "segment" are cleanly separated. In STP they are the same exercise doing two jobs, which he says is where a great deal of confusion comes from.

He called this the reason the framework avoids the **Tata Nano problem** — committing to a target segment up front, designing to that commitment, and discovering the intended buyers were not the eventual market. It is the same failure the Innova, Yulu and OYO examples above illustrate: the algorithm does not need to guess the target correctly because it never guesses.

> Note: He promised a fuller treatment of the Nano case in the last session and never got to it — the session ran out on media mix modelling. The argument above is what he actually gave, in Session 9. Do not expect or invent case detail about the Nano itself.

> Prof: A related framing he repeated — analytics is **not** "numerical marketing". Pitch it that way to a McKinsey client or an internal stakeholder and you lose, because marketers are largely not numerate. Analytics is *more carefully thought-out* marketing. Every claim gets an operational definition and every assumption gets exposed.

> Prof: He pushed back hard when students said the Customer C was demographics or the Competition C was white space. His point is that the value of analytics is precisely that every term in a framework gets an operational location in the data.

> Prof: On the Customer C specifically, his line was that most people who apply the 3Cs and STP "have not read Kotler" — because in Kotler''s own formulation the customer C **is** customer needs, not age and demographics. The framework was never wrong; it is applied loosely because case discussion does not force anyone to be precise about it. Building the algorithm does force it.')
on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary;

-- learn_concepts: 27 rows
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_marketing_pods', 'The Four Marketing Analytics Pods', 'Marketing analytics splits into four pods. The first two are where Sessions 7-10 live.

**Value creation.** Forecasting primary demand, exploratory research to find the factors customers decide on, measuring customer preference, and specifying the optimal product and price.

**Value communication and delivery.** Characterising customer segments, formulating the positioning statement, assessing advertising effects and media planning, and choosing distribution, salesforce and channels.

**Customer acquisition.** Assessing customer value, scoring leads, and scoring lead sources — macro media such as TV and radio, micro media such as search and display.

**Customer development and retention.** Cross-sell and recommendation systems, loyalty programmes, attrition detection, and value reinforcement through communities, social media, email and satisfaction measurement.

## Why the first two feel strategic and the last two feel tactical

The first two pods decide about a product, a brand, a market or a channel system, and those choices stick for years. The last two decide about one customer at a time: acquire this lead or not, cross-sell this person or not, save this account or let it churn. Feedback is faster and the action can be reversed quickly.

| | Value creation / communication | Acquisition / development |
|---|---|---|
| Unit of decision | Product, brand, market, channel system | An individual customer or lead |
| Horizon | Longer; choices persist a few years | Shorter; changeable quickly |
| Style | Macro, strategic | Micro, tactical, CRM |
| Firms used in class | American Express, Apple | Capital One, Kotak, Dell |

Amazon was the exception he named: strong across all four.

> Prof: He described acquisition as sowing the relationship and development and retention as harvesting it. Sophisticated acquisition is not "win any sale" — it starts by asking which customers and which channels bring high lifetime value.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_decision_frame', 'Analytics as Decision Making', 'A marketing decision problem is: given possible actions A1, A2, A3 and their result outcomes R1, R2, R3, find the action with the best outcome. Written compactly, estimate $R = f(A)$ and choose the A that maximises R.

> Trap: The goal is **not** to estimate R accurately for every A. A model that gets every point prediction slightly wrong is still useful if it ranks the actions correctly. Answering "marketing analytics is about predicting outcomes accurately" misses the whole framing.

## Three ways firms actually decide

**Evolved best practices.** Use what has historically worked here or in the industry. The word evolved is doing the work: evolution needs trial and error, so a playbook is slow and costly to build. It tracks gradual change perfectly well. What it cannot do is react to a sudden shock. His example was Apple-style launch scarcity, playful in normal times and tone-deaf under COVID. Students added tunnel vision: a firm that only repeats what worked never considers a genuinely different action.

**Theory and justified assumptions.** Reason from an explicit model. His standing example is monopoly pricing, Optimal Price = MC x PED / (PED + 1). The appeal is that a manager gets an action out of transparent assumptions. The weakness is that a valid theory may not exist or its assumptions may not fit — a monopoly formula does not mechanically solve a duopoly where a rival reacts.

**Empirical analytics.** Estimate $R = f(A)$ from data and pick the best A.

## Three things that make marketing analytics its own discipline

- **Decision making**, not prediction for its own sake.
- **Structural modelling**, not an arbitrary flexible function. The f should encode why an action produces an outcome.
- **Causal impact** of moving from one action to another, not description or prediction. Two approaches: causal inference with observational data (CIOD), and design and analysis of business experiments (DABE).

> Prof: On selling this to a client, he warns that "our model is more accurate" threatens a CMO with real domain expertise. The pitch that works is that the process makes the decision explicit, disciplined and defensible. Senior people may distrust the number and still value the rigour behind it.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_blackbox_failures', 'Structural Modelling and the Three Black-Box Failures', 'The tempting shortcut for forecasting a new product''s share: take every product already on the shelf, put observed share in the Y column and price, capacity, cleanability and brand in the X columns, fit a flexible model, then plug in the new product. His concrete version was a shelf census in a Big Bazaar.

There are three separate reasons this fails.

- **Observed share is confounded.** Share is not generated by the feature vector alone. Advertising, distribution and every other marketing action are baked into it, so the fitted mapping is not the pure effect of the product on share.
- **Degrees of freedom.** Many categories have few products (rows) and many attributes and levels (columns). There is not enough data to estimate a rich share surface.
- **Genuinely new attributes have no history.** If no product has ever had the feature, the historical data contain no variation to learn from. His example: fresh juice in a container that turns blue when the juice has spoiled.

## What structural modelling does instead

Build the share up from how a customer chooses. Each consumer has preference parameters, each candidate product produces a utility, utility produces a choice probability, and probabilities aggregate to share. The two ground truths this respects are that a 40% predicted share means 40% of the customer mass buys, and that a customer buys because the product beats the alternatives available to them.

That structure also solves the third failure directly: market research can describe a hypothetical feature to a respondent and elicit how much they value it, which no amount of historical shelf data can do.

> Trap: State all three failures separately. Answering only "the data are confounded" gets a third of the marks.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_product_optim_pipeline', 'The Product-Price Optimisation Algorithm', 'The value-creation problem becomes an optimisation. A product P is a vector of attribute levels. Build every feasible P and, for each one:

1. Compute predicted expected market share s(P) against the incumbent set, by structural modelling rather than a black-box method. For each consumer, work out how likely they are to buy P from their preference parameters, using a compensatory or non-compensatory model. Then aggregate across consumers.
2. Compute predicted cost(P) from the production team''s cost data.
3. Compute predicted expected profit.

The profit decomposition:

$$\text{Sales volume}(P) = \{\text{persons in the future market}\} \times s(P)$$

$$\text{Profit margin}(P) = \text{Price}(P) - \text{Cost}(P)$$

$$\text{Profit}(P) = \{\text{persons in the future market}\} \times s(P) \times [\text{Price}(P) - \text{Cost}(P)]$$

Market size is the same for every candidate, so it drops out of the ranking. What is left is the scaled objective, expected profit per person or per prospect:

$$\frac{\text{Profit}(P)}{\text{persons in the future market}} = s(P) \times [\text{Price}(P) - \text{Cost}(P)]$$

## The hard part

Price is a decision variable and cost comes from production. The genuinely difficult unknown is s(P): how individual customers will choose the candidate against the incumbents. That is why most of the session is spent on choice models.

## When 27 candidates becomes too many

Nothing forces the candidate set to use only the three levels that were measured. With 7 levels each of price, capacity and cleanability there are already 343 own-brand candidates, and the preference ratings for the new levels have to be interpolated or extrapolated. With more attributes still, complete enumeration stops being feasible: treat it as a continuous problem and use standard optimisation, for example Excel Solver.

> Trap: The scope here is the managerial formulation, not the optimiser. Do not spend revision time on Solver mechanics.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_compensatory_utility', 'The Compensatory Utility Model', 'Market research supplies, for each customer, a 1-to-7 preference rating for every level of every attribute plus attribute importances that sum to 100. The compensatory model then scores a product as the importance-weighted sum of its level ratings:

$$U(P) = \sum_{a \in \text{Attributes}} \text{Importance}_a \times \text{Rating}(\text{Level}_a(P))$$

The likelihood of buying P rises with U(P).

It is called compensatory because weakness on one attribute can be paid for by strength on another. No single bad attribute automatically kills the product.

## Where the ratings and importances come from

That sum needs its inputs in a particular shape, so this is the step before any arithmetic.

Conjoint analysis produces part-worths, not ratings and importances. The range of the part-worths within an attribute becomes that attribute''s importance, and the part-worths themselves are rescaled into a common 1-to-7 band:

$$\text{Rescaled} = \text{TargetMin} + (\text{TargetMax} - \text{TargetMin}) \times \frac{r - r_{\min}}{r_{\max} - r_{\min}}$$

For customer 1 the part-worth ranges are 4.5 on price, 27.5 on capacity, 6.0 on cleanability and 12.0 on brand, which give importances of 9, 55, 12 and 24 — the four numbers the worked example below runs on.

The anchoring matters: if the ratings within each attribute are not pinned to the same minimum and maximum, the importances are not comparable across attributes and the weighted sum is meaningless.

> Prof: How conjoint elicits part-worths is a market-research topic and he explicitly puts it outside this course. The manager consumes the preference parameters.

## Worked: customer 1 across the three products

The candidate here is the 5-dollar, 12 oz, Easy, Brand C mug, up against the two incumbents. Customer 1 has importances of 9 for price, 55 for capacity, 12 for cleanability and 24 for brand.

$$u_1 = 9(1) + 55(7) + 12(7) + 24(7) = 646$$
$$u_2 = 9(3) + 55(7) + 12(2) + 24(5) = 556$$
$$u_3 = 9(7) + 55(1) + 12(7) + 24(1) = 226$$

Highest utility is product 1, so the deterministic forecast for this customer is product 1.

> Trap: An importance of 55 on capacity does **not** mean the customer wants a big mug. It means capacity moves their decision a lot. Their level ratings say which capacity they want — here 20 oz rated 7, not 32 oz.

## What happens to this next

Two things, and they are the next two concepts in order. First the psychologist''s objection to the whole weighted-sum idea, which produces a different family of choice rules. Then the same four-term sum repeated for all ten customers and aggregated into a market share — at which point the near-ties in the utility table force the switch from a single predicted choice to probabilities.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_noncompensatory_rules', 'Non-Compensatory Choice Rules', 'Using a customer''s preference parameters to work out whether they will buy is a discipline in its own right, called **choice modelling**. It has two approaches, and he pointed out that both have won Nobel prizes — the economist''s utility-and-logit approach, and the psychologist''s heuristics approach, whose intellectual home is Kahneman''s *Thinking, Fast and Slow*. Neither is the "wrong" one.

The compensatory model is the economist''s. The psychologist''s alternatives say that a bad score on something that matters cannot always be bought back.

The psychologist''s two objections to the economist''s model are worth stating, because they explain where the heuristics come from:

- People do not actually know their own preference numbers. They know the *ordering* of what matters to them, not that capacity is worth 55 and brand 24.
- Even if they did know, computing a four-term weighted sum for every product on the shelf is not what a human brain does in a shop.

**Lexicographic.** Take the most important attribute. Pick whichever product is best on it. If there is a tie, go to the next most important attribute, and so on. For customer 1 in the deck this selects product 1.

**Elimination by aspects (EBA).** Set a minimum mental cutoff on each attribute. Starting with the most important, throw out every product that misses the cutoff, then move to the next attribute, until one product is left. With the deck''s cutoff of 1.5, customer 1 selects product 2.

The name follows from the mechanics: once a product is eliminated for missing a threshold on an important attribute, being excellent on a less important one cannot bring it back.

## Which model should a manager use?

His answer is empirical: whichever predicts choices better in that setting. As a tendency, compensatory models fit B2B purchasing better and non-compensatory rules fit B2C better. The reasoning is organisational — B2B decisions involve several stakeholders, explicit trade-off matrices and discussion, which aggregates into something effectively compensatory even when individuals hold hard cutoffs. Consumers are more likely to use fast heuristics.

Of the two non-compensatory rules, he says elimination by aspects is overwhelmingly the more used in practice.

> Trap: Treat "B2C means non-compensatory" as a tendency, not a law. For a high-stakes consumer purchase such as a house, people process more attributes and become willing to trade off. The criterion is always predictive performance.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_logit_choice', 'Logit Choice Probabilities and c', 'Run the compensatory sum for all ten customers and the utilities can simply be counted into a forecast: 2 customers rank product 1 top, 4 rank product 2 top, 4 rank product 3 top, so the deterministic shares are 20%, 40% and 40%. Both the utilities and those max choices are in the table further down.

That count assumes the preference parameters are exact. They are not. Compare customer 1, whose top utility of 646 sits well clear of 556, with customer 9, at 480 and 492. A small measurement error would flip customer 9 and would not flip customer 1, yet the count treats the two as equally settled. The fix is to predict probabilities rather than a single choice.

$$\Pr(\text{buy } P) = \frac{\exp(c\,u_P)}{\exp(c\,u_P) + \exp(c\,u_{I_1}) + \exp(c\,u_{I_2}) + \ldots}$$

c measures how certain we are about the utilities. c = 0 means no confidence at all and the probabilities flatten toward equal; c approaching infinity means complete confidence and the highest-utility product takes everything.

## Worked: customer 1 at c = 0.02

| | Product 1 | Product 2 | Product 3 |
|---|---|---|---|
| U | 646 | 556 | 226 |
| cU | 12.92 | 11.12 | 4.52 |
| exp(cU) | 408,399 | 67,508 | 92 |
| Probability | 0.86 | 0.14 | 0.00 |

The exponentials sum to 475,999; divide each by that. Turning c up and down moves the same utilities a long way: at c = 0.001 the split is .39 / .36 / .26, at c = 0.04 it is .97 / .03 / .00.

## Picking c

The right c is the one that reproduces actual market shares best. In practice, based on dozens of past studies:

$$c = \frac{100}{12 \times \text{range of utilities over the product space}}$$

Here the best possible utility is 7 x 100 = 700 and the worst is 1 x 100 = 100, so the range is 600 and c = 100 / (12 x 600) = 0.0139.

## Share is the average probability

Run every customer at c = 0.0139 and average each product''s probability column. The first four columns are the compensatory utilities and the deterministic count this concept opened with; the last three are what replaces them:

| Cust | U(P1) | U(P2) | U(P3) | Max choice | Pr(P1) | Pr(P2) | Pr(P3) |
|---|---|---|---|---|---|---|---|
| 1 | 646 | 556 | 226 | 1 | 0.78 | 0.22 | 0.00 |
| 2 | 621 | 598 | 297 | 1 | 0.58 | 0.42 | 0.01 |
| 3 | 177 | 516 | 693 | 3 | 0.00 | 0.08 | 0.92 |
| 4 | 574 | 409 | 654 | 3 | 0.24 | 0.02 | 0.73 |
| 5 | 298 | 415 | 580 | 3 | 0.02 | 0.09 | 0.89 |
| 6 | 558 | 354 | 700 | 3 | 0.12 | 0.01 | 0.87 |
| 7 | 290 | 660 | 502 | 2 | 0.01 | 0.90 | 0.10 |
| 8 | 423 | 621 | 531 | 2 | 0.05 | 0.74 | 0.21 |
| 9 | 480 | 492 | 358 | 2 | 0.42 | 0.50 | 0.08 |
| 10 | 295 | 667 | 560 | 2 | 0.00 | 0.81 | 0.18 |
| | | | | **Average** | **0.22** | **0.38** | **0.40** |

Those averages are the predicted shares: 22%, 38% and 40%.

Read across a row and the hedging is visible. Customer 1, with a wide utility gap, comes out 0.78 / 0.22 / 0.00 — the model is fairly sure. Customer 9, with utilities 12 points apart, comes out 0.42 / 0.50 / 0.08 — the model is nearly undecided, which is the honest answer. Each row sums to 1 because in this simplified market the customer buys exactly one of the three.

> Trap: Average the **probabilities**, not the max-choice indicators. The deterministic counts gave 0.20 / 0.40 / 0.40 for the same data, which is close here and will not be in general.

> Trap: C is not a percentage accuracy. c = 1 does not mean the research is 100% right. It is a relative confidence or dispersion parameter.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_profit_per_prospect', 'From Share to Expected Profit per Prospect', 'Costs in the mug example attach to two attributes only. Capacity: 12 oz costs 1.00, 20 oz costs 2.60, 32 oz costs 2.80. Cleanability: Difficult costs 1.00, Fair costs 2.20, Easy costs 3.00. All in dollars.

## Worked: the 5-dollar, 12 oz, Easy candidate

Predicted share is 0.400. Cost is 1.00 for 12 oz plus 3.00 for Easy, so 4.00. Margin is 5.00 minus 4.00, so 1.00. Expected profit per prospect is 0.40 x 1.00 = 0.400.

## The full candidate table

Reference table. Nobody will ask you to reproduce or recompute it — what matters is the four patterns listed underneath, which are the examinable part.

Repeat that across all 27 and rank. Brand is C throughout, so it is left out of the table. Share is the average logit probability from the previous step, cost is capacity cost plus cleanability cost, margin is price minus cost, and the last column is share times margin.

| Cand | Price | Cap | Clean | Share | Cost | Margin | Profit per prospect |
|---|---|---|---|---|---|---|---|
| 1 | 30 | 12 | Diff | 0.006 | 2.0 | 28.0 | 0.169 |
| 2 | 30 | 12 | Fair | 0.032 | 3.2 | 26.8 | 0.865 |
| 3 | 30 | 12 | Easy | 0.124 | 4.0 | 26.0 | 3.235 |
| 4 | 30 | 20 | Diff | 0.022 | 3.6 | 26.4 | 0.575 |
| 5 | 30 | 20 | Fair | 0.054 | 4.8 | 25.2 | 1.358 |
| **6** | **30** | **20** | **Easy** | 0.155 | 5.6 | 24.4 | **3.780** |
| 7 | 30 | 32 | Diff | 0.012 | 3.8 | 26.2 | 0.302 |
| 8 | 30 | 32 | Fair | 0.044 | 5.0 | 25.0 | 1.090 |
| 9 | 30 | 32 | Easy | 0.138 | 5.8 | 24.2 | 3.346 |
| 10 | 10 | 12 | Diff | 0.108 | 2.0 | 8.0 | 0.861 |
| 11 | 10 | 12 | Fair | 0.186 | 3.2 | 6.8 | 1.266 |
| 12 | 10 | 12 | Easy | 0.321 | 4.0 | 6.0 | 1.924 |
| 13 | 10 | 20 | Diff | 0.166 | 3.6 | 6.4 | 1.061 |
| 14 | 10 | 20 | Fair | 0.271 | 4.8 | 5.2 | 1.409 |
| 15 | 10 | 20 | Easy | 0.426 | 5.6 | 4.4 | 1.876 |
| 16 | 10 | 32 | Diff | 0.123 | 3.8 | 6.2 | 0.760 |
| 17 | 10 | 32 | Fair | 0.220 | 5.0 | 5.0 | 1.098 |
| 18 | 10 | 32 | Easy | 0.370 | 5.8 | 4.2 | 1.554 |
| 19 | 5 | 12 | Diff | 0.183 | 2.0 | 3.0 | 0.550 |
| 20 | 5 | 12 | Fair | 0.275 | 3.2 | 1.8 | 0.495 |
| 21 | 5 | 12 | Easy | 0.400 | 4.0 | 1.0 | 0.400 |
| 22 | 5 | 20 | Diff | 0.230 | 3.6 | 1.4 | 0.321 |
| 23 | 5 | 20 | Fair | 0.355 | 4.8 | 0.2 | 0.071 |
| **24** | **5** | **20** | **Easy** | **0.503** | 5.6 | −0.6 | −0.302 |
| 25 | 5 | 32 | Diff | 0.212 | 3.8 | 1.2 | 0.254 |
| 26 | 5 | 32 | Fair | 0.327 | 5.0 | 0.0 | 0.000 |
| 27 | 5 | 32 | Easy | 0.469 | 5.8 | −0.8 | −0.375 |

Candidate 6 is the profit winner at 3.780. Candidate 24 is the share winner at 0.503 and loses money on every unit, because its price of 5 dollars sits below its cost of 5.60.

## What the table shows at a glance

- **Share falls as price rises; profit per prospect does the opposite.** The 30-dollar block at the top has the worst shares and, apart from the Difficult variants, the best profits. That opposition is the reason the objective function has to be named before the winner can be.
- **Easy cleaning wins inside every price-capacity block.** Compare 4, 5, 6 or 19, 20, 21 — Easy always beats Fair, which always beats Difficult, even though Easy costs the most to make. The demand effect outweighs the 2-dollar cost difference everywhere.
- **20 oz beats 32 oz on share throughout**, which is why the top candidate is 20 oz rather than the largest available size.
- **Three candidates make no money or lose it** — 26 breaks exactly even, 24 and 27 are negative. All three are 5-dollar mugs with expensive specifications.

If these 27 points are plotted with share across and profit per prospect up the side, they form an arc: the cloud rises to candidate 6 near the left and falls away to 24 and 27 at the bottom right. The efficient frontier — the candidates not beaten on both measures at once — runs 6, 9, 3, 12, 15 and so on down to 24.

> Trap: Notice the conceptual order. Preference parameters, then utilities, then choice probabilities, then share, then economics. The black-box regression jumps straight from features to share and skips everything in the middle.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_objective_taste', 'Choosing the Objective Function', 'The algorithm ranks candidates. It cannot tell you what "best" means. The common objectives:

| Objective | Why a firm might hold it | Illustration used in class |
|---|---|---|
| Profit or free cash flow | Current economic surplus | Buffett-style thinking |
| Market share | Buy scale now at low or negative margin, monetise or weaken rivals later | Blitzscaling; Jio, Uber in China, OpenAI |
| Sales revenue | Top-line scale is itself attractive; a buyer may believe it can fix costs later | Private-equity acquisition logic |
| Margin | A strategic acquirer already has reach and wants a high-margin product to push through it | A larger same-industry acquirer |
| Low cost | Capital-constrained or risk-averse business wants something cheap to make | Family-business orientation |

He calls the choice a matter of **taste**: it follows from the firm''s objectives, ownership, financial position, growth model and managerial DNA. The metrics genuinely conflict, so picking one quietly on the client''s behalf is dangerous.

In the mug data that conflict is stark. Candidate 6 maximises profit at 3.780 per prospect. Candidate 24 maximises share at 0.503 and loses 0.302 per prospect. There is no reading of the data that makes one of them "the best product".

> Prof: The consulting tactic he says he learned from senior partners — if you cannot discover the client''s objective, do not bluff a single optimal recommendation. Give conditional ones. If profit is the objective choose X, if share choose Y, if revenue choose Z. That exposes the assumption instead of hiding it.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_beyond_the_algorithm', 'Beyond the Algorithm: QFD and Market-Driving Strategy', 'The optimisation is enough to fix the core attributes, provided desired benefits can actually be turned into production specifications. Three levels of product design go further than that:

- Translating desired benefits into production specs.
- Looking past what the customer says is important, to the higher-level needs underneath, and building something that addresses those.
- Aesthetics.

## Quality function deployment / house of quality

QFD is the disciplined translation between user needs and engineering specifications. User needs run down the rows, technical specifications across the columns, and each cell records the relationship: ++ strong positive, + positive, − negative, −− strong negative. Blank means no meaningful relationship.

The mug matrix from the handout:

| User need | Mouth opening size/shape | Insulating material | Handle shape | Outside material | Capacity |
|---|---|---|---|---|---|
| Shouldn''t cause dribble down front of shirt | ++ | | + | + | |
| Should keep liquid hot for at least an hour | − | ++ | | − | |
| Should have comfortable feel | | + | ++ | + | |
| Should be low cost | | −− | | −− | − |
| Should not spill if knocked on its side | −− | | | | − |

Read it for the conflicts rather than the confirmations, because that is what it is for. A wide mouth opening stops dribbling but loses heat and makes spills worse. Good insulating material keeps liquid hot and feels comfortable but pushes cost up. There is no specification that satisfies everything, and the matrix makes that visible on one page at design time rather than late in engineering.

> Note: The relationship signs are about *effect*, not desirability. A "−−" in the low-cost row means that specification drives cost up, which is bad for that need.

## Market-driven versus market-driving

| Dimension | Market-driven | Market-driving |
|---|---|---|
| Nature | Incremental innovation | Breakthrough innovation |
| Creates | New product, line extension | New platform, new category |
| Customer goal | Satisfy and delight current customers | Create customers |
| Nature of needs | Expressed | Latent |
| Source of insight | Quantitative research: surveys, test markets | Lead-user observation, focus groups |
| Risk | Lower | Higher |
| Cost | Lower | Higher |
| Frequency | Higher | Lower |

The choice-and-optimisation machinery is strongest in the market-driven column, where preferences and the competitive set are stable enough to measure. A student raised Tesla; he agreed that when an innovator changes how a whole category is perceived, the fixed-preference assumption starts to fail.

> Prof: Business schools over-weight the market-driven column because established firms and consulting clients do most of the hiring. Market-driving firms are not always startups — his example was Apple and the iPad opening computing to people who had barely used computers. He also stressed the failure rate, naming abandoned Apple efforts as the reminder.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_affinity_segmentation', 'Affinity Segmentation', 'Everything in the value communication and delivery pod — segments, positioning statement, advertising creative, salesforce and channels — is determined by the persona of the customers likely to buy the product we chose. Personas come out of affinity segmentation.

For a candidate product P (usually just the optimal one) and each available customer descriptor, compute the across-customer average of that descriptor, weighted by each customer''s probability of buying P:

$$\bar{X}_P = \frac{\sum_i X_i \Pr_i(P)}{\sum_i \Pr_i(P)}$$

## Worked: brand importance among likely buyers of product 3

One column of the calculation, in full, so the mechanics are visible once. Our candidate here is the profit winner — 30 dollars, 20 oz, Easy, Brand C — so these purchase probabilities are **not** the ones from Session 7.

| Cust | IBr | Pr(P1) | Pr(P2) | Pr(P3) | IBr × Pr(P3) |
|---|---|---|---|---|---|
| 1 | 24 | 0.703 | 0.202 | 0.095 | 2.28 |
| 2 | 31 | 0.555 | 0.403 | 0.042 | 1.30 |
| 3 | 12 | 0.009 | 0.968 | 0.024 | 0.28 |
| 4 | 23 | 0.614 | 0.062 | 0.324 | 7.45 |
| 5 | 12 | 0.125 | 0.633 | 0.243 | 2.91 |
| 6 | 19 | 0.254 | 0.015 | 0.731 | 13.88 |
| 7 | 17 | 0.006 | 0.991 | 0.004 | 0.06 |
| 8 | 12 | 0.058 | 0.912 | 0.030 | 0.36 |
| 9 | 25 | 0.434 | 0.512 | 0.054 | 1.35 |
| 10 | 20 | 0.006 | 0.991 | 0.003 | 0.06 |
| **Sum** | | **2.76** | **5.69** | **1.55** | **29.95** |

$$\bar{X} = \frac{29.95}{1.55} = 19.3$$

## Why weight at all — the naive version

He made the point by first doing it the obvious way. Look down the Pr(P3) column: only customer 6 is really likely to buy us, at 0.731. So the naive answer to "what is the average brand importance of our buyers?" is customer 6''s brand importance, which is **19**.

The actual answer is **19.34**. The gap is the whole idea:

- Customer 6 is *probably* buying us, not certainly. A 0.731 chance means there is a 0.269 chance they do not.
- Customers 4 and 5, at 0.324 and 0.243, are not the most likely buyers but are far from impossible. They belong in the average, partially.
- Weighting includes everyone in proportion to how likely they are to be our customer, instead of drawing an arbitrary line and saying "these people are ours, those are not".

Notice what did the work in the table. Customer 6 contributes 13.88 — nearly half the total — while customers 7 and 10, who are almost certainly buying product 2, contribute 0.06 each. The weighting has quietly turned "the average customer" into "the average likely buyer", which is the entire point.

> Note: The affinity segmentation output table has P + 1 rows, where P is the number of products including ours — one row per product, plus the overall market row. On the handout it is broken across three blocks because it is too wide for the page, and in each block only the **top four rows** are the output table. Everything below them is the raw input data being averaged.

Do this for every descriptor and every product, and you have the affinity output table.

## The second block: which levels they actually like

Attribute importances say how much a decision turns on an attribute. A separate block of the table weights the **level ratings** the same way, and says which level each segment prefers. These two blocks answer different questions and are the single most-confused pair in this session.

| Segment | 10 dollars | 5 dollars | 12 oz | 20 oz | 32 oz | Difficult | Fair | Easy |
|---|---|---|---|---|---|---|---|---|
| Product 1 buyers | 4.90 | 7.00 | 2.36 | 5.34 | 5.29 | 1.00 | 4.42 | 7.00 |
| Product 2 buyers | 5.93 | 7.00 | 2.96 | 6.24 | 3.43 | 1.00 | 4.30 | 7.00 |
| Product 3 buyers (ours) | 5.00 | 7.00 | 2.36 | 5.63 | 5.09 | 1.00 | 4.08 | 7.00 |
| Overall market | 5.5 | 7.0 | 2.7 | 5.9 | 4.2 | 1.0 | 4.3 | 7.0 |

Our row says 20 oz is the preferred capacity at 5.63, ahead of 32 oz at 5.09 and far ahead of 12 oz at 2.36. So our buyers do want a normal-sized mug — they simply do not care very much, which is the low importance figure of 9.86 in the other block.

> Trap: This is exactly why capacity importance and capacity preference must be read separately. Low importance plus a 20 oz preference means "they want 20 oz but would not walk away over it". Reading the low importance as "they want a small mug" reverses the finding — and it is the specific error he corrected in class.

Do the same for every descriptor available: attribute importances, the preference for a level times the importance of that attribute, and demographic or behavioural variables. Then do it for every other product in the category too — that is what makes it possible to say how our customers **differ** from a competitor''s.

> Trap: The weights do not sum to 1 across people, and they are not supposed to. Every customer could buy product 3, or none of them. What sums to 1 is P1 + P2 + P3 **within one customer**, because in this simplified market the options are mutually exclusive and exhaustive. The denominator in the formula is what does the normalising, so never rescale the weights first.

For a binary descriptor the weighted mean reads directly as a fraction: a sports mean of .84 for product 3 buyers says roughly 84% of that buyer mass plays sport.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_log_lift_persona', 'Focal Descriptors, Log Lift and the Persona', 'A persona should not spend words on things that are true of everyone. His analogy: asked to describe a classmate, you would not start with two eyes, one nose, two feet. A **focal** descriptor is one that makes the group distinctive.

$$\text{Lift} = \frac{\text{segment mean}}{\text{overall market mean}}, \qquad \text{Log lift} = \log(\text{Lift})$$

Log lift near zero means the segment looks like the market on that descriptor. Large positive means over-indexed, large negative means under-indexed.

A rough scale to read them by, since base-10 logs are not most people''s daily unit: **+0.30 is about double the market, −0.30 is about half, and anything between −0.05 and +0.05 is effectively the same as the market.**

> Trap: In a log-lift heatmap, strong **negative** values are just as focal as strong positive ones. The question is "are our customers different?", not "are our customers higher?". Near-zero is the uninteresting cell.

## The log lift table

All three segments, so you can see what "focal" looks like by contrast. Segment 3 is ours. In the class heatmap the large values print red and green and the near-zero ones yellow.

| Segment | IPr | ICp | ICl | IBr | Income | Age | Sports | Grad school |
|---|---|---|---|---|---|---|---|---|
| Product 1 buyers | −0.307 | +0.159 | +0.080 | +0.091 | +0.052 | +0.038 | −0.046 | −0.301 |
| Product 2 buyers | +0.131 | −0.036 | −0.194 | −0.051 | −0.043 | −0.022 | −0.125 | −0.071 |
| **Product 3 buyers (ours)** | **−0.211** | **−0.298** | **+0.293** | −0.004 | +0.047 | +0.009 | **+0.322** | **+0.389** |

Product 2''s row is the instructive contrast: almost every cell is small. Those buyers are close to the market average on everything except a mild price focus, so they are hard to write a distinctive persona for. Ours has five cells worth talking about, which is why it produces a usable brief.

## The persona for our mug, in two steps

Read out what the table says, literally:

- Less price-sensitive than the market (price importance log lift −0.211).
- Much less concerned with capacity (−0.298) — though 20 oz is still their preferred size.
- Cleanability is highly important (+0.293, roughly twice the market''s concern).
- Brand importance is about average (−0.004).
- Income and age are not focal (+0.047 and +0.009).
- Strongly sports-active (+0.322, about twice as likely to play sport) and far more graduate-educated than average (+0.389, about 2.5 times).

Then extend, using societal and cultural knowledge, anchored to that readout: educated, health-conscious, gym-going, busy people.

## How the extension is actually reasoned

The extension step is the one students find slipperiest, so it is worth seeing the chains he accepted in class. Each one goes from a focal descriptor to a claim the data does not directly contain.

- **Cleanability matters a lot → they are short on time.** Easy is 2 minutes, Difficult is 7. Caring intensely about that gap is caring about five minutes, which is a statement about time pressure, not about hygiene.
- **Low price importance → they are short on time.** Getting a good price requires searching and comparing. Busy people cannot search. So low price sensitivity on a cheap everyday item reads as time-poverty.
- **Plays sport + graduate-educated → health-conscious, plausibly gym-going.** Two focal descriptors pointing the same way.

A student objected that playing sport might *substitute* for the gym rather than predict it, and he accepted that as a fair counter — which is the right model for how confident to be. Another student took the hard line that nothing beyond the data can be claimed at all. His answer: that position is defensible, but it hands the advertising agency less to work with, and the job is to give them something usable.

> Trap: Price sensitivity is not income. People assume the two are the same, and for a Rolls-Royce or a house they largely are. For a mug — cheap to begin with — low price *importance* means only that the buyer is not paying attention to price in the aisle. Our buyers'' income log lift is +0.047, essentially the market average, which confirms income is not what is driving it.

> Prof: On sourcing the extrapolations, he was blunt that this used to mean hiring a consumer-psychology expert who knew the culture — fine for India, useless if the market is Nigeria and nobody in the room knows what correlates with what there. Today he uses a large language model for it, on the grounds that an LLM is "a gigantic repository of what is correlated with what", the collective record of human association. Feed it the readout, name the country, and ask what else follows. The judgement about what is reasonable stays yours.

> Trap: A near-zero log lift does **not** mean the descriptor is unimportant to them. Brand importance for our buyers is 19.34 in absolute terms, which is substantial — they do care about brand. The log lift of −0.004 says only that they care about it *the same amount as everyone else*, so it cannot be used to differentiate them. He corrected this misreading in class alongside the capacity one. Near-zero means "not distinctive", never "not important".

## What the persona is for

It sets who and what situations the advertising should depict, and it helps decide where to sell.

> Note: The handout slide ends by saying affinity segmentation "has also two other key applications in different contexts". He ran out of time and never said what they are — the session ended mid-sentence on the output table. So there is nothing to learn here beyond the advertising uses, and if a question asks for applications of affinity segmentation, answer with the persona-for-creative and channel-choice uses plus the positioning statement. Do not guess at the missing two. For this mug the class generated e-commerce and quick commerce, gyms and sports events, corporate bulk sales and office-park trial booths, and airport retail. He added that the company that supplied the data found airport stores especially important — airport shops have very limited inventory space, and this persona''s unusually low concern about capacity makes that a fit rather than a constraint.

> Trap: Do not invent the extension. It has to be anchored in the focal descriptors, not attached to them afterwards.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_competition_views', 'Three Operational Definitions of Competition', 'A qualitative case can say "analyse the competition" without ever defining the word. The affinity and choice data force three separate definitions, and they can point at different products.

| View | What makes them competitors | What you compare | In the mug data |
|---|---|---|---|
| Consumer psychologist | Their customer personas are most similar | Rows of the affinity output table, descriptors put on comparable scales | Product 1 |
| Economist | They are substitutes: the same customers get won or lost | Columns of purchase probabilities across people | Product 1 again |
| Brand manager | Among our buyers, which other brand is liked second most | Brand preference values only | Brand A, since P3 buyers rate C 5.699, A 4.338, B 1.632 |

The brand manager ignores everything except brand because, on that view, product attributes can be changed over time while the brand is the more persistent identity. He is explicit that this is a perspective you may or may not agree with — keep it labelled as the brand manager''s view, not universal truth.

## How "most similar personas" is actually measured

The consumer psychologist''s view says compare our row of the affinity output table against every other product''s row and take the closest. Asked how closeness is measured, he named three standard options and treated the choice as unimportant:

- **Euclidean distance** — the ordinary straight-line distance between two rows treated as points.
- **Sum of absolute differences** — go cell by cell, take each gap ignoring its sign, and add them up. The simplest to do by hand.
- **Cosine similarity** — compares the direction of the two rows rather than their magnitude.

The one requirement is that the descriptors are on comparable scales first, otherwise a column measured in thousands of rupees swamps a column measured 0 to 1.

> Trap: Do not over-invest here. He raised these only to answer "how would you measure that?" and moved on. Naming one measure and saying why scaling matters is a complete answer.

## Competition can be asymmetric

The brand-preference block of the affinity table, which is the evidence for the brand manager''s view:

| Whose buyers | Rate brand A | Rate brand B | Rate brand C |
|---|---|---|---|
| Product 1 buyers | **6.374** | 3.450 | 2.730 |
| Product 2 buyers | 3.810 | **5.088** | 2.748 |
| Product 3 buyers (ours) | 4.338 | 1.632 | **5.699** |
| Overall market | 4.6 | 4.1 | 3.2 |

Read our row across: we like C most (5.699) and A second (4.338), so brand A is our competitor on this view. Now read brand A''s row: their buyers rate A at 6.374, B at 3.450 and us at 2.730 — last, and well behind. We barely register to them.

So competition is **asymmetric**. We are worried about A; A is not worried about us. A student called brand A "well protected", which he liked: a small brand may have to worry about the leader far more than the leader worries about it. Notice also that A''s buyers give A a 6.374 — the strongest own-brand loyalty of the three — which is what being the leader looks like in this data.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_positioning_statement', 'Writing the Positioning Statement', 'The template from the slide:

> Worked example: Brand X is better at [claim or benefit] relative to [competitive frame] because it [supporting evidence]. The slide''s example — Rolaids is better at curing heartburn within 20 minutes, relative to Tums, because it contains a new ingredient.

Building one analytically needs two answers: who the competitor is, and what strength to emphasise.

## Which strength

Compare how much utility each attribute contributes for our target customers, against the same term for the chosen competitor. The contribution of attribute a is:

$$\text{Importance}_a \times \text{Rating}(\text{Level}_a(P))$$

Pick the attribute where our contribution is highest **relative to** the competitor''s. Operationally he runs it as a short loop: rank attributes by importance for our buyers, start at the top, ask whether we are actually better than the competitor on it, and if not move down. For our mug, cleanability comes first because it has the highest importance among these buyers, and the candidate is Easy to clean, so that is the natural claim to examine.

> Trap: Do not just pick the attribute our buyers care most about. Importance without relative superiority is not differentiation. The claim has to beat the competitive frame you named.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_ad_brief_hierarchy', 'The Advertising Brief and the Hierarchy of Effects', 'The decisions in value communication and advertising split in two. First, developmental research, pilot creation and pre-testing: what exactly is the message (the persona plus the positioning statement), how does it translate into creatives for different media and audiences, which formats and channels are in play, and preliminary evaluation of short-term effects in a controlled setting. Second, field rollout, evaluation and media mix optimisation.

## Who owns which decision

1. **Internal.** The product or consulting team writes the advertising brief: persona plus positioning.
2. **Agency.** The advertising agency turns the brief into print, audio and video creatives.
3. **Joint.** Internal team and agency together choose outlets and placements — Dainik Jagran or the Financial Times, Radio Mirchi or Spotify.
4. **Internal.** The product or marketing team evaluates effectiveness.

> Prof: Never let the advertising agency evaluate its own work. The agency is incentivised to show success. The line he is drawing is external agency versus internal firm, not internal product versus internal marketing.

After creative and outlet design there may be twenty or thirty execution combinations. Preliminary evaluation is what cuts them to three or five before the money goes into the field.

## The four preliminary metrics, in order

Attention, then recall of brands and sales arguments, then persuasion, then behaviour effects. Each is a precondition for the next: if nobody attends, nothing gets encoded; persuasion needs the message remembered; behaviour rarely moves without some motivational shift.

| Metric | How it was measured in class | Why it precedes the next |
|---|---|---|
| Attention | Skip rates; eye tracking for non-skippable display and print | Nothing encodes without it |
| Recall | Prompted "which brand did you see?" surveys | Persuasion needs the message remembered |
| Persuasion | Attitude scales, recommendation-likelihood or NPS-style proxies | Behaviour needs motivation to move |
| Behaviour | Purchase, click, redemption | Closest to the business result, but delayed and hard to attribute |

Behaviour is the real target and is usually impractical in a short controlled pilot. A Toyota advertisement may influence a purchase months later, after family discussion, with exposure online and purchase offline. So preliminary work leans on the earlier proxies and field rollout is where behaviour becomes central.

All four are examined causally, by experiment or by causal inference.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_observational_vs_causal', 'Observational versus Causal Assessment', 'Deciding between actions A1 and A2 needs the causal impact of moving from one to the other.

**Observational assessment** compares the response of customers under A1 with the response of *different* customers under A2. Any difference can be the action, or can be pre-existing differences between the two groups.

**Causal assessment** ideally compares the response of customers under A1 with the response of *those same customers* under A2, under similar conditions. Since nobody can be observed in both states at once, every design in this session is an approximation of that ideal.

The simplest approximation: take one group under A1, change the action on them to A2, compare the two responses. That is the before-after design.

## Terminology

The marketing action whose effect is being evaluated is the **treatment**. The customers subjected to it are the **treatment group**, treated group or treated customers.

Causal assessment is hard, and there are two distinct approaches: causal inference with observational data (CIOD), and design and analysis of business experiments (DABE).')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_validity_threats', 'Validity Threats in the Before-After Design', 'Run the Toyota study and suppose the post-measure R2 comes back higher than the pre-measure R1. Claiming the effect of advertising is R2 − R1 invites a counter-argument. Where a counter-argument is available, there is a validity **threat**.

**External validity threats** are about generalising to the broad target population: the populations or measures in the experiment do not match the populations or measures of the real marketing task. Large random samples are not enough — the sample has to come from the right population or an equivalent one. His India example: cities such as Indore, Nagpur, Surat, Pune and Coimbatore can be picked to capture different slices of the country, while the big metros are unrepresentative on language, migrant composition and urban-rural exposure.

**Internal validity threats** are about the specific measures and sample inside the experiment. There are two standard categories.

## Contemporaneous drift (D)

Any non-treatment influence that shifts attitudes between the pre- and post-measurement.

- **External events.** Between 27 December and early January a participant may hit Toyota information outside the experiment: a friend''s remark at a holiday gathering, a news story, a competitor''s advertising.
- **Psychological change.** Over a holiday week people tend to become more relaxed and optimistic, and rate everything more favourably.
- **Pre-survey sensitisation.** Filling in the first Toyota questionnaire primes participants to notice Toyota during the intervening week — spotting the cars on the road — which shifts the post-measure independently of the commercial.

## Measurement non-equivalence (MNE)

The measurement process itself changed between the two points, so R2 − R1 is distorted even if true attitudes did not move.

- **Survey incentive.** The mailed post-survey came with a 20-dollar gift card; the in-person pre-survey did not. Reciprocity or the resulting good mood inflates R2 as an artifact of procedure.
- **Selective attrition.** 120 completed the pre-survey and only 80 returned the post. If the 40 who dropped out differ systematically — say they cared less about Toyota — then R1 and R2 are measured on different subpopulations, and the average can rise without anyone changing their mind.

## The decomposition

$$R_2 - R_1 = E + D + \text{MNE} = E + B, \qquad E = (R_2 - R_1) - B$$

If B is small then R2 − R1 is a fair measure of the true effect. The design problem is that you have no reason to believe it is.

## With numbers on it

He put figures on this in the final session, and they are worth carrying because they make the argument concrete. On the 7-point attitude scale, the pre-measure R1 came out at 5.0 and the post-measure R2 at 5.3, so the observed change is a delta of 0.3.

The two questions that follow are the whole session:

- **Is the 0.3 caused by the advertisement, or is there another explanation?** Every alternative explanation is an internal validity threat — the holiday mood, the friend''s remark, the gift card, the 40 people who did not reply. That is the question the control group answers.
- **Supposing the 0.3 is real, does it hold outside Wisconsin?** That is external validity, and it cannot be fixed by a bigger sample — only by a representative one. Hence the microcosm cities.

> Prof: His intuition pump for why causality needs change, not comparison — a four-year-old already understands it. The child falls, the mother asks why, and the child says "that guy pushed me". The child was standing, then on the ground, and a push happened in between. Initial state, final state, treatment in the middle. That is the before-after design, and it is why comparing two different groups at one moment feels like a weaker kind of evidence.

> Prof: He frames validity as a falsification question. What counter-argument could falsify my causal claim? If an alternative story explains the movement just as well, the design has a threat.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_control_group_designs', 'Control-Group Designs', '## Before-after with a control group

Randomly split the 120 participants into an experimental group and a control group. Only the experimental group sees the Toyota commercials; the control group watches the same pilot with no Toyota advertising. Both groups are measured before and after.

| Group | Before | Treatment | After |
|---|---|---|---|
| Experimental | R1 | X | R2 |
| Control | R3 | O (none) | R4 |

For the control group, write the same decomposition: $R_4 - R_3 = E'' + D'' + \text{MNE}'' = E'' + B''$. But the control group saw no Toyota advertising, so its true effect is zero by construction, $E'' = 0$. And if the two groups are equivalent in their behaviour, their biases are equal, so $B'' = B$. Therefore $R_4 - R_3 = B$, and:

$$E = (R_2 - R_1) - (R_4 - R_3)$$

Change in the treated group minus change in the control group. This is the cleanest formula in the session because it makes the logic visible.

## After-only with a control group

Drop the pre-measurement in both groups. Start from the same algebra and rearrange:

$$E = R_2 - R_1 - R_4 + R_3 = (R_2 - R_4) + (R_3 - R_1)$$

If the two groups are equivalent at the start then $R_1 = R_3$, the second bracket vanishes, and:

$$E = R_2 - R_4$$

This is the A/B testing logic. It is an across-person comparison — people are no longer followed across time — and it still supports a causal claim, provided the groups are equivalent and there is no leakage.

> Prof: His framing is that after-only *looks* observational, because you are comparing two different groups at one point in time. The causal justification is that very large randomised groups make the omitted pre-measures effectively equivalent, so R1 and R3 would have cancelled anyway. That is why he says after-only carries a much heavier sample-size requirement than before-after with control.

> Trap: Reproduce his framing on the exam. Standard experimental-design texts treat a properly randomised post-test-only experiment as fully causal without any baseline measure, but that is not what this course taught.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_control_requirements', 'What a Control Group Requires', 'Two requirements, and both are failure modes.

## 1. The groups are equivalent except for the treatment

With **large samples**, random assignment to treatment or control. With **small samples**, match on profiles instead — actively construct comparable groups rather than trusting random balance.

If two groups are not equivalent, the variables on which they differ are called **confounds** or confounding variables.

## Why after-only needs a much bigger sample

Both control-group designs need sample size, but for different numbers of reasons, and he was explicit about the comparison.

- **Before-after with control** needs *moderately* large samples. The one thing it assumes is that the bias is the same in both groups — D′ = D and MNE′ = MNE. With tiny groups, one group''s holiday mood or attrition pattern will simply differ from the other''s by chance, and then B′ ≠ B and the subtraction stops working.
- **After-only with control (A/B testing)** needs *much* larger samples, because it assumes all of that **and** additionally that R1 = R3 — that the two groups started at exactly the same level, on a measurement nobody took. That extra assumption is carried entirely by the law of large numbers, so it needs the numbers to be large.

> Prof: His summary of the trade-off — A/B testing "does not work as causal assessment because you''re not doing the pre-measurement, unless the sample sizes are large, where even if you did the pre-measurement, they would cancel out anyway." Before-after with control is what he calls the gold standard, because it measures the bias rather than assuming it away.

> Trap: Randomisation with large samples reduces internal validity threats. It does nothing for external validity. A perfectly randomised Wisconsin Kmart sample is still a Wisconsin Kmart sample.

## 2. No leakage between the groups

The control group must not find out about the treatment or be affected by what happens to the treatment group. This is the **stable unit treatment value assumption (SUTVA)**: a person''s outcome depends on their own assigned treatment, not on someone else''s.

It gets harder to satisfy over longer time frames and wherever the two groups'' behaviour is linked. Two failure modes he gave:

- **Promo-code leakage.** Treated customers share a treatment-only code with controls. Controls start behaving like the treated, the measured difference shrinks, and the effect is typically biased downward.
- **Uber driver interference.** Treated drivers get extra compensation and accept more rides. With a limited pool of rides, control drivers then get fewer rides *because* the treated group exists. The groups interact through the market without ever communicating.

> Trap: Before trusting either $R_2 - R_4$ or the difference in differences, ask both questions. Equivalent groups? No leakage? If either fails, the control is not a clean counterfactual.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_time_series_design', 'Time Series Without a Control Group', 'Instead of a second group, create the control setting by measuring the same group again without the treatment: R1, then treatment, then R2, then no treatment, then R3.

This is the before-after-with-control design folded onto one group. R2 here plays both R2 and R3 from that design, and R3 here plays R4. So:

$$E = (R_2 - R_1) - (R_3 - R_2) = 2R_2 - (R_1 + R_3)$$

> Trap: The assumption has moved, it has not gone away. Before-after with control assumed the bias was the same **across the two groups**. This design assumes the bias is the same **within one group across adjacent time intervals**.

## Many periods

Extend to interleaved periods of treatment and no treatment, ideally randomised: no treatment, R1, treatment, R2, no treatment, R3, treatment, R4, treatment, R5, no treatment, R6, and so on. Build a dataset with a time index, a 0/1 treatment indicator and the response, then run:

$$\text{Response} = b_0 + b_{ti}\,\text{Time index} + b_{tr}\,\text{Treatment}$$

The coefficient on treatment estimates E, with the time index absorbing the trend.

## Why you would prefer this design

- No separate control group, so neither the equivalence requirement nor the leakage requirement applies.
- Long-term effects are easier to see.
- It can be run on field data in the real world, as long as the treatment varies over time.

> Trap: The official S10 outline mentions autoregressive time-series models with covariates. The handouts and class do not give any AR equation beyond this regression and the later adstock formulation, so do not invent one.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_analytics_synthesis', 'What Analytics Is Actually For', 'His closing argument is that the headline number is often not the most valuable output. Clever people can find a problem with almost any calculation. The immediate value is that trying to produce the number forces the team to be rigorous, concrete and systematic.

Two examples of that from this course:

- **Competition.** Without analysis, "who are our competitors?" stays fuzzy. Affinity segmentation forced three concrete answers: persona similarity, economic substitution and brand-preference rivalry.
- **Best product.** Without a stated objective, "best" can mean profit, share, revenue, margin or low cost. The model makes the client confront that choice.

The long-run value is broader search. He invoked **Move 37**, AlphaGo''s move against Lee Sedol: humans reach for familiar templates because mental compute is scarce, while an algorithm can inspect options that look implausible and occasionally find an unintuitive winner. His Tata Motors truck project with Prof. Manish Gangwar was the working example — a feature space running from small urban freight vehicles to long-haul trucks with sleeping space, where the data-driven concept differed from what an STP exercise had produced.

## Where STP is still the right tool

He gave several cases where the intended target was not the eventual market:

| Example | Intended target | What emerged |
|---|---|---|
| Toyota Qualis, then Innova | Joint families, family businesses | Tour and long-distance operators |
| Yulu | Last-mile commuters | Gig and delivery workers |
| OYO Rooms | Low-end business travellers | Young couples, roughly 18 to 30 |

That argues for casting a wide net rather than committing early. But exhaustive structural search needs preference, feature, competitor and cost data, and a HUL Kisan-type case does not have them. Where the data do not exist, classical STP, 3Cs and 4Ps are the best available method — and he put that at roughly 70% of situations today.

> Trap: Do not write "STP is bad". His conclusion is that both frameworks are good in different contexts. Analytics has value even where it is not literally implementable, because it clarifies the questions; its stronger advantage grows as richer preference and market data become available.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_micro_macro_extremes', 'Micro and Macro Extremes in Advertising Assessment', 'Assessing advertising in the field is complicated because four context factors vary independently:

- **Exposure measurement**: individual or group.
- **Behaviour measurement**: individual or group.
- **Response latency**: immediate or delayed.
- **Behaviour frequency**: one-time or repeated.

Two combinations are common enough to be worth naming.

| | Micro extreme | Macro extreme |
|---|---|---|
| Exposure | Known per individual | Known only in aggregate |
| Behaviour | Known per individual | Known only in aggregate |
| Latency | Immediate | Possibly delayed |
| Frequency | One-time | Repeated |
| Mindset | Loosely direct response | Loosely brand building |
| Class example | A MakeMyTrip-style single booking | Mass advertising with repeated bottle sales |

Most large advertising budgets, he argues, sit near the macro extreme. You may know Nagpur sold 10,000 bottles this week against 12,000 last week, and know the weekly spend on All India Radio, Radio Mirchi, Dainik Jagran and the Indian Express — but not which person saw which advertisement before buying which bottle. That is the data situation media mix modelling is built for.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_mmm_decisions', 'The Three Media Mix Modelling Decisions', 'The data are sales $y_t$ at time t, and campaign intensities $Ad_{A,t}$, $Ad_{B,t}$ and so on, any of which may be running simultaneously. The core analysis is how sales vary as a function of those intensities. Three decisions come out of it:

1. How much should we spend on advertising as a whole?
2. How much should go to campaign A, campaign B and the rest?
3. How should the spend be distributed over time?

## Macro and micro scheduling

**Macro scheduling** is decisions 1 and 2: allocating spend within a longer time frame such as a quarter or a year. **Micro scheduling** is decision 3: the pattern of execution over days or weeks — even, blitz, pulsing, or pulsing plus maintenance.

> Trap: The transcript has a verbal slip that calls the first two questions micro-scheduling one sentence after correctly calling them macro. The slide is unambiguous: first two are macro, the temporal pattern is micro.

## Measuring advertising volume

Volume is measured either as expenditure or as gross rating points:

$$\text{GRP} = \text{Reach percent} \times \text{Frequency}$$

GRP summarises total exposure pressure. The same GRP can be a large audience seeing the advertisement rarely, or a small audience seeing it often, which is exactly why reach and frequency are separate decisions.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_mmm_response_model', 'The MMM Response Function', 'The decision is an optimisation over the campaign intensities. Unconstrained:

$$\text{Profit}(Ad_{A,t}, Ad_{B,t}, \ldots) = \text{Sales}(Ad_{A,t}, Ad_{B,t}, \ldots) \times \text{Margin} - \text{Cost}(Ad_{A,t}, Ad_{B,t}, \ldots)$$

Or constrained: maximise sales times margin subject to cost staying under a budget.

Two things have to be built. First, the sales response function, usually a regression with a chosen functional form. Meta''s MMM package Robyn uses channel responses that add up, each with saturation on top of carryover:

$$\text{Sales}_A(Ad_{A,t}) = \beta_{0,A} + \beta_{1,A}\,\frac{(\text{Adstock}_A)^{\gamma}}{\alpha^{\gamma} + (\text{Adstock}_A)^{\gamma}}$$

$$\text{Adstock}_{A,t} = Ad_{A,t} + \delta Ad_{A,t-1} + \delta^2 Ad_{A,t-2} + \delta^3 Ad_{A,t-3} + \ldots$$

Second, the optimisation itself. Robyn uses a framework called Nevergrad. Google Meridian is another product in the same space.

**Adstock** is carryover: this week''s advertising still affects later weeks, with δ controlling how fast the memory decays. The fractional term is **saturation**: incremental response falls as effective exposure accumulates.

Both steps are hard because of the nonlinearity, and there is a data problem underneath. A mass-media model may have only about three years of weekly observations, roughly 156 rows, while trying to estimate several channel-response, decay, saturation and business parameters at once.

> Prof: The point of showing the equation is that it looks complicated. He is not asking anyone to derive or estimate Robyn — he is motivating the need for a simpler allocation framework, which is Dorfman-Steiner.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_dorfman_steiner', 'The Dorfman-Steiner Allocation Rule', 'Three assumptions:

- Sales volume can be increased only by price promotion (cutting price) or by advertising.
- The marketing budget allows only advertising or price-promotion expense.
- The firm is a static monopoly.

Under optimal pricing and advertising decisions:

$$\text{Advertising} = \frac{\text{Advertising elasticity}}{-\text{Price elasticity}} \times \text{Sales}$$

And for the split across campaigns, spend is proportional to each campaign''s own advertising elasticity: $Ad_A \propto \text{Elasticity}_{Ad_A}$.

## Worked example

Price elasticity −2.50. Overall advertising elasticity 0.15. Campaign A elasticity 0.10, campaign B 0.05. Current sales 10M dollars.

Total optimal advertising = (0.15 / 2.50) x 10M = 0.6M. The A-to-B elasticity ratio is .10 to .05, which is 2 to 1, so campaign A gets 0.4M and campaign B gets 0.2M.

## Reading the formula, one term at a time

He walked the formula through in three pieces, and said explicitly that only the third is puzzling.

**Sales, the multiplier.** Bigger sales means a bigger company and therefore a bigger advertising budget. Obvious, and it makes the rule a *ratio* — advertising should be some percentage of sales, not a fixed sum.

**Advertising elasticity, the numerator.** This is the percentage change in sales for a 1% change in advertising — effectively the return on advertising. Higher return, spend more. Also obvious.

**Price elasticity, the denominator.** This is the counterintuitive one: *lower* price sensitivity means you should advertise *more*. He gave two separate reasons, and the exam answer is better if it has both.

- **The lever argument.** Under the model''s assumptions there are only two ways to raise sales — cut price or advertise. If demand is not very price-sensitive, cutting price barely moves volume, so price promotion is a weak lever and advertising is the one that is left. You shift effort to the tool that works.
- **The funding argument**, which he called the more clever one. If demand is not very price-sensitive, you should not merely stop cutting price — you should *raise* it, because volume will hardly fall. The higher price brings in more revenue, and that revenue is what pays for the advertising.

So low price elasticity pushes in the same direction twice: it makes advertising the better lever, and it generates the money to fund it.

> Trap: "Advertise more when price elasticity is low" sounds backwards on first hearing, and it is the most likely thing to be asked about this formula. Do not just assert it — give at least one of the two pathways.

> Prof: Ask an advertising agency how much to spend and the natural answer is "as much as you can". Diminishing returns are the reason the economically optimal spend is finite.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_scheduling_patterns', 'Micro Scheduling and Wearout', 'Total budget and channel split settled, the remaining question is how the money appears week by week. Four patterns, all with the same area under the curve — only the timing changes.

| Pattern | Definition | His reading |
|---|---|---|
| Even | Divide the budget equally across all weeks | Inefficient: repeated identical exposure runs into wearout |
| Blitz | Concentrate spend in a short initial burst | Fits splashy launches — technology products, automobiles — where immediate attention and word of mouth matter |
| Pulsing | Alternate substantial on-periods with zero-advertising off-periods | The defining feature is going dark, so memory and attention can reset |
| Pulsing plus maintenance | Keep a low baseline through the would-be dark periods, with correspondingly lower peaks | Brand managers often prefer constant presence; he calls it less effective than true dark periods |

The Stouffer''s GRP chart in the handout is the real-world illustration: strong bursts separated by long near-zero stretches. Not perfectly regular pulsing, but it shows the key feature.

## Why pulsing exists

Psychology finds saturation effects in many stimuli because we attend to change and novelty rather than to constancy. The **exposure repetition pattern** describes how the peak effect of each exposure changes as repetitions accumulate:

- **Wear-in.** Response increases with repetition. Early exposures build comprehension and familiarity; several encounters may be needed before the message lands.
- **Wearout.** Once the message is familiar, incremental attention falls and further identical exposures are increasingly ignored.

So: stop when the wearout point appears, reset to zero advertising, and restart once the advertisement is nearly out of memory. The slide also labels a residual, path-dependent effect on the curve as hysteresis — the effect can persist after the stimulus stops.

> Prof: A student proposed defeating wearout by rotating several creatives continuously. He gave two objections. If there are five creatives, one of them is presumably the best, so rotation deliberately spends exposures on inferior advertisements. And several simultaneous messages can confuse the brand and dilute its identity.

> Trap: That objection sits in surface tension with two findings on the research slide — that ad effect is greater when copy strategy has recently changed, and that the benefits of constant change in TV advertising outweigh the risks. The material never reconciles them. A plausible reading is periodic refresh over time versus simultaneous rotation, but since he did not say that, present it as a nuance rather than rewriting his claim.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;
insert into public.learn_concepts (course_code, topic, title, note) values
  ('BANM2', 'bamg_ad_response_findings', 'What Decades of Ad-Response Research Found', 'The last slide is a dense list of empirical regularities. It is exactly the kind of material a short-answer question can lift from, so it is worth knowing all of it.

| # | Finding | What it implies for the decision |
|---|---|---|
| 1 | The predominant response function is concave: diminishing returns from the start | There is no long linear "free" region of advertising response |
| 2 | Advertising elasticity averages 0.1 | A 1% spend increase moves sales by far less than 1% |
| 3 | Half of campaigns do not work; when they do, about 18% increase in unit sales | Pre-test rather than assume every campaign creates value |
| 4 | Impact, if any, emerges fast — under 6 months — and lasts about 1 to 2 years | Look for early signals; model carryover, not just same-week effects |
| 5 | A visible short-term effect is a precondition for long-term effects | Do not defend a weak campaign with vague brand-building claims |
| 6 | Once effective advertising is identified, long-term impact is about twice the short-term impact | Short-run measurement understates a genuinely effective advertisement |
| 7 | "TV share of voice must exceed market share" is a myth | Do not use it as a universal spending law |
| 8 | Growing categories and categories with higher purchase frequency show greater ad effect | Context changes the expected elasticity |
| 9 | Elasticity is higher for new products, about 0.3 | Launches can warrant more aggressive spending than mature products |
| 10 | Smaller competitors tend to have higher advertising-to-sales ratios than market leaders | Relative position changes the appropriate intensity |
| 11 | Optimal spending is what achieves 3 to 4 exposures | Connects straight back to wear-in before wearout |
| 12 | Ad effect is greater when advertising tries to change attitude rather than reinforce it | Transformative persuasion has more upside than redundant confirmation |
| 13 | Ad effect is greater when copy strategy has recently changed | Freshness restores attention |
| 14 | The benefits of constant change in TV advertising outweigh the risks | Consistent positioning is not the same as never refreshing execution |

The two numbers most likely to be asked for on their own: average elasticity 0.1, new-product elasticity about 0.3.')
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;

-- learn_questions: 71 rows, all short_answer
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-01', 'BANM2', 'short_answer', 'bamg_marketing_pods', 7, 'Name the four pods of marketing analytics and give one activity in each.', '[]'::jsonb, '- **Value creation** — forecasting primary demand, exploratory research to identify customer decision factors, customer preference measurement, optimal product and price specification.
- **Value communication and delivery** — characterising customer segments, formulating the positioning statement, assessing advertising effects and media planning, distribution/salesforce/channel choices.
- **Customer acquisition** — customer value assessment, scoring leads, scoring lead sources (macro media: TV, radio; micro media: search, display).
- **Customer development and retention** — cross-sell and recommendation systems, loyalty programmes, attrition detection, value reinforcement via communities, social media, email, satisfaction.', 'Session 7 — The Four Marketing Analytics Pods', 'Sessions 7-10 sit in the first two pods.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-02', 'BANM2', 'short_answer', 'bamg_marketing_pods', 7, 'Why are the first two pods described as macro or strategic and the last two as micro or tactical?', '[]'::jsonb, '- In the first two, the unit of decision is a product, brand, market or channel system. Those choices persist for years, so they read as strategic.
- In acquisition and retention, the unit is the individual customer: acquire this lead, cross-sell this person, retain or let churn.
- Feedback is faster in the last two and the action can be reversed quickly, which makes them tactical or CRM-style.', 'Session 7 — The Four Marketing Analytics Pods', 'Firms named in class: American Express and Apple as visibly strong on value creation and communication; Capital One, Kotak and Dell as CRM-sophisticated; Amazon as unusually capable across all four.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-03', 'BANM2', 'short_answer', 'bamg_decision_frame', 7, 'State the problem of marketing decision making. Why is it not the same as predicting outcomes accurately?', '[]'::jsonb, '- Given a set of possible marketing actions A1, A2, A3 and their result outcomes R1, R2, R3, identify the action that leads to the best outcome. Compactly: estimate R = f(A) and choose the best A.
- The goal is not to estimate the value of R for every A. What is needed is enough reliable structure to rank the actions correctly.
- A model whose point predictions are all somewhat wrong is still useful if it gets the relevant ranking right.', 'Session 7 — Analytics as Decision Making', 'This is the framing he put on a slide and repeated. If asked how marketing analytics differs from data science or ML, lead with the decision objective, then structural mechanism, then causal effect of changing the action — not with software or algorithms.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-04', 'BANM2', 'short_answer', 'bamg_decision_frame', 7, 'Firms make marketing decisions in three broad ways. Name them and give the weakness of each.', '[]'::jsonb, '- **Evolved best practices** — use what has historically worked. Evolution requires trial and error, so building the playbook is slow and costly, and it cannot react to a sudden shock. Also risks tunnel vision: never considering a radically different action.
- **Theory or justified assumptions** — reason from an explicit model, e.g. Optimal Price = MC x PED / (PED + 1). A valid theory may not exist, or its assumptions may not fit: a monopoly formula does not solve a duopoly where the rival reacts.
- **Empirical analytics** — estimate R = f(A) from data and pick the best A.', 'Session 7 — Analytics as Decision Making', '> Trap: Do not say historical best practice fails because the world changes. He pushed for the sharper claim — evolution tracks *gradual* change fine. The real problems are costly trial-and-error and discontinuous shocks. His example was Apple-style launch scarcity reading as tone-deaf under COVID.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-05', 'BANM2', 'short_answer', 'bamg_decision_frame', 7, 'What are the three emphases that distinguish marketing analytics, and what are the two approaches to the third?', '[]'::jsonb, '- **Decision making** rather than prediction for its own sake.
- **Structural modelling** rather than an arbitrary flexible black-box function: f should encode ground truths about how and why an action produces an outcome.
- **Causal impact** of moving from one action to another, rather than descriptive or predictive analysis.
- The two approaches to causal assessment: causal inference with observational data (CIOD), and design and analysis of business experiments (DABE).', 'Session 7 — Analytics as Decision Making', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-06', 'BANM2', 'short_answer', 'bamg_blackbox_failures', 7, 'Give the three failures of using a black-box regression of historical market share on product features to design a new product.', '[]'::jsonb, '- **Observed share is confounded.** Share is not produced by the feature vector alone — advertising, distribution and other marketing actions are baked into it, so the fitted mapping is not the pure effect of the product on share.
- **Degrees of freedom.** Many categories have few products (rows) relative to the number of attributes and levels (columns), so there is too little data to estimate a rich share surface reliably.
- **No support for genuinely new attributes.** If no historical product has the proposed feature, the data contain no variation from which to estimate its effect.', 'Session 7 — Structural Modelling and the Three Black-Box Failures', 'State all three separately — one of them alone is not a complete answer. His third-failure example: fresh juice in a container that turns blue when the juice spoils. Structural market research can describe that hypothetical feature to a respondent and elicit its value; historical share data cannot.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-07', 'BANM2', 'short_answer', 'bamg_blackbox_failures', 7, 'What does structural modelling mean here, and what two ground truths does it respect that a share regression does not?', '[]'::jsonb, '- Structural modelling builds share up from how a customer actually chooses: preference parameters produce a utility for each product, utility produces a choice probability, and probabilities aggregate to share.
- Ground truth 1: if predicted share is 40%, the model implies that 40% of the represented customer mass buys the product.
- Ground truth 2: a customer buys the product because it is preferred to the alternatives actually available to them.', 'Session 7 — Structural Modelling and the Three Black-Box Failures', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-08', 'BANM2', 'short_answer', 'bamg_product_optim_pipeline', 7, 'Set out the product-price optimisation algorithm as a sequence of steps.', '[]'::jsonb, '- Enumerate every feasible candidate product P — all combinations of attribute levels.
- For each P, compute predicted expected market share s(P) against the incumbent set, structurally: for each consumer work out the likelihood of buying P from their preference parameters (compensatory or non-compensatory model), then aggregate across consumers.
- Compute predicted cost(P) from the production team''s cost data.
- Evaluate the chosen objective. For profit: market size x s(P) x [Price(P) − Cost(P)].
- Pick the candidate with the best value of that objective.', 'Session 7 — The Product-Price Optimisation Algorithm', 'In the mug example, brand is fixed at C, so the candidate set is 3 prices x 3 capacities x 3 cleanability levels = 27.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-09', 'BANM2', 'short_answer', 'bamg_product_optim_pipeline', 7, 'Why does market size drop out of the comparison, and what is the resulting objective called?', '[]'::jsonb, '- Profit(P) = market size x s(P) x [Price(P) − Cost(P)].
- Market size is the same constant for every candidate P, so it does not change the ranking and can be divided out.
- What remains is s(P) x [Price(P) − Cost(P)], which is the **expected profit per person**, or per prospect.', 'Session 7 — The Product-Price Optimisation Algorithm', 'Worth stating explicitly in an answer: the argmax is unchanged by dividing every candidate''s objective by the same positive constant.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-10', 'BANM2', 'short_answer', 'bamg_product_optim_pipeline', 7, 'The mug example has 27 candidates. What changes if price, capacity and cleanability each have 7 levels instead of 3?', '[]'::jsonb, '- The candidate set becomes 7 x 7 x 7 = 343 own-brand candidates.
- Preference parameters for the new intermediate levels are not measured, so they have to be obtained by interpolation or extrapolation.
- With more attributes on top of that, complete enumeration becomes infeasible: treat it as a continuous optimisation problem and use standard tools, for example Excel Solver.
- The conceptual algorithm does not change at all.', 'Session 7 — The Product-Price Optimisation Algorithm', 'Scope note: the course wants the managerial formulation, not the optimiser''s mechanics. Do not revise Solver algorithms.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-11', 'BANM2', 'short_answer', 'bamg_compensatory_utility', 7, 'Why is the economist''s choice model called compensatory?', '[]'::jsonb, '- Utility is the importance-weighted sum of the product''s attribute-level ratings, so every attribute contributes additively.
- A weak score on one attribute can therefore be offset — compensated — by a sufficiently strong score on another.
- No single weak attribute automatically eliminates the product.', 'Session 7 — The Compensatory Utility Model', 'He gave this as his own example of the short-answer style the exam will use. Two or three bullets is the right length.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-12', 'BANM2', 'short_answer', 'bamg_compensatory_utility', 7, 'Customer 1 has importances IPr 9, ICp 55, ICl 12, IBr 24, and rates the three products'' levels as shown in the deck. Compute the three utilities and give the deterministic forecast.', '[]'::jsonb, '- U(P1) = 9(1) + 55(7) + 12(7) + 24(7) = 646
- U(P2) = 9(3) + 55(7) + 12(2) + 24(5) = 556
- U(P3) = 9(7) + 55(1) + 12(7) + 24(1) = 226
- Highest utility is P1, so the max-choice forecast for customer 1 is product 1.

Repeating across all ten customers gives max-choice counts of 2, 4 and 4, hence shares of 20%, 40% and 40%.', 'Session 7 — The Compensatory Utility Model', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-13', 'BANM2', 'short_answer', 'bamg_compensatory_utility', 7, 'A customer''s capacity importance is 55. Does that mean they want a large mug?', '[]'::jsonb, '- No. Importance says how much the attribute moves that customer''s decision, not which level they want.
- Which level they want is in the level ratings. Customer 1 has capacity importance 55 but rates 20 oz at 7 and 32 oz at 6, so they prefer 20 oz.
- Importance and preference are two different columns and must not be read into each other.', 'Session 7 — The Compensatory Utility Model', 'This is one of the misconceptions he corrected in class, and the mirror image of the affinity-table trap in Session 8, where low capacity importance was misread as wanting a small mug.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-14', 'BANM2', 'short_answer', 'bamg_compensatory_utility', 7, 'Conjoint gives part-worths, not the 1-to-7 ratings and importances the model needs. What is the transformation, and why does the anchoring matter?', '[]'::jsonb, '- The **range** of the part-worths within an attribute becomes that attribute''s importance. For customer 1: price range 4.5, capacity 27.5, cleanability 6.0, brand 12.0, giving importances 9, 55, 12 and 24.
- The part-worths within each attribute are then rescaled into a common band, e.g. 1 to 7: Rescaled = TargetMin + (TargetMax − TargetMin) x (r − r_min) / (r_max − r_min).
- Anchoring matters because if the ratings within each attribute are not pinned to the same minimum and maximum, the importances are not comparable across attributes and the importance-weighted sum is meaningless.', 'Session 7 — The Compensatory Utility Model', 'How conjoint elicits part-worths in the first place is market-research methodology, which he put outside the scope of this course.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-15', 'BANM2', 'short_answer', 'bamg_noncompensatory_rules', 7, 'Describe the lexicographic and elimination-by-aspects rules, and say what makes both non-compensatory.', '[]'::jsonb, '- **Lexicographic**: select the product that performs best on the most important attribute; if there is a tie, break it on the next most important, and so on. For customer 1 in the deck this picks product 1.
- **Elimination by aspects**: set a minimum mental cutoff on each attribute; starting with the most important, eliminate every product that fails the cutoff, then repeat on the next attribute until one remains. With the deck''s cutoff of 1.5, customer 1 picks product 2.
- Both are non-compensatory because once a product is eliminated for failing an important attribute, superior performance on a less important attribute cannot bring it back.', 'Session 7 — Non-Compensatory Choice Rules', 'Note that the same customer with the same data gives a different answer under each rule — that is the point of showing both.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-16', 'BANM2', 'short_answer', 'bamg_noncompensatory_rules', 7, 'Should a manager use a compensatory or a non-compensatory model?', '[]'::jsonb, '- The criterion is empirical: whichever predicts choices more accurately in that setting.
- As a tendency, compensatory models fit B2B purchasing better and non-compensatory rules fit B2C better.
- The reasoning is organisational — B2B decisions involve multiple stakeholders and explicit trade-off matrices or discussion, which aggregates into something effectively compensatory even where individuals hold hard cutoffs. Consumers use faster cutoffs and heuristics.
- Of the two non-compensatory rules, elimination by aspects is overwhelmingly the more used in practice.', 'Session 7 — Non-Compensatory Choice Rules', '> Trap: Treat B2C to non-compensatory as a tendency, not a law. For consequential consumer purchases such as a house, people process more attributes and become willing to trade off.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-17', 'BANM2', 'short_answer', 'bamg_noncompensatory_rules', 7, 'Preferences and the competitive set both change. Why does that difference matter for how often the analysis is rerun?', '[]'::jsonb, '- Preference parameters — price sensitivity, functional tastes — are assumed to change relatively slowly.
- The competitive set changes much faster.
- So a competitor''s product change is absorbed by updating the product set and rerunning the spreadsheet, which is cheap.
- A genuine shift in underlying customer preferences requires new market research, which is substantially more expensive.', 'Session 7 — Non-Compensatory Choice Rules', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-18', 'BANM2', 'short_answer', 'bamg_logit_choice', 7, 'Why replace the deterministic max-utility forecast with logit probabilities?', '[]'::jsonb, '- The preference parameters come from market research and contain measurement error.
- Where the top two utilities are close, a small error can flip the predicted choice; where they are far apart it cannot. Customer 1 (646 vs 556) is safe; customer 9 (480 vs 492) is not.
- Rather than commit to a discrete prediction that may be wrong, hedge by predicting a probability for each product.', 'Session 7 — Logit Choice Probabilities and c', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-19', 'BANM2', 'short_answer', 'bamg_logit_choice', 7, 'Customer 1 has utilities 646, 556 and 226. With c = 0.02, give the logit procedure and the resulting probabilities.', '[]'::jsonb, '- Multiply each utility by c: 12.92, 11.12, 4.52.
- Exponentiate: approximately 408,399, 67,508 and 92.
- Sum them: 475,999.
- Divide each by the sum: approximately 0.86, 0.14 and 0.00.', 'Session 7 — Logit Choice Probabilities and c', 'He named this as one of his own examples of a quantitative short-answer item. Show the four steps; the arithmetic matters less than the procedure.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-20', 'BANM2', 'short_answer', 'bamg_logit_choice', 7, 'What does c represent, and how is it chosen in practice?', '[]'::jsonb, '- c captures how certain we are about the estimated utilities. c = 0 means no confidence, and probabilities flatten toward equal; c approaching infinity means complete confidence, and the highest-utility product takes all the probability.
- In principle the right c is the one that best reconstructs actual market shares.
- In practice, based on dozens of past studies, c = 100 / (12 x range of utilities over the product space).
- In the mug example the best possible utility is 7 x 100 = 700 and the worst is 1 x 100 = 100, so the range is 600 and c = 100 / (12 x 600) = 0.0139.', 'Session 7 — Logit Choice Probabilities and c', '> Trap: C is not a percentage accuracy of the market research. c = 1 does not mean 100% correct. It is a relative certainty or dispersion parameter.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-21', 'BANM2', 'short_answer', 'bamg_logit_choice', 7, 'How do you get from individual choice probabilities to a predicted market share?', '[]'::jsonb, '- Average each product''s choice probability across all customers.
- In the mug data at c = 0.0139, averaging the three probability columns gives 0.22, 0.38 and 0.40.', 'Session 7 — Logit Choice Probabilities and c', '> Trap: Average the probabilities, not the deterministic max-choice indicators. The max-choice counts gave 0.20 / 0.40 / 0.40 on the same data — close here, but they are different quantities.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-22', 'BANM2', 'short_answer', 'bamg_profit_per_prospect', 7, 'Our candidate is priced at 5 dollars with 12 oz capacity and Easy cleanability, and has predicted share 0.40. Capacity costs are 1.00 / 2.60 / 2.80 and cleanability costs are 1.00 / 2.20 / 3.00. Compute expected profit per prospect.', '[]'::jsonb, '- Cost = 1.00 (12 oz) + 3.00 (Easy) = 4.00.
- Margin = Price − Cost = 5.00 − 4.00 = 1.00.
- Expected profit per prospect = s(P) x margin = 0.40 x 1.00 = 0.400.', 'Session 7 — From Share to Expected Profit per Prospect', 'All figures in dollars. Only capacity and cleanability carry cost in this example; price and brand do not.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-23', 'BANM2', 'short_answer', 'bamg_profit_per_prospect', 7, 'Candidate 24 has the highest predicted share of the 27. Why is it not the answer?', '[]'::jsonb, '- Candidate 24 is priced at 5 dollars with 20 oz and Easy cleanability: the low price, the popular middle size and the desired cleanability, so its share is the highest at 0.503.
- Its cost is 5.60, so the margin is negative at minus 0.60 per unit.
- Expected profit per prospect is 0.503 x (minus 0.60) = minus 0.302.
- It is the right answer only if the objective is market share. Under a profit objective it destroys value on every unit sold.', 'Session 7 — From Share to Expected Profit per Prospect', 'The profit winner is candidate 6 — 30 dollars, 20 oz, Easy — at 3.780 per prospect, on a share of only 0.155.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-24', 'BANM2', 'short_answer', 'bamg_objective_taste', 7, 'List the common objective functions for product optimisation and give a reason a firm might hold each.', '[]'::jsonb, '- **Profit or free cash flow** — current economic surplus.
- **Market share** — buy scale now at low or negative margin, then monetise the installed base or weaken rivals.
- **Sales revenue** — top-line scale is attractive in itself, and an acquirer may believe it can fix costs later.
- **Margin** — a strategic acquirer that already has reach wants a high-margin product to push through its system.
- **Low cost** — a capital-constrained or risk-averse business wants something cheap to make.', 'Session 7 — Choosing the Objective Function', 'Illustrations from class: Buffett-style thinking for profit; blitzscaling, Jio, Uber in China and OpenAI for share; private-equity logic for revenue; a larger same-industry acquirer for margin; a family business for low cost.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-25', 'BANM2', 'short_answer', 'bamg_objective_taste', 7, 'A client will not tell you which objective it is optimising. What should the recommendation look like, and why?', '[]'::jsonb, '- Do not bluff a single optimal recommendation, because the choice of objective is a matter of the firm''s taste — its ownership, financial position, growth model and managerial DNA — and the metrics genuinely conflict.
- Present conditional recommendations instead: if profit is the objective choose X, if share choose Y, if revenue choose Z.
- That exposes the key assumption rather than hiding it, and lets the client confront the trade-off.', 'Session 7 — Choosing the Objective Function', 'He says he learned this from senior consulting partners. A student added that her firm (KPMG) uses the same conditional logic.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-26', 'BANM2', 'short_answer', 'bamg_beyond_the_algorithm', 7, 'The optimisation has picked a product. What does it not cover, and what tool bridges the gap?', '[]'::jsonb, '- It does not cover the translation of desired benefits into production specifications, which is not straightforward.
- It does not cover higher-level or latent customer needs that customers do not state cleanly.
- It does not cover aesthetics.
- Quality function deployment, the house of quality, is the disciplined bridge: user needs down the rows, technical specifications across the columns, and each cell recording the strength and sign of the relationship (++, +, −, −−).', 'Session 7 — Beyond the Algorithm: QFD and Market-Driving Strategy', 'Mug examples from the slide: mouth opening relates ++ to not dribbling; insulating material relates ++ to keeping liquid hot and −− to low cost.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s7-27', 'BANM2', 'short_answer', 'bamg_beyond_the_algorithm', 7, 'Contrast market-driven and market-driving strategy, and say where the choice-and-optimisation machinery works best.', '[]'::jsonb, '- Market-driven: incremental innovation, new product or line extension, satisfy and delight current customers, expressed needs, quantitative research such as surveys and test markets, lower risk, lower cost, higher frequency.
- Market-driving: breakthrough innovation, new platform or category, create customers, latent needs, lead-user observation and focus groups, higher risk, higher cost, lower frequency.
- The machinery is strongest in the market-driven setting, where preferences and the competitive set are stable enough to measure.
- It weakens when an innovator changes how the whole category is perceived, because the fixed-preference and fixed-competitive-set assumptions stop holding. A student''s Tesla example, which he accepted.', 'Session 7 — Beyond the Algorithm: QFD and Market-Driving Strategy', 'He noted business schools over-weight the market-driven column because established firms and consultancies do most of the hiring, and that market-driving firms are not always startups — Apple and the iPad were his counterexample. He also stressed the failure rate of breakthrough attempts.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-01', 'BANM2', 'short_answer', 'bamg_affinity_segmentation', 8, 'Define the affinity segmentation output table and give the formula for one cell.', '[]'::jsonb, '- For a candidate product P and each available customer descriptor X, compute the across-customer average of X weighted by each customer''s probability of buying P.
- Cell = Σ over customers of (X_i x Pr_i(P)) divided by Σ over customers of Pr_i(P).
- The table has one row per product plus an overall-market row, and one column per descriptor: attribute importances, preference-for-a-level times attribute importance, and demographic or behavioural variables.
- It is computed for every product in the category, not just ours, because the insight comes from how our buyers differ from a competitor''s.', 'Session 8 — Affinity Segmentation', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-02', 'BANM2', 'short_answer', 'bamg_affinity_segmentation', 8, 'Compute the weighted mean brand importance for likely buyers of product 3, and say why you do not rescale the weights first.', '[]'::jsonb, '- Numerator: Σ (IBr_i x P3_i) = 29.95. For example customer 1 contributes 24 x .095 = 2.28 and customer 2 contributes 31 x .042 = 1.30.
- Denominator: Σ P3_i = 1.55.
- Weighted mean = 29.95 / 1.55 = 19.3, which the table reports as about 19.34.
- The denominator already performs the normalisation, so rescaling the weights to sum to 1 beforehand would double-count it.', 'Session 8 — Affinity Segmentation', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-03', 'BANM2', 'short_answer', 'bamg_affinity_segmentation', 8, 'A classmate says the purchase probabilities used as affinity weights must sum to 1. Is that right?', '[]'::jsonb, '- Not across customers. Every customer could buy product 3, or none of them could, so Σ P3 across people can be 1.55, or 4, or anything in range.
- What does sum to 1 is P1 + P2 + P3 **within a single customer**, because in this simplified market the offered products are mutually exclusive and collectively exhaustive.', 'Session 8 — Affinity Segmentation', 'For a binary descriptor such as sports, the weighted mean reads directly as a fraction of the buyer mass: .84 means roughly 84% of likely product-3 buyers play sport.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-04', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8, 'What is a focal descriptor, and how is lift used to find one?', '[]'::jsonb, '- A focal descriptor is one that makes the buyer group **distinctive**, rather than one that is simply true of them. His analogy: describing a classmate, you would not say two eyes, one nose, two feet.
- Lift = segment mean / overall market mean; log lift = log(lift).
- Log lift near zero means the segment looks like the market on that descriptor, so it is not focal.
- Large positive means over-indexed and large negative means under-indexed. Both are focal.', 'Session 8 — Focal Descriptors, Log Lift and the Persona', '> Trap: In a log-lift heatmap, strong negative values matter as much as strong positive ones. The question is whether our customers are *different*, not whether they are *higher*.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-05', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8, 'Product-3 buyers have a negative log lift on capacity importance. What does that mean, and what does it not mean?', '[]'::jsonb, '- It means capacity matters less to their decision than it does to the market overall — they are less hung up about getting a particular size.
- It does **not** mean they prefer a smaller mug. Their mean capacity-level ratings still put 20 oz highest, at 5.63.
- Importance and level preference are separate quantities and a lift on one says nothing about the other.', 'Session 8 — Focal Descriptors, Log Lift and the Persona', 'He also used the low capacity importance positively: it makes airport retail, where shelf space limits the range of sizes stocked, a strategic fit rather than a constraint.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-06', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8, 'Give the persona for our mug''s likely buyers, first as a readout and then as the extended description.', '[]'::jsonb, 'Readout, straight from the log lifts:
- Less price-sensitive than the market overall.
- Much less concerned with capacity, though 20 oz is still their preferred size.
- Cleanability is highly important to them.
- Brand importance is about the market average.
- Income and age are not focal.
- Strongly sports-active and far more graduate-educated than average.

Extension, using societal and cultural knowledge: educated, health-conscious and gym-going, busy people.', 'Session 8 — Focal Descriptors, Log Lift and the Persona', 'The extension step is allowed to reach beyond the data, but it has to be anchored in the readout rather than invented. The reusable algorithm: weighted means, then lift versus overall, then keep the large absolute deviations, then translate literally, then add associated characteristics.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-07', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8, 'What is the persona actually used for?', '[]'::jsonb, '- It determines the kinds of people and situations to depict in the advertising, so the creative matches the buyer.
- It informs where the product should be sold. For this mug the class produced e-commerce and quick commerce, gyms and sports events, corporate bulk sales and office-park trial booths, and airport retail.
- Together with the positioning statement it forms the advertising brief handed to the agency.', 'Session 8 — Focal Descriptors, Log Lift and the Persona', 'So the persona is the analytical bridge from the chosen product back to two of the 4Ps: promotion and place.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-08', 'BANM2', 'short_answer', 'bamg_competition_views', 8, 'Give the three views of who a competitor is, and say what data each compares.', '[]'::jsonb, '- **Consumer psychologist**: competitors are products whose customer personas are most similar. Compare the rows of the affinity segmentation output table, after putting descriptors on comparable scales.
- **Economist**: competitors are substitutes — the same customers tend to be won or lost together. Compare the columns of purchase probabilities across people.
- **Brand manager**: the competitor is whichever other brand our buyers like second most. Compare brand-preference values only.', 'Session 8 — Three Operational Definitions of Competition', 'In the mug data the first two both point at product 1, and the brand-manager view points at brand A, since product-3 buyers rate C 5.699, A 4.338 and B 1.632.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-09', 'BANM2', 'short_answer', 'bamg_competition_views', 8, 'Why does the brand manager ignore the other attributes, and what does the mug data show about symmetry of competition?', '[]'::jsonb, '- On the brand manager''s view, product attributes can be changed over time while the brand is the more persistent identity, so brand preference is the durable signal. He is explicit that this is a perspective one may or may not agree with.
- Competition can be asymmetric. Product-3 buyers rate their own brand C highest and brand A second. But brand A''s own buyers rate A 6.374, B 3.450 and C 2.730 — brand C barely registers.
- So a smaller brand may need to worry about the leader far more than the leader needs to worry about it. A student called brand A "well protected".', 'Session 8 — Three Operational Definitions of Competition', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-10', 'BANM2', 'short_answer', 'bamg_positioning_statement', 8, 'Give the positioning statement template and the slide''s example.', '[]'::jsonb, '- Template: Brand X is better at [claim or benefit] relative to [competitive frame] because it [supporting evidence].
- Example: Rolaids is better at curing heartburn within 20 minutes, relative to Tums, because it contains a new ingredient.
- Building it analytically needs two answers: who the competitor is, and which strength to emphasise.', 'Session 8 — Writing the Positioning Statement', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-11', 'BANM2', 'short_answer', 'bamg_positioning_statement', 8, 'How do you decide which strength the positioning claim should emphasise?', '[]'::jsonb, '- Identify the attribute where our utility contribution is highest **relative to** the chosen competitor, where the contribution of attribute a is Importance_a x Rating(Level_a(P)).
- Operationally: rank attributes by importance for our buyers, start with the most important, ask whether we are actually better than the competitor on it, and if not move to the next.
- For our mug, cleanability comes first because it has the highest importance among these buyers, and the candidate is Easy to clean.', 'Session 8 — Writing the Positioning Statement', '> Trap: Do not simply pick the attribute our buyers care most about. Importance without relative superiority is not differentiation — the claim has to beat the competitive frame you named.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s8-12', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8, 'The readout says our buyers care a lot about cleanability and little about price. Justify extending that to "busy people, short on time".', '[]'::jsonb, '- **Cleanability**: Easy is 2 minutes and Difficult is 7, so caring intensely about that attribute is caring about a five-minute saving. That is a statement about time pressure.
- **Low price importance**: getting a good price requires searching and comparing offers. Busy people cannot search. So low price sensitivity on a cheap everyday item points at time-poverty.
- Both focal descriptors point the same way, which is what makes the extension reasonable rather than invented.
- The extension must be anchored in focal descriptors. Anything not supported by a red or green cell is not available to you.', 'Session 8 — Focal Descriptors, Log Lift and the Persona', '> Trap: Low price importance is not low income. For a Rolls-Royce or a house, price sensitivity does track income; for a mug it does not. Our buyers'' income log lift is +0.047 — essentially the market average — so income is not what is driving it.

> Prof: He accepted a student''s counter that playing sport might substitute for going to the gym rather than predict it. Reasonable extrapolations can be argued against, and saying so is better than overclaiming. He also noted the alternative — refusing to extrapolate at all — is defensible but hands the agency less to work with.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-01', 'BANM2', 'short_answer', 'bamg_ad_brief_hierarchy', 9, 'Who owns each step from advertising brief to evaluation, and what is the governance warning?', '[]'::jsonb, '- **Internal** — the product or consulting team writes the advertising brief: the persona plus the positioning statement.
- **Agency** — the advertising agency translates the brief into print, audio and video creatives.
- **Joint** — internal team and agency choose outlets and placements together, e.g. Dainik Jagran versus the Financial Times, Radio Mirchi versus Spotify.
- **Internal** — the product or marketing team evaluates effectiveness.
- The warning: never let the advertising agency evaluate its own work, because the agency is incentivised to show success.', 'Session 9 — The Advertising Brief and the Hierarchy of Effects', 'The line he draws is external agency versus internal firm team. He is not trying to separate internal product from internal marketing for this point. After creative and outlet design there may be 20-30 execution combinations; preliminary evaluation cuts them to about 3-5 before field rollout.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-02', 'BANM2', 'short_answer', 'bamg_ad_brief_hierarchy', 9, 'Name the four preliminary advertising metrics in order and explain why they are ordered that way.', '[]'::jsonb, '- **Attention** — did the advertisement hold the person? Measured by skip rates, or eye tracking for non-skippable display and print.
- **Recall** — is the brand and the sales argument remembered? Prompted "which brand did you see?" surveys.
- **Persuasion** — has attitude or inclination shifted? Attitude scales, recommendation-likelihood or NPS-style proxies.
- **Behaviour** — did purchase or another observable action change?

Each is a precondition for the next: nothing encodes without attention, persuasion needs the message remembered, and behaviour rarely moves without a motivational shift.', 'Session 9 — The Advertising Brief and the Hierarchy of Effects', 'Behaviour is the real target but is usually impractical in a short controlled pilot — a Toyota advertisement may influence a purchase months later, after family discussion, with exposure online and purchase offline. All four are assessed causally, by experiment or by causal inference.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-03', 'BANM2', 'short_answer', 'bamg_observational_vs_causal', 9, 'Distinguish observational assessment from causal assessment of a move from action A1 to A2.', '[]'::jsonb, '- **Observational**: compare the response of customers under A1 with the response of different customers under A2. Any difference may be the action, or may be pre-existing differences between the two groups.
- **Causal**: ideally compare the response of customers under A1 with the response of *those same customers* under A2, under similar conditions.
- Nobody can be observed in both states at once, which is why designs are approximations of the causal ideal.
- Terminology: the action being evaluated is the treatment; the customers subjected to it are the treatment or treated group.', 'Session 9 — Observational versus Causal Assessment', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-04', 'BANM2', 'short_answer', 'bamg_validity_threats', 9, 'In the Toyota study, R2 comes back higher than R1. Why is R2 − R1 not the causal effect of the commercial?', '[]'::jsonb, '- The observed movement contains the true effect plus two categories of bias: R2 − R1 = E + D + MNE.
- **D, contemporaneous drift**: any non-treatment influence that shifted attitudes between the two measurements.
- **MNE, measurement non-equivalence**: the measurement process itself changed between the two points.
- Writing B = D + MNE gives E = (R2 − R1) − B. R2 − R1 is only an accurate measure of E if B is small, and there is no reason to believe it is.', 'Session 9 — Validity Threats in the Before-After Design', 'He frames validity as falsification: what counter-argument could falsify my causal claim? If an alternative story explains the movement equally well, the design has a threat.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-05', 'BANM2', 'short_answer', 'bamg_validity_threats', 9, 'Give three sources of contemporaneous drift in the Toyota study.', '[]'::jsonb, '- **External events**: between 27 December and early January participants may meet Toyota information outside the experiment — a friend''s positive mention at a holiday gathering, a news story, or competitor advertising.
- **Psychological change**: over a holiday week people become more relaxed and optimistic and may rate everything, Toyota included, more favourably.
- **Pre-survey sensitisation**: completing the initial Toyota questionnaire primes participants to notice Toyota during the intervening week, such as spotting the cars on the road, shifting the post-measure independently of the commercial.', 'Session 9 — Validity Threats in the Before-After Design', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-06', 'BANM2', 'short_answer', 'bamg_validity_threats', 9, 'Give two sources of measurement non-equivalence in the Toyota study.', '[]'::jsonb, '- **Survey incentive effect**: the mailed post-survey came with a 20-dollar gift card and the in-person pre-survey did not. Reciprocity or the resulting positive mood inflates R2 as an artifact of the changed procedure, not a real attitude shift.
- **Selective attrition**: 120 completed the pre-survey and only 80 returned the post-survey. If the 40 non-responders differ systematically — for example being less interested in Toyota — then R1 and R2 are measured on different subpopulations, and the average can rise without any individual changing their mind.', 'Session 9 — Validity Threats in the Before-After Design', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-07', 'BANM2', 'short_answer', 'bamg_validity_threats', 9, 'Distinguish external from internal validity threats, and say why a large random sample does not settle the first.', '[]'::jsonb, '- **External validity threats** are counter-arguments about generalising to the broad target population, caused by a mismatch between the populations or measures in the experiment and those of the real marketing task.
- **Internal validity threats** are counter-arguments about the specific measures and sample inside the experiment.
- A large random sample does not create external validity: the sample still has to come from the right target population or an equivalent one. Randomly sampling Wisconsin Kmart visitors more heavily still gives you Wisconsin Kmart visitors.', 'Session 9 — Validity Threats in the Before-After Design', 'His India illustration: cities such as Indore, Nagpur, Surat, Pune and Coimbatore can be chosen to capture different slices of the country, while the big metros are unrepresentative on language, migrant composition and urban-rural exposure. Representativeness is not the same thing as sample size.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-08', 'BANM2', 'short_answer', 'bamg_control_group_designs', 9, 'Derive the estimator for the before-after with control group design.', '[]'::jsonb, '- For the experimental group: R2 − R1 = E + B.
- For the control group: R4 − R3 = E'' + B''.
- The control group saw no Toyota advertising, so its true effect is zero by construction: E'' = 0.
- Assuming the two groups are equivalent in behaviour, their biases are equal: D'' = D and MNE'' = MNE, so B'' = B.
- Therefore R4 − R3 = B, and E = (R2 − R1) − (R4 − R3): change in the treated group minus change in the control group.', 'Session 9 — Control-Group Designs', 'This is the cleanest formula in the session because the causal logic is visible in it. He treats it as the gold standard among the designs taught.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-09', 'BANM2', 'short_answer', 'bamg_control_group_designs', 9, 'Under what assumptions does the after-only with control group design reduce to E = R2 − R4?', '[]'::jsonb, '- Start from E = (R2 − R1) − (R4 − R3) and rearrange: E = R2 − R1 − R4 + R3 = (R2 − R4) + (R3 − R1).
- If the experimental and control groups are equivalent at the start of the experiment, R1 = R3, so the second bracket is zero.
- Then E = R2 − R4, with no pre-measurement needed in either group.
- It also requires no leakage between the groups.', 'Session 9 — Control-Group Designs', 'This is the A/B testing logic. He stresses that it *looks* observational — you compare two different groups at one point in time rather than following people across time — and that its causal justification is that very large randomised groups make the omitted pre-measures effectively equivalent. That is why he says after-only carries a much heavier sample-size requirement.

> Trap: Standard experimental-design texts treat a properly randomised post-test-only experiment as causal without any baseline measure. For this exam, reproduce his framing.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-10', 'BANM2', 'short_answer', 'bamg_control_requirements', 9, 'What are the two requirements of a control group, and how is the first achieved?', '[]'::jsonb, '- **Equivalence except for the treatment.** With large samples, random assignment to treatment or control. With small samples, matching on profiles, actively constructing comparable groups rather than trusting random balance. If the groups are not equivalent, the variables on which they differ are confounds.
- **No leakage between the groups.** The control group must not learn about the treatment or be affected by what happens to the treated group. This is the stable unit treatment value assumption, SUTVA.', 'Session 9 — What a Control Group Requires', 'The large-sample requirement is heavier for the after-only design, because there are no pre-measures to reveal or absorb an imbalance. Randomisation with large samples reduces internal validity threats but does nothing for external validity.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-11', 'BANM2', 'short_answer', 'bamg_control_requirements', 9, 'Give two ways leakage or interference can break a control group, and say which direction the bias runs in the first.', '[]'::jsonb, '- **Promo-code leakage**: treated customers share a treatment-only code with control customers. Controls then behave more like the treated, the measured difference shrinks, and the effect is typically biased downward.
- **Uber driver interference**: treated drivers receive extra compensation and accept more rides. With a limited pool of rides, control drivers then receive fewer rides *because* the treated group exists — the two groups interact through the market without ever communicating.', 'Session 9 — What a Control Group Requires', 'Leakage is harder to avoid over longer time frames and wherever constraints connect the two groups'' behaviour.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-12', 'BANM2', 'short_answer', 'bamg_time_series_design', 9, 'Set out the time-series-without-control-group design and its estimator.', '[]'::jsonb, '- Measure the same group across alternating states: R1, then treatment X, then R2, then no treatment O, then R3.
- It is the before-after-with-control design folded onto one group: R2 here plays the role of both R2 and R3 there, and R3 here plays R4 there.
- So E = (R2 − R1) − (R3 − R2) = 2R2 − (R1 + R3).
- The assumption has moved rather than disappeared: the bias is now assumed constant **within one group across adjacent time intervals**, instead of across two groups.', 'Session 9 — Time Series Without a Control Group', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-13', 'BANM2', 'short_answer', 'bamg_time_series_design', 9, 'How is the time-series design extended to many periods, and what are its advantages?', '[]'::jsonb, '- Interleave treatment and no-treatment periods, ideally randomised, and build a dataset of time index, a 0/1 treatment indicator and the response.
- Estimate Response = b0 + b_ti x Time_index + b_tr x Treatment. The coefficient on treatment estimates E, with the time index absorbing the trend.

Advantages:
- No separate control group, so neither the equivalence requirement nor the leakage requirement applies.
- Long-term effects are easier to observe.
- It can be run on natural field data, provided the treatment varies over time.', 'Session 9 — Time Series Without a Control Group', 'The S10 outline mentions autoregressive time-series models with covariates, but the handouts and class give no AR equation beyond this regression and the later adstock formulation. Do not invent one.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s9-14', 'BANM2', 'short_answer', 'bamg_control_requirements', 9, 'Both control-group designs need large samples. Why does after-only need a much larger sample than before-after with control?', '[]'::jsonb, '- **Before-after with control** assumes only that the bias is the same in both groups, D′ = D and MNE′ = MNE. That needs moderately large samples: with very small groups the two groups'' drift and attrition patterns will differ by chance, so B′ ≠ B and the subtraction fails.
- **After-only with control** assumes all of that, **and in addition** that R1 = R3 — that the groups started level on a measurement nobody actually took.
- That extra assumption is carried entirely by randomisation and the law of large numbers, so it needs much bigger samples to be safe.
- Hence before-after with control is the gold standard: it *measures* the bias rather than assuming it away.', 'Session 9 — What a Control Group Requires', 'His phrasing: A/B testing does not work as causal assessment because there is no pre-measurement — unless the samples are so large that the pre-measurements would have cancelled anyway.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-01', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10, 'He argues the headline number is often not the most valuable output of an analysis. What is, and give two examples from this course.', '[]'::jsonb, '- The immediate value is that trying to produce the number forces the team to think rigorously, concretely and systematically about the problem. Clever people can find a problem with almost any calculation.
- **Competition**: without analysis, "who are our competitors?" stays fuzzy. Affinity segmentation forced three concrete answers — persona similarity, economic substitution, brand-preference rivalry.
- **Best product**: without an explicit objective, "best" can mean profit, share, revenue, margin or low cost. The model makes the client confront that choice.
- The long-run value is broader search: a "Move 37" effect, where computation inspects options that look implausible to a human working from familiar templates.', 'Session 10 — What Analytics Is Actually For', 'Move 37 is AlphaGo''s move against Lee Sedol. His working example of the effect was the Tata Motors truck project with Prof. Manish Gangwar, where the data-driven concept differed from what an STP exercise produced.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-02', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10, 'Is STP obsolete now that exhaustive structural search exists?', '[]'::jsonb, '- No. Both frameworks are good in different contexts.
- Exhaustive structural search needs preference, feature, competitor and cost data. Where those do not exist — his HUL Kisan-type case — classical STP, 3Cs and 4Ps are the best available method. He put that at roughly 70% of situations today.
- Where the data do exist, the algorithm casts a wider net rather than committing early to a target segment, which matters because the intended target often is not the eventual market.
- Analytics has value even where it is not literally implementable, because it clarifies the questions. Its stronger advantage grows as richer preference and market data become available.', 'Session 10 — What Analytics Is Actually For', 'His examples of targets that shifted: Toyota Qualis/Innova aimed at joint families but taken up by tour and long-distance operators; Yulu aimed at last-mile commuters but taken up by gig and delivery workers; OYO aimed at low-end business travellers but taken up by young couples.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-03', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10, 'Where do the 4Ps and the 3Cs sit inside the analytical framework?', '[]'::jsonb, '- **Product**: the candidate feature vector P selected by the optimisation.
- **Price**: one of the candidate''s decision variables, optimised alongside the other attributes.
- **Promotion**: persona plus positioning, becoming the advertising brief and then the creative and media execution.
- **Place**: persona-informed channel choice.
- **Customer**: customer *needs*, held concretely in the preference-parameter database. Not age and demographics.
- **Competition**: the incumbent products, entering the utility and choice comparison directly. There is no vague white-space analysis.
- **Company**: capabilities and core competence, which show up concretely in the cost structure — a capability is something the firm can execute more effectively or more cheaply than rivals.
- The S and T of STP are deliberately not performed: the algorithm evaluates the broad customer and product space instead of pre-selecting a target segment.', 'Session 10 — What Analytics Is Actually For', 'He corrected students who answered that the Customer C was demographics or the Competition C was white space. The value of analytics, on his account, is exactly that every framework term gets an operational location in the data and equations.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-04', 'BANM2', 'short_answer', 'bamg_micro_macro_extremes', 10, 'What four context factors make advertising assessment complicated, and what are the two extremes they produce?', '[]'::jsonb, 'Four context factors:
- Exposure measurement: individual or group.
- Behaviour measurement: individual or group.
- Response latency: immediate or delayed.
- Behaviour frequency: one-time or repeated.

- **Micro extreme**: exposure and behaviour both at the individual level, immediate one-time behaviour. Loosely a direct-response mindset.
- **Macro extreme**: exposure and behaviour known only in aggregate, response possibly delayed and repeated. Loosely a brand-building mindset.', 'Session 10 — Micro and Macro Extremes in Advertising Assessment', 'Most large advertising budgets sit near the macro extreme: you may know Nagpur sold 10,000 bottles this week against 12,000 last week, and know the weekly spend by outlet, but not which person saw which advertisement before buying which bottle.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-05', 'BANM2', 'short_answer', 'bamg_mmm_decisions', 10, 'What three decisions does media mix modelling make, and which are macro versus micro scheduling?', '[]'::jsonb, '- How much should we spend on advertising as a whole?
- How much should go to campaign A, campaign B and so on?
- How should the advertising be distributed over time?
- The first two are **macro scheduling**: allocation within a longer time frame such as a quarter or a year. The third is **micro scheduling**: the pattern of execution over days or weeks.', 'Session 10 — The Three Media Mix Modelling Decisions', '> Trap: The transcript contains a verbal slip calling the first two questions micro-scheduling, one sentence after correctly calling them macro. The slide is unambiguous — first two macro, temporal pattern micro.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-06', 'BANM2', 'short_answer', 'bamg_mmm_decisions', 10, 'How is advertising volume measured, and what does GRP mean?', '[]'::jsonb, '- Either by expenditure, or by gross rating points.
- GRP = Reach percent x Frequency.
- It summarises total audience exposure pressure: a plan reaching a larger share of the population, or exposing that population more often, has a higher GRP.', 'Session 10 — The Three Media Mix Modelling Decisions', 'The same GRP can be high reach with low frequency or the reverse, which is why reach and frequency stay separate decisions rather than collapsing into the single number.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-07', 'BANM2', 'short_answer', 'bamg_mmm_response_model', 10, 'Write the general MMM optimisation and say what the two hard parts are.', '[]'::jsonb, '- Unconstrained: choose the campaign intensities to maximise Profit = Sales(Ad_A,t, Ad_B,t, ...) x Margin − Cost(Ad_A,t, Ad_B,t, ...).
- Or constrained: maximise Sales x Margin subject to Cost being under a given budget.
- Hard part 1: estimating the sales response function, usually a regression with a chosen functional form.
- Hard part 2: running the optimisation itself.
- Both are hard because of the nonlinearity, which is what motivates the Dorfman-Steiner simplification.', 'Session 10 — The MMM Response Function', 'Meta''s MMM package Robyn is the slide''s example; it uses Nevergrad for the optimisation. Google Meridian was named in class as another product.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-08', 'BANM2', 'short_answer', 'bamg_mmm_response_model', 10, 'What do adstock and the saturation term capture in the Robyn-style response function?', '[]'::jsonb, '- **Adstock** captures carryover: Adstock_A,t = Ad_A,t + δ Ad_A,t−1 + δ² Ad_A,t−2 + ..., so this week''s advertising still affects later weeks, with δ controlling how fast the memory decays.
- The **saturation** term, (Adstock)^γ / [α^γ + (Adstock)^γ], captures diminishing incremental response as effective exposure accumulates.
- Channel responses then add up: Sales = Sales_A(Ad_A,t) + Sales_B(Ad_B,t) + ...', 'Session 10 — The MMM Response Function', 'His managerial warning is data scarcity relative to complexity: a mass-media model may have only about three years of weekly observations, roughly 156 rows, while trying to estimate several channel-response, decay, saturation and business parameters. The point of showing the equation is that it looks complicated — he is not asking anyone to derive or estimate Robyn.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-09', 'BANM2', 'short_answer', 'bamg_dorfman_steiner', 10, 'State the Dorfman-Steiner rule and its three assumptions.', '[]'::jsonb, 'Assumptions:
- Sales volume can be increased only by price promotion (cutting price) or by advertising.
- The marketing budget allows only advertising or price-promotion expense.
- The firm is a static monopoly.

Under optimal pricing and advertising decisions:
- Advertising = [Advertising elasticity / (− Price elasticity)] x Sales.
- For campaign-specific allocation, spend on a campaign is proportional to that campaign''s advertising elasticity.', 'Session 10 — The Dorfman-Steiner Allocation Rule', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-10', 'BANM2', 'short_answer', 'bamg_dorfman_steiner', 10, 'Price elasticity is −2.50, overall advertising elasticity 0.15, campaign A elasticity 0.10, campaign B elasticity 0.05, and current sales are 10M dollars. Allocate the advertising budget.', '[]'::jsonb, '- Total optimal advertising = (0.15 / 2.50) x 10M = 0.6M dollars.
- The campaign elasticity ratio is .10 to .05, which is 2 to 1.
- Campaign A gets 0.4M dollars and campaign B gets 0.2M dollars.', 'Session 10 — The Dorfman-Steiner Allocation Rule', '', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-11', 'BANM2', 'short_answer', 'bamg_dorfman_steiner', 10, 'Explain the intuition for price elasticity sitting in the denominator of the Dorfman-Steiner rule.', '[]'::jsonb, 'The rule says lower price elasticity means *more* advertising, which is counterintuitive. There are two separate pathways, and a full answer gives both.

- **The lever argument.** Under the model''s assumptions sales can be raised only two ways: cut price, or advertise. If demand is not very price-sensitive, cutting price barely moves volume, so price promotion is a weak lever and advertising is the effective one that remains.
- **The funding argument.** If demand is not very price-sensitive, you should not merely stop cutting price — you should raise it, since volume will hardly fall. The higher price generates more revenue, and that revenue is what funds the advertising.

Supporting definitions: advertising elasticity is the percentage change in sales for a 1% change in advertising, and acts as the return on advertising in the numerator; price elasticity is negative by convention, so the minus sign in the denominator takes its magnitude.', 'Session 10 — The Dorfman-Steiner Allocation Rule', 'He called the numerator terms "relatively obvious" and the denominator "the puzzling thing", then gave both pathways explicitly — so both are fair game.

His aside: ask an advertising agency how much to spend and the natural answer is "as much as you can". Diminishing returns are why the economically optimal spend is finite.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-12', 'BANM2', 'short_answer', 'bamg_scheduling_patterns', 10, 'Name the four micro-scheduling patterns and give the defining feature of each.', '[]'::jsonb, '- **Even**: divide the budget equally across all weeks. He considers it inefficient, because repeated identical exposure runs into wearout.
- **Blitz**: concentrate spend in a short initial burst. Fits splashy launches — technology products, automobiles — where immediate attention, buzz and word of mouth matter.
- **Pulsing**: alternate substantial on-periods with zero-advertising off-periods. The defining feature is going dark.
- **Pulsing plus maintenance**: keep a low baseline through the would-be dark periods, with correspondingly lower peaks. Brand managers often prefer constant presence, but he calls it less effective than true dark periods at resetting wearout.', 'Session 10 — Micro Scheduling and Wearout', 'All four are drawn with the same area under the curve — only the timing changes. The Stouffer''s GRP chart in the handout is the real-world illustration: strong bursts separated by long near-zero stretches.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-13', 'BANM2', 'short_answer', 'bamg_scheduling_patterns', 10, 'Define wear-in and wearout, and explain why they argue for pulsing rather than even scheduling.', '[]'::jsonb, '- The psychological premise is that people attend to change and novelty rather than to constancy, so repeated stimuli saturate.
- **Wear-in**: response increases with repetition. Early exposures build comprehension and familiarity, and a person may need several encounters before the message lands.
- **Wearout**: once the message is familiar, incremental attention falls and further identical exposures are increasingly ignored.
- So spending evenly past the wearout point wastes exposures. Pulsing stops when wearout appears, goes dark until the advertisement is nearly out of memory, and restarts when repetition can create incremental response again.', 'Session 10 — Micro Scheduling and Wearout', 'The slide also labels a residual, path-dependent effect on the curve as hysteresis: the effect can persist after the stimulus stops.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-14', 'BANM2', 'short_answer', 'bamg_scheduling_patterns', 10, 'A student proposes advertising continuously but rotating five creatives to avoid wearout. What are the objections?', '[]'::jsonb, '- If five creatives exist, one of them is presumably the best, so rotation deliberately spends exposures on inferior advertisements.
- Multiple simultaneous messages can confuse the brand and dilute its identity.
- His practical summary is that the industry tends to favour pulsing or blitz over continuous even spending.', 'Session 10 — Micro Scheduling and Wearout', 'Nuance worth flagging: the research slide also says ad effect is greater when copy strategy has recently changed, and that the benefits of constant change in TV advertising outweigh the risks. The material never reconciles that with the objection above. A plausible reading is periodic refresh over time versus simultaneous rotation, but since he did not say so, present it as a nuance rather than rewriting his claim.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-15', 'BANM2', 'short_answer', 'bamg_ad_response_findings', 10, 'What shape is the advertising response function, and what is the average advertising elasticity?', '[]'::jsonb, '- The predominant response function is **concave**: advertising has diminishing returns from the very start. There is no long linear region where extra spend is free.
- Average advertising elasticity is about **0.1** — a 1% increase in spend corresponds on average to a much smaller percentage increase in sales.
- For **new products** elasticity is higher, about **0.3**.', 'Session 10 — What Decades of Ad-Response Research Found', 'Concavity is also the reason the economically optimal advertising spend is finite, which links straight to Dorfman-Steiner.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-16', 'BANM2', 'short_answer', 'bamg_ad_response_findings', 10, 'What does the research say about how often campaigns work, how fast effects appear, and how long they last?', '[]'::jsonb, '- About half of campaigns do not work at all. When they do work, the reported effect is roughly an 18% increase in unit sales.
- Impact, if any, emerges fast — under 6 months — and lasts about 1 to 2 years.
- A visible short-term effect appears to be a precondition for long-term effects: if an advertisement has no big short-term effect it probably will not have a long-term one.
- Once effective advertising is identified, the long-term impact is likely to be about twice the short-term impact.', 'Session 10 — What Decades of Ad-Response Research Found', 'The implication he draws from the third point: do not defend a weak campaign with vague brand-building claims. The implication of the fourth: short-run measurement understates the total value of a genuinely effective advertisement.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-17', 'BANM2', 'short_answer', 'bamg_ad_response_findings', 10, 'Give four findings about context — category, brand position, exposure count and creative — from the research summary.', '[]'::jsonb, '- Brands in growing product categories, and in categories with greater purchase frequency, show greater advertising effects.
- Smaller competitors tend to have higher advertising-to-sales ratios than market leaders.
- Optimal spending is the level that achieves 3 to 4 exposures, which connects to wear-in before wearout.
- Ad effect is greater when the advertising tries to change attitude rather than merely reinforce it, and greater when the copy strategy has recently changed. The benefits of constant change in TV advertising outweigh the risks.', 'Session 10 — What Decades of Ad-Response Research Found', 'Also on the slide: the claim that TV share of voice must exceed market share is a myth, so do not use it as a universal spending rule.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, difficulty, provenance) values
  ('bamg-s10-18', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10, 'Why does the log lift benchmark against the overall market rather than against the segment we want to target?', '[]'::jsonb, '- Because in this framework there is **no segment we decided to target**. That is the deliberate departure from STP.
- The product is chosen by evaluating every candidate against every customer and ranking on the stated objective, not by picking a tier first and designing to it.
- Segmentation enters only afterwards, and only for advertising: once a product has won, affinity segmentation asks who is actually likely to buy it.
- So "segment" is doing one job here, not two. In STP the same segmentation drives both product design and communication, which is where the confusion comes from.
- He called this the reason the framework avoids the **Tata Nano problem** — committing to an intended target up front and finding the eventual market is somebody else.', 'Session 10 — What Analytics Is Actually For', 'The Innova, Yulu and OYO examples are the same failure: the intended target was not the eventual market. The algorithm does not need to guess the target correctly because it never guesses.

> Prof: He promised a fuller Tata Nano treatment in the last session and never reached it. The argument above is what he actually gave, in Session 9 — do not invent case detail about the Nano itself.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, correct_answer = excluded.correct_answer, explanation = excluded.explanation;

commit;
