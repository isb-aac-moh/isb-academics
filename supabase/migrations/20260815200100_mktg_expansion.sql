-- MKTG practice-bank expansion: every topic goes from 1 question to 8.
--
-- GENERATED -- edit supabase/mktg-expansion.py and re-emit, never this file.
--
-- ROUND_SIZE is 8 and pickNext() does not repeat within a round, so a one-question topic
-- ended a topic-filtered round immediately. Quantitative answers are computed in the
-- generator; case answers are grounded in the coursepack and the learn_concepts notes.

begin;

-- learn_questions: 105 new rows
insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-be1', 'MKTG', 'formula', 'break_even', 3,
   'A shampoo sachet sells for Rs 5 and costs Rs 3.50 to make. A regional launch carries Rs 300,000 of fixed cost. How many sachets must sell before the launch breaks even?',
   '["85,715 sachets", "150,000 sachets", "60,000 sachets", "200,000 sachets"]'::jsonb, '200,000 sachets', 'Session 3',
   'Unit contribution = 5 − 3.50 = **Rs 1.50**.

Break-even volume = fixed cost / unit contribution = 300,000 / 1.50 = **200,000 sachets**.

150,000 comes from dividing by the price minus nothing useful; 60,000 comes from dividing by the price of Rs 5 rather than the contribution, which is the most common slip — fixed costs are recovered out of contribution, not out of revenue.', 'Divide by what each unit actually contributes to fixed cost, not by its price.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-be2', 'MKTG', 'formula', 'break_even', 3,
   'A display rack costs Rs 9,000 for the season. The product it holds carries a unit contribution of Rs 12. The brand manager expects the rack to sell 600 extra units. Should she take it?',
   '["Yes — break-even is 750 units and she expects 600", "No — break-even is 450 units and she expects only 600", "Yes — break-even is 450 units and she expects 600", "No — break-even is 750 units and she expects only 600"]'::jsonb, 'No — break-even is 750 units and she expects only 600', 'Session 3',
   'Break-even = 9,000 / 12 = **750 units**. She expects 600, which is 150 units short, so the rack loses money at the forecast volume.

The useful habit here is the one the note describes: break-even turns an argument ("is the rack worth it?") into a number you can check a forecast against.', 'Work out the volume the spend requires, then compare it with the volume you actually expect — in that order.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-be3', 'MKTG', 'formula', 'break_even', 3,
   'A firm sells at Rs 250 with variable cost Rs 150 and annual fixed costs of Rs 2,000,000. It wants a target profit of Rs 500,000, not just break-even. What volume does it need?',
   '["10,000 units", "20,000 units", "25,000 units", "16,667 units"]'::jsonb, '25,000 units', 'Session 3',
   'Treat the target profit as fixed cost that also has to be recovered:

Volume = (fixed cost + target profit) / unit contribution = (2,000,000 + 500,000) / 100 = **25,000 units**.

20,000 units is plain break-even, which ignores the profit target.', 'A profit target behaves exactly like an additional fixed cost.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-be4', 'MKTG', 'formula', 'break_even', 3,
   'Two products have the same Rs 400,000 fixed cost. Product A sells at Rs 100 with Rs 60 variable cost; Product B sells at Rs 100 with Rs 80 variable cost. How do their break-even volumes compare?',
   '["A needs 10,000 units, B needs 20,000 — B needs twice the volume", "Both need 10,000 units, because price and fixed cost are identical", "A needs 4,000 units, B needs 5,000 — B needs slightly more", "A needs 10,000 units, B needs 5,000 — B needs half the volume"]'::jsonb, 'A needs 10,000 units, B needs 20,000 — B needs twice the volume', 'Session 3',
   '- A: contribution = 100 − 60 = Rs 40, break-even = 400,000 / 40 = **10,000 units**
- B: contribution = 100 − 80 = Rs 20, break-even = 400,000 / 20 = **20,000 units**

Halving the contribution doubles the volume needed. This is why a small change in variable cost moves the required volume far more than it moves the price tag.', 'Same price and same fixed cost does not mean the same break-even — contribution is what does the work.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-be5', 'MKTG', 'formula', 'break_even', 3,
   'A brand currently sells 40,000 units at Rs 200 with a variable cost of Rs 120. Marketing proposes a price cut to Rs 180. How many units must it now sell to earn the same total contribution as before?',
   '["40,000 units", "44,445 units", "60,000 units", "53,334 units"]'::jsonb, '53,334 units', 'Session 3',
   'Current total contribution = 40,000 x (200 − 120) = **Rs 3,200,000**.

After the cut, unit contribution = 180 − 120 = Rs 60.

Required volume = 3,200,000 / 60 = 53,333.3, so **53,334 units** rounding up to a whole unit.

A 10% price cut needs a 33% volume increase to stand still — the leverage runs through contribution, not through price.', 'Hold total contribution constant and solve for the new volume; the price cut comes entirely out of the margin.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-be6', 'MKTG', 'case_fact', 'break_even', 3,
   'What does break-even analysis deliberately not tell you?',
   '["The volume at which profit is zero", "How a price change alters the volume needed", "How fixed costs are recovered out of unit contribution", "Whether the required volume is achievable in this market"]'::jsonb, 'Whether the required volume is achievable in this market', 'Session 3',
   'Break-even produces a number, not a judgement. It says how many units are needed; whether that many can actually be sold is a question about market size, distribution and competition that the arithmetic cannot answer.

This is why the professor treats break-even as the **first step** rather than the decision — it converts an argument into a checkable quantity, and then someone still has to judge the quantity.', 'Ask what the calculation takes as input and what it produces as output — achievability is neither.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-be7', 'MKTG', 'formula', 'break_even', 3,
   'A firm''s fixed costs rise from Rs 500,000 to Rs 650,000 while unit contribution stays at Rs 25. By how many units does break-even volume rise?',
   '["26,000 units", "20,000 units", "6,000 units", "3,750 units"]'::jsonb, '6,000 units', 'Session 3',
   '- Before: 500,000 / 25 = 20,000 units
- After: 650,000 / 25 = 26,000 units

Increase = **6,000 units**, which is simply the extra fixed cost divided by the unchanged contribution: 150,000 / 25.

26,000 is the new break-even level rather than the increase the question asked for.', 'You can get the change directly from the change in fixed cost — no need to compute both levels.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-mm1', 'MKTG', 'formula', 'margin_markup', 3,
   'A retailer buys at Rs 60 and sells at Rs 100. What are the percentage margin and the percentage markup?',
   '["Margin 40%, markup 40%", "Margin 60%, markup 66.7%", "Margin 66.7%, markup 40%", "Margin 40%, markup 66.7%"]'::jsonb, 'Margin 40%, markup 66.7%', 'Session 3',
   '- Margin = (p − c) / p = 40 / 100 = **40%**
- Markup = (p − c) / c = 40 / 60 = **66.7%**

Same transaction, two different numbers, because margin divides by price and markup divides by cost. Markup is always the larger of the two for a profitable item.', 'Margin divides by price; markup divides by cost. Write down which denominator you are using before you divide.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-mm2', 'MKTG', 'formula', 'margin_markup', 3,
   'A supplier says he gives his retailer 40%, meaning a 40% markup on cost. The retailer says she works on 40%, meaning a 40% margin on price. If the cost to the retailer is Rs 100 in both cases, what selling prices are they each describing?',
   '["Supplier Rs 166.67, retailer Rs 140", "Both Rs 140", "Supplier Rs 140, retailer Rs 166.67", "Supplier Rs 140, retailer Rs 144"]'::jsonb, 'Supplier Rs 140, retailer Rs 166.67', 'Session 3',
   '- The supplier''s 40% markup: price = 100 x 1.40 = **Rs 140**
- The retailer''s 40% margin: price = 100 / (1 − 0.40) = **Rs 166.67**

The same stated percentage produces prices Rs 26.67 apart. This is the practical reason the distinction matters — two parties can agree on "forty percent" and be planning different businesses.', 'For a target margin, divide the cost by (1 − margin); for a target markup, multiply the cost by (1 + markup).', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-mm3', 'MKTG', 'formula', 'margin_markup', 3,
   'A product has a 25% markup on cost. What is its percentage margin?',
   '["20%", "33.3%", "75%", "25%"]'::jsonb, '20%', 'Session 3',
   'Convert with margin = markup / (1 + markup) = 0.25 / 1.25 = **20%**.

Check it with a number: cost 100, markup 25% gives price 125, and margin = 25 / 125 = 20%.

Answering 25% is the error the conversion exists to prevent.', 'Convert by putting the markup over one-plus-itself, or just pick a cost of 100 and read both numbers off.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-mm4', 'MKTG', 'formula', 'margin_markup', 3,
   'A brand wants a 60% margin on a product that costs Rs 80 to make. What price must it charge?',
   '["Rs 133.33", "Rs 200", "Rs 128", "Rs 140"]'::jsonb, 'Rs 200', 'Session 3',
   'Price = cost / (1 − margin) = 80 / 0.40 = **Rs 200**.

Check: margin = (200 − 80) / 200 = 60%.

Rs 128 is cost x 1.60, which sets a 60% *markup* and delivers a margin of only 37.5%.', 'A target margin is a statement about price, so the unknown price has to be in the denominator — solve, do not multiply.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-mm5', 'MKTG', 'formula', 'margin_markup', 3,
   'A manufacturer sells to a wholesaler at Rs 50. The wholesaler takes a 20% margin, and the retailer then takes a 40% margin. What does the consumer pay?',
   '["Rs 104.17", "Rs 96.15", "Rs 85.00", "Rs 90.00"]'::jsonb, 'Rs 104.17', 'Session 3',
   'Work up the chain, dividing at each step because each party states a margin on **its own** selling price:

- Wholesaler price = 50 / (1 − 0.20) = Rs 62.50
- Retail price = 62.50 / (1 − 0.40) = **Rs 104.17**

Rs 85 comes from adding the two percentages and marking up once, which treats both margins as markups on the manufacturer''s price.', 'Each margin is taken on that party''s own price, so divide at every step and work upward one link at a time.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-mm6', 'MKTG', 'case_fact', 'margin_markup', 3,
   'Why is a percentage markup always numerically larger than the percentage margin on the same profitable sale?',
   '["Because markup includes fixed costs while margin does not", "Because markup divides the same profit by cost, which is smaller than price", "Because markup compounds across the distribution chain", "Because margin is calculated after tax and markup before it"]'::jsonb, 'Because markup divides the same profit by cost, which is smaller than price', 'Session 3',
   'Both use the identical numerator, the unit profit (p − c). Markup divides it by cost, margin divides it by price, and for any profitable item price is greater than cost. A smaller denominator gives a larger fraction.

It also tells you the two converge as margins get thin, and diverge sharply on high-margin goods.', 'Compare the denominators — the numerator is the same in both.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-mm7', 'MKTG', 'formula', 'margin_markup', 3,
   'A chocolate bar sells to the trade at Rs 40 with a variable cost of Rs 22. What is the unit contribution, and what percentage margin does it represent?',
   '["Rs 18 and 55%", "Rs 18 and 81.8%", "Rs 22 and 55%", "Rs 18 and 45%"]'::jsonb, 'Rs 18 and 45%', 'Session 3',
   '- Unit contribution = 40 − 22 = **Rs 18**
- Margin = 18 / 40 = **45%**

81.8% is 18 / 22, the markup on cost. Unit contribution is the figure that then goes into every break-even and cannibalisation calculation, so getting its percentage base right early avoids the error propagating.', 'Unit contribution is a rupee amount; turning it into a margin means dividing by price.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bc1', 'MKTG', 'formula', 'becr_cannibalization', 3,
   'A new line extension earns a unit contribution of Rs 30. The existing product it will take sales from earns Rs 50. Ignoring any incremental fixed cost, what is the break-even cannibalisation rate?',
   '["40%", "60%", "167%", "20%"]'::jsonb, '60%', 'Session 3',
   'BECR = new contribution / old contribution = 30 / 50 = **60%**.

Up to 60% of the new product''s volume can come out of the existing line before the launch stops adding contribution. Above that it destroys more margin than it creates.

167% is the ratio inverted, which would say a lower-margin product is safer to launch — the opposite of the truth.', 'Put the new product''s contribution over the old one; a lower-margin newcomer gives a lower ceiling.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bc2', 'MKTG', 'formula', 'becr_cannibalization', 3,
   'A new product is expected to sell 200,000 units with a 35% cannibalisation rate. The cannibalised product carries a unit contribution of Rs 90. What contribution is destroyed?',
   '["Rs 18,000,000", "Rs 2,205,000", "Rs 6,300,000", "Rs 6,300"]'::jsonb, 'Rs 6,300,000', 'Session 3',
   'Units lost = 200,000 x 0.35 = **70,000 units**.

Contribution destroyed = 70,000 x 90 = **Rs 6,300,000**.

Rs 18,000,000 applies the old contribution to all 200,000 new units, which assumes every single new sale is a cannibalised one.', 'The cannibalisation rate applies to the new product''s volume, and each lost unit costs you the *old* product''s contribution.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bc3', 'MKTG', 'case_fact', 'becr_cannibalization', 3,
   'Which statement correctly describes how the break-even cannibalisation rate is used?',
   '["It is a ceiling the expected rate is tested against — the launch loses money above it", "It is the share of new volume that must come from category growth", "It is a target the marketing plan should aim to reach", "It is the rate at which competitors lose share to the new product"]'::jsonb, 'It is a ceiling the expected rate is tested against — the launch loses money above it', 'Session 3',
   'BECR is a limit, not a goal. You compute it, then compare it with the cannibalisation rate you actually expect. Expected below BECR means the launch survives; expected above it means the launch destroys more margin than it creates.

Reading it as a target inverts the logic — nobody wants to maximise how much of their own base they convert.', 'Ask which of the two numbers you control and which you are testing against.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bc4', 'MKTG', 'formula', 'becr_cannibalization', 3,
   'Two launches are being compared. Launch A''s new product earns the same unit contribution as the existing line; Launch B''s earns half as much. What are their break-even cannibalisation rates?',
   '["A is 0%, B is 50%", "A is 50%, B is 100%", "Both are 100%", "A is 100%, B is 50%"]'::jsonb, 'A is 100%, B is 50%', 'Session 3',
   '- A: contribution ratio 1.0, so **BECR = 100%**. Every switching customer is margin-neutral, so even total cannibalisation breaks even.
- B: ratio 0.5, so **BECR = 50%**. Each switcher costs half their old margin.

This is why cheap line extensions are riskier than premium ones: the lower the newcomer''s margin, the less of your own base you can afford to convert.', 'Work from what a single switching customer costs you in each case.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bc5', 'MKTG', 'case_fact', 'becr_cannibalization', 3,
   'Where must a new product''s volume come from if the launch is to represent genuine growth?',
   '["From whichever source produces the highest reported volume", "From the firm''s own existing brands, which keeps the customer in-house", "From competitors or from category expansion", "From the firm''s premium line, since those customers are the most loyal"]'::jsonb, 'From competitors or from category expansion', 'Session 3',
   'Volume taken from your own brands is a **transfer**, not growth — and usually a transfer to a worse margin, which is exactly what the cannibalisation calculation prices.

The practical use is as a challenge to a launch forecast: ask whose units these are. A plan projecting large volume without saying where it comes from has not been finished.', 'Growth has to come from outside the firm''s existing sales, or it is not growth.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bc6', 'MKTG', 'formula', 'becr_cannibalization', 3,
   'A launch is forecast to sell 120,000 units and earn Rs 9,000,000 of profit before cannibalisation. The cannibalised line earns a unit contribution of Rs 250. Above what cannibalisation rate does the launch stop being worth doing?',
   '["25%", "36%", "30%", "75%"]'::jsonb, '30%', 'Session 3',
   'With incremental fixed costs already inside that profit figure, the break-even rate is the one that wipes the profit out:

rate = profit before cannibalisation / (new units x old unit contribution) = 9,000,000 / (120,000 x 250) = 9,000,000 / 30,000,000 = **30%**.

This is the version of BECR the Kookaburra case uses, and it differs from the plain contribution ratio precisely because fixed costs are real here.', 'Set post-cannibalisation profit to zero and solve for the rate.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bc7', 'MKTG', 'case_fact', 'becr_cannibalization', 3,
   'Why can the contribution-ratio form of BECR overstate how much cannibalisation a launch can absorb?',
   '["It assumes the cannibalisation rate is known with certainty", "It ignores the incremental fixed costs the launch itself carries", "It double-counts the margin on units lost from the existing line", "It uses the new product''s price rather than its contribution"]'::jsonb, 'It ignores the incremental fixed costs the launch itself carries', 'Session 3',
   'The ratio of new contribution to old contribution answers a narrower question: how much cannibalisation is tolerable when the launch adds no fixed cost of its own.

A launch carrying new capacity, depreciation and advertising has to cover those before it covers anything else, so the rate that actually zeroes out profit is lower. Kookaburra is the worked example — the contribution ratio there is above 1.0, while the profit-based ceiling in Year 2 is 29%.', 'Ask what the simple ratio leaves out of the profit calculation.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-kk1', 'MKTG', 'formula', 'case_kookaburra', 3,
   'Kookaburra''s existing Indian business sold 783,360 bats for net sales of Rs 1,442,940K against variable costs of Rs 808,050K. What is the average unit contribution used to value cannibalised units?',
   '["Rs 196.75", "Rs 1,842.10", "Rs 1,031.60", "Rs 810.47"]'::jsonb, 'Rs 810.47', 'Kookaburra case, Table 1',
   'Total contribution = 1,442,940 − 808,050 = **Rs 634,890K**.

Per unit = 634,890,000 / 783,360 = **Rs 810.47**.

Rs 1,842.10 is net sales per unit, which values a lost sale at its full revenue and ignores the variable cost the firm no longer incurs. Rs 196.75 is operating profit per unit, which wrongly loads fixed costs onto a unit that does not change them.', 'A cannibalised unit costs you its contribution, not its revenue and not its fully-loaded profit.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-kk2', 'MKTG', 'formula', 'case_kookaburra', 3,
   'Under the niche strategy in Year 1, Kookaburra sells 80,000 bats at Rs 2,350 with a variable cost of Rs 1,330. Fixed costs are depreciation of Rs 5,000K plus media Rs 45,000K, consumer promotion Rs 24,000K and trade promotion Rs 19,500K. What is profit before cannibalisation?',
   '["−Rs 56,900K", "Rs 81,600K", "Rs 35,300K", "−Rs 11,900K"]'::jsonb, '−Rs 11,900K', 'Kookaburra case, Tables 2-3',
   '- Variable margin = 80,000 x (2,350 − 1,330) = **Rs 81,600K**
- Fixed costs = 5,000 + 45,000 + 24,000 + 19,500 = **Rs 93,500K**

Profit = 81,600 − 93,500 = **−Rs 11,900K**.

−Rs 56,900K comes from also subtracting the Rs 50,000K capacity investment. That is capitalised, and it reaches the P&L through the depreciation line already counted.', 'Only depreciation of the capacity investment belongs in the P&L, not the investment itself.', 3, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-kk3', 'MKTG', 'formula', 'case_kookaburra', 3,
   'The niche strategy carries a 22% cannibalisation rate on 80,000 Year 1 units, and the base business earns Rs 810.47 per unit. What does cannibalisation cost, and what is Year 1 profit after it?',
   '["Rs 14,264K destroyed, giving Rs 2,364K", "Rs 14,264K destroyed, giving −Rs 26,164K", "Rs 17,600K destroyed, giving −Rs 29,500K", "Rs 64,838K destroyed, giving −Rs 76,738K"]'::jsonb, 'Rs 14,264K destroyed, giving −Rs 26,164K', 'Kookaburra case',
   'Units lost = 80,000 x 0.22 = 17,600. Contribution destroyed = 17,600 x 810.47 = **Rs 14,264K**.

Profit after cannibalisation = −11,900 − 14,264 = **−Rs 26,164K**.

The cannibalisation more than doubles the loss — and none of it is visible in the forecast table, which is the point of the case.', 'Apply the rate to the new product''s volume, then value each lost unit at the base contribution.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-kk4', 'MKTG', 'case_fact', 'case_kookaburra', 3,
   'Read only the pre-cannibalisation forecasts — niche earns −Rs 11,900K then Rs 35,300K; mainstream earns Rs 35,500K then Rs 155,300K. Why is "mainstream is obviously better" an unsafe conclusion?',
   '["The niche figures cover a longer time horizon than the mainstream ones", "Mainstream''s figures are stated before variable costs are deducted", "Mainstream carries a 32% cannibalisation rate against niche''s 22%, and those costs are not in the figures", "Mainstream volumes are forecasts while niche volumes are actuals"]'::jsonb, 'Mainstream carries a 32% cannibalisation rate against niche''s 22%, and those costs are not in the figures', 'Kookaburra case',
   'Every figure in the forecast table is **before** cannibalisation. Mainstream sells more units and cannibalises a higher share of them, so it destroys far more base contribution — Rs 70,025K in Year 1 against niche''s Rs 14,264K.

The comparison only becomes meaningful after both are charged for the volume they take from the existing line.', 'Check what the forecast table has and has not already subtracted before comparing the two columns.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-kk5', 'MKTG', 'formula', 'case_kookaburra', 3,
   'In Year 2 the niche launch earns Rs 35,300K before cannibalisation on 150,000 units, against a base contribution of Rs 810.47. What is the break-even cannibalisation rate, and does the expected 22% clear it?',
   '["126%, so cannibalisation is not a constraint", "29%, and 22% clears it but not by much", "29%, and 22% fails to clear it", "18%, and 22% fails to clear it"]'::jsonb, '29%, and 22% clears it but not by much', 'Kookaburra case',
   'Set profit after cannibalisation to zero:

rate = 35,300 / (150,000 x 810.47 / 1,000) = 35,300 / 121,571 = **0.290**.

Expected cannibalisation is 22%, so the launch survives with about seven points of headroom — thin enough that an error in the cannibalisation estimate could flip the decision.

126% is the contribution ratio (1,020 / 810.47), which is the right formula only when the launch carries no incremental fixed cost. Here it carries a great deal.', 'Fixed costs are already inside the Rs 35,300K, so find the rate that drives that profit to zero.', 3, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-kk6', 'MKTG', 'case_fact', 'case_kookaburra', 3,
   'A new cricket bat''s performance claims cannot be verified by a buyer before purchase. What is this problem called, and why does premium pricing help?',
   '["Free riding — a high price stops retailers from discounting away the brand''s image", "Moral hazard — a high price commits the firm to maintaining quality after the sale", "Adverse selection — a high price is costly to sustain with a bad product, so it carries information", "Adverse selection — a high price screens out buyers who would return the bat"]'::jsonb, 'Adverse selection — a high price is costly to sustain with a bad product, so it carries information', 'Kookaburra case',
   'Buyers rationally discount claims they cannot check, so the launch needs a **credible signal** rather than an assertion.

What makes a signal credible is that it would be expensive or risky for a firm with a bad product: celebrity endorsement, money-back guarantees, extended warranties, live demonstrations — and premium pricing itself, which a poor product could not sustain once word spread.

A signal anybody could send tells the buyer nothing.', 'Ask what all the credible signals have in common — and why a firm with a bad product could not imitate them.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-kk7', 'MKTG', 'case_fact', 'case_kookaburra', 3,
   'The case warns that marginal cost differs between the niche and mainstream scenarios — Rs 1,330 against Rs 1,250 per unit. What goes wrong if a single unit cost is carried across both?',
   '["Nothing, since both scenarios sell the same bat", "Break-even volumes stay correct but cannibalisation costs are overstated", "The comparison looks rigorous but is wrong, because volume discounts make the two scenarios genuinely different", "Only the Year 1 figures are affected, because Year 2 volumes converge"]'::jsonb, 'The comparison looks rigorous but is wrong, because volume discounts make the two scenarios genuinely different', 'Kookaburra case',
   'Mainstream buys materials in much larger quantities, so its variable cost per unit is lower. Applying one cost to both strategies quietly transfers that advantage to whichever scenario did not earn it.

The wider lesson the case is making: an analysis can be arithmetically flawless and still wrong because a shared assumption was not actually shared.', 'Look at why the two variable costs differ before deciding whether averaging them is harmless.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bmw1', 'MKTG', 'formula', 'case_bmw_films', 2,
   'BMW spent about $30M in total on "The Hire" and drew roughly 2M registrations. What was the approximate cost per viewer, and how does it compare with prime-time television?',
   '["About $1.50 per person against roughly $0.02 for a TV ad", "About $0.15 per person against roughly $0.02 for a TV ad", "About $15 per person against roughly $0.02 for a TV ad", "About $15 per person against roughly $2.00 for a TV ad"]'::jsonb, 'About $15 per person against roughly $0.02 for a TV ad', 'BMW Films case',
   '30,000,000 / 2,000,000 = **$15 per registrant**, against roughly two cents per viewer for prime-time television — a difference of nearly three orders of magnitude.

It is not a like-for-like comparison, because a registered, self-selected, profiled viewer is worth considerably more than an incidental one. But it is the first criticism the case expects you to raise rather than wait to be asked.', 'Divide total spend by registrations, then ask what makes the two kinds of viewer different.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bmw2', 'MKTG', 'case_fact', 'case_bmw_films', 2,
   'The films sat behind a registration wall and a player download, and ran only on BMWfilms.com. Why was that friction a deliberate strategy rather than a distribution mistake?',
   '["It reduced bandwidth costs enough to fund the production budget", "It prevented competitors from studying the campaign", "It filtered the audience down to the intended target and kept the 7-series segment out", "It satisfied film industry licensing terms for the directors involved"]'::jsonb, 'It filtered the audience down to the intended target and kept the 7-series segment out', 'BMW Films case',
   'The target was **future 3-series buyers** — young, online, years away from affording the car. The friction selected for exactly those people.

The 7-series segment on $300K+ was deliberately excluded: the tone was neither prestigious nor luxurious, and that segment found it disrespectful. Effective targeting means the message will *not* appeal to everyone, and preventing leakage matters as much as reaching the target.

A campaign everybody likes has usually failed to position anything.', 'Work out who the campaign was for before deciding whether the barriers were a bug.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bmw3', 'MKTG', 'case_fact', 'case_bmw_films', 2,
   'Which BMW segment accounted for half of unit sales, and what made it the strategic problem the campaign was aimed at?',
   '["The 3-series, at 50% of sales and the least loyal of the three", "The 7-series, at 50% of sales and the most loyal of the three", "The 3-series, at 50% of sales and the most loyal of the three", "The 5-series, at 50% of sales and the least loyal of the three"]'::jsonb, 'The 3-series, at 50% of sales and the least loyal of the three', 'BMW Films case',
   'The 3-series was about **50%** of unit sales — buyers around 35, mostly male, tech-savvy, high-earning, unmarried — and the **least loyal** of the three lines. The 7-series was 16% of sales and the most loyal.

Half the volume coming from the least loyal segment means BMW has to refill that segment every generation, which is precisely what a campaign aimed at people too young to buy is for.', 'Match the share of sales against the loyalty column and ask which combination creates an ongoing problem.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bmw4', 'MKTG', 'case_fact', 'case_bmw_films', 2,
   'Which criticism of the campaign''s distribution does the case expect students to raise?',
   '["The films ran only on BMWfilms.com, not even on BMW.com or at dealerships", "The films were distributed free, which undercut the brand''s premium positioning", "The films were too short to hold the attention of the target segment", "The films were released simultaneously rather than staggered across the six-month gap"]'::jsonb, 'The films ran only on BMWfilms.com, not even on BMW.com or at dealerships', 'BMW Films case',
   'Exclusivity was the point of the campaign, but nothing about the strategy required staying off BMW''s own homepage, auto magazine sites, auto shows, or CDs and DVDs at dealerships.

The distinction worth holding: the registration wall filtered *who* watched, which served the targeting. Refusing additional channels that reached the same target served nothing.', 'Separate the friction that did targeting work from the friction that did not.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bmw5', 'MKTG', 'case_fact', 'case_bmw_films', 2,
   'What did BMW do with the registration data after the campaign?',
   '["Sold it to the participating film directors'' studios", "Identified likely future high earners and invited them to test drives", "Discarded it, since the campaign''s goal was brand image rather than leads", "Used it to set regional dealer inventory levels"]'::jsonb, 'Identified likely future high earners and invited them to test drives', 'BMW Films case',
   'The registration wall produced a profiled list of exactly the people BMW wanted to reach years before they could buy — average viewer aged 30, earning $88K, 63% college-educated.

Mining it for future high earners and keeping them warm with test drives is what turned a brand campaign into a pipeline. The data capture was part of the design, not a by-product.', 'The wall collected something as well as excluding people — ask what BMW did with it.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bmw6', 'MKTG', 'case_fact', 'case_bmw_films', 2,
   'What was BMW''s competitive position immediately before 2000, and how had it got there?',
   '["Recovered from a late-1980s slump, with the highest return on marketing spend among US car makers", "Newly entered in North America and still building a dealer network", "Losing share steadily to Acura, Infiniti and Lexus with no recovery yet", "Leading on volume but spending twice what Lexus did for the same sales"]'::jsonb, 'Recovered from a late-1980s slump, with the highest return on marketing spend among US car makers', 'BMW Films case',
   'Acura, Infiniti and Lexus arrived between 1986 and 1989 with cheaper, genuinely high-quality alternatives and BMW''s sales fell. Recovery from 1992 came through reorganising the dealer network, new models and inventive campaigns including James Bond placements.

By 2000 **Lexus was spending twice what BMW did to sell the same volume**. That earned confidence in unconventional marketing is what made a $30M film project approvable.', 'The last option reverses who was outspending whom.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-bmw7', 'MKTG', 'formula', 'case_bmw_films', 2,
   '"The Hire" drew about 2M registrations and more than 6M views. What does the ratio between those two numbers indicate?',
   '["Roughly three registrations per viewing, suggesting shared accounts", "That the campaign reached 6M distinct people", "That two-thirds of registrants never watched a film", "Roughly three viewings per registered user, suggesting the content held attention"]'::jsonb, 'Roughly three viewings per registered user, suggesting the content held attention', 'BMW Films case',
   '6M+ views across about 2M registrants is roughly **three films each** — registrants came back rather than sampling once and leaving.

That matters for the cost-per-viewer criticism: the $15 buys repeated, voluntary engagement with branded content, which is a different product from a single incidental television exposure.', 'Divide views by registrations and ask what repeat viewing tells you about the content.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ub1', 'MKTG', 'case_fact', 'case_uber_ml', 4,
   'Uber''s pickup journey was broken into six stages. Why was each stage mapped from both the rider''s and the driver''s side?',
   '["A rider problem and a driver problem are often the same event seen twice", "Driver pain was the only side that machine learning could address", "Regulators required both sides to be documented", "Drivers and riders use separate applications with different failure modes"]'::jsonb, 'A rider problem and a driver problem are often the same event seen twice', 'Uber ML case',
   '"The car passed me" and "I can''t see the rider" are one failure described from two seats. Mapping only one side would have produced fixes that shifted cost onto the other.

The journey table is the real deliverable of that stage: "pickups are bad" is unbuildable, while "the ETA keeps updating while the icon spins" is something an engineer can attack.', 'Look at what a single mismatch at the kerb looks like from each seat.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ub2', 'MKTG', 'case_fact', 'case_uber_ml', 4,
   'Uber''s Pickup Quality score weights ETA-versus-actual at 0.30, driver idle time at 0.20, location error at 0.30 and cancellation at 0.20. What is notable about that set of weights?',
   '["Two of the four components measure the driver''s experience, not the rider''s", "All four components are rider-facing, which is why the score is called Pickup Quality", "The weights sum to more than one, so the score is not normalised", "Location error is weighted highest, making it the only component that matters"]'::jsonb, 'Two of the four components measure the driver''s experience, not the rider''s', 'Uber ML case',
   'Driver idle time and cancellation together carry **40%** of the score. A rider-only metric would have optimised the supply side into the ground — drivers absorbing longer waits to make rider numbers look better.

The weights sum to 1.0, but the case is careful to note they were chosen by people. A weighted composite is a choice, not a fact, which is why the follow-up questions ask whether the approach is right and how it would be validated.', 'Sort the four components by whose experience each one measures.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ub3', 'MKTG', 'case_fact', 'case_uber_ml', 4,
   'Why does the case insist the pickup quality metric be computed separately for each of Uber''s five target segments?',
   '["Regulators require segment-level reporting in every market", "Each segment uses a different version of the application", "Blended metrics cannot be computed when the components have different weights", "A single blended metric hides the segment with the worst experience, which is usually the one about to churn"]'::jsonb, 'A single blended metric hides the segment with the worst experience, which is usually the one about to churn', 'Uber ML case',
   'An average across segments can improve while the worst-served segment gets worse, because the larger segments dominate the number.

This is the same discipline the CLV topic applies to customer heterogeneity: a blended figure across genuinely different groups is not the figure for any of them.', 'Ask what an average can conceal about the group at the bottom of it.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ub4', 'MKTG', 'case_fact', 'case_uber_ml', 4,
   'In the build sequence, who leads at each stage?',
   '["The data scientist leads throughout, with the others consulted", "UX defines the problem, business analyst builds the model, data scientist designs the experience", "Data scientist defines the problem, business analyst builds the model, UX designs the experience", "Business analyst defines the problem, data scientist builds the model, UX designs the experience"]'::jsonb, 'Business analyst defines the problem, data scientist builds the model, UX designs the experience', 'Uber ML case',
   '- **Business analyst leads** — define the problem, judge whether ML is appropriate at all, gather and label data
- **Data scientist leads** — preprocess, define features, select the approach, improve the model
- **UX leads** — make the decisions, design the experience

Leadership moves as the work changes. Handing the whole sequence to the data scientist is how a team ends up with an accurate model of the wrong problem.', 'Track which skill the *current* question needs, not which one owns the technology.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ub5', 'MKTG', 'case_fact', 'case_uber_ml', 4,
   '"Evaluate if ML is appropriate" appears as an explicit step. What is the case warning against?',
   '["Using machine learning on problems where the data is proprietary", "Building a model before the training data has been labelled", "Reaching for a model when better map data or a clearer interface would solve the problem", "Allowing the UX team to define the success metric"]'::jsonb, 'Reaching for a model when better map data or a clearer interface would solve the problem', 'Uber ML case',
   'Plenty of pickup failures are fixed without any model at all — a corrected pickup point, a clearer map, a better meeting-point prompt. Starting with ML is the expensive way to discover that.

The step is a genuine decision gate, not a formality, and it sits with the business analyst precisely because it is a business judgement rather than a technical one.', 'Ask what the cheapest fix for a bad pickup point actually is.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ub6', 'MKTG', 'case_fact', 'case_uber_ml', 4,
   'A rider reports "I can''t find my car among all the Ubers." Which stage of the pickup journey is failing?',
   '["Navigate", "Track", "Contextualize", "Meet"]'::jsonb, 'Meet', 'Uber ML case',
   '**Meet** is the final stage, where rider and driver actually find each other. Its driver-side twin is "I can''t find my rider in a crowd."

Naming the stage is what makes the complaint actionable — this is a crowded-pickup identification problem, which is solved with colour codes, PIN matching or a designated meeting point, not with a better ETA model.', 'Place the complaint on the timeline: has the car arrived yet, or is it still on the way?', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ub7', 'MKTG', 'case_fact', 'case_uber_ml', 4,
   'What does the case mean by thinking "glocal" when scaling the pickup experience?',
   '["Pricing should be global while the product stays local", "Local teams should set their own strategy independently of the global one", "A global strategy has to carry local nuance, because the meeting problem differs by place", "Global metrics should replace local ones once a market matures"]'::jsonb, 'A global strategy has to carry local nuance, because the meeting problem differs by place', 'Uber ML case',
   'The "meet" problem in a crowded Mumbai market is not the "meet" problem in suburban California — different density, different addressing, different kerbside behaviour.

Scaling globally therefore means holding the strategy and the metric constant while letting the implementation vary, rather than either shipping one design everywhere or letting each market invent its own.', 'Ask which layer stays fixed across markets and which layer has to flex.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-un1', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
   'United''s VP of Customer Relations offered Dave Carroll a sum he declined, and United later made a donation instead. What were the two figures?',
   '["$2,400 offered, $3,000 donated to a music school", "$2,400 offered, $12,000 donated to a music school", "$3,000 offered, $2,400 donated to a music school", "$1,200 offered, $2,400 donated to a music school"]'::jsonb, '$2,400 offered, $3,000 donated to a music school', 'United Breaks Guitars case',
   'Carroll declined the **$2,400**; United donated **$3,000** to a music school and responded publicly only on Twitter, including the line that 99.95% of bags arrive on time and without incident.

The numbers matter less than the question behind them: what was the objective of compensating him, and what precedent does any figure set for every other broken guitar on every other flight?', 'One number was offered directly and refused; the other went somewhere else entirely.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-un2', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
   'United scored 56 on 2009 customer satisfaction, last among major US airlines, against Southwest''s 81. Why is "United should invest heavily in service" not the expected answer?',
   '["There is an optimal level of service for a segment buying on price, beyond which the spend does not return", "United''s score was already improving, so intervention was unnecessary", "Service quality has no measurable effect on airline profitability", "Satisfaction scores are not comparable across airlines with different route networks"]'::jsonb, 'There is an optimal level of service for a segment buying on price, beyond which the spend does not return', 'United Breaks Guitars case',
   'United''s economy proposition is **affordable connectivity** — mainstream, deliberately not premium. Service costs money, and for a price-driven segment that money comes out of the fare.

The professor''s framing is *optimal*, not maximum: there is a point past which more service stops returning its investment, and stopping there is a decision rather than a failure.', 'Ask who pays for better service, and whether that segment chose the airline for service in the first place.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-un3', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
   'What is vertical differentiation, and how does it apply here?',
   '["Firms deliberately offer different quality levels at different prices when willingness to pay varies", "Firms match the highest service level in the category to avoid losing share", "Firms segment by trip purpose rather than by price sensitivity", "Firms differentiate by route network rather than by service quality"]'::jsonb, 'Firms deliberately offer different quality levels at different prices when willingness to pay varies', 'United Breaks Guitars case',
   'When consumers differ in what they will pay, offering a lower-quality option at a lower price is a strategy, not a failure. Customers who will not pay much get the lower-quality option — and serving them properly at that price is a legitimate position.

It is the formal version of the professor''s point: do what is right for your target segment, not what the internet demands.', 'The word vertical means the options are ranked by quality, not merely different from each other.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-un4', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
   'What is the danger in setting compensation at a level high enough to satisfy a viral complainant?',
   '["It sets a precedent owed to everyone with a camera", "It admits legal liability for the underlying damage", "It breaches the airline''s published tariff conditions", "It signals to competitors what the airline''s service costs are"]'::jsonb, 'It sets a precedent owed to everyone with a camera', 'United Breaks Guitars case',
   'A payment sized to end one public complaint becomes the going rate for the next one. The question to ask first is what the compensation is **for** — repairing a relationship, buying silence, or doing what is fair — because those three objectives imply very different amounts.

Hence the professor''s line: do what is right for you, not what others want you to do.', 'Think past this one claim to the next thousand.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-un5', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
   'United''s public response ran only on Twitter and cited a 99.95% on-time, without-incident baggage rate. Why does that statistic land badly?',
   '["It reveals the number of bags United handles annually", "It answers a complaint about one person''s experience with a population average", "It contradicts the satisfaction scores published the same year", "It understates the airline''s true performance and invites scrutiny"]'::jsonb, 'It answers a complaint about one person''s experience with a population average', 'United Breaks Guitars case',
   'The statistic may well be accurate and still be the wrong reply: the complaint is that *this* bag was broken and nothing was done, and an aggregate rate does not speak to it.

Worth separating from the strategic question, though. The service-level decision can be defensible while the communication is poor — the case wants both judgements, not one substituted for the other.', 'Ask whether the number responds to what was actually being complained about.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-un6', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
   'Which three considerations does the case ask you to weigh on whether United should have improved service?',
   '["The service-profit relationship, vertical differentiation, and who the target segment is", "Brand equity, share of voice, and social media reach", "Legal liability, insurance cover, and regulatory exposure", "Cost per available seat mile, load factor, and on-time performance"]'::jsonb, 'The service-profit relationship, vertical differentiation, and who the target segment is', 'United Breaks Guitars case',
   'Those three together produce the answer the case wants, and each blocks a lazy version of it:

- the **service-profit relationship** asks what the spend returns
- **vertical differentiation** establishes that a lower-quality tier is a legitimate position
- the **target segment** decides whose preferences count

Drop any one and you end up either maximising service or dismissing the complaint entirely.', 'The three are about return on spend, positioning, and whose opinion matters.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-un7', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
   'How long after the incident did Dave Carroll post the song, and what happened next?',
   '["Fifteen days later; United settled immediately and the story ended", "Fifteen months later; United refused to respond publicly at all", "Fifteen months later; he became a celebrity and wrote two more songs", "Three years later; the song attracted little attention"]'::jsonb, 'Fifteen months later; he became a celebrity and wrote two more songs', 'United Breaks Guitars case',
   'The guitar was broken in 2008 on a Halifax-to-Omaha flight and the song appeared **fifteen months later**. Carroll became a celebrity, made a public fuss when a bag went missing on a later United flight, and wrote two more songs.

The gap is worth noticing: this was a slow-burning grievance that a modest resolution at any point in fifteen months would have closed.', 'The delay is long enough to be the most surprising fact in the sequence.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ul1', 'MKTG', 'case_fact', 'case_unilever_brazil', 5,
   'Only 28% of Northeast Brazilian households owned a washing machine against 67% elsewhere. Why does that fact make cleaning power more important to this segment, not less?',
   '["Washing machine ownership correlates with income, which drives all preferences", "Hand-washing uses less detergent, so each unit must be more concentrated", "Hand-washing with soap that yellows clothes makes whitening a core need rather than a premium extra", "Machine owners are less sensitive to detergent quality because machines do the work"]'::jsonb, 'Hand-washing with soap that yellows clothes makes whitening a core need rather than a premium extra', 'Unilever Brazil case',
   'These consumers wash by hand with soap that yellows clothes, so they then need bleach as well. Cleaning power and whitening are the **core need**, and hand-washing makes them matter more.

This is the insight the whole launch turns on: assume low income means "they only want cheap" and you build a stripped-down product that fails on the one dimension they actually care about.', 'Work out what the customer has to do without a machine, and what that does to the job the detergent must perform.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ul2', 'MKTG', 'case_fact', 'case_unilever_brazil', 5,
   'The case distinguishes price sensitive from value conscious. What is the difference?',
   '["They are two names for the same behaviour at different income levels", "Price-sensitive refers to the purchase decision and value-conscious to the repeat decision", "Price-sensitive means resisting high prices; value-conscious means paying for benefits that matter and refusing to pay for ones that do not", "Price-sensitive applies to low-income consumers and value-conscious to high-income ones"]'::jsonb, 'Price-sensitive means resisting high prices; value-conscious means paying for benefits that matter and refusing to pay for ones that do not', 'Unilever Brazil case',
   'Northeast consumers are **both**, and confusing them is the error the case is built to catch.

A value-conscious customer is a more demanding one than a rich customer: they will pay for cleaning power because it does real work for them, and refuse to pay for anything that does not. That is what makes the discipline of leaving benefits out as important as putting them in.', 'One is about the price; the other is about what the price buys.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ul3', 'MKTG', 'case_fact', 'case_unilever_brazil', 5,
   'Unilever chose to create a new brand, Ala, at an incremental cost of $0.10 per kg, against $0.05 to extend an existing brand and $0 to reposition one. Why pay the most?',
   '["Distribution partners refused to carry brand extensions", "Repositioning or extending Omo downward risked damaging the premium brand", "A new brand could be launched faster than a repositioning", "The new brand qualified for a lower tax rate in the Northeast"]'::jsonb, 'Repositioning or extending Omo downward risked damaging the premium brand', 'Unilever Brazil case',
   'Ala was positioned between Minerva''s quality and Campeiro''s cheapness. Pulling Omo down would have damaged the premium brand outright; extending it would have carried the same risk more cheaply, which is not the same as avoiding it.

Protecting Omo was worth ten cents a kilo — and the fact that the most expensive option won on strategic grounds is the point.', 'Ask what the cheaper options put at risk that the expensive one does not.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ul4', 'MKTG', 'case_fact', 'case_unilever_brazil', 5,
   'Beyond the profitability of the Northeast segment, what strategic argument did Unilever make for entering it?',
   '["Leaving the bottom of the market empty hands a competitor a base to attack upward from, as Nirma did in India", "Government incentives required multinationals to serve low-income regions", "The Northeast was expected to overtake the Southeast in detergent volume within five years", "Omo''s premium positioning could not be sustained without a volume brand beneath it"]'::jsonb, 'Leaving the bottom of the market empty hands a competitor a base to attack upward from, as Nirma did in India', 'Unilever Brazil case',
   'Nirma entered India from below, undercut Hindustan Lever on price and took enormous share before the incumbent responded. A premium brand that abandons the bottom of the market does not keep it empty.

So the decision is not only "is this segment profitable?" but "what happens if we leave it to somebody else?" — a defensive argument that survives even a thin margin.', 'The reason is about who else would move in, not about this segment''s own numbers.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ul5', 'MKTG', 'case_fact', 'case_unilever_brazil', 5,
   'In the Ala marketing mix, the Minerva-like option used cardboard packaging at $0.35 while the Campeiro-like option used plastic at $0.10. What does this choice illustrate?',
   '["Packaging cost is immaterial relative to formula cost", "Premium packaging is required to justify a price above 50% of Omo''s", "Every mix element is a cost lever that has to earn its place against the benefits the customer values", "Cardboard is always preferred in low-income markets for environmental reasons"]'::jsonb, 'Every mix element is a cost lever that has to earn its place against the benefits the customer values', 'Unilever Brazil case',
   'The two configurations differ across the board — formula 1.40 against 0.90, price 60% against 50% of Omo, promotion above the line against below, distribution through wholesalers against distributors.

The discipline the case teaches is deliver the important benefits and only those. Packaging that does not change the wash is a candidate to cut; formula strength is not.', 'Ask which mix elements change what the customer gets from the wash and which only change how it looks.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ul6', 'MKTG', 'case_fact', 'case_unilever_brazil', 5,
   'Ala is priced below Omo and will take some Omo volume. Under the BECR test, when does that transfer lose Unilever money?',
   '["When Ala''s volume exceeds Omo''s volume in the Northeast", "When Ala''s price falls below 50% of Omo''s price", "Whenever any Omo volume is lost, since Omo carries the higher margin", "When the actual cannibalisation rate exceeds the break-even rate implied by the two contributions"]'::jsonb, 'When the actual cannibalisation rate exceeds the break-even rate implied by the two contributions', 'Unilever Brazil case',
   'Some cannibalisation is expected and survivable — the test is whether the actual rate clears the break-even rate.

The accompanying discipline is where the volume comes from: new units drawn from competitors or from category expansion are growth, units drawn from Omo are a transfer to a worse margin. A launch forecast that does not say whose units these are has not been finished.', 'Cannibalisation is not automatically a loss — there is a rate at which it becomes one.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-ul7', 'MKTG', 'case_fact', 'case_unilever_brazil', 5,
   'Which summary best captures what the Unilever Brazil case is teaching?',
   '["Enter low-income segments only when a premium brand can be stretched to cover them", "Make what you can sell rather than sell what you can make, and serve low-income consumers as a business rather than as charity", "Match competitor pricing first, then differentiate on product benefits", "Treat low-income segments as a corporate responsibility exercise separate from the P&L"]'::jsonb, 'Make what you can sell rather than sell what you can make, and serve low-income consumers as a business rather than as charity', 'Unilever Brazil case',
   'Marketing to low-income consumers can be profitable, but it is hard and it is **not charity**. It takes willingness to re-engineer the mix and break company norms — the distribution and promotion choices here are not what a premium brand normally does.

And it takes the discipline to deliver the benefits that matter and only those, which is a harder constraint than simply spending less.', 'The framing runs from the customer inward, and it treats the segment as commercial rather than charitable.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-clv1', 'MKTG', 'formula', 'clv', 6,
   'A subscription business earns Rs 1,200 per customer per year in contribution, retains 75% of customers annually and discounts at 10%. What is the lifetime value of a customer it already has?',
   '["Rs 900", "Rs 3,600", "Rs 4,800", "Rs 2,571"]'::jsonb, 'Rs 2,571', 'Session 6',
   'For a customer already acquired, the acquisition cost is sunk:

CLV = m x r / (1 + d − r) = 1,200 x 0.75 / (1 + 0.10 − 0.75) = 1,200 x 0.75 / 0.35 = **Rs 2,571**.

Rs 4,800 comes from dividing by (1 − r) and ignoring the discount rate; Rs 3,600 assumes a flat three-year life with no churn and no discounting at all.', 'Use the existing-customer form — no acquisition cost — and keep the discount rate in the denominator.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-clv2', 'MKTG', 'formula', 'clv', 6,
   'The same business spends Rs 2,000 to acquire a new customer, with no immediate margin at signup. What is that new customer worth?',
   '["Rs 2,571", "Rs 4,571", "Rs 571", "−Rs 800"]'::jsonb, 'Rs 571', 'Session 6',
   'CLV for a not-yet-acquired customer subtracts the acquisition cost:

2,571 − 2,000 = **Rs 571**.

Still positive, so acquiring is worth doing — but the margin for error is much thinner than the Rs 2,571 figure suggests. The two formulas differ only in whether you have already paid to acquire the customer.', 'Start from the existing-customer value, then charge the acquisition cost against it.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-clv3', 'MKTG', 'case_fact', 'clv', 6,
   'A plan reports CLV of Rs 5,000 per customer. On inspection, the analyst summed five years of contribution and subtracted acquisition cost, with no other adjustment. Which error most likely inflates the figure?',
   '["Five years is too short a horizon for a subscription business", "Acquisition cost should not have been subtracted at all", "Retention was omitted, so every customer is assumed to still be there in year five", "The discount rate was omitted, which is the larger of the two effects"]'::jsonb, 'Retention was omitted, so every customer is assumed to still be there in year five', 'Session 6',
   'Working the standard example through: $850 with no churn and no discounting, $272 once churn is applied, $131 once both are. Almost all of the collapse is **churn**, not discounting.

Forgetting the retention factor overstates CLV roughly threefold, which makes it the first thing to check when a lifetime value looks too good. If a plan''s CLV has no r in it anywhere, that is the bug.', 'Two adjustments are missing; ask which one moves the number more.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-clv4', 'MKTG', 'formula', 'clv', 6,
   'A firm improves annual retention from 70% to 80% while contribution stays at Rs 1,000 and the discount rate at 10%. By how much does the lifetime value of an existing customer rise?',
   '["From Rs 2,333 to Rs 2,667, a rise of Rs 334", "From Rs 1,750 to Rs 2,667, a rise of Rs 917", "From Rs 700 to Rs 800, a rise of Rs 100", "From Rs 1,750 to Rs 2,000, a rise of Rs 250"]'::jsonb, 'From Rs 1,750 to Rs 2,667, a rise of Rs 917', 'Session 6',
   '- At r = 0.70: 1,000 x 0.70 / (1.10 − 0.70) = 1,000 x 0.70 / 0.40 = **Rs 1,750**
- At r = 0.80: 1,000 x 0.80 / (1.10 − 0.80) = 1,000 x 0.80 / 0.30 = **Rs 2,667**

Ten points of retention adds **Rs 917**, over half the original value. Retention sits in the denominator next to the discount rate but moves the answer far more, because it compounds against every future year at once.', 'Retention appears in both the numerator and the denominator, which is why its effect is so large.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-clv5', 'MKTG', 'case_fact', 'clv', 6,
   'Why is a blended CLV computed across a customer base with widely differing retention and margin described as "not the CLV of anybody"?',
   '["It overstates value for every customer in the base", "It cannot be computed when retention rates differ across customers", "It uses the mean rather than the median retention rate", "It averages what are effectively two different businesses into a number describing neither"]'::jsonb, 'It averages what are effectively two different businesses into a number describing neither', 'Session 6',
   'If one group churns fast on thin margins and another stays for years on fat ones, the blended figure sits between two realities and matches neither. Decisions taken on it will over-invest in the weak group and under-invest in the strong one.

This is the same problem the Uber case raises about a single blended pickup-quality metric across five segments.', 'Picture two very different groups and ask who the average actually describes.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-clv6', 'MKTG', 'case_fact', 'clv', 6,
   'What decisions is CLV computed in order to make?',
   '["How to forecast next quarter''s revenue", "How and when to acquire, retain, fire a customer, or buy an entire customer base", "How to allocate advertising between media channels", "How to set the list price of a new product"]'::jsonb, 'How and when to acquire, retain, fire a customer, or buy an entire customer base', 'Session 6',
   'The one people forget is **firing**. If a segment''s lifetime value is negative, serving them better is not the answer — the answer is to stop serving them, or to change the terms on which you do.

CLV also works as a valuation signal: in streaming it tracks market capitalisation closely enough that subscriber numbers move share prices.', 'Four decisions, and one of them involves ending a customer relationship on purpose.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-clv7', 'MKTG', 'case_fact', 'clv', 6,
   'Which of these does the standard CLV formula quietly assume away?',
   '["That contribution is measured after variable costs", "That the discount rate reflects the firm''s cost of capital", "That customers can be acquired at a known cost", "That contribution and retention both stay constant over the customer''s life"]'::jsonb, 'That contribution and retention both stay constant over the customer''s life', 'Session 6',
   'The closed form needs constant m, r and d. In reality contribution often rises as customers spend more or cost less to serve, and retention drifts — upward with lock-in, downward with dissatisfaction.

Along with customer heterogeneity, these are the assumptions to name when asked what the number leaves out. They do not make CLV useless; they make it a model whose limits you should be able to state.', 'Look at which inputs the closed form requires to hold still.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-evc1', 'MKTG', 'formula', 'evc', 7,
   'A machine tool lasts twice as long as the incumbent, which sells for Rs 40,000. The new tool also saves Rs 6,000 in annual maintenance over its life but requires Rs 5,000 of extra training. What is its EVC?',
   '["Rs 41,000", "Rs 46,000", "Rs 81,000", "Rs 51,000"]'::jsonb, 'Rs 81,000', 'Session 7',
   '- Reference value = what the customer would otherwise spend to get the same service. Two incumbent machines: **Rs 80,000**
- Net differential value = extra benefits − extra costs = 6,000 − 5,000 = **Rs 1,000**

EVC = 80,000 + 1,000 = **Rs 81,000**.

Rs 46,000 uses one incumbent machine as the reference and so ignores the doubled life, which is where most of the value is.', 'Reference value is the cost of matching your product using the customer''s next-best alternative — including buying it more than once.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-evc2', 'MKTG', 'case_fact', 'evc', 7,
   'In EVC analysis, what roles do the EVC figure and the seller''s variable cost play?',
   '["EVC is the recommended price and variable cost is the break-even price", "EVC is the price ceiling and variable cost is the price floor", "EVC is the price floor and variable cost is the price ceiling", "Both are floors, with the higher of the two binding"]'::jsonb, 'EVC is the price ceiling and variable cost is the price floor', 'Session 7',
   'EVC is the most the customer could rationally pay before the alternative becomes better value; variable cost is the least the seller can accept. The negotiation lives between them, and the recommendation is usually a split of that range.

Pricing at the ceiling captures all the value created and leaves the customer no reason to switch, which is why nobody actually recommends it.', 'One is set by the customer''s alternative, the other by the seller''s economics.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-evc3', 'MKTG', 'case_fact', 'evc', 7,
   'Why does EVC start from the customer''s next-best alternative rather than from the seller''s cost?',
   '["Variable cost changes with volume and so cannot anchor a price", "What the product cost to make has no bearing on what it is worth to the buyer", "Regulators require value-based justification for premium pricing", "Cost data is usually unavailable at the time pricing decisions are made"]'::jsonb, 'What the product cost to make has no bearing on what it is worth to the buyer', 'Session 7',
   'The question EVC answers is what the customer would do if you did not exist, and what that would cost them. Answer that honestly and the price largely sets itself.

Cost-plus asks a question the buyer does not care about, which is why it leaves money on the table whenever the product creates unusual value — and why it overprices whenever the product does not.', 'Ask whose position determines what the product is worth.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-evc4', 'MKTG', 'formula', 'evc', 7,
   'A software licence costs Rs 200,000 a year against a competitor at Rs 150,000. It saves two staff positions worth Rs 90,000 combined, but adds Rs 20,000 of integration cost. What is the EVC, and is the asking price defensible?',
   '["EVC is Rs 180,000, so Rs 200,000 exceeds the ceiling and is not defensible", "EVC is Rs 220,000, so Rs 200,000 sits below the ceiling and is defensible", "EVC is Rs 150,000, so Rs 200,000 exceeds the ceiling and is not defensible", "EVC is Rs 240,000, so Rs 200,000 sits below the ceiling and is defensible"]'::jsonb, 'EVC is Rs 220,000, so Rs 200,000 sits below the ceiling and is defensible', 'Session 7',
   '- Reference value = **Rs 150,000**, the competitor''s price
- Net differential value = 90,000 − 20,000 = **Rs 70,000**

EVC = 150,000 + 70,000 = **Rs 220,000**. The Rs 200,000 asking price leaves Rs 20,000 of value with the customer, which is what gives them a reason to switch.

Rs 240,000 forgets to net off the integration cost — extra costs the customer bears reduce the value you created, they do not sit outside the calculation.', 'Net differential value is benefits minus the extra costs the customer takes on, not benefits alone.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-evc5', 'MKTG', 'case_fact', 'evc', 7,
   'Communicating EVC to a customer usually requires more than stating the number. Why?',
   '["Customers respond to price anchors rather than to value arguments", "The customer will run their own numbers and reach a more conservative figure", "The calculation is proprietary and cannot be shared", "EVC is only valid for industrial products, not services"]'::jsonb, 'The customer will run their own numbers and reach a more conservative figure', 'Session 7',
   'Claimed savings often fail to materialise in the customer''s own accounting — labour savings are zero if existing staff simply absorb the work. Buyers know this and discount accordingly.

Hence the standard practice of conceding part of the value deliberately, as Atlantic does by applying a 2x multiplier rather than 4x. A number the customer can verify beats a larger number they distrust.', 'Ask what happens when the buyer redoes your arithmetic with their own assumptions.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-evc6', 'MKTG', 'formula', 'evc', 7,
   'A consumable is cheaper per unit than the incumbent but customers use 30% more of it. Where does that show up in the EVC calculation?',
   '["As an increase in reference value, since more units are consumed", "As a reduction in the seller''s variable cost floor", "It does not enter EVC, which considers purchase price only", "As a negative element of net differential value, reducing EVC below the reference value"]'::jsonb, 'As a negative element of net differential value, reducing EVC below the reference value', 'Session 7',
   'Net differential value is extra benefits **minus** extra costs, and it can be negative. Higher consumption is a real cost the customer bears, so the EVC ends up below the reference value — meaning the product must be priced below the incumbent to be worth switching to.

This is the case where EVC saves you from a mistake rather than justifying a premium.', 'Net differential value has a sign; nothing requires it to be positive.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-evc7', 'MKTG', 'case_fact', 'evc', 7,
   'What is the single most valuable question EVC is built to answer?',
   '["What price will maximise our unit volume?", "What would this customer do if we did not exist, and what would that cost them?", "What margin do we need to cover our fixed costs?", "What are competitors charging for a comparable product?"]'::jsonb, 'What would this customer do if we did not exist, and what would that cost them?', 'Session 7',
   'That question forces the analysis onto the customer''s alternative, which is where the value actually lives. Everything else in EVC — reference value, net differential value, the ceiling — is machinery for answering it.

The competitor''s price is an input to that question, not the question itself, which is the difference between value-based pricing and simply matching the market.', 'The question is about the customer''s world without you in it.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-at1', 'MKTG', 'case_fact', 'case_atlantic_computer', 8,
   'One Atlantic bundle does the work of two Zinc servers, and Zinc''s status-quo price is $2,000. What does pricing the bundle as a single server imply?',
   '["Atlantic charges twice the price for the same delivered capability", "Atlantic matches Zinc''s price per unit of capability", "Atlantic charges half price for the same delivered capability", "Atlantic prices below its own variable cost"]'::jsonb, 'Atlantic charges half price for the same delivered capability', 'Atlantic Computer case',
   'The customer needs two Zinc servers to get what one Atlantic bundle delivers. Priced as one server against Zinc''s $2,000, Atlantic is charging $2,000 for something worth $4,000 in Zinc terms.

That gap is the case in one sentence, and it is invisible if you price from cost rather than from what the customer would otherwise have to buy.', 'Count how many competitor machines the customer would need, then compare like with like.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-at2', 'MKTG', 'formula', 'case_atlantic_computer', 8,
   'Under the value-in approach, one Atlantic bundle costs the customer $5,000 in total while two Zinc servers cost $9,400. What price does this produce?',
   '["$4,200", "$4,400", "$2,431", "$2,200"]'::jsonb, '$4,200', 'Atlantic Computer case',
   'Extra value created = 9,400 − 5,000 = $4,400. Split evenly, the customer keeps half:

4,400 / 2 = $2,200 above the $2,000 reference = **$4,200**.

$2,200 is the shared value on its own, before adding the reference price it sits on top of. $2,431 is the EVC-based answer, which anchors on variable cost instead of on the market price.', 'Value-in builds on the current market price — work out the shared value, then add the reference.', 3, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-at3', 'MKTG', 'case_fact', 'case_atlantic_computer', 8,
   'The EVC-based and value-in approaches give different prices for the same bundle. What distinguishes them?',
   '["EVC assumes Zinc responds while value-in assumes it does not", "EVC includes the software while value-in prices hardware only", "EVC is calculated over three years and value-in over one", "EVC anchors on Atlantic''s variable cost as the floor; value-in anchors on the current market price"]'::jsonb, 'EVC anchors on Atlantic''s variable cost as the floor; value-in anchors on the current market price', 'Atlantic Computer case',
   'EVC starts from the $1,538 variable cost as a floor and works up to a defensible number; value-in starts from what the market already pays and splits the extra value created.

Value-in **always** produces the higher figure, because the market price is above Atlantic''s cost. Both are legitimate — the requirement is to say which one you used and why, since a number presented without its anchor is what gets challenged.', 'Ask what each method treats as its starting point.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-at4', 'MKTG', 'case_fact', 'case_atlantic_computer', 8,
   'Atlantic applies a 2x multiplier to the value created rather than 4x. What is the reasoning?',
   '["Customers will discount claimed savings, so conceding value up front makes the price defensible", "Zinc''s expected price cut halves the value created", "Regulatory limits cap value-based premiums at twice the reference price", "The bundle replaces two servers, so 2x is the arithmetically correct multiplier"]'::jsonb, 'Customers will discount claimed savings, so conceding value up front makes the price defensible', 'Atlantic Computer case',
   'Labour savings may be zero if existing staff simply absorb the extra servers, and customers know it. They will run their own numbers and get smaller ones.

Deliberately conceding part of the value allows for that conservatism and produces a price the customer can verify, rather than one they will argue with. The multiplier is a negotiating judgement, not a calculation.', 'The multiplier is about how the customer will react to the claim, not about the engineering.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-at5', 'MKTG', 'case_fact', 'case_atlantic_computer', 8,
   'PESA was previously given away free and would now carry a charge of roughly $1,400. Which reactions should the pricing recommendation anticipate?',
   '["A regulatory review of bundled pricing", "Sales force enthusiasm, since a priced product is easier to sell than a free one", "Immediate acceptance, since the value case is arithmetically sound", "Customer backlash and requests for evaluation contracts, plus a Zinc price cut"]'::jsonb, 'Customer backlash and requests for evaluation contracts, plus a Zinc price cut', 'Atlantic Computer case',
   'Charging for something that used to be free produces resistance regardless of the value case, and buyers will want to trial before committing. Zinc may cut from $1,700 to $1,200–$1,400, and may build competing performance software.

Atlantic''s own sales force is part of the problem too — they would rather keep giving PESA away because it makes selling easy. A price recommendation that ignores how everyone reacts is half an answer.', 'List everyone whose behaviour changes when the price changes, including people inside Atlantic.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-at6', 'MKTG', 'case_fact', 'case_atlantic_computer', 8,
   'The professor notes that even if Zinc cut its margin to zero, the Atlantic bundle still creates more value for the customer. Why does that matter?',
   '["It means Atlantic can price at the full EVC without resistance", "It shows the value advantage is structural rather than a pricing artefact", "It removes the need to model a competitive response", "It proves Zinc will exit the market"]'::jsonb, 'It shows the value advantage is structural rather than a pricing artefact', 'Atlantic Computer case',
   'If the advantage survives the most aggressive price response available to the competitor, it comes from the product doing the work of two machines rather than from a temporary price position.

That is the reassuring conclusion of the case, and it holds only so long as the value is real rather than asserted — which is why the labour-savings assumption gets so much scrutiny.', 'Ask what the claim survives, and what it depends on to stay true.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-at7', 'MKTG', 'case_fact', 'case_atlantic_computer', 8,
   'What does the case say the exam is actually testing on Atlantic Computer?',
   '["The internal politics of Cadena''s sales organisation", "The three-year revenue forecast under each pricing option", "The concept — EVC as a ceiling, value-in-use against the incumbent, and the competitive response", "Recall of the four pricing approaches and their exact dollar outputs"]'::jsonb, 'The concept — EVC as a ceiling, value-in-use against the incumbent, and the competitive response', 'Atlantic Computer case',
   'The case trivia is not the point. What transfers is that EVC sets a **ceiling**, that the metric is value-in-use savings measured against the incumbent, and that a price recommendation is incomplete without saying how competitors and customers will react.

The dollar figures are worth knowing as worked illustrations of that structure, not as facts to recall on their own.', 'Separate what is specific to Atlantic from what you would carry into any pricing decision.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pe1', 'MKTG', 'formula', 'pricing_elasticity', 8,
   'A product faces a price elasticity of demand of 2.5. What optimal percentage margin does the golden rule of pricing imply?',
   '["40%", "25%", "2.5%", "60%"]'::jsonb, '40%', 'Session 8',
   'The rule says percent margin equals one over elasticity:

(p − mc) / p = 1 / 2.5 = **40%**.

The more price-sensitive the customer, the lower the optimal margin — at an elasticity of 4 the optimal margin falls to 25%, and at 10 it is only 10%.', 'Invert the elasticity; the answer is a margin, not a price.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pe2', 'MKTG', 'formula', 'pricing_elasticity', 8,
   'A product has a marginal cost of Rs 60 and faces an elasticity of 4. What is the optimal price?',
   '["Rs 240", "Rs 75", "Rs 80", "Rs 100"]'::jsonb, 'Rs 80', 'Session 8',
   'Optimal margin = 1 / 4 = 25%, so price = mc / (1 − margin) = 60 / 0.75 = **Rs 80**.

Check: (80 − 60) / 80 = 25%.

Rs 75 comes from marking the cost up by 25% rather than solving for a 25% margin — the same margin-versus-markup trap from Session 3, now inside a pricing question.', 'The rule gives you a margin; converting a margin to a price means dividing by one minus it.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pe3', 'MKTG', 'formula', 'pricing_elasticity', 8,
   'Two segments buy the same product. Segment A has an elasticity of 2 and Segment B an elasticity of 5. What does the golden rule imply?',
   '["A should carry a 2% margin and B a 5% margin", "Both should carry the same margin, since the product is identical", "A should carry a 20% margin and B a 50% margin", "A should carry a 50% margin and B a 20% margin"]'::jsonb, 'A should carry a 50% margin and B a 20% margin', 'Session 8',
   '- Segment A: 1 / 2 = **50%**
- Segment B: 1 / 5 = **20%**

The less price-sensitive segment supports the higher margin. This is the formal basis for charging different segments different prices for the same good — the margin should follow the segment''s elasticity, not the product''s cost.', 'Apply the rule separately to each elasticity and notice which direction the margin moves.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pe4', 'MKTG', 'case_fact', 'pricing_elasticity', 8,
   'What does the golden rule of pricing say in plain language?',
   '["Price should be set at twice marginal cost in most markets", "Margin should equal elasticity, so more elastic products carry higher margins", "The higher your fixed costs, the higher your optimal margin", "The more price-sensitive your customers, the lower your optimal price and margin"]'::jsonb, 'The more price-sensitive your customers, the lower your optimal price and margin', 'Session 8',
   'Percent margin equals one over elasticity, so margin and price sensitivity move in opposite directions.

The reading to hold onto: elasticity is a property of the customer, not of the product, so the same item sold to two different segments can rationally carry two different margins.', 'Read the formula as a relationship between two quantities and ask which way it points.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pe5', 'MKTG', 'case_fact', 'pricing_elasticity', 8,
   'An analyst computes an optimal margin of 120% from an elasticity below 1. What has gone wrong?',
   '["An elasticity below 1 means demand is inelastic, and the firm is not yet at a profit-maximising price", "The formula requires elasticity to be expressed as a negative number", "Marginal cost has been confused with average cost", "The elasticity has been measured over too short a period"]'::jsonb, 'An elasticity below 1 means demand is inelastic, and the firm is not yet at a profit-maximising price', 'Session 8',
   'The rule produces a margin above 100%, which is impossible — that is the formula reporting that the situation is inconsistent with profit maximisation rather than giving an answer.

With inelastic demand, raising price increases revenue *and* cuts volume-driven costs, so the firm should keep raising price until elasticity rises past 1. An impossible output is information, not a calculation error.', 'Ask what an impossible answer is telling you about the firm''s current price.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pe6', 'MKTG', 'formula', 'pricing_elasticity', 8,
   'The golden rule of advertising says ad spend as a share of revenue equals percent margin multiplied by advertising elasticity. A brand has a 40% margin and an advertising elasticity of 0.15. What share of revenue should it spend?',
   '["2.7%", "15%", "40%", "6%"]'::jsonb, '6%', 'Session 8',
   'A / pQ = margin x advertising elasticity = 0.40 x 0.15 = **6%** of revenue.

Both terms matter: a high-margin brand can afford to advertise more because each incremental sale is worth more, and a brand whose sales actually respond to advertising should spend more than one whose sales do not.', 'Multiply the two rates; the answer is a share of revenue, not of profit.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pe7', 'MKTG', 'case_fact', 'pricing_elasticity', 8,
   'Why do the golden rules of pricing and advertising both feature the percentage margin?',
   '["Margin appears only by convention and could be replaced by markup", "Margin is the only variable both marketing and finance agree on", "Margin measures what an incremental unit is worth, which sets what winning one is worth spending", "Margin is a proxy for elasticity in both formulas"]'::jsonb, 'Margin measures what an incremental unit is worth, which sets what winning one is worth spending', 'Session 8',
   'A firm with a fat margin gains more from each extra sale, so it should both price for it and spend more to win it. A thin-margin firm should do neither.

Seeing the same term in both rules is a useful check that you are reading them as economics rather than as formulas to memorise — margin is the price of an incremental customer in both.', 'Ask what margin represents economically, then why that quantity would drive both decisions.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-af1', 'MKTG', 'case_fact', 'case_air_france', 9,
   'Some Air France campaigns showed returns above 1000%. Why is suspicion the correct first reaction?',
   '["The figures cover only the highest-performing keywords", "The figures reflect attribution error — customers who would have booked anyway clicked the paid link", "The figures are reported in a different currency from the campaign spend", "The figures exclude the cost of the clicks that did not convert"]'::jsonb, 'The figures reflect attribution error — customers who would have booked anyway clicked the paid link', 'Air France case',
   'Someone intending to fly Air France searches for it, clicks the paid link sitting above the organic one, and books. The campaign takes credit for a booking it did not cause.

The transferable lesson: in digital marketing the easiest number to produce is the one most likely to be wrong, because attribution is a modelling assumption dressed up as a measurement.', 'Ask what the customer would have done if the paid advertisement had not been there.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-af2', 'MKTG', 'case_fact', 'case_air_france', 9,
   'A publisher shows a low click-through rate. Where does the diagnostic point, and to which team?',
   '["An advertisement problem — fix the copy and the keyword match", "An attribution problem — fix the measurement before acting", "A website problem — fix the landing page and booking flow", "A pricing problem — fix the fare displayed in the advertisement"]'::jsonb, 'An advertisement problem — fix the copy and the keyword match', 'Air France case',
   'People saw the advertisement and did not click, so the failure happened before they ever reached the site. Low **TCR** is the opposite case: they clicked and then did not book, which is a website problem.

That split is the most reusable idea in the case, because it tells you which team to send the work to. Treating a low conversion rate as an advertising failure wastes months.', 'Locate where in the funnel the drop-off happens, then ask who owns that step.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-af3', 'MKTG', 'case_fact', 'case_air_france', 9,
   'Kayak charged a flat listing fee while Google, Yahoo and MSN used bid-based cost per click. Why does that complicate the comparison?',
   '["A fixed-fee channel and an auction channel have different economics, so raw return is not comparable", "Flat fees are treated as fixed costs and so cannot enter a return calculation", "Kayak''s traffic volume was too small to produce a reliable return figure", "Kayak reported conversions on a different time lag"]'::jsonb, 'A fixed-fee channel and an auction channel have different economics, so raw return is not comparable', 'Air France case',
   'In an auction the marginal cost of the next click is bid up; under a flat fee the marginal click is free once the fee is paid. Those produce different optimal behaviour, so ranking the two channels on return alone compares two different things.

Whether to keep Kayak turns on that structural difference rather than on its headline return.', 'Ask what the next click costs under each pricing structure.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-af4', 'MKTG', 'case_fact', 'case_air_france', 9,
   'What makes digital advertising genuinely different from traditional media, in the case''s framing?',
   '["Near-real-time data means a recommendation can be tested cheaply instead of committed to", "Digital reaches a larger audience for the same spend", "Digital campaigns require no creative development", "Digital attribution is more reliable than traditional media measurement"]'::jsonb, 'Near-real-time data means a recommendation can be tested cheaply instead of committed to', 'Air France case',
   'Campaigns can be halted or modified instantly, so testing is low-risk. In traditional media the entire spend is committed before anything is learned.

This changes what a good recommendation looks like: not "here is the answer" but "here is the test, here is what we will learn, and here is when we will stop."', 'The difference is about what you can do after launching, not about reach or cost.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-af5', 'MKTG', 'case_fact', 'case_air_france', 9,
   'Which metrics does the case work with?',
   '["CPC, CTR and TCR, plus ROA, average revenue per booking and probability of booking", "CLV, retention rate and acquisition cost", "Trial rate, repeat rate and awareness", "GRP, reach and frequency, plus cost per thousand impressions"]'::jsonb, 'CPC, CTR and TCR, plus ROA, average revenue per booking and probability of booking', 'Air France case',
   'Cost per click, click-through rate and total conversion rate are the standard digital set; the case adds return on advertising, average revenue per booking and probability of booking.

The suggested diagnostic segments publishers by **probability of booking multiplied by CPC**, which combines how likely a click is to convert with what that click costs.', 'The other options belong to broadcast media, customer value and new-product forecasting respectively.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-af6', 'MKTG', 'case_fact', 'case_air_france', 9,
   'What is the optimisation sequence the case recommends?',
   '["Optimise campaign strategy, optimise publisher strategy, summarise metrics, calculate KPI impact", "Summarise campaign metrics, calculate KPI impact, optimise publisher strategy, optimise campaign strategy", "Summarise campaign metrics, optimise publisher strategy, optimise campaign strategy, calculate KPI impact", "Calculate KPI impact, summarise campaign metrics, optimise campaign strategy, optimise publisher strategy"]'::jsonb, 'Summarise campaign metrics, optimise publisher strategy, optimise campaign strategy, calculate KPI impact', 'Air France case',
   'Measure first, then work from the broader decision to the narrower one — which publishers to be on before how to run campaigns within them — and quantify the impact last.

Doing it in the reverse order produces campaign tuning inside publishers you should not be using at all.', 'Work from measurement, through the wider decision, to the narrower one, and quantify at the end.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-af7', 'MKTG', 'formula', 'case_air_france', 9,
   'A publisher shows a healthy click-through rate but a poor total conversion rate. What should the recommendation address?',
   '["The advertisement copy and keyword match, since the clicks are low quality", "The bid level, since the cost per click is too high", "The attribution model, since the conversion figure cannot be trusted", "The landing and booking experience, since the advertisement is already doing its job"]'::jsonb, 'The landing and booking experience, since the advertisement is already doing its job', 'Air France case',
   'People clicked, so the advertisement earned its attention. They then failed to book, which happens on the site.

The temptation is to rewrite the advertisement because that is the marketing team''s own work, but the funnel says the loss is downstream. Sending the fix to the wrong team is exactly what the CTR-versus-TCR split exists to prevent.', 'Follow the funnel: the customer already got past the advertisement.', 2, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-grp1', 'MKTG', 'formula', 'grp_advertising', 9,
   'A media plan delivers 40% reach at an average frequency of 2.5. What is the GRP?',
   '["16", "42.5", "1,000", "100"]'::jsonb, '100', 'Session 9',
   'GRP = reach x frequency = 40 x 2.5 = **100**.

Reach is the share of the target audience exposed at least once; frequency is how many times each of them sees it on average. The product is expressed in rating points, not as a percentage.', 'Multiply the two; reach stays in percentage points.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-grp2', 'MKTG', 'formula', 'grp_advertising', 9,
   'A campaign achieves 300 GRPs at an average frequency of 5. What reach did it deliver?',
   '["15%", "60%", "150%", "1,500%"]'::jsonb, '60%', 'Session 9',
   'Reach = GRP / frequency = 300 / 5 = **60%**.

The rearrangement is the useful direction: a media planner is usually told the budget in GRPs and has to work out what audience it will actually cover.', 'Divide rather than multiply, and sanity-check that reach cannot exceed 100%.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-grp3', 'MKTG', 'case_fact', 'grp_advertising', 9,
   'Two plans both deliver 120 GRPs. Plan A is 60% reach at frequency 2; Plan B is 20% reach at frequency 6. What does the identical GRP figure conceal?',
   '["Plan B costs three times as much to deliver", "Plan A cannot be achieved with a single medium", "They cover very different audiences — A reaches three times as many people, B repeats to fewer", "Nothing — equal GRPs mean equal effectiveness"]'::jsonb, 'They cover very different audiences — A reaches three times as many people, B repeats to fewer', 'Session 9',
   'GRP is a product, so it collapses two quite different plans into one number. A reaches 60% of the target twice; B reaches 20% six times.

Which is better depends on the objective — building awareness in a new category favours reach, while driving recall of a complex message favours frequency. This is exactly why "60 GRPs" alone cannot tell you whether a plan is good.', 'Two numbers multiply into one, so ask what the single number cannot tell you about its factors.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-grp4', 'MKTG', 'formula', 'grp_advertising', 9,
   'A brand needs 250 GRPs and can buy spots delivering 10 rating points each at Rs 400,000 per spot. What is the campaign cost?',
   '["Rs 1,000,000", "Rs 10,000,000", "Rs 100,000,000", "Rs 25,000,000"]'::jsonb, 'Rs 10,000,000', 'Session 9',
   'Spots required = 250 / 10 = **25 spots**. Cost = 25 x 400,000 = **Rs 10,000,000**.

This is how a GRP target becomes a budget, and it is the step that makes the Parfitt-Collins awareness calculation actionable — an awareness goal turns into rating points, and rating points turn into money.', 'Convert the GRP target into a number of spots first, then price them.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-grp5', 'MKTG', 'case_fact', 'grp_advertising', 9,
   'What does GRP not capture?',
   '["The total weight of the media schedule", "Whether the audience reached is the right audience, or whether the message worked", "The average number of exposures per person reached", "How many people saw the advertisement at least once"]'::jsonb, 'Whether the audience reached is the right audience, or whether the message worked', 'Session 9',
   'GRP measures delivered weight against a defined target — nothing about whether the target was well chosen, whether the creative landed, or whether anyone acted.

That is why "is 60 GRPs a good plan?" has no answer on its own. It is an input measure, and treating it as an outcome is how campaigns get judged on volume rather than effect.', 'Ask which of these GRP is definitionally made of, and which sits outside the definition.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-grp6', 'MKTG', 'formula', 'grp_advertising', 9,
   'A plan reaches 30% of the target audience with 4 exposures and a second flight reaches a further 25% with 2 exposures. What are the total GRPs?',
   '["55", "120", "170", "50"]'::jsonb, '170', 'Session 9',
   'GRPs add across flights:

- First flight: 30 x 4 = 120
- Second flight: 25 x 2 = 50

Total = **170 GRPs**.

Note what you cannot do: total reach is not 55%, because the two flights may hit the same people. Rating points add; reach does not.', 'Compute each flight''s rating points and add them — but resist adding the reach figures.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-grp7', 'MKTG', 'case_fact', 'grp_advertising', 9,
   'Why is reach usually the priority for a new product launch rather than frequency?',
   '["New products have higher advertising elasticity than established ones", "Frequency is more expensive per rating point than reach", "Frequency only matters once repeat purchase has been established", "Nobody can try a product they have never heard of, so the first exposure does the most work"]'::jsonb, 'Nobody can try a product they have never heard of, so the first exposure does the most work', 'Session 9',
   'In the Parfitt-Collins chain, awareness is the first gate and it multiplies with trial and repeat. Reaching more people moves the first term; repeating to the same people does much less once they already know.

The balance shifts later — an established brand with a complex or easily forgotten message often gets more from frequency.', 'Think about which gate in the awareness-trial-repeat chain a first exposure opens.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pc1', 'MKTG', 'formula', 'parfitt_collins', 9,
   'A new snack achieves 60% awareness, 25% trial among those aware, and a 40% repeat rate. What market share does Parfitt-Collins predict?',
   '["10%", "60%", "6%", "12.5%"]'::jsonb, '6%', 'Session 9',
   'Share = 0.60 x 0.25 x 0.40 = **6%**.

The model multiplies, so each gate scales down what came before. Awareness of 60% sounds strong on its own and still ends at a single-digit share once the other two gates are applied.', 'Multiply all three rates as decimals, and check the result is smaller than the smallest of them.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pc2', 'MKTG', 'formula', 'parfitt_collins', 9,
   'A brand needs 4% share to break even. Trial is 25% and repeat is 32%. What awareness must the media plan buy?',
   '["12.8%", "32%", "50%", "40%"]'::jsonb, '50%', 'Session 9',
   'Awareness = target share / (trial x repeat) = 0.04 / (0.25 x 0.32) = 0.04 / 0.08 = **50%**.

This is the objectives-and-task method: start from the share you need, work back to the awareness required, then price the media that delivers it. The output is a media brief rather than an argument about spending more.', 'Rearrange to isolate awareness, and keep every rate in decimals throughout.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pc3', 'MKTG', 'case_fact', 'parfitt_collins', 9,
   'A calculation returns a required awareness of 130%. What does that result mean?',
   '["The brand needs to advertise in more than one medium", "The target share was set too low", "The awareness figure should be capped at 100% and the plan proceeds", "The plan is impossible, and the problem lies in trial or repeat rather than in media"]'::jsonb, 'The plan is impossible, and the problem lies in trial or repeat rather than in media', 'Session 9',
   'No budget buys more than total awareness, so the model is reporting that the target share cannot be reached through advertising at these trial and repeat rates.

That is the genuinely valuable output. Trial and repeat are product, pricing and experience problems, and a brand with a 10% repeat rate does not have an advertising problem — spending more simply pours people into a leaking bucket faster.', 'An impossible number is a finding, not an error; ask which input has to change.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pc4', 'MKTG', 'case_fact', 'parfitt_collins', 9,
   'Why does it matter that the three Parfitt-Collins rates multiply rather than add?',
   '["It ensures the predicted share can never exceed the awareness level", "A failure at any one gate collapses share regardless of how well the other two performed", "Multiplication makes the model easier to rearrange algebraically", "It allows the rates to be measured independently of one another"]'::jsonb, 'A failure at any one gate collapses share regardless of how well the other two performed', 'Session 9',
   'Perfect awareness with a product nobody re-buys gives you almost nothing. There is no compensating: a strong result on two gates cannot rescue a weak third.

It also means improvement effort should go to the weakest gate, since a proportional gain there moves the product by more than the same gain anywhere else.', 'Ask what happens to a product of three numbers when one of them approaches zero.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pc5', 'MKTG', 'case_fact', 'parfitt_collins', 9,
   'A brand has 80% awareness, 30% trial and 15% repeat, giving a 3.6% share. Management wants 6%. Which lever is most credible?',
   '["Awareness, because it is the only gate advertising controls", "Trial, because it sits between the other two", "None — the target requires awareness above 100%", "Repeat, because it is the weakest gate and the one the other two are feeding into"]'::jsonb, 'Repeat, because it is the weakest gate and the one the other two are feeding into', 'Session 9',
   'Getting to 6% needs the product of the three to rise by two-thirds. Awareness has only 20 points of headroom and is already the strongest gate, so the arithmetic there is unforgiving; repeat at 15% has the most room and is where the losses are concentrated.

A 15% repeat rate is also a signal about the product itself. More advertising against it would fill the bucket faster without fixing the leak.', 'Find the weakest gate first, then ask how much headroom each one actually has.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pc6', 'MKTG', 'case_fact', 'parfitt_collins', 9,
   'In which kind of market is Parfitt-Collins most used, and why?',
   '["FMCG, because awareness, trial and repeat are all measurable there", "Industrial goods, because purchase cycles are long enough to observe", "Luxury goods, because awareness matters more than trial", "Services, because repeat purchase is contractual"]'::jsonb, 'FMCG, because awareness, trial and repeat are all measurable there', 'Session 9',
   'Fast-moving consumer goods have frequent, trackable purchases, so all three rates can actually be measured from panel and scanner data rather than assumed.

The model is also taught as the Peckham or Collins model. In categories with long purchase cycles, repeat is not observable in any usable timeframe, which limits its value.', 'The constraint is measurement — which market lets you observe all three rates?', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('mktg-pc7', 'MKTG', 'formula', 'parfitt_collins', 9,
   'Trial is 30% and repeat is 40%. A manager reports required awareness for a 6% share as 0.5%. What went wrong?',
   '["The target share should have been divided by trial only", "The rates were applied in the wrong order", "Trial and repeat were multiplied when they should have been added", "Percentages and decimals were mixed — the answer is 50%, not 0.5%"]'::jsonb, 'Percentages and decimals were mixed — the answer is 50%, not 0.5%', 'Session 9',
   '0.06 / (0.30 x 0.40) = 0.06 / 0.12 = 0.50, which is **50%** expressed as a decimal. Reading 0.50 as "0.5%" is a hundred-fold error.

The concept note flags this as the standard way to lose the mark: pick one convention, decimals or percentages, and hold it for the whole calculation.', 'Check the magnitude against common sense — half the market is 50%, not half a percent.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

commit;
