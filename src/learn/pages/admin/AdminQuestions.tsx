import { useEffect, useState } from "react";
import { deleteQuestion, fetchQuestions, fetchScenarios, insertQuestion } from "../../lib/db";
import type { Provenance, Question, QuestionType, Scenario } from "../../types";

interface Props {
  courseId: string;
}

const emptyForm = {
  type: "formula" as QuestionType,
  topic: "",
  session: 1,
  prompt: "",
  choice1: "",
  choice2: "",
  choice3: "",
  choice4: "",
  correct_answer: "",
  source: "",
  scenario_id: "",
  scenario_order: "",
  difficulty: 2,
  provenance: "prof_verbatim" as Provenance,
};

export function AdminQuestions({ courseId }: Props) {
  const [questions, setQuestions] = useState<Question[]>([]);
  const [scenarios, setScenarios] = useState<Scenario[]>([]);
  const [form, setForm] = useState(emptyForm);
  const [status, setStatus] = useState<string>("");

  async function load() {
    const qs = await fetchQuestions(courseId);
    setQuestions(qs.sort((a, b) => a.session - b.session));
    const scs = await fetchScenarios(courseId);
    setScenarios(Object.values(scs).sort((a, b) => a.session - b.session));
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
    const choices = [form.choice1, form.choice2, form.choice3, form.choice4].filter(Boolean);
    if (choices.length < 2 || !choices.includes(form.correct_answer)) {
      setStatus("Correct answer must match one of the choices exactly.");
      return;
    }
    const id = `${form.type === "formula" ? "f" : "c"}-${crypto.randomUUID().slice(0, 8)}`;
    try {
      await insertQuestion({
        id,
        course_id: courseId,
        type: form.type,
        topic: form.topic.trim(),
        session: form.session,
        prompt: form.prompt.trim(),
        choices,
        correct_answer: form.correct_answer.trim(),
        source: form.source.trim() || `Session ${form.session}`,
        scenario_id: form.scenario_id || null,
        scenario_order: form.scenario_order ? Number(form.scenario_order) : null,
        difficulty: form.difficulty,
        provenance: form.provenance,
      });
    } catch (e) {
      setStatus(`Error: ${e instanceof Error ? e.message : "could not save that question."}`);
      return;
    }
    setStatus("Saved.");
    setForm(emptyForm);
    void load();
  }

  async function handleDelete(id: string) {
    await deleteQuestion(id);
    void load();
  }

  return (
    <div>
      <p className="text-sm text-ink-soft mb-4">
        New questions show up immediately in Smart Practice and Sessions. The topic key groups
        questions together — reuse an existing one (see the list below) to add to a concept, or
        type a new one to start a new concept.
      </p>

      <form onSubmit={handleSubmit} className="flex flex-col gap-3 mb-10 card p-5">
        <div className="flex gap-3">
          <select
            className="input"
            value={form.type}
            onChange={(e) => setForm({ ...form, type: e.target.value as QuestionType })}
          >
            <option value="formula">Formula</option>
            <option value="case_fact">Case fact</option>
          </select>
          <input
            className="input flex-1"
            placeholder="Topic key (e.g. clv, case_kookaburra)"
            value={form.topic}
            onChange={(e) => setForm({ ...form, topic: e.target.value })}
          />
          <input
            className="input w-20"
            type="number"
            min={1}
            max={10}
            placeholder="Session"
            value={form.session}
            onChange={(e) => setForm({ ...form, session: Number(e.target.value) })}
          />
        </div>
        <textarea
          className="input"
          placeholder="Question prompt"
          value={form.prompt}
          onChange={(e) => setForm({ ...form, prompt: e.target.value })}
        />
        {(["choice1", "choice2", "choice3", "choice4"] as const).map((key, i) => (
          <input
            key={key}
            className="input"
            placeholder={`Choice ${i + 1}${i < 2 ? " (required)" : " (optional)"}`}
            value={form[key]}
            onChange={(e) => setForm({ ...form, [key]: e.target.value })}
          />
        ))}
        <input
          className="input"
          placeholder="Correct answer — must exactly match one choice above"
          value={form.correct_answer}
          onChange={(e) => setForm({ ...form, correct_answer: e.target.value })}
        />
        <input
          className="input"
          placeholder="Source note (optional, e.g. Session 6 — CLV)"
          value={form.source}
          onChange={(e) => setForm({ ...form, source: e.target.value })}
        />
        <label className="text-xs text-ink-soft">
          Scenario (optional — links this question into a chain)
          <select
            value={form.scenario_id}
            onChange={(e) => {
              const scenario_id = e.target.value;
              setForm({ ...form, scenario_id, scenario_order: scenario_id ? form.scenario_order : "" });
            }}
            className="input mt-1"
          >
            <option value="">None — standalone question</option>
            {scenarios.map((s) => (
              <option key={s.id} value={s.id}>
                S{s.session} · {s.title}
              </option>
            ))}
          </select>
        </label>

        {form.scenario_id && (
          <label className="text-xs text-ink-soft">
            Position in the chain
            <input
              type="number"
              min={1}
              value={form.scenario_order}
              onChange={(e) => setForm({ ...form, scenario_order: e.target.value })}
              className="input mt-1"
              required
            />
          </label>
        )}

        <label className="text-xs text-ink-soft">
          Provenance
          <select
            value={form.provenance}
            onChange={(e) => setForm({ ...form, provenance: e.target.value as Provenance })}
            className="input mt-1"
          >
            <option value="prof_verbatim">Prof verbatim — his question, his numbers</option>
            <option value="prof_adapted">Prof adapted — his scenario, re-angled</option>
            <option value="authored">Authored — new, in his style</option>
          </select>
        </label>

        <label className="text-xs text-ink-soft">
          Difficulty
          <select
            value={form.difficulty}
            onChange={(e) => setForm({ ...form, difficulty: Number(e.target.value) })}
            className="input mt-1"
          >
            <option value={1}>1 — recall</option>
            <option value={2}>2 — standard</option>
            <option value={3}>3 — multi-step</option>
          </select>
        </label>

        <button className="btn btn-primary">Add question</button>
        {status && <p className="text-sm text-ink-soft">{status}</p>}
      </form>

      <h2 className="text-sm uppercase tracking-wide text-ink-soft mb-3 font-medium">
        {questions.length} question{questions.length === 1 ? "" : "s"} in the bank
      </h2>
      <div className="flex flex-col gap-2">
        {questions.map((q) => (
          <div key={q.id} className="card p-3 text-sm flex justify-between gap-3">
            <div>
              <div className="text-ink-soft">
                S{q.session} · {q.type} · {q.topic}
              </div>
              <div>{q.prompt}</div>
            </div>
            <button onClick={() => handleDelete(q.id)} className="text-bad shrink-0 hover:brightness-110">
              Delete
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
