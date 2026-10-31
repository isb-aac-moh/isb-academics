import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, fetchShared } from "../lib/queryCache";
import type { CourseGradingProfile } from "../types";

type Profiles = Map<string, CourseGradingProfile>;

function loadProfiles(force: boolean) {
  return fetchShared<Profiles>("course_grading_profiles", async () => {
    const { data } = await supabase.from("course_grading_profiles").select("*");
    return new Map((data as CourseGradingProfile[] ?? []).map((p) => [p.course_id, p]));
  }, force);
}

export function useCourseGradingProfiles() {
  const hit = cached<Profiles>("course_grading_profiles");
  const [profiles, setProfiles] = useState<Profiles>(hit ?? new Map());
  const [loading, setLoading] = useState(!hit);

  const reload = useCallback(async (force = true) => {
    setProfiles(await loadProfiles(force));
    setLoading(false);
  }, []);

  useEffect(() => {
    reload(false);
  }, [reload]);

  return { profiles, loading, reload };
}
