import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { Course, GatingCoreCourse } from "../types";

export function useCourses() {
  const [courses, setCourses] = useState<Course[]>([]);
  const [gatingCourses, setGatingCourses] = useState<GatingCoreCourse[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    const [coursesRes, gatingRes] = await Promise.all([
      supabase.from("courses").select("*").order("term").order("code"),
      supabase.from("gating_core_courses").select("*"),
    ]);
    setCourses((coursesRes.data as Course[]) ?? []);
    setGatingCourses((gatingRes.data as GatingCoreCourse[]) ?? []);
    setLoading(false);
  }, []);

  useEffect(() => {
    reload();
  }, [reload]);

  return { courses, gatingCourses, loading, reload };
}
