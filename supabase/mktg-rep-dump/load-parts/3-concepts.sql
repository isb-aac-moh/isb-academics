-- Learning agent data, part 3-concepts.
-- Run the parts in numeric order: later ones reference rows created by earlier ones.
-- Safe to run once only — re-running duplicates learn_attempts, whose keys are generated.

begin;

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

commit;
