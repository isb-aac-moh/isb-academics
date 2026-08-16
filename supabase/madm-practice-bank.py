"""MADM2 practice-bank expansion: brings every topic to eight questions.

    python3 supabase/madm-practice-bank.py > supabase/migrations/<timestamp>_madm_practice_bank.sql

supabase/madm-content.py must be applied first — it creates the concepts and scenarios these
questions reference, and it carries the 82 questions that come from the professor's own material
(his practice final, the in-class quick checks, the assigned textbook problems and the two cases).

Everything here is `authored`, which keeps it filterable: if the real exam turns out narrower than
the professor's practice set suggests, the authored rows can be pulled without touching anything he
wrote. EXPECTED below is the shortfall per topic against a target of eight, measured from what
madm-content.py already emits, and the generator refuses to write if the counts drift.

Numbers are computed rather than transcribed, and every worked answer is checkable from the
explanation alone.
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

# Shortfall to eight per topic, given what madm-content.py already emits.
EXPECTED = {
    "madm_relevant_cost_horizon": 7,
    "madm_product_costing": 8,
    "madm_traditional_costing": 8,
    "madm_cost_hierarchy": 5,
    "madm_abc_mechanics": 5,
    "madm_cross_subsidy": 6,
    "madm_abc_implementation": 7,
    "madm_customer_profitability": 5,
    "madm_managing_customers": 7,
    "madm_abm": 8,
    "madm_decentralization": 8,
    "madm_control_systems": 8,
    "madm_responsibility_centers": 6,
    "madm_budget_roles": 8,
    "madm_master_budget": 3,
    "madm_budget_behavior": 5,
    "madm_flexible_budget": 6,
    "madm_variance_decomposition": 3,
    "madm_sales_variances": 4,
    "madm_fixed_cost_variance": 7,
    "madm_variance_interpretation": 6,
    "madm_abc_service_sector": 2,
    "madm_divisional_performance": 3,
    "madm_transfer_pricing_basics": 7,
    "madm_tp_min_max": 4,
    "madm_tp_policy": 3,
    "madm_tp_negotiation": 5,
    "madm_international_tp": 6,
}

# The session each topic belongs to. groupBySession() files a topic under the session its
# questions carry, so a mismatch here would split a concept across two sessions in the app.
SESSION_OF = {
    "madm_relevant_cost_horizon": 6, "madm_product_costing": 6, "madm_traditional_costing": 6,
    "madm_cost_hierarchy": 6, "madm_abc_mechanics": 6, "madm_cross_subsidy": 6,
    "madm_abc_implementation": 6,
    "madm_customer_profitability": 7, "madm_managing_customers": 7, "madm_abm": 7,
    "madm_decentralization": 7, "madm_control_systems": 7, "madm_responsibility_centers": 7,
    "madm_budget_roles": 7, "madm_master_budget": 7, "madm_budget_behavior": 7,
    "madm_flexible_budget": 8, "madm_variance_decomposition": 8, "madm_sales_variances": 8,
    "madm_input_variances": 8, "madm_fixed_cost_variance": 8, "madm_variance_interpretation": 8,
    "madm_abc_service_sector": 8,
    "madm_divisional_performance": 9, "madm_transfer_pricing_basics": 9,
    "madm_tp_min_max": 9, "madm_tp_capacity": 9,
    "madm_tp_policy": 10, "madm_tp_negotiation": 10, "madm_international_tp": 10,
}

QUESTIONS: list = []


def q(qid, topic, prompt, choices, correct, expl, hint=None, qtype="formula", difficulty=2):
    QUESTIONS.append({
        "id": qid, "topic": topic, "session": SESSION_OF[topic], "type": qtype,
        "difficulty": difficulty, "prompt": prompt, "choices": choices,
        "correct_answer": correct, "explanation": expl, "hint": hint,
        "provenance": "authored", "source": f"Session {SESSION_OF[topic]}",
    })


# ===========================================================================
# Session 6 — short-run vs long-run cost (7)
# ===========================================================================

q("madm-a001", "madm_relevant_cost_horizon",
  "A print shop's copier costs $1,000 a year in depreciation, $10,000 a year in wages and $1,000 a year in other overhead, and runs 600,000 pages at two cents a page of ink and paper. What is the full cost per page?",
  ["$0.04", "$0.02", "$0.03", "$0.06"],
  "$0.04",
  "Fixed cost is 1,000 + 10,000 + 1,000 = $12,000 a year. Over 600,000 pages that is two cents a page.\n\nAdd the two cents of variable cost and the full cost is **four cents a page**.\n\nBoth halves are needed for a long-run question — should we run this function at all, what should a five-year contract be worth — and only the variable half matters for a short-run one.",
  "Spread the annual fixed cost over the annual volume, then add the variable cost per page.",
  difficulty=1)

q("madm-a002", "madm_relevant_cost_horizon",
  "The same print shop, with variable cost of two cents and full cost of four cents a page, is offered an outside vendor contract at three cents a page for the next five years. Should it outsource?",
  ["Yes — over five years the capacity costs are avoidable too, so the relevant comparison is four cents against three",
   "No — three cents exceeds the two-cent variable cost, so outsourcing loses money",
   "No — the depreciation on the copier is sunk and cannot be recovered",
   "Cannot tell without knowing the resale value of the copier"],
  "Yes — over five years the capacity costs are avoidable too, so the relevant comparison is four cents against three",
  "Five years is long enough that wages, overhead and the copier itself are all choices rather than commitments. Outsourcing avoids all of them, so the whole four cents is avoidable and three cents is the better deal.\n\nComparing against the two-cent variable cost is the classic error: it treats capacity as given in a decision whose entire point is to stop paying for the capacity.\n\nResale value would sharpen the number but not reverse the direction.",
  "Ask which costs the firm stops paying if it takes the contract.",
  qtype="case_fact")

q("madm-a003", "madm_relevant_cost_horizon",
  "A plant with idle capacity is offered a one-off export order at a price below full cost but above variable cost. Which reasoning supports accepting it?",
  ["The order contributes to fixed costs already committed, so profit rises by the contribution it earns",
   "Full cost is the minimum acceptable price for any order, so it should be declined",
   "The order should be accepted only if it also covers a share of allocated fixed overhead",
   "Accepting is right only if the plant can raise the price on existing customers to match"],
  "The order contributes to fixed costs already committed, so profit rises by the contribution it earns",
  "With idle capacity, nothing is displaced and no capacity cost changes. The only cash consequences are the variable costs of making the order and the revenue it brings, so any price above variable cost adds profit.\n\nThe practical caveats are real and separate: the order must genuinely be one-off, and the price must not leak into the pricing of regular business. Neither changes the arithmetic.\n\nRequiring full-cost recovery on an incremental order applies a long-run rule to a short-run question.",
  "Ask which costs actually change if the order is accepted.",
  qtype="case_fact", difficulty=1)

q("madm-a004", "madm_relevant_cost_horizon",
  "A service business quotes a five-year outsourcing contract for a function it currently performs in-house. Which cost should the quote be tested against?",
  ["Long-run full cost including capacity, because over five years the capacity itself is avoidable",
   "Short-run variable cost, because the equipment is already owned",
   "Last year's actual total cost, because it is the only verified number",
   "Allocated overhead only, since direct costs continue either way"],
  "Long-run full cost including capacity, because over five years the capacity itself is avoidable",
  "The length of the commitment is what determines which costs are in play. A five-year contract replaces the whole function, so equipment, people and supporting overhead all become avoidable and all belong in the comparison.\n\nUsing variable cost here would make in-house look artificially cheap and would systematically reject good outsourcing deals.\n\nLast year's actual total cost is a starting point, not the standard: it includes whatever was unusual about last year and may include costs the contract would not remove.",
  "Match the cost horizon to the length of the commitment being made.",
  qtype="case_fact")

q("madm-a005", "madm_relevant_cost_horizon",
  "A copier has a variable cost of two cents a page and a full cost of four cents. A customer asks for 200,000 pages a year for the next five years — a third of the machine's annual volume. What is the right price floor?",
  ["Closer to full cost, because sustained volume of this size forces a capacity decision",
   "Two cents, because the machine and staff already exist",
   "Two cents, because the customer is incremental to existing business",
   "Four cents plus a margin, because all long-term contracts must be priced at cost plus"],
  "Closer to full cost, because sustained volume of this size forces a capacity decision",
  "The distinction is not one-off versus repeat, it is whether the commitment puts capacity back in play. Two hundred thousand pages a year for five years is a third of the machine's throughput and a five-year obligation — it will drive decisions about machines, shifts and staffing.\n\nSo the variable-cost floor, which assumes capacity is fixed and free, no longer applies. The floor moves toward full cost.\n\nA true one-off order into spare capacity is the only case where two cents is defensible.",
  "Ask whether the order is small and temporary enough to leave capacity decisions untouched.",
  qtype="case_fact", difficulty=3)

q("madm-a006", "madm_relevant_cost_horizon",
  "Which statement best captures why the same set of facts can produce several different, all correct, cost numbers?",
  ["Cost is defined relative to a decision, and different decisions make different resources avoidable",
   "Accounting standards permit several treatments, so any of them can be chosen",
   "Managers disagree, so cost is ultimately a matter of negotiation",
   "Fixed costs can be measured in more than one way, while variable costs cannot"],
  "Cost is defined relative to a decision, and different decisions make different resources avoidable",
  "The professor's first parting thought: there is no such thing as *the* cost of something. A number is only meaningful once you say what decision it is for.\n\nTwo cents and four cents are both right for the copier. One answers what an extra page costs; the other answers what running the function costs. Neither is a better estimate of the other.\n\nThis is not about accounting flexibility or disagreement — it is about the question changing which resources are actually in play.",
  "Ask what makes a cost relevant in the first place.",
  qtype="case_fact", difficulty=1)

q("madm-a007", "madm_relevant_cost_horizon",
  "A cartridge costs $400 and lasts 40,000 pages; paper costs $0.01 per page. The copier has spare capacity. What does one additional page cost?",
  ["$0.02", "$0.01", "$0.04", "$0.03"],
  "$0.02",
  "Ink per page = 400 / 40,000 = **$0.01**. Paper is another **$0.01**.\n\nSo one more page costs **two cents**, and nothing else changes: the machine, the wages and the overhead are all unaffected by whether the page is printed.\n\nFour cents is the full cost, which includes the annual fixed cost spread over budgeted volume — a number that answers a completely different question.",
  "Only the two consumables scale with pages. Convert the cartridge cost to a per-page figure.",
  difficulty=1)

# ===========================================================================
# Session 6 — product costing (8)
# ===========================================================================

q("madm-a008", "madm_product_costing",
  "In product costing, what distinguishes a direct cost from an indirect cost?",
  ["A direct cost can be traced to the product easily and unambiguously; an indirect cost serves several products at once",
   "A direct cost varies with volume; an indirect cost does not",
   "A direct cost is paid in cash; an indirect cost is an accounting accrual",
   "A direct cost appears on the income statement; an indirect cost sits on the balance sheet"],
  "A direct cost can be traced to the product easily and unambiguously; an indirect cost serves several products at once",
  "Traceability is the dividing line. Direct material and direct labour attach to a specific unit and there is a record showing it. Overhead is a resource shared across products, where tracing to any one of them is difficult or not worth the effort.\n\nThe distinction is not the same as variable versus fixed. Some overhead is variable — factory electricity — and some direct cost can behave like a fixed commitment. Confusing the two pairs is one of the most common errors in the topic.",
  "Ask whether a record exists that assigns the cost to one product without an allocation step.",
  qtype="case_fact", difficulty=1)

q("madm-a009", "madm_product_costing",
  "A single-product factory has variable cost of $18 a unit, fixed cost of $360,000 and makes 40,000 units. What is full cost per unit, and why is it uncontroversial here?",
  ["$27 — with one product there is no allocation choice to make",
   "$18 — fixed costs are never part of product cost",
   "$27 — but only if the fixed costs are all manufacturing costs",
   "$9 — fixed cost per unit is the full cost"],
  "$27 — with one product there is no allocation choice to make",
  "Fixed cost per unit is 360,000 / 40,000 = $9, so full cost is 18 + 9 = **$27**.\n\nWhat makes it uncontroversial is that every cost belongs to the same product. There is no second product to argue about, so any allocation method assigns 100% of the fixed pool to the same place and gives the same answer.\n\nThe whole subject of cost allocation exists only because multiproduct firms share resources, and no transaction record says how to divide them.",
  "Compute fixed cost per unit, add variable cost, and ask what allocation decision was required.",
  difficulty=1)

q("madm-a010", "madm_product_costing",
  "Why does the choice of overhead allocation method matter beyond the accounting department?",
  ["Reported product profitability drives pricing, product-line and investment decisions, so the allocation shapes strategy",
   "Allocation determines the firm's total reported profit, so it changes what shareholders see",
   "Regulators require a specific method, so the wrong choice creates compliance risk",
   "It determines total overhead spending for the coming year"],
  "Reported product profitability drives pricing, product-line and investment decisions, so the allocation shapes strategy",
  "Allocation does not change how much overhead there is; it changes which product appears to be consuming it. That reported profitability is what managers price on, invest behind and cut.\n\nThe two-product example is the whole argument in miniature: one allocation says drop Product A, another says Product B is losing $5.21 a unit. Same firm, same overhead, opposite strategy.\n\nTotal firm profit is unaffected by the split, which is exactly why the second option is wrong.",
  "Ask what changes when the allocation changes: the total, or the ranking?",
  qtype="case_fact")

q("madm-a011", "madm_product_costing",
  "Which of these is best described as an indirect cost with respect to an individual product line?",
  ["The salary of a plant scheduler who sequences runs for every product",
   "Sheet steel consumed in one product's chassis",
   "Piece-rate wages paid to operators of a dedicated single-product line",
   "A royalty paid per unit of one branded product sold"],
  "The salary of a plant scheduler who sequences runs for every product",
  "The scheduler serves every product, so assigning her cost to any one of them requires an allocation choice — the definition of an indirect cost. In ABC terms she is a batch-level resource, driven by the number of production runs.\n\nThe other three all attach to a single product with a record showing it: material consumed by one chassis, wages on a dedicated line, and a per-unit royalty on one brand.\n\nNote that a dedicated line's wages are direct even though the line is a capacity resource. Traceability, not behaviour, is the test.",
  "Ask whether the cost serves one product or several.",
  qtype="case_fact")

q("madm-a012", "madm_product_costing",
  "A firm prices its products at variable cost plus a fixed percentage margin. What risk does this create in a business with substantial overhead?",
  ["Prices may not recover capacity costs over the long run, even though every order looks profitable",
   "Prices will be too high, because variable cost overstates the true cost of an order",
   "Products with high overhead consumption will be systematically over-priced",
   "There is no risk, because contribution margin is the only relevant measure"],
  "Prices may not recover capacity costs over the long run, even though every order looks profitable",
  "Variable-cost pricing is right for the marginal order into spare capacity, and wrong as a standing policy. If the margin percentage does not happen to cover the capacity cost that the product line consumes, every order looks profitable while the business as a whole does not recover its overhead.\n\nThat is the essence of the copying example run for five years rather than one month, and it is why long-run decisions need long-run costs including capacity.\n\nThe two over-pricing options have the direction backwards: variable-cost pricing under-charges, it does not over-charge.",
  "Ask what a variable-cost-based price does not cover, and over what horizon that matters.",
  qtype="case_fact")

q("madm-a013", "madm_product_costing",
  "Full absorption costing is required for financial reporting. What does that requirement mean for managerial decision-making?",
  ["Nothing directly — the reported number serves inventory valuation, and the decision-relevant cost has to be worked out separately",
   "Managers must use the same absorbed cost for all internal decisions, for consistency",
   "It means fixed costs are always relevant, since the standard requires their inclusion",
   "It means variable costing is not permitted anywhere in the firm"],
  "Nothing directly — the reported number serves inventory valuation, and the decision-relevant cost has to be worked out separately",
  "Financial reporting needs one number that is comparable across firms and consistent over time. A decision needs a number that reflects what actually changes if the decision is taken. There is no reason those two should be the same.\n\nUsing the absorbed cost internally is exactly how firms end up rejecting profitable incremental orders and mispricing capacity decisions.\n\nManagement accounting exists as a separate discipline precisely because the reporting number does not answer managerial questions.",
  "Ask what the reporting requirement is for, and whether that purpose matches a decision's purpose.",
  qtype="case_fact")

q("madm-a014", "madm_product_costing",
  "A firm makes two products from a shared plant. Which fact would make a single plantwide overhead rate a reasonable approximation?",
  ["Both products are made in similar batch sizes and consume support activities in proportion to their volume",
   "The two products have very different selling prices",
   "One product is made to order and the other to stock",
   "Overhead is a large share of total cost"],
  "Both products are made in similar batch sizes and consume support activities in proportion to their volume",
  "A single volume-based rate is right when overhead genuinely does move with volume for both products. Similar batch sizes and proportional support consumption is precisely that condition.\n\nDiffering prices say nothing about cost causation. Make-to-order versus make-to-stock is a reason the rate would fail, because the two have very different batch profiles. A large overhead share raises the stakes of getting the allocation wrong rather than making a single rate more defensible.",
  "Ask under what condition allocating by volume gives the same answer as allocating by cause.",
  qtype="case_fact", difficulty=3)

q("madm-a015", "madm_product_costing",
  "A firm's overhead is $600,000 and its two products have direct costs of $400,000 and $200,000. If overhead is allocated in proportion to direct cost, how much is charged to the second product, and what is being assumed?",
  ["$200,000 — that overhead consumption is proportional to direct cost",
   "$300,000 — that overhead is shared equally between the lines",
   "$200,000 — that overhead is a batch-level cost",
   "$400,000 — that the larger product should absorb less overhead"],
  "$200,000 — that overhead consumption is proportional to direct cost",
  "Total direct cost is $600,000, so the second product's share is 200,000 / 600,000 = one third, giving **$200,000** of overhead.\n\nThe embedded assumption is that a product consuming twice the direct cost also consumes twice the support resources. That is a volume-based assumption dressed in different clothing, and it fails for exactly the same reason: setups, order processing and design support do not scale with material and labour spending.\n\nAn equal split would be a facility-level treatment, which is a different assumption again — and rarely the right one for support activities.",
  "Compute the proportion, then state what has to be true for that base to allocate causally.",
  difficulty=1)

# ===========================================================================
# Session 6 — traditional costing (8)
# ===========================================================================

q("madm-a016", "madm_traditional_costing",
  "A plant has overhead of $840,000 and 42,000 direct labour hours. Product X uses 1.5 labour hours per unit. Under a single plantwide rate, how much overhead is charged to one unit of X?",
  ["$30", "$20", "$45", "$13.33"],
  "$30",
  "Rate = 840,000 / 42,000 = **$20 per labour hour**.\n\nOne unit of X uses 1.5 hours, so it absorbs 1.5 x 20 = **$30**.\n\nWhat this number cannot see is anything about X other than its labour content — not how many setups it needs, not how many orders it arrives in, not whether it has its own design team.",
  "Compute the plantwide rate first, then apply it to this product's hours.",
  difficulty=1)

q("madm-a017", "madm_traditional_costing",
  "What is the single assumption behind a volume-based overhead allocation?",
  ["That overhead is proportional to the volume measure chosen as the base",
   "That overhead is fixed in total and therefore must be spread evenly",
   "That direct labour is the largest component of product cost",
   "That every product has the same gross margin"],
  "That overhead is proportional to the volume measure chosen as the base",
  "Whether the base is labour hours, machine hours, labour dollars or units, the claim is the same: a product that uses twice as much of the base consumes twice as much overhead.\n\nWhen it holds, the system is right and there is nothing for ABC to fix. When it does not — because much of the overhead is driven by batches, product lines or customer behaviour — the allocation is arbitrary and the distortion follows.\n\nDirect labour being large used to be the reason it was chosen as a base. It has not been true in most manufacturing for decades, which is part of why the distortion grew.",
  "State what has to be true about overhead for the base to allocate causally.",
  qtype="case_fact", difficulty=1)

q("madm-a018", "madm_traditional_costing",
  "Under the two-product example, Product A absorbs $4.76 of overhead per unit and Product B $5.71, on total overhead of $100,000. What is the labour-hour rate being used?",
  ["$9.52 per labour hour", "$4.76 per labour hour", "$10.00 per labour hour", "$5.00 per labour hour"],
  "$9.52 per labour hour",
  "A uses 0.5 hours per unit, so 4.76 / 0.5 = $9.52. B uses 0.6, so 5.71 / 0.6 = $9.52 as well.\n\nDirectly: total hours are 15,000 x 0.5 = 7,500 for A and 5,000 x 0.6 = 3,000 for B, giving 10,500. The rate is 100,000 / 10,500 = **$9.52 per hour**.\n\nOne rate for the whole plant is the defining feature of the traditional system, and it is why the only thing that distinguishes the two products in the answer is their labour content.",
  "Back out the rate from either product's overhead per unit and its labour hours per unit.",
  difficulty=1)

q("madm-a019", "madm_traditional_costing",
  "Under the traditional system, Product A shows a gross margin of −$0.76 a unit and Product B $1.29. What does that report recommend, and what happens if the firm follows it?",
  ["Drop A — and the firm would drop the product that is actually earning $1.40 a unit under a causal allocation",
   "Drop B — and the firm would be correct, because B genuinely loses money",
   "Raise A's price — and the firm would lose the volume that absorbs most of its overhead",
   "Do nothing — the two margins net to a profit"],
  "Drop A — and the firm would drop the product that is actually earning $1.40 a unit under a causal allocation",
  "The traditional report says A loses money, so the obvious action is to drop it. Under ABC, A earns $1.40 a unit and B loses $5.21 — the ranking is exactly reversed.\n\nDropping A would remove 15,000 units of profitable volume and leave the firm with the product whose fifty small orders were consuming $50,000 of batch cost.\n\nThe margins do not net to a profit either: the business as stated is losing $5,000.",
  "Compare what the traditional report says with what the activity-based rebuild says.",
  qtype="case_fact")

q("madm-a020", "madm_traditional_costing",
  "A firm switches its allocation base from direct labour hours to machine hours. What happens to total reported overhead?",
  ["It is unchanged — only the split between products moves",
   "It falls, because machine hours are a more accurate base",
   "It rises, because machine-intensive products absorb more",
   "It depends on whether the firm is above or below budgeted volume"],
  "It is unchanged — only the split between products moves",
  "An allocation base divides a pool; it does not change the pool. Whatever the base, 100% of the overhead is assigned somewhere.\n\nWhat does move is the ranking. Machine-intensive products will absorb more and labour-intensive ones less, which can flip a product from apparently profitable to apparently not — without a single real cost having changed.\n\nThat is the general lesson of the session: allocation changes decisions, not spending.",
  "Ask whether changing how a fixed pool is divided can change its size.",
  qtype="case_fact", difficulty=1)

q("madm-a021", "madm_traditional_costing",
  "A plant makes 90,000 units of a standard product in six runs and 10,000 units of a custom product in forty runs. Overhead of $500,000 is allocated on units. How much does each unit of the custom product absorb, and why is that misleading?",
  ["$5 — the same as the standard unit, even though the custom product triggers forty of the forty-six runs",
   "$50 — because the custom product's low volume raises its per-unit share",
   "$5 — and it is not misleading, since both products go through the same plant",
   "$0.50 — because unit-based allocation weights by total volume"],
  "$5 — the same as the standard unit, even though the custom product triggers forty of the forty-six runs",
  "Rate = 500,000 / 100,000 units = **$5 a unit**, charged identically to both products.\n\nBut the custom product accounts for forty of the forty-six production runs on a tenth of the volume. Whatever part of that $500,000 is setup, scheduling and order processing is being driven overwhelmingly by the custom product, and unit-based allocation charges the standard product for most of it.\n\nThat is the cross-subsidy: the custom product is undercosted and the standard product overcosted, and the reported margins point in the wrong direction.",
  "Compare each product's share of units against its share of production runs.",
  difficulty=3)

q("madm-a022", "madm_traditional_costing",
  "Which of these is a legitimate reason a firm might keep a single volume-based rate despite knowing it distorts?",
  ["The cost of building and maintaining a more refined system exceeds the value of the better decisions it would support",
   "A single rate is required for external financial reporting",
   "Volume-based rates are more accurate for firms with high overhead",
   "Regulators prohibit multiple overhead pools"],
  "The cost of building and maintaining a more refined system exceeds the value of the better decisions it would support",
  "This is the professor's implementation point: weigh the cost and benefit of incremental precision. A more refined system needs activity analysis, driver measurement and ongoing maintenance, and if the decisions it would change are small, the cheaper system wins.\n\nFinancial reporting requires full absorption, not a single rate, and firms routinely report using several pools. Nothing in regulation prohibits multiple pools, and a high overhead share is an argument for refinement rather than against it.",
  "Ask what the more refined system costs, and what the better numbers are worth.",
  qtype="case_fact")

q("madm-a023", "madm_traditional_costing",
  "Overhead is $100,000, allocated on labour hours. Product A uses 7,500 hours and Product B 3,000. If B's process is automated so its labour falls to 1,000 hours with no change in the overhead pool or in B's actual resource consumption, what happens to reported costs?",
  ["A's allocated overhead rises to about $88,200 while B's falls, purely because of the change in the base",
   "Both products' allocated overhead falls, since total hours fell",
   "Nothing changes, because the overhead pool is unchanged",
   "B's allocated overhead rises, because automation is capital-intensive"],
  "A's allocated overhead rises to about $88,200 while B's falls, purely because of the change in the base",
  "Total hours drop from 10,500 to 8,500, so the rate rises to 100,000 / 8,500 = $11.76 per hour. A still uses 7,500 hours, so it now absorbs 7,500 x 11.76 = **$88,235**, up from $71,429. B absorbs the remaining $11,765.\n\nNothing about A changed. Its reported cost rose because another product left the base.\n\nThis is the perverse feedback that volume-based allocation creates: automating one product makes every other product look more expensive, which can trigger price rises or product cuts that have nothing to do with real costs.",
  "Recompute the rate with the new total hours, then reapply it to A's unchanged hours.",
  difficulty=3)

# ===========================================================================
# Session 6 — cost hierarchy (5)
# ===========================================================================

q("madm-a024", "madm_cost_hierarchy",
  "A bakery incurs the following: flour, oven cleaning between product changeovers, the annual recipe review for each product line, and the bakery's building insurance. In hierarchy order from unit to facility, how do they classify?",
  ["Flour unit, oven cleaning batch, recipe review product, insurance facility",
   "Flour unit, oven cleaning unit, recipe review batch, insurance facility",
   "Flour batch, oven cleaning batch, recipe review product, insurance product",
   "Flour unit, oven cleaning product, recipe review facility, insurance facility"],
  "Flour unit, oven cleaning batch, recipe review product, insurance facility",
  "Ask what triggers each cost one more time.\n\n- **Flour**: one more loaf — unit level\n- **Oven cleaning between changeovers**: one more production run — batch level\n- **Annual recipe review per line**: one more product line kept alive — product level\n- **Building insurance**: one more year in business — facility level\n\nThe hierarchy is a question about the trigger, not about size or about whether the cost feels fixed.",
  "For each cost, ask what has to happen once more for it to be incurred again.",
  qtype="case_fact")

q("madm-a025", "madm_cost_hierarchy",
  "A firm treats machine setup cost as a unit-level cost by dividing total setup cost by total units. What error does this introduce?",
  ["Products made in small runs are undercosted and products made in large runs are overcosted",
   "Products made in small runs are overcosted and products made in large runs are undercosted",
   "Total overhead is understated, because setups are counted only once",
   "No error, provided every product is made in the same batch size"],
  "Products made in small runs are undercosted and products made in large runs are overcosted",
  "A setup happens once per run regardless of run length. Dividing by units charges every unit equally, so a product made in fifty small runs pays the same per unit as one made in five large runs — even though it triggered ten times the setups.\n\nSo the small-run product is **undercosted** and the large-run product **overcosted**, which is the cross-subsidy in its purest form.\n\nThe last option is the useful qualification: if every product is made in identical batch sizes, unit-based allocation of setups happens to give the right answer.",
  "Compare each product's share of units against its share of setups.",
  qtype="case_fact")

q("madm-a026", "madm_cost_hierarchy",
  "Why are facility-level costs usually left unallocated when ABC data is used for decision-making?",
  ["There is no causal driver linking them to products, so allocating them adds a charge that changes rankings without carrying information",
   "They are always immaterial in size",
   "Financial reporting standards prohibit allocating them",
   "They are variable, so they belong in contribution margin instead"],
  "There is no causal driver linking them to products, so allocating them adds a charge that changes rankings without carrying information",
  "Rent, plant insurance and general administration are consumed by being in business, not by making any particular product. Any driver you pick — units, square feet, revenue — is a convention rather than a cause.\n\nAllocating them anyway loads every product with an arbitrary charge that can flip a product from apparently profitable to apparently not, purely as a function of the convention chosen.\n\nFinancial reporting does require them in inventory valuation. That is a reporting requirement, not a decision rule, and the textbook solution to the Pema problem says exactly this: facility-level costs are not allocated because they are not controllable at the product level.",
  "Ask whether any driver would genuinely reflect causation, and what allocating anyway does to product rankings.",
  qtype="case_fact")

q("madm-a027", "madm_cost_hierarchy",
  "A firm's batch-level pool is $240,000 and it runs 800 batches a year. A product currently made in 120 batches of 500 units is re-planned into 40 batches of 1,500 units. How much batch cost does it shed, assuming the rate holds?",
  ["$24,000", "$36,000", "$12,000", "Nothing — total batch cost is unchanged"],
  "$24,000",
  "Rate = 240,000 / 800 = **$300 per batch**.\n\nThe product currently absorbs 120 x 300 = $36,000. At 40 batches it absorbs 40 x 300 = $12,000.\n\nSaving = **$24,000**.\n\nThe important caveat is in the last option. In the short run the batch pool may not fall at all — the staff and equipment are still there. The saving is real over the horizon in which that capacity can be released or redeployed, which is precisely the short-run versus long-run distinction the session opened with.",
  "Compute the rate per batch, then apply it to the old and new batch counts.",
  difficulty=3)

q("madm-a028", "madm_cost_hierarchy",
  "Which cost is best classified as product-level rather than batch-level?",
  ["Maintaining and updating a product line's design specifications",
   "Processing a customer order",
   "Setting up a machine before a run",
   "Shipping a completed order to a customer"],
  "Maintaining and updating a product line's design specifications",
  "Design specifications exist for as long as the product line exists, and they cost the same whether the line is made in one run or fifty — **product level**.\n\nThe other three all recur with each order or run: processing an order, setting up before a run, shipping an order. All batch level.\n\nThe test is whether the cost scales with runs or with the existence of the product line.",
  "Ask whether the cost recurs with each run, or once for the product line as a whole.",
  qtype="case_fact", difficulty=1)

# ===========================================================================
# Session 6 — ABC mechanics (5)
# ===========================================================================

q("madm-a029", "madm_abc_mechanics",
  "An ABC system has an ordering pool of $180,000 over 3,000 orders and an inspection pool of $90,000 over 1,500 inspections. A product consumes 240 orders and 45 inspections. How much overhead is assigned to it?",
  ["$17,100", "$14,400", "$2,700", "$21,600"],
  "$17,100",
  "Two rates, then two multiplications.\n\n- Ordering: 180,000 / 3,000 = $60 an order, so 240 orders cost **$14,400**\n- Inspection: 90,000 / 1,500 = $60 an inspection, so 45 inspections cost **$2,700**\n\nTotal assigned = **$17,100**.\n\nThe rates happen to be equal here, which is a good reminder that the rate is not what matters — the driver quantities are. This product's ordering charge is more than five times its inspection charge purely because it triggers far more orders.",
  "One rate per pool, each multiplied by the driver units this product consumed, then summed.",
  difficulty=1)

q("madm-a030", "madm_abc_mechanics",
  "What is the two-stage logic that distinguishes ABC from a single plantwide rate?",
  ["Resources are first traced to activity cost pools, and pools are then assigned to cost objects by a causal driver",
   "Direct costs are assigned first and indirect costs second",
   "Variable costs are pooled separately from fixed costs before allocation",
   "Costs are assigned to departments first and then to products by headcount"],
  "Resources are first traced to activity cost pools, and pools are then assigned to cost objects by a causal driver",
  "The insight it rests on is that products do not consume resources directly — they consume **activities**, and activities consume resources. So the assignment needs two stages rather than one.\n\nA single plantwide rate collapses both stages into one volume-based step, which is exactly what loses the information about batches, product support and customer behaviour.\n\nSeparating variable from fixed is a different distinction entirely, and departmental allocation by headcount is just a two-stage version of the same volume-based error.",
  "Ask what sits between the resource and the product in the ABC chain.",
  qtype="case_fact", difficulty=1)

q("madm-a031", "madm_abc_mechanics",
  "A firm's total overhead is $100,000. After switching from a single labour-hour rate to three activity pools, what happens to total overhead assigned to products?",
  ["It stays at $100,000 — ABC reassigns the pool rather than changing it",
   "It falls, because ABC identifies waste",
   "It rises, because more pools mean more cost is captured",
   "It falls by the amount of facility-level cost that is no longer allocated"],
  "It stays at $100,000 — ABC reassigns the pool rather than changing it",
  "ABC is a measurement change, not a spending change. The same $100,000 is divided differently, and the total assigned is identical.\n\nWhat changes is which product carries which share, and that is what changes decisions.\n\nThe last option is the near-miss worth thinking about. If a firm chooses to leave facility-level cost unallocated for decision purposes, the amount *assigned to products* does fall — but the overhead still exists, and this is a presentation choice rather than something ABC does automatically.",
  "Ask whether dividing a pool differently can change how large the pool is.",
  qtype="case_fact", difficulty=1)

q("madm-a032", "madm_abc_mechanics",
  "In the two-product example, unit-level overhead is $30,000 over 10,500 labour hours, batch-level is $65,000 over 65 orders, and product-level is $5,000 split equally. Product A uses 7,500 hours and 15 orders. What overhead does A absorb in total?",
  ["$38,929", "$21,429", "$36,429", "$61,071"],
  "$38,929",
  "Three rates, three charges.\n\n- Unit level: 30,000 / 10,500 = $2.857 an hour, so 7,500 hours cost **$21,429**\n- Batch level: 65,000 / 65 = $1,000 an order, so 15 orders cost **$15,000**\n- Product level: **$2,500**, half of the $5,000\n\nTotal = **$38,929**, or $2.60 per unit over 15,000 units.\n\nProduct B absorbs the balance of $61,071, which is $12.21 a unit. The gap comes almost entirely from the batch line: fifty orders against fifteen.",
  "Compute all three rates, then charge A for the driver units it consumed at each level.",
  difficulty=3)

q("madm-a033", "madm_abc_mechanics",
  "Which choice of cost driver would be least defensible for an order-processing cost pool?",
  ["Direct labour hours", "Number of orders processed",
   "Number of order lines processed", "Number of order changes handled"],
  "Direct labour hours",
  "Order processing is triggered by orders, not by production time. Direct labour hours would charge a product for order processing in proportion to how long it takes to make — which has nothing to do with how many times somebody had to enter an order.\n\nThe other three are all plausible drivers of the same pool at different levels of refinement. Order lines and order changes are more precise than order count when orders vary a lot in complexity, at the cost of more measurement.\n\nUsing labour hours here is exactly the traditional system's error, applied to one pool instead of all of them.",
  "Ask which quantity actually makes the order-processing department do more work.",
  qtype="case_fact")

# ===========================================================================
# Session 6 — cross-subsidy (6)
# ===========================================================================

q("madm-a034", "madm_cross_subsidy",
  "Under a volume-based system, which pair of statements is correct?",
  ["High-volume standard products are overcosted; low-volume custom products are undercosted",
   "High-volume standard products are undercosted; low-volume custom products are overcosted",
   "Both product types are overcosted, because overhead is double-counted",
   "Neither is systematically mis-costed; errors are random"],
  "High-volume standard products are overcosted; low-volume custom products are undercosted",
  "The mechanism: volume-based allocation charges by units or hours, but a large share of overhead is triggered by batches and product support. The low-volume product consumes those resources out of proportion to its volume, and the allocation cannot see it.\n\nSo the low-volume product is **undercosted** and, because the same pool is being divided, the high-volume product must be **overcosted** by the same amount.\n\nThe errors are systematic rather than random, which is what makes the effect predictable and dangerous.",
  "Ask which product consumes support resources out of proportion to its volume.",
  qtype="case_fact", difficulty=1)

q("madm-a035", "madm_cross_subsidy",
  "What is the strategic danger of cross-subsidy, stated at the level of the whole firm?",
  ["The firm accumulates unprofitable products and customers while believing it is growing, and margins erode",
   "The firm reports lower total profit than it actually earns",
   "The firm's inventory valuation breaches accounting standards",
   "The firm's overhead spending rises automatically over time"],
  "The firm accumulates unprofitable products and customers while believing it is growing, and margins erode",
  "Each individual decision is rational given the numbers on the page. The undercosted specialty product looks profitable, so the firm adds more like it; the overcosted standard product looks marginal, so it gets priced up or cut.\n\nRevenue grows, complexity grows, and margins fall — with a cost system reporting nothing wrong, because it was never measuring the thing that changed.\n\nTotal reported profit is unaffected by the allocation, so the second option is wrong. Overhead spending does tend to rise, but as a consequence of the added complexity rather than automatically.",
  "Ask what each individual decision does, then ask what the sequence of them does.",
  qtype="case_fact")

q("madm-a036", "madm_cross_subsidy",
  "A firm prices at cost plus a fixed margin using volume-based costs. Which customers leave first, and what happens to the mix?",
  ["Customers of the overcosted standard products, because they are being over-priced — and the mix drifts toward the complex products",
   "Customers of the undercosted custom products, because they can find better value elsewhere",
   "Both leave at the same rate, so the mix is stable",
   "Neither leaves, because cost-plus pricing tracks the market"],
  "Customers of the overcosted standard products, because they are being over-priced — and the mix drifts toward the complex products",
  "Cost-plus on distorted costs produces distorted prices. The overcosted standard product is priced too high, so competitors can undercut it and those customers go. The undercosted custom product is priced too low, so it attracts more demand.\n\nThe result is the lawn-mowing dynamic: easy jobs leave, difficult jobs arrive, and average cost per job rises while the price formula stays the same.\n\nOver time the firm ends up specialising in exactly the work its cost system said was cheap and its cost system was wrong about.",
  "Which customers are being charged more than the product really costs, and what will they do?",
  qtype="case_fact", difficulty=3)

q("madm-a037", "madm_cross_subsidy",
  "A firm's ABC study shows the standard product's cost falling from $10.76 to $8.60 and the custom product's rising from $12.71 to $19.21. What should the firm consider doing about the custom product?",
  ["Reprice it, impose minimum order sizes, or reduce its batch costs before deciding whether to drop it",
   "Drop it immediately, since a $5.21 loss per unit is unsustainable",
   "Keep it unchanged, since ABC estimates are approximate",
   "Reallocate its batch costs to the standard product to restore its margin"],
  "Reprice it, impose minimum order sizes, or reduce its batch costs before deciding whether to drop it",
  "This is the class debate, and both teams had real arguments. Dropping the product frees resources and stops the bleeding; keeping it may be right if repricing works, if minimum order sizes cut batch costs, if the customers who buy it also buy the standard product, or if there is strategic value beyond the current margin.\n\nThe quantified version makes the case for acting rather than dropping: consolidating fifty small orders into ten large ones sheds $40,000 of batch cost, which is most of the loss.\n\nDropping without trying is the reflex the session was designed to slow down. Reallocating the cost back is just returning to the system that caused the problem.",
  "Ask what is actually driving the loss, and whether that driver can be changed.",
  qtype="case_fact")

q("madm-a038", "madm_cross_subsidy",
  "A manager argues that cross-subsidy does not matter because the two products' errors cancel out in total. What is wrong with the argument?",
  ["Total profit is unaffected, but the errors drive product-level decisions — and those are made one product at a time",
   "The errors do not cancel out; ABC finds additional overhead that the old system missed",
   "It is correct for manufacturers but not for service firms",
   "It is correct only if the two products have the same margin"],
  "Total profit is unaffected, but the errors drive product-level decisions — and those are made one product at a time",
  "The manager is right about the arithmetic. Allocation divides a fixed pool, so an overstatement on one product is an equal understatement on the other and the total is unchanged.\n\nHe is wrong about what the numbers are for. Nobody prices, drops or invests in the product portfolio in aggregate. Every one of those decisions is made about one product, using that product's reported margin — and both of those margins are wrong, in opposite directions.\n\nThe cancellation is precisely what makes it invisible, and that is what makes it dangerous.",
  "Ask what the reported numbers are used for, and at what level of aggregation those decisions are made.",
  qtype="case_fact", difficulty=3)

q("madm-a039", "madm_cross_subsidy",
  "A high-volume product looks unprofitable under a volume-based system and is dropped. What happens to the remaining product's reported cost?",
  ["It rises, because the same overhead is now spread over a smaller base",
   "It falls, because total overhead falls with the dropped product",
   "It is unchanged, because each product's overhead was independently calculated",
   "It falls, because the remaining product uses fewer labour hours per unit"],
  "It rises, because the same overhead is now spread over a smaller base",
  "Dropping the high-volume product removes most of the allocation base and very little of the overhead — the batch, product and facility costs largely stay. So the rate rises, and the remaining product's reported cost rises with it.\n\nWhich may make the remaining product look unprofitable, prompting another cut. That is the death spiral, and it comes entirely from a cost system that mistakes an allocation for a cause.\n\nEach product's overhead was never independently calculated: they share one rate, so they are mechanically linked.",
  "Ask what happens to the allocation rate when volume leaves but overhead mostly stays.",
  qtype="case_fact", difficulty=3)

# ===========================================================================
# Session 6 — ABC implementation (7)
# ===========================================================================

q("madm-a040", "madm_abc_implementation",
  "Which firm is the strongest candidate for an ABC implementation?",
  ["A specialty chemicals maker running high-volume commodity grades and low-volume custom grades on the same plant",
   "A quarry selling one grade of crushed stone",
   "A single-product contract manufacturer with one customer",
   "A firm whose overhead is 3% of total cost"],
  "A specialty chemicals maker running high-volume commodity grades and low-volume custom grades on the same plant",
  "ABC pays where **diversity** creates distortion. High- and low-volume lines sharing a plant is the textbook case: the custom grades consume setups, cleaning and technical support out of all proportion to their volume.\n\nA quarry with one product and a single-product contract manufacturer have nothing to reallocate. A firm with 3% overhead has almost nothing at stake — even a large percentage error in allocating it moves product cost very little.",
  "Ask which firm has both a large overhead pool and products that consume it unevenly.",
  qtype="case_fact", difficulty=1)

q("madm-a041", "madm_abc_implementation",
  "What does the professor's advice to be approximately right rather than grossly wrong imply for the number of activity pools?",
  ["Use enough pools to capture the main causal differences, and stop before the measurement cost exceeds the decision value",
   "Use as many pools as there are cost accounts, to maximise accuracy",
   "Use exactly four pools, one per level of the cost hierarchy",
   "Use one pool, since more pools introduce estimation error"],
  "Use enough pools to capture the main causal differences, and stop before the measurement cost exceeds the decision value",
  "Precision has a price: activity analysis, driver measurement, and ongoing maintenance as processes change. The gain is better decisions, and it is concentrated in the first few pools — the ones separating batch-driven from volume-driven cost.\n\nHis practical guidance was to go after the low-hanging fruit first, start simple, and look for something scalable. Do not let the best become the enemy of the good.\n\nFour pools by level is a useful starting structure, not a rule — a firm may need two batch-level pools with different drivers, or none at all.",
  "Weigh what an extra pool costs to build and maintain against what it would change.",
  qtype="case_fact")

q("madm-a042", "madm_abc_implementation",
  "A bank's ABC study gives a rate of $6.00 per teller transaction. A manager wants to use it to forecast the cost of a promotion expected to add 5,000 teller transactions next month. What is the problem?",
  ["The rate is a long-run average capacity cost, so it overstates the short-run incremental cost of extra transactions on staff already scheduled",
   "The rate is too low, because it excludes the cost of the promotion itself",
   "The rate cannot be applied to a forecast because it was built from actual rather than budgeted data",
   "There is no problem — the rate was built causally, so it forecasts correctly"],
  "The rate is a long-run average capacity cost, so it overstates the short-run incremental cost of extra transactions on staff already scheduled",
  "The teller pool is salaries and depreciation, both committed. Five thousand extra transactions absorbed by staff already on shift cost very little in the month they happen.\n\nThe $6.00 rate is the right number for a strategic question — is this customer line worth serving, what should the fee schedule be — and the wrong number for a short-run incremental forecast. It is the copying machine's two cents against four cents, in a service business.\n\nActual versus budgeted data is a real refinement the Buckeye team planned for year two, but it is not what makes this application wrong.",
  "Ask what the pool is made of, and whether any of it changes next month.",
  qtype="case_fact", difficulty=3)

q("madm-a043", "madm_abc_implementation",
  "Which is not one of the professor's implementation guidelines for ABC?",
  ["Build the complete system before releasing any results, so managers see a consistent picture",
   "Consider the costs and benefits of incremental precision",
   "Focus on the low-hanging fruit first",
   "Start simple and look for scalability"],
  "Build the complete system before releasing any results, so managers see a consistent picture",
  "The guidance was the opposite: start simple, get the big distortions out first, and expand if it proves useful. Buckeye's own approach was a pilot on three branches with three activities, with a plan to refine the following year if it worked.\n\nWaiting for completeness is how ABC projects consume two years and get abandoned. It is also the version of not letting the best become the enemy of the good.\n\nThe other three are all his, stated in those words.",
  "Recall the four pieces of advice on the implementation slide, and find the one that contradicts them.",
  qtype="case_fact", difficulty=1)

q("madm-a044", "madm_abc_implementation",
  "Why is ABC often described as equally relevant in the service sector?",
  ["Almost all costs in a service business are indirect with respect to a customer or product line, so the allocation choice determines the entire answer",
   "Service businesses have lower overhead, so allocation is simpler",
   "Service businesses have no inventory, so absorption costing does not apply",
   "Service costs are mostly variable, so drivers are easy to observe"],
  "Almost all costs in a service business are indirect with respect to a customer or product line, so the allocation choice determines the entire answer",
  "A bank has essentially no direct cost attributable to an individual account. Buckeye traced nothing directly to customers — every operating cost was indirect with respect to the customer line, so the allocation base was doing all the work.\n\nThat makes the choice of base more consequential in services than in manufacturing, not less. Buckeye's whole strategic error traces to one badly chosen base.\n\nService overhead is typically a larger share of cost, not smaller, and salaries are largely fixed in the short run rather than variable.",
  "Ask what fraction of a bank's costs can be traced directly to one customer.",
  qtype="case_fact")

q("madm-a045", "madm_abc_implementation",
  "According to the AI slide, what happens to the cost hierarchy if order intake, scheduling and documentation are automated?",
  ["Batch-level cost per order falls sharply, so small orders become nearly as cheap to process as large ones",
   "Unit-level cost rises, because compute is consumed per unit",
   "Facility-level cost becomes the dominant pool, since automation is a fixed investment",
   "The hierarchy stops applying, since AI costs cannot be classified"],
  "Batch-level cost per order falls sharply, so small orders become nearly as cheap to process as large ones",
  "The batch-level pool is what made low-volume products and small customers expensive. Automating order intake, scheduling and documentation attacks that pool directly, and if a small order becomes almost as cheap as a large one, the cross-subsidy that ABC was built to expose shrinks with it.\n\nThe same slide made two further points. Automated design variants and compliance testing cut product-level cost, so supporting a wider range gets cheaper. AI handling inquiries at scale makes the long tail of small customers viable.\n\nAnd new pools appear: compute cost, model licensing, hallucination risk, data governance. ABC has to be extended to capture them, not abandoned.",
  "Ask which level of the hierarchy those three activities sit at.",
  qtype="case_fact")

q("madm-a046", "madm_abc_implementation",
  "A firm has run ABC for a year and found no material differences from its old plantwide rate. What is the most sensible conclusion?",
  ["Its products consume support activities roughly in proportion to volume, so the simple system was already adequate",
   "The ABC study was conducted incorrectly and should be repeated",
   "The drivers chosen were too coarse and more pools are needed",
   "ABC does not work in that firm's industry"],
  "Its products consume support activities roughly in proportion to volume, so the simple system was already adequate",
  "ABC corrects distortion. Finding no distortion is a legitimate result and useful information: it means the products are similar enough in batch size and support consumption that a volume base allocates causally.\n\nThat is the cement-plant answer generalised. Diversity is the precondition, and without it every method gives the same answer.\n\nAssuming the study must be wrong because it found nothing is the trap. The right response is to keep the simple system and spend the effort elsewhere.",
  "Ask what ABC is for, and what it means when there is nothing for it to correct.",
  qtype="case_fact", difficulty=3)

# ===========================================================================
# Session 7 — customer profitability (5)
# ===========================================================================

q("madm-a047", "madm_customer_profitability",
  "A customer generates $180,000 of contribution margin, places 300 orders at $250 each, takes 90 deliveries at $400 each and receives 24 sales visits at $600 each. What is customer profit?",
  ["$54,600", "$105,000", "$69,000", "$180,000"],
  "$54,600",
  "Charge the customer for what it consumed.\n\n- Orders: 300 x 250 = $75,000\n- Deliveries: 90 x 400 = $36,000\n- Sales visits: 24 x 600 = $14,400\n\nTotal cost-to-serve = $125,400, so customer profit = 180,000 − 125,400 = **$54,600**.\n\nThe customer keeps only 30% of the contribution margin it generates. Anyone ranking customers on contribution margin alone would place this account far higher than it belongs.",
  "Multiply each activity rate by the units this customer consumed, add them, and subtract from contribution margin.",
  difficulty=1)

q("madm-a048", "madm_customer_profitability",
  "Two customers each buy $500,000. Customer P has a 30% contribution margin ratio and places 20 orders; Customer Q has 24% and places 200 orders. Orders cost $400 each. Which is more profitable, and by how much?",
  ["P by $102,000", "P by $30,000", "Q by $42,000", "They are equally profitable"],
  "P by $102,000",
  "Compute both halves for each customer.\n\n- Contribution margin: P earns 0.30 x 500,000 = $150,000; Q earns 0.24 x 500,000 = $120,000\n- Ordering cost: P spends 20 x 400 = $8,000; Q spends 200 x 400 = $80,000\n\nNet: P is 150,000 − 8,000 = $142,000; Q is 120,000 − 80,000 = $40,000, so **P leads by $102,000**.\n\nHere cost-to-serve reinforces the margin ranking instead of reversing it, which is the point. In the Ryan and Wilson case the order counts were far enough apart to overturn a $20,000 margin advantage; here the margin advantage and the cost advantage point the same way. Cost-to-serve does not automatically dominate — it has to be large enough, and the only way to know is to compute both.",
  "Compute contribution margin and cost-to-serve for each, then compare the net figures rather than either half.",
  difficulty=3)

q("madm-a049", "madm_customer_profitability",
  "Which customer characteristic most reliably signals a high cost-to-serve?",
  ["Many small orders rather than a few large ones",
   "A low contribution margin ratio",
   "A long relationship with the firm",
   "Purchasing across many product lines"],
  "Many small orders rather than a few large ones",
  "Order count is the customer-level version of batch size, and it is where cost-to-serve concentrates: each order triggers processing, scheduling, picking, shipping and invoicing regardless of how much is on it.\n\nA low contribution margin ratio is a revenue-quality problem, not a cost-to-serve one — the two are separate and can point in opposite directions.\n\nRelationship length says nothing by itself. Buying across many product lines can raise cost-to-serve, but it is a much weaker signal than order frequency.",
  "Ask which behaviour makes the firm do more work per rupee of revenue.",
  qtype="case_fact", difficulty=1)

q("madm-a050", "madm_customer_profitability",
  "The whale curve of cumulative profit against customers ranked most to least profitable peaks well above 100%. What does that shape mean?",
  ["The most profitable customers generate more than the firm's total profit, and the unprofitable tail gives some of it back",
   "The firm has mis-stated its total profit, since cumulative profit cannot exceed 100%",
   "Most customers are unprofitable and only a few break even",
   "Profit is evenly distributed and the curve is close to a straight line"],
  "The most profitable customers generate more than the firm's total profit, and the unprofitable tail gives some of it back",
  "Cumulative profit is a running total. If the best customers together generate, say, 150% of the firm's reported profit, the curve peaks at 150 and then falls back to 100 as the loss-making tail is added.\n\nThe area between the peak and 100% is what the unprofitable customers destroy — and it is invisible in any reporting that shows only the firm-level total.\n\nThe shape is not an error. It is the standard finding when customer profitability is measured properly.",
  "The curve is a cumulative total. Ask what makes a cumulative total go down.",
  qtype="case_fact")

q("madm-a051", "madm_customer_profitability",
  "A customer receives a 1% discount for early payment on $1,300,000 of sales, places 8 orders at $300 each, takes 20 shipments at $300 each, and requests 3 order changes at $2,500 each. If its contribution margin is $325,000, what is customer profitability?",
  ["$296,100", "$309,100", "$283,600", "$312,000"],
  "$296,100",
  "Work down the deductions.\n\n- Early-payment discount: 1% of 1,300,000 = $13,000\n- Ordering: 8 x 300 = $2,400\n- Shipping: 20 x 300 = $6,000\n- Order changes: 3 x 2,500 = $7,500\n\nTotal = $28,900, so profitability = 325,000 − 28,900 = **$296,100**.\n\nNotice that the discount is nearly half the total deduction. Payment terms and discounts are customer-level costs just as much as order processing is, and they are easy to leave out because they arrive as a revenue reduction rather than an expense.",
  "Deduct every customer-specific cost, including the discount taken on the revenue line.",
  difficulty=3)

# ===========================================================================
# Session 7 — managing the unprofitable tail (7)
# ===========================================================================

q("madm-a052", "madm_managing_customers",
  "An ABC study shows that a firm's bottom 15% of customers destroy a fifth of its profit. What is the weakest reason to terminate them immediately?",
  ["The reported loss per customer is large",
   "Their ordering behaviour cannot be changed despite repeated attempts",
   "They occupy capacity that profitable customers are waiting for",
   "Their revenue is small and shrinking"],
  "The reported loss per customer is large",
  "The reported loss is the trigger for investigation, not the argument for termination. Much of the assigned cost is capacity cost that does not leave with the customer — so terminating removes the contribution immediately and only some of the cost.\n\nThe other three are genuine arguments. If behaviour cannot be changed, repricing and channel shifts have been exhausted. If capacity is binding, there is a real opportunity cost. If the account is small and shrinking, there is little upside to protect.\n\nThe cheaper moves come first: reprice, change how they are served, change how they order.",
  "Ask what actually leaves the firm when a customer does, and what stays.",
  qtype="case_fact")

q("madm-a053", "madm_managing_customers",
  "A distributor introduces a $50 fee on orders below a minimum size. Which effect is the point of the fee?",
  ["Either the customer consolidates orders, cutting the cost, or it pays for the cost it creates — both outcomes are acceptable",
   "It raises revenue, which offsets the loss on unprofitable customers",
   "It drives small customers away, improving the average",
   "It signals to the market that the firm is premium-priced"],
  "Either the customer consolidates orders, cutting the cost, or it pays for the cost it creates — both outcomes are acceptable",
  "Menu pricing works because it makes the customer choose. A customer who consolidates removes the cost; a customer who keeps ordering in small lots now covers it. There is no third outcome the firm has to fear.\n\nThat is what makes repricing a better first move than termination: it converts a cost problem into a customer decision rather than a unilateral one.\n\nDriving small customers away is a possible outcome and a poor objective — some small customers are perfectly profitable once they order sensibly.",
  "List what a customer can do in response to the fee, and check whether the firm minds either answer.",
  qtype="case_fact")

q("madm-a054", "madm_managing_customers",
  "A firm shifts small accounts to a self-service portal. In ABC terms, what has it changed?",
  ["The driver quantity — those accounts now trigger fewer of the expensive activities",
   "The activity rate — the same activities now cost less per unit",
   "The cost pool — total support cost falls immediately",
   "The cost object — the accounts are no longer costed individually"],
  "The driver quantity — those accounts now trigger fewer of the expensive activities",
  "Self-service does not make a phone call cheaper; it means fewer phone calls happen. The rate per call is unchanged and the number of calls falls, so the cost assigned to those accounts falls.\n\nWhether the **pool** falls depends on whether the freed capacity is released or redeployed. In the short run the call-centre staff are still employed, so the saving is a capacity saving that has to be realised.\n\nThat distinction — driver quantity now, pool later — is the same short-run versus long-run point that runs through the whole of Session 6.",
  "Ask whether the change makes each activity cheaper, or makes the activity happen less often.",
  qtype="case_fact", difficulty=3)

q("madm-a055", "madm_managing_customers",
  "A firm is bearing high product-development and order-change costs for a small, low-margin customer. When is that defensible?",
  ["When the customer is being deliberately developed and is expected to become a high-profit account",
   "Never — development costs must always be recovered from the customer that causes them",
   "When the costs can be reallocated to larger customers",
   "When the customer's contribution margin ratio exceeds the firm average"],
  "When the customer is being deliberately developed and is expected to become a high-profit account",
  "The textbook raises exactly this possibility for Sylvester Steel's customer C: the firm may be investing upfront in an account it expects to grow, in which case bearing the development cost now is a sensible decision rather than a mistake.\n\nWhat makes it defensible is that it is a **decision** with an expected return, not an accident nobody noticed. The test is whether anyone can state the expected payoff and the horizon.\n\nThe customer's margin ratio is already below average here, which is part of what raised the question.",
  "Ask whether the cost is an investment with an expected return or an unnoticed leak.",
  qtype="case_fact")

q("madm-a056", "madm_managing_customers",
  "A firm terminates its 200 least profitable customers, who together were assigned $4 million of activity cost and generated $3 million of contribution margin. A year later profit has fallen. What is the most likely explanation?",
  ["Most of the $4 million was capacity cost that stayed, so the firm lost $3 million of contribution and saved much less",
   "The terminated customers were more profitable than the ABC study showed",
   "The remaining customers reduced their order sizes in response",
   "The activity rates were computed using actual rather than budgeted data"],
  "Most of the $4 million was capacity cost that stayed, so the firm lost $3 million of contribution and saved much less",
  "Assigned cost is not avoidable cost. The pools were mostly salaries, systems and facilities — capacity that remains employed unless the firm actively reduces it.\n\nSo the contribution leaves on day one and the cost leaves slowly, if at all. Worse, the same capacity cost is now spread over fewer customers, which makes the next tranche look unprofitable and invites another round of cuts.\n\nThat is why the customer-profitability menu puts repricing and channel change ahead of termination, and why termination has to be paired with an explicit plan to release the capacity.",
  "Ask which of the assigned costs actually stopped being incurred.",
  qtype="case_fact", difficulty=3)

q("madm-a057", "madm_managing_customers",
  "What does customer tiering allow a firm to do that a single service standard does not?",
  ["Match service level and price to what each tier costs to serve and is willing to pay",
   "Charge every customer the same price while serving them differently",
   "Avoid measuring cost-to-serve, since tiers are defined by revenue",
   "Guarantee that every customer is profitable"],
  "Match service level and price to what each tier costs to serve and is willing to pay",
  "A single service standard means the firm gives everyone the level the most demanding customers need, and charges everyone a price that averages across very different cost-to-serve profiles. Both halves are wrong for most of the base.\n\nTiering lets the firm decide, with evidence, which customers to acquire, which to support and retain, and which to let go — the three questions on the professor's KYC slide.\n\nIt does not guarantee profitability, and it depends on measuring cost-to-serve rather than avoiding it.",
  "Ask what a single standard forces the firm to do at both ends of the customer base.",
  qtype="case_fact")

q("madm-a058", "madm_managing_customers",
  "A firm discovers a customer is unprofitable on cost-to-serve. Which piece of information would most change the decision to act?",
  ["The customer refers a large share of the firm's new profitable accounts",
   "The customer has been with the firm for twelve years",
   "The customer's industry is growing",
   "The customer pays on time"],
  "The customer refers a large share of the firm's new profitable accounts",
  "This is the change-nothing branch of the menu: ask what the numbers are missing. Referral value is real economic value that does not appear anywhere in the customer's own profit line, and it can easily exceed the loss on the account.\n\nOther things in the same category: a loss-leading product that pulls a profitable one, reference value in a segment where credibility is hard to buy, and a young account being deliberately developed.\n\nTenure, industry growth and payment behaviour are all facts about the customer that do not, on their own, change the arithmetic.",
  "Ask which fact represents value the customer creates that the customer's own P&L does not capture.",
  qtype="case_fact")

# ===========================================================================
# Session 7 — activity-based management (8)
# ===========================================================================

q("madm-a059", "madm_abm",
  "What distinguishes activity-based management from activity-based costing?",
  ["ABC measures what activities cost; ABM uses that visibility to eliminate, simplify, automate or outsource them",
   "ABM is the version used for financial reporting; ABC is internal",
   "ABM allocates facility-level costs, which ABC leaves unallocated",
   "ABM applies to customers; ABC applies to products"],
  "ABC measures what activities cost; ABM uses that visibility to eliminate, simplify, automate or outsource them",
  "ABC is a measurement system and ABM is what you do with it. Without activity cost pools, the question of where the overhead goes has no answer beyond a departmental budget — and a departmental budget does not tell you which work is worth doing.\n\nThe six ABM questions run in order: what are our high-cost activities, do they add value for the customer, can we eliminate or simplify them, can we do them more efficiently, should someone else do them, can technology eliminate them.\n\nBoth apply equally to products and customers, and neither is a financial reporting framework.",
  "One of the two produces numbers; the other produces actions.",
  qtype="case_fact", difficulty=1)

q("madm-a060", "madm_abm",
  "A plant manager responds to a cost-reduction target by cutting the maintenance department's budget by 10%. Why does an ABM practitioner object?",
  ["Cutting the budget cuts capacity without reducing the demand for maintenance, so the work reappears as breakdowns",
   "Maintenance is a facility-level cost and cannot be reduced",
   "The cut is too small to matter",
   "Budgets should only be cut at the start of a financial year"],
  "Cutting the budget cuts capacity without reducing the demand for maintenance, so the work reappears as breakdowns",
  "This is the difference between cutting cost and removing the cause of cost. The machines still need the same maintenance; there are now fewer people to do it.\n\nThe ABM version asks what is driving maintenance demand — machine age, setup frequency, operator practice, the number of product variants — and reduces that. Then the capacity can be released without the work reappearing somewhere worse.\n\nDeferred maintenance is also the classic budget game, and Session 8 shows exactly how it turns up later as unfavourable efficiency variances.",
  "Ask whether cutting the budget changes how much maintenance the plant actually needs.",
  qtype="case_fact")

q("madm-a061", "madm_abm",
  "In the ABM question set, what is the purpose of asking whether an activity adds value for the customer?",
  ["To separate work worth doing more efficiently from work that should not be done at all",
   "To determine which activities can be allocated to products",
   "To decide which activities are variable and which are fixed",
   "To identify which department owns each activity"],
  "To separate work worth doing more efficiently from work that should not be done at all",
  "It is the fork in the road. If an activity adds value, the useful questions are about doing it better, cheaper or elsewhere. If it does not, the only sensible question is how to stop doing it.\n\nSkipping the question leads to a common failure: teams optimise an activity for months and make a process the customer never wanted 20% more efficient.\n\nThe question has nothing to do with allocation, cost behaviour or organisational ownership.",
  "Ask what changes about the remaining questions depending on the answer.",
  qtype="case_fact")

q("madm-a062", "madm_abm",
  "A firm finds that expediting costs $340,000 a year across 1,700 expedited orders. Which ABM response attacks the cause rather than the symptom?",
  ["Find out why orders need expediting — forecast error, supplier lead times, capacity bottlenecks — and fix that",
   "Negotiate a lower freight rate for expedited shipments",
   "Charge customers a $200 expediting fee",
   "Move expediting into a separate cost centre so it is visible"],
  "Find out why orders need expediting — forecast error, supplier lead times, capacity bottlenecks — and fix that",
  "Expediting is a symptom. Something upstream — a forecast that missed, a supplier that slipped, a bottleneck that queued — created the emergency, and the $200 a time is what the firm pays to paper over it.\n\nThe other three all have their place. A lower freight rate makes the symptom cheaper. A fee makes the customer pay for it, which is right when the customer causes it. Separating the cost centre makes it visible, which is where ABM starts.\n\nNone of them reduces the number of emergencies, which is what the third ABM question is for.",
  "Ask which option reduces the number of times the activity happens.",
  qtype="case_fact")

q("madm-a063", "madm_abm",
  "Why does ABM describe ABC as turning backward-looking costing into forward-looking management?",
  ["Because tracing cost to activities and drivers shows why cost occurs, which is what makes it changeable",
   "Because ABC uses budgeted rather than historical rates",
   "Because ABC forecasts next period's overhead",
   "Because ABC is applied to new products rather than existing ones"],
  "Because tracing cost to activities and drivers shows why cost occurs, which is what makes it changeable",
  "A departmental cost report tells you what was spent. An activity view tells you what the money was spent doing and what made it happen — and a driver is something a manager can act on.\n\nOnce you know that setup cost is $1,000 an order and one product places fifty orders, you have a lever. Knowing only that overhead was $100,000 gives you nothing to pull.\n\nWhether rates are budgeted or historical is a refinement, and ABC is not a forecasting technique.",
  "Ask what a driver gives a manager that a departmental total does not.",
  qtype="case_fact")

q("madm-a064", "madm_abm",
  "A firm automates its invoice-matching activity, cutting the pool from $600,000 to $150,000. What has to happen for the saving to be real?",
  ["The freed staff capacity has to be released or redeployed to work that was previously unmet",
   "The activity driver has to be changed to reflect the new process",
   "The remaining $150,000 has to be reallocated across products",
   "Nothing — the saving appears automatically once the software is live"],
  "The freed staff capacity has to be released or redeployed to work that was previously unmet",
  "Automation frees capacity; it does not by itself reduce spending. If the same people stay in the same roles doing less, the pool is unchanged and the firm has bought software on top of its existing cost base.\n\nThe saving is realised when headcount is reduced, when redeployment lets the firm avoid hiring elsewhere, or when the freed capacity absorbs growth that would otherwise have required more people.\n\nThis is the single most common way process-improvement business cases fail to show up in the accounts.",
  "Ask what has to change on the payroll for a capacity saving to become a cash saving.",
  qtype="case_fact", difficulty=3)

q("madm-a065", "madm_abm",
  "According to the AI slide, what new cost categories does ABM need to start tracking?",
  ["Compute cost, model licensing, hallucination risk and data governance",
   "Cloud storage and network bandwidth only",
   "Training data acquisition and employee retraining only",
   "None — AI removes activities without adding any"],
  "Compute cost, model licensing, hallucination risk and data governance",
  "The slide's point was two-directional. AI shrinks batch-, product- and customer-level pools by automating order intake, design variants and support. In exchange it creates new activity pools that did not exist before, and named four: **compute cost, model licensing, hallucination risk and data governance**.\n\nABC has to evolve to capture them. A firm that only counts the savings and never opens pools for the new costs is making the same mistake as a firm with one plantwide rate: assuming the cost structure it inherited is still the one it has.",
  "The slide lists four. Two are cash costs and two are risk or control costs.",
  qtype="case_fact", difficulty=1)

q("madm-a066", "madm_abm",
  "Which ABM question does outsourcing a warehousing function belong to?",
  ["Should someone else do them?",
   "Do these activities add value for the customer?",
   "Can we eliminate or simplify them?",
   "Can technology eliminate them?"],
  "Should someone else do them?",
  "Outsourcing keeps the activity and changes who performs it, which is the fifth of the six questions. It is worth asking after the earlier ones, because outsourcing a wasteful activity just moves the waste and adds a margin on top.\n\nThe order matters: eliminate first, simplify second, improve third, outsource fourth, automate where it fits. A firm that outsources before simplifying pays a supplier to run its bad process.\n\nThis is also the long-run cost decision from Session 6 — comparing an outside quote against full cost including capacity, not against variable cost.",
  "Ask whether the activity stops happening, happens differently, or happens somewhere else.",
  qtype="case_fact", difficulty=1)

# ===========================================================================
# Session 7 — decentralisation (8)
# ===========================================================================

q("madm-a067", "madm_decentralization",
  "Which of these is a cost of decentralisation rather than a benefit?",
  ["Duplication of activities and expertise across units",
   "Quicker decisions by people with local expertise",
   "Better adaptation to local conditions",
   "Development of a talent pool for future senior roles"],
  "Duplication of activities and expertise across units",
  "Every unit that builds its own version of a function the firm could run once is paying for the same expertise repeatedly. That is one of the four costs on the slide, alongside coordination failures, goal incongruence and silo behaviour.\n\nThe other three options are all benefits: speed, local adaptation and leadership development. The fifth benefit is that it frees top management for strategy, and the fourth is morale.\n\nEverything else in this half of the course exists to manage the cost column.",
  "Split the list into what decentralisation buys and what it costs.",
  qtype="case_fact", difficulty=1)

q("madm-a068", "madm_decentralization",
  "Why is some degree of decentralisation described as inevitable as firms grow?",
  ["A central decision-maker cannot process the volume or hold the local information that decisions require",
   "Regulators require large firms to have divisional structures",
   "Larger firms have more capital and can afford more managers",
   "Decentralisation is a legal requirement above a certain revenue threshold"],
  "A central decision-maker cannot process the volume or hold the local information that decisions require",
  "Two binding constraints: attention and information. There are only so many decisions a centre can make, and much of what a decision needs to know is held by people close to the customer, the plant or the market.\n\nWhat firms differ on is *how far* to go, not whether. That is a design choice, and it is decided by weighing the benefits against the four costs.\n\nNothing about it is a legal or regulatory requirement.",
  "Ask what the centre runs out of first as a firm gets larger.",
  qtype="case_fact", difficulty=1)

q("madm-a069", "madm_decentralization",
  "Two divisions each build their own analytics team rather than using a shared central one. Which cost of decentralisation is this?",
  ["Duplication of activities and expertise", "Goal incongruence",
   "Silo behaviour", "Lack of coordination"],
  "Duplication of activities and expertise",
  "The firm is paying twice for the same capability. That is duplication in its plainest form.\n\nIt is worth separating the four costs carefully, because they get confused. **Goal incongruence** is divisional and firm objectives pulling apart. **Silo behaviour** is a narrow focus on the unit's own numbers. **Coordination failure** is units each optimising locally in ways that do not fit together.\n\nDuplication may of course be a symptom of silo behaviour — a division that will not use a shared service — but the cost itself is duplication.",
  "Name the cost by what the firm is paying for twice.",
  qtype="case_fact", difficulty=1)

q("madm-a070", "madm_decentralization",
  "A regional manager cuts prices to hit her volume target, taking share from another region of the same firm. Which cost of decentralisation is on display?",
  ["Goal incongruence — her target and the firm's objective point in different directions",
   "Duplication of expertise",
   "Reduced workload for top management",
   "Better adaptation to local conditions"],
  "Goal incongruence — her target and the firm's objective point in different directions",
  "She is doing exactly what she is measured on, and the firm is worse off: the volume was not won from a competitor, and it came at a lower price.\n\nThat gap between what the measure rewards and what the firm wants is **goal incongruence**, and the whole apparatus of control systems — decision rights, performance measures, reward systems — exists to narrow it.\n\nIt is easy to read this as silo behaviour, which is closely related. The distinguishing feature here is that the incentive itself is misaligned, not merely that the manager is ignoring her neighbours.",
  "Ask whether the manager is failing at her job or succeeding at a badly chosen one.",
  qtype="case_fact")

q("madm-a071", "madm_decentralization",
  "Which benefit of decentralisation is about the firm's future rather than its present performance?",
  ["Developing a talent pool for senior management positions",
   "Increased efficiency from quicker local decisions",
   "Better adaptation to local conditions",
   "Reduced workload for top management"],
  "Developing a talent pool for senior management positions",
  "Running a unit with real decision rights is the only reliable way to find out who can run a bigger one, and the only way to give them the practice. That is a long-horizon benefit that shows up in succession rather than in this year's numbers.\n\nThe other three are all immediate operating benefits: speed, local fit, and freeing the centre's attention.\n\nIt is also the benefit most easily destroyed by over-tight control. A manager with no real decision rights is not being developed, whatever the org chart says.",
  "Which benefit pays off in five years rather than this quarter?",
  qtype="case_fact", difficulty=1)

q("madm-a072", "madm_decentralization",
  "A firm centralises procurement after finding that divisions were negotiating separately with the same suppliers. What is it trading away?",
  ["Divisional autonomy and local responsiveness, in exchange for scale and consistency",
   "Nothing — centralising procurement has no costs",
   "Goal congruence, which falls when decisions move to the centre",
   "The controllability principle, which requires central purchasing"],
  "Divisional autonomy and local responsiveness, in exchange for scale and consistency",
  "The gain is real: one negotiation instead of several, better terms, no duplicated expertise. The cost is equally real — divisions lose the ability to respond to a local supplier opportunity, and they now depend on a central function whose priorities may not match theirs.\n\nIt also complicates evaluation. A division manager charged a centrally negotiated price for an input she did not choose is being held accountable for something outside her control, which is the controllability principle pointing the other way.\n\nGoal congruence generally improves when a decision is centralised, since the centre holds the firm-level objective.",
  "Every centralisation buys something and gives something up. Name both.",
  qtype="case_fact")

q("madm-a073", "madm_decentralization",
  "Which statement about decentralisation and firm size is most accurate?",
  ["Firms of similar size can differ substantially in how decentralised they are, because it is a design choice",
   "Decentralisation increases mechanically with headcount",
   "Only multinational firms are meaningfully decentralised",
   "Firms become fully centralised again once they exceed a certain size"],
  "Firms of similar size can differ substantially in how decentralised they are, because it is a design choice",
  "Size makes some decentralisation unavoidable, and after that the degree is chosen. Two firms of the same size in the same industry can sit in very different places, depending on how much they value local responsiveness against coordination and consistency.\n\nThe choice shows up concretely: which decisions divisions may take without approval, what they are measured on, and whether they may source externally — which is the first of the three transfer pricing questions.\n\nNothing about it is mechanical or size-triggered.",
  "Ask whether the degree of decentralisation is determined by size or decided by management.",
  qtype="case_fact")

q("madm-a074", "madm_decentralization",
  "A division manager refuses to share a promising process improvement with a sister division because it would raise the benchmark she is measured against. Which cost of decentralisation is this?",
  ["Silo behaviour, reinforced by goal incongruence in the performance measure",
   "Duplication of activities and expertise",
   "Lack of coordination across units",
   "Reduced workload for top management"],
  "Silo behaviour, reinforced by goal incongruence in the performance measure",
  "The narrow focus on her own unit's standing is **silo behaviour**, and it has a specific cause: the measure is relative, so helping a peer hurts her.\n\nThat is the ratchet effect's cousin. When a manager's target is set from her own or her peers' past performance, looking too good — or making a peer look good — carries a cost, and rational managers respond.\n\nThe fix is in the reward system rather than in exhortation: reward the sharing, or stop measuring managers against each other.",
  "Name the behaviour, then ask what in the measurement system is producing it.",
  qtype="case_fact", difficulty=3)

# ===========================================================================
# Session 7 — control systems (8)
# ===========================================================================

q("madm-a075", "madm_control_systems",
  "What are the three components of a management control system?",
  ["Allocation of decision rights, choice of performance measures, choice of reward systems",
   "Budgeting, variance analysis, transfer pricing",
   "Planning, coordination, evaluation",
   "Cost centres, profit centres, investment centres"],
  "Allocation of decision rights, choice of performance measures, choice of reward systems",
  "Who decides, how they are measured, and how they are paid. The point of naming three components is that they only work when they are **aligned with each other**.\n\nPlanning, coordination and evaluation are the three roles of a *budget*, which is one instrument inside the system. The responsibility centre types are one way of implementing the first two components. Budgeting, variance analysis and transfer pricing are three of the course's topics rather than a framework.",
  "Three questions: who decides, how is that measured, and how is it rewarded.",
  qtype="case_fact", difficulty=1)

q("madm-a076", "madm_control_systems",
  "A sales manager is given authority over pricing and discounting but is measured and paid on revenue alone. What is the predictable outcome?",
  ["Discounting to drive volume, because revenue rises with units even when margin falls",
   "Excessive price increases, because higher prices raise revenue per unit",
   "No distortion, since revenue and profit move together",
   "Under-investment in the sales force, because revenue targets discourage spending"],
  "Discounting to drive volume, because revenue rises with units even when margin falls",
  "The decision right is over price; the measure ignores margin. A discount that raises units enough to raise revenue improves her number and can easily reduce profit.\n\nThat is a misalignment between components one and two: she controls something the measure does not capture. Measuring her on contribution margin instead would align them.\n\nSession 8's putter case is the same story with numbers attached — a price cut that produced a favourable volume variance and a much larger unfavourable price variance.",
  "Compare what she can decide with what her measure counts.",
  qtype="case_fact")

q("madm-a077", "madm_control_systems",
  "What does the controllability principle say, and what is its main practical limitation?",
  ["Hold people accountable only for outcomes they control — but almost nothing is entirely within one person's control, so it is a guideline",
   "Hold people accountable for all outcomes in their unit — and it applies without exception",
   "Measure only financial outcomes — but non-financial measures are sometimes needed",
   "Never hold a manager accountable for costs — but revenue is always controllable"],
  "Hold people accountable only for outcomes they control — but almost nothing is entirely within one person's control, so it is a guideline",
  "The principle is what makes evaluation fair and what makes it informative: an outcome the manager cannot influence tells you nothing about her.\n\nThe limitation is that pure controllability barely exists. A plant manager does not control input prices, the weather or the sales forecast, yet she influences the outcome through how she responds to all three. Applied absolutely, the principle would leave nothing to measure.\n\nSo it is applied in degree — which is exactly what the flexible budget does in Session 8, removing the volume effect the plant did not control while holding it to what it did.",
  "State the principle, then ask whether any real outcome fully satisfies it.",
  qtype="case_fact")

q("madm-a078", "madm_control_systems",
  "What is goal congruence?",
  ["A state in which the action that is best for the manager is also the action that is best for the firm",
   "Agreement between divisions on a shared budget target",
   "Alignment of the firm's strategy with its stated mission",
   "Consistency between the management accounts and the financial statements"],
  "A state in which the action that is best for the manager is also the action that is best for the firm",
  "It is the objective of the entire control system: design decision rights, measures and rewards so that a self-interested manager, doing what is best for herself, does what the firm wants anyway.\n\nIt is also the stated goal of transfer pricing in Session 9. A goal-congruent transfer price is one that leads autonomous divisions maximising their own profit to make the sourcing choice the firm would make.\n\nPerfect congruence is not achievable — the corrections are never complete, which is why the textbook says the manager will not always take the value-maximising action.",
  "Ask whose interests have to point in the same direction.",
  qtype="case_fact", difficulty=1)

q("madm-a079", "madm_control_systems",
  "A firm gives divisions full authority over capital spending but continues to measure and reward them on divisional profit. What distortion follows?",
  ["Over-investment, because managers get the benefit of the assets without being charged for the capital",
   "Under-investment, because capital spending reduces profit in the year it is made",
   "No distortion, since profit already reflects depreciation",
   "Over-investment, but only if the firm uses residual income"],
  "Over-investment, because managers get the benefit of the assets without being charged for the capital",
  "Profit charges depreciation but not the cost of the capital tied up. So a project earning less than the firm's cost of capital still adds profit, and a manager measured on profit takes it.\n\nThe textbook problem is exactly this: measured on profit alone, managers invest in a 12% project against a 15% cost of capital, because they receive the benefits without incurring the capital charge.\n\nResidual income fixes it by imposing that charge. ROI over-corrects in the other direction, causing the underinvestment problem.",
  "Ask what profit does and does not charge the manager for.",
  qtype="case_fact", difficulty=3)

q("madm-a080", "madm_control_systems",
  "Which change would most improve alignment where a call-centre team is rewarded on average call handling time and customer complaints are rising?",
  ["Add a resolution-quality measure, so speed is not the only thing rewarded",
   "Tighten the handling-time target further",
   "Move the team from a cost centre to a profit centre",
   "Remove all measurement, since metrics cause the problem"],
  "Add a resolution-quality measure, so speed is not the only thing rewarded",
  "A single-dimension measure gets optimised at the expense of everything it leaves out. Rewarding speed alone buys speed, including the kind that ends a call before the problem is solved — which is why complaints rise and repeat calls follow.\n\nAdding a measure of whether the issue was actually resolved makes the reward system reflect what the firm wants. Tightening the existing target makes the distortion worse.\n\nMoving the team to a profit centre would give it decision rights it does not have, breaking the alignment in a different way.",
  "Ask what the current measure leaves out, and whether the fix should be to the measure or to the target.",
  qtype="case_fact")

q("madm-a081", "madm_control_systems",
  "Numbers make people do things. What follows for a manager introducing a new performance metric?",
  ["The metric will be optimised, including in ways nobody intended, so it should be designed for the behaviour it will produce",
   "The metric should be kept secret from the people it measures, to avoid gaming",
   "Metrics should be changed frequently so nobody has time to game them",
   "Only financial metrics produce behavioural effects"],
  "The metric will be optimised, including in ways nobody intended, so it should be designed for the behaviour it will produce",
  "Once a number is used to evaluate people it stops being a neutral description and becomes an instruction. So the design question is not only whether the metric measures well, but what a rational person maximising it would actually do.\n\nBuckeye is the cleanest illustration: paying branch managers for account growth produced account growth, including the accounts that lost money.\n\nSecrecy defeats the purpose of a target, and frequent changes destroy the coordination and commitment a target is supposed to buy. Non-financial metrics produce exactly the same effects.",
  "Ask what a rational person maximising the metric would actually do.",
  qtype="case_fact")

q("madm-a082", "madm_control_systems",
  "A firm grants a division decision rights over product mix but measures it on units shipped. Which component of the control system is misaligned, and what happens?",
  ["Measures are inconsistent with decision rights, so the division shifts mix toward high-volume low-margin products",
   "Reward systems are misaligned, so the division under-invests in capacity",
   "Decision rights are too narrow, so the division escalates every choice",
   "Nothing is misaligned, because units shipped is objective and easily audited"],
  "Measures are inconsistent with decision rights, so the division shifts mix toward high-volume low-margin products",
  "Mix is the lever the division controls, and units shipped is blind to what each unit earns. A manager optimising the measure moves mix toward whatever ships in the largest numbers, regardless of margin.\n\nThat is a component-two failure: the measure does not capture the dimension the granted decision right operates on. Contribution margin or profit would.\n\nBeing objective and auditable is a virtue of a measure and is not the same as being the right measure. Plenty of precisely measured wrong things exist.",
  "Ask which lever the division controls, and whether the measure can see what pulling it does.",
  qtype="case_fact", difficulty=3)

# ===========================================================================
# Session 7 — responsibility centres (6)
# ===========================================================================

q("madm-a083", "madm_responsibility_centers",
  "An Amazon fulfilment centre is measured on cost per unit shipped and does not set prices. What kind of responsibility centre is it?",
  ["Cost centre", "Revenue centre", "Profit centre", "Investment centre"],
  "Cost centre",
  "It controls inputs — labour scheduling, process efficiency, consumables — and is measured on the cost of producing a given output. That is a **cost centre**.\n\nIt is not a revenue centre because it does not touch pricing or sales, and not a profit centre because it has no revenue line of its own.\n\nThe measure follows the decision rights: cost per unit shipped holds it to the one dimension it can actually move.",
  "Ask what the unit decides, then ask which measure matches.",
  qtype="case_fact", difficulty=1)

q("madm-a084", "madm_responsibility_centers",
  "A regional sales office sets discounts within a corporate band and is measured on bookings. It does not control the cost of what it sells. What is it?",
  ["Revenue centre", "Cost centre", "Profit centre", "Investment centre"],
  "Revenue centre",
  "It controls pricing and sales but not cost, and it is measured on revenue. That is a **revenue centre**.\n\nThe structure carries a known risk, which is the discounting distortion: a unit measured on revenue with authority over price will trade margin for volume. Firms usually manage it by capping the discount band, which is what limiting the authority does here.\n\nIt is not a profit centre because it has no responsibility for the cost side of a P&L.",
  "It controls one side of the income statement. Which one?",
  qtype="case_fact", difficulty=1)

q("madm-a085", "madm_responsibility_centers",
  "What single decision right separates a profit centre from an investment centre?",
  ["Authority over capital expenditure and the asset base",
   "Authority over pricing",
   "Authority over hiring",
   "Authority to source inputs externally"],
  "Authority over capital expenditure and the asset base",
  "A profit centre is responsible for a P&L. An investment centre is responsible for a P&L **and a balance sheet**, which is what makes ROI a fair measure for it and an unfair one for a profit centre.\n\nPricing and hiring are already inside a profit centre's remit. External sourcing authority is the first of the three transfer pricing questions and is a separate design choice — a profit centre may or may not have it.\n\nThis is what makes the executive-education example a profit centre: it decides its programmes, fees and staff, but its buildings and IT are provided centrally.",
  "One of the four centres is measured on a return. What does it need to control for that to be fair?",
  qtype="case_fact", difficulty=1)

q("madm-a086", "madm_responsibility_centers",
  "A firm measures a plant manager on divisional profit, but the plant's selling prices are set by a central marketing group. What is wrong?",
  ["The measure exceeds the decision rights, so she is accountable for prices she does not control",
   "The measure is too narrow, since profit ignores the asset base",
   "Nothing — profit is the most complete measure available",
   "The plant should be reclassified as an investment centre"],
  "The measure exceeds the decision rights, so she is accountable for prices she does not control",
  "Profit combines volume, price and cost. She controls cost and, in part, volume; price belongs to someone else. Holding her to the combination breaks the controllability principle and makes her result partly noise.\n\nThe two consistent fixes are to measure her on cost, or to give her the pricing authority. Which one is right depends on where the information and the judgement actually sit.\n\nMoving her to an investment centre would make the mismatch larger, not smaller.",
  "Compare the span of the measure with the span of the authority.",
  qtype="case_fact")

q("madm-a087", "madm_responsibility_centers",
  "Why does responsibility-centre classification matter for how a unit is evaluated?",
  ["It fixes which outcomes the unit can fairly be judged on, given what it actually decides",
   "It determines which accounting standards the unit must follow",
   "It sets the unit's share of allocated corporate overhead",
   "It decides whether the unit may trade with other divisions"],
  "It fixes which outcomes the unit can fairly be judged on, given what it actually decides",
  "The classification is a summary of decision rights, and the measure follows from it. That is the second component of the control system doing its job.\n\nJudging a cost centre on profit asks it to answer for prices it does not set. Judging a profit centre on ROI asks it to answer for an asset base it did not choose. Both produce evaluations that are partly noise and behaviour that is partly distorted.\n\nOverhead allocation and internal trading rights are separate design decisions that can apply to any centre type.",
  "Ask what the classification is really a summary of.",
  qtype="case_fact")

q("madm-a088", "madm_responsibility_centers",
  "A corporate IT function charges divisions for the services they consume and is expected to break even. It cannot set its own rates and cannot refuse internal work. What is it best treated as?",
  ["A cost centre, since it controls inputs but neither prices nor volume",
   "A profit centre, since it books revenue from divisions",
   "An investment centre, since it owns substantial assets",
   "A revenue centre, since it charges for its services"],
  "A cost centre, since it controls inputs but neither prices nor volume",
  "The internal charges look like revenue, but the unit sets neither the rate nor the quantity: divisions decide how much to consume and corporate sets the rate. What it does control is how efficiently it delivers the work.\n\nSo the fair measure is cost, or cost per unit of service — a **cost centre** with an internal chargeback mechanism on top.\n\nOwning assets does not make a unit an investment centre; deciding on them does. And a break-even expectation is not a profit target, it is a full-cost recovery rule.",
  "Strip away the chargeback and ask what the unit actually decides.",
  qtype="case_fact", difficulty=3)

# ===========================================================================
# Session 7 — budget roles (8)
# ===========================================================================

q("madm-a089", "madm_budget_roles",
  "A budget is described as three things at once. Which three?",
  ["A forecast, a contract and a target", "A forecast, a plan and a report",
   "A target, an incentive and a bonus", "A plan, a variance and a review"],
  "A forecast, a contract and a target",
  "- **Forecast** — the best guess of what will happen\n- **Contract** — the resources committed to the unit\n- **Target** — the number the manager is judged against\n\nThe overlap is the source of nearly every problem in the topic, because a good forecast and a tough target are rarely the same number. Ask one number to be both and it will be neither.\n\nThe three *roles* — planning, coordination and performance evaluation — are a related list and a different one.",
  "One is about prediction, one about resources, one about judgement.",
  qtype="case_fact", difficulty=1)

q("madm-a090", "madm_budget_roles",
  "What are the three roles of a budget?",
  ["Planning, coordination and performance evaluation",
   "Forecasting, financing and reporting",
   "Costing, pricing and allocation",
   "Authorisation, execution and audit"],
  "Planning, coordination and performance evaluation",
  "**Planning**: decide what to do and commit resources. **Coordination**: align functions and communicate expectations, so manufacturing plans for what sales intends to sell. **Performance evaluation**: hold managers accountable to the plan.\n\nThe tension is between the first two and the third. Planning and coordination want an accurate number; evaluation wants a demanding one.\n\nThat is why the professor said the benefit of budgeting comes from the process — the intense examination of targets, the challenging of assumptions, the examination of alternatives — rather than from the document.",
  "Two of the three are about what the firm will do; one is about how people will be judged.",
  qtype="case_fact", difficulty=1)

q("madm-a091", "madm_budget_roles",
  "Why is a good forecast rarely the same number as a good target?",
  ["A forecast should be unbiased; a target is set to stretch, so it deliberately sits above the expected outcome",
   "Forecasts are prepared annually and targets quarterly",
   "Forecasts include fixed costs and targets do not",
   "Targets are set by the board and forecasts by the finance function"],
  "A forecast should be unbiased; a target is set to stretch, so it deliberately sits above the expected outcome",
  "The two numbers are being asked to do different jobs. A forecast is an estimate and should be as close to right as possible. A target is a motivational device, usually set at what the professor called tight but attainable — which by construction is above the expected outcome.\n\nUse one number for both and something has to give. Set it at the forecast and it motivates nothing; set it at the stretch level and every downstream plan is built on a number the firm does not expect to hit.\n\nSome firms resolve this by keeping two numbers: a commitment and a forecast, updated separately.",
  "Ask what each number is for, and what a good one looks like.",
  qtype="case_fact")

q("madm-a092", "madm_budget_roles",
  "The budgeting process is described as recursive and political. Where does its value come from?",
  ["From the iteration itself — examining targets, challenging assumptions and choosing between alternatives",
   "From the accuracy of the final consolidated document",
   "From completing the cycle before the financial year begins",
   "From reducing the number of people involved so the process moves faster"],
  "From the iteration itself — examining targets, challenging assumptions and choosing between alternatives",
  "Budgets are rarely linear. Each step goes through revisions, and whole cycles get re-run. The professor's framing was that the benefit comes from that intensity: assumptions get challenged, alternatives get examined, and choices get made explicitly rather than by default.\n\nThe document is the residue. A perfectly accurate budget produced without argument would have taught the organisation nothing about its own plans.\n\nSpeed and narrow participation are exactly the wrong optimisations — they remove the argument that produces the value, and participation is also what surfaces local information.",
  "Ask whether the value is in the artefact or in producing it.",
  qtype="case_fact")

q("madm-a093", "madm_budget_roles",
  "A CFO proposes replacing budget-attainment bonuses with pay for forecast accuracy. What is the main thing this buys, and the main thing it loses?",
  ["It buys honest forecasts and loses the incentive to stretch — a manager about to miss now has a reason to let the miss happen",
   "It buys stretch performance and loses forecast quality",
   "It buys both accuracy and effort, with no offsetting loss",
   "It buys coordination and loses nothing, since forecasts are unrelated to effort"],
  "It buys honest forecasts and loses the incentive to stretch — a manager about to miss now has a reason to let the miss happen",
  "Paying for accuracy removes every reason to sandbag or pad, because a low forecast is now a forecast you have to hit exactly rather than a target you want to beat. Planning and coordination improve immediately.\n\nThe cost is that the number no longer asks for anything. And there is a sharper version: a manager who has forecast 100 and is heading for 110 now has an incentive to slow down, and one heading for 90 has no reason to fight.\n\nThat is the design exercise the professor closed the block with, and the answer is a trade-off rather than a fix.",
  "Ask what a manager paid purely for accuracy would do in the last month of the year.",
  qtype="case_fact", difficulty=3)

q("madm-a094", "madm_budget_roles",
  "Why is the revenue forecast built first, and what follows from that?",
  ["Every downstream budget is derived from it, so its error propagates through production, materials, labour and cash",
   "Revenue is the easiest number to forecast accurately",
   "Accounting standards require revenue to be budgeted before costs",
   "It is the only budget line the sales team is responsible for"],
  "Every downstream budget is derived from it, so its error propagates through production, materials, labour and cash",
  "Production comes from sales through the inventory equation, materials and labour come from production, overhead comes from the activity level, and cash comes from all of it. Every number inherits the revenue forecast's error.\n\nWhich is why the professor spent a slide on how to build it: triangulate local on-the-ground knowledge, macro and industry trends, and market research, rather than trusting any one source.\n\nRevenue is usually the *hardest* line to forecast, not the easiest, which is precisely the problem.",
  "Trace what each subsequent budget is computed from.",
  qtype="case_fact", difficulty=1)

q("madm-a095", "madm_budget_roles",
  "In what sense is a budget a contract?",
  ["It commits resources to the unit, which the unit can then rely on and the firm has agreed to fund",
   "It is legally enforceable against the manager",
   "It fixes transfer prices between divisions for the year",
   "It obliges the manager to spend the full amount allocated"],
  "It commits resources to the unit, which the unit can then rely on and the firm has agreed to fund",
  "The contract role is about resource commitment in both directions: the unit gets the headcount and spending it needs, and in exchange it accepts the plan.\n\nIt explains behaviour the other two roles do not. Padding is a response to the contract role — you ask for more than you need because what you are granted is what you will get. So is spending to avoid lapsing: an unspent allocation signals you needed less, and next year's contract shrinks.\n\nIt carries no legal force, and it certainly does not oblige anyone to spend the money — although the lapsing game makes it feel that way.",
  "Ask what the unit gets out of the budget, not just what it owes.",
  qtype="case_fact")

q("madm-a096", "madm_budget_roles",
  "A firm keeps a formal budget for evaluation and a separate rolling forecast updated monthly for planning. What problem is this design solving?",
  ["It splits the forecast and target roles so neither corrupts the other",
   "It reduces the total effort spent on budgeting",
   "It removes the need for variance analysis",
   "It makes the firm compliant with reporting standards"],
  "It splits the forecast and target roles so neither corrupts the other",
  "The tension is structural, so one response is to stop asking one number to do two jobs. The fixed budget carries the commitment and remains the standard for evaluation; the rolling forecast stays unbiased and drives operational decisions.\n\nThe cost is more effort, not less — two processes instead of one, plus the discipline to keep the forecast honest even when it diverges from the target the same people are judged on.\n\nVariance analysis still happens, and reporting standards say nothing about internal budgeting.",
  "The design keeps two numbers. Ask which role each one is carrying.",
  qtype="case_fact", difficulty=3)

# ===========================================================================
# Session 7 — master budget (3)
# ===========================================================================

q("madm-a097", "madm_master_budget",
  "A company budgets sales of 12,000 units, wants closing finished-goods inventory of 900 units and holds 1,400 at the start. How many units should it plan to produce?",
  ["11,500", "12,500", "14,300", "12,000"],
  "11,500",
  "Production = sales + ending inventory − beginning inventory = 12,000 + 900 − 1,400 = **11,500 units**.\n\nInventory is being drawn down by 500 units, so production is below sales by exactly that amount.\n\nThe common slip is to add the beginning inventory and subtract the ending one, which gives 12,500. Check the direction against intuition: if you are running stock down, you make fewer than you sell.",
  "Sales plus what you want to be left with, minus what you already have.",
  difficulty=1)

q("madm-a098", "madm_master_budget",
  "A firm plans to produce 9,400 units, each using 3 litres of a solvent. It holds 2,600 litres and wants 4,000 litres at the end. Solvent costs $7 a litre. What is the budgeted cost of purchases?",
  ["$207,200", "$197,400", "$217,000", "$187,600"],
  "$207,200",
  "Two steps.\n\n1. Solvent needed for production = 9,400 x 3 = **28,200 litres**\n2. Purchases = needed + ending − beginning = 28,200 + 4,000 − 2,600 = **29,600 litres**\n\nCost = 29,600 x $7 = **$207,200**.\n\nThe inventory equation runs twice in a master budget — once in units to get production from sales, once in input units to get purchases from production. Skipping the second step gives 28,200 litres and $197,400.",
  "Convert production into input requirement, then adjust that requirement for opening and closing stock.",
  difficulty=3)

q("madm-a099", "madm_master_budget",
  "Why do selling and administrative costs flow directly to the income statement rather than through inventory?",
  ["They are period costs driven by the sales plan, not costs of making the product",
   "They are always fixed, and fixed costs cannot be inventoried",
   "They are incurred after the product is sold",
   "They are immaterial in most budgets"],
  "They are period costs driven by the sales plan, not costs of making the product",
  "Product costs attach to units and sit in inventory until those units are sold. Selling and administrative costs are not costs of making anything — they are driven by the sales plan and belong to the period in which they are incurred.\n\nThis is why the budgeted income statement shows variable marketing and administration inside contribution margin, and fixed marketing and administration below it, without either ever passing through COGM or COGS.\n\nSome of them are variable, some are incurred long before a sale, and in most firms they are large. The classification is about what the cost is for, not its size, timing or behaviour.",
  "Ask whether the cost is incurred to make a unit or to run the period.",
  qtype="case_fact")

# ===========================================================================
# Session 7 — budget behaviour (5)
# ===========================================================================

q("madm-a100", "madm_budget_behavior",
  "A manager who beat her target by 20% this year finds next year's target raised by 20%. She resolves to deliver no more than 5% above target in future. What is this?",
  ["The ratchet effect", "Sandbagging", "Spending to avoid lapsing", "A timing game"],
  "The ratchet effect",
  "The **ratchet effect** is headquarters anchoring next year's target on this year's actual, so beating the target is punished with a harder one. Her response — capping how good she is willing to look — is the predictable consequence.\n\nSandbagging is low-balling the target during negotiation, which is a different move at a different moment. This manager is not negotiating; she is managing her actual result.\n\nThe distinction is worth holding: sandbagging happens when the target is set, the ratchet response happens when it is being delivered.",
  "Ask what triggered the behaviour: how the target was negotiated, or how last year's result was used.",
  qtype="case_fact", difficulty=1)

q("madm-a101", "madm_budget_behavior",
  "A department with $80,000 unspent in its training budget books a series of courses in the final three weeks of the financial year. What is this called, and what causes it?",
  ["Spending to avoid lapsing — an unspent allocation signals a lower need and shrinks next year's budget",
   "Padding — the department requested more than it needed",
   "A timing game — the spending is being pushed into the next period",
   "The ratchet effect — the target has been raised because of past performance"],
  "Spending to avoid lapsing — an unspent allocation signals a lower need and shrinks next year's budget",
  "Use it or lose it. Because next year's allocation is anchored on this year's spending, handing money back is expensive in a way that spending it badly is not.\n\nThe manager is responding rationally to the budget's contract role. The fix is in the system — carry-forward provisions, or separating the resource commitment from next year's baseline — rather than in the manager.\n\nA timing game would be the opposite move: delaying spending across the year-end. This is accelerating it.",
  "Ask what happens to next year's allocation if the money is handed back.",
  qtype="case_fact", difficulty=1)

q("madm-a102", "madm_budget_behavior",
  "A sales manager persuades a customer to delay a large December order into January so the revenue lands in the new year's target period. What is this?",
  ["A timing game", "Sandbagging", "Padding", "Spending to avoid lapsing"],
  "A timing game",
  "**Timing games** shift revenue or cost across the period boundary without changing the underlying business. Here December is already secure, or already lost, and January's target gets a head start.\n\nSandbagging and padding are both about the *target-setting* stage: shading the output target and inflating the resource request respectively. This manager accepted her target and is managing which side of the line the transaction falls on.\n\nThe economic damage is usually small and occasionally large — a delayed order can be a cancelled one.",
  "Nothing about the business changed. Only which period the number lands in.",
  qtype="case_fact", difficulty=1)

q("madm-a103", "madm_budget_behavior",
  "What is the central trade-off in participative budgeting?",
  ["It taps local knowledge and builds commitment, while handing the information advantage to people who benefit from shading the numbers",
   "It is faster than top-down budgeting but produces less detailed plans",
   "It improves accuracy but reduces manager motivation",
   "It works in small firms but is impossible in large ones"],
  "It taps local knowledge and builds commitment, while handing the information advantage to people who benefit from shading the numbers",
  "The people closest to the numbers know the most and also have the most to gain from misrepresenting them. That is the padding trade-off, and it is why participation is a genuine dilemma rather than an obvious best practice.\n\nMost firms land on a mix of top-down and bottom-up, with goals set tight but attainable — the top-down element caps the shading, the bottom-up element captures the knowledge.\n\nParticipation is slower, not faster, and it raises motivation through commitment rather than lowering it.",
  "Ask who holds the information, and what they gain from how they report it.",
  qtype="case_fact")

q("madm-a104", "madm_budget_behavior",
  "Which framing of budget gaming matches the professor's?",
  ["Rational responses to how the budget is used, so the fix is in the system rather than in the individuals",
   "Ethical failures by individual managers, best addressed through the code of conduct",
   "Unavoidable behaviour that firms should ignore",
   "Evidence that budgeting should be abandoned altogether"],
  "Rational responses to how the budget is used, so the fix is in the system rather than in the individuals",
  "His slide said it directly: these are rational responses to how the budget is used, not bad apples. Sandbagging, padding, lapsing and timing games all follow from using one number as forecast, contract and target at once.\n\nThat framing matters because it points at the remedy. Replacing the managers changes nothing; changing how targets are anchored, how slack is treated and how rewards are structured changes the behaviour.\n\nThere is a real ethical boundary — the textbook's controller faces plans known to be false — but treating the whole phenomenon as a character problem misdiagnoses it.",
  "Ask where the professor located the cause: in the people or in the design.",
  qtype="case_fact")

# ===========================================================================
# Session 8 — flexible budget (6)
# ===========================================================================

q("madm-a105", "madm_flexible_budget",
  "A firm budgeted 20,000 units at a variable cost of $14 and fixed costs of $180,000, and actually made 17,000 units. What is the flexible budget total cost?",
  ["$418,000", "$460,000", "$355,300", "$238,000"],
  "$418,000",
  "Flex the variable costs to actual output and leave fixed costs alone.\n\n- Variable: 17,000 x $14 = $238,000\n- Fixed: **$180,000**, unchanged\n\nFlexible budget total cost = **$418,000**.\n\nThe static budget was 20,000 x 14 + 180,000 = $460,000, and comparing actual cost against that number would credit the plant for the 3,000 units it did not have to make. Flexing only the variable half is what makes the comparison fair.",
  "Variable costs flex with output; fixed costs do not.",
  difficulty=1)

q("madm-a106", "madm_flexible_budget",
  "Why do fixed costs appear at the same amount in both the static and the flexible budget?",
  ["Because they do not vary with output, so re-computing the budget at a different volume does not change them",
   "Because fixed costs are outside management control",
   "Because the flexible budget only re-computes revenue",
   "Because fixed costs are allocated after the flexible budget is prepared"],
  "Because they do not vary with output, so re-computing the budget at a different volume does not change them",
  "The flexible budget answers one question: what would the numbers have been at the actual volume, if everything else had gone as planned? Fixed costs are by definition the part of the answer that does not depend on volume.\n\nSo any difference between budgeted and actual fixed cost is a **spending** variance — the committed capacity cost itself changed — and there is no quantity component to separate out.\n\nBeing fixed is not the same as being uncontrollable. Over a longer horizon, capacity is a choice.",
  "Ask what the flexible budget is holding constant, and what it is varying.",
  qtype="case_fact", difficulty=1)

q("madm-a107", "madm_flexible_budget",
  "A firm's actual profit is $105,000, its flexible budget profit is $90,000 and its master budget profit is $150,000. Which variance is the plant manager's, and what is it?",
  ["The flexible budget variance, $15,000 F", "The sales volume variance, $60,000 U",
   "The total profit variance, $45,000 U", "The flexible budget variance, $60,000 U"],
  "The flexible budget variance, $15,000 F",
  "The flexible budget variance is actual less flexible: 105,000 − 90,000 = **$15,000 F**. That is everything that happened at the volume actually produced, which is the plant's responsibility.\n\nThe sales volume variance of $60,000 U — flexible less master — is the profit lost by selling fewer units, and belongs to the revenue centre.\n\nThe total profit variance of $45,000 U is the sum of the two and belongs to nobody in particular, which is exactly why it has to be split before anyone is evaluated.",
  "Identify which pair of columns brackets the volume effect, and which pair brackets execution.",
  difficulty=1)

q("madm-a108", "madm_flexible_budget",
  "In which situation is a flexible budget least informative?",
  ["A firm whose costs are almost entirely fixed, so there is little to flex",
   "A firm with high variable costs and volatile volume",
   "A plant whose output differed substantially from plan",
   "A business with several products at different contribution margins"],
  "A firm whose costs are almost entirely fixed, so there is little to flex",
  "Flexing changes the variable lines. If almost everything is fixed — software, semiconductors, the high-fixed-cost environments on the professor's when-is-variance-analysis-less-useful slide — the flexible budget is nearly identical to the static one and adds little.\n\nThe other three are where it earns its keep. High variable costs mean a large volume adjustment; a big volume miss is exactly what it corrects for; and a multi-product mix is a case where flexing on total units alone can mislead unless mix is handled too.",
  "Ask how much of the budget actually changes when you re-compute it at a different volume.",
  qtype="case_fact", difficulty=3)

q("madm-a109", "madm_flexible_budget",
  "A plant produced 9,000 units against a budget of 10,000. Budgeted variable cost was $22 a unit and actual variable cost was $205,000. What is the variable cost variance?",
  ["$7,000 U", "$15,000 F", "$7,000 F", "$22,000 F"],
  "$7,000 U",
  "Flexible budget variable cost = 9,000 x $22 = **$198,000**. Actual was $205,000.\n\nVariance = 205,000 − 198,000 = **$7,000 U**.\n\nAgainst the static budget of $220,000 the same actual looks like a $15,000 saving, which is the distractor and the mistake. Producing 1,000 fewer units should have saved $22,000; only $15,000 of that appeared, so the plant overspent by $7,000 at the volume it actually ran.",
  "Compute what the standard allows for 9,000 units, then compare with what was spent.",
  difficulty=1)

q("madm-a110", "madm_flexible_budget",
  "What has to be known to build a flexible budget?",
  ["The actual output, plus the budgeted price, budgeted variable cost per unit and budgeted fixed cost",
   "The actual output and the actual costs incurred",
   "The budgeted output and the actual selling price",
   "The variance report from the previous period"],
  "The actual output, plus the budgeted price, budgeted variable cost per unit and budgeted fixed cost",
  "One actual number — the volume — and everything else from the original standards. That is what makes it the middle column: actual volume, budgeted everything.\n\nUsing any actual price or actual cost per unit would contaminate it and destroy the separation it exists to create.\n\nThis also answers the objection that a flexible budget cannot be prepared without more data. The standards were set when the budget was built, and the volume is known at period end.",
  "The middle column takes exactly one input from the actual results. Which one?",
  qtype="case_fact")

# ===========================================================================
# Session 8 — variance decomposition (3)
# ===========================================================================

q("madm-a111", "madm_variance_decomposition",
  "Which pair of variances sums to the total profit variance?",
  ["Sales volume variance and flexible budget variance",
   "Sales price variance and sales volume variance",
   "Variable cost variance and fixed cost variance",
   "Sales price variance and total cost variance"],
  "Sales volume variance and flexible budget variance",
  "The top split of the tree. The sales volume variance is flexible budget profit less master budget profit; the flexible budget variance is actual profit less flexible budget profit. Together they bracket the whole distance from master budget to actual.\n\nThe other combinations are all components sitting one level lower. Sales price, variable cost and fixed cost variances are the three pieces the flexible budget variance splits into, so any pair of them is incomplete.\n\nDrawing the tree before answering is the reliable method for these.",
  "Which two differences, laid end to end, span master budget profit to actual profit?",
  qtype="case_fact", difficulty=1)

q("madm-a112", "madm_variance_decomposition",
  "A firm reports a $40,000 U total profit variance, of which $34,000 U is the sales volume variance. What does the remainder tell you?",
  ["Operations and pricing together were $6,000 U at the volume actually achieved",
   "The plant overspent by $40,000 at the volume actually achieved",
   "Sales prices were $6,000 below budget",
   "Fixed costs were $6,000 above budget"],
  "Operations and pricing together were $6,000 U at the volume actually achieved",
  "The remainder is the flexible budget variance: 40,000 − 34,000 = **$6,000 U**. It contains everything that happened at the achieved volume — sales price, all the variable cost variances, and the fixed cost variance.\n\nSo it cannot be attributed to price alone or to fixed costs alone without breaking it down further.\n\nThe headline reading matters here. Most of the miss was volume, which is a demand or forecasting story, not an execution one. Reporting $40,000 U as a plant failure would be wrong by a factor of nearly seven.",
  "Subtract the volume effect, then ask what is left inside the remainder.",
  qtype="case_fact")

q("madm-a113", "madm_variance_decomposition",
  "A firm's total profit variance is $9,000 F. Its sales price variance is $12,000 U, its variable cost variance is $18,000 F and its fixed cost spending variance is $5,000 U. What is the sales volume variance?",
  ["$8,000 F", "$8,000 U", "$2,000 F", "$14,000 F"],
  "$8,000 F",
  "Write the identity with signs, treating unfavourable as negative:\n\n9,000 = (−12,000) + 18,000 + (−5,000) + volume\n\n9,000 = 1,000 + volume, so volume = **$8,000 F**.\n\nThese back-solving questions test whether you hold the tree rather than a single formula. The reliable method is always the same: list every component, sign each one, and solve for the missing term.",
  "Set the total equal to the sum of its four components, sign each, and solve.",
  difficulty=3)

# ===========================================================================
# Session 8 — sales variances (4)
# ===========================================================================

q("madm-a114", "madm_sales_variances",
  "A firm budgeted 6,000 units at a contribution margin of $18 and sold 6,700. What is the sales volume variance?",
  ["$12,600 F", "$12,600 U", "$700 F", "$120,600 F"],
  "$12,600 F",
  "Sales volume variance = (actual units − budgeted units) x budgeted contribution margin = (6,700 − 6,000) x $18 = **$12,600 F**.\n\nThe budgeted contribution margin is used deliberately: the volume variance is meant to isolate the effect of selling more units *at plan*, leaving any price or cost differences to their own variances.\n\nMultiplying the 700 extra units by the selling price rather than the contribution margin is the standard error, and it overstates the profit effect substantially.",
  "The volume variance is a profit number, so value the extra units at contribution margin.",
  difficulty=1)

q("madm-a115", "madm_sales_variances",
  "A firm sold 4,200 units at an average price of $58 against a budgeted price of $62. What is the sales price variance?",
  ["$16,800 U", "$16,800 F", "$4,200 U", "$260,400 U"],
  "$16,800 U",
  "Sales price variance = (actual price − budgeted price) x actual units = (58 − 62) x 4,200 = **$16,800 U**.\n\nEquivalently: actual revenue of $243,600 against flexible budget revenue of 4,200 x $62 = $260,400.\n\nNote that it is valued at **actual** units, not budgeted units. The price shortfall only applied to the units that were actually sold.",
  "Price difference per unit, multiplied by the units actually sold.",
  difficulty=1)

q("madm-a116", "madm_sales_variances",
  "A manager reports a favourable sales volume variance and an unfavourable sales price variance of similar size, following a deliberate discount. What should be concluded?",
  ["Net the two — the discount was worth taking only if the volume gain exceeded the price give-away",
   "The volume variance is what matters, since it shows demand responded",
   "The price variance is what matters, since price is what management controls",
   "Nothing can be concluded without the cost variances"],
  "Net the two — the discount was worth taking only if the volume gain exceeded the price give-away",
  "The discount caused both variances, so they have to be read together. Netting them gives the profit effect of the pricing decision.\n\nThe putter case is the worked version: $85,200 F of volume against $196,000 U of price, so the cut destroyed $110,800 of profit. The extra volume did not come close to compensating for the lower price, because demand was less price-sensitive than assumed.\n\nThe cost variances are separate — they were caused by other decisions and belong in their own comparison.",
  "One decision caused both numbers, so evaluate the decision on their net.",
  qtype="case_fact")

q("madm-a117", "madm_sales_variances",
  "A firm's static budget revenue is $500,000, its flexible budget revenue is $440,000 and its actual revenue is $455,000. What are the volume and price effects on revenue?",
  ["$60,000 U from volume, $15,000 F from price",
   "$45,000 U from volume, $15,000 U from price",
   "$60,000 F from volume, $15,000 U from price",
   "$45,000 U from volume and nothing from price"],
  "$60,000 U from volume, $15,000 F from price",
  "The flexible budget sits between the two, so read the two gaps.\n\n- Static to flexible: 500,000 − 440,000 = **$60,000 U** from selling fewer units\n- Flexible to actual: 455,000 − 440,000 = **$15,000 F** from a higher realised price\n\nThey net to the $45,000 revenue shortfall, and they tell opposite stories: the firm sold less than planned but got more per unit than planned. Reporting only the $45,000 would hide both.\n\nNote that this decomposition is on **revenue**. The sales volume variance in the profit tree is the same volume effect valued at contribution margin instead.",
  "Take the two gaps either side of the flexible budget column.",
  difficulty=1)

# ===========================================================================
# Session 8 — fixed cost variance (7)
# ===========================================================================

q("madm-a118", "madm_fixed_cost_variance",
  "Budgeted fixed costs were $260,000 and actual fixed costs were $271,500. What is the fixed cost spending variance?",
  ["$11,500 U", "$11,500 F", "Cannot be computed without the volume", "Zero, since fixed costs do not flex"],
  "$11,500 U",
  "Fixed cost spending variance = budgeted − actual = 260,000 − 271,500 = **$11,500 U**.\n\nVolume is irrelevant, which is what makes this the simplest variance in the tree: the budgeted figure is the same in the static and the flexible budget, so there is one comparison and no quantity component.\n\nThe last distractor confuses the flexing with the variance. Fixed costs do not flex with volume, and they can still differ from budget.",
  "Fixed costs appear identically in both budget columns, so there is only one difference to take.",
  difficulty=1)

q("madm-a119", "madm_fixed_cost_variance",
  "Why is there no quantity-and-price split for a fixed cost variance?",
  ["There is no input quantity that varies with output, so there is nothing for the flexible budget to flex",
   "Fixed costs are always paid at a contracted price",
   "The split is possible but is not required by accounting standards",
   "Fixed costs are allocated rather than incurred"],
  "There is no input quantity that varies with output, so there is nothing for the flexible budget to flex",
  "The three-column method depends on there being a standard input per unit of output. Fixed costs have no such standard — rent does not have a per-unit quantity — so the as-if column has nothing to be built from.\n\nWhat a fixed cost variance does tell you is that the committed capacity cost itself changed: a rent increase, an unbudgeted machine rental, an extra supervisor, deferred maintenance.\n\nFixed costs are certainly incurred rather than merely allocated, and their prices are not always contracted.",
  "Ask what the middle column of the three-column method needs, and whether a fixed cost has it.",
  qtype="case_fact")

q("madm-a120", "madm_fixed_cost_variance",
  "A plant reports a favourable fixed cost variance in the final month of its financial year. Why is this worth investigating rather than celebrating?",
  ["It is often produced by deferring maintenance or training, which returns as downtime and efficiency losses later",
   "Favourable fixed cost variances are arithmetically impossible",
   "It usually means fixed costs were misclassified as variable",
   "It means volume must have been below plan"],
  "It is often produced by deferring maintenance or training, which returns as downtime and efficiency losses later",
  "Deferring discretionary spending is the easiest way to make a period's cost target, and the timing is the clue: the last month of the measurement cycle is when a manager who is behind has the strongest reason to do it.\n\nThe cost does not disappear, it moves. Skipped preventive maintenance shows up as unplanned downtime and unfavourable efficiency variances in the following quarter.\n\nThat is the December-moves quick check, and it is why a favourable variance at the end of a cycle deserves more scrutiny than an unfavourable one.",
  "Ask what a manager behind on a cost target can do cheaply in the last month, and where the bill arrives.",
  qtype="case_fact")

q("madm-a121", "madm_fixed_cost_variance",
  "A plant rents extra equipment for $60,000, producing a $60,000 U fixed cost variance, an $85,000 F material quantity variance and a $40,000 F labour quantity variance. What is the right conclusion?",
  ["The rental added $65,000 of profit and was a good decision",
   "The rental cost $60,000 and should be discontinued",
   "The variances are unrelated and should be assessed separately",
   "The favourable variances prove the standards were too loose"],
  "The rental added $65,000 of profit and was a good decision",
  "Group the variances the decision caused, then net them: 85,000 F + 40,000 F − 60,000 U = **$65,000 F**.\n\nRead alone, the $60,000 U looks like overspending, and a manager judged line by line would never rent the equipment. Read alongside what it bought, it is one of the better decisions of the year.\n\nThis is the strongest illustration in the course that an unfavourable variance can be evidence of a good decision — and the reason the report has to be read as a whole.",
  "Ask which variances the rental decision caused, then net that group.",
  qtype="case_fact", difficulty=3)

q("madm-a122", "madm_fixed_cost_variance",
  "Volume came in 20% below plan and fixed costs came in $9,000 under budget. What question should this raise?",
  ["Whether the underspend is a genuine saving or spending that was postponed because volume was low",
   "Whether fixed costs were incorrectly flexed to the lower volume",
   "Whether the sales volume variance has been double-counted",
   "Whether the fixed cost variance should be reported as favourable at all"],
  "Whether the underspend is a genuine saving or spending that was postponed because volume was low",
  "Fixed costs should not fall with volume — that is what makes them fixed. So a favourable fixed cost variance in a low-volume period is worth a question: was capacity genuinely reduced, or was discretionary spending simply not incurred because the plant was quiet?\n\nDeferred maintenance, cancelled training and postponed hiring all look identical to a saving in the month and are not the same thing at all.\n\nIf the costs had been flexed downward, the variance would be an error rather than a question — which is the second distractor and a different problem.",
  "Ask why a cost that does not vary with volume happened to fall in a low-volume period.",
  qtype="case_fact", difficulty=3)

q("madm-a123", "madm_fixed_cost_variance",
  "Variable overhead is budgeted at $1.25 per labour hour with a standard of 0.4 hours per unit. Output was 8,000 units and actual variable overhead was $3,800. What is the variable overhead variance?",
  ["$200 F", "$200 U", "$1,200 F", "$800 F"],
  "$200 F",
  "The flexible budget flexes on the activity base. Standard hours for the actual output are 8,000 x 0.4 = 3,200, so budgeted variable overhead is 3,200 x $1.25 = **$4,000**.\n\nActual was $3,800, so the variance is **$200 F**.\n\nVariable overhead is treated like any other variable cost, and it can be split further into spending and efficiency components using the same three columns — the efficiency part follows the labour hours, since hours are the base.",
  "Flex the overhead on the standard hours allowed for the actual output.",
  difficulty=1)

q("madm-a124", "madm_fixed_cost_variance",
  "A firm's fixed manufacturing overhead includes $24,000 of straight-line depreciation. What does that imply about the fixed cost variance?",
  ["The depreciation element will not vary, so any variance comes from the other fixed costs",
   "Depreciation must be excluded from the fixed cost variance entirely",
   "The variance should be computed per unit, since depreciation is a unit cost",
   "Depreciation makes the fixed cost variance uncontrollable"],
  "The depreciation element will not vary, so any variance comes from the other fixed costs",
  "Straight-line depreciation on assets already owned is fixed by an accounting policy set in advance. Barring a disposal or an addition, it will come in exactly at budget.\n\nSo the whole fixed cost variance is generated by the remaining fixed items — supervision, rent, insurance, maintenance, equipment rentals — and that is where the investigation should go.\n\nThe Hempstead problem is built this way: $24,000 of depreciation lands exactly on budget and the entire $4,000 F variance comes from other fixed manufacturing overhead.",
  "Ask which fixed items could possibly differ from budget, and which are locked by policy.",
  qtype="case_fact")

# ===========================================================================
# Session 8 — variance interpretation (6)
# ===========================================================================

q("madm-a125", "madm_variance_interpretation",
  "A plant reports a strongly favourable labour efficiency variance. Which explanation would make it bad news?",
  ["Operators skipped in-process quality checks to hit the output number",
   "A new fixture reduced the time per unit",
   "Operators completed a training programme",
   "A redesigned layout removed a materials-handling step"],
  "Operators skipped in-process quality checks to hit the output number",
  "Fewer hours per unit is favourable by construction. Whether it is good depends entirely on what produced it.\n\nSkipped quality checks buy time now and pay for it in scrap, rework, warranty claims and customer complaints — none of which appear in the labour efficiency line.\n\nThe other three are genuine process improvements, and would show up alongside stable or improving quality metrics. The variance itself cannot tell you which of the four happened, which is the whole point of treating it as a signal.",
  "Ask what could produce fewer hours per unit without anything actually improving.",
  qtype="case_fact")

q("madm-a126", "madm_variance_interpretation",
  "Which combination of variances most strongly suggests a single upstream cause rather than independent events?",
  ["Favourable material price with unfavourable material quantity and unfavourable labour efficiency",
   "Unfavourable material price with unfavourable material quantity",
   "Favourable sales volume with favourable material price",
   "Unfavourable fixed cost with unfavourable sales price"],
  "Favourable material price with unfavourable material quantity and unfavourable labour efficiency",
  "That pattern is the signature of a purchasing decision: a cheaper, lower-grade input costs less per unit, tears or fails more often, and takes longer to work with.\n\nOne decision, three variances, in two different departments — which is exactly why reading the report line by line misleads. Purchasing looks excellent and production looks incompetent.\n\nThe other combinations are each plausible as independent events. Two unfavourable material variances together suggest a supply problem but do not link to labour; the last two pairs have no mechanism connecting them.",
  "Look for a pattern that one decision, taken in one department, would produce across several lines.",
  qtype="case_fact")

q("madm-a127", "madm_variance_interpretation",
  "Which is not one of the conditions under which the professor said variance analysis becomes less useful?",
  ["Firms with a stable product mix and predictable demand",
   "High fixed-cost environments such as software and semiconductors",
   "Innovation-driven firms where variance discipline discourages experimentation",
   "Service firms where quantity standards for knowledge work are hard to define"],
  "Firms with a stable product mix and predictable demand",
  "Stable mix and predictable demand is where variance analysis works **best**: standards are meaningful, the budget stays relevant through the period, and a deviation genuinely signals something.\n\nThe other three are all on his slide, along with rapidly shifting demand where the budget is obsolete before the period ends.\n\nThe common thread among the real limitations is that either the standard is meaningless, the comparison is against a plan nobody believes, or the discipline itself discourages what the firm needs.",
  "Three of these make standards or comparisons unreliable. One makes them reliable.",
  qtype="case_fact", difficulty=1)

q("madm-a128", "madm_variance_interpretation",
  "A purchasing manager is measured on the material price variance alone. What behaviour does this reliably produce?",
  ["Buying cheaper, lower-grade inputs and pushing the consequences into other departments' variances",
   "Negotiating longer-term supply contracts at stable prices",
   "Holding lower inventories to reduce carrying cost",
   "Refusing to buy at all when prices exceed standard"],
  "Buying cheaper, lower-grade inputs and pushing the consequences into other departments' variances",
  "The measure sees price per unit of input and nothing else. Quality, reliability, lead time and the downstream effects on usage and labour are all invisible to it, and all land on someone else's line.\n\nSo the rational response is to buy cheap. It is one of the four gaming behaviours on the professor's slide, and it is precisely what the Glass Vessels pattern shows.\n\nThe fix is on the measure: hold purchasing partly accountable for the quantity variances its choices drive, or add supplier quality and delivery metrics.",
  "Ask what the measure sees and what it does not, then ask what maximising it looks like.",
  qtype="case_fact")

q("madm-a129", "madm_variance_interpretation",
  "Which statement best captures what a variance report is for?",
  ["It is a diagnostic that tells you where to investigate, not a verdict on who performed well",
   "It is the definitive record of each manager's performance for the period",
   "It replaces the need for operational review meetings",
   "It identifies which costs should be cut in the following period"],
  "It is a diagnostic that tells you where to investigate, not a verdict on who performed well",
  "The professor's executive takeaways say it directly: variances are diagnostics, not verdicts, and root causes should be investigated before blame is assigned.\n\nA variance tells you that actual differed from standard. It cannot tell you whether the standard was right, whether the deviation was a good decision, or whether the favourable number was bought at a cost that lands next quarter.\n\nHe added a fourth point worth remembering: not all variances deserve equal management attention. A small variance on a large line may matter more than a large one on a small line, and neither is worth pursuing if the cause is already understood.",
  "Ask what a variance can establish on its own, and what it cannot.",
  qtype="case_fact", difficulty=1)

q("madm-a130", "madm_variance_interpretation",
  "Target's gross margin fell from about 30% to 21.5% while inventory ran 40% above the prior year. Which diagnostic question does variance analysis help answer first?",
  ["Whether the shortfall came from demand and pricing or from operational execution",
   "Whether the inventory should be written down or held",
   "Whether the stock price reaction was justified",
   "Whether the merchandising team should be replaced"],
  "Whether the shortfall came from demand and pricing or from operational execution",
  "The first cut is always the same: separate the sales volume variance from the flexible budget variance. One is a demand and forecasting story that belongs to merchandising and marketing; the other is execution at the volume actually achieved.\n\nWith margins collapsing under markdowns and inventory 40% high, the diagnostic points at forecasting and buying rather than at store operations — but that is a conclusion the decomposition supports, not one to assume.\n\nOnly after the split does it make sense to ask which responsibility centre owns the result, which was the professor's next slide.",
  "What is the first split in the decomposition tree, and what question does it answer?",
  qtype="case_fact")

# ===========================================================================
# Session 8 — ABC in the service sector (2)
# ===========================================================================

q("madm-a131", "madm_abc_service_sector",
  "Buckeye's branch managers were paid a bonus for hitting account-growth targets, and 80% of them succeeded while profits fell. What is the general lesson?",
  ["A volume-based incentive with no view of cost-to-serve pays managers to add loss-making customers",
   "Bonus plans should never be based on customer counts",
   "The targets were set too low, so the bonus was too easy to earn",
   "Branch managers cannot be held accountable for profitability"],
  "A volume-based incentive with no view of cost-to-serve pays managers to add loss-making customers",
  "The managers did exactly what they were paid to do. Every retail account they added lost the bank $1.15 a year, and nothing in their measure could see that.\n\nThis is the control-system framework failing on component two: the measure is inconsistent with what the firm wants. Numbers make people do things, and this number told branch managers to grow a loss.\n\nAccount counts are a perfectly reasonable measure once they are paired with a profitability screen — the fault is the absence of the second half, not the presence of the first.",
  "Ask what the bonus measured, and what the bank actually wanted.",
  qtype="case_fact")

q("madm-a132", "madm_abc_service_sector",
  "Retail customers wrote a tenth of Buckeye's check value but made 80% of teller transactions and 95% of inquiry calls. Why did the old system get their cost so badly wrong?",
  ["The base measured the size of transactions while the real cost drivers were the number of times customers used branch and call-centre capacity",
   "The base was applied to the wrong cost pool",
   "The bank's total indirect cost was understated",
   "Retail accounts should have been treated as direct costs"],
  "The base measured the size of transactions while the real cost drivers were the number of times customers used branch and call-centre capacity",
  "Dollar value of checks is a size measure. Nothing about handling a check depends on the amount written on it, and nothing about it captures walking into a branch or telephoning the service centre.\n\nSince retail wrote small checks, the base charged them almost nothing — while they were consuming the two most expensive activities almost entirely. Business customers, whose large checks made them look costly, barely used either.\n\nThe pool was the right pool and its total was right. The base was the failure, which is exactly the Session 6 lesson transplanted into a service business.",
  "Compare what the allocation base measures against what actually makes the bank do work.",
  qtype="case_fact", difficulty=3)

# ===========================================================================
# Session 9 — divisional performance (3)
# ===========================================================================

q("madm-a133", "madm_divisional_performance",
  "A division earns operating income of $700,000 on assets of $3,500,000 with a required return of 11%. What are its ROI and residual income?",
  ["ROI 20%, residual income $315,000", "ROI 20%, residual income $385,000",
   "ROI 5%, residual income $315,000", "ROI 20%, residual income $77,000"],
  "ROI 20%, residual income $315,000",
  "ROI = 700,000 / 3,500,000 = **20%**.\n\nCapital charge = 0.11 x 3,500,000 = $385,000, so residual income = 700,000 − 385,000 = **$315,000**.\n\nThe $385,000 distractor is the capital charge itself rather than what is left after it. The two measures answer different questions: ROI asks how efficiently capital is being used, residual income asks how much value is being created above the cost of that capital.",
  "ROI is a ratio; residual income is what remains after charging for the capital.",
  difficulty=1)

q("madm-a134", "madm_divisional_performance",
  "Why can residual income not be used to rank divisions of very different sizes?",
  ["It is an absolute amount, so a larger division shows a larger figure simply by being larger",
   "It ignores the cost of capital, which differs across divisions",
   "It is computed after tax, unlike ROI",
   "It requires GAAP adjustments that small divisions cannot make"],
  "It is an absolute amount, so a larger division shows a larger figure simply by being larger",
  "A division with ten times the assets earning the same percentage return above its capital charge will show roughly ten times the residual income. That says nothing about which is better managed.\n\nThat is the trade-off against ROI: ROI is comparable and creates the underinvestment problem, residual income fixes the underinvestment problem and loses comparability.\n\nResidual income explicitly charges for the cost of capital — that is its defining feature. Computing after tax and adjusting for GAAP are features of EVA.",
  "Ask what happens to each measure when you double the size of a division without changing its returns.",
  qtype="case_fact")

q("madm-a135", "madm_divisional_performance",
  "A firm has operating income of $500,000, a tax rate of 30%, assets of $4,000,000, current liabilities of $300,000 and a WACC of 9%. What is EVA?",
  ["$17,000", "$50,000", "$110,000", "$140,000"],
  "$17,000",
  "$$\\text{EVA} = \\text{Operating income} \\times (1 - t) - \\text{WACC} \\times (\\text{Assets} - \\text{Current liabilities})$$\n\nAfter-tax operating profit = 500,000 x 0.70 = **$350,000**. Capital base = 4,000,000 − 300,000 = $3,700,000, and the charge is 0.09 x 3,700,000 = **$333,000**.\n\nEVA = 350,000 − 333,000 = **$17,000**.\n\nTwo things distinguish EVA from residual income: the income is after tax, and the capital base nets off current liabilities. Forgetting either produces one of the distractors.",
  "Take income after tax, then charge WACC on assets net of current liabilities.",
  difficulty=3)

# ===========================================================================
# Session 9 — transfer pricing basics (7)
# ===========================================================================

q("madm-a136", "madm_transfer_pricing_basics",
  "A transfer price is raised from $80 to $95 on 10,000 internal units. What happens to corporate pre-tax profit?",
  ["It is unchanged — the seller gains $150,000 and the buyer loses the same amount",
   "It rises by $150,000, since the seller's revenue increases",
   "It falls by $150,000, since the buyer's costs increase",
   "It depends on the seller's variable cost"],
  "It is unchanged — the seller gains $150,000 and the buyer loses the same amount",
  "One division's revenue is the other's cost, so they cancel exactly on consolidation. **$150,000** moves from the buying division's profit to the selling division's, and the group total does not move.\n\nWhich is why the goal of transfer pricing is goal congruence rather than maximising either division's profit.\n\nThe qualification worth remembering: this holds for pre-tax profit within one tax jurisdiction. Once the divisions sit in different countries with different rates, the split changes the group's tax bill and the zero-sum property breaks.",
  "Ask what the same number is on each division's income statement.",
  difficulty=1)

q("madm-a137", "madm_transfer_pricing_basics",
  "If a transfer price does not change corporate profit, why do division managers fight over it so hard?",
  ["Divisional profit drives bonuses, promotions, capital allocation and whether the division survives",
   "Because the transfer price determines the firm's tax bill in every case",
   "Because corporate profit is not what senior management is measured on",
   "Because transfer prices are disclosed in the financial statements"],
  "Divisional profit drives bonuses, promotions, capital allocation and whether the division survives",
  "The number is consequential even though it is internal. Divisional profit is the primary metric for evaluating a division manager, profitable divisions get investment dollars while unprofitable ones get cut, and persistently unprofitable divisions get shut or sold.\n\nSo a transfer price that moves $150,000 between two divisions moves bonuses, capital and careers, and rational managers behave accordingly.\n\nTax effects are real but only across jurisdictions, and internal transfer prices are not separately disclosed in financial statements.",
  "Ask what divisional profit is used for inside the firm.",
  qtype="case_fact", difficulty=1)

q("madm-a138", "madm_transfer_pricing_basics",
  "What are the three objectives a transfer pricing system has to balance?",
  ["Goal alignment, divisional autonomy and fair performance measurement",
   "Tax minimisation, cost recovery and audit compliance",
   "Speed, accuracy and simplicity",
   "Cost, quality and delivery"],
  "Goal alignment, divisional autonomy and fair performance measurement",
  "**Goal alignment**: does the price make managers do what is best for the firm? **Autonomy**: does the system preserve the decision-making authority the firm chose to delegate? **Fair measurement**: does the price distort how well each division appears to perform?\n\nThe professor's point was that no system achieves all three perfectly, which is why this is a design problem rather than a calculation. Mandating a price achieves alignment at the expense of autonomy; free negotiation preserves autonomy and can produce prices that distort measurement.\n\nTax objectives enter only in the international setting.",
  "Three things a good system wants, and it cannot have all three.",
  qtype="case_fact", difficulty=1)

q("madm-a139", "madm_transfer_pricing_basics",
  "What are the three questions that run through every transfer pricing decision?",
  ["Who may source externally and who sets the price; what price produces goal congruence; and whether an internal transfer is better for the firm at all",
   "What the item costs, what it sells for, and what margin is fair",
   "Which division is larger, which is more profitable, and which reports to whom",
   "What the tax rates are, what the arm's-length range is, and what the auditor will accept"],
  "Who may source externally and who sets the price; what price produces goal congruence; and whether an internal transfer is better for the firm at all",
  "**Decision rights**, **goal congruence**, and the **sourcing choice**. They are worth answering in that order, because the first determines whether the price can even affect behaviour.\n\nIf sourcing is mandated internally, the price only shifts reported profit and a cost-based rule is harmless. If sourcing is delegated, the price becomes the buying manager's cost of internal supply and drives a real decision.\n\nThe third question is the corporate one, and it is answered by comparing the seller's minimum with the buyer's maximum.",
  "One question is about authority, one about incentives, and one about what is best for the firm.",
  qtype="case_fact")

q("madm-a140", "madm_transfer_pricing_basics",
  "A division manager complains that the transfer pricing policy makes her division look unprofitable while the other division pads its margins on internal sales. What is the substance of her complaint?",
  ["Performance measurement — the price is distorting how well each division appears to perform, without changing corporate profit",
   "Goal congruence — the price is causing the wrong sourcing decision",
   "Autonomy — she is not being allowed to source externally",
   "Tax — profit is being shifted to a lower-rate jurisdiction"],
  "Performance measurement — the price is distorting how well each division appears to perform, without changing corporate profit",
  "Her complaint is about fairness of measurement, the third of the three objectives. She is not saying the wrong sourcing decision is being made, and she is not asking for the right to buy outside.\n\nThat matters for the response. If the transfer is genuinely value-creating and only the split is disputed, the firm is arguing about distribution — and the remedy is in the measurement or reward system, not in the sourcing rule.\n\nIt becomes a goal congruence problem the moment the price pushes her to source externally when internal supply is cheaper for the firm.",
  "Ask which of the three objectives she is actually saying is being violated.",
  qtype="case_fact", difficulty=3)

q("madm-a141", "madm_transfer_pricing_basics",
  "Two divisions are in different countries with different tax rates. How does that change the transfer pricing problem?",
  ["The price stops being zero-sum for the group, because it moves taxable income between jurisdictions",
   "It has no effect, since consolidation eliminates internal transactions",
   "It removes the goal congruence problem, since tax dominates",
   "It makes cost-based pricing mandatory"],
  "The price stops being zero-sum for the group, because it moves taxable income between jurisdictions",
  "Subsidiaries are taxed where they earn income. Move income from a 21% jurisdiction to a 12.5% one and the group's tax bill falls, so the transfer price now changes group after-tax profit rather than merely splitting it.\n\nThe domestic problem does not go away — the price still drives sourcing decisions and still shapes divisional performance. There are now two objectives pulling on one number, and the tax-optimal price is rarely the goal-congruent one.\n\nWhich is why many groups run two sets of numbers: a tax transfer price that satisfies arm's-length rules, and a management price used for internal evaluation.",
  "Ask whether one division's gain still exactly offsets the other's once tax rates differ.",
  qtype="case_fact")

q("madm-a142", "madm_transfer_pricing_basics",
  "Why does the professor's short-run transfer pricing framework carry a caveat about long-term commitments?",
  ["Over the long run capacity is a choice, so a division will not commit to supply at a price covering only incremental and opportunity cost",
   "Long-term contracts are prohibited between divisions of the same firm",
   "Opportunity cost cannot be estimated more than a year ahead",
   "The framework only applies to manufactured goods"],
  "Over the long run capacity is a choice, so a division will not commit to supply at a price covering only incremental and opportunity cost",
  "With excess capacity the minimum transfer price falls to variable cost, which is the right answer for the next order into capacity that already exists. It is not a price anyone would sign a five-year supply agreement at, because over five years the capacity itself has to be justified and paid for.\n\nThis is the same short-run versus long-run distinction from Session 6, applied to internal transfers: the horizon determines which costs are avoidable and therefore relevant.\n\nIt is also part of why cost-based policies survive in practice despite their distortions — they at least cover capacity.",
  "Ask what becomes avoidable over a long horizon that was fixed in the short run.",
  qtype="case_fact", difficulty=3)

# ===========================================================================
# Session 9 — minimum and maximum transfer price (4)
# ===========================================================================

q("madm-a143", "madm_tp_min_max",
  "A selling division has a variable cost of $62 and excess capacity. The buying division can purchase externally at $75 and would save $4 a unit in inspection by sourcing internally. What is the transfer zone?",
  ["$62 to $79", "$62 to $75", "$66 to $75", "$62 to $71"],
  "$62 to $79",
  "**Floor**: excess capacity means no opportunity cost, so the minimum is the variable cost of **$62**.\n\n**Ceiling**: buying outside costs $75 plus $4 of inspection that internal sourcing avoids, so the all-in external cost is **$79**. The buyer is indifferent there.\n\nZone is **$62 to $79**, and the internal transfer creates $17 a unit of value for the firm.\n\nThe common error is subtracting the saving instead of adding it. Ask which option the $4 belongs to: it is a cost of buying outside, so it raises what the buyer would pay inside.",
  "Adjust the buyer's ceiling by costs that internal sourcing avoids, in the direction that makes internal sourcing more attractive.",
  difficulty=3)

q("madm-a144", "madm_tp_min_max",
  "Why is unitised fixed cost excluded from the minimum transfer price?",
  ["It is sunk with respect to the transfer decision — it does not change whether the unit is transferred or not",
   "It is always allocated to the buying division separately",
   "It is included in the buyer's maximum instead",
   "It is excluded only when the seller has excess capacity"],
  "It is sunk with respect to the transfer decision — it does not change whether the unit is transferred or not",
  "The floor is built from what actually changes: the cash cost of making one more unit, plus the contribution given up if something is displaced. Fixed cost per unit is an arithmetic artefact of dividing a committed total by a budgeted volume, and it changes when volume changes rather than when the transfer decision changes.\n\nIncluding it is precisely how mandated full-cost policies go wrong, and it is why the practice final's $385 example destroys $3 million of value.\n\nThe exclusion holds at full capacity too. At full capacity the floor rises because of the **opportunity** cost, not because the fixed cost suddenly became relevant.",
  "Ask whether the fixed cost changes as a result of the transfer.",
  qtype="case_fact")

q("madm-a145", "madm_tp_min_max",
  "A buying division would incur an extra $12 a unit of rework if it sources internally, because the internal part needs finishing. The external price is $140. What is its maximum transfer price?",
  ["$128", "$140", "$152", "$12"],
  "$128",
  "The ceiling is the external price adjusted for what changes. Internal sourcing **adds** $12 of rework, so the buyer can only afford 140 − 12 = **$128** and still be no worse off.\n\nThe formula is external price plus costs avoided minus costs incurred. Savings raise the ceiling; extra costs lower it.\n\nThe symmetric case on the seller's side is the Tesla modification: extra work to make the transferred unit raises the seller's floor. Extra work to use it lowers the buyer's ceiling. Both narrow the zone.",
  "Extra costs of buying inside come off the ceiling; costs avoided go on it.",
  difficulty=1)

q("madm-a146", "madm_tp_min_max",
  "The seller's minimum transfer price is $210 and the buyer's maximum is $190. What should happen?",
  ["The buyer sources externally — making it inside costs the firm more than buying it",
   "Corporate should mandate a transfer at $200, splitting the difference",
   "The divisions should negotiate until one accepts, since an internal transfer is always preferable",
   "The seller should reduce its price to $190 to keep the volume in-house"],
  "The buyer sources externally — making it inside costs the firm more than buying it",
  "The absence of a zone is the answer, not a problem to be negotiated around. The seller's $210 minimum **is** the true corporate cost of making the unit inside, including the contribution given up; the buyer's $190 maximum **is** the cost of buying it. Making it costs $20 more.\n\nMandating a transfer at $200 would force a decision that destroys $20 a unit, and would look like it worked because both divisions would report plausible numbers.\n\nThe seller cutting to $190 does not change the economics either — it just moves the $20 loss onto the seller's P&L while the firm still bears it.",
  "The two limits are also the two corporate costs. Compare them.",
  qtype="case_fact")

# ===========================================================================
# Session 10 — transfer pricing policy (3)
# ===========================================================================

q("madm-a147", "madm_tp_policy",
  "Why is market-based transfer pricing the theoretically cleanest policy, and what limits its use?",
  ["It is objective and equals the correct answer at full capacity, but it needs a genuinely competitive external market to exist",
   "It is simplest to administer, but it requires the divisions to negotiate",
   "It maximises corporate profit, but only where tax rates are equal",
   "It recovers the seller's fixed costs, but only at full capacity"],
  "It is objective and equals the correct answer at full capacity, but it needs a genuinely competitive external market to exist",
  "At full capacity the seller's opportunity cost is the contribution given up on an external sale, so variable cost plus opportunity cost comes to exactly the market price. Market-based pricing lands on the right answer for free.\n\nThe limitation is availability. Many internal transfers are of custom parts, intermediate goods and services with no external market — the Walker modified circuit, Seth's custom part — and there is no price to reference.\n\nIt is also the wrong answer under excess capacity, where the correct floor drops to variable cost.",
  "Ask when the market price coincides with the correct floor, and when there is no market price at all.",
  qtype="case_fact")

q("madm-a148", "madm_tp_policy",
  "In the survey of practice shown in class, roughly what share of firms use some form of cost-based transfer price?",
  ["About 46%", "About 24%", "About 30%", "About 70%"],
  "About 46%",
  "Variable cost 5%, full cost 24% and cost-plus 17% add to about **46%**. Market price accounts for about 30% and negotiated prices about 24%.\n\nThe interesting part is the gap between theory and practice: cost-based methods distort incentives whenever sourcing is delegated, and they remain the most common approach because they are simple, always available, and defensible to auditors and tax authorities.\n\nThe reconciliation is that many of those firms mandate internal sourcing, which is exactly the condition under which a cost-based price does no damage.",
  "Add the three cost-based variants together before comparing with the alternatives.",
  qtype="case_fact", difficulty=1)

q("madm-a149", "madm_tp_policy",
  "Why not simply have top management resolve each transfer pricing dispute as it arises?",
  ["It undermines decentralisation, consumes executive time, and asks the centre to decide without the local information the divisions hold",
   "It is prohibited by arm's-length pricing rules",
   "It always produces a price outside the transfer zone",
   "Division managers would refuse to accept the ruling"],
  "It undermines decentralisation, consumes executive time, and asks the centre to decide without the local information the divisions hold",
  "Those are the three reasons the professor gave for having a policy at all. Case-by-case intervention re-centralises the decisions the firm deliberately delegated, and it does so using worse information than the divisions have.\n\nIt also sets a precedent. Once escalation works, every future dispute gets escalated, and a manager who expects HQ to rule has less reason to negotiate seriously.\n\nA policy is not better because it produces better prices in any single case. It is better because it removes the need to decide each case at all.",
  "List what the firm gives up each time the centre steps in.",
  qtype="case_fact")

# ===========================================================================
# Session 10 — negotiation and holdup (5)
# ===========================================================================

q("madm-a150", "madm_tp_negotiation",
  "What is the main argument for letting divisions negotiate their own transfer prices?",
  ["It preserves autonomy and uses the local information the divisions hold, which the centre does not",
   "It guarantees the price lands in the middle of the transfer zone",
   "It removes the need to measure divisional profit",
   "It produces the same price as a market-based policy"],
  "It preserves autonomy and uses the local information the divisions hold, which the centre does not",
  "Negotiation is the policy that respects the decentralisation the firm chose. The divisions know their own capacity, alternatives and costs, and a negotiated price uses that knowledge without anyone having to codify it.\n\nThe cost is real: haggling, conflict, and outcomes that depend on relative bargaining power rather than economics. Seth and Brenda is the illustration.\n\nIt guarantees nothing about where inside the zone the price lands, and there is no reason it would coincide with a market price.",
  "Ask what negotiation preserves that a mandated formula destroys.",
  qtype="case_fact", difficulty=1)

q("madm-a151", "madm_tp_negotiation",
  "A selling division makes a large investment specific to one internal customer, on an informal understanding. What is the risk, and what would have prevented it?",
  ["Holdup — the buyer can squeeze once the investment is sunk; a take-or-pay commitment or cost sharing agreed beforehand would have prevented it",
   "Goal incongruence — solved by measuring both divisions on corporate profit",
   "Adverse selection — solved by requiring the seller to disclose its costs",
   "The ratchet effect — solved by resetting the seller's target"],
  "Holdup — the buyer can squeeze once the investment is sunk; a take-or-pay commitment or cost sharing agreed beforehand would have prevented it",
  "**Holdup** = relationship-specific investment + incomplete commitment. Once the money is spent on something with no value outside this relationship, all the bargaining power moves to the counterparty with outside options.\n\nThe remedies are all *ex ante*: a long-term purchase commitment or take-or-pay clause, the buyer co-funding the investment, pre-agreed formula pricing, an arbitration mechanism, or vertical integration.\n\nAfter the fact, nothing works well. Corporate can mandate a price, which resolves this dispute and undermines the structure without preventing the next one.",
  "Name the pattern from its two ingredients, then ask when the remedy has to be in place.",
  qtype="case_fact")

q("madm-a152", "madm_tp_negotiation",
  "Apple and GT Advanced is used as an example of holdup. What made GT vulnerable?",
  ["It built sapphire capacity that had value almost only in the Apple relationship, against a commitment that turned out to be soft",
   "It priced its output below variable cost",
   "It was a division of Apple and could not source externally",
   "It failed to obtain arm's-length pricing approval"],
  "It built sapphire capacity that had value almost only in the Apple relationship, against a commitment that turned out to be soft",
  "GT invested hundreds of millions in capacity dedicated to Apple's requirement. When Apple pulled back, that capacity had little alternative use and GT filed for bankruptcy in 2014.\n\nThe two ingredients are both there: the investment was relationship-specific, and the commitment behind it did not bind. Seth's $240,000 is the same structure at a much smaller scale.\n\nThe example is about contracting risk between separate firms, which is why the remedies are contractual. Inside a firm, vertical integration is already done and the remedy is a mandated internal commitment instead.",
  "Ask what happened to the value of GT's investment when Apple changed its mind.",
  qtype="case_fact", difficulty=1)

q("madm-a153", "madm_tp_negotiation",
  "In the Seth and Brenda case, what is corporate's most important concern?",
  ["That the transfer happens at all, since it creates $45 a unit regardless of where the price lands",
   "That the price is set at exactly the midpoint of $170 and $230",
   "That Seth recovers the $240,000 he spent on design",
   "That Brenda's division does not report a loss on the component"],
  "That the transfer happens at all, since it creates $45 a unit regardless of where the price lands",
  "Corporate profit rises by the same $45 a unit — $900,000 a year — at every transfer price, because the value comes from making the part at a variable cost of $125 rather than buying it at $170.\n\nSo the only outcome corporate should fear is no deal. Where inside the zone the price lands is distribution between two of its own divisions.\n\nThe $240,000 is sunk and cannot be a reason to pay more now, though it is a very good reason to have contracted differently a year ago. And a division reporting a loss on one component is a measurement question, not a value question.",
  "Ask which possible outcomes actually change corporate profit.",
  qtype="case_fact", difficulty=3)

q("madm-a154", "madm_tp_negotiation",
  "What is the strongest argument against corporate intervening in a transfer pricing dispute?",
  ["It sets a precedent that every future dispute gets escalated, and the centre lacks the local information anyway",
   "Intervention is prohibited under arm's-length pricing rules",
   "The centre cannot compute the transfer zone",
   "Divisions would be unable to enforce the ruling"],
  "It sets a precedent that every future dispute gets escalated, and the centre lacks the local information anyway",
  "The precedent effect is what makes a single intervention expensive out of proportion to the case. Once escalation works, managers stop negotiating and start lobbying, and the centre acquires a permanent workload it cannot discharge well.\n\nThe arguments for intervening are real too: it resolves the conflict quickly and makes sure the value-creating transfer happens. The professor presented it as a trade-off rather than a rule, which is how the exam is likely to frame it.\n\nArm's-length rules govern cross-border tax pricing, not internal dispute resolution.",
  "Ask what happens to the next dispute after the centre settles this one.",
  qtype="case_fact")

# ===========================================================================
# Session 10 — international transfer pricing (6)
# ===========================================================================

q("madm-a155", "madm_international_tp",
  "A group manufactures in a 30% tax jurisdiction and sells through a subsidiary in a 10% jurisdiction. Which transfer price policy minimises the group's tax, ignoring regulation?",
  ["A low transfer price on goods sold to the low-tax subsidiary, so more profit is booked there",
   "A high transfer price on goods sold to the low-tax subsidiary, so the manufacturer books the profit",
   "A transfer price equal to full cost plus a uniform markup in both directions",
   "The transfer price has no effect on group tax"],
  "A low transfer price on goods sold to the low-tax subsidiary, so more profit is booked there",
  "Selling into the low-tax jurisdiction cheaply leaves little profit in the 30% country and most of it in the 10% one. The mirror-image lever is buying **from** low-tax affiliates at inflated prices, which loads cost into high-tax countries.\n\nThe worked example: parts in the US at 21% and assembly in Ireland at 12.5%. A transfer price of $60 gives an effective rate of 16.75%; dropping it to $40 gives 12.5%.\n\nThe reason this is not the end of the story is arm's-length pricing rules and, since 2024, the OECD's 15% global minimum tax.",
  "Ask which jurisdiction you want the profit to appear in, and which direction the price has to move to put it there.",
  qtype="case_fact")

q("madm-a156", "madm_international_tp",
  "What does the arm's-length principle require?",
  ["That the transfer price reflect what unrelated parties would have charged each other",
   "That the transfer price equal the selling division's full cost",
   "That profits be split equally between the two jurisdictions",
   "That the group pay at least 15% tax in every country"],
  "That the transfer price reflect what unrelated parties would have charged each other",
  "It is a benchmark against independent behaviour, and it is the main constraint on tax-motivated transfer pricing. Acceptable methods include the comparable uncontrolled price, cost-plus, profit-split, and advance pricing agreements negotiated with the authority before the fact.\n\nIt is required by most jurisdictions — the US, India and the OECD countries among them.\n\nThe 15% figure is OECD Pillar Two's global minimum tax, which is a separate and more recent constraint working through a top-up rather than through the price.",
  "Ask what standard the price is being compared against.",
  qtype="case_fact", difficulty=1)

q("madm-a157", "madm_international_tp",
  "A group makes a part in Country A at a cost of 50, assembles in Country B at a cost of 30, and sells for 200. Tax is 25% in A and 15% in B. What is the total tax at a transfer price of 90?",
  ["22.0", "30.0", "18.0", "24.0"],
  "22.0",
  "Split the profit at the stated transfer price and tax each half at its own rate.\n\n- Country A: revenue 90 less cost 50 = 40 of income, taxed at 25% = **10.0**\n- Country B: revenue 200 less the 90 transfer price and 30 of assembly = 80 of income, taxed at 15% = **12.0**\n\nTotal tax = **22.0**, an effective rate of 22.0 / 120 = 18.3% on the group's 120 of profit.\n\nThe 30.0 distractor taxes all the profit in Country A; the 18.0 taxes it all in Country B. Those are the two extremes a transfer price can move the answer between, and the effective rate always lands somewhere in between, weighted by where the income is booked.",
  "Compute income in each jurisdiction at the given transfer price, tax each at its own rate, and add.",
  difficulty=3)

q("madm-a158", "madm_international_tp",
  "Why are intangibles the focus of most international transfer pricing disputes?",
  ["Intellectual property can be relocated with a signature and rarely has a comparable market price to benchmark against",
   "Intangibles are taxed at a higher rate than physical goods",
   "Arm's-length rules do not apply to intangibles",
   "Royalty payments are not deductible in most jurisdictions"],
  "Intellectual property can be relocated with a signature and rarely has a comparable market price to benchmark against",
  "A factory cannot be moved to a tax haven. A patent portfolio, a brand or an algorithm can be transferred to a subsidiary there, after which royalties flow from the operating country — which takes the deduction — to the haven, which books the income.\n\nAnd because there is rarely a comparable transaction between unrelated parties for a unique intangible, the arm's-length benchmark has little to anchor on. That is what makes these disputes long and expensive.\n\nApple's Irish structures, Google's Bermuda arrangement, Starbucks' Dutch royalties, Amazon's Luxembourg operations, and the IRS cases against Coca-Cola and Medtronic are all versions of the same argument.",
  "Ask what makes an intangible easier to relocate than a factory, and harder to price.",
  qtype="case_fact")

q("madm-a159", "madm_international_tp",
  "What was the outcome of the European Commission's case against Apple's Irish arrangements?",
  ["Ireland was found to have granted illegal state aid and Apple was ordered to pay about €13 billion, upheld in 2024",
   "Apple was cleared and the case was dropped in 2020",
   "Ireland was fined and Apple's tax bill was unchanged",
   "The case was settled with an advance pricing agreement"],
  "Ireland was found to have granted illegal state aid and Apple was ordered to pay about €13 billion, upheld in 2024",
  "The 2016 ruling found that the arrangements amounted to illegal state aid, with about **€13 billion** of back taxes ordered. The Court of Justice upheld it in 2024.\n\nThe structure at issue was the Double Irish: two Irish entities with different tax residencies, so non-US profits flowed to entities with minimal taxable presence. Effective rates on some Irish profits reached 0.005%. Ireland closed the arrangement to new structures in 2015.\n\nThe broader regulatory response was the OECD's BEPS programme, of which Pillar Two's global minimum tax is the most consequential piece.",
  "The case ran from 2016 to 2024. What was the finding and what was the amount?",
  qtype="case_fact", difficulty=1)

q("madm-a160", "madm_international_tp",
  "Which groups does OECD Pillar Two's global minimum tax apply to, and from when?",
  ["Groups with revenue above €750 million, from 2024",
   "All multinational groups, from 2016",
   "Groups with revenue above €100 million, from 2020",
   "Only groups with subsidiaries in listed tax havens, from 2024"],
  "Groups with revenue above €750 million, from 2024",
  "The threshold is **€750 million** of revenue and the rules took effect in **2024**. Where a subsidiary's effective rate falls below 15%, the parent's jurisdiction imposes a top-up tax to bring it up.\n\nThe design point is that it works through a top-up rather than by restating the transfer price. The price can stay where it is; the tax advantage is collected somewhere else.\n\nThat caps the gain from profit shifting without ending transfer pricing disputes, which turn on arm's-length benchmarks for intangibles rather than on headline rates.",
  "One number is a revenue threshold in euros and one is a year.",
  qtype="case_fact", difficulty=1)


# ---------------------------------------------------------------------------
# Emit
# ---------------------------------------------------------------------------

def main() -> int:
    problems: list = []
    seen_ids: set = set()
    rows: list = []

    for item in QUESTIONS:
        qid = item["id"]
        shuffled = shuffle_choices(qid, item["choices"], item["correct_answer"])
        check_question(qid, dict(item, choices=shuffled), problems, seen_ids)
        check_inline_math(f"{qid} prompt", item["prompt"], problems)
        check_inline_math(f"{qid} explanation", item["explanation"], problems)
        check_markdown(f"{qid} explanation", item["explanation"], problems)
        rows.append(dict(item, choices=shuffled))

    by_topic: dict = {}
    for r in rows:
        by_topic[r["topic"]] = by_topic.get(r["topic"], 0) + 1
    for topic, want in sorted(EXPECTED.items()):
        got = by_topic.get(topic, 0)
        if got != want:
            problems.append(f"topic {topic}: {got} new questions, expected {want}")
    for topic in sorted(set(by_topic) - set(EXPECTED)):
        problems.append(f"topic {topic}: not in the expected-count table")

    if problems:
        print("\n".join(f"-- PROBLEM: {p}" for p in problems), file=sys.stderr)
        print(f"\n{len(problems)} problem(s); nothing written.", file=sys.stderr)
        return 1

    out: list = []
    w = out.append
    w("-- MADM2 practice-bank expansion: every topic reaches 8 questions.")
    w("--")
    w("-- GENERATED FILE. Edit supabase/madm-practice-bank.py and re-emit, never this file.")
    w("--")
    w("-- Counts assume the MADM end-term content migration has been applied: it carries the 82")
    w("-- questions that come from the professor's own material, and the concepts and scenarios")
    w("-- these rows depend on. madm_input_variances and madm_tp_capacity already reach 8 from his")
    w("-- material alone and gain nothing here.")
    w("--")
    w("-- Everything below is provenance 'authored', so it stays separable from anything he wrote.")
    w("")
    w("begin;")
    w("")
    w(f"-- learn_questions: {len(rows)} new rows")
    for r in rows:
        w("insert into public.learn_questions")
        w("  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,")
        w("   explanation, hint, difficulty, provenance) values")
        w(f"  ({sql(r['id'])}, {sql(COURSE)}, {sql(r['type'])}, {sql(r['topic'])}, {r['session']},")
        w(f"   {sql(r['prompt'])},")
        w(f"   {json_array(r['choices'])}, {sql(r['correct_answer'])}, {sql(r['source'])},")
        w(f"   {sql(r['explanation'])}, {sql(r['hint'])}, {r['difficulty']}, {sql(r['provenance'])})")
        w("on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,")
        w("  correct_answer = excluded.correct_answer, explanation = excluded.explanation,")
        w("  hint = excluded.hint, topic = excluded.topic, session = excluded.session,")
        w("  difficulty = excluded.difficulty, provenance = excluded.provenance;")
        w("")
    w("commit;")
    w("")

    sys.stdout.write("\n".join(out))
    print(f"-- generated: {len(rows)} questions across {len(by_topic)} topics", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
