import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { Course, GatingCoreCourse } from "../types";

/** showAll=true (admin) sees disabled courses too; students only ever see active ones. */
export function useCourses(showAll = false) {
  const [courses, setCourses] = useState<Course[]>([]);
  const [gatingCourses, setGatingCourses] = useState<GatingCoreCourse[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    let query = supabase.from("courses").select("*").order("term").order("code");
    if (!showAll) query = query.eq("is_active", true);
    const [coursesRes, gatingRes] = await Promise.all([
      query,
      supabase.from("gating_core_courses").select("*"),
    ]);
    setCourses((coursesRes.data as Course[]) ?? []);
    setGatingCourses((gatingRes.data as GatingCoreCourse[]) ?? []);
    setLoading(false);
  }, [showAll]);

  useEffect(() => {
    reload();
  }, [reload]);

  return { courses, gatingCourses, loading, reload };
}
