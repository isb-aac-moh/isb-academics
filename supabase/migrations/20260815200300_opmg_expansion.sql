-- OPMG practice-bank expansion: every topic reaches 8 questions.
--
-- GENERATED -- edit supabase/opmg-expansion.py and re-emit, never this file.
--
-- Counts assume 20260815200000_opmg_additional_set.sql has been applied: eoq_cycle_inventory
-- and quality_process_capability reach 8 from the professor's set alone and gain nothing here.
--
-- hypothesis_testing_clt gets its first 8 questions. The concept was already in the database
-- but groupBySession() builds its topic list from questions, so it was unreachable in the app.

begin;

-- learn_questions: 77 new rows
insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n01', 'OPMG', 'formula', 'littles_law', 1,
   'A hospital ward admits 12 patients per day and each stays an average of 4.5 days. How many beds must be occupied on average?',
   '["48 beds", "16.5 beds", "2.7 beds", "54 beds"]'::jsonb, '54 beds', 'Session 1',
   'I = R x T = 12 x 4.5 = **54 beds**.

The ward needs at least 54 occupied beds on average simply to sustain that admission rate at that length of stay. Cutting average stay to 4 days would free 6 beds without admitting one fewer patient — which is why length of stay is the lever hospitals actually pull.', 'Inventory is the rate multiplied by the time each unit spends inside, not the two divided.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n02', 'OPMG', 'formula', 'littles_law', 1,
   'A café wants average time in the system down from 12 minutes to 9 while still serving 40 customers per hour. What happens to the average number of customers inside?',
   '["Stays at 8, since throughput is unchanged", "Falls from 8 to 7.5", "Rises from 6 to 8", "Falls from 8 to 6"]'::jsonb, 'Falls from 8 to 6', 'Session 1',
   'Convert the time to hours: 12 minutes = 0.2 h, 9 minutes = 0.15 h.

- Before: I = 40 x 0.2 = **8 customers**
- After: I = 40 x 0.15 = **6 customers**

Throughput is held constant, so the whole reduction in flow time shows up as fewer people waiting inside. The crowd in the shop is a symptom of flow time, not of demand.', 'Hold R fixed and put T in the same time units as R before multiplying.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n03', 'OPMG', 'case_fact', 'process_view', 1,
   'A hospital wants to analyse its emergency department. Which choice of flow unit makes the analysis coherent?',
   '["A doctor, tracked across a shift", "A patient, tracked from arrival to discharge", "A treatment protocol, tracked across revisions", "A bed, tracked across a month"]'::jsonb, 'A patient, tracked from arrival to discharge', 'Session 1',
   'The flow unit is the thing that **moves through** the process and whose journey you are trying to improve. Patients arrive, are processed and leave.

Doctors and beds are **resources** — they stay put while flow units pass through them. Confusing the two inverts every subsequent calculation: capacity is a property of resources, flow time a property of flow units.', 'Ask which item enters at one end and leaves at the other, and which stays behind to serve the next one.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n04', 'OPMG', 'case_fact', 'process_view', 1,
   'In the process view, what are the three quantities that describe any process, and how are they linked?',
   '["Flow rate, inventory and flow time, linked by I = R x T", "Capacity, utilisation and demand, linked by utilisation = demand / capacity", "Setup, run time and batch size, linked by the batching formula", "Cost, quality and speed, linked by trade-off curves"]'::jsonb, 'Flow rate, inventory and flow time, linked by I = R x T', 'Session 1',
   'Those three are the vocabulary of the whole course, and Little''s Law ties them together so tightly that fixing any two determines the third.

The other options are all real relationships, but each describes one aspect of a process rather than the process itself. Utilisation, for instance, needs capacity and flow rate — both defined in terms of the first triple.', 'Look for the set that describes what is inside the process, how fast it moves, and how long it takes.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n05', 'OPMG', 'case_fact', 'process_view', 1,
   'A bank calls its branch queue a "buffer" and its tellers "resources". A new analyst labels the queue a resource because it holds customers. Why is that wrong?',
   '["A buffer has no capacity while a resource does", "A buffer holds flow units waiting; a resource performs work on them", "A buffer is measured in time while a resource is measured in units", "A buffer is a physical space while a resource is a person"]'::jsonb, 'A buffer holds flow units waiting; a resource performs work on them', 'Session 1',
   'The distinction is about **doing work**. A teller transforms a waiting customer into a served one; the queue merely stores them until a teller is free.

It matters because buffers add flow time without adding capacity. Enlarging the waiting area lets more people wait — it does not let more people be served, which is the mistake the labelling error leads to.', 'Ask which one changes the state of a flow unit and which only holds it.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n06', 'OPMG', 'case_fact', 'process_view', 1,
   'A pizza chain measures "time from order placed to pizza handed over". A second team measures "time the oven is busy". What is each measuring?',
   '["Both are flow time, measured at different points", "The first is utilisation; the second is throughput", "The first is flow time for the flow unit; the second is utilisation of a resource", "The first is capacity; the second is flow time"]'::jsonb, 'The first is flow time for the flow unit; the second is utilisation of a resource', 'Session 1',
   'Flow time follows the **order** through the whole process. Oven busy-time describes how hard one **resource** is working.

The two move independently, which is why they get confused: an oven can be busy 95% of the time while orders still take an hour, because the delay is sitting in queues rather than in the oven.', 'One measurement follows the thing being made; the other watches a machine.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n07', 'OPMG', 'case_fact', 'process_view', 1,
   'Why does the process view insist you define the process boundary before measuring anything?',
   '["The boundary determines which employees are accountable", "Capacity cannot be computed without knowing the number of resources", "Flow time and inventory both change depending on where you decide the process starts and ends", "Regulators require a documented scope for process audits"]'::jsonb, 'Flow time and inventory both change depending on where you decide the process starts and ends', 'Session 1',
   'Measure a delivery process from the kitchen and you get one flow time; measure it from the moment the customer taps *order* and you get a much longer one, because the queue before the kitchen is now inside the boundary.

Neither is wrong, but they are not comparable — which is why two teams can argue about performance while both are right about different processes.', 'Imagine moving the start line earlier and ask which measured quantities change.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n08', 'OPMG', 'formula', 'process_view', 1,
   'A process has an average inventory of 300 units and a flow rate of 60 units per hour. What is the average flow time?',
   '["18,000 hours", "5 hours", "12 minutes", "0.2 hours"]'::jsonb, '5 hours', 'Session 1',
   'Rearranging Little''s Law: T = I / R = 300 / 60 = **5 hours**.

Any two of the three quantities give you the third, which is what makes the law so useful — inventory and flow rate are usually the easy ones to observe, and flow time is the one customers actually experience.', 'Divide inventory by the rate; the units of the answer should come out as time.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n09', 'OPMG', 'case_fact', 'strategy_process_alignment', 1,
   'A luxury tailor promises bespoke fitting and unlimited alterations. Which process design fits that strategy?',
   '["High-volume standardised production with tightly balanced stations", "Large batch sizes to spread setup costs across more garments", "Maximum automation to drive unit cost as low as possible", "High flexibility and skilled labour, accepting lower utilisation and higher cost per unit"]'::jsonb, 'High flexibility and skilled labour, accepting lower utilisation and higher cost per unit', 'Session 1',
   'The strategy sells variety and responsiveness, so the process has to be able to do something different for each customer. That means general-purpose capacity and skilled people, and it means giving up the efficiency a standardised line would deliver.

The alignment point: a process optimised for cost cannot deliver a promise built on customisation, and there is no configuration that does both well.', 'Ask what the customer is being promised, then what a process must sacrifice to keep that promise.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n10', 'OPMG', 'case_fact', 'strategy_process_alignment', 1,
   'A retailer''s stated strategy is everyday low prices, but its stores carry wide assortments, high staffing and frequent promotions. What is the diagnosis?',
   '["Operations are misaligned with strategy, and the cost base cannot support the price promise", "The strategy is sound and the operations simply need better execution", "The retailer is pursuing a differentiation strategy in practice, which is equally valid", "Assortment breadth has no bearing on the cost base"]'::jsonb, 'Operations are misaligned with strategy, and the cost base cannot support the price promise', 'Session 1',
   'Wide assortment, heavy staffing and frequent promotions all add cost — and everyday low prices require the opposite. The operations are quietly funding a service level the pricing cannot pay for.

Misalignment of this kind rarely shows up as a single broken process. It shows up as persistent margin pressure that no individual department appears responsible for.', 'Add up what the operating choices cost, and ask whether the pricing promise can carry it.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n11', 'OPMG', 'case_fact', 'strategy_process_alignment', 1,
   'What does it mean to say a firm must choose which operational dimension to compete on?',
   '["A firm should pick one dimension and ignore the rest entirely", "The choice is a marketing decision with no operational consequences", "Competing on cost automatically produces the best quality over time", "Cost, quality, speed, flexibility and reliability trade off, so a process cannot lead on all of them"]'::jsonb, 'Cost, quality, speed, flexibility and reliability trade off, so a process cannot lead on all of them', 'Session 1',
   'Choosing does not mean abandoning the others — it means deciding which one the process is **designed around** when they conflict, and holding the rest at a level that is good enough.

A firm claiming to lead on every dimension has usually not made the choice, which shows up later as a process that is mediocre at all of them.', 'The claim is about what happens when two of the dimensions pull against each other.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n12', 'OPMG', 'case_fact', 'strategy_process_alignment', 1,
   'An airline competing on lowest fare is deciding between one aircraft type and a mixed fleet. Which supports the strategy, and why?',
   '["A mixed fleet — matching aircraft size to each route maximises load factor", "Either, since fleet composition does not affect operating cost", "A mixed fleet — it reduces dependence on a single manufacturer", "One type — common training, spares and maintenance drive unit cost down"]'::jsonb, 'One type — common training, spares and maintenance drive unit cost down', 'Session 1',
   'A single type means one set of pilot qualifications, one spares inventory and one maintenance skill base. Every one of those is a standing cost that a mixed fleet multiplies.

The alternatives name real benefits — better route matching, less supplier risk — but both buy flexibility with cost, which is the wrong trade for this strategy.', 'Trace each option through to the standing costs it creates or removes.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n13', 'OPMG', 'case_fact', 'strategy_process_alignment', 1,
   'A hospital wants to cut emergency waiting times and simultaneously raise the utilisation of its scanners to near 100%. Why do these goals conflict?',
   '["Higher utilisation always reduces waiting because more patients are processed", "Scanner utilisation is unrelated to emergency waiting times", "A resource run near full utilisation develops long queues once demand varies at all", "Emergency patients do not use scanners"]'::jsonb, 'A resource run near full utilisation develops long queues once demand varies at all', 'Session 1',
   'Waiting time climbs steeply as utilisation approaches 100%, and it climbs faster the more variable arrivals are. Emergency demand is about as variable as it gets.

So the spare capacity that looks like waste on a utilisation report is exactly what is buying the short waits. Chasing both targets at once means pursuing two ends of the same trade-off.', 'Think about what happens to a queue when a highly variable arrival stream meets a resource with no slack.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n14', 'OPMG', 'case_fact', 'strategy_process_alignment', 1,
   'In the strategy-to-process chain, what is the correct order of reasoning?',
   '["All three are decided independently by different functions", "Operational priorities set competitive strategy, which sets process design", "Process design sets operational priorities, which set competitive strategy", "Competitive strategy sets operational priorities, which set process design choices"]'::jsonb, 'Competitive strategy sets operational priorities, which set process design choices', 'Session 1',
   'The direction runs from the customer promise inward: decide what you are competing on, translate that into which operational dimensions matter most, then design the process to deliver them.

Running it backwards is how firms end up with a strategy that describes what their existing process happens to be good at, rather than what the market rewards.', 'Start from the promise made to the customer and work inward.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n15', 'OPMG', 'formula', 'process_financial_link', 2,
   'A rental business holds 4,000 units of inventory at a cost of Rs 2,000 each, with an annual holding charge of 25% of value. It cuts average flow time by 20% at unchanged throughput. What does it save annually?',
   '["Rs 500,000", "Rs 2,000,000", "Rs 400,000", "Rs 1,600,000"]'::jsonb, 'Rs 400,000', 'Session 2',
   'At constant throughput, Little''s Law makes inventory fall in proportion to flow time: 4,000 x 0.20 = **800 units** released.

Saving = 800 x 2,000 x 0.25 = **Rs 400,000** per year.

This is the link the session is built on — a flow-time improvement is not a soft operational win, it converts directly into freed capital and a lower holding charge.', 'Convert the flow-time reduction into units of inventory first, then price those units at the holding rate.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n16', 'OPMG', 'case_fact', 'process_financial_link', 2,
   'Two firms have identical revenue and margin. One turns its inventory 12 times a year, the other 4. What does this imply?',
   '["The first ties up a third of the capital to support the same sales, so its return on capital is higher", "The first has three times the revenue of the second", "The second has lower holding costs because it orders less often", "Inventory turns have no effect on return on capital"]'::jsonb, 'The first ties up a third of the capital to support the same sales, so its return on capital is higher', 'Session 2',
   'Turns are cost of goods sold divided by average inventory, so four turns means three times the inventory of twelve turns at the same sales.

Same profit on a third of the capital is a materially better business, which is why operational flow measures end up on the finance dashboard rather than staying inside operations.', 'Same sales, different inventory — ask what that does to the capital employed.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n17', 'OPMG', 'case_fact', 'process_financial_link', 2,
   'A process improvement cuts flow time but throughput and prices are unchanged. Where does the benefit appear in the accounts?',
   '["Higher gross margin per unit, since each unit costs less to make", "Lower working capital and holding costs, rather than higher revenue", "Higher revenue, since faster service attracts more customers", "Nowhere measurable, since flow time is an operational metric only"]'::jsonb, 'Lower working capital and holding costs, rather than higher revenue', 'Session 2',
   'With throughput fixed by assumption, the improvement cannot show up as extra sales. What it does is shrink the inventory needed to sustain those sales, which releases capital and cuts the charge for carrying it.

Faster service may well win more customers in reality — but that is a separate effect, and claiming both from one improvement double-counts it.', 'Read the constraint in the question carefully before deciding which line moves.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n18', 'OPMG', 'formula', 'batching_capacity', 3,
   'A machine needs a 30-minute setup per batch and 1 minute per unit. What is its capacity in units per hour at a batch size of 30?',
   '["20 units/hour", "60 units/hour", "45 units/hour", "30 units/hour"]'::jsonb, '30 units/hour', 'Session 3',
   'Time per batch = 30 setup + 30 x 1 run = **60 minutes** for 30 units.

Capacity = 30 units / 1 hour = **30 units per hour**.

Half the machine''s time is going into setup, which is exactly what larger batches are meant to dilute.', 'Work out the total time for one whole batch, setup included, then divide the batch into it.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n19', 'OPMG', 'formula', 'batching_capacity', 3,
   'The same machine (30-minute setup, 1 minute per unit) moves to a batch size of 90. What is the new capacity?',
   '["30 units/hour", "60 units/hour", "45 units/hour", "90 units/hour"]'::jsonb, '45 units/hour', 'Session 3',
   'Time per batch = 30 + 90 = **120 minutes** for 90 units, so capacity = 90 / 2 = **45 units per hour**.

Tripling the batch raised capacity by half, not threefold. Setup is being spread over more units, but the run time per unit never goes away — which is why capacity approaches a ceiling of 60 per hour and never reaches it.', 'Recompute the whole batch time; the gain is bounded by the run time per unit.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n20', 'OPMG', 'formula', 'batching_capacity', 3,
   'As batch size grows without limit on a machine with setup time S and unit time p, what does capacity approach?',
   '["It grows without bound", "1/p, the capacity with no setup at all", "S/p", "Zero, as setup dominates"]'::jsonb, '1/p, the capacity with no setup at all', 'Session 3',
   'Capacity is B / (S + Bp). Divide through by B and it becomes 1 / (S/B + p), and S/B goes to zero as B grows.

So the ceiling is **1/p** — the capacity you would have if setups were free. Batching can recover the time lost to setup, but it can never make the machine faster than its own run rate.', 'Divide numerator and denominator by the batch size and see which term vanishes.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n21', 'OPMG', 'case_fact', 'batching_capacity', 3,
   'Larger batches raise capacity at a station with setups. What do they cost?',
   '["Lower capacity at every other station in the process", "Higher setup cost per batch, since bigger batches take longer to set up", "Nothing — larger batches are strictly better", "Longer flow time, because a unit waits for its whole batch to be processed"]'::jsonb, 'Longer flow time, because a unit waits for its whole batch to be processed', 'Session 3',
   'A unit finished early sits waiting until the rest of its batch is done and the batch moves on. Bigger batch, longer wait — and more inventory sitting in the process.

That is the trade the topic is named for: batch size buys capacity with flow time. Which one you should favour depends on whether the station is the bottleneck.', 'Follow a single unit through a large batch and ask when it actually leaves the station.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n22', 'OPMG', 'case_fact', 'batching_capacity', 3,
   'A station with setups is not the bottleneck and has spare capacity. What batch size policy makes sense?',
   '["Larger batches, to build up as much capacity headroom as possible", "The largest batch the machine can physically hold", "The same batch size as the bottleneck, to keep the line balanced", "Smaller batches, trading away capacity it does not need for shorter flow time"]'::jsonb, 'Smaller batches, trading away capacity it does not need for shorter flow time', 'Session 3',
   'Capacity at a non-bottleneck is worth nothing — the process cannot go faster than its bottleneck no matter how much headroom sits elsewhere. Flow time, on the other hand, is worth something everywhere.

So spend the spare capacity on smaller batches. This is the reasoning behind reducing setup times generally: cheaper setups make small batches affordable, which is where lean starts.', 'Ask what extra capacity at a non-bottleneck is actually worth to the process.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n23', 'OPMG', 'formula', 'batching_capacity', 3,
   'A station has a 40-minute setup and 2 minutes per unit. What batch size is needed for a capacity of 20 units per hour?',
   '["60 units", "20 units", "40 units", "30 units"]'::jsonb, '40 units', 'Session 3',
   'Require B / (40 + 2B) = 20/60 units per minute = 1/3.

So 3B = 40 + 2B, giving B = **40 units**.

Check: 40 + 80 = 120 minutes for 40 units, which is 20 per hour. Note the ceiling of 1/p = 30 per hour — any target above that is unreachable at any batch size.', 'Set the capacity expression equal to the target in consistent units and solve for the batch size.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n24', 'OPMG', 'formula', 'process_capacity_bottleneck', 3,
   'A three-station line runs at 20, 12 and 15 units per hour. Management doubles station 1 to 40 per hour. What is the new process capacity?',
   '["22.3 units/hour, the average of the three", "40 units/hour, set by the fastest station", "12 units/hour, unchanged — station 2 is still the bottleneck", "24 units/hour, since the first station doubled"]'::jsonb, '12 units/hour, unchanged — station 2 is still the bottleneck', 'Session 3',
   'Process capacity is the **minimum** across stations, so it is set by station 2 at 12 per hour both before and after.

The investment bought nothing. All it did was let station 1 build inventory in front of station 2 faster. Improving a non-bottleneck is the most common way to spend money on a process without changing its output.', 'The slowest station sets the pace — check whether the change touched it.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n25', 'OPMG', 'case_fact', 'subscription_model_dynamics', 3,
   'What does it mean to say a subscription model decouples revenue from cost?',
   '["Costs are fixed while revenue varies with usage", "Subscription revenue is recognised only once usage occurs", "Revenue and cost both scale with the number of subscribers", "Revenue arrives per period regardless of usage, while cost is driven by how much each member uses"]'::jsonb, 'Revenue arrives per period regardless of usage, while cost is driven by how much each member uses', 'Session 3',
   'A subscriber pays the same monthly fee whether they use the service once or twenty times, but each use consumes real capacity.

That asymmetry is the whole model: it is highly profitable on light users and can be loss-making on heavy ones, which makes the **distribution** of usage more important than the average.', 'Ask what happens to revenue and to cost when one member doubles their usage.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n26', 'OPMG', 'formula', 'subscription_model_dynamics', 3,
   'A rental subscription charges Rs 3,000 a month. Each rental costs Rs 400 in cleaning and logistics. At what usage does a member stop being profitable, ignoring other costs?',
   '["Above 7.5 rentals a month", "Above 12 rentals a month", "Above 30 rentals a month", "Above 4 rentals a month"]'::jsonb, 'Above 7.5 rentals a month', 'Session 3',
   '3,000 / 400 = **7.5 rentals**. Past that the variable cost of serving the member exceeds what they pay.

This threshold is why usage caps, fair-use policies and tiered plans exist. Without one, the members who love the product most are the ones losing the most money.', 'Divide the fixed monthly fee by the variable cost of a single use.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n27', 'OPMG', 'case_fact', 'subscription_model_dynamics', 3,
   'Why can rising engagement be bad news for a subscription operator, when it is good news for most businesses?',
   '["Each additional use consumes capacity without producing additional revenue", "Engaged members are more likely to cancel", "Engagement raises the price the operator must charge competitors", "Higher engagement always signals a quality problem"]'::jsonb, 'Each additional use consumes capacity without producing additional revenue', 'Session 3',
   'In a transactional business more usage means more sales. Under a subscription it means more cost against a fee that has already been collected.

So the operator has to watch engagement as a **cost driver** as well as a health metric — the same dashboard number means two opposite things depending on the revenue model underneath it.', 'Trace one extra use through both the revenue line and the cost line.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n28', 'OPMG', 'case_fact', 'subscription_model_dynamics', 3,
   'A subscription service finds 20% of members generate 60% of usage. What does that concentration imply operationally?',
   '["The average usage figure is sufficient for capacity planning", "Pricing should be lowered to attract more light users to balance the mix", "Capacity must be sized for the heavy tail, not for the average member", "The heavy users should be prioritised for further engagement campaigns"]'::jsonb, 'Capacity must be sized for the heavy tail, not for the average member', 'Session 3',
   'Planning on the mean understates peak load whenever usage is concentrated, and the concentration is what drives both capacity requirements and cost.

Attracting more light users does improve the economics, but it does not fix the capacity question — the heavy users still show up. Sizing and pricing are separate responses to the same distribution.', 'Ask whether an average describes a population where a fifth of it does most of the work.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n29', 'OPMG', 'case_fact', 'subscription_model_dynamics', 3,
   'How does a subscription change the operator''s incentive around flow time, compared with pay-per-use?',
   '["Faster turnaround serves the same member again sooner without new revenue, so it must be justified by retention", "Flow time matters only for the operator''s cost of capital", "Faster turnaround always increases revenue in the same period", "Flow time becomes irrelevant once revenue is fixed"]'::jsonb, 'Faster turnaround serves the same member again sooner without new revenue, so it must be justified by retention', 'Session 3',
   'Under pay-per-use, cutting flow time lets you sell more. Under a subscription it lets the same member consume more of what they have already paid for.

The business case therefore shifts from revenue to **retention** — faster service is worth paying for because it keeps members subscribed, not because it raises this month''s bill. A weaker and slower argument, but a real one.', 'Ask who benefits from the extra cycles the improvement creates, and whether they pay for them.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n30', 'OPMG', 'case_fact', 'subscription_model_dynamics', 3,
   'An FMCG manufacturer cannot decouple revenue from cost the way a subscription business can. Why not?',
   '["FMCG firms have no fixed costs to spread", "FMCG margins are too thin to support a subscription", "Revenue arrives only when a unit is sold, so each unit''s cost is tied to its own sale", "FMCG demand is too variable to forecast"]'::jsonb, 'Revenue arrives only when a unit is sold, so each unit''s cost is tied to its own sale', 'Session 3',
   'In a transactional model the revenue and the cost of goods travel together on every unit — sell twice as much and both roughly double.

Subscription breaks that pairing by collecting revenue on a calendar and incurring cost on usage. It is the timing mismatch, not the margin level, that creates the different operational problem.', 'Ask what event triggers revenue in each model, and what event triggers cost.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n31', 'OPMG', 'formula', 'theoretical_flow_time', 3,
   'A process has paths A-B-D (4 + 6 + 3 minutes) and A-C-D (4 + 10 + 3 minutes), where B and C run in parallel after A. What is the theoretical flow time?',
   '["13 minutes", "30 minutes", "17 minutes", "26 minutes"]'::jsonb, '17 minutes', 'Session 3',
   'Parallel paths mean the process waits for the **longer** one, so take the critical path: A-C-D = 4 + 10 + 3 = **17 minutes**.

13 minutes is the shorter path, which finishes early and then waits. 26 adds both paths, which would only be right if B and C ran one after the other.', 'With parallel activities, the process is held up by the slowest path, not the sum of all of them.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n32', 'OPMG', 'case_fact', 'theoretical_flow_time', 3,
   'What does theoretical flow time deliberately exclude?',
   '["Setup time at each resource", "All waiting time — it counts only value-adding activity", "The time taken by the critical path", "Rework and inspection activities"]'::jsonb, 'All waiting time — it counts only value-adding activity', 'Session 3',
   'Theoretical flow time is the time a unit would take if it never queued: pure work content along the critical path.

That makes it a benchmark rather than a prediction. Comparing it with actual flow time gives the flow time efficiency, and the gap between them is the improvement opportunity.', 'The word theoretical is doing the work — what would have to be true for a unit to achieve it?', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n33', 'OPMG', 'formula', 'theoretical_flow_time', 3,
   'A clinic''s theoretical flow time is 25 minutes and patients actually average 100 minutes. What is the flow time efficiency, and what does it say?',
   '["25% — three-quarters of a patient''s visit is spent waiting", "75% — a quarter of the visit is waiting", "25% — a quarter of the visit is waiting", "400% — patients take four times longer than theoretically possible"]'::jsonb, '25% — three-quarters of a patient''s visit is spent waiting', 'Session 3',
   'Flow time efficiency = theoretical / actual = 25 / 100 = **25%**.

So 75 of every 100 minutes add nothing for the patient. That is the number to attack, and it usually falls to queueing and handoffs rather than to slow clinicians — which is why hiring faster staff often fails to shift it.', 'Put the theoretical time over the actual one, then interpret the remainder.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n34', 'OPMG', 'case_fact', 'theoretical_flow_time', 3,
   'An improvement team shortens an activity that sits on a non-critical path. What happens to theoretical flow time?',
   '["It falls by the amount the activity was shortened", "Nothing, until that path becomes the critical one", "It rises, because the paths become less balanced", "It falls by half the amount, since two paths share the process"]'::jsonb, 'Nothing, until that path becomes the critical one', 'Session 3',
   'The critical path sets the theoretical flow time, and shortening something with slack just adds more slack.

The same logic as the bottleneck: improving the part that was not constraining the system changes nothing measurable. Worth checking which path is critical *before* choosing what to improve.', 'Ask whether the activity was holding anything up in the first place.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n35', 'OPMG', 'formula', 'theoretical_flow_time', 3,
   'A process runs A (5 min), then B (8 min) and C (6 min) in parallel, then D (4 min). B is cut from 8 to 5 minutes. What is the new theoretical flow time?',
   '["14 minutes", "17 minutes", "12 minutes", "15 minutes"]'::jsonb, '15 minutes', 'Session 3',
   'Originally the critical path ran through B: 5 + 8 + 4 = 17 minutes.

Cutting B to 5 makes C the longer parallel branch at 6, so the new critical path is 5 + 6 + 4 = **15 minutes**.

The activity was cut by 3 minutes but the process only gained 2, because the critical path switched to C partway through the improvement. Improvements stop paying once the constraint moves.', 'Recompute both paths after the change — the critical one may not be the same branch.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n36', 'OPMG', 'case_fact', 'theoretical_flow_time', 3,
   'Why can two processes with identical theoretical flow times have very different actual flow times?',
   '["Actual flow time depends on utilisation and variability, which theoretical flow time ignores", "Theoretical flow time is measured per batch and actual flow time per unit", "Actual flow time includes setup while theoretical flow time does not", "One process must have miscounted its critical path"]'::jsonb, 'Actual flow time depends on utilisation and variability, which theoretical flow time ignores', 'Session 3',
   'Theoretical flow time is pure work content. Actual flow time adds every queue, and queues are driven by how heavily loaded the resources are and how variable the arrivals and service times are.

Run the same work content at 95% utilisation instead of 60% and the actual flow time can multiply while the theoretical figure does not move at all.', 'The difference between the two numbers is waiting — ask what determines how much waiting there is.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n37', 'OPMG', 'formula', 'variability_queuing_basics', 4,
   'A single server handles 9 jobs per hour and demand is 6 jobs per hour. What is utilisation, and what happens to the queue if demand rises to 8.5?',
   '["150%, and the system is already unstable", "66.7%, and the queue is unaffected while capacity still exceeds demand", "66.7%, and the queue lengthens proportionally to 94.4%", "66.7%, and the queue lengthens sharply as utilisation reaches 94.4%"]'::jsonb, '66.7%, and the queue lengthens sharply as utilisation reaches 94.4%', 'Session 4',
   'Utilisation = R / Rp = 6 / 9 = **66.7%**, rising to 8.5 / 9 = **94.4%**.

Waiting time does not rise in proportion to utilisation — it rises with roughly 1/(1 − utilisation), so going from 66.7% to 94.4% multiplies the queue many times over even though capacity still exceeds demand.

That non-linearity is why systems feel fine until suddenly they do not.', 'Utilisation is a simple ratio, but the waiting it produces is anything but linear.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n38', 'OPMG', 'case_fact', 'variability_queuing_basics', 4,
   'A process has ample capacity — utilisation is only 60% — yet customers still queue. How is that possible?',
   '["The process must have a hidden bottleneck at 100% utilisation", "Arrivals and service times vary, so demand and capacity are mismatched moment to moment", "Utilisation must have been measured incorrectly", "Queues cannot form below 100% utilisation"]'::jsonb, 'Arrivals and service times vary, so demand and capacity are mismatched moment to moment', 'Session 4',
   'Average capacity exceeding average demand says nothing about any particular minute. Customers arrive in clusters and some take much longer than others, so the server is idle at times and overwhelmed at others.

Remove all variability and a 60%-utilised system would have no queue at all. Waiting is created by randomness, not by a shortage of average capacity.', 'Averages balancing does not mean they balance at every moment.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n39', 'OPMG', 'case_fact', 'variability_queuing_basics', 4,
   'A bank reduces the variability of service times without changing the average or adding staff. What happens?',
   '["Average waiting time falls, because waiting scales with variability", "Average waiting rises, because consistent service is slower", "Utilisation falls, because less time is wasted", "Nothing, since average capacity and demand are unchanged"]'::jsonb, 'Average waiting time falls, because waiting scales with variability', 'Session 4',
   'Waiting time is proportional to the variability term, so cutting the spread of service times cuts the queue even with utilisation held exactly where it was.

This is the cheapest lever in queueing: standardising how work is done costs far less than adding servers, and it attacks the same waiting time. Much of lean is this insight applied repeatedly.', 'Waiting depends on three things — utilisation, service time, and how variable the process is.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n40', 'OPMG', 'formula', 'variability_queuing_basics', 4,
   'Arrivals average 10 per hour with a standard deviation of 10 minutes between arrivals; the mean interarrival time is 6 minutes. What is the coefficient of variation of arrivals?',
   '["0.6", "1.0", "1.67", "10"]'::jsonb, '1.67', 'Session 4',
   'CV = standard deviation / mean = 10 / 6 = **1.67**.

A CV above 1 means arrivals are more variable than a Poisson process, which has CV = 1. That matters because the waiting-time formula carries the CVs directly — highly variable arrivals produce long queues even at modest utilisation.', 'The coefficient of variation is a ratio, so both quantities must be in the same units.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n41', 'OPMG', 'case_fact', 'queuing_scale_pooling', 5,
   'Two call centres each run one agent at 80% utilisation with their own queue. They merge into one queue served by both agents. What happens?',
   '["Average wait falls sharply, even though utilisation and total capacity are unchanged", "Utilisation falls to 40% because two agents now share the load", "Average wait rises, because the single queue is twice as long", "Average wait is unchanged, since capacity and demand are the same"]'::jsonb, 'Average wait falls sharply, even though utilisation and total capacity are unchanged', 'Session 5',
   'Pooling removes the situation where one agent sits idle while a customer waits in the other queue. Every agent can serve any waiting customer, so capacity is never stranded.

Nothing was added — same agents, same demand, same utilisation. The gain comes purely from removing the barrier between the two queues, which is why pooling is the highest-return change in most service systems.', 'Picture one agent idle while someone waits in the other line, and ask whether pooling allows that.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n42', 'OPMG', 'case_fact', 'queuing_scale_pooling', 5,
   'A pooled system with many servers is split into separate dedicated lines at the same total capacity and utilisation. What is the effect?',
   '["Waiting time is unchanged, since total capacity is the same", "Waiting time rises only if utilisation exceeds 90%", "Waiting time rises, because capacity can now be idle while customers wait elsewhere", "Waiting time falls, because each line is shorter"]'::jsonb, 'Waiting time rises, because capacity can now be idle while customers wait elsewhere', 'Session 5',
   'Splitting is pooling in reverse and it costs exactly what pooling gains. Each dedicated line has to absorb its own variability with no help from the others.

There can be good reasons to split — specialisation, different skill requirements, priority classes — but they have to be worth the waiting time the split creates.', 'Ask what becomes possible after the split that was impossible before.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n43', 'OPMG', 'case_fact', 'queuing_scale_pooling', 5,
   'Why does doubling the size of a pooled service system reduce waiting more than proportionally, at constant utilisation?',
   '["Waiting time is inversely proportional to the number of servers", "Larger systems have lower utilisation by definition", "Relative variability falls as the number of servers grows, so less slack is needed for the same wait", "Larger systems can process customers in batches"]'::jsonb, 'Relative variability falls as the number of servers grows, so less slack is needed for the same wait', 'Session 5',
   'With more servers handling a proportionally larger arrival stream, the fluctuations average out against each other. The system is more predictable relative to its size, so the same utilisation produces a shorter queue.

This is economies of scale expressed in waiting rather than in cost, and it is why a large hospital can safely run at a utilisation that would cripple a small clinic.', 'Think about how a bigger pool of independent demand behaves relative to its own size.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n44', 'OPMG', 'case_fact', 'queuing_scale_pooling', 5,
   'When is pooling a poor idea despite its queueing benefits?',
   '["When the servers are located in the same building", "When customers arrive in a predictable pattern", "When the work genuinely requires specialised skills that not every server has", "When utilisation is below 70%"]'::jsonb, 'When the work genuinely requires specialised skills that not every server has', 'Session 5',
   'Pooling only works if any server can take any customer. Where that is untrue — a specialist surgeon, a language requirement, a licensed role — a pooled queue either sends work to someone who cannot do it or quietly re-forms into separate queues.

The usual remedy is cross-training, which buys back the flexibility pooling needs, at the cost of the training itself.', 'Ask what pooling assumes about the interchangeability of servers.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n45', 'OPMG', 'case_fact', 'queuing_scale_pooling', 5,
   'A hospital cross-trains its nurses so any nurse can handle any patient type. What does this achieve in queueing terms?',
   '["It converts several dedicated queues into one pooled system without hiring anyone", "It reduces the average service time per patient", "It eliminates variability in patient arrivals", "It lowers utilisation by spreading work more evenly"]'::jsonb, 'It converts several dedicated queues into one pooled system without hiring anyone', 'Session 5',
   'Cross-training is what makes pooling possible when the work is not naturally interchangeable. The staffing level and the service times do not change; what changes is that no nurse is now stuck unable to help a waiting patient.

It neither speeds up service nor reduces variability — it stops variability in one stream from being absorbed by only one server.', 'Cross-training changes who *can* serve whom, not how fast or how variable the service is.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n46', 'OPMG', 'case_fact', 'lean_fundamentals', 6,
   'In lean terms, what distinguishes value-adding activity from the rest?',
   '["The customer would be willing to pay for it, and it changes the product toward what they want", "It is required by regulation or company policy", "It is performed by a skilled worker rather than a machine", "It takes place at the bottleneck resource"]'::jsonb, 'The customer would be willing to pay for it, and it changes the product toward what they want', 'Session 6',
   'The test is deliberately from the customer''s side. Inspection, moving material and storing work in progress all cost money and none of them change the product into something the customer wants more.

Some non-value-adding work is unavoidable — safety checks, regulatory steps — but calling it what it is keeps it under pressure rather than letting it become invisible.', 'Ask whether a customer, seeing the activity, would agree to pay for it.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n47', 'OPMG', 'case_fact', 'lean_fundamentals', 6,
   'Why does lean treat inventory as a waste in its own right, rather than as a neutral asset?',
   '["It increases the capacity of downstream stations", "It consumes capital and hides the problems that made it necessary", "It always spoils or becomes obsolete before use", "It is taxed more heavily than other assets"]'::jsonb, 'It consumes capital and hides the problems that made it necessary', 'Session 6',
   'Buffer stock lets a process keep running through breakdowns, long setups and quality failures — which means those problems never have to be fixed.

The capital cost is the visible half. The concealment is the half lean cares about: lowering inventory deliberately exposes the problems, which is the point rather than a side effect.', 'Ask what inventory lets a process get away with.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n48', 'OPMG', 'case_fact', 'lean_fundamentals', 6,
   'What is the operational argument for reducing setup times, in lean thinking?',
   '["Shorter setups directly raise the capacity of every station in the process", "Setup reduction removes the need for quality inspection", "Cheaper setups make small batches affordable, which cuts flow time and inventory", "Shorter setups allow larger batches to be run more often"]'::jsonb, 'Cheaper setups make small batches affordable, which cuts flow time and inventory', 'Session 6',
   'Large batches exist mainly to spread the cost of an expensive setup. Make setups cheap and that reason disappears, which unlocks small batches — and small batches mean shorter flow times, less work in progress and faster detection of defects.

The capacity gain at the station is real but secondary. The batch size it permits is the point.', 'Ask why large batches existed in the first place, then what removing that reason allows.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n49', 'OPMG', 'case_fact', 'lean_fundamentals', 6,
   'A pull system differs from a push system in what respect?',
   '["Work moves in larger batches to reduce handling", "Work is released only when a downstream station signals it is ready", "Work is scheduled centrally to maximise utilisation at every station", "Work is released according to a forecast made at the start of the period"]'::jsonb, 'Work is released only when a downstream station signals it is ready', 'Session 6',
   'Push releases work on a schedule regardless of what is happening downstream, which piles inventory in front of any station that falls behind. Pull ties every release to actual downstream readiness, so work in progress is capped by construction.

The trade is that a pull system will deliberately let an upstream resource sit idle rather than build inventory nobody has asked for — which looks like waste on a utilisation report and is not.', 'Ask what triggers the release of the next unit of work in each system.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n50', 'OPMG', 'case_fact', 'lean_fundamentals', 6,
   'Lean argues for low inventory, yet Toyota''s semiconductor buffer let it keep producing through the chip shortage. How do these fit together?',
   '["Toyota abandoned lean during the shortage", "Buffers are justified where supply risk is high and lead times are long — lean removes waste, not judgement", "Lean applies only to internal processes, never to purchased components", "The buffer was an error that happened to have a good outcome"]'::jsonb, 'Buffers are justified where supply risk is high and lead times are long — lean removes waste, not judgement', 'Session 6',
   'Lean targets inventory that exists to conceal fixable problems — long setups, unreliable equipment, poor quality. A chip shortage caused by a global supply shock is none of those, and no amount of internal improvement removes it.

So the buffer is a deliberate hedge against a risk outside the firm''s control, which is a different thing from work in progress accumulating because a machine keeps breaking.', 'Ask which kind of problem the inventory is covering for, and whether the firm could fix it.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n51', 'OPMG', 'case_fact', 'priority_queuing', 6,
   'A clinic introduces a priority class for urgent patients without adding capacity. What happens to average waiting time across all patients?',
   '["It rises sharply, because switching between classes wastes time", "It falls by exactly the share of patients classified as urgent", "It falls, because urgent patients are handled more efficiently", "It stays roughly the same — priority redistributes waiting rather than removing it"]'::jsonb, 'It stays roughly the same — priority redistributes waiting rather than removing it', 'Session 6',
   'No capacity was added and no variability was removed, so the total waiting in the system is essentially unchanged. Urgent patients wait less and everyone else waits more.

That is not a criticism — moving waiting to where it costs least is exactly the point. But it must be argued as a redistribution, not sold as an efficiency gain.', 'Ask whether the change touched capacity or variability at all.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n52', 'OPMG', 'case_fact', 'priority_queuing', 6,
   'Under what condition does prioritisation create genuine value rather than merely moving waiting around?',
   '["When the priority class is the largest group of customers", "When utilisation is below 50%", "When all customers value their time equally", "When the cost of waiting differs across classes, so the same delay does less harm to some"]'::jsonb, 'When the cost of waiting differs across classes, so the same delay does less harm to some', 'Session 6',
   'If everyone''s waiting cost were identical, shuffling the order would achieve nothing in total. The gain comes entirely from the differences — a delayed emergency patient loses far more than a delayed routine check-up.

So the case for priority rests on the *spread* of waiting costs, which is also why an unjustified priority scheme is worse than none.', 'Total waiting is fixed, so any gain has to come from who does the waiting.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n53', 'OPMG', 'case_fact', 'priority_queuing', 6,
   'Serving the shortest jobs first, rather than in arrival order, has what effect on average waiting time?',
   '["It increases it, because long jobs are delayed", "It reduces it, because short jobs stop queueing behind long ones", "It reduces it only when utilisation exceeds 90%", "It leaves it unchanged, since the same work is done either way"]'::jsonb, 'It reduces it, because short jobs stop queueing behind long ones', 'Session 6',
   'A long job at the front makes everyone behind it wait its full duration. Putting short jobs first means many customers each wait a little instead of a few waiting a lot, which lowers the average.

The cost is fairness: long jobs can be pushed back repeatedly if short ones keep arriving. This is the one scheduling rule that genuinely improves the average rather than redistributing it.', 'Count how many customers are held up behind a long job versus a short one.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n54', 'OPMG', 'case_fact', 'priority_queuing', 6,
   'An airport gives landing aircraft priority over departing ones on shared runways. What is the operational justification?',
   '["Landings take less runway time than departures", "It raises total runway throughput", "A circling aircraft burns fuel and carries safety risk, so its waiting is far more costly", "Departing aircraft have more flexible schedules by regulation"]'::jsonb, 'A circling aircraft burns fuel and carries safety risk, so its waiting is far more costly', 'Session 6',
   'The runway does the same amount of work either way, so throughput is unchanged. What differs is the cost of delay: a plane waiting on the ground burns comparatively little and is safe, while one holding in the air is doing neither.

A clean application of the rule that priority pays when waiting costs differ sharply between classes.', 'Compare what a delay costs on the ground with what it costs in the air.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n55', 'OPMG', 'case_fact', 'priority_queuing', 6,
   'A firm introduces a paid fast-track lane. What must it watch operationally?',
   '["Fast-track customers will begin to arrive less frequently", "Total capacity falls once the lanes are separated", "Standard-lane waiting rises, and beyond some point those customers leave", "Utilisation rises above 100% in the fast lane"]'::jsonb, 'Standard-lane waiting rises, and beyond some point those customers leave', 'Session 6',
   'Priority moves waiting onto the standard lane, and that lane has a tolerance. Push past it and the firm loses those customers — along with the volume that made the operation viable.

There is also a pooling cost if the lanes get dedicated servers: capacity can sit idle in one lane while the other queues. The revenue from fast-track has to cover both effects.', 'Follow the waiting that priority moves, and ask what the customers receiving it will do.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n56', 'OPMG', 'case_fact', 'six_sigma_dmaic', 8,
   'What are the five phases of DMAIC, in order?',
   '["Detect, Measure, Act, Improve, Close", "Design, Model, Analyse, Implement, Check", "Define, Measure, Analyse, Improve, Control", "Define, Model, Adjust, Inspect, Confirm"]'::jsonb, 'Define, Measure, Analyse, Improve, Control', 'Session 8',
   '**Define** the problem, **Measure** the current process, **Analyse** for root causes, **Improve** by changing something, **Control** so the gain holds.

The last phase is the one teams skip, and it is why improvements decay. Without a control mechanism the process drifts back to where it started within months.', 'Two of the phases happen before anyone is allowed to change anything.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n57', 'OPMG', 'case_fact', 'six_sigma_dmaic', 8,
   'A process is described as six sigma capable. What does that mean, and what does it not mean?',
   '["The process operates with six control charts", "The process has been improved six times", "The process produces exactly six defects per million, by definition", "Specification limits sit six standard deviations from the mean — not that defects are impossible"]'::jsonb, 'Specification limits sit six standard deviations from the mean — not that defects are impossible', 'Session 8',
   'Sigma capability measures how much room there is between the process spread and the customer''s limits. At six sigma the process can drift substantially and still produce almost nothing outside specification.

The idea is **robustness**, not perfection. A six sigma process still fails occasionally; what it does is stop failing every time something shifts slightly.', 'The number describes a distance measured in standard deviations, not a count of defects.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n58', 'OPMG', 'formula', 'six_sigma_dmaic', 8,
   'A process has specification limits at 90 and 110 with a mean of 100 and standard deviation 5. What is its sigma capability, and what happens if the standard deviation halves?',
   '["2.0, rising to 2.5", "2.0, rising to 4.0", "4.0, rising to 8.0", "2.0, unchanged"]'::jsonb, '2.0, rising to 4.0', 'Session 8',
   'Sigma capability = min[(110 − 100)/5, (100 − 90)/5] = **2.0**.

Halve the standard deviation to 2.5 and it becomes 10 / 2.5 = **4.0** — capability doubles.

Capability is inversely proportional to the standard deviation, so halving variation always doubles it. That relationship is what makes variation reduction the central lever in six sigma.', 'Capability is a distance divided by the standard deviation, so halving the denominator does the obvious thing.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n59', 'OPMG', 'case_fact', 'six_sigma_dmaic', 8,
   'Why does six sigma target variation reduction rather than simply re-centring the process mean?',
   '["Process means cannot be adjusted in practice", "Variation reduction is always cheaper than re-centring", "Re-centring changes the specification limits", "Centring helps only once, while lower variation protects against drift the firm cannot prevent"]'::jsonb, 'Centring helps only once, while lower variation protects against drift the firm cannot prevent', 'Session 8',
   'Re-centring is worth doing when a process is off-target, but it is a one-off correction — and real processes drift as tools wear, materials vary and conditions change.

A process with low variation absorbs that drift without producing defects. That standing tolerance is what capability buys, and it is why the effort goes into narrowing the distribution rather than repositioning it.', 'Ask what protects the process the *next* time something shifts.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n60', 'OPMG', 'case_fact', 'six_sigma_dmaic', 8,
   'A team completes an improvement and moves on without a control plan. What does DMAIC predict?',
   '["Capability falls immediately to its original level", "The process drifts back, because nothing detects and corrects the return of the old behaviour", "The process improves further as staff become practised", "The improvement is permanent once the root cause is removed"]'::jsonb, 'The process drifts back, because nothing detects and corrects the return of the old behaviour', 'Session 8',
   'Control exists precisely because improvements are not self-sustaining. Staff turn over, workarounds creep back, equipment wears — and with nothing watching, the process returns to its old state gradually enough that nobody notices.

The control phase is usually a chart and a defined response: what signal counts as out of control, and who does what when it appears.', 'Ask what would notice if the old behaviour came back.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n61', 'OPMG', 'formula', 'spc_control_charts', 8,
   'A process has mean 200 and standard deviation 12, sampled in groups of 9. What are the 3-sigma x-bar control limits?',
   '["188 to 212", "196 to 204", "164 to 236", "197.3 to 202.7"]'::jsonb, '188 to 212', 'Session 8',
   'The chart tracks sample means, so use the standard error: 12 / sqrt(9) = **4**.

Limits = 200 ± 3 x 4 = **188 to 212**.

164 to 236 uses the raw standard deviation of 12 and would flag almost nothing; 196 to 204 divides by 9 instead of by 3, which is the sqrt(n) error in the other direction.', 'Divide the standard deviation by the square root of the sample size, not by the sample size.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n62', 'OPMG', 'formula', 'hypothesis_testing_clt', 8,
   'Delivery times average 21.39 minutes with a standard deviation of 7.73. A pilot of 100 deliveries returns a sample mean of 19.2. What is the standard error, and what is the z-score?',
   '["SE = 0.0773, z = −28.3", "SE = 0.773, z = −28.3", "SE = 7.73, z = −0.28", "SE = 0.773, z = −2.83"]'::jsonb, 'SE = 0.773, z = −2.83', 'Session 8',
   'SE = sigma / sqrt(n) = 7.73 / 10 = **0.773**.

z = (19.2 − 21.39) / 0.773 = **−2.83**.

Dividing by sigma rather than by the standard error gives −0.28 and turns a decisive result into an inconclusive one. With n = 100 that error understates the z-score tenfold, which is the most expensive slip on this topic.', 'A sample mean is a draw from the sampling distribution, which is narrower than the process by sqrt(n).', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n63', 'OPMG', 'case_fact', 'hypothesis_testing_clt', 8,
   'What does the Central Limit Theorem claim about sample means?',
   '["They are normally distributed only when the underlying data is normal", "They have the same spread as the population but a different mean", "They follow the same distribution as the underlying data, with the same spread", "They are normally distributed whatever the shape of the underlying distribution, with spread sigma/sqrt(n)"]'::jsonb, 'They are normally distributed whatever the shape of the underlying distribution, with spread sigma/sqrt(n)', 'Session 8',
   'Both halves matter. Delivery times are heavily skewed, yet averages of delivery times are not — which is why the normal distribution shows up throughout process control even when nothing being measured is normal.

The second half, the sqrt(n) narrowing, is what makes averages informative: individual observations scatter enormously while their averages barely move.', 'The theorem says something about the *shape* and something about the *spread*.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n64', 'OPMG', 'formula', 'hypothesis_testing_clt', 8,
   'A team wants to halve the standard error of its estimate. How much more data does it need?',
   '["Half as much again", "Four times as much", "Twice as much", "Ten times as much"]'::jsonb, 'Four times as much', 'Session 8',
   'Standard error is sigma / sqrt(n), so halving it means doubling sqrt(n), which means **quadrupling n**.

Precision gets expensive quickly, and this is the arithmetic behind that. Going from 100 to 200 observations buys only a 29% reduction in standard error, not 50%.', 'The square root is what makes this costly — work backwards from what has to double.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n65', 'OPMG', 'case_fact', 'hypothesis_testing_clt', 8,
   'What exactly does a hypothesis test ask?',
   '["What is the probability that the null hypothesis is true?", "Does the new process perform better than the old one?", "If the null hypothesis were true, how surprising would this data be?", "What is the probability the new process is an improvement?"]'::jsonb, 'If the null hypothesis were true, how surprising would this data be?', 'Session 8',
   'The test conditions **on** the null and asks about the data, never the reverse. You are not proving the new thing is true — you are asking whether the old story can still explain what you just saw.

That framing explains the asymmetry students find strange: failing to reject the null does not mean nothing changed, only that there was not enough evidence to say otherwise.', 'Notice which of the two — the hypothesis or the data — the probability is actually about.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n66', 'OPMG', 'formula', 'hypothesis_testing_clt', 8,
   'In the delivery pilot, a one-sided test gives p = 0.0023. What would a two-sided test give, and when is one-sided appropriate?',
   '["0.00115 — one-sided is right when the sample is large", "0.0023 — the p-value does not depend on the choice", "0.0046 — one-sided is right when only one direction counts as success", "0.046 — one-sided is right when the standard deviation is known"]'::jsonb, '0.0046 — one-sided is right when only one direction counts as success', 'Session 8',
   'Two-sided doubles the tail probability: 2 x 0.0023 = **0.0046**.

One-sided is appropriate here because a delivery process getting *slower* is not evidence the change worked — only one direction counts. Choosing the wrong one changes the answer, and it is a common slip.', 'Ask whether a result in the opposite direction would be interesting or merely bad news.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n67', 'OPMG', 'case_fact', 'hypothesis_testing_clt', 8,
   'Is p = 0.05 a universal threshold for acting on a result?',
   '["Yes, it is the standard across all fields", "No — the right threshold depends on what being wrong costs in each direction", "Yes, below 0.05 a result is proven", "No, because 0.01 is the correct threshold for operational decisions"]'::jsonb, 'No — the right threshold depends on what being wrong costs in each direction', 'Session 8',
   '0.05 is a convention, not a law. The delivery result at 0.0023 is comfortably enough to act on for food delivery; a vaccine would demand far more evidence before anyone shipped it.

The question to ask is always the cost of each error: shipping a change that does nothing, against discarding one that would have helped.', 'The threshold is a business decision about consequences, not a statistical constant.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n68', 'OPMG', 'case_fact', 'hypothesis_testing_clt', 8,
   'A test fails to reject the null hypothesis. What can be concluded?',
   '["The null hypothesis has been proven true", "The sample size was necessarily too small", "The process is unchanged", "Not enough evidence was gathered to say the process changed — not that it is unchanged"]'::jsonb, 'Not enough evidence was gathered to say the process changed — not that it is unchanged', 'Session 8',
   'Absence of evidence is not evidence of absence. A real improvement can easily go undetected if the sample is small or the effect is modest relative to the process variation.

The practical response is to ask what effect size the test could have detected. A test that would have missed anything smaller than a 20% improvement has not told you much by failing.', 'The test can only reject or fail to reject — ask what the second outcome rules out.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n69', 'OPMG', 'case_fact', 'hypothesis_testing_clt', 8,
   'Why is the CLT the reason control charts work even when the underlying measurements are skewed?',
   '["Charts plot individual measurements, which are assumed normal", "Charts plot sample means, which are normal regardless of the shape of the raw data", "Control charts do not assume any distribution", "Skewed data becomes normal once specification limits are applied"]'::jsonb, 'Charts plot sample means, which are normal regardless of the shape of the raw data', 'Session 8',
   'Three-sigma limits rely on a normal distribution to make the roughly 99.7% claim meaningful. Raw delivery times, waiting times and defect counts are rarely normal.

Because the chart plots **averages** of n units, the CLT supplies the normality the limits assume. This is also why the limits use sigma/sqrt(n) rather than sigma — the quantity being plotted is the sample mean.', 'Ask what quantity is actually plotted on an x-bar chart, and which distribution applies to it.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n70', 'OPMG', 'formula', 'newsvendor_model', 9,
   'A stall buys pastries at Rs 30 and sells them at Rs 80, with unsold stock worthless at the end of the day. What is the optimal service level?',
   '["72.7%", "50%", "62.5%", "37.5%"]'::jsonb, '62.5%', 'Session 9',
   '- Cu = 80 − 30 = **Rs 50** (margin lost on a pastry it could have sold)
- Co = 30 − 0 = **Rs 30** (full cost of one left over)

SL* = 50 / (50 + 30) = **62.5%**.

37.5% is Co/(Cu+Co), the ratio inverted — which would have the stall deliberately running short more often than not.', 'Understocking cost goes on top of the fraction; salvage of zero makes Co the whole purchase cost.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n71', 'OPMG', 'formula', 'newsvendor_model', 9,
   'A newsvendor''s supplier offers to buy back unsold units at half their cost. What happens to the optimal order quantity?',
   '["It falls, because the supplier now shares the risk", "It rises only if the selling price also rises", "It is unchanged, since demand has not changed", "It rises, because the cost of overstocking has fallen"]'::jsonb, 'It rises, because the cost of overstocking has fallen', 'Session 9',
   'The buy-back raises salvage value, which cuts Co. A smaller Co raises SL* = Cu/(Cu+Co), and a higher service level means ordering more.

This is why buy-back terms exist at all: they push the retailer toward stocking the quantity the supplier would prefer, by making leftovers cheaper to hold.', 'Work out which of the two cost terms the buy-back changes, and which direction that pushes the ratio.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n72', 'OPMG', 'formula', 'safety_stock_reorder_point', 10,
   'Weekly demand averages 200 units with a standard deviation of 40. Lead time is 4 weeks. What is the standard deviation of lead-time demand?',
   '["40 units", "20 units", "160 units", "80 units"]'::jsonb, '80 units', 'Session 10',
   'Variances add over the lead time, not standard deviations: sigma x sqrt(L) = 40 x sqrt(4) = **80 units**.

160 units comes from sigma x L, which is the standard error of this topic — it treats uncertainty as though it accumulated linearly with time, and it overstates the safety stock badly.', 'Uncertainty grows with the square root of the lead time, never in proportion to it.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n73', 'OPMG', 'formula', 'safety_stock_reorder_point', 10,
   'Using the same figures (mean 200/week, sigma 40, lead time 4 weeks), what reorder point gives a 95% service level (z = 1.645)?',
   '["866 units", "800 units", "932 units", "1,120 units"]'::jsonb, '932 units', 'Session 10',
   '- Expected lead-time demand = 200 x 4 = **800 units**
- Safety stock = z x sigma x sqrt(L) = 1.645 x 80 = **132 units**

ROP = 800 + 132 = **932 units**.

800 is the deterministic reorder point with no protection against variability at all, which would leave the firm out of stock roughly half the time.', 'Reorder point is expected demand over the lead time plus the safety stock, not one or the other.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n74', 'OPMG', 'formula', 'safety_stock_reorder_point', 10,
   'A firm raises its target service level from 95% (z = 1.645) to 99% (z = 2.326), everything else unchanged. By what percentage does safety stock rise?',
   '["About 41%", "About 100%", "About 21%", "About 4%"]'::jsonb, 'About 41%', 'Session 10',
   'Safety stock is proportional to z, so the ratio is 2.326 / 1.645 = **1.41**, a rise of about **41%**.

Four percentage points of service level cost 41% more safety stock, and the last stretch toward 100% costs far more again — z rises without limit as the service level approaches certainty. This is why nobody targets 100%.', 'Safety stock scales with z, so compare the two z-values directly.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n75', 'OPMG', 'formula', 'safety_stock_reorder_point', 10,
   'A supplier cuts lead time from 9 weeks to 4 with no change in demand variability. What happens to safety stock at the same service level?',
   '["It is unchanged, since demand variability is what drives it", "It falls by a third, since it scales with the square root of lead time", "It falls by more than half, in proportion to the lead time", "It falls by a ninth"]'::jsonb, 'It falls by a third, since it scales with the square root of lead time', 'Session 10',
   'Safety stock is z x sigma x sqrt(L), so the ratio is sqrt(4)/sqrt(9) = 2/3 — a **one-third reduction**.

The lead time more than halved but safety stock fell by only a third, because the square root damps the effect. Real, but consistently smaller than people expect when they negotiate lead times.', 'Take the ratio of the square roots, not the ratio of the lead times.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n76', 'OPMG', 'case_fact', 'safety_stock_reorder_point', 10,
   'What is safety stock actually protecting against?',
   '["The average level of demand over the year", "The fixed cost of placing an order", "Demand and lead time turning out higher than expected during the replenishment window", "Variation in the purchase price of the item"]'::jsonb, 'Demand and lead time turning out higher than expected during the replenishment window', 'Session 10',
   'Average demand over the lead time is covered by the cycle stock in the reorder point. Safety stock covers only the **uncertainty** — the possibility that this particular replenishment window runs hotter than average.

Which is why it depends on sigma and the service level, and not at all on the average demand rate itself.', 'Split the reorder point into its two parts and ask what each one is for.', 2, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values
  ('opm-n77', 'OPMG', 'formula', 'safety_stock_reorder_point', 10,
   'A retailer consolidates 4 regional warehouses into 1, with identical independent demand streams and the same service level. What happens to total safety stock?',
   '["It is unchanged, since total demand is the same", "It halves, falling by a factor of sqrt(4)", "It falls to a quarter, in proportion to the number of warehouses", "It doubles, because one location must cover all regions"]'::jsonb, 'It halves, falling by a factor of sqrt(4)', 'Session 10',
   'Four separate warehouses each carry z x sigma x sqrt(L), for 4 x that in total. Pooled, demand variance adds, so the combined sigma is sigma x sqrt(4) and safety stock is z x sigma x sqrt(4) x sqrt(L).

The ratio is 4 / sqrt(4) = **2**, so total safety stock halves. The same square-root aggregation effect as pooling in queueing — consolidation reduces the buffer needed by sqrt(n), not by n.', 'Compare the sum of four separate buffers with one buffer built on the pooled variance.', 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  difficulty = excluded.difficulty, provenance = excluded.provenance;

commit;
