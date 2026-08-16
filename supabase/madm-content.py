"""Source of truth for the MADM2 end-term content: sessions, concepts, scenarios and the
questions that come from the professor's own material.

    python3 supabase/madm-content.py > supabase/migrations/<timestamp>_madm_end_term_content.sql

The authored expansion that brings every topic to eight questions lives in
supabase/madm-practice-bank.py and emits a second migration. This file must be applied first —
the practice bank's questions reference concepts and scenarios created here.

Course facts that shaped the decisions below:

- The course code in this database is MADM2 ("Managerial Accounting in Decision Making (Flexi
  Core)", Term 3), not MADM. The outline PDF is headed MADM_273.
- Sessions 1-5 are Prof. Radhika Lunawat's half and the mid-term's scope. Sessions 6-10 are Prof.
  Sunil Dutta's half and the end-term's scope. Sessions 1-5 get titles here so the session list
  reads as deliberately empty rather than broken.
- The outline says both exams are multiple-choice only, closed book and closed notes. So unlike
  BANM2, every question here is playable: type 'formula' or 'case_fact', four choices, one right.
- The decks do not follow the outline's session-by-session topic list. The outline promises
  budgeting in session 8, variance in 9 and transfer pricing in 10; what was actually taught is
  ABC in 6, ABM + control + budgeting in 7, variance + Buckeye in 8, variance problems + transfer
  pricing in 9, and transfer pricing part 2 in 10. Sessions here follow the decks, because that is
  what the class saw and what the practice final examines.
- Chapter 12's ROI / residual income / EVA material never got its own deck, but it is in the
  assigned reading (Ch 12 pp. 500-506) and in four assigned practice problems (12.42, 12.43,
  12.54, 12.55). It sits under session 9, next to the decentralisation material it belongs to.

Topics are prefixed `madm_`. learn_topic_mastery is keyed on (user, course, topic) so a collision
across courses is impossible, but the admin topic-stats screens read better when a topic name
carries its course.
"""

import sys

from practice_lib import (
    check_inline_math,
    check_markdown,
    check_question,
    json_array,
    shuffle_choices,
    sql,
)

COURSE = "MADM2"
TOTAL_SESSIONS = 10

# ---------------------------------------------------------------------------
# Course level
# ---------------------------------------------------------------------------

ANNOUNCEMENTS = """End-term covers Sessions 6-10 only — Prof. Sunil Dutta's half. Sessions 1-5 were Prof. Radhika Lunawat's half and the mid-term's scope.
Final exam is 40% of the grade, the same weight as the mid-term.
Format from the course outline: multiple-choice questions only, closed book and closed notes. There are no written answers to prepare.
There will be no make-up exams, and the outline warns that frivolous revaluation requests are penalised.
The professor's own practice set for this end-term is 21 multiple-choice questions covering ABC, budgeting, variance analysis, transfer pricing and responsibility centres. Every one of them is in this bank, marked as coming from him."""

OUTLINE = """## What this covers

Managerial Accounting and Decision Making is taught in two halves by two professors. The end-term is Prof. Sunil Dutta's half — sessions 6 through 10, the part of the course the outline calls **Incentives and Control**. Sessions 1-5 are listed here for completeness but carry no content: they were the mid-term's scope.

The first half of the course asked what a decision costs. This half asks a harder question: what happens when the number you compute is also the number somebody is paid on. Every session in it is a variation on that.

- **Session 6** shows that a firm's own cost system can lie to it. Overhead allocated by production volume makes high-volume products look expensive and low-volume ones look cheap, and managers then drop the wrong product. Activity-based costing fixes the allocation by following causality instead of convenience.
- **Session 7** takes ABC out of the accounting department. The same logic ranks customers rather than products, and the session then turns to the structure that decides who is measured on what: decentralisation, responsibility centres, and the budget as the instrument that sets the target.
- **Session 8** asks why actual profit differed from the budget, and separates the part the sales team owns from the part the plant owns. The flexible budget is the device that makes that separation fair.
- **Session 9** finishes variance analysis with the professor's worked problems, then opens transfer pricing: what price one division should charge another, and why opportunity cost — not full cost — is the answer.
- **Session 10** takes transfer pricing into practice: which policy to set, what happens when a mandated formula gets it wrong, how negotiations turn into holdup, and how the whole apparatus becomes a tax question once divisions sit in different countries.

## How to use this

Open a session, read the walkthrough at the top, then work down the concepts. Each concept has a short note and its own question bank. Once a concept makes sense, hit **Practice this concept** — the bank is multiple-choice because the exam is, and the explanations show the arithmetic rather than just naming the answer.

The formula drawer inside practice carries that session's reference sheet, so you are applying the relationships rather than trying to remember them under time pressure.

## What the professor said matters

Four lines closed the last session, and they are a fair summary of the whole half:

1. There is no such thing as *the* cost of something.
2. Numbers make people do things.
3. Opportunity cost is real.
4. Never stop at the headline number."""

# ---------------------------------------------------------------------------
# Sessions. (title, summary, formula_sheet) — summary is the session walkthrough shown at the
# top of the session page, formula_sheet is the drawer available during practice.
# ---------------------------------------------------------------------------

MIDTERM = ("Prof. Lunawat's half of the course, and the mid-term's scope. Not covered by this "
           "end-term guide, which starts at Session 6.")

SESSIONS: dict = {
    1: ("Overview, Introduction and Opportunity Cost", MIDTERM, None),
    2: ("Cost-Volume-Profit (CVP) Analysis", MIDTERM, None),
    3: ("Short-term Decisions: Relevant Costs", MIDTERM, None),
    4: ("Short-term Decisions, continued", MIDTERM, None),
    5: ("Long-term Decisions and the Role of Cost Allocation", MIDTERM, None),
}

SESSIONS[6] = ("Cost Allocation and Activity-Based Costing", """## Where this session sits

This is the start of Prof. Dutta's half, and it changes the question being asked. The first five sessions worked out what a decision costs. From here the course asks what the firm's own cost system tells its managers, and what those managers then do about it.

He opened with the copying function, deliberately small: a machine at $4,000 over four years, an ink cartridge at $400 that lasts 40,000 pages, paper at a cent a page, wages of $10,000 a year, other overhead of $1,000, and 600,000 pages a year to produce. Two questions off the same facts.

- What does one more page cost? Ink and paper only: two cents.
- What does a page cost? Add the $12,000 of annual fixed cost spread over 600,000 pages — another two cents — for a full cost of four cents.

Both numbers are right. Which one is relevant depends entirely on the decision. A one-off order of 10,000 pages onto a machine that is already sitting there is worth taking at anything above two cents. An outside vendor offering to run the whole function for five years at three cents is a good deal, because over five years the capacity costs are avoidable too.

> Prof: There is no such thing as *the* cost of something. The right cost number depends on the decision you are making.

## The problem multiproduct firms have

For a single product, full cost is variable cost plus fixed cost divided by units, and there is nothing to argue about. The moment two products share a resource, someone has to decide how much of that shared cost belongs to each — and there is no invoice that says.

The example he ran all session is two products sharing $100,000 of overhead:

| | Product A | Product B |
|---|---|---|
| Price | $10 | $14 |
| Units sold | 15,000 | 5,000 |
| Direct cost per unit | $6 | $7 |
| Labour hours per unit | 0.5 | 0.6 |
| Orders placed | 15 | 50 |

Revenue is $220,000, direct costs are $125,000, overhead is $100,000, and the business is losing $5,000. Which product is doing the damage?

## What a traditional system answers

A traditional system assumes overhead moves with production volume, and picks one volume measure — here labour hours. Total labour hours are 7,500 for A and 3,000 for B, so 10,500 in all, and the rate is $100,000 / 10,500 = $9.52 per labour hour.

That loads $4.76 of overhead onto each unit of A and $5.71 onto each unit of B. A's unit cost becomes $10.76 against a $10 price — a loss of 76 cents a unit — while B shows a margin of $1.29. The verdict writes itself: drop A.

## Why that verdict is wrong

Look back at the order counts. B is 25% of the volume but places 50 of the 65 orders. Most of the overhead in this business is not driven by how many units come off the line; it is driven by how many separate times somebody has to schedule a run, process an order, and ship it.

Split the $100,000 the way it actually behaves — $30,000 that scales with labour hours, $65,000 that scales with orders, $5,000 that supports the two product lines — and the picture inverts:

- Unit-level rate: $30,000 / 10,500 hours = $2.86 per hour
- Batch-level rate: $65,000 / 65 orders = $1,000 per order
- Product-level: $5,000 split equally, so $2,500 each

Product A absorbs $21,429 + $15,000 + $2,500 = $38,929, which is $2.60 a unit. Product B absorbs $8,571 + $50,000 + $2,500 = $61,071, which is $12.21 a unit. A now earns $1.40 a unit and B loses $5.21.

> Trap: The traditional system was not slightly off. It reversed the ranking. B's fifty small orders consumed $50,000 of batch cost against A's fifteen large orders at $15,000, and a labour-hour rate cannot see that.

## The cost hierarchy

The fix generalises into four levels, and knowing which level a cost sits at is most of what the exam tests.

| Level | Varies with | Examples |
|---|---|---|
| Unit | Each unit made | Energy, machining, direct materials |
| Batch | Each production run or order | Machine setup, order processing, shipping |
| Product | Each product line kept alive | Design specs, product-specific tooling |
| Facility | Simply being in business | Rent, plant insurance, general administration |

Low-volume products consume batch- and product-level resources out of all proportion to their volume. That is the whole mechanism behind the cross-subsidy.

## Cross-subsidy and what it does over time

Under a volume-based system, high-volume standard products are **overcosted** and low-volume custom ones are **undercosted**. Both errors are dangerous, in opposite directions. The overcosted product looks marginal, so managers price it up or drop it — losing the product that was actually funding the rest. The undercosted one looks profitable, so the firm adds more like it, and complexity accumulates until margins erode while everybody believes the business is growing.

The professor's lawn-mowing analogy from the textbook makes the dynamic concrete. Charge every lawn the same price and easy lawns are overpriced, difficult lawns underpriced. Easy-lawn customers get better offers elsewhere; difficult-lawn customers flock in. Over time the mix shifts entirely to the lawns that take longest.

## What ABC actually is

Two questions: what activities consume resources, and which cost object triggers those activities. Products do not consume resources directly — they consume activities, and activities consume resources. So the assignment runs in two stages: resources to activity cost pools, then pools to products or customers using a driver that causally moves the pool.

## When ABC is worth it

He was blunt about the limits. ABC systems are expensive to build and to maintain, and the gain comes from the diversity they resolve. A cement plant making one commodity product has nothing to reallocate — a single rate is already right. A job shop, a bank with several customer segments, or a firm running high- and low-volume lines side by side is where the distortion lives.

> Prof: Better to be approximately right than grossly wrong. Start simple, go after the low-hanging fruit first, and do not let the best become the enemy of the good.""",
"""## Full cost, single product

$$\\text{Full cost per unit} = \\text{Variable cost per unit} + \\frac{\\text{Fixed cost}}{\\text{Number of units}}$$

## Traditional (volume-based) allocation

$$\\text{Overhead rate} = \\frac{\\text{Total overhead}}{\\text{Total volume of the allocation base}}$$

The base is a volume measure — labour hours, labour dollars, machine hours, units.

$$\\text{Overhead assigned to a product} = \\text{Rate} \\times \\text{Product's units of the base}$$

## Activity-based costing

For each activity cost pool:

$$\\text{Activity rate} = \\frac{\\text{Cost in the pool}}{\\text{Total quantity of that pool's driver}}$$

$$\\text{Overhead assigned} = \\sum_{\\text{pools}} \\left( \\text{Activity rate} \\times \\text{Driver units consumed} \\right)$$

## The cost hierarchy

- **Unit level** — driver is units, machine hours, labour hours
- **Batch level** — driver is number of setups, orders, shipments, production runs
- **Product level** — driver is number of products; often split equally across the lines
- **Facility level** — no causal driver; usually left unallocated for decision-making

## Margins

$$\\text{Gross margin per unit} = \\text{Price} - \\text{Direct cost per unit} - \\text{Overhead assigned per unit}$$

## Which cost is relevant

- Short-run, capacity already in place: **variable cost**
- Long-run, capacity itself is a choice: **full cost including capacity**""")

SESSIONS[7] = ("Activity-Based Management, Customer Profitability, and Budgeting", """## Where this session sits

Three blocks, and they connect. First, ABC pointed at customers rather than products. Second, the organisational structure that decides who is measured on what. Third, the budget — the instrument that turns that structure into a number somebody is judged against.

## Not all customers are created equal

He put up the whale curve: customers ranked most to least profitable on the x-axis, cumulative profit on the y-axis. It rises steeply, peaks well above 100%, then falls back as the tail of unprofitable customers eats into what the good ones earned.

The characteristics of a high cost-to-serve customer are the customer-level version of Session 6's batch costs: many small orders rather than few large ones, frequent changes to orders, heavy support and inquiry usage, expedited deliveries, high returns, and custom requirements.

The textbook problems make this concrete. Two construction customers with identical $400,000 of sales: Ryan has the higher contribution margin at $120,000 against Wilson's $100,000, and yet Wilson is the more profitable customer — because Ryan placed 50 orders and took 150 deliveries against Wilson's 20 and 40. The contribution margin ranking and the profit ranking point in opposite directions.

> Trap: Contribution margin ranks revenue quality. Customer profitability ranks revenue quality **net of what it cost to earn it**. A customer can be top of one list and bottom of the other.

## What to do about the unprofitable tail

He deliberately refused to let "fire them" be the automatic answer, and the discussion slide lists the alternatives in the order a manager should try them:

- **Reprice** — service fees, order minimums, menu pricing that charges for the activities the customer actually consumes.
- **Change how you serve them** — move the small accounts to self-service and digital channels so the cost-to-serve falls instead of the customer leaving.
- **Change the customer's behaviour** — the textbook's answer to Quinn and Thorne is to work with them on their ordering pattern, and to teach them how Ralph runs purchasing.
- **Change nothing** — ask what the numbers are missing. Reference value, referrals, a loss-leading product that pulls in the profitable one, a young account being developed on purpose.

Firing a customer removes the revenue and the contribution immediately, while a good part of the cost you were assigning them is capacity cost that does not walk out with them.

## From costing to managing

Activity-based *management* is what you do with the visibility. Six questions, in order: what are our high-cost activities; do they add value for the customer; can we eliminate or simplify them; can we do them more efficiently; should someone else do them; can technology eliminate them.

That last one got its own slide on AI. If order intake, scheduling and documentation are automated, a small order becomes almost as cheap to process as a large one — which shrinks the batch-level pool that made low-volume products look bad in the first place. Serving the long tail of small customers may become viable. New pools appear in exchange: compute cost, model licensing, data governance.

## Decentralisation

Distributing decision rights away from the centre. It is inevitable as firms grow, and firms still differ a lot in how far they go.

| Benefits | Costs |
|---|---|
| Quicker decisions by the people with the expertise | Coordination failures across units |
| Better adaptation to local conditions | Duplication of activities and expertise |
| Higher morale from empowerment | Goal incongruence — divisional and firm goals pull apart |
| Frees top management for strategy | Silo behaviour, narrow focus on own unit |
| Develops the future leadership bench | |

## Management control systems

The processes and structures that keep activity pointed at the firm's goals. The objective is **goal congruence**: making the choice that is best for the manager also the choice that is best for the firm.

Three components, and they only work aligned with each other:

1. **Allocation of decision rights** — who decides what.
2. **Choice of performance measures** — are the metrics consistent with the decision rights granted?
3. **Choice of reward systems** — how is measured performance paid.

The general guideline is the **controllability principle**: hold people accountable, to the extent possible, only for outcomes they control. Units built to satisfy it are responsibility centres.

## Responsibility centres

| Centre | Decision rights | Measured on |
|---|---|---|
| Cost centre | Controls inputs | Cost |
| Revenue centre | Controls pricing and sales | Revenue |
| Profit centre | Controls cost, pricing and sales | Profit — responsible for a P&L |
| Investment centre | All of the above plus capital spending | ROI — responsible for a P&L and a balance sheet |

Autonomy increases down the list. His examples: an Amazon warehouse is a cost centre measured on cost per unit shipped; a Salesforce regional office is a revenue centre; the iPhone division is a profit centre; GE Aviation is an investment centre.

> Trap: The dividing line between profit and investment centre is capital expenditure, not size. A unit that sets its own prices, hires its own people and runs its own P&L but has buildings and IT provided centrally is a **profit centre** — it does not control the asset base it would be measured on.

## What a budget is

A quantified plan that allocates resources and sets expectations for a period. He then made the point the whole block turns on: a budget is three things at once.

- A **forecast** — the best guess of what will happen.
- A **contract** — the resources committed.
- A **target** — the number you are judged against.

A good forecast and a tough target are rarely the same number. Every pathology later in the session comes out of that overlap.

## Building the master budget

The revenue forecast comes first and every downstream number inherits its error. Triangulate it: on-the-ground local knowledge, macro and industry trends, market research.

Then the inventory equation converts sales into production:

Production = Sales + desired ending inventory − beginning inventory

For BuildIT: 8,000 sold, 90 wanted at the end, 75 on hand at the start, so 8,015 lots to produce. For BuildIT-PLUS: 2,000 + 20 − 15 = 2,005.

Input budgets follow from production — bill of materials for materials, routing sheet for labour, cost of capacity for overhead. The same equation runs again for materials, in kilograms rather than units: purchases = quantity needed for production + desired ending raw-material stock − beginning stock.

Costs then flow to the P&L through the same equation a third time:

COGS = beginning finished-goods inventory + cost of goods manufactured − ending finished-goods inventory

> Worked example: BuildIT produces 8,015 lots and sells 8,000, so finished-goods inventory rises. Fifteen lots' worth of cost stays on the balance sheet, and variable COGS comes in **lower** than variable COGM.

Selling and administrative costs are period costs. They are driven by the sales plan and go straight to the income statement without passing through inventory.

## The moment the budget becomes a target

The statement built above is a forecast. The moment it is used to evaluate people, behaviour changes, because the same number now sets pay, status and next year's resources.

**The ratchet effect.** Most firms anchor next year on this year's actual. Beat your target and next year's is harder. So managers learn not to look too good — the incentive to over-deliver is capped by what over-delivering does to the following year.

**Participative budgeting: cure or cause?** Bottom-up budgeting taps local knowledge and builds commitment. It also hands the information advantage to exactly the people who benefit from shading the numbers. That is the padding trade-off, and most firms end up with a mix of top-down and bottom-up with goals set "tight but attainable".

**The games.** All of these are rational responses to how the budget is used, not evidence of bad people:

- **Sandbagging** — low-ball the target you will be judged on.
- **Padding** — build slack into requested resources.
- **Spending to avoid lapsing** — use it or lose it, so it gets used.
- **Timing games** — shift revenue and costs across the year-end line.

He closed by asking what happens if you scrap budget-based bonuses and pay managers for forecast *accuracy* instead. It buys honest numbers. It also removes any reason to stretch, and gives a manager who is about to miss an incentive to make the miss happen.""",
"""## Customer profitability

$$\\text{Customer profit} = \\text{Revenue} - \\text{Variable cost} - \\sum \\left( \\text{Activity rate} \\times \\text{Activity units the customer consumed} \\right)$$

Common customer-level drivers: number of orders, number of deliveries, sales visits, order changes, expedited shipments, returns, support calls, miles per delivery.

## Contribution margin ratio

$$\\text{CMR} = \\frac{\\text{Contribution margin}}{\\text{Sales}}$$

A high CMR customer can still be unprofitable once cost-to-serve is charged.

## Responsibility centres

| Centre | Measure |
|---|---|
| Cost | Cost, or cost per unit of output |
| Revenue | Revenue, bookings |
| Profit | Divisional profit |
| Investment | ROI, residual income, EVA |

## The inventory equation — used three times

Finished goods, in units:

$$\\text{Production} = \\text{Sales} + \\text{Ending inventory} - \\text{Beginning inventory}$$

Raw material, in input units:

$$\\text{Purchases} = \\text{Production} \\times \\text{Input per unit} + \\text{Ending RM} - \\text{Beginning RM}$$

Cost of goods sold:

$$\\text{COGS} = \\text{Beginning FG} + \\text{COGM} - \\text{Ending FG}$$

## Budgeted income statement, shape

Revenue − variable COGS − variable marketing and admin = contribution margin. Contribution margin − fixed manufacturing − fixed marketing and admin = profit before taxes. Then taxes.

## Cash budget

$$\\text{Ending cash} = \\text{Opening cash} + \\text{Collections} - \\text{Payments}$$

Collections split the current month's sales from prior months' receivables by the stated collection pattern; payments do the same for purchases.""")

SESSIONS[8] = ("Variance Analysis and the Buckeye National Bank Case", """## Where this session sits

Session 7 built the budget. This one asks the question that arrives at the end of the period: actual profit is not the budgeted profit — why, who is responsible, and what should we learn for next time.

He opened with Target in 2022. Gross margin fell from about 30% to 25.7% in Q1 and 21.5% in Q2, operating income fell 43% then 87% year on year, and inventory was running 40% above the prior year, forcing markdowns. The stock dropped about a quarter on the Q1 announcement. Was that a demand forecasting failure, a pricing failure, or an execution failure? Which responsibility centre owns it? Variance analysis is the machinery for answering exactly that.

## Vocabulary

A **variance** is the difference between an actual outcome and the budget. It is **favourable (F)** when the actual result is better than budget and **unfavourable (U)** when it is worse. Variances are always stated in money, never in kilograms or hours, because money is what makes their relative importance comparable.

## The Glass Vessels example

The numbers he used all session:

| Budget assumption | |
|---|---|
| Sales forecast | 10,000 units |
| Price | $12 per unit |
| Labour | 0.4 hour per unit at $10 per hour |
| Material | 0.5 kg per unit at $6 per kg |
| Variable overhead | $1.25 per labour hour |
| Fixed overhead | $14,000 |

That gives a master budget: revenue $120,000, labour $40,000, material $30,000, variable overhead $5,000, fixed $14,000, total cost $89,000, operating profit $31,000.

Actual came in at 8,000 units: revenue $88,000, labour $34,000, material $25,500, variable overhead $3,800, fixed $15,100, total cost $78,400, operating profit $9,600.

Total profit variance: $21,400 U.

## The trap he set immediately

Total costs were $78,400 against a budget of $89,000. A colleague concludes production saved $10,600 and executed brilliantly.

She is wrong, and this is the single most important idea in the session. Volume was 20% below plan. Of course costs were lower — the plant made 2,000 fewer units. Comparing actual costs at 8,000 units against a budget built for 10,000 units compares two different things.

## The flexible budget

The flexible budget is the budget re-computed at the **actual** output volume: what would revenues and costs have been at 8,000 units if everything else had gone as planned?

Revenue $96,000, labour $32,000, material $24,000, variable overhead $4,000, fixed $14,000 (fixed costs do not flex), total cost $74,000, profit $22,000.

Now the $21,400 U splits cleanly into two halves that belong to two different people:

- **Sales volume variance** = flexible budget profit − master budget profit = $22,000 − $31,000 = **$9,000 U**. This is the profit lost purely because 2,000 fewer units were sold. It belongs to sales and marketing, not to the plant.
- **Flexible budget variance** = actual profit − flexible budget profit = $9,600 − $22,000 = **$12,400 U**. This is everything that went wrong at the volume actually achieved. This is the plant's number — and it is unfavourable, not the $10,600 saving the colleague thought she saw.

> Prof: Separate the demand shock from the operational execution. Evaluating a plant manager against a static budget is unfair, and it produces exactly the wrong conclusion.

## Breaking the flexible budget variance down

Comparing the flexible budget column against actual, line by line:

| Line | Flexible | Actual | Variance |
|---|---|---|---|
| Revenue | $96,000 | $88,000 | $8,000 U — sales price |
| Labour | $32,000 | $34,000 | $2,000 U |
| Material | $24,000 | $25,500 | $1,500 U |
| Variable overhead | $4,000 | $3,800 | $200 F |
| Fixed costs | $14,000 | $15,100 | $1,100 U |
| Profit | $22,000 | $9,600 | $12,400 U |

The revenue shortfall of $32,000 against the static budget therefore splits $24,000 to volume and $8,000 to price. Both belong to the revenue centre, but they say different things: one is a forecasting or market problem, the other is discounting discipline or pricing power.

## The decomposition tree

Total profit variance splits into sales volume variance and flexible budget variance. The flexible budget variance splits into sales price variance, variable cost variance and fixed cost variance. The variable cost variance splits again, into a quantity (efficiency) component and a price (spending) component.

## Splitting a variable cost variance

Labour cost was $2,000 over. Two possible reasons: more hours were used than budgeted, or each hour cost more than budgeted. Three columns separate them:

| Column | Meaning |
|---|---|
| BQ × BP | Flexible budget — budgeted input for the **actual output**, at budgeted price |
| AQ × BP | The "as if" budget — actual input used, at budgeted price |
| AQ × AP | Actual |

The gap between the first two is the **quantity (efficiency) variance**; the gap between the last two is the **price (spending) variance**.

> Worked example: Glass Vessels labour. BQ = 8,000 units × 0.4 hours = 3,200 hours, so BQ × BP = $32,000. Actual hours were 4,400, so AQ × BP = $44,000. Actual cost was $34,000. Quantity variance = $12,000 U, price variance = $10,000 F, and the two net to the $2,000 U on the line.

Material works the same way. BQ = 8,000 × 0.5 = 4,000 kg at $6 = $24,000. Actual usage 4,500 kg at budgeted price = $27,000, so the quantity variance is $3,000 U. Actual cost was $25,500, so the price variance is $1,500 F, netting to the $1,500 U on the line.

Note what the BQ column is not. It is not the original budget's input quantity. It is the input the standard *allows for the output actually produced*.

## Variances are signals, not verdicts

A favourable variance is not automatically good news, and the four Glass Vessels numbers tell one story rather than four:

- Material price $1,500 F and labour price $10,000 F
- Material quantity $3,000 U and labour quantity $12,000 U

Cheaper, lower-grade material and cheaper, less experienced labour generated waste and took longer. Purchasing looks like a hero and production looks incompetent, and neither reading survives putting the four numbers on one page.

The same logic runs in the other direction. Favourable labour efficiency can mean rushed production and lower quality. A favourable fixed cost variance in December can mean deferred maintenance that becomes downtime in Q1.

## Behavioural consequences

Managers game variances in predictable ways: buy cheap inputs for a favourable price variance, defer maintenance to hit a short-term cost target, pad the budget so the standard is easy, and sacrifice long-term investment for this period's numbers.

## When variance analysis is less useful

- **High fixed-cost environments** — software, semiconductors, AI. Variable cost variances are small and beside the point.
- **Rapidly shifting demand** — the budget is obsolete before the period ends, so the comparison is against a plan nobody believes.
- **Innovation-driven firms** — variance discipline discourages exactly the experimentation the firm needs.
- **Service and knowledge work** — quantity standards are hard to define honestly.

## The Buckeye National Bank case

The second half of the session ran the case, and it is the service-sector version of Session 6 exactly.

Buckeye grew by serving small businesses, then shifted strategy to chase retail accounts, paying branch-manager bonuses for account growth. Eighty per cent of managers hit their targets, more customers arrived — and profits kept falling.

The old cost system allocated all $2,850 thousand of indirect cost on the dollar value of checks processed. Retail wrote 10% of check value and business 90%, so retail absorbed $285 thousand over 150,000 accounts — $1.90 an account — and business absorbed $2,565 thousand over 50,000 accounts, or $51.30. Against average revenue of $10 and $40, retail looked like an $8.10 winner and business an $11.30 loser.

That allocation assumes indirect cost is proportional to the dollar value of checks. Nothing about processing a check depends on how large the check is.

The pilot ABC study used three activities:

| Activity | Cost pool | Driver | Rate |
|---|---|---|---|
| Paying checks | $1,140 | 2,850 thousand checks | $0.40 per check |
| Teller services | $1,200 | 200 thousand transactions | $6.00 per transaction |
| Customer inquiries | $510 | 100 thousand calls | $5.10 per call |

Retail wrote 570 thousand checks, made 160 thousand teller transactions and 95 thousand inquiry calls. Business wrote 2,280 thousand checks but made only 40 thousand teller transactions and 5 thousand calls.

Retail absorbs $228 + $960 + $484.5 = $1,672.5 thousand, which is $11.15 an account. Business absorbs $912 + $240 + $25.5 = $1,177.5 thousand, or $23.55. The verdict inverts: retail loses $1.15 an account and business earns $16.45.

> Trap: Business customers wrote four times the check value and looked expensive under the old system. What actually costs money is walking into a branch and calling the service centre — and retail does almost all of that. The old base measured size; the activity drivers measure work.

The strategy implication is not "stop acquiring retail customers". It is that a bonus paid on the *number* of accounts, with no view of cost-to-serve, pays managers to add loss-making accounts. Buckeye's options are the customer-profitability menu from Session 7: reprice with minimum balances and per-transaction fees, push retail toward ATM and online channels so the driver quantities fall, or target the retail segments whose behaviour looks like the profitable ones.

One caution he raised on the ABC rates: does an extra ten teller customers really add $60 of cost? Not immediately. The rate is a long-run average cost of the capacity, which is the right number for a strategic decision about product lines and pricing, and the wrong number for a one-off incremental question.""",
"""## The three columns

$$\\text{Static (master) budget} \\;\\longrightarrow\\; \\text{Flexible budget} \\;\\longrightarrow\\; \\text{Actual results}$$

- Static budget: budgeted volume, budgeted prices and quantities
- Flexible budget: **actual** volume, budgeted prices and quantities
- Actual: actual volume, actual prices and quantities

## Top-level variances

$$\\text{Total profit variance} = \\text{Actual profit} - \\text{Master budget profit}$$

$$\\text{Sales volume variance} = \\text{Flexible budget profit} - \\text{Master budget profit}$$

$$\\text{Flexible budget variance} = \\text{Actual profit} - \\text{Flexible budget profit}$$

$$\\text{Total profit variance} = \\text{Sales volume variance} + \\text{Flexible budget variance}$$

## Inside the flexible budget variance

$$\\text{Sales price variance} = \\text{Actual revenue} - \\text{Flexible budget revenue}$$

$$\\text{Fixed cost (spending) variance} = \\text{Budgeted fixed cost} - \\text{Actual fixed cost}$$

Fixed costs do not flex, so the flexible-budget figure equals the static-budget figure.

## Splitting a variable cost variance

With BQ the budgeted input **for the actual output**, AQ the actual input used, BP the budgeted input price and AP the actual input price:

$$\\text{Quantity (efficiency) variance} = (AQ - BQ) \\times BP$$

$$\\text{Price (spending) variance} = (AP - BP) \\times AQ$$

$$\\text{Total variable cost variance} = AQ \\times AP - BQ \\times BP = \\text{Quantity variance} + \\text{Price variance}$$

$$BQ = \\text{Actual output} \\times \\text{Standard input per unit of output}$$

## Signs

A positive result from the formulas above means actual exceeded budget, which for a cost is **unfavourable**. For revenue, actual above budget is **favourable**. Label every number F or U rather than relying on the sign.

## Activity-based costing rates, service setting

$$\\text{Activity rate} = \\frac{\\text{Activity cost pool}}{\\text{Total driver units}} \\qquad \\text{Cost per account} = \\frac{\\text{Total assigned cost}}{\\text{Number of accounts}}$$""")

SESSIONS[9] = ("Variance Problems, Divisional Performance, and Transfer Pricing", """## Where this session sits

Two halves. The first closes variance analysis with the professor's worked problems. The second opens transfer pricing, which occupies the rest of the course.

## Working the variance problems

**Space Toys (8.49).** Budget of 15,000 rockets at $25, actual sales 12,000. Rebuild the middle column first: at 12,000 units the flexible budget is revenue $300,000, labour $12,000, material $36,000, variable overhead $12,000, contribution margin $240,000, fixed costs $150,000, profit $90,000.

- Sales volume variance = $90,000 − $150,000 = **$60,000 U**
- Sales price variance = $300,000 actual revenue − $300,000 flexible revenue = **zero**. The whole revenue shortfall was volume.
- Material: flexible $36,000 against actual $30,000 = $6,000 F in total. Split it — budgeted 2 kg per unit at $1.50, so BQ = 24,000 kg against 22,000 actually used. Quantity variance = (22,000 − 24,000) × $1.50 = $3,000 F, and the price variance is the remaining $3,000 F.
- Fixed costs came in $9,000 under, which is favourable but worth a question: fixed cost underspending at 20% below planned volume is often deferred rather than saved.

**Problem 8.42, run backwards.** You are given a price variance of $3,150 U, a quantity variance of $4,500 F, a flexible budget quantity of 18,000 kg and a budgeted price of $1.50 per kg, and asked for the actual quantity and the actual price. Work the three columns in order.

- Flexible budget = 18,000 × $1.50 = $27,000
- The "as if" budget is the flexible budget adjusted by the quantity variance: $27,000 − $4,500 = $22,500. Since that column is AQ × BP, AQ = $22,500 / $1.50 = **15,000 kg**
- Actual = "as if" plus the price variance: $22,500 + $3,150 = $25,650, so AP = $25,650 / 15,000 = **$1.71 per kg**
- Total material variance = $4,500 F − $3,150 U = $1,350 F

> Prof: A favourable quantity variance alongside an unfavourable price variance usually means a higher-grade input was bought. It cost more per kilogram and produced less waste.

## Measuring a division that owns assets

Before transfer pricing, the assigned reading covers how an investment centre is scored, because that is what makes divisional numbers worth fighting over.

**Return on investment.** Operating income divided by the assets employed. Easy to compute, easy to compare across units of different sizes — and it creates an underinvestment problem. A manager currently earning 26% on $300,000 who is offered a project adding $5,000 of income on $50,000 of assets sees ROI fall to 23.7%. The project earns 10%, which may well beat the cost of capital, and she turns it down because it dilutes her number.

**Residual income.** Income minus a capital charge on the assets: any project earning more than the charge raises it, so the dilution problem disappears. It is not comparable across divisions of different sizes, because a big division has a bigger number by construction.

**Economic value added.** Residual income tightened up: after-tax operating profit, a WACC-based charge, and adjustments to the asset base. Conceptually the soundest and the most work to implement.

A caution on ROI that the textbook makes well: an old, heavily depreciated asset base produces a flattering ROI. A high ROI can mean a small denominator rather than a good business.

## What a transfer price is

When one division sells to another inside the same firm, the internal price is the transfer price. It is revenue to the seller and cost to the buyer, so it is exactly zero-sum: **internal transfer prices do not change corporate pre-tax profit**. They shift profit between divisions.

Which sounds harmless, and is not, because divisional profit is what drives bonuses and promotions, capital allocation, sourcing decisions and whether a division survives at all. Managers fight over transfer prices for the same reason they fight over budgets.

Three questions run through every transfer pricing problem: who has the right to source externally and who sets the price; what price makes autonomous managers choose what is best for the firm (**goal congruence**); and from the corporate point of view, is the internal transfer better than buying outside at all.

Any workable system has to balance goal alignment, divisional autonomy and fair performance measurement. No system achieves all three perfectly.

## The rule

$$\\text{Minimum TP the seller accepts} = \\text{Seller's incremental cost} + \\text{Seller's opportunity cost of transferring}$$

$$\\text{Maximum TP the buyer accepts} = \\text{External purchase price} \\pm \\text{costs saved or added by buying internally}$$

If the minimum is below the maximum, a transfer zone exists, the internal transfer is efficient for the company, and any price inside the zone gets autonomous managers to the right decision. If the minimum exceeds the maximum, there is no price both would accept — and that is not a failure of negotiation, it is the correct signal that the firm should buy outside.

The corporate view is the same two numbers wearing different hats. The seller's minimum **is** the true cost of making in-house; the buyer's maximum **is** the true cost of buying. Compare them and you have the sourcing decision.

## Capacity is the whole story

**No excess capacity.** Tesla's battery division: variable cost $1,800, external price $4,000, running at full capacity. Every battery transferred internally is a battery not sold outside, so the opportunity cost is the lost contribution margin of $2,200. Minimum TP = $1,800 + $2,200 = $4,000, which is just the market price. The vehicle division's outside quote is $4,400, so internal sourcing saves the firm $400 a unit and the transfer zone is $4,000 to $4,400.

**Excess capacity.** Same division able to sell only 150,000 of 300,000 units externally. Transferring displaces nothing, so the opportunity cost is zero and the minimum TP falls to the variable cost of $1,800. With an outside vendor at $3,000, the zone is $1,800 to $3,000.

**Partial capacity.** Neither extreme. Only the units that displace an external sale carry an opportunity cost, and it is spread over all the units transferred.

> Trap: The fixed cost per unit is never part of the minimum transfer price. It is sunk with respect to the transfer decision. Full cost enters the answer only when a corporate policy forces it to — which is Session 10's cautionary tale.

## Extra work on the transferred unit

If the buying division wants a modified version, the seller's incremental cost rises by the modification cost, and the minimum TP rises with it. Tesla again: $600 of extra variable cost to modify the standard battery takes the minimum from $4,000 to $4,600. That now exceeds the buyer's ceiling of $4,400, and the correct corporate decision flips to buying outside.

The mirror image applies on the buyer's side. If sourcing internally avoids $60 of incoming inspection and freight, the buyer's ceiling is the external price *plus* $60 — $1,060 against a $1,000 outside quote — because buying inside is worth that much more than the invoice suggests.

## Walker Inc., all three cases

Circuit Division makes Circuit 222: variable cost $140 standard, $155 for the modified version Satellite wants, capacity 100,000 units. Satellite can buy outside at $180.

| Scenario | Opportunity cost | Min TP | Max TP | Decision |
|---|---|---|---|---|
| External demand 100,000 at $170 | $170 − $140 = $30 | $185 | $180 | No transfer — buy outside |
| External demand 50,000 at $170 | zero | $155 | $180 | Transfer, zone $155–$180 |
| 50,000 at $170 plus one-time 50,000 at $160 | $160 − $140 = $20 | $175 | $180 | Transfer, zone $175–$180 |

The third case is the one worth studying. What gets displaced is the *marginal* external order, the $160 one, not the best one.

## When capacity is a constrained resource

Division A runs two products on one machine with 600 hours a month. Product 1: demand 300 units, price $10, variable cost $4, one hour each. Product 2: unlimited demand, price $15, variable cost $7, two hours each.

Rank by contribution margin per machine-hour, not per unit: Product 1 earns $6 an hour, Product 2 earns $4. So fill Product 1's 300 units of demand using 300 hours, then run Product 2 for 150 units with the remaining 300 hours.

Division B wants 50 units of Product 1. Those take 50 machine-hours, which displaces 25 units of Product 2 and $200 of contribution — $4 per transferred unit. Minimum TP = $4 + $4 = $8, against B's current external price of $9. The transfer is worth $1 a unit to the firm.

The unitised fixed costs of $2 and $6 in the problem are there to be ignored.""",
"""## Divisional performance measures

$$\\text{ROI} = \\frac{\\text{Operating income}}{\\text{Assets employed}}$$

$$\\text{Residual income} = \\text{Operating income} - \\left( \\text{Required rate of return} \\times \\text{Assets} \\right)$$

$$\\text{EVA} = \\text{Operating income} \\times (1 - t) - \\left( \\text{WACC} \\times (\\text{Assets} - \\text{Current liabilities}) \\right)$$

$$\\text{WACC} = (1 - t) \\times w_d \\times r_d + w_e \\times r_e$$

## Transfer pricing, short run

$$TP_{\\min} = \\text{Incremental cost per unit} + \\text{Opportunity cost per unit}$$

$$TP_{\\max} = \\text{External price} + \\text{Costs avoided by buying inside} - \\text{Extra costs of buying inside}$$

Transfer zone exists when $TP_{\\min} < TP_{\\max}$. Any price inside it is goal-congruent.

## Opportunity cost by capacity situation

| Situation | Opportunity cost per unit transferred |
|---|---|
| Excess capacity | Zero |
| Full capacity | External price − variable cost of the displaced sale |
| Partial capacity | (Units displaced ÷ units transferred) × contribution margin lost per displaced unit |
| Constrained resource | Contribution margin per unit of the constraint × constraint units used |

## Corporate sourcing test

$$\\text{Cost of making inside} = TP_{\\min} \\qquad \\text{Cost of buying outside} = TP_{\\max}$$

Make inside when $TP_{\\min} < TP_{\\max}$; buy outside otherwise.

## Ranking under a constraint

$$\\text{Rank by} \\quad \\frac{\\text{Contribution margin per unit}}{\\text{Constraint units per unit}}$$

## What is never in the minimum transfer price

Allocated or unitised fixed cost, and any mark-up over cost. Both are sunk or arbitrary with respect to the transfer decision.""")

SESSIONS[10] = ("Transfer Pricing in Practice: Policy, Negotiation and Tax", """## Where this session sits

Session 9 derived the rule. This one asks what a company should actually write into a policy, what goes wrong when the policy is a formula, what happens when two managers are left to negotiate, and how the whole subject becomes a tax question once the divisions sit in different countries.

He restated the rule to start: minimum TP is incremental cost plus opportunity cost, maximum TP is the external price adjusted for costs saved or incurred.

## Why have a policy at all

Because resolving transfer pricing conflicts case by case means top management gets pulled in constantly. That undermines the decentralisation the firm chose in the first place, eats executive time, and asks central managers to arbitrate using local information they do not have.

Three policies are available:

- **Market-based** — use the external market price. Objective and clean, but only works where a genuinely competitive external market for the item exists.
- **Negotiated** — divisions bargain freely. Preserves autonomy and uses local information, at the price of haggling and conflict.
- **Cost-based** — mandate transfers at full cost, or cost plus a mark-up. Simple to administer, and frequently distorts incentives.

Survey evidence he showed: roughly 46% of firms use some form of cost-based transfer price (variable cost 5%, full cost 24%, cost-plus 17%), about 30% use market price and about 24% negotiate.

## The danger of mandated full cost plus

This is the worked example the session turns on, and the practice final tests it directly.

Corporate policy says divisions may source where they like, and any internal transfer is priced at the seller's budgeted full cost plus 10%. Division A's budgeted full cost is $350 — $150 variable, $200 fixed unitised over budgeted volume — so the transfer price is $385. A can sell only 70,000 of its 100,000 unit capacity externally. Division B needs 20,000 units and can buy outside at $300.

Division B compares $385 with $300 and buys outside. Any manager evaluated on divisional profit would.

From the company's point of view that is wrong by $150 a unit. A has idle capacity, so the true incremental cost of supplying internally is $150. Buying outside spends $300 to avoid a $150 cost, and the mandated policy costs the firm $3 million.

> Trap: The manager is behaving rationally. The policy is at fault. Two features of full-cost-plus caused it — unitised fixed cost that is not incremental, and a mark-up that is pure profit shifting — and both get baked into a number the buying division treats as a real cost.

The general conclusion: cost-based policies are defensible when sourcing is mandated internally, because then the price only affects reported profit and not the decision. Once sourcing is delegated to divisions, cost-based pricing regularly produces the wrong sourcing choice, and negotiation is the better default.

## The negotiation, and what negotiation costs

The Seth and Brenda case. Seth's components division designed a custom part in collaboration with Brenda's refrigerator division, spending $240,000 on design and mock-ups, on nothing more than an understanding that he would be the front-runner in the bidding. He bid $230 a unit for 20,000 units a year — full cost plus about 15%. Brenda has outside bids around $170 and offers to split the difference at $200. Seth's division is at 70% capacity and missed bonus last year.

The arithmetic, per unit, relative to Brenda buying outside at $170:

| Transfer price | $170 | $200 | $230 |
|---|---|---|---|
| Change in Seth's profit | $45 | $75 | $105 |
| Change in Brenda's profit | $0 | −$30 | −$60 |
| Change in corporate profit | $45 | $45 | $45 |

Corporate profit is $45 a unit — $900,000 a year on 20,000 units — at every price. Seth's variable cost is $125, the outside alternative is $170, and the difference is real value created by transferring internally. The price only decides who gets credit for it.

That is what makes the dispute worth understanding rather than settling. The transfer should happen at any price between $125 and $170. Everything above that is distribution, and $230 is outside the range Brenda would ever rationally accept, since it is above her external alternative.

Should corporate intervene? Arguments both ways, and the exam-relevant point is the trade-off rather than a verdict. Intervening resolves the conflict quickly and makes sure the value-creating transfer happens. It also undermines the decentralisation the structure is built on, consumes executive time, sets a precedent that every future dispute gets escalated, and has HQ deciding without the local information the divisions hold.

## Holdup

Seth's real complaint is not the price. It is that he sank $240,000 into an asset that has value only in this relationship, on the strength of a vague promise, and Brenda now has all the bargaining power. That is the **holdup problem**: relationship-specific investment plus incomplete commitment.

His public example was Apple and GT Advanced in 2014 — GT invested hundreds of millions in sapphire capacity for Apple, Apple pulled back, GT filed for bankruptcy.

The fixes are all things you set up *before* the investment, not after:

- A long-term purchase commitment or take-or-pay clause from the buying division.
- Cost sharing — the buyer co-funds the specific investment.
- Pre-agreed formula pricing, or a pre-agreed arbitration mechanism.
- Vertical integration, or simply mandating internal sourcing for this item.

## International transfer pricing

Once divisions sit in different tax jurisdictions, the transfer price stops being zero-sum for the group. Subsidiaries are taxed where they earn income, rates differ, so a multinational has two levers: set low transfer prices on goods sold **to** low-tax subsidiaries, and buy **from** low-tax affiliates at inflated prices to load costs into high-tax countries.

His worked example. Parts cost $40, assembly costs $20, the product sells for $100.

- All in the US at 21%: taxable income $40, tax $8.40, effective rate 21%.
- Parts in the US, assembly in Ireland at 12.5%, transfer price $60: US income $20 taxed at 21% is $4.20; Irish income $20 taxed at 12.5% is $2.50; total $6.70, effective rate 16.75%.
- Push the transfer price down to $40, at cost: US income zero, all $40 of profit in Ireland, tax $5.00, effective rate 12.5%.

Which is exactly why tax authorities do not allow the firm to choose freely. **Arm's-length pricing** requires the transfer price to reflect what unrelated parties would charge, with acceptable methods including comparable market price, cost-plus, profit-split and advance pricing agreements.

**OECD Pillar Two** added a 15% global minimum tax from 2024 for groups above €750 million of revenue: if a subsidiary's effective rate falls below 15%, the home jurisdiction imposes a top-up. That caps the gain from profit shifting without ending transfer pricing disputes, which are mostly about intangibles anyway.

Intangibles are where the money is, because intellectual property — unlike a factory — can be moved to a tax haven with a signature. The royalty then flows from the operating country, which gets the deduction, to the haven, which books the income. Apple's Irish structures are the famous case: profits routed through Irish subsidiaries with minimal taxable presence, effective rates on some Irish profits as low as 0.005%, a 2016 European Commission ruling that Ireland had granted illegal state aid, €13 billion in back taxes, and the Court of Justice upholding it in 2024. Ireland closed the "Double Irish" to new structures in 2015. Google, Starbucks, Amazon, Coca-Cola and Medtronic all have versions of the same dispute.

## Summary of the module

- Transfer prices drive behaviour, because divisional profit drives bonuses, capital and survival.
- The right transfer price depends on context, and opportunity cost is what context means here. Full capacity points to market price; excess capacity points to variable cost.
- No policy is perfect. Match the policy to the situation: mandated sourcing tolerates cost-based prices, delegated sourcing needs negotiation or market prices.
- Relationship-specific investment creates holdup risk, and the remedy is contractual and comes first.
- International transfer pricing is a tax question bounded by arm's-length rules and the global minimum tax.

## The four things he asked the class to remember

1. There is no such thing as *the* cost of something.
2. Numbers make people do things.
3. Opportunity cost is real.
4. Never stop at the headline number.""",
"""## Transfer pricing policies

| Policy | Works when | Fails when |
|---|---|---|
| Market-based | A competitive external market exists | The item is custom, or the market is thin |
| Negotiated | Sourcing is delegated; divisions hold local information | Bargaining power is lopsided; haggling is costly |
| Cost-based (full cost or cost-plus) | Sourcing is mandated internally | Sourcing is delegated — it distorts the make-or-buy choice |

## The full-cost-plus failure, in one line

$$\\text{Mandated TP} = \\text{Full cost} \\times (1 + m) \\;\\gg\\; \\text{True incremental cost}$$

The buying division treats the mandated price as its cost of internal supply and outsources when it should not. Loss to the firm per unit = external price − seller's incremental cost.

## Value created by an internal transfer

$$\\text{Corporate gain per unit} = \\text{Buyer's external price} - \\text{Seller's incremental cost} - \\text{Seller's opportunity cost}$$

This number does not depend on the transfer price. The transfer price only splits it.

## Holdup

Relationship-specific investment + incomplete commitment = the investing party can be squeezed after the money is sunk. Remedies are ex ante: long-term or take-or-pay contracts, cost sharing, formula pricing, arbitration, vertical integration.

## International transfer pricing

$$\\text{Effective group tax rate} = \\frac{\\sum_{\\text{jurisdictions}} \\text{Income}_j \\times t_j}{\\sum_{\\text{jurisdictions}} \\text{Income}_j}$$

Shift income toward low $t_j$ by lowering the transfer price on goods sold into that jurisdiction, and raising it on goods bought from it.

Constraints: arm's-length pricing rules (comparable price, cost-plus, profit-split, advance pricing agreements), and the OECD Pillar Two 15% global minimum tax with a top-up in the parent jurisdiction, applying to groups above €750 million in revenue.""")

# ---------------------------------------------------------------------------
# Concepts. (topic, session, title, note)
# ---------------------------------------------------------------------------

CONCEPTS = [
    ("madm_relevant_cost_horizon", 6, "Short-Run vs Long-Run Cost", """Which cost number is right depends entirely on the decision, and the same facts produce several defensible numbers.

**The copying example.** A machine costing $4,000 with a four-year life, cartridges at $400 per 40,000 pages, paper at a cent a page, wages of $10,000 a year, other overhead of $1,000 a year, and 600,000 pages a year.

- Variable cost per page: ink at one cent plus paper at one cent, so two cents.
- Fixed cost per year: $1,000 of depreciation plus $10,000 of wages plus $1,000 of other overhead, which is $12,000. Over 600,000 pages that is another two cents.
- Full cost per page: four cents.

**Short-run decisions** take capacity as given. The extra page, the one-off order that fits into spare capacity, the decision to accept a rush job — all of these are priced against **variable cost**, because the capacity cost is already committed and does not change with the answer.

**Long-run decisions** put capacity itself in play. Should we run this function at all, outsource it, price a five-year contract, keep this product line? Now the capacity cost is avoidable, so the relevant number is **full cost**. An outside vendor at three cents a page for five years beats four cents.

> Trap: A one-off order of 10,000 pages onto a machine with spare capacity is worth taking above two cents. The same 10,000 pages a month, forever, is not — because sustained volume eventually forces the capacity decision, and then all four cents are back in play."""),

    ("madm_product_costing", 6, "Product Costing and Indirect Costs", """Product costing means estimating the fully absorbed cost of a product, variable plus fixed. It is also called full cost, and financial reporting requires it.

For a single product it is arithmetic: variable cost per unit plus fixed cost divided by units. Nothing to argue about.

The problem appears when several products share resources. Costs then split into two kinds:

- **Direct costs** can be traced to a product easily and unambiguously — direct material, direct labour.
- **Indirect costs**, or overhead, are resources serving several products at once, where tracing to any one product is difficult.

Someone has to decide how much of the shared cost belongs to each product, and no transaction record settles it. That choice is the whole subject.

**Why it is not just an accounting exercise.** How you allocate overhead determines which products look profitable and which do not, and that reported profitability drives pricing, product-line decisions, capital investment and strategy. A cost system is not a passive record; it is an input to decisions and an input to how people are judged.

> Prof: There is no such thing as *the* cost of something. Ask what decision the number is for."""),

    ("madm_traditional_costing", 6, "Traditional Volume-Based Costing", """A traditional cost system assumes overhead is proportional to production volume, picks one volume measure as the allocation base, and applies a single rate.

$$\\text{Overhead rate} = \\frac{\\text{Total overhead}}{\\text{Total units of the allocation base}}$$

Common bases: direct labour hours, direct labour dollars, machine hours, units produced.

**The two-product example.** Product A sells 15,000 units at $10 with $6 of direct cost and 0.5 labour hours each, placing 15 orders. Product B sells 5,000 units at $14 with $7 of direct cost and 0.6 labour hours each, placing 50 orders. Overhead is $100,000 and the business loses $5,000.

Labour hours total 7,500 for A and 3,000 for B, so 10,500, and the rate is $9.52 per hour. That gives A $4.76 of overhead a unit and B $5.71.

| | Product A | Product B |
|---|---|---|
| Price | $10.00 | $14.00 |
| Direct cost | $6.00 | $7.00 |
| Allocated overhead | $4.76 | $5.71 |
| Unit cost | $10.76 | $12.71 |
| Gross margin | −$0.76 | $1.29 |

The system says drop Product A. It is exactly backwards, and Session 6's ABC calculation shows why.

**When a single volume-based rate is fine.** When the products really do consume overhead in proportion to volume — a single-product plant, or a set of near-identical products made in similar batch sizes. The distortion needs diversity to bite."""),

    ("madm_cost_hierarchy", 6, "The Cost Hierarchy", """Overhead does not all behave the same way. Sorting it into four levels by what actually makes it move is the step that makes ABC work, and it is the single most testable idea in the session.

| Level | Driven by | Typical costs |
|---|---|---|
| **Unit** | Each unit produced | Energy, machining, consumables, unit maintenance |
| **Batch** | Each batch, run or order | Machine setup, production scheduling, order processing, shipping, quality inspection per lot |
| **Product** | Each product line kept alive | Design specifications and updates, product-specific tooling, product management |
| **Facility** | Simply operating the business | Rent, plant insurance, general administration, the CEO's salary |

**How to classify.** Ask what has to happen for the cost to be incurred one more time. Setting up a machine happens once per run regardless of whether the run is 10 units or 10,000 — batch level. Re-programming a CNC machine at the start of each production run is the same shape — batch level, not product level, because it recurs with every run rather than once per product line.

**Why the exam cares.** Low-volume products consume batch- and product-level resources out of proportion to their volume. A specialty product made in fifty small runs consumes fifty setups; a commodity product made in five large runs consumes five. A volume-based rate charges them by units and gets it exactly wrong.

**Facility-level costs.** Usually left unallocated for decision-making, because there is no causal driver and no product-level manager controls them. Allocating them anyway adds a fixed charge that changes rankings without carrying information."""),

    ("madm_abc_mechanics", 6, "How Activity-Based Costing Works", """ABC asks two questions: what activities consume resources, and which cost object triggers those activities. Products do not consume resources directly — they consume activities, and activities consume resources.

**The three steps.**

1. **Identify activities.** What work actually gets done — order processing, setup, quality testing, shipping, design support.
2. **Trace costs to activities.** Build a separate cost pool per activity instead of one bucket.
3. **Assign pools to cost objects** using a driver that causally moves that pool.

$$\\text{Activity rate} = \\frac{\\text{Cost in the pool}}{\\text{Total driver units}} \\qquad \\text{Assigned} = \\sum \\left( \\text{Rate} \\times \\text{Driver units consumed} \\right)$$

**The two-product example, redone.** The same $100,000 of overhead, split by how it behaves: $30,000 unit level driven by labour hours, $65,000 batch level driven by orders, $5,000 product level split equally.

- Unit-level rate: $30,000 over 10,500 hours, so $2.86 an hour
- Batch-level rate: $65,000 over 65 orders, so $1,000 an order
- Product level: $2,500 per product line

Product A absorbs 7,500 hours at the unit rate — $21,429 — plus 15 orders at $1,000, plus $2,500, giving $38,929, or $2.60 a unit. Product B absorbs $8,571 plus $50,000 plus $2,500, giving $61,071, or $12.21 a unit.

| | Product A | Product B |
|---|---|---|
| Price | $10.00 | $14.00 |
| Direct cost | $6.00 | $7.00 |
| ABC overhead | $2.60 | $12.21 |
| Unit cost | $8.60 | $19.21 |
| Gross margin | $1.40 | −$5.21 |

The ranking inverts. B's fifty small orders consumed $50,000 of batch cost against A's fifteen large orders at $15,000, and a labour-hour rate cannot see order count at all.

> Trap: Notice that total overhead is unchanged. ABC does not find or save money by itself. It reassigns the same pool, and the reassignment changes which decisions look right."""),

    ("madm_cross_subsidy", 6, "The Cross-Subsidy Problem", """Under a volume-based system, high-volume standard products are **overcosted** and low-volume custom products are **undercosted**. The two errors are the same error seen from opposite ends, and both are dangerous.

| | Overcosted | Undercosted |
|---|---|---|
| Which products | High volume, standard, large routine orders | Low volume, custom, small special orders |
| How they appear | Less profitable than they really are | More profitable than they really are |
| The risk | Managers cut or over-price the product that is actually funding the rest | Unprofitable products and customers proliferate |

**The dynamic over time.** Greg's lawn-mowing business charges a flat price per lawn, which is a volume-based allocation in disguise: it assumes every lawn takes the same work. Difficult lawns are underpriced and easy lawns overpriced. Owners of easy lawns get better quotes elsewhere and leave; owners of difficult lawns find Greg cheap and flock in. The mix drifts toward the lawns that take longest, and average cost per job climbs while the price stays flat.

The manufacturing version is identical: a firm using volume-based allocation to set prices watches its mix shift away from easy-to-make high-volume products toward difficult low-volume ones, one rational customer decision at a time.

**Why this is a strategic problem and not a bookkeeping one.** Companies accumulate unprofitable products and customers while believing they are growing. Revenue rises, margins erode, and the cost system reports nothing wrong because it was never measuring the thing that changed."""),

    ("madm_abc_implementation", 6, "When ABC Is Worth Building", """ABC produces better numbers and costs real money to build and maintain. The judgement is about where the gain justifies the cost.

**Where ABC pays.**

- Products or customers differ a lot in volume, batch size, or how much support they consume.
- Overhead is large relative to direct cost, so misallocating it moves the answer.
- The firm competes on price or is actively deciding what to keep, drop or reprice.
- Service businesses with several customer segments — a bank, a hospital, a hotel — where almost every cost is indirect.

**Where ABC adds little.** A cement plant producing a single commodity product has one product to allocate to, so any allocation gives the same answer. Diversity is what creates the distortion, and without diversity there is nothing to correct.

**How to implement it, from the deck.**

- Weigh the cost and benefit of incremental precision. More pools are not automatically better.
- Go after the low-hanging fruit first — the few activities holding most of the money.
- Do not let the best become the enemy of the good.
- Better to be approximately right than grossly wrong.
- Start simple, and look for something that scales.

**A caution on the rates.** An activity rate is a long-run average cost of capacity. It answers "what does this product line or customer segment cost us" well. It answers "what happens if ten more customers use a teller tomorrow" badly — in the short run that capacity is already paid for."""),

    ("madm_customer_profitability", 7, "Customer Profitability Analysis", """The same ABC logic pointed at customers rather than products. The result is usually a whale curve: cumulative profit rises steeply across the best customers, peaks well above 100%, then falls back as the unprofitable tail eats into it.

**What makes a customer expensive to serve.** Small frequent orders instead of large infrequent ones, order changes after placement, heavy support and inquiry usage, expedited deliveries, returns, custom specifications, long payment terms and discounts taken.

$$\\text{Customer profit} = \\text{Revenue} - \\text{Variable cost} - \\sum \\left( \\text{Activity rate} \\times \\text{Units consumed} \\right)$$

**Why contribution margin is not enough.** Two construction customers each buy $400,000. Ryan generates $120,000 of contribution margin against Wilson's $100,000 — and Wilson is the more profitable customer, because Ryan placed 50 orders and took 150 deliveries against Wilson's 20 and 40. The order and delivery costs more than reverse the contribution advantage.

The same pattern runs through the other textbook cases. Quinn's volume is a fraction of Ralph's and yet Quinn's ordering cost is about the same, because Quinn places nearly as many orders. Thorne is a small customer generating as much order-processing work as the largest, and is the only loss-maker in the set.

> Trap: A customer can rank top on contribution margin and bottom on profitability. Cost-to-serve is what separates the two rankings, and it is invisible unless somebody assigns it by activity."""),

    ("madm_managing_customers", 7, "Managing the Unprofitable Tail", """An ABC study showing that a quarter of customers generate nearly all the profit, and the bottom fifteen per cent destroy a fifth of it, is a beginning rather than a conclusion. "Fire them" is the answer the numbers seem to shout and rarely the right first move.

**The menu, roughly in the order to try it.**

- **Reprice.** Service fees, order minimums, menu pricing that charges separately for the activities the customer consumes. This converts a cost problem into a revenue line and lets the customer choose.
- **Change how you serve them.** Move small accounts to self-service, digital channels, standard catalogue items. The cost-to-serve falls without the revenue leaving.
- **Change the customer's behaviour.** The textbook answer to Quinn and Thorne is to work with them on their ordering pattern, and to learn how the profitable customer runs its purchasing so the practice can be shared.
- **Change nothing, and ask what the numbers are missing.** Reference value, referrals, a loss-leading product that pulls a profitable one, a young account being deliberately developed. Sylvester Steel absorbing development cost on a small customer may be an investment rather than a mistake.

**Why firing is the last resort.** The revenue and contribution leave immediately; a good part of the assigned cost is capacity cost that stays. Dropping the customers does not drop the cost, and the remaining customers then absorb it — which produces another round of apparently unprofitable customers.

**Tiering.** ABC-based customer profitability lets a firm distinguish among customers and tailor service levels and prices by tier. Which customers to acquire, which to support and retain, and which to let go becomes a decision with evidence behind it."""),

    ("madm_abm", 7, "Activity-Based Management", """ABC is a measurement system. Activity-based management is what you do with the visibility, and the deck framed it as six questions asked in order.

1. **What are our high-cost activities?** Visibility into where the money actually goes.
2. **Do these activities add value for the customer?** Separate value-adding work from waste.
3. **Can we eliminate or simplify them?** Process redesign.
4. **Can we do them more efficiently?** Continuous improvement within the activity.
5. **Should someone else do them?** Outsourcing and partnerships.
6. **Can technology eliminate them?** Automation and digital channels.

The step ABC contributes is the first one. Without activity cost pools, "where does our overhead go" has no answer beyond a departmental budget, and a departmental budget does not tell you which work is worth doing.

**What ABM changes about cost management.** It makes cost transparent by tracing spending to activities and drivers, which lets managers see *why* costs occur and *where* they can be reduced. Cutting a department's budget by 10% cuts capacity. Removing an activity, or halving how often it is triggered, removes the demand for capacity — which is the only version that holds.

**The AI slide.** He argued the cost hierarchy itself may shift. If order intake, scheduling and documentation are automated, batch-level cost per order falls sharply and a small order becomes almost as cheap to process as a large one. Automated design variants and compliance testing shrink product-level cost, so a wider range costs less to support. AI handling inquiries and personalising service at scale makes the long tail of small customers viable. New pools appear in exchange — compute, model licensing, hallucination risk, data governance — and ABC has to be extended to capture them."""),

    ("madm_decentralization", 7, "Decentralisation: Benefits and Costs", """Decentralisation is distributing decision-making authority away from a central authority to lower levels of the organisation. Some degree of it is inevitable as firms grow, and firms still differ substantially in how far they go.

**Benefits.**

- **Efficiency.** Lower-level employees make quicker decisions in their own area of expertise, without waiting for a centre that has to be briefed first.
- **Local adaptation.** Units tailor strategy to regional or local conditions.
- **Morale.** Employees who are empowered and involved are more motivated.
- **Top-management capacity.** The centre is freed to work on strategic issues rather than operational ones.
- **Talent development.** Running a unit is the training ground for future top management.

**Costs.**

- **Coordination failures** across units that are each optimising locally.
- **Duplication** of activities and expertise that a centralised function would carry once.
- **Goal incongruence** — divisional incentives and firm goals stop pointing the same way.
- **Silo behaviour** — a narrow focus on the subunit's own numbers.

Everything else in this half of the course is a response to the cost column. Responsibility centres, performance measures, budgets and transfer prices all exist because decision rights were given away and the firm still needs the resulting choices to add up."""),

    ("madm_control_systems", 7, "Management Control Systems and Goal Congruence", """A management control system is the set of processes and structures a firm uses to make sure activities and resources are directed toward organisational goals. Its objective is **goal congruence**: aligning what is good for the manager with what is good for the firm.

**Three components, and they only work aligned with one another.**

1. **Allocation of decision rights** — who makes what decisions.
2. **Choice of performance measures** — are the metrics consistent with the decision rights granted?
3. **Choice of reward systems** — how measured performance translates into pay and advancement.

A mismatch between any two produces predictable failure. Give a manager decision rights over pricing but measure her on cost, and she will cut cost at the expense of revenue. Measure a manager on a number she does not control and she will either be lucky or unlucky, and in neither case will the measurement mean anything.

**The controllability principle.** To the extent possible, hold employees accountable only for outcomes they control. It is a guideline rather than a law, because almost nothing is entirely within one person's control — but it is what motivates the flexible budget in Session 8 and the responsibility-centre structure below.

> Prof: Numbers make people do things. Once a number is used to evaluate people, it stops being a neutral description and becomes an instruction."""),

    ("madm_responsibility_centers", 7, "Responsibility Centres", """A responsibility centre is an organisational unit with well-specified decision rights and a performance measure consistent with those rights. Four standard forms, in increasing order of autonomy.

| Centre | Decision rights | Measure | Example |
|---|---|---|---|
| **Cost centre** | Controls inputs | Cost, or cost per unit of output | An Amazon warehouse, measured on cost per unit shipped |
| **Revenue centre** | Controls pricing and sales | Revenue, bookings | A Salesforce regional office |
| **Profit centre** | Controls cost, pricing and sales | Divisional profit; responsible for a P&L | The iPhone division |
| **Investment centre** | All of the above plus capital spending | ROI; responsible for a P&L and a balance sheet | GE Aviation |

**How to classify one.** Work through what the unit actually decides.

- Does it set prices and drive sales? If not, it is a cost centre.
- Does it also control its costs? If it sets price and volume but not cost, it is a revenue centre.
- Does it control capital expenditure and the asset base? Only then is it an investment centre.

> Trap: The exam's favourite case is a unit that sets its own fees, hires its own staff and chooses its own product line, while buildings and IT are provided and paid for centrally. It controls revenue and cost but not assets, so it is a **profit centre**, not an investment centre. Autonomy over operations is not autonomy over capital.

**Why the classification matters.** It fixes what the unit can fairly be judged on. Judging a cost centre on profit asks it to answer for prices it does not set; judging a profit centre on ROI asks it to answer for an asset base it did not choose."""),

    ("madm_budget_roles", 7, "What a Budget Is, and Its Three Roles", """A budget is a quantified plan that allocates resources and sets expectations for a period. The reason it generates so much behaviour is that it is three things at once:

- A **forecast** — the best guess of what will happen.
- A **contract** — the resources committed to the unit.
- A **target** — the number the manager is judged against.

**The three roles, and the tension between them.**

1. **Planning** — decide what to do and commit resources to it.
2. **Coordination** — align functions and communicate expectations, so manufacturing plans for what sales intends to sell.
3. **Performance evaluation** — hold managers accountable to the plan.

A good forecast and a tough target are rarely the same number. A forecast wants to be unbiased. A target wants to stretch. Ask one number to do both and it will do neither well — which is the source of essentially every budgeting pathology.

**The process is recursive and political.** Budgets are not built linearly. Each step goes through revisions and whole cycles get iterated, and the value comes from that iteration: intense examination of targets, assumptions being challenged, alternatives examined and choices made. The document at the end matters less than the argument that produced it."""),

    ("madm_master_budget", 7, "Building the Master Budget", """The master budget is built in a fixed order, because each piece needs the one before it.

**1. Revenue budget.** Forecast by customer, region and product. Triangulate: local on-the-ground knowledge, macro and industry trends, market research. Every downstream number inherits this forecast's error, which is why it is done first and argued about most.

**2. Production budget.** Convert sales into production with the inventory equation:

$$\\text{Production} = \\text{Sales} + \\text{Desired ending inventory} - \\text{Beginning inventory}$$

BuildIT: 8,000 lots to sell, 90 wanted at the end, 75 on hand, so 8,015 to produce. BuildIT-PLUS: 2,000 + 20 − 15 = 2,005.

**3. Input budgets.** Materials from the bill of materials, labour from the routing sheet, overhead from the cost of capacity. Materials run the inventory equation a second time, this time in kilograms or litres:

$$\\text{Purchases} = \\text{Quantity needed for production} + \\text{Ending raw material} - \\text{Beginning raw material}$$

**4. Cost of goods manufactured, then cost of goods sold.** The equation a third time:

$$\\text{COGS} = \\text{Beginning finished goods} + \\text{COGM} - \\text{Ending finished goods}$$

> Worked example: budgeting to produce 8,015 lots and sell 8,000 means finished goods inventory rises by 15 lots. Fifteen lots' worth of cost stays on the balance sheet, so variable COGS comes in **lower** than variable COGM.

**5. Period costs.** Selling and administrative costs are driven mostly by the sales plan and flow directly to the income statement. They never pass through inventory.

**6. Budgeted income statement.** Revenue, less variable COGS and variable marketing, gives contribution margin. Less fixed manufacturing and fixed marketing gives profit before taxes. Then taxes.

**Cash budget.** Separate from profit, and often the one that binds. Opening cash, plus collections split between the current period's sales and prior periods' receivables by the stated pattern, less payments for purchases and expenses on their own pattern, gives closing cash. A profitable month can still need a loan."""),

    ("madm_budget_behavior", 7, "Budget Games and Behavioural Effects", """The moment a budget is used to evaluate people, behaviour changes, because the same number now sets pay, status and next year's resources. Everything below is a rational response to that, not evidence of bad people.

**The ratchet effect.** Most firms anchor next year's target on this year's actual, which is easy and grounded in real operations. It also means beating your target hands you a harder one next year. So managers learn not to look too good — there is a ceiling on how much anyone will over-deliver.

**Participative budgeting: cure or cause?** Bottom-up budgeting taps local knowledge and builds buy-in and commitment. It also hands the information advantage to precisely the people who benefit from shading the numbers. Most firms end up with a mix of top-down and bottom-up, with goals set "tight but attainable".

**The four games.**

- **Sandbagging** — low-ball the sales or output target you will be judged on.
- **Padding** — build slack into the resources you request. A manager who privately believes she needs 10% less than she asks for is padding, and she can do it because she knows the number and headquarters does not.
- **Spending to avoid lapsing** — use it or lose it, so unspent budget gets spent in the last quarter whether or not it buys anything.
- **Timing games** — pull revenue forward or push costs back across the period boundary.

> Trap: Sandbagging and padding both create slack, and the exam distinguishes them by *what* is being shaded. Sandbagging low-balls the output or revenue target. Padding inflates the resources requested. The ratchet effect is neither — it is headquarters raising the target because of last year's result.

**Design responses, and their costs.** Paying for forecast accuracy instead of budget attainment buys honest numbers, removes any reason to stretch, and gives a manager who is about to miss a reason to make the miss happen. Not revising a target after an uncontrollable adverse event feels harsh, and the textbook's argument for holding firm is that defining a "big enough" event is a slippery slope, that managing risk is the job, and that nobody asks for a reset when the fire is in a competitor's plant."""),

    ("madm_flexible_budget", 8, "The Flexible Budget", """The flexible budget is the budget re-computed at the **actual** output volume: what would revenues and costs have been at the volume actually achieved, if everything else had gone as planned?

It exists to answer one objection. Comparing actual costs at 8,000 units against a budget built for 10,000 units compares two different things, and the comparison will show a cost saving whenever volume falls short — regardless of how the plant performed.

**How to build it.** Take the actual output. Apply the *budgeted* selling price, the *budgeted* variable cost per unit for each input, and the *budgeted* fixed cost total. Fixed costs do not flex; that is what makes them fixed.

Glass Vessels at 8,000 units instead of the budgeted 10,000: revenue $96,000, labour $32,000, material $24,000, variable overhead $4,000, fixed $14,000, total cost $74,000, profit $22,000.

**Why it is the fair standard.** It isolates the volume effect into a single number and leaves everything else clean. A plant manager judged against the static budget is answering for the sales team's shortfall. Judged against the flexible budget, she is answering only for what happened at the volume she was actually asked to produce.

> Trap: Total actual costs coming in under the static budget is not evidence of cost control. At Glass Vessels, actual costs of $78,400 against a static budget of $89,000 looked like a $10,600 saving. Against the flexible budget of $74,000 it is $4,400 of overspending."""),

    ("madm_variance_decomposition", 8, "The Variance Decomposition Tree", """A variance is the difference between an actual outcome and the budget. **Favourable (F)** means the actual result is better than budget, **unfavourable (U)** means worse. Variances are always expressed in money, never in kilograms or hours, so their relative importance is comparable.

**The top split.**

$$\\text{Total profit variance} = \\underbrace{\\text{Sales volume variance}}_{\\text{flexible} - \\text{static}} + \\underbrace{\\text{Flexible budget variance}}_{\\text{actual} - \\text{flexible}}$$

The sales volume variance is the profit given up purely because a different number of units was sold. It belongs to the revenue centre. The flexible budget variance is everything that went differently at the volume actually achieved, and it belongs to whoever ran the operation.

**Glass Vessels.** Master budget profit $31,000, flexible budget profit $22,000, actual profit $9,600. So $9,000 U of sales volume variance, $12,400 U of flexible budget variance, and $21,400 U in total.

**The tree below that.** The flexible budget variance splits into sales price variance, variable cost variance and fixed cost variance. The variable cost variance splits again into quantity (efficiency) and price (spending) components.

- Sales price variance = actual revenue − flexible budget revenue
- Fixed cost variance = budgeted fixed cost − actual fixed cost
- Variable cost variances split by input: labour, material, variable overhead

At Glass Vessels: sales price $8,000 U, labour $2,000 U, material $1,500 U, variable overhead $200 F, fixed $1,100 U. They sum to the $12,400 U.

**Reading it as a diagnosis.** The revenue shortfall of $32,000 against the static budget splits $24,000 to volume and $8,000 to price. Both sit with the revenue centre and they mean different things: one is a forecasting or market problem, the other is discounting discipline or pricing power."""),

    ("madm_sales_variances", 8, "Sales Volume and Sales Price Variances", """The two variances that belong to the revenue side, and the pair the exam most often asks you to separate.

**Sales volume variance** = flexible budget profit − master budget profit.

It captures the whole profit effect of selling a different number of units at budgeted prices and budgeted costs. Because the flexible budget uses budgeted contribution margin throughout, it can also be written as:

$$\\text{Sales volume variance} = (\\text{Actual units} - \\text{Budgeted units}) \\times \\text{Budgeted contribution margin per unit}$$

**Sales price variance** = actual revenue − flexible budget revenue.

Equivalently, the difference between actual and budgeted price times the units actually sold. It measures discounting or premium pricing on the volume achieved, and nothing else.

**Worked example, Glass Vessels.** Static revenue was $120,000 at 10,000 units and $12. Actual revenue was $88,000. The $32,000 shortfall splits: flexible revenue at 8,000 units and the budgeted price is $96,000, so $24,000 came from volume and $8,000 from price. The actual price was $11 rather than $12.

**A caution on reading them together.** A price cut that raises volume produces a favourable volume variance and an unfavourable price variance, and the net decides whether it was a good idea. The golf putter problem is the clean case: cutting price by $35 produced $85,200 F of volume variance and $196,000 U of price variance, so the price cut destroyed $110,800 of profit. Demand was less price-sensitive than the manager assumed.

> Trap: The sales volume variance is a **profit** variance, computed from contribution margin. The sales price variance is a **revenue** variance. Mixing the two bases is the most common arithmetic error on these questions."""),

    ("madm_input_variances", 8, "Splitting a Variable Cost Variance", """A variable cost came in over budget. Two possible reasons: more input was used than the standard allows, or each unit of input cost more than budgeted. Three columns separate them.

| Column | What it is | Name |
|---|---|---|
| BQ × BP | Standard input **for the actual output**, at standard price | Flexible budget |
| AQ × BP | Actual input used, at standard price | The "as if" budget |
| AQ × AP | Actual input used, at actual price | Actual |

$$\\text{Quantity (efficiency) variance} = (AQ - BQ) \\times BP \\qquad \\text{Price (spending) variance} = (AP - BP) \\times AQ$$

$$BQ = \\text{Actual output} \\times \\text{Standard input per unit of output}$$

The two variances always sum to the total variance for that input.

> Worked example: Glass Vessels labour. Standard is 0.4 hours per unit at $10, actual output 8,000 units, actual hours 4,400, actual cost $34,000. BQ is 3,200 hours, so the flexible budget is $32,000. The "as if" budget is 4,400 hours at $10, or $44,000. Quantity variance is $12,000 U, price variance is $10,000 F, and they net to the $2,000 U total.

> Worked example: the same drill for material. Standard 0.5 kg per unit at $6, output 8,000 units, actual usage 4,500 kg costing $25,500. BQ is 4,000 kg so the flexible budget is $24,000; the "as if" budget is $27,000. Quantity variance $3,000 U, price variance $1,500 F, total $1,500 U.

**Running it backwards.** Exam questions often give you the variances and ask for the actual quantity or actual price. Fill the three columns in order. Flexible budget is computable from the standards. Add or subtract the quantity variance to get the "as if" column, then divide by BP to recover AQ. Add or subtract the price variance to get actual cost, then divide by AQ to recover AP.

> Trap: BQ is not the original budget's input quantity. It is the input the standard allows **for the output actually produced**. Using the master budget's quantity here is the single most common mistake in this topic."""),

    ("madm_fixed_cost_variance", 8, "Fixed Cost and Variable Overhead Variances", """**Fixed cost spending variance** = budgeted fixed cost − actual fixed cost.

Fixed costs do not flex with volume, so the flexible budget figure is identical to the static budget figure and there is only one variance to compute. Actual fixed cost above budget is unfavourable.

There is no quantity-and-price split for a fixed cost, because there is no input quantity that varies with output. What a fixed cost variance tells you is that the committed capacity cost itself changed — a rent increase, an unbudgeted machine rental, a headcount addition, deferred maintenance.

**Reading a fixed cost variance properly.** It is the variance most easily gamed and most easily misread.

- A favourable fixed cost variance in the last month of the year often means deferred maintenance or postponed training, which shows up next period as downtime and unfavourable efficiency variances.
- An unfavourable fixed cost variance can be the best decision in the report. The golf putter case has a $50,000 U fixed cost variance from renting a milling machine, which bought $100,800 F of material quantity variance and $56,000 F of labour quantity variance — a net gain of $106,800.
- Fixed costs coming in under budget when volume was 20% below plan deserves a question rather than applause. Some of it may be spending that was avoided rather than saved.

**Variable overhead.** Treated like any other variable cost: it flexes with the activity base (usually labour hours or machine hours), and its variance can be split into a spending and an efficiency component using the same three columns. At Glass Vessels, budgeted at $1.25 per labour hour, the flexible budget at 8,000 units is $4,000 against actual of $3,800, a $200 F variance."""),

    ("madm_variance_interpretation", 8, "Variances as Signals, Not Verdicts", """A favourable variance is not automatically good news and an unfavourable one is not automatically bad. Variance analysis is where an investigation starts.

**Favourable numbers with unfavourable causes.**

- Favourable labour efficiency can mean rushed production, lower quality output, or undertrained workers cutting corners.
- Favourable material price can mean lower-quality inputs, or a supplier change carrying hidden risk. It can also just mean a bulk discount.
- Favourable fixed cost spending can mean deferred maintenance.

**Reading variances as one story.** Four Glass Vessels numbers, on one page: material price $1,500 F, material quantity $3,000 U, labour price $10,000 F, labour quantity $12,000 U. Read separately, purchasing looks excellent and production looks incompetent. Read together, the obvious hypothesis is that cheaper, lower-grade material and cheaper, less experienced labour generated waste and took longer. Investigate the purchasing decision first, not the plant.

**What each variance points at.**

| Variance | Question it raises |
|---|---|
| Sales price | Pricing power? Competitive pressure? Discounting discipline? |
| Sales volume | Forecasting failure? Market shift? |
| Labour efficiency | Process improvement opportunity? Automation? Training? |
| Material price | Supplier negotiation? A quality trade-off? |
| Fixed cost | Capacity discipline? A structural change? |

**Gaming.** Buy cheap inputs for a favourable price variance, defer maintenance to hit the cost target, pad the budget so the standard is soft, sacrifice long-term investment for this period's number. All of these are responses to how the variance is used.

**When variance analysis is less useful.** High fixed-cost environments where variable cost variances are immaterial; rapidly shifting demand where the budget is obsolete before the period ends; innovation-driven firms where variance discipline discourages experimentation; service and knowledge work where honest quantity standards are hard to define.

> Prof: Separate demand shock from execution, investigate root causes before assigning blame, and remember that not all variances deserve equal management attention."""),

    ("madm_abc_service_sector", 8, "Case: Buckeye National Bank", """The service-sector version of the Session 6 argument, and the case the class submitted.

**The situation.** Buckeye grew by serving small businesses, then shifted strategy to chase retail accounts and paid branch managers a bonus for hitting account-growth targets. Eighty per cent of managers hit their targets. More customers arrived. Profits kept falling. Net income went from $482 thousand to $408 thousand to $274 thousand over three years while noninterest expenses climbed.

**The old system.** All $2,850 thousand of indirect cost allocated on one base: the dollar value of checks processed. Retail wrote $9.5 million of the $95 million total, business wrote $85.5 million — 10% and 90%.

| | Retail | Business |
|---|---|---|
| Indirect cost assigned | $285 | $2,565 |
| Accounts | 150,000 | 50,000 |
| Indirect cost per account | $1.90 | $51.30 |
| Average revenue per account | $10.00 | $40.00 |
| Profit per account | $8.10 | −$11.30 |

The strategy follows directly: chase retail, tolerate business. Which is exactly what Buckeye did.

**What the allocation assumes.** That indirect cost is proportional to the dollar value of checks. Nothing about processing a check depends on the amount written on it. A $10 check and a $10,000 check consume the same processing.

**The ABC pilot.** Three activities.

| Activity | Pool | Driver | Rate |
|---|---|---|---|
| Paying checks | $1,140 | 2,850 thousand checks | $0.40 per check |
| Providing teller services | $1,200 | 200 thousand transactions | $6.00 per transaction |
| Responding to inquiries | $510 | 100 thousand calls | $5.10 per call |

Retail: 570 thousand checks, 160 thousand teller transactions, 95 thousand calls. Business: 2,280 thousand checks, 40 thousand teller transactions, 5 thousand calls.

| | Retail | Business |
|---|---|---|
| Paying checks | $228.0 | $912.0 |
| Teller services | $960.0 | $240.0 |
| Inquiries | $484.5 | $25.5 |
| Total | $1,672.5 | $1,177.5 |
| Per account | $11.15 | $23.55 |
| Profit per account | −$1.15 | $16.45 |

**Why the numbers move.** Business customers write four times the check value, which the old base charged them for. What actually costs money is walking into a branch and calling the service centre, and retail customers do 80% of the teller transactions and 95% of the calls on a quarter of the check volume. The old base measured transaction size; the activity drivers measure work performed.

**What Buckeye should do.** Not stop serving retail. The bonus plan is the immediate problem: paying branch managers for account count with no view of cost-to-serve pays them to add loss-making accounts. Then the Session 7 menu — minimum balance requirements and per-transaction fees, pushing routine retail activity to ATM and online channels so the driver quantities fall, and targeting the retail segments whose behaviour resembles the profitable accounts.

> Trap: The ABC rates are long-run average capacity costs. Ten more teller customers will not raise costs by $60 tomorrow — staff are already scheduled. The rates are the right input to a strategic question about product lines and pricing, and the wrong input to a short-run incremental one."""),

    ("madm_divisional_performance", 9, "ROI, Residual Income and EVA", """How an investment centre gets scored, and why the choice of measure changes what its manager does.

**Return on investment.**

$$\\text{ROI} = \\frac{\\text{Operating income}}{\\text{Assets employed}}$$

Simple, comparable across units of different sizes, and it creates an underinvestment problem. A manager earning 26% on $300,000 is offered a project adding $5,000 of income on $50,000 of assets. Her ROI falls from 26% to 23.7%, so she declines — even though the project earns 10% and may comfortably beat the firm's cost of capital.

The mirror image also happens. Measured on **profit alone**, managers accept any project with positive income, including ones earning less than the cost of capital, because they receive the benefit without being charged for the capital.

**Residual income.**

$$\\text{Residual income} = \\text{Operating income} - \\left( r \\times \\text{Assets} \\right)$$

Charging for capital fixes the underinvestment problem: any project earning more than $r$ raises residual income, so the manager's interest and the firm's coincide. The cost is comparability — a large division has a large residual income by construction, so it cannot be ranked against a small one.

**Economic value added.** Residual income made more precise: after-tax operating profit, a charge at the weighted average cost of capital, and adjustments to the asset base.

$$\\text{EVA} = \\text{Operating income} \\times (1 - t) - \\left( \\text{WACC} \\times (\\text{Assets} - \\text{Current liabilities}) \\right)$$

$$\\text{WACC} = (1 - t) \\times w_d \\times r_d + w_e \\times r_e$$

The strongest theoretical foundation and the most work to implement, particularly the GAAP adjustments.

> Trap: A high ROI can mean a small denominator. A business relying on personal service rather than modern facilities has old, heavily depreciated assets, so its book asset base is small and its ROI flattering. Compare ROI across divisions only when the asset bases are comparable in age and composition.

**The owner-manager contrast.** Owners take the long view and accept a project that dilutes this year's ROI. A hired division manager evaluated on year-over-year ROI does not. The gap is goal incongruence, and performance measures exist to narrow it — never to close it completely."""),

    ("madm_transfer_pricing_basics", 9, "What a Transfer Price Is", """When one division sells goods or services to another division of the same company, the internal price is the **transfer price**.

- To the **selling** division it is revenue. A higher transfer price raises its reported profit.
- To the **buying** division it is cost. A higher transfer price lowers its reported profit.

Because one division's revenue is the other's cost, **an internal transfer price does not change corporate pre-tax profit**. It only shifts profit between divisions.

**So why does it generate so much heat?** Because divisional profit is what everything else runs on.

- **Bonuses and promotions.** Divisional profit is the primary metric for evaluating a division manager.
- **Capital allocation.** Profitable divisions get investment; unprofitable ones get cut.
- **Sourcing decisions.** Whether to make or buy hinges on the transfer price the buying manager faces.
- **Divisional survival.** A division that looks persistently unprofitable gets shut or sold.

**The three questions in every transfer pricing problem.**

1. **Decision rights.** May divisions source externally when internal supply exists? If so, who sets the price?
2. **Goal congruence.** What transfer price leads autonomous managers, each maximising their own division's profit, to make the choice that is best for the company?
3. **Sourcing choice.** From the corporate perspective, is an internal transfer better than an external purchase at all?

**Three objectives, in tension.** A good system balances goal alignment, divisional autonomy and fair performance measurement. In practice no system achieves all three, which is why this is a design problem rather than a calculation.

> Trap: The zero-sum property holds only for pre-tax profit within one tax jurisdiction. Once divisions sit in different countries, the transfer price changes how much tax the group pays, and it stops being zero-sum."""),

    ("madm_tp_min_max", 9, "The Minimum and Maximum Transfer Price", """The general short-run framework, and almost every transfer pricing question reduces to it.

$$TP_{\\min} = \\text{Seller's incremental cost} + \\text{Seller's opportunity cost of the transfer}$$

$$TP_{\\max} = \\text{Cost of procuring externally} \\pm \\text{costs saved or incurred by buying internally}$$

If $TP_{\\min} < TP_{\\max}$ a **transfer zone** exists. The internal transfer creates value for the company, and any price inside the zone leads two autonomous, self-interested managers to agree to it. If $TP_{\\min} > TP_{\\max}$, no price exists that both accept — and that is the correct answer, not a negotiation failure. The company should buy outside.

**The corporate test is the same two numbers.** The seller's minimum *is* the true cost of making in-house, because it includes both the cash spent and the contribution given up. The buyer's maximum *is* the true cost of buying outside. Compare them and the sourcing decision follows.

**Adjusting the seller's side.** If the buying division wants a modified version, add the extra variable cost of modification. Tesla's battery division with a $600 modification goes from a $4,000 minimum to $4,600 — which pushes it above the buyer's $4,400 ceiling and flips the correct decision from make to buy.

**Adjusting the buyer's side.** Buying internally may avoid costs an external purchase would carry: incoming inspection, freight, expediting, quality risk. Those savings raise the ceiling. A buyer with a $1,000 outside quote who would avoid $60 of inspection and freight internally should accept up to $1,060.

> Trap: The fixed cost per unit is never in the minimum transfer price. Unitised fixed cost is sunk with respect to the transfer decision. It enters only when a corporate policy forces it in, and that is exactly what Session 10 shows going wrong.

**A caveat the professor stated.** This framework is for short-run decisions. Divisions will not make long-term commitments at a price that only covers incremental and opportunity cost, because over the long run capacity itself is a choice."""),

    ("madm_tp_capacity", 9, "Capacity and Opportunity Cost", """The seller's opportunity cost is the whole content of the transfer price, and it is determined by capacity.

| Situation | Opportunity cost per unit | Minimum TP |
|---|---|---|
| **Excess capacity** | Zero — nothing is displaced | Variable cost |
| **Full capacity** | Contribution margin lost on the displaced external sale | Variable cost + lost CM, which equals the market price |
| **Partial capacity** | Only the displacing units carry it, spread over all units transferred | Variable cost + weighted opportunity cost |
| **Constrained resource** | Contribution margin per unit of the constraint × constraint units used | Variable cost + that amount |

**Full capacity.** Tesla's battery division: variable cost $1,800, external price $4,000, at capacity. Every internal unit is an external unit not sold, so the opportunity cost is $2,200. Minimum TP is $4,000 — the market price. Against a $4,400 outside quote for the vehicle division, internal sourcing saves the firm $400 a unit.

**Excess capacity.** The same division able to sell only 150,000 of 300,000 units. Nothing is displaced, so the minimum falls to the $1,800 variable cost. Against a $3,000 outside quote, the zone runs from $1,800 to $3,000.

**Partial capacity, and which sale gets displaced.** Walker Inc. has 100,000 units of capacity, external demand of 50,000 at $170 plus a one-time order of 50,000 at $160, and Satellite wants 50,000 modified units costing $155 in variable cost. The transfer displaces the *marginal* order — the $160 one — so the opportunity cost is $160 − $140 = $20, the minimum TP is $175, and against Satellite's $180 outside price the transfer is still worth doing.

**A constrained resource.** Division A runs two products on one machine with 600 hours a month. Product 1 earns $6 of contribution per machine-hour, Product 2 earns $4, so the optimal mix fills Product 1's demand of 300 units first, then runs Product 2 for 150 units. Transferring 50 units of Product 1 takes 50 hours and displaces 25 units of Product 2, costing 25 × $8 = $200, or $4 per transferred unit. Minimum TP = $4 + $4 = $8, against Division B's external price of $9.

> Trap: Rank products by contribution margin **per unit of the constraint**, not per unit of product. Product 2 has the higher contribution margin per unit and the lower contribution per machine-hour, and the machine is what is scarce."""),

    ("madm_tp_policy", 10, "Transfer Pricing Policies", """Why have a policy at all? Because resolving disputes case by case pulls top management in constantly, which undermines the decentralisation the firm chose, consumes executive time, and asks central managers to arbitrate with local information they do not have.

**The three policies.**

| Policy | Strength | Weakness |
|---|---|---|
| **Market-based** | Objective, and equals the right answer at full capacity | Needs a competitive external market to exist |
| **Negotiated** | Preserves autonomy; uses the divisions' own information | Haggling, conflict, and outcomes driven by bargaining power |
| **Cost-based** (full cost or cost-plus) | Simple to administer and always available | Distorts sourcing decisions whenever sourcing is delegated |

Survey evidence from the deck: roughly 46% of firms use some form of cost-based transfer price — variable cost 5%, full cost 24%, cost-plus 17% — about 30% use market price, and about 24% negotiate.

**The danger of mandated full cost plus.** The worked example, and the practice final tests it directly.

Divisions may source where they like, and internal transfers are priced at the seller's budgeted full cost plus 10%. Division A's budgeted full cost is $350, being $150 of variable cost and $200 of unitised fixed cost, so the transfer price is $385. A has capacity of 100,000 and can sell only 70,000 externally. Division B needs 20,000 units and can buy outside at $300.

B compares $385 with $300 and buys outside. That is rational and it is wrong for the company: A has idle capacity, so the true incremental cost of internal supply is $150. Buying outside spends $300 to avoid a $150 cost, and the policy costs the firm $150 a unit, or $3 million.

> Trap: The manager is not at fault. Two features of the policy caused it — unitised fixed cost that is not incremental, and a mark-up that is pure internal profit — and the buying division treats the sum of both as its real cost of internal supply.

**The rule that falls out.** Cost-based policies are workable when sourcing is *mandated* internally, because then the price only moves reported profit and cannot change the decision. Once sourcing is delegated to divisions, cost-based prices regularly produce the wrong sourcing choice, and negotiated prices are the better default."""),

    ("madm_tp_negotiation", 10, "Negotiation, Holdup and Corporate Intervention", """**The Seth and Brenda case.** Seth's components division designed a custom part with Brenda's refrigerator division, spending $240,000 on design and mock-ups on nothing firmer than an understanding that he would be the front-runner in the bidding. He bid $230 a unit for 20,000 units a year, which is full cost plus about 15%. Brenda has outside bids near $170 and offers $200. Seth's division runs at 70% capacity and missed bonus last year.

The arithmetic per unit, against Brenda buying outside at $170, with Seth's variable cost at $125:

| Transfer price | $170 | $200 | $230 |
|---|---|---|---|
| Change in Seth's profit | $45 | $75 | $105 |
| Change in Brenda's profit | $0 | −$30 | −$60 |
| Change in corporate profit | $45 | $45 | $45 |

Corporate profit rises by $45 a unit — $900,000 a year — at every transfer price. The transfer creates real value because the internal variable cost is $125 against an external price of $170. The price only decides which division books the gain.

Note also that $230 sits above Brenda's external alternative, so it is outside any range she would rationally accept. The transfer zone here runs from $125 to $170.

**Should corporate intervene?**

| For | Against |
|---|---|
| Resolves the conflict quickly | Undermines the decentralisation the structure is built on |
| Ensures the value-creating transfer actually happens | Time-consuming, and HQ lacks the local information |
| | Sets a precedent that every future dispute gets escalated |

The exam-relevant point is the trade-off rather than a verdict. What must not happen is the transfer failing, because that destroys $45 a unit. Where inside the zone the price lands is a distribution question.

**The holdup problem.** Seth's real grievance is not the price. He sank $240,000 into an investment that has value only in this relationship, on a vague promise, and Brenda now holds the bargaining power. Relationship-specific investment plus incomplete commitment equals holdup.

The public example: Apple and GT Advanced in 2014. GT invested hundreds of millions in sapphire glass capacity for Apple, Apple pulled back, GT went bankrupt.

**The remedies are all ex ante.** Nothing fixes holdup after the money is sunk.

- A long-term purchase commitment or take-or-pay clause from the buying division.
- Cost sharing — the buyer co-funds the relationship-specific investment.
- Pre-agreed formula pricing, or a pre-agreed arbitration mechanism.
- Vertical integration, or an internal sourcing mandate for the item."""),

    ("madm_international_tp", 10, "International Transfer Pricing and Tax", """Once divisions sit in different tax jurisdictions, the transfer price stops being zero-sum for the group. Subsidiaries are taxed where they earn income and rates differ, so a multinational has two levers:

1. **Shift profits to low-tax countries** by setting low transfer prices on goods sold **to** those subsidiaries.
2. **Load costs into high-tax countries** by purchasing **from** low-tax affiliates at inflated transfer prices.

**The worked example.** Parts cost $40, assembly costs $20, the product sells for $100.

| Arrangement | US income | Irish income | Total tax | Effective rate |
|---|---|---|---|---|
| All in the US at 21% | $40 | — | $8.40 | 21.0% |
| Parts US, assembly Ireland at 12.5%, TP $60 | $20 | $20 | $6.70 | 16.75% |
| Same split, TP $40 at cost | $0 | $40 | $5.00 | 12.5% |

Pushing the transfer price down to cost moves all the profit to the low-tax jurisdiction. Which is precisely why firms are not free to choose it.

**Arm's-length pricing.** Most jurisdictions — the US, India, the OECD countries — require the transfer price to reflect what unrelated parties would charge. Acceptable methods include comparable uncontrolled price, cost-plus, profit-split, and advance pricing agreements negotiated with the authority in advance.

**OECD Pillar Two.** A 15% global minimum corporate tax from 2024 for groups above €750 million of revenue. If a subsidiary's effective rate falls below 15%, the parent's jurisdiction imposes a top-up tax. That caps the gain from profit shifting without ending transfer pricing disputes.

**Why intangibles are where the disputes are.** A factory cannot be moved to a tax haven; intellectual property can be transferred with a signature. The royalty then runs from the operating country, which takes the deduction, to the haven, which books the income — and there is rarely a comparable market price for a brand, an algorithm or a patent portfolio, so arm's-length pricing has little to anchor on.

**Apple and the Double Irish.** IP licensing income routed through two Irish entities with different tax residencies, so non-US profits landed with entities that had minimal taxable presence. Effective rates on some Irish profits reached 0.005%. The European Commission ruled in 2016 that Ireland had granted illegal state aid and ordered €13 billion in back taxes; the Court of Justice upheld it in 2024. Ireland closed the structure to new entrants in 2015. Google's Bermuda arrangement, Starbucks' Dutch royalty structure, Amazon's Luxembourg operations and the IRS disputes with Coca-Cola and Medtronic are all versions of the same argument, and all involve intangibles."""),
]

# ---------------------------------------------------------------------------
# Scenarios — the recurring fact patterns questions hang off.
# ---------------------------------------------------------------------------

SCENARIOS = [
    ("madm-sc-ab", 6, "Two Products, One Overhead Pool", """A firm makes two products that share $100,000 of overhead. It currently loses $5,000.

| | Product A | Product B |
|---|---|---|
| Price | $10 | $14 |
| Units sold | 15,000 | 5,000 |
| Direct cost per unit | $6 | $7 |
| Labour hours per unit | 0.5 | 0.6 |
| Orders placed | 15 | 50 |

Activity analysis splits the overhead into $30,000 at unit level driven by labour hours, $65,000 at batch level driven by orders, and $5,000 at product level split equally between the two lines.""", "Session 6 slides"),

    ("madm-sc-buckeye", 8, "Buckeye National Bank", """Buckeye allocates all $2,850 thousand of indirect cost on the dollar value of checks processed. Retail customers wrote $9.5 million of the $95 million total; business customers wrote $85.5 million. The bank has 150,000 retail and 50,000 business checking accounts, earning average annual revenue of $10 and $40 per account.

A pilot ABC study identified three activities:

| Activity | Cost pool | Total driver units |
|---|---|---|
| Paying checks | $1,140 | 2,850 thousand checks |
| Providing teller services | $1,200 | 200 thousand transactions |
| Responding to inquiries | $510 | 100 thousand calls |

Retail customers accounted for 570 thousand checks, 160 thousand teller transactions and 95 thousand inquiry calls. Business customers accounted for 2,280 thousand checks, 40 thousand teller transactions and 5 thousand calls.""", "Buckeye National Bank case, Session 8"),

    ("madm-sc-glass", 8, "Glass Vessels", """Budget assumptions: sales of 10,000 units at $12; labour of 0.4 hour per unit at $10 per hour; material of 0.5 kg per unit at $6 per kg; variable overhead of $1.25 per labour hour; fixed overhead of $14,000.

The master budget is therefore revenue $120,000, labour $40,000, material $30,000, variable overhead $5,000, fixed $14,000, total cost $89,000 and operating profit $31,000.

Actual results were 8,000 units sold: revenue $88,000, labour $34,000, material $25,500, variable overhead $3,800, fixed costs $15,100, total cost $78,400 and operating profit $9,600. Actual labour hours were 4,400 and actual material usage was 4,500 kg.""", "Session 8 slides"),

    ("madm-sc-hempstead", 8, "Hempstead Corporation", """Hempstead planned to make and sell 8,000 units at $150. Budgeted costs for 8,000 units were direct materials $480,000, direct labour $60,000, variable manufacturing overhead $150,000 and fixed manufacturing overhead $300,000 — a total of $990,000.

The sales team sold only 7,200 units and the plant produced 7,200. Actual results: sales revenue $1,152,000; direct materials $490,500; direct labour $69,600; variable manufacturing overhead $132,000; depreciation $24,000; other fixed manufacturing overhead $272,000; total costs $988,100; profit $163,900.

Labour was budgeted at $10 per hour and 0.75 hour per unit. The company actually paid for 6,200 labour hours.""", "Professor's practice final, questions 15-20"),

    ("madm-sc-p11", 9, "Divisions A and B: Product P11", """Division A produces P11 and sells it to external customers. Division B needs 1,000 units of a similar part.

| Division A | |
|---|---|
| Production capacity | 10,000 units |
| Demand for the product | 10,000 units |
| Selling price per unit | $50 |
| Variable production cost per unit | $20 |
| Fixed cost per unit (over 8,000 units) | $4 |
| Variable selling cost per unit | $5 |

Division B needs 1,000 units and currently pays an outside supplier $32 per unit. Division A incurs no variable selling cost on internal transfers.""", "Professor's practice final, questions 11-14"),

    ("madm-sc-tesla", 9, "Tesla: Battery and Vehicle Divisions", """The Battery Division has capacity of 300,000 units, variable cost of $1,800 per unit, unitised fixed cost of $700, and sells externally at $4,000.

The Vehicle Division needs 100,000 batteries and can buy them from an outside supplier at $4,400 per unit.""", "Session 9 slides"),

    ("madm-sc-walker", 9, "Walker Inc.", """The Circuit Division makes Circuit 222 with a variable cost of $140 and unitised fixed cost of $20. Capacity is 100,000 units.

The Satellite Division wants 50,000 units of a modified version, which costs $155 in variable cost to make. Satellite can buy the modified part externally at $180.""", "Session 9 slides"),

    ("madm-sc-fullcostplus", 10, "Mandated Full Cost Plus 10%", """Corporate policy lets divisions make their own procurement choices, internal or external, and prices any internal transfer at the selling division's budgeted full cost plus 10%.

Division A's budgeted full cost is $350 per unit — $150 of variable cost and $200 of fixed cost unitised over budgeted volume. Capacity is 100,000 units and A can sell only 70,000 externally.

Division B needs 20,000 units and can buy them from an external vendor at $300 each.""", "Session 10 slides"),

    ("madm-sc-sethbrenda", 10, "Seth and Brenda", """Seth's components division designed a custom part in collaboration with Brenda's refrigerator division, spending $240,000 on design and mock-ups. There was no payment for the design; the intent was that Seth would be the front-runner in the bidding.

Seth bid $230 per unit for 20,000 units annually, which is roughly full cost plus 15%. His accounting statement shows variable manufacturing cost of $125 and allocated manufacturing overhead of $75 per part. His division runs at about 70% of capacity.

Brenda has competitive outside bids at about $170 per unit and has offered $200. Both managers are evaluated largely on divisional performance.""", "Transfer Pricing case, Session 10"),
]

# ---------------------------------------------------------------------------
# Questions from the professor's own material: his practice final, the in-class quick checks,
# the assigned textbook problems and the two cases. `authored` filler lives in
# supabase/madm-practice-bank.py so the two are separable if the real exam turns out narrower.
# ---------------------------------------------------------------------------

QUESTIONS: list = []


def q(qid, topic, session, prompt, choices, correct, expl, hint=None, qtype="formula",
      difficulty=2, provenance="authored", source=None, scenario=None, order=None):
    QUESTIONS.append({
        "id": qid, "topic": topic, "session": session, "type": qtype, "difficulty": difficulty,
        "prompt": prompt, "choices": choices, "correct_answer": correct, "explanation": expl,
        "hint": hint, "provenance": provenance, "source": source,
        "scenario_id": scenario, "scenario_order": order,
    })


PF = "Professor's practice final"
QC = "In-class quick check"

# --- The professor's practice final, all 21, verbatim -----------------------

q("madm-pf01", "madm_budget_behavior", 7,
  "A division manager negotiates a cost budget that she privately believes is about 10% higher than what her division will actually need. Which term best describes this behaviour, and what makes it possible?",
  ["Padding (building budgetary slack): the manager exploits her information advantage over headquarters in a participative budgeting process.",
   "The ratchet effect: headquarters raised her budget because of her performance last year.",
   "A timing game: she is shifting costs from one period into another.",
   "Spending to avoid lapsing: she is using up the budget before year-end."],
  "Padding (building budgetary slack): the manager exploits her information advantage over headquarters in a participative budgeting process.",
  "**Padding** is inflating the resources you request so the target is easier to hit. It only works because the manager knows what the division really needs and headquarters does not — the information asymmetry that participative budgeting creates by design.\n\nThe other three are real games, but different ones. The ratchet effect is headquarters raising *your* target because you did well last year. A timing game shifts revenue or cost across the period boundary. Spending to avoid lapsing is burning unspent budget before it disappears.",
  "Ask what exactly is being shaded, and who holds the information that makes the shading possible.",
  qtype="case_fact", difficulty=1, provenance="prof_verbatim", source=PF)

q("madm-pf02", "madm_cost_hierarchy", 6,
  "In an activity-based costing system, which of the following is best classified as a batch-level cost?",
  ["Machine setup costs incurred each time a production run is started.",
   "Electricity used to run machines.",
   "The cost of maintaining and updating a product line's design specifications.",
   "Plant insurance and general administration costs."],
  "Machine setup costs incurred each time a production run is started.",
  "A batch-level cost is incurred once per run or order, no matter how many units the run contains. A setup is the textbook case.\n\n- Electricity to run machines scales with units — **unit level**.\n- Maintaining design specifications supports a product line for as long as it exists — **product level**.\n- Plant insurance and general administration sustain the business — **facility level**.",
  "Ask what has to happen one more time for the cost to be incurred again: one more unit, one more run, one more product line, or one more year in business.",
  qtype="case_fact", difficulty=1, provenance="prof_verbatim", source=PF)

q("madm-pf03", "madm_flexible_budget", 8,
  "A company's actual total costs for a month came in below the static (master) budget. Actual output, however, was well below the budgeted volume. Which statement best explains why this cost result is not, by itself, evidence of good cost control?",
  ["The static budget was built for a higher volume of output; actual costs should instead be compared with a flexible budget prepared for the actual volume.",
   "Favourable cost variances are always offset by unfavourable revenue variances.",
   "Total costs include fixed costs, which no manager can control.",
   "Cost variances are meaningless unless they are separated into price and quantity components."],
  "The static budget was built for a higher volume of output; actual costs should instead be compared with a flexible budget prepared for the actual volume.",
  "Producing less costs less. Comparing actual cost at the achieved volume against a budget built for a higher volume compares two different things, and it will report a saving whenever volume falls short — regardless of how the plant ran.\n\nThe flexible budget re-computes the budget at actual output, holding budgeted prices and standards fixed, which is the only comparison that isolates performance from volume.\n\nThe distractors are each wrong in an instructive way: cost and revenue variances are not mechanically linked; fixed costs are controllable over a longer horizon; and the price-quantity split is useful but is not what makes this comparison invalid.",
  "Ask whether the two numbers being compared were built for the same level of output.",
  qtype="case_fact", provenance="prof_verbatim", source=PF)

q("madm-pf04", "madm_customer_profitability", 7,
  "True or false: an ABC system may be used to measure the profitability or profit potential of a market segment, but not of an individual customer.",
  ["False", "True"],
  "False",
  "**False.** ABC assigns cost by the activities a cost object consumes, and an individual customer is a perfectly good cost object — the drivers are simply customer-level ones: orders placed, deliveries taken, sales visits, order changes, support calls, expedited shipments.\n\nThe textbook problems do exactly this. Quinn, Ralph, Sutliffe and Thorne are four named customers, each with a separate profit number, and Thorne turns out to be the only loss-maker.",
  "Ask whether an individual customer consumes measurable activities.",
  qtype="case_fact", difficulty=1, provenance="prof_verbatim", source=PF)

q("madm-pf05", "madm_variance_decomposition", 8,
  "Which of the following is not a component of the total profit variance?",
  ["All of the above are components of the total profit variance.",
   "Sales volume variance.",
   "Flexible budget variance.",
   "Sales price variance."],
  "All of the above are components of the total profit variance.",
  "All three are in the tree. Total profit variance splits into the **sales volume variance** and the **flexible budget variance**; the flexible budget variance then splits into the **sales price variance**, the variable cost variances and the fixed cost variance.\n\nSo the sales price variance is a component two levels down rather than one, but it is still part of the total.",
  "Draw the decomposition tree and check whether each named variance appears anywhere on it.",
  qtype="case_fact", difficulty=1, provenance="prof_verbatim", source=PF)

q("madm-pf06", "madm_transfer_pricing_basics", 9,
  "Which of the following describes the goal that should be pursued when setting transfer prices?",
  ["Establish incentives for autonomous division managers to make decisions that are in the overall organisation's best interests — goal congruence.",
   "Maximise profits of the buying division.",
   "Maximise profits of the selling division.",
   "Allow top management to become actively involved when calculating the proper dollar amounts."],
  "Establish incentives for autonomous division managers to make decisions that are in the overall organisation's best interests — goal congruence.",
  "A transfer price does not change corporate pre-tax profit — it moves profit from one division to the other. So maximising either division's profit is not a goal, it is just a choice about who gets credit.\n\nWhat the price does change is **behaviour**: which division sources where, and whether the value-creating transfer happens at all. Goal congruence is the objective.\n\nHaving top management set every price defeats the purpose of decentralisation and asks the centre to decide without the local information the divisions hold.",
  "Ask what a transfer price can actually change: not corporate profit, but the decisions autonomous managers make.",
  qtype="case_fact", difficulty=1, provenance="prof_verbatim", source=PF)

q("madm-pf07", "madm_cross_subsidy", 6,
  "A company produces two products: a low-volume specialty product made on a demand-pull basis, and a high-volume product pushed to inventory. A production-volume-based cost allocation system would tend to",
  ["Understate the product cost of the low-volume product.",
   "Accurately reflect the product cost of the two products.",
   "Overstate the product cost of the low-volume product.",
   "Understate the product cost of both products."],
  "Understate the product cost of the low-volume product.",
  "A volume-based system charges overhead in proportion to units, hours or machine time. The low-volume specialty product consumes a disproportionate share of **batch- and product-level** resources — setups, scheduling, order processing, design support — and volume-based allocation cannot see any of that.\n\nSo the specialty product is **undercosted** and the high-volume product is **overcosted**. That is the cross-subsidy, and it is why managers using such a system add more specialty products and consider dropping the one that is funding them.\n\nBoth products cannot be understated: the same pool is being divided, so an error in one direction for one product is the opposite error for the other.",
  "Think about what the specialty product consumes that has nothing to do with how many units it makes.",
  qtype="case_fact", provenance="prof_verbatim", source=PF)

q("madm-pf08", "madm_tp_policy", 10,
  "Division S manufactures a component that Division B can either buy internally or purchase from an outside vendor. Division S has substantial excess capacity. Corporate policy requires that all internal transfers be priced at Division S's full cost plus a markup. Both division managers are evaluated on divisional profit and are free to choose their sourcing. Which of the following best describes the fundamental problem with this policy?",
  ["It makes the transfer price overstate the true incremental cost of internal supply, so Division B may rationally outsource even when internal sourcing is cheaper for the company as a whole.",
   "It lets Division S recover its fixed costs twice — once through the transfer price and once through external sales.",
   "It reduces total corporate profit because the markup inflates the combined income reported by the two divisions.",
   "It eliminates Division B's incentive to negotiate, since a cost-based price is always below the outside vendor's price."],
  "It makes the transfer price overstate the true incremental cost of internal supply, so Division B may rationally outsource even when internal sourcing is cheaper for the company as a whole.",
  "With excess capacity, the true incremental cost of supplying internally is Division S's **variable cost** — nothing is displaced, so the opportunity cost is zero. Full cost plus a markup adds unitised fixed cost, which is not incremental, and a markup, which is pure internal profit.\n\nDivision B sees the inflated number, compares it with the outside price, and outsources. The manager is behaving correctly given the price she faces; the policy is at fault.\n\nThe worked version in class: full cost $350, transfer price $385, external vendor $300, true incremental cost $150. B buys outside and the firm loses $150 a unit.\n\nA markup on an internal transfer cannot inflate combined income — one division's revenue is the other's cost.",
  "Compare the mandated price with what supplying internally actually costs the company when capacity is idle.",
  qtype="case_fact", difficulty=3, provenance="prof_verbatim", source=PF)

q("madm-pf09", "madm_responsibility_centers", 7,
  "Which type of responsibility centre has the greatest amount of autonomy?",
  ["An investment centre.", "A revenue centre.", "A cost centre.", "A profit centre."],
  "An investment centre.",
  "Autonomy rises through the four forms as decision rights accumulate: a cost centre controls inputs, a revenue centre adds pricing and sales, a profit centre controls both cost and revenue, and an **investment centre** adds capital expenditure on top.\n\nThat last step is what distinguishes it — the investment centre is responsible for a balance sheet as well as a P&L, and is measured on ROI rather than profit.",
  "Order them by what the unit is allowed to decide, and ask which one gets to choose its own asset base.",
  qtype="case_fact", difficulty=1, provenance="prof_verbatim", source=PF)

q("madm-pf10", "madm_abc_mechanics", 6,
  "Rosenbrook's ABC system has three pools: Assembly, $477,900 over 29,500 machine hours; Packaging, $35,400 over 1,200 orders; Shipping, $45,778 over 748 shipments. Product TMX3 sells for $189.50, has direct cost of $79.80 per unit, and during the year had 280 units sold, 405 machine hours, 62 orders and 7 shipments. What is TMX3's ABC profit margin, to the nearest dollar?",
  ["$21,898", "$30,716", "$30,609", "$24,155"],
  "$21,898",
  "Work the three rates, then charge TMX3 for what it consumed.\n\n- Assembly: 477,900 / 29,500 = $16.20 per machine hour, so 405 hours cost $6,561\n- Packaging: 35,400 / 1,200 = $29.50 per order, so 62 orders cost $1,829\n- Shipping: 45,778 / 748 = $61.20 per shipment, so 7 shipments cost $428.40\n\nOverhead totals $8,818.40.\n\nRevenue is 280 x $189.50 = $53,060. Direct cost is 280 x $79.80 = $22,344. Total product cost is 22,344 + 8,818.40 = $31,162.40, so the margin is **$21,898** (21,897.60).\n\nThe wrong answers come from charging the product for a share of each pool based on units rather than on drivers actually consumed.",
  "Compute one rate per pool, then multiply each rate by the driver units this product consumed. Do not allocate by units sold.",
  difficulty=3, provenance="prof_verbatim", source=PF)

q("madm-pf11", "madm_tp_min_max", 9,
  "What is the minimum transfer price that would be acceptable to Division A?",
  ["$45", "$50", "$24", "$20"],
  "$45",
  "Division A is at capacity — demand of 10,000 units equals capacity of 10,000 — so every unit transferred is a unit not sold outside.\n\n- Incremental cost of an internal unit: $20 of variable production cost. The $5 variable selling cost is avoided on internal transfers.\n- Opportunity cost: the contribution margin given up on the displaced external sale, which is 50 − 20 − 5 = $25.\n\nMinimum TP = 20 + 25 = **$45**.\n\n$50 is the external price and ignores the selling cost saved. $20 is the variable cost with no opportunity cost, which would be right only with excess capacity. The $4 unitised fixed cost never belongs in the answer.",
  "Add the incremental cost of an internal unit to the contribution margin given up on the external sale it displaces.",
  difficulty=3, provenance="prof_verbatim", source=PF, scenario="madm-sc-p11", order=1)

q("madm-pf12", "madm_tp_min_max", 9,
  "What is the maximum transfer price Division B should be willing to pay Division A for its product?",
  ["$32", "$24", "$20", "$25"],
  "$32",
  "The buyer's ceiling is what it costs to get the part elsewhere. Division B currently pays an outside supplier **$32**, and it would never pay more internally than that.\n\nThere is no adjustment here: the problem gives no costs that internal sourcing would avoid or add on B's side. When such costs exist — avoided inspection or freight, extra handling — they move the ceiling up or down from the external price.\n\nDivision A's costs are irrelevant to B's ceiling. They set the floor, not the cap.",
  "The buyer's ceiling comes from the buyer's alternative, not from the seller's cost sheet.",
  difficulty=1, provenance="prof_verbatim", source=PF, scenario="madm-sc-p11", order=2)

q("madm-pf13", "madm_tp_capacity", 9,
  "To maximise corporate profits, should P11 be produced internally in Division A or procured from the external supplier?",
  ["Procure externally.", "Produce internally in Division A.",
   "Does not matter for corporate profits.", "Produce internally, but only up to Division A's spare capacity."],
  "Procure externally.",
  "The two limits are also the corporate numbers. The seller's minimum, $45, **is** the true cost of making the unit in-house — cash cost plus the contribution given up. The buyer's maximum, $32, **is** the cost of buying it outside.\n\nSince 45 > 32, no transfer price exists that both divisions would accept, and that is the correct signal: making it internally costs the company more than buying it. Procure externally.\n\nDivision A has no spare capacity here, so the last option describes a quantity that does not exist.",
  "Compare the seller's minimum with the buyer's maximum. If the minimum is higher, there is no zone and no transfer.",
  qtype="case_fact", provenance="prof_verbatim", source=PF, scenario="madm-sc-p11", order=3)

q("madm-pf14", "madm_tp_capacity", 9,
  "Now suppose demand for Division A's product is limited to 8,000 units, with all other facts unchanged. Compute the change in corporate profit if Division B procures 1,000 units of P11 from Division A rather than externally.",
  ["$12,000 increase", "$7,000 increase", "$3,000 increase", "$3,000 decrease"],
  "$12,000 increase",
  "Demand of 8,000 against capacity of 10,000 leaves 2,000 units of spare capacity, so the 1,000 units transferred displace no external sale and the opportunity cost is zero.\n\n- Corporate cost of producing internally: $20 of variable production cost (no variable selling cost on an internal transfer)\n- Corporate cost of procuring externally: $32\n\nSaving of $12 per unit on 1,000 units = **$12,000 increase**.\n\nNote how completely the answer flipped from the previous question. Nothing changed except capacity utilisation — and capacity is what determines the opportunity cost, which is the whole content of the transfer price.",
  "With spare capacity the opportunity cost is zero, so compare the seller's variable cost against the external price.",
  difficulty=3, provenance="prof_verbatim", source=PF, scenario="madm-sc-p11", order=4)

q("madm-pf15", "madm_variance_decomposition", 8,
  "What was Hempstead's total profit variance?",
  ["$46,100 U", "$4,900 F", "$51,000 U", "$48,000 U"],
  "$46,100 U",
  "Total profit variance = actual profit − master budget profit.\n\nMaster budget profit: 8,000 units x $150 = $1,200,000 of revenue, less budgeted costs of $990,000, giving $210,000.\n\nActual profit was $163,900.\n\n163,900 − 210,000 = **$46,100 U**.\n\nIt is unfavourable even though actual total costs of $988,100 came in below the $990,000 budget — which is the point of the question. The cost comparison is against a budget built for 8,000 units when only 7,200 were made.",
  "Start from the master budget profit at 8,000 units, then compare it with the actual profit. Nothing flexes yet.",
  provenance="prof_verbatim", source=PF, scenario="madm-sc-hempstead", order=1)

q("madm-pf16", "madm_variance_decomposition", 8,
  "What was Hempstead's total cost variance?",
  ["$67,100 U", "$0", "$45,000 U", "$1,900 F"],
  "$67,100 U",
  "The cost variance is measured against the **flexible** budget, at the 7,200 units actually made.\n\nBudgeted variable cost per unit: (480,000 + 60,000 + 150,000) / 8,000 = $86.25. At 7,200 units that is $621,000. Fixed cost does not flex, so it stays at $300,000. Flexible budget total cost = $921,000.\n\nActual total cost was $988,100.\n\n988,100 − 921,000 = **$67,100 U**.\n\nThe $1,900 F distractor is the comparison against the static budget of $990,000 — exactly the mistake the question is testing.",
  "Flex the variable costs to 7,200 units, leave fixed cost alone, then compare with actual.",
  difficulty=3, provenance="prof_verbatim", source=PF, scenario="madm-sc-hempstead", order=2)

q("madm-pf17", "madm_input_variances", 8,
  "Determine whether Hempstead's total direct material variance is favourable or unfavourable, and by how much.",
  ["$58,500 U", "$10,500 U", "$58,500 F", "$34,500 U"],
  "$58,500 U",
  "Flex the material budget to actual output first. Budgeted material is 480,000 / 8,000 = $60 per unit, so at 7,200 units the flexible budget is **$432,000**.\n\nActual material cost was $490,500.\n\n490,500 − 432,000 = **$58,500 U**.\n\nThe $10,500 U distractor is the static-budget comparison, 490,500 against 480,000 — which credits the plant for the 800 units it did not have to make.",
  "The flexible budget for materials is the standard cost per unit times the units actually produced.",
  provenance="prof_verbatim", source=PF, scenario="madm-sc-hempstead", order=3)

q("madm-pf18", "madm_sales_variances", 8,
  "Determine Hempstead's sales price variance.",
  ["$72,000 F", "$51,000 U", "$10,500 F", "$120,000 U"],
  "$72,000 F",
  "The sales price variance compares actual revenue with the flexible budget revenue at the same volume.\n\nFlexible budget revenue: 7,200 units x $150 = $1,080,000. Actual revenue was $1,152,000.\n\n1,152,000 − 1,080,000 = **$72,000 F**. The actual price was $160 per unit rather than the budgeted $150.\n\nThe $120,000 U distractor is the static comparison — 1,152,000 against 1,200,000 — which mixes the volume shortfall into a price number.",
  "Hold volume at what was actually sold and ask only what the price did.",
  provenance="prof_verbatim", source=PF, scenario="madm-sc-hempstead", order=4)

q("madm-pf19", "madm_input_variances", 8,
  "Hempstead budgeted labour at $10 per hour and 0.75 hour per unit, and actually paid for 6,200 hours. Calculate the labour quantity variance.",
  ["$8,000 U", "$3,300 F", "$4,500 U", "$5,000 U"],
  "$8,000 U",
  "BQ is the standard input for the output actually produced: 7,200 units x 0.75 hour = **5,400 hours**.\n\nQuantity variance = (AQ − BQ) x BP = (6,200 − 5,400) x $10 = **$8,000 U**.\n\nThe common error is using 8,000 units x 0.75 = 6,000 hours from the master budget, which gives $2,000 U. BQ always flexes to actual output.",
  "Work out how many hours the standard allows for 7,200 units, then compare with the hours actually paid for.",
  difficulty=3, provenance="prof_verbatim", source=PF, scenario="madm-sc-hempstead", order=5)

q("madm-pf20", "madm_input_variances", 8,
  "Using the same labour data, calculate Hempstead's labour price variance.",
  ["$7,600 U", "$10,600 U", "$3,600 U", "$3,300 F"],
  "$7,600 U",
  "Easiest route is the total minus the quantity component.\n\nFlexible budget labour: 7,200 units x 0.75 hour x $10 = $54,000. Actual labour cost was $69,600, so the total labour variance is $15,600 U.\n\nThe quantity variance was $8,000 U, so the price variance is 15,600 − 8,000 = **$7,600 U**.\n\nDirectly: the actual rate was 69,600 / 6,200 = $11.2258 per hour, and (11.2258 − 10) x 6,200 = $7,600 U.",
  "Total variance minus the quantity variance leaves the price variance. Both must be labelled F or U.",
  difficulty=3, provenance="prof_verbatim", source=PF, scenario="madm-sc-hempstead", order=6)

q("madm-pf21", "madm_master_budget", 7,
  "Meridian Housewares budgets sales of 20,000 units for the fourth quarter. Finished-goods inventory is expected to be 1,500 units at the start and the company wants 2,500 units at the end. Each unit requires 2 kg of resin costing $4 per kg. Resin inventory is expected to be 2,000 kg at the start and the company wants 5,000 kg at the end. What is the budgeted cost of resin purchases for the quarter?",
  ["$180,000", "$156,000", "$160,000", "$168,000"],
  "$180,000",
  "Two applications of the inventory equation, one in units and one in kilograms.\n\n1. Production = sales + ending FG − beginning FG = 20,000 + 2,500 − 1,500 = **21,000 units**\n2. Resin needed for production = 21,000 x 2 kg = **42,000 kg**\n3. Purchases = needed + ending RM − beginning RM = 42,000 + 5,000 − 2,000 = **45,000 kg**\n4. Cost = 45,000 x $4 = **$180,000**\n\nSkipping step 1 and going straight from 20,000 units of sales gives 43,000 kg and $172,000. Skipping step 3 gives $168,000. The equation has to run twice.",
  "Convert sales to production first, then convert production to purchases. Two separate inventory adjustments.",
  difficulty=3, provenance="prof_verbatim", source=PF)

# --- The in-class quick checks ---------------------------------------------

q("madm-qc01", "madm_relevant_cost_horizon", 6,
  "The copying function is a stand-alone business. Variable cost is two cents a page and full cost is four cents. A one-time order arrives for 10,000 extra pages next month, and the machine has spare capacity. What is the minimum acceptable price per page?",
  ["Variable cost", "Full cost", "Full cost plus a normal margin", "Whatever the outside vendor charges"],
  "Variable cost",
  "The capacity is already in place and already paid for. Nothing about accepting this order changes the machine, the wages or the overhead — the only cash that moves is ink and paper, at two cents a page.\n\nAny price above two cents leaves the business better off than refusing.\n\nFull cost would be the right floor for a long-run decision, where the capacity itself is up for review. The one-time nature of the order and the spare capacity are what make this the short-run case.",
  "Ask which costs actually change if the order is accepted.",
  qtype="case_fact", difficulty=1, provenance="prof_verbatim", source=QC)

q("madm-qc02", "madm_cost_hierarchy", 6,
  "A furniture maker re-programs its CNC machines every time it starts a new production run of a chair model. The programming cost is:",
  ["Batch-level", "Unit-level", "Product-level", "Facility-level"],
  "Batch-level",
  "The trigger is *starting a production run*, not making a chair and not keeping the model in the catalogue. A run of 10 chairs and a run of 1,000 chairs each need the programming once, so the cost scales with the number of runs — **batch level**.\n\nProduct level is the tempting wrong answer. It would be right for the cost of *designing* the chair model, which happens once for the model however many runs follow.",
  "Count how many times the cost is incurred: once per chair, once per run, once per model, or once per year.",
  qtype="case_fact", provenance="prof_verbatim", source=QC)

q("madm-qc03", "madm_abc_mechanics", 6,
  "Product B's 5,000 units currently arrive as 50 small orders, and the batch-level rate is $1,000 per order. Suppose minimum-order sizes consolidate them into 10 large orders. Roughly how much batch-level cost does B shed?",
  ["$40,000", "$8,000", "$50,000", "Nothing — batch costs are fixed"],
  "$40,000",
  "B currently absorbs 50 x $1,000 = $50,000 of batch cost. At 10 orders it would absorb 10 x $1,000 = $10,000.\n\nThe reduction is **$40,000**, which is most of the $5.21 per unit loss ABC revealed. Eight dollars a unit of the batch charge disappears without touching the price, the product or the volume.\n\nThe fourth option is the important distractor. Batch costs are not fixed with respect to the number of batches — that is exactly what makes them batch level. They are fixed with respect to units within a batch.",
  "Recompute B's batch charge at the new order count and take the difference.",
  provenance="prof_verbatim", source=QC, scenario="madm-sc-ab", order=3)

q("madm-qc04", "madm_abc_implementation", 6,
  "Which company would benefit least from implementing ABC?",
  ["A cement plant producing a single commodity product",
   "A job shop making hundreds of custom orders",
   "A bank serving many different customer segments",
   "An electronics firm with both high- and low-volume product lines"],
  "A cement plant producing a single commodity product",
  "ABC corrects distortions caused by **diversity**. With one product there is nothing to reallocate — every allocation method assigns 100% of overhead to the same place, so a single plantwide rate is already exactly right.\n\nThe other three are the classic candidates. The job shop has hundreds of different batch profiles. The bank has segments with wildly different transaction behaviour, which is the Buckeye case. The electronics firm has the high-volume and low-volume mix that produces cross-subsidy.",
  "Ask what ABC actually fixes, then ask which of these firms has that problem.",
  qtype="case_fact", difficulty=1, provenance="prof_verbatim", source=QC)

q("madm-qc05", "madm_responsibility_centers", 7,
  "A university's executive-education arm sets its own programme fees, hires its own faculty and staff, and decides which programmes to run. Its buildings, IT and other facilities are provided and paid for centrally. It is best described as a:",
  ["Profit centre", "Cost centre", "Revenue centre", "Investment centre"],
  "Profit centre",
  "Work through the decision rights. It sets prices and chooses its product line, so it controls revenue. It hires its own people and chooses its programmes, so it controls its own costs. Both together make it responsible for a P&L — a **profit centre**.\n\nIt is not an investment centre, because it does not control the asset base. Buildings and IT are provided and paid for centrally, so it never decides on capital expenditure and could not fairly be measured on return on investment.\n\nOperational autonomy is not the same as capital autonomy, and that distinction is the whole answer.",
  "Ask which of the four things it controls: inputs, prices, costs, and capital.",
  qtype="case_fact", provenance="prof_verbatim", source=QC)

q("madm-qc06", "madm_master_budget", 7,
  "A company is budgeted to produce 8,015 lots of BuildIT but to sell 8,000. Compared with variable cost of goods manufactured, this period's variable cost of goods sold will be:",
  ["Lower", "Higher", "The same", "Cannot tell"],
  "Lower",
  "COGS = beginning finished goods + COGM − ending finished goods.\n\nProducing 15 more lots than are sold means finished-goods inventory **rises** by 15 lots. That inventory increase is a cost that stays on the balance sheet rather than flowing through the income statement, so COGS comes in below COGM by fifteen lots' worth of variable cost.\n\nThe reverse happens when a firm sells out of inventory: production below sales makes COGS exceed COGM.",
  "Use the inventory equation. Ask whether inventory is rising or falling.",
  qtype="case_fact", provenance="prof_verbatim", source=QC)

q("madm-qc07", "madm_flexible_budget", 8,
  "A colleague looks at the Glass Vessels numbers and says: total costs came in at $78,400 against a budget of $89,000, so production saved us $10,600 — great execution. Is she right?",
  ["No", "Yes", "Cannot tell from these numbers", "Yes, but only because fixed costs were also lower"],
  "No",
  "Volume was 8,000 units against a budget of 10,000 — 20% below plan. Of course costs were lower; the plant made 2,000 fewer units.\n\nThe fair comparison is against the flexible budget, which re-costs the plan at 8,000 units: total cost of $74,000. Actual cost was $78,400, so production **overspent by $4,400**, the opposite of the conclusion drawn.\n\nThe third option is the near-miss. There is enough information here: the standards and the actual volume are all that a flexible budget needs.",
  "Ask whether the two numbers being compared were built for the same output volume.",
  qtype="case_fact", provenance="prof_verbatim", source=QC, scenario="madm-sc-glass", order=1)

q("madm-qc08", "madm_sales_variances", 8,
  "Glass Vessels budgeted revenue of $120,000 — 10,000 units at $12 — and reported actual revenue of $88,000, a shortfall of $32,000. How does that shortfall split between volume and price?",
  ["$24,000 volume, $8,000 price", "All $32,000 reflects lower volume",
   "$8,000 volume, $24,000 price", "Cannot tell without more data"],
  "$24,000 volume, $8,000 price",
  "Insert the flexible budget between the two. At the 8,000 units actually sold and the budgeted price of $12, revenue would have been $96,000.\n\n- Volume: 120,000 − 96,000 = **$24,000** of the shortfall came from selling 2,000 fewer units\n- Price: 96,000 − 88,000 = **$8,000** came from selling at $11 rather than $12\n\nThey sum to the $32,000. Both belong to the revenue centre, but they raise different questions: one is forecasting or market demand, the other is discounting discipline.",
  "Build the middle column — actual units at the budgeted price — and take the two differences.",
  provenance="prof_verbatim", source=QC, scenario="madm-sc-glass", order=2)

q("madm-qc09", "madm_input_variances", 8,
  "Glass Vessels budgets 0.5 kg of material per unit at $6 per kg, produced 8,000 units, and actually used 4,500 kg at a total cost of $25,500. What is the material quantity variance?",
  ["$3,000 U", "$1,500 U", "$1,500 F", "$3,000 F"],
  "$3,000 U",
  "BQ is the standard input for the output actually produced: 8,000 x 0.5 = **4,000 kg**.\n\nQuantity variance = (AQ − BQ) x BP = (4,500 − 4,000) x $6 = **$3,000 U**.\n\nFor completeness: the flexible budget is $24,000, the as-if budget is 4,500 x $6 = $27,000, and actual is $25,500. So the price variance is $1,500 F and the total material variance is $1,500 U — which is the $1,500 U sitting on the variance report line.",
  "Compute the kilograms the standard allows for 8,000 units, then value the difference at the budgeted price.",
  provenance="prof_verbatim", source=QC, scenario="madm-sc-glass", order=3)

q("madm-qc10", "madm_variance_interpretation", 8,
  "Glass Vessels reports a material price variance of $1,500 F, a material quantity variance of $3,000 U, a labour price variance of $10,000 F and a labour quantity variance of $12,000 U. What single story would you investigate first?",
  ["Purchasing bought cheaper, lower-grade material that generated waste.",
   "The variances are unrelated — investigate each separately.",
   "Production workers underperformed because they were lower skilled.",
   "The labour standard was set too tight."],
  "Purchasing bought cheaper, lower-grade material that generated waste.",
  "Both price variances are favourable and both quantity variances are unfavourable. That pattern is the signature of a quality trade-off: a cheaper input costs less per kilogram and produces more scrap, which drives both material usage and labour hours up.\n\nInvestigating each separately misses the connection, and would credit purchasing while blaming production for a consequence of purchasing's decision.\n\nThe lower-skilled labour story explains the labour pair on its own but says nothing about material usage. A tight standard would show as unfavourable quantity with no reason for favourable prices.",
  "Look at the pattern across all four rather than each number alone. What single decision would produce that pattern?",
  qtype="case_fact", difficulty=3, provenance="prof_verbatim", source=QC, scenario="madm-sc-glass", order=4)

q("madm-qc11", "madm_variance_interpretation", 8,
  "A plant manager behind on his annual cost targets postpones scheduled preventive maintenance in December and switches to a cheaper discount material supplier. What shows up in the December variance report, and in Q1?",
  ["Fixed cost F and material price F now; downtime, material quantity U and labour efficiency U later",
   "Fixed cost U now; favourable variances later",
   "No effect — total spending is unchanged",
   "Material quantity F now; material price U later"],
  "Fixed cost F and material price F now; downtime, material quantity U and labour efficiency U later",
  "Both moves buy favourable variances in the month they are taken. Skipping maintenance leaves fixed spending below budget; the cheaper supplier leaves the material price variance favourable.\n\nBoth bills arrive later. Deferred maintenance becomes unplanned downtime and unfavourable efficiency. Lower-grade material becomes scrap and rework, showing as unfavourable material quantity and labour efficiency.\n\nThis is why a favourable variance in the last period of a measurement cycle deserves more suspicion than an unfavourable one.",
  "Ask what each action does to this month's report, then ask what it does to the machine and the material next quarter.",
  qtype="case_fact", provenance="prof_verbatim", source=QC)

q("madm-qc12", "madm_tp_min_max", 9,
  "The Vehicle Division's battery specification differs from the standard version, and modifying the standard battery costs an additional $600 in variable cost. All other Tesla facts are unchanged — variable cost $1,800, external price $4,000, full capacity. What minimum transfer price would be acceptable to the Battery Division?",
  ["$4,600", "$4,000", "$1,800", "$2,400"],
  "$4,600",
  "Minimum TP = incremental cost + opportunity cost.\n\n- Incremental cost is now 1,800 + 600 = **$2,400**\n- The division is still at capacity, so every internal unit displaces an external sale. The opportunity cost is the contribution given up: 4,000 − 1,800 = **$2,200**\n\nMinimum TP = 2,400 + 2,200 = **$4,600**.\n\nThe modification cost is added to the incremental cost only — it does not change the contribution lost on the standard unit that is no longer sold.",
  "Add the modification to the incremental cost. The opportunity cost is still the margin on the standard external sale.",
  difficulty=3, provenance="prof_verbatim", source=QC, scenario="madm-sc-tesla", order=2)

q("madm-qc13", "madm_tp_capacity", 9,
  "With the $600 modification cost included, and the Vehicle Division able to buy outside at $4,400, what is the optimal sourcing choice from the corporate perspective?",
  ["Buy externally", "Make internally", "Make vs buy has no effect on corporate profit",
   "Make internally and raise the external price"],
  "Buy externally",
  "The seller's minimum of $4,600 is the true corporate cost of making the modified battery in-house. The buyer's maximum of $4,400 is the true cost of buying it.\n\nSince 4,600 > 4,400, there is no transfer zone: **buy externally**, and the firm saves $200 a unit by doing so.\n\nWithout the modification the answer was the opposite — make internally, saving $400 a unit. A $600 change in incremental cost flipped the decision, which is exactly why the framework works from incremental and opportunity cost rather than from full cost or from habit.",
  "The seller's minimum is the cost of making; the buyer's maximum is the cost of buying. Compare them.",
  qtype="case_fact", provenance="prof_verbatim", source=QC, scenario="madm-sc-tesla", order=3)

q("madm-qc14", "madm_tp_min_max", 9,
  "You are the buying manager in a division that needs a housing part. An external supplier offers it at $1,000 per unit. Another division has offered to make it, and procuring internally would avoid $60 per unit of incoming inspection and freight that an external purchase requires. What is the maximum transfer price you should accept?",
  ["$1,060", "$940", "$1,000", "The supplying division's variable cost"],
  "$1,060",
  "The ceiling is the cost of the alternative, adjusted for what changes if you source internally.\n\nBuying outside costs 1,000 + 60 = $1,060 all-in. Buying inside costs the transfer price and nothing else. So you are indifferent at a transfer price of **$1,060**, and better off below it.\n\n$940 is the same adjustment applied backwards. $1,000 ignores the avoided costs. The supplying division's variable cost sets the floor, not the ceiling.",
  "Compare the all-in cost of the external option with the all-in cost of the internal one.",
  provenance="prof_verbatim", source=QC)

q("madm-qc15", "madm_tp_capacity", 9,
  "The Battery Division has capacity of 300,000 units, variable cost of $1,800 and an external price of $4,000, and is at full capacity. The Vehicle Division needs 100,000 batteries and can buy them outside at $4,400. Should the Vehicle Division buy internally or externally?",
  ["It depends on the transfer price for the divisions, but internal sourcing is right for the company",
   "Buy internally — it is cheaper at $4,000 against $4,400",
   "Buy externally — do not disrupt the Battery Division's sales",
   "Indifferent, since a transfer does not change corporate profit"],
  "It depends on the transfer price for the divisions, but internal sourcing is right for the company",
  "Two separate questions hide inside this one.\n\n**For the company**: the true cost of making internally is variable cost plus the contribution given up, 1,800 + 2,200 = $4,000, against $4,400 to buy. Internal sourcing saves $400 a unit.\n\n**For the divisions**: whether they actually choose it depends on where the transfer price lands. Anything between $4,000 and $4,400 gets two self-interested managers to the right answer. Anything outside that range gets one of them to refuse.\n\nThe second option is right about the direction and wrong about the reasoning — $4,000 is the market price, and it happens to equal the true cost only because the division is at capacity.",
  "Separate what is best for the company from what autonomous managers will actually do.",
  qtype="case_fact", difficulty=3, provenance="prof_verbatim", source=QC, scenario="madm-sc-tesla", order=1)

# --- The cases -------------------------------------------------------------

BNB = "Buckeye National Bank case"
TPC = "Transfer Pricing case"

q("madm-bnb01", "madm_abc_service_sector", 8,
  "Under Buckeye's original cost system, what is the single indirect cost allocation rate, and what does it assume?",
  ["$0.03 per dollar of checks processed — it assumes indirect cost rises with the value written on a check",
   "$14.25 per account — it assumes indirect cost rises with the number of accounts",
   "$1.00 per check processed — it assumes indirect cost rises with the number of checks",
   "$0.40 per check processed — it assumes each check consumes the same processing"],
  "$0.03 per dollar of checks processed — it assumes indirect cost rises with the value written on a check",
  "The rate is total indirect cost divided by the base: 2,850 / 95,000 = $0.03 per dollar of checks processed.\n\nThe assumption buried in it is that indirect cost is proportional to the **dollar value** of the checks a customer writes. Nothing about processing a check depends on the amount written on it: a small check and a large one consume the same handling, and neither has anything to do with walking into a branch or calling the service centre.\n\nThe $0.40 rate is the ABC rate for the paying-checks activity, which is a different and far more defensible number.",
  "Divide the pool by the base the bank actually uses, then ask what has to be true for that base to work.",
  qtype="case_fact", provenance="prof_adapted", source=BNB, scenario="madm-sc-buckeye", order=1)

q("madm-bnb02", "madm_abc_service_sector", 8,
  "Under the original system, what is the indirect cost per retail account and per business account at Buckeye?",
  ["$1.90 retail, $51.30 business", "$11.15 retail, $23.55 business",
   "$14.25 retail, $14.25 business", "$1.90 business, $51.30 retail"],
  "$1.90 retail, $51.30 business",
  "Retail wrote $9.5 million of the $95 million total, so 10% of the $2,850 thousand pool — $285 thousand — spread over 150,000 accounts is **$1.90** an account.\n\nBusiness wrote 90%, so $2,565 thousand over 50,000 accounts is **$51.30**.\n\nAgainst average revenue of $10 and $40, that reports a profit of $8.10 per retail account and a loss of $11.30 per business account — and it is what drove the bank's strategy of chasing retail. The other pair is the ABC answer, which reverses it.",
  "Split the pool by check value, then divide each half by that line's account count.",
  provenance="prof_adapted", source=BNB, scenario="madm-sc-buckeye", order=2)

q("madm-bnb03", "madm_abc_service_sector", 8,
  "What are Buckeye's three ABC activity rates?",
  ["$0.40 per check, $6.00 per teller transaction, $5.10 per inquiry call",
   "$0.40 per check, $5.10 per teller transaction, $6.00 per inquiry call",
   "$1.14 per check, $1.20 per teller transaction, $0.51 per inquiry call",
   "$0.03 per check dollar, $6.00 per teller transaction, $5.10 per inquiry call"],
  "$0.40 per check, $6.00 per teller transaction, $5.10 per inquiry call",
  "Each pool divided by its own driver:\n\n- Paying checks: 1,140 / 2,850 = **$0.40 per check**\n- Teller services: 1,200 / 200 = **$6.00 per transaction**\n- Customer inquiries: 510 / 100 = **$5.10 per call**\n\nNotice the size difference. A teller transaction costs fifteen times what a check costs to process, and a phone call nearly thirteen times — which is why the customer line that walks into branches and telephones is the expensive one, whatever its check volume looks like.",
  "One rate per pool, each divided by its own driver quantity, in thousands throughout.",
  provenance="prof_adapted", source=BNB, scenario="madm-sc-buckeye", order=3)

q("madm-bnb04", "madm_abc_service_sector", 8,
  "Using Buckeye's ABC rates, what is the indirect cost per retail account and per business account?",
  ["$11.15 retail, $23.55 business", "$1.90 retail, $51.30 business",
   "$23.55 retail, $11.15 business", "$8.36 retail, $23.55 business"],
  "$11.15 retail, $23.55 business",
  "Retail: 570 checks at $0.40 is $228; 160 teller transactions at $6.00 is $960; 95 calls at $5.10 is $484.5. Total $1,672.5 thousand over 150,000 accounts = **$11.15**.\n\nBusiness: 2,280 checks at $0.40 is $912; 40 transactions at $6.00 is $240; 5 calls at $5.10 is $25.5. Total $1,177.5 thousand over 50,000 accounts = **$23.55**.\n\nThe two totals still add to $2,850 thousand — ABC reassigned the pool, it did not change its size.",
  "Charge each line for the driver units it actually consumed, add the three, then divide by accounts.",
  difficulty=3, provenance="prof_adapted", source=BNB, scenario="madm-sc-buckeye", order=4)

q("madm-bnb05", "madm_abc_service_sector", 8,
  "Under ABC, what is Buckeye's average contribution to profit per account for each customer line, and what strategy does it imply?",
  ["Retail loses $1.15 and business earns $16.45 — stop paying branch managers purely for account growth",
   "Retail earns $8.10 and business loses $11.30 — keep aggressively marketing retail accounts",
   "Retail loses $1.15 and business earns $16.45 — close the retail line entirely",
   "Both lines are profitable, so no change of strategy is needed"],
  "Retail loses $1.15 and business earns $16.45 — stop paying branch managers purely for account growth",
  "Revenue less ABC cost: retail is 10 − 11.15 = **−$1.15**; business is 40 − 23.55 = **$16.45**.\n\nSo the more retail accounts the bank added, the more money it lost — which explains why 80% of branch managers hit their growth targets while profits kept falling. The bonus plan paid for account count with no view of cost-to-serve.\n\nClosing the retail line is the overreaction. The right moves are the customer-profitability menu: minimum balances and per-transaction fees, pushing routine activity to ATM and online channels so the driver quantities fall, and targeting the retail segments whose behaviour resembles the profitable accounts.",
  "Subtract the ABC cost per account from the revenue per account, then ask what the bonus plan was actually rewarding.",
  qtype="case_fact", provenance="prof_adapted", source=BNB, scenario="madm-sc-buckeye", order=5)

q("madm-bnb06", "madm_abc_service_sector", 8,
  "A manager asks whether ten more customers using teller services would raise Buckeye's costs by $60. What is the right answer?",
  ["No — the $6.00 rate is a long-run average cost of capacity, not the short-run incremental cost of ten more transactions",
   "Yes — the rate was computed causally, so ten transactions cost ten times the rate",
   "No — the rate is too high; the true cost is closer to $0.40 per transaction",
   "Yes, but only if the bank has excess teller capacity"],
  "No — the $6.00 rate is a long-run average cost of capacity, not the short-run incremental cost of ten more transactions",
  "The pool is mostly teller salaries and depreciation, both of which are committed. Ten more transactions on staff who are already scheduled add essentially nothing today.\n\nThe rate is a **long-run average** cost of the capacity that teller services consume, which makes it the right number for a strategic question — is this customer line worth serving, what should the fee schedule be — and the wrong number for a short-run incremental one.\n\nThis is the same short-run versus long-run distinction as Session 6's copying machine, in a service setting.",
  "Ask what the pool is made of, and whether any of it changes tomorrow because ten more people walk in.",
  qtype="case_fact", difficulty=3, provenance="prof_adapted", source=BNB, scenario="madm-sc-buckeye", order=6)

q("madm-tp01", "madm_tp_negotiation", 10,
  "Relative to buying from an outside supplier at $170 per unit, what is the change in corporate profit if Brenda buys the component from Seth at $230 per unit, on 20,000 units?",
  ["$900,000 increase", "$1,200,000 decrease", "$2,100,000 increase", "No change"],
  "$900,000 increase",
  "Corporate profit does not depend on the transfer price at all — one division's revenue is the other's cost. What it depends on is whether the firm makes the part or buys it.\n\nMaking it internally costs the company Seth's variable cost of $125 (his division has spare capacity at 70% utilisation, so nothing is displaced). Buying it costs $170.\n\nSaving of $45 a unit on 20,000 units = **$900,000**, and that number is the same at a transfer price of $170, $200 or $230.\n\n$2,100,000 is the gain to Seth's division alone at $230; $1,200,000 is Brenda's loss at that price. Both are distribution, not creation.",
  "Corporate profit changes only through make-or-buy. Compare the seller's incremental cost with the external price.",
  difficulty=3, provenance="prof_adapted", source=TPC, scenario="madm-sc-sethbrenda", order=1)

q("madm-tp02", "madm_tp_negotiation", 10,
  "In the Seth and Brenda dispute, what is the transfer zone — the range of prices at which both divisions would rationally agree to transfer?",
  ["$125 to $170", "$170 to $230", "$200 to $230", "$125 to $200"],
  "$125 to $170",
  "**Seller's floor**: Seth's division is at 70% capacity, so transferring displaces no external sale and the opportunity cost is zero. His minimum is his variable cost of **$125**. The $75 of allocated overhead and the $240,000 already spent on design are both irrelevant — one is unitised fixed cost, the other is sunk.\n\n**Buyer's ceiling**: Brenda's outside bids are about **$170**, so she would never rationally pay more.\n\nSeth's $230 bid is above the buyer's ceiling and would never be accepted. Brenda's $200 offer is also above $170 — she is offering it to preserve the relationship and Seth's engineering support, not because the arithmetic requires it.",
  "Floor is the seller's incremental plus opportunity cost. Ceiling is the buyer's external alternative.",
  difficulty=3, provenance="prof_adapted", source=TPC, scenario="madm-sc-sethbrenda", order=2)

q("madm-tp03", "madm_tp_negotiation", 10,
  "Seth spent $240,000 designing the part on nothing more than an understanding that he would be the front-runner in the bidding, and now finds Brenda holding the bargaining power. What is this problem called, and when could it have been solved?",
  ["Holdup — and only before the investment was made, through contract design or cost sharing",
   "Holdup — and it is solved after the fact by corporate mandating the transfer price",
   "Goal incongruence — solved by changing how Seth's bonus is calculated",
   "The ratchet effect — solved by resetting Seth's divisional target"],
  "Holdup — and only before the investment was made, through contract design or cost sharing",
  "**Holdup** is relationship-specific investment plus incomplete commitment. Once the $240,000 is sunk into an asset that has value only in this relationship, the counterparty with outside options can squeeze — and Brenda is not even behaving badly, she is simply negotiating.\n\nThe remedies are all *ex ante*: a long-term purchase commitment or take-or-pay clause, Brenda co-funding the design, pre-agreed formula pricing, an arbitration mechanism, or vertical integration.\n\nHis public example was Apple and GT Advanced in 2014 — GT built sapphire capacity for Apple, Apple pulled back, and GT went bankrupt.\n\nCorporate mandating a price after the fact resolves this instance and undermines decentralisation without preventing the next one.",
  "Name the pattern first — specific investment plus vague commitment — then ask when the remedy has to be in place.",
  qtype="case_fact", provenance="prof_adapted", source=TPC, scenario="madm-sc-sethbrenda", order=3)

q("madm-wlk01", "madm_tp_capacity", 9,
  "Walker's Circuit Division is at full capacity with external demand of 100,000 units at $170 (variable cost $140). Satellite wants 50,000 modified units, which cost $155 in variable cost, and can buy them outside at $180. What are the minimum and maximum transfer prices, and should the transfer happen?",
  ["Min $185, max $180 — no transfer; Satellite buys outside",
   "Min $155, max $180 — transfer at any price in between",
   "Min $175, max $180 — transfer at any price in between",
   "Min $185, max $195 — transfer at any price in between"],
  "Min $185, max $180 — no transfer; Satellite buys outside",
  "Every modified unit displaces a standard unit sold externally, so the opportunity cost is the contribution given up: 170 − 140 = **$30**.\n\nMinimum TP = 155 + 30 = **$185**. Maximum TP = **$180**, Satellite's outside price.\n\nSince 185 > 180, there is no transfer zone. That is the correct corporate answer, not a negotiation failure: making it inside costs $185 of real resources against $180 to buy it.",
  "Full capacity means every transferred unit costs a lost external sale. Add that lost margin to the modified variable cost.",
  difficulty=3, provenance="prof_adapted", source="Session 9 slides", scenario="madm-sc-walker", order=1)

q("madm-wlk02", "madm_tp_capacity", 9,
  "Now Walker's external demand is 50,000 units at $170, leaving 50,000 units of spare capacity. Satellite still wants 50,000 modified units at a variable cost of $155, with an outside price of $180. What is the transfer zone?",
  ["$155 to $180", "$185 to $180 — no zone", "$175 to $180", "$140 to $170"],
  "$155 to $180",
  "The spare capacity exactly covers Satellite's requirement, so nothing external is displaced and the opportunity cost is **zero**.\n\nMinimum TP falls to the modified variable cost of **$155**; the maximum is still Satellite's $180 outside price. The zone is **$155 to $180** and internal sourcing saves the company $25 a unit.\n\nCompare with the previous scenario. The only fact that changed was capacity utilisation, and it moved the minimum transfer price by $30 and flipped the decision.",
  "With genuine spare capacity, what does transferring a unit cost the seller beyond the cash to make it?",
  provenance="prof_adapted", source="Session 9 slides", scenario="madm-sc-walker", order=2)

q("madm-wlk03", "madm_tp_capacity", 9,
  "Walker has external demand of 50,000 units at $170 plus a one-time order of 50,000 units at $160, and capacity of 100,000. Satellite wants 50,000 modified units costing $155 in variable cost, with an outside price of $180. What is the minimum transfer price?",
  ["$175", "$185", "$155", "$170"],
  "$175",
  "Capacity is fully used, so something has to give. What gets displaced is the **marginal** external order — the one-time 50,000 units at $160, not the better $170 business.\n\nOpportunity cost = 160 − 140 = **$20** per unit.\n\nMinimum TP = 155 + 20 = **$175**, against Satellite's ceiling of $180. The zone is narrow but real, and internal sourcing is still worth $5 a unit to the firm.\n\n$185 uses the $170 order's margin, which is the wrong displacement. This is the case worth studying: identify which sale actually goes away.",
  "When capacity binds, ask which specific external sale is given up — the best one or the worst one.",
  difficulty=3, provenance="prof_adapted", source="Session 9 slides", scenario="madm-sc-walker", order=3)

q("madm-cap01", "madm_tp_capacity", 9,
  "Division A makes two products on one machine with 600 hours a month. Product 1: demand 300 units, price $10, variable cost $4, one machine hour each. Product 2: unlimited demand, price $15, variable cost $7, two machine hours each. What is Division A's optimal product mix?",
  ["300 units of Product 1 and 150 units of Product 2",
   "300 units of Product 2 and no Product 1",
   "150 units of Product 1 and 225 units of Product 2",
   "600 units of Product 1 and no Product 2"],
  "300 units of Product 1 and 150 units of Product 2",
  "Rank by contribution margin per unit of the **constraint**, not per unit of product.\n\n- Product 1: CM of $6 in one machine hour = **$6 per hour**\n- Product 2: CM of $8 in two machine hours = **$4 per hour**\n\nSo fill Product 1's demand first: 300 units using 300 hours. The remaining 300 hours go to Product 2, giving 150 units.\n\nRanking by contribution margin per unit would put Product 2 first, because $8 beats $6 — and would waste the scarce machine. The unitised fixed costs in the problem are there to be ignored.",
  "The machine is what is scarce, so measure contribution per machine hour.",
  difficulty=3, provenance="prof_adapted", source="Session 9 slides")

q("madm-cap02", "madm_tp_capacity", 9,
  "Using the same Division A facts, Division B wants 50 units of Product 1 per month and currently buys them outside at $9. What is the minimum transfer price Division A should accept?",
  ["$8", "$4", "$6", "$9"],
  "$8",
  "Fifty units of Product 1 consume 50 machine hours. Those hours come out of Product 2, which uses two hours a unit — so 25 units of Product 2 are displaced.\n\nContribution lost = 25 x (15 − 7) = **$200**, spread over the 50 units transferred = **$4 per unit**.\n\nMinimum TP = variable cost + opportunity cost = 4 + 4 = **$8**.\n\nDivision B's ceiling is its external price of $9, so the transfer is worth $1 a unit to the company. The unitised fixed costs of $2 and $6 stay out of the calculation entirely.",
  "Convert the transferred units into constraint hours, then into displaced units of the other product.",
  difficulty=3, provenance="prof_adapted", source="Session 9 slides")

q("madm-fcp01", "madm_tp_policy", 10,
  "Under the mandated full-cost-plus-10% policy, what will Division B do, and what does it cost the company?",
  ["Buy externally at $300; the company loses $150 per unit, or $3 million",
   "Buy internally at $385; the company loses $85 per unit, or $1.7 million",
   "Buy externally at $300; the company loses nothing, since the transfer price is internal",
   "Buy internally at $385; the company gains $150 per unit"],
  "Buy externally at $300; the company loses $150 per unit, or $3 million",
  "Division B faces a transfer price of 350 x 1.10 = **$385** against an outside quote of $300, so it buys outside. Any manager evaluated on divisional profit would do the same.\n\nFrom the company's view that is wrong. Division A can sell only 70,000 of its 100,000 unit capacity, so supplying B displaces nothing and the true incremental cost is the **$150 variable cost**. Buying outside spends $300 to avoid a $150 cost.\n\nLoss = 300 − 150 = $150 a unit on 20,000 units = **$3 million**.\n\nThe manager is rational. The policy is at fault — it built unitised fixed cost and a markup into a number the buying division treats as a real cost.",
  "Work out what B decides given the price it faces, then work out what that decision costs the firm.",
  difficulty=3, provenance="prof_adapted", source="Session 10 slides", scenario="madm-sc-fullcostplus", order=1)

q("madm-fcp02", "madm_tp_policy", 10,
  "When is a cost-based transfer pricing policy defensible despite the distortion it can create?",
  ["When sourcing is mandated internally, so the price cannot change the make-or-buy decision",
   "When the selling division has excess capacity, since fixed costs then need recovering",
   "When both divisions are profit centres, since the markup balances out",
   "When a competitive external market for the item exists"],
  "When sourcing is mandated internally, so the price cannot change the make-or-buy decision",
  "A distorted transfer price does damage only when it changes a **decision**. If corporate mandates that the item is sourced internally, the price merely moves reported profit between two divisions of the same firm, and the sourcing choice is unaffected.\n\nOnce sourcing is delegated, cost-based prices routinely produce the wrong choice — which is the $3 million example — and negotiated prices become the better default.\n\nA competitive external market argues for market-based pricing, not cost-based. Excess capacity makes cost-based pricing **more** dangerous, not less, because the gap between full cost and incremental cost is at its widest.",
  "Ask what a transfer price can and cannot change, and when the sourcing decision is even open.",
  qtype="case_fact", provenance="prof_adapted", source="Session 10 slides")

q("madm-itp01", "madm_international_tp", 10,
  "A firm produces parts in the US at a cost of $40 and assembles in Ireland at a cost of $20, selling at $100. US tax is 21% and Irish tax is 12.5%. At a transfer price of $60, what is the effective tax rate on the $40 of profit?",
  ["16.75%", "21.0%", "12.5%", "33.5%"],
  "16.75%",
  "Split the profit across the two jurisdictions at the stated transfer price.\n\n- US: revenue of $60 less cost of $40 is $20 of income, taxed at 21% = $4.20\n- Ireland: revenue of $100 less the $60 transfer price and $20 of assembly is $20 of income, taxed at 12.5% = $2.50\n\nTotal tax is $6.70 on $40 of group profit, an effective rate of **16.75%**.\n\nDropping the transfer price to $40 would move all $40 of profit to Ireland, giving $5.00 of tax and an effective rate of 12.5% — which is exactly the arrangement arm's-length rules exist to prevent.",
  "Compute income in each jurisdiction at the given transfer price, tax each at its own rate, then divide by total profit.",
  difficulty=3, provenance="prof_adapted", source="Session 10 slides")

q("madm-itp02", "madm_international_tp", 10,
  "Under OECD Pillar Two, what happens when a large multinational's subsidiary pays an effective tax rate below 15%?",
  ["The home jurisdiction imposes a top-up tax to bring the rate to 15%",
   "The transfer price is automatically restated to an arm's-length benchmark",
   "The subsidiary loses the right to deduct royalties paid to affiliates",
   "The group is barred from consolidating that subsidiary for tax purposes"],
  "The home jurisdiction imposes a top-up tax to bring the rate to 15%",
  "Pillar Two, in force from 2024, applies a 15% global minimum corporate tax to groups with revenue above €750 million. Where a subsidiary's effective rate falls below 15%, the parent's jurisdiction collects the difference as a **top-up tax**.\n\nThe effect is to cap the gain from profit shifting: moving income to a zero-tax jurisdiction no longer produces a zero-tax outcome for the group. It does not end transfer pricing disputes, which mostly concern intangibles and arm's-length benchmarks rather than the headline rate.",
  "Ask what the rule does when the low rate is found — restate the price, or collect the difference somewhere else.",
  qtype="case_fact", provenance="prof_adapted", source="Session 10 slides")

# --- The assigned textbook problems ----------------------------------------

TB = "Assigned textbook problem"

q("madm-tb01", "madm_abc_mechanics", 6,
  "Pema makes 1,000 deluxe and 5,000 standard prints. Overhead is $390,000 and total labour cost is $325,000 — 1,000 x $75 plus 5,000 x $50. Under a single labour-dollar overhead rate, how much overhead is charged to one deluxe print?",
  ["$90", "$65", "$75", "$390"],
  "$90",
  "Rate = 390,000 / 325,000 = **$1.20 per labour dollar**.\n\nA deluxe print carries $75 of labour, so it absorbs 75 x 1.20 = **$90** of overhead. A standard print carries $50 of labour and absorbs $60.\n\nThat gives a reported profit of $85 on a deluxe print against $35 on a standard one, and the conclusion that deluxe frames are more than twice as profitable. The activity-based rebuild reverses it — the deluxe line's profit per unit falls to $41.50 while standard rises to $51.50.",
  "Compute the rate per labour dollar first, then apply it to this product's labour content.",
  provenance="prof_adapted", source=TB)

q("madm-tb02", "madm_cross_subsidy", 6,
  "Greg charges every customer the same price to mow a lawn, regardless of size, terrain or landscaping. What happens to his customer mix over time, and what is the manufacturing analogy?",
  ["Easy lawns leave for cheaper competitors and difficult lawns arrive, so average cost per job rises — the analogy is a firm whose mix drifts toward difficult low-volume products",
   "Difficult lawns leave because they are overpriced, so his mix improves — the analogy is a firm that naturally sheds complexity",
   "Nothing changes, because the flat price averages out across the mix",
   "He gains market share in both segments, since a single price is simpler for customers"],
  "Easy lawns leave for cheaper competitors and difficult lawns arrive, so average cost per job rises — the analogy is a firm whose mix drifts toward difficult low-volume products",
  "A flat price per lawn is a volume-based allocation in disguise: it assumes every lawn takes the same work, when size, terrain and landscaping features vary the time a great deal.\n\nSo difficult lawns are underpriced and easy lawns overpriced. Owners of easy lawns get better quotes elsewhere and leave; owners of difficult lawns find Greg cheap and arrive. The mix drifts toward the jobs that take longest and average cost climbs while the price stays flat.\n\nThe manufacturing version is identical: a firm pricing from volume-based costs watches its mix shift away from easy-to-make high-volume products toward difficult low-volume ones, one rational customer decision at a time.",
  "Ask which customers are getting a bargain under a flat price, and what they do about it.",
  qtype="case_fact", provenance="prof_adapted", source=TB)

q("madm-tb03", "madm_customer_profitability", 7,
  "Ryan Construction and Wilson Builders each buy $400,000. Ryan generates $120,000 of contribution margin, Wilson $100,000. Ryan places 50 orders and takes 150 deliveries; Wilson places 20 orders and takes 40. Orders cost $450 and deliveries $100, and volume-related cost is $108,000 for each. Which customer is more profitable?",
  ["Wilson, despite the lower contribution margin",
   "Ryan, because the contribution margin is higher",
   "They are equally profitable, since sales are identical",
   "Cannot tell without knowing each customer's payment terms"],
  "Wilson, despite the lower contribution margin",
  "Charge each customer for what it consumed.\n\n- Ryan: 120,000 − 108,000 − (50 x 450) − (150 x 100) = 120,000 − 108,000 − 22,500 − 15,000 = **−$25,500**\n- Wilson: 100,000 − 108,000 − (20 x 450) − (40 x 100) = 100,000 − 108,000 − 9,000 − 4,000 = **−$21,000**\n\nBoth are loss-makers here, and **Wilson is the better of the two** even though its contribution margin is $20,000 lower. Its lighter demand on ordering and delivery capacity more than makes up the difference.\n\nContribution margin ranks revenue quality. Customer profitability ranks it net of what it cost to earn, and the two rankings can point opposite ways.",
  "Subtract each customer's own order and delivery costs from its contribution margin before comparing.",
  difficulty=3, provenance="prof_adapted", source=TB)

q("madm-tb04", "madm_managing_customers", 7,
  "A firm's ABC study shows customer Thorne is a low-volume customer generating as much order-processing activity as its largest account, and Thorne is the only loss-maker. What does the textbook recommend?",
  ["Work with Thorne to place fewer, larger orders, and share how the profitable customer runs purchasing",
   "Terminate the relationship, since the account destroys value",
   "Raise Thorne's prices to match the largest customer's contribution margin ratio",
   "Reallocate Thorne's order-processing cost to the profitable customers"],
  "Work with Thorne to place fewer, larger orders, and share how the profitable customer runs purchasing",
  "The problem is Thorne's **ordering pattern**, not Thorne. Change the driver quantity and the cost disappears without the revenue leaving.\n\nThe textbook's suggestion is exactly this: work with customers like Quinn and Thorne to place fewer, larger orders, and if it is not proprietary, share how the profitable customer manages its purchasing function.\n\nTermination is the last resort — the contribution leaves immediately while much of the assigned cost is capacity cost that stays. Reallocating the cost elsewhere just hides it and creates the next apparently unprofitable customer.",
  "Ask what is actually driving the cost, and whether it can be changed without losing the account.",
  qtype="case_fact", provenance="prof_adapted", source=TB)

q("madm-tb05", "madm_customer_profitability", 7,
  "A hotel finds that a long-stay guest generates $1,892 of profit per day against $1,715 for a short-stay guest. Which explanation is not one of the reasons the textbook gives?",
  ["Long-stay guests pay a higher room rate per night",
   "Batch-level costs such as check-in are spread over more days",
   "The intensity of resource usage, such as concierge service, falls as the stay goes on",
   "The hotel cross-sells more miscellaneous services to a long-stay guest"],
  "Long-stay guests pay a higher room rate per night",
  "The room rate is the same $1,800 a day for both. The profit difference comes from the cost side and the ancillary revenue side.\n\n- **Batch-level spreading**: check-in and check-out happen once regardless of length of stay, so a nine-day guest carries a ninth of the cost per day.\n- **Declining intensity**: concierge and similar services get used heavily on arrival and taper off.\n- **Cross-selling**: miscellaneous spending per guest rises with the length of the stay.\n\nThis is the cost hierarchy in a service business, and it is why the textbook suggests offering long-stay guests a 5-10% discount: filling capacity is what drives profit in a high-fixed-cost industry.",
  "Check which quantities actually differ between the two guest types. The nightly rate is not one of them.",
  qtype="case_fact", provenance="prof_adapted", source=TB)

q("madm-tb06", "madm_cost_hierarchy", 6,
  "A firm is asked what it costs to produce 1,000 additional units. Materials are $250 a unit, labour $200 a unit, unit-level overhead $150 a unit, and the order needs one new batch at $25,000. There is no incremental product- or facility-level cost. What is the cost per unit, and why does a labour-based rate get it wrong?",
  ["$625; a labour-based rate charges $300 of overhead per unit and gives $750, because it ignores that only batch-level overhead is incremental",
   "$750; the labour-based rate is correct because overhead really does move with labour",
   "$600; batch costs should be excluded because the batch already exists",
   "$625; a labour-based rate gives the same answer by coincidence"],
  "$625; a labour-based rate charges $300 of overhead per unit and gives $750, because it ignores that only batch-level overhead is incremental",
  "Add up what actually changes: materials $250,000, labour $200,000, unit-level overhead $150,000, one new batch at $25,000. Total **$625,000**, or **$625 a unit**.\n\nA system allocating overhead at 150% of labour cost charges $300 of overhead per unit and reports $750 — because it charges the incremental order for product- and facility-level costs that do not change at all.\n\nThe cost hierarchy is what makes the more accurate estimate possible: it tells you which levels are actually triggered by the decision.",
  "List which levels of the hierarchy the extra order actually triggers, then add only those.",
  difficulty=3, provenance="prof_adapted", source=TB)

q("madm-tb07", "madm_master_budget", 7,
  "A retailer opens November with $16,000 of cash. November revenue is $50,000, October revenue was $40,000, and 70% of a month's sales are collected in the month with the remaining 30% collected the following month. Purchases equal 60% of revenue and are paid in the month, and marketing and admin costs are $6,000. What is the closing cash balance?",
  ["$27,000", "$25,000", "$31,000", "$23,000"],
  "$27,000",
  "Run the cash budget line by line.\n\n- Opening cash: $16,000\n- Collections on November sales: 70% of 50,000 = $35,000\n- Collections on October sales: 30% of 40,000 = $12,000\n- Total available: $63,000\n- Purchases: 60% of 50,000 = $30,000\n- Marketing and admin: $6,000\n\nClosing cash = 63,000 − 36,000 = **$27,000**.\n\nNote that this is a cash statement, not a profit statement. The two answer different questions, and a profitable month can still run short of cash.",
  "Collections come from two months of sales. Payments come out of the current month.",
  provenance="prof_adapted", source=TB)

q("madm-tb08", "madm_master_budget", 7,
  "A business collects 50% of a month's sales in the month and the rest the following month. March and April sales are fully collected by 31 May. May sales are $46,000. What is the accounts receivable balance at 31 May?",
  ["$23,000", "$46,000", "$20,000", "$25,000"],
  "$23,000",
  "Everything from March and April has been collected, so the only receivable outstanding is the uncollected half of May.\n\n50% of 46,000 = **$23,000**.\n\nThe long route gives the same answer: opening receivables of $20,000, plus May sales of $46,000, less $20,000 collected for April and $23,000 collected for May, leaves $23,000.\n\nThe short route works whenever the collection pattern is short enough that all older months have cleared.",
  "Ask which months still have money outstanding at the balance-sheet date.",
  difficulty=1, provenance="prof_adapted", source=TB)

q("madm-tb09", "madm_master_budget", 7,
  "Opening work-in-process is $180,000. During the month direct materials of $250,000, direct labour of $265,500 and variable overhead of $125,000 are added, and the variable cost of goods manufactured is $545,000. What is the closing WIP balance?",
  ["$275,500", "$180,000", "$820,500", "$365,500"],
  "$275,500",
  "The inventory equation applied to the work-in-process account. COGM is the outflow; materials, labour and overhead are the inflows.\n\nTotal inflow into WIP = 180,000 + 250,000 + 265,500 + 125,000 = $820,500. Less the $545,000 that left as finished goods leaves **$275,500**.\n\nThe same equation then runs on the finished-goods account, where COGM is the inflow and COGS the outflow. COGM is what links the two accounts.",
  "Opening balance plus everything that went in, less everything that came out.",
  difficulty=1, provenance="prof_adapted", source=TB)

q("madm-tb10", "madm_budget_behavior", 7,
  "A controller discovers that two managers routinely pad their budgets in a firm with rigid standards and formulaic incentive pay. What does the textbook suggest she do first?",
  ["Speak with the owner about his views on padding before acting, since he may already know and treat it as the accepted game",
   "Report both managers immediately, since knowingly false plans breach accounting ethics",
   "Pad her own budget by a comparable amount so she is not disadvantaged",
   "Quietly correct the two budgets before they are consolidated"],
  "Speak with the owner about his views on padding before acting, since he may already know and treat it as the accepted game",
  "There is a real ethical constraint here — the plans contain information known to be false, and accounting standards preclude knowingly compromising the integrity of information. But acting on it immediately pits the controller against her colleagues and destroys her effectiveness.\n\nThe textbook's pragmatic answer is to educate the owner about the pitfalls of rigid standards and formulaic incentive pay, and to find out first whether he already knows. If padding is the game everybody in the firm implicitly agrees to, her conscience is clear and the standards are satisfied.\n\nThe deeper point is that padding is a symptom. Rigid targets and mechanical bonus formulas cause it, and fixing individual managers does not fix the system that produced them.",
  "Ask whether the behaviour is the disease or the symptom, and who is in a position to change the system.",
  qtype="case_fact", provenance="prof_adapted", source=TB)

q("madm-tb11", "madm_budget_behavior", 7,
  "A fire at a plant makes a division manager's annual target unreachable through no fault of her own. Should the target be revised?",
  ["Separate the two questions: revise the operating plan with the latest information, but leaving the performance target alone is defensible",
   "Yes — the controllability principle says she must not be held to an outcome she did not control",
   "No — targets should never be revised for any reason once the year has begun",
   "Yes, and the revision should be automatic whenever an uncontrollable event occurs"],
  "Separate the two questions: revise the operating plan with the latest information, but leaving the performance target alone is defensible",
  "Two problems wear the same clothes. The **planning** problem — production scheduling, material ordering, capacity — should absolutely use the latest information. The **evaluation** problem is separate.\n\nThe textbook leans toward not resetting the target, on three arguments: defining a big enough event is a slippery slope and every adverse event will produce a request; managing risk is part of the job, and insulating managers from it defeats the purpose; and managers are often at their most inventive when their back is against the wall. Plus the test question — would she ask for a reset if the fire were in a competitor's plant?\n\nThe controllability principle is real and it is a guideline, not an absolute. Almost nothing is fully within one manager's control.",
  "Ask what the budget is being used for in each half of the question: planning, or evaluation.",
  qtype="case_fact", difficulty=3, provenance="prof_adapted", source=TB)

q("madm-tb12", "madm_sales_variances", 8,
  "Clarissa budgeted 4,000 cupcakes at $2.50 with variable cost of $1.00 and fixed costs of $2,000. She actually sold 4,500 for $10,800, with actual variable and fixed costs equal to budget. What are her sales volume and sales price variances?",
  ["Volume $750 F, price $450 U", "Volume $450 F, price $750 U",
   "Volume $1,250 F, price $500 U", "Volume $750 F, price $300 F"],
  "Volume $750 F, price $450 U",
  "Build the flexible budget at 4,500 cupcakes: revenue 4,500 x 2.50 = $11,250, variable cost $4,500, contribution $6,750, fixed $2,000, profit $4,750.\n\n- Sales volume variance = flexible profit − master profit = 4,750 − 4,000 = **$750 F**. Equivalently 500 extra units at the $1.50 budgeted contribution margin.\n- Sales price variance = actual revenue − flexible revenue = 10,800 − 11,250 = **$450 U**. She sold at $2.40.\n\nThey net to the $300 F total profit variance, which they must, because actual costs equalled budget so every other variance is zero.",
  "The volume variance is a profit number built on contribution margin. The price variance is a revenue number.",
  provenance="prof_adapted", source=TB)

q("madm-tb13", "madm_input_variances", 8,
  "A pool service budgets 0.50 gallons of chlorine per pool at $8.00 a gallon, serviced 500 pools, and used 280 gallons at $7.50. What are the chlorine quantity and price variances?",
  ["Quantity $240 U, price $140 F", "Quantity $140 F, price $240 U",
   "Quantity $240 F, price $140 U", "Quantity $100 U, price $140 F"],
  "Quantity $240 U, price $140 F",
  "Three columns.\n\n- Flexible budget: 500 pools x 0.50 gallons x $8.00 = $2,000\n- As-if budget: 280 gallons x $8.00 = $2,240\n- Actual: 280 gallons x $7.50 = $2,100\n\nQuantity variance = 2,240 − 2,000 = **$240 U** (280 gallons used against 250 allowed). Price variance = 2,100 − 2,240 = **$140 F**.\n\nTotal chlorine variance is $100 U. The pattern — favourable price, unfavourable quantity — is the one worth investigating as a single story rather than two.",
  "Build the flexible budget from the pools actually serviced, then insert the as-if column.",
  provenance="prof_adapted", source=TB)

q("madm-tb14", "madm_input_variances", 8,
  "QuickyLube budgets 0.50 labour hours per car at $12.50 an hour, serviced 210 cars, worked 140 hours and paid $1,470. What is the most likely explanation for the resulting variances?",
  ["Newer, cheaper technicians were scheduled during a slow week, taking longer per car",
   "Experienced technicians worked overtime, raising both the rate and the hours",
   "The standard rate was raised mid-period without updating the budget",
   "Cars serviced were simpler than budgeted, reducing both hours and wages"],
  "Newer, cheaper technicians were scheduled during a slow week, taking longer per car",
  "First the numbers. Flexible budget = 210 x 0.50 x 12.50 = $1,312.50; as-if = 140 x 12.50 = $1,750; actual = $1,470. So the quantity variance is **$437.50 U** and the price variance is **$280 F**.\n\nTechnicians took 140 / 210 = 0.67 hours per car, or 40 minutes against a 30-minute standard, and the actual wage was $10.50 against $12.50.\n\nCheap and slow together points at less experienced staff. The week was slow — 65 fewer cars than budgeted — so scheduling junior technicians is exactly what a manager would do.\n\nAs always, an out-of-date standard is the alternative hypothesis worth keeping on the list.",
  "Compute both variances, note their signs, then ask what single staffing decision produces that combination.",
  qtype="case_fact", difficulty=3, provenance="prof_adapted", source=TB)

q("madm-tb15", "madm_input_variances", 8,
  "GripRite reports a material price variance of $3,150 U and a quantity variance of $4,500 F. The flexible budget quantity is 18,000 kg at a budgeted price of $1.50 per kg. What was the actual quantity used and the actual price paid?",
  ["15,000 kg at $1.71 per kg", "21,000 kg at $1.29 per kg",
   "15,000 kg at $1.50 per kg", "18,000 kg at $1.71 per kg"],
  "15,000 kg at $1.71 per kg",
  "Fill the three columns in order.\n\n- Flexible budget = 18,000 x 1.50 = **$27,000**\n- The quantity variance is favourable, so the as-if column is below it: 27,000 − 4,500 = **$22,500**. That column is AQ x BP, so AQ = 22,500 / 1.50 = **15,000 kg**\n- The price variance is unfavourable, so actual is above the as-if column: 22,500 + 3,150 = **$25,650**, and AP = 25,650 / 15,000 = **$1.71**\n\nTotal material variance = 4,500 F − 3,150 U = $1,350 F.\n\nThe pattern — paying more per kilogram and using fewer of them — suggests a higher-quality material with less waste.",
  "Work the columns left to right, using each variance to step from one column to the next.",
  difficulty=3, provenance="prof_adapted", source=TB)

q("madm-tb16", "madm_input_variances", 8,
  "Pizzeria Paradise budgets 0.50 pounds of dough per pizza at $2.00 a pound, made 12,000 pizzas, and used 6,800 pounds at $1.90. Both the labour quantity and the dough quantity variances are unfavourable. What is the most economical explanation?",
  ["Lower-quality dough was bought cheaply, producing waste that raised both dough usage and labour hours",
   "Higher-quality dough was bought, so the price variance should have been unfavourable",
   "Too few staff were scheduled, which cannot affect dough usage",
   "The pizzas made were larger than standard, which affects dough but not labour"],
  "Lower-quality dough was bought cheaply, producing waste that raised both dough usage and labour hours",
  "The dough numbers: flexible budget 12,000 x 0.50 x 2.00 = $12,000; as-if 6,800 x 2.00 = $13,600; actual 6,800 x 1.90 = $12,920. Price variance **$680 F**, quantity variance **$1,600 U**.\n\nA favourable price paired with unfavourable quantity in *two* different inputs is the signature of a quality trade-off. Cheaper dough tears and gets discarded, which uses more dough and more time.\n\nThe textbook keeps two alternatives alive: over-scheduling or scheduling higher-paid staff would explain the labour variances alone, and out-of-date standards would explain both without anyone doing anything differently.",
  "Look at the sign pattern across both inputs, not one input at a time.",
  qtype="case_fact", provenance="prof_adapted", source=TB)

q("madm-tb17", "madm_variance_decomposition", 8,
  "A firm reports a total profit variance of $5,000 F, a sales price variance of $4,000 U, a variable cost variance of $4,000 F and a fixed cost spending variance of $2,000 U. What is the sales volume variance?",
  ["$7,000 F", "$3,000 F", "$7,000 U", "$5,000 F"],
  "$7,000 F",
  "The total profit variance is the sum of its components:\n\ntotal = sales price + variable cost + fixed cost spending + sales volume\n\nSubstituting, with unfavourable amounts negative: 5,000 = (−4,000) + 4,000 + (−2,000) + volume.\n\nSo volume = 5,000 + 2,000 = **$7,000 F**.\n\nThese back-solving questions are common because they test whether you know the tree rather than a single formula. Write the identity out, put signs on every term, and solve for the one that is missing.",
  "Write the total as the sum of its four components with signs, then solve for the unknown.",
  provenance="prof_adapted", source=TB)

q("madm-tb18", "madm_sales_variances", 8,
  "Jason cut his putter price from $280 to $245 and sold 5,600 instead of 5,000. The budgeted contribution margin was $142 a unit. The sales volume variance was $85,200 F and the sales price variance $196,000 U. Was the price cut a good decision?",
  ["No — it cost $110,800, because the extra volume did not compensate for the lower price",
   "Yes — the favourable volume variance shows demand responded as intended",
   "Cannot tell without knowing what happened to fixed costs",
   "Yes — total revenue rose, so the decision paid for itself"],
  "No — it cost $110,800, because the extra volume did not compensate for the lower price",
  "The two sales variances together measure the price decision, because cutting price affects both the price realised and the quantity sold.\n\n196,000 U − 85,200 F = **$110,800** of profit destroyed.\n\nDemand was less price-sensitive than assumed. A putter at $245 is still expensive, and buyers at that end of the market are not shopping on a 12.5% discount. The textbook's suggestion is to put the price back up, possibly above the old $280.\n\nRevenue did not in fact rise: 5,600 x 245 = $1,372,000 against 5,000 x 280 = $1,400,000.",
  "Net the two sales variances against each other — that is the profit effect of the pricing decision.",
  qtype="case_fact", difficulty=3, provenance="prof_adapted", source=TB)

q("madm-tb19", "madm_fixed_cost_variance", 8,
  "Jason rented a milling machine for $50,000, producing a $50,000 U fixed cost spending variance, a $100,800 F materials quantity variance and a $56,000 F labour quantity variance. Was renting the machine a good decision?",
  ["Yes — it added $106,800 of profit on net",
   "No — the fixed cost variance is unfavourable, which means the rental was not recovered",
   "Cannot tell, because quantity variances are not caused by equipment",
   "Yes, but only because the price variances were also favourable"],
  "Yes — it added $106,800 of profit on net",
  "Group the variances the decision actually caused. Renting the machine raised fixed costs and was expected to improve materials and labour efficiency, so those three belong together:\n\n100,800 F + 56,000 F − 50,000 U = **$106,800 F**.\n\nThis is the clearest illustration in the course that an unfavourable variance can be evidence of a good decision. Read alone, the $50,000 U looks like overspending. Read alongside what it bought, it is one of the best things Jason did all year.\n\nThe price variances came from market conditions and supplier changes, not from the machine, so they stay out of this comparison.",
  "Group the variances by the decision that caused them, then net that group.",
  qtype="case_fact", difficulty=3, provenance="prof_adapted", source=TB)

q("madm-tb20", "madm_variance_decomposition", 8,
  "Space Toys budgeted 15,000 rockets at $25 with a $150,000 profit, and sold 12,000 for $300,000 with an actual profit of $105,000. At 12,000 units the flexible budget profit is $90,000. What are the sales volume and sales price variances?",
  ["Volume $60,000 U, price zero", "Volume $60,000 U, price $75,000 U",
   "Volume $45,000 U, price $15,000 F", "Volume $75,000 U, price $15,000 F"],
  "Volume $60,000 U, price zero",
  "- Sales volume variance = flexible profit − master profit = 90,000 − 150,000 = **$60,000 U**\n- Sales price variance = actual revenue − flexible revenue. The flexible budget at 12,000 units and the budgeted $25 price is $300,000, and actual revenue was also $300,000, so the price variance is **zero**\n\nThe entire revenue shortfall was volume: 3,000 units were not sold, at the budgeted price throughout.\n\nThe flexible budget variance of $15,000 F — actual profit of $105,000 against $90,000 — therefore comes entirely from the cost lines, including a $9,000 F on fixed costs that is worth a second look when volume ran 20% below plan.",
  "Compare flexible against master for volume, and actual revenue against flexible revenue for price.",
  provenance="prof_adapted", source=TB)

q("madm-tb21", "madm_divisional_performance", 9,
  "Ge's division earns 26% on average assets of $300,000. She is offered a project that adds $5,000 of income and $50,000 of assets. What happens to her ROI, and what will she do?",
  ["ROI falls to 23.71%, so she is likely to reject a project that may well be worth taking",
   "ROI rises to 27.6%, so she will accept",
   "ROI is unchanged, so she will be indifferent",
   "ROI falls to 23.71%, and rejecting is the right decision for the firm"],
  "ROI falls to 23.71%, so she is likely to reject a project that may well be worth taking",
  "Current income is 26% of 300,000 = $78,000. With the project, income is $83,000 on assets of $350,000, so ROI = 83,000 / 350,000 = **23.71%**.\n\nThe project itself earns 5,000 / 50,000 = 10%. That may comfortably exceed the firm's cost of capital, in which case the firm wants it and the manager does not — because it dilutes the number she is measured on.\n\nThis is the **underinvestment problem** with ROI, and it is what residual income fixes: charging for capital means any project earning more than the charge raises the measure.",
  "Recompute ROI with the project included, then compare the project's own return against the firm's cost of capital.",
  provenance="prof_adapted", source=TB)

q("madm-tb22", "madm_divisional_performance", 9,
  "A division earns 25% ROI on $1,000,000 of assets. Two projects are available, returning 12% and 18%, against a firm cost of capital of 15%. What does each performance measure produce?",
  ["Measured on profit alone, managers take both, over-investing in the 12% project; measured on ROI, they take neither, under-investing in the 18% one",
   "Measured on profit alone, managers take neither; measured on ROI, they take both",
   "Both measures produce the same, correct outcome: take the 18% project only",
   "Measured on ROI, managers take the 12% project because it is less dilutive"],
  "Measured on profit alone, managers take both, over-investing in the 12% project; measured on ROI, they take neither, under-investing in the 18% one",
  "Two opposite distortions from the same facts.\n\n**Profit alone**: both projects add income, and the manager is never charged for the capital, so both get taken — including the 12% project, which destroys value against a 15% cost of capital.\n\n**ROI**: both returns are below the division's current 25%, so both dilute the reported number and both get rejected — including the 18% project the firm actually wants.\n\nResidual income resolves both. Charge 15% on the capital employed and the 18% project raises the measure while the 12% project lowers it, which is exactly the right ranking.",
  "Work out what each measure rewards, then check each project against the cost of capital and against the current ROI.",
  qtype="case_fact", difficulty=3, provenance="prof_adapted", source=TB)

q("madm-tb23", "madm_divisional_performance", 9,
  "A division reports operating income of $1,200,000 on assets of $6,000,000, with a required return of 12%. What is its residual income, and what does it tell you that ROI does not?",
  ["$480,000 — every project earning above 12% raises it, so the manager has no reason to reject a value-adding project",
   "20% — it is simply ROI expressed as a percentage",
   "$720,000 — it is the capital charge the division has to cover",
   "$480,000 — it lets you rank this division against a smaller one on equal terms"],
  "$480,000 — every project earning above 12% raises it, so the manager has no reason to reject a value-adding project",
  "Residual income = 1,200,000 − (0.12 x 6,000,000) = 1,200,000 − 720,000 = **$480,000**.\n\nWhat it fixes is the ROI underinvestment problem. A division earning 20% rejects a 15% project under ROI because it dilutes the ratio; under residual income the same project adds income above the 12% charge, so it raises the measure and gets taken.\n\nWhat residual income does **not** give you is comparability. It is an absolute amount, so a large division shows a large residual income by construction and cannot be ranked against a smaller one. That is the trade-off against ROI, and it is why the last option is wrong.",
  "Subtract the capital charge from operating income, then ask which of ROI's two problems that fixes.",
  provenance="prof_adapted", source=TB)

q("madm-tb24", "madm_divisional_performance", 9,
  "A firm is 30% debt-financed at a pre-tax cost of debt of 8% and 70% equity-financed at a cost of equity of 12%, with a tax rate of 30%. What is its WACC?",
  ["10.08%", "10.80%", "11.28%", "9.24%"],
  "10.08%",
  "$$\\text{WACC} = (1 - t) \\times w_d \\times r_d + w_e \\times r_e$$\n\nDebt term: 0.70 x 0.30 x 0.08 = 0.0168. Equity term: 0.70 x 0.12 = 0.084.\n\nWACC = 0.0168 + 0.084 = **10.08%**.\n\nThe tax shield applies only to the debt term, because interest is deductible and dividends are not. Forgetting it gives 0.024 + 0.084 = 10.8%, which is the first distractor.",
  "Only the debt component carries the tax shield.",
  provenance="prof_adapted", source=TB)

q("madm-tb25", "madm_divisional_performance", 9,
  "A long-established business relying on personal service rather than modern facilities reports an ROI of 35.71%. What is the most likely explanation?",
  ["The asset base is small because its equipment and buildings are old and mostly depreciated",
   "It has unusually high margins compared with its competitors",
   "It is being measured on residual income rather than ROI",
   "Its current liabilities have been subtracted from the asset base"],
  "The asset base is small because its equipment and buildings are old and mostly depreciated",
  "ROI is a ratio, and a spectacular ratio can come from a small denominator as easily as from a large numerator. A business that competes on personal service rather than facilities will have dated, heavily depreciated capital assets, so net book value is low and ROI is flattered.\n\nThis is a real limitation when comparing divisions. Ranking a division with new plant against one with fully depreciated plant on ROI compares the age of their asset bases as much as their performance.\n\nSubtracting current liabilities is part of the EVA capital base, not ROI, and would not produce this pattern by itself.",
  "A ratio has two halves. Ask what would make the denominator small.",
  qtype="case_fact", provenance="prof_adapted", source=TB)

q("madm-tb26", "madm_tp_capacity", 9,
  "Division A has capacity for 20,000 screens and is currently making 12,000 standard screens. A custom screen costs $105 in variable cost; standard screens sell for $210 with a variable cost of $90. Another division wants 5,000 custom screens. What is the minimum transfer price?",
  ["$105", "$225", "$129", "$195"],
  "$105",
  "Capacity is 20,000 and only 12,000 are being used, so there are 8,000 units of spare capacity — more than enough for the 5,000 custom screens. Nothing is displaced, so the opportunity cost is **zero**.\n\nMinimum TP = variable cost = **$105**.\n\nThe other answers are the same problem under different capacity assumptions. At full capacity each custom screen displaces a standard one worth $120 of contribution, giving 105 + 120 = $225. With only 4,000 units spare, 1,000 standard screens are displaced, costing $120,000 over 5,000 custom screens, or $24 each, giving $129.",
  "Check whether the requested volume fits inside the spare capacity before computing anything else.",
  provenance="prof_adapted", source=TB)

q("madm-tb27", "madm_tp_policy", 10,
  "A division supplies engines with a variable cost of Rs. 10,000 and allocated manufacturing overhead of Rs. 2,000. Engines have a ready external market at Rs. 18,000. What is the appropriate transfer price, and why?",
  ["Rs. 18,000 — the market price is the only one that reflects the opportunity cost of using up capacity in the Engines Division",
   "Rs. 12,000 — variable cost plus a 20% markup covers the cost of supply",
   "Rs. 13,200 — full cost plus 10% recovers both variable and fixed costs",
   "Rs. 10,000 — variable cost, because fixed costs are sunk"],
  "Rs. 18,000 — the market price is the only one that reflects the opportunity cost of using up capacity in the Engines Division",
  "There is a ready external market, so every engine transferred internally is an engine not sold at Rs. 18,000. The opportunity cost is the contribution given up, and variable cost plus that contribution comes to exactly the market price.\n\nAny cost-based price below it artificially depresses profit at the Engines Division and inflates it at Assembly, without changing group profit — and it would tell the Assembly Division that engines are cheaper than they really are.\n\nVariable cost is the right answer only when there is spare capacity and nothing is displaced, which is not the case here.",
  "Ask what the selling division gives up when it transfers a unit that it could otherwise sell.",
  qtype="case_fact", provenance="prof_adapted", source=TB)

q("madm-tb28", "madm_tp_policy", 10,
  "A company cafeteria has a variable cost of $6 per meal and a full cost of $13.50, and comparable meals sell for $12.00 outside. The textbook prefers charging departments the market price of $12.00 even though the cafeteria then records a loss. Why?",
  ["It shows management the cafeteria's true economic value, and the loss is information rather than a reason to close it",
   "It maximises the cafeteria's reported profit, which is what a profit centre should do",
   "It is the only price that recovers the cafeteria's fixed costs",
   "Departments would consume too few meals at any lower price"],
  "It shows management the cafeteria's true economic value, and the loss is information rather than a reason to close it",
  "Charging departments something makes them aware of the cost of the service they are consuming — free internal services get over-consumed. The market price is preferred because it shows the relative monetary value of what the cafeteria provides against what the same meals would cost outside.\n\nThe resulting loss of $1.50 a meal, or $27,000 a year, is then a piece of information: this is what the firm pays to have a cafeteria on site. Management may well decide that is worth it for strategic reasons.\n\nMarket price of $12.00 does not recover the $13.50 full cost — that is precisely why the loss appears.",
  "Ask what charging a department is for, and what a reported internal loss actually tells management.",
  qtype="case_fact", provenance="prof_adapted", source=TB)


# ---------------------------------------------------------------------------
# Emit
# ---------------------------------------------------------------------------

def main() -> int:
    problems: list = []
    seen_topics = {c[0] for c in CONCEPTS}
    seen_scenarios = {s[0] for s in SCENARIOS}

    for topic, session, title, note in CONCEPTS:
        check_markdown(f"concept {topic}", note, problems)
        check_inline_math(f"concept {topic}", note, problems)
        if session not in SESSIONS:
            problems.append(f"concept {topic}: session {session} has no session row")

    for n, (title, summary, sheet) in SESSIONS.items():
        check_markdown(f"session {n} summary", summary, problems)
        check_inline_math(f"session {n} summary", summary, problems)
        if sheet:
            check_markdown(f"session {n} formula sheet", sheet, problems)
            check_inline_math(f"session {n} formula sheet", sheet, problems)

    for sid, session, title, setup, source in SCENARIOS:
        check_markdown(f"scenario {sid}", setup, problems)
        check_inline_math(f"scenario {sid}", setup, problems)

    seen_ids: set = set()
    rows: list = []
    for item in QUESTIONS:
        qid = item["id"]
        shuffled = shuffle_choices(qid, item["choices"], item["correct_answer"])
        check_question(qid, dict(item, choices=shuffled), problems, seen_ids)
        check_inline_math(f"{qid} prompt", item["prompt"], problems)
        check_inline_math(f"{qid} explanation", item["explanation"], problems)
        check_markdown(f"{qid} explanation", item["explanation"], problems)
        if item["topic"] not in seen_topics:
            problems.append(f"{qid}: topic {item['topic']} has no concept row")
        if item["scenario_id"] and item["scenario_id"] not in seen_scenarios:
            problems.append(f"{qid}: scenario {item['scenario_id']} does not exist")
        # groupBySession() keys a topic to the session its *questions* carry, so a question filed
        # under a different session from its concept would split the topic across two sessions.
        concept_session = {c[0]: c[1] for c in CONCEPTS}.get(item["topic"])
        if concept_session is not None and concept_session != item["session"]:
            problems.append(
                f"{qid}: session {item['session']} but concept {item['topic']} is session {concept_session}")
        rows.append(dict(item, choices=shuffled))

    if problems:
        print("\n".join(f"-- PROBLEM: {p}" for p in problems), file=sys.stderr)
        print(f"\n{len(problems)} problem(s); nothing written.", file=sys.stderr)
        return 1

    out: list = []
    w = out.append
    w("-- MADM2 (Managerial Accounting in Decision Making) end-term content, sessions 6-10.")
    w("--")
    w("-- GENERATED FILE. Edit supabase/madm-content.py and regenerate; do not hand-edit.")
    w("-- Every statement upserts, so re-running this on a loaded database is safe.")
    w("--")
    w("-- Prof. Sunil Dutta's half of the course. The outline says both exams are multiple-choice")
    w("-- only, closed book and closed notes, so every question here is playable — unlike BANM2,")
    w("-- there are no short_answer rows.")
    w("--")
    w("-- Sessions 1-5 are Prof. Lunawat's half and the mid-term's scope. They get titles so the")
    w("-- session list reads as deliberately empty rather than broken.")
    w("--")
    w("-- Sources: the session 6-10 decks, the Buckeye National Bank case and its question set, the")
    w("-- transfer pricing case, the professor's practice final and its answer key, the assigned")
    w("-- textbook solutions for sessions 6-10, and the MADM_273 course outline.")
    w("")
    w("begin;")
    w("")
    w("insert into public.learn_courses (course_code, total_sessions, enabled, sort_order)")
    w(f"values ({sql(COURSE)}, {TOTAL_SESSIONS}, true, 3)")
    w("on conflict (course_code) do update")
    w("  set total_sessions = excluded.total_sessions, sort_order = excluded.sort_order;")
    w("")

    w("insert into public.learn_course_content (course_code, outline, announcements) values")
    w(f"  ({sql(COURSE)}, {sql(OUTLINE)}, {sql(ANNOUNCEMENTS)})")
    w("on conflict (course_code) do update set outline = excluded.outline,")
    w("  announcements = excluded.announcements;")
    w("")

    w(f"-- learn_session_content: {len(SESSIONS)} rows")
    for n in sorted(SESSIONS):
        title, summary, sheet = SESSIONS[n]
        w("insert into public.learn_session_content (course_code, session, title, summary, formula_sheet) values")
        w(f"  ({sql(COURSE)}, {n}, {sql(title)},")
        w(f"   {sql(summary)},")
        w(f"   {sql(sheet)})")
        w("on conflict (course_code, session) do update set title = excluded.title,")
        w("  summary = excluded.summary, formula_sheet = excluded.formula_sheet;")
        w("")

    w(f"-- learn_concepts: {len(CONCEPTS)} rows")
    for topic, _session, title, note in CONCEPTS:
        w("insert into public.learn_concepts (course_code, topic, title, note) values")
        w(f"  ({sql(COURSE)}, {sql(topic)}, {sql(title)},")
        w(f"   {sql(note)})")
        w("on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;")
        w("")

    w(f"-- learn_scenarios: {len(SCENARIOS)} rows")
    for sid, session, title, setup, source in SCENARIOS:
        w("insert into public.learn_scenarios (id, course_code, session, title, setup, source) values")
        w(f"  ({sql(sid)}, {sql(COURSE)}, {session}, {sql(title)},")
        w(f"   {sql(setup)}, {sql(source)})")
        w("on conflict (id) do update set title = excluded.title, setup = excluded.setup,")
        w("  session = excluded.session, source = excluded.source;")
        w("")

    w(f"-- learn_questions: {len(rows)} rows")
    for r in rows:
        src = r["source"] or f"Session {r['session']}"
        w("insert into public.learn_questions")
        w("  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,")
        w("   explanation, hint, difficulty, provenance, scenario_id, scenario_order) values")
        w(f"  ({sql(r['id'])}, {sql(COURSE)}, {sql(r['type'])}, {sql(r['topic'])}, {r['session']},")
        w(f"   {sql(r['prompt'])},")
        w(f"   {json_array(r['choices'])}, {sql(r['correct_answer'])}, {sql(src)},")
        w(f"   {sql(r['explanation'])}, {sql(r['hint'])}, {r['difficulty']}, {sql(r['provenance'])},")
        w(f"   {sql(r['scenario_id'])}, {r['scenario_order'] if r['scenario_order'] is not None else 'null'})")
        w("on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,")
        w("  correct_answer = excluded.correct_answer, explanation = excluded.explanation,")
        w("  hint = excluded.hint, topic = excluded.topic, session = excluded.session,")
        w("  difficulty = excluded.difficulty, provenance = excluded.provenance,")
        w("  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order;")
        w("")

    w("commit;")
    w("")

    sys.stdout.write("\n".join(out))

    by_topic: dict = {}
    for r in rows:
        by_topic[r["topic"]] = by_topic.get(r["topic"], 0) + 1
    print(f"\n-- generated: {len(SESSIONS)} sessions, {len(CONCEPTS)} concepts, "
          f"{len(SCENARIOS)} scenarios, {len(rows)} questions", file=sys.stderr)
    print("-- questions per topic (target 8 including madm-practice-bank.py):", file=sys.stderr)
    for topic, _s, _t, _n in CONCEPTS:
        print(f"--   {topic:34s} {by_topic.get(topic, 0)}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
