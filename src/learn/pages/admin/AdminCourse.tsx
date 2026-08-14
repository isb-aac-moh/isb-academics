import { useEffect, useState } from "react";
import { fetchCourseContent, upsertCourse, upsertCourseContent } from "../../lib/db";
import type { Course, CourseContent } from "../../types";

interface Props {
  courses: Course[];
  courseId: string;
  onCoursesChange: () => void;
}

const EMPTY_CONTENT: CourseContent = {
  course_id: "",
  outline: "",
  announcements: "",
  cheatsheet_url: "",
  exam_samples_url: "",
  feedback_form_url: "",
};

function slugify(name: string): string {
  return name.trim().toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
}

export function AdminCourse({ courses, courseId, onCoursesChange }: Props) {
  const course = courses.find((c) => c.id === courseId) ?? null;

  const [courseDraft, setCourseDraft] = useState({ name: "", code: "", enabled: false });
  const [courseStatus, setCourseStatus] = useState("");

  const [contentDraft, setContentDraft] = useState<CourseContent>(EMPTY_CONTENT);
  const [contentStatus, setContentStatus] = useState("");

  const [newCourseName, setNewCourseName] = useState("");
  const [newCourseStatus, setNewCourseStatus] = useState("");

  useEffect(() => {
    if (!course) return;
    setCourseDraft({ name: course.name, code: course.code ?? "", enabled: course.enabled });
    setCourseStatus("");
    void loadContent(course.id);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseId]);

  async function loadContent(id: string) {
    const data = await fetchCourseContent(id);
    setContentDraft({
      course_id: id,
      outline: data?.outline ?? "",
      announcements: data?.announcements ?? "",
      cheatsheet_url: data?.cheatsheet_url ?? "",
      exam_samples_url: data?.exam_samples_url ?? "",
      feedback_form_url: data?.feedback_form_url ?? "",
    });
  }

  async function handleSaveCourse() {
    if (!course) return;
    setCourseStatus("Saving…");
    try {
      await upsertCourse({ ...course, ...courseDraft, code: courseDraft.code.trim() || null });
    } catch (err) {
      setCourseStatus(`Error: ${(err as Error).message}`);
      return;
    }
    setCourseStatus("Saved.");
    onCoursesChange();
  }

  async function handleSaveContent() {
    setContentStatus("Saving…");
    try {
      await upsertCourseContent({
        course_id: courseId,
        outline: contentDraft.outline?.trim() || null,
        announcements: contentDraft.announcements?.trim() || null,
        cheatsheet_url: contentDraft.cheatsheet_url?.trim() || null,
        exam_samples_url: contentDraft.exam_samples_url?.trim() || null,
        feedback_form_url: contentDraft.feedback_form_url?.trim() || null,
      });
    } catch (err) {
      setContentStatus(`Error: ${(err as Error).message}`);
      return;
    }
    setContentStatus("Saved.");
  }

  async function handleAddCourse() {
    const name = newCourseName.trim();
    if (!name) return;
    const id = slugify(name);
    if (courses.some((c) => c.id === id)) {
      setNewCourseStatus("A course with that name already exists.");
      return;
    }
    setNewCourseStatus("Adding…");
    try {
      await upsertCourse({ id, name, code: null, total_sessions: 0, enabled: false, sort_order: courses.length });
    } catch (err) {
      setNewCourseStatus(`Error: ${(err as Error).message}`);
      return;
    }
    setNewCourseName("");
    setNewCourseStatus("Added — disabled until you switch it on below.");
    onCoursesChange();
  }

  if (!course) return null;

  return (
    <div>
      <div className="card p-4 mb-6">
        <label className="text-xs text-ink-soft mb-1 block">Add a new course</label>
        <div className="flex items-center gap-2">
          <input
            className="input"
            placeholder="e.g. Operations"
            value={newCourseName}
            onChange={(e) => setNewCourseName(e.target.value)}
          />
          <button onClick={() => void handleAddCourse()} className="btn btn-primary shrink-0">
            Add
          </button>
        </div>
        {newCourseStatus && <p className="text-sm text-ink-soft mt-2">{newCourseStatus}</p>}
      </div>

      <div className="card p-4 mb-6 flex flex-col gap-3">
        <div>
          <label className="text-xs text-ink-soft mb-1 block">Course name</label>
          <input
            className="input"
            value={courseDraft.name}
            onChange={(e) => setCourseDraft((d) => ({ ...d, name: e.target.value }))}
          />
        </div>
        <div>
          <label className="text-xs text-ink-soft mb-1 block">Course code (optional)</label>
          <input
            className="input"
            placeholder="e.g. MKTG273"
            value={courseDraft.code}
            onChange={(e) => setCourseDraft((d) => ({ ...d, code: e.target.value }))}
          />
        </div>
        <label className="flex items-center gap-2 text-sm">
          <input
            type="checkbox"
            checked={courseDraft.enabled}
            onChange={(e) => setCourseDraft((d) => ({ ...d, enabled: e.target.checked }))}
          />
          Visible to students (uncheck to keep building it out privately)
        </label>
        <div className="flex items-center gap-3">
          <button onClick={() => void handleSaveCourse()} className="btn btn-primary self-start">
            Save
          </button>
          {courseStatus && <p className="text-sm text-ink-soft">{courseStatus}</p>}
        </div>
      </div>

      <p className="text-sm text-ink-soft mb-4">
        Course-wide content, shown to students at the top of the {course.name} sessions page.
      </p>
      <div className="card p-4 flex flex-col gap-4">
        <div>
          <label className="text-xs text-ink-soft mb-1 block">Key dates / announcements</label>
          <textarea
            className="input"
            placeholder="e.g. Final exam moved to Friday, Nov 14"
            value={contentDraft.announcements ?? ""}
            onChange={(e) => setContentDraft((d) => ({ ...d, announcements: e.target.value }))}
          />
        </div>
        <div>
          <label className="text-xs text-ink-soft mb-1 block">Course outline</label>
          <textarea
            className="input"
            placeholder="What the course covers, session by session"
            value={contentDraft.outline ?? ""}
            onChange={(e) => setContentDraft((d) => ({ ...d, outline: e.target.value }))}
          />
        </div>
        <div>
          <label className="text-xs text-ink-soft mb-1 block">Cheatsheet link (OneDrive)</label>
          <input
            className="input"
            placeholder="https://..."
            value={contentDraft.cheatsheet_url ?? ""}
            onChange={(e) => setContentDraft((d) => ({ ...d, cheatsheet_url: e.target.value }))}
          />
        </div>
        <div>
          <label className="text-xs text-ink-soft mb-1 block">Past / sample exam questions link</label>
          <input
            className="input"
            placeholder="https://..."
            value={contentDraft.exam_samples_url ?? ""}
            onChange={(e) => setContentDraft((d) => ({ ...d, exam_samples_url: e.target.value }))}
          />
        </div>
        <div>
          <label className="text-xs text-ink-soft mb-1 block">Feedback form link</label>
          <input
            className="input"
            placeholder="https://..."
            value={contentDraft.feedback_form_url ?? ""}
            onChange={(e) => setContentDraft((d) => ({ ...d, feedback_form_url: e.target.value }))}
          />
        </div>
        <div className="flex items-center gap-3">
          <button onClick={() => void handleSaveContent()} className="btn btn-primary self-start">
            Save
          </button>
          {contentStatus && <p className="text-sm text-ink-soft">{contentStatus}</p>}
        </div>
      </div>
    </div>
  );
}
