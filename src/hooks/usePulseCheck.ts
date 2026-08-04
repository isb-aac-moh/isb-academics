import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { PulseCheckSubmission, PulseCheckResult, PulseCheckHistogramBucket } from "../types";

export const PULSE_CHECK_MIN_RESPONDENTS = 5;
export const PULSE_CHECK_MAX_EDITS = 3;

export function usePulseCheck(userId: string | undefined, liveBiddingTerms: string[]) {
  const [ownSubmissions, setOwnSubmissions] = useState<PulseCheckSubmission[]>([]);
  const [results, setResults] = useState<Record<string, PulseCheckResult[]>>({});
  const [histograms, setHistograms] = useState<Record<string, PulseCheckHistogramBucket[]>>({});
  const [loading, setLoading] = useState(true);
  const [submitError, setSubmitError] = useState<string | null>(null);

  const termsKey = liveBiddingTerms.join(",");

  const reload = useCallback(async () => {
    if (!userId) { setLoading(false); return; }
    setLoading(true);
    const terms = termsKey ? termsKey.split(",") : [];
    const [ownRes, ...termResults] = await Promise.all([
      supabase.from("pulse_check_submissions").select("*").eq("user_id", userId),
      ...terms.map((term) => supabase.rpc("pulse_check_results_by_term", { p_term: term })),
      ...terms.map((term) => supabase.rpc("pulse_check_histogram_by_term", { p_term: term })),
    ]);
    setOwnSubmissions((ownRes.data as PulseCheckSubmission[]) ?? []);
    const nextResults: Record<string, PulseCheckResult[]> = {};
    const nextHistograms: Record<string, PulseCheckHistogramBucket[]> = {};
    terms.forEach((term, i) => {
      nextResults[term] = (termResults[i]?.data as PulseCheckResult[]) ?? [];
      nextHistograms[term] = (termResults[terms.length + i]?.data as PulseCheckHistogramBucket[]) ?? [];
    });
    setResults(nextResults);
    setHistograms(nextHistograms);
    setLoading(false);
  }, [userId, termsKey]);

  useEffect(() => {
    reload();
  }, [reload]);

  async function submit(entry: { course_id: string; term: string; bid_points_estimate: number }) {
    if (!userId) return;
    setSubmitError(null);
    const { error } = await supabase
      .from("pulse_check_submissions")
      .insert({ ...entry, user_id: userId });
    if (error) {
      console.error("[usePulseCheck] submit failed:", error);
      setSubmitError(
        error.code === "23505"
          ? "You've already submitted a pulse for this course."
          : "Couldn't submit — check your connection and try again."
      );
      return;
    }
    await reload();
  }

  // Up to 3 edits allowed, enforced at the RLS layer (edit_count can only
  // climb, and the update policy stops matching once it hits 3) — a rejected
  // 4th attempt lands here as a generic "no rows updated" no-op from
  // Supabase, not a thrown error. `original` is the submission being edited
  // (there can be several per term); `entry.course_id` is what it's being
  // changed to, which may be the same course or a different one.
  async function edit(original: PulseCheckSubmission, entry: { course_id: string; bid_points_estimate: number }) {
    if (!userId) return;
    setSubmitError(null);
    const { data, error } = await supabase
      .from("pulse_check_submissions")
      .update({ ...entry, edit_count: original.edit_count + 1 })
      .eq("id", original.id)
      .eq("user_id", userId)
      .select("id");
    if (error) {
      console.error("[usePulseCheck] edit failed:", error);
      setSubmitError("Couldn't save your edit — check your connection and try again.");
      return;
    }
    if (!data || data.length === 0) {
      setSubmitError("This submission has already used up its 3 allowed edits.");
      return;
    }
    await reload();
  }

  async function remove(submissionId: string) {
    if (!userId) return;
    setSubmitError(null);
    const { error } = await supabase
      .from("pulse_check_submissions")
      .delete()
      .eq("id", submissionId)
      .eq("user_id", userId);
    if (error) {
      console.error("[usePulseCheck] remove failed:", error);
      setSubmitError("Couldn't remove that submission — check your connection and try again.");
      return;
    }
    await reload();
  }

  return { ownSubmissions, results, histograms, loading, submitError, submit, edit, remove };
}
