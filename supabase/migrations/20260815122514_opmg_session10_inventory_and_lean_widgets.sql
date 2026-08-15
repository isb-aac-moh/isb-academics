-- OPMG session 10 (Inventory Management: EOQ, Safety Stock & Risk Pooling) --
-- new material, this session had no prior content anywhere. Also embeds two more
-- interactive widgets (kanban-loop, plus reusing the existing littles-law widget) into
-- the session 6/7 lean concept, closing the gap the cohort's field manual highlighted.
-- Source: S10 slide deck + the raw Aug in-class transcript + flow summary (session's
-- last class of the term). GENERATED — see gen_opmg_s10.py in the authoring session.

begin;

update public.learn_courses set total_sessions = 10 where course_code = 'OPMG';

insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'eoq_cycle_inventory', 'Economic Order Quantity: Why Amazon Holds Less Inventory', 'Buy a pair of shoes from an Adidas showroom, or buy the same shoes on Amazon. Assume, for a moment, that the price is the same either way. Which one do you think costs the seller more to fulfil?

Amazon is doing far more: picking, packing, last-mile delivery, free returns, warehousing across a huge catalogue. Adidas just has to have the shoe on a shelf when you walk in. By any intuition, Amazon should be the more expensive operation to run — and yet it can price the same or lower.

## Where the answer is not

It isn''t warehouse efficiency, and it isn''t cost of capital — big firms borrow at similar rates, so the opportunity cost of tying up money in inventory (the $r$ below) is roughly the same for both. The answer is in how much inventory each firm has to hold to serve the same demand, which is exactly what this concept works out.

## The three costs of running inventory

For a batch (order quantity) $Q$, three costs happen per unit time:

- **Ordering cost** — $SR/Q$: a fixed cost $S$ every time you place an order, happening $R/Q$ times per unit time.
- **Holding cost** — $HQ/2$: the average amount of inventory sitting around is $Q/2$ (it ramps down from $Q$ to 0 between orders), each unit costing $H$ to hold per unit time.
- **Variable cost** — $CR$: the per-unit purchase cost times demand.

> Trap: The variable cost $CR$ does not depend on $Q$ at all. How much you order, and how often, has nothing to do with how expensive the goods themselves are — only an indirect effect through $H$, since $H = h + rC$ (physical holding cost plus the opportunity cost of capital tied up in each unit).

## The golden rule

Minimise ordering cost plus holding cost and you get a clean result: at the optimum, **the two are equal** — $SR/Q^* = HQ^*/2$.

> Prof: A useful diagnostic falls straight out of this. If your fixed cost per unit time and your holding cost per unit time are roughly the same, you are ordering at close to the right frequency. If one badly outweighs the other, you almost certainly aren''t — and you don''t need the formula to know it, just the ratio.

Solving that equality for $Q$ gives the **Economic Order Quantity**:

$$Q_{EOQ} = \sqrt{\frac{2RS}{H}} \qquad \text{Ordering frequency} = \frac{R}{Q}$$

## Worked example: Kristen''s Cookie Co.

Weekly demand 100 dozen, raw material $10/dozen, ordering cost $25, shipping $25/order (so $S = 50$), opportunity cost of capital 20%/year, no separate physical holding cost mentioned (so $H = rC = 0.20 \times 10 = \$2$/dozen/year).

Annualise the demand first — $R = 100 \times 52 = 5{,}200$ dozen/year:

$$Q_{EOQ} = \sqrt{\frac{2 \times 5{,}200 \times 50}{2}} = \sqrt{260{,}000} \approx \mathbf{510 \text{ dozen}}$$

Order about every $52 / (5{,}200/510) \approx \mathbf{5.1 \text{ weeks}}$.

:::viz eoq demand=5200 orderCost=50 holdingCost=2 unit="dozen"

## Managing cycle inventory: the summary that matters

- Average inventory for a batch size $Q$ is $Q/2$ — bigger batches mean more inventory sitting around, full stop.
- The relationship between $Q$ and $(R, S)$ is a **square root**, not linear: demand up by 4× only justifies batch size up by 2× (order twice as often, not four times as rarely). To cut your batch size in half, you need to cut setup cost by a factor of **4**, not 2.

That square-root relationship is the whole answer to the Amazon question.

## Back to Amazon vs. Adidas

Assume both face the same total demand for shoes, $R = 10{,}000$ units a year, and roughly the same $H$ (same cost of capital, similar physical storage cost per unit). Amazon serves it from one aggregated warehouse. Adidas splits the same demand across 100 stores, each facing $R_{\text{store}} = 100$ units/year, each running its own EOQ policy.

$$Q_{\text{Amazon}} = \sqrt{\frac{2 \times 10{,}000 \times S}{H}} \qquad Q_{\text{Adidas, per store}} = \sqrt{\frac{2 \times 100 \times S}{H}} = \frac{Q_{\text{Amazon}}}{10}$$

One-tenth the order size sounds like an advantage for Adidas — until you count all 100 stores. Total Adidas inventory is $100 \times Q_{\text{Adidas, per store}} = 100 \times Q_{\text{Amazon}}/10 = 10 \times Q_{\text{Amazon}}$.

**Splitting the same demand across 100 locations costs 10× the inventory** — not 100×, because of the square root, but still an order of magnitude. That difference in holding cost is what funds Amazon''s free delivery and free returns; it isn''t operational magic, it''s aggregation.

> Prof: A student pushed on whether this is really about $S$ (Adidas orders being more expensive per batch, since each store transaction has its own overhead) rather than aggregation. It can be both in practice, but even holding $S$ and $H$ identical between the two, the aggregation effect alone produces the 10× gap — that''s the point worth taking away, not the exact number.

The same square-root logic shows up everywhere firms pool something to save on inventory: Toyota and Maruti building one engine platform under several car models, Asian Paints mixing any shade from one base-tone paint instead of stocking every finished colour. The safety-stock concept below runs the identical argument on the uncertainty side.

## Doesn''t this contradict lean?

A fair objection: lean says the ideal process has **zero** inventory, and EOQ says some inventory is actually optimal. Are they in tension?

> Prof: They''re not, once you look at what EOQ is actually a function of. The formula says $Q^* \propto \sqrt{S}$ — batch size shrinks as setup/ordering cost shrinks. A lean firm doesn''t override the EOQ math with a policy; it attacks $S$ directly (co-locating suppliers, cutting changeover time, simplifying the ordering process), and the *same* formula then hands back a smaller optimal batch on its own. Lean and EOQ are describing the same lever from two different angles, not fighting over it.', null) on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;

insert into public.learn_concepts (course_code, topic, title, note, resource_url) values ('OPMG', 'safety_stock_reorder_point', 'Safety Stock & the Reorder Point Under Uncertainty', 'If demand were perfectly predictable, inventory management would be one line: order enough to cover the lead time, and arrange for it to arrive exactly as the last unit sells. Reorder point $= R \times L$ — demand rate times lead time — and you''re done.

Demand is never that well-behaved. This concept is about what changes when it isn''t.

## Why the deterministic reorder point isn''t enough

Kristen''s Cookie Co. orders raw material with a 1.5-week lead time. Weekly demand averages 100 dozen, so the deterministic reorder point would be $100 \times 1.5 = 150$ dozen — order when 150 are left, and the next batch lands exactly as you run out.

But weekly demand isn''t a constant 100 — it has a standard deviation of 20. Reorder at exactly 150 and you will stock out **roughly half the time**, because half the time actual demand over that 1.5 weeks comes in above the average. Something has to give: either accept frequent stockouts, or hold extra inventory as a cushion.

## Characterising demand during the lead time

The demand faced during the lead time — call it $LTD$ — isn''t one week''s demand, it''s the **sum** of $L$ weeks of independent, identically distributed demand:

$$D_1 + D_2 + \cdots + D_L \sim N(RL,\ \sigma_R\sqrt{L})$$

> Trap: Variances add; standard deviations do not. Adding $L$ independent draws each with standard deviation $\sigma_R$ gives a sum with standard deviation $\sigma_R\sqrt{L}$, not $\sigma_R \times L$. This single square root is where almost every reorder-point mistake comes from.

## Safety stock and the reorder point

Pick a target **service level** $SL$ — the probability that lead-time demand does *not* exceed what you have on hand. Reading that probability off the $LTD$ distribution:

$$I_s = z_{SL} \times \sigma_R\sqrt{L} \qquad ROP = RL + I_s$$

$z_{SL}$ is the standard-normal value for your target service level (2.326 for 99%, from the standard normal table — not 2.33, not 2.23; look it up rather than recalling it from memory under exam pressure).

Drag the sliders below and watch the gap between the dashed line (mean lead-time demand) and the solid line (the actual reorder point) — that gap **is** the safety stock.

:::viz safety-stock meanDemand=100 sdDemand=20 leadTime=1.5 serviceLevel=99 unit="dozen" timeUnit="week"

## Worked example: Kristen''s Cookie Co., part 2

$R = 100$/week, $\sigma_R = 20$/week, $L = 1.5$ weeks, target $SL = 99\%$.

$$LTD \sim N(100 \times 1.5,\ 20\sqrt{1.5}) = N(150,\ 24.5)$$

$$I_s = 2.326 \times 24.5 \approx \mathbf{57 \text{ dozen}} \qquad ROP = 150 + 57 \approx \mathbf{207 \text{ dozen}}$$

Order not at 150, but at 207 — the extra 57 dozen is what buys the 99% protection.

## Risk pooling: the same square root, again

**Fun Colors** stocks 75 paint colours, each independently normal with mean 100 cans/week, $\sigma = 40$, lead time 2 weeks, target service level 98% ($z \approx 2.054$).

Stocked separately, each colour needs its own safety stock: $I_s = 2.054 \times 40\sqrt{2} \approx 116$ cans. Across 75 colours, that''s $75 \times 116 \approx 8{,}716$ cans of safety stock, total.

Now suppose Fun Colors can mix any colour to order from a single base-tone paint instead. Demand for the base tone is the **sum** of the 75 individual demands: mean $75 \times 100 = 7{,}500$/week, and — variances add, not standard deviations — $\sigma = 40\sqrt{75} \approx 346.4$/week.

$$I_{s,\text{pooled}} = 2.054 \times 346.4 \times \sqrt{2} \approx \mathbf{1{,}006 \text{ cans}}$$

Pooling into one base tone cuts total safety stock from **~8,716 to ~1,006** — a factor of $75/\sqrt{75} = \sqrt{75} \approx 8.7\times$. It is the identical square-root mechanism as Amazon vs. Adidas in the EOQ concept, just applied to uncertainty instead of ordering cost.

> Prof: This is why colocation of suppliers, geographic aggregation (Amazon''s single warehouse), and product-platform sharing (one engine under several car models, at Toyota and Maruti both) all reduce inventory the same way — each is a different flavour of pooling independent variability into one bigger, relatively-less-variable pool.

## Safety stock is not excess inventory

> Prof: During COVID, a lot of firms read "we hold too much inventory" and cut the buffer that was actually safety stock, not slack. It sits unused most of the time by design — that''s what a hedge against uncertainty looks like right up until the uncertainty happens.

This is the same lesson lean draws from Toyota''s chip stockpile ahead of the 2011 earthquake: a buffer sized against a real, quantified risk is not waste, even though on any given ordinary day it looks exactly like waste sitting on the shelf.

## What drives how much safety stock you need

$$I_s = z_{SL} \times \sigma_R \times \sqrt{L}$$

Three levers, and only three: your target service level, the demand variability (or forecast error) you''re protecting against, and the delivery lead time. Cut any of the three — tighten forecasts, negotiate shorter lead times, or accept a lower service level where the cost of a stockout is genuinely small — and safety stock falls with it.

Average inventory, all in, is cycle stock plus safety stock: $\dfrac{Q}{2} + I_s$.', null) on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;

insert into public.learn_session_content (course_code, session, title, summary, resource_url, formula_sheet, updated_at) values ('OPMG', 10, 'Inventory Management: EOQ, Safety Stock & Risk Pooling', '## So far, and where this session goes

- Operations should align with the firm''s strategic position, not run on generic "efficiency."
- Process metrics feed straight into financials: Inventory $= $ Flow time $\times$ Flow rate (Little''s Law), process flows, bottlenecks, critical paths, waiting times.
- Queuing reduces waiting time; quality control (control limits, SPC) keeps a process honest over time.

Everything so far managed inventory driven by the process itself. This session — the last of the course — asks two more questions: how much should you order at a time when ordering itself has a cost (**economies of scale**, the EOQ concept), and how much extra should you hold when demand won''t sit still (**safety stock**, under uncertainty).

## Learning objectives

- What service level is, and how to pick the right one when demand is unpredictable.
- What unpredictable variability actually does to inventory.
- How to use economies of scale in procurement to manage inventory.
- How to design inventory systems that hold up under uncertainty.

## Why the same shoes cost the seller differently to deliver

The session opens with a live comparison: buying shoes at an Adidas showroom versus on Amazon, assuming the price is the same either way. Amazon is doing far more — delivery, returns, wider selection — for the same money, which should mean higher cost, not lower.

The class worked through several wrong-but-reasonable guesses (warehouse efficiency, showroom rent, transport cost) before landing on the real answer: **it''s about how much inventory each model has to hold to serve the same demand.** The full argument — Adidas splitting demand across 100 stores costs roughly 10× the inventory of Amazon''s one aggregated warehouse, from the square-root relationship in the EOQ formula — is worked out with the numbers in the EOQ concept below.

## Economies of scale: the EOQ model

Read the concept note for the full derivation (three cost components, the golden rule that ordering cost equals holding cost at the optimum, and Kristen''s Cookie Co. worked to $Q^* \approx 510$ dozen, ordering every ~5.1 weeks) and try the interactive EOQ widget there.

> Trap: A natural objection came up in class — doesn''t holding *any* inventory contradict lean''s "ideal process has zero inventory"? It doesn''t, once you see that EOQ''s optimal batch size is itself a function of setup/ordering cost ($Q^* \propto \sqrt{S}$). A lean firm doesn''t override the formula, it shrinks $S$ (co-located suppliers, faster changeovers) and the same formula hands back a smaller batch on its own.

Two practice problems from the deck worth trying yourself, since the mechanics transfer directly: **Northern Airline**''s flight-attendant training batches (the "batch" is a training class size; $S$ is running one training cohort, $H$ is the cost of an idle trained attendant sitting in the pool) and a **coffee house**''s Colombian coffee order, which adds a three-week delivery lead time on top of the plain EOQ question — a preview of the next section.

## Managing uncertainty: safety stock and the reorder point

When demand is deterministic, the reorder point is just $R \times L$. When it isn''t — which is always — you need a cushion, and the size of that cushion has an exact formula: $I_s = z_{SL} \times \sigma_R\sqrt{L}$.

Read the concept note for the full Kristen''s Cookie Co. worked example (reorder at 207 dozen, not 150, to hit 99% service level) and the Fun Colors risk-pooling example, which shows the identical square-root aggregation benefit from the EOQ section showing up again — this time reducing safety stock instead of order quantity.

> Trap: Reaching for a remembered z-value under time pressure is exactly how this topic gets missed by a small but costly margin in class — one student proposed $z \approx 2.23$ for a 99% target; the correct value is 2.326. Look it up rather than recall it approximately.

## Drivers of effective inventory management

Both halves of this session — EOQ and safety stock — are aggregation arguments in disguise: pool demand (geography, like Amazon''s warehousing), pool products (one engine platform under several models, at Toyota and Maruti both), or shrink the lead time itself by working with suppliers who are physically closer. Different firms lean on different levers, and it is rarely all-or-nothing.

## Closing the loop

Safety stock is a hedge against uncertainty, not slack — the same point the lean concept makes about Toyota''s chip stockpile ahead of the 2011 earthquake, and the same mistake many firms made when they read "cut excess inventory" during COVID as license to cut their safety stock too.

Average inventory, across everything this course has covered, comes down to one line: $\dfrac{Q}{2} + I_s$ — cycle stock from how you order, plus safety stock from how uncertain the world is.', null, '## EOQ

$$Q_{EOQ} = \sqrt{\frac{2RS}{H}} \qquad H = h + rC \qquad \text{Ordering Freq} = \frac{R}{Q}$$

At the optimum: ordering cost $SR/Q^*$ = holding cost $HQ^*/2$.

Average inventory (cycle stock only) $= Q/2$. Square-root relationship: demand $\times 4 \Rightarrow$ batch $\times 2$; halving batch size needs setup cost $\div 4$.

## Safety stock & reorder point

$$LTD \sim N(RL,\ \sigma_R\sqrt{L}) \qquad I_s = z_{SL} \times \sigma_R\sqrt{L} \qquad ROP = RL + I_s$$

> Trap: standard deviations don''t add — $\sigma_R\sqrt{L}$, never $\sigma_R \times L$.

## Average inventory, overall

$$\text{Avg. inventory} = \frac{Q}{2} + I_s$$

## Aggregation / risk pooling

Splitting demand for $n$ identical, independent streams into $n$ separate pools costs $\sqrt{n}$ times the inventory (EOQ or safety stock) of serving the same total demand from one pooled stream.', now()) on conflict (course_code, session) do update set title = excluded.title, summary = excluded.summary, formula_sheet = excluded.formula_sheet, updated_at = excluded.updated_at;

-- embed the existing littles-law widget into the lean batch-size discussion, and a new
-- kanban-loop widget into the Kanban mechanism discussion (both in lean_fundamentals).
update public.learn_concepts set note = 'Most people meet lean as a list of Japanese words and a recommendation to reduce inventory. That framing is why most lean programmes fail.

Lean is not a toolkit. It is a philosophy with one idea at its centre, and every tool is downstream of it.

## The one idea

Waste — *muda* — is **the gap between your actual process and the ideal one**.

> Prof: The ideal process is one where demand arrives, output is produced instantly, flow time is zero and inventory is zero. It is unachievable. Every deviation from it is waste anyway.

Notice what that definition does. It refuses to let you call something acceptable just because it is normal, or unavoidable, or industry standard. A two-day inspection step is waste. It may be waste you cannot currently remove — but you do not get to stop calling it waste, because the moment you do, you stop looking for a way.

> Prof: Asked to define "lean" cold, a class typically answers "efficient" or "minimal resources." Both get pushed back on the same way — *who defines what is possible?* "Minimal resources" assumes you already know the floor. Lean has no floor. It only has a direction: keep closing the gap to an ideal you will never actually reach.

## What waste looks like in practice

- Excess inventory (work-in-progress piling up)
- Overproduction — making things before demand exists
- Waiting — customers, machines or workers
- Unnecessary motion or transport
- Rework, defects, quality failures
- Bureaucracy and inessential handling

> Prof: A student (Ganesh) asked why a defective unit counts as *waste* rather than just a quality problem. The answer collapses the two categories into one: **"You are not in the business of making defective units."** Every correction, every re-do, every quality failure is muda by the same definition as excess inventory — it is a gap between the ideal process (which produces the right thing the first time) and the actual one.

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

## The six tools, one at a time

### 1. Cut batch size

Picture a four-stage line, A → B → C → D, each stage taking one minute per unit. In steady state the line still finishes one batch every T minutes no matter the batch size — a station''s *rate* doesn''t care how work arrives. So capacity never moves.

:::viz littles-law rate=60 time=4 rateUnit="units/hr" timeUnit="min" unitName="units in the batch"

Flow time does. A single unit now has to wait for its **entire batch** to accumulate at every stage before it can move on, and by Little''s Law ($I = R 	imes T$) that extra waiting shows up as extra inventory sitting in the system. Quadruple the batch size and you roughly quadruple both flow time and WIP, for the same throughput.

> Trap: So why batch at all? Because changeovers cost something. If resetting a station between different jobs is slow or expensive, splitting into single units means paying that setup cost over and over. Batch size shrinks toward one only as fast as you can shrink setup time — which is exactly what **SMED** (Single-Minute Exchange of Die) targets: make changeovers so fast that small batches stop being expensive.

### 2. Pull, not push — and JIT

Push: material shows up, so the station produces — whether or not the next step actually needs it yet. Cut pieces pile up in front of sewing because cutting never checked.

Pull: a station only produces once the *next* station has actually used up what it had and asks for more. Nothing gets made until there is a real, immediate need for it.

**JIT** is what pull looks like end to end: have exactly what''s needed, how much is needed, when it''s needed, where it''s needed — a "hand-to-mouth" flow with nothing early, nothing extra, nothing sitting around "just in case." Every station treats whoever consumes its output next as its customer; the trigger always comes from downstream, never from an upstream forecast.

> Worked example: after COVID-era shortages, "JIT failed" became the popular verdict. It hadn''t — what failed was a misreading of it. Firms had eliminated **all** inventory, not just *excess* inventory, and those are different things. Toyota, after the 2011 earthquake, sorted its inputs by disruption risk: plastic resin substitutes easily, so no buffer; semiconductors take years to rebuild, so it held a calculated 2–6 months of chip stock. In the 2021 chip shortage, Toyota was the only major automaker largely unaffected. Everyone else had copied the headline and skipped the distinction.

### 3. Kanban: the mechanism, not just the word

Kanban is the physical rule that makes pull real: a card travels **backward** from a downstream station to an upstream one, and it is the only thing that authorises production.

> Trap: **No card, no production.** Station *i* may not make another unit until a card arrives saying station *i+1* has actually consumed one. That single rule is what stops WIP from silently piling up between stations — it isn''t a scheduling tool, it''s a permission slip.

:::viz kanban-loop cards=3


### 4. Jidoka: quality at the source

The cost of a defect is not fixed — it multiplies with every stage it travels through before someone catches it. Roughly: caught at its own station, minor; caught at the next station, a small delay; caught at end-of-line, rework and rescheduling; caught at final inspection, a delivery delay; caught by the end user, warranty cost and reputation damage.

The radical move is to **stop the line the instant a defect is found**, before the root cause is even known. It feels like it kills output. It is actually the cheap option, because the alternative is paying that multiplying cost on every unit that passes through before someone acts.

### 5. Flexible resources

A worker who can only do one task caps your capacity at whatever that one station allows. A cross-trained worker can flow to wherever the backlog actually is (the Kristen Cookie Co. idea) — with three payoffs: more capacity (nobody stands idle while a neighbouring station backs up), more learning (rotating through stations is what actually surfaces kaizen ideas, since you see how your work affects the next person''s), and better job satisfaction (the same 60-second task all day is numbing; variety keeps people engaged).

### 6. Functional → cellular layout

Group machines by what they *are* (all cutting machines together, all assembly together) and parts zig-zag across the whole factory, queueing at every shared department along the way. Group machines by what they *build* instead — every operation one product family needs, placed in sequence, next to each other — and parts flow straight through with no crisscrossing and no shared-resource queues.

The second version also ties back to Jidoka: with everything for one product line physically adjacent, a problem is much easier to spot the moment it happens, instead of thirty metres and two departments later.

## Why you should deliberately remove your safety net

This is the counterintuitive move that separates lean firms from firms that own lean binders.

Traditional manufacturers use inventory to *cover* problems: a missed due date, a scrapped batch, a supplier who ran late. The buffer absorbs it and nobody finds out. The problem never gets fixed because it never becomes visible.

Lean firms cut inventory **in order to make those failures surface**, then fix the root cause. Reducing the buffer is a diagnostic instrument, not just a cost saving. The same idea, drawn as a picture: think of inventory as water and problems as rocks on the riverbed. High water hides the rocks, which feels safe — until you realise you''re sailing over a reef. Lower the water on purpose and the rocks you were always going to hit become visible while you still have room to steer around them.

Service firms hide the same problems in **time buffers** — Swiggy padding a delivery estimate by five minutes. Tighten the target and the failures reappear, which is the point.

> Trap: Fix the root cause, not the symptom. Overproducing so you never miss a deadline is a symptom fix that also creates waste. Asking why repeatedly — "the machine was not maintained → quality issue → rework → missed deadline" — is the actual work. Kaizen runs on three moves together: increase problem visibility (cut the buffer on purpose), make targeted improvements (active worker involvement, dedicated time to experiment, suppliers included), and do root-cause analysis (the five-whys, then change, monitor, adjust).

## Where lean does not apply cleanly

Starbucks applied lean to cut flow times and got mixed results. The reason is instructive: it serves two customers at once.

For a grab-and-go customer, less flow time is straightforwardly value. For someone there for the atmosphere, **dwell time is the product** — reducing it is destroying what they came for.

Lean needs one clear ideal process. Starbucks has two, and no amount of tooling resolves that.' where course_code = 'OPMG' and topic = 'lean_fundamentals';

commit;
