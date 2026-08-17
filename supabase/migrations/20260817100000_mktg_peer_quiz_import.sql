-- MKTG: 25 questions adapted from a batchmate's Term 3 practice quiz.
--
-- Source: https://isb-mktg-end-term-t3-quiz.netlify.app (90 questions, Prof Abhinav Uppal's
-- section). Every numeric answer in that bank was recomputed and all 16 check out, and the
-- distractors are built from named arithmetic traps rather than filler. But it is a different
-- section, so the 90 were filtered three ways before anything was imported:
--
--   1. ~40 duplicate questions we already have. Several are near-identical -- their price-cut
--      question uses the same Rs 200 -> Rs 180 at Rs 120 variable cost that mktg-be4 does, and
--      their Parfitt-Collins uses the same 4% share / 25% trial setup as mktg-pc5. Their
--      "healthy CTR, poor TCR", "7 Ms Mission", "conjoint = experimental x preferences",
--      "value for the organisation vs the customer" and "where acquisition spend becomes
--      retention spend" questions are effectively word-for-word matches for ours.
--
--   2. 12 questions test material that appears nowhere in Prof Shubhranshu Singh's decks or in
--      anything derived from them: Aaker's five brand-personality dimensions, the
--      Direct/Pull/Push/Brokered channel-function grid, customer equity as four value types,
--      the McKinsey 1%-price-lever chart, Parkay margarine, white space, beach-head segments,
--      Maslow, contact-efficiency math, and "attitudinal" as a segmentation base separate from
--      behavioural. Held back pending a check against the actual S5/S7 slides -- if they are
--      there, that is a real gap in our bank; if not, importing them would have students
--      revising another section's syllabus.
--
--   3. Two are wrong for us. Their Q1 keys the AMA definition ("creating, communicating,
--      delivering and *exchanging* offerings"), which contradicts the "creating, communicating,
--      delivering and *extracting* value" framing that mktg-vp2 and the S1 note are built on.
--      Their segment-discovery question lists "cluster and factor analysis" in that order,
--      which is backwards -- factor reduces the variables, then cluster groups the people, and
--      mktg-stp7 already has it right.
--
-- What remains is 25 questions, renumbered onto our topic slugs and rewritten into house style
-- (Rs figures rather than lakh/crore, our explanation format, hints added). No existing row is
-- touched. Topics go from 8 questions to 9-11; ROUND_SIZE is 8, so a round still fills and now
-- draws from a slightly wider pool.

begin;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values

-- ---------------------------------------------------------------------------
-- value_proposition (Session 1)
-- ---------------------------------------------------------------------------

('mktg-vp9', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$A new packaged snack takes 25% share in its first month, then settles at 7% within a quarter. Awareness and distribution both stay high throughout. What is the most likely diagnosis?$q$,
 $c$["The product failed to deliver the benefit buyers actually valued", "Distribution became too thin to sustain availability for repeat buyers", "Price was set above what buyers in the category will pay", "Advertising weight decayed too fast to hold top-of-mind awareness"]$c$::jsonb,
 $a$The product failed to deliver the benefit buyers actually valued$a$, 'Session 1',
 $e$Split the number into **trial** and **repeat**. Marketing bought the trial — 25% of the category tried it once. Repeat collapsed, and repeat is bought by the product itself.

The stem rules out the other three on purpose. Thin distribution or weak awareness would have suppressed *trial* as well, and the 25% opening month says neither did. A price problem shows up the same way. This is "make what you can sell, not sell what you can make" read backwards: a mix good enough to get people to buy once cannot save a product that does not work.$e$,
 $h$Which of the two numbers is bought by marketing, and which is bought by the product?$h$, 2, 'authored'),

('mktg-vp10', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$A direct-to-consumer eyewear brand opens a handful of tactile flagship stores while keeping most of its sales online. In building the value proposition, what are the stores?$q$,
 $c$["A point of differentiation, built through Place", "A point of parity the category now requires", "A reason to believe supporting the price claim", "An augmentation of the core product benefit"]$c$::jsonb,
 $a$A point of differentiation, built through Place$a$, 'Session 1',
 $e$A **point of differentiation** is something buyers want that rivals do not offer, and it can be built through any of the four Ps — not just Product. Here the difference is *where and how* the product is experienced, which is Place doing the differentiating.

The parity option is the trap: a POP is something rivals already offer, and physical stores are precisely what other DTC players do not have. Calling it an augmentation confuses the levels-of-a-product framework (delivery, warranty, credit) with the value proposition framework.$e$,
 $h$Which P is the store, and does anyone else in the category have one?$h$, 2, 'authored'),

('mktg-vp11', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$A firm lists everything it does well and everything customers say they want, then builds its pitch on the overlap. What step has it skipped?$q$,
 $c$["Excluding the things competitors already do well", "Quantifying the economic value of each benefit it delivers", "Segmenting the customer base before aggregating what customers want", "Testing whether the overlap can be communicated credibly"]$c$::jsonb,
 $a$Excluding the things competitors already do well$a$, 'Session 1',
 $e$The value proposition is a **three-circle** construction: what customers want, minus what we do well, minus **what competitors also do well**. Stop at two circles and the pitch rests on points of parity, which stop you losing but never make anyone choose you.

This is the same customer-orientation-plus-competitive-advantage pair from the definition of marketing. A firm that only looks at itself and its customers has described a nice company that loses.$e$,
 $h$Two circles were used. How many does the framework have?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- stp_positioning (Session 2)
-- ---------------------------------------------------------------------------

('mktg-stp9', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$Tata Nano was designed for two-wheeler families buying their first car, but was largely bought as a second car by urban households. What is the central lesson?$q$,
 $c$["Positioning on lowest price undermined the aspiration of the intended segment", "The frame of reference was drawn too broadly across the passenger-car category", "Distribution reached the wrong retail formats to serve the intended buyers", "The core benefit was not credible to buyers at the announced price point"]$c$::jsonb,
 $a$Positioning on lowest price undermined the aspiration of the intended segment$a$, 'Session 2',
 $e$"The cheapest car" is a claim about the *buyer* as much as the car. A family moving off a scooter is making a status purchase, and the position told their neighbours they had bought the least they could get away with. The people who could afford to ignore that signal — households buying a runabout second car — bought it instead.

The lesson is procedural, not just diagnostic: track the **target segment against actual buyers**, because the gap between them is where a positioning failure shows up first.$e$,
 $h$Ask what the position said about the person buying, not about the product.$h$, 2, 'authored'),

('mktg-stp10', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$A premium audio brand repeatedly refuses to launch a budget sub-brand despite pressure from its dealers. In positioning terms, what is this?$q$,
 $c$["Recognition that choosing a segment means declining others", "A defence of the points of parity the category demands", "An attempt to avoid double marginalisation in its channel", "Protection of the reason to believe behind its claims"]$c$::jsonb,
 $a$Recognition that choosing a segment means declining others$a$, 'Session 2',
 $e$Positioning forces a choice. Deciding to serve one segment is simultaneously deciding **not** to serve others, and a brand that refuses to make that second half of the decision ends up meaning nothing in particular to anyone.

Double marginalisation is the distractor worth naming: it is a channel-pricing problem about stacked markups, and it has nothing to do with which segment you serve. Dealer pressure is exactly the force that makes this decision hard, which is why it is the example.$e$,
 $h$What is the brand giving up by saying no, and what would it give up by saying yes?$h$, 2, 'authored'),

('mktg-stp11', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$A heritage denim brand launches tailored formalwear aimed at affluent men who dress traditionally and shop at specialist menswear stores. The launch underperforms. What is the most likely diagnosis?$q$,
 $c$["The segment was attractive but the brand had no credibility with it", "The range carried too few points of parity with established formalwear", "The frame of reference was set against denim rather than formalwear", "The price point sat above the segment's willingness to pay"]$c$::jsonb,
 $a$The segment was attractive but the brand had no credibility with it$a$, 'Session 2',
 $e$Targeting requires two tests, and a segment has to pass both: **attractiveness** (large enough, growing, strong need, reachable) and **fit** with our own competitive strength (are we credible, can we deliver profitably, is it already well served). This segment was attractive. The firm was the wrong seller.

A jeans name carries meanings — casual, young, mass — that a buyer shopping tailored menswear specialists is specifically not looking for. Nothing about the product or the price fixes that, which is why fit is a separate test rather than a footnote to attractiveness.$e$,
 $h$Two tests. The segment passed one of them.$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- margin_markup (Session 3)
-- ---------------------------------------------------------------------------

('mktg-mm8', 'MKTG', 'case_fact', 'margin_markup', 3,
 $q$A manufacturer's new small-pack SKU improves its own annual margin per customer, but delivers the retailer far less annual margin per customer than the existing large pack. What is the most likely consequence?$q$,
 $c$["Retailers resist stocking and pushing the new pack", "Customers trade down and total category revenue contracts", "The manufacturer's unit margin turns negative at scale", "Cannibalisation rises above the SKU's break-even threshold"]$c$::jsonb,
 $a$Retailers resist stocking and pushing the new pack$a$, 'Session 3',
 $e$Margin analysis is run **through the whole channel**, not just at your own line, precisely so you can predict how partners will behave. A retailer earning less per customer than before has no reason to give the pack shelf space or push it, whatever it does for you.

The usual fix is rebalancing the wholesale price so the retailer's margin per customer holds up — which costs the manufacturer part of the gain, and is the real trade-off the analysis surfaces. Note that shelf space is the scarce resource here, so "less margin per customer" is the number that matters, not margin per unit.$e$,
 $h$Work out who has to agree to stock it, and what the change does to their economics.$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- break_even (Session 3)
-- ---------------------------------------------------------------------------

('mktg-be8', 'MKTG', 'formula', 'break_even', 3,
 $q$A launch is priced at Rs 1,800 with a variable cost of Rs 1,100 and fixed costs of Rs 28,000,000. At a forecast volume of 50,000 units, what is profit before any cannibalisation effect?$q$,
 $c$["Rs 7,000,000", "Rs 3,500,000", "Rs 12,000,000", "Rs 62,000,000"]$c$::jsonb,
 $a$Rs 7,000,000$a$, 'Session 3',
 $e$Build the P&L in the order the framework does. Unit contribution = 1,800 − 1,100 = **Rs 700**. Total contribution = 700 × 50,000 = **Rs 35,000,000**. Profit = 35,000,000 − 28,000,000 = **Rs 7,000,000**.

The Rs 62,000,000 trap subtracts fixed cost from *revenue* (90,000,000 − 28,000,000) and never deducts variable cost at all. Rs 3,500,000 halves the contribution. Getting the order right — contribution first, fixed cost last — is what stops both.$e$,
 $h$Unit contribution, then total contribution, then subtract fixed cost.$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- becr_cannibalization (Session 3)
-- ---------------------------------------------------------------------------

('mktg-bc8', 'MKTG', 'formula', 'becr_cannibalization', 3,
 $q$An existing product generates Rs 120,000,000 of revenue and Rs 72,000,000 of total variable cost on 80,000 units. A new launch sells 60,000 units at a 30% cannibalisation rate. What does cannibalisation cost?$q$,
 $c$["Rs 10,800,000", "Rs 3,600,000", "Rs 7,200,000", "Rs 14,400,000"]$c$::jsonb,
 $a$Rs 10,800,000$a$, 'Session 3',
 $e$Two steps, and the first one is the one people skip. Base unit contribution = (120,000,000 − 72,000,000) / 80,000 = **Rs 600**. Cost of cannibalisation = new units × cannibalisation rate × base unit contribution = 60,000 × 0.30 × 600 = **Rs 10,800,000**.

The Rs 14,400,000 trap applies the rate to the *base* product's 80,000 units. The cannibalisation rate is defined on the new product's volume — it answers "of the units the new product sells, what share came out of the old one?" — so 60,000 is the number it multiplies.$e$,
 $h$You are not given the base unit contribution. Derive it before anything else.$h$, 3, 'authored'),

-- ---------------------------------------------------------------------------
-- five_cs_customer (Session 4)
-- ---------------------------------------------------------------------------

('mktg-5c9', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$A business school adds alumni to its recruiting events, opens website sign-ups for campus visits, and follows up with every visitor within 48 hours. In funnel terms, what is this programme mainly doing?$q$,
 $c$["Adding influence points at the information-search and evaluation stages", "Broadening the frame of reference against which applicants judge the school", "Repositioning the programme to appeal to a new segment", "Shifting spend from paid media towards owned channels"]$c$::jsonb,
 $a$Adding influence points at the information-search and evaluation stages$a$, 'Session 4',
 $e$Each action inserts the school into a stage where the prospect is **already active**. Alumni widen the reach of information search; sign-ups catch someone mid-evaluation; the 48-hour follow-up acts while the lead is still warm rather than letting go after the visit.

Nothing here changes who the school is for or what it claims to be, which rules out repositioning and the frame of reference. The general move is to map the decision process first, then ask at which stages you currently have no presence.$e$,
 $h$Ask what the prospect is doing when each of these three things reaches them.$h$, 2, 'authored'),

('mktg-5c10', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$Assessing how regulation, technology and macroeconomic conditions will shape a market falls under which of the 5 Cs?$q$,
 $c$["Context", "Collaborators", "Company", "Competitors"]$c$::jsonb,
 $a$Context$a$, 'Session 4',
 $e$**Context** is the external environment nobody in the market controls: regulation, the economy, culture and technology. It is the C most often skipped, and the one that decides whether the other four analyses are still valid in two years.

Collaborators is the adjacent trap. That C covers partners who can help you *and* whether they capture enough value to want to — a question about specific firms, not about the conditions everyone operates under.$e$,
 $h$Which C is about forces no player in the market can control?$h$, 1, 'authored'),

('mktg-5c11', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$In a 5 Cs analysis, a firm notes that its principal asset is a proprietary dataset and the models trained on it. Which heading is that?$q$,
 $c$["Company, since this describes its core competence", "Context, since data availability is an environmental factor", "Collaborators, since data partners supply the inputs", "Customer, since the data describes customer behaviour"]$c$::jsonb,
 $a$Company, since this describes its core competence$a$, 'Session 4',
 $e$**Company** covers core competence, strengths, weaknesses and goals — what the firm itself owns and can do. A proprietary dataset is an asset on the balance sheet in all but name, and the models are the competence built on it.

Filing a technology asset under Context is the tempting error. Context is the *external* environment — how the market is changing around you. The distinction is ownership: general advances in machine learning are Context; your own data and your own models are Company.$e$,
 $h$Does the firm own this, or does it merely operate in it?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- branding_basics (Session 5)
-- ---------------------------------------------------------------------------

('mktg-br9', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$If managing a brand means managing the associations attached to it in customers' minds, what should a proposed sponsorship be judged on first?$q$,
 $c$["Whether it links the brand to the meanings the firm wants to own", "The reach and frequency it delivers for every rupee committed", "Its ability to generate short-term trial among current non-users", "The share of voice it buys relative to direct competitors"]$c$::jsonb,
 $a$Whether it links the brand to the meanings the firm wants to own$a$, 'Session 5',
 $e$A brand is a set of associations, so a sponsorship is an act of attaching something to it. The first question is what gets attached — the meanings, the audience's existing feelings about the property, the company the brand now keeps.

Reach, frequency and share of voice all measure **exposure**, not what the exposure means. They are the right metrics for a campaign whose content is already decided, and the wrong first question for a decision that changes what the brand stands for. A cheap sponsorship that attaches the wrong meaning is not a bargain.$e$,
 $h$Exposure is one question. What is the other one, and which comes first here?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- clv (Session 6)
-- ---------------------------------------------------------------------------

('mktg-clv8', 'MKTG', 'case_fact', 'clv', 6,
 $q$In the finite-horizon CLV formula, what does the term cr(t) refer to?$q$,
 $c$["The cumulative retention factor surviving up to period t", "The rate at which customers churn out during period t", "The contribution ratio applied to the margin earned in period t", "The discount factor converting period t margin to present value"]$c$::jsonb,
 $a$The cumulative retention factor surviving up to period t$a$, 'Session 6',
 $e$cr(t) is **cumulative** retention — the probability the customer is still there in period t. With a constant annual retention rate r, it is simply r to the power t, which is why the infinite-horizon version collapses into a single geometric term.

Discounting is handled separately by the 1/(1+d)^t factor. Two things shrink a future year's contribution and they are not the same thing: the customer may have left (retention), and a rupee then is worth less than a rupee now (discounting). Collapsing them is the standard error.$e$,
 $h$Two separate factors shrink a future year. This is the one that is not about money.$h$, 2, 'authored'),

('mktg-clv9', 'MKTG', 'case_fact', 'clv', 6,
 $q$A subscription business raises monthly retention from 95% to 97% while its monthly discount rate stays at 1%. What happens to CLV?$q$,
 $c$["It jumps by roughly half again, because the denominator (1 + d − r) shrinks sharply", "It rises roughly in proportion to the two-percentage-point improvement", "It moves little, because monthly discounting dominates retention at this frequency", "It cannot be determined without first knowing the acquisition cost"]$c$::jsonb,
 $a$It jumps by roughly half again, because the denominator (1 + d − r) shrinks sharply$a$, 'Session 6',
 $e$CLV = m·r / (1 + d − r). The denominator goes from 1 + 0.01 − 0.95 = **0.06** to 1 + 0.01 − 0.97 = **0.04**. A third comes off a number that is already small, and it sits underneath everything: multiplying in the slightly larger r on top, CLV rises about **53%**.

This is why retention is the lever subscription businesses obsess over. The relationship is not linear, and the closer retention already is to 1 the more violent each further point becomes. Acquisition cost shifts the *level* of CLV but not this sensitivity, so it is not needed to answer.$e$,
 $h$Put both numbers into the denominator before reasoning about the size of the effect.$h$, 3, 'authored'),

('mktg-clv10', 'MKTG', 'formula', 'clv', 6,
 $q$A customer yields Rs 5,000 of contribution a year at 80% annual retention and a 10% discount rate, and contributes Rs 5,000 of margin at the moment she joins. What is the most the firm can spend to acquire her and still break even?$q$,
 $c$["Rs 18,333", "Rs 13,333", "Rs 8,333", "Rs 5,000"]$c$::jsonb,
 $a$Rs 18,333$a$, 'Session 6',
 $e$Future stream = m·r / (1 + d − r) = 5,000 × 0.8 / 0.3 = **Rs 13,333**. CLV of a not-yet-acquired customer = m₀ − AC + 13,333. Set that to zero: AC = 13,333 + 5,000 = **Rs 18,333**.

Stopping at Rs 13,333 is the trap, and it comes from forgetting m₀ — the margin the customer pays *at* acquisition, which is not discounted and not subject to retention because she is definitionally still there. Any business with a meaningful signup payment can afford to spend more than the future stream alone suggests.$e$,
 $h$Set CLV to zero and solve for AC. Do not forget the margin earned on day one.$h$, 3, 'authored'),

-- ---------------------------------------------------------------------------
-- brand_architecture (Session 6)
-- ---------------------------------------------------------------------------

('mktg-ba9', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$A premium spirits brand finds that the idea of male achievement its advertising has leaned on for decades no longer lands with younger drinkers, though the product is unchanged. What is the appropriate response?$q$,
 $c$["A repositioning that changes what the brand is understood to mean", "A horizontal extension into categories those drinkers already buy", "A vertical extension offering an accessible entry into the range", "A shift in media strategy to reach the younger cohort efficiently"]$c$::jsonb,
 $a$A repositioning that changes what the brand is understood to mean$a$, 'Session 6',
 $e$**Repositioning** changes the meaning of the brand rather than what it sells, and a shift in the surrounding culture is one of its triggers, alongside a new target market and competitor moves. The product being unchanged is the clue: nothing is wrong with the liquid, something is wrong with what it says.

New media is the tempting answer and the wrong one — it carries the same dated meaning to a new audience, more efficiently. Both extension options add products the brand does not need, and neither touches the association that has stopped working.$e$,
 $h$The product has not changed. What has?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- pricing_elasticity (Session 8)
-- ---------------------------------------------------------------------------

('mktg-pe8', 'MKTG', 'case_fact', 'pricing_elasticity', 8,
 $q$What is the central weakness of cost-plus pricing?$q$,
 $c$["The unit cost depends on a volume that the price itself determines", "It fails to recover fixed costs over the product's full life cycle", "It systematically sets prices below the direct variable cost floor", "It prevents the firm from segmenting the market on willingness to pay"]$c$::jsonb,
 $a$The unit cost depends on a volume that the price itself determines$a$, 'Session 8',
 $e$Per-unit fixed cost is F/V. To compute it you need V, but V is a function of the price you are trying to set — the logic is **circular**, and it resolves only by assuming the answer. Set a high price, forecast low volume, get a high unit cost, justify a high price.

The method also ignores the two things that actually bound a price: what the customer will pay and what competitors charge. Blocking value-based segmentation is a real consequence, but it is downstream of the circularity rather than the flaw itself.$e$,
 $h$Write out the unit cost formula and ask what you need to know before you can use it.$h$, 2, 'authored'),

('mktg-pe9', 'MKTG', 'case_fact', 'pricing_elasticity', 8,
 $q$In setting a price, where do the floor and the ceiling sit?$q$,
 $c$["Direct variable cost and the customer's maximum willingness to pay", "Fully loaded unit cost and the nearest competitor's price", "Marginal cost and the price implied by the target market share", "Average total cost and the industry's historical price band"]$c$::jsonb,
 $a$Direct variable cost and the customer's maximum willingness to pay$a$, 'Session 8',
 $e$The **floor** is direct variable cost: below it every additional sale destroys money. The **ceiling** is what the customer will pay: above it there is no sale. Everything between the two is a judgement informed by competition, positioning and the segment you are serving.

Using fully loaded cost as the floor is the common and expensive error — it rules out volume that still contributes to fixed costs, and it drags the circularity of cost-plus pricing in through the back door. Competitor price influences where you land inside the range; it does not define either boundary.$e$,
 $h$Which cost genuinely makes a sale not worth having, and what stops the sale at the top end?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- price_sensitivity (Session 8)
-- ---------------------------------------------------------------------------

('mktg-ps9', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$Petrol stations at the same junction display their prices on large boards visible from the road. Which driver of price sensitivity is this acting on?$q$,
 $c$["The ease of making direct comparisons between sellers", "The buyer's ability to carry inventory between purchases", "Inferences drawn about quality from the posted price", "The share of the cost borne by someone other than the buyer"]$c$::jsonb,
 $a$The ease of making direct comparisons between sellers$a$, 'Session 8',
 $e$Posted, standardised, side-by-side prices make substitution effortless, and effortless substitution pushes sensitivity **up** sharply. Petrol is the textbook case because the product is identical across sellers, so price is the only variable left.

Inventory does matter in this category — a driver with a full tank can wait — but the boards are not what acts on it. Read the question as "which mechanism does this specific intervention change?", not "which mechanisms are present?"$e$,
 $h$Ask what the boards change about the buyer's decision, not what else is true about petrol.$h$, 1, 'authored'),

('mktg-ps10', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$An enterprise database vendor finds customers accept annual price rises without switching, even though cheaper alternatives are available and well known to them. What is the most likely driver?$q$,
 $c$["High switching costs already sunk into the incumbent", "Weak awareness of the substitutes on offer", "Difficulty in comparing the offerings directly", "An inference that the higher price signals better quality"]$c$::jsonb,
 $a$High switching costs already sunk into the incumbent$a$, 'Session 8',
 $e$**Switching and sunk costs** — migration effort, retraining, rewritten integrations, risk of downtime — hold the customer in place regardless of what the alternatives cost. The comparison a buyer actually makes is not price against price, it is price against price plus the cost of moving.

The stem says substitutes are available *and* well known, which is there to rule out the awareness explanation. That phrasing is the whole question: read the premise before reaching for the most familiar driver.$e$,
 $h$The stem rules out one of these four explicitly. Which one, and what does that leave?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- case_air_france (Session 9)
-- ---------------------------------------------------------------------------

('mktg-af8', 'MKTG', 'case_fact', 'case_air_france', 9,
 $q$In the Air France sponsored-search analysis, how is the probability of booking for a publisher computed?$q$,
 $c$["Click-through rate multiplied by transaction conversion rate", "Net revenue divided by the total cost of the campaign", "Total bookings divided by the total cost of the campaign", "Transaction conversion rate divided by cost per click"]$c$::jsonb,
 $a$Click-through rate multiplied by transaction conversion rate$a$, 'Session 9 — Air France case',
 $e$**P(booking) = CTR × TCR**. It chains the two conditional steps: the chance an impression becomes a click, times the chance a click becomes a sale. The product is the chance an impression becomes a booking.

Net revenue over cost is **ROA**, which measures how efficiently money turned into revenue — a different question from how likely a given impression is to convert. Both matter, and the case's point is that they can disagree: a publisher can convert brilliantly and still cost too much.$e$,
 $h$Two rates in sequence. What do you do with sequential probabilities?$h$, 2, 'authored'),

('mktg-af9', 'MKTG', 'case_fact', 'case_air_france', 9,
 $q$A publisher in the Air France analysis shows a high probability of booking but also a high cost per click. What is the recommended action?$q$,
 $c$["Adjust the campaign to bring the cost of those clicks down", "Cut funding and redeploy the budget to cheaper publishers", "Increase funding, since conversion efficiency is already proven", "Rewrite the website copy to lift the conversion rate further"]$c$::jsonb,
 $a$Adjust the campaign to bring the cost of those clicks down$a$, 'Session 9 — Air France case',
 $e$This is the "excellent at generating sales, but expensive" quadrant — Google US and MSN US sat here. The conversion machinery works, so the problem is the price of the traffic: bid strategy, keyword match types, average position, negative keywords.

Cutting funding is reserved for publishers that are expensive **and** poor at converting. Rewriting website copy addresses TCR, which is already fine. The diagnostic discipline is to fix the metric that is broken, not the one you know how to fix.$e$,
 $h$One of the two numbers is good. Which lever moves the bad one?$h$, 2, 'authored'),

('mktg-af10', 'MKTG', 'formula', 'case_air_france', 9,
 $q$A search campaign generates Rs 960,000 in revenue at a total cost of Rs 160,000. What is its return on advertising spend?$q$,
 $c$["500%", "600%", "167%", "83%"]$c$::jsonb,
 $a$500%$a$, 'Session 9 — Air France case',
 $e$ROA = **net** revenue / cost = (960,000 − 160,000) / 160,000 = 800,000 / 160,000 = **500%**.

The 600% trap divides *gross* revenue by cost, which counts the money you spent as though it were money you made and overstates every publisher by exactly 100 percentage points. Since the case ranks publishers on this number, using the gross version does not just inflate the figures — it changes which publishers look worth funding.$e$,
 $h$Take the cost out of the revenue before you divide by it.$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- comms_planning (Session 9)
-- ---------------------------------------------------------------------------

('mktg-cp9', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$A life insurer's advertising shows a family coping after an unexpected death, closing on a reassuring message. In message-design terms, what is this?$q$,
 $c$["An emotional appeal using negative emotion", "An emotional appeal using positive affect", "A rational appeal built on product comparison", "A rational appeal delivered through a testimonial"]$c$::jsonb,
 $a$An emotional appeal using negative emotion$a$, 'Session 9',
 $e$Fear is the classic **negative emotional appeal**, and insurance is where it lives. The standard caveat is that it works best when moderated: too little and nobody acts, too much and the audience shuts the message out rather than the risk.

The reassuring close is what makes the appeal usable — it gives the fear somewhere to go — but it does not convert the appeal into a positive one. The emotion doing the persuading is still the one in the opening.$e$,
 $h$Which emotion is doing the persuading, and is the closing frame the same one?$h$, 2, 'authored');

commit;
