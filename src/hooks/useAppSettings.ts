import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { DEFAULT_TERM_CREDIT_LIMITS } from "../lib/creditProgress";
import type { AppSettings } from "../types";

export function useAppSettings() {
  const [liveBiddingTerms, setLiveBiddingTerms] = useState<string[]>([]);
  const [termCreditLimits, setTermCreditLimits] = useState<Record<string, { min: number; max: number }>>(DEFAULT_TERM_CREDIT_LIMITS);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from("app_settings").select("*").eq("id", true).maybeSingle();
    const settings = data as AppSettings | null;
    setLiveBiddingTerms(settings?.live_bidding_terms ?? []);
    // Merge over the default so a term missing from the DB value (e.g. a
    // future term ISB adds before an admin edits it) still has a sane limit.
    setTermCreditLimits({ ...DEFAULT_TERM_CREDIT_LIMITS, ...(settings?.term_credit_limits ?? {}) });
    setLoading(false);
  }, []);

  useEffect(() => {
    reload();
  }, [reload]);

  async function saveLiveBiddingTerms(terms: string[]) {
    const { error } = await supabase
      .from("app_settings")
      .update({ live_bidding_terms: terms, updated_at: new Date().toISOString() })
      .eq("id", true);
    if (!error) setLiveBiddingTerms(terms);
    else console.error("[useAppSettings] save failed:", error);
  }

  async function saveTermCreditLimits(limits: Record<string, { min: number; max: number }>) {
    const { error } = await supabase
      .from("app_settings")
      .update({ term_credit_limits: limits, updated_at: new Date().toISOString() })
      .eq("id", true);
    if (!error) setTermCreditLimits(limits);
    else console.error("[useAppSettings] save failed:", error);
  }

  return { liveBiddingTerms, termCreditLimits, loading, saveLiveBiddingTerms, saveTermCreditLimits };
}
