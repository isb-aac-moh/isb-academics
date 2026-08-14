import { useEffect, useState } from "react";
import { fetchSessionContent, upsertCourse, upsertSessionContent } from "../../lib/db";
import type { Course, SessionContent } from "../../types";

interface Props {
  course: Course;
  onCourseChange: () => void;
}

type Draft = { title: string; summary: string; resource_url: string };

export function AdminSessions({ course, onCourseChange }: Props) {
  const [drafts, setDrafts] = useState<Record<number, Draft>>({});
  const [status, setStatus] = useState<Record<number, string>>({});
  const [totalSessionsInput, setTotalSessionsInput] = useState(String(course.total_sessions));
  const [totalSessionsStatus, setTotalSessionsStatus] = useState("");

  useEffect(() => {
    void load();
    setTotalSessionsInput(String(course.total_sessions));
    setTotalSessionsStatus("");
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [course.id, course.total_sessions]);

  async function load() {
    const data = await fetchSessionContent(course.id);
    const next: Record<number, Draft> = {};
    for (let s = 1; s <= course.total_sessions; s++) {
      next[s] = {
        title: data[s]?.title ?? "",
        summary: data[s]?.summary ?? "",
        resource_url: data[s]?.resource_url ?? "",
      };
    }
    setDrafts(next);
  }

  async function handleSaveTotalSessions() {
    const n = Math.max(0, Math.min(30, Number(totalSessionsInput) || 0));
    setTotalSessionsStatus("Saving…");
    try {
      await upsertCourse({ ...course, total_sessions: n });
    } catch (err) {
      setTotalSessionsStatus(`Error: ${(err as Error).message}`);
      return;
    }
    setTotalSessionsStatus("Saved.");
    onCourseChange();
  }

  async function handleSave(session: number) {
    setStatus((s) => ({ ...s, [session]: "Saving…" }));
    const draft = drafts[session];
    try {
      const content: SessionContent = {
        course_id: course.id,
        session,
        title: draft.title.trim() || null,
        summary: draft.summary.trim() || null,
        resource_url: draft.resource_url.trim() || null,
      };
      await upsertSessionContent(content);
    } catch (err) {
      setStatus((s) => ({ ...s, [session]: `Error: ${(err as Error).message}` }));
      return;
    }
    setStatus((s) => ({ ...s, [session]: "Saved." }));
  }

  return (
    <div>
      <div className="card p-4 mb-6 flex items-end gap-3">
        <div>
          <label className="text-xs text-ink-soft mb-1 block">Total sessions in {course.name}</label>
          <input
            className="input w-24"
            type="number"
            min={0}
            max={30}
            value={totalSessionsInput}
            onChange={(e) => setTotalSessionsInput(e.target.value)}
          />
        </div>
        <button onClick={() => void handleSaveTotalSessions()} className="btn btn-primary">
          Save
        </button>
        {totalSessionsStatus && <p className="text-sm text-ink-soft">{totalSessionsStatus}</p>}
      </div>

      <p className="text-sm text-ink-soft mb-4">
        A title, short summary, and a slides/resource link for each session, shown to students on
        the Sessions page.
      </p>
      {course.total_sessions === 0 ? (
        <p className="text-sm text-ink-soft">Set total sessions above to start adding session content.</p>
      ) : (
        <div className="flex flex-col gap-4">
          {Array.from({ length: course.total_sessions }, (_, i) => i + 1).map((session) => (
            <div key={session} className="card p-4 flex flex-col">
              <div className="text-sm font-medium mb-2">Session {session}</div>
              <input
                className="input mb-2"
                placeholder="Session title"
                value={drafts[session]?.title ?? ""}
                onChange={(e) =>
                  setDrafts((d) => ({ ...d, [session]: { ...d[session], title: e.target.value } }))
                }
              />
              <textarea
                className="input mb-2"
                placeholder="Session summary (optional)"
                value={drafts[session]?.summary ?? ""}
                onChange={(e) =>
                  setDrafts((d) => ({ ...d, [session]: { ...d[session], summary: e.target.value } }))
                }
              />
              <input
                className="input mb-2"
                placeholder="Slides/resource link (optional)"
                value={drafts[session]?.resource_url ?? ""}
                onChange={(e) =>
                  setDrafts((d) => ({ ...d, [session]: { ...d[session], resource_url: e.target.value } }))
                }
              />
              <div className="flex items-center gap-3">
                <button onClick={() => void handleSave(session)} className="btn btn-primary">
                  Save
                </button>
                {status[session] && <p className="text-sm text-ink-soft">{status[session]}</p>}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
