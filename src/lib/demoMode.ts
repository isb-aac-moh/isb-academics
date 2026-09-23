// Recruiter-facing demo: visiting /demo skips real Microsoft SSO entirely and runs the whole
// app against an in-memory fake Supabase client (see demoClient.ts) seeded with fictional data.
// Nothing here ever reaches the real database — no RLS changes, no seeded rows, no risk to real
// student data. The flag lives in sessionStorage (not a React state) because it has to be read
// by supabase.ts at module-evaluation time, before App/useAuth ever render.
const KEY = "isb_demo_mode";

export const DEMO_USER_ID = "00000000-0000-4000-8000-000000000001";

/** Call once, as early as possible (top of lib/supabase.ts) — sets the flag on a fresh /demo load. */
export function markDemoEntryIfNeeded(): void {
  if (typeof window === "undefined") return;
  if (window.location.pathname === "/demo") {
    try {
      sessionStorage.setItem(KEY, "1");
    } catch {
      // Storage unavailable (private mode) — demo mode just won't persist across reloads.
    }
  }
}

export function isDemoMode(): boolean {
  try {
    return sessionStorage.getItem(KEY) === "1";
  } catch {
    return false;
  }
}

/** Full reload back to the real app — clearing mid-session and only routing away would leave
    the already-created fake Supabase client in place for the rest of the tab's life. */
export function exitDemoMode(): void {
  try {
    sessionStorage.removeItem(KEY);
  } catch {
    // ignore
  }
  window.location.href = "/";
}
