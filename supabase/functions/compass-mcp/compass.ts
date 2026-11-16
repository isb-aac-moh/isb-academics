import { createMcpHandler, McpServer } from "npm:@modelcontextprotocol/server@^2.0.0";
import { z } from "npm:zod@^4.3.6";
// The same search the Ask page runs, so both channels return the same cards and decline the same questions.
import { ask, askMany, buildAsk, scopeOf, type AskIndex, type Card, type DeclineRule } from "../../../src/compass/lib/ask.ts";

export interface Dataset {
  cards: Card[];
  declineRule?: DeclineRule;
  courses: { code: string; name: string; sessions: { n: number; title: string; resources: { type: string; url: string }[]; concepts: { id: string }[] }[] }[];
  // Read only for `rel`: the hand-made links between ideas. The AI-suggested links were never put in this file.
  concepts: Record<string, { rel: { to: string; type: string; why?: string }[] }>;
}

const COURSEWORK = "From ISB coursework";
const OWN = "Beyond the course (Claude's own thinking)";
const INSTRUCTIONS = `Compass holds checked idea cards from ISB coursework. Search it only when the user uses /compass, starts with "Compass:", names Compass, or asks what ISB taught. Don't bring it into other conversations on your own.`;
const SITE = "https://isb-academics.vercel.app/compass"; // Pages open for signed-in ISB users; the Moodle links need an ISB login too.
const SOURCES = `Give links exactly as returned and never build one. Don't add facts the cards don't hold. Anything else goes in a separate section after it titled "${OWN}". Never mix the two.`;
// Restating cards one by one reads like a glossary. Claude answers the question from the cards and the lessons they sit in, and cites each point.
const answerFormat = (title: string) => `Under a section titled "${title}", answer the question directly, as steps or a short explanation, whichever fits it. Build it only from the cards and the also_taught ideas in lessons, and skip any that don't help. End each point with its source in brackets: idea title, course, session. Use lessons to show what ISB teaches together and in what order to work through it. Then a list titled "Where to study this": each lesson as course and session with its Moodle link as "Open in Moodle", then each card you used with its idea_url as "See how it connects". ${SOURCES}`;
const ANSWER_FORMAT = answerFormat(COURSEWORK);
// The app's yes/no gate is fitted for one card on a page. Broad questions ("how to build a healthcare product") fail it even when the right course is in the top 3, so Claude gets the nearest cards and does the filtering.
const CLOSEST_FORMAT = `These are the nearest cards by keyword, not confirmed answers. Say that plainly first. If none of them help, say Compass has no checked card for this and stop the ISB part there. ${answerFormat(`${COURSEWORK} (closest matches)`)}`;
const IDEA_FORMAT = `Under a section titled "${COURSEWORK}", explain this idea from its card: what it is, when to use it, the trap, skipping any that are empty. Then how it connects: what it builds_on (study those first) and what leads_to it, with each link's why, and the ideas taught_alongside it that help. Cite course and session. End with its Moodle links and idea_url. ${SOURCES}`;
const SESSION_FORMAT = `Under a section titled "${COURSEWORK}", walk through this class: what it covers as a whole, then its ideas in a sensible order, one or two lines each, grouping ones that belong together. End with its Moodle links. Mention other_sessions only if the user wants to keep going. ${SOURCES}`;
const LIMIT = 6, LESSONS = 4, ALSO_TAUGHT = 8;
const NO_MATCH_FORMAT = `Say this first, in plain words. You may then offer a general answer, only in a section titled "${OWN}", and must not present it as ISB coursework. If the user's wording may have caused the miss, search once more with course terms first.`;
// Extra cards must score this share of the top card, or a shared word like "law" pulls in unrelated ideas.
// 0.4 kept every correct result on the 50 answerable test questions; 0.5 lost one. Claude gets all cards, so noise costs more here than in the app.
const KEEP_SHARE = 0.4;
const NO_MATCH = "Compass has no checked card that answers this. It covers only some ISB courses, so this does not mean ISB never taught it.";

export const buildIndex = (data: Dataset) => buildAsk(data.cards, data.declineRule, Object.fromEntries(data.courses.map(c => [c.code, c.name])));

const ideaUrl = (c: Card) => `${SITE}/c/${encodeURIComponent(c.id)}`;
const brief = (c: Card) => ({ title: c.title, what: c.what, idea_url: ideaUrl(c) });
const courseName = (data: Dataset, code: string) => data.courses.find(x => x.code === code)?.name || code;
// Same rule as the answer card in the app: the session's first file or folder.
const files = (data: Dataset, code: string, n: number) => data.courses.find(x => x.code === code)?.sessions.find(s => s.n === n)?.resources.filter(r => ["filewithwatermark", "resource", "folder"].includes(r.type)).map(r => r.url) ?? [];
const taughtIn = (data: Dataset, c: Card) => [...new Set(c.where.map(([code]) => code))].map(code => ({
  course: courseName(data, code),
  sessions: [...new Set(c.where.filter(([x, s]) => x === code && s !== null).map(([, s]) => s as number))].map(n => ({ session: n, moodle: files(data, code, n)[0] })),
}));
const inSession = (data: Dataset, code: string, n: number) => data.cards.filter(c => c.where.some(([x, s]) => x === code && s === n));
const fold = (s: string) => s.toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();

/** Cards and links only: never slide text, whole files, or a way to list everything. */
export function searchCards(index: AskIndex, data: Dataset, question: string, alsoTry: string[] = []) {
  const answer = alsoTry.length ? askMany(index, [question, ...alsoTry], LIMIT) : ask(index, question, LIMIT);
  if (!answer.cards.length) return { found: false, message: NO_MATCH, answer_format: NO_MATCH_FORMAT };
  const scores = new Map(index.search.search(question).map(h => [h.id as string, h.score]));
  const top = scores.get(answer.cards[0].id) ?? 0;
  // A question about a named course and session is a list of that session's cards, so scores don't apply.
  // With several wordings the scores come from different searches, so Claude does the filtering instead.
  const cards = alsoTry.length || scopeOf(question) ? answer.cards : answer.cards.filter((c, i) => i === 0 || (top > 0 && (scores.get(c.id) ?? 0) >= KEEP_SHARE * top));
  // The sessions these cards come from, with the other checked ideas taught in each, so Claude can show the lesson and not just the atom.
  const found = new Set(cards.map(c => c.id)), shown = new Set(found);
  const keys = [...new Set(cards.flatMap(c => c.where.filter(([, s]) => s !== null).map(([code, s]) => `${code}:${s}`)))].slice(0, LESSONS);
  const lessons = keys.map(key => {
    const [code, n] = [key.split(":")[0], Number(key.split(":")[1])];
    const here = inSession(data, code, n);
    return {
      course: courseName(data, code), session: n, moodle: files(data, code, n)[0],
      found_here: here.filter(c => found.has(c.id)).map(c => c.title),
      also_taught: here.filter(c => !shown.has(c.id)).slice(0, ALSO_TAUGHT).map(c => (shown.add(c.id), brief(c))),
    };
  });
  return {
    found: true,
    ...(answer.declined && { match: "closest" }),
    answer_format: answer.declined ? CLOSEST_FORMAT : ANSWER_FORMAT,
    cards: cards.map(c => ({
      title: c.title, what: c.what, use: c.use, trap: c.trap,
      idea_url: ideaUrl(c),
      map_url: `${SITE}/map?node=${encodeURIComponent(c.id)}&focus=1`,
      taught_in: taughtIn(data, c),
    })),
    lessons,
  };
}

/** One card in full, with its checked links and the ideas taught in the same sessions. Takes a title, alias or idea link. */
export function openIdea(index: AskIndex, data: Dataset, idea: string) {
  let id = idea.includes("/c/") ? idea.split("/c/").pop()! : idea;
  try { id = decodeURIComponent(id); } catch { /* a title with a bare % sign */ }
  const card = index.byId[id] ?? data.cards.find(c => [c.title, ...c.aliases].some(t => fold(t) === fold(id)));
  if (!card) {
    const near = ask(index, idea, 3).cards.map(c => c.title);
    return { found: false, message: `No idea is called "${idea}".`, ...(near.length && { did_you_mean: near }), answer_format: "Say no idea has that name. If did_you_mean has the one the user meant, open that instead; otherwise search Compass." };
  }
  const link = (id: string, type: string, why?: string) => index.byId[id] && { ...brief(index.byId[id]), link: type.replace(/_/g, " "), ...(why && { why }) };
  const shared = new Map<string, number>();
  for (const [code, n] of card.where) if (n !== null) for (const c of inSession(data, code, n)) if (c.id !== card.id) shared.set(c.id, (shared.get(c.id) ?? 0) + 1);
  return {
    found: true,
    answer_format: IDEA_FORMAT,
    title: card.title, what: card.what, use: card.use, trap: card.trap,
    idea_url: ideaUrl(card),
    taught_in: taughtIn(data, card),
    builds_on: (data.concepts[card.id]?.rel ?? []).map(r => link(r.to, r.type, r.why)).filter(Boolean),
    leads_to: data.cards.flatMap(c => (data.concepts[c.id]?.rel ?? []).filter(r => r.to === card.id).map(r => link(c.id, r.type, r.why))).filter(Boolean),
    // Most shared sessions first: ideas taught together more than once are the closest companions.
    taught_alongside: [...shared].sort((a, b) => b[1] - a[1]).slice(0, ALSO_TAUGHT).map(([id]) => brief(index.byId[id])),
  };
}

/** Every checked idea from one class, in the order the session lists them. Takes a course code or name. */
export function openSession(data: Dataset, course: string, session: number) {
  const key = fold(course);
  const partial = data.courses.filter(c => fold(c.name).includes(key));
  const co = data.courses.find(c => fold(c.code) === key || fold(c.name) === key) ?? (partial.length === 1 ? partial[0] : undefined);
  // "Marketing" fits three courses, so Claude asks rather than guessing.
  if (!co) return { found: false, message: partial.length ? `"${course}" fits more than one course.` : `No course called "${course}" is in Compass.`, courses: (partial.length ? partial : data.courses).map(c => `${c.name} (${c.code})`), answer_format: "Say so and ask which of courses the user means, if any." };
  const withIdeas = co.sessions.map(s => ({ session: s.n, ideas: inSession(data, co.code, s.n).length })).filter(s => s.ideas);
  const ses = co.sessions.find(s => s.n === session);
  const here = inSession(data, co.code, session);
  if (!ses || !here.length) return { found: false, message: `${co.name} session ${session} has no checked ideas in Compass.`, other_sessions: withIdeas, answer_format: "Say so, and offer the nearest session from other_sessions." };
  const order = new Map(ses.concepts.map((c, i) => [c.id, i]));
  return {
    found: true,
    answer_format: SESSION_FORMAT,
    course: co.name, session, ...(ses.title !== `Session ${session}` && { title: ses.title }),
    moodle: files(data, co.code, session),
    ideas: here.sort((a, b) => (order.get(a.id) ?? 1e9) - (order.get(b.id) ?? 1e9)).map(c => ({ ...brief(c), use: c.use, trap: c.trap })),
    other_sessions: withIdeas.filter(s => s.session !== session),
  };
}

export interface Tools {
  search: (question: string, alsoTry: string[]) => Promise<unknown>;
  openIdea: (idea: string) => Promise<unknown>;
  openSession: (course: string, session: number) => Promise<unknown>;
}

const reply = async (result: Promise<unknown>) => ({ content: [{ type: "text" as const, text: JSON.stringify(await result) }] });

export const mcpHandler = (tools: Tools) => createMcpHandler(() => {
  const server = new McpServer({ name: "compass", version: "0.2.0" }, { instructions: INSTRUCTIONS });
  server.registerTool("search_compass", {
    title: "Search Compass",
    description: "Search ISB's checked coursework cards for an idea, framework or question. Use only when the user uses /compass, starts with \"Compass:\", names Compass, or asks what ISB taught. Use the terms a course would use. Returns up to 6 cards with where each was taught, plus lessons: the sessions they come from and the other ideas taught in each. Or found: false. Pass also_try with 2 or 3 other ways a course might word the same question (for example \"MVP types\" and \"jobs to be done\" for \"how do I build a product\"), so one unlucky word doesn't hide the right card. Follow the answer_format in the result.",
    inputSchema: z.object({ question: z.string().min(2).max(300), also_try: z.array(z.string().min(2).max(300)).max(3).optional() }),
    annotations: { readOnlyHint: true },
  }, ({ question, also_try }) => reply(tools.search(question, also_try ?? [])));
  server.registerTool("open_idea", {
    title: "Open a Compass idea",
    description: "Open one Compass idea in full: its card, where ISB taught it, the ideas it builds on and leads to, and the ideas taught alongside it. Use when the user wants more on an idea from a Compass answer. Pass its title or idea_url exactly as Compass returned it. Follow the answer_format in the result.",
    inputSchema: z.object({ idea: z.string().min(2).max(300) }),
    annotations: { readOnlyHint: true },
  }, ({ idea }) => reply(tools.openIdea(idea)));
  server.registerTool("open_session", {
    title: "Open an ISB class",
    description: "List every checked Compass idea from one ISB class, in order, with its Moodle links. Use when the user asks what a session covered or wants to go through a whole class. Pass the course name or code and the session number. Follow the answer_format in the result.",
    inputSchema: z.object({ course: z.string().min(2).max(100), session: z.number().int().min(0).max(60) }),
    annotations: { readOnlyHint: true },
  }, ({ course, session }) => reply(tools.openSession(course, session)));
  server.registerPrompt("compass", {
    title: "Ask Compass",
    description: "Answer from ISB's checked coursework cards",
    argsSchema: z.object({ question: z.string().describe("What you want to find in ISB coursework") }),
  }, ({ question }) => ({ messages: [{ role: "user", content: { type: "text", text: `Compass: ${question}` } }] }));
  return server;
});
