/**
 * Admin — for the AAC resource coordinator (Anuj) to manage courses, resources,
 * and notifications without needing a code change. Gated on user.is_admin (App.tsx).
 */
import { useState } from "react";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { supabase } from "../lib/supabase";
import type { ConcentrationArea, IndustrySpecialization, TermCode } from "../types";

const CONCENTRATIONS: ConcentrationArea[] = [
  "Entrepreneurship", "Finance", "Marketing", "Operations Management",
  "Information Technology Management", "Strategy and Leadership",
];
const SPECIALIZATIONS: IndustrySpecialization[] = ["Healthcare", "Manufacturing", "Public Policy", "Infrastructure"];
const TERMS: TermCode[] = ["Term 4", "Term 5", "Term 6", "Term 7", "Block Week 1", "Block Week 2", "Block Week 3", "Block Week 4"];

type Tab = "courses" | "resources" | "notifications";

export default function AdminPage() {
  const [tab, setTab] = useState<Tab>("courses");

  return (
    <div className="min-h-screen pb-24" style={{ background: COLOR.bg }}>
      <header className="px-5 md:px-8 pt-10 pb-4 border-b" style={{ borderColor: COLOR.borderLight }}>
        <h1 style={{ fontFamily: FONT.serif, fontSize: 26, fontWeight: 500, color: COLOR.ink }}>Admin</h1>
        <div className="flex gap-2 mt-4">
          {(["courses", "resources", "notifications"] as Tab[]).map((t) => (
            <button
              key={t}
              onClick={() => setTab(t)}
              style={{
                padding: "7px 14px", borderRadius: 8, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans,
                textTransform: "capitalize", cursor: "pointer", border: "none",
                background: tab === t ? COLOR.ink : COLOR.bgSoft, color: tab === t ? "#fff" : COLOR.ink2,
              }}
            >
              {t}
            </button>
          ))}
        </div>
      </header>

      <main className="px-5 md:px-8 pt-6" style={{ maxWidth: 900 }}>
        {tab === "courses" && <CoursesAdmin />}
        {tab === "resources" && <ResourcesAdmin />}
        {tab === "notifications" && <NotificationsAdmin />}
      </main>
    </div>
  );
}

const EMPTY_COURSE = {
  code: "", name: "", professor: "", term: "Term 4" as TermCode, credits: 1,
  concentration_areas: [] as ConcentrationArea[], industry_specializations: [] as IndustrySpecialization[],
};

function CoursesAdmin() {
  const { courses, reload } = useCourses(true); // admin sees disabled courses too
  const [form, setForm] = useState({ ...EMPTY_COURSE });
  const [editId, setEditId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  function toggleArea(area: ConcentrationArea) {
    setForm((f) => ({
      ...f,
      concentration_areas: f.concentration_areas.includes(area)
        ? f.concentration_areas.filter((a) => a !== area)
        : [...f.concentration_areas, area],
    }));
  }

  function toggleSpec(spec: IndustrySpecialization) {
    setForm((f) => ({
      ...f,
      industry_specializations: f.industry_specializations.includes(spec)
        ? f.industry_specializations.filter((s) => s !== spec)
        : [...f.industry_specializations, spec],
    }));
  }

  function startEdit(id: string) {
    const c = courses.find((c) => c.id === id);
    if (!c) return;
    setEditId(id);
    setForm({
      code: c.code, name: c.name, professor: c.professor, term: c.term, credits: c.credits,
      concentration_areas: c.concentration_areas, industry_specializations: c.industry_specializations,
    });
  }

  function cancelEdit() {
    setEditId(null);
    setForm({ ...EMPTY_COURSE });
  }

  async function handleSave() {
    if (!form.name.trim()) return;
    setSaving(true);
    const { error } = editId
      ? await supabase.from("courses").update(form).eq("id", editId)
      : await supabase.from("courses").insert(form);
    setSaving(false);
    if (!error) {
      setForm({ ...EMPTY_COURSE });
      setEditId(null);
      reload();
    } else {
      console.error("[AdminPage] save course failed:", error);
    }
  }

  async function toggleActive(id: string, isActive: boolean) {
    await supabase.from("courses").update({ is_active: !isActive }).eq("id", id);
    reload();
  }

  return (
    <div>
      <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
        <div className="flex items-center justify-between mb-2">
          <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans }}>{editId ? "Edit course" : "Add a course"}</p>
          {editId && <button onClick={cancelEdit} style={{ fontSize: 12, color: COLOR.ink3, background: "none", border: "none", cursor: "pointer" }}>Cancel edit</button>}
        </div>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-2 mb-2">
          <LabeledField label="Code">
            <input style={inputStyle} value={form.code} onChange={(e) => setForm((f) => ({ ...f, code: e.target.value }))} />
          </LabeledField>
          <LabeledField label="Course name" className="col-span-2">
            <input style={inputStyle} value={form.name} onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))} />
          </LabeledField>
          <LabeledField label="Professor">
            <input style={inputStyle} value={form.professor} onChange={(e) => setForm((f) => ({ ...f, professor: e.target.value }))} />
          </LabeledField>
          <LabeledField label="Term">
            <select style={inputStyle} value={form.term} onChange={(e) => setForm((f) => ({ ...f, term: e.target.value as TermCode }))}>
              {TERMS.map((t) => <option key={t} value={t}>{t}</option>)}
            </select>
          </LabeledField>
          <LabeledField label="Credits">
            <input style={inputStyle} type="number" min={1} value={form.credits} onChange={(e) => setForm((f) => ({ ...f, credits: Number(e.target.value) }))} />
          </LabeledField>
        </div>
        <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, margin: "8px 0 4px" }}>Concentration area(s)</p>
        <div className="flex flex-wrap gap-1 mb-2">
          {CONCENTRATIONS.map((c) => (
            <Chip key={c} active={form.concentration_areas.includes(c)} onClick={() => toggleArea(c)} label={c} />
          ))}
        </div>
        <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, margin: "8px 0 4px" }}>Industry specialization(s)</p>
        <div className="flex flex-wrap gap-1 mb-3">
          {SPECIALIZATIONS.map((s) => (
            <Chip key={s} active={form.industry_specializations.includes(s)} onClick={() => toggleSpec(s)} label={s} />
          ))}
        </div>
        <button onClick={handleSave} disabled={saving} style={buttonStyle}>
          {saving ? "Saving…" : editId ? "Save changes" : "Add course"}
        </button>
      </div>

      <div className="space-y-2">
        {courses.map((c) => (
          <div key={c.id} className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: c.is_active ? COLOR.surface : COLOR.bgSoft, border: `1px solid ${COLOR.borderLight}`, opacity: c.is_active ? 1 : 0.6 }}>
            <div style={{ minWidth: 0 }}>
              <p style={{ fontSize: 13, fontWeight: 600, fontFamily: FONT.sans }}>
                {c.name} {!c.is_active && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.red, marginLeft: 6 }}>DISABLED</span>}
              </p>
              <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans }}>
                {c.code} · {c.professor} · {c.term} · {c.credits}cr
                {c.concentration_areas.length > 0 && ` · ${c.concentration_areas.join(", ")}`}
              </p>
            </div>
            <div style={{ display: "flex", gap: 12, flexShrink: 0 }}>
              <button onClick={() => startEdit(c.id)} style={{ fontSize: 12, color: COLOR.ink2, background: "none", border: "none", cursor: "pointer" }}>Edit</button>
              <button onClick={() => toggleActive(c.id, c.is_active)} style={{ fontSize: 12, color: c.is_active ? COLOR.red : COLOR.green, background: "none", border: "none", cursor: "pointer" }}>
                {c.is_active ? "Disable" : "Enable"}
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function LabeledField({ label, children, className }: { label: string; children: React.ReactNode; className?: string }) {
  return (
    <div className={className}>
      <p style={{ fontSize: 10, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 4 }}>{label}</p>
      {children}
    </div>
  );
}

function ResourcesAdmin() {
  const [items, setItems] = useState<{ id: string; title: string; url: string; category: string }[]>([]);
  const [form, setForm] = useState({ title: "", url: "", category: "general" });
  const [loaded, setLoaded] = useState(false);

  if (!loaded) {
    supabase.from("resources").select("*").order("created_at", { ascending: false }).then(({ data }) => {
      setItems(data ?? []);
      setLoaded(true);
    });
  }

  async function handleAdd() {
    if (!form.title.trim() || !form.url.trim()) return;
    const { data, error } = await supabase.from("resources").insert(form).select("*").single();
    if (!error && data) {
      setItems((prev) => [data, ...prev]);
      setForm({ title: "", url: "", category: "general" });
    }
  }

  async function handleDelete(id: string) {
    await supabase.from("resources").delete().eq("id", id);
    setItems((prev) => prev.filter((i) => i.id !== id));
  }

  return (
    <div>
      <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
        <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, marginBottom: 10 }}>Add a resource</p>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-2 mb-3">
          <input style={inputStyle} placeholder="Title" value={form.title} onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))} />
          <input style={inputStyle} placeholder="URL" value={form.url} onChange={(e) => setForm((f) => ({ ...f, url: e.target.value }))} />
          <input style={inputStyle} placeholder="Category" value={form.category} onChange={(e) => setForm((f) => ({ ...f, category: e.target.value }))} />
        </div>
        <button onClick={handleAdd} style={buttonStyle}>Add resource</button>
      </div>
      <div className="space-y-2">
        {items.map((r) => (
          <div key={r.id} className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
            <div style={{ minWidth: 0 }}>
              <p style={{ fontSize: 13, fontWeight: 600, fontFamily: FONT.sans }}>{r.title}</p>
              <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, wordBreak: "break-all" }}>{r.category} · {r.url}</p>
            </div>
            <button onClick={() => handleDelete(r.id)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer", flexShrink: 0, textAlign: "left" }}>Delete</button>
          </div>
        ))}
      </div>
    </div>
  );
}

function NotificationsAdmin() {
  const [items, setItems] = useState<{ id: string; title: string; body: string }[]>([]);
  const [form, setForm] = useState({ title: "", body: "" });
  const [loaded, setLoaded] = useState(false);

  if (!loaded) {
    supabase.from("notifications").select("*").order("created_at", { ascending: false }).then(({ data }) => {
      setItems(data ?? []);
      setLoaded(true);
    });
  }

  async function handleAdd() {
    if (!form.title.trim()) return;
    const { data, error } = await supabase.from("notifications").insert(form).select("*").single();
    if (!error && data) {
      setItems((prev) => [data, ...prev]);
      setForm({ title: "", body: "" });
    }
  }

  async function handleDelete(id: string) {
    await supabase.from("notifications").delete().eq("id", id);
    setItems((prev) => prev.filter((i) => i.id !== id));
  }

  return (
    <div>
      <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
        <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, marginBottom: 10 }}>Post a notice</p>
        <input style={{ ...inputStyle, marginBottom: 8 }} placeholder="Title" value={form.title} onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))} />
        <textarea style={{ ...inputStyle, marginBottom: 8, resize: "none" }} rows={3} placeholder="Body" value={form.body} onChange={(e) => setForm((f) => ({ ...f, body: e.target.value }))} />
        <button onClick={handleAdd} style={buttonStyle}>Post</button>
      </div>
      <div className="space-y-2">
        {items.map((n) => (
          <div key={n.id} style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
            <div style={{ display: "flex", justifyContent: "space-between" }}>
              <p style={{ fontSize: 13, fontWeight: 600, fontFamily: FONT.sans }}>{n.title}</p>
              <button onClick={() => handleDelete(n.id)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer" }}>Delete</button>
            </div>
            <p style={{ fontSize: 12, color: COLOR.ink2, fontFamily: FONT.sans, marginTop: 2 }}>{n.body}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

function Chip({ active, onClick, label }: { active: boolean; onClick: () => void; label: string }) {
  return (
    <button
      onClick={onClick}
      style={{
        padding: "4px 10px", borderRadius: 7, fontSize: 11, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer",
        border: "none", background: active ? COLOR.navy : COLOR.bgSoft, color: active ? "#fff" : COLOR.ink2,
        maxWidth: "100%", whiteSpace: "normal", textAlign: "left", wordBreak: "break-word",
      }}
    >
      {label}
    </button>
  );
}

const inputStyle: React.CSSProperties = {
  width: "100%", padding: "9px 11px", borderRadius: 8, border: `1px solid ${COLOR.border}`,
  fontSize: 13, fontFamily: FONT.sans, color: COLOR.ink, background: COLOR.surface, outline: "none",
};

const buttonStyle: React.CSSProperties = {
  padding: "9px 16px", borderRadius: 8, background: COLOR.navy, color: "#fff", border: "none",
  fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer",
};
