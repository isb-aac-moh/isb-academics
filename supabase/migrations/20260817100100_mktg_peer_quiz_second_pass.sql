-- MKTG: second pass over the batchmate quiz (see 20260817100000 for the first 25).
--
-- The first pass held back 12 questions because the concepts appear nowhere in Prof Shubhranshu
-- Singh's decks. On re-reading, that test was too blunt: it conflated "not on our slides" with
-- "not our syllabus". Seven of the twelve are either standard Marketing Management content that
-- any section is fair game to examine, or the missing worked example for something our own bank
-- already teaches in prose. Those go in here.
--
--   - Segmentation bases. We had no question at all asking a student to classify a base, which
--     is a real gap in S2 -- usage occasion and usage rate are behavioural under every taxonomy.
--   - Beach-head targeting. Standard, and it explains why a first segment is often smaller than
--     the eventual target.
--   - White space. Names the fourth cell of the capability map whose other cells mktg-vp11 and
--     mktg-vp3 already cover.
--   - The 1%-lever ranking. Reinforces mktg-vp4 ("price is the only P that generates revenue")
--     with the magnitude. The ranking is what is asked; the figures sit in the explanation.
--   - Aaker's five brand-personality dimensions, and Maslow. Both standard, and Maslow is the
--     mechanism underneath our own Unilever Brazil questions about why low-income buyers pay for
--     a brand at all.
--   - Contact efficiency. mktg-dc5 already asks *why* a manufacturer uses retailers; this is the
--     arithmetic that makes the answer concrete.
--
-- Five stay out, and these are decisions rather than caution:
--
--   - The Direct/Pull/Push/Brokered channel-function grid (2 questions). Our S7 runs on double
--     marginalisation, two-part tariffs and moral hazard in teams. Importing a different 2x2 for
--     the same decision would leave students holding two unrelated frameworks for one question.
--   - Customer equity split into direct / relationship / information / communication value. Could
--     not be matched to any framework outside that one deck -- the mainstream versions are
--     Rust-Zeithaml-Lemon and Kumar's CEV, and neither decomposes this way.
--   - "Attitudinal" as a segmentation base distinct from behavioural (2 questions). Benefits
--     sought, price sensitivity and loyalty sit under behavioural in the standard taxonomy, and
--     keying them to a fourth base would teach a student to get the ordinary version wrong.
--
-- Also still out, from the first pass: their AMA definition question, which contradicts the
-- "creating, communicating, delivering and extracting value" framing mktg-vp2 is built on, and
-- their segment-discovery question, which lists cluster before factor analysis.

begin;

insert into public.learn_questions
  (id, course_code, type, topic, session, prompt, choices, correct_answer, source,
   explanation, hint, difficulty, provenance) values

-- ---------------------------------------------------------------------------
-- value_proposition (Session 1)
-- ---------------------------------------------------------------------------

('mktg-vp12', 'MKTG', 'case_fact', 'value_proposition', 1,
 $q$On a map of what customers want, what we do well and what competitors do well, what is "white space"?$q$,
 $c$["Attributes customers want that neither we nor competitors currently deliver", "Attributes both we and our competitors deliver, and customers expect", "Attributes we deliver well but customers have not learned to value", "Attributes competitors deliver well that we would need to match"]$c$::jsonb,
 $a$Attributes customers want that neither we nor competitors currently deliver$a$, 'Session 1',
 $e$**White space** is demand sitting outside everyone's current offer. It is the most valuable cell on the map because a point of differentiation built there is not a race — nobody is standing in it yet.

Learn the map by its cells. Shared and expected attributes are **points of parity**. Things only we do well that customers want are our **points of differentiation**. Things we do well that nobody wants are wasted capability, and things only competitors do well are our gaps. White space is the empty one.$e$,
 $h$Two of the three circles are empty in this cell. Which two?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- stp_positioning (Session 2)
-- ---------------------------------------------------------------------------

('mktg-stp12', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$A beverage firm groups buyers by usage occasion, usage rate and repeat purchasing. Which segmentation base is this?$q$,
 $c$["Behavioural", "Psychographic", "Demographic", "Geographic"]$c$::jsonb,
 $a$Behavioural$a$, 'Session 2',
 $e$**Behavioural** bases segment on what people *do* with the category: when they use it, how much they use, whether they come back, what benefits they buy it for, how loyal they are. Every variable in the stem is an observed action.

**Psychographic** is the trap, and the distinction is worth fixing: psychographics are personality, values, lifestyle and media habits — what people *are* like, inferred from surveys. Behavioural data usually already exists in your transaction records; psychographic data has to be collected.$e$,
 $h$Is each variable something the firm observed, or something it had to ask about?$h$, 1, 'authored'),

('mktg-stp13', 'MKTG', 'case_fact', 'stp_positioning', 2,
 $q$A payments startup launches into freelance designers, a group far smaller than the small-business market it ultimately wants. In targeting terms, what are the designers?$q$,
 $c$["A beach-head segment the firm intends to expand out from", "A test market used to validate the pricing model", "A niche chosen because larger segments are already well served", "A secondary segment served opportunistically alongside the main one"]$c$::jsonb,
 $a$A beach-head segment the firm intends to expand out from$a$, 'Session 2',
 $e$The segment you start in is often smaller than the one you are aiming at. A **beach-head** is chosen because you can win it outright — narrow enough to serve credibly with what you have, and adjacent enough to the bigger market that winning it builds something you can expand with.

A niche implies you intend to stay, which the stem rules out. A test market implies you are gathering information before the real launch, not building a position. The beach-head is the real launch; it is just deliberately small.$e$,
 $h$The stem says what the firm ultimately wants. Does that fit staying put, or moving out?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- branding_basics (Session 5)
-- ---------------------------------------------------------------------------

('mktg-br10', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$What are the five dimensions of brand personality?$q$,
 $c$["Sincerity, Excitement, Competence, Sophistication, Ruggedness", "Warmth, Boldness, Elegance, Reliability, Adventurousness", "Sincerity, Playfulness, Premiumness, Trustworthiness, Toughness", "Friendliness, Innovation, Luxury, Dependability, Strength"]$c$::jsonb,
 $a$Sincerity, Excitement, Competence, Sophistication, Ruggedness$a$, 'Session 5',
 $e$Aaker's five: **Sincerity** (down-to-earth, honest), **Excitement** (daring, imaginative), **Competence** (reliable, successful), **Sophistication** (upper-class, charming) and **Ruggedness** (outdoorsy, tough). The point of the framework is that brands are described with the vocabulary used for people, which is what lets a customer feel a brand is or is not "for someone like me".

The wrong options are near-synonyms chosen to feel familiar, so this is one of the few places where the exact words are the examinable content. Learn the five nouns rather than the idea behind them.$e$,
 $h$Five words. Four of these lists are paraphrases of the real one.$h$, 1, 'authored'),

('mktg-br11', 'MKTG', 'case_fact', 'branding_basics', 5,
 $q$Low-income consumers pay a premium for branded detergent partly because of what the purchase says about them. In Maslow's terms, which need is the brand serving?$q$,
 $c$["Esteem needs, since the purchase carries status and self-respect", "Physiological needs, since cleaning is a basic requirement", "Safety needs, since a known brand reduces the risk of a bad purchase", "Social needs, since detergent choice is observed by neighbours"]$c$::jsonb,
 $a$Esteem needs, since the purchase carries status and self-respect$a$, 'Session 5',
 $e$Brand symbolism operates at the **esteem** level and above — dignity, status, the sense of being someone who buys properly. That is why a value-conscious buyer will pay more than the cheapest shelf price rather than trading all the way down.

Safety is the tempting answer because risk reduction is genuinely one of the things a brand does. But if the need were only safety, any cheaper brand with a reliable reputation would satisfy it, and the case shows it does not. The premium is buying something the cheaper reliable option cannot supply.$e$,
 $h$If risk reduction were the whole story, would a cheap reliable brand do just as well?$h$, 2, 'authored'),

-- ---------------------------------------------------------------------------
-- distribution_channels (Session 7)
-- ---------------------------------------------------------------------------

('mktg-dc9', 'MKTG', 'formula', 'distribution_channels', 7,
 $q$Five manufacturers each need to reach the same four retail customers. Moving from direct dealing to a single shared distributor changes the number of contacts from:$q$,
 $c$["20 to 9", "20 to 11", "9 to 20", "45 to 20"]$c$::jsonb,
 $a$20 to 9$a$, 'Session 7',
 $e$Direct dealing needs every manufacturer to reach every customer: 5 × 4 = **20** relationships. One intermediary in the middle needs each manufacturer to reach it and it to reach each customer: 5 + 4 = **9**.

Multiplication becomes addition, and that is the whole economic case for intermediaries. The gap widens fast — 50 manufacturers and 40 retailers is 2,000 contacts direct against 90 through a distributor. It is also why the argument for going direct has to come from somewhere else entirely: loyalty, customer data, control of the 4 Ps, keeping know-how in house.$e$,
 $h$Count the lines you would draw on each diagram.$h$, 1, 'authored'),

-- ---------------------------------------------------------------------------
-- pricing_elasticity (Session 8)
-- ---------------------------------------------------------------------------

('mktg-pe10', 'MKTG', 'case_fact', 'pricing_elasticity', 8,
 $q$A 1% improvement in each of the following is modelled for a typical firm. Which produces the largest gain in operating profit?$q$,
 $c$["Price", "Variable cost", "Volume", "Fixed cost"]$c$::jsonb,
 $a$Price$a$, 'Session 8',
 $e$The standard ranking is **price, then variable cost, then volume, then fixed cost** — roughly 11%, 8%, 3% and 2% of operating profit for a 1% move in each. Price wins because it is the only one of the four that flows straight to the bottom line with nothing attached to it.

A 1% volume gain brings its variable cost along, so only the margin on it survives. Cost reductions are real but apply to a base smaller than revenue. This is the quantitative version of "price is the only P that generates revenue" — and it is why pricing decisions deserve more analytical effort than they usually get.$e$,
 $h$Three of these arrive with something attached. One arrives clean.$h$, 2, 'authored');

commit;
