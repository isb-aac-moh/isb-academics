import { createMcpHandler, McpServer } from "npm:@modelcontextprotocol/server@^2.0.0";
import { z } from "npm:zod@^4.3.6";
// The same search the Ask page runs, so both channels return the same cards and decline the same questions.
import { ask, askMany, buildAsk, scopeOf, type AskIndex, type Card, type DeclineRule } from "../../../src/compass/lib/ask.ts";

export interface Dataset {
  cards: Card[];
  declineRule?: DeclineRule;
  courses: { code: string; name: string; sessions: { n: number; resources: { type: string; url: string }[] }[] }[];
}

const COURSEWORK = "From ISB coursework";
const OWN = "Beyond the course (Claude's own thinking)";
const INSTRUCTIONS = `Compass holds checked idea cards from ISB coursework. Search it only when the user uses /compass, starts with "Compass:", names Compass, or asks what ISB taught. Don't bring it into other conversations on your own.`;
const SITE = "https://isb-academics.vercel.app/compass"; // Pages open for signed-in ISB users; the Moodle links need an ISB login too.
// Restating cards one by one reads like a glossary. Claude answers the question from the cards and the lessons they sit in, and cites each point.
const answerFormat = (title: string) => `Under a section titled "${title}", answer the question directly, as steps or a short explanation, whichever fits it. Build it only from the cards and the also_taught ideas in lessons, and skip any that don't help. End each point with its source in brackets: idea title, course, session. Use lessons to show what ISB teaches together and in what order to work through it. Then a list titled "Where to study this": each lesson as course and session with its Moodle link as "Open in Moodle", then each card you used with its idea_url as "See how it connects". Give links exactly as returned and never build one. Don't add facts the cards don't hold. Anything else goes in a separate section after it titled "${OWN}". Never mix the two.`;
const ANSWER_FORMAT = answerFormat(COURSEWORK);
// The app's yes/no gate is fitted for one card on a page. Broad questions ("how to build a healthcare product") fail it even when the right course is in the top 3, so Claude gets the nearest cards and does the filtering.
const CLOSEST_FORMAT = `These are the nearest cards by keyword, not confirmed answers. Say that plainly first. If none of them help, say Compass has no checked card for this and stop the ISB part there. ${answerFormat(`${COURSEWORK} (closest matches)`)}`;
const LIMIT = 6, LESSONS = 4, ALSO_TAUGHT = 8;
const NO_MATCH_FORMAT = `Say this first, in plain words. You may then offer a general answer, only in a section titled "${OWN}", and must not present it as ISB coursework. If the user's wording may have caused the miss, search once more with course terms first.`;
// Extra cards must score this share of the top card, or a shared word like "law" pulls in unrelated ideas.
// 0.4 kept every correct result on the 50 answerable test questions; 0.5 lost one. Claude gets all cards, so noise costs more here than in the app.
const KEEP_SHARE = 0.4;
const NO_MATCH = "Compass has no checked card that answers this. It covers only some ISB courses, so this does not mean ISB never taught it.";

export const buildIndex = (data: Dataset) => buildAsk(data.cards, data.declineRule, Object.fromEntries(data.courses.map(c => [c.code, c.name])));

/** Cards and links only: never slide text, whole files, or a way to list everything. */
export function searchCards(index: AskIndex, data: Dataset, question: string, alsoTry: string[] = []) {
  const answer = alsoTry.length ? askMany(index, [question, ...alsoTry], LIMIT) : ask(index, question, LIMIT);
  if (!answer.cards.length) return { found: false, message: NO_MATCH, answer_format: NO_MATCH_FORMAT };
  const scores = new Map(index.search.search(question).map(h => [h.id as string, h.score]));
  const top = scores.get(answer.cards[0].id) ?? 0;
  // A question about a named course and session is a list of that session's cards, so scores don't apply.
  // With several wordings the scores come from different searches, so Claude does the filtering instead.
  const cards = alsoTry.length || scopeOf(question) ? answer.cards : answer.cards.filter((c, i) => i === 0 || (top > 0 && (scores.get(c.id) ?? 0) >= KEEP_SHARE * top));
  const ideaUrl = (c: Card) => `${SITE}/c/${encodeURIComponent(c.id)}`;
  const courseName = (code: string) => data.courses.find(x => x.code === code)?.name || code;
  // Same rule as the answer card in the app: the session's first file or folder.
  const moodle = (code: string, n: number) => data.courses.find(x => x.code === code)?.sessions.find(s => s.n === n)?.resources.find(r => ["filewithwatermark", "resource", "folder"].includes(r.type))?.url;
  // The sessions these cards come from, with the other checked ideas taught in each, so Claude can show the lesson and not just the atom.
  const shown = new Set(cards.map(c => c.id));
  const keys = [...new Set(cards.flatMap(c => c.where.filter(([, s]) => s !== null).map(([code, s]) => `${code}:${s}`)))].slice(0, LESSONS);
  const lessons = keys.map(key => {
    const [code, n] = [key.split(":")[0], Number(key.split(":")[1])];
    const here = data.cards.filter(c => c.where.some(([x, s]) => x === code && s === n));
    return {
      course: courseName(code), session: n, moodle: moodle(code, n),
      found_here: here.filter(c => shown.has(c.id)).map(c => c.title),
      also_taught: here.filter(c => !shown.has(c.id)).slice(0, ALSO_TAUGHT).map(c => (shown.add(c.id), { title: c.title, what: c.what, idea_url: ideaUrl(c) })),
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
      taught_in: [...new Set(c.where.map(([code]) => code))].map(code => ({
        course: courseName(code),
        sessions: [...new Set(c.where.filter(([x, s]) => x === code && s !== null).map(([, s]) => s as number))].map(n => ({ session: n, moodle: moodle(code, n) })),
      })),
    })),
    lessons,
  };
}

export const mcpHandler = (search: (question: string, alsoTry: string[]) => Promise<unknown>) => createMcpHandler(() => {
  const server = new McpServer({ name: "compass", version: "0.1.0" }, { instructions: INSTRUCTIONS });
  server.registerTool("search_compass", {
    title: "Search Compass",
    description: "Search ISB's checked coursework cards for an idea, framework or question. Use only when the user uses /compass, starts with \"Compass:\", names Compass, or asks what ISB taught. Use the terms a course would use. Returns up to 6 cards with where each was taught, plus lessons: the sessions they come from and the other ideas taught in each. Or found: false. Pass also_try with 2 or 3 other ways a course might word the same question (for example \"MVP types\" and \"jobs to be done\" for \"how do I build a product\"), so one unlucky word doesn't hide the right card. Follow the answer_format in the result.",
    inputSchema: z.object({ question: z.string().min(2).max(300), also_try: z.array(z.string().min(2).max(300)).max(3).optional() }),
    annotations: { readOnlyHint: true },
  }, async ({ question, also_try }) => ({ content: [{ type: "text", text: JSON.stringify(await search(question, also_try ?? [])) }] }));
  server.registerPrompt("compass", {
    title: "Ask Compass",
    description: "Answer from ISB's checked coursework cards",
    argsSchema: z.object({ question: z.string().describe("What you want to find in ISB coursework") }),
  }, ({ question }) => ({ messages: [{ role: "user", content: { type: "text", text: `Compass: ${question}` } }] }));
  return server;
});
