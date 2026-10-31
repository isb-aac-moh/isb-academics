import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, fetchShared } from "../lib/queryCache";
import type { Course, GatingCoreCourse } from "../types";

type CourseData = { courses: Course[]; gatingCourses: GatingCoreCourse[] };

/** showAll=true (admin) sees disabled courses too; students only ever see active ones. */
export function loadCourses(showAll = false, force = false) {
  return fetchShared<CourseData>(`courses:${showAll}`, async () => {
    let query = supabase.from("courses").select("*").order("term").order("code");
    if (!showAll) query = query.eq("is_active", true);
    const [coursesRes, gatingRes] = await Promise.all([
      query,
      supabase.from("gating_core_courses").select("*"),
    ]);
    return {
      courses: (coursesRes.data as Course[]) ?? [],
      gatingCourses: (gatingRes.data as GatingCoreCourse[]) ?? [],
    };
  }, force);
}

export function useCourses(showAll = false) {
  const hit = cached<CourseData>(`courses:${showAll}`);
  const [courses, setCourses] = useState<Course[]>(hit?.courses ?? []);
  const [gatingCourses, setGatingCourses] = useState<GatingCoreCourse[]>(hit?.gatingCourses ?? []);
  const [loading, setLoading] = useState(!hit);

  // Called with no argument by an admin after a save (forces a fresh read); the mount effect asks
  // for the shared copy and lets a request already in flight answer it.
  const reload = useCallback(async (force = true) => {
    const data = await loadCourses(showAll, force);
    setCourses(data.courses);
    setGatingCourses(data.gatingCourses);
    setLoading(false);
  }, [showAll]);

  useEffect(() => {
    reload(false);
  }, [reload]);

  return { courses, gatingCourses, loading, reload };
}
