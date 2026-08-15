-- Fix a KaTeX parse error found in live verification: the EOQ concept had a currency
-- sign inside single-$ inline math (\$2), which is only valid in display ($$...$$) math.
begin;

update public.learn_concepts set note = 'Buy a pair of shoes from an Adidas showroom, or buy the same shoes on Amazon. Assume, for a moment, that the price is the same either way. Which one do you think costs the seller more to fulfil?

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

Weekly demand 100 dozen, raw material $10/dozen, ordering cost $25, shipping $25/order (so $S = 50$), opportunity cost of capital 20%/year, no separate physical holding cost mentioned (so $H = rC = 0.20 \times 10 = 2$ dollars/dozen/year).

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

> Prof: They''re not, once you look at what EOQ is actually a function of. The formula says $Q^* \propto \sqrt{S}$ — batch size shrinks as setup/ordering cost shrinks. A lean firm doesn''t override the EOQ math with a policy; it attacks $S$ directly (co-locating suppliers, cutting changeover time, simplifying the ordering process), and the *same* formula then hands back a smaller optimal batch on its own. Lean and EOQ are describing the same lever from two different angles, not fighting over it.' where course_code = 'OPMG' and topic = 'eoq_cycle_inventory';

commit;
