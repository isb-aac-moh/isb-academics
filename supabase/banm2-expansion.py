"""Source of truth for the BANM2 practice-bank expansion.

    python3 supabase/banm2-expansion.py > supabase/migrations/<timestamp>_banm2_expansion.sql

Brings all 27 BANM2 topics to 8 questions each, adding 148 to the 68 already live.

Format is unchanged and deliberately so: BANM2's end-term is written short answers, not MCQs, so
every row here is `short_answer` with an empty choices array and the model answer in
`correct_answer` — exactly as supabase/banm2-content.py loads them. Nothing here turns BANM2 into
Smart Practice; `has_practice` is derived from whether a course has non-short_answer questions
(fetchCourses in src/learn/lib/db.ts), so it stays false and the course stays a reading reference.

Grounding: every answer comes from the concept notes in supabase/banm2-content.py, which were
written from the professor's own decks and class transcript. Nothing is invented, and the 68
existing prompts were read first so these do not restate them.

banm2-content.py stays the source of truth for the guide prose (sessions, concepts, the original
68 questions). This file only adds questions, so the two do not overlap and neither has to be
regenerated when the other changes.
"""

import sys

from practice_lib import check_inline_math, check_markdown, check_question, json_array, sql

COURSE = "BANM2"

# (topic, session, prompt, model answer, note)
Q: list = []


def q(topic, session, prompt, answer, note=""):
    Q.append((topic, session, prompt, answer, note))


# ===========================================================================
# Session 7
# ===========================================================================

q("bamg_marketing_pods", 7,
  "Which pods do Sessions 7 to 10 sit in, and which sessions map to which pod?",
  "- Sessions 7-10 live in the **first two pods**: value creation, and value communication and delivery.\n"
  "- **Session 7** is value creation — specifying the optimal product and price.\n"
  "- **Session 8** straddles the two: affinity segmentation and the persona come out of the choice model, and the positioning statement is value communication.\n"
  "- **Sessions 9 and 10** are value communication and delivery — assessing advertising effects, and media planning.\n"
  "- Customer acquisition and customer development/retention are the other two pods and are not the scope of this end-term.",
  "Trap: the four pods are the map of the whole discipline, not of this course. Only the first two are examined here.")

q("bamg_marketing_pods", 7,
  "Give the unit of decision, horizon and style for each half of the pod table.",
  "- **Value creation / value communication**: unit of decision is a product, brand, market or channel system; horizon is longer, with choices persisting a few years; style is macro and strategic.\n"
  "- **Acquisition / development and retention**: unit of decision is an individual customer or lead; horizon is shorter and changeable quickly; style is micro, tactical and CRM-like.\n"
  "- The firms named in class were American Express and Apple for the first, Capital One, Kotak and Dell for the second.",
  "The three rows are unit of decision, horizon and style — name all three rather than only the strategic/tactical label.")

q("bamg_marketing_pods", 7,
  "Which firm did he name as the exception across all four pods, and why does that matter?",
  "- **Amazon** — strong across all four pods.\n"
  "- It matters because the pod split usually describes where a firm concentrates its analytical capability. Most firms are good at one half and weak at the other.\n"
  "- A firm strong on all four can connect a product decision to the individual-customer decisions that follow it, rather than running the two as separate functions.",
  "One name, and the point is about the split being a description of most firms rather than a law.")

q("bamg_marketing_pods", 7,
  "He described acquisition as sowing and development and retention as harvesting. What does that framing imply for how acquisition should be done?",
  "- Sophisticated acquisition is **not** \"win any sale\".\n"
  "- It starts by asking which customers and which channels bring high lifetime value, because those are what can actually be harvested later.\n"
  "- Acquiring a customer with low or negative lifetime value creates work for the retention pod with nothing at the end of it.\n"
  "- So lead scoring and lead-source scoring belong in acquisition precisely to filter for that.",
  "Prof: the metaphor is doing analytical work — what you sow determines whether there is anything to harvest.")

q("bamg_marketing_pods", 7,
  "List the activities he placed in the customer development and retention pod.",
  "- Cross-sell and recommendation systems.\n"
  "- Loyalty programmes.\n"
  "- Attrition detection.\n"
  "- Value reinforcement through communities, social media, email and satisfaction measurement.",
  "This pod is out of scope for the end-term, but the list is short enough to be worth holding in case a question asks for the full four-pod map.")

q("bamg_marketing_pods", 7,
  "Within customer acquisition, what is the difference between macro media and micro media, and what is scored?",
  "- **Macro media**: TV, radio — mass channels where exposure is known only in aggregate.\n"
  "- **Micro media**: search and display — channels where exposure can be attributed to an individual.\n"
  "- What is scored is both the **lead** (is this person worth acquiring?) and the **lead source** (is this channel bringing worthwhile people?).\n"
  "- Scoring the source is what stops a channel that delivers cheap but low-value leads from looking successful on cost per acquisition alone.",
  "The macro/micro split here is the same distinction Session 10 returns to as the micro and macro extremes of advertising assessment.")

q("bamg_decision_frame", 7,
  "State the monopoly pricing formula he used as the standing example of theory-based decision making, and its weakness.",
  "- Optimal Price = MC x PED / (PED + 1).\n"
  "- The appeal: a manager gets an actionable answer out of transparent, stated assumptions.\n"
  "- The weakness: a valid theory may not exist for the situation, or its assumptions may not fit. A monopoly formula does not mechanically solve a duopoly where a rival reacts to your price.",
  "State the formula and then the assumption that breaks — the example is chosen because the assumption is so visible.")

q("bamg_decision_frame", 7,
  "Why does \"our model is more accurate\" fail as a pitch to a CMO, and what works instead?",
  "- It threatens a CMO with real domain expertise: the claim is that the model knows their market better than they do.\n"
  "- What works is that the process makes the decision **explicit, disciplined and defensible**.\n"
  "- Senior people may distrust the number itself and still value the rigour behind it — the argument is about the quality of the reasoning, not about beating their judgement.",
  "Prof: this is a consulting point, and he made it as one. The pitch is about process, not accuracy.")

q("bamg_decision_frame", 7,
  "What is meant by structural modelling as one of the three distinguishing emphases, and what is it contrasted with?",
  "- The f in R = f(A) should **encode why an action produces an outcome**, rather than being an arbitrary flexible function fitted to data.\n"
  "- It is contrasted with a black-box model that maps features to outcomes with no account of the mechanism.\n"
  "- The practical payoff is that a structural model can be asked about actions never previously observed, because the mechanism still applies where historical data does not exist.",
  "This emphasis is what Session 7's whole choice-model apparatus is an instance of.")

q("bamg_decision_frame", 7,
  "Give the two approaches to establishing causal impact and say what distinguishes them.",
  "- **Causal inference with observational data (CIOD)** — the analyst does not control the assignment of the action and has to argue the comparison is fair from data that already exists.\n"
  "- **Design and analysis of business experiments (DABE)** — the analyst controls assignment, which is what Session 9's control-group designs are.\n"
  "- The distinction is who decides which customers got which action: the world, or the analyst.",
  "Both are named in Session 7 and Session 9 is entirely the second of them.")

q("bamg_decision_frame", 7,
  "Why is tunnel vision a weakness of evolved best practices, and who raised it?",
  "- Students raised it in class.\n"
  "- A firm that only repeats what has worked never considers a genuinely different action, so the set of actions it evaluates is bounded by its own history.\n"
  "- Evolution requires trial and error, so building the playbook is slow and costly, and it cannot react to a sudden shock — his example was Apple-style launch scarcity, playful in normal times and tone-deaf under COVID.",
  "The COVID example is about reacting to a shock; tunnel vision is the separate point about never searching widely in the first place.")

q("bamg_blackbox_failures", 7,
  "What was his concrete version of the black-box setup, and what would the X and Y columns contain?",
  "- A **shelf census in a Big Bazaar**: record every product already on the shelf.\n"
  "- Y column: observed market share.\n"
  "- X columns: price, capacity, cleanability and brand — the product's attribute levels.\n"
  "- Fit a flexible model to that, then plug in the new product's attribute vector to forecast its share.",
  "Worth being able to describe the setup before criticising it — the three failures only make sense against a specific procedure.")

q("bamg_blackbox_failures", 7,
  "Explain the degrees-of-freedom failure in the black-box approach.",
  "- Many categories have **few products** (rows) but **many attributes and levels** (columns).\n"
  "- There is not enough data to estimate a rich share surface over that many dimensions.\n"
  "- The model will fit the handful of observed products well and generalise badly, because almost every combination of levels is unobserved.",
  "This one is about the shape of the data — rows against columns — not about confounding.")

q("bamg_blackbox_failures", 7,
  "Give his example of a genuinely new attribute with no history, and explain why structural modelling handles it.",
  "- **Fresh juice in a container that turns blue when the juice has spoiled.**\n"
  "- No product has ever had this feature, so historical shelf data contains no variation in it and nothing can be learned about its effect.\n"
  "- Structural modelling handles it because market research can **describe the hypothetical feature to a respondent** and elicit how much they value it, producing a preference parameter where no historical data could exist.",
  "This is the failure that structural modelling solves most directly, rather than merely mitigating.")

q("bamg_blackbox_failures", 7,
  "Why is observed market share described as confounded?",
  "- Share is **not generated by the feature vector alone**.\n"
  "- Advertising, distribution and every other marketing action are baked into the observed share.\n"
  "- So a model fitted to it recovers the combined effect of features and everything correlated with them, not the pure effect of the product on share.\n"
  "- A product might have high share because it has better shelf placement, and the model would attribute that to its capacity.",
  "Trap: state this as one of three failures, not as the whole answer. Answering only \"the data are confounded\" gets a third of the marks.")

q("bamg_blackbox_failures", 7,
  "What are the two ground truths structural modelling respects, and why do they matter?",
  "- A **40% predicted share means 40% of the customer mass buys** — share is built out of individual purchase decisions, so it cannot come out above 100% or behave incoherently.\n"
  "- A **customer buys because the product beats the alternatives available to them** — choice is relative to a competitive set, not an absolute property of the product.\n"
  "- A share regression respects neither: it can predict any number, and it has no representation of the alternatives being chosen against.",
  "These two are what make the structural forecast interpretable rather than merely fitted.")

q("bamg_blackbox_failures", 7,
  "Set out the chain structural modelling uses to build share, in order.",
  "- Each consumer has **preference parameters**.\n"
  "- Each candidate product produces a **utility** for that consumer.\n"
  "- Utility produces a **choice probability**.\n"
  "- Probabilities **aggregate to share**.\n"
  "- The black-box regression jumps straight from features to share and skips every step in the middle.",
  "The order is the answer. Being able to recite it is what makes the criticism of the black box concrete.")

q("bamg_product_optim_pipeline", 7,
  "Write the three profit expressions in the decomposition and say what each represents.",
  "- Sales volume(P) = persons in the future market x s(P).\n"
  "- Profit margin(P) = Price(P) − Cost(P).\n"
  "- Profit(P) = persons in the future market x s(P) x [Price(P) − Cost(P)].\n"
  "- The first turns a share into a volume, the second is the per-unit economics, and the third multiplies them.",
  "Getting the decomposition down is what makes it obvious why market size cancels out of the ranking.")

q("bamg_product_optim_pipeline", 7,
  "Of price, cost and share, which is the genuinely hard unknown and why?",
  "- **Share, s(P).**\n"
  "- Price is a decision variable — the firm sets it.\n"
  "- Cost comes from the production team's cost data.\n"
  "- Share requires predicting how individual customers will choose the candidate against the incumbents, which is why most of the session is spent on choice models.",
  "The three inputs are not equally difficult, and the session's structure follows from which one is hard.")

q("bamg_product_optim_pipeline", 7,
  "What has to happen to the preference ratings when the candidate set uses levels that were never measured?",
  "- The ratings for the new levels have to be **interpolated or extrapolated** from the measured ones.\n"
  "- Nothing forces the candidate set to use only the three levels market research asked about — with 7 levels each of price, capacity and cleanability there are already 343 own-brand candidates.\n"
  "- Extrapolation beyond the measured range is the riskier of the two, since there is no evidence about how preference behaves out there.",
  "The candidate set is a modelling choice, and expanding it has a data cost as well as a computational one.")

q("bamg_product_optim_pipeline", 7,
  "When does complete enumeration stop being feasible, and what replaces it?",
  "- With more attributes and more levels each, the candidate count grows multiplicatively and enumeration becomes infeasible.\n"
  "- Treat it as a **continuous optimisation problem** and use standard optimisation tools — for example Excel Solver.\n"
  "- The managerial formulation is unchanged; only the search method changes.",
  "Trap: the scope is the managerial formulation, not the optimiser. Do not spend revision time on Solver mechanics.")

q("bamg_product_optim_pipeline", 7,
  "Why must s(P) be computed against the incumbent set rather than on its own?",
  "- A customer buys a product because it **beats the alternatives available to them**, so a share figure is meaningless without saying what it was competing against.\n"
  "- The same candidate has different shares in different competitive sets.\n"
  "- This is one of the two ground truths structural modelling respects and the share regression does not.",
  "Connects the optimisation pipeline back to why the black-box approach fails.")

q("bamg_compensatory_utility", 7,
  "Where do attribute importances come from, and what constraint do they satisfy?",
  "- Market research supplies them per customer, derived from conjoint part-worths.\n"
  "- The **range of the part-worths within an attribute** becomes that attribute's importance.\n"
  "- They **sum to 100** across attributes for each customer.\n"
  "- For customer 1 the part-worth ranges are 4.5 on price, 27.5 on capacity, 6.0 on cleanability and 12.0 on brand, giving importances of 9, 55, 12 and 24.",
  "The sum-to-100 constraint is what makes importances comparable across attributes for one customer.")

q("bamg_compensatory_utility", 7,
  "Compute customer 1's utility for product 2 and say why it loses to product 1.",
  "- u2 = 9(3) + 55(7) + 12(2) + 24(5) = 27 + 385 + 24 + 120 = **556**.\n"
  "- u1 = 646, so product 1 wins for this customer.\n"
  "- The two are level on capacity, which carries the largest importance at 55. Product 1's advantage comes from cleanability (rating 7 against 2) and brand (7 against 5), which together outweigh product 2's better price rating.",
  "Worth doing the arithmetic attribute by attribute — the interesting part is which attribute produced the gap.")

q("bamg_compensatory_utility", 7,
  "What does the compensatory model predict about a product with one very weak attribute?",
  "- Weakness on one attribute can be **paid for** by strength on another, so no single bad attribute automatically kills the product.\n"
  "- Whether it survives depends on the importance weight on the weak attribute: a low rating on something weighted 9 barely matters, while the same rating on something weighted 55 is very hard to compensate for.\n"
  "- This is exactly what the non-compensatory rules deny.",
  "The answer is conditional on the importance weight, not a flat yes or no.")

q("bamg_compensatory_utility", 7,
  "Give the rescaling formula used to put part-worths on a common band, and say what breaks without it.",
  "- Rescaled = TargetMin + (TargetMax − TargetMin) x (r − r_min) / (r_max − r_min).\n"
  "- Without common anchoring, the ratings within each attribute are not pinned to the same minimum and maximum.\n"
  "- Then the importances are not comparable across attributes and the importance-weighted sum is meaningless — you would be adding quantities measured on different scales.",
  "The anchoring is what makes the weighted sum a legitimate operation at all.")

q("bamg_noncompensatory_rules", 7,
  "Walk through the lexicographic rule for customer 1 and say which product it selects.",
  "- Take the most important attribute: **capacity**, importance 55.\n"
  "- Pick whichever product is best on it. Products 1 and 2 both rate 7 on capacity, so there is a tie.\n"
  "- Move to the next most important attribute, brand at 24: product 1 rates 7 against product 2's 5.\n"
  "- **Product 1** is selected.",
  "The tie-breaking step is the part worth rehearsing — the rule is only interesting when the top attribute does not decide it outright.")

q("bamg_noncompensatory_rules", 7,
  "Walk through elimination by aspects for customer 1 with the deck's cutoff, and say which product it selects.",
  "- Set a minimum mental cutoff on each attribute — the deck uses **1.5**.\n"
  "- Start with the most important attribute and throw out every product that misses the cutoff, then move to the next attribute.\n"
  "- **Product 2** is selected for customer 1.\n"
  "- Note this differs from the lexicographic answer on the same customer and the same data, which is the point of showing both.",
  "Two non-compensatory rules, one customer, two different answers — the choice of rule is itself a modelling decision.")

q("bamg_noncompensatory_rules", 7,
  "Why does the name elimination by aspects describe the mechanics?",
  "- Once a product is eliminated for missing a threshold on an important attribute, being excellent on a less important one **cannot bring it back**.\n"
  "- Elimination is permanent and it proceeds attribute by attribute, in importance order.\n"
  "- That irreversibility is exactly what makes the rule non-compensatory.",
  "The name is the definition — being able to explain it is a compact way of showing what non-compensatory means.")

q("bamg_noncompensatory_rules", 7,
  "Which non-compensatory rule does he say is overwhelmingly the more used in practice?",
  "- **Elimination by aspects.**\n"
  "- Lexicographic choice is the simpler rule to state but is much less commonly applied.",
  "A one-line fact, but a plausible short-answer prompt on its own.")

q("bamg_noncompensatory_rules", 7,
  "Why does he argue B2B purchasing tends toward compensatory behaviour even when individuals hold hard cutoffs?",
  "- The reasoning is **organisational**, not psychological.\n"
  "- B2B decisions involve several stakeholders, explicit trade-off matrices and discussion.\n"
  "- Individuals may each hold hard cutoffs, but aggregating several people's views through a formal process produces something effectively compensatory.\n"
  "- Consumers, deciding alone and quickly, are more likely to use fast heuristics.",
  "The mechanism is aggregation across people, which is why it does not contradict individuals using cutoffs.")

q("bamg_logit_choice", 7,
  "Contrast customer 1 and customer 9 and explain what the comparison motivates.",
  "- Customer 1's top utility is **646** against a next-best of 556 — a wide gap.\n"
  "- Customer 9's are **480 and 492** — nearly level.\n"
  "- A small measurement error would flip customer 9's predicted choice and would not flip customer 1's.\n"
  "- The deterministic max-utility rule treats both as certain, which motivates predicting **probabilities** instead.",
  "The two customers are chosen to make the point that a single predicted choice hides how confident the prediction is.")

q("bamg_logit_choice", 7,
  "Compute c using his rule of thumb for the mug data and show the range calculation.",
  "- c = 100 / (12 x range of utilities over the product space).\n"
  "- Best possible utility is 7 x 100 = **700** (top rating on every attribute, importances summing to 100).\n"
  "- Worst possible is 1 x 100 = **100**.\n"
  "- Range = 600, so c = 100 / (12 x 600) = 100 / 7200 = **0.0139**.",
  "The range comes from the rating scale and the importance sum, not from the utilities actually observed.")

q("bamg_logit_choice", 7,
  "What happens to the predicted probabilities as c moves, using his figures for customer 1?",
  "- c = 0.001: split is **.39 / .36 / .26** — nearly flat, reflecting almost no confidence in the utilities.\n"
  "- c = 0.02: **.86 / .14 / .00**.\n"
  "- c = 0.04: **.97 / .03 / .00** — approaching the deterministic answer.\n"
  "- The same utilities move a long way, which is why c has to be chosen deliberately rather than left at a default.",
  "Trap: c is not a percentage accuracy. c = 1 does not mean the research is 100% right — it is a relative confidence or dispersion parameter.")

q("bamg_logit_choice", 7,
  "The deterministic counts gave shares of 0.20 / 0.40 / 0.40 and the logit probabilities gave 0.22 / 0.38 / 0.40. What should be read into how close they are?",
  "- Not much. They are close **here** and will not be in general.\n"
  "- Averaging the probabilities is the correct procedure; averaging the max-choice indicators is not, and the two agreeing on one dataset does not validate the wrong one.\n"
  "- The deterministic count discards information about how marginal each customer's choice was, which is precisely what matters when utilities are close.",
  "Trap: average the probabilities, not the max-choice indicators.")

q("bamg_profit_per_prospect", 7,
  "Give the cost table for the mug example in full.",
  "- **Capacity**: 12 oz costs 1.00, 20 oz costs 2.60, 32 oz costs 2.80.\n"
  "- **Cleanability**: Difficult costs 1.00, Fair costs 2.20, Easy costs 3.00.\n"
  "- All figures in dollars. Costs attach to these two attributes only — price and brand carry no production cost in this example.",
  "Which attributes carry cost is itself part of the setup; brand and price do not appear in the cost function.")

q("bamg_profit_per_prospect", 7,
  "Compute expected profit per prospect for candidate 6 and say why it wins.",
  "- Spec: 30 dollars, 20 oz, Easy. Share **0.155**.\n"
  "- Cost = 2.60 (20 oz) + 3.00 (Easy) = **5.60**. Margin = 30.00 − 5.60 = **24.40**.\n"
  "- Profit per prospect = 0.155 x 24.40 = **3.780**.\n"
  "- It wins on the margin side, not the share side: it has one of the lower shares of the 27 but a margin large enough to dominate.",
  "The winner has a low share, which is the whole point of ranking on profit rather than on share.")

q("bamg_profit_per_prospect", 7,
  "Compute candidate 24's expected profit per prospect and explain the sign.",
  "- Spec: 5 dollars, 20 oz, Easy. Share **0.503**, the highest of the 27.\n"
  "- Cost = 2.60 + 3.00 = **5.60**. Margin = 5.00 − 5.60 = **minus 0.60**.\n"
  "- Profit per prospect = 0.503 x (−0.60) = **minus 0.302**.\n"
  "- The price of 5 dollars sits below the cost of 5.60, so it loses money on every unit sold. Winning the most customers makes the loss larger, not smaller.",
  "A negative margin turns share into a liability — the more you sell, the worse it gets.")

q("bamg_profit_per_prospect", 7,
  "What is the conceptual order the profit-per-prospect calculation depends on?",
  "- Preference parameters, then utilities, then choice probabilities, then share, then economics.\n"
  "- Each step is the input to the next, and the economics only enter at the very end.\n"
  "- The black-box regression jumps straight from features to share and skips everything in the middle, which is why it cannot be repaired by adding a cost column.",
  "Trap: this ordering is the summary of the whole session — worth being able to state without prompting.")

q("bamg_profit_per_prospect", 7,
  "Why is expected profit per prospect the right scaled objective rather than total profit?",
  "- Total profit = persons in the future market x s(P) x [Price(P) − Cost(P)].\n"
  "- **Market size is the same for every candidate**, so it is a common factor and cannot change the ranking.\n"
  "- Dividing it out leaves s(P) x [Price(P) − Cost(P)], which is expected profit per person or per prospect.\n"
  "- It also means a market-size forecast is not needed to choose the product, only to value it.",
  "The practical benefit is that the hardest number to forecast turns out not to be needed for the decision.")

q("bamg_profit_per_prospect", 7,
  "Candidate 21 is 5 dollars, 12 oz, Easy with share 0.400. Compute its profit per prospect and compare it with candidate 24.",
  "- Cost = 1.00 (12 oz) + 3.00 (Easy) = **4.00**. Margin = 5.00 − 4.00 = **1.00**.\n"
  "- Profit per prospect = 0.400 x 1.00 = **0.400**.\n"
  "- Candidate 24 has a higher share (0.503) but a negative margin, so it returns minus 0.302.\n"
  "- Dropping from 20 oz to 12 oz costs 0.103 of share and saves 1.60 of cost, which is what flips the candidate from loss-making to profitable.",
  "A clean illustration that a share sacrifice can be worth taking when it buys enough margin.")

q("bamg_objective_taste", 7,
  "Why does he call the choice of objective a matter of taste?",
  "- It follows from the firm's **objectives, ownership, financial position, growth model and managerial DNA** — not from the data.\n"
  "- The algorithm ranks candidates but cannot say what \"best\" means.\n"
  "- The metrics genuinely conflict, so there is no analytical resolution: picking one quietly on the client's behalf is a judgement smuggled in as a calculation.",
  "Taste here means it is a legitimate choice the client owns, not that it is arbitrary.")

q("bamg_objective_taste", 7,
  "Which candidate maximises profit, which maximises share, and why does that make the objective unavoidable?",
  "- **Candidate 6** maximises profit at 3.780 per prospect.\n"
  "- **Candidate 24** maximises share at 0.503, and loses 0.302 per prospect.\n"
  "- The two are different products, so no single recommendation satisfies both.\n"
  "- There is no reading of the data that makes one of them \"the best product\" — the objective has to be stated before the question has an answer.",
  "The conflict in this dataset is stark by design, which is why it is the example he uses.")

q("bamg_objective_taste", 7,
  "Why might a firm rationally choose market share as the objective despite low or negative margins?",
  "- To **buy scale now** at low or negative margin, then monetise it later or weaken rivals in the meantime.\n"
  "- The class illustrations were blitzscaling — Jio, Uber in China, OpenAI.\n"
  "- It presumes access to capital and a belief that scale is defensible once achieved; without either, it is just losing money.",
  "The objective is rational conditional on the growth model and the funding, which is what makes it a taste question.")

q("bamg_objective_taste", 7,
  "Why would a strategic acquirer favour margin, and why would a family business favour low cost?",
  "- A **strategic acquirer** already has reach and distribution, so it wants a high-margin product to push through the channel it owns. Volume is not its constraint.\n"
  "- A **family business** or capital-constrained firm is risk-averse and wants something cheap to make, because a low cost base limits the downside if the product fails.\n"
  "- Both are rational; they differ in what each firm already has and what it can afford to lose.",
  "The objective follows from the firm's existing assets and risk position.")

q("bamg_objective_taste", 7,
  "Why might a private-equity buyer optimise sales revenue rather than profit?",
  "- Top-line scale is itself attractive to a buyer, and a private-equity acquirer may believe it can **fix costs later**.\n"
  "- Revenue is harder to manufacture than margin, so a large top line is treated as evidence of genuine market demand.\n"
  "- The bet is that operational improvement is within the buyer's control while demand is not.",
  "The logic is about which problems the buyer believes it can solve after the acquisition.")

q("bamg_objective_taste", 7,
  "What is the consulting tactic he learned from senior partners for an unknown client objective?",
  "- Do **not bluff a single optimal recommendation**.\n"
  "- Give **conditional recommendations**: if profit is the objective choose X, if share choose Y, if revenue choose Z.\n"
  "- That exposes the assumption instead of hiding it, and it hands the client the decision that is genuinely theirs.",
  "Prof: presenting one number without its objective is where a recommendation gets challenged and falls apart.")

q("bamg_beyond_the_algorithm", 7,
  "Name the three levels of product design that go beyond the optimisation.",
  "- Translating desired benefits into **production specifications**.\n"
  "- Looking past what the customer says is important, to the **higher-level needs underneath**, and building something that addresses those.\n"
  "- **Aesthetics.**",
  "The optimisation fixes the core attributes; these three are what it does not reach.")

q("bamg_beyond_the_algorithm", 7,
  "What does a house of quality look like, and what do the cells record?",
  "- **User needs** run down the rows; **technical specifications** run across the columns.\n"
  "- Each cell records the relationship between that need and that specification: **++** strong positive, **+** positive, **−** negative, **−−** strong negative.\n"
  "- The value is that trade-offs become visible early, rather than being discovered late in engineering.",
  "QFD is the disciplined translation between what the customer wants and what engineering can build.")

q("bamg_beyond_the_algorithm", 7,
  "Give the mug QFD relationships he worked through.",
  "- \"Should not cause dribble down the front of the shirt\" relates **++** to the size and shape of the mouth opening.\n"
  "- \"Should keep liquid hot for at least an hour\" relates **++** to the insulating material and **−** to a large mouth opening.\n"
  "- \"Should be low cost\" relates **−−** to both the insulating material and the outside material.\n"
  "- Note the conflict: a large mouth opening helps one need and hurts another, which is exactly the kind of trade-off the matrix is built to surface.",
  "The dribble and heat-retention needs pull the mouth opening in opposite directions — that visible conflict is the output.")

q("bamg_beyond_the_algorithm", 7,
  "Where does the choice-and-optimisation machinery work best, and where does it start to fail?",
  "- It is strongest in the **market-driven** column, where preferences and the competitive set are stable enough to measure.\n"
  "- It weakens under **market-driving** strategy: when an innovator changes how a whole category is perceived, the fixed-preference assumption starts to fail.\n"
  "- A student raised Tesla as the example and he agreed.",
  "The method assumes preferences exist to be measured; market-driving strategy is the case where the firm changes them.")

q("bamg_beyond_the_algorithm", 7,
  "Why is a QFD matrix useful even before any engineering work begins?",
  "- It forces user needs to be written down as needs rather than as solutions.\n"
  "- It makes the relationships explicit, so a specification that damages a stated need is visible immediately rather than after a prototype.\n"
  "- It surfaces conflicts between needs — the mug's mouth opening serving one need and harming another — which are the decisions that actually require management judgement.",
  "The output is a set of visible trade-offs, which is a planning artefact rather than an engineering one.")

q("bamg_beyond_the_algorithm", 7,
  "The optimisation has chosen a product. What has it not settled?",
  "- Whether the desired benefits can actually be **turned into production specifications** — the optimisation works in attribute levels, not in engineering terms.\n"
  "- The **higher-level needs** underneath the stated attributes.\n"
  "- **Aesthetics**, which the attribute vector does not represent at all.\n"
  "- It also assumes the competitive set and preferences hold still, which market-driving strategy violates.",
  "The optimisation is enough to fix the core attributes and no more — that boundary is the point of the topic.")

# ===========================================================================
# Session 8
# ===========================================================================

q("bamg_affinity_segmentation", 8,
  "Why is affinity segmentation run for every product in the category, not just ours?",
  "- Running it only for our product describes our buyers in absolute terms.\n"
  "- Running it for competitors too is what makes it possible to say how our customers **differ** from a competitor's.\n"
  "- Difference is what the persona and the positioning statement need — a descriptor that is true of every buyer in the category carries no information.",
  "The comparison across products is what turns a description into a differentiator.")

q("bamg_affinity_segmentation", 8,
  "Which descriptors can be run through the affinity formula?",
  "- **Attribute importances.**\n"
  "- The **preference for a level times the importance of that attribute**.\n"
  "- **Demographic or behavioural variables** — income, age, sports activity, education.\n"
  "- Any customer-level variable can be used; the formula only needs a value per customer and that customer's purchase probability.",
  "The formula is agnostic about the descriptor, which is why the output table can be wide.")

q("bamg_affinity_segmentation", 8,
  "How does a binary descriptor read in the affinity output, and give the example.",
  "- For a binary descriptor the weighted mean reads directly as a **fraction**.\n"
  "- A sports mean of **.84** for product 3 buyers says roughly **84% of that buyer mass plays sport**.\n"
  "- No further transformation is needed, because averaging a 0/1 variable is already a proportion.",
  "Convenient property worth knowing — binary descriptors need no interpretation step.")

q("bamg_affinity_segmentation", 8,
  "What does the denominator in the affinity formula do, and what goes wrong without it?",
  "- The denominator is the sum of purchase probabilities across customers, and it **does the normalising**.\n"
  "- Without it the numerator is a probability-weighted total rather than a mean, and its size would depend on how many customers happen to be likely buyers.\n"
  "- This is why you never rescale the weights to sum to 1 beforehand — the formula already handles it, and rescaling would destroy the information about how much total buyer mass the product attracts.",
  "Trap: the weights are not supposed to sum to 1 across people. What sums to 1 is P1 + P2 + P3 within one customer.")

q("bamg_affinity_segmentation", 8,
  "In the worked brand-importance example, identify each quantity in the calculation.",
  "- Customer 1: brand importance 24, P3 probability .095, contributing 24 x .095 = **2.28**.\n"
  "- Customer 2: brand importance 31, P3 probability .042, contributing **1.30**.\n"
  "- Summed across all ten customers: numerator **29.95**, denominator **1.55**.\n"
  "- Weighted mean = 29.95 / 1.55 = **19.3**.",
  "The denominator of 1.55 is the total buyer mass for product 3 — well below 10, which is the point about weights not summing to 1.")

q("bamg_log_lift_persona", 8,
  "Why does he use log lift rather than raw lift?",
  "- Log lift puts over- and under-indexing on a **symmetric scale around zero**.\n"
  "- On raw lift, being twice the market average is 2.0 while being half the average is 0.5 — visually very different distances from 1.0 despite being equally distinctive.\n"
  "- Taking logs makes those two equal and opposite, which is what a heatmap needs if strong negatives are to read as clearly as strong positives.",
  "Trap: strong negative values are just as focal as strong positive ones. Near-zero is the uninteresting cell.")

q("bamg_log_lift_persona", 8,
  "Give the full log-lift readout for the mug persona.",
  "- Price importance **−0.211** — less price-sensitive than the market.\n"
  "- Capacity importance **−0.298** — much less concerned with capacity, though 20 oz is still their preferred size.\n"
  "- Cleanability **+0.293** — highly important.\n"
  "- Brand importance **−0.004** — about average, so not focal.\n"
  "- Income **+0.047** and age **+0.009** — not focal.\n"
  "- Sports activity **+0.322** and graduate education **+0.387** — strongly over-indexed.",
  "The two near-zero rows matter as much as the large ones: they are what you leave out of the persona.")

q("bamg_log_lift_persona", 8,
  "Why did the data supplier find airport stores especially important for this mug?",
  "- Airport shops have **very limited inventory space**.\n"
  "- This persona's unusually **low concern about capacity** (log lift −0.298) means a narrow range of sizes is acceptable to them.\n"
  "- So the constraint that normally makes airport retail difficult is a fit rather than a problem for this particular product.",
  "A good illustration of a focal descriptor driving a distribution decision rather than just a creative one.")

q("bamg_log_lift_persona", 8,
  "What is the two-step structure of writing the persona, and what is the constraint on the second step?",
  "- **Step 1: read out** what the log-lift table literally says, descriptor by descriptor.\n"
  "- **Step 2: extend**, using societal and cultural knowledge, into a describable person — educated, health-conscious, gym-going, busy.\n"
  "- The constraint is that the extension must be **anchored in the focal descriptors**, not attached afterwards.",
  "Trap: do not invent the extension. Every element of it should trace back to a focal descriptor.")

q("bamg_competition_views", 8,
  "For each of the three views of competition, say what data is compared.",
  "- **Consumer psychologist**: rows of the affinity output table, with descriptors put on comparable scales — whose customer personas are most similar.\n"
  "- **Economist**: columns of purchase probabilities across people — who are substitutes, in that the same customers get won or lost.\n"
  "- **Brand manager**: brand preference values only — among our buyers, which other brand is liked second most.",
  "Three definitions, three different slices of the same output table.")

q("bamg_competition_views", 8,
  "Which products do the three views identify in the mug data?",
  "- Consumer psychologist: **product 1**.\n"
  "- Economist: **product 1** again.\n"
  "- Brand manager: **brand A**, since P3 buyers rate C 5.699, A 4.338 and B 1.632 — C is our own brand, so A is the second-most-liked.\n"
  "- Two views agreeing does not mean they always will; the definitions can point at different products.",
  "The numbers matter: 5.699 / 4.338 / 1.632 is what makes A rather than B the brand-manager answer.")

q("bamg_competition_views", 8,
  "Why does the brand manager's view ignore product attributes entirely?",
  "- On that view, **product attributes can be changed over time** while the brand is the more persistent identity.\n"
  "- So brand preference is treated as the durable measure of rivalry and attributes as transient.\n"
  "- He is explicit that this is a perspective you may or may not agree with — keep it labelled as the brand manager's view, not universal truth.",
  "Prof: the labelling matters. It is a defensible perspective, not an established fact.")

q("bamg_competition_views", 8,
  "Explain the asymmetry of competition in the mug data with the numbers.",
  "- Our buyers rate brand C most and brand A second (5.699 / 4.338 / 1.632).\n"
  "- But brand A's **own** buyers rate A 6.374, B 3.450 and C 2.730 — we barely register for them.\n"
  "- So A is a serious competitor to us while we are a minor one to A. Competition does not have to be mutual.",
  "A student called brand A well protected, which he liked — a small brand may worry about the leader far more than the leader worries about it.")

q("bamg_competition_views", 8,
  "Why does a qualitative case instruction to \"analyse the competition\" become a problem?",
  "- The word competition is never defined, so the analysis can drift to whatever the analyst had in mind.\n"
  "- The affinity and choice data force **three separate operational definitions**, and they can point at different products.\n"
  "- Making the definition explicit is itself part of the value of the analysis, independent of which product it names.",
  "This is one of the two examples he uses in Session 10 for analytics forcing rigour rather than just producing a number.")

q("bamg_competition_views", 8,
  "How would the economist's view be computed in practice?",
  "- Compare **columns of purchase probabilities across people**.\n"
  "- Two products are close substitutes if the same customers assign meaningful probability to both — winning one customer means losing them from the other.\n"
  "- The test is about correlation of demand across the customer base, not about how similar the products or their buyers look.",
  "Substitution is a statement about whose customers move, which is why it uses the probability columns.")

q("bamg_positioning_statement", 8,
  "Give the positioning statement template and identify what each slot needs.",
  "- \"Brand X is better at **[claim or benefit]** relative to **[competitive frame]** because it **[supporting evidence]**.\"\n"
  "- The claim comes from the attribute where our contribution is highest relative to the competitor's.\n"
  "- The competitive frame comes from the three views of competition — you must have named a competitor.\n"
  "- The supporting evidence is what makes the claim credible rather than asserted.",
  "Three slots, and two of them require analysis done earlier in the session.")

q("bamg_positioning_statement", 8,
  "Write out the slide's example and say what makes each slot work.",
  "- \"Rolaids is better at **curing heartburn within 20 minutes**, relative to **Tums**, because it **contains a new ingredient**.\"\n"
  "- The claim is specific and testable — 20 minutes, not \"fast relief\".\n"
  "- The frame names one competitor rather than the whole category.\n"
  "- The evidence gives a reason to believe the claim rather than repeating it.",
  "Specificity in the claim slot is what separates a positioning statement from a slogan.")

q("bamg_positioning_statement", 8,
  "Give the formula for an attribute's utility contribution and say how it is used to choose the claim.",
  "- Contribution of attribute a = **Importance_a x Rating(Level_a(P))**.\n"
  "- Compute it for our target customers and for the chosen competitor.\n"
  "- Pick the attribute where **our contribution is highest relative to the competitor's** — not simply where ours is highest.",
  "It is the relative comparison that identifies a differentiator; an absolute maximum only identifies what our buyers like.")

q("bamg_positioning_statement", 8,
  "Describe the short loop he runs operationally to pick the claim.",
  "- Rank attributes by importance for our buyers.\n"
  "- Start at the top and ask whether we are actually **better than the competitor** on it.\n"
  "- If not, move down the ranking and ask again.\n"
  "- For our mug, cleanability comes first because it has the highest importance among these buyers, and the candidate is Easy to clean — so it is the natural claim to examine.",
  "The loop combines importance and superiority in the right order: importance sets the search order, superiority is the test.")

q("bamg_positioning_statement", 8,
  "Why is importance alone not enough to select a positioning claim?",
  "- **Importance without relative superiority is not differentiation.**\n"
  "- Claiming to be good at something the whole category is good at gives the customer no reason to switch.\n"
  "- The claim has to beat the competitive frame you named, which is why the competitor must be chosen before the claim.",
  "Trap: do not just pick the attribute our buyers care most about — that is the most common error on this topic.")

q("bamg_positioning_statement", 8,
  "What two analytical inputs does an analytically-built positioning statement require, and where does each come from?",
  "- **Who the competitor is** — from the three operational views of competition, applied to the affinity and choice data.\n"
  "- **Which strength to emphasise** — from comparing per-attribute utility contributions between our buyers and the competitor's.\n"
  "- Both are outputs of Session 8's earlier machinery, which is why positioning sits at the end of the session rather than the start.",
  "The statement is the last step of a chain, not a standalone creative exercise.")

# ===========================================================================
# Session 9
# ===========================================================================

q("bamg_ad_brief_hierarchy", 9,
  "What are the two halves the value-communication decisions split into?",
  "- **First**: developmental research, pilot creation and pre-testing — what the message is, how it translates into creatives for different media and audiences, which formats and channels are in play, and preliminary evaluation of short-term effects in a controlled setting.\n"
  "- **Second**: field rollout, evaluation and media mix optimisation.\n"
  "- Session 9 is largely the first half; Session 10 is the second.",
  "The split also explains why Session 9's metrics are proxies and Session 10's are sales.")

q("bamg_ad_brief_hierarchy", 9,
  "Who owns each of the four steps from brief to evaluation?",
  "1. **Internal** — the product or consulting team writes the advertising brief: persona plus positioning.\n"
  "2. **Agency** — the advertising agency turns the brief into print, audio and video creatives.\n"
  "3. **Joint** — internal team and agency together choose outlets and placements.\n"
  "4. **Internal** — the product or marketing team evaluates effectiveness.",
  "Steps 1 and 4 are both internal, and step 4 being internal is the governance point.")

q("bamg_ad_brief_hierarchy", 9,
  "State the governance warning precisely, including the line he is drawing.",
  "- **Never let the advertising agency evaluate its own work**, because the agency is incentivised to show success.\n"
  "- The line is **external agency versus internal firm** — not internal product team versus internal marketing team.\n"
  "- Either internal team may do the evaluation; what matters is that the party being judged is not the judge.",
  "Prof: he was explicit about which boundary this is, because the obvious misreading is that marketing cannot evaluate its own campaign.")

q("bamg_ad_brief_hierarchy", 9,
  "How was each of the four preliminary metrics measured in class?",
  "- **Attention** — skip rates; eye tracking for non-skippable display and print.\n"
  "- **Recall** — prompted \"which brand did you see?\" surveys.\n"
  "- **Persuasion** — attitude scales, recommendation-likelihood or NPS-style proxies.\n"
  "- **Behaviour** — purchase, click, redemption.",
  "The measurement method is a plausible short-answer prompt on its own, separate from the ordering.")

q("bamg_ad_brief_hierarchy", 9,
  "Why is behaviour usually impractical in a short controlled pilot, and what follows?",
  "- Effects are **delayed and hard to attribute**. A Toyota advertisement may influence a purchase months later, after family discussion, with exposure online and purchase offline.\n"
  "- So preliminary work leans on the earlier proxies — attention, recall, persuasion.\n"
  "- Behaviour becomes central at field rollout, which is where Session 10 picks up.",
  "Behaviour is the real target and the hardest to observe in the setting where you most want it.")

q("bamg_ad_brief_hierarchy", 9,
  "What is preliminary evaluation actually for, in terms of the number of options?",
  "- After creative and outlet design there may be **twenty or thirty execution combinations**.\n"
  "- Preliminary evaluation cuts them to **three or five** before the money goes into the field.\n"
  "- Its job is elimination under controlled conditions, not final measurement.",
  "Framing it as a filter explains why cheaper proxy metrics are acceptable at this stage.")

q("bamg_observational_vs_causal", 9,
  "Why is the causal ideal impossible to observe directly?",
  "- The ideal compares the response of customers under A1 with the response of **those same customers** under A2, under similar conditions.\n"
  "- Nobody can be observed in both states at once — a customer either saw the advertisement or did not.\n"
  "- Every design in the session is therefore an **approximation** of that ideal, and the design question is which approximation is defensible.",
  "This is why the session is a sequence of designs rather than a single correct method.")

q("bamg_observational_vs_causal", 9,
  "Define treatment, treatment group and treated customers.",
  "- The **treatment** is the marketing action whose effect is being evaluated.\n"
  "- The **treatment group**, treated group or treated customers are the customers subjected to it.\n"
  "- The terms are interchangeable; the vocabulary comes from experimental design and is used throughout the session.",
  "Simple terminology question, but the words are used without definition in every subsequent design.")

q("bamg_observational_vs_causal", 9,
  "What is the simplest approximation to the causal ideal, and what is it called?",
  "- Take **one group under A1**, change the action on them to A2, and compare the two responses.\n"
  "- This is the **before-after design**.\n"
  "- It approximates the ideal by using the same people at two different times, rather than different people at the same time.",
  "The approximation swaps the impossible comparison for a temporal one, which is where its validity threats come from.")

q("bamg_observational_vs_causal", 9,
  "Why can an observational comparison not settle a causal question?",
  "- It compares the response of customers under A1 with the response of **different** customers under A2.\n"
  "- Any difference can be the action, **or** can be pre-existing differences between the two groups.\n"
  "- Nothing in the data distinguishes the two explanations, so the comparison cannot identify the effect on its own.",
  "The problem is that two explanations fit equally well, not that the measurement is imprecise.")

q("bamg_observational_vs_causal", 9,
  "Name the two approaches to causal assessment and say which one Session 9 is about.",
  "- **Causal inference with observational data (CIOD)**.\n"
  "- **Design and analysis of business experiments (DABE)**.\n"
  "- Session 9's control-group and time-series designs are DABE — the analyst controls who gets the treatment.",
  "Both were named back in Session 7 as part of what distinguishes marketing analytics.")

q("bamg_observational_vs_causal", 9,
  "Why does the after-only design look observational, and what rescues it?",
  "- It compares **two different groups at one point in time**, which is exactly the shape of an observational comparison.\n"
  "- What rescues it is that assignment was **randomised** and the groups are large, so the omitted pre-measures would have been equivalent and would have cancelled.\n"
  "- The causal claim rests on the assignment mechanism, not on the shape of the comparison.",
  "Prof: this framing is his, and it is why he says after-only carries a much heavier sample-size requirement.")

q("bamg_observational_vs_causal", 9,
  "A firm compares customers who clicked its advertisement with customers who did not, and finds the clickers bought more. What is wrong?",
  "- This is an **observational comparison**: the two groups are different people who selected themselves into clicking.\n"
  "- Customers who click are plausibly those already interested in the product, so they would have bought more regardless.\n"
  "- The difference confounds the effect of the advertisement with the pre-existing difference that caused the click.\n"
  "- A causal answer needs assignment the firm controls, not a split the customer created.",
  "Self-selection is the clearest everyday case of the observational problem, and it is the same error as Air France's attribution issue in MKTG.")

q("bamg_validity_threats", 9,
  "Write the decomposition of the before-after difference and define each term.",
  "- R2 − R1 = **E + D + MNE** = **E + B**.\n"
  "- **E** is the true causal effect of the treatment.\n"
  "- **D** is contemporaneous drift — non-treatment influences shifting attitudes between measurements.\n"
  "- **MNE** is measurement non-equivalence — the measurement process itself changing.\n"
  "- **B** is the combined bias, D + MNE, so E = (R2 − R1) − B.",
  "The whole session is about designs that estimate B so it can be subtracted.")

q("bamg_validity_threats", 9,
  "Explain pre-survey sensitisation and which category it belongs to.",
  "- Filling in the first Toyota questionnaire **primes participants to notice Toyota** during the intervening week — spotting the cars on the road, noticing mentions.\n"
  "- That shifts the post-measure independently of the commercial.\n"
  "- It is a form of **contemporaneous drift (D)**, because it changes attitudes between the two measurements rather than changing how they are measured.",
  "Easy to misfile as measurement non-equivalence — the test is whether true attitudes moved or only the measurement did.")

q("bamg_validity_threats", 9,
  "Explain selective attrition with the numbers, and why it distorts the result.",
  "- **120 completed the pre-survey and only 80 returned the post.**\n"
  "- If the 40 who dropped out differ systematically — say they cared less about Toyota — then R1 and R2 are measured on **different subpopulations**.\n"
  "- The average can rise without anyone changing their mind, purely because the less interested people left the sample.\n"
  "- It is measurement non-equivalence, not drift: the measurement process changed, not the attitudes.",
  "The key phrase is that the average can move without any individual moving.")

q("bamg_validity_threats", 9,
  "How does he frame validity as a question, and what does that framing ask you to do?",
  "- As a **falsification question**: what counter-argument could falsify my causal claim?\n"
  "- If an alternative story explains the movement just as well, the design has a threat.\n"
  "- So the working method is to try to argue against your own result before someone else does, and then design to close off the arguments that succeed.",
  "Prof: where a counter-argument is available, there is a validity threat. That is the definition he uses.")

q("bamg_control_group_designs", 9,
  "Set out the before-after-with-control design table.",
  "- **Experimental group**: R1 before, treatment X, R2 after.\n"
  "- **Control group**: R3 before, no treatment (O), R4 after.\n"
  "- The 120 participants are randomly split between the two, and the control group watches the same pilot with no Toyota advertising.",
  "The control group has to be doing something comparable — the same pilot without the advertisement, not nothing at all.")

q("bamg_control_group_designs", 9,
  "State the two assumptions that make the control group's change equal the bias.",
  "- The control group saw no Toyota advertising, so its **true effect is zero by construction**: E' = 0.\n"
  "- If the two groups are **equivalent in their behaviour**, their biases are equal: B' = B.\n"
  "- Therefore R4 − R3 = E' + B' = B, and the control group's observed change is a direct estimate of the bias.",
  "Both assumptions are needed; the second is what the control-group requirements in the next topic are about.")

q("bamg_control_group_designs", 9,
  "Why is the before-after-with-control formula described as the cleanest in the session?",
  "- E = (R2 − R1) − (R4 − R3): **change in the treated group minus change in the control group**.\n"
  "- The logic is visible in the formula itself — you measure the bias directly on a group that could not have had an effect, then subtract it.\n"
  "- Nothing has to be assumed away algebraically; the two assumptions are stated up front and the arithmetic follows.",
  "Contrast with after-only, where an assumption is used to make a term vanish.")

q("bamg_control_group_designs", 9,
  "Derive the after-only estimator from the before-after-with-control one.",
  "- Start from E = R2 − R1 − R4 + R3 and regroup: E = **(R2 − R4) + (R3 − R1)**.\n"
  "- If the two groups are equivalent at the start then R1 = R3, so the second bracket vanishes.\n"
  "- E = **R2 − R4**.",
  "The regrouping step is the part worth rehearsing; the vanishing follows immediately once R1 = R3.")

q("bamg_control_group_designs", 9,
  "What is after-only with a control group better known as, and what kind of comparison is it?",
  "- It is **A/B testing** logic.\n"
  "- It is an **across-person comparison** — people are no longer followed across time.\n"
  "- It still supports a causal claim, provided the groups are equivalent and there is no leakage.",
  "Trap: reproduce his framing. Standard texts treat a randomised post-test-only design as fully causal without a baseline; this course does not present it that way.")

q("bamg_control_group_designs", 9,
  "Why does after-only carry a heavier sample-size requirement than before-after with control?",
  "- There are **no pre-measures** to reveal or absorb an imbalance between the groups.\n"
  "- The design depends entirely on randomisation having made R1 and R3 equivalent, and only large samples make that reliable.\n"
  "- With before-after, an imbalance would show up in the pre-measures and is differenced out anyway.",
  "The sample-size difference is a direct consequence of dropping the baseline measurement.")

q("bamg_control_requirements", 9,
  "How is group equivalence achieved with large samples and with small ones?",
  "- **Large samples**: random assignment to treatment or control.\n"
  "- **Small samples**: match on profiles instead — actively construct comparable groups rather than trusting random balance.\n"
  "- With few participants, randomisation can easily produce imbalanced groups by chance, which is what matching prevents.",
  "The method depends on sample size; randomisation is not universally the right answer.")

q("bamg_control_requirements", 9,
  "What is a confound, and when does the term apply?",
  "- If two groups are **not equivalent**, the variables on which they differ are called **confounds** or confounding variables.\n"
  "- They matter because a difference in outcomes could be caused by the confound rather than by the treatment.\n"
  "- The term describes a failure of the first control-group requirement.",
  "Definition question, and it links directly to the equivalence requirement rather than standing alone.")

q("bamg_control_requirements", 9,
  "State SUTVA and say what it requires.",
  "- The **stable unit treatment value assumption**: a person's outcome depends on **their own assigned treatment, not on someone else's**.\n"
  "- It is the formal statement of the no-leakage requirement.\n"
  "- It gets harder to satisfy over longer time frames and wherever the two groups' behaviour is linked.",
  "Name it in full — the acronym alone is unlikely to earn the mark.")

q("bamg_control_requirements", 9,
  "Explain the Uber driver interference example and why it is different from promo-code leakage.",
  "- Treated drivers get extra compensation and accept more rides. With a **limited pool of rides**, control drivers then get fewer rides *because* the treated group exists.\n"
  "- The groups interact **through the market**, without ever communicating.\n"
  "- Promo-code leakage requires contact between the groups; this does not — which makes it harder to prevent by keeping the groups apart.",
  "The mechanism is a shared scarce resource rather than information transfer.")

q("bamg_control_requirements", 9,
  "What does randomisation do for internal validity, and what does it not do?",
  "- With large samples it **reduces internal validity threats** by making the groups equivalent.\n"
  "- It does **nothing for external validity**.\n"
  "- A perfectly randomised Wisconsin Kmart sample is still a Wisconsin Kmart sample — randomising within a population does not make that population representative of any other.",
  "Trap: this is the standard confusion. Randomisation addresses who is in which group, not which population you drew from.")

q("bamg_control_requirements", 9,
  "What two questions should be asked before trusting a control-based estimate?",
  "- **Are the groups equivalent?**\n"
  "- **Is there leakage between them?**\n"
  "- If either fails, the control is not a clean counterfactual, and neither R2 − R4 nor the difference in differences can be trusted.",
  "Trap: ask both before reporting the estimate, not after being challenged on it.")

q("bamg_time_series_design", 9,
  "Set out the time-series design and derive its estimator.",
  "- Measure the same group repeatedly: **R1, treatment, R2, no treatment, R3**.\n"
  "- It is the before-after-with-control design folded onto one group: R2 here plays both R2 and R3 from that design, and R3 here plays R4.\n"
  "- E = (R2 − R1) − (R3 − R2) = **2R2 − (R1 + R3)**.",
  "The folding is what makes the algebra work — being able to say which measurement plays which role is the answer.")

q("bamg_time_series_design", 9,
  "Where has the assumption moved to in the time-series design?",
  "- Before-after with control assumed the bias was the same **across the two groups**.\n"
  "- The time-series design assumes the bias is the same **within one group across adjacent time intervals**.\n"
  "- The assumption has moved, it has not gone away.",
  "Trap: this design is not assumption-free. It trades a cross-group assumption for a cross-time one.")

q("bamg_time_series_design", 9,
  "Write the many-period regression and say what each coefficient does.",
  "- Response = b0 + b_ti x Time index + b_tr x Treatment.\n"
  "- The dataset has a time index, a **0/1 treatment indicator** and the response.\n"
  "- **b_tr estimates E**, the treatment effect.\n"
  "- **b_ti absorbs the trend**, so a general drift over the period is not attributed to the treatment.",
  "The time index is what makes the many-period version robust to gradual drift.")

q("bamg_time_series_design", 9,
  "Give the interleaved period structure for the many-period design.",
  "- No treatment, R1, treatment, R2, no treatment, R3, treatment, R4, treatment, R5, no treatment, R6, and so on.\n"
  "- The periods should **ideally be randomised** rather than strictly alternating.\n"
  "- Randomising when the treatment is on prevents the treatment pattern from lining up with any external cycle, such as a weekly or seasonal one.",
  "Note the R4/R5 consecutive treatment periods — the pattern is not required to alternate strictly.")

q("bamg_time_series_design", 9,
  "Give the three reasons to prefer the time-series design.",
  "- **No separate control group**, so neither the equivalence requirement nor the leakage requirement applies.\n"
  "- **Long-term effects are easier to see**, because the group is followed over an extended period.\n"
  "- It can be run on **field data in the real world**, as long as the treatment varies over time.",
  "The third is the most practically important: it does not require a controlled experimental setting.")

q("bamg_time_series_design", 9,
  "What should you not do about autoregressive time-series models on this exam?",
  "- The official Session 10 outline mentions autoregressive time-series models with covariates.\n"
  "- The handouts and class **do not give any AR equation** beyond the many-period regression and the later adstock formulation.\n"
  "- So do not invent one. Answer with the regression and the adstock carryover that were actually taught.",
  "Trap: the outline is broader than the taught material here. Answer from the handouts.")

# ===========================================================================
# Session 10
# ===========================================================================

q("bamg_analytics_synthesis", 10,
  "What is Move 37 and what does he use it to argue?",
  "- **AlphaGo's move against Lee Sedol** — a move human players found implausible that turned out to be strong.\n"
  "- The argument is about **broader search**: humans reach for familiar templates because mental compute is scarce, while an algorithm can inspect options that look implausible and occasionally find an unintuitive winner.\n"
  "- That is the long-run value of analytics, as distinct from the immediate value of forcing rigour.",
  "He separates two values of analytics — rigour now, broader search later. Move 37 is the second.")

q("bamg_analytics_synthesis", 10,
  "Describe the Tata Motors example and what it illustrates.",
  "- A truck project with **Prof. Manish Gangwar**.\n"
  "- The feature space ran from small urban freight vehicles to long-haul trucks with sleeping space.\n"
  "- The **data-driven concept differed from what an STP exercise had produced**, which is the working example of broader search finding something the familiar template missed.",
  "The point is the disagreement between the two methods, not that either was wrong.")

q("bamg_analytics_synthesis", 10,
  "Give the three cases where the intended target was not the eventual market.",
  "- **Toyota Qualis, then Innova**: intended for joint families and family businesses; emerged with tour and long-distance operators.\n"
  "- **Yulu**: intended for last-mile commuters; emerged with gig and delivery workers.\n"
  "- **OYO Rooms**: intended for low-end business travellers; emerged with young couples, roughly 18 to 30.\n"
  "- Together they argue for casting a wide net rather than committing early.",
  "All three are targeting misses in the same direction — the market found the product rather than the reverse.")

q("bamg_analytics_synthesis", 10,
  "What does exhaustive structural search require, and what follows where those requirements fail?",
  "- It needs **preference, feature, competitor and cost data**.\n"
  "- A HUL Kisan-type case does not have them.\n"
  "- Where the data do not exist, **classical STP, 3Cs and 4Ps are the best available method** — and he put that at roughly **70% of situations today**.",
  "The 70% figure is his and is worth quoting; it is the reason he refuses to call STP obsolete.")

q("bamg_analytics_synthesis", 10,
  "Why does he say analytics has value even where it is not literally implementable?",
  "- Because **trying to produce the number forces the team to be rigorous, concrete and systematic**, regardless of whether the number survives scrutiny.\n"
  "- Clever people can find a problem with almost any calculation, so the headline number is often not the most valuable output.\n"
  "- The value is in the questions it forces — what do we mean by competitor, what do we mean by best.",
  "Trap: do not write \"STP is bad\". His conclusion is that both frameworks are good in different contexts.")

q("bamg_micro_macro_extremes", 10,
  "Name the four context factors and the values each takes.",
  "- **Exposure measurement**: individual or group.\n"
  "- **Behaviour measurement**: individual or group.\n"
  "- **Response latency**: immediate or delayed.\n"
  "- **Behaviour frequency**: one-time or repeated.\n"
  "- They vary independently, which is what makes field assessment complicated.",
  "Four factors, two values each — the independence is the reason there are more than two possible situations.")

q("bamg_micro_macro_extremes", 10,
  "Characterise the micro extreme across all four factors and give the class example.",
  "- Exposure: **known per individual**.\n"
  "- Behaviour: **known per individual**.\n"
  "- Latency: **immediate**.\n"
  "- Frequency: **one-time**.\n"
  "- Mindset is loosely direct response; the class example was a **MakeMyTrip-style single booking**.",
  "All four line up in the same direction, which is what makes it an extreme rather than a middle case.")

q("bamg_micro_macro_extremes", 10,
  "Characterise the macro extreme across all four factors and give the class example.",
  "- Exposure: **known only in aggregate**.\n"
  "- Behaviour: **known only in aggregate**.\n"
  "- Latency: **possibly delayed**.\n"
  "- Frequency: **repeated**.\n"
  "- Mindset is loosely brand building; the class example was mass advertising with repeated bottle sales.",
  "The macro extreme is the data situation media mix modelling exists to handle.")

q("bamg_micro_macro_extremes", 10,
  "Give his concrete description of the macro data situation.",
  "- You may know **Nagpur sold 10,000 bottles this week against 12,000 last week**.\n"
  "- You may know the weekly spend on **All India Radio, Radio Mirchi, Dainik Jagran and the Indian Express**.\n"
  "- What you do not know is **which person saw which advertisement before buying which bottle**.\n"
  "- Aggregate outcomes and aggregate spend, with no link between them at the individual level.",
  "The example is worth reproducing because it makes clear exactly which join is missing.")

q("bamg_micro_macro_extremes", 10,
  "Where do most large advertising budgets sit, and why does that matter?",
  "- He argues most large budgets sit **near the macro extreme**.\n"
  "- It matters because it rules out individual-level attribution for the majority of advertising spend.\n"
  "- That is precisely the data situation media mix modelling is built for, which is why MMM rather than click attribution is the tool for the rest of the session.",
  "The claim about where budgets sit is what motivates the whole of Session 10.")

q("bamg_micro_macro_extremes", 10,
  "Why is the mindset label attached to each extreme described as loose?",
  "- The micro extreme is loosely **direct response** and the macro extreme loosely **brand building**.\n"
  "- The labels describe a tendency rather than a definition: the extremes are defined by the four measurement factors, not by marketing intent.\n"
  "- A brand-building campaign measured individually would still be at the micro extreme on the data dimensions.",
  "The categories are about what you can measure, not about what you are trying to achieve.")

q("bamg_micro_macro_extremes", 10,
  "Since the four factors vary independently, how many combinations exist and what follows?",
  "- Four binary factors give **sixteen** combinations in principle.\n"
  "- Only two are common enough to be worth naming, the micro and macro extremes, where all four line up.\n"
  "- The rest are mixed cases, which is why real assessment problems often do not fit either named extreme cleanly.",
  "The arithmetic is simple but the implication matters: the two extremes are landmarks, not an exhaustive classification.")

q("bamg_mmm_decisions", 10,
  "What data does media mix modelling start from?",
  "- **Sales y_t at time t**.\n"
  "- **Campaign intensities Ad_A,t, Ad_B,t** and so on, any of which may be running simultaneously.\n"
  "- The core analysis is how sales vary as a function of those intensities.\n"
  "- Note the simultaneity: campaigns overlap, which is what makes separating their effects difficult.",
  "The overlap of campaigns is the reason this is a modelling problem rather than a lookup.")

q("bamg_mmm_decisions", 10,
  "State the three MMM decisions precisely.",
  "1. How much should we spend on advertising **as a whole**?\n"
  "2. How much should go to **campaign A, campaign B** and the rest?\n"
  "3. How should the spend be **distributed over time**?",
  "Three decisions, and the macro/micro split falls between the second and the third.")

q("bamg_mmm_decisions", 10,
  "Define macro and micro scheduling and map them to the three decisions.",
  "- **Macro scheduling** is decisions **1 and 2** — allocating spend within a longer time frame such as a quarter or a year.\n"
  "- **Micro scheduling** is decision **3** — the pattern of execution over days or weeks: even, blitz, pulsing, or pulsing plus maintenance.",
  "Trap: the transcript has a verbal slip calling the first two micro-scheduling one sentence after correctly calling them macro. The slide is unambiguous.")

q("bamg_mmm_decisions", 10,
  "How is advertising volume measured, and why are reach and frequency separate decisions?",
  "- Volume is measured either as **expenditure** or as **gross rating points**.\n"
  "- GRP = **Reach percent x Frequency**, and it summarises total exposure pressure.\n"
  "- The same GRP can be a large audience seeing the advertisement rarely, or a small audience seeing it often — which is exactly why reach and frequency are separate decisions rather than one.",
  "The non-uniqueness of GRP is the point: the summary statistic hides a decision.")

q("bamg_mmm_decisions", 10,
  "A campaign delivers 200 GRPs. What does that not tell you?",
  "- It does not tell you the **split between reach and frequency** — 50% reach at frequency 4 and 20% reach at frequency 10 both give 200.\n"
  "- Those are very different plans: one builds awareness broadly, the other drives repetition in a narrow group.\n"
  "- Since wear-in and wearout depend on repetitions per person, the split matters for whether the spend works at all.",
  "Connects the GRP measure directly to the scheduling material later in the session.")

q("bamg_mmm_decisions", 10,
  "Why does decision 3 need separate treatment rather than following from decisions 1 and 2?",
  "- Decisions 1 and 2 fix **how much** and **where**, but the same total can be delivered in very different temporal patterns with the same area under the curve.\n"
  "- Because response depends on repetition through wear-in and wearout, the pattern changes the effect even when the total does not.\n"
  "- So the timing is a genuinely separate optimisation, which is what the four micro-scheduling patterns address.",
  "The same budget spent differently over time produces different results — that is why the third decision exists.")

q("bamg_mmm_response_model", 10,
  "Write the unconstrained and constrained forms of the MMM optimisation.",
  "- **Unconstrained**: Profit(Ad_A,t, Ad_B,t, ...) = Sales(Ad_A,t, Ad_B,t, ...) x Margin − Cost(Ad_A,t, Ad_B,t, ...).\n"
  "- **Constrained**: maximise sales times margin **subject to cost staying under a budget**.\n"
  "- The decision variables are the campaign intensities in both cases.",
  "The two forms differ in whether the budget is chosen or imposed.")

q("bamg_mmm_response_model", 10,
  "What are the two things that have to be built, and what tools does Robyn use for each?",
  "- The **sales response function**, usually a regression with a chosen functional form — Robyn uses channel responses that add up, each with saturation on top of carryover.\n"
  "- The **optimisation itself** — Robyn uses a framework called **Nevergrad**.\n"
  "- Google Meridian is another product in the same space.",
  "Two components and two tool names; both steps are hard because of the nonlinearity.")

q("bamg_mmm_response_model", 10,
  "Write the adstock recursion and say what delta controls.",
  "- Adstock_A,t = Ad_A,t + delta x Ad_A,t−1 + delta² x Ad_A,t−2 + delta³ x Ad_A,t−3 + ...\n"
  "- **Delta controls how fast the memory decays** — a higher delta means advertising keeps working for longer.\n"
  "- Adstock is carryover: this week's advertising still affects later weeks.",
  "The geometric weights are the whole content of the carryover idea.")

q("bamg_mmm_response_model", 10,
  "What does the fractional term in the Robyn response function do?",
  "- It is the **saturation** term: incremental response falls as effective exposure accumulates.\n"
  "- In the expression beta_1,A x (Adstock)^gamma / (alpha^gamma + (Adstock)^gamma), the ratio approaches 1 as adstock grows, so additional advertising buys less and less.\n"
  "- Together with adstock it captures the two temporal features of advertising response: it persists, and it diminishes.",
  "Carryover and saturation are separate phenomena; the function has a separate piece for each.")

q("bamg_mmm_response_model", 10,
  "State the data problem underneath MMM.",
  "- A mass-media model may have only about **three years of weekly observations, roughly 156 rows**.\n"
  "- It is trying to estimate several **channel-response, decay, saturation and business parameters** at once.\n"
  "- So the model is parameter-rich relative to the data, which is why estimates can be unstable.",
  "The 156 figure is worth remembering — it makes the scale of the problem concrete.")

q("bamg_mmm_response_model", 10,
  "Why did he show the Robyn equation at all?",
  "- To make the point that **it looks complicated**.\n"
  "- He is not asking anyone to derive or estimate Robyn.\n"
  "- The equation motivates the need for a **simpler allocation framework**, which is Dorfman-Steiner.",
  "Prof: the equation is a setup for the next topic, not examinable machinery in itself.")

q("bamg_dorfman_steiner", 10,
  "State the Dorfman-Steiner rule for the split across campaigns.",
  "- Spend is **proportional to each campaign's own advertising elasticity**: Ad_A is proportional to Elasticity_Ad_A.\n"
  "- So the ratio of spend between two campaigns equals the ratio of their elasticities.\n"
  "- This is the second half of the rule; the first half sets the total.",
  "Two parts to the rule: total spend, then the split. Both are needed for a full allocation.")

q("bamg_dorfman_steiner", 10,
  "Given price elasticity −2.0, advertising elasticity 0.20 and sales of 25M dollars, compute total optimal advertising.",
  "- Advertising = (Advertising elasticity / −Price elasticity) x Sales.\n"
  "- = (0.20 / 2.0) x 25M = **2.5M dollars**.\n"
  "- The price elasticity enters through its magnitude, which is what the minus sign in the denominator achieves.",
  "Practice with different numbers from the worked example — the structure is identical.")

q("bamg_dorfman_steiner", 10,
  "Define advertising elasticity and price elasticity as used in this rule.",
  "- **Advertising elasticity** is the percentage change in sales for a 1% change in advertising.\n"
  "- **Price elasticity** is the percentage change in sales for a 1% change in price, and is **negative** under the usual convention.\n"
  "- The formula uses the magnitude of the price elasticity, via the minus sign in the denominator.",
  "Getting the sign convention right is what stops the formula producing a negative budget.")

q("bamg_dorfman_steiner", 10,
  "Why is the economically optimal advertising spend finite?",
  "- Because of **diminishing returns** — the response function is concave, so each additional rupee buys less.\n"
  "- Ask an advertising agency how much to spend and the natural answer is \"as much as you can\"; the rule exists to give a bounded answer instead.\n"
  "- The optimum is where the marginal return equals the marginal cost, which the elasticity ratio encodes.",
  "Prof: the agency's incentive is the reason a formal rule is needed rather than a judgement call.")

q("bamg_dorfman_steiner", 10,
  "How do the three Dorfman-Steiner assumptions limit where the rule applies?",
  "- Sales can be increased **only by price promotion or advertising** — so any other lever, such as distribution or product change, is outside the model.\n"
  "- The marketing budget allows **only advertising or price-promotion expense**.\n"
  "- The firm is a **static monopoly** — no competitor reacts, and nothing changes over time.\n"
  "- Real markets violate all three, so the rule is a benchmark rather than a prescription.",
  "The monopoly assumption is the same limitation the Session 7 monopoly pricing formula had.")

q("bamg_scheduling_patterns", 10,
  "What do the four scheduling patterns have in common, and what differs?",
  "- All four have the **same area under the curve** — the same total budget.\n"
  "- Only the **timing** differs.\n"
  "- That is what makes micro scheduling a genuine decision: the same money produces different results depending on when it is spent.",
  "If the totals differed, the comparison would be confounded with the budget decision.")

q("bamg_scheduling_patterns", 10,
  "Why does he call even scheduling inefficient?",
  "- Dividing the budget equally across all weeks means **repeated identical exposure**, which runs into **wearout**.\n"
  "- Once the message is familiar, incremental attention falls and further identical exposures are increasingly ignored.\n"
  "- So the later weeks of an even schedule buy progressively less than the earlier ones.",
  "Even scheduling is the default and the one the psychology argues against.")

q("bamg_scheduling_patterns", 10,
  "When does blitz scheduling fit, and why?",
  "- It concentrates spend in a **short initial burst**.\n"
  "- It fits **splashy launches** — technology products, automobiles — where immediate attention and word of mouth matter.\n"
  "- The logic is that the value of the launch moment is high enough to justify spending the budget before wearout sets in.",
  "The fit is about the value of timing, not about the product category as such.")

q("bamg_scheduling_patterns", 10,
  "What is hysteresis on the exposure repetition curve?",
  "- A **residual, path-dependent effect** labelled on the slide.\n"
  "- The effect can **persist after the stimulus stops** — advertising's influence does not end when the spend does.\n"
  "- It is what makes going dark viable: the effect decays rather than vanishing, so a pause does not reset the brand to zero.",
  "Hysteresis and adstock are describing the same underlying persistence from two different directions.")

q("bamg_scheduling_patterns", 10,
  "What is the tension between his objection to creative rotation and the research findings, and how should it be presented?",
  "- His objection: rotation deliberately spends exposures on inferior advertisements, and several simultaneous messages can confuse the brand.\n"
  "- The research slide says **ad effect is greater when copy strategy has recently changed**, and that **the benefits of constant change in TV advertising outweigh the risks**.\n"
  "- The material never reconciles them. A plausible reading is **periodic refresh over time versus simultaneous rotation** — but since he did not say that, present it as a nuance rather than rewriting his claim.",
  "Trap: do not resolve the tension on his behalf. Flag it and offer the reading as a possibility.")

q("bamg_ad_response_findings", 10,
  "Which two numbers from the research slide are most likely to be asked for on their own?",
  "- **Average advertising elasticity 0.1.**\n"
  "- **New-product elasticity about 0.3.**\n"
  "- Both say a 1% spend increase moves sales by far less than 1%, and that launches respond about three times as strongly as mature products.",
  "He flagged these two explicitly as the most quotable figures on the slide.")

q("bamg_ad_response_findings", 10,
  "What do the findings say about the relationship between short-term and long-term effects?",
  "- A **visible short-term effect is a precondition for long-term effects** — so a weak campaign cannot be defended with vague brand-building claims.\n"
  "- Once effective advertising is identified, **long-term impact is about twice the short-term impact**.\n"
  "- Together: short-run measurement understates a genuinely effective advertisement, but it does not rescue an ineffective one.",
  "The two findings pull in opposite directions and both are needed for the correct conclusion.")

q("bamg_ad_response_findings", 10,
  "What do the findings say about how often campaigns work and how fast effects appear?",
  "- **Half of campaigns do not work**; when they do, sales rise about **18% in units**.\n"
  "- Impact, if any, **emerges fast — under 6 months — and lasts about 1 to 2 years**.\n"
  "- Implication: pre-test rather than assume every campaign creates value, and look for early signals rather than waiting.",
  "The 50% failure rate is the strongest argument in the deck for pre-testing.")

q("bamg_ad_response_findings", 10,
  "Which finding is identified as a myth, and what is the correct treatment of it?",
  "- **\"TV share of voice must exceed market share\"** is a myth.\n"
  "- Do not use it as a universal spending law.\n"
  "- It is the one item on the slide framed as something to reject rather than apply.",
  "Worth knowing specifically because it is a rule people quote confidently in practice.")

q("bamg_ad_response_findings", 10,
  "What does finding 11 say about optimal spending, and what does it connect to?",
  "- Optimal spending is what achieves **3 to 4 exposures**.\n"
  "- It connects straight back to **wear-in before wearout**: several exposures are needed before the message lands, and beyond that further identical exposures are ignored.\n"
  "- It also gives a concrete target for the frequency half of the GRP decision.",
  "This finding is what turns the wear-in/wearout curve into an actionable number.")


# ===========================================================================
# Emit
# ===========================================================================

EXPECTED = {
    "bamg_marketing_pods": 6, "bamg_decision_frame": 5, "bamg_blackbox_failures": 6,
    "bamg_product_optim_pipeline": 5, "bamg_compensatory_utility": 4,
    "bamg_noncompensatory_rules": 5, "bamg_logit_choice": 4, "bamg_profit_per_prospect": 6,
    "bamg_objective_taste": 6, "bamg_beyond_the_algorithm": 6,
    "bamg_affinity_segmentation": 5, "bamg_log_lift_persona": 4, "bamg_competition_views": 6,
    "bamg_positioning_statement": 6,
    "bamg_ad_brief_hierarchy": 6, "bamg_observational_vs_causal": 7, "bamg_validity_threats": 4,
    "bamg_control_group_designs": 6, "bamg_control_requirements": 6, "bamg_time_series_design": 6,
    "bamg_analytics_synthesis": 5, "bamg_micro_macro_extremes": 7, "bamg_mmm_decisions": 6,
    "bamg_mmm_response_model": 6, "bamg_dorfman_steiner": 5, "bamg_scheduling_patterns": 5,
    "bamg_ad_response_findings": 5,
}


def as_callout(note: str) -> str:
    """Matches banm2-content.py: a note opening with Trap:/Prof:/Worked example: becomes a
    blockquote, which the renderer turns into the matching coloured callout."""
    import re

    if not note:
        return ""
    return "> " + note if re.match(r"^(trap|prof(essor)?|worked example):", note, re.I) else note


def main() -> int:
    problems: list = []
    seen: set = set()
    rows = []
    counters: dict = {}

    for topic, session, prompt, answer, note in Q:
        counters[topic] = counters.get(topic, 0) + 1
        qid = f"bamg-x-{topic.replace('bamg_', '')}-{counters[topic]:02d}"
        explanation = as_callout(note)
        item = {
            "type": "short_answer", "choices": [], "correct_answer": answer,
            "explanation": explanation or "See the concept note for this topic.",
            "difficulty": 2, "provenance": "prof_adapted",
        }
        check_question(qid, item, problems, seen)
        check_markdown(f"{qid} answer", answer, problems)
        check_inline_math(f"{qid} answer", answer, problems)
        check_inline_math(f"{qid} prompt", prompt, problems)
        rows.append((qid, topic, session, prompt, answer, item["explanation"]))

    for topic, want in sorted(EXPECTED.items()):
        got = counters.get(topic, 0)
        if got != want:
            problems.append(f"topic {topic}: {got} new questions, expected {want}")
    for topic in sorted(set(counters) - set(EXPECTED)):
        problems.append(f"topic {topic}: not in the expected-count table")

    if problems:
        print("\n".join(f"-- PROBLEM: {p}" for p in problems), file=sys.stderr)
        print(f"\n{len(problems)} problem(s); nothing written.", file=sys.stderr)
        return 1

    out: list = []
    w = out.append
    w("-- BANM2 practice-bank expansion: every topic reaches 8 questions.")
    w("--")
    w("-- GENERATED -- edit supabase/banm2-expansion.py and re-emit, never this file.")
    w("--")
    w("-- All rows are short_answer, matching 20260814150000_banm2_end_term_content.sql: the BANM2")
    w("-- end-term is written short answers, so the course stays a reading reference rather than")
    w("-- Smart Practice. has_practice is derived from the absence of non-short_answer questions")
    w("-- (fetchCourses in src/learn/lib/db.ts), so it is unaffected by this migration.")
    w("")
    w("begin;")
    w("")
    w(f"-- learn_questions: {len(rows)} new rows")
    for (qid, topic, session, prompt, answer, explanation) in rows:
        source = f"Session {session}"
        w("insert into public.learn_questions")
        w("  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,")
        w("   explanation, difficulty, provenance) values")
        w(f"  ({sql(qid)}, {sql(COURSE)}, 'short_answer', {sql(topic)}, {session},")
        w(f"   {sql(prompt)},")
        w(f"   {json_array([])}, {sql(answer)}, {sql(source)},")
        w(f"   {sql(explanation)}, 2, 'prof_adapted')")
        w("on conflict (id) do update set prompt = excluded.prompt,")
        w("  correct_answer = excluded.correct_answer, explanation = excluded.explanation,")
        w("  topic = excluded.topic, session = excluded.session;")
        w("")
    w("commit;")
    w("")

    sys.stdout.write("\n".join(out))
    print(f"-- generated: {len(rows)} questions across {len(counters)} topics", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
