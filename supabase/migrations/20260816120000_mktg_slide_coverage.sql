-- MKTG: full slide coverage pass.
--
-- Written after a slide-by-slide diff of Prof Shubhranshu Singh's nine decks against what was
-- already in learn_session_content / learn_concepts / learn_questions. Two kinds of gap were found:
--
-- 1. Session summaries were built from class notes and skipped items that only exist on the slides
--    -- the product levels breakdown (S1 p12), what/who can be marketed (S1 p7-8), the positioning
--    payoff and difficulty slides (S2 p13-14), the Snickers margin example and the full Kookaburra
--    cannibalisation table (S3 p5-8, p16), the Uber pickup stage definitions (S4 p15), the middle
--    "New Process" column of the Unilever sensitivity table (S5 p10), the EVC price-range split
--    (S7 p11), the price-sensitivity measurement 2x2 (S8 p7), and most of S9 -- the communications
--    taxonomy, media planning, the four budget-setting methods and the six copy rules.
--
-- 2. All 15 existing MKTG topics were quantitative or case topics. Session 1 had no topic at all,
--    and the frameworks the qualitative half of the exam is built on had nowhere to live. Eight
--    framework topics are added here, each with a concept note and 8 questions -- 8 because
--    ROUND_SIZE is 8 and pickNext() does not repeat within a round, so a short topic ends a
--    topic-filtered round early. A topic with no questions never appears in groupBySession(), which
--    is why the concept notes alone would not have surfaced.
--
-- Slide references in comments are to the PDFs, e.g. S3 p16.

begin;

-- ---------------------------------------------------------------------------
-- 1. Session summaries and formula sheets
-- ---------------------------------------------------------------------------

update public.learn_session_content set updated_at = now(), summary = $md$
## What marketing actually is

Most people arrive with a definition of marketing that means "advertising." That definition will not survive this course.

**Marketing is meeting needs profitably** — creating, communicating, delivering and **extracting** value. Four verbs, and notice the last one. Extracting value is part of the job, not something the finance team handles afterwards. A firm that creates enormous value and captures none of it is not doing good marketing. It is doing charity with extra steps.

Two halves sit underneath that definition and the slides name both:

- **Customer orientation** — make profits by understanding customers' needs and wants and creating value for them
- **Competitive advantage** — satisfy those needs *more effectively than the competition does*

Drop the second half and you have a description of a nice company that loses.

> Prof: "Make what you can sell, not sell what you can make." This returns in Session 5 with Unilever and is the spine of the whole course.

That sentence is the difference between marketing and sales. Sales starts with the product you have. Marketing starts with the customer you want.

## Who you market to, and what you market

Easy slides to skim, easy marks to lose.

**Who** — consumers (**B2C**), businesses both for-profit and not-for-profit (**B2B**), and governments (**B2G**). This course is B2C throughout.

**What** — a good deal more than products:

| Category | Examples |
|---|---|
| Products | iPad, cars, diapers |
| Services | Hotels, airlines, schools |
| Places | Incredible India, Uniquely Singapore |
| Information, awareness, education | AIDS awareness, anti-drug campaigns, campaigns against female foeticide |
| Individuals | Politicians, job seekers, celebrities |

The point of the list is that the frameworks do not care what is being sold. A tourism board segments and positions exactly the way a detergent brand does.

## 3 Cs, then 5 Cs

Before deciding anything, you have to understand the situation. Start with three:

**Customer, Company, Competition.** Then add two more that people forget until they matter:

- **Context** — regulatory environment, laws, tariffs
- **Collaborators** — partners, government subsidies, R&D alliances

Session 4 takes all five apart properly.

## Setting strategy: STP

- **Segmentation** — divide the total market into distinct groups
- **Targeting** — select which group to focus on
- **Positioning** — how the brand is perceived in the consumer's mind

Note the order, and that positioning happens **in the consumer's mind**, not in your deck. You do not decide your positioning; you decide what you will do to influence it.

A **positioning map** plots competing products on the axes consumers actually care about, such as price against quality.

> Trap: The axes need not be labelled in advance. Statistical techniques generate the map from consumer data — you are *discovering* which dimensions matter, not assuming them. A map drawn from your own intuition tells you what you already believed.

The whole planning process reads **5 Cs → STP → 4 Ps**: understand the situation, choose a strategy, then implement it.

## Customer value

Creating value is a three-step move: identify a customer need (that is what the 5 Cs are for), address it to create benefits, and check that the benefits exceed what the customer gives up.

**Value = benefits − costs**, and both sides have economic and non-economic parts. That second half is where most of the interesting behaviour lives.

- Non-economic **benefit** — the emotional attachment of "I made it myself" (the IKEA effect: the same bed, plus pride of assembly)
- Non-economic **cost** — patients disliking an AI diagnosis because it makes them feel un-special

Neither appears on a price tag, and both change what people buy.

> Trap: Raw quality is not enough. Value has to be **perceived** by the customer. A better product nobody can tell is better earns nothing for being better.

## Value proposition

Three circles: what the customer **really wants**, what **we do well**, what the **rival does well**. Where all three overlap you have points of parity. Where the first two overlap and the third does not, you have your proposition.

| Term | Definition | Purpose |
|---|---|---|
| **Points of parity** | Needs both you and the rival fulfil | Neutralise the competition |
| **Points of differentiation** | Needs you fulfil that rivals cannot | The basis of your value proposition |

Points of parity are not wasted effort. They are the price of entry — the reasons a customer *cannot* rule you out. Differentiation is what makes them choose you.

> Trap: Communicate consumer **needs**, not internal capabilities. "A reliable phone" is a value proposition. "Six sigma certified" is a fact about you that no customer asked for, and it forces them to do the translation themselves.

The value proposition is the pitch for why your product alone delivers the best differential value to your customer.

## The 4 Ps

The 4 Ps are how a point of difference gets built. The question to ask of each: *can I create a POD here, and is it the one my customers care about?*

### Product

A product has three levels, and knowing which level a feature sits at is a standard exam question.

| Level | What it is | Examples |
|---|---|---|
| **Core benefit** | The need actually being met | A bed to sleep on |
| **Actual product** | The thing you hand over | Features, design, quality level, **brand name**, packaging |
| **Augmented product** | Everything wrapped around it | Delivery, installation, credit, warranty, after-sale service |

> Trap: Brand name and packaging belong to the **actual** product, not the augmented one. Warranty and delivery are augmented. People reliably swap these two.

### Place

Where the company sells and how it gets the product to market. Two constituents on the slide: the **point-of-sale experience**, and the **channels of distribution** (online versus brick-and-mortar). The basic chain is Manufacturer → Retailer → Consumer, and Session 7 shows what that middle box costs you. The iPhone launching exclusively on AT&T was a place-based differentiator.

### Promotion

Inform, persuade and/or remind potential buyers about an offering — through innovative ad campaigns, personal selling and personalised offers. Session 9 is this P in full.

### Price

The only P that **generates revenue**; every other one spends it. Price extracts value, and it also signals quality. United Airlines prices as mainstream, Starbucks as premium, and both are deliberate.

## Other Ps and As

Beyond the four: **Purpose** (profit, society, environment, welfare), **People** (personnel and their incentives) and **Processes** (manufacturing, R&D, supply chain).

The **4 As** restate the mix from the customer's side rather than the firm's:

| 4 A | Firm-side equivalent |
|---|---|
| Acceptability | Creating value (product) |
| Affordability | Pricing |
| Accessibility | Distribution |
| Awareness | Communication |

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

A new brand is warranted when the risk of damage is high, or when the image would be misaligned. Session 6 turns this into the house-of-brands versus branded-house decision.

## What the course covers

Analysing markets and customers (5 Cs) · developing strategy (STP) · making decisions (4 Ps) · branding · pricing · marketing communications · distribution · and the quantitative work that keeps all of it honest: margin and break-even analysis, CLV, and EVC.
$md$, formula_sheet = $md$
## Definitions

- **Marketing** = meeting needs profitably = creating, communicating, delivering and **extracting** value
- **Customer orientation** + **competitive advantage** are the two halves of it
- **Value** = benefits − costs (each having economic and non-economic parts)

## Frameworks

- **3 Cs** — Customer, Company, Competition
- **5 Cs** — + Context, Collaborators
- **STP** — Segmentation → Targeting → Positioning
- **4 Ps** — Product, Price, Place, Promotion (**Price** is the only one that generates revenue)
- **Other Ps** — Purpose, People, Processes
- **4 As** — Acceptability (value) · Affordability (price) · Accessibility (distribution) · Awareness (communication)
- **Planning process** — 5 Cs → STP → 4 Ps

## Product levels

| Level | Contents |
|---|---|
| Core benefit | The need being met |
| **Actual** | Features · design · quality level · **brand name** · packaging |
| **Augmented** | Delivery · installation · credit · warranty · after-sale service |

## Who and what

- **Who** — B2C · B2B (for-profit and not-for-profit) · B2G
- **What** — products · services · places · information/awareness/education · individuals

## Value proposition

- **Points of parity** — you and the rival both deliver → neutralise
- **Points of differentiation** — only you deliver → the proposition

## Differentiation

- **Horizontal** — taste-based, no objective winner
- **Vertical** — quality-based, everyone prefers more
$md$ where course_code = 'MKTG' and session = 1;

update public.learn_session_content set updated_at = now(), summary = $md$
## Where this session goes

Session 1 said positioning happens in the consumer's mind. This session is the machinery for getting it there: how to find groups worth serving, how to choose between them, and how to write down what you will mean to the one you pick.

**Segmentation** asks what different customer groups are out there. **Targeting** asks which one we go after. **Positioning** asks what we are promising them.

## Why segment at all

It is usually not possible to create or promote one mass product that serves the entire market. Segmentation splits the consumer base into groups that share two properties:

1. They have **common needs or preferences**, and
2. They **respond similarly to the four elements of the marketing mix** — product, price, place, promotion.

That second condition is the one people forget, and it is the operational one. A group that reacts differently to a price cut is a different segment even if the demographics look identical.

## Segmentation bases

| Basis | What it splits on | Examples |
|---|---|---|
| **Geographic** | Region, country, city, climate, culture | McDonald's is upscale in India, low-end in the US. Haldiram's pani puri is under $1 in India, ~$10 in England |
| **Demographic** | Age, gender, income, education, occupation | The most common, because it describes segments in **reachable** terms |
| **Behavioural** | Purchase history, brand loyalty, benefits sought, usage frequency | Amazon, Starbucks, Sephora, Spotify |
| **Psychographic** | Lifestyle, values, beliefs, interests | Patagonia, Red Bull, Nike, Alo, the (RED) iPhone |
| **Benefit** | The specific benefit sought | Toothpaste: whitening vs sensitivity vs cavities |

> Trap: Even when you segment behaviourally or psychographically, you still have to describe the segment **demographically** to actually reach it. Media is bought on demographics — there is no "adventurous people" targeting option.

> Worked example: The (RED) iPhone sells on standing apart plus a social cause. In China the AIDS-funding angle is not communicated at all — red carries festive meaning there and disease associations are avoided. Same product, different psychographic framing by geography.

Segments are derived with **factor analysis** (collapse 50+ variables into 2–3 dimensions) then **cluster analysis** (group customers so they are most similar within a cluster and most dissimilar across clusters).

## Targeting

Pick the segment that best maximises your objective — which is not always profit. Patagonia's objective includes environmental welfare, and that changes which segments are attractive.

Two questions, and both have to be answered:

**Is the segment attractive?** How large is it, and is it growing? How strong is the need — who is in the most pain? Can we identify and access these customers at all?

**Do we fit it?** Are we credible with this segment? Can we produce a reliable offering? Can we do it profitably? And is the segment already well served by the competition?

The matrix is attractiveness against **your capability**.

> Trap: The dangerous cell is low capability in a highly attractive market. Everyone can see it is attractive, strong competitors are already there, and they will punish the entry. Attractiveness alone is a trap.

> Trap: Watch for **leakage** — a message aimed at one segment reaching and upsetting another. Limit reach and avoid content that alienates adjacent segments.

## Targeting more than one segment

Retailers usually have to. Coupons are the standard device: the price-sensitive segment clips them, everyone else pays full price, and one store serves both.

Manufacturers use the **adjacent segment strategy** — expand into a neighbouring segment with a new product rather than stretching one product to cover both.

> Worked example: Toyota's ladder runs Yaris → Corolla → Camry → Avalon → Supra → Lexus, laid out by year of launch, perceived quality and price. Each rung is a separate offer aimed at the segment next door, which is how Toyota climbed from economy to luxury without ever asking one badge to mean both.

## Niche targeting

When large dominant players own the market, enter a segment they do not care about. A niche lets you build a monopoly in a small segment and extract full value while staying beneath their notice. The smallest possible segment is one consumer served exactly as needed — **most pain, most need, least served**.

> Worked example: Red Bull entered the US as a **mixer** to go with vodka, not as a cola competitor. The taurine and bull-testicle rumour circulated and Red Bull stayed silent, letting the mystique build. Coke and Pepsi dismissed it — "our segment doesn't drink that." By the time they noticed, Red Bull was too entrenched to acquire or displace.

The lesson is that entering a *different* segment avoids retaliation until it is too late for the incumbent. Attacking head-on invites a response from someone with more money than you.

## When not to differentiate

Differentiation is expensive, and it is not always right.

- If market demand **exceeds** combined supply capacity, a third firm can enter doing the same thing and still profit. Price wars only start when firms need to steal each other's customers.
- **Co-location** is deliberate non-differentiation: petrol stations, jewellery shops and museums cluster because customers prefer clusters — it lowers the risk of a wasted trip and raises category traffic.

> Trap: Price-sensitive consumers are a reason to differentiate **more**, not less. Without differentiation you get pulled into a price war with no margin, and price-sensitive customers are exactly the ones who will leave for a cheaper option.

## Positioning

The act of making your offering occupy a distinctive place, **relative to your competition**, in the minds of the target audience.

Every good product offers more than one benefit and could appeal to more than one segment. So you have to choose which benefit is *the* benefit and who it appeals to most — and that choice also chooses your competition, because it decides which set of alternatives the customer will compare you against.

> Prof: The positioning statement is written **first**, as an internal guide. Differentiation is how that positioning gets implemented through product, price and channels.

### The positioning statement

Four questions, one sentence:

| Question | Element |
|---|---|
| Which customers are we going after? | **Target segment** |
| What are we promising them? | **Points of difference** |
| Why should they believe us? | **Reason to believe** |
| Who do we expect to steal business from? | **Frame of reference** |

> "To customers who are **<target market>**, our product **<brand name>** offers **<points of difference>** relative to **<frame of reference>**, because **<reason to believe>**."

> Worked example (the classic): "For World Wide Web users who enjoy books, Amazon.com is a retail bookseller that provides instant access to over 1.1 million books. Unlike traditional book retailers, Amazon.com provides a combination of extraordinary convenience, low prices, and comprehensive selection."

Read that back against the four questions and every one is answered, in order.

**Positioning statements are internal only and never published.**

> Trap: Publishing one reveals who you think you compete with and invites comparative advertising. When BMW and Audi fought publicly, the outcome was that consumers bought Japanese cars instead — the fight legitimised the question and a third party won it.

### What a positioning does for you

Two payoffs, and neither is about the customer:

- **It focuses strategy.** Product strategy and marketing planning have a test to pass, and limited resources get allocated against it rather than spread evenly.
- **It aligns the organisation.** Everyone knows who we are selling to and why them, and how any given initiative fits the strategic goal. That builds internal consensus before the arguments start.

### What makes positioning hard

- It needs a deep understanding of customer needs *and* of how customers differ
- It needs a sound understanding of the competing alternatives
- It forces the firm to be honest about its own strengths and weaknesses
- It **forces choices** — deciding to target one segment is simultaneously deciding not to target the others

> Prof: Writing one is not inherently hard. It is hard when you skipped the 5C analysis and the segmentation work that has to come first.

## BMW: how it got there

BMW entered North America in the 1950s through independent distributors and opened BMW North America around 1975–76, launching **"The Ultimate Driving Machine"** on a prestige-and-performance positioning.

Between 1986 and 1989, Acura, Infiniti and Lexus entered with cheaper high-quality alternatives and BMW's sales fell. From 1992 it recovered by reorganising dealers, launching new models and running inventive campaigns including the GoldenEye James Bond placement — achieving the highest return on marketing spend among US auto manufacturers. **Lexus spent twice what BMW did to sell the same volume.** By 2000 volume was back above 200K.

| Series | Share | Profile | Loyalty |
|---|---|---|---|
| 3-series | ~50% | ~35 years, ~$100K, not married | **Least loyal** |
| 5-series | ~32% | ~45 years, ~$150K, some married, some with babies | Middle |
| 7-series | ~16% | ~55 years, $300K+, married with kids | **Most loyal** |

Across all three: highly educated (MBA, CS), about two-thirds male, tech-savvy.

Read that with STP in hand: half the volume comes from the *least* loyal segment, so BMW must keep refilling the 3-series every generation. That is the problem the next session's campaign is aimed at.
$md$, formula_sheet = $md$
## STP

- **Segmentation** → what groups exist
- **Targeting** → which to pursue (attractiveness × **your capability**)
- **Positioning** → the distinctive place you occupy in their mind, relative to competition

A segment is a group with common needs **that responds similarly to the 4 Ps**.

## Segmentation bases

Geographic · Demographic · Behavioural · Psychographic · Benefit

Derived via **factor analysis** (reduce dimensions) then **cluster analysis** (similar within, dissimilar across)

> Trap: Whatever basis you segment on, you still describe the segment demographically to reach it.

## Targeting checklist

Attractiveness: size · growth · strength of need · can we identify and access them
Fit: credibility · reliable offering · profitability · already well served by competitors?

## Positioning statement (internal only, never published)

| Question | Element |
|---|---|
| Which customers? | Target segment |
| What are we promising? | Points of difference |
| Why believe us? | Reason to believe |
| Who do we steal from? | Frame of reference |

> "To customers who are **<target market>**, our product **<brand>** offers **<point of difference>** relative to **<frame of reference>**, because **<reason to believe>**."

**What it does for you:** focuses strategy and resource allocation · aligns the organisation and builds internal consensus
**Why it is hard:** needs customer depth, competitor depth, self-honesty, and it forces choices

## Growth plays

- **Adjacent segment** — expand along a spectrum with new products (Toyota: Yaris → Lexus)
- **Multiple segments at once** — coupons for the price-sensitive
- **Niche** — most pain, most need, least served (Red Bull, Rolex)

## When not to differentiate

- Demand exceeds combined supply capacity
- Co-location raises total category traffic
$md$ where course_code = 'MKTG' and session = 2;

update public.learn_session_content set updated_at = now(), summary = $md$
## Where this session goes

Session 2 set up BMW's problem: half its volume comes from its least loyal segment. This session shows what BMW did about it — and then turns to the arithmetic that lets you judge any marketing decision rather than admire it.

Marketing decisions look like this: launch a new product, change the price of an existing one, take on a new distribution channel, run an advertising campaign. Each one is a bet with a number attached, and the slides are blunt about the standard: to be made effectively, these decisions need **reliable data and good analysis**. Everything below is that analysis.

## BMW Films, analysed

Launched in 2000, deliberately during a **six-month window with no new product launches** — the campaign had to carry the brand alone. Five short films, "The Hire", with top directors and actors: **$15M production plus $14M advertising and promotion**, roughly $29M. Released only on bmwfilms.com, behind registration and a player download.

About **2M consumers registered and watched**, with positive press coverage. The average viewer was 30 years old, earned $88K and 63% held a college degree. The most popular film was **Star**. Students described the films as fast, adrenaline-driven, funny, unpredictable and unconventional.

### Why it worked

The stated objective was to **maintain the sales trend**, and the real target was **future 3-series buyers** — younger consumers with internet access, years away from affording the car. The film was built for them, which is why it landed with that group.

Everything that looks like a distribution mistake was a filter. 7-series customers, on $300K+, were **deliberately excluded**: the registration friction screened them out, and the tone was neither prestigious nor luxurious — that segment found it disrespectful.

> Prof: Effective targeting means the message will **not** appeal to other segments. Preventing leakage is as important as reaching the target.

That is the transferable idea. A campaign everyone likes has usually positioned nothing.

Afterwards BMW used the registration data to spot future high earners and invited them to test drives, keeping them engaged years before they could afford to buy.

### What it cost, and what was missed

$$\frac{\$29\text{M}}{2\text{M registrants}} \approx \$15 \text{ per person}$$

A prime-time TV ad runs about **$0.02 per viewer**. Not a like-for-like comparison — a registered, profiled, self-selected viewer is worth more than an incidental one — but you should raise it before you are asked.

> Trap: The distribution gap is the standard exam criticism. The films ran **only** on bmwfilms.com — not on BMW.com, not on auto magazine sites, not at auto shows, not on CDs or DVDs at dealerships. Exclusivity was the strategy, but nothing about it required staying off BMW's own homepage.

## Margin and markup

Everything in the analytics block is a rearrangement of one identity:

$$\text{Profit} = pq - cq - F = (p - c)q - F$$

$p$ is unit price, $c$ is unit variable cost, $q$ is quantity, $F$ is fixed cost. **Unit margin**, also called **unit contribution**, is $p - c$.

$$\%\text{Margin} = \frac{p - c}{p} \times 100 \qquad \%\text{Markup} = \frac{p - c}{c} \times 100$$

Margin divides by **price**, markup divides by **cost**. Same numerator, and markup is always the bigger number.

> Worked example: A cafe sells Snickers bars for $1 and buys them at $0.70.
> Contribution $= 1 - 0.70 = \$0.30$.
> $\%$Margin $= 0.30/1 = \mathbf{30\%}$. $\%$Markup $= 0.30/0.70 = \mathbf{43\%}$.
> Same bar, two different numbers, and quoting the wrong one to a supplier is an expensive slip.

## Break-even volume

A new marketing project carries fixed costs — new equipment, licensing fees. Break-even volume is the number of units at which total contribution has covered those fixed costs.

$$Q_{BE} = \frac{\text{project fixed cost}}{\text{unit contribution}}$$

> Worked example: The cafe is not selling Snickers yet. Doing so needs a display rack costing $60.
> $Q_{BE} = 60 / 0.30 = \mathbf{200\ bars}$.

> Trap: Do **not** include costs already incurred. Sunk costs are irrelevant to the decision; only costs you will incur *if you do the project* belong in $F$.

### Break-even on a change in unit margin

If you cut price, how much extra volume do you need just to stand still? Set new total contribution equal to old total contribution:

$$Q_{BE}^{\text{new}} \times \text{new contribution} = Q^{\text{old}} \times \text{old contribution}$$

$$\frac{Q_{BE}^{\text{new}}}{Q^{\text{old}}} = \frac{\text{old contribution}}{\text{new contribution}}$$

> Worked example: Price falls from $1 to $0.90 while cost stays at $0.70, so contribution falls from $0.30 to $0.20. The ratio is $0.30/0.20 = 1.5$ — you need **50% more units** to break even on the price cut.

> Trap: The slide's own line reads $\$0.40/\$0.20 = 2$, i.e. a 100% increase, using a different old margin than the $0.30 it derives two lines above. Learn the formula rather than the number, and in an exam recompute from whatever margins the question gives you.

## Cannibalisation

When a firm launches a new product, some buyers of its own existing products switch. That is not automatically bad — the question is how much switching the launch can absorb before it stops being worth doing.

$$\text{Cannibalisation rate} = \frac{\text{old product units cannibalised}}{\text{new product unit volume}}$$

$$\text{Cost of cannibalisation} = \text{units cannibalised} \times \text{old unit margin}$$

Break-even is where the new product's contribution exactly offsets the contribution lost on the old one:

$$\text{new units} \times \text{new contribution} = \text{units cannibalised} \times \text{old contribution}$$

$$\boxed{BECR = \frac{\text{new product contribution}}{\text{old product contribution}}}$$

## What break-even analysis is, and is not

- It is a **benchmark** and a **first step** in evaluating a proposed marketing action
- It is **not the sole criterion** — strategic, social and ethical considerations sit alongside it
- More often than not the action should do rather better than break even, and should pay for itself **within a given time frame**

## Kookaburra: the case

The five case questions were: build Year 1 and Year 2 P&Ls for the niche and mainstream positioning strategies; chart the cost and impact of cannibalisation; choose a positioning strategy; ask whether *any* cannibalisation rate lets the niche strategy break even in Year 1; and compute the niche BECR for Year 2.

The P&L skeleton is worth memorising because it is the same every time:

| Line | Formula |
|---|---|
| Unit price | $P$ |
| Unit volume | $Q$ |
| Total revenue | $P \times Q$ |
| Unit variable cost | $VC$ |
| Total variable cost | $VC \times Q$ |
| Fixed cost | $F$ |
| **Profit or loss** | $P \times Q - (VC \times Q + F)$ |

### The base unit margin

Everything downstream needs the margin on the *existing* bats, and it is derived rather than given:

$$\text{Base unit margin} = \frac{\text{total revenue} - \text{total variable cost}}{\text{unit sales}} = \frac{144.29\text{ cr} - 80.81\text{ cr}}{7.83\text{ lakh}} = \textbf{Rs 810.47}$$

### The full cannibalisation table

| | Niche Y1 | Niche Y2 | Mainstream Y1 | Mainstream Y2 |
|---|---|---|---|---|
| Profit **pre**-cannibalisation (Rs 000) | **(11,900)** | 35,300 | 35,500 | 1,55,300 |
| Cannibalisation rate | 22% | 22% | 32% | 32% |
| Units stolen from base | 17,600 | 33,000 | 86,400 | 1,40,800 |
| Unit contribution of stolen units | 810.47 | 810.47 | 810.47 | 810.47 |
| Cost of cannibalisation (Rs 000) | 14,264 | 26,746 | 70,025 | 1,14,114 |
| Profit **post**-cannibalisation (Rs 000) | **(26,164)** | 8,554 | **(34,525)** | 41,186 |

Three things fall straight out of that table.

**Year 1 loses money either way.** Niche loses Rs 2.62 cr, mainstream Rs 3.45 cr, both after cannibalisation. Mainstream is actually profitable *before* cannibalisation (Rs 3.55 cr) and is dragged under by it, because a mainstream launch steals from your own base at a much higher rate.

**Year 2 reverses the ranking.** Mainstream earns Rs 4.12 cr against niche's Rs 0.86 cr. So the answer depends entirely on the time horizon you are allowed to use, and saying so is part of the answer.

**Cannibalisation is the whole story, not a footnote.** For mainstream Year 1 it converts a Rs 3.55 cr profit into a Rs 3.45 cr loss.

> Trap: If **both** positioning strategies produce losses in the year you are asked about, the answer is neither — or "not yet". "Pick the less bad one" is not the expected answer.

### The Year 2 BECR

$$\text{Additional profit from launch} = \text{new product units} \times BECR \times \text{base unit margin}$$

$$\text{Rs } 3.53\text{ cr} = (1.5\text{ lakh units} \times BECR) \times \text{Rs } 810.47 \implies BECR = \mathbf{0.29}$$

Kookaburra can tolerate 29% cannibalisation of existing sales. Expected cannibalisation is 22%, so the launch survives — not comfortably, but it survives.

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

Raise price only when demand is **inelastic** — formally, $\dfrac{p - mc}{p} = \dfrac{1}{\varepsilon}$. Session 8 does this properly.

- **Niche segment** — smaller volume, less price-sensitive, higher price justified
- **Mainstream segment** — larger volume, more price-sensitive, lower price needed

> Trap: Volume discounts are why marginal cost differs between the two positioning strategies. If you carry one unit cost across both scenarios you will get the comparison wrong while appearing rigorous.

## Be honest about the assumptions

> Prof: Be mindful about the assumptions behind the numbers. A **sensitivity analysis** — varying the contentious numbers to see how much the conclusion moves — is advisable.

That is the real lesson of the case. The Rs 810.47 base margin, the 22% and 32% cannibalisation rates and the volume forecasts are all estimates. A recommendation that survives only at one exact set of estimates is not a recommendation.
$md$, formula_sheet = $md$
## Profit

$$\text{Profit} = (p - c)q - F$$

Unit contribution (unit margin) $= p - c$

## Margin vs markup

$$\%\text{Margin} = \frac{p - c}{p} \qquad \%\text{Markup} = \frac{p - c}{c}$$

Margin divides by **price**, markup divides by **cost**; markup is always larger. Converting:

$$\text{margin} = \frac{\text{markup}}{1 + \text{markup}} \qquad \text{markup} = \frac{\text{margin}}{1 - \text{margin}}$$

Snickers: $p = 1$, $c = 0.70$ → contribution $0.30$, margin **30%**, markup **43%**

## Break-even

$$Q_{BE} = \frac{F}{p - c}$$

Ignore sunk costs — only costs incurred *if* the project happens. Rack at $60 / $0.30 = **200 units**.

For a change in unit margin:

$$\frac{Q_{BE}^{\text{new}}}{Q^{\text{old}}} = \frac{\text{old contribution}}{\text{new contribution}}$$

## Cannibalisation

$$\text{Cannibalisation rate} = \frac{\text{old units lost}}{\text{new product units sold}}$$

$$\text{Cost of cannibalisation} = \text{units lost} \times \text{old unit margin}$$

$$BECR = \frac{\text{new product contribution}}{\text{old product contribution}}$$

> Trap: Actual rate $>$ BECR means the launch loses money.

## Kookaburra numbers

- Base unit margin $= (144.29\text{cr} - 80.81\text{cr}) / 7.83\text{ lakh} = $ **Rs 810.47**
- Post-cannibalisation Year 1: niche **(Rs 2.62 cr)**, mainstream **(Rs 3.45 cr)** — both losses
- Post-cannibalisation Year 2: niche **Rs 0.86 cr**, mainstream **Rs 4.12 cr**
- Niche Year 2 BECR $= 3.53\text{cr} / (1.5\text{ lakh} \times 810.47) = $ **0.29** against actual 0.22

## Break-even analysis is

A benchmark and a first step — not the sole criterion. Strategic, social and ethical factors sit alongside it, and the action should usually beat break-even inside a set time frame. Always run a **sensitivity analysis**.
$md$ where course_code = 'MKTG' and session = 3;

update public.learn_session_content set updated_at = now(), summary = $md$
## Where this session goes

You now have frameworks for the market and the arithmetic to test decisions. What is still missing is the customer — specifically, how they actually decide, and what happens when a firm misreads what its customers want from it.

## The 5 Cs, properly

| C | The question |
|---|---|
| **Customer** | Who are they — needs, wants, lifestyle, preferences, willingness to pay? And **how do they decide** — purchase type, stages, influencers? |
| **Company** | Core competence, strengths, weaknesses, goals |
| **Competition** | Who competes for our customers — their strengths, weaknesses, and **likely reactions to our actions** |
| **Context** | Regulation, economy, culture, technology |
| **Collaborators** | Who can help us, what can they do, and can they **capture enough value** by helping? |

Two of those cells are easy to skim past and shouldn't be. Competitors have *reactions* — a plan that assumes they stand still is not a plan. And collaborators need to make money from helping you, or they will stop.

Note also that the Customer box has two halves: who they are, and *how they decide*. The second half is the rest of this session.

> Prof: Willingness to pay links straight back to horizontal and vertical differentiation. Which attributes will a consumer pay more for, which do they merely want, and which do they not care about? Higher-income consumers pay for quality improvements; others will not.

## The customer decision-making process

Awareness of need → Identify alternatives → Get information about alternatives → Evaluate alternatives → **Purchase decision** → Use → Post-purchase evaluation.

The loop closes two ways. A positive post-purchase evaluation leads to **repeat purchase**. A negative one sends the customer back to identifying alternatives — which is to say, back to your competitors.

> Trap: The **acquisition/retention split happens at the purchase decision**. Everything before it is acquisition spend; everything after is retention. Exam questions test whether you know which side of that line a given activity sits on — and the boundary is where CLV, next session's topic, gets its two different formulas.

**Influencers** count too. Dave Carroll's father-in-law was a business consultant in New York whom Dave consulted regularly on important decisions. The person who decides, the person who pays and the person who influences are often three different people, and the 5 Cs Customer box is where you are supposed to notice that.

## United Breaks Guitars

United is one of the three largest airlines in the world. Its economy value proposition is **affordable connectivity** — mainstream, not premium.

2009 customer satisfaction: Southwest 81, Continental 68, Delta 64, American 60, US Airways 59, Northwest 57, **United 56 — last**.

In 2008 Dave Carroll, a musician, flew Halifax to Omaha and United broke his guitar. No compensation was offered. Fifteen months later, in 2009, he posted the video on YouTube. The VP of Customer Relations called and offered $2,400; Carroll declined; United donated $3,000 to a music school.

United responded publicly **only on Twitter**, and only to Dave and his team, in a sequence worth reading as a case study in what not to do — apology mixed with policy defence ("policy asks for claims w/in 24 hours"), over-familiarity ("I am now his BFF!"), and then the statistic: **"The fact is that 99.95% of our customers' bags are delivered on time and without incident."** The story was widely covered in the press and United did not respond anywhere else.

Carroll became a celebrity, made a fuss when his bag went missing on a later United flight, and wrote and posted two more songs about the airline.

### Should United improve customer service?

Every instinct says yes. Hold that instinct and weigh three things: the **service-profit relationship**, **vertical differentiation**, and **who the target segment actually is**.

> Prof: There will come a point where offering more customer service does not bring a return on investment. You should stop increasing it at that point. There is an optimal level of customer service for every product and service.

*Optimal*, not maximum. Service costs money, and for a price-driven segment that money comes out of the fare.

Vertical differentiation means that in a market where consumers differ in willingness to pay, firms deliberately offer higher and lower quality. Consumers who will not pay much consume the lower-quality option — and serving them properly at that price is a legitimate position, not a failure.

### Was the compensation appropriate?

Three questions, in order: what is the **objective** of the compensation, how much would be **enough**, and what are the **implications**? The third is the one that decides it. A payment large enough to satisfy a viral complainant is a payment you have now promised everyone with a camera.

> Trap: The expected answer is **not** "United should have apologised better." Highest possible customer service is not always desirable. Focus on your target segment and do what is right for you, not what others want you to do.

## Uber: pickup quality and ML

The other half of the session is about turning a vague complaint into something buildable.

Uber's pickup journey has six stages. Learn what each stage *is*, not only what goes wrong in it:

| Stage | What the stage does | Rider pain | Driver pain |
|---|---|---|---|
| **Contextualize** | Deduce where the rider is | The car passed me, I have to walk | I can't see the rider |
| **Assist** | Determine the best rendezvous location for the anchor location | Wrong pickup location, I have to coordinate | Rider is elsewhere, I loop around |
| **Depict** | Rendezvous location confirmed by the rider and passed to the driver | I'm at the location, the driver isn't | Rider is not where depicted |
| **Navigate** | Route the driver to the rendezvous location | Driver stopped on the wrong side | Lost time to bad navigation |
| **Track** | Let the rider track the car and act appropriately | The car icon spins, the ETA keeps changing | Rider cancels after I've driven minutes |
| **Meet** | Make sure rider and driver actually find each other | I can't find my car among all the Ubers | I can't find my rider in a crowd |

That table is the real deliverable. "Pickups are bad" is unbuildable; "the ETA keeps updating while the icon spins" is something an engineer can attack. Notice that the same event usually appears twice, once from each side — which is why fixing one side alone tends to move the problem rather than solve it.

$$\text{Pickup Quality} = \min\big[0.30\,(\text{ETA vs ATA}) + 0.20\,(\text{Driver idle}) + 0.30\,(\text{Location error}) + 0.20\,(\text{Cancellation})\big]$$

Two of the four components measure the *driver's* experience — a rider-only metric would have optimised the supply side into the ground. The follow-up question on the slide is the harder one: **how would you validate this metric?** Weights chosen in a room are a hypothesis, and validating them means checking that movements in the index actually track satisfaction and retention.

> Trap: A complete analysis requires doing this **for each of Uber's five target segments separately**. A single blended metric hides the segment where the experience is worst, which is usually the one about to churn.

### Building the model

Seven steps with three different owners, and who owns what is examinable.

**Business analyst leads**

1. **Define the business problem.** Flawed pickups cause rider and driver dissatisfaction and lost revenue.
2. **Evaluate whether ML is appropriate.** Uber has massive data, collected and analysed in real time, the predictors of pickup quality are not known with certainty, and no incremental investment is needed. Those are the conditions that make ML the right tool.
3. **Gather and label data.** First-party data from the app (ETA, ATA, driver idle time), proxy signals (cancellations, walking activity), third-party data (traffic, weather, road conditions) and direct user feedback.

**Data scientist leads**

4. **Preprocess data and define features.** Ingest from sensors, users and third parties, clean errors and missing data, then define features and the objective function.
5. **Select the ML approach and algorithms.** Supervised learning here — logistic regression, support vector machines, neural networks — assessed against each other.
6. **Engineer features and improve the model.** New input features, feature engineering, and ensemble methods that combine several techniques.

**UX leads**

7. **Make decisions and design the experience.** Trigger messages to riders about ETA or pickup-location changes, messages to drivers, real-time updates, automatic dashboard updates.

> Trap: "Evaluate if ML is appropriate" is an explicit step, not a formality. Plenty of pickup problems are fixed with better map data or a clearer UI and no model at all.

Takeaways: start with the customer and understand pain points across segments; use quantitative metrics to define success and train the models; build cross-functionally across business, data science and design; and think **"glocal"** — scaling globally demands a balance of local nuance and global strategy.
$md$, formula_sheet = $md$
## 5 Cs

| C | Question |
|---|---|
| Customer | Who they are **and how they decide** |
| Company | Core competence, strengths, weaknesses, goals |
| Competition | Strengths, weaknesses, **likely reactions** |
| Context | Regulation, economy, culture, technology |
| Collaborators | What they can do, and can they **capture enough value** |

## Customer decision-making process

Awareness of need → Identify alternatives → Get info → Evaluate → **Purchase** → Use → Post-purchase evaluation

- Positive evaluation → **repeat purchase**; negative → back to identifying alternatives
- **Acquisition** is everything before the purchase decision
- **Retention** is everything after

## Uber pickup

Stages: **Contextualize → Assist → Depict → Navigate → Track → Meet**

**Pickup Quality = Minimize [(0.30 × ETA vs ATA) + (0.20 × Driver Idle Time) + (0.30 × Pickup Location Error) + (0.20 × Ride Cancellation)]**

ML build: business analyst (define problem → is ML appropriate → gather and label data) → data scientist (preprocess and define features → select approach → engineer features and improve) → UX (decisions and experience)

## Service level

- There is an **optimal** level of customer service, not a maximum
- **Vertical differentiation** — deliberately serving low-WTP segments with lower quality is a strategy, not a failure
- Compensation: ask objective → how much is enough → **implications**
$md$ where course_code = 'MKTG' and session = 4;

update public.learn_session_content set updated_at = now(), summary = $md$
## What the case is for

Four things at once, and the slides say so up front: understanding customer needs and market opportunity well enough to make a **go / no-go** decision; developing a go-to-market plan for a new product; satisfying customer needs while watching the bottom line; and seeing how a **dominant player maintains its dominance**.

The decision: should Unilever launch a low-cost detergent for Brazil's low-income Northeast — a segment it has never served?

The case is designed to expose whether you actually believe low-income consumers are worth understanding, or merely worth pitying. Most people fail it on the first pass by assuming poor customers want cheap things.

## The 5 Cs, applied

Run the five, with two additions the slides call out:

- **Company** — and perform an **average margin analysis** across the existing portfolio, because you cannot compute cannibalisation cost without it
- **Competitors** — and consider the **Nirma experience** in India
- **Customers**, **Context**, **Collaborators**

## Why they cannot simply ignore the segment

> Prof: In the end Unilever's decision was quite simple. The mission is "to serve the needs of all people everywhere" — we are not a luxury brand company. And: never let what happened in India with Nirma happen again.

Nirma undercut Hindustan Lever from below and took enormous share. That is the strategic argument: a premium brand that abandons the bottom of the market does not leave it empty. It hands a competitor a base from which to attack upward.

So the question is not only "is this segment profitable?" but "what happens if we leave it to somebody else?" The three decision questions on the slide are exactly these: is this an attractive segment, can Unilever be competitive and make money in it, and what about cannibalisation.

## The customer insight that unlocks it

Northeast Brazil consumers are **price sensitive but also value conscious** — those are different things, and confusing them is the classic error.

> Worked example: Only **28% of households in Northeast Brazil owned a washing machine, against 67% elsewhere**. They wash by hand, using soap that yellows clothes, so they then need bleach. Cleaning power and whitening are not premium features to this customer — they are the core need, and hand-washing makes them matter *more*, not less.

> Trap: "Low income means they only want cheap" is wrong and it is the assumption that kills the launch. Price-conscious is not value-conscious. These customers will pay for the benefits that matter and refuse to pay for ones that do not — a more demanding customer than a rich one, not a less demanding one.

## The strategy: a positioning statement

The case uses a slightly shortened template:

> "For **<target segment>**, **<brand name>** offers better **<points of difference>** than **<other relevant competition>**, because it is **<reason>**."

## The branding decision

Should Unilever use an existing brand? Four options were on the table: reposition **Omo** downward, reposition **Minerva**, reposition **Campeiro**, or extend Omo or Minerva. Unilever ultimately created a **new brand, Ala**, positioned between Minerva quality and Campeiro cheapness.

The cost of that choice is explicit:

| Choice | Incremental cost per kg |
|---|---|
| Reposition an existing brand | — |
| Extend an existing brand | $0.05 |
| **Launch a new brand** | **$0.10** |

They chose the most expensive option. Protecting Omo was worth ten cents a kilo.

## The marketing mix: three coherent packages

The sensitivity analysis on the slide is not a menu of independent choices. It is three complete packages for a 500g pack, and the middle one is easy to miss:

| | Like Minerva | New Process | Like Campeiro |
|---|---|---|---|
| Formula cost | 1.40 | **1.00** | 0.90 |
| Packaging | Cardboard, 0.35 | — | Plastic, 0.10 |
| Price as % of Omo | 60% | **55%** | 50% |
| Price $/kg | 1.80 | **1.65** | 1.50 |
| Promotion | Primarily above the line (ATL), 0.15 | — | Primarily below the line (BTL), 0.05 |
| Distribution | Wholesalers, 0.10 | — | Distributors, 0.05 |

Read that as a set of coupled decisions. A premium formula with below-the-line promotion and distributor reach is not a coherent product — it costs like a good detergent and reaches customers like a cheap one.

**ATL** is mass media (TV, print, radio) aimed at broad awareness; **BTL** is targeted and direct — sampling, in-store, trade promotion. The choice follows the segment, not the budget.

## Break-even cannibalisation

$$BECR = \frac{\text{new unit margin}}{\text{old unit margin}} \qquad \text{Cannibalisation rate} = \frac{\text{volume lost from existing Unilever brands}}{\text{volume from the new brand}}$$

Compute Unilever's current average margin per kg and the new product's margin per kg, then compare.

> Trap: Unilever loses money if the actual cannibalisation rate is **above** the BECR. New volume has to come from **competitors or from category expansion** — volume taken from your own brands is a transfer to a worse margin, not growth.

## Takeaways

- **Make what you can sell, not sell what you can make**
- Find the right positioning and build to it
- Marketing to low-income consumers does not have to be charity — it can be profitable, but it is challenging
- **Be disciplined**: deliver the important customer benefits, and only those. The discipline is in what you leave out.
- Be willing to **re-engineer your marketing mix** and to **break company norms**
- Keep the distinction between price conscious and value conscious
- Look at your business through your customers' eyes

## Chain-store paradox

A side note on why an incumbent might fight even when fighting costs it money. Payoffs are (entrant, incumbent):

| | Incumbent fights | Incumbent accommodates |
|---|---|---|
| Entrant enters | −$2M, −$2M | $2M, $2M |
| Entrant stays out | 0, $5M | |

Fighting is worse for the incumbent in this single game — accommodating pays $2M, fighting loses $2M. In **repeated** interactions it pays anyway, because the reputation deters the next entrant. Reputation matters in repeated interactions, and that is the Nirma lesson seen from the incumbent's side.

## Product lifecycle

Five stages: **product development → introduction → growth → maturity → decline**.

Sales and profit are two separate curves. During development sales are zero and the firm is spending, so profit is negative. Profit turns positive during growth and **peaks before sales do**, then falls through maturity as competition drives price down, while sales are still climbing. A product can be growing and getting worse as a business at the same time, which is why "sales are up" is never an answer on its own.

## Branding

A brand is a marketing device designed to create value **above and beyond the core product or service benefits**. It matters across all three goods types, and the differences are worth knowing:

| Goods type | When quality is known | Why brand matters |
|---|---|---|
| **Search** | Before buying, by inspection | Least dependent on brand — you can just look |
| **Experience** | Only after using | Brand carries the promise you cannot verify first |
| **Credence** | Possibly never, even after use (medicine, financial advice) | Brand is close to the only signal available |

**Brands create value for the organisation** by increasing the effectiveness of marketing actions and by becoming a separable company asset — something that can be sold, licensed or valued on its own.

**Brands create value for customers** by identifying the offering, differentiating it from competitors, serving as a credible quality signal, and offering emotional, social and self-expressive benefits — through positive associations and through the brand's ability to express who the user is.
$md$, formula_sheet = $md$
## Break-even cannibalisation

$$BECR = \frac{\text{new unit margin}}{\text{old unit margin}}$$

$$\text{Cannibalisation rate} = \frac{\text{volume lost from existing brands}}{\text{volume of the new brand}}$$

Lose money when actual rate $>$ BECR. New volume must come from **competitors or category growth**.

## Positioning statement (Prof's S5 variant)

> "For **<target segment>**, **<brand>** offers better **<points of difference>** than **<relevant competition>**, because it is **<reason>**."

## Brand option costs (per kg)

Reposition existing **—** · Extend existing **$0.05** · **New brand $0.10**

## The three mix packages

| | Like Minerva | New Process | Like Campeiro |
|---|---|---|---|
| Formula | 1.40 | 1.00 | 0.90 |
| Packaging | Cardboard 0.35 | — | Plastic 0.10 |
| % of Omo price | 60% | 55% | 50% |
| $/kg | 1.80 | 1.65 | 1.50 |
| Promotion | ATL 0.15 | — | BTL 0.05 |
| Distribution | Wholesalers 0.10 | — | Distributors 0.05 |

## Key distinction

- **Price conscious** — wants the lowest price
- **Value conscious** — pays for benefits that matter, refuses those that do not

## Brand value

- To the firm: marketing effectiveness + a **separable asset**
- To the customer: identification, differentiation, quality signal, emotional/social/self-expressive benefit
- **Search** goods (verify before) · **experience** goods (verify after) · **credence** goods (never verify)

## Product lifecycle

Development → Introduction → Growth → Maturity → Decline. Profit peaks **before** sales.
$md$ where course_code = 'MKTG' and session = 5;

update public.learn_session_content set updated_at = now(), summary = $md$
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

- **Vertical brand extension** — greater benefits at a higher price (upscale offering), or fewer benefits at a lower price (downscale offering). Moves along the price-benefit line, staying in the category.
- **Horizontal brand extension** — often a **different category at a similar price**. Same price point, new shelf.

Downscale vertical extensions are the dangerous ones: they reach more customers and quietly redefine what the brand means.

## Brand repositioning

Changing the meaning of the brand — moving it on the price-benefit map rather than adding a second offering. Amazon, Starbucks and Spotify have all done it. Three reasons to: the **target market changed**, **competitors acted**, or the **context changed**.

The distinction from extension is worth holding: an extension adds an offering and keeps the old one; repositioning moves the one you have.

## Co-branding and brand-image spillover

Brand images of partnering brands spill onto each other. The benefit is **brand image transfer**; the risk is **brand confusion**.

> Worked example: **(RED) in 2007** is the standing example of co-branding gone wrong — Converse, Apple, Gap, American Express, Motorola and Armani Exchange all pointing at the same mark at once. With that many partners the association stopped meaning anything in particular, which is the failure mode: not damage, dilution.

## Luxury branding

Luxury brands signal status, on a spectrum from **loud luxury to subtle luxury**. The signalling instruments are logo design and size, the 4 Ps lined up behind them, and the **brand story**.

Consumer segments nest by increasing wealth — and the wealthier the segment, the more subtle the signal tends to become, because the point of a signal is to be legible to the people who matter and invisible to those who do not. Session 9's counter-signalling idea is the same mechanism seen from the advertising side.

## Customer lifetime value

Now the second asset. CLV is the **net present value of future contributions from a customer**. A mobile operator spends $400 to acquire a customer who pays $250 a year in margin. Good deal? Most people answer instantly and most answer wrong, because it depends on three things nobody mentioned.

Build it in three steps.

**Step 1 — no churn, no discounting.** AC $400, contribution $250/year, five years.
CLV net of acquisition cost $= 1{,}250 - 400 = $ **$850**

**Step 2 — add churn.** Probability of losing a customer is 0.2 each year, so retention $r = 80\%$ and year $t$'s expected contribution is $250 \times 0.8^t$.
$200 + 160 + 128 + 102 + 82 - 400 = $ **$272**

**Step 3 — add discounting.** Discount rate $d = 10\%$, so divide each expected contribution by $1.1^t$.
$182 + 132 + 96 + 70 + 51 - 400 = $ **$131**

> Trap: Notice how fast the number falls — $850 to $272 to $131 on the same customer. Almost all of that is churn, not discounting. If you forget the retention factor you will overstate CLV by roughly 3×, which is enough to justify an acquisition strategy that destroys value.

### The general formula

$$\text{CLV}_{\text{existing}} = \sum_{t=1}^{T} \frac{m_t \cdot cr_t}{(1+d)^t} \qquad \text{CLV}_{\text{new}} = \sum_{t=1}^{T} \frac{m_t \cdot cr_t}{(1+d)^t} - AC + m_0$$

where $m_t$ is the margin at time $t$, $cr_t$ is the **cumulative retention factor** (the probability the customer is still there at $t$, which is $r^t$ when retention is constant), $d$ is the discount rate and $T$ the horizon.

Under an infinite horizon with constant $m$, $r$ and $d$ the sum collapses:

$$\text{CLV}_{\text{existing}} = m\left(\frac{r}{1 + d - r}\right) \qquad \text{CLV}_{\text{not yet acquired}} = m\left(\frac{r}{1 + d - r}\right) - AC + m_0$$

> Worked example: $m = 250$, $AC = 400$, $r = 80\%$, $d = 10\%$, $m_0 = 0$.

$$\text{CLV} = 250\left(\frac{0.80}{1 + 0.10 - 0.80}\right) - 400 = 250\left(\frac{0.8}{0.3}\right) - 400 = 667 - 400 = \mathbf{267}$$

Look at the denominator, $1 + d - r$: retention sits right beside the discount rate and moves the answer far more, because it compounds against every future year at once. That is why "reduce churn" outranks almost everything else in a mature subscription business.

### What the simple formula hides

- **Higher contributions in future years** — individual customers spend more over time, and cost efficiencies improve the margin
- **Different retention rates in future years** — retention rises with lock-in and falls if customers are dissatisfied
- **Customer heterogeneity** — when customers with different retention rates and margins are mixed together, a blended CLV is not the CLV of anybody. Estimating it properly means segmenting first.

### What CLV is for

Deciding how and when to **acquire** an individual customer, **retain** one, **fire** one, or acquire an entire customer base or company. That third option is the one people forget: if a customer's CLV is negative, serving them better is not the answer.

It shows up in video streaming (Netflix, Disney+, Amazon Prime Video, where CLV tracks market cap), financial services (JPMorgan Chase, Morgan Stanley), mobile carriers (AT&T, T-Mobile), Medtronic insulin pumps, HP printers and toner, and consumer packaged goods (Gillette, P&G's Swiffer). Every razor-and-blade model is a CLV bet: lose money on the device, make it back over the retained lifetime.
$md$, formula_sheet = $md$
## CLV, built up

**No churn, no discount:** $\ \text{CLV} = (m \times T) - AC$

**With churn:** each year's expected contribution is $m \cdot r^t$

**With churn and discounting:**

$$\text{CLV} = \sum_{t=1}^{T} \frac{m_t \cdot cr_t}{(1+d)^t} - AC + m_0$$

$cr_t$ = cumulative retention factor ($= r^t$ when $r$ is constant)

## Infinite horizon (constant $m$, $r$, $d$)

$$\text{CLV}_{\text{existing}} = m\left(\frac{r}{1 + d - r}\right)$$

$$\text{CLV}_{\text{not yet acquired}} = m\left(\frac{r}{1 + d - r}\right) - AC + m_0$$

$m$ = margin · $r$ = retention rate · $d$ = discount rate · $AC$ = acquisition cost · $m_0$ = margin at time 0

Mobile plan: $250 \times (0.8/0.3) - 400 = 667 - 400 = \mathbf{267}$

> Trap: Churn matters far more than discounting. Forgetting $r$ overstates CLV roughly threefold.

## What CLV decides

Acquire · retain · **fire** · buy an entire customer base

## Brand architecture

- **House of brands** — more positioning room, failures contained, costly to run
- **Branded house** — communication efficiency, instant transfer, dilution risk
- **Vertical extension** — more/fewer benefits at a higher/lower price, same category
- **Horizontal extension** — different category, similar price
- **Repositioning** — move the existing brand's meaning (target changed, competitors acted, context changed)
- **Co-branding** — benefit is image transfer, risk is brand confusion
$md$ where course_code = 'MKTG' and session = 6;

update public.learn_session_content set updated_at = now(), summary = $md$
## Where this session goes

Two topics that both answer the question "how does value actually reach the customer, and who captures it along the way?" — first the channel, then the price.

## Distribution is the expensive P

Creating and communicating value is not enough; the firm has to make the product **available** for purchase. Distribution decisions both facilitate and influence the purchase decision — look back at the customer decision-making process from Session 4 and note that place touches nearly every stage, not only the purchase box.

Place is often the **most expensive of the 4 Ps**, and most firms do not realise it, because the cost is buried in margin given away rather than money spent.

## Direct versus indirect

**Indirect channel**: Manufacturer → Retailer → Consumer.
**Direct / vertically integrated channel**: Manufacturer (owning retail) → Consumer.

Which one is better depends on six questions, each with a piece of theory behind it:

| Question | Related concept |
|---|---|
| Which gives a **lower price to consumers**? | Double marginalisation |
| Which gives **better retail customer service**? | Moral hazard in teams |
| Which gives **higher total profits** to the firms? | Mergers, collusion |
| Which gives **better control of the 4 Ps**? | DIY versus delegation |
| Which risks **technology or skills leaking** to rivals? | — |
| Which better **preserves consumer loyalty** to the product? | — |

### Why use retailers at all

Because they supply services that would be very costly for a manufacturer to provide: geographical coverage, infrastructure (trucks, stores), customer access and information, in-store and after-sales service, and plain competency at retailing. Vertical integration means building all of that from nothing.

## Double marginalisation, and three fixes

Here is the problem that makes channels interesting. The manufacturer marks up over its cost, then the retailer marks up again over that. The final price ends up **higher than the price a single integrated firm would set** — and both parties earn less than they would have.

That is worth pausing on: it is not a fight over the split. Both sides lose. The structure itself destroys value, because each party sets its margin without accounting for the volume the other loses.

Three fixes for this **vertical** conflict:

1. **Price ceiling** — a maximum suggested retail price (MSRP)
2. **Two-part tariff** — the retailer pays a fixed upfront fee plus a per-unit price equal to the **manufacturer's marginal cost**
3. **Co-provision of retail service, or revenue-sharing incentives**

> Trap: The two-part tariff works because setting the per-unit price at marginal cost removes the retailer's incentive to mark up — the retailer now behaves like an integrated firm. The manufacturer takes its profit through the fixed fee instead. Get the per-unit price wrong and you have reintroduced the whole problem while adding a fee.

## Horizontal channel conflict

Conflict between players at the same level, with a fix for each:

| Conflict | Fix |
|---|---|
| Retailers competing with each other | **Exclusive territories** |
| A retailer pushing a rival manufacturer's product | **Exclusive dealing** |
| Showrooming and webrooming | Set the incentive structure to **promote rather than inhibit** it |

That last one is the modern case. Showrooming is inspecting in-store and buying online; webrooming is researching online and buying in-store. Both are going to happen; the choice is whether your incentives fight the behaviour or capture it.

## Economic value to the customer

Now pricing, and the single most valuable question in it: **what would this customer do if we did not exist, and what would that cost them?**

EVC does three jobs: it **sets the price** of new products and services, it **identifies potential competitors** (whoever supplies the reference value is your competitor, whether or not they are in your category), and it **identifies segments and targets** (customers whose alternatives differ have different EVCs, which is value-based segmentation).

Cost-plus pricing asks what the product cost you. The customer does not care. EVC builds the price from their side of the table:

$$\text{EVC} = \text{Reference value} + \text{Net differential value}$$

- **Reference value** — the customer's cost of using the next-best alternative
- **Net differential value** — the extra value your product creates, **minus** any extra costs it imposes

> Prof: Competitors are not always obvious. Soap can compete with entertainment for the same rupee.

Identify the wrong reference and every number after it is anchored to the wrong thing.

### Worked example: UNO washable diapers

A premium washable diaper that requires no anti-rash cream. Variable cost **₹400/unit**; one diaper lasts a month, against disposables used 4/day at ₹15 each.

| Component | Working | Value |
|---|---|---|
| Reference value — cost of disposables | $30 \times 4 \times 15$ | **₹1,800/month** |
| Benefit: no anti-rash cream needed | | +₹500 |
| Cost: more washing | | −₹100 |
| **Net differential value** | $500 - 100$ | **+₹400** |
| **Total EVC** | $1{,}800 + 400$ | **₹2,200/month** |

Note what the reference value is: money the parent is *already spending* without thinking of it as a price. That is why it anchors so well.

### Turning EVC into a price

**EVC is the ceiling (₹2,200). Variable cost is the floor (₹400).** The price range between them is ₹1,800 wide, and the slide splits it down the middle — ₹900 to the firm, ₹900 left with the customer:

$$\text{Price} = 400 + \frac{2{,}200 - 400}{2} = \mathbf{₹1{,}300}$$

> Trap: EVC is the **maximum defensible price**, not the recommended price. Charging the full ₹2,200 leaves the customer exactly as well off as before — no reason to switch, and every reason to resent it if they do. You have to share the value you created. The ₹1,300 midpoint is a starting point, then adjusted for competitive pressure.

### Doing an EVC analysis properly

- Carefully identify the different benefits the offering provides — and ask whether there are any **costs** as well
- **Quantify** the benefits rather than listing them
- Consider that consumers may value the offering differently — **value-based segmentation**
- Be prepared for a **competitive response**, and be prepared to **defend your recommendation**

### Why EVC works better in B2B

In B2B you can show the customer the calculation directly, and they have a procurement team that thinks in those terms. In B2C, consumers do not internalise the full value, so the **perceived** EVC sits below the actual one — and perceived value is what sets your real ceiling.

> Trap: If you cannot communicate the value, you cannot charge for it. For genuinely new products with no clear reference, market research — focus groups, small-market pilots, conjoint — is essential. Firms that rely on internal estimates routinely misjudge willingness to pay.
$md$, formula_sheet = $md$
## EVC

$$\text{EVC} = \text{Reference value} + \text{Net differential value}$$

$$\text{Net differential value} = \text{extra benefits} - \text{extra costs}$$

- **Reference value** = cost of the customer's next-best alternative
- **EVC** = price **ceiling**; **variable cost** = price floor
- Start at the midpoint, then adjust for competition

UNO diaper: reference $30 \times 4 \times 15 = ₹1{,}800$; net differential $500 - 100 = ₹400$; **EVC = ₹2,200**; floor ₹400; midpoint price **₹1,300**

**EVC's three uses:** price new products · identify potential competitors · identify segments and targets

> Trap: EVC is the maximum defensible price, not the recommendation. Share the value or nobody switches.

## Channel

- **Indirect** Manufacturer → Retailer → Consumer · **Direct** Manufacturer(+Retailer) → Consumer
- **Double marginalisation** — two successive markups push the final price above the integrated optimum and both firms earn less
- Vertical fixes: **price ceiling / MSRP** · **two-part tariff** (fixed fee + per-unit at marginal cost) · **co-provision / revenue sharing**
- Horizontal fixes: **exclusive territories** (retailer vs retailer) · **exclusive dealing** (retailer favouring a rival) · incentives that work *with* showrooming and webrooming
- Why retailers: coverage · infrastructure · customer access · in-store and after-sales service · competency

## Channel choice, six questions

Lower consumer price (double marginalisation) · better retail service (moral hazard in teams) · higher firm profits (mergers, collusion) · control of the 4 Ps (DIY vs delegation) · technology leakage · consumer loyalty
$md$ where course_code = 'MKTG' and session = 7;

update public.learn_session_content set updated_at = now(), summary = $md$
## Where this session goes

Last session gave you EVC — a ceiling built from the customer's alternative. This session puts it to work on a real pricing decision, then generalises to the rule that governs every price you will ever set.

## Price as a profit driver

**Price is the most important profit driver**, and pricing decisions are also considered the hardest marketing decisions. The reason is informational: firms lack good information about their own costs, about the benefits or value the product delivers to consumers, and about the key drivers of the purchase decision itself.

Everything else in this session is an attempt to replace one of those three missing pieces with something measurable.

## EVC, restated and limited

EVC is the **monetary value placed on the benefits and cost savings** provided by a product — always *relative to some existing technology*, and *for a specific customer and application*. Change the customer or the use case and the number changes with it.

> Trap: The limitation is that buyers may not "buy" your EVC calculation. They often do not fully understand or know their own cost structure, so a number that is correct can still be unpersuasive. This is exactly what happens next in Atlantic.

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

A price recommendation that ignores everyone else's reaction is half an answer.

- **Consumers will resist.** The software was free before; charging about $1,400 for it will cause backlash, and customers will ask for evaluation contracts before committing.
- **Consumers run their own numbers**, which will not match yours. Labour savings may be zero if existing staff simply absorb the extra servers — which is why Atlantic uses a **2× multiplier rather than 4×**, deliberately conceding value to allow for customer conservatism.
- **Zinc will cut prices**, possibly from a $1,700 reference down to $1,200–$1,400. Be ready for a price war.
- Zinc may build its own performance software, so Atlantic has to keep innovating.

> Prof: Even if Zinc cuts its margin to zero, the Atlantic bundle still creates more value for the consumer. That is the point of value-based pricing.

## The golden rule of pricing

$$\frac{p - mc}{p} = \frac{1}{\varepsilon}$$

The left side is **percent margin**, which is a measure of market power. $\varepsilon$ is the **price elasticity of demand**. The rule: the higher the elasticity, the lower the price. Higher price sensitivity, lower price.

Plainly: if consumers keep buying when you raise the price, raise the price.

## What price sensitivity depends on

Seven factors from the slide. Note how many are design or positioning decisions rather than facts about the market:

| Factor | Raises or lowers sensitivity |
|---|---|
| **Awareness/availability of substitutes** | More substitutes → more sensitive |
| **Ease of direct comparison** | Easier to compare → more sensitive |
| **Expenditure** (relative value in the bundle) | Large share of total spend → more sensitive |
| **Shared cost** (employer or insurer pays part) | Someone else pays → less sensitive |
| **Switching cost** | High switching cost → less sensitive |
| **Price/quality inference** | Price reads as quality → less sensitive |
| **Ability to carry inventory** | Can stockpile at a discount → more sensitive |

> Trap: **Elasticity and sensitivity are not the same word.** Elasticity is a measurable number you put into a formula. Sensitivity is qualitative — "more" or "less". Exam questions use the words precisely, so a question about sensitivity is not asking you to compute anything.

## Measuring price sensitivity

Two dimensions: what you measure, and the conditions you measure it under.

| Variable measured | Natural conditions | Experimental conditions |
|---|---|---|
| **Actual purchase** | **Sales data** | **Field experiments**, **laboratory experiments** |
| **Preferences / intentions** | **Surveys** | **Trade-off analysis (conjoint)** |

The trade-off runs diagonally. The top-left cell is the most real and the least controlled — sales data tells you what people did, but you never varied the price cleanly. The bottom-right is the most controlled and the least real — conjoint gives you a precise elasticity for a purchase nobody actually made.

## Price discrimination

If different customers have different elasticities, one price leaves money on the table for some and loses sales among others.

| Degree | Basis | Example |
|---|---|---|
| **First** | Individual | Personalised pricing, one price per buyer |
| **Second** | Self-selection off a menu (including **bundling**) | Business vs economy class, bundle vs unbundled |
| **Third** | Observable segment | Student and senior discounts |
| **Behavioural** | Observed past behaviour | Amazon inferring sensitivity from purchase history |
| **Inter-temporal** | Time | Skimming downward, or rising prices for network-effect products |

> Worked example: Bundling is second-degree discrimination. It works by combining **negatively correlated valuations** — you value A highly and B little, I am the reverse, so a single bundle price extracts more from both of us than separate prices would, because each of us is mostly paying for the half we wanted.

## Psychological aspects of pricing

- **Prices ending in 9 or 99.** Nike shoes at $79.99 rather than $80. The theoretical underpinning is **mental categorization** — $79.99 lands in the "seventies" bucket, and the one cent is irrelevant.
- **Higher price means more value.** A higher price raises perceived and even experienced quality; the MRI wine study showed the brain responding differently to identical wine at a higher stated price. People were not lying about enjoying it more.
- **Prospect theory**: losses loom larger than gains, so **unbundle gains and bundle losses**. Present savings separately and costs together.

## Exam format

> Prof: The final is **MCQ only, half quantitative and half qualitative**, written on paper with OMR sheets. **One cheat sheet is allowed — both sides, printed or handwritten.** Basic calculators are permitted. Questions differ across sections. The cases were taught for conceptual learning, not for memorising case facts.
$md$, formula_sheet = $md$
## Golden rule of pricing

$$\frac{p - mc}{p} = \frac{1}{\varepsilon}$$

Percent margin (market power) equals one over price elasticity. Higher elasticity → lower price.

## EVC vs value-in pricing

- **EVC-based** — anchors on **variable cost** as the floor, then splits floor-to-ceiling
- **Value-in** — anchors on the **current market price**, then splits the gap to EVC
- Value-in always gives a higher number
- EVC limitation: buyers often do not know their own cost structure, so they may not accept the calculation

## Price sensitivity, seven drivers

Availability of substitutes · ease of direct comparison · expenditure as share of bundle · shared cost · switching cost · price/quality inference · ability to carry inventory

## Measuring price sensitivity

| Variable measured | Natural | Experimental |
|---|---|---|
| Actual purchase | Sales data | Field & laboratory experiments |
| Preferences / intentions | Surveys | Trade-off analysis (conjoint) |

## Price discrimination

1st individual · 2nd self-selection (**bundling**) · 3rd observable segment · behavioural · inter-temporal

> Bundling works on **negatively correlated valuations**.

## Psychological

- Charm pricing ($79.99) works via **mental categorization**, not the cent
- Higher price → higher perceived *and experienced* quality
- Prospect theory: **unbundle gains, bundle losses**
$md$ where course_code = 'MKTG' and session = 8;

update public.learn_session_content set updated_at = now(), summary = $md$
## Where this session goes

Everything so far has been about deciding what to offer and what to charge. This last session is about telling people — and about the fact that most advertising measurement is less trustworthy than it looks.

## Golden rule of advertising

$$\frac{A}{pQ} = \left(\frac{p - c}{p}\right) \times \epsilon_{DA}$$

$A$ is advertising expenditure, $pQ$ is revenue, $(p-c)/p$ is percent margin and $\epsilon_{DA}$ is the elasticity of demand with respect to advertising. So: **advertise more if you make a lot of money on every unit sold, and if demand is genuinely sensitive to advertising.**

Both terms must be present. A high-margin product whose purchases nobody's advertising influences does not justify the spend, and neither does a highly ad-responsive product with no margin in it.

## S-curve of advertising effectiveness

Advertising effectiveness against advertising expenditure is an **S**: nearly flat at low spend, then a steep responsive middle, then flat again at saturation.

Spending below the threshold is worse than not spending — you pay without ever crossing into the range where anything happens. Spending past saturation buys nothing.

> Worked example: **Counter-signalling.** Established brands reduce logo prominence — Starbucks and Lululemon both did it. It works because only a brand everyone already recognises can afford to stop shouting. Under Armour tried it and failed, because it had not yet earned the recognition that makes restraint legible.

## Four roles of advertising

Advertising is not one activity. Knowing which role you are playing determines what "good" looks like.

- **Informative** — tell people the product exists and what it does
- **Persuasive** — change preference
- **Money-burning** — the spend **itself** is the signal. Visible expense says deep pockets, long-term commitment and confidence in quality; it also intimidates competitors and suppliers.
- **Reminder (ad pulsing)** — refresh memory for a brand everyone already knows, like Coca-Cola, in bursts rather than continuously

The third one is the least intuitive and the most interesting: the message can be almost irrelevant, because what carries information is that you could afford to send it at all.

## The communications toolkit

The slide lays out every instrument available, and knowing the categories matters more than knowing any one of them.

**Mass and targeted media** — TV, digital, print, outdoor.

- **Advertising**, which splits into **outbound** (you go to them) and **inbound** (they come to you — digital, search)
- **Product placement**, which splits into **screen placement** (the product is visible) and **script placement** (the product is mentioned in dialogue)
- **Public relations** — press releases, influencers, public events, and managing a crisis

**Personal and interpersonal means**

- **Sales force**
- **Word of mouth**, offline and online. **Offline word of mouth is 41% more persuasive** than online.

## India media context (2024)

Two facts that pull in opposite directions, which is why they are on consecutive slides.

**Time spent per day with media** totals 6:17 — TV 3:12, digital 2:30, print 0:19, radio 0:16. TV still wins attention.

**Total media ad spending** — digital **$4.92B**, TV $4.45B, newspaper $2.40B, radio $0.41B, out-of-home $0.37B, magazine $0.12B. Digital has already passed TV in money despite trailing it in time.

**Digital ad spending by format** — display **$2,975M**, search $1,765M, classified $177M. For reference, in the USA search is 38.8% and display 27.7%, the reverse ordering.

So Indian digital budgets are buying **awareness** where American ones are buying **intent**. That is a positioning fact about a whole market, and it changes what the same rupee does.

## Developing a communication plan: the 7 Ms

The first two come from your STP work; the remaining five are the communications decisions.

| | M | The question |
|---|---|---|
| 1 | **Markets** | Who should I talk to? (target segment) |
| 2 | **Message content** | What should I tell them? (key benefit / positioning) |
| 3 | **Mission** | What are we trying to influence? Awareness, Interest, Desire, Action |
| 4 | **Message design** | How should I say it? (creative team) |
| 5 | **Media strategy** | How do I reach them? |
| 6 | **Money** | How much do I need to spend? |
| 7 | **Measurement** | Was it worth it? |

> Trap: Markets and message content are **not** communications decisions — they are STP decisions you inherit. If the answer to "who are we talking to" is being invented during the campaign brief, the problem is upstream.

## Mission and the hierarchy of effects

Mission means picking which stage you are trying to move: **Awareness → Interest → Desire → Action**.

The two source types cross over in the middle. **Mass media sources (advertising)** are most efficient at awareness and interest. **Personal and interpersonal sources (personal selling, word of mouth)** are most efficient at desire and action.

> Trap: **Mission drives media choice.** Buying mass media to close a sale, or a sales force to build awareness, is paying premium rates for the wrong half of the curve.

## Message design

**Rational appeals** — product demonstration, use of a spokesperson, testimonials, product comparison (comparative or combative advertising).

**Emotional appeals** — negative emotions (fear), positive emotions (happiness, affection, humour), kids and family settings.

**Subliminal appeals** — there is **no evidence they work**.

> Trap: Avoid combative advertising unless you can actually kill the rival. A public fight usually benefits the **third player** who stayed out of it — the same dynamic as BMW and Audi handing the market to Japanese cars. Also avoid negative associations with your own product, even in a joke.

## Media planning

Three types of media, and the distinction is about who owns the channel:

- **Paid** — you bought the placement (advertising)
- **Owned** — you own the channel (your website, your app, your store, your email list)
- **Earned** — someone else gave it to you for free (press coverage, word of mouth, shares)

Then choose the medium your target market actually uses.

## Money: measuring advertising quantity

- **Reach** — the percentage of the population exposed to the message **at least once**
- **Frequency** — the average number of times a reached individual has been exposed
- **Gross Rating Points (GRPs) = Reach × Frequency**

> Worked example: An ad seen by 20% of households, an average of 3 times during the campaign, delivers **60 GRPs**.

> Trap: The same 60 GRPs could be 60% reach × 1 exposure — a completely different campaign with a completely different effect. GRPs are a budget unit, not a strategy.

## Money: setting the advertising budget

Four methods, roughly in increasing order of defensibility:

1. **Percentage of sales** — simple, and backwards: it cuts spend exactly when sales fall
2. **Match (or better) competition** — lets a rival set your budget
3. **Objectives and tasks** — decide what has to be achieved, then cost the tasks that achieve it
4. **Parfitt-Collins model** — work backwards from the market share you need

### Parfitt-Collins

$$\%\text{Aware} \times \%\text{Try} \times \%\text{Repeat} = \%\text{Market share}$$

It **multiplies**, so missing any one gate collapses the share regardless of the other two.

> Worked example: You need a 6% break-even market share. Research says 30% of those aware will try, and 40% of triers become repeat buyers.
> $[A] \times 0.30 \times 0.40 = 0.06 \implies [A] \times 0.12 = 0.06 \implies [A] = \mathbf{0.50}$
> **50% of the market must become aware.** Now go and buy that awareness with reach, frequency and GRPs.

Now you have a media brief rather than an argument. And if the required awareness comes out above 100%, the plan is impossible — which tells you the problem is trial or repeat, and those are product problems that no budget fixes.

## Measurement

- **Pre-launch tests** of the creative strategy
- **Physiological response measures** — galvanic skin response, eye-tracking, fMRI
- **Starch scores** for print advertising: **Noted**, **Associated**, **Read**
- **Day-after recall** for TV advertising
- **Cross-market tests** — increase GRPs in one market and measure the response against another
- **Google Analytics** and the rest of the digital stack

## Six rules for the copy itself

Unglamorous, and directly examinable:

1. Show the product
2. Mention the brand name
3. State the positives
4. Show the product in use
5. Avoid unpleasant connections with your product
6. Tell people where and how they can buy it

## Cheap-talk communication

> Prof: Talk is cheap. Do not trust cheap talk when interests are completely misaligned. Demand proof or a contract.

The Peanuts example: Charlie Brown can accept or reject Lucy's offer to hold the football, and Lucy can let him kick or pull the ball away. Her promise costs her nothing to make and nothing to break, so it carries no information. Compare that with money-burning advertising, which is believable precisely *because* it is expensive.

## Takeaways

- Align your communication strategy with your positioning and every element of the marketing mix
- A great campaign is a key element of your marketing plan, but it is not all of it. It may occasionally help you sell what you can make — but it does wonders if you **make what you can sell**
- Define the mission and the metrics **before** spending a penny

## Air France: sponsored search

Four case questions: uniform or tailored strategy across search engine publishers for higher ROA; whether campaign tactics or copy should be adjusted; which KPIs matter most; and whether **Kayak** belongs in future SEM campaigns.

Standard digital KPIs are CPC, CTR and TCR. To those add **ROA**, average revenue per booking, and probability of booking.

> Trap: The 1000% ROA figures in the case reflect **attribution error**, not real returns. A customer who was always going to book searches for the airline, clicks the paid link above the organic one, and books — and the campaign claims a booking it did not cause. Spotting that is the point of the question.

The method the case teaches, in order: **summarise campaign metrics → optimise publisher strategy → optimise campaign strategy → calculate KPI impact → act on recommendations to measure the assumptions.**

Segment publishers by **probability of booking × CPC**. Then diagnose: a low CTR is an **ad** problem, a low TCR is a **website** problem. That split is the most reusable idea here, because it tells you which team owns the fix.

Kayak is the odd one out: it charged a flat listing fee rather than bid-based CPC, so comparing its return to auction-based publishers compares two different things.

Because digital campaigns give almost immediate access to data and can be halted or modified on the fly, **testing recommendations is not risky** — which changes what a good recommendation looks like. Not "here is the answer," but "here is the test, here is what we learn, here is when we stop."

> Prof: The remaining Air France slides were deferred and **will not appear on the final exam**.
$md$, formula_sheet = $md$
## Golden rule of advertising

$$\frac{A}{pQ} = \left(\frac{p - c}{p}\right) \times \epsilon_{DA}$$

Ad spend as a share of revenue = percent margin × advertising elasticity. Advertise more when margin is high **and** demand is ad-sensitive.

## The 7 Ms

STP: 1 **Markets** · 2 **Message content**
Communications: 3 **Mission** (Awareness → Interest → Desire → Action) · 4 **Message design** · 5 **Media strategy** · 6 **Money** · 7 **Measurement**

Mass media wins **awareness and interest**; personal selling and word of mouth win **desire and action**.

## Media

- **Paid** (you bought it) · **Owned** (you own it) · **Earned** (given to you)
- Advertising: outbound vs inbound (digital, search) · product placement: screen vs script · PR: releases, influencers, events, crisis
- **Offline word of mouth is 41% more persuasive** than online

## Money

$$\text{GRP} = \text{Reach} \times \text{Frequency}$$

20% reach × 3 exposures = 60 GRPs. Reach = % exposed **at least once**.

**Budget methods:** percentage of sales · match competition · objectives and tasks · Parfitt-Collins

## Parfitt-Collins

$$\%\text{Aware} \times \%\text{Try} \times \%\text{Repeat} = \%\text{Market share}$$

$$\%\text{Aware} = \frac{\text{target share}}{\%\text{Try} \times \%\text{Repeat}} = \frac{0.06}{0.30 \times 0.40} = 50\%$$

## Measurement

Pre-launch creative tests · physiological (galvanic skin response, eye-tracking, fMRI) · **Starch scores** for print (Noted / Associated / Read) · day-after recall for TV · cross-market GRP tests · Google Analytics

## Roles of advertising

Informative · Persuasive · Money-burning (signal) · Reminder (**pulsing**) — and the response curve is an **S**: nothing below threshold, steep middle, flat at saturation

## Digital KPIs

CPC · CTR · TCR · **ROA** · revenue per booking · probability of booking

Low **CTR** → fix the ad. Low **TCR** → fix the website.

> Trap: Implausibly high ROA usually means attribution error.

## Six copy rules

Show the product · mention the brand name · state the positives · show it in use · avoid unpleasant connections · say where and how to buy
$md$ where course_code = 'MKTG' and session = 9;

-- ---------------------------------------------------------------------------
-- 2. Framework concepts
--
-- Eight topics for the qualitative half of the course. Every existing MKTG topic was
-- quantitative or case-based, and Session 1 had none at all.
-- ---------------------------------------------------------------------------

insert into public.learn_concepts (course_code, topic, title, note) values
('MKTG', 'value_proposition', 'Value Proposition & the 4 Ps', $md$
Marketing is **meeting needs profitably**: creating, communicating, delivering and **extracting** value. The last verb is the one people drop, and dropping it turns marketing into charity with a budget.

Two halves sit under the definition. **Customer orientation** — profit comes from understanding needs and creating value. **Competitive advantage** — you must meet those needs *better than the competition does*. Either half alone describes a company that fails.

## Value

$$\text{Value} = \text{benefits} - \text{costs}$$

Both sides have **economic and emotional** components. The IKEA effect ("I made it myself") is an emotional benefit; a patient's discomfort with an AI diagnosis is an emotional cost. Neither shows on a price tag.

> Trap: Raw quality is not enough — value has to be **perceived** by the customer. A better product nobody can tell is better earns nothing for being better.

## The proposition itself

Three circles: what the customer **really wants**, what **we do well**, what the **rival does well**.

- **Points of parity** — needs both you and the rival meet. They *neutralise* the competition; they are the reasons a customer cannot rule you out.
- **Points of differentiation** — needs only you meet. This is the proposition.

> Trap: State the proposition in terms of customer **needs**, not internal capabilities. "A reliable phone" is a proposition; "six sigma certified" is a fact about you.

## The 4 Ps deliver it

| P | Role |
|---|---|
| **Product** | Core benefit → **actual** (features, design, quality level, brand name, packaging) → **augmented** (delivery, installation, credit, warranty, after-sale service) |
| **Place** | Where you sell and how it reaches the market: point-of-sale experience and channels |
| **Promotion** | Inform, persuade, remind — campaigns, personal selling, personalised offers |
| **Price** | The **only P that generates revenue**; extracts value and signals quality |

> Trap: Brand name and packaging are **actual** product; warranty and delivery are **augmented**. This swap is the most common error on the product-levels question.

Beyond the four: **Purpose, People, Processes**. The **4 As** restate the mix customer-side — Acceptability (value), Affordability (price), Accessibility (distribution), Awareness (communication).

## Differentiation

**Horizontal** is taste (colour, flavour) — no option is objectively better. **Vertical** is quality (battery life, resolution) — everyone prefers more, which is why only vertical differences reliably command a premium.
$md$),

('MKTG', 'stp_positioning', 'Segmentation, Targeting & Positioning', $md$
Three questions in order. **Segmentation**: what customer groups are out there? **Targeting**: which do we go after? **Positioning**: what are we promising them?

## Segmentation

A mass product that serves the whole market usually is not possible. A segment is a group that shares common needs *and* **responds similarly to the four elements of the marketing mix**. That second condition is the operational one — a group that reacts differently to a price cut is a different segment however similar the demographics look.

Bases: **geographic** (McDonald's positions differently by country), **demographic** (the most common, because it is *reachable*), **behavioural** (loyalty, usage, benefits sought), **psychographic** (values and lifestyle), **benefit** (whitening vs sensitivity toothpaste).

Segments are found with **factor analysis** (collapse many variables into a few dimensions) then **cluster analysis** (most similar within a cluster, most dissimilar across).

> Trap: Whatever basis you segment on, you still have to describe the segment **demographically** to reach it. Media is bought on demographics.

## Targeting

Two tests. **Attractiveness**: size, growth, strength of need, and whether you can identify and access these customers. **Fit**: your credibility, your ability to deliver reliably and profitably, and whether competitors already serve the segment well.

The matrix is attractiveness against **your capability**.

> Trap: The dangerous cell is low capability in a highly attractive market. Everyone can see it is attractive, and the incumbents there will punish an entry.

**Adjacent segment strategy** — expand with new products into the segment next door (Toyota: Yaris → Corolla → Camry → Avalon → Supra → Lexus). **Niche strategy** — enter a segment the dominant players do not care about, and own it before they notice. **Multiple segments at once** — coupons let one store serve the price-sensitive and everyone else.

## Positioning

Making your offering occupy a **distinctive place, relative to competitors, in the minds of the target audience**. Every good product offers several benefits; choosing the key one also chooses the competition you will be compared against.

The statement answers four questions:

| Question | Element |
|---|---|
| Which customers? | Target segment |
| What are we promising? | Points of difference |
| Why believe us? | Reason to believe |
| Who do we steal from? | Frame of reference |

> "To customers who are **<target market>**, our product **<brand>** offers **<points of difference>** relative to **<frame of reference>**, because **<reason to believe>**."

**What it buys you:** focused product strategy and resource allocation, plus organisational alignment — everyone knows who we sell to and why.

**Why it is hard:** it needs real depth on customers and on competing alternatives, honesty about your own weaknesses, and it **forces choices** — targeting one segment is simultaneously refusing others.

> Trap: Positioning statements are **internal only**. Publishing one names your frame of reference and invites comparative advertising.
$md$),

('MKTG', 'five_cs_customer', 'The 5 Cs & How Customers Decide', $md$
The situation analysis that comes before any strategy. Five boxes, and two of them hide a second question.

| C | The question |
|---|---|
| **Customer** | Who they are — needs, wants, lifestyle, preferences, willingness to pay. **And how they decide** — purchase type, stages, influencers. |
| **Company** | Core competence, strengths, weaknesses, goals |
| **Competition** | Who competes for our customers, their strengths and weaknesses, and their **likely reactions to our actions** |
| **Context** | Regulation, economy, culture, technology |
| **Collaborators** | Who can help us, what they can do, and whether they **capture enough value** to keep helping |

> Trap: Competitors *react*. A plan that assumes they stand still is not a plan. And a collaborator who cannot make money from helping you will stop helping you.

## The customer decision-making process

Awareness of need → Identify alternatives → Get information about alternatives → Evaluate alternatives → **Purchase decision** → Use → Post-purchase evaluation.

The loop closes two ways: a positive post-purchase evaluation produces a **repeat purchase**; a negative one sends the customer back to identifying alternatives — which is to say, to your competitors.

> Trap: **Acquisition is everything before the purchase decision; retention is everything after.** That line is where CLV splits into its two formulas, and exam questions test which side an activity sits on.

Note also that decisions have **influencers** who are neither the buyer nor the user. Dave Carroll consulted his father-in-law, a business consultant, on important decisions.

## Service level is a choice, not a maximum

> Prof: There is an optimal level of customer service for every product and service. Past that point more service does not return its investment.

**Vertical differentiation** is the reason. Where customers differ in willingness to pay, firms deliberately offer higher and lower quality, and serving a low-WTP segment properly at a low price is a legitimate position rather than a failure. United's economy proposition is **affordable connectivity** — service that would suit a premium airline would come out of the fare.

> Trap: For a service failure, ask the compensation question in three parts: what is the **objective** of compensating, how much is **enough**, and what are the **implications**? A payment large enough to satisfy a viral complainant is a payment you have promised everyone with a camera.

## Turning complaints into something buildable

"Pickups are bad" cannot be worked on. Uber broke the pickup into six stages — **Contextualize, Assist, Depict, Navigate, Track, Meet** — with the pain named on both the rider and driver side at each one, then defined a weighted metric to minimise. That is the move: decompose the journey, name the pain per stage per side, then measure.
$md$),

('MKTG', 'branding_basics', 'What a Brand Does', $md$
A brand is a **marketing device designed to create value above and beyond the core product or service benefits**. Strip the brand away and the detergent still cleans; what changes is what the purchase means and how much of it the buyer will believe before trying.

## Why brands matter more for some goods

| Goods type | When quality can be judged | Role of the brand |
|---|---|---|
| **Search** | Before purchase, by inspection | Smallest — you can just look |
| **Experience** | Only after use | Carries the promise you cannot verify first |
| **Credence** | Possibly never, even after use — medicine, financial advice | Often the only signal available |

## Value created

**For the organisation**

- Increases the **effectiveness of marketing actions** — the same campaign works harder behind a known brand
- Creates a **separable company asset** — something that can be sold, licensed or valued on its own, independent of the factory

**For the customer**

- **Identifies** the offering
- **Differentiates** it from competitors
- Serves as a **credible quality signal**
- Offers **emotional, social and self-expressive** benefits — through positive associations and through the brand's ability to express who the user is

That last one is why two people can pay different amounts for the same physical object without either of them being irrational.

## Product lifecycle

**Product development → Introduction → Growth → Maturity → Decline.**

Sales and profit are separate curves. Profit is negative through development, turns positive in growth, and **peaks before sales do** — competition compresses price while volume is still climbing. A product can be growing and getting worse as a business at the same time.

## Price conscious is not value conscious

The Unilever Brazil distinction, and the one that catches most people.

- **Price conscious** — wants the lowest price
- **Value conscious** — pays willingly for benefits that matter and refuses to pay for ones that do not

Low-income consumers are frequently both, which makes them a *more* demanding customer than a rich one, not a less demanding one. In Northeast Brazil only 28% of households owned a washing machine against 67% elsewhere; hand-washing made cleaning power and whitening the core need rather than a premium extra.

> Trap: "Low income means they only want cheap" is the assumption that kills the launch. The discipline is to deliver the benefits that matter — and **only** those.
$md$),

('MKTG', 'brand_architecture', 'Brand Architecture & Extensions', $md$
Brands are managed **through the 4 Ps**, and consistency among them is the whole game — all four must reinforce the same image. A premium price with discount distribution does not read as a bargain, it reads as confusion.

## House of brands vs branded house

| | Independent brands (house of brands) | Brand extensions (branded house) |
|---|---|---|
| **Pros** | More positioning opportunities · easier acquisitions · failures less risky for company image | Communication efficiency · instant brand image transfer · deters competition |
| **Cons** | More expensive and complicated to manage · lose the benefit of a big brand | Risk of dilution or ambiguity · bad news affects all products · less management autonomy |

Insurance versus leverage. A house of brands contains failures and pays for the containment; a branded house transfers strength instantly and transfers weakness just as fast.

## Two directions to extend

- **Vertical extension** — greater benefits at a higher price (upscale) or fewer at a lower price (downscale). Same category, different point on the price-benefit line.
- **Horizontal extension** — usually a **different category at a similar price**.

> Trap: Downscale vertical extensions are the dangerous ones. They reach more customers and quietly redefine what the brand means to everybody.

## Repositioning is not extension

**Repositioning changes the meaning of the existing brand** rather than adding an offering beside it — Amazon, Starbucks and Spotify have all done it. Three reasons: the **target market changed**, **competitors acted**, or the **context changed**.

## Co-branding

Brand images of partnering brands **spill onto each other**. The benefit is image transfer; the risk is **brand confusion**.

> Worked example: **(RED) in 2007** — Converse, Apple, Gap, American Express, Motorola and Armani Exchange all pointing at one mark. With that many partners the association stopped meaning anything specific. The failure mode was not damage; it was dilution.

## Luxury

Luxury brands **signal status**, along a spectrum from **loud luxury to subtle luxury**. The instruments are logo design and size, the 4 Ps behind them, and the **brand story**. Segments nest by increasing wealth, and the wealthier the segment the more subtle the signal — a signal only has to be legible to the people who matter.
$md$),

('MKTG', 'distribution_channels', 'Distribution & Double Marginalisation', $md$
The firm has to make the product **available**, and distribution decisions both facilitate and influence the purchase decision at nearly every stage of the customer journey. Place is often the **most expensive of the 4 Ps** — and most firms do not realise it, because the cost is margin given away rather than money spent.

## Two structures

**Indirect**: Manufacturer → Retailer → Consumer.
**Direct / vertically integrated**: Manufacturer (owning retail) → Consumer.

Six questions decide between them, each with theory behind it:

| Question | Related concept |
|---|---|
| Lower price to consumers? | **Double marginalisation** |
| Better retail customer service? | **Moral hazard in teams** |
| Higher profits to the firms? | Mergers, collusion |
| Better control of the 4 Ps? | DIY vs delegation |
| Technology or skills leaking to rivals? | — |
| Preserving consumer loyalty? | — |

**Why use retailers at all:** geographic coverage, infrastructure (trucks, stores), customer access and information, in-store and after-sales service, and retailing competency. Integrating means building all of it.

## Double marginalisation

The manufacturer marks up over cost; the retailer marks up again over that. The final price ends up **higher than an integrated firm would set**, and **both firms earn less** than they would have.

> Trap: This is not a fight over the split — both sides lose. Each party sets its margin without accounting for the volume the other loses, so the structure itself destroys value.

Three fixes for this **vertical** conflict:

1. **Price ceiling** — maximum suggested retail price (MSRP)
2. **Two-part tariff** — fixed upfront fee plus a per-unit price **equal to the manufacturer's marginal cost**
3. **Co-provision of retail service**, or revenue-sharing incentives

> Trap: The two-part tariff works because pricing the unit at marginal cost removes the retailer's reason to mark up — it now behaves like an integrated firm, and the manufacturer takes its profit through the fee. Set the per-unit price above marginal cost and you have the original problem plus a fee.

## Horizontal conflict

| Conflict | Fix |
|---|---|
| Retailers competing with each other | **Exclusive territories** |
| A retailer pushing a rival manufacturer's product | **Exclusive dealing** |
| **Showrooming** (inspect in store, buy online) and **webrooming** (research online, buy in store) | Set incentives to **promote, not inhibit** the behaviour |
$md$),

('MKTG', 'price_sensitivity', 'Price Sensitivity & Discrimination', $md$
**Price is the most important profit driver**, and pricing is considered the hardest marketing decision — because firms lack information about their own costs, about the value delivered to consumers, and about what actually drives the purchase.

## Elasticity is not sensitivity

The golden rule, $\frac{p-mc}{p} = \frac{1}{\varepsilon}$, says percent margin equals one over elasticity: **higher elasticity, lower price**.

> Trap: **Elasticity** is a number you compute. **Sensitivity** is qualitative — "more" or "less". A question asking about sensitivity is not asking you to calculate anything.

## What price sensitivity depends on

| Factor | Effect |
|---|---|
| Awareness/availability of substitutes | More substitutes → more sensitive |
| Ease of direct comparison | Easier to compare → more sensitive |
| Expenditure (share of the total bundle) | Bigger share of spend → more sensitive |
| Shared cost (employer, insurer pays part) | Someone else pays → **less** sensitive |
| Switching cost | Higher → **less** sensitive |
| Price/quality inference | Price reads as quality → **less** sensitive |
| Ability to carry inventory | Can stockpile on discount → more sensitive |

Several of these are decisions, not facts. Switching costs and price-quality inference are things you build.

## Measuring it

| Variable measured | Natural conditions | Experimental conditions |
|---|---|---|
| **Actual purchase** | Sales data | Field experiments, laboratory experiments |
| **Preferences / intentions** | Surveys | Trade-off analysis (**conjoint**) |

The trade-off runs on the diagonal: sales data is real but uncontrolled, conjoint is controlled but hypothetical.

## Price discrimination

Different customers have different elasticities, so one price loses money on both ends.

| Degree | Basis | Example |
|---|---|---|
| **First** | The individual | Personalised pricing |
| **Second** | Self-selection from a menu, including **bundling** | Business vs economy class |
| **Third** | An observable segment | Student and senior discounts |
| **Behavioural** | Observed past behaviour | Amazon inferring sensitivity from history |
| **Inter-temporal** | Time | Skimming downward; rising prices for network goods |

> Worked example: Bundling is second-degree. It works on **negatively correlated valuations** — you value A highly and B little, I am the reverse, so one bundle price extracts more from both of us than two separate prices would.

## Psychological pricing

- **Prices ending in 9** ($79.99 rather than $80) work through **mental categorization** — the bucket changes, the cent is irrelevant
- **Higher price raises perceived and even experienced quality** — the MRI wine study found the brain responding differently to identical wine at a higher stated price
- **Prospect theory**: losses loom larger than gains, so **unbundle gains and bundle losses**
$md$),

('MKTG', 'comms_planning', 'Communications Planning: the 7 Ms', $md$
Communications is the last thing you decide and the first thing anyone notices. The plan has seven parts, and the first two are inherited rather than chosen.

| | M | Question |
|---|---|---|
| 1 | **Markets** | Who should I talk to? (target segment) |
| 2 | **Message content** | What should I tell them? (key benefit / positioning) |
| 3 | **Mission** | What are we trying to influence — Awareness, Interest, Desire, Action? |
| 4 | **Message design** | How should I say it? |
| 5 | **Media strategy** | How do I reach them? |
| 6 | **Money** | How much do I spend? |
| 7 | **Measurement** | Was it worth it? |

> Trap: Markets and message content come out of **STP**, not out of the campaign brief. If you are deciding who the audience is while writing the brief, the problem is upstream.

## Mission and the hierarchy of effects

Across **Awareness → Interest → Desire → Action**, the efficient source changes. **Mass media (advertising)** wins the early stages; **personal and interpersonal sources (personal selling, word of mouth)** win the late ones. Mission therefore drives media choice — buying mass media to close a sale pays premium rates for the wrong half of the curve.

**Offline word of mouth is 41% more persuasive** than online.

## Four roles of advertising

- **Informative** — the product exists and does this
- **Persuasive** — change preference
- **Money-burning** — the **spend itself** is the signal: deep pockets, commitment, confidence in quality, and a warning to competitors
- **Reminder (ad pulsing)** — refresh memory in bursts for a brand everyone knows

The response curve is an **S**: below a threshold nothing happens, then a steep responsive middle, then saturation. Spending under the threshold is worse than not spending.

## The toolkit

**Mass and targeted media** — TV, digital, print, outdoor. Advertising splits **outbound** vs **inbound** (digital, search). **Product placement** splits **screen** (shown) vs **script** (mentioned). **Public relations** covers press releases, influencers, public events and crisis management. **Personal and interpersonal** means the sales force and word of mouth.

**Media types by ownership: paid** (you bought it) · **owned** (your site, app, store, list) · **earned** (coverage, shares, word of mouth).

## Message design

**Rational appeals** — demonstration, spokesperson, testimonials, product comparison (comparative/combative). **Emotional appeals** — fear, humour, happiness, affection, kids and family. **Subliminal appeals** — no evidence they work.

> Trap: Avoid combative advertising unless you can actually kill the rival. A public fight usually benefits the **third player** who stayed out of it.

## Money and measurement

$$\text{GRP} = \text{Reach} \times \text{Frequency}$$

Reach is the % exposed **at least once**; frequency is the average exposures per reached person. Budget-setting methods: **percentage of sales**, **match (or better) competition**, **objectives and tasks**, and **Parfitt-Collins**.

Measurement runs from pre-launch creative tests through physiological measures (galvanic skin response, eye-tracking, fMRI), **Starch scores** for print (Noted / Associated / Read), day-after recall for TV, cross-market GRP tests and analytics.

## Six rules for the copy

Show the product · mention the brand name · state the positives · show it in use · avoid unpleasant connections · tell people where and how to buy.

> Prof: **Cheap talk** — do not trust claims when interests are completely misaligned. Lucy's promise to hold the football costs her nothing to break, so it carries no information. Money-burning advertising is believable precisely because it is expensive.
$md$)
on conflict (course_code, topic) do update set title = excluded.title, note = excluded.note;

-- ---------------------------------------------------------------------------
-- 3. Framework questions -- 8 per new topic
--
-- 8 because ROUND_SIZE is 8 and pickNext() does not repeat within a round; a topic with
-- fewer questions ends a topic-filtered round early. Every question tests a framework the
-- slides state, not a fact about a case.
-- ---------------------------------------------------------------------------

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values

-- value_proposition (Session 1)
('mktg-vp1', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$A phone maker lists these attributes. Which one belongs to the **augmented** product rather than the actual product?$q$,
 $c$["Packaging", "Brand name", "Two-year warranty", "Screen quality level"]$c$::jsonb, $a$Two-year warranty$a$, 'Session 1',
 $e$The three levels are **core benefit** (the need being met), **actual product** (features, design, quality level, brand name, packaging) and **augmented product** (delivery, installation, credit, warranty, after-sale service).

Warranty is augmented — it wraps around the thing you hand over. Packaging, brand name and quality level are all part of the actual product, and swapping those two levels is the most common error on this question.$e$,
 $h$Ask whether the attribute is part of the object handed over, or something wrapped around it.$h$, 1, 'authored'),

('mktg-vp2', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$A firm creates enormous consumer value and captures almost none of it. Which part of the definition of marketing has it failed?$q$,
 $c$["Creating value", "Communicating value", "Delivering value", "Extracting value"]$c$::jsonb, $a$Extracting value$a$, 'Session 1',
 $e$Marketing is **creating, communicating, delivering and extracting** value. The fourth verb is the one people drop, and it is not the finance team's problem — meeting needs *profitably* is the definition.

A firm that creates value it never captures is doing charity with extra steps. The point of the framework is that all four verbs have to hold at once.$e$,
 $h$Four verbs. Which one is about the firm getting paid?$h$, 1, 'authored'),

('mktg-vp3', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$A challenger brand matches the incumbent on battery life, which every buyer expects. What has it achieved?$q$,
 $c$["A point of parity, which neutralises that dimension as a reason to reject it", "A point of differentiation, since matching a leader is itself a differentiator", "Nothing of value, because parity attributes do not affect purchase", "Vertical differentiation, because battery life is a quality dimension"]$c$::jsonb,
 $a$A point of parity, which neutralises that dimension as a reason to reject it$a$, 'Session 1',
 $e$**Points of parity** are needs both you and the rival fulfil. Their job is to *neutralise* the competition — they are the reasons a customer cannot rule you out.

They are not wasted effort, which rules out the third option, but they are not the basis of the proposition either. Only **points of differentiation** — needs you meet that rivals cannot — make someone choose you.$e$,
 $h$Parity attributes stop you losing; differentiation makes you win.$h$, 2, 'authored'),

('mktg-vp4', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$Which statement about the 4 Ps is correct?$q$,
 $c$["Price is the only P that generates revenue; the others cost money", "Promotion generates revenue by driving demand", "Product generates revenue because it is what is sold", "All four generate revenue in different proportions"]$c$::jsonb,
 $a$Price is the only P that generates revenue; the others cost money$a$, 'Session 1',
 $e$Product, place and promotion are all spending decisions. **Price is the only P that brings money in** — it is where value is extracted, and it also signals quality.

Promotion drives demand but is a cost line; product is what you spend to build. The asymmetry is why pricing decisions carry more profit leverage than any other element of the mix.$e$,
 $h$Three of them are on the cost side of the P&L.$h$, 1, 'authored'),

('mktg-vp5', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$Which pair of attributes are respectively **vertical** and **horizontal** differentiators?$q$,
 $c$["Screen resolution; phone colour", "Phone colour; screen resolution", "Battery life; megapixel count", "Case material; strap colour"]$c$::jsonb,
 $a$Screen resolution; phone colour$a$, 'Session 1',
 $e$**Vertical** differentiation is quality-based: everyone prefers more of it, so more of it commands a premium. **Horizontal** is taste-based: no option is objectively better, and half the market prefers the other one.

Screen resolution is vertical, colour is horizontal. Battery life and megapixels are both vertical; case material and strap colour are both horizontal. Getting the direction right matters because only vertical differences reliably support a higher price.$e$,
 $h$Would every single customer want more of it, or do customers genuinely disagree?$h$, 2, 'authored'),

('mktg-vp6', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$In the 4 As framework, which A corresponds to distribution?$q$,
 $c$["Accessibility", "Acceptability", "Affordability", "Awareness"]$c$::jsonb, $a$Accessibility$a$, 'Session 1',
 $e$The 4 As restate the marketing mix from the customer's side rather than the firm's: **Acceptability** = creating value (product), **Affordability** = pricing, **Accessibility** = distribution, **Awareness** = communication.

If a question asks about the 4 As it is asking about the marketing mix, not about some separate framework you have not seen.$e$,
 $h$Which word describes the customer being able to get hold of the thing?$h$, 1, 'authored'),

('mktg-vp7', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$Customers pay more for furniture they assemble themselves than for identical pre-assembled furniture. In the value equation, what is the extra willingness to pay?$q$,
 $c$["A non-economic benefit", "A non-economic cost", "An economic benefit", "A reduction in economic cost"]$c$::jsonb,
 $a$A non-economic benefit$a$, 'Session 1',
 $e$**Value = benefits − costs**, and both sides have economic and non-economic (emotional) components. The pride of "I made it myself" is an emotional benefit — the IKEA effect.

The mirror case is an emotional *cost*: patients disliking an AI diagnosis because it makes them feel un-special. Neither appears on a price tag, and both change what people buy — which is why the definition has four parts rather than two.$e$,
 $h$Nothing about the wood changed. Something about how the buyer feels did.$h$, 2, 'authored'),

('mktg-vp8', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$A B2C brand's proposition reads: "Manufactured in an ISO-certified facility using six-sigma process control." What is wrong with it?$q$,
 $c$["It states an internal capability rather than a customer need, leaving the customer to translate it", "Nothing — a verifiable production claim is a strong reason to believe", "It is a point of parity, and parity claims should never be communicated", "It describes the augmented product, which cannot support a proposition"]$c$::jsonb,
 $a$It states an internal capability rather than a customer need, leaving the customer to translate it$a$, 'Session 1',
 $e$A value proposition has to be stated in terms of the **consumer need** it meets. "A phone that does not break" is a proposition; "six sigma certified" is a fact about you that no customer asked for.

Certification can serve as a *reason to believe* inside a positioning statement, which is why the second option is tempting — but on its own it is not a proposition, because the customer has to do the work of converting it into a benefit.$e$,
 $h$Who is doing the translation work in that sentence?$h$, 3, 'authored'),

-- stp_positioning (Session 2)
('mktg-stp1', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$Beyond sharing common needs, what defines a genuine market segment?$q$,
 $c$["Its members respond similarly to the four elements of the marketing mix", "Its members share the same demographic profile", "Its members buy from the same set of competitors", "Its members can be reached through a single media channel"]$c$::jsonb,
 $a$Its members respond similarly to the four elements of the marketing mix$a$, 'Session 2',
 $e$The slide definition has two conditions: common needs or preferences, **and** a similar response to product, price, place and promotion.

The second is the operational one. Two groups with identical demographics that react differently to a price cut are two segments, not one — and a segmentation that does not predict response cannot guide a mix decision.$e$,
 $h$A segmentation is only useful if it predicts something you can act on.$h$, 2, 'authored'),

('mktg-stp2', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$A brand segments psychographically, targeting consumers who value adventure. Why must it still profile that segment demographically?$q$,
 $c$["Because media is bought on demographics, so the segment has to be described in reachable terms", "Because psychographic segments are not stable over time", "Because regulators require demographic disclosure in advertising", "Because psychographic variables cannot be measured reliably"]$c$::jsonb,
 $a$Because media is bought on demographics, so the segment has to be described in reachable terms$a$, 'Session 2',
 $e$Whatever basis you segment on — behavioural, psychographic, benefit — you still have to describe the segment demographically to reach it. There is no "adventurous people" targeting option on a media plan.

This is why demographic segmentation is the most common: not because it explains behaviour best, but because it is the language in which reach is bought and sold.$e$,
 $h$Think about placing the media buy, not about understanding the customer.$h$, 2, 'authored'),

('mktg-stp3', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$On the targeting matrix, which cell is the most dangerous place for a firm to enter?$q$,
 $c$["High segment attractiveness, low business capability", "High segment attractiveness, high business capability", "Low segment attractiveness, high business capability", "Low segment attractiveness, low business capability"]$c$::jsonb,
 $a$High segment attractiveness, low business capability$a$, 'Session 2',
 $e$Attractiveness on its own is a trap. Everyone can see a large, growing, high-need segment, which means strong competitors are already in it — and they will punish a weak entrant.

The matrix is attractiveness against **your capability** precisely so that this cell is visible. Low attractiveness with low capability is simply ignored; nobody is tempted by it.$e$,
 $h$The obvious opportunity is obvious to your competitors too.$h$, 2, 'authored'),

('mktg-stp4', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$In the positioning statement template, which element answers "who do we expect to steal business from?"$q$,
 $c$["Frame of reference", "Points of difference", "Reason to believe", "Target segment"]$c$::jsonb,
 $a$Frame of reference$a$, 'Session 2',
 $e$Four questions, four elements: **target segment** (which customers), **points of difference** (what we promise), **reason to believe** (why they should believe us), and **frame of reference** (who we take business from).

In the template — "our product **<brand>** offers **<points of difference>** relative to **<frame of reference>**" — the frame of reference is the competitive set the customer will compare you against.$e$,
 $h$Which blank in the template names your competition?$h$, 1, 'authored'),

('mktg-stp5', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$A carmaker adds successively more expensive models — economy, mid-range, executive, luxury — each aimed at the segment next door. What strategy is this?$q$,
 $c$["Adjacent segment strategy", "Niche segment strategy", "Horizontal brand extension", "Mass-market undifferentiated strategy"]$c$::jsonb,
 $a$Adjacent segment strategy$a$, 'Session 2',
 $e$The **adjacent segment strategy** expands into a neighbouring segment with a *new product* rather than stretching one product to cover both — Toyota's Yaris → Corolla → Camry → Avalon → Supra → Lexus ladder, laid out by launch year, perceived quality and price.

A **niche** strategy is the opposite move: enter a small segment the dominant players ignore. Horizontal extension means a different category at a similar price, which is not what is happening here.$e$,
 $h$Each new model sits one rung along from the last, not in a different category.$h$, 2, 'authored'),

('mktg-stp6', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$A researcher has 50 survey variables per consumer and wants distinct customer groups. What is the correct order of techniques?$q$,
 $c$["Factor analysis to reduce dimensions, then cluster analysis to form groups", "Cluster analysis to form groups, then factor analysis to reduce dimensions", "Factor analysis alone, since factors are the segments", "Cluster analysis alone, since clusters already handle many variables"]$c$::jsonb,
 $a$Factor analysis to reduce dimensions, then cluster analysis to form groups$a$, 'Session 2',
 $e$**Factor analysis** collapses 50-plus correlated variables into two or three underlying dimensions. **Cluster analysis** then groups consumers so that they are most similar within a cluster and most dissimilar across clusters.

Factors are dimensions, not segments — which rules out the third option. Clustering on 50 raw correlated variables first is what the reduction step exists to avoid.$e$,
 $h$Reduce the space before you carve it up.$h$, 2, 'authored'),

('mktg-stp7', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$Why are positioning statements kept internal rather than published?$q$,
 $c$["Publishing names your frame of reference and invites comparative advertising, which often benefits a third player", "Because they contain confidential cost and margin assumptions", "Because regulators restrict claims of differentiation in advertising", "Because customers cannot be expected to understand the template"]$c$::jsonb,
 $a$Publishing names your frame of reference and invites comparative advertising, which often benefits a third player$a$, 'Session 2',
 $e$A positioning statement declares who you think you compete with. Publishing it hands a rival the invitation to argue the comparison in public.

When BMW and Audi fought openly, consumers bought Japanese cars instead — the fight legitimised the question and a firm that stayed out of it won the answer. The statement is an internal guide for strategy and alignment, not a piece of copy.$e$,
 $h$Ask who benefits when two brands argue about which of them is better.$h$, 3, 'authored'),

('mktg-stp8', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$Which is a benefit of having an agreed positioning, according to the slides?$q$,
 $c$["Better allocation of limited resources and internal consensus on what fits the strategy", "It guarantees a price premium over undifferentiated competitors", "It removes the need for segmentation research in later years", "It allows the firm to serve additional segments at no extra cost"]$c$::jsonb,
 $a$Better allocation of limited resources and internal consensus on what fits the strategy$a$, 'Session 2',
 $e$The two payoffs are about the firm, not the customer. Positioning **focuses** product strategy and marketing planning so limited resources go against one test rather than being spread evenly; and it **aligns the organisation**, so everyone knows who we sell to, why them, and how a given initiative fits.

It also *forces choices*: targeting one segment is simultaneously deciding not to target others. That is what makes it hard, and it is the opposite of serving more segments cheaply.$e$,
 $h$Both payoffs are internal.$h$, 2, 'authored'),

-- five_cs_customer (Session 4)
('mktg-5c1', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$Which C asks whether a partner can capture enough value from the arrangement to keep participating?$q$,
 $c$["Collaborators", "Context", "Competition", "Company"]$c$::jsonb, $a$Collaborators$a$, 'Session 4',
 $e$The **Collaborators** box asks who can help us, what they can do, and whether they can **capture sufficient value** by helping. A partner who cannot make money from the arrangement will stop honouring it, however good the contract looks.

**Context** is regulation, economy, culture and technology. **Competition** is rivals and their likely reactions. **Company** is your own competence and goals.$e$,
 $h$Which C is about the people on your side of the table?$h$, 1, 'authored'),

('mktg-5c2', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$At which point in the customer decision-making process does acquisition spend become retention spend?$q$,
 $c$["The purchase decision", "The post-purchase evaluation", "The evaluation of alternatives", "The first repeat purchase"]$c$::jsonb,
 $a$The purchase decision$a$, 'Session 4',
 $e$The process runs awareness of need → identify alternatives → get information → evaluate alternatives → **purchase decision** → use → post-purchase evaluation. Everything before the purchase decision is acquisition; everything after it is retention.

That boundary is not a labelling convention. It is where CLV splits into two formulas — one for a customer you already have and one for a customer you have yet to acquire, differing by the acquisition cost.$e$,
 $h$The line falls where the customer becomes yours.$h$, 2, 'authored'),

('mktg-5c3', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$A plan forecasts three years of share gains assuming rivals hold their current prices and product lines. Which part of the 5 Cs has been done badly?$q$,
 $c$["Competition, because the framework asks for competitors' likely reactions to our actions", "Context, because the economic environment is assumed constant", "Company, because internal capability has been overstated", "Customer, because willingness to pay has not been established"]$c$::jsonb,
 $a$Competition, because the framework asks for competitors' likely reactions to our actions$a$, 'Session 4',
 $e$The Competition box is not a list of rivals and their market shares. It asks for their strengths, weaknesses **and likely reactions to our actions**.

A plan that assumes competitors stand still while you take their customers is not a plan. This is the same idea as the chain-store paradox: the incumbent's response is part of your payoff, not a surprise that happens afterwards.$e$,
 $h$Which box explicitly asks what the other side will do next?$h$, 2, 'authored'),

('mktg-5c4', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$A budget airline is criticised for having worse service than premium carriers. What does the framework say about raising service to match them?$q$,
 $c$["There is an optimal service level, not a maximum — beyond it the spend does not return, and the cost comes out of the fare the segment chose it for", "Service should always be raised to the level of the best competitor, since service quality drives loyalty", "Service should be raised only if the airline also raises prices to the premium level", "Service level is a context variable and cannot be chosen by the firm"]$c$::jsonb,
 $a$There is an optimal service level, not a maximum — beyond it the spend does not return, and the cost comes out of the fare the segment chose it for$a$, 'Session 4',
 $e$> Prof: There will come a point where offering more customer service does not bring a return on investment. There is an optimal level of customer service for every product and service.

**Vertical differentiation** is the reason. Where customers differ in willingness to pay, firms deliberately offer higher and lower quality, and serving a low-WTP segment properly at a low price is a legitimate position rather than a failure. Matching the premium carrier means becoming one.$e$,
 $h$Optimal, not maximum. Who pays for the extra service?$h$, 2, 'authored'),

('mktg-5c5', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$A customer's post-purchase evaluation is negative. Where does the framework send them next?$q$,
 $c$["Back to identifying alternatives", "Out of the market entirely", "To a repeat purchase at a lower price point", "Back to awareness of need, with the need now satisfied"]$c$::jsonb,
 $a$Back to identifying alternatives$a$, 'Session 4',
 $e$The loop closes two ways. A positive post-purchase evaluation produces a **repeat purchase**. A negative one sends the customer back to **identifying alternatives** — which is to say, to your competitors, with the need still live.

That is why post-purchase experience is a retention lever rather than an afterthought: a dissatisfied customer does not leave the market, they re-enter the search.$e$,
 $h$The need has not gone away just because the purchase disappointed.$h$, 1, 'authored'),

('mktg-5c6', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$A firm considers a large payout to settle a service failure that has gone viral. Which consideration should decide it?$q$,
 $c$["The implications — what the payout promises every future customer with an audience", "The size of the audience the complaint reached", "Whether the complaint is factually accurate", "Whether competitors have paid similar amounts in similar situations"]$c$::jsonb,
 $a$The implications — what the payout promises every future customer with an audience$a$, 'Session 4',
 $e$Three questions in order: what is the **objective** of compensating, how much would be **enough**, and what are the **implications**. The third decides it.

A payment large enough to satisfy a viral complainant is a payment you have now offered to everyone with a camera. Accuracy and audience size shape the first two questions but do not settle the policy the payout creates.$e$,
 $h$You are not settling one claim. You are setting a price.$h$, 3, 'authored'),

('mktg-5c7', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$"Our pickup experience is bad." What is the first analytical move that makes this workable?$q$,
 $c$["Break the journey into stages and name the pain at each stage for each side of the marketplace", "Survey customers to score overall satisfaction with pickups", "Benchmark pickup times against the nearest competitor", "Build a predictive model on all available pickup data and inspect the strongest features"]$c$::jsonb,
 $a$Break the journey into stages and name the pain at each stage for each side of the marketplace$a$, 'Session 4',
 $e$Uber decomposed the pickup into six stages — Contextualize, Assist, Depict, Navigate, Track, Meet — and wrote the rider pain and the driver pain at each one. The same event usually shows up twice, once from each side, which is why fixing one side alone tends to move the problem rather than solve it.

Only after that decomposition does a weighted metric mean anything, and only after the metric does modelling make sense. Starting with the model skips the step where you learn what to predict.$e$,
 $h$Before you can measure it or model it, you have to say what "it" is.$h$, 2, 'authored'),

('mktg-5c8', 'MKTG', 'case_fact', 'five_cs_customer', 4,
 $q$Within the Customer box of the 5 Cs, willingness to pay connects most directly to which earlier idea?$q$,
 $c$["Which attributes are vertical differentiators worth paying more for, and which are merely wanted", "Whether the segment can be reached through mass media", "Whether collaborators can capture sufficient value", "The frame of reference in the positioning statement"]$c$::jsonb,
 $a$Which attributes are vertical differentiators worth paying more for, and which are merely wanted$a$, 'Session 4',
 $e$> Prof: Willingness to pay links straight back to horizontal and vertical differentiation. Which attributes will a consumer pay more for, which do they merely want, and which do they not care about?

Higher-income consumers pay for quality improvements; others will not. So the same vertical attribute supports a premium in one segment and none in another — which is exactly why willingness to pay sits in the Customer box rather than in Pricing.$e$,
 $h$Wanting something and paying more for it are different questions.$h$, 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  type = excluded.type, difficulty = excluded.difficulty, provenance = excluded.provenance;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values

-- branding_basics (Session 5)
('mktg-br1', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$For which type of good does the brand carry the most weight, and why?$q$,
 $c$["Credence goods, because quality may never be verifiable even after use", "Search goods, because buyers compare specifications before purchase", "Experience goods, because quality is revealed immediately on first use", "All three equally, since branding operates the same way in every category"]$c$::jsonb,
 $a$Credence goods, because quality may never be verifiable even after use$a$, 'Session 5',
 $e$**Search** goods can be judged by inspection before buying, so the brand matters least. **Experience** goods reveal their quality only after use, so the brand carries the promise you cannot check first. **Credence** goods — medicine, financial advice — may never be verifiable even afterwards, which leaves the brand as close to the only signal available.

The general rule: the harder verification is, the more work the brand does.$e$,
 $h$Rank the three by how easily a buyer can check whether they were right.$h$, 2, 'authored'),

('mktg-br2', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$Which of these is value a brand creates **for the organisation** rather than for the customer?$q$,
 $c$["It becomes a separable company asset that can be valued, sold or licensed", "It differentiates the offering from competitors", "It serves as a credible signal of quality", "It offers self-expressive benefits to the user"]$c$::jsonb,
 $a$It becomes a separable company asset that can be valued, sold or licensed$a$, 'Session 5',
 $e$Brands create value for the **organisation** two ways: they increase the effectiveness of marketing actions, and they become a **separable asset** — something with value independent of the factory.

The other three are customer-side: identification, differentiation, credible quality signalling, and emotional, social and self-expressive benefits. Exam questions frequently ask you to sort the list into the two columns.$e$,
 $h$Which one would still have a price if the company sold nothing next year?$h$, 2, 'authored'),

('mktg-br3', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$A low-income segment refuses a cheaper detergent that cleans less well, but pays a premium over the cheapest option for cleaning power. What does this show?$q$,
 $c$["They are price conscious and value conscious — they pay for benefits that matter and refuse to pay for ones that do not", "They are not genuinely price sensitive, so the segment was misdiagnosed", "They are brand loyal rather than benefit driven", "They are behaving irrationally given their budget constraint"]$c$::jsonb,
 $a$They are price conscious and value conscious — they pay for benefits that matter and refuse to pay for ones that do not$a$, 'Session 5',
 $e$**Price conscious** means wanting the lowest price. **Value conscious** means paying willingly for the benefits that matter and refusing to pay for the ones that do not. The two coexist, and confusing them is the classic error.

That makes such a customer *more* demanding than a rich one, not less. The discipline the case teaches is to deliver the important customer benefits, and **only** those.$e$,
 $h$Two different words. One is about the price, the other is about what the price buys.$h$, 3, 'authored'),

('mktg-br4', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$In the product lifecycle, what is the relationship between the sales curve and the profit curve?$q$,
 $c$["Profit peaks before sales do, then declines while sales are still rising", "Profit and sales peak at the same point", "Sales peak before profit does, so profit is highest in decline", "Profit is flat across the lifecycle because margins are set at launch"]$c$::jsonb,
 $a$Profit peaks before sales do, then declines while sales are still rising$a$, 'Session 5',
 $e$Across product development → introduction → growth → maturity → decline, profit is negative during development, turns positive in growth and **peaks earlier than sales** — competition compresses price and margin while volume is still climbing.

The consequence is the useful part: a product can be growing and getting worse as a business at the same time, so "sales are up" is never an answer on its own.$e$,
 $h$Two curves on the same axes, and they do not peak together.$h$, 2, 'authored'),

('mktg-br5', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$What is a brand, as the course defines it?$q$,
 $c$["A device that creates value above and beyond the core product or service benefits", "The visual identity system that makes a product recognisable on shelf", "The accumulated advertising spend behind a product line", "The legal protection a firm holds over its product name"]$c$::jsonb,
 $a$A device that creates value above and beyond the core product or service benefits$a$, 'Session 5',
 $e$A brand is a marketing device designed to create value **above and beyond the core product or service benefits**. Strip it away and the detergent still cleans; what changes is what the purchase means and how much a buyer will believe before trying.

Logos, ad spend and trademarks are instruments or consequences of a brand. None of them is the definition, and each is a common distractor.$e$,
 $h$The definition is about value the core product does not deliver by itself.$h$, 1, 'authored'),

('mktg-br6', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$Two consumers pay different amounts for physically identical bags, one branded and one not. Which brand benefit best explains the gap?$q$,
 $c$["Emotional, social and self-expressive benefits — the brand expresses who the user is", "Identification, since the buyer can find the product more easily", "Quality signalling, since the bags are physically identical", "Increased effectiveness of the firm's marketing actions"]$c$::jsonb,
 $a$Emotional, social and self-expressive benefits — the brand expresses who the user is$a$, 'Session 5',
 $e$Brands deliver identification, differentiation, credible quality signalling **and** emotional, social and self-expressive benefits, through positive associations and the brand's ability to express who the user is.

Quality signalling cannot explain the gap here because the bags are identical and known to be; the difference is what carrying one says. Effectiveness of marketing actions is a firm-side benefit, not something the consumer pays for.$e$,
 $h$Nothing about the object differs. Something about being seen with it does.$h$, 2, 'authored'),

('mktg-br7', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$At which stage of the product lifecycle is the firm spending with no sales at all?$q$,
 $c$["Product development", "Introduction", "Growth", "Maturity"]$c$::jsonb,
 $a$Product development$a$, 'Session 5',
 $e$During **product development** sales are zero and investment is being made, so the profit curve sits below zero. Introduction has small sales and usually still-negative profit; profit turns positive during growth.

The five stages are product development → introduction → growth → maturity → decline.$e$,
 $h$Before anything is on sale.$h$, 1, 'authored'),

('mktg-br8', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$A premium manufacturer is deciding whether to serve a low-income segment it has ignored. Which argument for entering is strategic rather than financial?$q$,
 $c$["Abandoning the bottom of the market leaves a rival a base from which to attack upward", "The segment is large enough to cover the new brand's fixed costs", "Margins per kilogram in the segment exceed the company average", "Cannibalisation of existing brands will stay below the break-even rate"]$c$::jsonb,
 $a$Abandoning the bottom of the market leaves a rival a base from which to attack upward$a$, 'Session 5',
 $e$The financial question is whether the segment pays. The strategic question is what happens if you leave it to somebody else — a premium brand that abandons the bottom does not leave it empty, it hands a competitor a foothold and a cost structure to climb with.

The other three options are all financial tests. They matter, but they answer "is this profitable?" rather than "what does refusing it cost us later?"$e$,
 $h$One option is about what happens if you do nothing.$h$, 3, 'authored'),

-- brand_architecture (Session 6)
('mktg-ba1', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$Which is an advantage of a **house of brands** (independent brands) over a branded house?$q$,
 $c$["A product failure is less risky for the company's overall image", "Communication is more efficient across the portfolio", "Brand image transfers instantly to new launches", "New entrants are deterred by the size of the parent brand"]$c$::jsonb,
 $a$A product failure is less risky for the company's overall image$a$, 'Session 6',
 $e$A house of brands buys **containment**: more positioning opportunities, easier acquisitions, and failures that do not spread to the company image. It pays for that with cost and complexity, and by giving up the benefit of one big brand.

The other three options are all branded-house advantages — communication efficiency, instant image transfer and deterrence.$e$,
 $h$Insurance versus leverage. Which column is insurance?$h$, 2, 'authored'),

('mktg-ba2', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$A single brand covers every product a firm sells. What is the characteristic risk?$q$,
 $c$["Bad news about one product affects all of them, and the brand's meaning can dilute", "Acquisitions become harder to integrate into the portfolio", "Each product needs its own positioning research", "Communication costs rise with each additional product"]$c$::jsonb,
 $a$Bad news about one product affects all of them, and the brand's meaning can dilute$a$, 'Session 6',
 $e$A branded house transfers strength instantly — and transfers weakness just as fast. Its costs are dilution or ambiguity of meaning, contagion from bad news, and less management autonomy per product.

Harder acquisitions and per-product positioning work are costs of the *opposite* structure. Communication cost falling, not rising, is the branded house's main advantage.$e$,
 $h$What travels along the shared name in both directions?$h$, 2, 'authored'),

('mktg-ba3', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$A shampoo brand launches a body wash at the same price point under the same name. What is this?$q$,
 $c$["A horizontal brand extension", "A vertical brand extension, upscale", "A vertical brand extension, downscale", "Brand repositioning"]$c$::jsonb,
 $a$A horizontal brand extension$a$, 'Session 6',
 $e$**Horizontal extension** moves into a different category at a similar price. **Vertical extension** stays in the category and moves along the price-benefit line — more benefits at a higher price (upscale) or fewer at a lower one (downscale).

Same price, new category, so this is horizontal. Repositioning would mean changing what the existing brand means rather than adding an offering next to it.$e$,
 $h$Did the price move, or the category?$h$, 2, 'authored'),

('mktg-ba4', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$What distinguishes brand repositioning from a brand extension?$q$,
 $c$["Repositioning changes the meaning of the existing brand; an extension adds an offering beside it", "Repositioning always moves the brand downmarket; an extension moves it up", "Repositioning applies to a house of brands; extension applies to a branded house", "Repositioning requires a new brand name; an extension reuses the old one"]$c$::jsonb,
 $a$Repositioning changes the meaning of the existing brand; an extension adds an offering beside it$a$, 'Session 6',
 $e$Repositioning moves the brand you already have — Amazon, Starbucks and Spotify have all done it. Its three triggers are a **change in the target market**, **competitors' actions**, or a **change in the context**.

An extension keeps the existing offering and adds another one, vertically or horizontally. Direction and brand architecture are separate questions from which of the two moves you are making.$e$,
 $h$One offering after the move, or two?$h$, 2, 'authored'),

('mktg-ba5', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$A cause campaign signs six unrelated partner brands at once. What is the characteristic failure?$q$,
 $c$["Dilution — with that many associations the mark stops meaning anything in particular", "Reputational damage from the weakest partner", "Legal exposure from inconsistent claims across partners", "Cannibalisation of the partners' own product lines"]$c$::jsonb,
 $a$Dilution — with that many associations the mark stops meaning anything in particular$a$, 'Session 6',
 $e$Co-branding works through **brand-image spillover**: the partners' images transfer onto each other. The benefit is image transfer; the risk is **brand confusion**.

(RED) in 2007 is the standing example — Converse, Apple, Gap, American Express, Motorola and Armani Exchange all pointing at one mark. The failure was not damage from any single partner, it was that the association stopped being specific.$e$,
 $h$The risk is not that the meaning turned bad.$h$, 3, 'authored'),

('mktg-ba6', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$Why is a **downscale** vertical extension considered the riskier direction?$q$,
 $c$["It reaches many more customers and quietly redefines what the brand means", "It cannibalises the upscale product one-for-one", "It cannot borrow the parent brand's quality signal", "It requires a separate distribution channel"]$c$::jsonb,
 $a$It reaches many more customers and quietly redefines what the brand means$a$, 'Session 6',
 $e$Going down the price-benefit line puts the name in far more hands, and the brand's meaning is set by what most people associate with it. The cheaper offer ends up defining the brand for the majority who only ever meet that version.

This is exactly why Unilever paid $0.10 per kg for a new brand rather than repositioning Omo downward for nothing.$e$,
 $h$Whose experience ends up defining the name?$h$, 3, 'authored'),

('mktg-ba7', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$Luxury brands often reduce logo size and prominence as they target wealthier segments. What is the logic?$q$,
 $c$["Status signals move from loud to subtle because a signal only needs to be legible to the people who matter", "Production costs fall when less branding is applied", "Wealthier consumers are less brand loyal, so branding is wasted on them", "Subtle branding widens the addressable market"]$c$::jsonb,
 $a$Status signals move from loud to subtle because a signal only needs to be legible to the people who matter$a$, 'Session 6',
 $e$Luxury branding runs on a spectrum from **loud luxury to subtle luxury**, with logo design and size, the 4 Ps and the brand story doing the signalling. Segments nest by increasing wealth, and the wealthier the segment the more subtle the signal.

It is the same mechanism as counter-signalling in advertising: only a brand already recognised by the audience that matters can afford to stop shouting.$e$,
 $h$Who is the signal meant to reach, and who is it fine to lose?$h$, 3, 'authored'),

('mktg-ba8', 'MKTG', 'case_fact', 'brand_architecture', 6,
 $q$A brand advertises exclusivity and craft, prices at a premium, and sells through discount warehouse clubs. What has gone wrong?$q$,
 $c$["The 4 Ps are inconsistent, so they no longer reinforce a single brand image", "The brand has been extended horizontally without research", "The brand has been repositioned without changing the target market", "Distribution has created double marginalisation"]$c$::jsonb,
 $a$The 4 Ps are inconsistent, so they no longer reinforce a single brand image$a$, 'Session 6',
 $e$Brands are managed **through the 4 Ps**, and consistency among them is the key — all four have to reinforce the same image.

A premium price with discount distribution does not read as a bargain, it reads as confusion. Nothing has been extended or repositioned here; the mix simply contradicts itself.$e$,
 $h$Read the four elements together and ask what image they add up to.$h$, 2, 'authored'),

-- distribution_channels (Session 7)
('mktg-dc1', 'MKTG', 'case_fact', 'distribution_channels', 7,
 $q$A manufacturer marks up over its cost and its independent retailer marks up again. Compared with a single vertically integrated firm, what happens?$q$,
 $c$["The consumer pays more and the two firms together earn less", "The consumer pays more and the two firms together earn more", "The consumer pays less because two firms compete on margin", "The consumer pays the same, but profit shifts to the retailer"]$c$::jsonb,
 $a$The consumer pays more and the two firms together earn less$a$, 'Session 7',
 $e$This is **double marginalisation**, and the counter-intuitive part is that it is not a fight over the split — both sides lose. Each party sets its margin without accounting for the volume the other loses, so the final price ends up above the integrated optimum and total channel profit below it.

That is why the fixes exist: the structure itself destroys value that neither firm captures.$e$,
 $h$Two successive markups. Ask what happens to volume.$h$, 2, 'authored'),

('mktg-dc2', 'MKTG', 'case_fact', 'distribution_channels', 7,
 $q$In a two-part tariff that solves double marginalisation, what should the manufacturer set the **per-unit** price equal to?$q$,
 $c$["Its own marginal cost", "Its marginal cost plus a normal margin", "The retailer's marginal cost", "Half the intended retail price"]$c$::jsonb,
 $a$Its own marginal cost$a$, 'Session 7',
 $e$Setting the per-unit price at the manufacturer's **marginal cost** removes the retailer's reason to mark up over an inflated wholesale price — the retailer now faces the true cost of an extra unit and behaves like an integrated firm. The manufacturer takes its profit through the **fixed upfront fee** instead.

Set the per-unit price above marginal cost and you have reintroduced the original problem, with a fee attached.$e$,
 $h$The fee earns the profit. What is the per-unit price for?$h$, 3, 'authored'),

('mktg-dc3', 'MKTG', 'case_fact', 'distribution_channels', 7,
 $q$Two of a manufacturer's retailers keep undercutting each other in the same city. Which remedy addresses this?$q$,
 $c$["Exclusive territories", "Exclusive dealing", "A two-part tariff", "A maximum suggested retail price"]$c$::jsonb,
 $a$Exclusive territories$a$, 'Session 7',
 $e$This is **horizontal** conflict — between players at the same level — and the remedy is **exclusive territories**, which stops retailers competing away each other's margin on the same product.

**Exclusive dealing** solves the other horizontal problem: a retailer pushing a rival manufacturer's product. Two-part tariffs and MSRPs address **vertical** conflict, which is the manufacturer-versus-retailer double markup.$e$,
 $h$First decide whether the conflict is vertical or horizontal.$h$, 2, 'authored'),

('mktg-dc4', 'MKTG', 'case_fact', 'distribution_channels', 7,
 $q$Why would a manufacturer choose retailers over selling direct?$q$,
 $c$["Retailers supply coverage, infrastructure, customer access and service that would be very costly to build", "Retailers eliminate double marginalisation", "Retailers give the manufacturer better control over the 4 Ps", "Retailers reduce the risk of technology leaking to rivals"]$c$::jsonb,
 $a$Retailers supply coverage, infrastructure, customer access and service that would be very costly to build$a$, 'Session 7',
 $e$Retailers offer geographic coverage, infrastructure (trucks, stores), customer access and information, in-store and after-sales service, and plain retailing competency. Integrating means building every one of those.

The other three options are arguments for going **direct**: a direct channel avoids double marginalisation, gives better control over the 4 Ps and reduces leakage risk. Sorting the list into the two columns is the standard question here.$e$,
 $h$Three of these are reasons to integrate, not to delegate.$h$, 2, 'authored'),

('mktg-dc5', 'MKTG', 'case_fact', 'distribution_channels', 7,
 $q$What does the course say about the cost of Place relative to the other Ps?$q$,
 $c$["It is often the most expensive of the 4 Ps, and most firms do not realise it", "It is the cheapest P once a channel is established", "It is roughly equal in cost to promotion in most categories", "Its cost is fully recovered through retailer-funded promotions"]$c$::jsonb,
 $a$It is often the most expensive of the 4 Ps, and most firms do not realise it$a$, 'Session 7',
 $e$Place is frequently the most expensive of the four, and firms miss it because the cost appears as **margin given away** rather than as money spent. A line item gets scrutinised; a discount to the trade often does not.

Distribution decisions also facilitate and influence the purchase decision at nearly every stage of the customer journey, not only at the moment of purchase.$e$,
 $h$Where does the cost show up in the accounts?$h$, 1, 'authored'),

('mktg-dc6', 'MKTG', 'case_fact', 'distribution_channels', 7,
 $q$A shopper researches a product online and then buys it in a physical store. What is this called, and what should the manufacturer do?$q$,
 $c$["Webrooming — set incentives that promote rather than inhibit the behaviour", "Showrooming — set incentives that promote rather than inhibit the behaviour", "Webrooming — impose exclusive territories to stop it", "Showrooming — impose exclusive dealing to stop it"]$c$::jsonb,
 $a$Webrooming — set incentives that promote rather than inhibit the behaviour$a$, 'Session 7',
 $e$**Webrooming** is researching online and buying in store. **Showrooming** is the reverse: inspecting in store and buying online.

Both are going to happen regardless, so the recommended response is to set the incentive structure to **promote rather than inhibit** them — capture the behaviour instead of fighting it. Exclusive territories and exclusive dealing solve different horizontal problems entirely.$e$,
 $h$Which half of the journey happened on the web?$h$, 2, 'authored'),

('mktg-dc7', 'MKTG', 'case_fact', 'distribution_channels', 7,
 $q$When comparing channels on **retail customer service quality**, which underlying concept is being invoked?$q$,
 $c$["Moral hazard in teams", "Double marginalisation", "Adverse selection", "Mergers and collusion"]$c$::jsonb,
 $a$Moral hazard in teams$a$, 'Session 7',
 $e$Each channel question on the slide has a concept behind it: consumer price → **double marginalisation**; retail service → **moral hazard in teams**; total firm profits → mergers and collusion; control of the 4 Ps → DIY versus delegation.

Service is a team-effort problem: the manufacturer and retailer both contribute to the customer's experience, neither can fully observe the other's effort, and each is tempted to under-provide because the benefit is shared.$e$,
 $h$Effort is shared, hard to observe, and the payoff is joint.$h$, 3, 'authored'),

('mktg-dc8', 'MKTG', 'case_fact', 'distribution_channels', 7,
 $q$A maximum suggested retail price (MSRP) is used to address which problem?$q$,
 $c$["Vertical channel conflict, by capping the retailer's markup", "Horizontal channel conflict between competing retailers", "Showrooming by online-only competitors", "Cannibalisation between the manufacturer's own products"]$c$::jsonb,
 $a$Vertical channel conflict, by capping the retailer's markup$a$, 'Session 7',
 $e$MSRP is a **price ceiling**, the first of the three fixes for vertical (manufacturer-versus-retailer) conflict, alongside the two-part tariff and co-provision or revenue sharing. Capping the retail price limits the second markup that pushes the final price above the integrated optimum.

Horizontal conflict between retailers is handled by exclusive territories, not by a price cap.$e$,
 $h$A ceiling limits somebody's markup. Whose?$h$, 2, 'authored'),

-- price_sensitivity (Session 8)
('mktg-ps1', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$An employer reimburses part of the cost of a product. What happens to the employee's price sensitivity?$q$,
 $c$["It falls, because shared cost reduces sensitivity", "It rises, because the buyer pays more attention to list prices", "It is unchanged, because the total price is unchanged", "It rises, because reimbursement makes comparison easier"]$c$::jsonb,
 $a$It falls, because shared cost reduces sensitivity$a$, 'Session 8',
 $e$**Shared cost** — an employer or insurer paying part — is one of the seven drivers, and it lowers sensitivity: the buyer feels less of each rupee of price.

The full list: availability of substitutes, ease of direct comparison, expenditure as a share of the bundle, shared cost, switching cost, price/quality inference, and the ability to carry inventory. Shared cost, switching cost and price/quality inference all *reduce* sensitivity; the rest raise it.$e$,
 $h$How much of the price does this buyer actually feel?$h$, 1, 'authored'),

('mktg-ps2', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$In the measurement framework, which method sits at **preferences/intentions × experimental conditions**?$q$,
 $c$["Trade-off analysis (conjoint)", "Surveys", "Sales data", "Field experiments"]$c$::jsonb,
 $a$Trade-off analysis (conjoint)$a$, 'Session 8',
 $e$The 2×2 is variable measured against conditions of measurement:

| | Natural | Experimental |
|---|---|---|
| Actual purchase | Sales data | Field and laboratory experiments |
| Preferences / intentions | Surveys | Trade-off analysis (conjoint) |

Conjoint is the most controlled and the least real — a precise elasticity for a purchase nobody actually made.$e$,
 $h$Stated preference, under a design you control.$h$, 2, 'authored'),

('mktg-ps3', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$Which method measures **actual purchases under natural conditions**, and what is its weakness?$q$,
 $c$["Sales data — real behaviour, but price was never varied cleanly", "Surveys — cheap to run, but respondents misreport", "Laboratory experiments — well controlled, but artificial", "Conjoint analysis — precise, but hypothetical"]$c$::jsonb,
 $a$Sales data — real behaviour, but price was never varied cleanly$a$, 'Session 8',
 $e$Sales data occupies the actual-purchase × natural cell: the most real evidence you can get, and the least controlled. Prices moved for reasons tangled up with promotions, seasons and competitor actions, so isolating the elasticity is hard.

The trade-off runs along the diagonal of the 2×2 — realism at one end, control at the other, and no cell has both.$e$,
 $h$What people really did, in conditions you did not design.$h$, 2, 'authored'),

('mktg-ps4', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$An airline sells business and economy seats and lets customers choose between them. Which type of price discrimination is this?$q$,
 $c$["Second degree — self-selection from a menu", "First degree — individual pricing", "Third degree — pricing by observable segment", "Inter-temporal — pricing by time"]$c$::jsonb,
 $a$Second degree — self-selection from a menu$a$, 'Session 8',
 $e$**Second-degree** discrimination offers a menu and lets customers sort themselves — cabin classes, bundles versus unbundled, versioned products. The seller does not need to know who anyone is.

**First degree** prices each individual. **Third degree** uses an observable segment (student, senior). **Inter-temporal** uses time. The distinguishing question is always: who does the sorting, you or the customer?$e$,
 $h$Nobody checks your identity. You pick.$h$, 2, 'authored'),

('mktg-ps5', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$Bundling two products extracts more than pricing them separately when customer valuations are…$q$,
 $c$["Negatively correlated across the two products", "Positively correlated across the two products", "Identical across all customers", "Uncorrelated and uniformly distributed"]$c$::jsonb,
 $a$Negatively correlated across the two products$a$, 'Session 8',
 $e$Bundling is second-degree discrimination, and it works on **negatively correlated valuations**: you value A highly and B little, I am the reverse. One bundle price extracts a good share from both of us, because each is mostly paying for the half they wanted.

If valuations are positively correlated the same customers value both highly and both cheaply, so the bundle adds nothing that separate prices could not achieve.$e$,
 $h$You want the customers to disagree about which half is worth having.$h$, 3, 'authored'),

('mktg-ps6', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$Why does pricing at $79.99 rather than $80.00 change behaviour?$q$,
 $c$["Mental categorization — the price lands in a lower mental bucket, and the one cent is irrelevant", "The saving is material once aggregated across a basket", "Consumers systematically fail to round numbers correctly", "It signals a discount from a previously higher price"]$c$::jsonb,
 $a$Mental categorization — the price lands in a lower mental bucket, and the one cent is irrelevant$a$, 'Session 8',
 $e$The theoretical underpinning of charm pricing is **mental categorization**: $79.99 is filed in the "seventies" bucket rather than the "eighties" one. The cent is not the mechanism, which is why the effect survives even when the buyer knows about it.

The related pricing psychology on the slide: higher prices raise perceived and even *experienced* quality, and prospect theory says to unbundle gains and bundle losses.$e$,
 $h$Nobody is fooled about the arithmetic. Something else is happening.$h$, 2, 'authored'),

('mktg-ps7', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$Prospect theory implies which framing when presenting a price and its associated savings?$q$,
 $c$["Unbundle the gains and bundle the losses", "Bundle the gains and unbundle the losses", "Present gains and losses together as a single net figure", "Present the largest figure first regardless of sign"]$c$::jsonb,
 $a$Unbundle the gains and bundle the losses$a$, 'Session 8',
 $e$Losses loom larger than gains, so multiple small losses hurt more than one combined loss, while multiple separately-presented gains feel better than one lump. Hence: **unbundle gains, bundle losses** — list savings and benefits individually, present the cost once.

This is a framing decision, not a pricing one: the numbers are identical either way.$e$,
 $h$Which side of the ledger benefits from being broken into pieces?$h$, 3, 'authored'),

('mktg-ps8', 'MKTG', 'case_fact', 'price_sensitivity', 8,
 $q$A question asks whether a segment is "more price sensitive". What kind of answer is expected?$q$,
 $c$["A qualitative comparison — sensitivity is more or less, while elasticity is the number you compute", "A computed elasticity value, since sensitivity and elasticity are the same thing", "A margin figure derived from the golden rule of pricing", "A conjoint estimate, since sensitivity can only be measured experimentally"]$c$::jsonb,
 $a$A qualitative comparison — sensitivity is more or less, while elasticity is the number you compute$a$, 'Session 8',
 $e$**Elasticity** is a measurable quantity that goes into $\frac{p-mc}{p} = \frac{1}{\varepsilon}$. **Sensitivity** is qualitative — more or less.

Exam questions use the words precisely, so a sensitivity question is asking you to reason from the seven drivers, not to calculate anything. Reaching for the formula is the trap here.$e$,
 $h$One of the two words is a number.$h$, 2, 'authored'),

-- comms_planning (Session 9)
('mktg-cp1', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$Of the 7 Ms, which two are inherited from STP rather than decided in the communications plan?$q$,
 $c$["Markets and message content", "Mission and measurement", "Media strategy and money", "Message design and media strategy"]$c$::jsonb,
 $a$Markets and message content$a$, 'Session 9',
 $e$The 7 Ms split two and five. **Markets** (who to talk to) and **message content** (what to tell them — the key benefit and positioning) come out of segmentation, targeting and positioning. **Mission, message design, media strategy, money and measurement** are the communications decisions.

If the answer to "who is the audience" is being invented while writing the campaign brief, the problem is upstream in the STP work.$e$,
 $h$Two of the seven were answered before the campaign existed.$h$, 2, 'authored'),

('mktg-cp2', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$In the 7 Ms, what does **Mission** specify?$q$,
 $c$["Which stage to influence — awareness, interest, desire or action", "The creative execution and tone of the campaign", "The share of revenue to be spent on advertising", "The brand's long-run purpose beyond profit"]$c$::jsonb,
 $a$Which stage to influence — awareness, interest, desire or action$a$, 'Session 9',
 $e$Mission asks what we are trying to influence, and the options are the stages of the hierarchy of effects: **Awareness, Interest, Desire, Action**.

Creative execution is **message design**; spend is **money**; long-run purpose is the "Purpose" P from Session 1. Mission matters because it drives media choice — and defining mission and metrics *before* spending is the closing takeaway of the session.$e$,
 $h$Four stages, and you have to pick which one you are moving.$h$, 2, 'authored'),

('mktg-cp3', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$A brand is well known but few prospects are converting to purchase. Which source type should the budget shift toward?$q$,
 $c$["Personal and interpersonal sources — sales force and word of mouth", "Mass media advertising, to reinforce awareness", "Outdoor and print, to broaden reach", "Product placement, to normalise the brand"]$c$::jsonb,
 $a$Personal and interpersonal sources — sales force and word of mouth$a$, 'Session 9',
 $e$Across the hierarchy of effects, mass media sources are most efficient at **awareness and interest**; personal and interpersonal sources — personal selling, word of mouth — are most efficient at **desire and action**. The two curves cross in the middle.

Awareness is not the constraint here, so more mass media buys the wrong half of the curve. Offline word of mouth is also **41% more persuasive** than online.$e$,
 $h$Which end of the funnel is stuck?$h$, 2, 'authored'),

('mktg-cp4', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$A newspaper writes an unpaid feature about a brand and readers share it. In media planning terms this is…$q$,
 $c$["Earned media", "Owned media", "Paid media", "Inbound advertising"]$c$::jsonb,
 $a$Earned media$a$, 'Session 9',
 $e$Media planning splits channels by ownership: **paid** (you bought the placement), **owned** (your website, app, store, email list) and **earned** (coverage, shares and word of mouth that someone else gave you).

Inbound advertising is a different cut — the split of advertising into outbound (you go to them) and inbound (they come to you, via digital and search).$e$,
 $h$Nobody paid for it and nobody owns the channel.$h$, 1, 'authored'),

('mktg-cp5', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$A firm runs an extravagantly expensive campaign whose content says little about the product. On what grounds can this still work?$q$,
 $c$["Money-burning — the visible expense itself signals deep pockets, commitment and confidence in quality", "Reminder advertising — repetition alone sustains recall", "Persuasive advertising — production value shifts preference directly", "Informative advertising — the scale of the campaign conveys product information"]$c$::jsonb,
 $a$Money-burning — the visible expense itself signals deep pockets, commitment and confidence in quality$a$, 'Session 9',
 $e$Of the four roles — informative, persuasive, **money-burning** and reminder (ad pulsing) — money-burning is the one where the message can be nearly irrelevant. What carries information is that the firm could afford to send it at all, which also warns competitors and reassures suppliers.

A firm with a bad product could not recover the spend, which is exactly why the spend is credible. Compare cheap talk, where a promise costs nothing and therefore says nothing.$e$,
 $h$The signal is the invoice, not the copy.$h$, 3, 'authored'),

('mktg-cp6', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$A brand can afford advertising below the threshold of the S-curve. What does the model say?$q$,
 $c$["Spending below the threshold is worse than not spending, since it buys no measurable response", "A small spend produces small but proportional returns", "Returns are highest at low spend because the market is unsaturated", "The S-curve applies only to digital media, so the spend is safe"]$c$::jsonb,
 $a$Spending below the threshold is worse than not spending, since it buys no measurable response$a$, 'Session 9',
 $e$The advertising response curve is an **S**: nearly flat below a critical spend, then a steep responsive middle, then flat again at saturation.

Below the threshold you pay without ever crossing into the range where anything happens — so the money is spent and nothing is bought. Past saturation, the same thing is true from the other end.$e$,
 $h$The curve is flat at both ends for different reasons.$h$, 2, 'authored'),

('mktg-cp7', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$Which budget-setting method cuts advertising exactly when sales are falling?$q$,
 $c$["Percentage of sales", "Objectives and tasks", "Match (or better) competition", "Parfitt-Collins"]$c$::jsonb,
 $a$Percentage of sales$a$, 'Session 9',
 $e$**Percentage of sales** is the simplest of the four methods and backwards in exactly this way: the budget follows last period's revenue, so spend contracts in the moment support is most needed.

**Match competition** lets a rival set your budget. **Objectives and tasks** costs the work required to achieve a stated goal. **Parfitt-Collins** works backwards from the market share you need to the awareness you must buy.$e$,
 $h$Which method makes the budget a consequence of sales rather than a cause?$h$, 2, 'authored'),

('mktg-cp8', 'MKTG', 'case_fact', 'comms_planning', 9,
 $q$A challenger brand plans an aggressive comparative campaign naming the market leader. What is the standard warning?$q$,
 $c$["A public fight usually benefits the third player who stayed out of it", "Comparative claims cannot be substantiated and invite regulatory action", "Naming a leader raises its awareness in proportion to your spend", "Combative advertising works only for the market leader"]$c$::jsonb,
 $a$A public fight usually benefits the third player who stayed out of it$a$, 'Session 9',
 $e$Avoid combative advertising unless you can actually kill the rival. When BMW and Audi fought publicly, consumers bought Japanese cars — the fight legitimised the comparison and a firm that stayed out of it collected the answer.

The related rules in message design: avoid unpleasant associations with your own product even in a joke, and remember that subliminal appeals have **no evidence** behind them.$e$,
 $h$Count the players. There are more than two.$h$, 3, 'authored')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  type = excluded.type, difficulty = excluded.difficulty, provenance = excluded.provenance;

-- ---------------------------------------------------------------------------
-- 4. Rewriting the case questions that tested recall
--
-- The professor has said the exam does not test case facts -- the cases are taught for the
-- learning that can be derived from them. Ten questions asked for a fact (the brand name, the
-- satisfaction score, the compensation figures, which film was most popular, which industry)
-- and are replaced here by questions on the principle the case exists to teach. Ids and topics
-- are kept so each case topic still holds 8 questions and topic-filtered rounds stay full.
-- The remaining case questions already tested transferable reasoning and are left alone.
-- ---------------------------------------------------------------------------

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values

('c1', 'MKTG', 'case_fact', 'case_unilever_brazil', 5,
 $q$A firm designs a low-cost entrant with a premium formula, cardboard packaging, above-the-line advertising and wholesaler distribution, then prices it near the cheap end. What is wrong?$q$,
 $c$["The mix elements are incoherent — it costs like a premium product and reaches customers like a cheap one", "Above-the-line advertising is never appropriate for low-income segments", "Cardboard packaging cannot be used below a certain price point", "Wholesalers will refuse to carry a product priced near the bottom of the category"]$c$::jsonb,
 $a$The mix elements are incoherent — it costs like a premium product and reaches customers like a cheap one$a$, 'Session 5',
 $e$The options in a launch like this are **coupled packages**, not a menu to mix freely. A premium formula plus premium packaging plus ATL promotion plus wholesaler reach carries a premium cost structure; pricing it at the cheap end simply loses money on every pack.

The discipline the case teaches is to deliver the important customer benefits and **only** those, then re-engineer the rest of the mix to match — not to pick the most attractive line from each column.$e$,
 $h$Add up what the choices cost, then look at the price.$h$, 3, 'prof_adapted'),

('c2', 'MKTG', 'case_fact', 'case_bmw_films', 2,
 $q$A brand faces six months with no new product to announce but wants to hold its sales trend. Which role of advertising is it buying?$q$,
 $c$["Brand maintenance — reminding and reinforcing rather than informing about a new product", "Informative advertising, since the campaign must explain the product range", "Money-burning, since there is no message to carry", "Persuasive advertising aimed at switching current owners of rival brands"]$c$::jsonb,
 $a$Brand maintenance — reminding and reinforcing rather than informing about a new product$a$, 'Session 2',
 $e$With nothing new to announce, the campaign cannot be informative about a launch. Its job is to keep the brand present and desirable with the audience that will buy later — the reminder role from Session 9, applied over a long horizon.

That framing also explains the target choice: if the objective is the trend rather than this quarter's sales, aiming at buyers years away from affording the car is a coherent decision rather than a wasted one.$e$,
 $h$Nothing new to say. So what is the campaign for?$h$, 3, 'prof_adapted'),

('c3', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
 $q$An airline's economy value proposition is "affordable connectivity". What does that imply about where it should invest?$q$,
 $c$["In the attributes that deliver affordability and reliable connection, not in service levels its segment did not choose it for", "In service quality until it matches the highest-rated competitor in the category", "In whichever attributes competitors are currently investing in", "In premium service, since satisfaction scores correlate with long-run profitability in every segment"]$c$::jsonb,
 $a$In the attributes that deliver affordability and reliable connection, not in service levels its segment did not choose it for$a$, 'Session 4',
 $e$The value proposition is the test. Investment belongs in the attributes the target segment picked you for; spending on attributes a different segment values means paying for a position you are not occupying, and the money comes out of the fare.

**Vertical differentiation** is what makes this legitimate: where willingness to pay differs, firms deliberately offer higher and lower quality, and a low-price segment served properly at low cost is a position rather than a failure. There is an **optimal** service level, not a maximum.$e$,
 $h$Read the proposition and ask what the customer actually bought.$h$, 2, 'prof_adapted'),

('c5', 'MKTG', 'case_fact', 'case_air_france', 9,
 $q$Two search publishers show identical return on advertising spend. What else must you know before shifting budget between them?$q$,
 $c$["The probability of booking and the average revenue per booking behind that return", "The creative used in each publisher's ad copy", "The total number of impressions each publisher served", "Which publisher has the larger overall market share"]$c$::jsonb,
 $a$The probability of booking and the average revenue per booking behind that return$a$, 'Session 9',
 $e$The same ROA can come from many cheap low-value bookings or few expensive ones, and the two respond very differently to more budget. The case adds **probability of booking** and **average revenue per booking** to the standard CPC, CTR and TCR precisely so the ratio can be decomposed.

The method is to segment publishers on **probability of booking × CPC** rather than ranking them on a single blended return — and a return that looks implausibly high is usually attribution error rather than performance.$e$,
 $h$A ratio hides both of its inputs.$h$, 3, 'prof_adapted'),

('c6', 'MKTG', 'case_fact', 'case_kookaburra', 3,
 $q$A proposed launch clears break-even by a small margin. What does the framework say about approving it on that basis?$q$,
 $c$["Break-even is a benchmark and a first step, not the sole criterion — strategic, social and ethical factors and a payback time frame also apply", "Clearing break-even is sufficient, since the project by definition does not lose money", "Break-even should be recomputed with sunk costs included before approving", "Break-even only applies to new products, so it cannot support this decision"]$c$::jsonb,
 $a$Break-even is a benchmark and a first step, not the sole criterion — strategic, social and ethical factors and a payback time frame also apply$a$, 'Session 3',
 $e$Break-even analysis turns an argument into a number you can check a forecast against. It does not decide anything on its own: strategic, social and ethical considerations sit alongside it, and more often than not a proposed action should do rather better than break even and pay for itself **within a given time frame**.

Add to that the case's closing warning — be mindful of the assumptions behind the numbers, and run a **sensitivity analysis** on the contentious ones. A recommendation that survives only at one exact set of estimates is not a recommendation. Sunk costs are excluded, never included.$e$,
 $h$What does break-even actually prove, and what does it leave open?$h$, 2, 'prof_adapted'),

('c7', 'MKTG', 'case_fact', 'case_uber_ml', 4,
 $q$A team proposes a weighted quality index with four components and fixed weights. What is the necessary next step?$q$,
 $c$["Validate it — check that movements in the index actually track satisfaction and retention", "Publish it as the team's north-star metric so everyone optimises against it", "Increase the number of components so the index captures more of the experience", "Set all weights equal to remove the subjectivity in choosing them"]$c$::jsonb,
 $a$Validate it — check that movements in the index actually track satisfaction and retention$a$, 'Session 4',
 $e$Weights chosen in a room are a hypothesis. The slide asks two questions of the pickup quality metric — *is this the right approach*, and *how would you validate it* — and the second is the one teams skip.

Adopting an unvalidated index is worse than having none, because the organisation then optimises the index rather than the experience. Adding components or equalising weights changes the hypothesis without testing it.$e$,
 $h$You have a hypothesis about what quality is. What do you owe it?$h$, 3, 'prof_adapted'),

('mktg-un1', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
 $q$Public opinion demands a firm raise service well beyond what its target segment is paying for. What does the framework recommend?$q$,
 $c$["Do what is right for the target segment, since the critics are not the customers whose willingness to pay funds the service", "Follow public opinion, since reputation effects eventually reach every segment", "Split the difference and raise service partway toward the demanded level", "Raise service and raise prices simultaneously to fund it"]$c$::jsonb,
 $a$Do what is right for the target segment, since the critics are not the customers whose willingness to pay funds the service$a$, 'Session 4',
 $e$The takeaway is blunt: offering the highest possible customer service is not always desirable. Understand your customers' needs, stay focused on your target segment, and **do what is right for you, not what others want you to do**.

Raising price to fund service is a repositioning decision, not a service decision — it moves you to a different segment. And a firm that lets the loudest audience set its quality level has handed its positioning to people who do not buy from it.$e$,
 $h$Ask who is paying, and who is talking.$h$, 3, 'prof_adapted'),

('mktg-un7', 'MKTG', 'case_fact', 'case_united_breaks_guitars', 4,
 $q$Where does a badly handled service failure sit in the customer decision-making process, and why does that make it expensive?$q$,
 $c$["Post-purchase evaluation — a negative evaluation sends the customer back to identifying alternatives rather than to repeat purchase", "The purchase decision — it converts an acquisition into a lost sale", "Evaluation of alternatives — it removes the firm from the customer's consideration set before purchase", "Awareness of need — it suppresses the need from arising again"]$c$::jsonb,
 $a$Post-purchase evaluation — a negative evaluation sends the customer back to identifying alternatives rather than to repeat purchase$a$, 'Session 4',
 $e$The loop closes two ways out of post-purchase evaluation: positive leads to **repeat purchase**, negative sends the customer back to **identifying alternatives** with the need still live. They do not leave the market; they re-enter the search, now with a reason to prefer someone else.

That places service recovery squarely on the **retention** side of the acquisition/retention line, which is why it is measured against lifetime value rather than against the cost of the single transaction that went wrong.$e$,
 $h$Trace the arrow that leaves a negative evaluation.$h$, 2, 'prof_adapted'),

('mktg-bmw6', 'MKTG', 'case_fact', 'case_bmw_films', 2,
 $q$A premium brand is attacked by new entrants offering comparable quality at a lower price, and its sales fall. Which response fits the frameworks?$q$,
 $c$["Rebuild the reason to believe in the premium position through product, channel and communication, rather than matching price", "Reposition downward to meet the entrants on price", "Extend the brand downscale to capture the price-sensitive buyers", "Exit the contested segment and concentrate on the most loyal one"]$c$::jsonb,
 $a$Rebuild the reason to believe in the premium position through product, channel and communication, rather than matching price$a$, 'Session 2',
 $e$Entrants attacking on price-adjusted quality are competing on the **vertical** dimension. Matching them on price concedes the position without changing the product, and a downscale extension reaches more customers while quietly redefining what the brand means.

The recovery route is the mix: reorganise the channel, launch new models, and communicate inventively enough that the premium claim is believable again. Abandoning the contested segment surrenders the volume that funds everything else.$e$,
 $h$Two of these options change what the brand means. One reinforces it.$h$, 3, 'prof_adapted'),

('mktg-bmw5', 'MKTG', 'case_fact', 'case_bmw_films', 2,
 $q$A campaign identifies prospects who will not be able to afford the product for several years, and the firm keeps engaging them. On what basis is that spend justified?$q$,
 $c$["Customer lifetime value — the return is the discounted margin over the whole relationship, not this period's sales", "Break-even volume within the campaign period", "Gross rating points delivered per rupee of spend", "The break-even cannibalisation rate against existing models"]$c$::jsonb,
 $a$Customer lifetime value — the return is the discounted margin over the whole relationship, not this period's sales$a$, 'Session 2',
 $e$Acquisition spend on someone who cannot buy yet fails every current-period test and can still be correct, because the thing being bought is a future relationship. That is exactly what **CLV net of acquisition cost** measures, and it is why the acquisition/retention line matters.

GRPs measure how much advertising was delivered, not what it was worth. Break-even and BECR test a launch, not a multi-year acquisition strategy.$e$,
 $h$The payoff is years away. Which metric can see that far?$h$, 3, 'prof_adapted')
on conflict (id) do update set prompt = excluded.prompt, choices = excluded.choices,
  correct_answer = excluded.correct_answer, explanation = excluded.explanation,
  hint = excluded.hint, topic = excluded.topic, session = excluded.session,
  type = excluded.type, difficulty = excluded.difficulty, provenance = excluded.provenance;

commit;
