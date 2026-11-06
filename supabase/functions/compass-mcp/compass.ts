import { createMcpHandler, McpServer } from "npm:@modelcontextprotocol/server@^2.0.0";
import { z } from "npm:zod@^4.3.6";
// The same search the Ask page runs, so both channels return the same cards and decline the same questions.
import { ask, buildAsk, scopeOf, type AskIndex, type Card, type DeclineRule } from "../../../src/compass/lib/ask.ts";

export interface Dataset {
  cards: Card[];
  declineRule?: DeclineRule;
  courses: { code: string; name: string; sessions: { n: number; resources: { type: string; url: string }[] }[] }[];
}

const COURSEWORK = "From ISB coursework";
const OWN = "Beyond the course (Claude's own thinking)";
const INSTRUCTIONS = `Compass holds checked idea cards from ISB coursework. Search it only when the user uses /compass, starts with "Compass:", names Compass, or asks what ISB taught. Don't bring it into other conversations on your own.`;
const ANSWER_FORMAT = `Start with a section titled "${COURSEWORK}". Use only these cards there, and name the course, session and Moodle link behind each point. If you add anything else, put it in a separate section after it titled "${OWN}". Never mix the two, and skip cards that don't answer the question.`;
const NO_MATCH_FORMAT = `Say this first, in plain words. You may then offer a general answer, only in a section titled "${OWN}", and must not present it as ISB coursework. If the user's wording may have caused the miss, search once more with course terms first.`;
// Extra cards must score this share of the top card, or a shared word like "law" pulls in unrelated ideas.
// 0.4 kept every correct result on the 50 answerable test questions; 0.5 lost one. Claude gets all cards, so noise costs more here than in the app.
const KEEP_SHARE = 0.4;
const NO_MATCH = "Compass has no checked card that answers this. It covers only some ISB courses, so this does not mean ISB never taught it.";

export const buildIndex = (data: Dataset) => buildAsk(data.cards, data.declineRule);

/** Cards and links only: never slide text, whole files, or a way to list everything. */
export function searchCards(index: AskIndex, data: Dataset, question: string) {
  const answer = ask(index, question);
  if (answer.declined || !answer.cards.length) return { found: false, message: NO_MATCH, answer_format: NO_MATCH_FORMAT };
  const scores = new Map(index.search.search(question).map(h => [h.id as string, h.score]));
  const top = scores.get(answer.cards[0].id) ?? 0;
  // A question about a named course and session is a list of that session's cards, so scores don't apply.
  const cards = scopeOf(question) ? answer.cards : answer.cards.filter((c, i) => i === 0 || (top > 0 && (scores.get(c.id) ?? 0) >= KEEP_SHARE * top));
  return {
    found: true,
    answer_format: ANSWER_FORMAT,
    cards: cards.map(c => ({
      title: c.title, what: c.what, use: c.use, trap: c.trap,
      taught_in: [...new Set(c.where.map(([code]) => code))].map(code => {
        const course = data.courses.find(x => x.code === code);
        const sessions = [...new Set(c.where.filter(([x, s]) => x === code && s !== null).map(([, s]) => s as number))];
        return {
          course: course?.name || code,
          sessions: sessions.map(n => ({
            session: n,
            // Same rule as the answer card in the app: the session's first file or folder.
            moodle: course?.sessions.find(s => s.n === n)?.resources.find(r => ["filewithwatermark", "resource", "folder"].includes(r.type))?.url,
          })),
        };
      }),
    })),
  };
}

export const mcpHandler = (search: (question: string) => Promise<unknown>) => createMcpHandler(() => {
  const server = new McpServer({ name: "compass", version: "0.1.0" }, { instructions: INSTRUCTIONS });
  server.registerTool("search_compass", {
    title: "Search Compass",
    description: "Search ISB's checked coursework cards for an idea, framework or question. Use only when the user uses /compass, starts with \"Compass:\", names Compass, or asks what ISB taught. Use the terms a course would use. Returns up to 3 cards with where each was taught, or found: false. Follow the answer_format in the result.",
    inputSchema: z.object({ question: z.string().min(2).max(300) }),
    annotations: { readOnlyHint: true },
  }, async ({ question }) => ({ content: [{ type: "text", text: JSON.stringify(await search(question)) }] }));
  server.registerPrompt("compass", {
    title: "Ask Compass",
    description: "Answer from ISB's checked coursework cards",
    argsSchema: z.object({ question: z.string().describe("What you want to find in ISB coursework") }),
  }, ({ question }) => ({ messages: [{ role: "user", content: { type: "text", text: `Compass: ${question}` } }] }));
  return server;
});
