import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, remember, takeEarly } from "../lib/queryCache";
import type { StudentAcademicProfile } from "../types";

const EMPTY: Omit<StudentAcademicProfile, "user_id"> = {
  undergrad_field: "",
  work_ex_domain: "",
  work_ex_role: "",
  work_ex_years: 0,
  failed_gating_courses: [],
  target_concentrations: [],
  target_specialization: "undecided",
  completed_term2_flexi: [],
  completed_term3_flexi: [],
  term2_converted_elective: null,
  term3_converted_elective: null,
  international_exchange_points_used: null,
  inter_campus_exchange_points_used: null,
  cross_listed_concentration_choices: {},
};

export const academicProfileKey = (userId: string) => `academic_profile:${userId}`;

export async function fetchAcademicProfile(userId: string) {
  const { data } = await supabase
    .from("student_academic_profiles")
    .select("*")
    .eq("user_id", userId)
    .maybeSingle();
  return data;
}

export function useAcademicProfile(userId: string | undefined) {
  const hit = userId ? cached<StudentAcademicProfile>(academicProfileKey(userId)) : undefined;
  const [profile, setProfile] = useState<StudentAcademicProfile | null>(hit ?? null);
  const [loading, setLoading] = useState(!hit);
  const [saveError, setSaveError] = useState<string | null>(null);

  const reload = useCallback(async () => {
    if (!userId) { setLoading(false); return; }
    const data = await takeEarly(academicProfileKey(userId), () => fetchAcademicProfile(userId));
    setProfile((data as StudentAcademicProfile) ?? { user_id: userId, ...EMPTY });
    setLoading(false);
  }, [userId]);

  useEffect(() => {
    reload();
  }, [reload]);

  // Keep the shared copy in step with every change, saves included, for the next page that asks.
  useEffect(() => {
    if (userId && profile) remember(academicProfileKey(userId), profile);
  }, [userId, profile]);

  async function save(updates: Partial<StudentAcademicProfile>) {
    if (!userId) return;
    const previous = profile;
    const next = { ...(profile ?? { user_id: userId, ...EMPTY }), ...updates };
    setProfile(next);
    const { error } = await supabase
      .from("student_academic_profiles")
      .upsert({ ...next, user_id: userId }, { onConflict: "user_id" });
    if (error) {
      console.error("[useAcademicProfile] save failed:", error);
      setProfile(previous);
      setSaveError("Couldn't save your change — check your connection and try again.");
    } else {
      setSaveError(null);
    }
  }

  return { profile, loading, saveError, save };
}
