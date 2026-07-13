import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { StudentAcademicProfile } from "../types";

const EMPTY: Omit<StudentAcademicProfile, "user_id"> = {
  undergrad_field: "",
  work_ex_domain: "",
  work_ex_years: 0,
  failed_gating_courses: [],
  target_concentrations: [],
  target_specialization: "undecided",
  completed_term2_flexi: [],
  completed_term3_flexi: [],
};

export function useAcademicProfile(userId: string | undefined) {
  const [profile, setProfile] = useState<StudentAcademicProfile | null>(null);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    if (!userId) { setLoading(false); return; }
    setLoading(true);
    const { data } = await supabase
      .from("student_academic_profiles")
      .select("*")
      .eq("user_id", userId)
      .maybeSingle();
    setProfile((data as StudentAcademicProfile) ?? { user_id: userId, ...EMPTY });
    setLoading(false);
  }, [userId]);

  useEffect(() => {
    reload();
  }, [reload]);

  async function save(updates: Partial<StudentAcademicProfile>) {
    if (!userId) return;
    const next = { ...(profile ?? { user_id: userId, ...EMPTY }), ...updates };
    setProfile(next);
    const { error } = await supabase
      .from("student_academic_profiles")
      .upsert({ ...next, user_id: userId }, { onConflict: "user_id" });
    if (error) console.error("[useAcademicProfile] save failed:", error);
  }

  return { profile, loading, save };
}
