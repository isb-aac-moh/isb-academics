import { useEffect, useState } from "react";
import { AdminQuestions } from "./admin/AdminQuestions";
import { AdminScenarios } from "./admin/AdminScenarios";
import { AdminConcepts } from "./admin/AdminConcepts";
import { AdminSessions } from "./admin/AdminSessions";
import { AdminCourse } from "./admin/AdminCourse";
import { AdminMaterials } from "./admin/AdminMaterials";
import { AdminMonitoring } from "./admin/AdminMonitoring";
import { fetchCourses } from "../lib/db";
import type { Course } from "../types";

type Tab = "monitoring" | "questions" | "scenarios" | "concepts" | "sessions" | "materials" | "course";

const TABS: { id: Tab; label: string }[] = [
  { id: "monitoring", label: "Monitoring" },
  { id: "questions", label: "Questions" },
  { id: "scenarios", label: "Scenarios" },
  { id: "concepts", label: "Concepts" },
  { id: "sessions", label: "Sessions" },
  { id: "materials", label: "Materials" },
  { id: "course", label: "Course" },
];

export function AdminPage() {
  const [tab, setTab] = useState<Tab>("monitoring");
  const [courses, setCourses] = useState<Course[]>([]);
  const [courseId, setCourseId] = useState<string>("");

  useEffect(() => {
    void loadCourses();
  }, []);

  async function loadCourses() {
    const cs = await fetchCourses();
    setCourses(cs);
    setCourseId((current) => (current && cs.some((c) => c.id === current) ? current : (cs[0]?.id ?? "")));
  }

  const activeCourse = courses.find((c) => c.id === courseId) ?? null;

  return (
    <div className="max-w-3xl px-4 md:px-8 py-10">
      <h1 className="text-xl font-bold mb-1">Admin</h1>
      <p className="text-sm text-ink-soft mb-6">
        Monitor cohort progress and manage course content. Changes here show up immediately for
        students.
      </p>

      <div className="flex gap-1 mb-4 border-b border-line">
        {TABS.map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={[
              "px-3 py-2 text-sm font-medium border-b-2 -mb-px transition-colors",
              tab === t.id ? "border-accent text-ink" : "border-transparent text-ink-soft hover:text-ink",
            ].join(" ")}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab !== "monitoring" && (
        <div className="flex items-center gap-2 mb-6">
          <label className="text-xs text-ink-soft shrink-0">Course</label>
          <select
            className="input w-auto"
            value={courseId}
            onChange={(e) => setCourseId(e.target.value)}
          >
            {courses.map((c) => (
              <option key={c.id} value={c.id}>
                {c.name}
                {c.enabled ? "" : " (disabled — not visible to students)"}
              </option>
            ))}
          </select>
        </div>
      )}

      {tab === "monitoring" && <AdminMonitoring />}
      {tab === "questions" && courseId && <AdminQuestions courseId={courseId} />}
      {tab === "scenarios" && courseId && <AdminScenarios courseId={courseId} />}
      {tab === "concepts" && courseId && <AdminConcepts courseId={courseId} />}
      {tab === "sessions" && activeCourse && <AdminSessions course={activeCourse} onCourseChange={loadCourses} />}
      {tab === "materials" && activeCourse && <AdminMaterials course={activeCourse} />}
      {tab === "course" && (
        <AdminCourse courses={courses} courseId={courseId} onCoursesChange={loadCourses} />
      )}
    </div>
  );
}
