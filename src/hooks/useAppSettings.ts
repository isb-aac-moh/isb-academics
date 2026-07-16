import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { AppSettings } from "../types";

export function useAppSettings() {
  const [liveBiddingTerms, setLiveBiddingTerms] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from("app_settings").select("*").eq("id", true).maybeSingle();
    setLiveBiddingTerms((data as AppSettings | null)?.live_bidding_terms ?? []);
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

  return { liveBiddingTerms, loading, saveLiveBiddingTerms };
}
