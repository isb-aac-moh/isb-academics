import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";

export interface ActualEnrollment {
  id: string;
  user_id: string;
  course_id: string | null;
  term: string;
  points_paid: number;
  grade: string | null;
}

/** What a student actually ended up enrolled in — separate from their bid_plan_entries intentions. */
export function useActualEnrollments(userId: string | undefined) {
  const [entries, setEntries] = useState<ActualEnrollment[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    if (!userId) { setLoading(false); return; }
    setLoading(true);
    const { data } = await supabase
      .from("actual_enrollments")
      .select("*")
      .eq("user_id", userId)
      .order("term");
    setEntries((data as ActualEnrollment[]) ?? []);
    setLoading(false);
  }, [userId]);

  useEffect(() => {
    reload();
  }, [reload]);

  async function addEntry(entry: { course_id: string | null; term: string; points_paid: number; grade: string | null }) {
    if (!userId) return;
    const alreadyExists = entries.some((e) => e.course_id === entry.course_id && e.term === entry.term);
    if (alreadyExists) return;
    const { data, error } = await supabase
      .from("actual_enrollments")
      .insert({ ...entry, user_id: userId })
      .select("*")
      .single();
    if (!error && data) setEntries((prev) => [...prev, data as ActualEnrollment]);
  }

  async function updateEntry(id: string, updates: Partial<Pick<ActualEnrollment, "points_paid" | "grade">>) {
    const { data, error } = await supabase
      .from("actual_enrollments")
      .update(updates)
      .eq("id", id)
      .select("*")
      .single();
    if (!error && data) setEntries((prev) => prev.map((e) => (e.id === id ? (data as ActualEnrollment) : e)));
  }

  async function removeEntry(id: string) {
    const { error } = await supabase.from("actual_enrollments").delete().eq("id", id);
    if (!error) setEntries((prev) => prev.filter((e) => e.id !== id));
  }

  const pointsPaid = entries.reduce((sum, e) => sum + e.points_paid, 0);

  return { entries, loading, addEntry, updateEntry, removeEntry, pointsPaid };
}
