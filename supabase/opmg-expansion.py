"""Source of truth for the OPMG practice-bank expansion.

    python3 supabase/opmg-expansion.py > supabase/migrations/<timestamp>_opmg_expansion.sql

Brings every OPMG topic to 8 questions, counting what is already in the database plus the twelve
from the professor's additional set (supabase/opmg-additional-set.py, which must be applied first
since eoq_cycle_inventory and quality_process_capability reach 8 only with its rows).

Also fixes a live gap: `hypothesis_testing_clt` exists in learn_concepts with **zero** questions.
groupBySession() in src/learn/lib/sessions.ts builds its topic list from questions, so the concept
was in the database and unreachable in the app. Eight questions make it appear.

Numbers are computed here rather than transcribed. Queue-wait questions deliberately stay on
structure (pooling, utilisation, the square-root effects) rather than asking for a wait time from
the approximation formula -- the exact variant differs between texts, and a plausible-looking wrong
number is worse than no question.
"""

import math
import sys

from practice_lib import check_inline_math, check_markdown, check_question, json_array, shuffle_choices, sql

COURSE = "OPMG"

QUESTIONS: list = []


def q(qid, topic, session, prompt, choices, correct, expl, hint=None, qtype="formula", difficulty=2,
      provenance="authored", source=None):
    QUESTIONS.append({
        "id": qid, "topic": topic, "session": session, "type": qtype, "difficulty": difficulty,
        "prompt": prompt, "choices": choices, "correct_answer": correct, "explanation": expl,
        "hint": hint, "provenance": provenance, "source": source,
    })


# ===========================================================================
# Session 1 -- Little's Law (2)
# ===========================================================================

q("opm-n01", "littles_law", 1,
  "A hospital ward admits 12 patients per day and each stays an average of 4.5 days. How many beds must be occupied on average?",
  ["54 beds", "16.5 beds", "2.7 beds", "48 beds"],
  "54 beds",
  "I = R x T = 12 x 4.5 = **54 beds**.\n\nThe ward needs at least 54 occupied beds on average simply to sustain that admission rate at that length of stay. Cutting average stay to 4 days would free 6 beds without admitting one fewer patient — which is why length of stay is the lever hospitals actually pull.",
  "Inventory is the rate multiplied by the time each unit spends inside, not the two divided.")

q("opm-n02", "littles_law", 1,
  "A café wants average time in the system down from 12 minutes to 9 while still serving 40 customers per hour. What happens to the average number of customers inside?",
  ["Falls from 8 to 6", "Falls from 8 to 7.5", "Rises from 6 to 8", "Stays at 8, since throughput is unchanged"],
  "Falls from 8 to 6",
  "Convert the time to hours: 12 minutes = 0.2 h, 9 minutes = 0.15 h.\n\n- Before: I = 40 x 0.2 = **8 customers**\n- After: I = 40 x 0.15 = **6 customers**\n\nThroughput is held constant, so the whole reduction in flow time shows up as fewer people waiting inside. The crowd in the shop is a symptom of flow time, not of demand.",
  "Hold R fixed and put T in the same time units as R before multiplying.")

# ===========================================================================
# Session 1 -- process view (6)
# ===========================================================================

q("opm-n03", "process_view", 1,
  "A hospital wants to analyse its emergency department. Which choice of flow unit makes the analysis coherent?",
  ["A patient, tracked from arrival to discharge",
   "A doctor, tracked across a shift",
   "A bed, tracked across a month",
   "A treatment protocol, tracked across revisions"],
  "A patient, tracked from arrival to discharge",
  "The flow unit is the thing that **moves through** the process and whose journey you are trying to improve. Patients arrive, are processed and leave.\n\nDoctors and beds are **resources** — they stay put while flow units pass through them. Confusing the two inverts every subsequent calculation: capacity is a property of resources, flow time a property of flow units.",
  "Ask which item enters at one end and leaves at the other, and which stays behind to serve the next one.",
  qtype="case_fact")

q("opm-n04", "process_view", 1,
  "In the process view, what are the three quantities that describe any process, and how are they linked?",
  ["Flow rate, inventory and flow time, linked by I = R x T",
   "Capacity, utilisation and demand, linked by utilisation = demand / capacity",
   "Cost, quality and speed, linked by trade-off curves",
   "Setup, run time and batch size, linked by the batching formula"],
  "Flow rate, inventory and flow time, linked by I = R x T",
  "Those three are the vocabulary of the whole course, and Little's Law ties them together so tightly that fixing any two determines the third.\n\nThe other options are all real relationships, but each describes one aspect of a process rather than the process itself. Utilisation, for instance, needs capacity and flow rate — both defined in terms of the first triple.",
  "Look for the set that describes what is inside the process, how fast it moves, and how long it takes.",
  qtype="case_fact")

q("opm-n05", "process_view", 1,
  "A bank calls its branch queue a \"buffer\" and its tellers \"resources\". A new analyst labels the queue a resource because it holds customers. Why is that wrong?",
  ["A buffer holds flow units waiting; a resource performs work on them",
   "A buffer is a physical space while a resource is a person",
   "A buffer has no capacity while a resource does",
   "A buffer is measured in time while a resource is measured in units"],
  "A buffer holds flow units waiting; a resource performs work on them",
  "The distinction is about **doing work**. A teller transforms a waiting customer into a served one; the queue merely stores them until a teller is free.\n\nIt matters because buffers add flow time without adding capacity. Enlarging the waiting area lets more people wait — it does not let more people be served, which is the mistake the labelling error leads to.",
  "Ask which one changes the state of a flow unit and which only holds it.",
  qtype="case_fact")

q("opm-n06", "process_view", 1,
  "A pizza chain measures \"time from order placed to pizza handed over\". A second team measures \"time the oven is busy\". What is each measuring?",
  ["The first is flow time for the flow unit; the second is utilisation of a resource",
   "Both are flow time, measured at different points",
   "The first is capacity; the second is flow time",
   "The first is utilisation; the second is throughput"],
  "The first is flow time for the flow unit; the second is utilisation of a resource",
  "Flow time follows the **order** through the whole process. Oven busy-time describes how hard one **resource** is working.\n\nThe two move independently, which is why they get confused: an oven can be busy 95% of the time while orders still take an hour, because the delay is sitting in queues rather than in the oven.",
  "One measurement follows the thing being made; the other watches a machine.",
  qtype="case_fact")

q("opm-n07", "process_view", 1,
  "Why does the process view insist you define the process boundary before measuring anything?",
  ["Flow time and inventory both change depending on where you decide the process starts and ends",
   "Regulators require a documented scope for process audits",
   "Capacity cannot be computed without knowing the number of resources",
   "The boundary determines which employees are accountable"],
  "Flow time and inventory both change depending on where you decide the process starts and ends",
  "Measure a delivery process from the kitchen and you get one flow time; measure it from the moment the customer taps *order* and you get a much longer one, because the queue before the kitchen is now inside the boundary.\n\nNeither is wrong, but they are not comparable — which is why two teams can argue about performance while both are right about different processes.",
  "Imagine moving the start line earlier and ask which measured quantities change.",
  qtype="case_fact")

q("opm-n08", "process_view", 1,
  "A process has an average inventory of 300 units and a flow rate of 60 units per hour. What is the average flow time?",
  ["5 hours", "18,000 hours", "0.2 hours", "12 minutes"],
  "5 hours",
  "Rearranging Little's Law: T = I / R = 300 / 60 = **5 hours**.\n\nAny two of the three quantities give you the third, which is what makes the law so useful — inventory and flow rate are usually the easy ones to observe, and flow time is the one customers actually experience.",
  "Divide inventory by the rate; the units of the answer should come out as time.")

# ===========================================================================
# Session 1 -- strategy / process alignment (6)
# ===========================================================================

q("opm-n09", "strategy_process_alignment", 1,
  "A luxury tailor promises bespoke fitting and unlimited alterations. Which process design fits that strategy?",
  ["High flexibility and skilled labour, accepting lower utilisation and higher cost per unit",
   "High-volume standardised production with tightly balanced stations",
   "Maximum automation to drive unit cost as low as possible",
   "Large batch sizes to spread setup costs across more garments"],
  "High flexibility and skilled labour, accepting lower utilisation and higher cost per unit",
  "The strategy sells variety and responsiveness, so the process has to be able to do something different for each customer. That means general-purpose capacity and skilled people, and it means giving up the efficiency a standardised line would deliver.\n\nThe alignment point: a process optimised for cost cannot deliver a promise built on customisation, and there is no configuration that does both well.",
  "Ask what the customer is being promised, then what a process must sacrifice to keep that promise.",
  qtype="case_fact")

q("opm-n10", "strategy_process_alignment", 1,
  "A retailer's stated strategy is everyday low prices, but its stores carry wide assortments, high staffing and frequent promotions. What is the diagnosis?",
  ["Operations are misaligned with strategy, and the cost base cannot support the price promise",
   "The strategy is sound and the operations simply need better execution",
   "The retailer is pursuing a differentiation strategy in practice, which is equally valid",
   "Assortment breadth has no bearing on the cost base"],
  "Operations are misaligned with strategy, and the cost base cannot support the price promise",
  "Wide assortment, heavy staffing and frequent promotions all add cost — and everyday low prices require the opposite. The operations are quietly funding a service level the pricing cannot pay for.\n\nMisalignment of this kind rarely shows up as a single broken process. It shows up as persistent margin pressure that no individual department appears responsible for.",
  "Add up what the operating choices cost, and ask whether the pricing promise can carry it.",
  qtype="case_fact")

q("opm-n11", "strategy_process_alignment", 1,
  "What does it mean to say a firm must choose which operational dimension to compete on?",
  ["Cost, quality, speed, flexibility and reliability trade off, so a process cannot lead on all of them",
   "A firm should pick one dimension and ignore the rest entirely",
   "Competing on cost automatically produces the best quality over time",
   "The choice is a marketing decision with no operational consequences"],
  "Cost, quality, speed, flexibility and reliability trade off, so a process cannot lead on all of them",
  "Choosing does not mean abandoning the others — it means deciding which one the process is **designed around** when they conflict, and holding the rest at a level that is good enough.\n\nA firm claiming to lead on every dimension has usually not made the choice, which shows up later as a process that is mediocre at all of them.",
  "The claim is about what happens when two of the dimensions pull against each other.",
  qtype="case_fact")

q("opm-n12", "strategy_process_alignment", 1,
  "An airline competing on lowest fare is deciding between one aircraft type and a mixed fleet. Which supports the strategy, and why?",
  ["One type — common training, spares and maintenance drive unit cost down",
   "A mixed fleet — matching aircraft size to each route maximises load factor",
   "A mixed fleet — it reduces dependence on a single manufacturer",
   "Either, since fleet composition does not affect operating cost"],
  "One type — common training, spares and maintenance drive unit cost down",
  "A single type means one set of pilot qualifications, one spares inventory and one maintenance skill base. Every one of those is a standing cost that a mixed fleet multiplies.\n\nThe alternatives name real benefits — better route matching, less supplier risk — but both buy flexibility with cost, which is the wrong trade for this strategy.",
  "Trace each option through to the standing costs it creates or removes.",
  qtype="case_fact")

q("opm-n13", "strategy_process_alignment", 1,
  "A hospital wants to cut emergency waiting times and simultaneously raise the utilisation of its scanners to near 100%. Why do these goals conflict?",
  ["A resource run near full utilisation develops long queues once demand varies at all",
   "Scanner utilisation is unrelated to emergency waiting times",
   "Higher utilisation always reduces waiting because more patients are processed",
   "Emergency patients do not use scanners"],
  "A resource run near full utilisation develops long queues once demand varies at all",
  "Waiting time climbs steeply as utilisation approaches 100%, and it climbs faster the more variable arrivals are. Emergency demand is about as variable as it gets.\n\nSo the spare capacity that looks like waste on a utilisation report is exactly what is buying the short waits. Chasing both targets at once means pursuing two ends of the same trade-off.",
  "Think about what happens to a queue when a highly variable arrival stream meets a resource with no slack.",
  difficulty=3, qtype="case_fact")

q("opm-n14", "strategy_process_alignment", 1,
  "In the strategy-to-process chain, what is the correct order of reasoning?",
  ["Competitive strategy sets operational priorities, which set process design choices",
   "Process design sets operational priorities, which set competitive strategy",
   "Operational priorities set competitive strategy, which sets process design",
   "All three are decided independently by different functions"],
  "Competitive strategy sets operational priorities, which set process design choices",
  "The direction runs from the customer promise inward: decide what you are competing on, translate that into which operational dimensions matter most, then design the process to deliver them.\n\nRunning it backwards is how firms end up with a strategy that describes what their existing process happens to be good at, rather than what the market rewards.",
  "Start from the promise made to the customer and work inward.",
  qtype="case_fact")

# ===========================================================================
# Session 2 -- process / financial link (3)
# ===========================================================================

q("opm-n15", "process_financial_link", 2,
  "A rental business holds 4,000 units of inventory at a cost of Rs 2,000 each, with an annual holding charge of 25% of value. It cuts average flow time by 20% at unchanged throughput. What does it save annually?",
  ["Rs 400,000", "Rs 2,000,000", "Rs 1,600,000", "Rs 500,000"],
  "Rs 400,000",
  "At constant throughput, Little's Law makes inventory fall in proportion to flow time: 4,000 x 0.20 = **800 units** released.\n\nSaving = 800 x 2,000 x 0.25 = **Rs 400,000** per year.\n\nThis is the link the session is built on — a flow-time improvement is not a soft operational win, it converts directly into freed capital and a lower holding charge.",
  "Convert the flow-time reduction into units of inventory first, then price those units at the holding rate.",
  difficulty=3)

q("opm-n16", "process_financial_link", 2,
  "Two firms have identical revenue and margin. One turns its inventory 12 times a year, the other 4. What does this imply?",
  ["The first ties up a third of the capital to support the same sales, so its return on capital is higher",
   "The first has three times the revenue of the second",
   "The second has lower holding costs because it orders less often",
   "Inventory turns have no effect on return on capital"],
  "The first ties up a third of the capital to support the same sales, so its return on capital is higher",
  "Turns are cost of goods sold divided by average inventory, so four turns means three times the inventory of twelve turns at the same sales.\n\nSame profit on a third of the capital is a materially better business, which is why operational flow measures end up on the finance dashboard rather than staying inside operations.",
  "Same sales, different inventory — ask what that does to the capital employed.",
  qtype="case_fact")

q("opm-n17", "process_financial_link", 2,
  "A process improvement cuts flow time but throughput and prices are unchanged. Where does the benefit appear in the accounts?",
  ["Lower working capital and holding costs, rather than higher revenue",
   "Higher revenue, since faster service attracts more customers",
   "Higher gross margin per unit, since each unit costs less to make",
   "Nowhere measurable, since flow time is an operational metric only"],
  "Lower working capital and holding costs, rather than higher revenue",
  "With throughput fixed by assumption, the improvement cannot show up as extra sales. What it does is shrink the inventory needed to sustain those sales, which releases capital and cuts the charge for carrying it.\n\nFaster service may well win more customers in reality — but that is a separate effect, and claiming both from one improvement double-counts it.",
  "Read the constraint in the question carefully before deciding which line moves.",
  qtype="case_fact")

# ===========================================================================
# Session 3 -- batching (6)
# ===========================================================================

def batch_capacity(setup, unit_time, batch):
    """Units per unit time for a resource with a per-batch setup."""
    return batch / (setup + batch * unit_time)


assert abs(batch_capacity(30, 1, 30) - 0.5) < 1e-9

q("opm-n18", "batching_capacity", 3,
  "A machine needs a 30-minute setup per batch and 1 minute per unit. What is its capacity in units per hour at a batch size of 30?",
  ["30 units/hour", "60 units/hour", "20 units/hour", "45 units/hour"],
  "30 units/hour",
  "Time per batch = 30 setup + 30 x 1 run = **60 minutes** for 30 units.\n\nCapacity = 30 units / 1 hour = **30 units per hour**.\n\nHalf the machine's time is going into setup, which is exactly what larger batches are meant to dilute.",
  "Work out the total time for one whole batch, setup included, then divide the batch into it.")

q("opm-n19", "batching_capacity", 3,
  "The same machine (30-minute setup, 1 minute per unit) moves to a batch size of 90. What is the new capacity?",
  ["45 units/hour", "90 units/hour", "60 units/hour", "30 units/hour"],
  "45 units/hour",
  "Time per batch = 30 + 90 = **120 minutes** for 90 units, so capacity = 90 / 2 = **45 units per hour**.\n\nTripling the batch raised capacity by half, not threefold. Setup is being spread over more units, but the run time per unit never goes away — which is why capacity approaches a ceiling of 60 per hour and never reaches it.",
  "Recompute the whole batch time; the gain is bounded by the run time per unit.")

q("opm-n20", "batching_capacity", 3,
  "As batch size grows without limit on a machine with setup time S and unit time p, what does capacity approach?",
  ["1/p, the capacity with no setup at all", "Zero, as setup dominates", "S/p", "It grows without bound"],
  "1/p, the capacity with no setup at all",
  "Capacity is B / (S + Bp). Divide through by B and it becomes 1 / (S/B + p), and S/B goes to zero as B grows.\n\nSo the ceiling is **1/p** — the capacity you would have if setups were free. Batching can recover the time lost to setup, but it can never make the machine faster than its own run rate.",
  "Divide numerator and denominator by the batch size and see which term vanishes.",
  difficulty=3)

q("opm-n21", "batching_capacity", 3,
  "Larger batches raise capacity at a station with setups. What do they cost?",
  ["Longer flow time, because a unit waits for its whole batch to be processed",
   "Higher setup cost per batch, since bigger batches take longer to set up",
   "Lower capacity at every other station in the process",
   "Nothing — larger batches are strictly better"],
  "Longer flow time, because a unit waits for its whole batch to be processed",
  "A unit finished early sits waiting until the rest of its batch is done and the batch moves on. Bigger batch, longer wait — and more inventory sitting in the process.\n\nThat is the trade the topic is named for: batch size buys capacity with flow time. Which one you should favour depends on whether the station is the bottleneck.",
  "Follow a single unit through a large batch and ask when it actually leaves the station.",
  qtype="case_fact")

q("opm-n22", "batching_capacity", 3,
  "A station with setups is not the bottleneck and has spare capacity. What batch size policy makes sense?",
  ["Smaller batches, trading away capacity it does not need for shorter flow time",
   "Larger batches, to build up as much capacity headroom as possible",
   "The same batch size as the bottleneck, to keep the line balanced",
   "The largest batch the machine can physically hold"],
  "Smaller batches, trading away capacity it does not need for shorter flow time",
  "Capacity at a non-bottleneck is worth nothing — the process cannot go faster than its bottleneck no matter how much headroom sits elsewhere. Flow time, on the other hand, is worth something everywhere.\n\nSo spend the spare capacity on smaller batches. This is the reasoning behind reducing setup times generally: cheaper setups make small batches affordable, which is where lean starts.",
  "Ask what extra capacity at a non-bottleneck is actually worth to the process.",
  difficulty=3, qtype="case_fact")

q("opm-n23", "batching_capacity", 3,
  "A station has a 40-minute setup and 2 minutes per unit. What batch size is needed for a capacity of 20 units per hour?",
  ["40 units", "20 units", "60 units", "30 units"],
  "40 units",
  "Require B / (40 + 2B) = 20/60 units per minute = 1/3.\n\nSo 3B = 40 + 2B, giving B = **40 units**.\n\nCheck: 40 + 80 = 120 minutes for 40 units, which is 20 per hour. Note the ceiling of 1/p = 30 per hour — any target above that is unreachable at any batch size.",
  "Set the capacity expression equal to the target in consistent units and solve for the batch size.",
  difficulty=3)

# ===========================================================================
# Session 3 -- bottleneck (1)
# ===========================================================================

q("opm-n24", "process_capacity_bottleneck", 3,
  "A three-station line runs at 20, 12 and 15 units per hour. Management doubles station 1 to 40 per hour. What is the new process capacity?",
  ["12 units/hour, unchanged — station 2 is still the bottleneck",
   "24 units/hour, since the first station doubled",
   "40 units/hour, set by the fastest station",
   "22.3 units/hour, the average of the three"],
  "12 units/hour, unchanged — station 2 is still the bottleneck",
  "Process capacity is the **minimum** across stations, so it is set by station 2 at 12 per hour both before and after.\n\nThe investment bought nothing. All it did was let station 1 build inventory in front of station 2 faster. Improving a non-bottleneck is the most common way to spend money on a process without changing its output.",
  "The slowest station sets the pace — check whether the change touched it.")

# ===========================================================================
# Session 3 -- subscription dynamics (6)
# ===========================================================================

q("opm-n25", "subscription_model_dynamics", 3,
  "What does it mean to say a subscription model decouples revenue from cost?",
  ["Revenue arrives per period regardless of usage, while cost is driven by how much each member uses",
   "Revenue and cost both scale with the number of subscribers",
   "Costs are fixed while revenue varies with usage",
   "Subscription revenue is recognised only once usage occurs"],
  "Revenue arrives per period regardless of usage, while cost is driven by how much each member uses",
  "A subscriber pays the same monthly fee whether they use the service once or twenty times, but each use consumes real capacity.\n\nThat asymmetry is the whole model: it is highly profitable on light users and can be loss-making on heavy ones, which makes the **distribution** of usage more important than the average.",
  "Ask what happens to revenue and to cost when one member doubles their usage.",
  qtype="case_fact")

q("opm-n26", "subscription_model_dynamics", 3,
  "A rental subscription charges Rs 3,000 a month. Each rental costs Rs 400 in cleaning and logistics. At what usage does a member stop being profitable, ignoring other costs?",
  ["Above 7.5 rentals a month", "Above 12 rentals a month", "Above 4 rentals a month", "Above 30 rentals a month"],
  "Above 7.5 rentals a month",
  "3,000 / 400 = **7.5 rentals**. Past that the variable cost of serving the member exceeds what they pay.\n\nThis threshold is why usage caps, fair-use policies and tiered plans exist. Without one, the members who love the product most are the ones losing the most money.",
  "Divide the fixed monthly fee by the variable cost of a single use.")

q("opm-n27", "subscription_model_dynamics", 3,
  "Why can rising engagement be bad news for a subscription operator, when it is good news for most businesses?",
  ["Each additional use consumes capacity without producing additional revenue",
   "Engaged members are more likely to cancel",
   "Engagement raises the price the operator must charge competitors",
   "Higher engagement always signals a quality problem"],
  "Each additional use consumes capacity without producing additional revenue",
  "In a transactional business more usage means more sales. Under a subscription it means more cost against a fee that has already been collected.\n\nSo the operator has to watch engagement as a **cost driver** as well as a health metric — the same dashboard number means two opposite things depending on the revenue model underneath it.",
  "Trace one extra use through both the revenue line and the cost line.",
  qtype="case_fact")

q("opm-n28", "subscription_model_dynamics", 3,
  "A subscription service finds 20% of members generate 60% of usage. What does that concentration imply operationally?",
  ["Capacity must be sized for the heavy tail, not for the average member",
   "The average usage figure is sufficient for capacity planning",
   "The heavy users should be prioritised for further engagement campaigns",
   "Pricing should be lowered to attract more light users to balance the mix"],
  "Capacity must be sized for the heavy tail, not for the average member",
  "Planning on the mean understates peak load whenever usage is concentrated, and the concentration is what drives both capacity requirements and cost.\n\nAttracting more light users does improve the economics, but it does not fix the capacity question — the heavy users still show up. Sizing and pricing are separate responses to the same distribution.",
  "Ask whether an average describes a population where a fifth of it does most of the work.",
  difficulty=3, qtype="case_fact")

q("opm-n29", "subscription_model_dynamics", 3,
  "How does a subscription change the operator's incentive around flow time, compared with pay-per-use?",
  ["Faster turnaround serves the same member again sooner without new revenue, so it must be justified by retention",
   "Flow time becomes irrelevant once revenue is fixed",
   "Faster turnaround always increases revenue in the same period",
   "Flow time matters only for the operator's cost of capital"],
  "Faster turnaround serves the same member again sooner without new revenue, so it must be justified by retention",
  "Under pay-per-use, cutting flow time lets you sell more. Under a subscription it lets the same member consume more of what they have already paid for.\n\nThe business case therefore shifts from revenue to **retention** — faster service is worth paying for because it keeps members subscribed, not because it raises this month's bill. A weaker and slower argument, but a real one.",
  "Ask who benefits from the extra cycles the improvement creates, and whether they pay for them.",
  difficulty=3, qtype="case_fact")

q("opm-n30", "subscription_model_dynamics", 3,
  "An FMCG manufacturer cannot decouple revenue from cost the way a subscription business can. Why not?",
  ["Revenue arrives only when a unit is sold, so each unit's cost is tied to its own sale",
   "FMCG firms have no fixed costs to spread",
   "FMCG margins are too thin to support a subscription",
   "FMCG demand is too variable to forecast"],
  "Revenue arrives only when a unit is sold, so each unit's cost is tied to its own sale",
  "In a transactional model the revenue and the cost of goods travel together on every unit — sell twice as much and both roughly double.\n\nSubscription breaks that pairing by collecting revenue on a calendar and incurring cost on usage. It is the timing mismatch, not the margin level, that creates the different operational problem.",
  "Ask what event triggers revenue in each model, and what event triggers cost.",
  qtype="case_fact")

# ===========================================================================
# Session 3 -- theoretical flow time (6)
# ===========================================================================

q("opm-n31", "theoretical_flow_time", 3,
  "A process has paths A-B-D (4 + 6 + 3 minutes) and A-C-D (4 + 10 + 3 minutes), where B and C run in parallel after A. What is the theoretical flow time?",
  ["17 minutes", "13 minutes", "26 minutes", "30 minutes"],
  "17 minutes",
  "Parallel paths mean the process waits for the **longer** one, so take the critical path: A-C-D = 4 + 10 + 3 = **17 minutes**.\n\n13 minutes is the shorter path, which finishes early and then waits. 26 adds both paths, which would only be right if B and C ran one after the other.",
  "With parallel activities, the process is held up by the slowest path, not the sum of all of them.")

q("opm-n32", "theoretical_flow_time", 3,
  "What does theoretical flow time deliberately exclude?",
  ["All waiting time — it counts only value-adding activity",
   "Setup time at each resource",
   "The time taken by the critical path",
   "Rework and inspection activities"],
  "All waiting time — it counts only value-adding activity",
  "Theoretical flow time is the time a unit would take if it never queued: pure work content along the critical path.\n\nThat makes it a benchmark rather than a prediction. Comparing it with actual flow time gives the flow time efficiency, and the gap between them is the improvement opportunity.",
  "The word theoretical is doing the work — what would have to be true for a unit to achieve it?",
  qtype="case_fact")

q("opm-n33", "theoretical_flow_time", 3,
  "A clinic's theoretical flow time is 25 minutes and patients actually average 100 minutes. What is the flow time efficiency, and what does it say?",
  ["25% — three-quarters of a patient's visit is spent waiting",
   "400% — patients take four times longer than theoretically possible",
   "75% — a quarter of the visit is waiting",
   "25% — a quarter of the visit is waiting"],
  "25% — three-quarters of a patient's visit is spent waiting",
  "Flow time efficiency = theoretical / actual = 25 / 100 = **25%**.\n\nSo 75 of every 100 minutes add nothing for the patient. That is the number to attack, and it usually falls to queueing and handoffs rather than to slow clinicians — which is why hiring faster staff often fails to shift it.",
  "Put the theoretical time over the actual one, then interpret the remainder.")

q("opm-n34", "theoretical_flow_time", 3,
  "An improvement team shortens an activity that sits on a non-critical path. What happens to theoretical flow time?",
  ["Nothing, until that path becomes the critical one",
   "It falls by the amount the activity was shortened",
   "It rises, because the paths become less balanced",
   "It falls by half the amount, since two paths share the process"],
  "Nothing, until that path becomes the critical one",
  "The critical path sets the theoretical flow time, and shortening something with slack just adds more slack.\n\nThe same logic as the bottleneck: improving the part that was not constraining the system changes nothing measurable. Worth checking which path is critical *before* choosing what to improve.",
  "Ask whether the activity was holding anything up in the first place.",
  qtype="case_fact")

q("opm-n35", "theoretical_flow_time", 3,
  "A process runs A (5 min), then B (8 min) and C (6 min) in parallel, then D (4 min). B is cut from 8 to 5 minutes. What is the new theoretical flow time?",
  ["15 minutes", "14 minutes", "17 minutes", "12 minutes"],
  "15 minutes",
  "Originally the critical path ran through B: 5 + 8 + 4 = 17 minutes.\n\nCutting B to 5 makes C the longer parallel branch at 6, so the new critical path is 5 + 6 + 4 = **15 minutes**.\n\nThe activity was cut by 3 minutes but the process only gained 2, because the critical path switched to C partway through the improvement. Improvements stop paying once the constraint moves.",
  "Recompute both paths after the change — the critical one may not be the same branch.",
  difficulty=3)

q("opm-n36", "theoretical_flow_time", 3,
  "Why can two processes with identical theoretical flow times have very different actual flow times?",
  ["Actual flow time depends on utilisation and variability, which theoretical flow time ignores",
   "Theoretical flow time is measured per batch and actual flow time per unit",
   "One process must have miscounted its critical path",
   "Actual flow time includes setup while theoretical flow time does not"],
  "Actual flow time depends on utilisation and variability, which theoretical flow time ignores",
  "Theoretical flow time is pure work content. Actual flow time adds every queue, and queues are driven by how heavily loaded the resources are and how variable the arrivals and service times are.\n\nRun the same work content at 95% utilisation instead of 60% and the actual flow time can multiply while the theoretical figure does not move at all.",
  "The difference between the two numbers is waiting — ask what determines how much waiting there is.",
  qtype="case_fact")

# ===========================================================================
# Session 4 -- variability and queuing (4)
# ===========================================================================

q("opm-n37", "variability_queuing_basics", 4,
  "A single server handles 9 jobs per hour and demand is 6 jobs per hour. What is utilisation, and what happens to the queue if demand rises to 8.5?",
  ["66.7%, and the queue lengthens sharply as utilisation reaches 94.4%",
   "66.7%, and the queue lengthens proportionally to 94.4%",
   "150%, and the system is already unstable",
   "66.7%, and the queue is unaffected while capacity still exceeds demand"],
  "66.7%, and the queue lengthens sharply as utilisation reaches 94.4%",
  "Utilisation = R / Rp = 6 / 9 = **66.7%**, rising to 8.5 / 9 = **94.4%**.\n\nWaiting time does not rise in proportion to utilisation — it rises with roughly 1/(1 − utilisation), so going from 66.7% to 94.4% multiplies the queue many times over even though capacity still exceeds demand.\n\nThat non-linearity is why systems feel fine until suddenly they do not.",
  "Utilisation is a simple ratio, but the waiting it produces is anything but linear.")

q("opm-n38", "variability_queuing_basics", 4,
  "A process has ample capacity — utilisation is only 60% — yet customers still queue. How is that possible?",
  ["Arrivals and service times vary, so demand and capacity are mismatched moment to moment",
   "Utilisation must have been measured incorrectly",
   "Queues cannot form below 100% utilisation",
   "The process must have a hidden bottleneck at 100% utilisation"],
  "Arrivals and service times vary, so demand and capacity are mismatched moment to moment",
  "Average capacity exceeding average demand says nothing about any particular minute. Customers arrive in clusters and some take much longer than others, so the server is idle at times and overwhelmed at others.\n\nRemove all variability and a 60%-utilised system would have no queue at all. Waiting is created by randomness, not by a shortage of average capacity.",
  "Averages balancing does not mean they balance at every moment.",
  qtype="case_fact")

q("opm-n39", "variability_queuing_basics", 4,
  "A bank reduces the variability of service times without changing the average or adding staff. What happens?",
  ["Average waiting time falls, because waiting scales with variability",
   "Nothing, since average capacity and demand are unchanged",
   "Average waiting rises, because consistent service is slower",
   "Utilisation falls, because less time is wasted"],
  "Average waiting time falls, because waiting scales with variability",
  "Waiting time is proportional to the variability term, so cutting the spread of service times cuts the queue even with utilisation held exactly where it was.\n\nThis is the cheapest lever in queueing: standardising how work is done costs far less than adding servers, and it attacks the same waiting time. Much of lean is this insight applied repeatedly.",
  "Waiting depends on three things — utilisation, service time, and how variable the process is.",
  qtype="case_fact")

q("opm-n40", "variability_queuing_basics", 4,
  "Arrivals average 10 per hour with a standard deviation of 10 minutes between arrivals; the mean interarrival time is 6 minutes. What is the coefficient of variation of arrivals?",
  ["1.67", "0.6", "10", "1.0"],
  "1.67",
  "CV = standard deviation / mean = 10 / 6 = **1.67**.\n\nA CV above 1 means arrivals are more variable than a Poisson process, which has CV = 1. That matters because the waiting-time formula carries the CVs directly — highly variable arrivals produce long queues even at modest utilisation.",
  "The coefficient of variation is a ratio, so both quantities must be in the same units.")

# ===========================================================================
# Session 5 -- scale and pooling (5)
# ===========================================================================

q("opm-n41", "queuing_scale_pooling", 5,
  "Two call centres each run one agent at 80% utilisation with their own queue. They merge into one queue served by both agents. What happens?",
  ["Average wait falls sharply, even though utilisation and total capacity are unchanged",
   "Average wait is unchanged, since capacity and demand are the same",
   "Average wait rises, because the single queue is twice as long",
   "Utilisation falls to 40% because two agents now share the load"],
  "Average wait falls sharply, even though utilisation and total capacity are unchanged",
  "Pooling removes the situation where one agent sits idle while a customer waits in the other queue. Every agent can serve any waiting customer, so capacity is never stranded.\n\nNothing was added — same agents, same demand, same utilisation. The gain comes purely from removing the barrier between the two queues, which is why pooling is the highest-return change in most service systems.",
  "Picture one agent idle while someone waits in the other line, and ask whether pooling allows that.",
  qtype="case_fact")

q("opm-n42", "queuing_scale_pooling", 5,
  "A pooled system with many servers is split into separate dedicated lines at the same total capacity and utilisation. What is the effect?",
  ["Waiting time rises, because capacity can now be idle while customers wait elsewhere",
   "Waiting time falls, because each line is shorter",
   "Waiting time is unchanged, since total capacity is the same",
   "Waiting time rises only if utilisation exceeds 90%"],
  "Waiting time rises, because capacity can now be idle while customers wait elsewhere",
  "Splitting is pooling in reverse and it costs exactly what pooling gains. Each dedicated line has to absorb its own variability with no help from the others.\n\nThere can be good reasons to split — specialisation, different skill requirements, priority classes — but they have to be worth the waiting time the split creates.",
  "Ask what becomes possible after the split that was impossible before.",
  qtype="case_fact")

q("opm-n43", "queuing_scale_pooling", 5,
  "Why does doubling the size of a pooled service system reduce waiting more than proportionally, at constant utilisation?",
  ["Relative variability falls as the number of servers grows, so less slack is needed for the same wait",
   "Larger systems have lower utilisation by definition",
   "Larger systems can process customers in batches",
   "Waiting time is inversely proportional to the number of servers"],
  "Relative variability falls as the number of servers grows, so less slack is needed for the same wait",
  "With more servers handling a proportionally larger arrival stream, the fluctuations average out against each other. The system is more predictable relative to its size, so the same utilisation produces a shorter queue.\n\nThis is economies of scale expressed in waiting rather than in cost, and it is why a large hospital can safely run at a utilisation that would cripple a small clinic.",
  "Think about how a bigger pool of independent demand behaves relative to its own size.",
  difficulty=3, qtype="case_fact")

q("opm-n44", "queuing_scale_pooling", 5,
  "When is pooling a poor idea despite its queueing benefits?",
  ["When the work genuinely requires specialised skills that not every server has",
   "When utilisation is below 70%",
   "When the servers are located in the same building",
   "When customers arrive in a predictable pattern"],
  "When the work genuinely requires specialised skills that not every server has",
  "Pooling only works if any server can take any customer. Where that is untrue — a specialist surgeon, a language requirement, a licensed role — a pooled queue either sends work to someone who cannot do it or quietly re-forms into separate queues.\n\nThe usual remedy is cross-training, which buys back the flexibility pooling needs, at the cost of the training itself.",
  "Ask what pooling assumes about the interchangeability of servers.",
  qtype="case_fact")

q("opm-n45", "queuing_scale_pooling", 5,
  "A hospital cross-trains its nurses so any nurse can handle any patient type. What does this achieve in queueing terms?",
  ["It converts several dedicated queues into one pooled system without hiring anyone",
   "It reduces the average service time per patient",
   "It lowers utilisation by spreading work more evenly",
   "It eliminates variability in patient arrivals"],
  "It converts several dedicated queues into one pooled system without hiring anyone",
  "Cross-training is what makes pooling possible when the work is not naturally interchangeable. The staffing level and the service times do not change; what changes is that no nurse is now stuck unable to help a waiting patient.\n\nIt neither speeds up service nor reduces variability — it stops variability in one stream from being absorbed by only one server.",
  "Cross-training changes who *can* serve whom, not how fast or how variable the service is.",
  qtype="case_fact")

# ===========================================================================
# Session 6 -- lean (5)
# ===========================================================================

q("opm-n46", "lean_fundamentals", 6,
  "In lean terms, what distinguishes value-adding activity from the rest?",
  ["The customer would be willing to pay for it, and it changes the product toward what they want",
   "It is performed by a skilled worker rather than a machine",
   "It takes place at the bottleneck resource",
   "It is required by regulation or company policy"],
  "The customer would be willing to pay for it, and it changes the product toward what they want",
  "The test is deliberately from the customer's side. Inspection, moving material and storing work in progress all cost money and none of them change the product into something the customer wants more.\n\nSome non-value-adding work is unavoidable — safety checks, regulatory steps — but calling it what it is keeps it under pressure rather than letting it become invisible.",
  "Ask whether a customer, seeing the activity, would agree to pay for it.",
  qtype="case_fact")

q("opm-n47", "lean_fundamentals", 6,
  "Why does lean treat inventory as a waste in its own right, rather than as a neutral asset?",
  ["It consumes capital and hides the problems that made it necessary",
   "It always spoils or becomes obsolete before use",
   "It increases the capacity of downstream stations",
   "It is taxed more heavily than other assets"],
  "It consumes capital and hides the problems that made it necessary",
  "Buffer stock lets a process keep running through breakdowns, long setups and quality failures — which means those problems never have to be fixed.\n\nThe capital cost is the visible half. The concealment is the half lean cares about: lowering inventory deliberately exposes the problems, which is the point rather than a side effect.",
  "Ask what inventory lets a process get away with.",
  qtype="case_fact")

q("opm-n48", "lean_fundamentals", 6,
  "What is the operational argument for reducing setup times, in lean thinking?",
  ["Cheaper setups make small batches affordable, which cuts flow time and inventory",
   "Shorter setups directly raise the capacity of every station in the process",
   "Setup reduction removes the need for quality inspection",
   "Shorter setups allow larger batches to be run more often"],
  "Cheaper setups make small batches affordable, which cuts flow time and inventory",
  "Large batches exist mainly to spread the cost of an expensive setup. Make setups cheap and that reason disappears, which unlocks small batches — and small batches mean shorter flow times, less work in progress and faster detection of defects.\n\nThe capacity gain at the station is real but secondary. The batch size it permits is the point.",
  "Ask why large batches existed in the first place, then what removing that reason allows.",
  difficulty=3, qtype="case_fact")

q("opm-n49", "lean_fundamentals", 6,
  "A pull system differs from a push system in what respect?",
  ["Work is released only when a downstream station signals it is ready",
   "Work is released according to a forecast made at the start of the period",
   "Work moves in larger batches to reduce handling",
   "Work is scheduled centrally to maximise utilisation at every station"],
  "Work is released only when a downstream station signals it is ready",
  "Push releases work on a schedule regardless of what is happening downstream, which piles inventory in front of any station that falls behind. Pull ties every release to actual downstream readiness, so work in progress is capped by construction.\n\nThe trade is that a pull system will deliberately let an upstream resource sit idle rather than build inventory nobody has asked for — which looks like waste on a utilisation report and is not.",
  "Ask what triggers the release of the next unit of work in each system.",
  qtype="case_fact")

q("opm-n50", "lean_fundamentals", 6,
  "Lean argues for low inventory, yet Toyota's semiconductor buffer let it keep producing through the chip shortage. How do these fit together?",
  ["Buffers are justified where supply risk is high and lead times are long — lean removes waste, not judgement",
   "Toyota abandoned lean during the shortage",
   "The buffer was an error that happened to have a good outcome",
   "Lean applies only to internal processes, never to purchased components"],
  "Buffers are justified where supply risk is high and lead times are long — lean removes waste, not judgement",
  "Lean targets inventory that exists to conceal fixable problems — long setups, unreliable equipment, poor quality. A chip shortage caused by a global supply shock is none of those, and no amount of internal improvement removes it.\n\nSo the buffer is a deliberate hedge against a risk outside the firm's control, which is a different thing from work in progress accumulating because a machine keeps breaking.",
  "Ask which kind of problem the inventory is covering for, and whether the firm could fix it.",
  difficulty=3, qtype="case_fact")

# ===========================================================================
# Session 6 -- priority queuing (5)
# ===========================================================================

q("opm-n51", "priority_queuing", 6,
  "A clinic introduces a priority class for urgent patients without adding capacity. What happens to average waiting time across all patients?",
  ["It stays roughly the same — priority redistributes waiting rather than removing it",
   "It falls, because urgent patients are handled more efficiently",
   "It rises sharply, because switching between classes wastes time",
   "It falls by exactly the share of patients classified as urgent"],
  "It stays roughly the same — priority redistributes waiting rather than removing it",
  "No capacity was added and no variability was removed, so the total waiting in the system is essentially unchanged. Urgent patients wait less and everyone else waits more.\n\nThat is not a criticism — moving waiting to where it costs least is exactly the point. But it must be argued as a redistribution, not sold as an efficiency gain.",
  "Ask whether the change touched capacity or variability at all.",
  qtype="case_fact")

q("opm-n52", "priority_queuing", 6,
  "Under what condition does prioritisation create genuine value rather than merely moving waiting around?",
  ["When the cost of waiting differs across classes, so the same delay does less harm to some",
   "When all customers value their time equally",
   "When utilisation is below 50%",
   "When the priority class is the largest group of customers"],
  "When the cost of waiting differs across classes, so the same delay does less harm to some",
  "If everyone's waiting cost were identical, shuffling the order would achieve nothing in total. The gain comes entirely from the differences — a delayed emergency patient loses far more than a delayed routine check-up.\n\nSo the case for priority rests on the *spread* of waiting costs, which is also why an unjustified priority scheme is worse than none.",
  "Total waiting is fixed, so any gain has to come from who does the waiting.",
  difficulty=3, qtype="case_fact")

q("opm-n53", "priority_queuing", 6,
  "Serving the shortest jobs first, rather than in arrival order, has what effect on average waiting time?",
  ["It reduces it, because short jobs stop queueing behind long ones",
   "It increases it, because long jobs are delayed",
   "It leaves it unchanged, since the same work is done either way",
   "It reduces it only when utilisation exceeds 90%"],
  "It reduces it, because short jobs stop queueing behind long ones",
  "A long job at the front makes everyone behind it wait its full duration. Putting short jobs first means many customers each wait a little instead of a few waiting a lot, which lowers the average.\n\nThe cost is fairness: long jobs can be pushed back repeatedly if short ones keep arriving. This is the one scheduling rule that genuinely improves the average rather than redistributing it.",
  "Count how many customers are held up behind a long job versus a short one.",
  difficulty=3, qtype="case_fact")

q("opm-n54", "priority_queuing", 6,
  "An airport gives landing aircraft priority over departing ones on shared runways. What is the operational justification?",
  ["A circling aircraft burns fuel and carries safety risk, so its waiting is far more costly",
   "Landings take less runway time than departures",
   "It raises total runway throughput",
   "Departing aircraft have more flexible schedules by regulation"],
  "A circling aircraft burns fuel and carries safety risk, so its waiting is far more costly",
  "The runway does the same amount of work either way, so throughput is unchanged. What differs is the cost of delay: a plane waiting on the ground burns comparatively little and is safe, while one holding in the air is doing neither.\n\nA clean application of the rule that priority pays when waiting costs differ sharply between classes.",
  "Compare what a delay costs on the ground with what it costs in the air.",
  qtype="case_fact")

q("opm-n55", "priority_queuing", 6,
  "A firm introduces a paid fast-track lane. What must it watch operationally?",
  ["Standard-lane waiting rises, and beyond some point those customers leave",
   "Fast-track customers will begin to arrive less frequently",
   "Total capacity falls once the lanes are separated",
   "Utilisation rises above 100% in the fast lane"],
  "Standard-lane waiting rises, and beyond some point those customers leave",
  "Priority moves waiting onto the standard lane, and that lane has a tolerance. Push past it and the firm loses those customers — along with the volume that made the operation viable.\n\nThere is also a pooling cost if the lanes get dedicated servers: capacity can sit idle in one lane while the other queues. The revenue from fast-track has to cover both effects.",
  "Follow the waiting that priority moves, and ask what the customers receiving it will do.",
  qtype="case_fact")

# ===========================================================================
# Session 8 -- six sigma (5)
# ===========================================================================

q("opm-n56", "six_sigma_dmaic", 8,
  "What are the five phases of DMAIC, in order?",
  ["Define, Measure, Analyse, Improve, Control",
   "Design, Model, Analyse, Implement, Check",
   "Define, Model, Adjust, Inspect, Confirm",
   "Detect, Measure, Act, Improve, Close"],
  "Define, Measure, Analyse, Improve, Control",
  "**Define** the problem, **Measure** the current process, **Analyse** for root causes, **Improve** by changing something, **Control** so the gain holds.\n\nThe last phase is the one teams skip, and it is why improvements decay. Without a control mechanism the process drifts back to where it started within months.",
  "Two of the phases happen before anyone is allowed to change anything.",
  qtype="case_fact")

q("opm-n57", "six_sigma_dmaic", 8,
  "A process is described as six sigma capable. What does that mean, and what does it not mean?",
  ["Specification limits sit six standard deviations from the mean — not that defects are impossible",
   "The process produces exactly six defects per million, by definition",
   "The process has been improved six times",
   "The process operates with six control charts"],
  "Specification limits sit six standard deviations from the mean — not that defects are impossible",
  "Sigma capability measures how much room there is between the process spread and the customer's limits. At six sigma the process can drift substantially and still produce almost nothing outside specification.\n\nThe idea is **robustness**, not perfection. A six sigma process still fails occasionally; what it does is stop failing every time something shifts slightly.",
  "The number describes a distance measured in standard deviations, not a count of defects.",
  qtype="case_fact")

q("opm-n58", "six_sigma_dmaic", 8,
  "A process has specification limits at 90 and 110 with a mean of 100 and standard deviation 5. What is its sigma capability, and what happens if the standard deviation halves?",
  ["2.0, rising to 4.0", "2.0, rising to 2.5", "4.0, rising to 8.0", "2.0, unchanged"],
  "2.0, rising to 4.0",
  "Sigma capability = min[(110 − 100)/5, (100 − 90)/5] = **2.0**.\n\nHalve the standard deviation to 2.5 and it becomes 10 / 2.5 = **4.0** — capability doubles.\n\nCapability is inversely proportional to the standard deviation, so halving variation always doubles it. That relationship is what makes variation reduction the central lever in six sigma.",
  "Capability is a distance divided by the standard deviation, so halving the denominator does the obvious thing.")

q("opm-n59", "six_sigma_dmaic", 8,
  "Why does six sigma target variation reduction rather than simply re-centring the process mean?",
  ["Centring helps only once, while lower variation protects against drift the firm cannot prevent",
   "Process means cannot be adjusted in practice",
   "Variation reduction is always cheaper than re-centring",
   "Re-centring changes the specification limits"],
  "Centring helps only once, while lower variation protects against drift the firm cannot prevent",
  "Re-centring is worth doing when a process is off-target, but it is a one-off correction — and real processes drift as tools wear, materials vary and conditions change.\n\nA process with low variation absorbs that drift without producing defects. That standing tolerance is what capability buys, and it is why the effort goes into narrowing the distribution rather than repositioning it.",
  "Ask what protects the process the *next* time something shifts.",
  difficulty=3, qtype="case_fact")

q("opm-n60", "six_sigma_dmaic", 8,
  "A team completes an improvement and moves on without a control plan. What does DMAIC predict?",
  ["The process drifts back, because nothing detects and corrects the return of the old behaviour",
   "The improvement is permanent once the root cause is removed",
   "The process improves further as staff become practised",
   "Capability falls immediately to its original level"],
  "The process drifts back, because nothing detects and corrects the return of the old behaviour",
  "Control exists precisely because improvements are not self-sustaining. Staff turn over, workarounds creep back, equipment wears — and with nothing watching, the process returns to its old state gradually enough that nobody notices.\n\nThe control phase is usually a chart and a defined response: what signal counts as out of control, and who does what when it appears.",
  "Ask what would notice if the old behaviour came back.",
  qtype="case_fact")

# ===========================================================================
# Session 8 -- SPC (1)
# ===========================================================================

q("opm-n61", "spc_control_charts", 8,
  "A process has mean 200 and standard deviation 12, sampled in groups of 9. What are the 3-sigma x-bar control limits?",
  ["188 to 212", "164 to 236", "196 to 204", "197.3 to 202.7"],
  "188 to 212",
  "The chart tracks sample means, so use the standard error: 12 / sqrt(9) = **4**.\n\nLimits = 200 ± 3 x 4 = **188 to 212**.\n\n164 to 236 uses the raw standard deviation of 12 and would flag almost nothing; 196 to 204 divides by 9 instead of by 3, which is the sqrt(n) error in the other direction.",
  "Divide the standard deviation by the square root of the sample size, not by the sample size.")

# ===========================================================================
# Session 8 -- hypothesis testing and the CLT (8) -- previously unreachable
# ===========================================================================

SE_EX = 7.73 / math.sqrt(100)
Z_EX = (19.2 - 21.39) / SE_EX
assert abs(SE_EX - 0.773) < 1e-9 and abs(Z_EX + 2.83) < 0.01

q("opm-n62", "hypothesis_testing_clt", 8,
  "Delivery times average 21.39 minutes with a standard deviation of 7.73. A pilot of 100 deliveries returns a sample mean of 19.2. What is the standard error, and what is the z-score?",
  ["SE = 0.773, z = −2.83", "SE = 7.73, z = −0.28", "SE = 0.773, z = −28.3", "SE = 0.0773, z = −28.3"],
  "SE = 0.773, z = −2.83",
  "SE = sigma / sqrt(n) = 7.73 / 10 = **0.773**.\n\nz = (19.2 − 21.39) / 0.773 = **−2.83**.\n\nDividing by sigma rather than by the standard error gives −0.28 and turns a decisive result into an inconclusive one. With n = 100 that error understates the z-score tenfold, which is the most expensive slip on this topic.",
  "A sample mean is a draw from the sampling distribution, which is narrower than the process by sqrt(n).")

q("opm-n63", "hypothesis_testing_clt", 8,
  "What does the Central Limit Theorem claim about sample means?",
  ["They are normally distributed whatever the shape of the underlying distribution, with spread sigma/sqrt(n)",
   "They follow the same distribution as the underlying data, with the same spread",
   "They are normally distributed only when the underlying data is normal",
   "They have the same spread as the population but a different mean"],
  "They are normally distributed whatever the shape of the underlying distribution, with spread sigma/sqrt(n)",
  "Both halves matter. Delivery times are heavily skewed, yet averages of delivery times are not — which is why the normal distribution shows up throughout process control even when nothing being measured is normal.\n\nThe second half, the sqrt(n) narrowing, is what makes averages informative: individual observations scatter enormously while their averages barely move.",
  "The theorem says something about the *shape* and something about the *spread*.",
  qtype="case_fact")

q("opm-n64", "hypothesis_testing_clt", 8,
  "A team wants to halve the standard error of its estimate. How much more data does it need?",
  ["Four times as much", "Twice as much", "Half as much again", "Ten times as much"],
  "Four times as much",
  "Standard error is sigma / sqrt(n), so halving it means doubling sqrt(n), which means **quadrupling n**.\n\nPrecision gets expensive quickly, and this is the arithmetic behind that. Going from 100 to 200 observations buys only a 29% reduction in standard error, not 50%.",
  "The square root is what makes this costly — work backwards from what has to double.")

q("opm-n65", "hypothesis_testing_clt", 8,
  "What exactly does a hypothesis test ask?",
  ["If the null hypothesis were true, how surprising would this data be?",
   "What is the probability that the null hypothesis is true?",
   "Does the new process perform better than the old one?",
   "What is the probability the new process is an improvement?"],
  "If the null hypothesis were true, how surprising would this data be?",
  "The test conditions **on** the null and asks about the data, never the reverse. You are not proving the new thing is true — you are asking whether the old story can still explain what you just saw.\n\nThat framing explains the asymmetry students find strange: failing to reject the null does not mean nothing changed, only that there was not enough evidence to say otherwise.",
  "Notice which of the two — the hypothesis or the data — the probability is actually about.",
  qtype="case_fact")

q("opm-n66", "hypothesis_testing_clt", 8,
  "In the delivery pilot, a one-sided test gives p = 0.0023. What would a two-sided test give, and when is one-sided appropriate?",
  ["0.0046 — one-sided is right when only one direction counts as success",
   "0.00115 — one-sided is right when the sample is large",
   "0.0023 — the p-value does not depend on the choice",
   "0.046 — one-sided is right when the standard deviation is known"],
  "0.0046 — one-sided is right when only one direction counts as success",
  "Two-sided doubles the tail probability: 2 x 0.0023 = **0.0046**.\n\nOne-sided is appropriate here because a delivery process getting *slower* is not evidence the change worked — only one direction counts. Choosing the wrong one changes the answer, and it is a common slip.",
  "Ask whether a result in the opposite direction would be interesting or merely bad news.")

q("opm-n67", "hypothesis_testing_clt", 8,
  "Is p = 0.05 a universal threshold for acting on a result?",
  ["No — the right threshold depends on what being wrong costs in each direction",
   "Yes, it is the standard across all fields",
   "Yes, below 0.05 a result is proven",
   "No, because 0.01 is the correct threshold for operational decisions"],
  "No — the right threshold depends on what being wrong costs in each direction",
  "0.05 is a convention, not a law. The delivery result at 0.0023 is comfortably enough to act on for food delivery; a vaccine would demand far more evidence before anyone shipped it.\n\nThe question to ask is always the cost of each error: shipping a change that does nothing, against discarding one that would have helped.",
  "The threshold is a business decision about consequences, not a statistical constant.",
  qtype="case_fact")

q("opm-n68", "hypothesis_testing_clt", 8,
  "A test fails to reject the null hypothesis. What can be concluded?",
  ["Not enough evidence was gathered to say the process changed — not that it is unchanged",
   "The process is unchanged",
   "The null hypothesis has been proven true",
   "The sample size was necessarily too small"],
  "Not enough evidence was gathered to say the process changed — not that it is unchanged",
  "Absence of evidence is not evidence of absence. A real improvement can easily go undetected if the sample is small or the effect is modest relative to the process variation.\n\nThe practical response is to ask what effect size the test could have detected. A test that would have missed anything smaller than a 20% improvement has not told you much by failing.",
  "The test can only reject or fail to reject — ask what the second outcome rules out.",
  qtype="case_fact")

q("opm-n69", "hypothesis_testing_clt", 8,
  "Why is the CLT the reason control charts work even when the underlying measurements are skewed?",
  ["Charts plot sample means, which are normal regardless of the shape of the raw data",
   "Control charts do not assume any distribution",
   "Skewed data becomes normal once specification limits are applied",
   "Charts plot individual measurements, which are assumed normal"],
  "Charts plot sample means, which are normal regardless of the shape of the raw data",
  "Three-sigma limits rely on a normal distribution to make the roughly 99.7% claim meaningful. Raw delivery times, waiting times and defect counts are rarely normal.\n\nBecause the chart plots **averages** of n units, the CLT supplies the normality the limits assume. This is also why the limits use sigma/sqrt(n) rather than sigma — the quantity being plotted is the sample mean.",
  "Ask what quantity is actually plotted on an x-bar chart, and which distribution applies to it.",
  difficulty=3, qtype="case_fact")

# ===========================================================================
# Session 9 -- newsvendor (2)
# ===========================================================================

q("opm-n70", "newsvendor_model", 9,
  "A stall buys pastries at Rs 30 and sells them at Rs 80, with unsold stock worthless at the end of the day. What is the optimal service level?",
  ["62.5%", "37.5%", "50%", "72.7%"],
  "62.5%",
  "- Cu = 80 − 30 = **Rs 50** (margin lost on a pastry it could have sold)\n- Co = 30 − 0 = **Rs 30** (full cost of one left over)\n\nSL* = 50 / (50 + 30) = **62.5%**.\n\n37.5% is Co/(Cu+Co), the ratio inverted — which would have the stall deliberately running short more often than not.",
  "Understocking cost goes on top of the fraction; salvage of zero makes Co the whole purchase cost.")

q("opm-n71", "newsvendor_model", 9,
  "A newsvendor's supplier offers to buy back unsold units at half their cost. What happens to the optimal order quantity?",
  ["It rises, because the cost of overstocking has fallen",
   "It falls, because the supplier now shares the risk",
   "It is unchanged, since demand has not changed",
   "It rises only if the selling price also rises"],
  "It rises, because the cost of overstocking has fallen",
  "The buy-back raises salvage value, which cuts Co. A smaller Co raises SL* = Cu/(Cu+Co), and a higher service level means ordering more.\n\nThis is why buy-back terms exist at all: they push the retailer toward stocking the quantity the supplier would prefer, by making leftovers cheaper to hold.",
  "Work out which of the two cost terms the buy-back changes, and which direction that pushes the ratio.",
  difficulty=3)

# ===========================================================================
# Session 10 -- safety stock and reorder point (6)
# ===========================================================================

q("opm-n72", "safety_stock_reorder_point", 10,
  "Weekly demand averages 200 units with a standard deviation of 40. Lead time is 4 weeks. What is the standard deviation of lead-time demand?",
  ["80 units", "160 units", "40 units", "20 units"],
  "80 units",
  "Variances add over the lead time, not standard deviations: sigma x sqrt(L) = 40 x sqrt(4) = **80 units**.\n\n160 units comes from sigma x L, which is the standard error of this topic — it treats uncertainty as though it accumulated linearly with time, and it overstates the safety stock badly.",
  "Uncertainty grows with the square root of the lead time, never in proportion to it.")

q("opm-n73", "safety_stock_reorder_point", 10,
  "Using the same figures (mean 200/week, sigma 40, lead time 4 weeks), what reorder point gives a 95% service level (z = 1.645)?",
  ["932 units", "800 units", "866 units", "1,120 units"],
  "932 units",
  "- Expected lead-time demand = 200 x 4 = **800 units**\n- Safety stock = z x sigma x sqrt(L) = 1.645 x 80 = **132 units**\n\nROP = 800 + 132 = **932 units**.\n\n800 is the deterministic reorder point with no protection against variability at all, which would leave the firm out of stock roughly half the time.",
  "Reorder point is expected demand over the lead time plus the safety stock, not one or the other.")

q("opm-n74", "safety_stock_reorder_point", 10,
  "A firm raises its target service level from 95% (z = 1.645) to 99% (z = 2.326), everything else unchanged. By what percentage does safety stock rise?",
  ["About 41%", "About 4%", "About 100%", "About 21%"],
  "About 41%",
  "Safety stock is proportional to z, so the ratio is 2.326 / 1.645 = **1.41**, a rise of about **41%**.\n\nFour percentage points of service level cost 41% more safety stock, and the last stretch toward 100% costs far more again — z rises without limit as the service level approaches certainty. This is why nobody targets 100%.",
  "Safety stock scales with z, so compare the two z-values directly.")

q("opm-n75", "safety_stock_reorder_point", 10,
  "A supplier cuts lead time from 9 weeks to 4 with no change in demand variability. What happens to safety stock at the same service level?",
  ["It falls by a third, since it scales with the square root of lead time",
   "It falls by more than half, in proportion to the lead time",
   "It is unchanged, since demand variability is what drives it",
   "It falls by a ninth"],
  "It falls by a third, since it scales with the square root of lead time",
  "Safety stock is z x sigma x sqrt(L), so the ratio is sqrt(4)/sqrt(9) = 2/3 — a **one-third reduction**.\n\nThe lead time more than halved but safety stock fell by only a third, because the square root damps the effect. Real, but consistently smaller than people expect when they negotiate lead times.",
  "Take the ratio of the square roots, not the ratio of the lead times.",
  difficulty=3)

q("opm-n76", "safety_stock_reorder_point", 10,
  "What is safety stock actually protecting against?",
  ["Demand and lead time turning out higher than expected during the replenishment window",
   "The average level of demand over the year",
   "The fixed cost of placing an order",
   "Variation in the purchase price of the item"],
  "Demand and lead time turning out higher than expected during the replenishment window",
  "Average demand over the lead time is covered by the cycle stock in the reorder point. Safety stock covers only the **uncertainty** — the possibility that this particular replenishment window runs hotter than average.\n\nWhich is why it depends on sigma and the service level, and not at all on the average demand rate itself.",
  "Split the reorder point into its two parts and ask what each one is for.",
  qtype="case_fact")

q("opm-n77", "safety_stock_reorder_point", 10,
  "A retailer consolidates 4 regional warehouses into 1, with identical independent demand streams and the same service level. What happens to total safety stock?",
  ["It halves, falling by a factor of sqrt(4)",
   "It falls to a quarter, in proportion to the number of warehouses",
   "It is unchanged, since total demand is the same",
   "It doubles, because one location must cover all regions"],
  "It halves, falling by a factor of sqrt(4)",
  "Four separate warehouses each carry z x sigma x sqrt(L), for 4 x that in total. Pooled, demand variance adds, so the combined sigma is sigma x sqrt(4) and safety stock is z x sigma x sqrt(4) x sqrt(L).\n\nThe ratio is 4 / sqrt(4) = **2**, so total safety stock halves. The same square-root aggregation effect as pooling in queueing — consolidation reduces the buffer needed by sqrt(n), not by n.",
  "Compare the sum of four separate buffers with one buffer built on the pooled variance.",
  difficulty=3)


# ===========================================================================
# Emit
# ===========================================================================

# What each topic must gain to reach 8, given what is already live plus the professor's set.
EXPECTED = {
    "littles_law": 2, "process_view": 6, "strategy_process_alignment": 6,
    "process_financial_link": 3, "batching_capacity": 6, "process_capacity_bottleneck": 1,
    "subscription_model_dynamics": 6, "theoretical_flow_time": 6,
    "variability_queuing_basics": 4, "queuing_scale_pooling": 5, "lean_fundamentals": 5,
    "priority_queuing": 5, "six_sigma_dmaic": 5, "spc_control_charts": 1,
    "hypothesis_testing_clt": 8, "newsvendor_model": 2, "safety_stock_reorder_point": 6,
}


def main() -> int:
    problems: list = []
    seen: set = set()
    rows = []

    for item in QUESTIONS:
        qid = item["id"]
        shuffled = shuffle_choices(qid, item["choices"], item["correct_answer"])
        checked = dict(item, choices=shuffled)
        check_question(qid, checked, problems, seen)
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
    w("-- OPMG practice-bank expansion: every topic reaches 8 questions.")
    w("--")
    w("-- GENERATED -- edit supabase/opmg-expansion.py and re-emit, never this file.")
    w("--")
    w("-- Counts assume 20260815200000_opmg_additional_set.sql has been applied: eoq_cycle_inventory")
    w("-- and quality_process_capability reach 8 from the professor's set alone and gain nothing here.")
    w("--")
    w("-- hypothesis_testing_clt gets its first 8 questions. The concept was already in the database")
    w("-- but groupBySession() builds its topic list from questions, so it was unreachable in the app.")
    w("")
    w("begin;")
    w("")
    w(f"-- learn_questions: {len(rows)} new rows")
    for r in rows:
        src = r["source"] or f"Session {r['session']}"
        w("insert into public.learn_questions")
        w("  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,")
        w("   explanation, hint, difficulty, provenance) values")
        w(f"  ({sql(r['id'])}, {sql(COURSE)}, {sql(r['type'])}, {sql(r['topic'])}, {r['session']},")
        w(f"   {sql(r['prompt'])},")
        w(f"   {json_array(r['choices'])}, {sql(r['correct_answer'])}, {sql(src)},")
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
