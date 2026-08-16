-- MKTG Session 7: resolve the six direct-vs-indirect channel questions.
--
-- The 20260816120000 migration turned the slide's list of six comparison questions into a
-- table of "question -> related concept" without ever answering which channel wins each one --
-- exactly reproducing the slide's own gap instead of closing it. Reworked here by actually
-- running the theory named against each question:
--
--   - Lower price to consumers: double marginalisation says direct wins outright (two stacked
--     markups beat one integrated one, every time).
--   - Higher total profits to the firms: same mechanism, reframed as the merger/collusion logic
--     -- eliminating the double margin grows the total pie rather than redividing a smaller one.
--   - Control of the 4 Ps: direct wins outright (DIY vs delegation -- you cannot control a shelf
--     you do not own).
--   - Technology/skill leakage: direct wins outright (capability stays inside one firm).
--   - Consumer loyalty: direct wins outright (the retailer, not you, owns the point of sale and
--     the purchase data, and has its own incentive to push a rival or a private-label product).
--   - Retail customer service: this is the one genuine trade-off, not a fifth win for direct.
--     Moral-hazard-in-teams argues integration aligns incentives, but it does not by itself
--     produce good service -- the manufacturer still has to build the competency, which is
--     exactly the subject of the very next section, "Why Use Retailers?" That section only makes
--     sense as an answer to a tension the previous one raises, so leaving the six questions
--     unresolved also broke the logical connection between two consecutive parts of the slide.
--
-- Net: direct wins five of six on paper, and real markets still run mostly on indirect channels
-- anyway -- which is the actual point being taught. The 4 A separately overwrites the same
-- session/topic text that already exists, so JSON well-formedness and question rows are
-- untouched; this migration only replaces the affected subsection inside two markdown fields
-- and their formula-sheet summaries.

begin;

update public.learn_session_content set updated_at = now(), summary = replace(
  summary,
$old$## Direct versus indirect

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

Because they supply services that would be very costly for a manufacturer to provide: geographical coverage, infrastructure (trucks, stores), customer access and information, in-store and after-sales service, and plain competency at retailing. Vertical integration means building all of that from nothing.$old$,
$new$## Direct versus indirect

**Indirect channel**: Manufacturer → Retailer → Consumer.
**Direct / vertically integrated channel**: Manufacturer (owning retail) → Consumer.

Six questions decide between them, each with a piece of theory behind it — and, unusually for this deck, the slide asks all six without answering any of them out loud. Run the named theory against each one and direct wins five outright. The sixth is the real trade-off, and it is what the next section exists to resolve.

| Question | Related concept | Answer |
|---|---|---|
| Lower **price to consumers**? | Double marginalisation | **Direct.** Two independent markups stack; one integrated firm sets a single markup. Indirect is strictly worse for the buyer — this is the same mechanism Session 7's next section walks through in full. |
| Higher **total profits** to the firms? | Mergers, collusion | **Direct** (or a device that reproduces it, like the two-part tariff). Eliminating the double markup is the same logic that makes a merger profitable: it grows the whole pie rather than redividing a smaller one. |
| Better **control of the 4 Ps**? | DIY versus delegation | **Direct.** You cannot control price, promotion or merchandising at a shelf you do not own. |
| Less **technology or skill leakage** to rivals? | — | **Direct.** Capability stays inside one firm instead of being handed to an independent partner who may also serve competitors. |
| Better **preserves consumer loyalty**? | — | **Direct.** An indirect channel puts the retailer between you and the customer — it owns the point of sale and the purchase data, and has its own reason to push a rival brand or its own private label once the customer is in the aisle. |
| Better **retail customer service**? | Moral hazard in teams | **Contested — the real trade-off.** Under indirect, manufacturer and retailer split the return on any service investment, so each has some incentive to under-provide it: a classic team moral-hazard problem, and integration removes that misalignment. But removing the misalignment only fixes the *incentive* to invest in service — the manufacturer still has to build the competency to deliver it, which most manufacturers have not. |

> Trap: On paper direct wins almost every comparison, and yet most goods still sell through indirect channels. That gap is not a contradiction — it means the missing variable is not on this list, and it is the subject of the next section.

### Why use retailers at all

The missing variable, and the reason the theory above does not settle the channel decision on its own. Retailers supply services that would be very costly for a manufacturer to build from nothing: geographical coverage, infrastructure (trucks, stores), customer access and information, in-store and after-sales service, and retailing competency accumulated over years. Direct wins every argument above in principle and still loses in practice to a retailer who already has infrastructure a manufacturer would need a decade to replicate — which is exactly why the service-quality question above is genuinely contested rather than a sixth clean win for integration.$new$
) where course_code = 'MKTG' and session = 7;

update public.learn_session_content set updated_at = now(), formula_sheet = replace(
  formula_sheet,
$old$## Channel choice, six questions

Lower consumer price (double marginalisation) · better retail service (moral hazard in teams) · higher firm profits (mergers, collusion) · control of the 4 Ps (DIY vs delegation) · technology leakage · consumer loyalty$old$,
$new$## Channel choice, six questions

**Direct wins outright:** price (double marginalisation) · total profit (mergers/collusion) · control of the 4 Ps (DIY vs delegation) · technology leakage · consumer loyalty

**Contested:** retail service (moral hazard in teams argues for direct; retailer competency argues for indirect — see "why use retailers")$new$
) where course_code = 'MKTG' and session = 7;

update public.learn_concepts set note = replace(
  note,
$old$Six questions decide between them, each with theory behind it:

| Question | Related concept |
|---|---|
| Lower price to consumers? | **Double marginalisation** |
| Better retail customer service? | **Moral hazard in teams** |
| Higher profits to the firms? | Mergers, collusion |
| Better control of the 4 Ps? | DIY vs delegation |
| Technology or skills leaking to rivals? | — |
| Preserving consumer loyalty? | — |

**Why use retailers at all:** geographic coverage, infrastructure (trucks, stores), customer access and information, in-store and after-sales service, and retailing competency. Integrating means building all of it.$old$,
$new$Six questions decide between them, each with theory behind it — and direct wins five of the six outright:

| Question | Related concept | Answer |
|---|---|---|
| Lower price to consumers? | **Double marginalisation** | **Direct** — two stacked markups beat one |
| Higher profits to the firms? | Mergers, collusion | **Direct** — eliminating the double markup grows the total pie |
| Better control of the 4 Ps? | DIY vs delegation | **Direct** — you cannot control a shelf you do not own |
| Technology or skills leaking to rivals? | — | **Direct** — capability stays inside one firm |
| Preserving consumer loyalty? | — | **Direct** — the retailer, not you, owns the point of sale |
| Better retail customer service? | **Moral hazard in teams** | **Contested.** Integration aligns the incentive to invest in service, but the manufacturer still has to build the competency — which retailers already have |

> Trap: Direct wins almost every comparison on paper, yet most goods sell indirect anyway. The missing variable is retailer competency, not more theory.

**Why use retailers at all:** geographic coverage, infrastructure (trucks, stores), customer access and information, in-store and after-sales service, and retailing competency accumulated over years — precisely what makes the service-quality question above contested rather than a sixth win for direct. Integrating means building all of it from nothing.$new$
) where course_code = 'MKTG' and topic = 'distribution_channels';

commit;
