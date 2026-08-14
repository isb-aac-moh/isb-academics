import { useEffect, useState } from "react";
import { deleteConcept, fetchConcepts, upsertConcept } from "../../lib/db";
import type { Concept } from "../../types";

interface Props {
  courseId: string;
}

function emptyForm(courseId: string): Concept {
  return { course_id: courseId, topic: "", title: "", note: "", resource_url: "" };
}

export function AdminConcepts({ courseId }: Props) {
  const [concepts, setConcepts] = useState<Record<string, Concept>>({});
  const [form, setForm] = useState<Concept>(emptyForm(courseId));
  const [status, setStatus] = useState("");

  async function load() {
    setConcepts(await fetchConcepts(courseId));
  }

  useEffect(() => {
    void load();
    setForm(emptyForm(courseId));
    setStatus("");
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseId]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!form.topic.trim() || !form.title.trim() || !form.note.trim()) {
      setStatus("Topic key, title, and note are all required.");
      return;
    }
    setStatus("Saving…");
    try {
      await upsertConcept({
        course_id: courseId,
        topic: form.topic.trim(),
        title: form.title.trim(),
        note: form.note.trim(),
        resource_url: form.resource_url?.trim() || null,
      });
    } catch (err) {
      setStatus(`Error: ${(err as Error).message}`);
      return;
    }
    setStatus("Saved.");
    setForm(emptyForm(courseId));
    void load();
  }

  async function handleDelete(topic: string) {
    await deleteConcept(courseId, topic);
    void load();
  }

  const list = Object.values(concepts).sort((a, b) => a.topic.localeCompare(b.topic));

  return (
    <div>
      <p className="text-sm text-ink-soft mb-4">
        The teach-first note shown before a topic's first question. Topic key must match the
        topic used on the Questions tab exactly — saving an existing key overwrites that concept.
      </p>

      <form onSubmit={handleSubmit} className="flex flex-col gap-3 mb-10 card p-5">
        <input
          className="input"
          placeholder="Topic key (e.g. clv, case_kookaburra)"
          value={form.topic}
          onChange={(e) => setForm({ ...form, topic: e.target.value })}
        />
        <input
          className="input"
          placeholder="Title (shown to students)"
          value={form.title}
          onChange={(e) => setForm({ ...form, title: e.target.value })}
        />
        <textarea
          className="input"
          placeholder="Teaching note"
          value={form.note}
          onChange={(e) => setForm({ ...form, note: e.target.value })}
        />
        <input
          className="input"
          placeholder="Slides/resource link (optional)"
          value={form.resource_url ?? ""}
          onChange={(e) => setForm({ ...form, resource_url: e.target.value })}
        />
        <button className="btn btn-primary">Save concept</button>
        {status && <p className="text-sm text-ink-soft">{status}</p>}
      </form>

      <h2 className="text-sm uppercase tracking-wide text-ink-soft mb-3 font-medium">
        {list.length} concept{list.length === 1 ? "" : "s"}
      </h2>
      <div className="flex flex-col gap-2">
        {list.map((c) => (
          <div key={c.topic} className="card p-3 text-sm flex justify-between gap-3">
            <div>
              <div className="text-ink-soft">{c.topic}</div>
              <div className="font-medium">{c.title}</div>
              <div className="text-ink-soft">{c.note}</div>
            </div>
            <div className="flex flex-col gap-1 items-end shrink-0">
              <button onClick={() => setForm(c)} className="text-accent hover:brightness-110">
                Edit
              </button>
              <button onClick={() => handleDelete(c.topic)} className="text-bad hover:brightness-110">
                Delete
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
