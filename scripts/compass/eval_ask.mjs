// Runs the app's own search (src/compass/lib/ask.ts) on questions read from stdin and prints what it returns.
// Usage: node eval_ask.mjs <data.json> < questions.json. Called by card_pilot.py browser_rule.
import { readFileSync } from "node:fs";
import { ask, buildAsk } from "../../src/compass/lib/ask.ts";

const data = JSON.parse(readFileSync(process.argv[2], "utf8"));
const index = buildAsk(data.cards);
const started = performance.now();
const out = JSON.parse(readFileSync(0, "utf8")).map(q => { const a = ask(index, q); return { ids: a.cards.map(c => c.id), features: a.features }; });
console.error(`average: ${((performance.now() - started) / Math.max(out.length, 1)).toFixed(2)} ms per question`);
console.log(JSON.stringify(out));
