import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { pipeline } from "npm:@supabase/middleware@1";
import { withOAuthProtectedResource, withSupabase } from "npm:@supabase/server@1";
import { type SupabaseClient } from "npm:@supabase/supabase-js@2";
import { buildIndex, type Dataset, mcpHandler, searchCards } from "./compass.ts";

const DAILY_SEARCHES = 100;
const RELOAD_MS = 10 * 60 * 1000; // So a replaced or corrected card file reaches the connector within minutes.

let cache: { at: number; data: Dataset; index: ReturnType<typeof buildIndex> } | null = null;

async function load(admin: SupabaseClient) {
  if (cache && Date.now() - cache.at < RELOAD_MS) return cache;
  const { data: blob, error } = await admin.storage.from("compass").download("compass.json");
  if (error) throw new Error("Could not load the Compass cards.");
  const data: Dataset = JSON.parse(await blob.text());
  cache = { at: Date.now(), data, index: buildIndex(data) };
  return cache;
}

// Connector tokens are refused by every table and bucket (see the connector migration), so all reads
// go through the admin client after the checks below.
Deno.serve(pipeline(
  [withOAuthProtectedResource(), withSupabase({ auth: "user" })],
  async (req, { supabaseAdmin: admin, userClaims }) => {
    const userId = userClaims!.id;
    const { data: user, error } = await admin.from("users").select("is_admin").eq("id", userId).maybeSingle();
    if (error) throw new Error("Could not check access.");
    if (!user?.is_admin) return new Response("The Compass connector is open to admins only for now.", { status: 403 });

    return mcpHandler(async (question, alsoTry) => {
      const since = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();
      const { count, error: countError } = await admin.from("compass_connector_log").select("id", { count: "exact", head: true }).eq("user_id", userId).gte("at", since);
      if (countError) throw new Error("Could not check the daily limit.");
      if ((count ?? 0) >= DAILY_SEARCHES) return { found: false, message: `Daily limit of ${DAILY_SEARCHES} Compass searches reached. Try again tomorrow.` };

      const { data, index } = await load(admin);
      const result = searchCards(index, data, question, alsoTry);
      // Same limit as the app's analytics: the first 60 characters of a question, never the whole thing.
      const { error: logError } = await admin.from("compass_connector_log").insert({
        user_id: userId, question: question.slice(0, 60), cards: result.cards?.length ?? 0, phrasings: alsoTry.length,
        outcome: !result.found ? "none" : "match" in result ? "closest" : "good",
      });
      if (logError) throw new Error("Could not record the search.");
      return result;
    }).fetch(req);
  },
));
