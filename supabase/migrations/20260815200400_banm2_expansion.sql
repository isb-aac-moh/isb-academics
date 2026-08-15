-- BANM2 practice-bank expansion: every topic reaches 8 questions.
--
-- GENERATED -- edit supabase/banm2-expansion.py and re-emit, never this file.
--
-- All rows are short_answer, matching 20260814150000_banm2_end_term_content.sql: the BANM2
-- end-term is written short answers, so the course stays a reading reference rather than
-- Smart Practice. has_practice is derived from the absence of non-short_answer questions
-- (fetchCourses in src/learn/lib/db.ts), so it is unaffected by this migration.

begin;

-- learn_questions: 148 new rows
insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-marketing_pods-01', 'BANM2', 'short_answer', 'bamg_marketing_pods', 7,
   'Which pods do Sessions 7 to 10 sit in, and which sessions map to which pod?',
   '[]'::jsonb, '- Sessions 7-10 live in the **first two pods**: value creation, and value communication and delivery.
- **Session 7** is value creation — specifying the optimal product and price.
- **Session 8** straddles the two: affinity segmentation and the persona come out of the choice model, and the positioning statement is value communication.
- **Sessions 9 and 10** are value communication and delivery — assessing advertising effects, and media planning.
- Customer acquisition and customer development/retention are the other two pods and are not the scope of this end-term.', 'Session 7',
   '> Trap: the four pods are the map of the whole discipline, not of this course. Only the first two are examined here.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-marketing_pods-02', 'BANM2', 'short_answer', 'bamg_marketing_pods', 7,
   'Give the unit of decision, horizon and style for each half of the pod table.',
   '[]'::jsonb, '- **Value creation / value communication**: unit of decision is a product, brand, market or channel system; horizon is longer, with choices persisting a few years; style is macro and strategic.
- **Acquisition / development and retention**: unit of decision is an individual customer or lead; horizon is shorter and changeable quickly; style is micro, tactical and CRM-like.
- The firms named in class were American Express and Apple for the first, Capital One, Kotak and Dell for the second.', 'Session 7',
   'The three rows are unit of decision, horizon and style — name all three rather than only the strategic/tactical label.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-marketing_pods-03', 'BANM2', 'short_answer', 'bamg_marketing_pods', 7,
   'Which firm did he name as the exception across all four pods, and why does that matter?',
   '[]'::jsonb, '- **Amazon** — strong across all four pods.
- It matters because the pod split usually describes where a firm concentrates its analytical capability. Most firms are good at one half and weak at the other.
- A firm strong on all four can connect a product decision to the individual-customer decisions that follow it, rather than running the two as separate functions.', 'Session 7',
   'One name, and the point is about the split being a description of most firms rather than a law.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-marketing_pods-04', 'BANM2', 'short_answer', 'bamg_marketing_pods', 7,
   'He described acquisition as sowing and development and retention as harvesting. What does that framing imply for how acquisition should be done?',
   '[]'::jsonb, '- Sophisticated acquisition is **not** "win any sale".
- It starts by asking which customers and which channels bring high lifetime value, because those are what can actually be harvested later.
- Acquiring a customer with low or negative lifetime value creates work for the retention pod with nothing at the end of it.
- So lead scoring and lead-source scoring belong in acquisition precisely to filter for that.', 'Session 7',
   '> Prof: the metaphor is doing analytical work — what you sow determines whether there is anything to harvest.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-marketing_pods-05', 'BANM2', 'short_answer', 'bamg_marketing_pods', 7,
   'List the activities he placed in the customer development and retention pod.',
   '[]'::jsonb, '- Cross-sell and recommendation systems.
- Loyalty programmes.
- Attrition detection.
- Value reinforcement through communities, social media, email and satisfaction measurement.', 'Session 7',
   'This pod is out of scope for the end-term, but the list is short enough to be worth holding in case a question asks for the full four-pod map.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-marketing_pods-06', 'BANM2', 'short_answer', 'bamg_marketing_pods', 7,
   'Within customer acquisition, what is the difference between macro media and micro media, and what is scored?',
   '[]'::jsonb, '- **Macro media**: TV, radio — mass channels where exposure is known only in aggregate.
- **Micro media**: search and display — channels where exposure can be attributed to an individual.
- What is scored is both the **lead** (is this person worth acquiring?) and the **lead source** (is this channel bringing worthwhile people?).
- Scoring the source is what stops a channel that delivers cheap but low-value leads from looking successful on cost per acquisition alone.', 'Session 7',
   'The macro/micro split here is the same distinction Session 10 returns to as the micro and macro extremes of advertising assessment.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-decision_frame-01', 'BANM2', 'short_answer', 'bamg_decision_frame', 7,
   'State the monopoly pricing formula he used as the standing example of theory-based decision making, and its weakness.',
   '[]'::jsonb, '- Optimal Price = MC x PED / (PED + 1).
- The appeal: a manager gets an actionable answer out of transparent, stated assumptions.
- The weakness: a valid theory may not exist for the situation, or its assumptions may not fit. A monopoly formula does not mechanically solve a duopoly where a rival reacts to your price.', 'Session 7',
   'State the formula and then the assumption that breaks — the example is chosen because the assumption is so visible.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-decision_frame-02', 'BANM2', 'short_answer', 'bamg_decision_frame', 7,
   'Why does "our model is more accurate" fail as a pitch to a CMO, and what works instead?',
   '[]'::jsonb, '- It threatens a CMO with real domain expertise: the claim is that the model knows their market better than they do.
- What works is that the process makes the decision **explicit, disciplined and defensible**.
- Senior people may distrust the number itself and still value the rigour behind it — the argument is about the quality of the reasoning, not about beating their judgement.', 'Session 7',
   '> Prof: this is a consulting point, and he made it as one. The pitch is about process, not accuracy.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-decision_frame-03', 'BANM2', 'short_answer', 'bamg_decision_frame', 7,
   'What is meant by structural modelling as one of the three distinguishing emphases, and what is it contrasted with?',
   '[]'::jsonb, '- The f in R = f(A) should **encode why an action produces an outcome**, rather than being an arbitrary flexible function fitted to data.
- It is contrasted with a black-box model that maps features to outcomes with no account of the mechanism.
- The practical payoff is that a structural model can be asked about actions never previously observed, because the mechanism still applies where historical data does not exist.', 'Session 7',
   'This emphasis is what Session 7''s whole choice-model apparatus is an instance of.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-decision_frame-04', 'BANM2', 'short_answer', 'bamg_decision_frame', 7,
   'Give the two approaches to establishing causal impact and say what distinguishes them.',
   '[]'::jsonb, '- **Causal inference with observational data (CIOD)** — the analyst does not control the assignment of the action and has to argue the comparison is fair from data that already exists.
- **Design and analysis of business experiments (DABE)** — the analyst controls assignment, which is what Session 9''s control-group designs are.
- The distinction is who decides which customers got which action: the world, or the analyst.', 'Session 7',
   'Both are named in Session 7 and Session 9 is entirely the second of them.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-decision_frame-05', 'BANM2', 'short_answer', 'bamg_decision_frame', 7,
   'Why is tunnel vision a weakness of evolved best practices, and who raised it?',
   '[]'::jsonb, '- Students raised it in class.
- A firm that only repeats what has worked never considers a genuinely different action, so the set of actions it evaluates is bounded by its own history.
- Evolution requires trial and error, so building the playbook is slow and costly, and it cannot react to a sudden shock — his example was Apple-style launch scarcity, playful in normal times and tone-deaf under COVID.', 'Session 7',
   'The COVID example is about reacting to a shock; tunnel vision is the separate point about never searching widely in the first place.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-blackbox_failures-01', 'BANM2', 'short_answer', 'bamg_blackbox_failures', 7,
   'What was his concrete version of the black-box setup, and what would the X and Y columns contain?',
   '[]'::jsonb, '- A **shelf census in a Big Bazaar**: record every product already on the shelf.
- Y column: observed market share.
- X columns: price, capacity, cleanability and brand — the product''s attribute levels.
- Fit a flexible model to that, then plug in the new product''s attribute vector to forecast its share.', 'Session 7',
   'Worth being able to describe the setup before criticising it — the three failures only make sense against a specific procedure.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-blackbox_failures-02', 'BANM2', 'short_answer', 'bamg_blackbox_failures', 7,
   'Explain the degrees-of-freedom failure in the black-box approach.',
   '[]'::jsonb, '- Many categories have **few products** (rows) but **many attributes and levels** (columns).
- There is not enough data to estimate a rich share surface over that many dimensions.
- The model will fit the handful of observed products well and generalise badly, because almost every combination of levels is unobserved.', 'Session 7',
   'This one is about the shape of the data — rows against columns — not about confounding.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-blackbox_failures-03', 'BANM2', 'short_answer', 'bamg_blackbox_failures', 7,
   'Give his example of a genuinely new attribute with no history, and explain why structural modelling handles it.',
   '[]'::jsonb, '- **Fresh juice in a container that turns blue when the juice has spoiled.**
- No product has ever had this feature, so historical shelf data contains no variation in it and nothing can be learned about its effect.
- Structural modelling handles it because market research can **describe the hypothetical feature to a respondent** and elicit how much they value it, producing a preference parameter where no historical data could exist.', 'Session 7',
   'This is the failure that structural modelling solves most directly, rather than merely mitigating.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-blackbox_failures-04', 'BANM2', 'short_answer', 'bamg_blackbox_failures', 7,
   'Why is observed market share described as confounded?',
   '[]'::jsonb, '- Share is **not generated by the feature vector alone**.
- Advertising, distribution and every other marketing action are baked into the observed share.
- So a model fitted to it recovers the combined effect of features and everything correlated with them, not the pure effect of the product on share.
- A product might have high share because it has better shelf placement, and the model would attribute that to its capacity.', 'Session 7',
   '> Trap: state this as one of three failures, not as the whole answer. Answering only "the data are confounded" gets a third of the marks.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-blackbox_failures-05', 'BANM2', 'short_answer', 'bamg_blackbox_failures', 7,
   'What are the two ground truths structural modelling respects, and why do they matter?',
   '[]'::jsonb, '- A **40% predicted share means 40% of the customer mass buys** — share is built out of individual purchase decisions, so it cannot come out above 100% or behave incoherently.
- A **customer buys because the product beats the alternatives available to them** — choice is relative to a competitive set, not an absolute property of the product.
- A share regression respects neither: it can predict any number, and it has no representation of the alternatives being chosen against.', 'Session 7',
   'These two are what make the structural forecast interpretable rather than merely fitted.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-blackbox_failures-06', 'BANM2', 'short_answer', 'bamg_blackbox_failures', 7,
   'Set out the chain structural modelling uses to build share, in order.',
   '[]'::jsonb, '- Each consumer has **preference parameters**.
- Each candidate product produces a **utility** for that consumer.
- Utility produces a **choice probability**.
- Probabilities **aggregate to share**.
- The black-box regression jumps straight from features to share and skips every step in the middle.', 'Session 7',
   'The order is the answer. Being able to recite it is what makes the criticism of the black box concrete.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-product_optim_pipeline-01', 'BANM2', 'short_answer', 'bamg_product_optim_pipeline', 7,
   'Write the three profit expressions in the decomposition and say what each represents.',
   '[]'::jsonb, '- Sales volume(P) = persons in the future market x s(P).
- Profit margin(P) = Price(P) − Cost(P).
- Profit(P) = persons in the future market x s(P) x [Price(P) − Cost(P)].
- The first turns a share into a volume, the second is the per-unit economics, and the third multiplies them.', 'Session 7',
   'Getting the decomposition down is what makes it obvious why market size cancels out of the ranking.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-product_optim_pipeline-02', 'BANM2', 'short_answer', 'bamg_product_optim_pipeline', 7,
   'Of price, cost and share, which is the genuinely hard unknown and why?',
   '[]'::jsonb, '- **Share, s(P).**
- Price is a decision variable — the firm sets it.
- Cost comes from the production team''s cost data.
- Share requires predicting how individual customers will choose the candidate against the incumbents, which is why most of the session is spent on choice models.', 'Session 7',
   'The three inputs are not equally difficult, and the session''s structure follows from which one is hard.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-product_optim_pipeline-03', 'BANM2', 'short_answer', 'bamg_product_optim_pipeline', 7,
   'What has to happen to the preference ratings when the candidate set uses levels that were never measured?',
   '[]'::jsonb, '- The ratings for the new levels have to be **interpolated or extrapolated** from the measured ones.
- Nothing forces the candidate set to use only the three levels market research asked about — with 7 levels each of price, capacity and cleanability there are already 343 own-brand candidates.
- Extrapolation beyond the measured range is the riskier of the two, since there is no evidence about how preference behaves out there.', 'Session 7',
   'The candidate set is a modelling choice, and expanding it has a data cost as well as a computational one.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-product_optim_pipeline-04', 'BANM2', 'short_answer', 'bamg_product_optim_pipeline', 7,
   'When does complete enumeration stop being feasible, and what replaces it?',
   '[]'::jsonb, '- With more attributes and more levels each, the candidate count grows multiplicatively and enumeration becomes infeasible.
- Treat it as a **continuous optimisation problem** and use standard optimisation tools — for example Excel Solver.
- The managerial formulation is unchanged; only the search method changes.', 'Session 7',
   '> Trap: the scope is the managerial formulation, not the optimiser. Do not spend revision time on Solver mechanics.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-product_optim_pipeline-05', 'BANM2', 'short_answer', 'bamg_product_optim_pipeline', 7,
   'Why must s(P) be computed against the incumbent set rather than on its own?',
   '[]'::jsonb, '- A customer buys a product because it **beats the alternatives available to them**, so a share figure is meaningless without saying what it was competing against.
- The same candidate has different shares in different competitive sets.
- This is one of the two ground truths structural modelling respects and the share regression does not.', 'Session 7',
   'Connects the optimisation pipeline back to why the black-box approach fails.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-compensatory_utility-01', 'BANM2', 'short_answer', 'bamg_compensatory_utility', 7,
   'Where do attribute importances come from, and what constraint do they satisfy?',
   '[]'::jsonb, '- Market research supplies them per customer, derived from conjoint part-worths.
- The **range of the part-worths within an attribute** becomes that attribute''s importance.
- They **sum to 100** across attributes for each customer.
- For customer 1 the part-worth ranges are 4.5 on price, 27.5 on capacity, 6.0 on cleanability and 12.0 on brand, giving importances of 9, 55, 12 and 24.', 'Session 7',
   'The sum-to-100 constraint is what makes importances comparable across attributes for one customer.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-compensatory_utility-02', 'BANM2', 'short_answer', 'bamg_compensatory_utility', 7,
   'Compute customer 1''s utility for product 2 and say why it loses to product 1.',
   '[]'::jsonb, '- u2 = 9(3) + 55(7) + 12(2) + 24(5) = 27 + 385 + 24 + 120 = **556**.
- u1 = 646, so product 1 wins for this customer.
- The two are level on capacity, which carries the largest importance at 55. Product 1''s advantage comes from cleanability (rating 7 against 2) and brand (7 against 5), which together outweigh product 2''s better price rating.', 'Session 7',
   'Worth doing the arithmetic attribute by attribute — the interesting part is which attribute produced the gap.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-compensatory_utility-03', 'BANM2', 'short_answer', 'bamg_compensatory_utility', 7,
   'What does the compensatory model predict about a product with one very weak attribute?',
   '[]'::jsonb, '- Weakness on one attribute can be **paid for** by strength on another, so no single bad attribute automatically kills the product.
- Whether it survives depends on the importance weight on the weak attribute: a low rating on something weighted 9 barely matters, while the same rating on something weighted 55 is very hard to compensate for.
- This is exactly what the non-compensatory rules deny.', 'Session 7',
   'The answer is conditional on the importance weight, not a flat yes or no.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-compensatory_utility-04', 'BANM2', 'short_answer', 'bamg_compensatory_utility', 7,
   'Give the rescaling formula used to put part-worths on a common band, and say what breaks without it.',
   '[]'::jsonb, '- Rescaled = TargetMin + (TargetMax − TargetMin) x (r − r_min) / (r_max − r_min).
- Without common anchoring, the ratings within each attribute are not pinned to the same minimum and maximum.
- Then the importances are not comparable across attributes and the importance-weighted sum is meaningless — you would be adding quantities measured on different scales.', 'Session 7',
   'The anchoring is what makes the weighted sum a legitimate operation at all.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-noncompensatory_rules-01', 'BANM2', 'short_answer', 'bamg_noncompensatory_rules', 7,
   'Walk through the lexicographic rule for customer 1 and say which product it selects.',
   '[]'::jsonb, '- Take the most important attribute: **capacity**, importance 55.
- Pick whichever product is best on it. Products 1 and 2 both rate 7 on capacity, so there is a tie.
- Move to the next most important attribute, brand at 24: product 1 rates 7 against product 2''s 5.
- **Product 1** is selected.', 'Session 7',
   'The tie-breaking step is the part worth rehearsing — the rule is only interesting when the top attribute does not decide it outright.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-noncompensatory_rules-02', 'BANM2', 'short_answer', 'bamg_noncompensatory_rules', 7,
   'Walk through elimination by aspects for customer 1 with the deck''s cutoff, and say which product it selects.',
   '[]'::jsonb, '- Set a minimum mental cutoff on each attribute — the deck uses **1.5**.
- Start with the most important attribute and throw out every product that misses the cutoff, then move to the next attribute.
- **Product 2** is selected for customer 1.
- Note this differs from the lexicographic answer on the same customer and the same data, which is the point of showing both.', 'Session 7',
   'Two non-compensatory rules, one customer, two different answers — the choice of rule is itself a modelling decision.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-noncompensatory_rules-03', 'BANM2', 'short_answer', 'bamg_noncompensatory_rules', 7,
   'Why does the name elimination by aspects describe the mechanics?',
   '[]'::jsonb, '- Once a product is eliminated for missing a threshold on an important attribute, being excellent on a less important one **cannot bring it back**.
- Elimination is permanent and it proceeds attribute by attribute, in importance order.
- That irreversibility is exactly what makes the rule non-compensatory.', 'Session 7',
   'The name is the definition — being able to explain it is a compact way of showing what non-compensatory means.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-noncompensatory_rules-04', 'BANM2', 'short_answer', 'bamg_noncompensatory_rules', 7,
   'Which non-compensatory rule does he say is overwhelmingly the more used in practice?',
   '[]'::jsonb, '- **Elimination by aspects.**
- Lexicographic choice is the simpler rule to state but is much less commonly applied.', 'Session 7',
   'A one-line fact, but a plausible short-answer prompt on its own.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-noncompensatory_rules-05', 'BANM2', 'short_answer', 'bamg_noncompensatory_rules', 7,
   'Why does he argue B2B purchasing tends toward compensatory behaviour even when individuals hold hard cutoffs?',
   '[]'::jsonb, '- The reasoning is **organisational**, not psychological.
- B2B decisions involve several stakeholders, explicit trade-off matrices and discussion.
- Individuals may each hold hard cutoffs, but aggregating several people''s views through a formal process produces something effectively compensatory.
- Consumers, deciding alone and quickly, are more likely to use fast heuristics.', 'Session 7',
   'The mechanism is aggregation across people, which is why it does not contradict individuals using cutoffs.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-logit_choice-01', 'BANM2', 'short_answer', 'bamg_logit_choice', 7,
   'Contrast customer 1 and customer 9 and explain what the comparison motivates.',
   '[]'::jsonb, '- Customer 1''s top utility is **646** against a next-best of 556 — a wide gap.
- Customer 9''s are **480 and 492** — nearly level.
- A small measurement error would flip customer 9''s predicted choice and would not flip customer 1''s.
- The deterministic max-utility rule treats both as certain, which motivates predicting **probabilities** instead.', 'Session 7',
   'The two customers are chosen to make the point that a single predicted choice hides how confident the prediction is.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-logit_choice-02', 'BANM2', 'short_answer', 'bamg_logit_choice', 7,
   'Compute c using his rule of thumb for the mug data and show the range calculation.',
   '[]'::jsonb, '- c = 100 / (12 x range of utilities over the product space).
- Best possible utility is 7 x 100 = **700** (top rating on every attribute, importances summing to 100).
- Worst possible is 1 x 100 = **100**.
- Range = 600, so c = 100 / (12 x 600) = 100 / 7200 = **0.0139**.', 'Session 7',
   'The range comes from the rating scale and the importance sum, not from the utilities actually observed.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-logit_choice-03', 'BANM2', 'short_answer', 'bamg_logit_choice', 7,
   'What happens to the predicted probabilities as c moves, using his figures for customer 1?',
   '[]'::jsonb, '- c = 0.001: split is **.39 / .36 / .26** — nearly flat, reflecting almost no confidence in the utilities.
- c = 0.02: **.86 / .14 / .00**.
- c = 0.04: **.97 / .03 / .00** — approaching the deterministic answer.
- The same utilities move a long way, which is why c has to be chosen deliberately rather than left at a default.', 'Session 7',
   '> Trap: c is not a percentage accuracy. c = 1 does not mean the research is 100% right — it is a relative confidence or dispersion parameter.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-logit_choice-04', 'BANM2', 'short_answer', 'bamg_logit_choice', 7,
   'The deterministic counts gave shares of 0.20 / 0.40 / 0.40 and the logit probabilities gave 0.22 / 0.38 / 0.40. What should be read into how close they are?',
   '[]'::jsonb, '- Not much. They are close **here** and will not be in general.
- Averaging the probabilities is the correct procedure; averaging the max-choice indicators is not, and the two agreeing on one dataset does not validate the wrong one.
- The deterministic count discards information about how marginal each customer''s choice was, which is precisely what matters when utilities are close.', 'Session 7',
   '> Trap: average the probabilities, not the max-choice indicators.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-profit_per_prospect-01', 'BANM2', 'short_answer', 'bamg_profit_per_prospect', 7,
   'Give the cost table for the mug example in full.',
   '[]'::jsonb, '- **Capacity**: 12 oz costs 1.00, 20 oz costs 2.60, 32 oz costs 2.80.
- **Cleanability**: Difficult costs 1.00, Fair costs 2.20, Easy costs 3.00.
- All figures in dollars. Costs attach to these two attributes only — price and brand carry no production cost in this example.', 'Session 7',
   'Which attributes carry cost is itself part of the setup; brand and price do not appear in the cost function.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-profit_per_prospect-02', 'BANM2', 'short_answer', 'bamg_profit_per_prospect', 7,
   'Compute expected profit per prospect for candidate 6 and say why it wins.',
   '[]'::jsonb, '- Spec: 30 dollars, 20 oz, Easy. Share **0.155**.
- Cost = 2.60 (20 oz) + 3.00 (Easy) = **5.60**. Margin = 30.00 − 5.60 = **24.40**.
- Profit per prospect = 0.155 x 24.40 = **3.780**.
- It wins on the margin side, not the share side: it has one of the lower shares of the 27 but a margin large enough to dominate.', 'Session 7',
   'The winner has a low share, which is the whole point of ranking on profit rather than on share.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-profit_per_prospect-03', 'BANM2', 'short_answer', 'bamg_profit_per_prospect', 7,
   'Compute candidate 24''s expected profit per prospect and explain the sign.',
   '[]'::jsonb, '- Spec: 5 dollars, 20 oz, Easy. Share **0.503**, the highest of the 27.
- Cost = 2.60 + 3.00 = **5.60**. Margin = 5.00 − 5.60 = **minus 0.60**.
- Profit per prospect = 0.503 x (−0.60) = **minus 0.302**.
- The price of 5 dollars sits below the cost of 5.60, so it loses money on every unit sold. Winning the most customers makes the loss larger, not smaller.', 'Session 7',
   'A negative margin turns share into a liability — the more you sell, the worse it gets.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-profit_per_prospect-04', 'BANM2', 'short_answer', 'bamg_profit_per_prospect', 7,
   'What is the conceptual order the profit-per-prospect calculation depends on?',
   '[]'::jsonb, '- Preference parameters, then utilities, then choice probabilities, then share, then economics.
- Each step is the input to the next, and the economics only enter at the very end.
- The black-box regression jumps straight from features to share and skips everything in the middle, which is why it cannot be repaired by adding a cost column.', 'Session 7',
   '> Trap: this ordering is the summary of the whole session — worth being able to state without prompting.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-profit_per_prospect-05', 'BANM2', 'short_answer', 'bamg_profit_per_prospect', 7,
   'Why is expected profit per prospect the right scaled objective rather than total profit?',
   '[]'::jsonb, '- Total profit = persons in the future market x s(P) x [Price(P) − Cost(P)].
- **Market size is the same for every candidate**, so it is a common factor and cannot change the ranking.
- Dividing it out leaves s(P) x [Price(P) − Cost(P)], which is expected profit per person or per prospect.
- It also means a market-size forecast is not needed to choose the product, only to value it.', 'Session 7',
   'The practical benefit is that the hardest number to forecast turns out not to be needed for the decision.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-profit_per_prospect-06', 'BANM2', 'short_answer', 'bamg_profit_per_prospect', 7,
   'Candidate 21 is 5 dollars, 12 oz, Easy with share 0.400. Compute its profit per prospect and compare it with candidate 24.',
   '[]'::jsonb, '- Cost = 1.00 (12 oz) + 3.00 (Easy) = **4.00**. Margin = 5.00 − 4.00 = **1.00**.
- Profit per prospect = 0.400 x 1.00 = **0.400**.
- Candidate 24 has a higher share (0.503) but a negative margin, so it returns minus 0.302.
- Dropping from 20 oz to 12 oz costs 0.103 of share and saves 1.60 of cost, which is what flips the candidate from loss-making to profitable.', 'Session 7',
   'A clean illustration that a share sacrifice can be worth taking when it buys enough margin.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-objective_taste-01', 'BANM2', 'short_answer', 'bamg_objective_taste', 7,
   'Why does he call the choice of objective a matter of taste?',
   '[]'::jsonb, '- It follows from the firm''s **objectives, ownership, financial position, growth model and managerial DNA** — not from the data.
- The algorithm ranks candidates but cannot say what "best" means.
- The metrics genuinely conflict, so there is no analytical resolution: picking one quietly on the client''s behalf is a judgement smuggled in as a calculation.', 'Session 7',
   'Taste here means it is a legitimate choice the client owns, not that it is arbitrary.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-objective_taste-02', 'BANM2', 'short_answer', 'bamg_objective_taste', 7,
   'Which candidate maximises profit, which maximises share, and why does that make the objective unavoidable?',
   '[]'::jsonb, '- **Candidate 6** maximises profit at 3.780 per prospect.
- **Candidate 24** maximises share at 0.503, and loses 0.302 per prospect.
- The two are different products, so no single recommendation satisfies both.
- There is no reading of the data that makes one of them "the best product" — the objective has to be stated before the question has an answer.', 'Session 7',
   'The conflict in this dataset is stark by design, which is why it is the example he uses.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-objective_taste-03', 'BANM2', 'short_answer', 'bamg_objective_taste', 7,
   'Why might a firm rationally choose market share as the objective despite low or negative margins?',
   '[]'::jsonb, '- To **buy scale now** at low or negative margin, then monetise it later or weaken rivals in the meantime.
- The class illustrations were blitzscaling — Jio, Uber in China, OpenAI.
- It presumes access to capital and a belief that scale is defensible once achieved; without either, it is just losing money.', 'Session 7',
   'The objective is rational conditional on the growth model and the funding, which is what makes it a taste question.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-objective_taste-04', 'BANM2', 'short_answer', 'bamg_objective_taste', 7,
   'Why would a strategic acquirer favour margin, and why would a family business favour low cost?',
   '[]'::jsonb, '- A **strategic acquirer** already has reach and distribution, so it wants a high-margin product to push through the channel it owns. Volume is not its constraint.
- A **family business** or capital-constrained firm is risk-averse and wants something cheap to make, because a low cost base limits the downside if the product fails.
- Both are rational; they differ in what each firm already has and what it can afford to lose.', 'Session 7',
   'The objective follows from the firm''s existing assets and risk position.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-objective_taste-05', 'BANM2', 'short_answer', 'bamg_objective_taste', 7,
   'Why might a private-equity buyer optimise sales revenue rather than profit?',
   '[]'::jsonb, '- Top-line scale is itself attractive to a buyer, and a private-equity acquirer may believe it can **fix costs later**.
- Revenue is harder to manufacture than margin, so a large top line is treated as evidence of genuine market demand.
- The bet is that operational improvement is within the buyer''s control while demand is not.', 'Session 7',
   'The logic is about which problems the buyer believes it can solve after the acquisition.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-objective_taste-06', 'BANM2', 'short_answer', 'bamg_objective_taste', 7,
   'What is the consulting tactic he learned from senior partners for an unknown client objective?',
   '[]'::jsonb, '- Do **not bluff a single optimal recommendation**.
- Give **conditional recommendations**: if profit is the objective choose X, if share choose Y, if revenue choose Z.
- That exposes the assumption instead of hiding it, and it hands the client the decision that is genuinely theirs.', 'Session 7',
   '> Prof: presenting one number without its objective is where a recommendation gets challenged and falls apart.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-beyond_the_algorithm-01', 'BANM2', 'short_answer', 'bamg_beyond_the_algorithm', 7,
   'Name the three levels of product design that go beyond the optimisation.',
   '[]'::jsonb, '- Translating desired benefits into **production specifications**.
- Looking past what the customer says is important, to the **higher-level needs underneath**, and building something that addresses those.
- **Aesthetics.**', 'Session 7',
   'The optimisation fixes the core attributes; these three are what it does not reach.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-beyond_the_algorithm-02', 'BANM2', 'short_answer', 'bamg_beyond_the_algorithm', 7,
   'What does a house of quality look like, and what do the cells record?',
   '[]'::jsonb, '- **User needs** run down the rows; **technical specifications** run across the columns.
- Each cell records the relationship between that need and that specification: **++** strong positive, **+** positive, **−** negative, **−−** strong negative.
- The value is that trade-offs become visible early, rather than being discovered late in engineering.', 'Session 7',
   'QFD is the disciplined translation between what the customer wants and what engineering can build.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-beyond_the_algorithm-03', 'BANM2', 'short_answer', 'bamg_beyond_the_algorithm', 7,
   'Give the mug QFD relationships he worked through.',
   '[]'::jsonb, '- "Should not cause dribble down the front of the shirt" relates **++** to the size and shape of the mouth opening.
- "Should keep liquid hot for at least an hour" relates **++** to the insulating material and **−** to a large mouth opening.
- "Should be low cost" relates **−−** to both the insulating material and the outside material.
- Note the conflict: a large mouth opening helps one need and hurts another, which is exactly the kind of trade-off the matrix is built to surface.', 'Session 7',
   'The dribble and heat-retention needs pull the mouth opening in opposite directions — that visible conflict is the output.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-beyond_the_algorithm-04', 'BANM2', 'short_answer', 'bamg_beyond_the_algorithm', 7,
   'Where does the choice-and-optimisation machinery work best, and where does it start to fail?',
   '[]'::jsonb, '- It is strongest in the **market-driven** column, where preferences and the competitive set are stable enough to measure.
- It weakens under **market-driving** strategy: when an innovator changes how a whole category is perceived, the fixed-preference assumption starts to fail.
- A student raised Tesla as the example and he agreed.', 'Session 7',
   'The method assumes preferences exist to be measured; market-driving strategy is the case where the firm changes them.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-beyond_the_algorithm-05', 'BANM2', 'short_answer', 'bamg_beyond_the_algorithm', 7,
   'Why is a QFD matrix useful even before any engineering work begins?',
   '[]'::jsonb, '- It forces user needs to be written down as needs rather than as solutions.
- It makes the relationships explicit, so a specification that damages a stated need is visible immediately rather than after a prototype.
- It surfaces conflicts between needs — the mug''s mouth opening serving one need and harming another — which are the decisions that actually require management judgement.', 'Session 7',
   'The output is a set of visible trade-offs, which is a planning artefact rather than an engineering one.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-beyond_the_algorithm-06', 'BANM2', 'short_answer', 'bamg_beyond_the_algorithm', 7,
   'The optimisation has chosen a product. What has it not settled?',
   '[]'::jsonb, '- Whether the desired benefits can actually be **turned into production specifications** — the optimisation works in attribute levels, not in engineering terms.
- The **higher-level needs** underneath the stated attributes.
- **Aesthetics**, which the attribute vector does not represent at all.
- It also assumes the competitive set and preferences hold still, which market-driving strategy violates.', 'Session 7',
   'The optimisation is enough to fix the core attributes and no more — that boundary is the point of the topic.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-affinity_segmentation-01', 'BANM2', 'short_answer', 'bamg_affinity_segmentation', 8,
   'Why is affinity segmentation run for every product in the category, not just ours?',
   '[]'::jsonb, '- Running it only for our product describes our buyers in absolute terms.
- Running it for competitors too is what makes it possible to say how our customers **differ** from a competitor''s.
- Difference is what the persona and the positioning statement need — a descriptor that is true of every buyer in the category carries no information.', 'Session 8',
   'The comparison across products is what turns a description into a differentiator.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-affinity_segmentation-02', 'BANM2', 'short_answer', 'bamg_affinity_segmentation', 8,
   'Which descriptors can be run through the affinity formula?',
   '[]'::jsonb, '- **Attribute importances.**
- The **preference for a level times the importance of that attribute**.
- **Demographic or behavioural variables** — income, age, sports activity, education.
- Any customer-level variable can be used; the formula only needs a value per customer and that customer''s purchase probability.', 'Session 8',
   'The formula is agnostic about the descriptor, which is why the output table can be wide.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-affinity_segmentation-03', 'BANM2', 'short_answer', 'bamg_affinity_segmentation', 8,
   'How does a binary descriptor read in the affinity output, and give the example.',
   '[]'::jsonb, '- For a binary descriptor the weighted mean reads directly as a **fraction**.
- A sports mean of **.84** for product 3 buyers says roughly **84% of that buyer mass plays sport**.
- No further transformation is needed, because averaging a 0/1 variable is already a proportion.', 'Session 8',
   'Convenient property worth knowing — binary descriptors need no interpretation step.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-affinity_segmentation-04', 'BANM2', 'short_answer', 'bamg_affinity_segmentation', 8,
   'What does the denominator in the affinity formula do, and what goes wrong without it?',
   '[]'::jsonb, '- The denominator is the sum of purchase probabilities across customers, and it **does the normalising**.
- Without it the numerator is a probability-weighted total rather than a mean, and its size would depend on how many customers happen to be likely buyers.
- This is why you never rescale the weights to sum to 1 beforehand — the formula already handles it, and rescaling would destroy the information about how much total buyer mass the product attracts.', 'Session 8',
   '> Trap: the weights are not supposed to sum to 1 across people. What sums to 1 is P1 + P2 + P3 within one customer.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-affinity_segmentation-05', 'BANM2', 'short_answer', 'bamg_affinity_segmentation', 8,
   'In the worked brand-importance example, identify each quantity in the calculation.',
   '[]'::jsonb, '- Customer 1: brand importance 24, P3 probability .095, contributing 24 x .095 = **2.28**.
- Customer 2: brand importance 31, P3 probability .042, contributing **1.30**.
- Summed across all ten customers: numerator **29.95**, denominator **1.55**.
- Weighted mean = 29.95 / 1.55 = **19.3**.', 'Session 8',
   'The denominator of 1.55 is the total buyer mass for product 3 — well below 10, which is the point about weights not summing to 1.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-log_lift_persona-01', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8,
   'Why does he use log lift rather than raw lift?',
   '[]'::jsonb, '- Log lift puts over- and under-indexing on a **symmetric scale around zero**.
- On raw lift, being twice the market average is 2.0 while being half the average is 0.5 — visually very different distances from 1.0 despite being equally distinctive.
- Taking logs makes those two equal and opposite, which is what a heatmap needs if strong negatives are to read as clearly as strong positives.', 'Session 8',
   '> Trap: strong negative values are just as focal as strong positive ones. Near-zero is the uninteresting cell.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-log_lift_persona-02', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8,
   'Give the full log-lift readout for the mug persona.',
   '[]'::jsonb, '- Price importance **−0.211** — less price-sensitive than the market.
- Capacity importance **−0.298** — much less concerned with capacity, though 20 oz is still their preferred size.
- Cleanability **+0.293** — highly important.
- Brand importance **−0.004** — about average, so not focal.
- Income **+0.047** and age **+0.009** — not focal.
- Sports activity **+0.322** and graduate education **+0.387** — strongly over-indexed.', 'Session 8',
   'The two near-zero rows matter as much as the large ones: they are what you leave out of the persona.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-log_lift_persona-03', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8,
   'Why did the data supplier find airport stores especially important for this mug?',
   '[]'::jsonb, '- Airport shops have **very limited inventory space**.
- This persona''s unusually **low concern about capacity** (log lift −0.298) means a narrow range of sizes is acceptable to them.
- So the constraint that normally makes airport retail difficult is a fit rather than a problem for this particular product.', 'Session 8',
   'A good illustration of a focal descriptor driving a distribution decision rather than just a creative one.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-log_lift_persona-04', 'BANM2', 'short_answer', 'bamg_log_lift_persona', 8,
   'What is the two-step structure of writing the persona, and what is the constraint on the second step?',
   '[]'::jsonb, '- **Step 1: read out** what the log-lift table literally says, descriptor by descriptor.
- **Step 2: extend**, using societal and cultural knowledge, into a describable person — educated, health-conscious, gym-going, busy.
- The constraint is that the extension must be **anchored in the focal descriptors**, not attached afterwards.', 'Session 8',
   '> Trap: do not invent the extension. Every element of it should trace back to a focal descriptor.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-competition_views-01', 'BANM2', 'short_answer', 'bamg_competition_views', 8,
   'For each of the three views of competition, say what data is compared.',
   '[]'::jsonb, '- **Consumer psychologist**: rows of the affinity output table, with descriptors put on comparable scales — whose customer personas are most similar.
- **Economist**: columns of purchase probabilities across people — who are substitutes, in that the same customers get won or lost.
- **Brand manager**: brand preference values only — among our buyers, which other brand is liked second most.', 'Session 8',
   'Three definitions, three different slices of the same output table.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-competition_views-02', 'BANM2', 'short_answer', 'bamg_competition_views', 8,
   'Which products do the three views identify in the mug data?',
   '[]'::jsonb, '- Consumer psychologist: **product 1**.
- Economist: **product 1** again.
- Brand manager: **brand A**, since P3 buyers rate C 5.699, A 4.338 and B 1.632 — C is our own brand, so A is the second-most-liked.
- Two views agreeing does not mean they always will; the definitions can point at different products.', 'Session 8',
   'The numbers matter: 5.699 / 4.338 / 1.632 is what makes A rather than B the brand-manager answer.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-competition_views-03', 'BANM2', 'short_answer', 'bamg_competition_views', 8,
   'Why does the brand manager''s view ignore product attributes entirely?',
   '[]'::jsonb, '- On that view, **product attributes can be changed over time** while the brand is the more persistent identity.
- So brand preference is treated as the durable measure of rivalry and attributes as transient.
- He is explicit that this is a perspective you may or may not agree with — keep it labelled as the brand manager''s view, not universal truth.', 'Session 8',
   '> Prof: the labelling matters. It is a defensible perspective, not an established fact.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-competition_views-04', 'BANM2', 'short_answer', 'bamg_competition_views', 8,
   'Explain the asymmetry of competition in the mug data with the numbers.',
   '[]'::jsonb, '- Our buyers rate brand C most and brand A second (5.699 / 4.338 / 1.632).
- But brand A''s **own** buyers rate A 6.374, B 3.450 and C 2.730 — we barely register for them.
- So A is a serious competitor to us while we are a minor one to A. Competition does not have to be mutual.', 'Session 8',
   'A student called brand A well protected, which he liked — a small brand may worry about the leader far more than the leader worries about it.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-competition_views-05', 'BANM2', 'short_answer', 'bamg_competition_views', 8,
   'Why does a qualitative case instruction to "analyse the competition" become a problem?',
   '[]'::jsonb, '- The word competition is never defined, so the analysis can drift to whatever the analyst had in mind.
- The affinity and choice data force **three separate operational definitions**, and they can point at different products.
- Making the definition explicit is itself part of the value of the analysis, independent of which product it names.', 'Session 8',
   'This is one of the two examples he uses in Session 10 for analytics forcing rigour rather than just producing a number.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-competition_views-06', 'BANM2', 'short_answer', 'bamg_competition_views', 8,
   'How would the economist''s view be computed in practice?',
   '[]'::jsonb, '- Compare **columns of purchase probabilities across people**.
- Two products are close substitutes if the same customers assign meaningful probability to both — winning one customer means losing them from the other.
- The test is about correlation of demand across the customer base, not about how similar the products or their buyers look.', 'Session 8',
   'Substitution is a statement about whose customers move, which is why it uses the probability columns.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-positioning_statement-01', 'BANM2', 'short_answer', 'bamg_positioning_statement', 8,
   'Give the positioning statement template and identify what each slot needs.',
   '[]'::jsonb, '- "Brand X is better at **[claim or benefit]** relative to **[competitive frame]** because it **[supporting evidence]**."
- The claim comes from the attribute where our contribution is highest relative to the competitor''s.
- The competitive frame comes from the three views of competition — you must have named a competitor.
- The supporting evidence is what makes the claim credible rather than asserted.', 'Session 8',
   'Three slots, and two of them require analysis done earlier in the session.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-positioning_statement-02', 'BANM2', 'short_answer', 'bamg_positioning_statement', 8,
   'Write out the slide''s example and say what makes each slot work.',
   '[]'::jsonb, '- "Rolaids is better at **curing heartburn within 20 minutes**, relative to **Tums**, because it **contains a new ingredient**."
- The claim is specific and testable — 20 minutes, not "fast relief".
- The frame names one competitor rather than the whole category.
- The evidence gives a reason to believe the claim rather than repeating it.', 'Session 8',
   'Specificity in the claim slot is what separates a positioning statement from a slogan.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-positioning_statement-03', 'BANM2', 'short_answer', 'bamg_positioning_statement', 8,
   'Give the formula for an attribute''s utility contribution and say how it is used to choose the claim.',
   '[]'::jsonb, '- Contribution of attribute a = **Importance_a x Rating(Level_a(P))**.
- Compute it for our target customers and for the chosen competitor.
- Pick the attribute where **our contribution is highest relative to the competitor''s** — not simply where ours is highest.', 'Session 8',
   'It is the relative comparison that identifies a differentiator; an absolute maximum only identifies what our buyers like.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-positioning_statement-04', 'BANM2', 'short_answer', 'bamg_positioning_statement', 8,
   'Describe the short loop he runs operationally to pick the claim.',
   '[]'::jsonb, '- Rank attributes by importance for our buyers.
- Start at the top and ask whether we are actually **better than the competitor** on it.
- If not, move down the ranking and ask again.
- For our mug, cleanability comes first because it has the highest importance among these buyers, and the candidate is Easy to clean — so it is the natural claim to examine.', 'Session 8',
   'The loop combines importance and superiority in the right order: importance sets the search order, superiority is the test.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-positioning_statement-05', 'BANM2', 'short_answer', 'bamg_positioning_statement', 8,
   'Why is importance alone not enough to select a positioning claim?',
   '[]'::jsonb, '- **Importance without relative superiority is not differentiation.**
- Claiming to be good at something the whole category is good at gives the customer no reason to switch.
- The claim has to beat the competitive frame you named, which is why the competitor must be chosen before the claim.', 'Session 8',
   '> Trap: do not just pick the attribute our buyers care most about — that is the most common error on this topic.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-positioning_statement-06', 'BANM2', 'short_answer', 'bamg_positioning_statement', 8,
   'What two analytical inputs does an analytically-built positioning statement require, and where does each come from?',
   '[]'::jsonb, '- **Who the competitor is** — from the three operational views of competition, applied to the affinity and choice data.
- **Which strength to emphasise** — from comparing per-attribute utility contributions between our buyers and the competitor''s.
- Both are outputs of Session 8''s earlier machinery, which is why positioning sits at the end of the session rather than the start.', 'Session 8',
   'The statement is the last step of a chain, not a standalone creative exercise.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_brief_hierarchy-01', 'BANM2', 'short_answer', 'bamg_ad_brief_hierarchy', 9,
   'What are the two halves the value-communication decisions split into?',
   '[]'::jsonb, '- **First**: developmental research, pilot creation and pre-testing — what the message is, how it translates into creatives for different media and audiences, which formats and channels are in play, and preliminary evaluation of short-term effects in a controlled setting.
- **Second**: field rollout, evaluation and media mix optimisation.
- Session 9 is largely the first half; Session 10 is the second.', 'Session 9',
   'The split also explains why Session 9''s metrics are proxies and Session 10''s are sales.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_brief_hierarchy-02', 'BANM2', 'short_answer', 'bamg_ad_brief_hierarchy', 9,
   'Who owns each of the four steps from brief to evaluation?',
   '[]'::jsonb, '1. **Internal** — the product or consulting team writes the advertising brief: persona plus positioning.
2. **Agency** — the advertising agency turns the brief into print, audio and video creatives.
3. **Joint** — internal team and agency together choose outlets and placements.
4. **Internal** — the product or marketing team evaluates effectiveness.', 'Session 9',
   'Steps 1 and 4 are both internal, and step 4 being internal is the governance point.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_brief_hierarchy-03', 'BANM2', 'short_answer', 'bamg_ad_brief_hierarchy', 9,
   'State the governance warning precisely, including the line he is drawing.',
   '[]'::jsonb, '- **Never let the advertising agency evaluate its own work**, because the agency is incentivised to show success.
- The line is **external agency versus internal firm** — not internal product team versus internal marketing team.
- Either internal team may do the evaluation; what matters is that the party being judged is not the judge.', 'Session 9',
   '> Prof: he was explicit about which boundary this is, because the obvious misreading is that marketing cannot evaluate its own campaign.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_brief_hierarchy-04', 'BANM2', 'short_answer', 'bamg_ad_brief_hierarchy', 9,
   'How was each of the four preliminary metrics measured in class?',
   '[]'::jsonb, '- **Attention** — skip rates; eye tracking for non-skippable display and print.
- **Recall** — prompted "which brand did you see?" surveys.
- **Persuasion** — attitude scales, recommendation-likelihood or NPS-style proxies.
- **Behaviour** — purchase, click, redemption.', 'Session 9',
   'The measurement method is a plausible short-answer prompt on its own, separate from the ordering.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_brief_hierarchy-05', 'BANM2', 'short_answer', 'bamg_ad_brief_hierarchy', 9,
   'Why is behaviour usually impractical in a short controlled pilot, and what follows?',
   '[]'::jsonb, '- Effects are **delayed and hard to attribute**. A Toyota advertisement may influence a purchase months later, after family discussion, with exposure online and purchase offline.
- So preliminary work leans on the earlier proxies — attention, recall, persuasion.
- Behaviour becomes central at field rollout, which is where Session 10 picks up.', 'Session 9',
   'Behaviour is the real target and the hardest to observe in the setting where you most want it.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_brief_hierarchy-06', 'BANM2', 'short_answer', 'bamg_ad_brief_hierarchy', 9,
   'What is preliminary evaluation actually for, in terms of the number of options?',
   '[]'::jsonb, '- After creative and outlet design there may be **twenty or thirty execution combinations**.
- Preliminary evaluation cuts them to **three or five** before the money goes into the field.
- Its job is elimination under controlled conditions, not final measurement.', 'Session 9',
   'Framing it as a filter explains why cheaper proxy metrics are acceptable at this stage.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-observational_vs_causal-01', 'BANM2', 'short_answer', 'bamg_observational_vs_causal', 9,
   'Why is the causal ideal impossible to observe directly?',
   '[]'::jsonb, '- The ideal compares the response of customers under A1 with the response of **those same customers** under A2, under similar conditions.
- Nobody can be observed in both states at once — a customer either saw the advertisement or did not.
- Every design in the session is therefore an **approximation** of that ideal, and the design question is which approximation is defensible.', 'Session 9',
   'This is why the session is a sequence of designs rather than a single correct method.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-observational_vs_causal-02', 'BANM2', 'short_answer', 'bamg_observational_vs_causal', 9,
   'Define treatment, treatment group and treated customers.',
   '[]'::jsonb, '- The **treatment** is the marketing action whose effect is being evaluated.
- The **treatment group**, treated group or treated customers are the customers subjected to it.
- The terms are interchangeable; the vocabulary comes from experimental design and is used throughout the session.', 'Session 9',
   'Simple terminology question, but the words are used without definition in every subsequent design.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-observational_vs_causal-03', 'BANM2', 'short_answer', 'bamg_observational_vs_causal', 9,
   'What is the simplest approximation to the causal ideal, and what is it called?',
   '[]'::jsonb, '- Take **one group under A1**, change the action on them to A2, and compare the two responses.
- This is the **before-after design**.
- It approximates the ideal by using the same people at two different times, rather than different people at the same time.', 'Session 9',
   'The approximation swaps the impossible comparison for a temporal one, which is where its validity threats come from.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-observational_vs_causal-04', 'BANM2', 'short_answer', 'bamg_observational_vs_causal', 9,
   'Why can an observational comparison not settle a causal question?',
   '[]'::jsonb, '- It compares the response of customers under A1 with the response of **different** customers under A2.
- Any difference can be the action, **or** can be pre-existing differences between the two groups.
- Nothing in the data distinguishes the two explanations, so the comparison cannot identify the effect on its own.', 'Session 9',
   'The problem is that two explanations fit equally well, not that the measurement is imprecise.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-observational_vs_causal-05', 'BANM2', 'short_answer', 'bamg_observational_vs_causal', 9,
   'Name the two approaches to causal assessment and say which one Session 9 is about.',
   '[]'::jsonb, '- **Causal inference with observational data (CIOD)**.
- **Design and analysis of business experiments (DABE)**.
- Session 9''s control-group and time-series designs are DABE — the analyst controls who gets the treatment.', 'Session 9',
   'Both were named back in Session 7 as part of what distinguishes marketing analytics.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-observational_vs_causal-06', 'BANM2', 'short_answer', 'bamg_observational_vs_causal', 9,
   'Why does the after-only design look observational, and what rescues it?',
   '[]'::jsonb, '- It compares **two different groups at one point in time**, which is exactly the shape of an observational comparison.
- What rescues it is that assignment was **randomised** and the groups are large, so the omitted pre-measures would have been equivalent and would have cancelled.
- The causal claim rests on the assignment mechanism, not on the shape of the comparison.', 'Session 9',
   '> Prof: this framing is his, and it is why he says after-only carries a much heavier sample-size requirement.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-observational_vs_causal-07', 'BANM2', 'short_answer', 'bamg_observational_vs_causal', 9,
   'A firm compares customers who clicked its advertisement with customers who did not, and finds the clickers bought more. What is wrong?',
   '[]'::jsonb, '- This is an **observational comparison**: the two groups are different people who selected themselves into clicking.
- Customers who click are plausibly those already interested in the product, so they would have bought more regardless.
- The difference confounds the effect of the advertisement with the pre-existing difference that caused the click.
- A causal answer needs assignment the firm controls, not a split the customer created.', 'Session 9',
   'Self-selection is the clearest everyday case of the observational problem, and it is the same error as Air France''s attribution issue in MKTG.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-validity_threats-01', 'BANM2', 'short_answer', 'bamg_validity_threats', 9,
   'Write the decomposition of the before-after difference and define each term.',
   '[]'::jsonb, '- R2 − R1 = **E + D + MNE** = **E + B**.
- **E** is the true causal effect of the treatment.
- **D** is contemporaneous drift — non-treatment influences shifting attitudes between measurements.
- **MNE** is measurement non-equivalence — the measurement process itself changing.
- **B** is the combined bias, D + MNE, so E = (R2 − R1) − B.', 'Session 9',
   'The whole session is about designs that estimate B so it can be subtracted.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-validity_threats-02', 'BANM2', 'short_answer', 'bamg_validity_threats', 9,
   'Explain pre-survey sensitisation and which category it belongs to.',
   '[]'::jsonb, '- Filling in the first Toyota questionnaire **primes participants to notice Toyota** during the intervening week — spotting the cars on the road, noticing mentions.
- That shifts the post-measure independently of the commercial.
- It is a form of **contemporaneous drift (D)**, because it changes attitudes between the two measurements rather than changing how they are measured.', 'Session 9',
   'Easy to misfile as measurement non-equivalence — the test is whether true attitudes moved or only the measurement did.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-validity_threats-03', 'BANM2', 'short_answer', 'bamg_validity_threats', 9,
   'Explain selective attrition with the numbers, and why it distorts the result.',
   '[]'::jsonb, '- **120 completed the pre-survey and only 80 returned the post.**
- If the 40 who dropped out differ systematically — say they cared less about Toyota — then R1 and R2 are measured on **different subpopulations**.
- The average can rise without anyone changing their mind, purely because the less interested people left the sample.
- It is measurement non-equivalence, not drift: the measurement process changed, not the attitudes.', 'Session 9',
   'The key phrase is that the average can move without any individual moving.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-validity_threats-04', 'BANM2', 'short_answer', 'bamg_validity_threats', 9,
   'How does he frame validity as a question, and what does that framing ask you to do?',
   '[]'::jsonb, '- As a **falsification question**: what counter-argument could falsify my causal claim?
- If an alternative story explains the movement just as well, the design has a threat.
- So the working method is to try to argue against your own result before someone else does, and then design to close off the arguments that succeed.', 'Session 9',
   '> Prof: where a counter-argument is available, there is a validity threat. That is the definition he uses.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_group_designs-01', 'BANM2', 'short_answer', 'bamg_control_group_designs', 9,
   'Set out the before-after-with-control design table.',
   '[]'::jsonb, '- **Experimental group**: R1 before, treatment X, R2 after.
- **Control group**: R3 before, no treatment (O), R4 after.
- The 120 participants are randomly split between the two, and the control group watches the same pilot with no Toyota advertising.', 'Session 9',
   'The control group has to be doing something comparable — the same pilot without the advertisement, not nothing at all.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_group_designs-02', 'BANM2', 'short_answer', 'bamg_control_group_designs', 9,
   'State the two assumptions that make the control group''s change equal the bias.',
   '[]'::jsonb, '- The control group saw no Toyota advertising, so its **true effect is zero by construction**: E'' = 0.
- If the two groups are **equivalent in their behaviour**, their biases are equal: B'' = B.
- Therefore R4 − R3 = E'' + B'' = B, and the control group''s observed change is a direct estimate of the bias.', 'Session 9',
   'Both assumptions are needed; the second is what the control-group requirements in the next topic are about.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_group_designs-03', 'BANM2', 'short_answer', 'bamg_control_group_designs', 9,
   'Why is the before-after-with-control formula described as the cleanest in the session?',
   '[]'::jsonb, '- E = (R2 − R1) − (R4 − R3): **change in the treated group minus change in the control group**.
- The logic is visible in the formula itself — you measure the bias directly on a group that could not have had an effect, then subtract it.
- Nothing has to be assumed away algebraically; the two assumptions are stated up front and the arithmetic follows.', 'Session 9',
   'Contrast with after-only, where an assumption is used to make a term vanish.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_group_designs-04', 'BANM2', 'short_answer', 'bamg_control_group_designs', 9,
   'Derive the after-only estimator from the before-after-with-control one.',
   '[]'::jsonb, '- Start from E = R2 − R1 − R4 + R3 and regroup: E = **(R2 − R4) + (R3 − R1)**.
- If the two groups are equivalent at the start then R1 = R3, so the second bracket vanishes.
- E = **R2 − R4**.', 'Session 9',
   'The regrouping step is the part worth rehearsing; the vanishing follows immediately once R1 = R3.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_group_designs-05', 'BANM2', 'short_answer', 'bamg_control_group_designs', 9,
   'What is after-only with a control group better known as, and what kind of comparison is it?',
   '[]'::jsonb, '- It is **A/B testing** logic.
- It is an **across-person comparison** — people are no longer followed across time.
- It still supports a causal claim, provided the groups are equivalent and there is no leakage.', 'Session 9',
   '> Trap: reproduce his framing. Standard texts treat a randomised post-test-only design as fully causal without a baseline; this course does not present it that way.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_group_designs-06', 'BANM2', 'short_answer', 'bamg_control_group_designs', 9,
   'Why does after-only carry a heavier sample-size requirement than before-after with control?',
   '[]'::jsonb, '- There are **no pre-measures** to reveal or absorb an imbalance between the groups.
- The design depends entirely on randomisation having made R1 and R3 equivalent, and only large samples make that reliable.
- With before-after, an imbalance would show up in the pre-measures and is differenced out anyway.', 'Session 9',
   'The sample-size difference is a direct consequence of dropping the baseline measurement.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_requirements-01', 'BANM2', 'short_answer', 'bamg_control_requirements', 9,
   'How is group equivalence achieved with large samples and with small ones?',
   '[]'::jsonb, '- **Large samples**: random assignment to treatment or control.
- **Small samples**: match on profiles instead — actively construct comparable groups rather than trusting random balance.
- With few participants, randomisation can easily produce imbalanced groups by chance, which is what matching prevents.', 'Session 9',
   'The method depends on sample size; randomisation is not universally the right answer.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_requirements-02', 'BANM2', 'short_answer', 'bamg_control_requirements', 9,
   'What is a confound, and when does the term apply?',
   '[]'::jsonb, '- If two groups are **not equivalent**, the variables on which they differ are called **confounds** or confounding variables.
- They matter because a difference in outcomes could be caused by the confound rather than by the treatment.
- The term describes a failure of the first control-group requirement.', 'Session 9',
   'Definition question, and it links directly to the equivalence requirement rather than standing alone.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_requirements-03', 'BANM2', 'short_answer', 'bamg_control_requirements', 9,
   'State SUTVA and say what it requires.',
   '[]'::jsonb, '- The **stable unit treatment value assumption**: a person''s outcome depends on **their own assigned treatment, not on someone else''s**.
- It is the formal statement of the no-leakage requirement.
- It gets harder to satisfy over longer time frames and wherever the two groups'' behaviour is linked.', 'Session 9',
   'Name it in full — the acronym alone is unlikely to earn the mark.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_requirements-04', 'BANM2', 'short_answer', 'bamg_control_requirements', 9,
   'Explain the Uber driver interference example and why it is different from promo-code leakage.',
   '[]'::jsonb, '- Treated drivers get extra compensation and accept more rides. With a **limited pool of rides**, control drivers then get fewer rides *because* the treated group exists.
- The groups interact **through the market**, without ever communicating.
- Promo-code leakage requires contact between the groups; this does not — which makes it harder to prevent by keeping the groups apart.', 'Session 9',
   'The mechanism is a shared scarce resource rather than information transfer.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_requirements-05', 'BANM2', 'short_answer', 'bamg_control_requirements', 9,
   'What does randomisation do for internal validity, and what does it not do?',
   '[]'::jsonb, '- With large samples it **reduces internal validity threats** by making the groups equivalent.
- It does **nothing for external validity**.
- A perfectly randomised Wisconsin Kmart sample is still a Wisconsin Kmart sample — randomising within a population does not make that population representative of any other.', 'Session 9',
   '> Trap: this is the standard confusion. Randomisation addresses who is in which group, not which population you drew from.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-control_requirements-06', 'BANM2', 'short_answer', 'bamg_control_requirements', 9,
   'What two questions should be asked before trusting a control-based estimate?',
   '[]'::jsonb, '- **Are the groups equivalent?**
- **Is there leakage between them?**
- If either fails, the control is not a clean counterfactual, and neither R2 − R4 nor the difference in differences can be trusted.', 'Session 9',
   '> Trap: ask both before reporting the estimate, not after being challenged on it.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-time_series_design-01', 'BANM2', 'short_answer', 'bamg_time_series_design', 9,
   'Set out the time-series design and derive its estimator.',
   '[]'::jsonb, '- Measure the same group repeatedly: **R1, treatment, R2, no treatment, R3**.
- It is the before-after-with-control design folded onto one group: R2 here plays both R2 and R3 from that design, and R3 here plays R4.
- E = (R2 − R1) − (R3 − R2) = **2R2 − (R1 + R3)**.', 'Session 9',
   'The folding is what makes the algebra work — being able to say which measurement plays which role is the answer.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-time_series_design-02', 'BANM2', 'short_answer', 'bamg_time_series_design', 9,
   'Where has the assumption moved to in the time-series design?',
   '[]'::jsonb, '- Before-after with control assumed the bias was the same **across the two groups**.
- The time-series design assumes the bias is the same **within one group across adjacent time intervals**.
- The assumption has moved, it has not gone away.', 'Session 9',
   '> Trap: this design is not assumption-free. It trades a cross-group assumption for a cross-time one.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-time_series_design-03', 'BANM2', 'short_answer', 'bamg_time_series_design', 9,
   'Write the many-period regression and say what each coefficient does.',
   '[]'::jsonb, '- Response = b0 + b_ti x Time index + b_tr x Treatment.
- The dataset has a time index, a **0/1 treatment indicator** and the response.
- **b_tr estimates E**, the treatment effect.
- **b_ti absorbs the trend**, so a general drift over the period is not attributed to the treatment.', 'Session 9',
   'The time index is what makes the many-period version robust to gradual drift.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-time_series_design-04', 'BANM2', 'short_answer', 'bamg_time_series_design', 9,
   'Give the interleaved period structure for the many-period design.',
   '[]'::jsonb, '- No treatment, R1, treatment, R2, no treatment, R3, treatment, R4, treatment, R5, no treatment, R6, and so on.
- The periods should **ideally be randomised** rather than strictly alternating.
- Randomising when the treatment is on prevents the treatment pattern from lining up with any external cycle, such as a weekly or seasonal one.', 'Session 9',
   'Note the R4/R5 consecutive treatment periods — the pattern is not required to alternate strictly.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-time_series_design-05', 'BANM2', 'short_answer', 'bamg_time_series_design', 9,
   'Give the three reasons to prefer the time-series design.',
   '[]'::jsonb, '- **No separate control group**, so neither the equivalence requirement nor the leakage requirement applies.
- **Long-term effects are easier to see**, because the group is followed over an extended period.
- It can be run on **field data in the real world**, as long as the treatment varies over time.', 'Session 9',
   'The third is the most practically important: it does not require a controlled experimental setting.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-time_series_design-06', 'BANM2', 'short_answer', 'bamg_time_series_design', 9,
   'What should you not do about autoregressive time-series models on this exam?',
   '[]'::jsonb, '- The official Session 10 outline mentions autoregressive time-series models with covariates.
- The handouts and class **do not give any AR equation** beyond the many-period regression and the later adstock formulation.
- So do not invent one. Answer with the regression and the adstock carryover that were actually taught.', 'Session 9',
   '> Trap: the outline is broader than the taught material here. Answer from the handouts.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-analytics_synthesis-01', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10,
   'What is Move 37 and what does he use it to argue?',
   '[]'::jsonb, '- **AlphaGo''s move against Lee Sedol** — a move human players found implausible that turned out to be strong.
- The argument is about **broader search**: humans reach for familiar templates because mental compute is scarce, while an algorithm can inspect options that look implausible and occasionally find an unintuitive winner.
- That is the long-run value of analytics, as distinct from the immediate value of forcing rigour.', 'Session 10',
   'He separates two values of analytics — rigour now, broader search later. Move 37 is the second.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-analytics_synthesis-02', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10,
   'Describe the Tata Motors example and what it illustrates.',
   '[]'::jsonb, '- A truck project with **Prof. Manish Gangwar**.
- The feature space ran from small urban freight vehicles to long-haul trucks with sleeping space.
- The **data-driven concept differed from what an STP exercise had produced**, which is the working example of broader search finding something the familiar template missed.', 'Session 10',
   'The point is the disagreement between the two methods, not that either was wrong.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-analytics_synthesis-03', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10,
   'Give the three cases where the intended target was not the eventual market.',
   '[]'::jsonb, '- **Toyota Qualis, then Innova**: intended for joint families and family businesses; emerged with tour and long-distance operators.
- **Yulu**: intended for last-mile commuters; emerged with gig and delivery workers.
- **OYO Rooms**: intended for low-end business travellers; emerged with young couples, roughly 18 to 30.
- Together they argue for casting a wide net rather than committing early.', 'Session 10',
   'All three are targeting misses in the same direction — the market found the product rather than the reverse.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-analytics_synthesis-04', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10,
   'What does exhaustive structural search require, and what follows where those requirements fail?',
   '[]'::jsonb, '- It needs **preference, feature, competitor and cost data**.
- A HUL Kisan-type case does not have them.
- Where the data do not exist, **classical STP, 3Cs and 4Ps are the best available method** — and he put that at roughly **70% of situations today**.', 'Session 10',
   'The 70% figure is his and is worth quoting; it is the reason he refuses to call STP obsolete.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-analytics_synthesis-05', 'BANM2', 'short_answer', 'bamg_analytics_synthesis', 10,
   'Why does he say analytics has value even where it is not literally implementable?',
   '[]'::jsonb, '- Because **trying to produce the number forces the team to be rigorous, concrete and systematic**, regardless of whether the number survives scrutiny.
- Clever people can find a problem with almost any calculation, so the headline number is often not the most valuable output.
- The value is in the questions it forces — what do we mean by competitor, what do we mean by best.', 'Session 10',
   '> Trap: do not write "STP is bad". His conclusion is that both frameworks are good in different contexts.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-micro_macro_extremes-01', 'BANM2', 'short_answer', 'bamg_micro_macro_extremes', 10,
   'Name the four context factors and the values each takes.',
   '[]'::jsonb, '- **Exposure measurement**: individual or group.
- **Behaviour measurement**: individual or group.
- **Response latency**: immediate or delayed.
- **Behaviour frequency**: one-time or repeated.
- They vary independently, which is what makes field assessment complicated.', 'Session 10',
   'Four factors, two values each — the independence is the reason there are more than two possible situations.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-micro_macro_extremes-02', 'BANM2', 'short_answer', 'bamg_micro_macro_extremes', 10,
   'Characterise the micro extreme across all four factors and give the class example.',
   '[]'::jsonb, '- Exposure: **known per individual**.
- Behaviour: **known per individual**.
- Latency: **immediate**.
- Frequency: **one-time**.
- Mindset is loosely direct response; the class example was a **MakeMyTrip-style single booking**.', 'Session 10',
   'All four line up in the same direction, which is what makes it an extreme rather than a middle case.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-micro_macro_extremes-03', 'BANM2', 'short_answer', 'bamg_micro_macro_extremes', 10,
   'Characterise the macro extreme across all four factors and give the class example.',
   '[]'::jsonb, '- Exposure: **known only in aggregate**.
- Behaviour: **known only in aggregate**.
- Latency: **possibly delayed**.
- Frequency: **repeated**.
- Mindset is loosely brand building; the class example was mass advertising with repeated bottle sales.', 'Session 10',
   'The macro extreme is the data situation media mix modelling exists to handle.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-micro_macro_extremes-04', 'BANM2', 'short_answer', 'bamg_micro_macro_extremes', 10,
   'Give his concrete description of the macro data situation.',
   '[]'::jsonb, '- You may know **Nagpur sold 10,000 bottles this week against 12,000 last week**.
- You may know the weekly spend on **All India Radio, Radio Mirchi, Dainik Jagran and the Indian Express**.
- What you do not know is **which person saw which advertisement before buying which bottle**.
- Aggregate outcomes and aggregate spend, with no link between them at the individual level.', 'Session 10',
   'The example is worth reproducing because it makes clear exactly which join is missing.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-micro_macro_extremes-05', 'BANM2', 'short_answer', 'bamg_micro_macro_extremes', 10,
   'Where do most large advertising budgets sit, and why does that matter?',
   '[]'::jsonb, '- He argues most large budgets sit **near the macro extreme**.
- It matters because it rules out individual-level attribution for the majority of advertising spend.
- That is precisely the data situation media mix modelling is built for, which is why MMM rather than click attribution is the tool for the rest of the session.', 'Session 10',
   'The claim about where budgets sit is what motivates the whole of Session 10.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-micro_macro_extremes-06', 'BANM2', 'short_answer', 'bamg_micro_macro_extremes', 10,
   'Why is the mindset label attached to each extreme described as loose?',
   '[]'::jsonb, '- The micro extreme is loosely **direct response** and the macro extreme loosely **brand building**.
- The labels describe a tendency rather than a definition: the extremes are defined by the four measurement factors, not by marketing intent.
- A brand-building campaign measured individually would still be at the micro extreme on the data dimensions.', 'Session 10',
   'The categories are about what you can measure, not about what you are trying to achieve.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-micro_macro_extremes-07', 'BANM2', 'short_answer', 'bamg_micro_macro_extremes', 10,
   'Since the four factors vary independently, how many combinations exist and what follows?',
   '[]'::jsonb, '- Four binary factors give **sixteen** combinations in principle.
- Only two are common enough to be worth naming, the micro and macro extremes, where all four line up.
- The rest are mixed cases, which is why real assessment problems often do not fit either named extreme cleanly.', 'Session 10',
   'The arithmetic is simple but the implication matters: the two extremes are landmarks, not an exhaustive classification.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_decisions-01', 'BANM2', 'short_answer', 'bamg_mmm_decisions', 10,
   'What data does media mix modelling start from?',
   '[]'::jsonb, '- **Sales y_t at time t**.
- **Campaign intensities Ad_A,t, Ad_B,t** and so on, any of which may be running simultaneously.
- The core analysis is how sales vary as a function of those intensities.
- Note the simultaneity: campaigns overlap, which is what makes separating their effects difficult.', 'Session 10',
   'The overlap of campaigns is the reason this is a modelling problem rather than a lookup.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_decisions-02', 'BANM2', 'short_answer', 'bamg_mmm_decisions', 10,
   'State the three MMM decisions precisely.',
   '[]'::jsonb, '1. How much should we spend on advertising **as a whole**?
2. How much should go to **campaign A, campaign B** and the rest?
3. How should the spend be **distributed over time**?', 'Session 10',
   'Three decisions, and the macro/micro split falls between the second and the third.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_decisions-03', 'BANM2', 'short_answer', 'bamg_mmm_decisions', 10,
   'Define macro and micro scheduling and map them to the three decisions.',
   '[]'::jsonb, '- **Macro scheduling** is decisions **1 and 2** — allocating spend within a longer time frame such as a quarter or a year.
- **Micro scheduling** is decision **3** — the pattern of execution over days or weeks: even, blitz, pulsing, or pulsing plus maintenance.', 'Session 10',
   '> Trap: the transcript has a verbal slip calling the first two micro-scheduling one sentence after correctly calling them macro. The slide is unambiguous.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_decisions-04', 'BANM2', 'short_answer', 'bamg_mmm_decisions', 10,
   'How is advertising volume measured, and why are reach and frequency separate decisions?',
   '[]'::jsonb, '- Volume is measured either as **expenditure** or as **gross rating points**.
- GRP = **Reach percent x Frequency**, and it summarises total exposure pressure.
- The same GRP can be a large audience seeing the advertisement rarely, or a small audience seeing it often — which is exactly why reach and frequency are separate decisions rather than one.', 'Session 10',
   'The non-uniqueness of GRP is the point: the summary statistic hides a decision.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_decisions-05', 'BANM2', 'short_answer', 'bamg_mmm_decisions', 10,
   'A campaign delivers 200 GRPs. What does that not tell you?',
   '[]'::jsonb, '- It does not tell you the **split between reach and frequency** — 50% reach at frequency 4 and 20% reach at frequency 10 both give 200.
- Those are very different plans: one builds awareness broadly, the other drives repetition in a narrow group.
- Since wear-in and wearout depend on repetitions per person, the split matters for whether the spend works at all.', 'Session 10',
   'Connects the GRP measure directly to the scheduling material later in the session.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_decisions-06', 'BANM2', 'short_answer', 'bamg_mmm_decisions', 10,
   'Why does decision 3 need separate treatment rather than following from decisions 1 and 2?',
   '[]'::jsonb, '- Decisions 1 and 2 fix **how much** and **where**, but the same total can be delivered in very different temporal patterns with the same area under the curve.
- Because response depends on repetition through wear-in and wearout, the pattern changes the effect even when the total does not.
- So the timing is a genuinely separate optimisation, which is what the four micro-scheduling patterns address.', 'Session 10',
   'The same budget spent differently over time produces different results — that is why the third decision exists.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_response_model-01', 'BANM2', 'short_answer', 'bamg_mmm_response_model', 10,
   'Write the unconstrained and constrained forms of the MMM optimisation.',
   '[]'::jsonb, '- **Unconstrained**: Profit(Ad_A,t, Ad_B,t, ...) = Sales(Ad_A,t, Ad_B,t, ...) x Margin − Cost(Ad_A,t, Ad_B,t, ...).
- **Constrained**: maximise sales times margin **subject to cost staying under a budget**.
- The decision variables are the campaign intensities in both cases.', 'Session 10',
   'The two forms differ in whether the budget is chosen or imposed.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_response_model-02', 'BANM2', 'short_answer', 'bamg_mmm_response_model', 10,
   'What are the two things that have to be built, and what tools does Robyn use for each?',
   '[]'::jsonb, '- The **sales response function**, usually a regression with a chosen functional form — Robyn uses channel responses that add up, each with saturation on top of carryover.
- The **optimisation itself** — Robyn uses a framework called **Nevergrad**.
- Google Meridian is another product in the same space.', 'Session 10',
   'Two components and two tool names; both steps are hard because of the nonlinearity.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_response_model-03', 'BANM2', 'short_answer', 'bamg_mmm_response_model', 10,
   'Write the adstock recursion and say what delta controls.',
   '[]'::jsonb, '- Adstock_A,t = Ad_A,t + delta x Ad_A,t−1 + delta² x Ad_A,t−2 + delta³ x Ad_A,t−3 + ...
- **Delta controls how fast the memory decays** — a higher delta means advertising keeps working for longer.
- Adstock is carryover: this week''s advertising still affects later weeks.', 'Session 10',
   'The geometric weights are the whole content of the carryover idea.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_response_model-04', 'BANM2', 'short_answer', 'bamg_mmm_response_model', 10,
   'What does the fractional term in the Robyn response function do?',
   '[]'::jsonb, '- It is the **saturation** term: incremental response falls as effective exposure accumulates.
- In the expression beta_1,A x (Adstock)^gamma / (alpha^gamma + (Adstock)^gamma), the ratio approaches 1 as adstock grows, so additional advertising buys less and less.
- Together with adstock it captures the two temporal features of advertising response: it persists, and it diminishes.', 'Session 10',
   'Carryover and saturation are separate phenomena; the function has a separate piece for each.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_response_model-05', 'BANM2', 'short_answer', 'bamg_mmm_response_model', 10,
   'State the data problem underneath MMM.',
   '[]'::jsonb, '- A mass-media model may have only about **three years of weekly observations, roughly 156 rows**.
- It is trying to estimate several **channel-response, decay, saturation and business parameters** at once.
- So the model is parameter-rich relative to the data, which is why estimates can be unstable.', 'Session 10',
   'The 156 figure is worth remembering — it makes the scale of the problem concrete.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-mmm_response_model-06', 'BANM2', 'short_answer', 'bamg_mmm_response_model', 10,
   'Why did he show the Robyn equation at all?',
   '[]'::jsonb, '- To make the point that **it looks complicated**.
- He is not asking anyone to derive or estimate Robyn.
- The equation motivates the need for a **simpler allocation framework**, which is Dorfman-Steiner.', 'Session 10',
   '> Prof: the equation is a setup for the next topic, not examinable machinery in itself.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-dorfman_steiner-01', 'BANM2', 'short_answer', 'bamg_dorfman_steiner', 10,
   'State the Dorfman-Steiner rule for the split across campaigns.',
   '[]'::jsonb, '- Spend is **proportional to each campaign''s own advertising elasticity**: Ad_A is proportional to Elasticity_Ad_A.
- So the ratio of spend between two campaigns equals the ratio of their elasticities.
- This is the second half of the rule; the first half sets the total.', 'Session 10',
   'Two parts to the rule: total spend, then the split. Both are needed for a full allocation.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-dorfman_steiner-02', 'BANM2', 'short_answer', 'bamg_dorfman_steiner', 10,
   'Given price elasticity −2.0, advertising elasticity 0.20 and sales of 25M dollars, compute total optimal advertising.',
   '[]'::jsonb, '- Advertising = (Advertising elasticity / −Price elasticity) x Sales.
- = (0.20 / 2.0) x 25M = **2.5M dollars**.
- The price elasticity enters through its magnitude, which is what the minus sign in the denominator achieves.', 'Session 10',
   'Practice with different numbers from the worked example — the structure is identical.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-dorfman_steiner-03', 'BANM2', 'short_answer', 'bamg_dorfman_steiner', 10,
   'Define advertising elasticity and price elasticity as used in this rule.',
   '[]'::jsonb, '- **Advertising elasticity** is the percentage change in sales for a 1% change in advertising.
- **Price elasticity** is the percentage change in sales for a 1% change in price, and is **negative** under the usual convention.
- The formula uses the magnitude of the price elasticity, via the minus sign in the denominator.', 'Session 10',
   'Getting the sign convention right is what stops the formula producing a negative budget.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-dorfman_steiner-04', 'BANM2', 'short_answer', 'bamg_dorfman_steiner', 10,
   'Why is the economically optimal advertising spend finite?',
   '[]'::jsonb, '- Because of **diminishing returns** — the response function is concave, so each additional rupee buys less.
- Ask an advertising agency how much to spend and the natural answer is "as much as you can"; the rule exists to give a bounded answer instead.
- The optimum is where the marginal return equals the marginal cost, which the elasticity ratio encodes.', 'Session 10',
   '> Prof: the agency''s incentive is the reason a formal rule is needed rather than a judgement call.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-dorfman_steiner-05', 'BANM2', 'short_answer', 'bamg_dorfman_steiner', 10,
   'How do the three Dorfman-Steiner assumptions limit where the rule applies?',
   '[]'::jsonb, '- Sales can be increased **only by price promotion or advertising** — so any other lever, such as distribution or product change, is outside the model.
- The marketing budget allows **only advertising or price-promotion expense**.
- The firm is a **static monopoly** — no competitor reacts, and nothing changes over time.
- Real markets violate all three, so the rule is a benchmark rather than a prescription.', 'Session 10',
   'The monopoly assumption is the same limitation the Session 7 monopoly pricing formula had.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-scheduling_patterns-01', 'BANM2', 'short_answer', 'bamg_scheduling_patterns', 10,
   'What do the four scheduling patterns have in common, and what differs?',
   '[]'::jsonb, '- All four have the **same area under the curve** — the same total budget.
- Only the **timing** differs.
- That is what makes micro scheduling a genuine decision: the same money produces different results depending on when it is spent.', 'Session 10',
   'If the totals differed, the comparison would be confounded with the budget decision.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-scheduling_patterns-02', 'BANM2', 'short_answer', 'bamg_scheduling_patterns', 10,
   'Why does he call even scheduling inefficient?',
   '[]'::jsonb, '- Dividing the budget equally across all weeks means **repeated identical exposure**, which runs into **wearout**.
- Once the message is familiar, incremental attention falls and further identical exposures are increasingly ignored.
- So the later weeks of an even schedule buy progressively less than the earlier ones.', 'Session 10',
   'Even scheduling is the default and the one the psychology argues against.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-scheduling_patterns-03', 'BANM2', 'short_answer', 'bamg_scheduling_patterns', 10,
   'When does blitz scheduling fit, and why?',
   '[]'::jsonb, '- It concentrates spend in a **short initial burst**.
- It fits **splashy launches** — technology products, automobiles — where immediate attention and word of mouth matter.
- The logic is that the value of the launch moment is high enough to justify spending the budget before wearout sets in.', 'Session 10',
   'The fit is about the value of timing, not about the product category as such.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-scheduling_patterns-04', 'BANM2', 'short_answer', 'bamg_scheduling_patterns', 10,
   'What is hysteresis on the exposure repetition curve?',
   '[]'::jsonb, '- A **residual, path-dependent effect** labelled on the slide.
- The effect can **persist after the stimulus stops** — advertising''s influence does not end when the spend does.
- It is what makes going dark viable: the effect decays rather than vanishing, so a pause does not reset the brand to zero.', 'Session 10',
   'Hysteresis and adstock are describing the same underlying persistence from two different directions.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-scheduling_patterns-05', 'BANM2', 'short_answer', 'bamg_scheduling_patterns', 10,
   'What is the tension between his objection to creative rotation and the research findings, and how should it be presented?',
   '[]'::jsonb, '- His objection: rotation deliberately spends exposures on inferior advertisements, and several simultaneous messages can confuse the brand.
- The research slide says **ad effect is greater when copy strategy has recently changed**, and that **the benefits of constant change in TV advertising outweigh the risks**.
- The material never reconciles them. A plausible reading is **periodic refresh over time versus simultaneous rotation** — but since he did not say that, present it as a nuance rather than rewriting his claim.', 'Session 10',
   '> Trap: do not resolve the tension on his behalf. Flag it and offer the reading as a possibility.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_response_findings-01', 'BANM2', 'short_answer', 'bamg_ad_response_findings', 10,
   'Which two numbers from the research slide are most likely to be asked for on their own?',
   '[]'::jsonb, '- **Average advertising elasticity 0.1.**
- **New-product elasticity about 0.3.**
- Both say a 1% spend increase moves sales by far less than 1%, and that launches respond about three times as strongly as mature products.', 'Session 10',
   'He flagged these two explicitly as the most quotable figures on the slide.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_response_findings-02', 'BANM2', 'short_answer', 'bamg_ad_response_findings', 10,
   'What do the findings say about the relationship between short-term and long-term effects?',
   '[]'::jsonb, '- A **visible short-term effect is a precondition for long-term effects** — so a weak campaign cannot be defended with vague brand-building claims.
- Once effective advertising is identified, **long-term impact is about twice the short-term impact**.
- Together: short-run measurement understates a genuinely effective advertisement, but it does not rescue an ineffective one.', 'Session 10',
   'The two findings pull in opposite directions and both are needed for the correct conclusion.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_response_findings-03', 'BANM2', 'short_answer', 'bamg_ad_response_findings', 10,
   'What do the findings say about how often campaigns work and how fast effects appear?',
   '[]'::jsonb, '- **Half of campaigns do not work**; when they do, sales rise about **18% in units**.
- Impact, if any, **emerges fast — under 6 months — and lasts about 1 to 2 years**.
- Implication: pre-test rather than assume every campaign creates value, and look for early signals rather than waiting.', 'Session 10',
   'The 50% failure rate is the strongest argument in the deck for pre-testing.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_response_findings-04', 'BANM2', 'short_answer', 'bamg_ad_response_findings', 10,
   'Which finding is identified as a myth, and what is the correct treatment of it?',
   '[]'::jsonb, '- **"TV share of voice must exceed market share"** is a myth.
- Do not use it as a universal spending law.
- It is the one item on the slide framed as something to reject rather than apply.', 'Session 10',
   'Worth knowing specifically because it is a rule people quote confidently in practice.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, difficulty, provenance) values
  ('bamg-x-ad_response_findings-05', 'BANM2', 'short_answer', 'bamg_ad_response_findings', 10,
   'What does finding 11 say about optimal spending, and what does it connect to?',
   '[]'::jsonb, '- Optimal spending is what achieves **3 to 4 exposures**.
- It connects straight back to **wear-in before wearout**: several exposures are needed before the message lands, and beyond that further identical exposures are ignored.
- It also gives a concrete target for the frequency half of the GRP decision.', 'Session 10',
   'This finding is what turns the wear-in/wearout curve into an actionable number.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  topic = excluded.topic, session = excluded.session;

commit;
