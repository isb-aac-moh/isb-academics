import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import type { Course, Student } from "../types";
import { fetchCourses } from "../lib/db";
import { ChevronRightIcon } from "../components/icons";

interface Props {
  profile: Student;
}

/**
 * Subject picker. The bottom bar carries one "Learn" tab rather than one tab per course — a tab per
 * subject stops fitting the moment a third course lands — so this is the step between the tab and a
 * course's sessions.
 */
export function LearnPage({ profile }: Props) {
  const navigate = useNavigate();
  const [courses, setCourses] = useState<Course[] | null>(null);

  useEffect(() => {
    void fetchCourses().then(setCourses);
  }, []);

  return (
    <div className="px-5 py-8 md:px-8 md:py-10 max-w-3xl">
      <h1 className="text-2xl font-bold tracking-[-0.02em] mb-1.5">Learn</h1>
      <p className="text-ink-soft mb-7">Pick a subject to read its sessions and concepts.</p>

      {courses === null ? (
        <p className="text-sm text-ink-soft">Loading…</p>
      ) : (
        <div className="grid gap-3 sm:grid-cols-2">
          {courses.map((c) => {
            const open = c.enabled || profile.is_admin;
            return (
              <button
                key={c.id}
                onClick={() => open && navigate(`/learn/sessions/${c.id}`)}
                disabled={!open}
                className={`card text-left p-5 flex items-start justify-between gap-3 ${
                  open ? "card-hover" : "opacity-55 cursor-default"
                }`}
              >
                <span className="min-w-0">
                  <span className="block font-semibold mb-0.5">{c.name}</span>
                  <span className="block text-sm text-ink-soft">
                    {c.code ?? ""}
                    {!c.enabled && (profile.is_admin ? " · preview" : " · coming soon")}
                  </span>
                </span>
                {open && <ChevronRightIcon className="shrink-0 text-ink-soft mt-0.5" />}
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}
