-- Deepen OPMG sessions 6-8 (Lean, Process Capability, SPC, Six Sigma): fold in the
-- classroom open questions and intuition from the Aug 3 / Aug 5 sessions (Voice of the
-- Customer, the LSL-is-really-minus-infinity debate, why the p-value isn't doubled, Type I
-- vs Type II error on control-limit width, and the full lean toolkit mechanics), plus two
-- new interactive widgets (control-limit-width, six-sigma-drift). Source: class transcripts
-- (Granola, Aug 3 & Aug 5 2026) and a cohort-built revision field manual for the same two
-- sessions. GENERATED — see gen_opmg_update.py in the authoring session, not checked in.

begin;

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

update public.learn_concepts set note = 'A restaurant promises delivery in under 30 minutes. Is that good quality?

You cannot answer, and the reason you cannot is that the question is hiding two entirely separate questions inside one word.

## Two questions, one word

- **Quality of design** — is *under 30 minutes* the right promise for this customer? That is a marketing question about what people need. A fine-dining restaurant promising 30-minute delivery has bad quality of design; the promise itself is wrong.
- **Quality of conformance** — given that promise, how reliably does the actual process keep it? That is an operations question.

Process capability measures the **second** one. It takes the promise as given and asks how good you are at hitting it.

Keeping these apart matters, because the fixes are unrelated. Poor design is fixed by changing what you sell. Poor conformance is fixed by changing how you work.

## Where the spec number comes from — Voice of the Customer

A specification is the customer''s expectation, translated into a number with a tolerance. Get the tolerance wrong and you either waste money on precision nobody notices, or ship something customers can feel is off — and "the right tolerance" is not the same for every customer of the same product.

> Worked example: a tournament tennis ball and an everyday one deform by roughly the same amount, on average, under an 18 lb load. The difference is the *tolerance band* around that average — a professional-grade ball allows only about a fourteenth of the variation the everyday ball does. Neither number is "more correct." At the professional level tiny bounce inconsistencies can decide a point; at the recreational level nobody can feel a difference of a few hundredths of an inch. The tighter spec is calibrated to what that specific customer can perceive, not to some abstract idea of quality.

Specs can get granular in the other direction too — M&M''s specs its color mix to the percentage point (roughly a quarter blue, a fifth orange, and so on down to single-digit shares for the rest), even though almost no one can taste a difference between colors. The point isn''t that the granularity is rational for every customer; it''s that *someone''s* stated or revealed preference put a number on it, and once it''s specced, conformance is judged against that number regardless of whether it feels arbitrary to you.

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

> Prof: A student pushed on the LSL of 0 directly — does it really make sense? The answer given in class was that conceptually the LSL should be **minus infinity**: arriving early is never a defect, so there is no lower bound to violate. Zero is a serviceable stand-in here only because it is so many standard deviations below the mean (2.77σ) that it barely moves the answer either way — the *binding* constraint is always the near side, which for Grab-A-Bite is the upper limit. Don''t reach for "LSL = 0" as a general trick; reach for "is there actually a lower promise being made?" first.

> Trap: Why the **minimum** rather than an average? Because defects pile up on whichever side is closer. Averaging 1.12 and 2.77 would report 1.9σ and hide the fact that one shoulder of your distribution is sitting almost on top of the promise. With only one spec limit given, there is only one number to compute.

> Trap: This was rounded aloud in class to "about 1.5 sigma," but the arithmetic on those exact numbers gives 1.12. Learn the formula and compute it — the quoted figure is not reliable, and an exam will hand you fresh numbers anyway.

> Trap: taking the minimum of two Z-values also means you cannot just double one tail''s probability to get the total defect rate — the two tails are rarely symmetric. Doubling gives an **upper bound**, not the true rate. In practice, if a distribution is skewed enough for this to matter, the fix is usually to re-centre the mean rather than compute the exact two-tailed figure by hand.

## Why the same number means different things

1.12σ sounds abstract until you ask what it is for. Roughly 12% defective would be catastrophic in cardiac surgery and merely mediocre for a snack order.

Capability is only meaningful **against the promise the business made** — which is the quality-of-design question again, arriving from the other direction.

## Cp and Cpk

Two related measures that answer slightly different questions:

- $C_p = \dfrac{USL - LSL}{6\sigma}$ — how wide the specification is relative to your spread. It ignores where the process is *centred*.
- $C_{pk} = \dfrac{\text{sigma capability}}{3}$ — the same idea but accounting for centring.

> Trap: A process can have a healthy $C_p$ and a terrible $C_{pk}$. That combination has a specific meaning: your spread is fine, you are just off-centre. Re-centring a process is usually far cheaper than reducing its variability, so diagnosing which one you have is worth real money.' where course_code = 'OPMG' and topic = 'quality_process_capability';

update public.learn_concepts set note = 'Your delivery process averaged 21 minutes last month. This morning''s sample averages 24. Should you investigate?

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

> Prof: A student asked why this isn''t multiplied by two, the way a two-tailed test would be. It isn''t two-tailed on purpose: only a *decrease* counts as evidence the pilot worked. If the mean had gone up instead, that is not neutral — it is evidence against the change, not a result you''d credit by symmetry. One-sided tests use the direction the hypothesis actually predicted.

## Test days separately, not pooled

> Trap: Pooling seven days of data averages away exactly the day-to-day variability you are trying to detect. Tested individually, days 2, 3 and 6 came back anomalous — which points at traffic and weekend effects worth investigating. Pooled, they would have vanished into a perfectly reasonable weekly average.

## How wide should the limits be? Type I vs. Type II error

$\pm 3\sigma$ is convention, not law, and choosing the width is a real trade-off with names attached to both sides of it:

| | Type I error | Type II error |
|---|---|---|
| What happens | A false alarm — the process hasn''t changed, but a sample looks unusual anyway | A missed signal — the process **has** changed, but a sample happens to look ordinary |
| What it costs | Time spent investigating a root cause that isn''t there | A broken process keeps running, undetected |
| Narrower limits | More of these | Fewer of these |
| Wider limits | Fewer of these | More of these |

Narrow the band and you catch every real shift faster, at the cost of chasing more false alarms — the right call for vaccines and aerospace, where missing a real problem is catastrophic and an unnecessary check is cheap by comparison. Widen the band and false alarms drop, but a real shift can run for longer before anyone notices — often the right call for something like a food-delivery process, where an occasional slow week isn''t worth constant investigation.

> Prof: There is no universally correct width. It''s an industry-specific judgement call, and $\pm 3\sigma$ is simply a commonly accepted balance point, not a law of nature.

Drag the band below and watch both error rates move in opposite directions — then drag the "actual shift" slider to see how a real change of a given size gets easier or harder to catch depending on where you set the band.

:::viz control-limit-width mean=19.32 sd=7.73 n=50 k=3 shift=3 unit="min"' where course_code = 'OPMG' and topic = 'spc_control_charts';

update public.learn_concepts set note = 'Six Sigma is usually explained as "3.4 defects per million opportunities," which is technically correct and almost entirely useless as an explanation. It makes the whole thing sound like perfectionism.

It is not about perfectionism. It is about what happens on your worst day.

## The actual point

> Prof: Six Sigma is not primarily about producing near-zero defects in steady state. Its real value is robustness when the process inevitably shifts.

Every process drifts. A supplier changes their formulation, the weather turns, an experienced operator leaves, a new batch of raw material arrives slightly different. None of this is failure — it is Tuesday.

Now compare two processes, both currently producing zero defects:

- One sits with its spec limits about 3σ away. A modest drift and part of its distribution crosses the line. Defects appear, and you have to stop and investigate.
- One sits with its limits 6σ away. The same drift moves the distribution, and output is *still comfortably inside spec*. You notice on the control chart, investigate at your own pace, and never stop producing.

Both had zero defects yesterday. Only one still has zero defects today.

Drag the mean below to simulate that drift directly and watch which process starts failing first — same spec window, same amount of drift, different amount of margin.

:::viz six-sigma-drift lsl=100 usl=160 sigmaWide=10 sigmaTight=5 centerMean=130

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

> Worked example: A process where the mean drops from 1000 to 100 while σ only falls from 10 to 9. The coefficient of variation gets **worse** — relatively speaking the process is more variable than before. The absolute defect count improves anyway. Judge by defects against the spec, not by relative variability, because the customer experiences defects and has never heard of your CV.' where course_code = 'OPMG' and topic = 'six_sigma_dmaic';

update public.learn_session_content set summary = '## Where this session sits

Lean gets finished here, and then the course pivots. Everything so far has been about *flow* — how fast, how much, how long. The rest is about **quality**: not how much you produce, but how reliably it matches what you promised.

## Lean, finished

Lean is a philosophy of waste elimination, where waste (*muda*) is the gap between your process and the ideal one: demand arrives, output appears instantly, zero flow time, zero inventory. Unachievable — and every deviation from it is still waste.

That definition is deliberately uncomfortable. It refuses to let you call a two-day inspection acceptable because it is normal. You may not be able to remove it, but you do not get to stop calling it waste.

The tools all do one job, synchronising flow: batch size reduction, pull/JIT, Kanban, quality checks at every station, cross-trained resources, cellular layout. If any of those six names is fuzzy — what a Kanban card actually authorises, why Jidoka means stopping the line, what a cellular layout looks like next to a functional one — the lean concept note below works through each one with the actual mechanics, not just the name.

> Trap: Lean firms do not mandate small batches. They reduce the **cost** of small batches — closer layouts, faster changeovers — and small batches follow naturally. Mandating the batch size without cutting changeover cost just destroys capacity, which is how a lean programme makes a plant slower.

### Inventory hides problems

Manufacturers use inventory to cover missed dates and scrap; lean firms cut inventory to make those failures **visible**, then fix root causes. Removing the buffer is a diagnostic instrument, not just a saving. Service firms hide the same problems in time buffers, like Swiggy padding an estimate by five minutes.

> Worked example: Toyota sorted inputs by disruption risk after the 2011 earthquake. Plastic resin substitutes easily, so no buffer. Semiconductors take years to rebuild, so it held a calculated 2 to 6 months of stock — and was the only major automaker largely unaffected by the 2021 chip shortage. Everyone else copied "eliminate inventory" without the distinction between excess stock and disruption buffer.

Starbucks shows the limit: for grab-and-go customers less flow time is value, for atmosphere customers dwell time **is** the product. Lean needs one clear ideal process, and Starbucks has two.

> Prof: Asked cold to define "lean," a class typically answers "efficient" or "minimal resources" — and gets pushed back with *"who defines what is possible?"* There is no floor to be minimal against; there''s only a direction. A separate question, from a student (Ganesh), was why a defect counts as *waste* rather than just a quality problem — the answer: "you''re not in the business of making defective units," so every rework and correction is muda by the same definition as excess inventory.

## Two questions hiding in one word

Now the pivot. A restaurant promises delivery under 30 minutes. Is that good quality? You cannot answer, because "quality" is concealing two separate questions.

**Quality of design** is what the customer needs — the spec itself. Is *under 30 minutes* the right promise? That is a marketing question.

**Quality of conformance** is how reliably the actual process hits that spec. That is an operations question, and process capability measures it.

Keeping them apart matters because the fixes are unrelated. Bad design is fixed by changing what you sell; bad conformance by changing how you work.

### Where the spec number comes from

A spec is the customer''s tolerance, translated into a number — and that tolerance is calibrated to what a *specific* customer can perceive, not to some universal idea of precision. A tournament tennis ball is specced roughly fourteen times tighter than an everyday one for the same average deformation, because professional players can feel a difference recreational players never will. M&M''s specs its color mix to the percentage point for the same reason in reverse: someone''s preference put a number on it, however granular, and once it''s specced, conformance is judged against that number.

### Grab-A-Bite, before Anisha

The market is office lunch, so the spec is delivery **under 30 minutes**. Baseline mean 21.38 min, σ 7.73 min.

Your process does not produce one delivery time — it produces a distribution. The promise is a hard line. Conformance is therefore a geometry question: how much of your distribution falls on the wrong side?

- **Percent defective** — 12.5% of actual deliveries came in over 30 minutes
- **Sigma capability** — $\min\left[\frac{USL-\mu}{\sigma},\ \frac{\mu-LSL}{\sigma}\right]$, with LSL taken as 0 since delivery time cannot be negative

$$\min\left[\frac{30 - 21.38}{7.73},\ \frac{21.38 - 0}{7.73}\right] = \min[1.12,\ 2.77] = \mathbf{1.12\sigma}$$

> Trap: In class this was rounded aloud to "about 1.5 sigma," but the arithmetic on those exact numbers gives 1.12. Know the formula and be able to compute it — do not memorise the quoted figure. Check your own slide annotation before the exam.

> Trap: Why the minimum and not an average? Defects pile up on whichever side is closer. Averaging 1.12 and 2.77 reports 1.9σ and hides that one shoulder of the distribution is sitting almost on the promise.

> Prof: A student pushed on the LSL of 0 directly. Conceptually it should be **minus infinity** — arriving early is never a defect — and 0 is only a workable stand-in because it sits so far below the mean (2.77σ) that it barely changes the answer. The binding constraint is always the near side.

## Central Limit Theorem

To monitor a process you need to know how much a measurement *should* wobble. That is what the CLT provides.

Individual delivery times scatter widely. Averages of many deliveries barely move. Formally, sample means of size $n$ are normally distributed regardless of the original distribution:

$$\bar{X} \sim N\left(\mu,\ \frac{\sigma}{\sqrt{n}}\right)$$

Two claims worth separating. First, **normal regardless of the parent distribution** — which is why the normal shows up everywhere in process control even when nothing measured is normal. Second, the spread is $\sigma/\sqrt{n}$, narrower than the process by a factor of $\sqrt{n}$. To halve your uncertainty you need four times the data.

## Hypothesis testing

The null hypothesis is the status quo — the coin is fair, the process mean is still 90 minutes. Data is judged against the null, and the burden of proof sits with the data. If what you observed would be very unlikely under the null, you reject it and raise the flag.

> Prof: You are never proving the new thing is true. You are asking whether the old story can still explain what you just saw.

Next session turns this into control charts: group outputs into buckets, plot the sample means, and test deviations statistically.', updated_at = now() where course_code = 'OPMG' and session = 7;

update public.learn_session_content set summary = '## The problem this session solves

You changed the process and this week''s numbers look better. Did it work, or did you get a good week?

That question needs a method, not an opinion — and the method has to work every day, not just once.

## Specification limits belong to the customer

First, a distinction that the whole session rests on. USL and LSL are **imposed from outside**. Grab-A-Bite''s 30-minute upper limit came from the customer promise, not from the kitchen.

> Prof: A student asked whether the LSL of zero really makes sense for a delivery time. It doesn''t, quite — the honest answer is that the LSL is effectively **minus infinity**, since nobody complains about food arriving early. Zero is used in the formula only because it is so far below the mean that it never binds; the sigma-capability number is unaffected either way, since the minimum always lands on the upper side here.

> Trap: Sigma capability takes the **minimum** of the two Z values to catch the worst tail. Skewed distributions pile defects on one side, and the minimum finds the side nearer the mean. Doubling the tail probability is an upper bound on the defect rate, not the actual rate — if the skew is bad enough to matter, the practical fix is usually to re-centre the mean rather than compute the two-tailed figure exactly.

## Did the improvement work? Hypothesis testing

Anisha''s pilot: sample mean **19.2 minutes** from n = 100. Null hypothesis is that nothing changed — μ = 21.39, σ = 7.73.

> Trap: 19.2 is not a draw from the population distribution. It is a draw from the **sampling distribution of the mean**, which is $N\left(21.39,\ \tfrac{7.73}{\sqrt{100}}\right)$. Using σ instead of σ/√n is the most common error on this topic and it changes the answer by a factor of ten.

$$z = \frac{19.2 - 21.39}{7.73/\sqrt{100}} = -2.83 \quad\Rightarrow\quad p = 0.0023 \ \text{(one-sided)}$$

One-sided because only improvement counts — a delivery process getting *slower* is not evidence the change worked. And 0.0023 is comfortably enough to reject the null for food delivery; a vaccine would demand far more.

> Prof: A student asked why this p-value isn''t doubled for a two-tailed test. It stays one-sided on purpose — only a decrease in the mean counts as evidence the pilot worked. An increase would be evidence *against* it, not a neutral result you average in.

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

### How wide should the limits be? Type I vs. Type II error

- **Narrow** — more false alarms (**Type I**: flagging a process that hasn''t actually changed), but you catch every real change fast (fewer **Type II**: missing a process that has). Right for vaccines and aerospace, where a missed shift is catastrophic.
- **Wide** — fewer Type I false alarms, but real shifts can pass unnoticed for longer (more Type II).

> Prof: There''s no universally correct width — it''s industry-specific. ±3σ is convention, not law, and it can be adjusted. The choice is a trade between the cost of a needless investigation and the cost of a missed change, and those costs differ by industry.

Drag the band width below and watch both error rates move in opposite directions.

:::viz control-limit-width mean=19.32 sd=7.73 n=50 k=3 shift=3 unit="min"

## What Six Sigma is actually for

> Prof: Six Sigma is not primarily about near-zero defects in steady state. Its real value is **robustness when the process inevitably shifts**.

Every process drifts — a supplier changes, the weather turns, an experienced operator leaves. With σ tight enough, a mean shift still leaves output inside spec, so you keep producing while you hunt the root cause instead of shutting the line down. You are buying insurance against drift, not a headline defect count.

**DMAIC**: Define, Measure, Analyse, Improve, Control. The Control phase is the loop — get the process in control, then improve again from the new baseline. It is the phase people skip and the one that makes the rest worth doing.

Six sigma is a target. In many contexts 4.5 sigma is plenty, and "is it worth it here?" is a real business question.', formula_sheet = '## Hypothesis test on a sample mean

$$\text{Standard error} = \frac{\sigma}{\sqrt{n}} \qquad z = \frac{\bar{x} - \mu_0}{\sigma/\sqrt{n}}$$

Use a one-sided p-value when only one direction counts as improvement.

> Trap: Divide by $\sigma/\sqrt{n}$, never by $\sigma$. This is the most common error in the topic — with $n = 100$ it understates $z$ tenfold.

## Control limits

$$UCL = \mu + 3\frac{\sigma}{\sqrt{n}} \qquad LCL = \mu - 3\frac{\sigma}{\sqrt{n}}$$

Width is a business choice; $\pm 3\sigma$ is convention.

## Specification vs control limits

- **Spec limits** — customer-imposed: "what does the customer want?"
- **Control limits** — process-derived: "is the process the same as yesterday?"

## Type I vs Type II error

- **Type I** — false alarm: flags an unchanged process. Narrower limits → more of these.
- **Type II** — missed signal: a real change looks ordinary. Wider limits → more of these.

## Capability recap

$$\text{Sigma capability} = \min\left[\frac{USL - \mu}{\sigma},\ \frac{\mu - LSL}{\sigma}\right] \qquad C_{pk} = \frac{\text{sigma}}{3}$$

## DMAIC

Define → Measure → Analyse → Improve → **Control** (the loop back)', updated_at = now() where course_code = 'OPMG' and session = 8;

commit;
