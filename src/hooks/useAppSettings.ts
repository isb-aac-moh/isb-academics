import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, fetchShared, invalidate } from "../lib/queryCache";
import { DEFAULT_TERM_CREDIT_LIMITS } from "../lib/creditProgress";
import type { AppSettings } from "../types";

type Settings = { liveBiddingTerms: string[]; termCreditLimits: Record<string, { min: number; max: number }> };

function loadSettings(force: boolean) {
  return fetchShared<Settings>("app_settings", async () => {
    const { data } = await supabase.from("app_settings").select("*").eq("id", true).maybeSingle();
    const settings = data as AppSettings | null;
    return {
      liveBiddingTerms: settings?.live_bidding_terms ?? [],
      // Merge over the default so a term missing from the DB value (e.g. a
      // future term ISB adds before an admin edits it) still has a sane limit.
      termCreditLimits: { ...DEFAULT_TERM_CREDIT_LIMITS, ...(settings?.term_credit_limits ?? {}) },
    };
  }, force);
}

export function useAppSettings() {
  const hit = cached<Settings>("app_settings");
  const [liveBiddingTerms, setLiveBiddingTerms] = useState<string[]>(hit?.liveBiddingTerms ?? []);
  const [termCreditLimits, setTermCreditLimits] = useState<Record<string, { min: number; max: number }>>(hit?.termCreditLimits ?? DEFAULT_TERM_CREDIT_LIMITS);
  const [loading, setLoading] = useState(!hit);

  const reload = useCallback(async (force = true) => {
    const settings = await loadSettings(force);
    setLiveBiddingTerms(settings.liveBiddingTerms);
    setTermCreditLimits(settings.termCreditLimits);
    setLoading(false);
  }, []);

  useEffect(() => {
    reload(false);
  }, [reload]);

  async function saveLiveBiddingTerms(terms: string[]) {
    const { error } = await supabase
      .from("app_settings")
      .update({ live_bidding_terms: terms, updated_at: new Date().toISOString() })
      .eq("id", true);
    if (!error) { setLiveBiddingTerms(terms); invalidate("app_settings"); }
    else console.error("[useAppSettings] save failed:", error);
  }

  async function saveTermCreditLimits(limits: Record<string, { min: number; max: number }>) {
    const { error } = await supabase
      .from("app_settings")
      .update({ term_credit_limits: limits, updated_at: new Date().toISOString() })
      .eq("id", true);
    if (!error) { setTermCreditLimits(limits); invalidate("app_settings"); }
    else console.error("[useAppSettings] save failed:", error);
  }

  return { liveBiddingTerms, termCreditLimits, loading, saveLiveBiddingTerms, saveTermCreditLimits };
}
