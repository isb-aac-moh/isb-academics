import { createMcpHandler, McpServer } from "npm:@modelcontextprotocol/server@^2.0.0";
import { z } from "npm:zod@^4.3.6";
// The same search the Ask page runs, so both channels return the same cards and decline the same questions.
import { ask, buildAsk, type AskIndex, type Card, type DeclineRule } from "../../../src/compass/lib/ask.ts";

export interface Dataset {
  cards: Card[];
  declineRule?: DeclineRule;
  courses: { code: string; name: string; sessions: { n: number; resources: { type: string; url: string }[] }[] }[];
}

const INSTRUCTIONS = `Compass holds checked idea cards from ISB coursework. Answer from the returned cards, name the course and session behind each point, and include the Moodle links. If found is false, say Compass has no checked card on this. Clearly mark anything you add from your own knowledge as not from ISB coursework.`;
const NO_MATCH = "Compass has no checked card that answers this. It covers only some ISB courses, so this does not mean ISB never taught it.";

export const buildIndex = (data: Dataset) => buildAsk(data.cards, data.declineRule);

/** Cards and links only: never slide text, whole files, or a way to list everything. */
export function searchCards(index: AskIndex, data: Dataset, question: string) {
  const answer = ask(index, question);
  if (answer.declined || !answer.cards.length) return { found: false, message: NO_MATCH };
  return {
    found: true,
    cards: answer.cards.map(c => ({
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
    description: "Search ISB's checked coursework cards for an idea, framework or question. Use the terms a course would use, and search again with other words if nothing matches. Returns up to 3 cards with where each was taught, or found: false.",
    inputSchema: z.object({ question: z.string().min(2).max(300) }),
    annotations: { readOnlyHint: true },
  }, async ({ question }) => ({ content: [{ type: "text", text: JSON.stringify(await search(question)) }] }));
  return server;
});
