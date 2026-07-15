/**
 * Admin — for the AAC resource coordinator (Anuj) to manage courses, resources,
 * and notifications without needing a code change. Gated on user.is_admin (App.tsx).
 */
import { useState } from "react";
import { useParams, useNavigate, Navigate } from "react-router-dom";
import { LayoutGrid, GraduationCap, BookOpen, Megaphone, Pin } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { useResources } from "../hooks/useResources";
import { useNotifications } from "../hooks/useNotifications";
import { supabase } from "../lib/supabase";
import { RESOURCE_TABS, NOTIFICATION_TAGS, ALL_TERMS } from "../lib/options";
import type { ConcentrationArea, IndustrySpecialization, TermCode, ResourceType, NotificationTag, Course } from "../types";
import { COURSE_SCOPED_RESOURCE_TYPES } from "../types";

const CONCENTRATIONS: ConcentrationArea[] = [
  "Entrepreneurship", "Finance", "Marketing", "Operations Management",
  "Information Technology Management", "Strategy and Leadership",
];
const SPECIALIZATIONS: IndustrySpecialization[] = ["Healthcare", "Manufacturing", "Public Policy", "Infrastructure"];

type Tab = "overview" | "courses" | "resources" | "notifications";
const TABS: { key: Tab; label: string; icon: React.ReactNode }[] = [
  { key: "overview", label: "Overview", icon: <LayoutGrid size={14} /> },
  { key: "courses", label: "Courses", icon: <GraduationCap size={14} /> },
  { key: "resources", label: "Resources", icon: <BookOpen size={14} /> },
  { key: "notifications", label: "Notice Board", icon: <Megaphone size={14} /> },
];

export default function AdminPage() {
  const { tab } = useParams<{ tab: string }>();
  const navigate = useNavigate();

  if (!tab || !TABS.some((t) => t.key === tab)) return <Navigate to="/admin/overview" replace />;
  const activeTab = tab as Tab;
  const goToTab = (t: Tab) => navigate(`/admin/${t}`);

  return (
    <div className="min-h-screen pb-24" style={{ background: COLOR.bg }}>
      <header className="px-5 md:px-8 pt-10 pb-4 border-b" style={{ borderColor: COLOR.borderLight }}>
        <h1 style={{ fontFamily: FONT.serif, fontSize: 26, fontWeight: 500, color: COLOR.ink }}>Admin</h1>
        <div className="flex gap-2 mt-4 flex-wrap">
          {TABS.map((t) => (
            <button
              key={t.key}
              onClick={() => goToTab(t.key)}
              className="flex items-center gap-1.5"
              style={{
                padding: "7px 14px", borderRadius: 8, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans,
                cursor: "pointer", border: "none",
                background: activeTab === t.key ? COLOR.ink : COLOR.bgSoft, color: activeTab === t.key ? "#fff" : COLOR.ink2,
              }}
            >
              {t.icon} {t.label}
            </button>
          ))}
        </div>
      </header>

      <main className="px-5 md:px-8 pt-6" style={{ maxWidth: 900 }}>
        {activeTab === "overview" && <Overview onNavigate={goToTab} />}
        {activeTab === "courses" && <CoursesAdmin />}
        {activeTab === "resources" && <ResourcesAdmin />}
        {activeTab === "notifications" && <NotificationsAdmin />}
      </main>
    </div>
  );
}

function Overview({ onNavigate }: { onNavigate: (t: Tab) => void }) {
  const { courses } = useCourses(true);
  const { resources } = useResources();
  const { notifications } = useNotifications();

  const activeCourses = courses.filter((c) => c.is_active).length;
  const disabledCourses = courses.length - activeCourses;
  const pinnedNotices = notifications.filter((n) => n.pinned).length;

  return (
    <div>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-8">
        <StatCard label="Courses" value={courses.length} sub={`${activeCourses} active${disabledCourses ? `, ${disabledCourses} disabled` : ""}`} onClick={() => onNavigate("courses")} />
        <StatCard label="Resources" value={resources.length} sub={`${resources.filter((r) => r.resource_type === "Platform Directory").length} platform links`} onClick={() => onNavigate("resources")} />
        <StatCard label="Notices" value={notifications.length} sub={`${pinnedNotices} pinned`} onClick={() => onNavigate("notifications")} />
        <StatCard label="Missing faculty" value={courses.filter((c) => !c.professor || c.professor === "TBD").length} sub="courses with TBD professor" onClick={() => onNavigate("courses")} />
      </div>

      <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 10 }}>Resources by category</p>
      <div className="space-y-1.5 mb-8" style={{ maxWidth: 420 }}>
        {[...RESOURCE_TABS.map((t) => ({ key: t.key, label: t.label, types: t.types as readonly string[] })), { key: "platform", label: "Platform Directory", types: ["Platform Directory"] }, { key: "general", label: "General", types: ["General"] }].map((t) => {
          const count = resources.filter((r) => t.types.includes(r.resource_type)).length;
          const pct = resources.length ? (count / resources.length) * 100 : 0;
          return (
            <div key={t.key} className="flex items-center gap-3">
              <span style={{ width: 130, fontSize: 12, fontFamily: FONT.sans, color: COLOR.ink2, flexShrink: 0 }}>{t.label}</span>
              <div style={{ flex: 1, height: 6, borderRadius: 3, background: COLOR.borderLight, overflow: "hidden" }}>
                <div style={{ height: "100%", width: `${pct}%`, background: COLOR.navyHero, borderRadius: 3 }} />
              </div>
              <span style={{ fontSize: 12, fontFamily: FONT.sans, color: COLOR.ink3, width: 20, textAlign: "right" }}>{count}</span>
            </div>
          );
        })}
      </div>

      <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 10 }}>Recent notices</p>
      <div className="space-y-2">
        {notifications.slice(0, 3).map((n) => (
          <div key={n.id} style={{ padding: "9px 12px", borderRadius: 8, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
            <div className="flex items-center gap-2">
              {n.pinned && <Pin size={11} color={COLOR.navyHero} fill={COLOR.navyHero} />}
              <span style={{ fontSize: 12.5, fontWeight: 600, fontFamily: FONT.sans, color: COLOR.ink }}>{n.title}</span>
            </div>
          </div>
        ))}
        {notifications.length === 0 && <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>No notices posted yet.</p>}
      </div>
    </div>
  );
}

function StatCard({ label, value, sub, onClick }: { label: string; value: number; sub: string; onClick: () => void }) {
  return (
    <button onClick={onClick} style={{ textAlign: "left", padding: "14px 16px", borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, cursor: "pointer" }}>
      <p style={{ fontSize: 24, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>{value}</p>
      <p style={{ fontSize: 11.5, fontWeight: 700, color: COLOR.ink2, fontFamily: FONT.sans, marginTop: 2 }}>{label}</p>
      <p style={{ fontSize: 10.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>{sub}</p>
    </button>
  );
}

const EMPTY_COURSE = {
  code: "", name: "", professor: "", term: "Term 4" as TermCode, credits: 1, is_core: false,
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
      code: c.code, name: c.name, professor: c.professor, term: c.term, credits: c.credits, is_core: c.is_core,
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
              {ALL_TERMS.map((t) => <option key={t} value={t}>{t}</option>)}
            </select>
          </LabeledField>
          <LabeledField label="Credits">
            <input style={inputStyle} type="number" min={0.4} step={0.1} value={form.credits} onChange={(e) => setForm((f) => ({ ...f, credits: Number(e.target.value) }))} />
          </LabeledField>
        </div>
        <label className="flex items-center gap-2 mb-3" style={{ cursor: "pointer" }}>
          <input type="checkbox" checked={form.is_core} onChange={(e) => setForm((f) => ({ ...f, is_core: e.target.checked }))} />
          <span style={{ fontSize: 12.5, fontFamily: FONT.sans, color: COLOR.ink2 }}>Core course (mandatory — not bid on, no concentration credit)</span>
        </label>
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
                {c.name}
                {c.is_core && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.navyHero, marginLeft: 6 }}>CORE</span>}
                {!c.is_active && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.red, marginLeft: 6 }}>DISABLED</span>}
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

const EMPTY_RESOURCE = { title: "", url: "", description: "", resource_type: "General" as ResourceType, term: "", course_id: "", pinned: false, pinned_global: false };

function ResourcesAdmin() {
  const { resources, reload } = useResources();
  const { courses } = useCourses(true);
  const [form, setForm] = useState({ ...EMPTY_RESOURCE });
  const [editId, setEditId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const isCourseScoped = COURSE_SCOPED_RESOURCE_TYPES.includes(form.resource_type);
  const coursesInTerm = courses.filter((c) => c.term === form.term);

  function startEdit(id: string) {
    const r = resources.find((r) => r.id === id);
    if (!r) return;
    const course = r.course_id ? courses.find((c) => c.id === r.course_id) : null;
    setEditId(id);
    setForm({
      title: r.title, url: r.url, description: r.description ?? "", resource_type: r.resource_type,
      term: r.term ?? course?.term ?? "", course_id: r.course_id ?? "", pinned: r.pinned, pinned_global: r.pinned_global,
    });
  }

  function cancelEdit() {
    setEditId(null);
    setForm({ ...EMPTY_RESOURCE });
  }

  async function handleSave() {
    if (!form.title.trim() || !form.url.trim()) return;
    setSaving(true);
    const payload = {
      title: form.title.trim(),
      url: form.url.trim(),
      description: form.description.trim() || null,
      resource_type: form.resource_type,
      term: isCourseScoped && form.term ? form.term : null,
      course_id: isCourseScoped && form.course_id ? form.course_id : null,
      pinned: form.pinned,
      pinned_global: form.pinned_global,
    };
    const { error } = editId
      ? await supabase.from("resources").update(payload).eq("id", editId)
      : await supabase.from("resources").insert(payload);
    setSaving(false);
    if (!error) {
      setForm({ ...EMPTY_RESOURCE });
      setEditId(null);
      reload();
    } else {
      console.error("[AdminPage] save resource failed:", error);
    }
  }

  async function handleDelete(id: string) {
    await supabase.from("resources").delete().eq("id", id);
    reload();
  }

  return (
    <div>
      <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
        <div className="flex items-center justify-between mb-2">
          <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans }}>{editId ? "Edit resource" : "Add a resource"}</p>
          {editId && <button onClick={cancelEdit} style={{ fontSize: 12, color: COLOR.ink3, background: "none", border: "none", cursor: "pointer" }}>Cancel edit</button>}
        </div>

        <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, margin: "4px 0" }}>Type</p>
        {RESOURCE_TABS.map((group) => (
          <div key={group.key} className="mb-2">
            <p style={{ fontSize: 10, color: COLOR.ink3, fontFamily: FONT.sans, margin: "2px 0" }}>{group.label}</p>
            <div className="flex flex-wrap gap-1">
              {group.types.map((t) => (
                <Chip key={t} active={form.resource_type === t} onClick={() => setForm((f) => ({ ...f, resource_type: t, term: "", course_id: "" }))} label={t} />
              ))}
            </div>
          </div>
        ))}
        <div className="mb-3">
          <p style={{ fontSize: 10, color: COLOR.ink3, fontFamily: FONT.sans, margin: "2px 0" }}>Not tied to a course</p>
          <div className="flex flex-wrap gap-1">
            {(["Platform Directory", "General"] as const).map((t) => (
              <Chip key={t} active={form.resource_type === t} onClick={() => setForm((f) => ({ ...f, resource_type: t, term: "", course_id: "" }))} label={t} />
            ))}
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-2 mb-2">
          <LabeledField label="Title">
            <input style={inputStyle} value={form.title} onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))} />
          </LabeledField>
          <LabeledField label="URL">
            <input style={inputStyle} value={form.url} onChange={(e) => setForm((f) => ({ ...f, url: e.target.value }))} placeholder="https://…" />
          </LabeledField>
        </div>
        <LabeledField label="Description (shown to students so they know what's inside before clicking)" className="mb-2">
          <textarea
            style={{ ...inputStyle, resize: "none" }} rows={2}
            value={form.description} onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))}
            placeholder="e.g. Covers TVM, WACC, and capital budgeting — 12 slides from Session 3"
          />
        </LabeledField>

        {isCourseScoped && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-2 mb-3">
            <LabeledField label="Term">
              <select style={inputStyle} value={form.term} onChange={(e) => setForm((f) => ({ ...f, term: e.target.value, course_id: "" }))}>
                <option value="">Select term…</option>
                {ALL_TERMS.map((t) => <option key={t} value={t}>{t}</option>)}
              </select>
            </LabeledField>
            <LabeledField label="Course (optional — leave blank for a term-wide resource)">
              <select style={inputStyle} value={form.course_id} onChange={(e) => setForm((f) => ({ ...f, course_id: e.target.value }))} disabled={!form.term}>
                <option value="">No specific course</option>
                {coursesInTerm.map((c: Course) => <option key={c.id} value={c.id}>{c.name}</option>)}
              </select>
            </LabeledField>
          </div>
        )}

        <label className="flex items-center gap-2 mb-2" style={{ cursor: "pointer" }}>
          <input type="checkbox" checked={form.pinned} onChange={(e) => setForm((f) => ({ ...f, pinned: e.target.checked }))} />
          <span style={{ fontSize: 12.5, fontFamily: FONT.sans, color: COLOR.ink2 }}>Pin to top of its section (e.g. top of the Other tab, or top of General Resources)</span>
        </label>
        <label className="flex items-center gap-2 mb-3" style={{ cursor: "pointer" }}>
          <input type="checkbox" checked={form.pinned_global} onChange={(e) => setForm((f) => ({ ...f, pinned_global: e.target.checked }))} />
          <span style={{ fontSize: 12.5, fontFamily: FONT.sans, color: COLOR.ink2 }}>Pin globally — sticky banner at the top of Course Resources, regardless of filters</span>
        </label>

        <button onClick={handleSave} disabled={saving} style={buttonStyle}>
          {saving ? "Saving…" : editId ? "Save changes" : "Add resource"}
        </button>
      </div>

      <div className="space-y-2">
        {resources.map((r) => {
          const course = r.course_id ? courses.find((c) => c.id === r.course_id) : null;
          return (
            <div key={r.id} className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
              <div style={{ minWidth: 0 }}>
                <p style={{ fontSize: 13, fontWeight: 600, fontFamily: FONT.sans }}>
                  {r.title}
                  {r.pinned && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.navyHero, marginLeft: 6 }}>PINNED</span>}
                  {r.pinned_global && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.red, marginLeft: 6 }}>GLOBAL</span>}
                </p>
                <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, wordBreak: "break-all" }}>
                  {r.resource_type}{r.term && ` · ${r.term}`}{course && ` · ${course.name}`} · {r.url}
                </p>
              </div>
              <div style={{ display: "flex", gap: 12, flexShrink: 0 }}>
                <button onClick={() => startEdit(r.id)} style={{ fontSize: 12, color: COLOR.ink2, background: "none", border: "none", cursor: "pointer" }}>Edit</button>
                <button onClick={() => handleDelete(r.id)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer" }}>Delete</button>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

const EMPTY_NOTIFICATION = { title: "", body: "", tag: "General" as NotificationTag, pinned: false };

function NotificationsAdmin() {
  const { notifications, reload } = useNotifications();
  const [form, setForm] = useState({ ...EMPTY_NOTIFICATION });
  const [editId, setEditId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  function startEdit(id: string) {
    const n = notifications.find((n) => n.id === id);
    if (!n) return;
    setEditId(id);
    setForm({ title: n.title, body: n.body, tag: n.tag, pinned: n.pinned });
  }

  function cancelEdit() {
    setEditId(null);
    setForm({ ...EMPTY_NOTIFICATION });
  }

  async function handleSave() {
    if (!form.title.trim()) return;
    setSaving(true);
    const { error } = editId
      ? await supabase.from("notifications").update(form).eq("id", editId)
      : await supabase.from("notifications").insert(form);
    setSaving(false);
    if (!error) {
      setForm({ ...EMPTY_NOTIFICATION });
      setEditId(null);
      reload();
    }
  }

  async function handleDelete(id: string) {
    await supabase.from("notifications").delete().eq("id", id);
    reload();
  }

  return (
    <div>
      <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
        <div className="flex items-center justify-between mb-2">
          <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans }}>{editId ? "Edit notice" : "Post a notice"}</p>
          {editId && <button onClick={cancelEdit} style={{ fontSize: 12, color: COLOR.ink3, background: "none", border: "none", cursor: "pointer" }}>Cancel edit</button>}
        </div>
        <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, margin: "4px 0" }}>Tag</p>
        <div className="flex flex-wrap gap-1 mb-3">
          {NOTIFICATION_TAGS.map((t) => (
            <Chip key={t} active={form.tag === t} onClick={() => setForm((f) => ({ ...f, tag: t }))} label={t} />
          ))}
        </div>
        <LabeledField label="Title">
          <input style={{ ...inputStyle, marginBottom: 8 }} value={form.title} onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))} />
        </LabeledField>
        <LabeledField label="Body">
          <textarea style={{ ...inputStyle, marginBottom: 8, resize: "none" }} rows={3} value={form.body} onChange={(e) => setForm((f) => ({ ...f, body: e.target.value }))} />
        </LabeledField>
        <label className="flex items-center gap-2 mb-3" style={{ cursor: "pointer" }}>
          <input type="checkbox" checked={form.pinned} onChange={(e) => setForm((f) => ({ ...f, pinned: e.target.checked }))} />
          <span style={{ fontSize: 12.5, fontFamily: FONT.sans, color: COLOR.ink2 }}>Pin to top</span>
        </label>
        <button onClick={handleSave} disabled={saving} style={buttonStyle}>
          {saving ? "Saving…" : editId ? "Save changes" : "Post"}
        </button>
      </div>
      <div className="space-y-2">
        {notifications.map((n) => (
          <div key={n.id} style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
            <div className="flex items-center justify-between gap-2 flex-wrap">
              <div className="flex items-center gap-2">
                {n.pinned && <Pin size={12} color={COLOR.navyHero} fill={COLOR.navyHero} />}
                <span style={{ fontSize: 10, fontWeight: 700, padding: "1px 7px", borderRadius: 5, background: COLOR.bgSoft, color: COLOR.ink2, fontFamily: FONT.sans, textTransform: "uppercase" }}>{n.tag}</span>
                <p style={{ fontSize: 13, fontWeight: 600, fontFamily: FONT.sans }}>{n.title}</p>
              </div>
              <div style={{ display: "flex", gap: 10, flexShrink: 0 }}>
                <button onClick={() => startEdit(n.id)} style={{ fontSize: 12, color: COLOR.ink2, background: "none", border: "none", cursor: "pointer" }}>Edit</button>
                <button onClick={() => handleDelete(n.id)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer" }}>Delete</button>
              </div>
            </div>
            <p style={{ fontSize: 12, color: COLOR.ink2, fontFamily: FONT.sans, marginTop: 4 }}>{n.body}</p>
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
