import { useEffect, useState } from "react";
import { deleteScenario, fetchScenarios, upsertScenario } from "../../lib/db";
import type { Scenario } from "../../types";

interface Props {
  courseId: string;
}

const emptyForm = { id: "", session: 1, title: "", setup: "", source: "" };

export function AdminScenarios({ courseId }: Props) {
  const [scenarios, setScenarios] = useState<Scenario[]>([]);
  const [form, setForm] = useState(emptyForm);
  const [status, setStatus] = useState("");

  async function load() {
    const map = await fetchScenarios(courseId);
    setScenarios(Object.values(map).sort((a, b) => a.session - b.session));
  }

  useEffect(() => {
    void load();
    setForm(emptyForm);
    setStatus("");
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseId]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setStatus("Saving…");
    const id = form.id.trim() || `${courseId.slice(0, 3)}-s${form.session}-${crypto.randomUUID().slice(0, 6)}`;
    try {
      await upsertScenario({
        id,
        course_id: courseId,
        session: form.session,
        title: form.title.trim(),
        setup: form.setup.trim(),
        source: form.source.trim() || null,
      });
      setStatus("Saved.");
      setForm(emptyForm);
      void load();
    } catch (err) {
      setStatus(`Error: ${err instanceof Error ? err.message : "failed"}`);
    }
  }

  async function handleDelete(id: string) {
    try {
      await deleteScenario(id);
      void load();
    } catch (err) {
      setStatus(`Error: ${err instanceof Error ? err.message : "delete failed"}`);
    }
  }

  return (
    <div>
      <p className="text-sm text-ink-soft mb-4">
        A scenario is a shared setup with several questions hanging off it. Questions link to one from
        the Questions tab. Deleting a scenario leaves its questions in place as standalone. Click Edit
        on an existing scenario to update it in place.
      </p>

      <form onSubmit={handleSubmit} className="flex flex-col gap-3 mb-8">
        <label className="text-xs text-ink-soft">
          Session
          <input
            type="number"
            min={1}
            value={form.session}
            onChange={(e) => setForm({ ...form, session: Number(e.target.value) })}
            className="input mt-1"
            required
          />
        </label>
        <label className="text-xs text-ink-soft">
          Title
          <input
            value={form.title}
            onChange={(e) => setForm({ ...form, title: e.target.value })}
            placeholder="Rent-an-AI-Startup"
            className="input mt-1"
            required
          />
        </label>
        <label className="text-xs text-ink-soft">
          Setup (Markdown — same conventions as concept notes)
          <textarea
            value={form.setup}
            onChange={(e) => setForm({ ...form, setup: e.target.value })}
            rows={6}
            className="input mt-1"
            required
          />
        </label>
        <label className="text-xs text-ink-soft">
          Source
          <input
            value={form.source}
            onChange={(e) => setForm({ ...form, source: e.target.value })}
            placeholder="Quiz 1, Q6-Q8"
            className="input mt-1"
          />
        </label>
        <button type="submit" className="btn btn-primary self-start">
          Save scenario
        </button>
        {status && <p className="text-xs text-ink-soft">{status}</p>}
      </form>

      <div className="flex flex-col divide-y divide-line">
        {scenarios.map((s) => (
          <div key={s.id} className="py-3 flex items-start justify-between gap-4">
            <div className="min-w-0">
              <div className="text-sm font-medium">
                S{s.session} · {s.title}
              </div>
              <div className="text-xs text-ink-soft line-clamp-2">{s.setup}</div>
            </div>
            <div className="flex flex-col gap-1 items-end shrink-0">
              <button
                onClick={() => setForm({ ...s, source: s.source ?? "" })}
                className="text-xs text-accent hover:underline"
              >
                Edit
              </button>
              <button onClick={() => void handleDelete(s.id)} className="text-xs text-bad hover:underline">
                Delete
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
