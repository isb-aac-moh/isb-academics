import { useState, useEffect } from "react";
import { supabase } from "../lib/supabase";
import type { User } from "../types";

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session?.user) {
        gateAndLoadProfile(session.user.email, session.user.id);
      } else {
        setLoading(false);
      }
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) {
        gateAndLoadProfile(session.user.email, session.user.id);
      } else {
        setUser(null);
        setLoading(false);
      }
    });

    return () => subscription.unsubscribe();
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
    loadProfile(uid);
  }

  async function loadProfile(uid: string) {
    const { data } = await supabase
      .from("users")
      .select("*")
      .eq("id", uid)
      .single();
    setUser(data ?? null);
    setLoading(false);
  }

  async function signInWithAzure(): Promise<string | null> {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "azure",
      options: {
        redirectTo: window.location.origin,
        scopes: "openid email profile",
      },
    });
    return error?.message ?? null;
  }

  async function sendMagicLink(email: string): Promise<string | null> {
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

  async function signOut() {
    await supabase.auth.signOut();
    setUser(null);
  }

  return { user, loading, sendMagicLink, signInWithAzure, signOut };
}
