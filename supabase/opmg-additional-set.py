"""Source of truth for the professor's OPMG "Additional Practice Set" migration.

    python3 supabase/opmg-additional-set.py > supabase/migrations/<timestamp>_opmg_additional_set.sql

Three multi-part cases the professor circulated for end-term revision, with his own worked
solutions. This is the first content in the course to use learn_scenarios: each case is one setup
with four questions hanging off it, served as an unbroken chain by chainFor() in
src/learn/lib/adaptive.ts.

Every number below is computed, not transcribed. The professor's stated answer is asserted against
the computation, so a typo on either side stops the generator rather than reaching a student.

Two deliberate departures from the PDF, both recorded in `provenance`:

- **Choice order.** The professor's answer is option B in 11 of the 12 questions. Choices render in
  stored order (QuestionCard.tsx does not shuffle), so storing them A-D verbatim would let a student
  pattern-match instead of solving. shuffle_choices() spreads the answer deterministically. The
  option *text* is untouched, and no option refers to its own letter, so nothing breaks.
- **Q8's prompt** is missing its target quantity in the PDF ("...to yield saleable tins?" with no
  number). The professor's own solution uses the 200 tins established in Q7. Filling that blank is
  the one substantive edit here, so Q8 alone is marked `prof_adapted`; the other eleven are
  `prof_verbatim`.

The professor's "Pick B." sign-offs are dropped from the explanations for the same reason the
choices are shuffled -- after the shuffle a letter reference would be wrong, and the app already
shows which option was correct.
"""

import math
import sys

from practice_lib import check_inline_math, check_markdown, check_question, json_array, shuffle_choices, sql

COURSE = "OPMG"
SOURCE = "Additional Practice Set (Prof.)"

# ---------------------------------------------------------------------------
# Case 1 -- Organic Spice Processor, Guntur
# ---------------------------------------------------------------------------

R1, P1, S1, H1 = 500, 40, 180, 8          # kg/yr, Rs/kg, Rs/order, Rs/kg/yr (flat)

eoq1 = math.sqrt(2 * S1 * R1 / H1)                              # 150 kg
tc1 = (R1 / eoq1) * S1 + (eoq1 / 2) * H1 + P1 * R1              # 21,200
tc_250 = (R1 / 250) * S1 + (250 / 2) * H1 + 38 * R1             # 20,360
tc_400 = (R1 / 400) * S1 + (400 / 2) * H1 + 36 * R1             # 19,825

assert (eoq1, tc1, tc_250, tc_400) == (150, 21_200, 20_360, 19_825), (eoq1, tc1, tc_250, tc_400)
assert tc1 - tc_250 == 840 and tc1 - tc_400 == 1_375

GUNTUR_SETUP = """A turmeric processor in Guntur sources raw turmeric from local farmers.

- Annual demand = **500 kg** (50 weeks x 10 kg per week)
- Purchase price = **Rs 40 per kg**
- Fixed ordering cost = **Rs 180** per procurement run
- Cold-storage holding cost = **Rs 8 per kg per year** — a flat warehousing fee, independent of the purchase price"""

# ---------------------------------------------------------------------------
# Case 2 -- Amrutanjan Healthcare, Chennai
# ---------------------------------------------------------------------------

MU2, SD2, LSL2, USL2, N2 = 100, 10, 80, 120, 4
COST2, PRICE2, SALVAGE2 = 40, 100, 20

sigma_cap2 = min((USL2 - MU2) / SD2, (MU2 - LSL2) / SD2)        # 2.0
sd_xbar2 = SD2 / math.sqrt(N2)                                   # 5
ucl2, lcl2 = MU2 + 3 * sd_xbar2, MU2 - 3 * sd_xbar2              # 115, 85
cu2, co2 = PRICE2 - COST2, COST2 - SALVAGE2                      # 60, 20
sl2 = cu2 / (cu2 + co2)                                          # 0.75
# Demand scenarios and their cumulative probability.
DEMAND2 = [(100, 0.25), (200, 0.75), (300, 1.00)]
qstar2 = next(q for q, cum in DEMAND2 if cum >= sl2)             # 200
yield2 = 1 - 0.05                                                # 2-sigma centred ~ 5% outside spec
run2 = qstar2 / yield2                                           # 210.5

assert (sigma_cap2, ucl2, lcl2, sl2, qstar2) == (2.0, 115, 85, 0.75, 200)
assert round(run2) == 211 and int(run2) == 210   # professor rounds down to the 210 option

AMRUTANJAN_SETUP = """Amrutanjan produces medicated balm in 100g tins.

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
| 300 tins | 0.25 | 1.00 |"""

# ---------------------------------------------------------------------------
# Case 3 -- Haldiram's Snack Division, Noida
# ---------------------------------------------------------------------------

MU3, SD3, LSL3, USL3 = 50, 4, 40, 60
R3, P3, S3, H3 = 400, 200, 800, 16
SD3_NEW, S3_NEW = 2, 200

sigma_cap3 = min((USL3 - MU3) / SD3, (MU3 - LSL3) / SD3)         # 2.5
eoq3 = math.sqrt(2 * S3 * R3 / H3)                               # 200
eoq3_new = math.sqrt(2 * S3_NEW * R3 / H3)                       # 100
inv3 = (R3 / eoq3) * S3 + (eoq3 / 2) * H3                        # 3,200
inv3_new = (R3 / eoq3_new) * S3_NEW + (eoq3_new / 2) * H3        # 1,600

assert (sigma_cap3, eoq3, eoq3_new, inv3, inv3_new) == (2.5, 200, 100, 3_200, 1_600)
assert inv3 - inv3_new == 1_600

HALDIRAM_SETUP = """Haldiram's orders multilayer packaging film rolls from a vendor.

- Film thickness must fall within **40 to 60 microns**
- The vendor's process runs at mean = **50 microns**, standard deviation = **4 microns**
- Haldiram's orders **400 rolls per year** at **Rs 200 per roll**
- Fixed ordering cost = **Rs 800 per order**, which includes incoming quality inspection
- Annual holding cost = **Rs 16 per roll per year**"""

# ---------------------------------------------------------------------------
# Scenarios and questions
# ---------------------------------------------------------------------------

SCENARIOS = [
    ("opm-add-guntur", 10, "Organic Spice Processor, Guntur — EOQ with Discount Options", GUNTUR_SETUP),
    ("opm-add-amrutanjan", 9, "Amrutanjan Healthcare, Chennai — Process Capability + Newsvendor", AMRUTANJAN_SETUP),
    ("opm-add-haldiram", 10, "Haldiram's Snack Division, Noida — Process Capability + EOQ", HALDIRAM_SETUP),
]

# (id, scenario, order, topic, session, difficulty, prompt, choices, correct, explanation, hint)
QUESTIONS = [
    (
        "opm-add01", "opm-add-guntur", 1, "eoq_cycle_inventory", 10, 2,
        "What is the standard EOQ and total annual cost (purchase + ordering + holding)?",
        [
            "Q* = 100 kg; total cost = Rs 20,800",
            "Q* = 150 kg; total cost = Rs 21,200",
            "Q* = 200 kg; total cost = Rs 21,600",
            "Q* = 250 kg; total cost = Rs 22,000",
        ],
        "Q* = 150 kg; total cost = Rs 21,200",
        "Q* = sqrt(2 x 180 x 500 / 8) = sqrt(22,500) = **150 kg**.\n\n"
        "- Annual ordering = (500/150) x 180 = Rs 600\n"
        "- Annual holding = (150/2) x 8 = Rs 600 — equal at the EOQ, which is the standard check\n"
        "- Purchase = 40 x 500 = Rs 20,000\n\n"
        "Total = **Rs 21,200**.",
        "Purchase cost is the same at every order quantity here, but the question asks for total cost — add it in rather than comparing ordering + holding alone.",
    ),
    (
        "opm-add02", "opm-add-guntur", 2, "eoq_cycle_inventory", 10, 2,
        "The existing turmeric supplier has offered 5% price discount (Rs 38 per kg) for any single order of 250 kg or more. Should the processor increase the order quantity, and what is the total annual cost at Q = 250?",
        [
            "No; ordering 250 kg inflates holding cost more than the discount saves",
            "Yes; total cost at Q = 250 falls to Rs 20,360, saving Rs 840 vs. standard",
            "Yes; total cost at Q = 250 falls to Rs 19,000",
            "No; the unconstrained EOQ at Rs 38 is above 250, so the firm should find a new optimum first",
        ],
        "Yes; total cost at Q = 250 falls to Rs 20,360, saving Rs 840 vs. standard",
        "The EOQ formula does not change, because H = Rs 8 is a flat warehousing fee and does not move with price. Q* stays **150 kg**, below the 250-kg threshold, so taking the discount means being constrained up to Q = 250.\n\n"
        "TC(250, Rs 38) = (500/250) x 180 + (250/2) x 8 + 38 x 500 = 360 + 1,000 + 19,000 = **Rs 20,360**.\n\n"
        "Saving vs. standard = 21,200 − 20,360 = **Rs 840**. Take the discount.",
        "Check whether H depends on price before recomputing the EOQ. Here it does not, so Q* is unchanged and the only question is whether being forced up to 250 is worth the lower price.",
    ),
    (
        "opm-add03", "opm-add-guntur", 3, "eoq_cycle_inventory", 10, 2,
        "We found a new supplier that offers 10% discount (Rs 36/kg) for orders of 400 kg or more. Should you switch to the new supplier?",
        [
            "TC = Rs 19,825; New supplier option is better than previous supplier options",
            "TC = Rs 20,800; New supplier option saves less than the discount offered by the previous supplier and should be rejected",
            "TC = Rs 18,500; New supplier option is best and should be chosen immediately",
            "TC = Rs 19,825; New supplier option is better on cost but identical in savings to the discount offered by the previous supplier",
        ],
        "TC = Rs 19,825; New supplier option is better than previous supplier options",
        "TC(400, Rs 36) = (500/400) x 180 + (400/2) x 8 + 36 x 500 = 225 + 1,600 + 18,000 = **Rs 19,825**.\n\n"
        "Ranking: standard Rs 21,200 > previous supplier's discount Rs 20,360 > new supplier Rs 19,825.\n\n"
        "The new supplier saves Rs 1,375 against the standard policy — more than the Rs 840 the previous supplier's discount saves — so it has the lowest total cost of the three.",
        "Evaluate every price break at its own threshold quantity and compare total costs across all three policies, not just against the standard one.",
    ),
    (
        "opm-add04", "opm-add-guntur", 4, "eoq_cycle_inventory", 10, 3,
        "The processor's cold-storage facility can hold at most 350 kg of inventory. Given this constraint, which discount option(s) should be used?",
        [
            "Only new supplier",
            "Only discount option of previous supplier",
            "Both options have same cost",
            "Neither",
        ],
        "Only discount option of previous supplier",
        "The new supplier's price break needs Q = 400 kg, which exceeds the 350-kg cold-storage limit, so despite being cheaper on paper (Rs 19,825 vs Rs 20,360) it is simply **infeasible**.\n\n"
        "The processor takes the previous supplier's discount at Q = 250, which fits.\n\n"
        "The point of the question: a cost-optimal solution has to be filtered through operational constraints before it is a decision.",
        "Work out which options are feasible before comparing their costs — the cheapest infeasible option is not an option.",
    ),
    (
        "opm-add05", "opm-add-amrutanjan", 1, "quality_process_capability", 7, 2,
        "What is the sigma-capability of the filling process?",
        ["Sigma-capability = 1.0", "Sigma-capability = 2.0", "Sigma-capability = 4.0", "Sigma-capability = 6.0"],
        "Sigma-capability = 2.0",
        "Sigma-capability = min[(USL − mean)/sigma, (mean − LSL)/sigma] = min[(120−100)/10, (100−80)/10] = min[2.0, 2.0] = **2.0**.\n\n"
        "Both specification limits sit exactly 2 standard deviations from the mean, so the process is centred.",
        "Take the minimum of the two one-sided distances — a process is only as capable as its nearer specification limit.",
    ),
    (
        "opm-add06", "opm-add-amrutanjan", 2, "spc_control_charts", 8, 2,
        "What are the UCL and LCL of the x-bar control chart with n = 4?",
        [
            "UCL = 120g; LCL = 80g (the specification limits)",
            "UCL = 110g; LCL = 90g",
            "UCL = 115g; LCL = 85g",
            "UCL = 105g; LCL = 95g",
        ],
        "UCL = 115g; LCL = 85g",
        "The chart plots sample *means*, so it uses the standard error, not the raw sigma:\n\n"
        "sigma_xbar = sigma / sqrt(n) = 10 / sqrt(4) = **5g**.\n\n"
        "- UCL = 100 + 3 x 5 = **115g**\n"
        "- LCL = 100 − 3 x 5 = **85g**\n\n"
        "Control limits (85–115g) are narrower than the specification limits (80–120g), as expected for a 2-sigma capable process. Confusing the two is the classic error — specification limits come from the customer, control limits come from the process.",
        "Control limits are about the distribution of the sample mean, so divide sigma by sqrt(n) before going out three of them.",
    ),
    (
        "opm-add07", "opm-add-amrutanjan", 3, "newsvendor_model", 9, 2,
        "What is the optimal service level (SL*) and the optimal pre-season production quantity (Q*)?",
        [
            "SL* = 60%; Q* = 100 tins",
            "SL* = 75%; Q* = 200 tins",
            "SL* = 75%; Q* = 300 tins",
            "SL* = 67%; Q* = 200 tins",
        ],
        "SL* = 75%; Q* = 200 tins",
        "- Cu = 100 − 40 = **Rs 60** (margin lost per tin short)\n"
        "- Co = 40 − 20 = **Rs 20** (net loss per unsold tin)\n\n"
        "SL* = Cu / (Cu + Co) = 60 / 80 = **75%**.\n\n"
        "Now take the smallest Q whose cumulative probability clears 75%: P(D <= 100) = 0.25, which is short; P(D <= 200) = 0.75, which clears it. So Q* = **200 tins**.",
        "Co is the *net* loss on an unsold unit — cost minus salvage, not the full cost.",
    ),
    (
        "opm-add08", "opm-add-amrutanjan", 4, "quality_process_capability", 7, 3,
        "The quality team discards any defective tins that are outside specifications. How many tins must the production line actually run to yield the 200 saleable (non-defective) tins?",
        ["200 tins", "210 tins", "240 tins", "400 tins"],
        "210 tins",
        "A centred 2-sigma process (from the capability question) leaves roughly 5% of output beyond the specification limits: P(|Z| > 2) = 2 x 0.023 = 0.046, call it 5%.\n\n"
        "Yield = 1 − 0.05 = 0.95, so the line must start:\n\n"
        "200 / 0.95 = 210.5, i.e. about **210 tins**.\n\n"
        "Capability is not just a quality statistic — it decides how many units you have to start to finish the number you actually promised.",
        "Divide the saleable target by the yield; multiplying it by the defect rate instead understates the shortfall.",
    ),
    (
        "opm-add09", "opm-add-haldiram", 1, "quality_process_capability", 7, 2,
        "What is the sigma-capability of the vendor's current film process?",
        ["2.0", "2.5", "4.0", "5.0"],
        "2.5",
        "Sigma-capability = min[(60−50)/4, (50−40)/4] = min[2.5, 2.5] = **2.5**. The process is centred on the 50-micron midpoint.",
        "Both specification limits are 10 microns away; divide that by the standard deviation.",
    ),
    (
        "opm-add10", "opm-add-haldiram", 2, "eoq_cycle_inventory", 10, 2,
        "What is Haldiram's optimal order quantity?",
        ["Q* = 100 rolls", "Q* = 200 rolls", "Q* = 300 rolls", "Q* = 400 rolls"],
        "Q* = 200 rolls",
        "Q* = sqrt(2 x 800 x 400 / 16) = sqrt(40,000) = **200 rolls**.\n\n"
        "The Rs 200 per-roll purchase price does not enter the formula, because holding cost is given directly as Rs 16 per roll per year rather than as a percentage of value.",
        "Only R, S and H go into the EOQ. Purchase price matters only when H is expressed as a fraction of it.",
    ),
    (
        "opm-add11", "opm-add-haldiram", 3, "eoq_cycle_inventory", 10, 2,
        "After the process improvement, the vendor achieves 'certified supplier' status by reducing standard deviation to 2 microns. This lowers Haldiram's inspection intensity, reducing ordering cost to Rs 200 per order. What is Haldiram's optimal order quantity after the vendor is 'certified supplier'?",
        ["Q* = 50", "Q* = 100", "Q* = 200", "Q* = 150"],
        "Q* = 100",
        "Q* = sqrt(2 x 200 x 400 / 16) = sqrt(10,000) = **100 rolls**.\n\n"
        "Ordering cost fell by a factor of 4 (800 to 200), so Q* falls by sqrt(4) = 2.\n\n"
        "Note what did *not* happen: the vendor's standard deviation never enters the EOQ formula. The quality improvement reaches the inventory decision only through the ordering cost it removes.",
        "The sigma improvement is a distractor — trace it through to the parameter it actually changes before recomputing.",
    ),
    (
        "opm-add12", "opm-add-haldiram", 4, "eoq_cycle_inventory", 10, 3,
        "By how much does the total annual inventory operations cost (ordering + holding, excluding purchase) decrease after the vendor improvement?",
        ["Rs 800", "Rs 1,600", "Rs 3,200", "No change"],
        "Rs 1,600",
        "Before (Q = 200, S = 800): ordering = (400/200) x 800 = Rs 1,600; holding = (200/2) x 16 = Rs 1,600; total = **Rs 3,200**.\n\n"
        "After (Q = 100, S = 200): ordering = (400/100) x 200 = Rs 800; holding = (100/2) x 16 = Rs 800; total = **Rs 1,600**.\n\n"
        "Reduction = **Rs 1,600 per year** — a one-off improvement at the vendor turning into a permanent annual saving downstream.",
        "Ordering and holding are equal at the EOQ in both states, so compute one and double it.",
    ),
]


def main() -> int:
    problems: list = []
    seen: set = set()

    for sid, _sess, title, setup in SCENARIOS:
        check_inline_math(f"scenario {sid}", setup, problems)
        check_markdown(f"scenario {sid}", setup, problems)
        if not title.strip():
            problems.append(f"{sid}: empty title")

    scenario_ids = {s[0] for s in SCENARIOS}
    rows = []
    for (qid, scen, order, topic, session, diff, prompt, choices, correct, expl, hint) in QUESTIONS:
        if scen not in scenario_ids:
            problems.append(f"{qid}: unknown scenario {scen!r}")
        shuffled = shuffle_choices(qid, choices, correct)
        q = {
            "type": "formula", "choices": shuffled, "correct_answer": correct,
            "explanation": expl, "difficulty": diff,
            "provenance": "prof_adapted" if qid == "opm-add08" else "prof_verbatim",
        }
        check_question(qid, q, problems, seen)
        check_inline_math(f"{qid} prompt", prompt, problems)
        check_markdown(f"{qid} explanation", expl, problems)
        rows.append((qid, scen, order, topic, session, diff, prompt, shuffled, correct, expl, hint, q["provenance"]))

    # The chain is only worth having if it arrives in the professor's order.
    for sid in scenario_ids:
        orders = sorted(r[2] for r in rows if r[1] == sid)
        if orders != list(range(1, len(orders) + 1)):
            problems.append(f"{sid}: scenario_order is not 1..n -> {orders}")

    if problems:
        print("\n".join(f"-- PROBLEM: {p}" for p in problems), file=sys.stderr)
        print(f"\n{len(problems)} problem(s); nothing written.", file=sys.stderr)
        return 1

    out: list = []
    w = out.append
    w("-- The professor's OPMG 'Additional Practice Set': three multi-part cases with his worked")
    w("-- solutions, circulated for end-term revision.")
    w("--")
    w("-- GENERATED -- edit supabase/opmg-additional-set.py and re-emit, never this file.")
    w("--")
    w("-- First use of learn_scenarios in this course: each case is one setup with four questions")
    w("-- chained off it. Choice order is shuffled (the professor's answer is B in 11 of 12, and")
    w("-- QuestionCard renders choices in stored order); opm-add08's prompt has its missing target")
    w("-- quantity filled in from the professor's own solution, so it alone is prof_adapted.")
    w("")
    w("begin;")
    w("")
    w(f"-- learn_scenarios: {len(SCENARIOS)} rows")
    for sid, sess, title, setup in SCENARIOS:
        w("insert into public.learn_scenarios (id, course_code, session, title, setup, source) values")
        w(f"  ({sql(sid)}, {sql(COURSE)}, {sess}, {sql(title)}, {sql(setup)}, {sql(SOURCE)})")
        w("on conflict (id) do update set title = excluded.title, setup = excluded.setup, "
          "session = excluded.session, source = excluded.source;")
        w("")
    w(f"-- learn_questions: {len(rows)} rows")
    for (qid, scen, order, topic, session, diff, prompt, choices, correct, expl, hint, prov) in rows:
        w("insert into public.learn_questions")
        w("  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,")
        w("   explanation, hint, scenario_id, scenario_order, difficulty, provenance) values")
        w(f"  ({sql(qid)}, {sql(COURSE)}, 'formula', {sql(topic)}, {session}, {sql(prompt)},")
        w(f"   {json_array(choices)}, {sql(correct)}, {sql(SOURCE)},")
        w(f"   {sql(expl)}, {sql(hint)}, {sql(scen)}, {order}, {diff}, {sql(prov)})")
        w("on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,")
        w("  correct_answer = excluded.correct_answer, explanation = excluded.explanation,")
        w("  hint = excluded.hint, topic = excluded.topic, session = excluded.session,")
        w("  scenario_id = excluded.scenario_id, scenario_order = excluded.scenario_order,")
        w("  difficulty = excluded.difficulty, provenance = excluded.provenance;")
        w("")
    w("commit;")
    w("")

    sys.stdout.write("\n".join(out))
    print(f"-- generated: {len(SCENARIOS)} scenarios, {len(rows)} questions", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
