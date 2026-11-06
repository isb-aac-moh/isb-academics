import MiniSearch from "minisearch";

// The student's question goes in; one checked card or a plain decline comes out. Runs entirely in the
// browser with no AI. scripts/compass/card_pilot.py scores this same code against the test questions.
export interface Card { id: string; title: string; aliases: string[]; what: string; use: string; trap: string; where: [string, number | null][]; questions: string[] }
export interface DeclineRule { mean: number[]; sd: number[]; coef: number[]; intercept: number }
export interface AskIndex { search: MiniSearch<Card>; byId: Record<string, Card>; cards: Card[]; rule?: DeclineRule }
export interface Answer { cards: Card[]; declined: boolean; features: number[] }

const STOP = new Set("a an the of and or to in on for with by is are was were be do does did how what which where when who why i my we our me you your it its this that at as from about should can could would not no but into than then there their they them have has had if so".split(" "));
const COURSE_WORDS: Record<string, RegExp> = { OPMG: /\b(opmg|operations)\b/, STRG: /\b(strg|strategy)\b/, MKTG: /\b(mktg|marketing)\b/, BANM: /\b(banm|business analytics)\b/, SWPM: /\b(swpm|software product management)\b/, FRNT: /\b(frnt|frontier)\b/, FADM: /\b(fadm|financial accounting)\b/, FCRV: /\b(fcrv|foundations of finance)\b/, MGEC: /\b(mgec|managerial economics)\b/, SMDM: /\b(smdm|statistical methods)\b/,
  LSAT: /\b(lsat|leading self)\b/, ASMD: /\b(asmd|managerial decision)/, HCEN: /\b(hcen|health ?care entrepreneurship)\b/, SUET: /\b(suet|sustainability and ethics)\b/, ENTR: /\b(entr|(?<!care )entrepreneurship)\b/, BSNS: /\b(bsns|non-?market)\b/, MKTR: /\b(mktr|marketing research)\b/, ABTE: /\b(abte|a\/b testing)/, CDMA: /\b(cdma|mergers)\b/, WACM: /\b(wacm|written analysis)\b/ };
const tokens = (t: string) => t.toLowerCase().match(/[a-z0-9]+/g) || [];
// A light stemmer so "retailers" finds "retailer" and "pricing" finds "price".
const stem = (w: string) => (w.length > 4 ? w.replace(/(ies)$/, "y").replace(/(ing|ed|es|s|e)$/, "") : w);

export function buildAsk(cards: Card[], rule?: DeclineRule, courseNames: Record<string, string> = {}): AskIndex {
  const search = new MiniSearch<Card>({
    fields: ["title", "aliasText", "body", "questionText", "courseText"], storeFields: ["id"],
    processTerm: t => { const w = t.toLowerCase(); return STOP.has(w) ? null : w === "healthcare" ? ["health", "care"] : stem(w); },
    extractField: (c, f) => f === "aliasText" ? c.aliases.join(" ") : f === "body" ? `${c.what} ${c.use} ${c.trap}` : f === "questionText" ? c.questions.join(" ") : f === "courseText" ? c.where.map(([code]) => courseNames[code] ?? "").join(" ") : (c as unknown as Record<string, string>)[f] ?? "",
    searchOptions: { boost: { title: 6, aliasText: 4, questionText: 2, body: 1, courseText: 1 }, combineWith: "OR" },
  });
  search.addAll(cards);
  return { search, byId: Object.fromEntries(cards.map(c => [c.id, c])), cards, rule };
}

/** A question that names one course and asks about a session or class is limited to that course. */
export function scopeOf(q: string): [string, number | null] | null {
  const low = q.toLowerCase();
  if (low.includes("across") || !/\b(session|class|cover|covered)\b/.test(low)) return null;
  const named = Object.keys(COURSE_WORDS).filter(c => COURSE_WORDS[c].test(low));
  if (named.length !== 1) return null;
  const n = low.match(/\b(?:session|class)\s+(\d+)/);
  return [named[0], n ? Number(n[1]) : null];
}

export function ask(index: AskIndex, q: string, limit = 3): Answer {
  // Exact words first; typo tolerance only when nothing matched, so a near-miss word can't outrank a real match.
  let hits = index.search.search(q);
  if (!hits.length) hits = index.search.search(q, { prefix: t => t.length > 3, fuzzy: t => (t.length > 4 ? 0.2 : 0) });
  const scope = scopeOf(q); const inScope = (c: Card) => !!scope && c.where.some(([a, s]) => a === scope[0] && (scope[1] === null || s === scope[1]));
  let ranked = hits.map(h => index.byId[h.id as string]);
  if (scope) { const keep = ranked.filter(inScope); ranked = keep.length ? keep : index.cards.filter(inScope).length ? index.cards.filter(inScope) : ranked; }
  const top = ranked[0]; const terms = tokens(q).filter(t => !STOP.has(t) && t.length > 2);
  const words = top ? new Set(tokens(`${top.title} ${top.what} ${top.use} ${top.trap} ${top.questions.join(" ")}`).map(stem)) : new Set<string>();
  const cover = terms.filter(t => words.has(stem(t))).length / Math.max(terms.length, 1);
  const features = [Math.log1p(hits[0]?.score ?? 0), cover, scope ? 1 : 0];
  const r = index.rule; let declined = !top;
  if (r && top) declined = features.reduce((sum, x, i) => sum + r.coef[i] * (x - r.mean[i]) / r.sd[i], r.intercept) < 0;
  return { cards: ranked.slice(0, limit), declined, features };
}

/** Several wordings of one question: each is searched alone and the rankings are merged, so a miss on one wording is covered by another. */
export function askMany(index: AskIndex, queries: string[], limit = 5): Answer {
  const answers = queries.map(q => ask(index, q, limit)); const score = new Map<string, number>();
  answers.forEach(a => a.cards.forEach((c, i) => score.set(c.id, (score.get(c.id) ?? 0) + 1 / (10 + i))));
  const cards = [...score].sort((a, b) => b[1] - a[1]).slice(0, limit).map(([id]) => index.byId[id]);
  return { cards, declined: answers.every(a => a.declined), features: answers[0].features };
}
