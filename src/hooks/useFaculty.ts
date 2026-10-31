import { useCallback, useEffect, useState } from "react";
import { supabase } from "../lib/supabase";
import { cached, fetchShared } from "../lib/queryCache";
import type { CourseFaculty, Faculty, FacultyRating } from "../types";

export interface CourseFacultyEntry extends CourseFaculty {
  faculty: Faculty;
  ratings: FacultyRating[]; // newest first
}

type ByCourse = Map<string, CourseFacultyEntry[]>;

function loadFaculty(force: boolean) {
  return fetchShared<ByCourse>("faculty", async () => {
    const [f, cf, r] = await Promise.all([
      supabase.from("faculty").select("*"),
      supabase.from("course_faculty").select("*").order("sort_order"),
      supabase.from("faculty_ratings").select("*").order("sort_key", { ascending: false }),
    ]);
    const faculty = new Map(((f.data as Faculty[]) ?? []).map((x) => [x.id, x]));
    const ratings = new Map<string, FacultyRating[]>();
    ((r.data as FacultyRating[]) ?? []).forEach((x) => ratings.set(x.faculty_id, [...(ratings.get(x.faculty_id) ?? []), x]));
    const map: ByCourse = new Map();
    ((cf.data as CourseFaculty[]) ?? []).forEach((x) => {
      const fac = faculty.get(x.faculty_id);
      if (fac) map.set(x.course_id, [...(map.get(x.course_id) ?? []), { ...x, faculty: fac, ratings: ratings.get(x.faculty_id) ?? [] }]);
    });
    return map;
  }, force);
}

export function useFaculty() {
  const hit = cached<ByCourse>("faculty");
  const [byCourse, setByCourse] = useState<ByCourse>(hit ?? new Map());
  const [loading, setLoading] = useState(!hit);

  const reload = useCallback(async (force = true) => {
    setByCourse(await loadFaculty(force));
    setLoading(false);
  }, []);

  useEffect(() => {
    reload(false);
  }, [reload]);

  return { byCourse, loading, reload };
}

export const HOME_CAMPUS = "Mohali"; // this app serves the Mohali cohort

// The single real rating shown at a glance, never an average. Order: this course
// at Mohali, this course at Hyderabad, this course with no campus stated, then the
// professor's latest on any other course. Newest first within each step.
export function headlineRating(ratings: FacultyRating[], courseCode: string) {
  const base = courseCode.replace(/\d+$/, "");
  const scored = ratings.filter((r) => r.instructor_rating !== null);
  const same = scored.filter((r) => r.course_code?.replace(/\d+$/, "") === base);
  const pick = same.find((r) => r.campus === HOME_CAMPUS) ?? same.find((r) => r.campus !== null) ?? same[0];
  if (pick) return { rating: pick, sameCourse: true };
  return scored[0] ? { rating: scored[0], sameCourse: false } : null;
}
