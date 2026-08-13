-- Load the ISB Learning Agent's content and gameplay history into this database.
--
-- Generated from supabase/mktg-rep-dump/data/*.json, which was verified row-for-row against
-- the old project before that project became unreachable. Two remaps are applied here:
--
--   course id -> course code    'marketing' -> MKTG, 'operations' -> OPMG
--   student id -> users.id      matched on email; the old project's auth ids mean nothing here
--
-- The five students keep their XP, streaks and full answer history. Re-running this is not
-- safe: it would duplicate attempts, which have generated uuid keys.

begin;

-- learn_courses: 2 rows
insert into public.learn_courses (course_code, total_sessions, enabled, sort_order) values ('MKTG', 9, true, 0);
insert into public.learn_courses (course_code, total_sessions, enabled, sort_order) values ('OPMG', 9, true, 1);

-- learn_profiles: 5 rows
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 170, 5, '2026-08-13', '2026-08-09T17:36:08.044716+00:00');
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('b85f7426-486b-4726-9884-05598dc76371', 60, 2, '2026-08-10', '2026-08-09T19:16:07.105063+00:00');
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('33664123-77c1-413b-9d3d-618efc1e34c2', 30, 1, '2026-08-10', '2026-08-10T09:07:39.470772+00:00');
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('31f9bd26-85bb-430a-b347-2f3679cb5322', 0, 2, '2026-08-12', '2026-08-11T17:01:28.901421+00:00');
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('4ade8731-5a77-4bf3-9989-b2e0359c2aba', 0, 1, '2026-08-12', '2026-08-12T12:25:34.864779+00:00');

-- learn_scenarios: 0 rows
-- (none in the source snapshot)

-- learn_questions: 75 rows
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('f1', 'MKTG', 'formula', 'clv', 6, 'CLV of a not-yet-acquired customer: monthly contribution m=$250, acquisition cost=$400, retention rate=80%, discount rate=10%, m0=0. What''s the CLV?', '["$267","$667","$200","$331"]'::jsonb, '$267', 'Session 6 — CLV', 'CLV = 250×(0.8/(1+0.10−0.80)) − 400 = 250×(0.8/0.3) − 400 = 667 − 400 = $267. The $667 distractor is the value BEFORE subtracting acquisition cost — a common step to forget.', 'Infinite horizon: CLV = m × [r ÷ (1 + d − r)], then subtract acquisition cost. Do not forget the retention factor — it matters far more than discounting.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('f2', 'MKTG', 'formula', 'break_even', 3, 'Fixed cost = $60, unit contribution = $0.30. What''s the break-even volume?', '["200 bars","180 bars","20 bars","2,000 bars"]'::jsonb, '200 bars', 'Session 3 — Break-even', '$60 ÷ $0.30 = 200 bars. Dividing the wrong way gives a tiny fraction, nowhere near the other options — 20 and 180 are the tempting near-miss distractors instead.', 'Break-even volume = fixed cost ÷ unit contribution, where contribution is p − c. Ignore sunk costs entirely.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('f3', 'MKTG', 'formula', 'margin_markup', 3, 'Snickers: price = $1.00, cost = $0.70. What''s the % markup (not margin)?', '["43%","30%","70%","133%"]'::jsonb, '43%', 'Session 3 — Margin vs Markup (classic mix-up: 30% is the margin)', 'Markup = (1.00−0.70)/0.70 ≈ 43%. The 30% option is the MARGIN for this same product ((1.00−0.70)/1.00) — the classic mix-up the course flags directly.', 'Margin divides by **price**, markup divides by **cost**. Same rupee difference, two different percentages — check which denominator the question wants.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f2', 'OPMG', 'formula', 'littles_law', 1, 'An ISB student is in 48 WhatsApp groups -- 18 academic (4 msgs/hr each) and 30 non-academic (2 msgs/hr each). They check their phone every 30 minutes and clear all unread messages each time. Assuming steady state, what''s the average number of unread messages at any point in time?', '["16.5 messages","24.0 messages","33.0 messages","49.5 messages"]'::jsonb, '33.0 messages', 'Session 1 — Little''s Law', 'Ra = 18x4 = 72/hr, Rna = 30x2 = 60/hr. Messages arrive randomly across the 30-min window, so the average time a message sits unread is 30/2 = 15 min = 0.25 hr (not the full 30 min). I = Ra x Ta + Rna x Tna = 72x0.25 + 60x0.25 = 18+15 = 33.', 'I = R × T. Identify which two you were given and solve for the third. If more than one type of customer shares the process, split them into segments **before** applying the law — the mixed population breaks it.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('f4', 'MKTG', 'formula', 'grp_advertising', 9, '20% reach with 3 exposures. What''s the GRP (Gross Rating Points)?', '["60","23","6.7","17"]'::jsonb, '60', 'Session 9 — GRP = Reach × Frequency', '20 × 3 = 60 GRPs. 23 and 17 come from adding/subtracting reach and frequency instead of multiplying; 6.7 comes from dividing.', 'GRP = Reach × Frequency. Watch out — the same GRP can be high reach with low frequency, or the reverse.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('f5', 'MKTG', 'formula', 'parfitt_collins', 9, 'You need a 6% break-even market share. Trial rate is 30%, repeat rate is 40%. What awareness level do you need?', '["50%","12%","7.2%","72%"]'::jsonb, '50%', 'Session 9 — Parfitt-Collins', '0.06 = Awareness × 0.30 × 0.40 → Awareness = 0.06/0.12 = 50%. 12% comes from multiplying all three numbers together instead of solving for the missing one.', '%Aware × %Try × %Repeat = %Market Share. Rearrange to solve for whichever is missing, and keep everything in decimals.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c2', 'OPMG', 'case_fact', 'strategy_process_alignment', 1, 'McDonald''s has seen declining same-store sales and rising drive-through wait times. Which initiative best stays aligned with McDonald''s actual strategy of quick, inexpensive meals?', '["Introduce gourmet-style food items prepared fresh in store","Expand the menu with a larger variety of inexpensive items","Let outlets offer table service at a premium price to willing customers","Offer a single menu instead of multiple menus throughout the day"]'::jsonb, 'Offer a single menu instead of multiple menus throughout the day', 'Session 1 — Strategy & Process Alignment', 'Any change that reduces McDonald''s ability to deliver low price and speed works against its strategy. Fresh gourmet items hurt responsiveness and cost; a bigger menu and table service both add complexity. Reducing menu variation throughout the day is the one option that makes the process MORE responsive and lower-cost -- directly reinforcing the promise.', 'Name the value proposition before you judge the operational choice. There is no context-free right answer — the question is always "right for what promise?"', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c3', 'OPMG', 'case_fact', 'process_view', 1, 'In the Domino''s flow-unit example from class, which of the following is correctly classified as a resource rather than part of the flow unit itself?', '["The dough and cheese","The unfulfilled order","The delivery rider","The pizza box"]'::jsonb, 'The delivery rider', 'Session 1 — Process View', 'Raw materials (dough, cheese) and the order itself are what''s flowing through the process -- they''re the flow unit, not resources. Resources are the doers of work: the chef, the oven, the rider. This is exactly the line between "cost of goods sold" (accounting) and a process''s actual inventory.', 'Ask what the flow unit is first. Then remember: resources are the **doers** of work (people, machines). Raw materials are part of what is flowing, not resources.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f3', 'OPMG', 'formula', 'littles_law', 1, 'A student club lets members list a "startup" on their resume via one of its portfolio companies. 200 students/year join a Full-Year plan (1 year), 400 students/year join a Placement-Season plan (3 months). 30% of subscribers on either plan choose to be listed as "Founder," and no portfolio company may have more than 2 Founders at a time. What''s the minimum number of portfolio companies needed?', '["30 companies","35 companies","45 companies","50 companies"]'::jsonb, '45 companies', 'Session 1 — Little''s Law', 'Founders-in-force at any time: I = 0.3xRfxTf + 0.3xRpxTp = 0.3x200x1 + 0.3x400x0.25 = 60+30 = 90. At 2 founders/company max, need at least 90/2 = 45 companies.', 'I = R × T. Identify which two you were given and solve for the third. If more than one type of customer shares the process, split them into segments **before** applying the law — the mixed population breaks it.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f4', 'OPMG', 'formula', 'littles_law', 1, 'BuyRite grocery: customers arrive at 300/hr, and on average 150 customers are in the store at any time (this figure already includes anyone in the checkout lane). On average, how long does a customer spend in the store?', '["35 minutes","33.33 minutes","30 minutes","25 minutes"]'::jsonb, '30 minutes', 'Session 1 — Little''s Law', 'Little''s Law: T = I/R = 150 / 300 per hr = 0.5 hr = 30 minutes. A common mistake is to add the checkout-lane customers on top of the 150 -- they''re already part of that total.', 'I = R × T. Identify which two you were given and solve for the third. If more than one type of customer shares the process, split them into segments **before** applying the law — the mixed population breaks it.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f6', 'OPMG', 'formula', 'littles_law', 1, 'A CEO receives 20 emails/hour, 20% "unimportant." On average there are three times as many unimportant emails sitting in the inbox as important ones. If an important email spends 4 minutes in the inbox on average, how long does an unimportant one spend?', '["4 minutes","12 minutes","16 minutes","48 minutes"]'::jsonb, '48 minutes', 'Session 1 — Little''s Law', 'Iu = 3xIi means 0.2RxTu = 3x(0.8RxTi), so Tu = 12xTi = 12x4 = 48 minutes. The "3x as many" refers to inventory (count sitting in the inbox), not directly to time -- you have to invert through the flow rates to get there.', 'I = R × T. Identify which two you were given and solve for the third. If more than one type of customer shares the process, split them into segments **before** applying the law — the mixed population breaks it.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f7', 'OPMG', 'formula', 'process_financial_link', 2, 'Rent-A-Dress needs an average of 4,400 dresses in its pipeline to support 100 rentals/day (10-day rentals). Each dress stays useful for about 125 days before retiring. What''s the average number of new dresses RAD purchases each day?', '["35 dresses/day","200 dresses/day","22 dresses/day","4,400 dresses/day"]'::jsonb, '35 dresses/day', 'Session 2 — Rent-A-Dress', 'Treat RAD as a process with new dresses as input and retired dresses as output: I=4,400, T=125 days. Little''s Law: R = I/T = 4400/125 = 35.2, approximately 35 dresses/day.', 'Idle inventory still depreciates. Work out total inventory across every stage, then multiply by the depreciation rate. Revenue only accrues on the units that are actually with a customer.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f8', 'OPMG', 'formula', 'process_financial_link', 2, 'After scaling to 150 rentals/day (10-day rentals, 2 dresses/rental), RAD''s internal process (all steps plus shipping) takes 5 days, and each dress now lasts 150 days before retiring. What''s the average number of new dresses RAD purchases per month (about 30 days)?', '["9,000","900","300","30"]'::jsonb, '900', 'Session 2 — Rent-A-Dress', 'Inventory with customers: 150x2x10=3,000. Inventory in the internal process: 150x2x5=1,500. Total I=4,500 dresses, T=150 days. R = I/T = 4500/150 = 30/day, times 30 days is approximately 900/month.', 'Idle inventory still depreciates. Work out total inventory across every stage, then multiply by the depreciation rate. Revenue only accrues on the units that are actually with a customer.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f9', 'OPMG', 'formula', 'process_financial_link', 2, 'RAD scales to 150 rentals/day, shipping stays 1 day each way, and a dress now spends 8 days in RAD''s internal process. If RAD owns 3,600 dresses on average, what''s the average number of dresses shipped per rental?', '["2 dresses/rental","1.5 dresses/rental","1.33 dresses/rental","1.2 dresses/rental"]'::jsonb, '1.2 dresses/rental', 'Session 2 — Rent-A-Dress', 'Total dress flow time T = 1+10+1+8 = 20 days. R(dresses) = I/T = 3600/20 = 180/day. Dresses per rental = R(dresses)/R(rentals) = 180/150 = 1.2.', 'Idle inventory still depreciates. Work out total inventory across every stage, then multiply by the depreciation rate. Revenue only accrues on the units that are actually with a customer.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f10', 'OPMG', 'formula', 'process_financial_link', 2, 'Gala Land theme park: on average, 3,200 visitors are in its stores and restaurants at any time, each spending at a rate of Rs 500/hour, over a 15-hour operating day. What''s the average concession revenue per day?', '["Rs 1.5 million","Rs 15 million","Rs 24 million","Rs 112.5 million"]'::jsonb, 'Rs 24 million', 'Session 2 — Rent-A-Dress', 'Revenue rate = 3,200 visitors x Rs 500/visitor/hr = Rs 1.6 million/hr. Over a 15-hour day: 1.6M x 15 = Rs 24 million/day.', 'Idle inventory still depreciates. Work out total inventory across every stage, then multiply by the depreciation rate. Revenue only accrues on the units that are actually with a customer.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f11', 'OPMG', 'formula', 'process_financial_link', 2, 'Gala Land launches a fast-track program letting some visitors skip the major-ride queue and spend that freed-up time at the concessions (Rs 500/hr) instead. The shift moves 600 frequent-visitor-hours and 450 infrequent-visitor-hours of "waiting" into "spending" inventory each day. What''s the change in daily park revenue?', '["No change -- fast-track isn''t priced","Increase by Rs 4.5 million","Increase by Rs 7.88 million","Decrease by Rs 4.5 million"]'::jsonb, 'Increase by Rs 7.88 million', 'Session 2 — Rent-A-Dress', 'The shifted inventory (600+450=1,050 visitor-hours) now earns concession revenue instead of sitting idle in a queue: (600+450) x Rs 500/hr x 15 hr/day = Rs 7.875 million, approximately Rs 7.88 million of increase.', 'Idle inventory still depreciates. Work out total inventory across every stage, then multiply by the depreciation rate. Revenue only accrues on the units that are actually with a customer.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f12', 'OPMG', 'formula', 'theoretical_flow_time', 3, 'At a vaccination facility, a pre-registered individual''s process is: 5 min verification + 2 min vaccination + 15 min observation. 2% of vaccinated individuals have an adverse reaction requiring 60 extra minutes with a doctor. What''s the average theoretical flow time for a pre-registered individual?', '["22 minutes","23.2 minutes","24.2 minutes","27 minutes"]'::jsonb, '23.2 minutes', 'Session 3 — Flow Time & Capacity', 'No-reaction path: 5+2+15=22 min. Reaction path: 22+60=82 min. Weighted average: 98%x22 + 2%x82 = 21.56+1.64 = 23.2 minutes.', 'Find the **longest** path through the process, then add activity times along that path only. Work on parallel branches that are not the critical path does not count.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f13', 'OPMG', 'formula', 'theoretical_flow_time', 3, 'A process has two paths from input to output: A-B-C-E (2+2+2+2=8 hrs) and A-D-E (2+3+2=7 hrs). What is the theoretical flow time of the process?', '["7 hours","8 hours","9 hours","15 hours (sum of every activity)"]'::jsonb, '8 hours', 'Session 3 — Flow Time & Capacity', 'Theoretical flow time is set by the critical path -- the LONGEST path through the process, not the sum of every activity in the diagram. A-B-C-E at 8 hours is longer than A-D-E at 7 hours, so TFT = 8 hours.', 'Find the **longest** path through the process, then add activity times along that path only. Work on parallel branches that are not the critical path does not count.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f14', 'OPMG', 'formula', 'process_capacity_bottleneck', 3, 'Kristen''s Cookie Co.: mixer (10/hr), Kristen (7.5/hr), roommate (15/hr), one oven (6/hr). The first order finishes in 26 minutes. With the single oven as the bottleneck, when does the 20th order finish (system starts empty)?', '["260 minutes","226 minutes","216 minutes","116 minutes"]'::jsonb, '216 minutes', 'Session 3 — Flow Time & Capacity', 'The oven (6/hr) is the bottleneck, so after the first order, each subsequent order arrives 1/6 hr = 10 min later. 20th order = 26 + (20-1)x10 = 26+190 = 216 minutes.', 'Capacity of each resource = 60 ÷ (minutes per unit), times the number of that resource. Process capacity is the **minimum** across resources. Flow rate = min(demand, capacity).', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f15', 'OPMG', 'formula', 'process_capacity_bottleneck', 3, 'Kristen''s Cookie Co. adds a second oven and fully cross-trains Kristen and her roommate into one combined "human resource" pool (12 min/order per person, 2 people, 5/hr capacity each). With 2 ovens (6/hr each), when does the 20th order finish?', '["80 minutes","86 minutes","140 minutes","216 minutes"]'::jsonb, '140 minutes', 'Session 3 — Flow Time & Capacity', 'The mixer and the cross-trained human-resource pool are now the joint bottleneck, each at 10/hr capacity. Orders arrive 1/10 hr = 6 min apart after the first. 20th order = 26 + (20-1)x6 = 26+114 = 140 minutes.', 'Capacity of each resource = 60 ÷ (minutes per unit), times the number of that resource. Process capacity is the **minimum** across resources. Flow rate = min(demand, capacity).', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f16', 'OPMG', 'formula', 'process_capacity_bottleneck', 3, 'An airport X-ray scanner screens bags at 12/minute. 5% of bags need an additional 90-second security-officer check. What''s the maximum rate bags can go through security?', '["600 per hour","40 per hour","720 per hour","Cannot be determined"]'::jsonb, '720 per hour', 'Session 3 — Flow Time & Capacity', 'X-ray capacity = 12x60 = 720/hr. The security officer''s time contribution per bag SCREENED is only 5%x90 sec = 4.5 sec/bag, giving a capacity of 3600/4.5 = 800/hr -- higher than the X-ray. The X-ray scanner is the bottleneck at 720/hr.', 'Capacity of each resource = 60 ÷ (minutes per unit), times the number of that resource. Process capacity is the **minimum** across resources. Flow rate = min(demand, capacity).', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c5', 'OPMG', 'case_fact', 'process_capacity_bottleneck', 3, 'Misty Cloud''s server processes 45 Advanced-Optimization (AO) requests/hr or 120 Basic-Analytics (BA) requests/hr. 60% of incoming requests are AO. What''s the server''s capacity in requests/hr, given this mix?', '["60","72","75","90"]'::jsonb, '60', 'Session 3 — Flow Time & Capacity', 'Time contribution per average request = 60%x(60/45 min) + 40%x(60/120 min) = 0.6x1.33+0.4x0.5 = 1.0 min/request. Capacity = 60/1.0 = 60/hr. The tempting trap answer, 0.6x45+0.4x120=75, wrongly averages CAPACITIES instead of TIME CONTRIBUTIONS -- since AO takes longer, the server spends more than 60% of its time on AO requests, not exactly 60%.', 'Capacity of each resource = 60 ÷ (minutes per unit), times the number of that resource. Process capacity is the **minimum** across resources. Flow rate = min(demand, capacity).', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c6', 'OPMG', 'case_fact', 'process_capacity_bottleneck', 3, 'Work flows A to B to C to D. Aaron alone does A (3 min); Aaron and Betty together do B (5 min); Betty and David together do C (4 min); David alone does D (3 min). What is the bottleneck of this process?', '["Activity B","Activity D","Activity A","None of the above -- the bottleneck must be a resource, not an activity"]'::jsonb, 'None of the above -- the bottleneck must be a resource, not an activity', 'Session 3 — Flow Time & Capacity', 'A bottleneck is always a RESOURCE (a person, a machine), not an activity. Aaron''s total load is A+B=8 min, Betty''s is B+C=9 min, David''s is C+D=7 min -- Betty is the true bottleneck resource, but no answer choice names a resource directly, so the correct answer flags the conceptual trap in the question itself.', 'Capacity of each resource = 60 ÷ (minutes per unit), times the number of that resource. Process capacity is the **minimum** across resources. Flow rate = min(demand, capacity).', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f17', 'OPMG', 'formula', 'process_capacity_bottleneck', 3, 'A vaccination center enforces the full 30-minute observation period (5% adverse-reaction rate). It has 2 registration staff (6 min/person average), 1 vaccinator (2 min/person), and 1 doctor (3 min/person on average, weighted by reaction rate). What is the center''s overall capacity?', '["10 vaccinated individuals per hour","20 vaccinated individuals per hour","30 vaccinated individuals per hour","40 vaccinated individuals per hour"]'::jsonb, '20 vaccinated individuals per hour', 'Session 3 — Flow Time & Capacity', 'Registration pool: 2 staff x (60/6)=10/hr each = 20/hr. Vaccinator: 60/2=30/hr. Doctor: 60/3=20/hr. Registration desk and doctor are jointly the bottleneck at 20/hr -- the center''s capacity is 20/hr.', 'Capacity of each resource = 60 ÷ (minutes per unit), times the number of that resource. Process capacity is the **minimum** across resources. Flow rate = min(demand, capacity).', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f18', 'OPMG', 'formula', 'process_capacity_bottleneck', 3, 'Coldice Hospital''s hernia procedure needs 30 minutes of surgeon+OR time per patient. 15 surgeons work mornings (5 hrs), 8 surgeons work afternoons (5 hrs); 12 operating rooms are available throughout. What''s the maximum number of patients Coldice can handle per day?', '["160 patients per day","200 patients per day","240 patients per day","400 patients per day"]'::jsonb, '200 patients per day', 'Session 3 — Flow Time & Capacity', 'Morning: min(15 surgeons x 2/hr, 12 rooms x 2/hr) = min(30,24)=24/hr, x5hrs=120. Afternoon: min(8x2, 12x2)=min(16,24)=16/hr, x5hrs=80. Total = 120+80 = 200 patients/day.', 'Capacity of each resource = 60 ÷ (minutes per unit), times the number of that resource. Process capacity is the **minimum** across resources. Flow rate = min(demand, capacity).', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f19', 'OPMG', 'formula', 'batching_capacity', 3, 'A pharma plant processes vaccine in batches: the vat step takes 1 hour regardless of batch size (up to 100L); bottling runs at 1,000 vials/hr (10 ml/vial). Currently using 10L batches, the manager wants to switch to 15L batches, expecting 50% more output per day. Is the manager right?', '["Yes, output increases by 50%","No, output does not increase by 50%","Yes, and flow time also decreases","Yes, but flow time increases"]'::jsonb, 'No, output does not increase by 50%', 'Session 3 — Flow Time & Capacity', 'At 10L: bottler takes 10,000ml/(1000x10ml/hr)=1hr, so capacity=1 batch/hr=10L/hr. At 15L: bottler takes 15,000ml at the same rate = 1.5hr, capacity=1/1.5=0.67 batch/hr = 0.67x15=10L/hr. The bottler becomes the sole bottleneck at the larger batch size, and process capacity stays exactly 10L/hr either way -- the batch-size change doesn''t touch overall output.', 'Batch size pulls flow time and capacity in opposite directions. Smaller batches cut flow time by letting stages overlap; larger batches raise capacity by spreading setup time over more units.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f20', 'OPMG', 'formula', 'batching_capacity', 3, 'A lab processes blood samples: 3 min/sample chemical purification (one technician, one sample at a time), then loading 5 samples into a centrifuge takes 5 minutes (technician), then 25 minutes of centrifuging (no technician needed) for the batch of 5. Clinics send samples in groups of 5. What''s the process capacity in samples/hour?', '["5 samples per hour","10 samples per hour","15 samples per hour","20 samples per hour"]'::jsonb, '10 samples per hour', 'Session 3 — Flow Time & Capacity', 'Using a group of 5 as the flow unit: the technician''s time per batch = 3x5+5=20 min, giving 3 batches/hr; the centrifuge''s time per batch = 5+25=30 min, giving 2 batches/hr. The centrifuge is the bottleneck at 2 batches/hr x 5 samples = 10 samples/hr.', 'Batch size pulls flow time and capacity in opposite directions. Smaller batches cut flow time by letting stages overlap; larger batches raise capacity by spreading setup time over more units.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f21', 'OPMG', 'formula', 'variability_queuing_basics', 4, 'Cars arrive at Quick Fill, a single-station petrol pump, at 6/hour on average; service takes 4 minutes on average. CVi = CVp = 1. What is the average number of cars at the petrol pump (waiting plus being served)?', '["1","0.267","0.4","0.667"]'::jsonb, '0.667', 'Session 4 — Variability & Queuing', 'Rp = 60/4 = 15/hr, c=1, u = 6/15 = 0.4. Working through the wait-time formula gives an average wait Wq of about 2.67 minutes. Total time in the system = Tp+Wq = 4+2.67 = 6.67 min. By Little''s Law, average cars at the station = Ri x (Tp+Wq) = (6/60) x 6.67 = 0.667.', 'CV = standard deviation ÷ mean. Remember that queues form from **variability**, not just from insufficient capacity — average capacity above average demand does not prevent a queue.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f22', 'OPMG', 'formula', 'variability_queuing_basics', 4, 'Suppose Quick Fill''s customers start refilling earlier (tank at 1/4 instead of 1/8 full), which raises the car arrival rate from 6/hr to 7/hr. Service time (4 min), CVi, and CVp stay unchanged. What is the new average time a car spends at the petrol pump?', '["10 minutes","6.67 minutes","7.5 minutes","10.67 minutes"]'::jsonb, '7.5 minutes', 'Session 4 — Variability & Queuing', 'New utilization u = 7/15 = 0.467. Plugging into the wait-time formula gives an average wait of about 3.5 minutes. Total time at the station = wait + Tp = 3.5+4 = 7.5 minutes.', 'CV = standard deviation ÷ mean. Remember that queues form from **variability**, not just from insufficient capacity — average capacity above average demand does not prevent a queue.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f23', 'OPMG', 'formula', 'variability_queuing_basics', 4, 'An airport has 2 runways; average time on the active runway per aircraft is 2.5 minutes. Total take-offs and landings average 40/hour. CVi = CVp = 1. What is the average time an aircraft waits after pushing back from the gate, before it can take off?', '["0 minutes","0.6 minutes","5.7 minutes","11 minutes"]'::jsonb, '5.7 minutes', 'Session 4 — Variability & Queuing', 'Rp = 60/2.5 = 24/hr, c=2, Ri=40/hr. Utilization u = 40/(2x24) = 0.833. Applying the wait-time formula with CVi=CVp=1 gives an average wait of about 5.7 minutes -- and by symmetry, take-off and landing waits are equal here since there''s no priority distinction yet.', 'CV = standard deviation ÷ mean. Remember that queues form from **variability**, not just from insufficient capacity — average capacity above average demand does not prevent a queue.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f24', 'OPMG', 'formula', 'variability_queuing_basics', 4, 'Using the same airport (2 runways, Rp=24/hr, total demand 40/hr, average wait 5.7 min per aircraft), what is the average number of aircraft waiting to land at any moment?', '["3.8","1.9","0.4","0.2"]'::jsonb, '1.9', 'Session 4 — Variability & Queuing', 'Landings are half of the 40/hr total, so R(landing) = 20/hr. By Little''s Law, average aircraft waiting to land = R x average wait = 20/hr x (5.7/60) hr = 1.9.', 'CV = standard deviation ÷ mean. Remember that queues form from **variability**, not just from insufficient capacity — average capacity above average demand does not prevent a queue.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f25', 'OPMG', 'formula', 'queuing_scale_pooling', 5, 'All''s Well Nursing Home (2 nurses, utilization 58.3%) has an 11-minute average wait. Do Good Hospital serves 10x the demand, staffed to the SAME 58.3% utilization. What happens to the average wait?', '["It stays at 11 minutes since utilization is unchanged","It roughly doubles, since demand is 10x higher","It collapses to about 105 seconds","It becomes unpredictable without more data"]'::jsonb, 'It collapses to about 105 seconds', 'Session 5 — Queuing Design', 'You only wait if every server happens to be busy at once. As the server pool grows at the same utilization, the odds of that happening shrink fast. Do Good''s wait falls to about 105 seconds despite serving 10x the patients, purely from scale -- bigger pools absorb randomness.', 'Utilisation ρ = Ri ÷ (c × Rp). One shared queue beats several dedicated ones; more servers at the same utilisation means shorter waits, because the odds of all servers being busy at once fall fast.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f26', 'OPMG', 'formula', 'queuing_scale_pooling', 5, 'All''s Well considers splitting its 2 nurses into two separate single-nurse stations, each taking half the patients (same total capacity, same 58.3% utilization per station). What happens to the average wait compared to one shared line?', '["It stays the same, since utilization per nurse is unchanged","It roughly doubles to about 28 minutes","It is cut in half","It depends on which nurse is faster"]'::jsonb, 'It roughly doubles to about 28 minutes', 'Session 5 — Queuing Design', 'Same resources, same busy-ness -- but splitting into separate un-pooled lines means a free nurse in one line can''t help a patient waiting in the other. Wait jumps from 11 minutes (pooled) to about 28 minutes (segregated) purely from the queue architecture.', 'Utilisation ρ = Ri ÷ (c × Rp). One shared queue beats several dedicated ones; more servers at the same utilisation means shorter waits, because the odds of all servers being busy at once fall fast.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f27', 'OPMG', 'formula', 'queuing_scale_pooling', 5, 'Two nurses can either work as specialists in a chain (each doing a separate 10-minute half of a 20-minute job, each in their own queue) or as a cross-trained team (both doing the full 20-minute job, sharing one queue). Which design produces less total waiting, and why?', '["The specialist chain, because each step is individually faster","The cross-trained team, because pooling avoids two separate un-pooled queues","Both are identical, since total work content is the same","It depends on which specialist goes first"]'::jsonb, 'The cross-trained team, because pooling avoids two separate un-pooled queues', 'Session 5 — Queuing Design', 'Splitting the job into a chain of specialists forces every patient through two separate, un-pooled queues back to back -- the worst of both worlds (about 28 min total). Cross-training and pooling into one shared queue for the full job cuts total wait to 11 minutes -- the same pooling-beats-segregation lesson, wearing a different costume.', 'Utilisation ρ = Ri ÷ (c × Rp). One shared queue beats several dedicated ones; more servers at the same utilisation means shorter waits, because the odds of all servers being busy at once fall fast.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c7', 'OPMG', 'case_fact', 'priority_queuing', 6, 'RGIA''s ground ops manager wants to reduce the average wait an aircraft experiences before landing (currently sharing 2 runways with take-offs). Landing delays are far more costly than take-off delays. Which change is likely to reduce the average landing wait?', '["Dedicate one runway exclusively to landings, one to take-offs","Give aircraft that need to land priority access to either runway","Either dedicating runways by type, or giving landing priority, would reduce the average landing wait","The only option is building a new runway"]'::jsonb, 'Either dedicating runways by type, or giving landing priority, would reduce the average landing wait', 'Session 6 — Priority Queuing', 'Both moves work, through two different levers. Priority access redistributes the SAME total wait toward landings and away from take-offs (the conservation law). Dedicating a runway to landings is a deliberate segregation choice -- justified here because reducing landing wait specifically is the actual goal, exactly the case where splitting into separate resource pools makes sense.', 'Overall average wait does not change when you add priority — it only moves. Solve the priority class as its own system, then back out the rest from the weighted average.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f28', 'OPMG', 'formula', 'priority_queuing', 6, 'If RGIA gives landing aircraft priority access to both runways (2 runways, Rp=24/hr, landing arrival rate 20/hr), what is the resulting average wait for a landing aircraft, and what happens to take-off wait?', '["Landing wait drops to about 0.6 minutes; take-off wait increases","Landing wait drops to about 0.6 minutes; take-off wait is unaffected","Neither wait changes, since runway capacity is fixed","Both waits drop, since priority improves overall efficiency"]'::jsonb, 'Landing wait drops to about 0.6 minutes; take-off wait increases', 'Session 6 — Priority Queuing', 'Treating both runways as available to landings first: u = 20/(2x24) = 0.417, giving an average wait of about 0.6 minutes. Since the system-wide average wait can''t change (same total demand, same total capacity), the wait saved by landings must show up as extra wait for take-offs -- the conservation law in action.', 'Overall average wait does not change when you add priority — it only moves. Solve the priority class as its own system, then back out the rest from the weighted average.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f29', 'OPMG', 'formula', 'priority_queuing', 6, 'Do Good Hospital''s 13 nurses produce a 9.43-minute average wait, undifferentiated. The hospital designates 20% of patients as emergency (near-zero wait) and the other 80% as non-emergency. Using the conservation law, what is the approximate wait for non-emergency patients?', '["9.43 minutes -- unchanged","About 11.8 minutes","About 4.7 minutes","About 47 minutes"]'::jsonb, 'About 11.8 minutes', 'Session 6 — Priority Queuing', 'The weighted average is pinned at 9.43: 0.2 x W(emergency) + 0.8 x W(non-emergency) = 9.43. With W(emergency) approximately 0, W(non-emergency) = 9.43/0.8 = 11.8 minutes.', 'Overall average wait does not change when you add priority — it only moves. Solve the priority class as its own system, then back out the rest from the weighted average.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c8', 'OPMG', 'case_fact', 'lean_fundamentals', 6, 'In the 4-station painting-workshop simulation, why did every team lose money in round 1 even though the stations averaged reasonable output?', '["Because the simulation charged an entry fee","Because inventory piled up in front of the bottleneck station, tying up cost without generating any extra sale","Because customers refused to buy the finished product","Because the fastest station was overpaid"]'::jsonb, 'Because inventory piled up in front of the bottleneck station, tying up cost without generating any extra sale', 'Session 6 — Lean Operations', '"Profit is not sales" -- teams that sold the most weren''t the most profitable, because work-in-progress stuck at the bottleneck was silently costing money (inventory, space) without ever converting to revenue. Same lesson as mismatched station capacities in Kristen''s Cookie Co., just with real money on the screen.', 'Waste is any gap from the ideal (instant output, zero inventory, zero flow time). Ask whether the fix targets the root cause or just hides the symptom with more inventory or more time buffer.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c9', 'OPMG', 'case_fact', 'lean_fundamentals', 6, 'Toyota held 2-6 months of semiconductor chip buffer inventory, which is why it was the only major automaker unaffected by the 2021 global chip shortage. Why doesn''t this contradict lean''s principle of eliminating inventory?', '["Lean only applies to finished-goods inventory, not raw materials","Toyota''s real rule was to eliminate EXCESS inventory -- the chip buffer was a deliberate, sized hedge against a real, quantifiable disruption risk, not waste from poor synchronization","Toyota is exempt from lean principles due to its size","The chip shortage made all inventory rules temporarily void"]'::jsonb, 'Toyota''s real rule was to eliminate EXCESS inventory -- the chip buffer was a deliberate, sized hedge against a real, quantifiable disruption risk, not waste from poor synchronization', 'Session 6 — Lean Operations', 'Lean''s target is waste, not all inventory. Plastic resin is easily substitutable (low disruption risk, no buffer needed); semiconductors take years to rebuild capacity (high disruption risk), so holding a buffer there is insurance, not muda. Competitors who copied only the headline "hold zero inventory" and skipped this nuance got hurt in 2021; Toyota didn''t.', 'Waste is any gap from the ideal (instant output, zero inventory, zero flow time). Ask whether the fix targets the root cause or just hides the symptom with more inventory or more time buffer.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c10', 'OPMG', 'case_fact', 'lean_fundamentals', 6, 'Which of the following is NOT one of the seven forms of waste (muda) named in class?', '["Overproduction","Excess inventory","Employee turnover","Rework (correction of defects)"]'::jsonb, 'Employee turnover', 'Session 6 — Lean Operations', 'The seven forms are: overproduction, waiting, excess inventory, unnecessary motion, unnecessary handling, non-value-adding processing, and rework. Employee turnover is a real business problem but isn''t one of the seven -- each of the seven is specifically a deviation from the ideal process of instant output, zero flow time, zero inventory, zero defects.', 'Waste is any gap from the ideal (instant output, zero inventory, zero flow time). Ask whether the fix targets the root cause or just hides the symptom with more inventory or more time buffer.', null, null, 2, 'prof_adapted', '2026-08-11T09:24:09.263753+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c11', 'OPMG', 'case_fact', 'quality_process_capability', 7, 'The upper and lower spec limits for coffee temperature are 185F and 175F. The process mean is 180F, sd is 5F. If a machine problem raises sd to 10F, which of the following will NOT happen?', '["The width of the USL and LSL band will increase","More defects will be generated","Sigma-capability of the process will reduce","More sample observations will fall outside control limits"]'::jsonb, 'The width of the USL and LSL band will increase', 'Session 7 — Quality & Process Capability', 'USL and LSL are set by the customer promise -- they don''''t move just because the process''s own variability changed. As sd rises, sigma capability falls, more output lands outside spec (more defects), and more sample means are likely to fall outside control limits.', 'Sigma capability = min[(USL − μ)/σ, (μ − LSL)/σ]. Always the **minimum**, never an average — and if only one spec limit exists, that is the only one you compute.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f31', 'OPMG', 'formula', 'quality_process_capability', 7, 'Lester Sporting Goods'' rubber-core molding process has a mean of 54.5 grams and sd of 0.55 grams, against a spec of 53-56 grams. What fraction of output falls within spec?', '["99.68%","99.86%","88.73%","99.36%"]'::jsonb, '99.36%', 'Session 7 — Quality & Process Capability', 'z for the USL = (56-54.5)/0.55 = 2.73; z for the LSL = (53-54.5)/0.55 = -2.73. The probability of landing within [-2.73, 2.73] on a standard normal is 99.36%.', 'Sigma capability = min[(USL − μ)/σ, (μ − LSL)/σ]. Always the **minimum**, never an average — and if only one spec limit exists, that is the only one you compute.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f32', 'OPMG', 'formula', 'quality_process_capability', 7, 'Wondrous Widgets is introducing a new product with spec limits (9.75, 10.25) and a process mean of 10. To achieve a sigma capability of 4, what should the process standard deviation be?', '["0.0625","0.1250","0.6250","1.0000"]'::jsonb, '0.0625', 'Session 7 — Quality & Process Capability', 'Since the process is centered within the spec limits: (10.25-10)/sd = 4, so sd = 0.25/4 = 0.0625.', 'Sigma capability = min[(USL − μ)/σ, (μ − LSL)/σ]. Always the **minimum**, never an average — and if only one spec limit exists, that is the only one you compute.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f33', 'OPMG', 'formula', 'quality_process_capability', 7, 'A machining step has mean 25 cm and sd 0.3 cm; spec limits are 24.55 and 25.45. A sample of 9 units is taken each hour. What is the sigma capability of this process?', '["1.5","3.0","4.5","9.0"]'::jsonb, '1.5', 'Session 7 — Quality & Process Capability', 'Sigma capability does not depend on sample size -- that detail is a distractor (it matters for control limits, not capability). Because the process is centered: (25.45-25)/0.3 = 1.5.', 'Sigma capability = min[(USL − μ)/σ, (μ − LSL)/σ]. Always the **minimum**, never an average — and if only one spec limit exists, that is the only one you compute.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c4', 'OPMG', 'case_fact', 'process_view', 1, 'For a pizza delivery process with flow unit "an order," what marks the process''s output boundary?', '["The moment ingredients arrive from the supplier","The moment the order is placed by the customer","The moment the order is fulfilled and delivered to the customer","The moment the kitchen starts prepping"]'::jsonb, 'The moment the order is fulfilled and delivered to the customer', 'Session 1 — Process View', 'A process view traces a flow unit from its defined input boundary to its output boundary. Domino''s flow unit -- an unfulfilled order -- exits the process the instant it becomes a fulfilled, delivered order. Ingredients arriving and prep starting are upstream of that boundary, not the boundary itself.', 'Ask what the flow unit is first. Then remember: resources are the **doers** of work (people, machines). Raw materials are part of what is flowing, not resources.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c12', 'OPMG', 'case_fact', 'spc_control_charts', 8, 'If a company narrows the control limits for a process without changing anything else about the process, which of the following happens?', '["The process will be stopped more often, suspecting an assignable cause","The sigma-capability of the process will reduce","The process will generate more defects","None of the above"]'::jsonb, 'The process will be stopped more often, suspecting an assignable cause', 'Session 8 — SPC & Control Charts', 'Narrowing control limits without any other change raises the chance of a Type I error -- incorrectly rejecting "nothing changed." It doesn''t touch process capability or the actual defect rate, both of which are properties of the process itself, not of where you draw the control lines.', 'Control limits = μ ± 3 × (σ/√n). Note the √n — a sample mean is drawn from a distribution that is narrower than the population by that factor. Spec limits come from the customer; control limits come from the process.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f34', 'OPMG', 'formula', 'spc_control_charts', 8, 'Wondrous Widgets samples 16 units every hour; process mean is 10mm, sd is 0.04mm. Using standard 3-sigma-of-the-sample-mean control limits, what should the upper control limit be?', '["10.01","10.03","10.04","10.12"]'::jsonb, '10.03', 'Session 8 — SPC & Control Charts', 'Standard deviation of the sample mean = 0.04/sqrt(16) = 0.01. UCL = 10 + 3x0.01 = 10.03.', 'Control limits = μ ± 3 × (σ/√n). Note the √n — a sample mean is drawn from a distribution that is narrower than the population by that factor. Spec limits come from the customer; control limits come from the process.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c13', 'OPMG', 'case_fact', 'spc_control_charts', 8, 'If every unit in a sample falls within the product''s specification limits, must the process be "in control"?', '["Yes, since all the output is acceptable","Yes, since there is a very small probability of a defect","No, since control limits could be much narrower than the specification limits","No, since the sample size may not be large enough to decide"]'::jsonb, 'No, since control limits could be much narrower than the specification limits', 'Session 8 — SPC & Control Charts', 'Whether a process is "in control" depends on comparing the sample mean to CONTROL limits (voice of the process), not specification limits (voice of the customer). If sigma capability is high, control limits can sit well inside spec limits -- so every unit can meet spec while the sample mean still falls outside the tighter control band, correctly signaling something changed.', 'Control limits = μ ± 3 × (σ/√n). Note the √n — a sample mean is drawn from a distribution that is narrower than the population by that factor. Spec limits come from the customer; control limits come from the process.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f36', 'OPMG', 'formula', 'spc_control_charts', 8, 'Vroom''s delivery times average 165 minutes with sd 10 minutes. A daily sample of 25 orders is checked against control limits of 161 and 169 minutes; each investigation costs Rs 20,000. What is the approximate average investigation cost per day, over the long run?', '["20,000","5,000","1,000","500"]'::jsonb, '1,000', 'Session 8 — SPC & Control Charts', 'Sample-mean sd = 10/sqrt(25) = 2. The control limits sit 2 sample-standard-deviations from the mean (z=+/-2). P(outside) = 2xP(Z<-2) = 2x0.0228 = 0.0455. Expected daily cost = 20,000 x 0.0455, approximately 1,000.', 'Control limits = μ ± 3 × (σ/√n). Note the √n — a sample mean is drawn from a distribution that is narrower than the population by that factor. Spec limits come from the customer; control limits come from the process.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f37', 'OPMG', 'formula', 'spc_control_charts', 8, 'Mellogg''s cereal boxes average 80g of raisins, sd 10g. A sample of 25 boxes is checked hourly; the line stops if the sample average falls below 75g or above 85g. On average, how often does the inspector stop the line even when nothing is actually wrong?', '["once every 100 hours","twice every 100 hours","once every 300 hours","never"]'::jsonb, 'once every 100 hours', 'Session 8 — SPC & Control Charts', 'Sample-mean sd = 10/sqrt(25) = 2. The control limits (75, 85) sit 2.5 sample-standard-deviations from the mean (5/2=2.5). P(Type I error) = 2xP(Z>2.5), approximately 1.2%, or roughly once per 100 hours.', 'Control limits = μ ± 3 × (σ/√n). Note the √n — a sample mean is drawn from a distribution that is narrower than the population by that factor. Spec limits come from the customer; control limits come from the process.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f38', 'OPMG', 'formula', 'six_sigma_dmaic', 8, 'Swishhh samples 50 orders/day; control limits are 161 and 169 minutes. Investigations that turn up nothing wrong cost Rs 1,000/day on average, at Rs 20,000 per investigation. What is the approximate process standard deviation?', '["5","11","14","17"]'::jsonb, '14', 'Session 8 — Six Sigma & DMAIC', 'P(false investigation) = 1,000/20,000 = 0.05, split evenly across both tails, so P(sample average > UCL) = 0.025, giving z=1.96. UCL=169=165+1.96 x sd/sqrt(50), so sd is approximately 14 minutes.', 'Six Sigma buys robustness against drift, not just a low steady-state defect count. Ask what happens when the mean inevitably shifts.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('f6', 'MKTG', 'formula', 'becr_cannibalization', 3, 'In the Kookaburra case, what was the Break-Even Cannibalization Rate (BECR) for the Niche strategy in Year 2?', '["29%","22%","35%","15%"]'::jsonb, '29%', 'Session 3 — Kookaburra', 'Kookaburra''s Niche Year 2 BECR was 29% — the ceiling it could tolerate. 22% was the case''s actual cannibalization rate, a different and easily confused number.', 'BECR = new product contribution ÷ old product contribution. Compare it against the actual cannibalisation rate — above BECR means the launch loses money.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('f7', 'MKTG', 'formula', 'pricing_elasticity', 8, 'Golden Rule of Pricing: (p − mc)/p = 1/elasticity. If price elasticity is 4, what''s the optimal % margin?', '["25%","4%","40%","75%"]'::jsonb, '25%', 'Session 8 — Golden Rule of Pricing', '1/4 = 25%. 4% inverts the fraction the wrong way; 40% and 75% aren''t reciprocals of 4 at all.', 'Golden rule: (p − mc) ÷ p = 1 ÷ ε. Percent margin equals one over elasticity, so more elastic demand means a lower optimal price.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('f8', 'MKTG', 'formula', 'evc', 7, 'UNO washable diaper example: Reference Value = ₹1,800/month, Net Differential Value = ₹400/month. What''s the Total EVC?', '["₹2,200/month","₹1,800/month","₹2,300/month","₹1,300/month"]'::jsonb, '₹2,200/month', 'Session 7 — EVC', '₹1,800 + ₹400 = ₹2,200. ₹1,800 alone is just the Reference Value with no credit for the differentiation.', 'EVC = reference value + net differential value. Reference is what the next-best alternative costs them; differential is extra benefits minus extra costs. EVC is the ceiling, not the price.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('c1', 'MKTG', 'case_fact', 'case_unilever_brazil', 5, 'Unilever created a brand new product to enter Brazil''s low-income NE market, positioned between Minerva and Campeiro. What was it called?', '["\"Ala\"","\"Omo Light\"","\"Minerva Basic\"","\"Campeiro Plus\""]'::jsonb, '"Ala"', 'Session 5 — Unilever Brazil case', '"Ala" was the new brand. The case explicitly considers and rejects repositioning Minerva or extending Omo — those were on the table but not the final call.', 'Price conscious is not the same as value conscious. The Northeast customer will pay for cleaning and whitening because they hand-wash with soap that yellows clothes.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('c3', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4, 'In 2009, United had the lowest customer satisfaction score among major US airlines. What was it?', '["56","81","68","60"]'::jsonb, '56', 'Session 4 — United Breaks Guitars case', '56 was United''s score, the lowest that year. 81 was Southwest''s — the highest — easy to swap if you''re recalling the range instead of the specific airline.', 'United sells affordable connectivity, not premium service. Ask what the OPTIMAL level of service is for that value proposition, not the maximum.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('c4', 'MKTG', 'case_fact', 'case_atlantic_computer', 8, 'Which of the four pricing approaches considered in the Atlantic Computer case uses the customer''s value-in-use to set a defensible price ceiling?', '["Value-in-use (EVC-based)","Cost-plus","Status-quo","Competition-based"]'::jsonb, 'Value-in-use (EVC-based)', 'Session 8 — Atlantic Computer case', 'Value-in-use IS the EVC-based approach. The other three are the other options the case explicitly compares it against.', 'Two routes: EVC-based anchors on variable cost as the floor; value-in anchors on the current market price. Value-in always gives the higher number — say which you used.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('c5', 'MKTG', 'case_fact', 'case_air_france', 9, 'In the Air France case, how did Kayak''s pricing model differ from Google/Yahoo/MSN''s?', '["Flat listing/click fee instead of bid-based CPC","Pure bid-based CPC, same as the others","Monthly flat subscription","Revenue share on bookings"]'::jsonb, 'Flat listing/click fee instead of bid-based CPC', 'Session 9 — Air France case', 'Kayak''s flat-fee model, not bid-based CPC, was the whole reason it needed separate treatment in the case''s analysis.', 'Low CTR is an ad problem; low TCR is a website problem. And an implausibly high ROA usually signals attribution error, not real return.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('c6', 'MKTG', 'case_fact', 'case_kookaburra', 3, 'The Kookaburra case centers on a cannibalization risk in which industry?', '["Cricket bats","Laundry detergent","Airlines","Search advertising"]'::jsonb, 'Cricket bats', 'Session 3 — Kookaburra case', 'Cricket bats. The case uses this concrete product to teach cannibalization/BECR analysis, later reused conceptually in Unilever Brazil.', 'Units cannibalised = new product volume × cannibalisation rate. Multiply that by the OLD product margin (₹810.47) to get the cost of cannibalisation.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c1', 'OPMG', 'case_fact', 'strategy_process_alignment', 1, 'GoGo Airlines wants to position itself like IndiGo -- affordable fares, reliable on-time service, convenient connectivity. Which operational initiative should GoGo NOT pursue if it wants to preserve alignment between its strategy and its operations?', '["Add modest schedule buffers at congested airports, even if it slightly reduces aircraft utilization","Use common operating procedures and a limited number of aircraft families to simplify training, maintenance, and scheduling","Introduce a variety of cabin layouts, boarding procedures, and service routines on business-traveler-heavy routes","Use digital check-in, automated disruption alerts, and standardized ground processes to cut cost and improve reliability"]'::jsonb, 'Introduce a variety of cabin layouts, boarding procedures, and service routines on business-traveler-heavy routes', 'Session 1 — Strategy & Process Alignment', 'Differentiated service on select routes might generate extra revenue there, but it injects variation into aircraft assignment, crew training, boarding, and scheduling -- exactly the complexity a low-cost, reliable operating system is built to avoid. The other three options all support GoGo''s actual value proposition: buffers protect reliability, standardization supports cost efficiency, and digitalization improves both.', 'Name the value proposition before you judge the operational choice. There is no context-free right answer — the question is always "right for what promise?"', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f1', 'OPMG', 'formula', 'littles_law', 1, 'A consulting firm has 8 client projects going on at any time; on average, each project takes 4 months to complete. On average, how many projects is the firm completing per month?', '["8","4","2","1"]'::jsonb, '2', 'Session 1 — Little''s Law', 'Little''s Law: R = I/T = 8 projects / 4 months = 2 projects per month.', 'I = R × T. Identify which two you were given and solve for the third. If more than one type of customer shares the process, split them into segments **before** applying the law — the mixed population breaks it.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('c2', 'MKTG', 'case_fact', 'case_bmw_films', 2, 'In the BMW Films campaign ("The Hire" series), which short film was the most popular?', '["\"Star\"","\"Ambush\"","\"Chosen\"","\"Ticker\""]'::jsonb, '"Star"', 'Session 2 — BMW Films case', '"Star" was the most-watched film in the series — the case''s headline engagement stat.', 'The target was future 3-series buyers, not current owners. Registration friction was deliberate — it kept the 7-series segment out.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('c7', 'MKTG', 'case_fact', 'case_uber_ml', 4, 'In the Uber ML case, the customer pickup journey starts with which stage?', '["Contextualize","Assist","Track","Meet"]'::jsonb, 'Contextualize', 'Session 4 — Uber ML case', 'Contextualize is the first stage. Assist is the second — a near neighbor, which is why it''s a tempting wrong pick.', 'The pickup quality metric is a weighted composite: 30% ETA accuracy, 20% driver idle, 30% location error, 20% cancellation. And it should be computed per segment.', null, null, 2, 'prof_adapted', '2026-08-09T14:41:20.649516+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f5', 'OPMG', 'formula', 'littles_law', 1, 'Mt. Kinley, a consulting firm, has held steady at 200 associates on average for 20 years. An associate is promoted to manager or leaves after 4 years. How many new MBA graduates does Mt. Kinley need to hire each year?', '["200 graduates per year","100 graduates per year","50 graduates per year","10 graduates per year"]'::jsonb, '50 graduates per year', 'Session 1 — Little''s Law', 'Little''s Law on the associate pool: R = I/T = 200 associates / 4 years = 50 hires per year.', 'I = R × T. Identify which two you were given and solve for the third. If more than one type of customer shares the process, split them into segments **before** applying the law — the mixed population breaks it.', null, null, 2, 'prof_adapted', '2026-08-11T09:22:37.908389+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f30', 'OPMG', 'formula', 'quality_process_capability', 7, 'C & A''s potato chip filling process has a lower spec limit of 9.5 oz and an upper spec limit of 10.5 oz. The process standard deviation is 0.3 oz, mean is 10 oz. What is the sigma capability?', '["3.33","1.11","1.67","1.00"]'::jsonb, '1.67', 'Session 7 — Quality & Process Capability', 'USL-mean = mean-LSL = 0.5 oz (the process is centered). Sigma capability = 0.5/0.3 = 1.67.', 'Sigma capability = min[(USL − μ)/σ, (μ − LSL)/σ]. Always the **minimum**, never an average — and if only one spec limit exists, that is the only one you compute.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f35', 'OPMG', 'formula', 'spc_control_charts', 8, 'LSG uses a sample size of 25 (process mean 54.5g, sd 0.55g) with standard 3-sigma control limits. What are the control limits?', '["52.8500 and 56.1500","54.1700 and 54.8300","53.0000 and 56.0000","54.0875 and 54.9125"]'::jsonb, '54.1700 and 54.8300', 'Session 8 — SPC & Control Charts', 'Sample standard deviation = 0.55/sqrt(25) = 0.11. UCL = 54.5+3x0.11 = 54.83; LCL = 54.5-3x0.11 = 54.17.', 'Control limits = μ ± 3 × (σ/√n). Note the √n — a sample mean is drawn from a distribution that is narrower than the population by that factor. Spec limits come from the customer; control limits come from the process.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c14', 'OPMG', 'case_fact', 'six_sigma_dmaic', 8, 'Through process improvement, Swishhh doubles its process capability (halves its standard deviation) while keeping its control limits unchanged. What happens to the average cost of unnecessary investigations per day?', '["Reduced by less than half","Halved","Reduced by more than half","Remains unchanged"]'::jsonb, 'Reduced by more than half', 'Session 8 — Six Sigma & DMAIC', 'Halving sd pushes the control limits from about 2 sample-standard-deviations away to about 4 away. Because a normal distribution''s tail shrinks much faster than linearly, the Type I error probability collapses from about 5% to a tiny fraction of a percent -- the cost of unnecessary investigation falls by far more than half. This is exactly the "robustness to drift" payoff Six Sigma is really about.', 'Six Sigma buys robustness against drift, not just a low steady-state defect count. Ask what happens when the mean inevitably shifts.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f39', 'OPMG', 'formula', 'six_sigma_dmaic', 8, 'After doubling its process capability, what new control limits would Swishhh need to set to keep its investigation cost exactly the same as before?', '["[161,169]","[150,180]","[157.5,172.5]","[163,167]"]'::jsonb, '[163,167]', 'Session 8 — Six Sigma & DMAIC', 'Keeping the same investigation rate means keeping the same z-value (1.96) relative to the NEW, smaller sample standard deviation. With sd halved, the control band that reproduces the same z-distance is correspondingly narrower: [163,167] instead of the original [161,169].', 'Six Sigma buys robustness against drift, not just a low steady-state defect count. Ask what happens when the mean inevitably shifts.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f40', 'OPMG', 'formula', 'newsvendor_model', 9, 'Kristen''s Cookie Co. sells cookies at $2.49/dozen, costs $1.24/dozen to make, and sells leftovers same-night at $0.99/dozen. What is the optimal service level SL*?', '["50.0%","83.3%","16.7%","20.0%"]'::jsonb, '83.3%', 'Session 9 — Newsvendor Model', 'Cu = 2.49-1.24 = $1.25. Co = 1.24-0.99 = $0.25. SL* = Cu/(Cu+Co) = 1.25/1.50 = 83.3%.', 'Cu = price − cost, Co = cost − salvage. Critical ratio = Cu ÷ (Cu + Co). That ratio is the target service level, and only then do you convert it into a quantity using the demand distribution.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-f41', 'OPMG', 'formula', 'newsvendor_model', 9, 'Given SL*=83.3% for Kristen''s cookies, and the cumulative demand probability crosses 83.3% right at 13 dozen, what should Kristen stock?', '["10 dozen","13 dozen","16 dozen","18 dozen"]'::jsonb, '13 dozen', 'Session 9 — Newsvendor Model', 'Q* is the smallest stocking quantity where P(Demand <= Q) >= SL*. For cookies that''s 13 dozen -- matching the brute-force expected-profit-maximizing answer, but now you know why.', 'Cu = price − cost, Co = cost − salvage. Critical ratio = Cu ÷ (Cu + Co). That ratio is the target service level, and only then do you convert it into a quantity using the demand distribution.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c15', 'OPMG', 'case_fact', 'newsvendor_model', 9, 'Kristen''s scones have the same mean demand and the same economics as her cookies (so the same SL*=83.3%), but a flatter, more spread-out demand distribution. What changes as a result?', '["SL* rises above 83.3% for scones","The stocking quantity Q* is higher for scones (16 vs 13), and expected profit is lower even when stocked optimally","Nothing changes -- SL* and Q* are identical for both products","SL* falls below 83.3% for scones"]'::jsonb, 'The stocking quantity Q* is higher for scones (16 vs 13), and expected profit is lower even when stocked optimally', 'Session 9 — Newsvendor Model', 'The optimal service level SL* is pure economics -- it doesn''t move when the demand distribution changes. What changes is the physical quantity needed to hit that service level: a flatter, more variable demand distribution needs more inventory (16 vs 13 dozen) to reach the same 83.3%, and variability is costly even when you respond to it perfectly -- expected profit is lower.', 'Cu = price − cost, Co = cost − salvage. Critical ratio = Cu ÷ (Cu + Co). That ratio is the target service level, and only then do you convert it into a quantity using the demand distribution.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c16', 'OPMG', 'case_fact', 'newsvendor_model', 9, 'Hotel California sells advance rooms at $200 and last-minute rooms at $300, holding 3 rooms back for last-minute demand. Why is Cu = $100, not $300?', '["Because $300 is too high to be realistic","Because you would have earned $200 anyway from an advance booking -- Cu is the incremental gain over the next-best alternative, not the full transaction value","Because the hotel only has 3 rooms","Because Cu must always equal Co"]'::jsonb, 'Because you would have earned $200 anyway from an advance booking -- Cu is the incremental gain over the next-best alternative, not the full transaction value', 'Session 9 — Newsvendor Model', 'Cu measures the loss from understocking by one unit -- the INCREMENTAL benefit of having one more unit available. Since an unsold last-minute room could have been sold in advance for $200 anyway, the true marginal gain from holding it for a last-minute sale is only the $100 premium ($300-$200), not the full $300.', 'Cu = price − cost, Co = cost − salvage. Critical ratio = Cu ÷ (Cu + Co). That ratio is the target service level, and only then do you convert it into a quantity using the demand distribution.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c17', 'OPMG', 'case_fact', 'newsvendor_model', 9, 'A firm adds a "quick response" option to its newsvendor process -- if it understocks, it can now place a costlier emergency top-up order instead of losing the sale outright. What happens to the optimal service level SL*?', '["SL* rises, since the firm can now serve any leftover demand","SL* falls, since understocking no longer means losing the sale outright -- just paying a higher marginal cost","SL* is unaffected, since it never depends on operational flexibility","SL* becomes undefined once emergency orders are possible"]'::jsonb, 'SL* falls, since understocking no longer means losing the sale outright -- just paying a higher marginal cost', 'Session 9 — Newsvendor Model', 'Quick response shrinks Cu, the cost of understocking -- you no longer lose the whole margin, just the difference between the emergency-order cost and the original cost. A smaller Cu means a smaller Cu/(Cu+Co), so the optimal service level drops -- the firm can safely take on more upfront stockout risk because it now has a safety valve. (Worked in class: SL* dropped from 75% with no quick-response option to 50% with it.)', 'Cu = price − cost, Co = cost − salvage. Critical ratio = Cu ÷ (Cu + Co). That ratio is the target service level, and only then do you convert it into a quantity using the demand distribution.', null, null, 2, 'prof_adapted', '2026-08-11T09:25:48.998928+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c18', 'OPMG', 'case_fact', 'subscription_model_dynamics', 3, 'Rent-A-Dress considers a subscription model. Why might higher subscription usage actually push the business further into a loss, similar to what happened when it simply served more 10-day-rental demand?', '["Higher usage always increases inventory turnover, which is bad for asset utilization","Once a customer has paid the subscription fee, they feel compelled to extract value from it, driving order frequency up -- and each extra order still carries its full operational cost even though it earns no extra revenue","Subscriptions eliminate variable costs entirely","Higher usage reduces the need for shipping"]'::jsonb, 'Once a customer has paid the subscription fee, they feel compelled to extract value from it, driving order frequency up -- and each extra order still carries its full operational cost even though it earns no extra revenue', 'Session 3 — Subscription Models', 'Subscriptions decouple REVENUE from usage (you''re paid the same fee regardless), but they don''t decouple COST from usage -- every order a subscriber places still needs shipping, inspection, and cleaning. If a flat fee triggers a usage increase, the firm can end up paying full operational cost for volume it isn''t earning any extra revenue on, worsening the loss exactly the way scaling 10-day-rental demand did in the base case.', 'A subscription decouples revenue from cost — but it also raises usage. For a business holding physical stock, higher usage means more inventory in the cycle and more depreciation.', null, null, 2, 'prof_adapted', '2026-08-11T09:34:01.971229+00:00');
insert into public.learn_questions (id, course_code, type, topic, session, prompt, choices, correct_answer, source, explanation, hint, scenario_id, scenario_order, difficulty, provenance, created_at) values ('opm-c19', 'OPMG', 'case_fact', 'subscription_model_dynamics', 3, 'HUL and other FMCG firms can''t decouple revenue from cost the way a subscription business can -- a demand shock hits both sides at once. What''s HUL''s actual buffer against this?', '["It stockpiles finished inventory to smooth demand shocks","It runs on negative net working capital, routinely owing suppliers money for 60-70 days, partially insulating the cost side when demand dips","It uses dynamic pricing to match cost to demand","It vertically integrates into every input it uses"]'::jsonb, 'It runs on negative net working capital, routinely owing suppliers money for 60-70 days, partially insulating the cost side when demand dips', 'Session 3 — Subscription Models', 'Without a subscription model to decouple revenue from cost, HUL instead buys itself timing flexibility on the cost side: because it typically pays suppliers well after it''s already collected cash from its own sales, a demand dip doesn''t immediately translate into a cash crunch the way it would for a firm paying suppliers upfront.', 'A subscription decouples revenue from cost — but it also raises usage. For a business holding physical stock, higher usage means more inventory in the cycle and more depreciation.', null, null, 2, 'prof_adapted', '2026-08-11T09:34:01.971229+00:00');

-- learn_concepts: 32 rows
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'pricing_elasticity', 'Golden Rule of Pricing', '
Every pricing conversation eventually reaches the same question: if we raise the price, how much volume do we lose?

Economics has a precise answer, and it compresses into one of the most useful lines in the course.

## The rule

$$\frac{p - mc}{p} = \frac{1}{\varepsilon}$$

Percent margin equals one over price elasticity.

Read it plainly: **the more price-sensitive your customers, the lower your optimal margin.** If demand is very responsive to price, you make money on volume at a thin margin. If it barely responds, you make money on margin.

The everyday version — *if consumers keep buying when you raise the price, raise the price* — is the same statement without the algebra.

:::viz break-even price=100 cost=40 fixed=5000 currency="$" unit="units"

## What actually makes customers less price-sensitive

Elasticity is not a fixed property of a product. It is a property of the **buying situation**, and you can influence several of these:

- **High switching costs** — leaving is expensive, so a price rise does not trigger an exit
- **Price-quality inference** — with no other signal, a higher price *reads* as higher quality
- **Shared cost** — someone else pays part of it (an employer, an insurer), so the buyer feels less of the rise
- **No easily comparable alternative** — comparison is what makes people sensitive
- **Small share of total spend** — nobody optimises the cheapest line on a large invoice
- **Cannot stockpile** — they cannot wait for a promotion and buy in bulk

Notice how many of these are design decisions rather than facts about the market.

> Trap: **Elasticity is not sensitivity.** Elasticity is a measurable number you put into the formula. Sensitivity is qualitative — more or less. Exam wording distinguishes them deliberately, so a question asking about sensitivity is not asking you to compute anything.

## Measuring it

The 2×2 worth remembering, because it organises every method:

| | Natural | Experimental |
|---|---|---|
| **Actual purchase** | Sales data | Field/lab experiments |
| **Preferences** | Surveys | Conjoint analysis |

Actual purchase data is more trustworthy but harder to vary; stated preference is easy to gather and people lie. Conjoint sits in the useful corner: stated preference, but structured so the tradeoffs reveal what a direct question would not.

## Price discrimination

If different customers have different elasticities, charging them all the same price leaves money on the table for some and loses sales among others.

| Degree | Basis | Example |
|---|---|---|
| First | Individual | Personalised pricing |
| Second | Self-selection | Bundles, cabin classes |
| Third | Segment | Student, senior |
| Behavioural | Past behaviour | Amazon reading purchase history |
| Intertemporal | Time | Skimming, or rising for network goods |

> Worked example: Bundling is second-degree, and it works on **negatively correlated valuations**. If you value A highly and B little, and I am the reverse, a single bundle price extracts more from both of us than two separate prices would — because each of us is paying mostly for the half we wanted.

## Psychological pricing

> Trap: Prices ending in 9 work through **category perception**, not the value of one cent. $79.99 lands in the "seventy-something" mental bucket rather than the "eighty" one. The saving is irrelevant; the bucket is the entire effect.

Higher prices also raise perceived — and even *experienced* — quality. The MRI wine study found the brain''s pleasure response differed for identical wine presented at a higher stated price. People were not lying about enjoying it more.

**Prospect theory**: losses loom larger than equivalent gains. So when framing a price, **segregate gains and aggregate losses** — present savings separately so each registers, and bundle costs together so they are felt once.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'grp_advertising', 'GRP (Gross Rating Points)', '
A media plan comes back promising 60 GRPs. Is that a good plan?

You still cannot say, and the reason exposes what the metric does and does not capture.

## The definition

$$\text{GRP} = \text{Reach} \times \text{Frequency}$$

**Reach** is the share of your target audience exposed at least once. **Frequency** is how many times each of them sees it on average.

> Worked example: 20% reach × 3 exposures = **60 GRPs**.

## Why the number alone is not enough

> Trap: The same GRP figure describes completely different campaigns. 60 GRPs is 20% reach × 3, or 60% reach × 1, or 10% reach × 6. One of those talks to a lot of people once; another talks to very few people repeatedly. GRP cannot tell them apart, and they are not interchangeable.

So the useful question is never "how many GRPs" but **which of the two you should be buying**.

- **New product** — buy reach. Nobody knows you exist, and telling the same tiny group six times does not fix that.
- **Established brand in a reminder role** — buy frequency, delivered in pulses. Coca-Cola does not need reach; everyone has heard of it.

That maps directly onto the roles of advertising: informative campaigns want reach, reminder campaigns want frequency.

## The response curve

Advertising does not convert money into awareness at a constant rate. The curve has three parts:

- Below a **critical spend**, essentially nothing happens
- Then a responsive middle where extra spend genuinely buys attention
- Then a plateau, where more money changes little

> Trap: Spending below the critical threshold is worse than not spending at all — you pay without ever crossing into the range where anything happens. This is why halving a campaign budget can eliminate its return entirely rather than halving it, and why a small brand is often better off dominating one channel than sprinkling across four.

## How much to spend

$$\frac{A}{pQ} = \left(\frac{p - c}{p}\right) \times \varepsilon_{DA}$$

Ad spend as a share of revenue equals percent margin times advertising elasticity.

Both terms have to be present. Advertise more when the margin is high **and** demand actually responds to advertising — a high-margin product nobody''s purchase is influenced by advertising does not justify the spend, and neither does a highly ad-responsive product you make no money on.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'break_even', 'Break-Even Volume', '
You are offered a display rack for your product in a shop. It costs $60 for the season. Should you take it?

You cannot answer with an opinion. But you can answer with a number: **how many extra units would it have to sell before it pays for itself?** If that number looks achievable, take it. If it does not, walk away.

That is break-even analysis. It converts an argument into an arithmetic question.

## The formula, and why it is that

Each unit you sell contributes $p - c$ towards covering your fixed costs — its **unit contribution**. The fixed cost sits there needing to be covered. So:

$$Q_{BE} = \frac{F}{p - c}$$

> Worked example: A $60 display rack, a Snickers bar with $0.30 of contribution.

$$Q_{BE} = \frac{60}{0.30} = 200 \text{ bars}$$
> Two hundred extra bars over the season. Now the decision is a judgement about the shop''s footfall, not about whether $60 feels like a lot.

Drag the price below and watch how sharply that crossing point moves.

:::viz break-even price=1 cost=0.7 fixed=60 currency="$" unit="bars"

## What counts as a fixed cost

> Trap: Ignore sunk costs. Money already spent is not part of the decision, however painful it was. Only costs that **change with the decision** belong in the calculation. If you already paid for the rack, the question is no longer whether to buy it — it is what to do now that you have it.

## When the margin changes

The more revealing use of break-even is not "should I buy this" but "what happens if I cut price?"

$$\frac{Q_{BE}^{\text{new}}}{Q^{\text{old}}} = \frac{\text{old contribution}}{\text{new contribution}}$$

Contribution and required volume move in inverse proportion. Halve the contribution and you need **twice the volume just to stand still**.

That is why a "small" price cut is rarely small. Dropping from $0.30 to $0.20 of contribution — ten cents, on a dollar item — means you need to sell half as much again before you are back where you started. Most price cuts are proposed without anybody running that number.

## What break-even does not tell you

> Prof: Break-even and sensitivity analysis are the **first step**, not the decision. They tell you what has to be true, not whether it will be. Strategic, social and ethical factors sit alongside the arithmetic.

The honest way to use it is as a reality check on a claim. Someone says the promotion will work; break-even tells you it needs 200 extra bars; now you can have a productive argument about whether 200 is plausible, which is a much better conversation than trading intuitions about $60.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'case_united_breaks_guitars', 'United Breaks Guitars', '
This case arrives disguised as a customer service disaster. It is actually a test of whether you will let outrage override strategy.

## What happened

In 2008 Dave Carroll flew Halifax to Omaha and United broke his guitar. No compensation. Fifteen months later he posted a song about it on YouTube.

The VP of Customer Relations offered **$2,400**. Carroll declined. United donated **$3,000** to a music school. United responded publicly **only on Twitter**, including the line: "The fact is that 99.95% of our customers'' bags are delivered on time and without incident."

Carroll became a celebrity, made a public fuss when his bag went missing on a later United flight, and wrote two more songs.

Every instinct says United handled this badly and should invest heavily in service. Hold that thought.

## The context that changes the answer

United''s economy value proposition is **affordable connectivity**. Mainstream, deliberately not premium. Customers buy it because it is cheap and it goes where they need to go.

2009 satisfaction scores: Southwest 81, Continental 68, Delta 64, American 60, US Airways 59, Northwest 57, **United 56 — last.**

That looks damning until you ask what those scores cost to move, and who is paying.

## Should United have improved customer service?

Three things to weigh: the **service-profit relationship**, **vertical differentiation**, and **who the target segment actually is**.

> Prof: There will come a point where offering more customer service does not bring a return on investment. You should stop increasing it at that point. There is an optimal level of customer service for every product and service.

Note the word: *optimal*, not maximum. Service costs money, that money comes from somewhere, and for a price-driven segment it comes out of the fare.

**Vertical differentiation** is the formal version. When consumers differ in willingness to pay, firms deliberately offer higher and lower quality at different prices. Customers who will not pay much get the lower-quality option — and choosing to serve them properly at that price is a strategy, not a failure.

> Trap: The expected answer is **not** "United should have apologised faster." Highest possible service is not always desirable. Serving a low-willingness-to-pay segment with a deliberately lower-quality service is a legitimate position. Do what is right for your target segment, not what the internet demands.

## The compensation question

The same shape. What was the **objective** of compensating him — repairing a relationship, buying silence, doing what was fair? How much would have been enough? And what precedent does any number set for every other broken guitar on every other flight?

> Prof: Do what is right for you, not what others want you to do.

A payment large enough to satisfy a viral complainant is a payment you have now promised to everybody with a camera.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'case_uber_ml', 'Uber ML — Pickup Experience', '
Uber''s riders and drivers were both unhappy about pickups, and neither could articulate why in a way that was actionable.

This case is about turning a vague complaint into something a company can actually build against — and about deciding whether machine learning is the right tool at all.

## First, map the journey

Before any modelling, the team broke the pickup into six stages and asked what goes wrong at each — **on both sides**, because a rider problem and a driver problem often turn out to be the same event viewed twice.

| Stage | Rider pain | Driver pain |
|---|---|---|
| **Contextualize** | The car passed me, I have to walk | I can''t see the rider |
| **Assist** | Wrong pickup location, I have to coordinate | Rider is elsewhere, I loop around |
| **Depict** | I''m at the location, the driver isn''t | Rider is not where depicted |
| **Navigate** | Driver stopped on the wrong side | Lost time to bad navigation |
| **Track** | The car icon spins, the ETA keeps changing | Rider cancels after I''ve driven minutes |
| **Meet** | I can''t find my car among all the Ubers | I can''t find my rider in a crowd |

That table is the real deliverable. "Pickups are bad" is unbuildable; "the ETA keeps updating while the icon spins" is a specific thing an engineer can attack.

## Then define what good means

You cannot improve what you cannot score. Uber compressed the whole experience into one number:

$$\text{Pickup Quality} = \min\big[0.30\,(\text{ETA vs ATA}) + 0.20\,(\text{Driver idle}) + 0.30\,(\text{Location error}) + 0.20\,(\text{Cancellation})\big]$$

Four components, weighted. Note that two of them (driver idle, cancellation) are about the *driver''s* experience — a rider-only metric would have optimised the supply side into the ground.

The case then asks two follow-ups that matter more than the formula: **is this the right approach, and how would you validate it?** A weighted composite is a choice, not a fact, and those weights were picked by people.

> Trap: A complete analysis requires running this **separately for each of Uber''s five target segments**. A single blended metric hides the segment where the experience is worst — and that is usually the segment about to churn.

## Only then, the model

The build sequence is deliberately cross-functional, and who *leads* changes at each stage:

- **Business analyst leads** — define the problem, decide whether ML is even appropriate, gather and label data
- **Data scientist leads** — preprocess, define features, select the approach, improve the model
- **UX leads** — make the decisions, design the experience

> Trap: "Evaluate if ML is appropriate" is an explicit step, not a formality. Plenty of pickup problems are solved with better map data or a clearer UI and no model at all. Reaching for ML first is the expensive way to discover that.

## What to take away

Start with the customer and their pain across segments. Use quantitative metrics to define success rather than arguing about it. Build cross-functionally. And think **"glocal"** — scaling globally requires local nuance inside a global strategy, because the "meet" problem in a Mumbai market is not the "meet" problem in suburban California.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'case_air_france', 'Air France — Sponsored Search', '
Air France is buying sponsored search across Google, Yahoo, MSN and Kayak. Some campaigns are showing returns above 1000%.

The correct first reaction to that number is suspicion, and the case rewards students who have it.

## The decision

Should Air France bid uniformly across publishers, or tailor strategy to each, in order to maximise return on advertising? Underneath that sits a more useful question: **which numbers here can you actually trust?**

## The metrics

Standard digital metrics are **CPC** (cost per click), **CTR** (click-through rate) and **TCR** (total conversion rate). The case adds **ROA**, average revenue per booking, and probability of booking.

> Trap: The 1000% ROA figures reflect **attribution error**, not real returns. A customer who was always going to book Air France searches for it, clicks the paid link sitting above the organic one, and books — and the campaign takes credit for a booking it did not cause. Recognising this is the point of the question, not celebrating the result.

This is the transferable lesson: in digital marketing, the easiest number to produce is the one most likely to be wrong, because attribution is a modelling assumption dressed up as a measurement.

## The diagnostic worth remembering

Segment publishers by **probability of booking × CPC**, then read the funnel to locate the problem:

- **Low CTR** → an **ad** problem. People saw it and did not click. Fix the copy and the keyword match.
- **Low TCR** → a **website** problem. People clicked and then did not book. The ad did its job; the landing experience did not.

That split is the most reusable idea in the case, because it tells you which team to send the work to. A low conversion rate is not an advertising failure, and treating it as one wastes months.

## Kayak

Kayak charged a **flat listing fee** rather than bid-based CPC, so its economics are not directly comparable to the other publishers. Whether to keep it turns on that structural difference, not on its raw ROA — comparing a fixed-fee channel to an auction channel by return alone compares two different things.

## Why digital is genuinely different

Campaigns produce near-real-time data and can be halted or modified instantly, so **testing a recommendation is low-risk**. That is the real distinction from traditional media, where you commit the entire spend before you learn anything.

Which changes what a good recommendation looks like: not "here is the answer," but "here is the test, here is what we will learn, here is when we will stop."

The optimisation sequence: summarise campaign metrics → optimise publisher strategy → optimise campaign strategy → calculate KPI impact.

> Prof: The remaining Air France slides were deferred and **will not appear on the final exam**.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'case_bmw_films', 'BMW Films', '
In 2000, BMW North America had a problem most marketers would envy: the brand was healthy, sales were growing, and there was nothing new to launch for six months.

What they did with that gap is the case.

## How BMW got to 2000

The position was hard-won. BMW entered North America in the 1950s through independent distributors and opened BMW North America around 1975–76, launching "The Ultimate Driving Machine" and its prestige-plus-performance stance.

Then between 1986 and 1989, Acura, Infiniti and Lexus arrived with cheaper, genuinely high-quality alternatives, and BMW''s sales fell. Recovery from 1992 came through reorganising the dealer network, new models, and inventive campaigns including placement in James Bond films — reaching the highest return on marketing spend among US auto manufacturers. **Lexus spent twice what BMW did to sell the same volume.**

So this is a company with earned confidence in unconventional marketing.

## Who actually buys a BMW

| Series | Share | Profile | Loyalty |
|---|---|---|---|
| 3-series | 50% | ~35, mostly male, tech-savvy, high earners, unmarried | **Least loyal** |
| 5-series | 32% | Older, some married, no children | Middle |
| 7-series | 16% | 55+, senior roles, $300K+, married, college-age kids | **Most loyal** |

Read that table with the STP framework in hand. Half the volume comes from the *least* loyal segment — meaning BMW has to keep refilling the 3-series every generation. That is the strategic problem the campaign is aimed at.

## The campaign

Five short films ("The Hire") with top directors and actors — $15M production, about $15M promotion, **$30M total**. Released only on BMWfilms.com, behind registration and a player download.

About **2M registrations and 6M+ views** (roughly 3 per user). The average viewer was 30 years old, earning $88K, 63% college-educated. The most popular film was **"Star."**

## Why the friction was the strategy

Everything odd about the campaign becomes sensible once you identify the target: **future 3-series buyers** — college-age people with internet access, years away from affording the car.

The registration wall and player download were not a distribution mistake. They were a filter. 7-series customers on $300K+ were **deliberately excluded**: the tone was neither prestigious nor luxurious, and that segment found it disrespectful.

> Prof: Effective targeting means the message will **not** appeal to other segments. Preventing leakage matters as much as reaching the target.

That is the transferable lesson. A campaign everybody likes has usually failed to position anything.

Afterwards BMW mined the registration data to identify future high earners and invited them to test drives — keeping them warm for years before they could buy.

## The criticisms you are expected to raise

> Trap: Cost per viewer was about **$15 per person**, against roughly **$0.02 per viewer** for a prime-time TV ad:

$$\frac{\$30\text{M}}{2\text{M registrants}} \approx \$15 \text{ per person}$$
> Not a like-for-like comparison — a registered, self-selected, profiled viewer is worth more than an incidental one — but you should raise it rather than wait to be asked.

> Trap: The distribution gap is the other expected criticism. The films ran **only** on BMWfilms.com — not on BMW.com, not on auto magazine sites, not at auto shows, not on CDs or DVDs at dealerships. Exclusivity was the point, but nothing about the strategy required staying off BMW''s own homepage.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'theoretical_flow_time', 'Theoretical Flow Time & the Critical Path', '
A passport application involves about fifteen minutes of actual work. It takes weeks.

That gap — fifteen minutes of doing versus weeks of elapsed time — is the subject of process improvement. To close it, you first have to be able to measure it, which means separating the work from the waiting.

## Theoretical flow time

**Theoretical flow time** is how long one unit would take if you rushed it through with absolute priority and it never waited for anything. It is the floor: the best the process could possibly do for a single unit.

For Kristen''s Cookies, one dozen: wash and mix 6 + spread 2 + setup 1 + bake 9 + cool 5 + pack 2 + billing 1 = **26 minutes**.

Actual flow time is always higher. The difference is waiting — caused by batching, by variability, and by other units competing for the same resources.

## The trap in the addition

Adding up every activity in the process gives you a number. It is usually the wrong number.

Theoretical flow time is the sum of activities **along the critical path** — the *longest* route through the process — not the sum of everything in it.

> Worked example: A car has a chassis line (5 hrs) and a body line (6 hrs) running in parallel, both feeding final assembly. The two branches happen at the same time, so the flow time follows the longer route: A-D-E = 8 hours. Shave an hour off the 5-hour chassis branch and the answer changes by exactly zero — the car still waits for the body.

> Trap: Summing all activity times gives a figure that is too large and describes nothing real. Find the longest path first, then add along it.

## Three levers, in order of how often they are missed

1. **Work faster on critical-path activities.** Obvious, and usually the expensive option.
2. **Move work off the critical path** so it runs in parallel with something else. Free, if the work does not actually depend on what precedes it — and often it does not.
3. **Shrink the batch** so consecutive stages overlap.

That third one deserves a demonstration.

> Worked example: Enriching 7,200 units of uranium in a single batch takes 22 hours. Split it into two batches of 3,600 and each finishes in **13 hours** — because batch two starts stage one while batch one is already on stage two. No machine got faster. The stages simply stopped waiting for each other.

## Choosing the flow unit

One dozen was chosen as the flow unit for Kristen''s Cookies because it is the most probable order on a campus. The oven holds one dozen and the mixer holds three.

> Trap: Operational constraints should not pick your flow unit — customer demand should. Choosing "three dozen" because that is what the mixer holds gives you a tidy analysis of a process nobody is asking for.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'variability_queuing_basics', 'Why Randomness Creates Waiting', '
Stand in any queue and you will eventually ask the same question: *why am I waiting when the person serving me is not even busy all the time?*

That question has a real answer, and it is the foundation of everything else in this part of the course.

## Start with a process that cannot queue

Imagine a coffee counter where a customer arrives **exactly** every 60 seconds, and the barista takes **exactly** 50 seconds per cup. No queue ever forms. Not a short one — none at all. The barista even gets 10 seconds of idle time between customers.

Now change one thing. Keep both averages identical, but let the arrivals scatter: sometimes two people arrive together, sometimes nobody comes for three minutes. On average, still one a minute. On average, still 50 seconds of work.

A queue appears immediately.

Nothing about the capacity changed. The **average** is still comfortably sufficient. What changed is that reality stopped being punctual.

> Prof: Blanket capacity thinking fails here. A queue is not evidence that you lack capacity. It is evidence that arrivals and service times are **variable**, and variability alone is enough.

## Why the idle time does not save you

The barista''s spare 10 seconds cannot be banked. If nobody is waiting, that idle time evaporates — you cannot serve tomorrow''s customer today. But when two people arrive at once, the backlog is very real and has to be worked off.

Losses accumulate; slack does not. That asymmetry is the entire mechanism.

## Two kinds of variability

Once you see that variability is the culprit, the next question is which kind you are facing.

- **Predictable** — the lunch rush, the Monday spike, the December peak. You know it is coming, so you can plan capacity around it.
- **Unpredictable** — genuine randomness. No amount of planning removes it; you can only hold buffer against it.

> Prof: Think of a regression. Predictable variability is the explained variance — your regressors. Unpredictable variability is the residual. You plan for the first and hold spare capacity for the second.

## Putting a number on variability

To compare "how variable" two processes are, you need a unit-free measure. That is the **coefficient of variation**:

$$CV = \frac{\sigma}{\text{mean}}$$

Dividing by the mean is what makes it comparable — a standard deviation of 2 minutes means something very different for a 3-minute haircut than for a 3-hour flight.

$CV = 1$ describes a fully random (exponential) process, and it is the standard assumption when a question gives you no other information. It is also close to worst-case, so assuming it is the conservative choice.

You will meet two of them:

| Symbol | Measures | Reduced by |
|---|---|---|
| $CV_i$ | Variability in **inter-arrival** times | Appointments, demand shaping |
| $CV_p$ | Variability in **service** times | SOPs, standardisation, pre-sorting work |

## Seeing it move

Below is what all of this produces. Drag utilisation upward and watch the shape — the wait does not climb steadily, it climbs slowly and then goes vertical.

:::viz queuing serviceTime=20 unit="min" servers=2

> Trap: "Average capacity exceeds average demand, so there will be no queue" is the single most common error on this topic, and the coffee counter above is the counter-example. Ten customers arriving in one burst will queue even when you can serve one per minute and they average one per minute.

## The beads game

Class ran a simulation: three stages in series, each stage''s capacity that round set by a die roll. One die averages 3.5, so a line of them should run at 3.5.

It does not. The simulation settled around **2.8** and never reached 3.5.

The reason is worth sitting with. A high roll at stage two is worthless unless stage one happened to pass enough beads down. Good luck at one stage cannot be stored, but bad luck at any stage blocks everything behind it — the same asymmetry as the barista''s idle seconds. A single stage, with no neighbour to starve it, does average exactly 3.5.

> Prof: Variability interactions in series are always detrimental. Always.

## The five inputs to any queue

Everything from here on is built from these five numbers:

| Input | Symbol |
|---|---|
| Arrival rate | $R_i$ |
| Service rate per server | $R_p$ |
| Variability in arrivals | $CV_i$ |
| Variability in service | $CV_p$ |
| Number of servers | $c$ |
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'queuing_scale_pooling', 'Scale, Pooling & Cross-Training', '
The previous concept left you somewhere uncomfortable: queues form because of variability, and you cannot remove variability. So what can you actually do about waiting?

Three things, none of which require hiring anyone: **pool your servers, get bigger, or change what you are promising.**

## Pooling: one queue beats several

Picture two nurses, each with their own dedicated line. You join one. The other nurse finishes early — but the person at the front of *her* line goes next, not you, even though you arrived first.

That is the whole problem with dedicated queues: they throw away flexibility. Somewhere in the system a server is free while someone is waiting, and the structure prevents them meeting.

> Worked example: The nursing station with one shared queue and two nurses waits about **11 minutes**. Split it into two dedicated queues and the wait rises to about **14 minutes** — same staff, same demand, same variability. The three minutes were destroyed by the layout.

> Trap: Separate queues are only justified when the service types genuinely differ — an express lane, a self-check-in kiosk. "It feels fairer" is not a reason; a single queue is also *more* fair, since it preserves arrival order.

## Why splitting a service into stages backfires

The instinct to specialise is strong: one nurse does intake, another does the treatment. Surely each gets faster?

Each stage now has its own variability, and worse, the stages interfere — one can starve or block its neighbour, exactly like the beads game. Splitting the nursing station''s 20-minute service into a chain pushed total waiting from 11 minutes to about **28**.

The exception is real but has to be earned: if specialising genuinely makes each stage faster (a nurse who only does bandaging gets quicker at bandaging), the drop in $T_p$ can outweigh the added variability. Assume it does not until someone shows you the numbers.

## Scale absorbs variability

Now the surprising one. Multiply the nursing station by ten — 35 arrivals an hour, 20 nurses — keeping utilisation identical. The wait collapses from 11 minutes to roughly **30 seconds**.

Utilisation did not change. So where did the wait go?

Into probability. A queue forms when *every* server happens to be busy at the moment you arrive. With two nurses, both being busy at once is common. With twenty, all twenty being simultaneously busy is exponentially less likely. The variability is still there — it is just being absorbed across more servers.

:::viz queuing serviceTime=20 unit="min" servers=2

The practical payoff is the real lesson. Run those 20 nurses at 13 instead and you get about 9.5 minutes of wait at roughly **90% utilisation**. Scale is what lets a business run hot without punishing its customers — small operations must keep slack, large ones need not.

> Prof: This is the entire quick-commerce bet. The unit economics only close at near-monopoly density, and the current burn is a wager on getting there.

## When waiting is the wrong thing to optimise

Sometimes the answer is not to reduce the wait at all, but to change what you promised. The service strategy triangle has three corners and you get two:

| You choose | You give up | Who lives here |
|---|---|---|
| Fast + high variety | Low cost | Emergency rooms, ambulances, fire engines |
| Fast + low cost | Variety | McDonald''s, Subway |
| Variety + low cost | Speed | Tailors, government offices, local mechanics |

McDonald''s variety is largely an illusion — the same handful of items through identical steps, which is exactly why it is fast and cheap. A neighbourhood tailor keeps his server (himself) constantly busy, and you accept the wait in exchange for getting precisely what you asked for.

> Trap: The ISB ambulance sits idle about 90% of the time, and that is correct design, not waste. When you are selling fast response to unpredictable demand, **low utilisation is the product**. An efficiency drive that "fixes" it has misunderstood the business.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'lean_fundamentals', 'Lean Operations & the Seven Wastes', '
Most people meet lean as a list of Japanese words and a recommendation to reduce inventory. That framing is why most lean programmes fail.

Lean is not a toolkit. It is a philosophy with one idea at its centre, and every tool is downstream of it.

## The one idea

Waste — *muda* — is **the gap between your actual process and the ideal one**.

> Prof: The ideal process is one where demand arrives, output is produced instantly, flow time is zero and inventory is zero. It is unachievable. Every deviation from it is waste anyway.

Notice what that definition does. It refuses to let you call something acceptable just because it is normal, or unavoidable, or industry standard. A two-day inspection step is waste. It may be waste you cannot currently remove — but you do not get to stop calling it waste, because the moment you do, you stop looking for a way.

## What waste looks like in practice

- Excess inventory (work-in-progress piling up)
- Overproduction — making things before demand exists
- Waiting — customers, machines or workers
- Unnecessary motion or transport
- Rework, defects, quality failures
- Bureaucracy and inessential handling

## The tools, and what each is actually for

| Tool | The job it does |
|---|---|
| Batch size reduction | Less WIP, production closer to real demand |
| Pull / JIT | Work happens because output is **needed**, not because input arrived |
| Kanban | A card signalling what is needed, how much, when and where |
| Quality check at every station | Defects cost least at the point of creation |
| Flexible, cross-trained resources | Absorb variability and keep the line synchronised |
| Cellular layout | People on the same product sit together, not grouped by skill |

> Trap: Lean firms do not mandate small batches by policy. They reduce the **cost** of small batches — closer layouts, faster changeovers — and small batches follow on their own. Mandating small batches without first cutting changeover cost simply destroys capacity, which is how a lean initiative ends up making a plant slower.

## Why you should deliberately remove your safety net

This is the counterintuitive move that separates lean firms from firms that own lean binders.

Traditional manufacturers use inventory to *cover* problems: a missed due date, a scrapped batch, a supplier who ran late. The buffer absorbs it and nobody finds out. The problem never gets fixed because it never becomes visible.

Lean firms cut inventory **in order to make those failures surface**, then fix the root cause. Reducing the buffer is a diagnostic instrument, not just a cost saving.

Service firms hide the same problems in **time buffers** — Swiggy padding a delivery estimate by five minutes. Tighten the target and the failures reappear, which is the point.

> Trap: Fix the root cause, not the symptom. Overproducing so you never miss a deadline is a symptom fix that also creates waste. Asking why repeatedly — "the machine was not maintained → quality issue → rework → missed deadline" — is the actual work.

## The lesson COVID taught expensively

When supply chains seized up in 2020, the popular verdict was that just-in-time had failed. It had not. What failed was a misreading of it.

Firms had eliminated **all** inventory, not just *excess* inventory. Those are different things: excess inventory is waste, buffer stock held against a known disruption risk is not.

> Worked example: After the 2011 earthquake, Toyota sorted its inputs by disruption risk. Plastic resin substitutes easily, so it held no buffer. Semiconductors take **years** to rebuild capacity, so Toyota held a calculated **2 to 6 months** of chip stock. In the 2021 chip shortage, Toyota was the only major automaker largely unaffected.

Everyone else had copied the headline — "eliminate inventory" — and skipped the distinction, along with Japan''s short domestic supply chains, production levelling, cross-functional teams and stop-to-fix culture.

## Where lean does not apply cleanly

Starbucks applied lean to cut flow times and got mixed results. The reason is instructive: it serves two customers at once.

For a grab-and-go customer, less flow time is straightforwardly value. For someone there for the atmosphere, **dwell time is the product** — reducing it is destroying what they came for.

Lean needs one clear ideal process. Starbucks has two, and no amount of tooling resolves that.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'quality_process_capability', 'Quality Dimensions & Process Capability', '
A restaurant promises delivery in under 30 minutes. Is that good quality?

You cannot answer, and the reason you cannot is that the question is hiding two entirely separate questions inside one word.

## Two questions, one word

- **Quality of design** — is *under 30 minutes* the right promise for this customer? That is a marketing question about what people need. A fine-dining restaurant promising 30-minute delivery has bad quality of design; the promise itself is wrong.
- **Quality of conformance** — given that promise, how reliably does the actual process keep it? That is an operations question.

Process capability measures the **second** one. It takes the promise as given and asks how good you are at hitting it.

Keeping these apart matters, because the fixes are unrelated. Poor design is fixed by changing what you sell. Poor conformance is fixed by changing how you work.

## Picturing conformance

Your process does not produce one delivery time. It produces a *distribution* of them — mostly around some average, occasionally much faster, occasionally much slower.

The promise, meanwhile, is a hard line. Under 30 minutes, or you broke it.

So conformance is a geometry question: how much of your distribution falls on the wrong side of the line?

The curve below is the process. The dashed lines are the promise. Everything shaded red broke it. Drag the mean and then the spread, and notice they are two different problems with two different fixes.

:::viz capability mean=21.38 sd=7.73 lsl=0 usl=30 unit="min" label="Delivery time"

## Two ways to put a number on it

**Percent defective** is the direct one: the share of output outside spec. For Grab-A-Bite before Anisha''s changes, 12.5% of actual deliveries exceeded 30 minutes.

It is honest and easy to explain to a non-specialist. Its weakness is that it tells you nothing about *how close* you are to trouble — a process at 0% defective might be one bad day away from 5%.

**Sigma capability** fixes that by measuring distance instead of counting failures — how many standard deviations separate your mean from the nearest spec limit:

$$\text{Sigma capability} = \min\left[\frac{USL - \mu}{\sigma},\ \frac{\mu - LSL}{\sigma}\right]$$

For Grab-A-Bite, taking LSL as 0 because a delivery cannot take negative time:

$$\min\left[\frac{30 - 21.38}{7.73},\ \frac{21.38 - 0}{7.73}\right] = \min[1.12,\ 2.77] = \mathbf{1.12\sigma}$$

> Trap: Why the **minimum** rather than an average? Because defects pile up on whichever side is closer. Averaging 1.12 and 2.77 would report 1.9σ and hide the fact that one shoulder of your distribution is sitting almost on top of the promise. With only one spec limit given, there is only one number to compute.

> Trap: This was rounded aloud in class to "about 1.5 sigma," but the arithmetic on those exact numbers gives 1.12. Learn the formula and compute it — the quoted figure is not reliable, and an exam will hand you fresh numbers anyway.

## Why the same number means different things

1.12σ sounds abstract until you ask what it is for. Roughly 12% defective would be catastrophic in cardiac surgery and merely mediocre for a snack order.

Capability is only meaningful **against the promise the business made** — which is the quality-of-design question again, arriving from the other direction.

## Cp and Cpk

Two related measures that answer slightly different questions:

- $C_p = \dfrac{USL - LSL}{6\sigma}$ — how wide the specification is relative to your spread. It ignores where the process is *centred*.
- $C_{pk} = \dfrac{\text{sigma capability}}{3}$ — the same idea but accounting for centring.

> Trap: A process can have a healthy $C_p$ and a terrible $C_{pk}$. That combination has a specific meaning: your spread is fine, you are just off-centre. Re-centring a process is usually far cheaper than reducing its variability, so diagnosing which one you have is worth real money.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'subscription_model_dynamics', 'Subscription Models: Decoupling Revenue from Cost', '
Netflix charges you whether or not you watch anything this month. A cinema only earns when you turn up.

That difference sounds like a pricing choice. It is actually an operations choice, and it changes what kind of risk the business carries.

## What a subscription actually does

A subscription **decouples the revenue side from the cost side**.

In a per-unit model, every transaction triggers a cost event: a sale means a unit made, shipped, served. Revenue and cost move together, which feels safe until demand drops and you discover your costs did not drop as fast.

In a subscription, cash arrives on a schedule regardless of usage. That is why businesses with a subscription base show far steadier cash flow through a slow month — the fees keep coming while the world wobbles.

## The caveat that reverses the conclusion

Here is where people over-generalise from Netflix.

> Trap: For a digital service, low usage costs nothing — there is no marginal cost per item consumed, so a subscriber who watches nothing is pure margin. For a business holding **physical stock**, low usage is not merely harmless, it is actively **good**: less usage means less inventory in circulation and better rotation of what you own.

The same subscription mechanic has opposite implications depending on whether consumption consumes an asset. Ask that question first, every time.

## The risk nobody prices in

Subscriptions raise the usage rate. Customers who have paid up front feel obliged to extract value, so order frequency climbs — and for a physical-goods business that is the dangerous direction.

This is precisely the Rent-A-Dress dynamic. More usage means more dresses in the wash cycle, more inventory required to serve the same subscribers, and more depreciation. A subscription that "succeeds" at driving engagement can tip such a model into a loss.

## What actually drives subscription profit

Four levers, and the exam likes the third:

- How large the price reduction is
- Conversion rate onto the plan
- **Cannibalisation** of existing non-subscription revenue
- Stickiness and repeat usage

> Trap: In quick commerce (Swiggy, Blinkit) the lock-in argument is weak, because switching costs are close to zero — the competing app is one tap away. If the plan creates no real switching friction, all it has done is discount your best customers and raise their usage. Both sides of that are bad.

## What firms do when they cannot decouple

FMCG companies like HUL and P&G have no subscription to hide behind — a demand shock hits revenue and cost simultaneously. So they buffer differently:

- **Negative net working capital.** HUL always owes its suppliers, paying after 60 to 70 days. The cost side is partially insulated when demand dips, because the bills for this month''s dip land two months later.
- **Demand forecasting**, to convert unpredictable variability into predictable variability.
- **Vertical integration into inelastic demand** — the Reliance refined-oil move. If part of your business sells something people buy regardless, it steadies the rest.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'newsvendor_model', 'The Newsvendor Model', '
A newspaper vendor has to decide this morning how many papers to buy. Too few and she turns customers away. Too many and tonight they are worthless.

She cannot wait to see demand. She has to commit first and find out afterwards. That structure — **one order, uncertain demand, no second chance** — is everywhere: fresh food, fashion, hotel rooms, vaccine doses, concert merchandise.

The instinct is to order the average demand. That instinct is wrong, and seeing why is the point.

## Why the average is the wrong answer

Ordering the average would be right if being one unit short cost the same as being one unit long. It almost never does.

If a newspaper costs 20 and sells for 50, running out costs you 30 of lost margin. A leftover costs you the 20 you spent, less whatever scrap value remains. Those two numbers are rarely equal, and the bigger one should pull your order in its direction.

So name them:

- $C_u$ — the **underage** cost, what you lose by being one unit short. Usually price − cost, the margin you failed to earn.
- $C_o$ — the **overage** cost, what you lose by being one unit long. Usually cost − salvage.

## The critical ratio

Ask the question one unit at a time: *should I stock one more?* Yes, while the expected gain still beats the expected loss. Work that through and it collapses to a single number:

$$\text{Optimal service level} = \frac{C_u}{C_u + C_o}$$

That ratio is the fraction of the time you should be able to meet demand. It is a statement about **asymmetry of regret** — how much worse running out is than being left over.

Green below is demand you can serve, red is demand you turn away. Raise the price and watch the red shrink: losing a sale now hurts more, so you rationally stock more.

:::viz newsvendor mean=100 sd=30 price=249 cost=124 salvage=99 unit="dozen"

> Prof: The critical ratio does not depend on the demand distribution at all. The distribution only enters at the final step, converting a service level into a quantity.

That is a genuinely useful separation. The economics decide *how safe you want to be*; the demand data decides *what quantity delivers that safety*.

## Worked example: the cookies

Sell at $2.49, cost $1.24, salvage $0.99.

- $C_u = 2.49 - 1.24 = 1.25$
- $C_o = 1.24 - 0.99 = 0.25$
- $CR = \dfrac{1.25}{1.50} = 83.3\%$

Running out is five times worse than a leftover, so you deliberately over-stock — targeting an 83.3% chance of meeting demand rather than 50%.

Then stock the smallest $Q$ where $P(D \le Q) \ge 0.833$, which in the class''s demand table is **13 dozen**. Brute-forcing expected profit in Excel gives the same 13, with none of the insight into why.

## Converting a service level into a quantity

- **Discrete demand** — smallest $Q$ with $P(D \le Q) \ge CR$. Go one above the cutoff if the upside probability still clears the threshold.
- **Normal demand** — $Q^* = \mu + z\sigma$, where $z = \Phi^{-1}(CR)$.

## A stockout can be the right answer

> Trap: A low service level is a feature, not a bug. Vegetables have a high $C_o$ because they rot, so the optimal service level is low and running out is **correct**. Chasing 99% availability on perishables destroys money, and a manager who boasts about never running out of lettuce is describing a problem.

> Trap: $C_u$ and $C_o$ are not just accounting numbers. Include goodwill, the value of an attractor product that brings customers to the platform at all, and the cost of capital for durables. Exams like to bury one of these in the case text and see whether you notice.

## Variants worth knowing

- **More variable demand** raises the stocking level and *lowers* profit. You buy protection and pay for it — uncertainty is expensive even when handled optimally.
- **Quick response** — a second chance to order mid-season drops the optimal service level from 75% to 50%, because being short stops being terminal.
- **A demand oracle** changes the decision itself, not just your confidence in it. Revalue the whole problem rather than plugging a smaller σ into the same formula.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'hypothesis_testing_clt', 'Hypothesis Testing & the CLT Trap', '
You changed something in the process, and the numbers look better. Did it work, or did you get a good week?

That question has a formal answer, and getting it right depends on one idea that almost everybody gets wrong the first time.

## Averages behave better than individuals

Individual delivery times scatter enormously. One order takes 12 minutes, the next takes 34.

But *averages* of many deliveries barely move. Average fifty of them and you will get something close to the true process mean nearly every time — because the fast ones and the slow ones cancel out.

The **Central Limit Theorem** makes that precise, and it makes two claims:

$$\bar{X} \sim N\left(\mu,\ \frac{\sigma}{\sqrt{n}}\right)$$

1. Sample means are **normally distributed regardless of the shape of the original distribution.** Delivery times are skewed; averages of delivery times are not. This is why the normal distribution shows up everywhere in process control even when nothing being measured is normal.
2. Their spread is $\sigma/\sqrt{n}$, called the **standard error** — narrower than the process by a factor of $\sqrt{n}$.

That $\sqrt{n}$ has a practical consequence worth noting: to halve your uncertainty you need **four times** the data. Precision gets expensive quickly.

## The mistake that costs the most marks

> Trap: A sample mean is **not** a draw from the population distribution. It is a draw from the sampling distribution of the mean, which is narrower by $\sqrt{n}$. Dividing by $\sigma$ instead of $\sigma/\sqrt{n}$ is the single most common error on this topic — and with $n = 100$ it understates your z-score tenfold, turning a decisive result into an inconclusive one.

## How a hypothesis test actually reasons

The **null hypothesis** is the status quo: nothing changed, the coin is fair, the process mean is still 21.39 minutes.

You then ask a narrow question: *if the null were true, how surprising would my data be?* If the answer is "very," you reject the null.

> Prof: You are never proving the new thing is true. You are asking whether the old story can still explain what you just saw.

That framing matters because it explains the asymmetry. Failing to reject the null does not mean the process is unchanged — it means you did not gather enough evidence to say otherwise.

## Worked example: did Anisha''s change work?

Null: nothing changed, so $\mu = 21.39$ and $\sigma = 7.73$. The pilot returned a sample mean of **19.2** from $n = 100$.

$$\text{SE} = \frac{7.73}{\sqrt{100}} = 0.773 \qquad z = \frac{19.2 - 21.39}{0.773} = -2.83 \qquad p = 0.0023$$

> Worked example: One-sided, because only one direction counts as success — a delivery process getting *slower* is not evidence the change worked. Two-sided would double the p-value to 0.0046. Choosing the wrong one is a common slip and changes your answer.

## How small does p need to be?

> Trap: There is no universal threshold, and 0.05 is a convention rather than a law. 0.0023 is comfortably enough to act on for food delivery. A vaccine would demand far more evidence. The right question is always what it costs to be wrong in each direction — shipping a change that does nothing, versus discarding one that would have helped.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'priority_queuing', 'Priority Queuing: Redistribution, Not Creation', '
Every queue you have ever stood in reflects a decision about fairness that somebody made, usually without saying so out loud.

First-come-first-served is one such decision. An emergency room that treats a heart attack ahead of a sprained wrist has made a different one. This concept is about what that second decision actually costs — and, crucially, **who pays for it**.

## The uncomfortable idea, before any arithmetic

Here is the part that surprises people:

> Prof: Giving one group priority does not reduce the total amount of waiting in the system. It only decides whose waiting it is.

Think about why that must be true. The same people still arrive. The same servers are still working at the same speed. The total number of person-minutes spent waiting is fixed by arrivals and capacity — priority cannot conjure capacity out of a sorting rule. All it does is take minutes from one group and hand them to another.

Stated plainly it sounds obvious. It is forgotten constantly, usually by someone proposing a "fast track" as though it were free.

## Watching it happen

Take the nursing station from the previous session: 13 nurses, 35 arrivals per hour, average wait **9.43 minutes** with everyone treated in arrival order.

Now split arrivals into 20% emergency and 80% routine, and let emergencies jump ahead. The overall average wait stays at **9.43 minutes**. Same arrivals, same capacity, same total waiting — redistributed.

## Computing each class

**Step 1 — treat the priority class as though it were alone.**

From an emergency patient''s point of view, the routine patients might as well not exist: nurses drop what they are doing. So model emergencies against the full server pool:

$$R_i = 0.20 \times 35 = 7/\text{hr} \quad \text{against } 13 \text{ servers}$$

That is roughly 18% utilisation, which on the queuing curve is nowhere near the wall. The wait is effectively **zero**.

**Step 2 — back out the other class from the average.**

The overall average is a weighted blend of the two classes, and you now know one of them:

$$0.20 \times 0 + 0.80 \times W = 9.43 \quad\Rightarrow\quad W \approx 11.8 \text{ minutes}$$

So routine patients moved from 9.43 to 11.8 minutes. That is the price of the emergency class waiting zero.

## When priority stops being cheap

The 20% case looks like a free lunch — one group gains a lot, the other loses a little. That is only true because the priority class is **small**.

> Trap: Push the emergency share to 50% and both groups can end up worse off. The priority class is now large enough to queue behind itself, so its wait is no longer zero — while the routine class is now waiting behind far more people than before. Check this yourself before the exam; it is a favourite question precisely because the intuition breaks.

## Where you will meet this

Airline boarding groups, hospital triage, supermarket express lanes, paid support tiers. In every case the design question is the same two-parter: **how small is the priority class, and what happens to the majority you just pushed back?**

A fast track that covers half your customers is not a fast track. It is a slow track with extra steps.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'strategy_process_alignment', 'Strategy -> Operations -> Process Alignment', '
The first ten minutes of this course were spent arguing about a single word: **efficiency**.

Output over input. Lower inventory. Beating the competition''s numbers. Every answer offered got shot down, and the shooting-down was the lesson.

> Prof: Blanket definitions do not work. Every business''s definition of "good" is a function of the promise it has made to its customers — its value proposition. Operations Management is the discipline of delivering on that promise.

That is the thesis of the entire course. You will never be handed a universal formula for good operations. You will be asked, every single time: *given this firm''s promise, what must its processes achieve, and how would we know if they are?*

## The tea test

A cup of tea from a roadside stall and one from Starbucks are not the same product delivered differently.

The stall promises cheapness and speed, so it is organised around a single kettle, no seating, and no consistency guarantee. Starbucks promises a consistent experience, so it is organised around trained staff, calibrated machines, standard recipes and somewhere to sit.

Neither is badly run. They are running *different processes* because they made *different promises*. Ask "which is more efficient?" and you have asked a question with no answer.

## The three nested layers

Formally, the argument above is three questions stacked:

| Layer | The question | Dimensions to rank |
|---|---|---|
| Competitive strategy | What is our value proposition? | Price, Time, Quality, Variety |
| Operations strategy | What must operations do **particularly well**? | Cost, Responsiveness, Quality, Flexibility |
| Process structure | How do we build those competencies? | Process choice and management |

The arrows run both ways. Strategy shapes process — but what is operationally feasible also limits which promises you can credibly make. A firm that cannot deliver in 30 minutes should not promise 30 minutes.

> Prof: Aligning these two ends is "60% of what a top-tier strategy consultancy actually does." Most engagements are, underneath, a diagnosis of a mismatch between what a firm promises and how its work is organised.

## Operations is not factories

Worth clearing up, since the word misleads. The job postings shown in class were Amazon, Meta and Google, hiring for pricing, demand forecasting, vendor management, and coordinating service delivery between customers and engineering teams. **Operations is organising work to create and deliver value** — wherever that work happens.

## Misalignment gallery

The fastest way to feel the framework is to watch it fail. Four cases, none of which appear on a slide:

- **NeXT** — built computers for research labs, then obsessed over machining a perfect one-foot cube case. Industrial-design precision was irrelevant to the promise (raw compute for researchers) and pushed the price out of reach. A genuine competency, aimed at nothing.
- **Andre Agassi** — ran 15km a day until Brad Gilbert pointed out that tennis is lateral 10m sprints and direction changes, not distance endurance. He had trained hard at the wrong thing.
- **Adam Smith International** — a project-management middleman asking why it employed so many in-house subject experts, when its actual promise was *managing external contractors*.
- **Airtel vs Jio** — the same industry, deliberately opposite alignments. Jio optimised price and reach: standalone 5G, more customers per tower, aggressive entry. Airtel optimised reliability: fail-safe non-standalone 5G layered on existing 4G, denser towers, and buying Indus Towers to convert opex into capex. Both coherent. Neither is "more efficient."

> Trap: The exam version asks you to judge whether some operational choice is right. There is no context-free answer, and answering as though there were is the way to lose the marks. Name the value proposition first, then judge the choice against it.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'batching_capacity', 'Batch Size: Flow Time vs. Capacity', '
"Smaller batches are leaner" is one of those statements that is repeated until it stops being examined. It is half true, and the missing half costs real capacity.

Batch size pulls flow time and capacity in **opposite directions**. That tension is the whole concept, and which side you want depends on what your business is competing on.

## Smaller batches cut flow time

When a batch is large, everything in it waits for the whole batch to finish a stage before any of it moves on. Shrink the batch and the stages start overlapping.

> Worked example: Enriching 7,200 units of uranium in a single batch takes 22 hours. Split it into two batches of 3,600 and each finishes in **13 hours** — because batch two enters stage one while batch one is already on stage two.

No machine got faster. The stages simply stopped waiting for each other.

## Larger batches raise capacity

Now the other direction. Every batch carries a **setup cost** — a changeover, a clean-down, a recalibration — and that setup is paid once per batch regardless of size.

$$\text{Capacity} = \frac{X}{F + R \cdot X}$$

where $X$ is batch size, $F$ is setup time and $R$ is run time per unit. Bigger $X$ spreads $F$ over more units, so the resource spends more of its day making things and less of it changing over.

If that setup is happening **on the bottleneck**, the capacity you recover is real output.

> Worked example: A glass mould takes 24 hours to set up and one minute per unit afterwards. At a batch of 100 you spend 24 hours of setup for 100 minutes of work. The batch size is not a preference here; it is the difference between a viable process and an absurd one.

## So which do you want?

> Trap: The honest answer is that it depends on which constraint is binding. Smaller batches cut flow time **and** cut capacity at any resource with meaningful setup time. If you are capacity-constrained, shrinking batches makes the problem worse. If you are competing on responsiveness and have capacity to spare, shrinking batches is close to free.

This is also why lean firms do not simply mandate small batches — they attack $F$ first, reducing changeover cost so that small batches stop costing capacity. Mandating the batch size without doing that just destroys throughput.

## Demand mix changes the arithmetic

Batch size is not only about production runs. The *mix of orders you accept* is a batching decision too.

Kristen''s Cookies with 2-dozen orders and one oven: the oven now takes 20 minutes per order, so 3 orders/hr — which is still 6 dozen/hr, no better than one-dozen orders. With **two** ovens it becomes 6 orders/hr, which is 12 dozen/hr, double the baseline.

> Worked example: That is a real commercial conclusion, not an exercise. Offering a discount for larger same-flavour orders can pay for itself — you are not buying volume, you are buying a demand mix that uses the bottleneck better.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'six_sigma_dmaic', 'Six Sigma: Robustness, Not Zero Defects', '
Six Sigma is usually explained as "3.4 defects per million opportunities," which is technically correct and almost entirely useless as an explanation. It makes the whole thing sound like perfectionism.

It is not about perfectionism. It is about what happens on your worst day.

## The actual point

> Prof: Six Sigma is not primarily about producing near-zero defects in steady state. Its real value is robustness when the process inevitably shifts.

Every process drifts. A supplier changes their formulation, the weather turns, an experienced operator leaves, a new batch of raw material arrives slightly different. None of this is failure — it is Tuesday.

Now compare two processes, both currently producing zero defects:

- One sits with its spec limits about 3σ away. A modest drift and part of its distribution crosses the line. Defects appear, and you have to stop and investigate.
- One sits with its limits 6σ away. The same drift moves the distribution, and output is *still comfortably inside spec*. You notice on the control chart, investigate at your own pace, and never stop producing.

Both had zero defects yesterday. Only one still has zero defects today.

**You are buying insurance against drift, not a headline defect count.** The steady-state number is almost beside the point.

> Trap: Six Sigma is a target, not a requirement. In plenty of contexts 4.5 sigma is entirely sufficient. "Is six sigma worth it here?" is a real business question, and the answer depends on what a shift would actually cost you — which for a snack delivery and a heart valve are very different numbers.

## DMAIC

The improvement cycle that carries the method:

| Phase | What happens |
|---|---|
| **D**efine | What is the problem, and what does the customer need? |
| **M**easure | Establish the baseline — mean, σ, defect rate |
| **A**nalyse | Find root causes, not symptoms |
| **I**mprove | Change the process |
| **C**ontrol | Hold the gain, then start again |

Control is the phase people skip, and it is the one that makes the rest worth doing. It is not the end of the project — it is the loop back to the beginning. Get the process in control, then improve it again from the new baseline.

## Mean or variance?

Improvement can come from moving the mean, tightening σ, or both. They are not interchangeable.

> Trap: Lowering the mean is not automatically good. With a **two-sided** spec, pulling the mean too far creates defects at the *other* limit — you have not improved the process, you have relocated its failures. Grab-A-Bite is one-sided, so lower is simply better there. Do not carry that instinct into a two-sided problem.

> Worked example: A process where the mean drops from 1000 to 100 while σ only falls from 10 to 9. The coefficient of variation gets **worse** — relatively speaking the process is more variable than before. The absolute defect count improves anyway. Judge by defects against the spec, not by relative variability, because the customer experiences defects and has never heard of your CV.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'littles_law', 'Little''s Law: I = R x T', '
Suppose you walk past a bank and count 20 people inside. What can you tell me about how long they will be there?

On its own, nothing. But add one more fact — the bank serves 40 customers an hour — and you can now say something surprisingly precise: the average person is inside for about half an hour. You did not observe a single customer from entry to exit. You just counted heads and knew the rate.

That is Little''s Law, and it is the most useful thing in this course precisely because the two facts it needs are usually the two facts a business already has.

## The three quantities

Any process, of any kind, can be described with three numbers:

- **Flow rate ($R$)** — how many units pass through per unit time. Customers per hour, orders per day.
- **Flow time ($T$)** — how long one unit spends inside, entry to exit.
- **Inventory ($I$)** — how many units are inside right now.

And they are locked together:

$$I = R \times T$$

## Why it is true

Picture inventory as the area of a rectangle: flow rate is its height, flow time is its width. Hold a rate of 20 per hour for 3 hours and 60 units have accumulated inside. Halve the time each unit stays and, at the same rate, only half as many are in there at any moment.

Drag either edge below and watch the third number follow.

:::viz littles-law rate=30 time=0.5 rateUnit="per hour" timeUnit="hours" unitName="browsers"

## The form you will actually use

Exam questions rarely hand you $R$ and $T$ and ask for $I$ — that would be too kind. They hand you two of the three and ask for the missing one, most often:

$$T = \frac{I}{R}$$

That rearrangement is the valuable one, because inventory and flow rate are the two things a business can observe directly. Nobody follows a single customer around with a stopwatch. Everybody can count the queue and count the tills.

## When it holds

The law is not a rule of thumb; it is exact. But it is exact under four conditions:

1. Consistent units across $I$, $R$ and $T$
2. Long-run averages, not a snapshot at 3pm on a Tuesday
3. The system is stable — over your observation window, roughly what came in has gone out
4. You count the **same population** in all three

> Trap: Condition 4 is where the marks are, and it is the least obvious. If two kinds of customer share one queue, applying the law to the combined population is simply wrong. Split by segment, apply the law to each, then recombine.

## Worked example: the ISB cafeteria

120 customers arrive per hour. Resist the urge to divide anything by 120 — that is one population made of three:

| Segment | Rate | Time | Inventory |
|---|---|---|---|
| Coffee only | 54/hr | 2 min | $54 \times \tfrac{2}{60} = 1.8$ |
| Coffee + food | 36/hr | 7 min | $36 \times \tfrac{7}{60} = 4.2$ |
| Chat only | 30/hr | — | — |

Now the question: 10 people are standing at the register. How long does the register itself take?

The coffee-only and coffee-plus-food segments account for $1.8 + 4.2 = 6$ of those 10 people — they are mid-transaction, not queuing. So the actual register queue is $10 - 6 = 4$ people, and

$$T = \frac{I}{R} = \frac{4}{90} = 2.67 \text{ minutes}$$

That subtraction is the entire technique. There was no way to reach 2.67 by dividing 10 by 120.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'process_view', 'The Process View', '
Ask ten people in a company why an order took three weeks and you will get ten answers, each true and none useful. Sales blames operations, operations blames procurement, procurement blames the supplier.

The problem is not that they are lying. It is that each of them can only see their own department. Nobody is looking at the thing the customer actually experiences — the order''s journey from one end to the other.

The process view is the fix: stop looking at the organisation chart and start following the work.

## What a process is

A **network of activities and buffers that converts inputs into outputs**, with resources doing the work and an information structure coordinating it.

Activities are where something happens. Buffers are where things wait. Both matter — in most real processes, the waiting dwarfs the doing.

## Five questions that give you the view

1. What are the process boundaries — what goes in, what comes out?
2. What is the **flow unit**, the thing you are going to track?
3. Attach yourself to that flow unit and trace every step it takes.
4. Who does the work at each step? Those are your resources.
5. What information is needed at each step, and where does it come from?

Question 3 is the one that does the work. You are not interviewing departments; you are riding along with a single order and writing down everything that happens to it, including the waiting.

## The distinction that trips everyone

> Trap: Raw materials are **not** resources. Dough, cheese and vegetables are part of what is *flowing* — they are being transformed into the output. Resources are the *doers* of work: the chef, the oven, the delivery rider.

Get this backwards and your entire process map is wrong. It is also exactly the line between cost of goods sold and the process''s real inventory, so accountants and operations people who disagree about it are usually disagreeing about this.

## Worked example: a Domino''s order

The flow unit is an *unfulfilled order*. Ride along with it:

| Step | Time | Resource |
|---|---|---|
| Stretch and toss | 4 min | Chef |
| Bake | 6 min | Oven |
| Cut and pack | 5 min | Second person |
| Deliver | 8 min | Rider |

It leaves the far end as a *fulfilled order*. Four steps, four resources, 23 minutes of work — and now you have something you can actually analyse, because it is written in the customer''s terms rather than the org chart''s.

> Prof: Around 5% of orders are infeasible and we ignore them on purpose. The process view works on long-run averages. Edge cases are fires — and by definition, rare.

That is a licence worth taking seriously. Students often stall trying to model every exception. Model the 95%; the exceptions are a separate conversation.

## Why the rigour pays

- **Scalable** — the same tool zooms into one workstation or out to the whole company
- **Horizontal** — it cuts across departments rather than down them, which is precisely where hand-off failures hide
- **Flows, not snapshots** — you manage systematically instead of firefighting
- **Customer-centric** — one shared model that everyone can analyse and argue about with evidence
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'margin_markup', 'Margin vs. Markup', '
A retailer tells you she works on 40%. Her supplier says he gives her 40%. They are describing the same transaction and they mean different numbers.

This is not pedantry. It is one of the most reliable sources of pricing errors in real businesses, and it comes down to a single question: **forty percent of what?**

## The two definitions

$$\%\text{Margin} = \frac{p - c}{p} \qquad \%\text{Markup} = \frac{p - c}{c}$$

The numerator is identical — the money you make on the unit. Only the denominator differs.

**Margin divides by price. Markup divides by cost.**

## Why they diverge

Cost is always smaller than price, so dividing by it always gives a bigger number. Markup is therefore always the larger of the two, and the gap widens as the item gets more profitable.

> Worked example: A Snickers bar at $p = 1.00$, $c = 0.70$. Unit margin is $0.30 either way.
> As a **margin**: $0.30 / 1.00 = 30\%$.
> As a **markup**: $0.30 / 0.70 = 43\%$.
> Same bar, same thirty cents, two perfectly correct answers to two different questions.

:::viz break-even price=1 cost=0.7 fixed=60 currency="$" unit="bars"

## Converting between them

$$\text{margin} = \frac{\text{markup}}{1 + \text{markup}} \qquad \text{markup} = \frac{\text{margin}}{1 - \text{margin}}$$

Worth being able to do quickly, because the two communities genuinely speak different dialects.

## Why the two dialects exist

This is not arbitrary. Retailers think **upward from cost** — they buy something and decide what to add. Markup is the natural unit of that decision.

Finance and strategy think **downward from revenue** — the P&L starts with sales and works down. Margin is the natural unit there.

Both are reasoning correctly about their own problem. The damage happens at the interface, when one hands a number to the other without saying which convention it is in.

> Trap: If a question gives you "40% markup" and you treat it as margin, every downstream number — break-even volume, contribution, the cannibalisation test — will be wrong, and wrong in a way that still looks plausible. Check the denominator before you do anything else.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'process_capacity_bottleneck', 'Process Capacity & the Bottleneck', '
A friend tells you their bakery can produce 500 loaves a day. You ask how they know. They add up what each station could do and divide by something.

That is almost always wrong, and the reason why is the most reusable idea in operations.

## You do not control flow rate

This is the first thing to internalise. Flow rate is an *outcome*, not a dial. What you control is **capacity**. Capacity then meets demand, and between them they produce the flow rate:

- Demand **below** capacity → flow rate = demand. You are **demand-constrained**; the fix is marketing, not operations.
- Demand **above** capacity → flow rate = capacity. You are **capacity-constrained**; now operations matters.

Knowing which of these you are in should be the first question you ask, because it determines whether anything in this concept will help you at all.

## The chain is as strong as its weakest link

The **bottleneck** is the resource pool with the lowest capacity, and it sets the capacity of the whole process. Not the average of the stations. Not the sum. The minimum.

Try it below — push the roommate''s capacity to 30 and watch the flow rate refuse to move.

:::viz process-flow stations="Mixer:10,Crystal:8,Roommate:15,Oven:6" demand=8

> Prof: An hour lost at the bottleneck is an hour lost for the whole process. An hour saved anywhere else is a mirage.

That sentence is worth memorising, because the mirage is genuinely convincing. Speeding up a non-bottleneck produces visible local improvement — that station''s numbers get better, its people feel more productive — and zero additional output.

## Worked example: Kristen''s Cookies

One dozen per order, one oven:

| Resource | Time per unit | Capacity |
|---|---|---|
| Mixer | 6 min | 10/hr |
| Crystal | 8 min | 7.5/hr |
| Roommate | 4 min | 15/hr |
| Oven | 10 min | **6/hr** |

Process capacity is 6 dozen an hour, set by the oven. The roommate at 15/hr is idle more than half the time, and that is fine — trying to "fix" it would achieve nothing.

## Why buying a second oven disappoints

Add a second oven. Capacity should double to 12, and it goes to **7.5**.

Because with two ovens the oven pool is no longer the constraint — Crystal is, at 7.5/hr. You spent capital and gained 1.5 dozen an hour.

Now rebalance the line: move the 2-minute spreading task from Crystal to the roommate. Crystal falls to 6 min/unit, the roommate rises to 6 min/unit, and the two ovens at 10 min each give 12/hr combined, with nothing below it.

> Trap: The same oven, the same money — **1.5 dozen/hr if you install it and walk away, 4 dozen/hr if you rebalance afterwards.** Always rebalance the line after a capital investment. Exam questions routinely stop after the purchase and wait to see whether you notice.

## Two kinds of utilisation

- **Utilisation** $= \dfrac{\text{flow rate}}{\text{capacity}}$. It caps at 100%.
- **Implied utilisation** $= \dfrac{\text{demand}}{\text{capacity}}$. It does not cap, and that is the point.

An implied utilisation above 100% is the signal that says "this resource is the bottleneck for the demand you currently have." A resource at 130% implied utilisation is not working harder than one at 100% — it is falling behind faster.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'spc_control_charts', 'Control Limits vs. Specification Limits', '
Your delivery process averaged 21 minutes last month. This morning''s sample averages 24. Should you investigate?

Not yet — and knowing why not is the whole of this concept.

## The problem with reacting to numbers

Every process is variable. A sample that comes back higher than last month''s average might mean something changed, or it might mean today was a Tuesday. React to every wobble and you will spend your life chasing noise, exhausting your team and eroding their belief that any alarm means anything. Ignore everything and you will miss the day something genuinely broke.

You need a threshold that separates ordinary variation from a real signal. That is what a **control chart** is.

## Where the threshold comes from

Take samples of size $n$ and plot each sample''s *mean*. The Central Limit Theorem says those sample means are normally distributed around the true process mean, with a spread of $\sigma/\sqrt{n}$ — much narrower than the process itself.

That narrowness is what makes the chart sensitive. Individual deliveries scatter widely; averages of fifty deliveries barely move unless something real has shifted.

Set the limits three of those standard errors either side:

$$UCL = \mu + 3\frac{\sigma}{\sqrt{n}} \qquad LCL = \mu - 3\frac{\sigma}{\sqrt{n}}$$

For Grab-A-Bite after the improvement, with $\mu = 19.32$, $\sigma = 7.73$ and $n = 50$:

$$UCL = 19.32 + 3\frac{7.73}{\sqrt{50}} = 22.6 \qquad LCL = 19.32 - 3\frac{7.73}{\sqrt{50}} = 16.04$$

Plot each day''s sample mean. A point outside those limits is a **flag, not a verdict** — it says "this is unlikely enough to be worth a look," not "something is broken."

## The distinction that gets tested most

Control limits look like specification limits. They answer completely different questions.

| | Specification limits | Control limits |
|---|---|---|
| Who sets them | The customer | The process''s own history |
| The question | What does the customer want? | Is the process the same as yesterday? |
| Where they come from | Given to you | $\mu \pm 3\dfrac{\sigma}{\sqrt{n}}$ |

> Trap: Mixing these up is the classic error. A process can sit comfortably inside its control limits while producing defects — control limits say nothing whatsoever about what the customer asked for. It can equally breach a control limit while every single unit still meets spec. "In control" and "capable" are independent properties.

> Trap: The **lower** limit matters even in a one-sided business. If deliveries suddenly get much faster, you still want to know why — someone may be skipping a step. An unexplained improvement is an uncontrolled process, and whatever caused it can reverse just as quietly.

## Testing a single day properly

The same logic, done formally. Anisha''s pilot returned a sample mean of 19.2 from $n = 100$, against a null of $\mu = 21.39$, $\sigma = 7.73$.

> Trap: 19.2 is a draw from the **sampling distribution of the mean**, not from the population. The correct spread is $\sigma/\sqrt{n} = 0.773$, not $7.73$. Using $\sigma$ here understates $z$ by a factor of ten and is the single most common mistake on this topic.

$$z = \frac{19.2 - 21.39}{0.773} = -2.83 \quad\Rightarrow\quad p = 0.0023 \ \text{(one-sided)}$$

Comfortably enough to conclude the process genuinely improved.

## Test days separately, not pooled

> Trap: Pooling seven days of data averages away exactly the day-to-day variability you are trying to detect. Tested individually, days 2, 3 and 6 came back anomalous — which points at traffic and weekend effects worth investigating. Pooled, they would have vanished into a perfectly reasonable weekly average.

## How wide should the limits be?

$\pm 3\sigma$ is convention, not law, and the choice is a business judgement:

- **Narrow** — more false alarms, but you catch every real change. Right for vaccines and aerospace, where a missed shift is catastrophic.
- **Wide** — fewer false alarms, but real shifts can slip through unnoticed.

You are trading the cost of a needless investigation against the cost of a missed change. Those costs differ by industry, so the right width does too.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'becr_cannibalization', 'Break-Even Cannibalization Rate (BECR)', '
You are about to launch a cheaper version of your own product. Someone in the room says "but it will cannibalise the existing line."

They are right. It will. That is not an argument against launching — every line extension takes some sales from its siblings. The real question is **how much cannibalisation this launch can absorb before it stops being worth doing**, and that has a number.

## The two quantities

$$BECR = \frac{\text{new product contribution}}{\text{old product contribution}}$$

$$\text{Cannibalisation rate} = \frac{\text{old units lost}}{\text{new product units sold}}$$

The first is a **ceiling** — the most cannibalisation this launch could tolerate. The second is what you actually expect to happen. Compare them.

> Trap: If the actual rate **exceeds** the BECR, the launch loses money. BECR is a limit you are testing against, not a target you are aiming for.

## Reading it intuitively

The ratio makes sense the moment you think about what a cannibalised sale costs you.

If the new product earns the **same** contribution as the old one, BECR = 1.0. A customer switching is margin-neutral — you did not gain, but you did not lose. You could cannibalise everything and break even.

If the new product earns **half** the contribution, BECR = 0.5. Now every switcher costs you half their old margin, so more than half your new volume coming from your own customers puts you underwater.

The lower the new product''s margin, the less of your own base you can afford to convert. Which is exactly why cheap line extensions are dangerous in a way premium ones are not.

## Worked example: Kookaburra

Base unit margin on the existing bat is ₹810.47.

Niche launch, Year 1: 80,000 units at a 22% cannibalisation rate.

$$80{,}000 \times 0.22 = 17{,}600 \text{ units} \qquad 17{,}600 \times 810.47 = ₹14{,}264\text{K}$$

That ₹14,264K of destroyed margin turns a pre-cannibalisation loss of ₹11,900K into **−₹26,164K**. The cannibalisation more than doubled the loss.

By Year 2 the BECR for the niche option is **0.29** — up to 29% cannibalisation is survivable, and expected cannibalisation is 22%. It clears, but not by much.

## Where the volume has to come from

> Trap: New incremental volume must come from **competitors or from category growth**. Volume taken from your own brands is not growth, it is a transfer — and usually a transfer to a worse margin.

This is the sentence to keep in mind when someone presents a launch forecast. Ask where each unit comes from. A plan that projects large volume without saying whose it is has not been thought through.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'evc', 'Economic Value to the Customer (EVC)', '
The single most valuable question in marketing is not "what should we charge?" It is "**what would this customer do if we did not exist, and what would that cost them?**"

Answer that honestly and the price almost sets itself. Economic Value to the Customer is the discipline of answering it.

## Starting from their alternative, not your cost

Cost-plus pricing asks what the product cost you and adds a margin. The customer does not care what it cost you. What they care about is whether you are better than their next-best option, and by how much.

So EVC builds the price from **their** side of the table:

$$\text{EVC} = \text{Reference value} + \text{Net differential value}$$

- **Reference value** — what the next-best alternative costs them. This is the anchor.
- **Net differential value** — the extra benefits you provide, minus the extra costs you impose.

> Prof: Competitors are not always obvious. Soap can compete with entertainment for the same rupee.

That warning matters more than it first appears. Identify the wrong reference and every number after it is anchored to the wrong thing.

## Building it up

:::viz evc reference=1800 extraBenefit=500 extraCost=100 unitCost=400 currency="₹" period="/month"

> Worked example: A washable, reusable diaper lasting one month, with a variable cost of ₹400 against ₹3–4 for a disposable.
>
> A parent currently uses 4 disposables a day at ₹15 each. Over 30 days that is **₹1,800** — the reference value, and it is what they are already spending without thinking of it as a price.
>
> Your product removes the need for anti-rash cream: **+₹500**. But it adds washing: **−₹100**. Net differential **+₹400**.
>
> Total EVC = ₹1,800 + ₹400 = **₹2,200 a month.**

## Ceiling, not price

This is the part people get wrong.

**EVC is the price ceiling. Variable cost is the floor.** Here the viable range is ₹400 to ₹2,200.

> Trap: Charging the full ₹2,200 leaves the customer exactly as well off as before — you captured every rupee of the value you created, so they have no reason to switch and every reason to resent you if they do. Split the differential value. The midpoint is a common starting point before adjusting for competitive pressure.

## Why this works better in B2B

In B2B you can walk the customer through the calculation. They have a procurement team that thinks in exactly these terms, and a spreadsheet to check you with.

In B2C, consumers do not internalise the full value. The parent above is not computing ₹500 of avoided cream — so the **perceived** EVC sits below the real one, and perceived value is your actual ceiling.

> Trap: If you cannot communicate the value, you cannot charge for it. For a genuinely new product with no clear reference point, you need real research — focus groups, small-market pilots, conjoint analysis. Firms that skip this and price off internal estimates routinely misjudge willingness to pay.

## What EVC is used for

Beyond setting a price: identifying who your competitors really are (whoever provides the reference value), and finding segments that are underserved or mispriced because their alternative is worse than average.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'parfitt_collins', 'Parfitt-Collins Model', '
Advertising budgets get set in one of two ways. Either someone takes last year''s number and adjusts it, or someone asks what the advertising is supposed to *achieve* and works backwards.

The second way needs a model that connects money to market share. This is that model.

## Three gates, not a funnel of one

To buy your product repeatedly, a customer has to clear three separate hurdles:

1. **Know you exist** — awareness
2. **Try you once** — trial
3. **Come back** — repeat

$$\%\text{Aware} \times \%\text{Try} \times \%\text{Repeat} = \%\text{Market share}$$

The critical feature is that it **multiplies**. Miss any one gate and the share collapses regardless of how well the other two performed. Perfect awareness with a product nobody re-buys gives you almost nothing.

Taught as Parfitt-Collins, and sometimes as the Peckham/Collins model. Mostly used in FMCG, where all three rates are measurable.

## Using it backwards

The forward direction is mildly interesting. The backwards direction is where the money is:

$$\%\text{Aware} = \frac{\text{target share}}{\%\text{Try} \times \%\text{Repeat}}$$

> Worked example: You need a 6% share to break even. Trial is 30% and repeat is 40%.

$$\%\text{Aware} = \frac{0.06}{0.30 \times 0.40} = 50\%$$

Now you have a media brief. Not "spend more on advertising," but "we need to reach half the target market" — which a media planner can cost.

That is the **objectives-and-task method**: start from the share you need, work back to the awareness you must buy, then price the media that delivers it.

## The most useful thing it tells you

> Trap: The rearrangement is what gets tested — given a target share and two of the three rates, solve for the third. Watch the decimals: 30% is 0.30, and mixing percentages with decimals mid-calculation is the standard way to lose the mark.

But the genuinely valuable output is a **sanity check**. If the required awareness comes out above 100%, the plan is impossible — and no amount of media budget fixes it. That result is telling you the problem is trial or repeat, which are product, pricing and experience problems, not media problems.

A brand with a 10% repeat rate does not have an advertising problem. Spending more simply pours more people into a leaking bucket faster.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'case_unilever_brazil', 'Unilever Brazil', '
Unilever dominates the Brazilian detergent market. The question is whether to launch a low-cost brand for the low-income Northeast — a segment it has never served.

Everything about the case is designed to expose whether you actually believe low-income consumers are worth understanding, or merely worth pitying.

## Why they cannot just ignore it

> Prof: In the end Unilever''s decision was quite simple. The mission is "to serve the needs of all people everywhere" — we are not a luxury brand company. And: never let what happened in India with Nirma happen again.

That second sentence is the strategic one. Nirma entered India from below, undercut Hindustan Lever on price, and took enormous share before the incumbent responded. A premium brand that abandons the bottom of the market does not keep the bottom of the market empty — it hands someone a base from which to attack upward.

So the decision is not only "is this segment profitable?" It is also "what happens if we leave it to somebody else?"

## The customer insight that unlocks everything

Northeast Brazil consumers are **price sensitive but also value conscious.** Those are different things, and confusing them is the error the case is built to catch.

> Worked example: Only **28% of households in the Northeast owned a washing machine, against 67% elsewhere.** They wash by hand, using soap that yellows clothes, so they then need bleach as well. Cleaning power and whitening are not premium extras to this customer — they are the core need, and hand-washing makes them matter *more*, not less.

> Trap: "Low income means they only want cheap" is the assumption that destroys this launch. Price-conscious is not value-conscious. These customers will pay for the benefits that matter and refuse to pay for the ones that do not — which is a much more demanding customer than a rich one.

Get that wrong and you build a stripped-down product that fails on the one dimension they care about.

## The branding decision

Four options were considered: reposition Omo downward, reposition Minerva or Campeiro, extend Omo or Minerva, or create something new.

Unilever created a **new brand, Ala**, positioned between Minerva quality and Campeiro cheapness. Repositioning Omo downward would have damaged the premium brand; extending it would have carried the same risk more cheaply.

Incremental cost per kg: reposition **$0**, extend **$0.05**, new brand **$0.10**. The new brand is the most expensive option and they chose it anyway — protecting Omo was worth ten cents a kilo.

| Choice | Like Minerva | Like Campeiro |
|---|---|---|
| Formula | 1.40 | 0.90 |
| Packaging | Cardboard, 0.35 | Plastic, 0.10 |
| Price as % of Omo | 60% | 50% |
| Price $/kg | 1.80 | 1.50 |
| Promotion | Above the line, 0.15 | Below the line, 0.05 |
| Distribution | Wholesalers, 0.10 | Distributors, 0.05 |

## The cannibalisation test

$$BECR = \frac{\text{new unit margin}}{\text{old unit margin}} \qquad \text{Cannibalisation rate} = \frac{\text{volume lost from existing brands}}{\text{volume of the new brand}}$$

> Trap: Unilever loses money if the actual cannibalisation rate is **above** the BECR. New volume must come from competitors or from category expansion — volume taken from Omo is a transfer to a worse margin, not growth.

## What the case is really teaching

- **Make what you can sell, not sell what you can make**
- Marketing to low-income consumers can be profitable, but it is hard and it is **not charity**
- **Be disciplined**: deliver the important benefits, and only those. The discipline is in what you leave out.
- Be willing to re-engineer the marketing mix and to break company norms — the distribution and promotion choices above are not what a premium brand does
- Look at the business through your customers'' eyes
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'case_atlantic_computer', 'Atlantic Computer', '
Atlantic has built a server bundle — the Tronn server plus its PESA performance software — that does the work of two of the competitor''s machines.

The software was previously given away free. Now someone has to decide what to charge, and the case is the cleanest illustration in the course of why cost-plus pricing leaves money on the table.

## The situation

The rival, Zinc, sells at a status-quo price of **$2,000**. That number is the anchor in everyone''s head, including Atlantic''s own sales force, who would quite like to keep giving the software away because it makes selling easy.

The uncomfortable fact is that one Atlantic bundle genuinely replaces two Zinc servers. Priced as a single server, Atlantic is charging half price for the same capability.

## Two defensible ways to price it

**EVC-based** anchors on your **variable cost** as the floor.

- Variable cost: $1,538 (the floor)
- EVC-based price: $2,431 above that floor
- Split the floor-to-ceiling range in half for the recommendation

**Value-in** anchors on the **current market price** instead.

- One Atlantic bundle costs the customer $5,000 in total (labour + electricity + software)
- Two Zinc servers cost $9,400
- Extra value created:

$$\frac{\$4{,}400}{2} = \$2{,}200 \text{ over the } \$2{,}000 \text{ reference} = \$4{,}200$$

> Trap: Value-in **always** produces a higher number, because it anchors on what the market already pays rather than on what the product costs you. Both are legitimate. Use EVC when you need a defensible floor under competitive pressure; use value-in when you are arguing for a higher price. Whichever you pick, say which one you used and why — presenting a number without its anchor is what gets challenged.

## Be ready to defend it

A price recommendation that ignores how everyone else reacts is half an answer.

- **Customers will resist.** The software used to be free. Charging roughly $1,400 for it will produce backlash and requests for evaluation contracts before anyone commits.
- **They will run their own numbers, and get different ones.** Labour savings may be zero if existing staff simply absorb the extra servers — which is exactly why Atlantic applies a **2× multiplier rather than 4×**, deliberately conceding some of the value to allow for customer conservatism.
- **Zinc will cut prices**, perhaps from $1,700 down to $1,200–$1,400. Expect a price war and know what you will do in it.
- Zinc may build competing performance software, so the differentiation has to keep moving.

> Prof: Even if Zinc cuts its margin to zero, the Atlantic bundle still creates more value for the consumer. That is the case for value-based pricing.

That is the reassuring conclusion, and it depends entirely on the value being real rather than asserted.

> Trap: The exam does not want case trivia. It wants the concept — **EVC is the price ceiling**, the metric is value-in-use savings against the incumbent, and a price recommendation is incomplete without the competitive response.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'clv', 'Customer Lifetime Value (CLV)', '
A mobile operator spends $400 to acquire a customer who then pays them $250 a year in margin. Good deal?

Almost everyone answers instantly and most answer wrong, because the honest answer depends on three things nobody mentioned: how long that customer stays, what a future rupee is worth today, and whether "a customer" is even a meaningful average.

Customer Lifetime Value is the discipline of not answering that question by instinct.

## Build it in three steps

The formula is much easier to trust if you watch it assemble.

:::viz clv margin=250 retention=0.8 discount=0.1 acquisition=400 currency="$"

**Step 1 — pretend nobody ever leaves.** Acquisition cost $400, contribution $250 a year, five years.

CLV net = $1,250 − $400 = **$850**

Comfortably profitable. Also fantasy: it assumes every acquired customer is still there in year five.

**Step 2 — let customers leave.** Retention is 80%, so the odds a customer is still around in year $t$ are $0.8^t$, and each year''s expected contribution is $250 \times 0.8^t$ dollars.

$200 + $160 + $128 + $102 + $82 − $400 = **$272**

The same customer, honestly accounted for, is worth less than a third of the first answer.

**Step 3 — money has a time value.** Discount at 10%, dividing each expected contribution by $1.1^t$.

$182 + $132 + $96 + $70 + $51 − $400 = **$131**

> Trap: $850 → $272 → $131 on one customer. Almost all of that collapse is **churn**, not discounting. Forgetting the retention factor overstates CLV roughly threefold, and it is the most common error on this topic. If a business plan shows a CLV that looks too good, check whether $r$ appears anywhere in it.

## The closed form

Extend that to an infinite horizon with constant $m$, $r$ and $d$ and the sum collapses:

$$\text{CLV}_{\text{existing}} = m\left(\frac{r}{1 + d - r}\right) \qquad \text{CLV}_{\text{new}} = m\left(\frac{r}{1 + d - r}\right) - AC + m_0$$

> Worked example: $m = 250$, $AC = 400$, $r = 80\%$, $d = 10\%$, $m_0 = 0$.

$$250\left(\frac{0.8}{0.3}\right) = \$667 \quad\Rightarrow\quad \$667 - \$400 = \$267$$

The two formulas differ only in whether you have already paid to acquire them. For a customer you already have, the acquisition cost is sunk and irrelevant.

## Why retention beats discounting for attention

Look at the denominator: $1 + d - r$. Retention sits right next to the discount rate but moves the answer far more, because it compounds against every future year at once.

A few points of retention is usually worth more than a large improvement in almost anything else — which is why "reduce churn" outranks "acquire more" in most mature subscription businesses.

## What the formula quietly assumes away

- Contributions rising over time, through higher spend or cost efficiencies
- Retention changing — upward with lock-in, downward with dissatisfaction
- **Customer heterogeneity** — a blended CLV across customers with different $r$ and $m$ is not the CLV of anybody. It is an average of two different businesses.

## Why anyone computes it

To decide how and when to acquire a customer, retain one, **fire** one, or buy an entire customer base. That third option is the one people forget: if a segment''s CLV is negative, serving them better is not the answer.

In streaming, CLV tracks market capitalisation closely enough to work as a valuation signal — which is why subscriber numbers move share prices.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'process_financial_link', 'Linking Process Metrics to the P&L (Rent-A-Dress)', '
Here is a business that looks healthy and is quietly dying.

Rent-A-Dress ships 200 dresses a day at $25 a day, on a ten-day rental. Revenue is $25,000 a day. Costs of actually running the operation — shipping, inspection, cleaning — come to about $2,500. EBITDA of roughly $22,500 a day.

It loses money. Not a little: about **$3,900 every day**.

Nothing in the operating business explains that. The explanation is sitting in a warehouse.

## The sentence that connects the two halves

> **Idle inventory still depreciates.**

That is the whole link between process metrics and the P&L. A dress that is being inspected, washed, or waiting for a batch is not earning anything — but it is losing value at exactly the same rate as one that is out with a customer. Every day of flow time you add is a day of depreciation you pay for and earn nothing against.

Which means a process improvement that cuts flow time cuts inventory, and cutting inventory cuts the depreciation charge — **even if revenue never moves at all**. That is an unusual and powerful lever, because it improves profit without needing a single extra customer.

## Where the dresses actually are

Apply Little''s Law stage by stage and the problem becomes visible:

| Stage | Flow rate | Flow time | Inventory |
|---|---|---|---|
| At customer | 200/day | 10 days | 2,000 |
| Shipping both ways | 200/day | 2 days | 400 |
| Inspection | 200/day | 5 days | 1,000 |
| Quick clean | 140/day | 1 day | 140 |
| Buffer + max clean | 60/day | 4 days | 240 |
| Rental-ready | — | — | 500 |
| **Total** | | | **4,400** |

Only 2,000 of 4,400 dresses are with a customer at any moment. The rest are in transit, being inspected, or waiting.

Now the depreciation lands:

$$4{,}400 \times \$6 = \$26{,}400/\text{day} \quad\Rightarrow\quad \text{net loss} \approx \$3{,}900/\text{day}$$

Turnaround inside operations is $\frac{2{,}000}{200} = 10$ days. So a dress earns for ten days and sits idle for ten days. It earns roughly **half the time it exists**, while depreciating all of it.

## The fix that feels obvious and is wrong

Shorten the rental to five days. Each dress then serves twice as many customers — surely that helps?

> Trap: It makes things worse. Earning time per dress falls, but the ten idle days inside operations do not shrink at all — inspection still takes five days, cleaning still takes four. So to serve the same demand you need *more* total dresses, and depreciation scales with the fleet. You shortened the earning half and left the wasteful half untouched.

## The fix that works

Attack the idle time instead. Cut inspection from five days to two: total inventory falls from 4,400 to about 3,658, depreciation to about $21,950/day, and the business swings to roughly **+$525/day**.

Same customers. Same price. Same revenue. The entire swing came from dresses spending fewer days doing nothing.

> Trap: That is a thin margin resting on the max-clean batching assumption. If arrivals thin out, the buffer wait grows and it flips straight back into loss. The right exam answer names the sensitivity rather than declaring victory on the number.
', null);
insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('MKTG', 'case_kookaburra', 'Kookaburra Cricket Bats', '
Kookaburra is deciding how to position a new cricket bat: as a **niche** premium product, or as a **mainstream** volume one.

Both options are on the table with full forecasts, and the case is a test of whether you can resist answering from the top-line numbers.

## What the forecasts say

| Scenario | Units | Profit before cannibalisation |
|---|---|---|
| Niche, Year 1 | 80,000 | −₹11,900K |
| Niche, Year 2 | 150,000 | ₹35,300K |
| Mainstream, Year 1 | 270,000 | ₹35,500K |
| Mainstream, Year 2 | 440,000 | ₹155,300K |

Read those and mainstream looks obviously better — bigger in both years, profitable immediately. But every one of those figures is *before* cannibalisation, and the existing bat carries a unit margin of **₹810.47**.

## What cannibalisation does to Year 1

Niche Year 1 runs at a 22% cannibalisation rate.

$$80{,}000 \times 0.22 = 17{,}600 \text{ units} \qquad 17{,}600 \times 810.47 = ₹14{,}264\text{K}$$

That destroyed margin turns a ₹11,900K loss into **−₹26,164K**. The cannibalisation more than doubled the damage — and it would have been invisible if you had stopped at the forecast table.

## The break-even test

By Year 2 the BECR for the niche option is **0.29** — it can absorb up to 29% cannibalisation before the launch stops being worth doing, against 22% expected. It clears, but the margin for error is thin.

> Trap: If **both** positioning strategies produce losses, the answer is neither. "Pick the less bad one" is not what is being asked, and a recommendation to launch something loss-making needs a strategic argument that the arithmetic cannot supply.

> Trap: Volume discounts mean marginal cost **differs between the two scenarios**. Carrying a single unit cost across both will give you a comparison that looks rigorous and is wrong.

## The other half of the case

A new bat faces **adverse selection**: buyers cannot verify performance claims before purchase, so they rationally discount them. Which means the launch needs a credible signal, not just an assertion:

- Celebrity endorsement — Virat Kohli using the bat
- Money-back guarantee, or no-questions-asked returns
- Extended warranty
- Strategic scarcity (demarketing)
- Live demonstrations
- **Premium pricing itself**, which signals quality precisely because a bad product could not sustain it
- Exclusive distribution

Notice what these have in common: each is expensive or risky for a firm with a *bad* product, which is exactly why they carry information. A signal anybody could send tells the buyer nothing.

## The framing to keep

> Prof: Break-even and sensitivity analysis are the **first step**, not the decision. Strategic, social and ethical factors sit alongside the arithmetic.
', null);

-- learn_session_content: 18 rows
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 2, 'Segmentation, Targeting & Positioning', '
## Where this session goes

Session 1 said positioning happens in the consumer''s mind. This session is the machinery for getting it there: how to find groups worth serving, how to choose between them, and how to write down what you will mean to the one you pick.

## The 4 Ps are not universal

Other frameworks add **Purpose** (the why — profit, health, environment, behaviour change), **People** (employees, not customers: compensation, wellness, culture) and **Processes** (supply chain, manufacturing).

The **4 As** — Acceptability, Accessibility, Awareness, Affordability — are the same ideas relabelled from the customer''s side rather than the firm''s.

> Trap: If someone asks about the 4 As, they are asking about the marketing mix. Do not treat it as a separate framework you have not seen.

## Segmentation bases

| Basis | What it splits on | Examples |
|---|---|---|
| **Geographic** | Region, country, city | McDonald''s is upscale in India, low-end in the US. Haldiram''s pani puri is under $1 in India, ~$10 in England |
| **Demographic** | Age, income, education | The most common, because it describes segments in **reachable** terms |
| **Behavioural** | Purchase history, usage, loyalty | Amazon, Starbucks loyalty programmes |
| **Psychographic** | Lifestyle, values, attitudes | Red Bull (thrill), Lululemon (fitness) |
| **Benefit** | The specific benefit sought | Toothpaste: whitening vs sensitivity vs cavities |

> Trap: Even when you segment behaviourally or psychographically, you still have to describe the segment **demographically** to actually reach it. Media is bought on demographics — there is no "adventurous people" targeting option.

> Worked example: The (RED) iPhone sells on standing apart plus a social cause. In China the AIDS-funding angle is not communicated at all — red carries festive meaning there and disease associations are avoided. Same product, different psychographic framing by geography.

## Targeting

Pick the segment that best maximises your objective — which is not always profit. Patagonia''s objective includes environmental welfare, and that changes which segments are attractive.

An attractive segment is large and growing, has strong unmet pain, fits your core competencies, lets you make a believable offer, and does not trip regulatory requirements.

The matrix is attractiveness against **your capability**.

> Trap: The dangerous cell is low capability in a highly attractive market. Everyone can see it is attractive, strong competitors are already there, and they will punish the entry. Attractiveness alone is a trap.

> Trap: Watch for **leakage** — a message aimed at one segment reaching and upsetting another. Limit reach and avoid content that alienates adjacent segments.

Segments are derived with **factor analysis** (collapse 50+ variables into 2–3 dimensions) then **cluster analysis** (group similar customers, maximise dissimilarity between clusters).

## Niche targeting

A niche lets you build a monopoly in a small segment and extract full value, while staying beneath the notice of dominant players. The smallest possible segment is one consumer served exactly as needed — **most pain, most need, least served**.

> Worked example: Red Bull entered the US as a **mixer** to go with vodka, not as a cola competitor. The taurine and bull-testicle rumour circulated and Red Bull stayed silent, letting the mystique build. Coke and Pepsi dismissed it — "our segment doesn''t drink that." By the time they noticed, Red Bull was too entrenched to acquire or displace.

The lesson is that entering a *different* segment avoids retaliation until it is too late for the incumbent. Attacking head-on invites a response from someone with more money than you.

## When not to differentiate

Differentiation is expensive, and it is not always right.

- If market demand **exceeds** combined supply capacity, a third firm can enter doing the same thing and still profit. Price wars only start when firms need to steal each other''s customers.
- **Co-location** is deliberate non-differentiation: petrol stations, jewellery shops and museums cluster because customers prefer clusters — it lowers the risk of a wasted trip and raises category traffic.

> Trap: Price-sensitive consumers are a reason to differentiate **more**, not less. Without differentiation you get pulled into a price war with no margin, and price-sensitive customers are exactly the ones who will leave for a cheaper option.

## Positioning

The place a brand occupies in the consumer''s mental map, relative to competitors.

> Prof: The positioning statement is written **first**, as an internal guide. Differentiation is how that positioning gets implemented through product, price and channels.

**Positioning statements are internal only and never published.**

> Trap: Publishing one reveals who you think you compete with and invites comparative advertising. When BMW and Audi fought publicly, the outcome was that consumers bought Japanese cars instead — the fight legitimised the question and a third party won it.

The template: "To customers who are **<target market>**, our **<brand>** offers **<points of difference>** relative to **<frame of reference>**, because **<reasons to believe>**."

> Prof: Writing one is not inherently hard. It is hard when you skipped the 5C analysis and the segmentation work that has to come first.

## BMW: how it got there

BMW entered North America in the 1950s through independent distributors and opened BMW North America around 1975–76, launching "The Ultimate Driving Machine."

Between 1986 and 1989, Acura, Infiniti and Lexus entered with cheaper high-quality alternatives and BMW''s sales fell. From 1992 it recovered by reorganising dealers, launching new models and running inventive campaigns including James Bond placement — achieving the highest return on marketing spend among US auto manufacturers. **Lexus spent twice what BMW did to sell the same volume.**

| Series | Share | Profile | Loyalty |
|---|---|---|---|
| 3-series | 50% | ~35, mostly male, tech-savvy, high earners, unmarried | **Least loyal** |
| 5-series | 32% | Slightly older, some married, no children yet | Middle |
| 7-series | 16% | Older, senior roles, $300K+, married with college-age kids | **Most loyal** |

Read that with STP in hand: half the volume comes from the *least* loyal segment, so BMW must keep refilling the 3-series every generation. That is the problem the next session''s campaign is aimed at.
', null, '
## STP

- **Segmentation** → what groups exist
- **Targeting** → which to pursue (attractiveness × **your capability**)
- **Positioning** → the place you occupy in their mind

## Segmentation bases

Geographic · Demographic · Behavioural · Psychographic · Benefit

Derived via **factor analysis** (reduce dimensions) then **cluster analysis**

> Trap: Whatever basis you segment on, you still describe the segment demographically to reach it.

## Positioning statement (internal only, never published)

> "To customers who are **<target market>**, our **<brand>** offers **<point of difference>** relative to **<frame of reference>**, because **<reason to believe>**."

## Growth plays

- **Adjacent segment** — expand along a spectrum (Toyota)
- **Niche** — most pain, most need, least served (Red Bull, Rolex)

## When not to differentiate

- Demand exceeds combined supply capacity
- Co-location raises total category traffic
', '2026-08-10T10:05:39.501564+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 3, 'Marketing Analytics & Break-Even', '
## Where this session goes

Session 2 set up BMW''s problem: half its volume comes from its least loyal segment. This session shows what BMW did about it — and then turns to the arithmetic that lets you judge any marketing decision rather than admire it.

## BMW Films, analysed

Launched in 2000, deliberately during a **six-month window with no new product launches** — the campaign had to carry the brand alone. Five short films with top directors and actors: $15M production, about $15M promotion, $30M total. Released only on BMWfilms.com, behind registration and a player download.

About **2M registrations and 6M+ views** — roughly 3 views per registered user. Average viewer was 30 years old, $88K income, 63% college-educated. Students described the films as fast, adrenaline-driven, funny, unpredictable and unconventional.

### Why it worked

The real target was **future 3-series buyers** — college-age consumers with internet access, years away from affording the car. The film was built for them, which is why it landed with that group.

Everything that looks like a distribution mistake was a filter. 7-series customers, on $300K+, were **deliberately excluded**: the registration friction screened them out, and the tone was neither prestigious nor luxurious — that segment found it disrespectful.

> Prof: Effective targeting means the message will **not** appeal to other segments. Preventing leakage is as important as reaching the target.

That is the transferable idea. A campaign everyone likes has usually positioned nothing.

Afterwards BMW used the registration data to spot future high earners and invited them to test drives, keeping them engaged years before they could afford to buy.

### What it cost, and what was missed

$$\frac{\$30\text{M}}{2\text{M registrants}} \approx \$15 \text{ per person}$$

A prime-time TV ad runs about **$0.02 per viewer**. Not a like-for-like comparison — a registered, profiled, self-selected viewer is worth more than an incidental one — but you should raise it before you are asked.

> Trap: The distribution gap is the standard exam criticism. The films ran **only** on BMWfilms.com — not on BMW.com, not on auto magazine sites, not at auto shows, not on CDs or DVDs at dealerships. Exclusivity was the strategy, but nothing about it required staying off BMW''s own homepage.

## The analytics block

Now the tools. Everything below is a rearrangement of one identity:

$$\text{Profit} = (P - C)Q - F$$

Unit contribution is $P - C$.

$$\%\text{Margin} = \frac{P - C}{P} \qquad \%\text{Markup} = \frac{P - C}{C} \qquad Q_{BE} = \frac{F}{P - C}$$

Margin divides by **price**, markup divides by **cost**. Same numerator, and markup is always the bigger number. Exclude sunk costs from the break-even.

### Cannibalisation

A new product that eats into your existing one is not automatically bad — the question is how much it can eat before the launch stops being worth doing.

$$\text{Cannibalisation rate} = \frac{\text{units cannibalised}}{\text{new product units}} \qquad \text{Cost} = \text{units cannibalised} \times \text{old margin}$$

The **break-even cannibalisation rate** is the point where new-product profit exactly offsets the cannibalisation loss.

> Worked example: The cricket bat, Year 2. Benefit from the launch is ₹3.53 crores. Expected cannibalisation is 22% against a break-even cannibalisation rate of **29%** — so up to 29% is tolerable and the launch survives at 22%. Not comfortably, but it survives.

> Trap: If **both** positioning strategies produce losses, the answer is neither. "Pick the less bad one" is not the expected answer.

## Signalling quality

Consumers distrust claims about new products because they cannot verify them before buying — **adverse selection**. So a claim needs a signal, and a signal only works if a firm with a bad product could not afford to send it:

- Celebrity endorsement (Virat Kohli using the bat)
- Money-back guarantee or no-questions-asked returns
- Extended warranty
- Strategic scarcity, or demarketing
- Live demonstrations
- **Premium pricing itself as a quality signal**
- Exclusive or premium distribution channels

Each of these is expensive or risky if the product is poor, which is exactly why they carry information.

## Golden rule of pricing, first pass

Raise price only when demand is **inelastic** — formally, $\dfrac{p - mc}{p} = \dfrac{1}{\varepsilon}$.

- **Niche segment** — smaller volume, less price-sensitive, higher price justified
- **Mainstream segment** — larger volume, more price-sensitive, lower price needed

> Trap: Volume discounts are why marginal cost differs between the two positioning strategies. If you carry one unit cost across both scenarios you will get the comparison wrong while appearing rigorous.
', null, '
## Profit

$$\text{Profit} = (p - c) \times q - F$$

Unit contribution $= p - c$

## Margin vs markup

$$\%\text{Margin} = \frac{p - c}{p} \qquad \%\text{Markup} = \frac{p - c}{c}$$

Margin divides by **price**, markup divides by **cost**. Converting between them:

$$\text{margin} = \frac{\text{markup}}{1 + \text{markup}} \qquad \text{markup} = \frac{\text{margin}}{1 - \text{margin}}$$

## Break-even

$$Q_{BE} = \frac{F}{p - c}$$

Ignore sunk costs. For a change in margin:

$$\frac{Q_{BE}^{\text{new}}}{Q^{\text{old}}} = \frac{\text{old contribution}}{\text{new contribution}}$$

## Cannibalisation

$$BECR = \frac{\text{new product contribution}}{\text{old product contribution}}$$

$$\text{Cannibalisation rate} = \frac{\text{old units lost}}{\text{new product units sold}}$$

> Trap: Actual rate $>$ BECR means the launch loses money.
', '2026-08-10T10:05:39.501564+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 1, 'Marketing Fundamentals', '
## What marketing actually is

Most people arrive with a definition of marketing that means "advertising." That definition will not survive this course.

**Marketing is creating, communicating, delivering and extracting value for consumers.** Four verbs, and notice the last one — extracting value is part of the job, not something the finance team handles afterwards. A firm that creates enormous value and captures none of it is not doing good marketing. It is doing charity with extra steps.

This course is about B2C.

> Prof: "Make what you can sell, not sell what you can make." This returns in Session 5 with Unilever and is the spine of the whole course.

That sentence is the difference between marketing and sales. Sales starts with the product you have. Marketing starts with the customer you want.

## 3 Cs, then 5 Cs

Before deciding anything, you have to understand the situation. Start with three:

**Customer, Company, Competition.** Then add two more that people forget until they matter:

- **Context** — regulatory environment, laws, tariffs
- **Collaborators** — partners, government subsidies, R&D alliances

## Setting strategy: STP

- **Segmentation** — divide the total market into distinct groups
- **Targeting** — select which group to focus on
- **Positioning** — how the brand is perceived in the consumer''s mind

Note the order, and that positioning happens **in the consumer''s mind**, not in your deck. You do not decide your positioning; you decide what you will do to influence it.

A **positioning map** plots competing products on the axes consumers actually care about, such as price against quality.

> Trap: The axes need not be labelled in advance. Statistical techniques generate the map from consumer data — you are *discovering* which dimensions matter, not assuming them. A map drawn from your own intuition tells you what you already believed.

## Customer value

**Value = benefits − costs**, and both sides have economic and non-economic parts. That second half is where most of the interesting behaviour lives.

- Non-economic **benefit** — the emotional attachment of "I built this" (the IKEA effect)
- Non-economic **cost** — patients disliking an AI diagnosis because it makes them feel un-special

Neither appears on a price tag, and both change what people buy.

## Value proposition

What you deliver that consumers need and rivals cannot.

| Term | Definition | Purpose |
|---|---|---|
| **Points of parity** | Needs both you and the rival fulfil | Neutralise the competition |
| **Points of differentiation** | Needs you fulfil that rivals cannot | The basis of your value proposition |

Points of parity are not wasted effort. They are the price of entry — the reasons a customer *cannot* rule you out. Differentiation is what makes them choose you.

> Trap: Communicate consumer **needs**, not internal capabilities. "A reliable phone" is a value proposition. "Six sigma certified" is a fact about you that no customer asked for, and it forces them to do the translation themselves.

## The 4 Ps

- **Product** — core (battery life, display, camera, processor, size) plus augmented (ecosystem, warranty, financing, brand, after-sales). Brand usually sits in product strategy and also feeds positioning.
- **Price** — the only P that **generates revenue**. Every other one costs money. Price also signals quality.
- **Place** — direct, through retailers (P&G to Walmart), or online. The iPhone launching exclusively on AT&T was a place-based differentiator.
- **Promotion** — advertising, communications, persuasion, sales incentives. BMW Films is the standing example.

## Two kinds of differentiation

| Type | Basis | Test | Examples |
|---|---|---|---|
| **Horizontal** | Taste | No option is objectively better | Phone colour, vanilla vs chocolate, pulp vs no-pulp |
| **Vertical** | Quality | Everyone prefers more of it | Battery life, megapixels, screen resolution |

The distinction matters because it determines whether you can charge more. On a vertical dimension everyone wants more, so more commands a premium. On a horizontal one, half the market actively prefers the other option — and offering both is a variety decision, not a quality one.

**Conjoint analysis** identifies which attributes consumers weigh most, so you differentiate where it counts rather than where it is easy.

## Umbrella brands

One name across many products — Coke and Diet Coke. The benefit is borrowed brand equity; the risk is that a failure damages the parent.

> Worked example: Toyota launched **Lexus** as a separate brand to protect the quality perception; BMW launched **Mini Cooper** separately to avoid diluting its premium image. Apple did the opposite — iPhone and iPad are line extensions under one umbrella, because each success reinforces the others.

A new brand is warranted when the risk of damage is high, or when the image would be misaligned.
', null, '
## Definitions

- **Marketing** = creating, communicating, delivering and **extracting** value
- **Value** = benefits − costs (each having economic and non-economic parts)

## Frameworks

- **3 Cs** — Customer, Company, Competition
- **5 Cs** — + Context, Collaborators
- **STP** — Segmentation → Targeting → Positioning
- **4 Ps** — Product, Price, Place, Promotion (**Price** is the only one that generates revenue)
- **4 As** — Acceptability, Affordability, Accessibility, Awareness
- **Product levels** — Core → Actual → Augmented
- **Planning process** — 5 Cs → STP → 4 Ps

## Value proposition

- **Points of parity** — you and the rival both deliver → neutralise
- **Points of differentiation** — only you deliver → the proposition

## Differentiation

- **Horizontal** — taste-based, no objective winner
- **Vertical** — quality-based, everyone prefers more
', '2026-08-10T10:05:39.501564+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 4, '5 Cs & Customer Decision-Making', '
## Where this session goes

You now have frameworks for the market and the arithmetic to test decisions. What is still missing is the customer — specifically, how they actually decide, and what happens when a firm misreads what its customers want from it.

## The 5 Cs, properly

| C | The question |
|---|---|
| **Customer** | Who are they — needs, wants, lifestyle, preferences, willingness to pay? And **how do they decide**? |
| **Company** | Core competence, strengths, weaknesses, goals |
| **Competition** | Who competes for our customers — their strengths, weaknesses, and **likely reactions to our actions** |
| **Context** | Regulation, economy, culture, technology |
| **Collaborators** | Who can help us, and can they **capture enough value** by helping? |

Two of those cells are easy to skim past and shouldn''t be. Competitors have *reactions* — a plan that assumes they stand still is not a plan. And collaborators need to make money from helping you, or they will stop.

> Prof: Willingness to pay links straight back to horizontal and vertical differentiation. Which attributes will a consumer pay more for, which do they merely want, and which do they not care about? Higher-income consumers pay for quality improvements; others will not.

## The customer decision-making process

Awareness of need → Identify alternatives → Get information → Evaluate alternatives → **Purchase decision** → Use → Post-purchase evaluation → repeat purchase, or back around the loop.

> Trap: The **acquisition/retention split happens at the purchase decision**. Everything before it is acquisition spend; everything after is retention. Exam questions test whether you know which side of that line a given activity sits on — and the boundary is where CLV, next session''s topic, gets its two different formulas.

## United Breaks Guitars

United is one of the three largest airlines in the world. Its economy value proposition is **affordable connectivity** — mainstream, not premium.

2009 customer satisfaction: Southwest 81, Continental 68, Delta 64, American 60, US Airways 59, Northwest 57, **United 56 — last**.

In 2008 Dave Carroll flew Halifax to Omaha and United broke his guitar. No compensation. Fifteen months later he posted the video. The VP of Customer Relations offered $2,400; Carroll declined; United donated $3,000 to a music school. United responded publicly **only on Twitter**, including "The fact is that 99.95% of our customers'' bags are delivered on time and without incident."

Carroll became a celebrity, made a fuss when his bag went missing on a later United flight, and wrote two more songs.

### Should United improve customer service?

Every instinct says yes. Hold that instinct and weigh three things: the **service-profit relationship**, **vertical differentiation**, and **who the target segment actually is**.

> Prof: There will come a point where offering more customer service does not bring a return on investment. You should stop increasing it at that point. There is an optimal level of customer service for every product and service.

*Optimal*, not maximum. Service costs money, and for a price-driven segment that money comes out of the fare.

Vertical differentiation means that in a market where consumers differ in willingness to pay, firms deliberately offer higher and lower quality. Consumers who will not pay much consume the lower-quality option — and serving them properly at that price is a legitimate position, not a failure.

> Trap: The expected answer is **not** "United should have apologised better." Highest possible customer service is not always desirable. Do what is right for your target segment, not what the internet demands. A payment large enough to satisfy a viral complainant is a payment you have now promised everyone with a camera.

## Uber: pickup quality and ML

The other half of the session is about turning a vague complaint into something buildable.

Six stages, each with pain on both sides — and often the same event seen twice:

| Stage | Rider pain | Driver pain |
|---|---|---|
| Contextualize | The car passed me, I have to walk | I can''t see the rider |
| Assist | Wrong pickup location, I have to coordinate | Rider is elsewhere, I loop around |
| Depict | I''m at the location, the driver isn''t | Rider is not where depicted |
| Navigate | Driver stopped on the wrong side | Lost time to bad navigation |
| Track | The car icon spins, the ETA keeps changing | Rider cancels after I''ve driven minutes |
| Meet | I can''t find my car among all the Ubers | I can''t find my rider in a crowd |

That table is the real deliverable. "Pickups are bad" is unbuildable; "the ETA keeps updating while the icon spins" is something an engineer can attack.

$$\text{Pickup Quality} = \min\big[0.30\,(\text{ETA vs ATA}) + 0.20\,(\text{Driver idle}) + 0.30\,(\text{Location error}) + 0.20\,(\text{Cancellation})\big]$$

Note that two components measure the *driver''s* experience — a rider-only metric would have optimised the supply side into the ground.

> Trap: A complete analysis requires doing this **for each of Uber''s five target segments separately**. A single blended metric hides the segment where the experience is worst, which is usually the one about to churn.

### Building the model

Business analyst leads (define the problem → decide whether ML is even appropriate → gather and label data) → data scientist leads (preprocess, define features, select the approach, improve the model) → UX leads (make decisions, design the experience).

> Trap: "Evaluate if ML is appropriate" is an explicit step, not a formality. Plenty of pickup problems are fixed with better map data or a clearer UI and no model at all.

Takeaways: start with the customer, use quantitative metrics to define success, build cross-functionally, and think **"glocal"** — global strategy with local nuance.
', null, '
## 5 Cs

Customer · Company · Competition · Context · Collaborators

> Collaborators must be able to **capture enough value** to keep helping you.

## Customer decision-making process

Awareness → Identify alternatives → Get info → Evaluate → **Purchase** → Use → Post-purchase evaluation → Repeat

- **Acquisition** is everything before the purchase decision
- **Retention** is everything after

## Uber pickup quality

**Minimize [(0.30 × ETA vs ATA) + (0.20 × Driver Idle Time) + (0.30 × Pickup Location Error) + (0.20 × Ride Cancellation)]**

## Service level

- There is an **optimal** level of customer service, not a maximum
- **Vertical differentiation** — deliberately serving low-WTP segments with lower quality is a strategy, not a failure
', '2026-08-10T10:05:39.501564+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 7, 'Lean Deep Dive, Quality Dimensions & Statistical Foundations', '
## Where this session sits

Lean gets finished here, and then the course pivots. Everything so far has been about *flow* — how fast, how much, how long. The rest is about **quality**: not how much you produce, but how reliably it matches what you promised.

## Lean, finished

Lean is a philosophy of waste elimination, where waste (*muda*) is the gap between your process and the ideal one: demand arrives, output appears instantly, zero flow time, zero inventory. Unachievable — and every deviation from it is still waste.

That definition is deliberately uncomfortable. It refuses to let you call a two-day inspection acceptable because it is normal. You may not be able to remove it, but you do not get to stop calling it waste.

The tools all do one job, synchronising flow: batch size reduction, pull/JIT, Kanban, quality checks at every station, cross-trained resources, cellular layout.

> Trap: Lean firms do not mandate small batches. They reduce the **cost** of small batches — closer layouts, faster changeovers — and small batches follow naturally. Mandating the batch size without cutting changeover cost just destroys capacity, which is how a lean programme makes a plant slower.

### Inventory hides problems

Manufacturers use inventory to cover missed dates and scrap; lean firms cut inventory to make those failures **visible**, then fix root causes. Removing the buffer is a diagnostic instrument, not just a saving. Service firms hide the same problems in time buffers, like Swiggy padding an estimate by five minutes.

> Worked example: Toyota sorted inputs by disruption risk after the 2011 earthquake. Plastic resin substitutes easily, so no buffer. Semiconductors take years to rebuild, so it held a calculated 2 to 6 months of stock — and was the only major automaker largely unaffected by the 2021 chip shortage. Everyone else copied "eliminate inventory" without the distinction between excess stock and disruption buffer.

Starbucks shows the limit: for grab-and-go customers less flow time is value, for atmosphere customers dwell time **is** the product. Lean needs one clear ideal process, and Starbucks has two.

## Two questions hiding in one word

Now the pivot. A restaurant promises delivery under 30 minutes. Is that good quality? You cannot answer, because "quality" is concealing two separate questions.

**Quality of design** is what the customer needs — the spec itself. Is *under 30 minutes* the right promise? That is a marketing question.

**Quality of conformance** is how reliably the actual process hits that spec. That is an operations question, and process capability measures it.

Keeping them apart matters because the fixes are unrelated. Bad design is fixed by changing what you sell; bad conformance by changing how you work.

### Grab-A-Bite, before Anisha

The market is office lunch, so the spec is delivery **under 30 minutes**. Baseline mean 21.38 min, σ 7.73 min.

Your process does not produce one delivery time — it produces a distribution. The promise is a hard line. Conformance is therefore a geometry question: how much of your distribution falls on the wrong side?

- **Percent defective** — 12.5% of actual deliveries came in over 30 minutes
- **Sigma capability** — $\min\left[\frac{USL-\mu}{\sigma},\ \frac{\mu-LSL}{\sigma}\right]$, with LSL taken as 0 since delivery time cannot be negative

$$\min\left[\frac{30 - 21.38}{7.73},\ \frac{21.38 - 0}{7.73}\right] = \min[1.12,\ 2.77] = \mathbf{1.12\sigma}$$

> Trap: In class this was rounded aloud to "about 1.5 sigma," but the arithmetic on those exact numbers gives 1.12. Know the formula and be able to compute it — do not memorise the quoted figure. Check your own slide annotation before the exam.

> Trap: Why the minimum and not an average? Defects pile up on whichever side is closer. Averaging 1.12 and 2.77 reports 1.9σ and hides that one shoulder of the distribution is sitting almost on the promise.

## Central Limit Theorem

To monitor a process you need to know how much a measurement *should* wobble. That is what the CLT provides.

Individual delivery times scatter widely. Averages of many deliveries barely move. Formally, sample means of size $n$ are normally distributed regardless of the original distribution:

$$\bar{X} \sim N\left(\mu,\ \frac{\sigma}{\sqrt{n}}\right)$$

Two claims worth separating. First, **normal regardless of the parent distribution** — which is why the normal shows up everywhere in process control even when nothing measured is normal. Second, the spread is $\sigma/\sqrt{n}$, narrower than the process by a factor of $\sqrt{n}$. To halve your uncertainty you need four times the data.

## Hypothesis testing

The null hypothesis is the status quo — the coin is fair, the process mean is still 90 minutes. Data is judged against the null, and the burden of proof sits with the data. If what you observed would be very unlikely under the null, you reject it and raise the flag.

> Prof: You are never proving the new thing is true. You are asking whether the old story can still explain what you just saw.

Next session turns this into control charts: group outputs into buckets, plot the sample means, and test deviations statistically.
', null, '
## Capability

$$\text{Percent defective} = P(X < LSL) + P(X > USL)$$

$$\text{Sigma capability} = \min\left[\frac{USL - \mu}{\sigma},\ \frac{\mu - LSL}{\sigma}\right]$$

$$C_p = \frac{USL - LSL}{6\sigma} \qquad C_{pk} = \frac{\text{sigma capability}}{3}$$

> Trap: Always the **minimum**, never the average. The nearest spec limit is where the defects are. If only one limit is given, that is the only one you compute.

## Central Limit Theorem

Sample means are normal regardless of the parent distribution:

$$\bar{X} \sim N\left(\mu,\ \frac{\sigma}{\sqrt{n}}\right)$$

The standard error is $\sigma/\sqrt{n}$.

## Z-score

$$z = \frac{x - \mu}{\sigma} \qquad \text{for a sample mean:} \quad z = \frac{\bar{x} - \mu}{\sigma/\sqrt{n}}$$
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 8, 'Process Capability, SPC & Six Sigma', '
## The problem this session solves

You changed the process and this week''s numbers look better. Did it work, or did you get a good week?

That question needs a method, not an opinion — and the method has to work every day, not just once.

## Specification limits belong to the customer

First, a distinction that the whole session rests on. USL and LSL are **imposed from outside**. Grab-A-Bite''s 30-minute upper limit came from the customer promise, not from the kitchen. The LSL of zero is arguably irrelevant here — for delivery time it is effectively minus infinity, since nobody complains about early food.

> Trap: Sigma capability takes the **minimum** of the two Z values to catch the worst tail. Skewed distributions pile defects on one side, and the minimum finds the side nearer the mean. Doubling the tail probability is an upper bound on the defect rate, not the actual rate.

## Did the improvement work? Hypothesis testing

Anisha''s pilot: sample mean **19.2 minutes** from n = 100. Null hypothesis is that nothing changed — μ = 21.39, σ = 7.73.

> Trap: 19.2 is not a draw from the population distribution. It is a draw from the **sampling distribution of the mean**, which is $N\left(21.39,\ \tfrac{7.73}{\sqrt{100}}\right)$. Using σ instead of σ/√n is the most common error on this topic and it changes the answer by a factor of ten.

$$z = \frac{19.2 - 21.39}{7.73/\sqrt{100}} = -2.83 \quad\Rightarrow\quad p = 0.0023 \ \text{(one-sided)}$$

One-sided because only improvement counts — a delivery process getting *slower* is not evidence the change worked. And 0.0023 is comfortably enough to reject the null for food delivery; a vaccine would demand far more.

## Reducing the mean vs reducing the variance

Improvement can come from moving the mean, tightening σ, or both. They are not interchangeable.

> Trap: Lowering the mean is not automatically good. With a two-sided spec, pulling the mean too far creates defects on the *other* side — you relocated the failures rather than removing them. Grab-A-Bite is one-sided, so lower is simply better here. Do not carry that instinct into a two-sided problem.

A pathological case from class: mean falls 1000 → 100 while σ falls only 10 → 9. The coefficient of variation gets **worse**, yet the absolute defect count improves. Judge by defects against the spec — the customer experiences defects and has never heard of your CV.

## Daily tracking

Seven days of pilot data were tested day by day, not pooled.

> Trap: Lumping the days together averages out exactly the variability you are looking for. Each day can have its own mean and σ — traffic, weekday versus weekend.

Testing each day against μ = 19.32, σ = 7.73 flagged days 2, 3 and 6 as anomalous. That is not a verdict, it is a starting point for finding the external source.

## Control limits are not specification limits

| | Specification limits | Control limits |
|---|---|---|
| Set by | The customer | The process itself |
| Question | What does the customer want? | Is the process the same as yesterday? |
| Formula | Given | $\mu \pm 3\dfrac{\sigma}{\sqrt{n}}$ |

For Grab-A-Bite with $n = 50$:

$$19.32 \pm 3\frac{7.73}{\sqrt{50}} \quad\Rightarrow\quad UCL = 22.6,\ LCL = 16.04$$

Plot the daily sample mean. Crossing a limit triggers an investigation — it is a flag, not proof of a problem.

> Trap: "In control" and "capable" are independent properties. A process can sit comfortably inside its control limits while producing defects, because control limits say nothing about what the customer asked for.

> Trap: The lower limit still matters in a one-sided business. If deliveries suddenly get much faster, you want to know why — someone may be skipping a step. An unexplained improvement is an uncontrolled process.

### How wide should the limits be?

- **Narrow** — more false alarms, but you catch every real change. Right for vaccines and aerospace.
- **Wide** — fewer false alarms, but real shifts can pass unnoticed.

±3σ is convention, not law. The choice balances the cost of a needless investigation against the cost of a missed change, and those costs differ by industry.

## What Six Sigma is actually for

> Prof: Six Sigma is not primarily about near-zero defects in steady state. Its real value is **robustness when the process inevitably shifts**.

Every process drifts — a supplier changes, the weather turns, an experienced operator leaves. With σ tight enough, a mean shift still leaves output inside spec, so you keep producing while you hunt the root cause instead of shutting the line down. You are buying insurance against drift, not a headline defect count.

**DMAIC**: Define, Measure, Analyse, Improve, Control. The Control phase is the loop — get the process in control, then improve again from the new baseline. It is the phase people skip and the one that makes the rest worth doing.

Six sigma is a target. In many contexts 4.5 sigma is plenty, and "is it worth it here?" is a real business question.
', null, '
## Hypothesis test on a sample mean

$$\text{Standard error} = \frac{\sigma}{\sqrt{n}} \qquad z = \frac{\bar{x} - \mu_0}{\sigma/\sqrt{n}}$$

Use a one-sided p-value when only one direction counts as improvement.

> Trap: Divide by $\sigma/\sqrt{n}$, never by $\sigma$. This is the most common error in the topic — with $n = 100$ it understates $z$ tenfold.

## Control limits

$$UCL = \mu + 3\frac{\sigma}{\sqrt{n}} \qquad LCL = \mu - 3\frac{\sigma}{\sqrt{n}}$$

Width is a business choice; $\pm 3\sigma$ is convention.

## Specification vs control limits

- **Spec limits** — customer-imposed: "what does the customer want?"
- **Control limits** — process-derived: "is the process the same as yesterday?"

## Capability recap

$$\text{Sigma capability} = \min\left[\frac{USL - \mu}{\sigma},\ \frac{\mu - LSL}{\sigma}\right] \qquad C_{pk} = \frac{\text{sigma}}{3}$$

## DMAIC

Define → Measure → Analyse → Improve → **Control** (the loop back)
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 5, 'Queuing Design: Scale, Pooling & Cross-Training', '
## The question this session answers

Last session established that variability causes queues and that you cannot remove variability. That leaves an obvious follow-up: **so what can you actually do about waiting?**

Three answers, none of which require hiring anyone — pool, scale, or change what you promised.

## The nursing station, worked end to end

First, a complete example to anchor everything else.

$R_i$ = 3.5 patients/hr. Each nurse serves 3/hr (20 min each). Two nurses. $CV_i = CV_p = 1$.

$$\rho = \frac{3.5}{2 \times 3} = 0.583$$

Average wait in queue is about **11 minutes**. Then Little''s Law fills in the rest of the table — note that it applies inside the queue just as it does anywhere else:

| Where | Inventory | Time |
|---|---|---|
| In queue | 0.64 patients | 11 min |
| In service | 1.16 patients | 20 min |
| **Total system** | **1.8 patients** | **31 min** |

> Trap: The nurses are busy only 58% of the time and a queue still forms. That is not a contradiction, and it is worth sitting with. Variability scrambles arrivals and service into lumps — queues build during bursts and dissolve in the gaps, but the long-run average stays at 0.64. Idle time cannot be banked; backlog is real.

## Waiting is a function of utilisation and variability

- As utilisation approaches 100%, waiting time explodes toward infinity. You need spare capacity to dissolve a queue; at 100% there is never any catch-up time.
- As variability rises, the explosion starts sooner.
- When arrival rate equals service rate with any variability at all, the system is **unstable** and the queue grows without bound. Capacity effectively leaks.

That last point deserves emphasis because it is counterintuitive: a process with exactly enough capacity does not cope. It fails.

## Economies of scale

Now the surprising one. Scale the nursing station 10× — 35 arrivals/hr, 20 nurses, **same utilisation** — and the wait collapses to about **30 seconds**.

Utilisation did not change, so where did the wait go?

Into probability. A queue forms only when *every* server is busy at the moment you arrive. With two nurses that happens often. With twenty, all twenty being simultaneously busy is exponentially less likely. The variability is still there; it is being absorbed across more servers.

Run those 20 nurses at 13 instead and you get about 9.5 minutes of wait at roughly **90% utilisation**. That is the real prize: **scale is what lets you run hot without long waits.** Small operations must hold slack. Large ones need not.

> Prof: This is the whole quick-commerce bet. The economics only work at near-monopoly density. The current burn is a wager on getting there.

## The service strategy triangle

Sometimes the answer is not to reduce the wait but to change the promise. Three corners: **fast response**, **low cost**, **high variety**. Pick two.

| You want | You sacrifice | Examples |
|---|---|---|
| Fast + high variety | Low cost | Emergency rooms, fire engines, ambulances |
| Fast + low cost | High variety | McDonald''s, Subway, Burger King |
| High variety + low cost | Fast response | Neighbourhood tailors, government offices, local mechanics |

The ISB ambulance is free about 90% of the time **by design** — that idleness is the product, not waste. McDonald''s variety is an illusion: the same four or five items through the same steps every time, which is exactly why it is fast and cheap. A neighbourhood tailor keeps his server constantly busy and you accept the wait in exchange for getting precisely what you asked for.

Quick commerce wants fast plus low cost, but high delivery variability forces it into the high-cost corner. Dark stores cut variety somewhat — not enough to escape.

## Queue design

- **One queue feeding many servers beats many dedicated queues.** Splitting the nursing station into two dedicated lines pushes the wait from 11 to about **14 minutes**, because you lose the ability to send the next patient to whoever frees up first. Same staff, same demand, three minutes destroyed by layout.
- Separate queues are justified only when service types genuinely differ — express lanes, self-check-in. "It feels fairer" is not a reason; a single queue is also more fair.
- **Sequential (tandem) queues add variability at every stage.** Splitting one 20-minute service into a chain pushed total wait from 11 to about **28 minutes**. The exception is when specialisation genuinely makes each stage faster.
- **Priority queuing** moves waiting from one group to another. Give 20% of patients immediate service and their wait drops while everyone else''s rises — which is next session''s subject.
', null, '
## Utilisation

$$\rho = \frac{R_i}{c \times R_p}$$

## Waiting (Kingman / VUT)

$$W_q = \left(\frac{CV_i^2 + CV_p^2}{2}\right) \times \left(\frac{\rho^{\sqrt{2(c+1)}-1}}{c(1-\rho)}\right) \times T_p$$

$$T = W_q + T_p$$

## Little''s Law inside the queue

$$I_q = R_i \times W_q \qquad I_s = R_i \times T_p \qquad I = R_i \times T$$

## Design rules

- One queue, many servers **beats** many dedicated queues
- Tandem queues **add** variability at every stage
- Priority **redistributes** waiting, it does not remove it
- Pooling absorbs variability; scale lets you run hot without long waits
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 9, 'The Newsvendor Model', '
## The problem

You order once, demand is uncertain, and leftovers cannot be sold at full price. Newspapers, fresh food, fashion, hotel rooms, vaccine doses — all the same shape.

You have to commit before you learn. That is what makes it hard, and it is why the obvious answer is wrong.

Cookie example from class: sell at $2.49, cost $1.24, salvage $0.99. How many dozen do you make this morning?

## Why "order the average" fails

Ordering average demand would be right if being one short cost the same as being one long. It almost never does.

Here, failing to sell a cookie you made costs you $0.25. Failing to *have* a cookie someone wanted costs you $1.25 of margin you never earned. Running out is five times worse — so the right answer is not the average, it is deliberately more than the average.

That asymmetry is the entire model.

## Two ways to answer it

**Brute force.** Build the expected-profit table in Excel and read off the peak. It lands at **13 dozen**. Correct, and it teaches you nothing about why.

**Marginal thinking.** Ask, unit by unit: is the next unit worth making? Make it while the marginal expected profit is still positive. That question has a clean answer.

## The critical ratio

- **$C_u$ (underage)** = what you lose by being one unit short = price − cost = **1.25**
- **$C_o$ (overage)** = what you lose by being one unit long = cost − salvage = **0.25**

$$\text{Optimal service level} = \frac{C_u}{C_u + C_o} = \frac{1.25}{1.50} = 83.3\%$$

Then stock the smallest $Q$ where $P(D \le Q) \ge 0.833$, which gives Q* = 13.

> Prof: The critical ratio does not depend on the demand distribution at all. The distribution only enters at the last step, when you convert a service level into a quantity.

That separation is genuinely useful: the economics decide **how safe you want to be**, the demand data decides **what quantity delivers that safety**. They are different inputs from different people.

## A stockout is not always a failure

> Trap: A low service level is a feature, not a bug. Vegetables have a high $C_o$ — they rot — so the optimal service level is low and stocking out is the **correct** answer. Chasing 99% availability on perishables destroys money, and a manager boasting that they never run out of lettuce is describing a problem.

$C_u$ and $C_o$ should include intangibles: goodwill, the value of an attractor product that brings customers to the platform at all, and the cost of capital for durables. Exams like to bury one of these in the case text.

## Variants

- **Discrete demand** — go one above the cutoff if the upside probability still beats the threshold. Continuous demand stops exactly at the optimal service level.
- **More variable demand** — raises the stocking level and *lowers* profit. You buy protection and pay for it; uncertainty is expensive even when handled optimally.
- **A demand oracle** changes the decision itself, not just your confidence. Revalue the whole problem, do not just plug in a tighter σ.
- **Quick response** (a second ordering opportunity) drops the optimal service level from 75% to 50%, because being short is no longer terminal.
- **Hotel last-minute rooms** — same structure, different $C_u$ and $C_o$.
', null, '
## Newsvendor

$$C_u = \text{price} - \text{cost} \qquad C_o = \text{cost} - \text{salvage}$$

$$\text{Critical ratio} = \frac{C_u}{C_u + C_o}$$

That ratio **is** the optimal service level.

## Turning the ratio into a quantity

- Discrete demand: smallest $Q$ where $P(D \le Q) \ge CR$
- Normal demand:

$$Q^* = \mu + z \cdot \sigma, \qquad z = \Phi^{-1}(CR)$$

## Reading it

- High $C_u$ (losing a sale hurts) → high service level → stock more
- High $C_o$ (leftovers hurt) → low service level → stocking out is correct

> Trap: The critical ratio is independent of the demand distribution. The distribution enters only when converting the service level into $Q$.
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 5, 'Branding & Unilever Brazil', '
## The decision

Should Unilever launch a low-cost detergent for Brazil''s low-income Northeast — a segment it has never served?

The case is designed to expose whether you actually believe low-income consumers are worth understanding, or merely worth pitying. Most people fail it on the first pass by assuming poor customers want cheap things.

## Why they cannot simply ignore the segment

> Prof: In the end Unilever''s decision was quite simple. The mission is "to serve the needs of all people everywhere" — we are not a luxury brand company. And: never let what happened in India with Nirma happen again.

Nirma undercut Hindustan Lever from below and took enormous share. That is the strategic argument: a premium brand that abandons the bottom of the market does not leave it empty. It hands a competitor a base from which to attack upward.

So the question is not only "is this segment profitable?" but "what happens if we leave it to somebody else?"

## The customer insight that unlocks it

Northeast Brazil consumers are **price sensitive but also value conscious** — those are different things, and confusing them is the classic error.

> Worked example: Only **28% of households in Northeast Brazil owned a washing machine, against 67% elsewhere**. They wash by hand, using soap that yellows clothes, so they then need bleach. Cleaning power and whitening are not premium features to this customer — they are the core need, and hand-washing makes them matter *more*, not less.

> Trap: "Low income means they only want cheap" is wrong and it is the assumption that kills the launch. Price-conscious is not value-conscious. These customers will pay for the benefits that matter and refuse to pay for ones that do not — a more demanding customer than a rich one, not a less demanding one.

## The branding decision

Options considered: reposition Omo downward? Reposition Minerva or Campeiro? Extend Omo or Minerva? Unilever ultimately created a **new brand, Ala**, positioned between Minerva quality and Campeiro cheapness.

Incremental cost per kg: reposition an existing brand **$0**, extend an existing brand **$0.05**, launch a new brand **$0.10**. They chose the most expensive option — protecting Omo was worth ten cents a kilo.

| Choice | Like Minerva (premium) | Like Campeiro (cheap) |
|---|---|---|
| Formula | 1.40 | 0.90 |
| Packaging | Cardboard, 0.35 | Plastic, 0.10 |
| Price as % of Omo | 60% | 50% |
| Price $/kg | 1.80 | 1.50 |
| Promotion | Above the line, 0.15 | Below the line, 0.05 |
| Distribution | Wholesalers, 0.10 | Distributors, 0.05 |

Read that table as a set of coupled decisions rather than a menu. A premium formula with below-the-line promotion and distributor reach is not a coherent product.

## Break-even cannibalisation

$$BECR = \frac{\text{new unit margin}}{\text{old unit margin}} \qquad \text{Cannibalisation rate} = \frac{\text{volume lost from existing brands}}{\text{volume from the new brand}}$$

Compute Unilever''s current average margin per kg and the new product''s margin per kg, then compare.

> Trap: Unilever loses money if the actual cannibalisation rate is **above** the BECR. New volume has to come from competitors or from category expansion — volume taken from your own brands is a transfer to a worse margin, not growth.

## Takeaways

- **Make what you can sell, not sell what you can make**
- Find the right positioning and build to it
- Marketing to low-income consumers does not have to be charity — it can be profitable, but it is hard
- **Be disciplined**: deliver the important customer benefits, and only those. The discipline is in what you leave out.
- Be willing to re-engineer the marketing mix and to break company norms
- Look at the business through your customers'' eyes

## Chain-store paradox

A side note on why an incumbent might fight even when fighting costs it money.

| | Incumbent fights | Incumbent accommodates |
|---|---|---|
| Entrant enters | −$2M, −$2M | $2M, $2M |
| Entrant stays out | 0, $5M | |

Fighting is worse for the incumbent in this single game. In **repeated** interactions it pays, because the reputation deters the next entrant — which is exactly the Nirma lesson from the other side.

## Branding

A brand is a device that creates value **above and beyond the core product benefits** — relevant for search, experience and credence goods.

- **For the firm**: makes marketing actions more effective, and creates a separable asset
- **For the customer**: identifies the offering, differentiates it, signals quality credibly, and delivers emotional, social and self-expressive benefits

## Product lifecycle

Development → Introduction → Growth → Maturity → Decline, with sales and profit curves that peak at different times — profit usually earlier than sales, which is why a growing product can be a worsening business.
', null, '
## Break-even cannibalisation

$$BECR = \frac{\text{new unit margin}}{\text{old unit margin}}$$

$$\text{Cannibalisation rate} = \frac{\text{volume lost from existing brands}}{\text{volume of the new brand}}$$

Lose money when actual rate $>$ BECR. New volume must come from **competitors or category growth**.

## Positioning statement (Prof''s S5 variant)

> "For **<target segment>**, **<brand>** offers better **<points of difference>** than **<relevant competition>**, because it is **<reason>**."

## Key distinction

- **Price conscious** — wants the lowest price
- **Value conscious** — pays for benefits that matter, refuses those that do not

## Brand value

- To the firm: marketing effectiveness + a separable asset
- To the customer: identification, differentiation, quality signal, emotional/social/self-expressive benefit
', '2026-08-10T10:05:39.501564+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 2, 'Linking Process Flow to Financial Performance', '
## Where this session sits

Session 1 gave you three process metrics and a law connecting them. Useful — but a CFO does not fund process improvements because the flow time is elegant.

This session builds the bridge to money, and the bridge is one sentence: **inventory that is not earning is still depreciating.**

## Why airlines struggle to make money

An aircraft earns only when it is in the air. Every minute on the ground is a drag on an extremely expensive asset. So the operational metric is **turnaround time** — landing to next takeoff.

What makes it hard is that TAT is not fully inside the airline''s control. Weather, air traffic and cascading delays all intervene. So airlines attack the parts they can:

- Standardised fleets — IndiGo flies one aircraft type, so maintenance is faster
- Sky bridges instead of stairs and buses
- Pre-stocking supplies at the origin airport
- Dedicated gates for scheduling control; Delta effectively controls Atlanta

> Trap: Boarding-order optimisation is the famous one, and it is mathematically negligible. Zone, window-middle-aisle, back-to-front — none of it moves TAT enough to matter. Do not reach for it in an exam answer; it signals that you optimised the visible thing rather than the important one.

## Rent-A-Dress: a healthy business that loses money

200 dresses ship per day, a 10-day rental, $250 per rental ($25/day). Revenue $25,000 a day, operating costs about $2,500. It loses roughly $3,900 a day.

Nothing in the operating business explains that. Apply Little''s Law stage by stage and the explanation appears:

| Stage | Flow rate | Flow time | Inventory |
|---|---|---|---|
| At customer | 200/day | 10 days | 2,000 |
| Shipping (out + in) | 200/day | 1 day each | 400 |
| Inspection | 200/day | 5 days | 1,000 |
| Quick clean | 140/day | 1 day | 140 |
| Buffer before max clean | 60/day | 2 days | 120 |
| Max clean | 60/day | 2 days | 120 |
| Rental-ready | — | — | 500 |
| **Total** | | | **4,400** |

Only 2,000 of 4,400 dresses are with a customer at any moment. Everything else is in transit, being inspected, or waiting.

Turnaround inside operations: 2,000 units of non-customer inventory ÷ 200/day = **10 days**. A dress earns for 10 days and sits idle for 10 days — it earns roughly half the time it exists, while depreciating all of it.

## Where the money goes

| Line | Amount |
|---|---|
| Revenue | $25,000/day |
| Shipping | −$1,000 |
| Inspection | −$200 |
| Quick clean | −$700 |
| Max clean | −$600 |
| EBITDA | ~$22,500 |
| Depreciation | see below |
| **Net** | **−$3,900/day** |

Then depreciation lands:

$$4{,}400 \times \$6 = \$26{,}400/\text{day}$$

Depreciation on **idle** inventory is what kills it. The operating business is fine. The asset base is too big for the revenue it produces.

> Trap: The instinct is to shorten the rental to 5 days so each dress serves more customers. It does not work. Earning time per dress falls, the idle time in operations does not change, so total inventory has to *rise* to serve the same demand — and depreciation rises with it. You shortened the earning half and left the wasteful half alone.

## Break-even

A dress earns for roughly half its cycle, so revenue per cycle is 5P. Variable cost per cycle is about $12.50, and depreciation over a 22-day cycle is

$$22 \times \$6 = \$132$$

$$5P > \$144.50 \quad\Rightarrow\quad P > \$28.90$$

The current price is $25. The business is priced below break-even, and the viable band is narrow: a 2-day rental at $120/day is psychologically unacceptable, and a 15-day rental at $375 has no value proposition for a single occasion.

## The fix that works

Improve inspection from 5 days to about 2. Fewer dresses need max clean. Total inventory drops from 4,400 to about 3,658, depreciation falls to about $21,950/day, and the business swings to roughly **+$525/day**.

Same customers, same price, same revenue. The entire swing came from dresses spending fewer days doing nothing.

> Trap: That is barely break-even and highly sensitive to the batching assumption on max clean. If fewer dresses arrive, the 2-day wait gets worse and it flips back to a loss. Do not present it as a comfortable win.

## Same dynamic, other industries

Once you have the pattern, you see it everywhere the asset is the business:

- **Hotels** — a vacant room is a sunk cost; turnaround between guests is the metric
- **Restaurants** — table turns drive revenue
- **Car rental** — Enterprise keeps a fleet under two years old and is fanatical about turnaround; Hertz makes no age guarantee and always has spare cars on the lot
- **Consulting** — bench time is lost revenue; time-and-materials firms care far more than project-billing firms like Infosys
', null, '
## Linking flow to financials

$$\text{Asset utilisation} = \frac{\text{earning inventory}}{\text{total inventory}}$$

$$\text{Turnaround in ops} = \frac{\text{non-customer inventory}}{\text{flow rate}}$$

$$\text{Depreciation/day} = I \times d$$

where $d$ is depreciation per unit per day.

## Break-even price

$$(\text{earning days}) \times P = \text{variable cost} + (\text{cycle days} \times d)$$

> Trap: A dress earns for only part of its cycle. Use earning days, not cycle days, on the revenue side.
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 3, 'Flow Time, Capacity & Bottlenecks', '
## The shift this session makes

The first two sessions were diagnosis: describe a process, measure it, connect it to money. This one is the first about **improvement** — and it starts by separating two questions that people routinely merge.

- **How long does one unit take?** That is flow time, and it is governed by the *critical path*.
- **How many units per hour can we do?** That is capacity, and it is governed by the *bottleneck*.

Different questions, different levers, different answers. Confusing them is the most expensive mistake in this course, because the fix for one does nothing for the other.

## Theoretical vs actual flow time

**Theoretical flow time** is the minimum work time if a single rush order went through uninterrupted, with no waiting anywhere. It is the floor — the best the process could do for one unit — and it is the sum of activity times **on the critical path**.

For Kristen''s Cookies, one dozen: wash and mix 6 + spread 2 + setup 1 + bake 9 + cool 5 + pack 2 + billing 1 = **26 minutes**.

Actual flow time is always higher, because of batching, variability and resource contention.

> Prof: A passport application has about 15 minutes of theoretical flow time and takes weeks. The gap between those two numbers is the entire subject of process improvement.

### Choosing the flow unit

One dozen was chosen because it is the most probable order on a campus. The oven holds one dozen and the mixer holds three — but **operational constraints should not pick your flow unit, customer demand should.** Choosing "three dozen" because the mixer likes it gives you a tidy analysis of a process nobody asked for.

## Critical path

Theoretical flow time is the **longest path** through the process, not the sum of everything in it.

> Worked example: A car with a chassis line (5 hrs) and a body line (6 hrs) running in parallel, feeding assembly. The critical path A-D-E is 8 hours. Speeding up anything on the 5-hour branch changes nothing — the car still waits for the body.

Three levers to cut theoretical flow time, in rough order of how often they get missed:

1. Work faster on critical-path activities
2. Move activities off the critical path so they run in parallel
3. Shrink the batch so stages can overlap

> Worked example: Uranium enrichment, one batch of 7,200 takes 22 hours. Split it into two batches of 3,600 and flow time drops to 13 hours, because the second batch starts stage one while the first is on stage two. No machine got faster; the stages stopped waiting for each other.

## Capacity and the bottleneck

Now the other question. You do not control flow rate directly — flow rate is an outcome. You control **capacity**, and capacity meets demand to produce it:

- Demand < capacity → flow rate = demand. **Demand-constrained**; the fix is marketing.
- Demand > capacity → flow rate = capacity. **Capacity-constrained**; now operations matters.

Working out which of those you are in should be the first question, because it decides whether anything else in this session helps you.

The **bottleneck** is the resource pool with the lowest capacity — not the average, not the sum. The minimum.

> Prof: An hour lost at the bottleneck is an hour lost for the whole process. An hour saved anywhere else is a mirage.

That mirage is genuinely convincing. Speeding up a non-bottleneck makes that station''s numbers better and its people feel more productive, and produces zero extra output.

### Kristen''s Cookies, one dozen, one oven

| Resource | Time per unit | Capacity |
|---|---|---|
| Mixer | 6 min | 10/hr |
| Crystal | 8 min | 7.5/hr |
| Roommate | 4 min | 15/hr |
| Oven | 10 min | **6/hr** |

The oven is the bottleneck at 6 dozen/hr. The roommate is idle more than half the time, and that is fine.

## Adding capacity, and why you must rebalance

Buy a second oven and capacity does not double — it rises to 7.5/hr, because Crystal becomes the new bottleneck. The raw gain is 1.5 dozen/hr for a whole oven.

Now move the 2-minute spreading task from Crystal to the roommate. Crystal drops to 6 min, roommate rises to 6 min, ovens run at 10 min each. Combined oven capacity is 12/hr, and nothing else is below it.

> Trap: The second oven is worth 1.5 dozen/hr if you install it and walk away, or 4 dozen/hr if you rebalance the line afterwards. Same capital, very different return. Always rebalance after an investment — exam questions routinely stop at the purchase to see whether you notice.

## Demand mix changes the answer

Switch the flow unit to 2-dozen orders with one oven and the oven takes 20 min, giving 3 units/hr — still 6 dozen/hr, no gain. With two ovens it is 6 units/hr, which is 12 dozen/hr, double the baseline.

That is a real business conclusion: a discount for larger same-flavour orders can pay for itself when it shifts the demand mix toward better bottleneck utilisation. You are not buying volume, you are buying a mix.
', null, '
## Flow time

$$\text{Theoretical flow time} = \sum_{\text{critical path}} \text{activity times}$$

The critical path is the **longest** path through the process.

$$\text{Actual flow time} = \text{theoretical} + \text{waiting}$$

## Capacity

$$\text{Capacity of a resource} = \frac{\text{number of units of that resource}}{\text{time per flow unit}}$$

For one resource in units/hour: $\dfrac{60}{\text{minutes per unit}}$

$$\text{Process capacity} = \min_i(\text{capacity}_i) \quad \leftarrow \text{the bottleneck}$$

$$\text{Flow rate} = \min(\text{demand},\ \text{process capacity})$$

## Utilisation

$$\rho = \frac{\text{flow rate}}{\text{capacity}} \qquad \rho_{\text{implied}} = \frac{\text{demand}}{\text{capacity}}$$

> Trap: Utilisation caps at 100%. Implied utilisation does not — a value above 100% is what identifies the bottleneck at current demand.
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 8, 'Pricing Strategy', '
## Where this session goes

Last session gave you EVC — a ceiling built from the customer''s alternative. This session puts it to work on a real pricing decision, then generalises to the rule that governs every price you will ever set.

## Atlantic Computer: two ways to price the same bundle

The Tronn server plus PESA software, against a rival (Zinc) selling at a status-quo price of $2,000.

The awkward fact: one Atlantic bundle genuinely does the work of two Zinc servers. Priced as a single server, Atlantic is charging half price for the same capability — and the software was previously given away free, which makes the sales force reluctant to start charging.

**EVC-based pricing** starts from the **variable cost** as the floor.

- Variable cost: $1,538 (floor)
- EVC-based price: $2,431 above that floor
- Split the floor-to-ceiling range in half to get the recommendation

**Value-in pricing** starts from the **current price** as the reference instead.

- Cost of one Atlantic bundle: $5,000 (labour + electricity + software)
- Cost of two Zinc servers: $9,400
- Extra value created:

$$\frac{\$4{,}400}{2} = \$2{,}200 \text{ over the } \$2{,}000 \text{ reference} = \$4{,}200$$

> Trap: Value-in pricing **always** yields a higher number than EVC-based pricing, because it anchors on the current market price rather than on your cost. Both are acceptable. Use EVC when you need a defensible floor under competitive pressure; use value-in when you are advocating for a higher price. Say which you used — a number without its anchor is what gets challenged.

### What will actually happen

A price recommendation that ignores everyone else''s reaction is half an answer.

- **Consumers will resist.** The software was free before; charging about $1,400 for it will cause backlash, and customers will ask for evaluation contracts before committing.
- **Consumers run their own numbers**, which will not match yours. Labour savings may be zero if existing staff simply absorb the extra servers — which is why Atlantic uses a **2× multiplier rather than 4×**, deliberately conceding value to allow for customer conservatism.
- **Zinc will cut prices**, possibly from a $1,700 reference down to $1,200–$1,400. Be ready for a price war.
- Zinc may build its own performance software, so Atlantic has to keep innovating.

> Prof: Even if Zinc cuts its margin to zero, the Atlantic bundle still creates more value for the consumer. That is the point of value-based pricing.

## The golden rule of pricing

$$\frac{p - mc}{p} = \frac{1}{\varepsilon}$$

Percent margin equals one over price elasticity. More elastic demand (more price-sensitive customers) means a lower optimal margin and a lower price.

Plainly: if consumers keep buying when you raise the price, raise the price.

### What reduces price sensitivity

Note how many of these are design decisions rather than facts about the market:

- High switching costs
- **Price-quality inference** — a higher price reads as higher quality
- Shared costs, where somebody else pays part (an employer, an insurer)
- No easily comparable alternatives
- Small share of the total bundle
- Inability to stockpile

> Trap: **Elasticity and sensitivity are not the same word.** Elasticity is a measurable number you put into a formula. Sensitivity is qualitative — "more" or "less". Exam questions use the words precisely, so a question about sensitivity is not asking you to compute anything.

Elasticity is measured with conjoint analysis, logit regression on actual purchase data, and consumer choice models. The 2×2: actual purchase versus stated preference, crossed with natural versus experimental settings.

## Price discrimination

If different customers have different elasticities, one price leaves money on the table for some and loses sales among others.

| Degree | Basis | Example |
|---|---|---|
| **First** | Individual | Personalised pricing |
| **Second** | Self-selection off a menu | Bundles vs unbundled, business vs economy |
| **Third** | Segment | Student and senior discounts |
| **Behavioural** | Observed past behaviour | Amazon inferring sensitivity from purchase history |
| **Intertemporal** | Time | Skimming downward, or rising for network-effect products |

> Worked example: Bundling is second-degree discrimination. It works by combining **negatively correlated valuations** — you value A highly and B little, I am the reverse, so a single bundle price extracts more from both of us than separate prices would, because each of us is mostly paying for the half we wanted.

## Psychological pricing

- Prices ending in 9 work through **category perception**, not the one cent. $79.99 sits in a different mental bucket from $80, and the saving is irrelevant.
- Higher prices raise perceived **and even experienced** quality — the MRI wine study showed the brain responding differently to identical wine at a higher stated price. People were not lying about enjoying it more.
- **Prospect theory**: losses loom larger than gains. Segregate gains, aggregate losses when framing a price.

## Exam format

> Prof: The final is **MCQ only, half quantitative and half qualitative**, written on paper with OMR sheets. **One cheat sheet is allowed — both sides, printed or handwritten.** Basic calculators are permitted. Questions differ across sections. The cases were taught for conceptual learning, not for memorising case facts.
', null, '
## Golden rule of pricing

$$\frac{p - mc}{p} = \frac{1}{\varepsilon}$$

Percent margin equals one over price elasticity. More elastic demand → lower optimal price and margin.

## EVC vs value-in pricing

- **EVC-based** — anchors on **variable cost** as the floor, then splits floor-to-ceiling
- **Value-in** — anchors on the **current market price**, then splits the gap to EVC
- Value-in always gives a higher number

## What lowers price sensitivity

Switching costs · price-quality inference · shared costs · no comparable alternative · small share of total spend · cannot stockpile

## Price discrimination

1st individual · 2nd self-selection (bundling) · 3rd segment · behavioural · intertemporal

> Bundling works on **negatively correlated valuations**.

## Psychological

- Charm pricing works via **category perception**, not the cent
- Prospect theory: **segregate gains, aggregate losses**
', '2026-08-10T10:05:39.501564+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 1, 'Introduction to Operations Management', '
## The argument that opens the course

Before a single framework appeared, the class spent ten minutes arguing about one word: **efficiency**.

Output over input. Lower inventory. Beating the competition''s benchmarks. Every answer offered got shot down, and the shooting-down was the lesson.

> Prof: Blanket definitions do not work. Every business''s definition of "good" is a function of the promise it has made to its customers — its value proposition. Operations Management is the discipline of delivering on that promise.

Nothing else in this course makes sense without that. You will never be handed a universal formula for good operations. You will be asked, every single time: *given this firm''s promise, what must its processes achieve, and how would we know if they are?*

## Strategy, operations, process

The formal version of that argument is three questions stacked inside each other.

| Layer | The question | Dimensions to rank |
|---|---|---|
| Competitive strategy | What is our value proposition? How do we compete? | Price, Time, Quality, Variety |
| Operations strategy | Given that, what must operations do **particularly well**? | Cost, Responsiveness, Quality, Flexibility |
| Process structure | How do we structure processes to build those competencies? | Process choice and management |

The arrows run both ways. Strategy shapes process, but what is operationally feasible also limits which promises you can credibly make.

> Prof: Aligning these two ends is "60% of what a top-tier strategy consultancy actually does." Most engagements are, underneath, a diagnosis of a mismatch between what a firm promises and how its work is organised.

### Domino''s: where "30 minutes or free" came from

Ask who Domino''s competed with in 2008 India and the obvious answers — other pizza chains, other restaurants — are both wrong. It competed with **a customer making their own snack at home**.

Once you see that, the promise writes itself. To beat homemade pakoda you must win on **quick** and **hot**. Not variety. Not price. Those are what the alternative already does well.

And that promise then cascades into a process:

- 4 min order to oven
- 6 min bake
- 5 min cut and pack
- 8 min delivery
- = 23 min of work, plus a 7 min buffer, equals the 30 minute guarantee

Every downstream decision traces back to the 8-minute delivery target: store density, and one delivery person per order rather than batching two nearby ones.

> Trap: Batching two nearby deliveries looks more efficient and is the wrong answer here. Simple coordinated rules beat locally optimal customisation when orders can fall through the cracks.

### Swiggy, and a misalignment that hurt people

Swiggy''s promise moved from speed alone to speed **plus variety**, which cascades into onboarding diverse cuisines, spreading them geographically so fast delivery stays feasible everywhere, and keeping the app simple enough that variety does not become friction.

The counter-example shown in class: delivery partners paid purely per delivery, with no fixed component, are incentivised to ride without stopping. A strategic choice about incentives produced a real human cost — which is what strategy-to-process alignment looks like when it works exactly as designed and the design was wrong.

## Four more misalignments

None of these are on a slide, and together they are the fastest way to feel the framework.

- **NeXT** — built computers for research labs, then obsessed over a perfect one-foot cube case. Industrial-design precision was irrelevant to the promise and only raised the price.
- **Andre Agassi** — ran 15km a day until his coach pointed out that tennis is lateral 10m sprints and direction changes. He had trained hard at the wrong thing.
- **Adam Smith International** — a project-management middleman questioning why it kept so many in-house experts when its promise was managing external contractors.
- **Airtel vs Jio** — same industry, deliberately opposite alignment. Jio optimised price and reach; Airtel optimised reliability, layering fail-safe 5G on existing 4G and buying Indus Towers to turn opex into capex.

## The process view

Departments each see their own slice, which is why nobody in a company can explain why an order took three weeks. The fix is to stop looking at the org chart and follow the work.

A process is a **network of activities and buffers converting inputs to outputs**, with resources doing the work and an information structure coordinating it.

Five questions to adopt it:

1. What are the boundaries — what goes in, what comes out?
2. What is the flow unit?
3. Attach yourself to that flow unit and trace its steps.
4. Who does the work at each step?
5. What information is needed at each step, and where does it come from?

> Trap: Raw materials are not resources. Dough, cheese and vegetables are part of what is flowing. Resources are the doers of work — the chef, the oven, the rider. This is exactly the line between cost of goods sold and the process''s actual inventory.

Domino''s flow unit is an *unfulfilled order*, and roughly 5% of orders are infeasible and deliberately ignored — the process view works on long-run averages. Edge cases are fires, and by definition rare.

## Why financial measures are not enough

Revenue, net income, ROA and cash flow are all real. As **diagnostics** they are useless, and for three specific reasons: they are **infrequent**, **aggregate** (they hide where in the process the problem is) and **lagging** (they tell you something broke, not what to fix).

Process metrics are the opposite: leading, disaggregated, actionable.

## Little''s Law

Three numbers describe any process, and one equation ties them together:

- **Flow rate ($R$)** — units per unit time
- **Flow time ($T$)** — entry to exit for one unit
- **Inventory ($I$)** — units inside right now

$$I = R \times T$$

The technique that matters: when several distinct flow-unit types share a resource, split $R$, $T$ and $I$ **by segment** before applying the law. Applying it to a mixed population is simply wrong, and it is what the cafeteria problem exists to catch.
', null, '
## Little''s Law

$$I = R \times T$$

- $R$ = flow rate (units per unit time)
- $T$ = flow time (entry to exit)
- $I$ = inventory (units in process)

Rearranged:

$$T = \frac{I}{R} \qquad R = \frac{I}{T}$$

## Conditions for validity

1. Consistent units across $I$, $R$ and $T$
2. Long-run averages, not a snapshot
3. System is stable — what came in has gone out
4. The **same population** is counted in all three

> Trap: Condition 4 is the one exams test. Mixed customer types sharing one queue must be split by segment first.
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 4, 'Variability & Queuing I', '
## Two halves

The first half finishes capacity — how to raise it, and how to choose what to make with it. The second half opens the subject that occupies the rest of the course: **variability**, and why queues form even when you have enough capacity.

## Theory of Constraints

Identify the constraint, elevate it, then repeat — because once you fix one bottleneck, something else becomes the bottleneck. It is a cycle, not a project, and firms that treat it as a project stop one step too early.

Four levers to raise capacity:

- Add resources (simple, expensive)
- **Line balancing** — spread work evenly across people
- Change the product mix
- Change the batch size

> Prof: Eli Goldratt''s *The Goal* is the source, and it is worth reading before placements. Vector Consulting was founded on these principles and recruits from ISB.

## Flow time and capacity are orthogonal

This is the point people get wrong, and it is worth stating flatly: changing one does not necessarily change the other.

> Worked example: Add a second oven at Kristen''s Cookies. Capacity rises from 6 to 10/hr. Theoretical flow time stays at 26 minutes. You can bake **more**, not **faster**.

The bottleneck does not even have to sit on the critical path. If Scan is the bottleneck on the upper branch but the critical path runs through a longer lower branch, then flow time is set by the lower branch and capacity by Scan. Two different questions, two different answers, in the same process.

## Product mix: margin per bottleneck minute

In a make-to-stock business, capacity matters more than flow time. So which product should you make?

> Trap: Ranking by margin per unit is the naive answer. Rank by **margin per minute of bottleneck time**, because the scarce resource is the bottleneck minute — not the unit, and not your attention.

| Product | Margin | Oven time | Margin per oven minute |
|---|---|---|---|
| Oatmeal raisin | $3.10 | 25 min | **0.124** |
| Chocolate chip | $2.50 | 26 min | 0.096 |

Oatmeal raisin wins — but only because both products share the same bottleneck.

> Trap: When products have **different** bottlenecks, margin-per-minute comparison breaks down. You cannot put a bottleneck time and a non-bottleneck time in the same denominator; they are not the same currency. That is when you need linear programming.

## Linear programming, briefly

Decision variables are units of each product. The objective is total margin. Constraints are demand per product and total time available on each resource. For the cookie case it returns 100 chocolate chip and 13 oatmeal raisin. Airlines, retailers and FMCG firms use exactly this for assortment and production planning.

## Batching and capacity

Batching exists when setup time is large relative to per-unit time — a glass mould that takes 24 hours to set up and one minute per unit afterwards.

$$\text{Capacity} = \frac{X}{F + R \cdot X}$$

where $X$ is batch size, $F$ is setup time and $R$ is per-unit time. Bigger batches spread the setup over more units, so capacity rises.

## Variability

Now the turn. A fully deterministic process with capacity above demand never forms a queue — not a short one, none at all. Real processes are not deterministic, and that difference is not a rounding error. It is where all the waiting comes from.

- **Predictable** variability (seasonality, trend) can be planned around
- **Unpredictable** variability always hurts

> Prof: Think of it like a regression. Predictable variability is the explained variance — your regressors. Unpredictable variability is the residual. You can plan for the first and only buffer against the second.

### The beads game

Three dice in series, each roll being that stage''s capacity for the round. A single die averages 3.5, so intuition says the line should run near that.

> Trap: The long-run throughput is **less than 3.5** — the simulation settled around 2.8 and never reached it. A high roll only helps if there is inventory upstream waiting to use it. Good luck cannot be stored; bad luck blocks everything behind it. Variability interactions in series are always detrimental. A single stage, with nothing to starve it, does average exactly 3.5.

## The five things that determine a queue

Everything from here is built from these:

- Arrival rate ($R_i$)
- Service rate per server ($R_p$)
- Variability in arrivals ($CV_i$)
- Variability in service ($CV_p$)
- Number of servers ($c$)

Those five feed Kingman''s approximation to give average wait and queue length.
', null, '
## Capacity

$$\text{Capacity with batching} = \frac{X}{F + R \cdot X}$$

- $X$ = batch size, $F$ = setup time, $R$ = run time per unit

$$\text{Margin per bottleneck minute} = \frac{\text{margin per unit}}{\text{bottleneck time per unit}}$$

> Trap: Only valid when products share a bottleneck. Different bottlenecks need linear programming.

## Coefficient of variation

$$CV = \frac{\sigma}{\text{mean}}$$

$CV_i$ uses inter-arrival times, $CV_p$ uses service times. $CV = 1$ means fully random (exponential).

## Utilisation

$$\rho = \frac{R_i}{c \times R_p}$$

## Waiting time (Kingman / VUT)

$$W_q = \underbrace{\left(\frac{CV_i^2 + CV_p^2}{2}\right)}_{\text{Variability}} \times \underbrace{\left(\frac{\rho^{\sqrt{2(c+1)}-1}}{c(1-\rho)}\right)}_{\text{Utilisation}} \times \underbrace{T_p}_{\text{Time}}$$

Read it as **V × U × T**.
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 7, 'Distribution & Economic Value', '
## Where this session goes

Two topics that both answer the question "how does value actually reach the customer, and who captures it along the way?" — first the channel, then the price.

## Distribution is the expensive P

Place is often the **most expensive of the 4 Ps**, and firms frequently do not realise it because the cost is buried in margin given away rather than money spent.

**Indirect channel**: Manufacturer → Retailer → Consumer.
**Direct / vertically integrated**: Manufacturer (owning retail) → Consumer.

The trade-offs: price to the consumer (double marginalisation), retail service quality (moral hazard), profits, control over the 4 Ps, technology and skill leakage, and who owns the customer relationship.

Why use retailers at all: geographic coverage, infrastructure, customer access and information, in-store and after-sales service, and retailer competency you would otherwise have to build from nothing.

## Double marginalisation, and three fixes

Here is the problem that makes channels interesting. The manufacturer marks up over its cost, then the retailer marks up again over that. The final price ends up **higher than the price a single integrated firm would set** — and both parties earn less than they would have.

That is worth pausing on: it is not a fight over the split. Both sides lose. The structure itself destroys value, because each party sets its margin without accounting for the volume the other loses.

Three fixes:

1. **Price ceiling / maximum suggested retail price (MSRP)**
2. **Two-part tariff** — a fixed upfront fee plus a per-unit price set at the manufacturer''s marginal cost
3. **Co-provision of retail service, or revenue sharing**

> Trap: The two-part tariff works because setting the per-unit price at marginal cost removes the retailer''s incentive to mark up — the retailer now behaves like an integrated firm. The manufacturer takes its profit through the fixed fee instead. Get the per-unit price wrong and you have reintroduced the whole problem while adding a fee.

## Horizontal channel conflict

- Retailers competing with each other → **exclusive territories**
- A retailer pushing a rival''s product → **exclusive dealing**
- Showrooming and webrooming → align incentives so you do not fight the behaviour

## Economic value to the customer

Now pricing, and the single most valuable question in it: **what would this customer do if we did not exist, and what would that cost them?**

Cost-plus pricing asks what the product cost you. The customer does not care. EVC builds the price from their side of the table:

$$\text{EVC} = \text{Reference value} + \text{Net differential value}$$

- **Reference value** — what the next-best alternative costs the customer
- **Net differential value** — the extra benefits you provide, minus the extra costs you impose

> Prof: Competitors are not always obvious. Soap can compete with entertainment for the same rupee.

Identify the wrong reference and every number after it is anchored to the wrong thing.

### Worked example: the reusable diaper

A washable, reusable diaper that lasts a month. Variable cost **₹400**, against ₹3–4 for a disposable.

| Component | Working | Value |
|---|---|---|
| Reference value | $30 \times 4 \times 15$ | **₹1,800/month** |
| Benefit: no anti-rash cream needed | | +₹500 |
| Cost: extra washing | | −₹100 |
| Net differential value | | **+₹400** |
| **Total EVC** | 1,800 + 400 | **₹2,200/month** |

Note what the reference value is: money the parent is *already spending* without thinking of it as a price. That is why it anchors so well.

**EVC is the price ceiling. Variable cost (₹400) is the floor.** The viable range is ₹400 to ₹2,200, and a common starting point is the midpoint, adjusted for competitive pressure.

> Trap: EVC is the **maximum defensible price**, not the recommended price. Charging the full ₹2,200 leaves the customer exactly as well off as before — no reason to switch, and every reason to resent it if they do. You have to share the value you created.

### Why EVC works better in B2B

In B2B you can show the customer the calculation directly, and they have a procurement team that thinks in those terms. In B2C, consumers do not internalise the full value, so the **perceived** EVC sits below the actual one — and perceived value is what sets your real ceiling.

> Trap: If you cannot communicate the value, you cannot charge for it. For genuinely new products with no clear reference, market research — focus groups, small-market pilots, conjoint — is essential. Firms that rely on internal estimates routinely misjudge willingness to pay.
', null, '
## EVC

$$\text{EVC} = \text{Reference value} + \text{Net differential value}$$

$$\text{Net differential value} = \text{extra benefits} - \text{extra costs}$$

- **Reference value** = cost of the customer''s next-best alternative
- **EVC** = price **ceiling**; **variable cost** = price floor
- Common start: midpoint of floor and ceiling, then adjust

> Trap: EVC is the maximum defensible price, not the recommendation. Share the value or nobody switches.

## Channel

- **Double marginalisation** — two successive markups push the final price above the integrated optimum
- Fixes: **price ceiling / MSRP**, **two-part tariff** (fixed fee + per-unit at marginal cost), **revenue sharing**
- **Exclusive territories** solve retailer-vs-retailer conflict
- **Exclusive dealing** stops a retailer favouring a rival
', '2026-08-10T10:05:39.501564+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 9, 'Marketing Communications', '
## Where this session goes

Everything so far has been about deciding what to offer and what to charge. This last session is about telling people — and about the fact that most advertising measurement is less trustworthy than it looks.

## Four roles of advertising

Advertising is not one activity. Knowing which role you are playing determines what "good" looks like.

- **Informative** — tell people the product exists and what it does
- **Persuasive** — change preference
- **Money-burning** — the spend **itself** is the signal. Visible expense says deep pockets, long-term commitment and confidence in quality; it also intimidates competitors and suppliers.
- **Reminder (pulsing)** — refresh memory for a brand everyone already knows, like Coca-Cola

The third one is the least intuitive and the most interesting: the message can be almost irrelevant, because what carries information is that you could afford to send it at all.

**Ad response curve**: no return below a critical spend, then real response, then flat. Spending below the threshold is worse than not spending — you pay without ever crossing into the range where anything happens.

> Worked example: **Counter-signalling.** Established brands reduce logo prominence — Starbucks and Lululemon both did it. It works because only a brand everyone already recognises can afford to stop shouting. Under Armour tried it and failed, because it had not yet earned the recognition that makes restraint legible.

## Golden rule of advertising

$$\frac{A}{pQ} = \left(\frac{p - c}{p}\right) \times \varepsilon_{DA}$$

Ad spend as a share of revenue equals percent margin times the elasticity of demand with respect to advertising.

Both terms must be present. Advertise more when margin is high **and** demand is genuinely ad-sensitive — a high-margin product nobody''s purchase is influenced by advertising does not justify the spend.

## The 7 Ms

Market → Mission → Message → Media → Money → Measurement, plus message design.

> Trap: **Mission drives media choice.** Mass media is efficient for awareness; targeted and personal channels are efficient for action. The hierarchy-of-effects lines cross around "interest" — before that mass media wins, after it personal selling and word of mouth do. Offline word of mouth is **41% more persuasive** than online.

## Message design

**Rational appeals** — demonstration, spokesperson, testimonials, comparative ads.
**Emotional appeals** — fear, humour, happiness, family.

> Trap: Avoid combative advertising unless you can actually kill the rival. A public fight usually benefits the **third player** who stayed out of it — the same dynamic as BMW and Audi handing the market to Japanese cars. Also avoid negative associations with your own product, even in a joke.

## India media context

Digital ad spend **exceeds** TV despite TV commanding more consumption time. India''s digital spend skews toward **display** over search, the reverse of the US pattern — worth knowing because it means Indian digital budgets are buying awareness where American ones are buying intent.

## Measurement and budgeting

**Parfitt-Collins** (also taught as Peckham/Collins) connects money to market share through three gates:

$$\%\text{Aware} \times \%\text{Try} \times \%\text{Repeat} = \%\text{Market share}$$

It **multiplies**, so missing any one gate collapses the share regardless of the other two.

> Worked example: You need a 6% break-even share, with trial at 30% and repeat at 40%.

$$\%\text{Aware} = \frac{0.06}{0.30 \times 0.40} = 50\%$$

Now you have a media brief rather than an argument. And if the required awareness comes out above 100%, the plan is impossible — which tells you the problem is trial or repeat, and those are product problems that no budget fixes.

**GRP = Reach × Frequency.** 20% reach × 3 exposures = 60 GRPs — but the same 60 could be 60% reach × 1, which is a completely different campaign.

Effectiveness testing: focus groups, physiological measures, eye tracking, fMRI, Starch scores for print (Noted / Associated / Read), aided and unaided recall, and cross-market GRP tests.

> Prof: **Cheap talk** — do not believe claims when incentives are misaligned. Demand proof or a contract. The Peanuts example: Lucy always pulls the football away, whatever she promised.

## Air France: sponsored search

Standard digital KPIs are CPC, CTR and TCR. To those add **ROA**, average revenue per booking, and probability of booking.

> Trap: The 1000% ROA figures in the case reflect **attribution error**, not real returns. A customer who was always going to book searches for the airline, clicks the paid link above the organic one, and books — and the campaign claims a booking it did not cause. Spotting that is the point of the question.

The method: segment publishers by **probability of booking × CPC**. Then diagnose — a low CTR is an **ad** problem, a low TCR is a **website** problem. That split is the most reusable idea here, because it tells you which team owns the fix.

Kayak is the odd one out: it charged a flat listing fee rather than bid-based CPC, so comparing its return to auction-based publishers compares two different things.

Because digital campaigns give near-real-time data and can be halted instantly, **testing recommendations is low-risk** — which changes what a good recommendation looks like. Not "here is the answer," but "here is the test, here is what we learn, here is when we stop."

> Prof: The remaining Air France slides were deferred and **will not appear on the final exam**.
', null, '
## Golden rule of advertising

$$\frac{A}{pQ} = \left(\frac{p - c}{p}\right) \times \varepsilon_{DA}$$

Ad spend as a share of revenue = percent margin × advertising elasticity.

## Parfitt-Collins

$$\%\text{Aware} \times \%\text{Try} \times \%\text{Repeat} = \%\text{Market share}$$

Rearranged:

$$\%\text{Aware} = \frac{\text{target share}}{\%\text{Try} \times \%\text{Repeat}}$$

## GRP

$$\text{GRP} = \text{Reach} \times \text{Frequency}$$

20% reach × 3 exposures = 60 GRPs.

## Digital KPIs

CPC · CTR · TCR · **ROA** · revenue per booking · probability of booking

Low **CTR** → fix the ad. Low **TCR** → fix the website.

> Trap: Implausibly high ROA usually means attribution error.

## Roles of advertising

Informative · Persuasive · Money-burning (signal) · Reminder (pulsing)
', '2026-08-10T10:05:39.501564+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 6, 'Priority Queuing & the Start of Lean', '
## Where this session goes

Last session ended on a hint: priority queuing moves waiting around. This session makes that precise, then turns to attacking variability at its source — and finishes with a simulation where every team lost money.

## Priority queuing: redistribution, not creation

Baseline: 13 nurses, 35 arrivals/hour, average wait **9.43 min**.

Now split arrivals into 20% emergency and 80% non-emergency, and give emergencies priority. **The overall average wait does not change.** Same arrivals, same capacity, same total waiting — it just moves.

That has to be true when you think about it. Priority is a sorting rule, and sorting cannot manufacture capacity. All it can do is take minutes from one group and give them to another.

How to compute each class:

**The priority class, as its own system.** From an emergency patient''s point of view the routine flow is invisible — nurses drop what they are doing. So model emergencies against the full server pool: arrival rate $0.20 \times 35 = 7$/hr against 13 servers. Utilisation about 18%, so the wait is effectively **0 minutes**.

**The rest, by weighted average:**

$$0.20 \times 0 + 0.80 \times W = 9.43 \quad\Rightarrow\quad W \approx 11.8 \text{ minutes}$$

So routine patients moved from 9.43 to 11.8 minutes to buy emergencies a wait of zero.

> Trap: Push the emergency share to 50% and both groups can end up worse off. The priority class is now big enough to congest itself, while the non-priority class waits behind far more people. Priority is only close to free when the priority class is **small**. A fast track covering half your customers is not a fast track.

## Reducing variability at the source

If variability causes queues, the most direct attack is on the variability itself.

$CV = \dfrac{\sigma}{\text{mean}}$. The default assumption when you have no data is $CV_i = CV_p = 1$ (exponential) — the pessimistic case, and mathematically convenient.

| Reduce | How | Real example |
|---|---|---|
| **CVp** (service) | SOPs, standardisation | Amazon assigning drivers to fixed buildings so route familiarity tightens service times |
| **CVi** (arrivals) | Appointments, demand shaping | Appointments drive CVi toward 0, so any remaining queue comes from service variability alone |
| **CVp** (service) | Pre-sorting work | Call-centre IVR routing by call type before an agent picks up |

That middle row is the powerful one. An appointment system does not add capacity — it removes the randomness in arrivals, and gets much of the benefit for free.

## The behavioural side

Eleven minutes is not good or bad on its own. Perceived waiting is a different quantity from actual waiting, and it is cheaper to change.

- **Anxiety** — a hospital wait feels far longer than the same wait for a table
- **Not knowing how long** — telling people the wait shortens the felt wait
- **Unexplained delay** — airlines state a reason on purpose
- **Perceived unfairness** — priority queues feel unfair, which is why firms physically separate them
- **Unoccupied time** — wifi, hold music and magazines all shrink felt wait
- **Pre-service waits feel longer than in-service waits** — slow order-taking kills a restaurant, slow food does not. A doctor''s waiting room is a signal that service has begun.

## Lean simulation

A painting workshop game: coloured toys through several stations. Round one, **every team lost money.**

The cause was capacity mismatch. The grey station needed shape changes and more colours, so it was the bottleneck. Faster upstream stations kept producing anyway, and work-in-progress piled up in front of grey — generating cost with no revenue. Everything the earlier sessions predicted, felt rather than derived.

Five improvements were available: Kanban, auto-inspect, reduced tool changeover, workshop layout, and batch size reduction.

- **Kanban (pull)** — the downstream station must request before upstream sends. Production happens at the rate needed, not the rate possible.
- **Batch size 4 → 1** — less average WIP, faster flow, less stranded inventory at the end.
- **Reduced tool changeover** — aimed straight at the grey bottleneck.
- **Layout** — inter-station transfer from 4 seconds to 1.

> Trap: The winning teams did not pick the single best improvement. They paired Kanban with smaller batches. The improvements are **multiplicative** — a pull signal with a batch of 4 still moves work in lumps of 4, so half the benefit of the pull system never arrives.
', null, '
## Priority queuing

Overall average wait is **unchanged** by adding priority classes.

**Priority class** — treat as its own system:

$$\rho_p = \frac{\text{share}_p \times R_i}{c \times R_p}$$

**Non-priority class** — solve the weighted average:

$$(\text{share}_p \times W_p) + (\text{share}_{np} \times W_{np}) = W_{\text{overall}}$$

## Variability

$$CV = \frac{\sigma}{\text{mean}}$$

Default when unknown: $CV_i = CV_p = 1$. Appointments drive $CV_i \to 0$; SOPs lower $CV_p$.

## Lean levers

Pull (Kanban) · small batches · quality at each station · cross-trained resources · cellular layout

> Trap: Improvements combine **multiplicatively** — a pull signal with a large batch still moves work in lumps.
', '2026-08-11T09:15:48.041053+00:00');
insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('MKTG', 6, 'Brand Management & CLV', '
## Where this session goes

Two halves that look unrelated and are not. The first is how to manage brands as assets. The second is how to value a customer as an asset. Both are about what you own that does not appear on a balance sheet.

## How brands are managed

Through the 4 Ps — and **consistency among them is the key**. All four should reinforce the same brand image. A premium price with discount distribution does not read as a bargain; it reads as confusion.

## House of brands vs branded house

| | Independent brands (house of brands) | Brand extensions (branded house) |
|---|---|---|
| **Pros** | More positioning opportunities; makes acquisitions easier; failures are less risky for company image | Efficiency of communication; instant brand image transfer; deters competition |
| **Cons** | More expensive and complicated to manage; lose the benefit of a big brand | Risk of dilution or ambiguity; bad news affects all products; less management autonomy |

The trade is essentially insurance versus leverage. A house of brands contains failures and pays for the containment. A branded house transfers strength instantly and transfers weakness just as fast.

## Two directions to extend

- **Vertical brand extension** — greater benefits at a higher price (upscale), or fewer at a lower price (downscale). Moves along the price-benefit line.
- **Horizontal brand extension** — often a different category at a similar price.

Downscale vertical extensions are the dangerous ones: they reach more customers and quietly redefine what the brand means.

## Brand repositioning

Changing what the brand means. Amazon, Starbucks and Spotify have all done it. Three reasons to: the target market changed, competitors acted, or the context changed.

## Co-branding

Brand images of partners spill onto each other. The benefit is image transfer; the risk is brand confusion.

> Worked example: **(RED) in 2007** is the standing example of co-branding gone wrong — Converse, Apple, Gap, Amex, Motorola and Armani Exchange all at once. With that many partners the association stopped meaning anything in particular, which is the failure mode: not damage, dilution.

## Luxury branding

Luxury brands signal status on a spectrum from **loud** to **subtle**. Logo design and size do the signalling, the 4 Ps must line up, and the brand story matters. Consumer segments nest by increasing wealth — and the wealthier the segment, the more subtle the signal tends to become, because the point of a signal is to be legible to the people who matter and invisible to those who do not.

## Customer lifetime value

Now the second asset. A mobile operator spends $400 to acquire a customer who pays $250 a year in margin. Good deal? Most people answer instantly and most answer wrong, because it depends on three things nobody mentioned.

Build it in three steps.

**Step 1 — no churn, no discounting.** AC $400, contribution $250/year, five years.
CLV net = $1,250 − $400 = **$850**

**Step 2 — add churn.** Retention 80%, so each year''s expected contribution is $250 \times 0.8^t$ dollars.
$200 + $160 + $128 + $102 + $82 − $400 = **$272**

**Step 3 — add discounting.** Discount rate 10%, so divide each expected contribution by $1.1^t$.
$182 + $132 + $96 + $70 + $51 − $400 = **$131**

> Trap: Notice how fast the number falls — $850 to $272 to $131 on the same customer. Almost all of that is churn, not discounting. If you forget the retention factor you will overstate CLV by roughly 3×, which is enough to justify an acquisition strategy that destroys value.

### The infinite-horizon formula

$$\text{CLV}_{\text{existing}} = m\left(\frac{r}{1 + d - r}\right) \qquad \text{CLV}_{\text{new}} = m\left(\frac{r}{1 + d - r}\right) - AC + m_0$$

> Worked example: $m = 250$, $AC = 400$, $r = 80\%$, $d = 10\%$, $m_0 = 0$.

$$\text{CLV} = 250\left(\frac{0.8}{0.3}\right) - 400 = 667 - 400 = 267$$

Look at the denominator, $1 + d - r$: retention sits right beside the discount rate and moves the answer far more, because it compounds against every future year at once. That is why "reduce churn" outranks almost everything else in a mature subscription business.

### What the simple formula hides

- Contributions may rise over time — customers spend more, or you get cost efficiencies
- Retention rates change — up with lock-in, down with dissatisfaction
- **Customer heterogeneity** — a blended CLV across customers with different $r$ and $m$ is not the CLV of anybody

### What CLV is for

Deciding how and when to acquire a customer, retain one, **fire** one, or acquire an entire customer base or company. That third option is the one people forget: if a segment''s CLV is negative, serving it better is not the answer.

It shows up in streaming (where CLV tracks market cap), financial services, mobile carriers, Medtronic insulin pumps, HP printers and toner, Gillette and Swiffer — every razor-and-blade model is a CLV bet.
', null, '
## CLV, built up

**No churn, no discount:** $\ \text{CLV} = (m \times T) - AC$

**With churn:** each year''s expected contribution is $m \cdot r^t$

**With churn and discounting:**

$$\text{CLV} = \sum_{t=1}^{T} \frac{m \cdot r^t}{(1+d)^t} - AC$$

## Infinite horizon (constant $m$, $r$, $d$)

$$\text{CLV}_{\text{existing}} = m\left(\frac{r}{1 + d - r}\right)$$

$$\text{CLV}_{\text{not yet acquired}} = m\left(\frac{r}{1 + d - r}\right) - AC + m_0$$

$m$ = margin · $r$ = retention rate · $d$ = discount rate · $AC$ = acquisition cost · $m_0$ = margin at time 0

> Trap: Churn matters far more than discounting. Forgetting $r$ overstates CLV roughly threefold.

## Brand architecture

- **House of brands** — more positioning room, failures contained, costly to run
- **Branded house** — communication efficiency, instant transfer, dilution risk
- **Vertical extension** — more/fewer benefits at a higher/lower price
- **Horizontal extension** — different category, similar price
', '2026-08-10T10:05:39.501564+00:00');

-- learn_course_content: 0 rows
-- (none in the source snapshot)

-- learn_materials: 0 rows
-- (none in the source snapshot)

-- learn_attempts: 48 rows
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('38cd4b32-3ffe-45f2-bd5a-59acc624c32a', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c4', true, '2026-08-09T17:36:27.570793+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('d6b61e6a-6df5-4909-9d95-4d246ff337ee', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c6', false, '2026-08-09T17:36:29.319607+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('1dd0034d-4383-4f27-b2f8-a1676bb43b63', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c6', false, '2026-08-09T17:59:28.105978+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('9d9c9b0d-ba26-450e-8f9f-f246002389ab', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f8', true, '2026-08-09T18:18:16.482266+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('83d431c0-71a1-46e4-9a16-e4f5cf872c72', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c1', true, '2026-08-09T18:18:33.509408+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('94120689-0a0b-428e-8f3f-a8218c8e5612', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c6', true, '2026-08-09T18:18:50.075671+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('4e6e9c69-157c-4e1b-82d3-398529274c5b', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c2', true, '2026-08-09T18:19:06.798527+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('13b63695-062e-442c-9913-f64a6e79520d', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f7', true, '2026-08-09T18:19:19.72214+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('813cc3a2-bb0f-4ffe-ac28-f4224d4f741b', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f1', true, '2026-08-09T18:19:36.555535+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('b5177e63-a418-4902-a476-038ef3521074', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c6', true, '2026-08-09T18:19:53.517168+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('4981f3ff-8959-42cc-b7ab-c90c194dd490', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f5', false, '2026-08-09T18:19:59.422721+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('f17eaab9-04bd-4a7b-93d5-c7172caedb39', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f5', false, '2026-08-09T18:20:03.427663+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('75358375-2598-4593-91d5-37a3c3418b31', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f5', true, '2026-08-09T18:39:06.839578+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('8220e565-1b68-4e3b-a178-539bc1cfd39b', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f6', true, '2026-08-09T18:43:44.819741+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('229e9272-a3d1-4abd-aee7-e1253085bd9a', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f4', true, '2026-08-09T18:44:07.071878+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('74c364a0-6e2a-4b0b-9b67-08bcd7bc0528', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c7', true, '2026-08-09T18:44:46.160762+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('8fe178c7-bb10-4d6e-95c0-2ce06dec6e79', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c7', true, '2026-08-09T18:44:46.1673+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('437ac053-8a1a-47ac-94f6-4a9c238f84b0', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c6', false, '2026-08-09T18:44:48.637354+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('ff8365f0-81b2-4a89-bb4a-98e12544a671', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f2', false, '2026-08-09T18:44:50.955876+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('f9f95665-9b3b-4352-80be-4276122c599f', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f3', false, '2026-08-09T18:44:53.376141+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('53ebe0a3-14e1-4e22-ac33-7c43b0e811bf', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f5', false, '2026-08-09T18:44:56.238032+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('7b687316-eacb-4973-8c8d-224d32f8b3a5', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c6', true, '2026-08-09T19:09:37.075557+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('c388bb74-f50b-4885-a640-dad2d42846c2', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f2', false, '2026-08-09T19:09:40.20484+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('4ab3a35b-05be-4a2e-8211-9fa9ae9b7137', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c5', false, '2026-08-09T19:09:42.66855+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('4ce0d11b-f862-4f7e-b07b-8a400d368cf7', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f5', false, '2026-08-09T19:09:44.667407+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('ab63cd4b-037a-402a-a1d6-2372bc98a7d9', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c3', false, '2026-08-09T19:09:46.249296+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('612023d5-1d04-40c5-9519-dadb7197d130', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f3', false, '2026-08-09T19:09:49.108534+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('daf7ab1f-8f4b-46c9-9c36-4ceac3c5bd63', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c2', false, '2026-08-09T19:09:51.541319+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('ac4219cc-0bf9-4ee3-b547-15e0eab2714c', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c7', false, '2026-08-09T19:09:53.853117+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('312d2da3-c5e9-4dc5-bbdd-83ddfc293a70', 'b85f7426-486b-4726-9884-05598dc76371', 'c4', true, '2026-08-09T19:16:31.113909+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('f15867a8-d286-4e6f-a26f-68f9119b92a7', 'b85f7426-486b-4726-9884-05598dc76371', 'f2', false, '2026-08-09T19:21:37.74921+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('bc6d311d-0e11-41a1-8661-c667447478e4', 'b85f7426-486b-4726-9884-05598dc76371', 'c5', true, '2026-08-09T19:21:41.540877+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('430e722e-1e84-4e72-b56f-40af7e4748db', 'b85f7426-486b-4726-9884-05598dc76371', 'c2', true, '2026-08-09T19:21:44.942371+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('c664d65f-06d1-4010-bac9-dcd6a6c4461a', 'b85f7426-486b-4726-9884-05598dc76371', 'f7', false, '2026-08-09T19:21:48.710944+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('43dff801-51c1-4ffd-8144-101cfab67e57', 'b85f7426-486b-4726-9884-05598dc76371', 'f1', true, '2026-08-09T19:21:51.647803+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('26800955-8be1-4aed-89eb-f7a470c6583f', 'b85f7426-486b-4726-9884-05598dc76371', 'c3', true, '2026-08-09T19:21:54.790896+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('f1bc71ca-ef6e-4d3b-ab77-ab126a6b81b9', 'b85f7426-486b-4726-9884-05598dc76371', 'f4', false, '2026-08-09T19:21:57.619153+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('b7482ef9-2a69-4a3a-a3c3-b9439883078d', 'b85f7426-486b-4726-9884-05598dc76371', 'c7', true, '2026-08-09T19:22:01.340487+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('3542d519-3636-4d39-a80e-09c6a24595bf', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c2', true, '2026-08-10T04:01:04.884928+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('afde421f-f270-4dfd-a907-05c5272f9cdd', '33664123-77c1-413b-9d3d-618efc1e34c2', 'f5', true, '2026-08-10T09:52:04.527961+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('7412b724-19f4-448f-8301-6a6d15596a61', '33664123-77c1-413b-9d3d-618efc1e34c2', 'c7', true, '2026-08-10T09:52:18.710001+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('729a87bb-b868-4bff-9e1b-535dfecf0be8', '33664123-77c1-413b-9d3d-618efc1e34c2', 'c5', true, '2026-08-10T09:52:34.802631+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('4afdca22-82db-4dfa-97e8-0597c62b5546', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f6', false, '2026-08-12T11:39:37.13192+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('cda5f127-db8a-4744-a387-10f0749acc8f', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'opm-f2', false, '2026-08-12T11:41:36.854396+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('1a6d92e0-f7c3-4f8e-88b5-0be075dc9b90', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'opm-f5', false, '2026-08-12T11:42:45.702801+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('109625cb-89a5-4368-a0bd-c3cb944fd654', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'opm-f5', true, '2026-08-12T11:47:52.056909+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('85101897-568c-40b4-aac7-15c47880db72', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'f3', true, '2026-08-12T12:54:00.267715+00:00');
insert into public.learn_attempts (id, user_id, question_id, correct, created_at) values ('ea71b24d-f78f-4d8c-ba1d-d826bcb55b1b', 'db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'c2', true, '2026-08-12T12:54:53.531338+00:00');

-- learn_topic_mastery: 28 rows
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'break_even', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'break_even', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'case_unilever_brazil', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'clv', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'clv', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'evc', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'grp_advertising', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'grp_advertising', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('33664123-77c1-413b-9d3d-618efc1e34c2', 'MKTG', 'parfitt_collins', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'parfitt_collins', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'pricing_elasticity', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'pricing_elasticity', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('33664123-77c1-413b-9d3d-618efc1e34c2', 'MKTG', 'case_air_france', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'case_air_france', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'case_air_france', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'case_atlantic_computer', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'case_atlantic_computer', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'case_bmw_films', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'case_kookaburra', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('33664123-77c1-413b-9d3d-618efc1e34c2', 'MKTG', 'case_uber_ml', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'case_uber_ml', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'case_uber_ml', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('b85f7426-486b-4726-9884-05598dc76371', 'MKTG', 'case_united_breaks_guitars', 2, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'case_united_breaks_guitars', 1, 0, 0, 0, null);
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'becr_cannibalization', 1, 0, 0, 1, '2026-08-12T11:39:36.984+00:00');
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'OPMG', 'littles_law', 1, 1, 1, 3, '2026-08-12T11:47:51.834+00:00');
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'margin_markup', 1, 1, 1, 1, '2026-08-12T12:54:00.012+00:00');
insert into public.learn_topic_mastery (user_id, course_code, topic, level, consecutive_correct, total_correct, total_attempts, last_seen_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 'MKTG', 'case_bmw_films', 1, 1, 1, 1, '2026-08-12T12:54:53.345+00:00');

commit;
