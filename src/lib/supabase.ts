import { createClient } from "@supabase/supabase-js";
import { markDemoEntryIfNeeded, isDemoMode } from "./demoMode";
import { createDemoClient } from "./demoClient";
import { buildDemoSeed, demoRpcHandlers } from "./demoSeed";

// Must run before isDemoMode() below — sets the flag on a fresh /demo load, before this module
// decides which client to export. See demoMode.ts.
markDemoEntryIfNeeded();

// Where the signed-in session lives in localStorage. Shared with index.html, which reads it to decide
// whether to draw the app outline before JS arrives.
export const AUTH_STORAGE_KEY = "pulse-isb-auth"; // same key as isb-explorer — shared Supabase project, one login
export const CONSENT_RETURN_KEY = "compass-connector-consent"; // the approval page to return to after sign-in

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

// Recruiter demo (/demo — see demoMode.ts): the whole app runs unmodified against an in-memory
// fake client instead of the real project, so a public demo needs no real login and can never
// read or write real student data.
export const supabase = isDemoMode()
  ? (createDemoClient(buildDemoSeed(), demoRpcHandlers) as unknown as ReturnType<typeof createClient>)
  : createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        persistSession: true,
        storageKey: AUTH_STORAGE_KEY,
        autoRefreshToken: true,
        detectSessionInUrl: true,
      },
    });
