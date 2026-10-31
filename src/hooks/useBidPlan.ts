import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, remember, takeEarly } from "../lib/queryCache";

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

export const bidPlanKey = (userId: string) => `bid_plan:${userId}`;

export async function fetchBidPlan(userId: string) {
  const { data } = await supabase
    .from("bid_plan_entries")
    .select("*")
    .eq("user_id", userId)
    .order("term");
  return data;
}

export function useBidPlan(userId: string | undefined) {
  const hit = userId ? cached<BidPlanEntry[]>(bidPlanKey(userId)) : undefined;
  const [entries, setEntries] = useState<BidPlanEntry[]>(hit ?? []);
  const [loading, setLoading] = useState(!hit);

  const reload = useCallback(async () => {
    if (!userId) { setLoading(false); return; }
    const data = await takeEarly(bidPlanKey(userId), () => fetchBidPlan(userId));
    setEntries((data as BidPlanEntry[]) ?? []);
    setLoading(false);
  }, [userId]);

  useEffect(() => {
    reload();
  }, [reload]);

  // Keep the shared copy in step with every change, for the next page that asks.
  useEffect(() => {
    if (userId && !loading) remember(bidPlanKey(userId), entries);
  }, [userId, loading, entries]);

  async function addEntry(entry: { course_id: string | null; term: string; planned_points: number }) {
    if (!userId) return;
    const alreadyExists = entries.some((e) => e.course_id === entry.course_id && e.term === entry.term);
    if (alreadyExists) return;
    const { data, error } = await supabase
      .from("bid_plan_entries")
      .insert({ ...entry, user_id: userId })
      .select("*")
      .single();
    if (!error && data) setEntries((prev) => [...prev, data as BidPlanEntry]);
  }

  async function removeEntry(id: string) {
    const { error } = await supabase.from("bid_plan_entries").delete().eq("id", id);
    if (!error) setEntries((prev) => prev.filter((e) => e.id !== id));
  }

  // Marks a planned entry as reconciled against a real result — 0 means "didn't
  // get it" (a real winning bid is always >= MIN_BID_PER_COURSE, so 0 is a safe
  // sentinel), a positive number is what was actually paid.
  async function resolveEntry(id: string, actualPoints: number) {
    const { data, error } = await supabase
      .from("bid_plan_entries")
      .update({ actual_points: actualPoints })
      .eq("id", id)
      .select("*")
      .single();
    if (!error && data) setEntries((prev) => prev.map((e) => (e.id === id ? (data as BidPlanEntry) : e)));
  }

  const pointsPlanned = entries.reduce((sum, e) => sum + e.planned_points, 0);

  return { entries, loading, addEntry, removeEntry, resolveEntry, pointsPlanned };
}
