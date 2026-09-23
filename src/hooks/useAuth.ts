import { useState, useEffect, useRef } from "react";
import { supabase } from "../lib/supabase";
import posthog from "posthog-js";
import { isDemoMode, exitDemoMode } from "../lib/demoMode";
import { DEMO_USER } from "../lib/demoData";
import type { User } from "../types";

// Brief pause after clicking "Login to see demo" before landing on the dashboard — long enough to
// register as a real action, short enough not to feel like a stall.
const DEMO_SIGN_IN_DELAY_MS = 700;

/**
 * Sign-in entry points. Module-level functions rather than part of the hook, because the login
 * screen needs only these — calling useAuth() there would stand up a second auth subscription and
 * a second profile query alongside the one App already owns.
 */
export async function signInWithAzure(): Promise<string | null> {
  const { error } = await supabase.auth.signInWithOAuth({
    provider: "azure",
    options: {
      redirectTo: window.location.origin,
      scopes: "openid email profile",
    },
  });
  return error?.message ?? null;
}

export async function sendMagicLink(email: string): Promise<string | null> {
  const trimmed = email.trim().toLowerCase();
  if (!trimmed.endsWith("@isb.edu")) {
    return "Only @isb.edu email addresses are allowed.";
  }
  const { error } = await supabase.auth.signInWithOtp({
    email: trimmed,
    options: { emailRedirectTo: window.location.origin },
  });
  return error?.message ?? null;
}

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  // Distinct from `loading` (which gates the whole app on the initial auth check): this only
  // drives the demo login button's own inline spinner, so Login stays mounted and interactive
  // instead of the top-level loading branch swapping the whole screen out from under it.
  const [demoSigningIn, setDemoSigningIn] = useState(false);
  // True when a valid @isb.edu SSO session exists but the `users` table (owned
  // by isb-explorer) has no matching row yet — distinct from "not signed in",
  // so the UI can explain it instead of silently bouncing back to the login form.
  const [notProvisioned, setNotProvisioned] = useState(false);
  // Which uid the loaded profile belongs to. onAuthStateChange also fires for TOKEN_REFRESHED
  // (roughly hourly, and on every tab refocus), which carries the same user and does not need the
  // `users` row fetched again.
  const loadedUid = useRef<string | null>(null);

  useEffect(() => {
    // Demo mode never touches real Supabase Auth — there's no session to check, so skip straight
    // to the (unauthenticated) Login screen and wait for enterDemo() below, fired by its own
    // "Login to see demo" button rather than automatically. See lib/demoMode.ts.
    if (isDemoMode()) {
      setLoading(false);
      return;
    }

    // No separate getSession() call: subscribing emits INITIAL_SESSION with the stored session
    // immediately, so having both meant every single page load ran the gate and the `users` query
    // twice over — two identical round trips on the one request the first paint waits for.
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) {
        if (loadedUid.current === session.user.id) return;
        gateAndLoadProfile(session.user.email, session.user.id);
      } else {
        loadedUid.current = null;
        setUser(null);
        setNotProvisioned(false);
        setLoading(false);
      }
    });

    return () => subscription.unsubscribe();
    // Mount-only by design: one subscription owns auth for the app's lifetime, and
    // gateAndLoadProfile closes over nothing that changes.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Same gate as isb-explorer — reuses the same `users` table and SSO tenant
  async function gateAndLoadProfile(email: string | undefined, uid: string) {
    if (!email || !email.toLowerCase().endsWith("@isb.edu")) {
      console.warn("[auth] non-ISB email signed in, signing out:", email);
      await supabase.auth.signOut();
      setUser(null);
      setLoading(false);
      return;
    }
    loadedUid.current = uid;
    loadProfile(uid);
  }

  async function loadProfile(uid: string) {
    const { data } = await supabase
      .from("users")
      .select("*")
      .eq("id", uid)
      .maybeSingle();
    setUser(data ?? null);
    setNotProvisioned(!data);
    setLoading(false);
    if (data) {
      // Identify the user so all future events are linked to their profile.
      posthog.identify(data.id, { role: data.role });
      posthog.capture("user_signed_in", { method: "sso_or_magic_link" });
    }
  }

  async function signOut() {
    if (isDemoMode()) {
      exitDemoMode(); // clears the flag and hard-reloads to "/", back on the real client
      return;
    }
    posthog.reset();
    await supabase.auth.signOut();
    loadedUid.current = null;
    setUser(null);
    setNotProvisioned(false);
  }

  // Fired by Login's "Login to see demo" button — the explicit action that actually enters the
  // demo, as opposed to just landing on /demo, which only puts up the gate. See DemoMode.
  async function enterDemo() {
    setDemoSigningIn(true);
    await new Promise((resolve) => setTimeout(resolve, DEMO_SIGN_IN_DELAY_MS));
    loadedUid.current = DEMO_USER.id;
    setUser(DEMO_USER);
    setDemoSigningIn(false);
  }

  return {
    user, loading, notProvisioned, sendMagicLink, signInWithAzure, signOut,
    demoSigningIn,
    enterDemo: isDemoMode() ? enterDemo : undefined,
  };
}
