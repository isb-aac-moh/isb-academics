-- MKTG: 15 questions adapted from a 20-question numerical practice sheet.
--
-- Source: "Marketing Management -- 20 Numerical Practice Questions (with Solutions)", covering
-- the formulas from Sessions 3, 5, 6, 7, 8 and 9. Every one of the 20 worked solutions was
-- recomputed and all 20 check out, so the filtering below is about overlap, not correctness.
--
-- Five of the 20 are duplicates of questions we already have, and are not imported:
--
--   Q3  base unit margin from revenue/variable-cost aggregates -- mktg-kk1 is the same
--       computation on the real Kookaburra numbers.
--   Q8  BECR from two unit contributions plus the decision rule -- mktg-bc1, bc3 and bc4.
--   Q10 BECR backed out of an additional-profit target -- mktg-bc6 is the same relationship.
--   Q14 infinite-horizon CLV net of acquisition cost -- mktg-clv2.
--   Q18 golden rule of pricing, margin then optimal price -- mktg-pe1 and pe2 between them.
--
-- Q1 (a four-part margin / markup / profit build) and Q5 (break-even on a price cut) are each
-- covered piece by piece -- mm1, mm7, be8 and be5 -- so they add no computation we do not already
-- ask for. Q5's ratio shortcut (break-even volume / old volume = old contribution / new
-- contribution) is genuinely useful and was not written down anywhere, so it goes into the
-- explanation on mktg-be10 rather than into a question of its own.
--
-- The remaining 15 fill real gaps. Three are worth naming because they are things our bank
-- teaches in prose but never makes a student compute:
--
--   - Sunk cost exclusion from break-even (mktg-be9). We had eight break-even questions and none
--     that put an already-spent figure in the stem.
--   - Break-even on a price *increase*, and the volume loss it can absorb (mktg-be10). All our
--     existing work runs in the cut direction, where volume has to rise.
--   - Implied elasticity read backwards out of an observed price (mktg-pe11). Every existing
--     golden-rule question runs elasticity to price; none runs price to elasticity.
--
-- Figures are converted to house style (Rs, full numbers rather than lakh/crore). The Unilever
-- question keeps dollars because the case does. No existing row is touched.

begin;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values

-- ---------------------------------------------------------------------------
-- margin_markup (Session 3)
-- ---------------------------------------------------------------------------

('mktg-mm9', 'MKTG', 'formula', 'margin_markup', 3,
 $q$A distributor prices every product at a 60% markup on cost. One SKU retails at Rs 480. What is the unit variable cost, and what percentage margin does the distributor earn?$q$,
 $c$["Rs 300 and 37.5%", "Rs 300 and 60%", "Rs 288 and 40%", "Rs 192 and 60%"]$c$::jsonb,
 $a$Rs 300 and 37.5%$a$, 'Session 3',
 $e$Markup is defined on cost, and cost is the number you do not have yet — so divide rather than subtract. Cost = price / (1 + markup) = 480 / 1.60 = **Rs 300**. Contribution = 480 − 300 = Rs 180, so margin = 180 / 480 = **37.5%**.

The conversion is worth memorising in both directions: margin = markup / (1 + markup) = 0.60 / 1.60 = 37.5%, and markup = margin / (1 − margin).

Rs 288 comes from taking 60% *off the price*, which silently redefines the markup as a percentage of price. Reporting 60% as the margin is the same confusion pointed the other way.$e$,
 $h$The 60% is a percentage of a number you have not worked out yet. Which operation gets you to it?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- break_even (Session 3)
-- ---------------------------------------------------------------------------

('mktg-be9', 'MKTG', 'formula', 'break_even', 3,
 $q$A cafe chain is evaluating a cold-brew kiosk. Brewing equipment costs Rs 120,000 and a one-time municipal licence Rs 60,000. It has already spent Rs 40,000 on consumer research. Each cold brew sells for Rs 75 and costs Rs 45 to make. What is the break-even volume?$q$,
 $c$["6,000 cold brews", "7,333 cold brews", "4,000 cold brews", "2,400 cold brews"]$c$::jsonb,
 $a$6,000 cold brews$a$, 'Session 3',
 $e$Project fixed cost = 120,000 + 60,000 = **Rs 180,000**. Unit contribution = 75 − 45 = **Rs 30**. Break-even volume = 180,000 / 30 = **6,000 cold brews**.

The Rs 40,000 of research is a sunk cost. It has already left the bank whether or not the kiosk opens, so it cannot be affected by the decision and does not belong in it. Sweeping it in raises break-even to 7,333 and can push a project that is genuinely worth doing below the forecast — which is how sunk costs destroy value twice.

The 2,400 trap divides by price instead of contribution, which assumes every rupee of revenue is profit.$e$,
 $h$One of the three cost figures does not change with the decision. Should it be in it?$h$, 2, 'authored'),

('mktg-be10', 'MKTG', 'formula', 'break_even', 3,
 $q$A haircare brand sells 40,000 units at Rs 200 with a unit variable cost of Rs 150, and is considering raising the price to Rs 230. What is the largest percentage volume loss it can absorb and be no worse off?$q$,
 $c$["37.5%", "62.5%", "60%", "15%"]$c$::jsonb,
 $a$37.5%$a$, 'Session 3',
 $e$The ratio does all the work: break-even volume / old volume = old contribution / new contribution. Old contribution = 200 − 150 = Rs 50; new contribution = 230 − 150 = Rs 80; ratio = 50 / 80 = **0.625**. Break-even volume = 40,000 × 0.625 = **25,000 units**, so the brand can shed 15,000 units — a **37.5%** loss.

Learn the formula once and read the direction off the ratio. A price *cut* shrinks the new contribution, so the ratio exceeds 1 and volume must rise. A price *increase* grows it, so the ratio falls below 1 and volume is allowed to fall. Same arithmetic, opposite sign, and the direction is what people get wrong far more often than the division.

62.5% is the break-even volume as a share of today's, not the loss that leaves.$e$,
 $h$Work out break-even volume as a fraction of today's, then ask what the gap is.$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- becr_cannibalization (Session 3)
-- ---------------------------------------------------------------------------

('mktg-bc9', 'MKTG', 'formula', 'becr_cannibalization', 3,
 $q$A durables firm launches a mid-tier model expected to sell 120,000 units in Year 1 at a unit contribution of Rs 150. The cannibalisation rate is 0.25, and the premium model it takes sales from earns Rs 200 per unit. What is the net incremental contribution from the launch?$q$,
 $c$["Rs 12,000,000", "Rs 18,000,000", "Rs 13,500,000", "Rs 6,000,000"]$c$::jsonb,
 $a$Rs 12,000,000$a$, 'Session 3',
 $e$Both sides of the ledger. Gross contribution = 120,000 × 150 = **Rs 18,000,000**. Units cannibalised = 120,000 × 0.25 = **30,000**. Contribution lost = 30,000 × 200 = **Rs 6,000,000**. Net = 18,000,000 − 6,000,000 = **Rs 12,000,000**.

Two unit contributions appear in one calculation and they are not interchangeable. The new units carry Rs 150 because that is what the firm now earns; the cannibalised units carry Rs 200 because that is what it stops earning. Valuing the lost units at Rs 150 gives Rs 13,500,000 and assumes a switching customer was worth the same either way — which is the exact assumption the launch is meant to test.

Rs 18,000,000 is the gross figure with the cannibalisation ignored altogether.$e$,
 $h$Two unit contributions are given. Which one attaches to the units the firm loses?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- case_unilever_brazil (Session 5)
-- ---------------------------------------------------------------------------

('mktg-ul8', 'MKTG', 'formula', 'case_unilever_brazil', 5,
 $q$Unilever Brazil evaluates a brand extension priced at $1.65/kg, built from the New Process formula ($1.00), plastic packaging ($0.10), below-the-line promotion ($0.05), distributors ($0.05) and $0.05 of incremental cost to extend an existing brand. Existing Unilever brands earn $0.50/kg. Expected cannibalisation is 0.85. What should Unilever do?$q$,
 $c$["Do not launch as configured — BECR is 0.80 and the expected 0.85 exceeds it", "Launch — BECR is 1.25, comfortably above the expected 0.85", "Do not launch — the new margin of $0.40 is below the existing $0.50, so any cannibalisation destroys value", "Launch — BECR is 0.80, and any rate below 1.0 means the extension pays for itself"]$c$::jsonb,
 $a$Do not launch as configured — BECR is 0.80 and the expected 0.85 exceeds it$a$, 'Unilever Brazil case',
 $e$Build the margin before touching the decision rule. Total cost = 1.00 + 0.10 + 0.05 + 0.05 + 0.05 = **$1.25/kg**, so the new unit margin = 1.65 − 1.25 = **$0.40/kg**. BECR = new margin / old margin = 0.40 / 0.50 = **0.80**. Expected cannibalisation of 0.85 sits above the threshold, so this configuration destroys value.

The third option is the trap worth understanding, because it is nearly right. A lower new margin does not mean *any* cannibalisation is fatal — this extension can afford to take 80% of its volume out of Omo and still break even. What kills it is that 85% exceeds the 80% it can carry.

The fix is a lever on either side of the inequality. Raise the new margin (cheaper formula, lower incremental cost, higher relative price) and the threshold rises; source volume from competitors rather than from Omo and the actual rate falls.$e$,
 $h$Add up the mix costs first. The decision rule needs a margin you do not have yet.$h$, 3, 'authored'),

-- ---------------------------------------------------------------------------
-- clv (Session 6)
-- ---------------------------------------------------------------------------

('mktg-clv11', 'MKTG', 'formula', 'clv', 6,
 $q$A gym earns Rs 1,200 of contribution per member per year and spends Rs 3,000 to acquire a member. Over a five-year horizon with no attrition and no discounting, what is CLV net of acquisition cost?$q$,
 $c$["Rs 3,000", "Rs 6,000", "Rs 1,800", "−Rs 9,000"]$c$::jsonb,
 $a$Rs 3,000$a$, 'Session 6',
 $e$Strip out retention and discounting and CLV is arithmetic. Total contribution = 1,200 × 5 = **Rs 6,000**. Net of acquisition cost = 6,000 − 3,000 = **Rs 3,000**.

This is the version to build every other CLV question out from, because it shows what the other terms do. Retention shrinks each future year's *expected* contribution. Discounting shrinks each future year's *value*. Acquisition cost is deducted once, at the start — deducting it every year is where −Rs 9,000 comes from, and it is a surprisingly common slip once the table gets long.

Rs 1,800 charges the first year to acquisition and counts only four paying years.$e$,
 $h$How many times is the acquisition cost paid?$h$, 1, 'authored'),

('mktg-clv12', 'MKTG', 'formula', 'clv', 6,
 $q$A gym earns Rs 1,200 of contribution per member per year. The probability of losing a member in any year is 0.25, the horizon is four years, there is no discounting, and acquisition cost is Rs 2,000. What is CLV net of acquisition cost?$q$,
 $c$["Rs 461", "Rs 2,800", "Rs 1,600", "Rs 2,461"]$c$::jsonb,
 $a$Rs 461$a$, 'Session 6',
 $e$Expected contribution in year t = m × r^t, with r = 0.75:

- Year 1: 1,200 × 0.75 = Rs 900.00
- Year 2: 1,200 × 0.75² = Rs 675.00
- Year 3: 1,200 × 0.75³ = Rs 506.25
- Year 4: 1,200 × 0.75⁴ = Rs 379.69

Total **Rs 2,460.94**, less Rs 2,000 of acquisition cost = **Rs 460.94**.

Rs 1,600 applies the retention rate once and then multiplies by four years. Retention compounds, because a member has to survive *every* year up to t and not merely the first — that is what the exponent is doing, and it is why a business at 75% retention is worth so much less than four years of margin suggests. Rs 2,800 ignores attrition altogether.$e$,
 $h$Does the retention rate apply once, or once per year survived?$h$, 2, 'authored'),

('mktg-clv13', 'MKTG', 'formula', 'clv', 6,
 $q$A streaming service earns Rs 3,000 per subscriber per year, retains 80% of subscribers annually, discounts at 10%, and spends Rs 5,000 to acquire a subscriber. On a three-year horizon, what is CLV net of acquisition cost?$q$,
 $c$["−Rs 77", "Rs 856", "Rs 2,461", "Rs 4,923"]$c$::jsonb,
 $a$−Rs 77$a$, 'Session 6',
 $e$Apply Σ m·r^t / (1 + d)^t — retention first, then discounting:

- Year 1: 3,000 × 0.8 = 2,400, discounted 2,400 / 1.10 = Rs 2,181.82
- Year 2: 3,000 × 0.64 = 1,920, discounted 1,920 / 1.21 = Rs 1,586.78
- Year 3: 3,000 × 0.512 = 1,536, discounted 1,536 / 1.331 = Rs 1,154.02

Total **Rs 4,922.61**, less Rs 5,000 = **−Rs 77.39**.

The number is a hair below zero, and that is not the same finding as "do not acquire". Extend the horizon to four years or lift retention by a point and the sign flips. When an answer lands this close to the line the right move is to say the decision turns on assumptions and run the sensitivity, rather than to report a verdict the arithmetic cannot support.

Rs 856 drops the discounting and Rs 2,461 drops the retention. Two separate things shrink a future year, and each trap keeps only one of them.$e$,
 $h$Two factors shrink each year. Apply both, then look at how close the total sits to zero.$h$, 3, 'authored'),

('mktg-clv14', 'MKTG', 'formula', 'clv', 6,
 $q$A private bank earns Rs 2,400 of contribution per customer per year, discounts at 12% and spends Rs 6,000 to acquire a customer, with no margin at signup. Over an infinite horizon, what is the minimum annual retention rate at which acquisition breaks even?$q$,
 $c$["80%", "72%", "71.4%", "85%"]$c$::jsonb,
 $a$80%$a$, 'Session 6',
 $e$CLV = m × r / (1 + d − r) − AC. Set it to zero and solve for r:

    2,400r = 6,000 × (1.12 − r)
    2,400r = 6,720 − 6,000r
    8,400r = 6,720
    r = **0.80**

So retention must hold at 80%, or equivalently churn must not exceed 20%.

Break-even retention and maximum acquisition spend are the same equation solved for different unknowns, and it is worth seeing both. Run it forwards at r = 0.85 and gross CLV = 2,400 × 0.85 / 0.27 = Rs 7,555.56 — the ceiling on what the bank should ever pay for a customer.

72% comes from dropping the r in the numerator. Even the first year's margin is conditional on the customer staying. 71.4% drops the discounting.$e$,
 $h$Set CLV to zero and solve for r. Keep the r on top of the fraction.$h$, 3, 'authored'),

-- ---------------------------------------------------------------------------
-- evc (Session 7)
-- ---------------------------------------------------------------------------

('mktg-evc8', 'MKTG', 'formula', 'evc', 7,
 $q$A household currently buys 2 cans of bottled water a day at Rs 40 a can, 30 days a month. A home purifier delivers benefits the household values at Rs 400 a month (no delivery hassle) and Rs 250 a month (taste and health assurance), but imposes Rs 120 of electricity and Rs 180 of filter replacement a month. What is the monthly EVC?$q$,
 $c$["Rs 2,750", "Rs 3,050", "Rs 2,400", "Rs 350"]$c$::jsonb,
 $a$Rs 2,750$a$, 'Session 7',
 $e$EVC = reference value + net differentiation value, and each half is built separately.

- Reference value = what the next-best alternative costs in equivalent use = 2 × 40 × 30 = **Rs 2,400/month**
- Net differentiation value = (400 + 250) − (120 + 180) = 650 − 300 = **Rs 350/month**
- EVC = 2,400 + 350 = **Rs 2,750/month**

The negatives count as much as the positives. Rs 3,050 adds the two benefits and never nets the costs the purifier introduces, and a one-sided benefit list is the standard route to an EVC number no customer will pay.

Note also that reference value is a *consumption* calculation, not a price: what matters is what the household spends to get the same job done over the same period, which is why the daily rate and the month both appear.$e$,
 $h$Build the two halves separately. The purifier introduces costs as well as benefits.$h$, 2, 'authored'),

('mktg-evc9', 'MKTG', 'formula', 'evc', 7,
 $q$A product has an EVC of Rs 2,750 a month to the target household and a variable cost of Rs 900 a month. What is the feasible price range, and what price splits the surplus equally between firm and customer?$q$,
 $c$["Rs 900 to Rs 2,750, split at Rs 1,825", "Rs 900 to Rs 2,750, split at Rs 1,375", "Rs 900 to Rs 2,750, split at Rs 1,850", "Rs 0 to Rs 2,750, split at Rs 1,375"]$c$::jsonb,
 $a$Rs 900 to Rs 2,750, split at Rs 1,825$a$, 'Session 7',
 $e$The two ends of the range come from different parties. Variable cost is the **floor** — below it the firm loses money on every unit sold. EVC is the **ceiling** — above it the customer is better off with the alternative.

Total surplus = 2,750 − 900 = **Rs 1,850**. An equal split gives each side Rs 925, so the price is 900 + 925 = **Rs 1,825**.

Rs 1,375 halves the EVC rather than the surplus, which quietly hands the customer the whole of the firm's cost advantage. Rs 1,850 reports the surplus itself as though it were the price.

Where the price actually lands inside the range is a bargaining-power question, not an arithmetic one. The calculation establishes the range and nothing more — an equal split is a convention for exam answers, not a prediction.$e$,
 $h$Split the gap between the floor and the ceiling, not the ceiling itself.$h$, 2, 'authored'),

('mktg-evc10', 'MKTG', 'formula', 'evc', 7,
 $q$An industrial-coatings supplier wants Rs 3,200 per drum. The customer's next-best alternative costs Rs 2,900 per drum in equivalent use. The new coating saves Rs 600 of labour but adds Rs 250 of curing-time cost. Is the price defensible on EVC grounds?$q$,
 $c$["Yes — EVC is Rs 3,250, though the price leaves the customer only Rs 50", "Yes — EVC is Rs 3,500, so the price leaves the customer Rs 300", "No — EVC is Rs 2,550, so Rs 3,200 sits above it", "No — EVC is Rs 350, the value the coating adds over the alternative"]$c$::jsonb,
 $a$Yes — EVC is Rs 3,250, though the price leaves the customer only Rs 50$a$, 'Session 7',
 $e$EVC = reference value + net differentiation value = 2,900 + (600 − 250) = **Rs 3,250**. At Rs 3,200 the price sits Rs 50 below EVC, so the arithmetic supports it.

Read the same relationship backwards to see what the sales argument has to carry: for a Rs 3,200 price to sit at or below EVC, net differentiation must be at least 3,200 − 2,900 = **Rs 300**. The coating delivers Rs 350, so there is Rs 50 of headroom and no more.

Defensible on paper is not the same as saleable. The supplier is capturing Rs 300 of the Rs 350 it creates, and to agree the buyer has to accept the supplier's arithmetic about the buyer's own labour and curing costs. Buyers routinely do not, which is why EVC-based prices usually land well below the ceiling.

Rs 3,500 counts the labour saving and forgets the cost the coating introduces.$e$,
 $h$The alternative's cost is the starting point, not the answer. What gets added to it?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- pricing_elasticity (Session 8)
-- ---------------------------------------------------------------------------

('mktg-pe11', 'MKTG', 'formula', 'pricing_elasticity', 8,
 $q$A snack brand prices at Rs 150 against a marginal cost of Rs 90. A new conjoint study then estimates true price elasticity of demand at 4.0. What elasticity does the current price behave as though it faced, and what should the brand do?$q$,
 $c$["Implied elasticity 2.5 — cut the price to Rs 120", "Implied elasticity 2.5 — raise the price to Rs 180", "Implied elasticity 1.5 — cut the price to Rs 120", "Implied elasticity 4.0 — hold the price at Rs 150"]$c$::jsonb,
 $a$Implied elasticity 2.5 — cut the price to Rs 120$a$, 'Session 8',
 $e$The golden rule (p − mc)/p = 1/ε runs in both directions, and this question uses each once.

**Backwards, as a diagnostic.** The current price already produces a margin of (150 − 90)/150 = 40%. That is an observed fact rather than a target, and 0.40 = 1/ε implies **ε = 2.5** — the price behaves as though customers were only moderately price-sensitive.

**Forwards, as a prescription.** With the measured ε = 4.0, target margin = 1/4 = 25%, so p* = 90 / (1 − 0.25) = **Rs 120**.

The gap between implied 2.5 and measured 4.0 is the finding: the brand has been charging a margin its demand curve does not support. Marginal cost never moves — it is Rs 90 throughout. The margin falls only because the price falls, taking unit contribution from Rs 60 to Rs 30.

Implied 1.5 comes from inverting the *markup* (60/90 = 66.7%). The golden rule is written on margin.$e$,
 $h$Run the rule backwards from today's price first, then forwards from the measured elasticity.$h$, 3, 'authored'),

-- ---------------------------------------------------------------------------
-- grp_advertising (Session 9)
-- ---------------------------------------------------------------------------

('mktg-grp8', 'MKTG', 'formula', 'grp_advertising', 9,
 $q$A brand with Rs 500,000,000 of annual revenue, a 40% margin and an advertising elasticity of 0.05 is shown a media plan delivering 35% reach at an average frequency of 4, priced at Rs 200,000 per GRP. What does the plan cost, against what the golden rule of advertising justifies?$q$,
 $c$["Rs 28,000,000 against Rs 10,000,000", "Rs 28,000,000 against Rs 25,000,000", "Rs 7,000,000 against Rs 10,000,000", "Rs 28,000,000 against Rs 200,000,000"]$c$::jsonb,
 $a$Rs 28,000,000 against Rs 10,000,000$a$, 'Session 9',
 $e$Two independent calculations that are meant to be compared.

**What the plan costs.** GRP = reach × frequency = 35 × 4 = **140 GRPs**. Cost = 140 × 200,000 = **Rs 28,000,000**.

**What the rule justifies.** A / (p × Q) = % margin × advertising elasticity = 0.40 × 0.05 = 0.02, so A = 500,000,000 × 0.02 = **Rs 10,000,000**, or 2% of revenue.

The gap is the answer to the exam question. The plan costs nearly three times what the elasticity justifies, and exactly two things can be true: the plan is too big, or the 0.05 elasticity estimate is too low. Which you believe decides whether you cut the media buy or go back and re-measure, and the arithmetic will not settle it for you.

Rs 25,000,000 drops the margin term, which is the term that stops a low-margin business from spending like a high-margin one.$e$,
 $h$Cost the plan and size the budget separately, then put them side by side.$h$, 3, 'authored'),

-- ---------------------------------------------------------------------------
-- parfitt_collins (Session 9)
-- ---------------------------------------------------------------------------

('mktg-pc8', 'MKTG', 'formula', 'parfitt_collins', 9,
 $q$A brand needs 6% market share to break even. Research shows 25% of aware consumers try the product and 35% of triers become repeat buyers. Its media plan delivers 35% reach. What share can the plan deliver at best, and what awareness does break-even require?$q$,
 $c$["3.06% at best, against 68.6% awareness required", "8.75% at best, against 68.6% awareness required", "3.06% at best, against 10% awareness required", "35% at best, against 68.6% awareness required"]$c$::jsonb,
 $a$3.06% at best, against 68.6% awareness required$a$, 'Session 9',
 $e$Share = % aware × % try × % repeat, so run it once in each direction.

**Best case from the plan.** Awareness cannot exceed reach, so even if every consumer the plan touches becomes aware, awareness caps at 35%: share = 0.35 × 0.25 × 0.35 = **3.06%**.

**What break-even needs.** 0.06 = A × 0.25 × 0.35 = A × 0.0875, so A = **68.6%**.

The plan is short by a factor of two, and the diagnosis follows straight from the structure. Either buy far more reach, or lower the awareness hurdle by lifting trial (sampling, introductory pricing) or repeat (fix the product). The last of those is the one media money cannot buy, and it is usually the one that matters.

The 10% trap adds the trial and repeat rates instead of multiplying them. The rates apply in sequence to a base that shrinks at every step, which is precisely why the required awareness comes out so high.$e$,
 $h$Awareness cannot be larger than reach. Start there, then solve the same equation for what is needed.$h$, 3, 'authored');

commit;
