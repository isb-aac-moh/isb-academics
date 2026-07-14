import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";

export interface BidPlanEntry {
  id: string;
  user_id: string;
  course_id: string | null;
  term: string;
  planned_points: number;
  actual_points: number | null;
}

// Bid mechanics from Elective Bidding FAQ / Bidding Session Summary:
export const TOTAL_BID_POINTS = 4500;
export const MIN_BID_PER_COURSE = 100;
export const RESERVE_PER_REMAINING_CREDIT = 100;
export const TOTAL_ELECTIVE_CREDITS_REQUIRED = 18; // + 1 ELP = 19 total, ELP isn't bid on

export function useBidPlan(userId: string | undefined) {
  const [entries, setEntries] = useState<BidPlanEntry[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    if (!userId) { setLoading(false); return; }
    setLoading(true);
    const { data } = await supabase
      .from("bid_plan_entries")
      .select("*")
      .eq("user_id", userId)
      .order("term");
    setEntries((data as BidPlanEntry[]) ?? []);
    setLoading(false);
  }, [userId]);

  useEffect(() => {
    reload();
  }, [reload]);

  async function addEntry(entry: { course_id: string | null; term: string; planned_points: number }) {
    if (!userId) return;
    const { data, error } = await supabase
      .from("bid_plan_entries")
      .insert({ ...entry, user_id: userId })
      .select("*")
      .single();
    if (!error && data) setEntries((prev) => [...prev, data as BidPlanEntry]);
  }

  async function removeEntry(id: string) {
    await supabase.from("bid_plan_entries").delete().eq("id", id);
    setEntries((prev) => prev.filter((e) => e.id !== id));
  }

  const pointsPlanned = entries.reduce((sum, e) => sum + e.planned_points, 0);

  return { entries, loading, addEntry, removeEntry, pointsPlanned };
}
