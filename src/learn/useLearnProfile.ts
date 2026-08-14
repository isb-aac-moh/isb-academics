import { useEffect, useState } from "react";
import { getOrCreateProfile } from "./lib/db";
import type { Student } from "./types";
import type { User } from "../types";

/**
 * The learning app's per-student state (XP, streak) for an already-signed-in user.
 *
 * The standalone app owned the whole login: it gated on @isb.edu, created the student row, and
 * carried its own admin flag. None of that happens here — the app's useAuth has already done
 * the gating and provisioning, so this only fetches or creates the learn_profiles row and
 * borrows name, email and is_admin from the user it is handed. One identity, one admin flag.
 */
export function useLearnProfile(user: User) {
  const [profile, setProfile] = useState<Student | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    getOrCreateProfile(user.id, user.name || user.email, user.email, user.is_admin ?? false)
      .then((p) => {
        if (!cancelled) setProfile(p);
      })
      .catch((e: unknown) => {
        if (!cancelled) setError(e instanceof Error ? e.message : "Could not load your practice profile.");
      });
    return () => {
      cancelled = true;
    };
  }, [user.id, user.name, user.email, user.is_admin]);

  return { profile, error, setProfile };
}
