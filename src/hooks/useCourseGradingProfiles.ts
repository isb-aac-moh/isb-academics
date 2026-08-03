import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { CourseGradingProfile } from "../types";

export function useCourseGradingProfiles() {
  const [profiles, setProfiles] = useState<Map<string, CourseGradingProfile>>(new Map());
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from("course_grading_profiles").select("*");
    setProfiles(new Map((data as CourseGradingProfile[] ?? []).map((p) => [p.course_id, p])));
    setLoading(false);
  }, []);

  useEffect(() => {
    reload();
  }, [reload]);

  return { profiles, loading, reload };
}
