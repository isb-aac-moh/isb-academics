-- The professor's OPMG 'Additional Practice Set': three multi-part cases with his worked
-- solutions, circulated for end-term revision.
--
-- GENERATED -- edit supabase/opmg-additional-set.py and re-emit, never this file.
--
-- First use of learn_scenarios in this course: each case is one setup with four questions
-- chained off it. Choice order is shuffled (the professor's answer is B in 11 of 12, and
-- QuestionCard renders choices in stored order); opm-add08's prompt has its missing target
-- quantity filled in from the professor's own solution, so it alone is prof_adapted.

begin;

-- learn_scenarios: 3 rows
insert into public.learn_scenarios (id, course_code, session, title, setup, source) values
  ('opm-add-guntur', 'OPMG', 10, 'Organic Spice Processor, Guntur — EOQ with Discount Options', 'A turmeric processor in Guntur sources raw turmeric from local farmers.

- Annual demand = **500 kg** (50 weeks x 10 kg per week)
- Purchase price = **Rs 40 per kg**
- Fixed ordering cost = **Rs 180** per procurement run
- Cold-storage holding cost = **Rs 8 per kg per year** — a flat warehousing fee, independent of the purchase price', 'Additional Practice Set (Prof.)')
on conflict (id) do update set title = excluded.title, setup = excluded.setup, session = excluded.session, source = excluded.source;

insert into public.learn_scenarios (id, course_code, session, title, setup, source) values
  ('opm-add-amrutanjan', 'OPMG', 9, 'Amrutanjan Healthcare, Chennai — Process Capability + Newsvendor', 'Amrutanjan produces medicated balm in 100g tins.

- Filling machine: process mean = **100g**, standard deviation = **10g**
- Specifications: each tin must hold between **80g (LSL)** and **120g (USL)**
- Control charts use **n = 4** tins per sample

Amrutanjan must also decide how many tins to produce before the winter season.

- Production cost = **Rs 40** per tin; selling price = **Rs 100** per tin
- Unsold tins are cleared to a wholesale buyer at **Rs 20** per tin

Seasonal demand has three scenarios:

| Demand | Probability | Cumulative |
|---|---|---|
| 100 tins | 0.25 | 0.25 |
| 200 tins | 0.50 | 0.75 |
| 300 tins | 0.25 | 1.00 |', 'Additional Practice Set (Prof.)')
on conflict (id) do update set title = excluded.title, setup = excluded.setup, session = excluded.session, source = excluded.source;

insert into public.learn_scenarios (id, course_code, session, title, setup, source) values
  ('opm-add-haldiram', 'OPMG', 10, 'Haldiram''s Snack Division, Noida — Process Capability + EOQ', 'Haldiram''s orders multilayer packaging film rolls from a vendor.

- Film thickness must fall within **40 to 60 microns**
- The vendor''s process runs at mean = **50 microns**, standard deviation = **4 microns**
- Haldiram''s orders **400 rolls per year** at **Rs 200 per roll**
- Fixed ordering cost = **Rs 800 per order**, which includes incoming quality inspection
- Annual holding cost = **Rs 16 per roll per year**', 'Additional Practice Set (Prof.)')
on conflict (id) do update set title = excluded.title, setup = excluded.setup, session = excluded.session, source = excluded.source;

-- learn_questions: 12 rows
insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add01', 'OPMG', 'formula', 'eoq_cycle_inventory', 10, 'What is the standard EOQ and total annual cost (purchase + ordering + holding)?',
   '["Q* = 250 kg; total cost = Rs 22,000", "Q* = 200 kg; total cost = Rs 21,600", "Q* = 150 kg; total cost = Rs 21,200", "Q* = 100 kg; total cost = Rs 20,800"]'::jsonb, 'Q* = 150 kg; total cost = Rs 21,200', 'Additional Practice Set (Prof.)',
   'Q* = sqrt(2 x 180 x 500 / 8) = sqrt(22,500) = **150 kg**.

- Annual ordering = (500/150) x 180 = Rs 600
- Annual holding = (150/2) x 8 = Rs 600 — equal at the EOQ, which is the standard check
- Purchase = 40 x 500 = Rs 20,000

Total = **Rs 21,200**.', 'Purchase cost is the same at every order quantity here, but the question asks for total cost — add it in rather than comparing ordering + holding alone.', 'opm-add-guntur', 1, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add02', 'OPMG', 'formula', 'eoq_cycle_inventory', 10, 'The existing turmeric supplier has offered 5% price discount (Rs 38 per kg) for any single order of 250 kg or more. Should the processor increase the order quantity, and what is the total annual cost at Q = 250?',
   '["Yes; total cost at Q = 250 falls to Rs 20,360, saving Rs 840 vs. standard", "No; the unconstrained EOQ at Rs 38 is above 250, so the firm should find a new optimum first", "Yes; total cost at Q = 250 falls to Rs 19,000", "No; ordering 250 kg inflates holding cost more than the discount saves"]'::jsonb, 'Yes; total cost at Q = 250 falls to Rs 20,360, saving Rs 840 vs. standard', 'Additional Practice Set (Prof.)',
   'The EOQ formula does not change, because H = Rs 8 is a flat warehousing fee and does not move with price. Q* stays **150 kg**, below the 250-kg threshold, so taking the discount means being constrained up to Q = 250.

TC(250, Rs 38) = (500/250) x 180 + (250/2) x 8 + 38 x 500 = 360 + 1,000 + 19,000 = **Rs 20,360**.

Saving vs. standard = 21,200 − 20,360 = **Rs 840**. Take the discount.', 'Check whether H depends on price before recomputing the EOQ. Here it does not, so Q* is unchanged and the only question is whether being forced up to 250 is worth the lower price.', 'opm-add-guntur', 2, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add03', 'OPMG', 'formula', 'eoq_cycle_inventory', 10, 'We found a new supplier that offers 10% discount (Rs 36/kg) for orders of 400 kg or more. Should you switch to the new supplier?',
   '["TC = Rs 19,825; New supplier option is better on cost but identical in savings to the discount offered by the previous supplier", "TC = Rs 20,800; New supplier option saves less than the discount offered by the previous supplier and should be rejected", "TC = Rs 19,825; New supplier option is better than previous supplier options", "TC = Rs 18,500; New supplier option is best and should be chosen immediately"]'::jsonb, 'TC = Rs 19,825; New supplier option is better than previous supplier options', 'Additional Practice Set (Prof.)',
   'TC(400, Rs 36) = (500/400) x 180 + (400/2) x 8 + 36 x 500 = 225 + 1,600 + 18,000 = **Rs 19,825**.

Ranking: standard Rs 21,200 > previous supplier''s discount Rs 20,360 > new supplier Rs 19,825.

The new supplier saves Rs 1,375 against the standard policy — more than the Rs 840 the previous supplier''s discount saves — so it has the lowest total cost of the three.', 'Evaluate every price break at its own threshold quantity and compare total costs across all three policies, not just against the standard one.', 'opm-add-guntur', 3, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add04', 'OPMG', 'formula', 'eoq_cycle_inventory', 10, 'The processor''s cold-storage facility can hold at most 350 kg of inventory. Given this constraint, which discount option(s) should be used?',
   '["Both options have same cost", "Only discount option of previous supplier", "Only new supplier", "Neither"]'::jsonb, 'Only discount option of previous supplier', 'Additional Practice Set (Prof.)',
   'The new supplier''s price break needs Q = 400 kg, which exceeds the 350-kg cold-storage limit, so despite being cheaper on paper (Rs 19,825 vs Rs 20,360) it is simply **infeasible**.

The processor takes the previous supplier''s discount at Q = 250, which fits.

The point of the question: a cost-optimal solution has to be filtered through operational constraints before it is a decision.', 'Work out which options are feasible before comparing their costs — the cheapest infeasible option is not an option.', 'opm-add-guntur', 4, 3, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add05', 'OPMG', 'formula', 'quality_process_capability', 7, 'What is the sigma-capability of the filling process?',
   '["Sigma-capability = 4.0", "Sigma-capability = 6.0", "Sigma-capability = 1.0", "Sigma-capability = 2.0"]'::jsonb, 'Sigma-capability = 2.0', 'Additional Practice Set (Prof.)',
   'Sigma-capability = min[(USL − mean)/sigma, (mean − LSL)/sigma] = min[(120−100)/10, (100−80)/10] = min[2.0, 2.0] = **2.0**.

Both specification limits sit exactly 2 standard deviations from the mean, so the process is centred.', 'Take the minimum of the two one-sided distances — a process is only as capable as its nearer specification limit.', 'opm-add-amrutanjan', 1, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add06', 'OPMG', 'formula', 'spc_control_charts', 8, 'What are the UCL and LCL of the x-bar control chart with n = 4?',
   '["UCL = 105g; LCL = 95g", "UCL = 110g; LCL = 90g", "UCL = 120g; LCL = 80g (the specification limits)", "UCL = 115g; LCL = 85g"]'::jsonb, 'UCL = 115g; LCL = 85g', 'Additional Practice Set (Prof.)',
   'The chart plots sample *means*, so it uses the standard error, not the raw sigma:

sigma_xbar = sigma / sqrt(n) = 10 / sqrt(4) = **5g**.

- UCL = 100 + 3 x 5 = **115g**
- LCL = 100 − 3 x 5 = **85g**

Control limits (85–115g) are narrower than the specification limits (80–120g), as expected for a 2-sigma capable process. Confusing the two is the classic error — specification limits come from the customer, control limits come from the process.', 'Control limits are about the distribution of the sample mean, so divide sigma by sqrt(n) before going out three of them.', 'opm-add-amrutanjan', 2, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add07', 'OPMG', 'formula', 'newsvendor_model', 9, 'What is the optimal service level (SL*) and the optimal pre-season production quantity (Q*)?',
   '["SL* = 67%; Q* = 200 tins", "SL* = 75%; Q* = 200 tins", "SL* = 60%; Q* = 100 tins", "SL* = 75%; Q* = 300 tins"]'::jsonb, 'SL* = 75%; Q* = 200 tins', 'Additional Practice Set (Prof.)',
   '- Cu = 100 − 40 = **Rs 60** (margin lost per tin short)
- Co = 40 − 20 = **Rs 20** (net loss per unsold tin)

SL* = Cu / (Cu + Co) = 60 / 80 = **75%**.

Now take the smallest Q whose cumulative probability clears 75%: P(D <= 100) = 0.25, which is short; P(D <= 200) = 0.75, which clears it. So Q* = **200 tins**.', 'Co is the *net* loss on an unsold unit — cost minus salvage, not the full cost.', 'opm-add-amrutanjan', 3, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add08', 'OPMG', 'formula', 'quality_process_capability', 7, 'The quality team discards any defective tins that are outside specifications. How many tins must the production line actually run to yield the 200 saleable (non-defective) tins?',
   '["200 tins", "210 tins", "240 tins", "400 tins"]'::jsonb, '210 tins', 'Additional Practice Set (Prof.)',
   'A centred 2-sigma process (from the capability question) leaves roughly 5% of output beyond the specification limits: P(|Z| > 2) = 2 x 0.023 = 0.046, call it 5%.

Yield = 1 − 0.05 = 0.95, so the line must start:

200 / 0.95 = 210.5, i.e. about **210 tins**.

Capability is not just a quality statistic — it decides how many units you have to start to finish the number you actually promised.', 'Divide the saleable target by the yield; multiplying it by the defect rate instead understates the shortfall.', 'opm-add-amrutanjan', 4, 3, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add09', 'OPMG', 'formula', 'quality_process_capability', 7, 'What is the sigma-capability of the vendor''s current film process?',
   '["4.0", "5.0", "2.5", "2.0"]'::jsonb, '2.5', 'Additional Practice Set (Prof.)',
   'Sigma-capability = min[(60−50)/4, (50−40)/4] = min[2.5, 2.5] = **2.5**. The process is centred on the 50-micron midpoint.', 'Both specification limits are 10 microns away; divide that by the standard deviation.', 'opm-add-haldiram', 1, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add10', 'OPMG', 'formula', 'eoq_cycle_inventory', 10, 'What is Haldiram''s optimal order quantity?',
   '["Q* = 400 rolls", "Q* = 300 rolls", "Q* = 100 rolls", "Q* = 200 rolls"]'::jsonb, 'Q* = 200 rolls', 'Additional Practice Set (Prof.)',
   'Q* = sqrt(2 x 800 x 400 / 16) = sqrt(40,000) = **200 rolls**.

The Rs 200 per-roll purchase price does not enter the formula, because holding cost is given directly as Rs 16 per roll per year rather than as a percentage of value.', 'Only R, S and H go into the EOQ. Purchase price matters only when H is expressed as a fraction of it.', 'opm-add-haldiram', 2, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add11', 'OPMG', 'formula', 'eoq_cycle_inventory', 10, 'After the process improvement, the vendor achieves ''certified supplier'' status by reducing standard deviation to 2 microns. This lowers Haldiram''s inspection intensity, reducing ordering cost to Rs 200 per order. What is Haldiram''s optimal order quantity after the vendor is ''certified supplier''?',
   '["Q* = 50", "Q* = 150", "Q* = 200", "Q* = 100"]'::jsonb, 'Q* = 100', 'Additional Practice Set (Prof.)',
   'Q* = sqrt(2 x 200 x 400 / 16) = sqrt(10,000) = **100 rolls**.

Ordering cost fell by a factor of 4 (800 to 200), so Q* falls by sqrt(4) = 2.

Note what did *not* happen: the vendor''s standard deviation never enters the EOQ formula. The quality improvement reaches the inventory decision only through the ordering cost it removes.', 'The sigma improvement is a distractor — trace it through to the parameter it actually changes before recomputing.', 'opm-add-haldiram', 3, 2, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values
  ('opm-add12', 'OPMG', 'formula', 'eoq_cycle_inventory', 10, 'By how much does the total annual inventory operations cost (ordering + holding, excluding purchase) decrease after the vendor improvement?',
   '["Rs 1,600", "No change", "Rs 3,200", "Rs 800"]'::jsonb, 'Rs 1,600', 'Additional Practice Set (Prof.)',
   'Before (Q = 200, S = 800): ordering = (400/200) x 800 = Rs 1,600; holding = (200/2) x 16 = Rs 1,600; total = **Rs 3,200**.

After (Q = 100, S = 200): ordering = (400/100) x 200 = Rs 800; holding = (100/2) x 16 = Rs 800; total = **Rs 1,600**.

Reduction = **Rs 1,600 per year** — a one-off improvement at the vendor turning into a permanent annual saving downstream.', 'Ordering and holding are equal at the EOQ in both states, so compute one and double it.', 'opm-add-haldiram', 4, 3, 'prof_verbatim')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

commit;
