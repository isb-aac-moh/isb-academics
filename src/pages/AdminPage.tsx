/**
 * Admin — for the AAC resource coordinator (Anuj) to manage courses, resources,
 * and notifications without needing a code change. Gated on user.is_admin (App.tsx).
 */
import { useState, useEffect } from "react";
import { useParams, useNavigate, Navigate } from "react-router-dom";
import { LayoutGrid, GraduationCap, BookOpen, Megaphone, Pin, Link2, ArrowUp, ArrowDown, Sparkles } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useCourses } from "../hooks/useCourses";
import { useCourseGradingProfiles } from "../hooks/useCourseGradingProfiles";
import { useResources } from "../hooks/useResources";
import { useNotifications } from "../hooks/useNotifications";
import { useNavLinks } from "../hooks/useNavLinks";
import { useAppSettings } from "../hooks/useAppSettings";
import { useDashboardPopups } from "../hooks/useDashboardPopups";
import { supabase } from "../lib/supabase";
import { RESOURCE_TABS, NOTIFICATION_TAGS, ALL_TERMS, POPUP_PAGES } from "../lib/options";
import { BIDDABLE_TERM_ORDER } from "../lib/creditProgress";
import { NAV_LINK_ICONS, type NavLinkIconKey } from "../lib/navLinkIcons";
import { POPUP_ICONS, type PopupIconKey } from "../lib/popupIcons";
import type { ConcentrationArea, IndustrySpecialization, TermCode, ResourceType, NotificationTag, Course, NavLinkType, NavLinkVisibility, CourseGradingProfile, GroupFormation, AttendancePolicy, PopupFrequency, PopupPrimaryAction } from "../types";
import { COURSE_SCOPED_RESOURCE_TYPES } from "../types";

// Admins often paste a bare domain ("example.com") into link fields — without
// a scheme, <a href> resolves it as a relative path off the current route
// instead of an external URL. Default missing schemes to https://.
function withScheme(url: string): string {
  return /^[a-z][a-z0-9+.-]*:/i.test(url) ? url : `https://${url}`;
}

const CONCENTRATIONS: ConcentrationArea[] = [
  "Entrepreneurship", "Finance", "Marketing", "Operations Management",
  "Information Technology Management", "Strategy and Leadership",
];
const SPECIALIZATIONS: IndustrySpecialization[] = ["Healthcare", "Manufacturing", "Public Policy", "Infrastructure"];

type Tab = "overview" | "courses" | "resources" | "notifications" | "nav-links" | "popups";
const TABS: { key: Tab; label: string; icon: React.ReactNode }[] = [
  { key: "overview", label: "Overview", icon: <LayoutGrid size={14} /> },
  { key: "courses", label: "Courses", icon: <GraduationCap size={14} /> },
  { key: "resources", label: "Resources", icon: <BookOpen size={14} /> },
  { key: "notifications", label: "Notice Board", icon: <Megaphone size={14} /> },
  { key: "nav-links", label: "Nav Links", icon: <Link2 size={14} /> },
  { key: "popups", label: "Popups", icon: <Sparkles size={14} /> },
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

      <main className="px-5 md:px-8 pt-6" style={{ maxWidth: 1600 }}>
        {activeTab === "overview" && <Overview onNavigate={goToTab} />}
        {activeTab === "courses" && <CoursesAdmin />}
        {activeTab === "resources" && <ResourcesAdmin />}
        {activeTab === "notifications" && <NotificationsAdmin />}
        {activeTab === "nav-links" && <NavLinksAdmin />}
        {activeTab === "popups" && <PopupsAdmin />}
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

      <LiveBiddingSettings />
      <TermCreditLimitsSettings />

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

// Which term(s)/block week(s) show as "Live now" in the Bidding Planner — used to
// be a hardcoded constant requiring a code change + redeploy every time ISB opens
// a new bidding round. Now just an admin-editable setting.
const BIDDABLE_TERMS = BIDDABLE_TERM_ORDER;

function LiveBiddingSettings() {
  const { liveBiddingTerms, loading, saveLiveBiddingTerms } = useAppSettings();
  const [saving, setSaving] = useState(false);

  async function toggle(term: string) {
    setSaving(true);
    const next = liveBiddingTerms.includes(term)
      ? liveBiddingTerms.filter((t) => t !== term)
      : [...liveBiddingTerms, term];
    await saveLiveBiddingTerms(next);
    setSaving(false);
  }

  if (loading) return null;

  return (
    <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
      <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 4 }}>Live bidding round</p>
      <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 10 }}>
        Which term(s)/block week(s) show as "Live now" in the Bidding Planner right now.
      </p>
      <div className="flex flex-wrap gap-1.5">
        {BIDDABLE_TERMS.map((term) => (
          <Chip key={term} active={liveBiddingTerms.includes(term)} onClick={() => toggle(term)} label={term} />
        ))}
      </div>
      {saving && <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 8 }}>Saving…</p>}
    </div>
  );
}

// Per-term min/max elective credits — used to be the hardcoded TERM_CREDIT_LIMITS
// constant in creditProgress.ts. Now admin-editable for the same reason
// live_bidding_terms is: ISB's own limits can change term to term without needing
// a code change + redeploy.
function TermCreditLimitsSettings() {
  const { termCreditLimits, loading, saveTermCreditLimits } = useAppSettings();
  const [draft, setDraft] = useState(termCreditLimits);
  const [dirty, setDirty] = useState(false);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (!dirty) setDraft(termCreditLimits);
  }, [termCreditLimits, dirty]);

  function update(term: string, field: "min" | "max", value: number) {
    setDraft((d) => ({ ...d, [term]: { ...d[term], [field]: value } }));
    setDirty(true);
  }

  async function handleSave() {
    setSaving(true);
    await saveTermCreditLimits(draft);
    setSaving(false);
    setDirty(false);
  }

  if (loading) return null;

  return (
    <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
      <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 4 }}>Term elective credit limits</p>
      <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 10 }}>
        Min/max elective credits a student can bid in each term/Block Week — shown as a check in the Bidding Planner's budget step.
      </p>
      <div className="space-y-1.5" style={{ maxWidth: 420 }}>
        {BIDDABLE_TERM_ORDER.map((term) => {
          const limit = draft[term] ?? { min: 0, max: 0 };
          return (
            <div key={term} className="flex items-center gap-2">
              <span style={{ width: 110, fontSize: 12, fontFamily: FONT.sans, color: COLOR.ink2, flexShrink: 0 }}>{term}</span>
              <input
                type="number" min={0} value={limit.min}
                onChange={(e) => update(term, "min", Number(e.target.value))}
                style={{ width: 56, padding: "4px 6px", borderRadius: 6, border: `1px solid ${COLOR.border}`, fontSize: 12, fontFamily: FONT.sans }}
              />
              <span style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans }}>to</span>
              <input
                type="number" min={0} value={limit.max}
                onChange={(e) => update(term, "max", Number(e.target.value))}
                style={{ width: 56, padding: "4px 6px", borderRadius: 6, border: `1px solid ${COLOR.border}`, fontSize: 12, fontFamily: FONT.sans }}
              />
              <span style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans }}>credits</span>
            </div>
          );
        })}
      </div>
      {dirty && (
        <button
          onClick={handleSave}
          disabled={saving}
          style={{
            marginTop: 12, padding: "7px 14px", borderRadius: 7, border: "none", fontSize: 12.5, fontWeight: 700, fontFamily: FONT.sans,
            background: COLOR.navyHero, color: "#fff", cursor: saving ? "not-allowed" : "pointer", opacity: saving ? 0.7 : 1,
          }}
        >
          {saving ? "Saving…" : "Save changes"}
        </button>
      )}
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
  const { profiles: gradingProfiles, reload: reloadGrading } = useCourseGradingProfiles();
  const [form, setForm] = useState({ ...EMPTY_COURSE });
  const [editId, setEditId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [gradingCourseId, setGradingCourseId] = useState<string | null>(null);

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
    const { error } = await supabase.from("courses").update({ is_active: !isActive }).eq("id", id);
    if (error) {
      console.error("[AdminPage] toggle course active failed:", error);
      alert("Couldn't update that course — check your connection and try again.");
      return;
    }
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
          <div key={c.id}>
            <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: c.is_active ? COLOR.surface : COLOR.bgSoft, border: `1px solid ${COLOR.borderLight}`, opacity: c.is_active ? 1 : 0.6 }}>
              <div style={{ minWidth: 0 }}>
                <p style={{ fontSize: 13, fontWeight: 600, fontFamily: FONT.sans }}>
                  {c.name}
                  {c.is_core && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.navyHero, marginLeft: 6 }}>CORE</span>}
                  {!c.is_active && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.red, marginLeft: 6 }}>DISABLED</span>}
                </p>
                <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans }}>
                  {c.code} · {c.professor} · {c.term} · {c.credits}cr
                  {c.concentration_areas.length > 0 && ` · ${c.concentration_areas.join(", ")}`}
                  {gradingProfiles.has(c.id) && <span style={{ color: COLOR.green, fontWeight: 700 }}> · has grading profile</span>}
                </p>
              </div>
              <div style={{ display: "flex", gap: 12, flexShrink: 0 }}>
                <button onClick={() => setGradingCourseId(gradingCourseId === c.id ? null : c.id)} style={{ fontSize: 12, color: COLOR.navyHero, background: "none", border: "none", cursor: "pointer" }}>
                  {gradingCourseId === c.id ? "Close grading" : "Grading"}
                </button>
                <button onClick={() => startEdit(c.id)} style={{ fontSize: 12, color: COLOR.ink2, background: "none", border: "none", cursor: "pointer" }}>Edit</button>
                <button onClick={() => toggleActive(c.id, c.is_active)} style={{ fontSize: 12, color: c.is_active ? COLOR.red : COLOR.green, background: "none", border: "none", cursor: "pointer" }}>
                  {c.is_active ? "Disable" : "Enable"}
                </button>
              </div>
            </div>
            {gradingCourseId === c.id && (
              <GradingProfileEditor course={c} profile={gradingProfiles.get(c.id)} onSaved={reloadGrading} />
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

const EMPTY_GRADING = {
  grade_participation_pct: 0, grade_individual_pct: 0, grade_group_pct: 0, grade_exam_pct: 0,
  exam_midterm_count: 0, exam_endterm_count: 0, exam_quiz_count: 0,
  load_quant: 0, load_assignments: 0, load_participation: 0, load_exam_pressure: 0, load_group: 0, load_reading: 0,
  brief: [] as { label: string; text: string }[],
  student_feedback: [] as string[],
  group_size: "",
  cross_section: null as boolean | null,
  group_formation: "" as GroupFormation | "",
  peer_eval: null as boolean | null,
  attendance: "" as AttendancePolicy | "",
  source_url: "",
};

function GradingProfileEditor({ course, profile, onSaved }: { course: Course; profile?: CourseGradingProfile; onSaved: () => void }) {
  const [form, setForm] = useState(() =>
    profile
      ? {
          ...profile,
          source_url: profile.source_url ?? "",
          group_size: profile.group_size ?? "",
          group_formation: profile.group_formation ?? ("" as const),
          attendance: profile.attendance ?? ("" as const),
        }
      : { ...EMPTY_GRADING },
  );
  const [saving, setSaving] = useState(false);
  const gradeTotal = form.grade_participation_pct + form.grade_individual_pct + form.grade_group_pct + form.grade_exam_pct;

  function num(key: keyof typeof EMPTY_GRADING) {
    return (e: React.ChangeEvent<HTMLInputElement>) => setForm((f) => ({ ...f, [key]: Number(e.target.value) }));
  }

  function updateBrief(i: number, field: "label" | "text", value: string) {
    setForm((f) => ({ ...f, brief: f.brief.map((b, bi) => (bi === i ? { ...b, [field]: value } : b)) }));
  }

  function addBrief() {
    setForm((f) => ({ ...f, brief: [...f.brief, { label: "", text: "" }] }));
  }

  function removeBrief(i: number) {
    setForm((f) => ({ ...f, brief: f.brief.filter((_, bi) => bi !== i) }));
  }

  function updateFeedback(i: number, value: string) {
    setForm((f) => ({ ...f, student_feedback: f.student_feedback.map((t, ti) => (ti === i ? value : t)) }));
  }

  function addFeedback() {
    setForm((f) => ({ ...f, student_feedback: [...f.student_feedback, ""] }));
  }

  function removeFeedback(i: number) {
    setForm((f) => ({ ...f, student_feedback: f.student_feedback.filter((_, ti) => ti !== i) }));
  }

  async function handleSave() {
    setSaving(true);
    const { error } = await supabase.from("course_grading_profiles").upsert({
      course_id: course.id,
      ...form,
      source_url: form.source_url.trim() || null,
      group_size: form.group_size.trim() || null,
      group_formation: form.group_formation || null,
      attendance: form.attendance || null,
      extracted_at: profile?.extracted_at ?? null,
    });
    setSaving(false);
    if (!error) onSaved();
    else console.error("[AdminPage] save grading profile failed:", error);
  }

  return (
    <div style={{ padding: "14px 16px", borderRadius: 9, background: COLOR.bgSoft, marginTop: 6 }}>
      <p style={{ fontSize: 12.5, fontWeight: 700, fontFamily: FONT.sans, marginBottom: 10 }}>
        Grading DNA — {course.code}
        {gradeTotal !== 100 && <span style={{ color: COLOR.red, fontWeight: 600 }}> (grade % totals {gradeTotal}, should be 100)</span>}
      </p>

      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 4 }}>Grading composition (%)</p>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-2 mb-3">
        <LabeledField label="Participation"><input style={inputStyle} type="number" value={form.grade_participation_pct} onChange={num("grade_participation_pct")} /></LabeledField>
        <LabeledField label="Individual"><input style={inputStyle} type="number" value={form.grade_individual_pct} onChange={num("grade_individual_pct")} /></LabeledField>
        <LabeledField label="Group"><input style={inputStyle} type="number" value={form.grade_group_pct} onChange={num("grade_group_pct")} /></LabeledField>
        <LabeledField label="Exam"><input style={inputStyle} type="number" value={form.grade_exam_pct} onChange={num("grade_exam_pct")} /></LabeledField>
      </div>

      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 4 }}>Exam structure (count)</p>
      <div className="grid grid-cols-3 gap-2 mb-3" style={{ maxWidth: 320 }}>
        <LabeledField label="Mid-terms"><input style={inputStyle} type="number" min={0} value={form.exam_midterm_count} onChange={num("exam_midterm_count")} /></LabeledField>
        <LabeledField label="End-terms"><input style={inputStyle} type="number" min={0} value={form.exam_endterm_count} onChange={num("exam_endterm_count")} /></LabeledField>
        <LabeledField label="Quizzes"><input style={inputStyle} type="number" min={0} value={form.exam_quiz_count} onChange={num("exam_quiz_count")} /></LabeledField>
      </div>

      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 4 }}>Workload profile (0-5)</p>
      <div className="grid grid-cols-3 md:grid-cols-6 gap-2 mb-3">
        <LabeledField label="Quant"><input style={inputStyle} type="number" min={0} max={5} step={0.5} value={form.load_quant} onChange={num("load_quant")} /></LabeledField>
        <LabeledField label="Assignments"><input style={inputStyle} type="number" min={0} max={5} step={0.5} value={form.load_assignments} onChange={num("load_assignments")} /></LabeledField>
        <LabeledField label="Participation"><input style={inputStyle} type="number" min={0} max={5} step={0.5} value={form.load_participation} onChange={num("load_participation")} /></LabeledField>
        <LabeledField label="Exam pressure"><input style={inputStyle} type="number" min={0} max={5} step={0.5} value={form.load_exam_pressure} onChange={num("load_exam_pressure")} /></LabeledField>
        <LabeledField label="Group"><input style={inputStyle} type="number" min={0} max={5} step={0.5} value={form.load_group} onChange={num("load_group")} /></LabeledField>
        <LabeledField label="Reading"><input style={inputStyle} type="number" min={0} max={5} step={0.5} value={form.load_reading} onChange={num("load_reading")} /></LabeledField>
      </div>

      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 4 }}>Brief (shown as "every detail" in the planner)</p>
      <div className="space-y-2 mb-2">
        {form.brief.map((b, i) => (
          <div key={i} className="flex gap-2 items-start">
            <input style={{ ...inputStyle, width: 110, flexShrink: 0 }} placeholder="Label" value={b.label} onChange={(e) => updateBrief(i, "label", e.target.value)} />
            <input style={{ ...inputStyle, flex: 1 }} placeholder="Text" value={b.text} onChange={(e) => updateBrief(i, "text", e.target.value)} />
            <button onClick={() => removeBrief(i)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer", padding: "6px 4px" }}>✕</button>
          </div>
        ))}
        <button onClick={addBrief} style={{ fontSize: 12, color: COLOR.navyHero, background: "none", border: "none", cursor: "pointer" }}>+ Add bullet</button>
      </div>

      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 4 }}>
        Student feedback (word of mouth, not from the outline)
      </p>
      <div className="space-y-2 mb-3">
        {form.student_feedback.map((t, i) => (
          <div key={i} className="flex gap-2 items-start">
            <textarea style={{ ...inputStyle, flex: 1, minHeight: 44 }} placeholder="What a student said about this course" value={t} onChange={(e) => updateFeedback(i, e.target.value)} />
            <button onClick={() => removeFeedback(i)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer", padding: "6px 4px" }}>✕</button>
          </div>
        ))}
        <button onClick={addFeedback} style={{ fontSize: 12, color: COLOR.navyHero, background: "none", border: "none", cursor: "pointer" }}>+ Add feedback</button>
      </div>

      <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, marginBottom: 4 }}>
        Groups & attendance (leave blank / "Not stated" when the outline doesn't say)
      </p>
      <div className="grid grid-cols-2 md:grid-cols-5 gap-2 mb-3">
        <LabeledField label="Group size">
          <input style={inputStyle} placeholder="e.g. 4-6" value={form.group_size} onChange={(e) => setForm((f) => ({ ...f, group_size: e.target.value }))} />
        </LabeledField>
        <LabeledField label="Cross-section">
          <select style={inputStyle} value={triState(form.cross_section)} onChange={(e) => setForm((f) => ({ ...f, cross_section: parseTriState(e.target.value) }))}>
            <option value="">Not stated</option>
            <option value="yes">Allowed</option>
            <option value="no">Same section only</option>
          </select>
        </LabeledField>
        <LabeledField label="Formation">
          <select style={inputStyle} value={form.group_formation} onChange={(e) => setForm((f) => ({ ...f, group_formation: e.target.value as GroupFormation | "" }))}>
            <option value="">Not stated</option>
            <option value="Self-select">Self-select</option>
            <option value="Instructor-assigned">Instructor-assigned</option>
            <option value="ASA-assigned">ASA-assigned</option>
          </select>
        </LabeledField>
        <LabeledField label="Peer evaluation">
          <select style={inputStyle} value={triState(form.peer_eval)} onChange={(e) => setForm((f) => ({ ...f, peer_eval: parseTriState(e.target.value) }))}>
            <option value="">Not stated</option>
            <option value="yes">Yes</option>
            <option value="no">No</option>
          </select>
        </LabeledField>
        <LabeledField label="Attendance">
          <select style={inputStyle} value={form.attendance} onChange={(e) => setForm((f) => ({ ...f, attendance: e.target.value as AttendancePolicy | "" }))}>
            <option value="">Not stated</option>
            <option value="Not mandatory">Not mandatory</option>
            <option value="ISB policy">ISB policy</option>
            <option value="Participation-linked">Participation-linked</option>
            <option value="Stricter than ISB policy">Stricter than ISB policy</option>
          </select>
        </LabeledField>
      </div>

      <LabeledField label="Source URL (course outline)" className="mb-3">
        <input style={inputStyle} value={form.source_url} onChange={(e) => setForm((f) => ({ ...f, source_url: e.target.value }))} />
      </LabeledField>

      <button onClick={handleSave} disabled={saving} style={buttonStyle}>{saving ? "Saving…" : "Save grading profile"}</button>
    </div>
  );
}

// The three-way selects above round-trip null ("not stated") through a <select>,
// which can only hold strings.
function triState(v: boolean | null): string {
  return v === null ? "" : v ? "yes" : "no";
}

function parseTriState(v: string): boolean | null {
  return v === "" ? null : v === "yes";
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
      url: withScheme(form.url.trim()),
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
    const { error } = await supabase.from("resources").delete().eq("id", id);
    if (error) {
      console.error("[AdminPage] delete resource failed:", error);
      alert("Couldn't delete that resource — check your connection and try again.");
      return;
    }
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
    const { error } = await supabase.from("notifications").delete().eq("id", id);
    if (error) {
      console.error("[AdminPage] delete notification failed:", error);
      alert("Couldn't delete that notice — check your connection and try again.");
      return;
    }
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

const EMPTY_NAV_LINK = {
  label: "", icon: "Link2" as NavLinkIconKey, link_type: "external" as NavLinkType,
  href: "", visibility: "everyone" as NavLinkVisibility,
};

function NavLinksAdmin() {
  const { navLinks, reload } = useNavLinks();
  const [form, setForm] = useState({ ...EMPTY_NAV_LINK });
  const [editId, setEditId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  function startEdit(id: string) {
    const l = navLinks.find((l) => l.id === id);
    if (!l) return;
    setEditId(id);
    setForm({ label: l.label, icon: l.icon as NavLinkIconKey, link_type: l.link_type, href: l.href, visibility: l.visibility });
  }

  function cancelEdit() {
    setEditId(null);
    setForm({ ...EMPTY_NAV_LINK });
  }

  async function handleSave() {
    if (!form.label.trim() || !form.href.trim()) return;
    setSaving(true);
    const isNew = !editId;
    const payload = {
      label: form.label.trim(),
      icon: form.icon,
      link_type: form.link_type,
      href: form.link_type === "external" ? withScheme(form.href.trim()) : form.href.trim(),
      visibility: form.visibility,
    };
    const { error } = editId
      ? await supabase.from("nav_links").update(payload).eq("id", editId)
      : await supabase.from("nav_links").insert({ ...payload, sort_order: navLinks.length });
    setSaving(false);
    if (!error) {
      // Every new nav link also becomes a browsable resource by default, kept
      // independent of the nav_links row (no FK) — removing the nav link later
      // must leave the resource in place on the Resources page (Eshan's spec).
      if (isNew) {
        const { error: resourceError } = await supabase
          .from("resources")
          .insert({ title: payload.label, url: payload.href, resource_type: "Platform Directory" });
        if (resourceError) console.error("[AdminPage] auto-create resource for nav link failed:", resourceError);
      }
      setForm({ ...EMPTY_NAV_LINK });
      setEditId(null);
      reload();
    } else {
      console.error("[AdminPage] save nav link failed:", error);
    }
  }

  async function handleDelete(id: string) {
    const { error } = await supabase.from("nav_links").delete().eq("id", id);
    if (error) {
      console.error("[AdminPage] delete nav link failed:", error);
      alert("Couldn't delete that link — check your connection and try again.");
      return;
    }
    reload();
  }

  async function move(id: string, direction: -1 | 1) {
    const idx = navLinks.findIndex((l) => l.id === id);
    const target = navLinks[idx + direction];
    if (!target) return;
    const current = navLinks[idx];
    const first = await supabase.from("nav_links").update({ sort_order: target.sort_order }).eq("id", current.id);
    if (first.error) {
      console.error("[AdminPage] reorder nav link failed:", first.error);
      alert("Couldn't reorder that link — check your connection and try again.");
      return;
    }
    const second = await supabase.from("nav_links").update({ sort_order: current.sort_order }).eq("id", target.id);
    if (second.error) {
      console.error("[AdminPage] reorder nav link failed (partial):", second.error);
      alert("Reorder only half-completed — two links may now share the same position. Reloading to show the actual state; check the order below.");
    }
    reload();
  }

  return (
    <div>
      <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
        <div className="flex items-center justify-between mb-2">
          <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans }}>{editId ? "Edit link" : "Add a link"}</p>
          {editId && <button onClick={cancelEdit} style={{ fontSize: 12, color: COLOR.ink3, background: "none", border: "none", cursor: "pointer" }}>Cancel edit</button>}
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-2 mb-2">
          <LabeledField label="Label">
            <input style={inputStyle} value={form.label} onChange={(e) => setForm((f) => ({ ...f, label: e.target.value }))} />
          </LabeledField>
          <LabeledField label="Icon">
            <select style={inputStyle} value={form.icon} onChange={(e) => setForm((f) => ({ ...f, icon: e.target.value as NavLinkIconKey }))}>
              {(Object.keys(NAV_LINK_ICONS) as NavLinkIconKey[]).map((key) => <option key={key} value={key}>{key}</option>)}
            </select>
          </LabeledField>
        </div>

        <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, margin: "4px 0" }}>Type</p>
        <div className="flex flex-wrap gap-1 mb-2">
          {(["external", "internal"] as NavLinkType[]).map((t) => (
            <Chip key={t} active={form.link_type === t} onClick={() => setForm((f) => ({ ...f, link_type: t }))} label={t === "external" ? "External URL" : "Internal page"} />
          ))}
        </div>

        <LabeledField label={form.link_type === "external" ? "URL" : "App path (e.g. /resources)"} className="mb-2">
          <input style={inputStyle} value={form.href} onChange={(e) => setForm((f) => ({ ...f, href: e.target.value }))} placeholder={form.link_type === "external" ? "https://…" : "/resources"} />
        </LabeledField>

        <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, margin: "4px 0" }}>Visible to</p>
        <div className="flex flex-wrap gap-1 mb-3">
          {(["everyone", "admin"] as NavLinkVisibility[]).map((v) => (
            <Chip key={v} active={form.visibility === v} onClick={() => setForm((f) => ({ ...f, visibility: v }))} label={v === "everyone" ? "Everyone" : "Admins only"} />
          ))}
        </div>

        <button onClick={handleSave} disabled={saving} style={buttonStyle}>
          {saving ? "Saving…" : editId ? "Save changes" : "Add link"}
        </button>
      </div>

      <div className="space-y-2">
        {navLinks.map((l, idx) => {
          const Icon = NAV_LINK_ICONS[l.icon as NavLinkIconKey];
          return (
            <div key={l.id} className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
              <div className="flex items-center gap-2" style={{ minWidth: 0 }}>
                <Icon size={15} color={COLOR.ink2} />
                <div style={{ minWidth: 0 }}>
                  <p style={{ fontSize: 13, fontWeight: 600, fontFamily: FONT.sans }}>
                    {l.label}
                    {l.visibility === "admin" && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.red, marginLeft: 6 }}>ADMINS ONLY</span>}
                  </p>
                  <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, wordBreak: "break-all" }}>
                    {l.link_type === "external" ? "External" : "Internal"} · {l.href}
                  </p>
                </div>
              </div>
              <div style={{ display: "flex", gap: 10, flexShrink: 0, alignItems: "center" }}>
                <button onClick={() => move(l.id, -1)} disabled={idx === 0} style={{ background: "none", border: "none", cursor: idx === 0 ? "default" : "pointer", opacity: idx === 0 ? 0.3 : 1 }} aria-label="Move up">
                  <ArrowUp size={14} color={COLOR.ink2} />
                </button>
                <button onClick={() => move(l.id, 1)} disabled={idx === navLinks.length - 1} style={{ background: "none", border: "none", cursor: idx === navLinks.length - 1 ? "default" : "pointer", opacity: idx === navLinks.length - 1 ? 0.3 : 1 }} aria-label="Move down">
                  <ArrowDown size={14} color={COLOR.ink2} />
                </button>
                <button onClick={() => startEdit(l.id)} style={{ fontSize: 12, color: COLOR.ink2, background: "none", border: "none", cursor: "pointer" }}>Edit</button>
                <button onClick={() => handleDelete(l.id)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer" }}>Delete</button>
              </div>
            </div>
          );
        })}
        {navLinks.length === 0 && <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>No extra links yet.</p>}
      </div>
    </div>
  );
}

const EMPTY_POPUP = {
  title: "", body: "", icon: "" as PopupIconKey | "", page: "",
  frequency: "always" as PopupFrequency,
  primary_label: "Got it", primary_action: "dismiss" as PopupPrimaryAction, primary_target: "",
  secondary_label: "Maybe later",
};

const FREQUENCY_OPTIONS: { value: PopupFrequency; label: string }[] = [
  { value: "always", label: "Every visit to the page" },
  { value: "session", label: "Once per browser session" },
  { value: "once", label: "Once, ever" },
];

const PRIMARY_ACTION_OPTIONS: { value: PopupPrimaryAction; label: string }[] = [
  { value: "dismiss", label: "Just dismiss" },
  { value: "internal", label: "Go to a page in the app" },
  { value: "external", label: "Open a link" },
];

function PopupsAdmin() {
  const { popups, reload } = useDashboardPopups();
  const [form, setForm] = useState({ ...EMPTY_POPUP });
  const [editSlug, setEditSlug] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  function startEdit(slug: string) {
    const p = popups.find((p) => p.slug === slug);
    if (!p) return;
    setEditSlug(slug);
    setForm({
      title: p.title, body: p.body, icon: (p.icon as PopupIconKey) ?? "", page: p.page,
      frequency: p.frequency, primary_label: p.primary_label, primary_action: p.primary_action,
      primary_target: p.primary_target ?? "", secondary_label: p.secondary_label ?? "",
    });
  }

  function cancelEdit() {
    setEditSlug(null);
    setForm({ ...EMPTY_POPUP });
  }

  async function handleSave() {
    if (!form.title.trim() || !form.body.trim()) return;
    if (form.primary_action !== "dismiss" && !form.primary_target.trim()) return;
    setSaving(true);
    // Internal targets are app paths, not URLs — only external links get the https:// fallback.
    const primaryTarget =
      form.primary_action === "dismiss" ? null
      : form.primary_action === "internal" ? form.primary_target.trim()
      : withScheme(form.primary_target.trim());
    const payload = {
      title: form.title.trim(),
      body: form.body.trim(),
      icon: form.icon || null,
      page: form.page,
      frequency: form.frequency,
      primary_label: form.primary_label.trim() || "Got it",
      primary_action: form.primary_action,
      primary_target: primaryTarget,
      secondary_label: form.secondary_label.trim() || null,
      updated_at: new Date().toISOString(),
    };
    const { error } = editSlug
      ? await supabase.from("dashboard_popups").update(payload).eq("slug", editSlug)
      : await supabase.from("dashboard_popups").insert({ slug: crypto.randomUUID(), enabled: true, ...payload });
    setSaving(false);
    if (!error) {
      setForm({ ...EMPTY_POPUP });
      setEditSlug(null);
      reload();
    } else {
      console.error("[AdminPage] save popup failed:", error);
    }
  }

  async function toggleEnabled(slug: string, enabled: boolean) {
    const { error } = await supabase.from("dashboard_popups").update({ enabled: !enabled }).eq("slug", slug);
    if (error) {
      console.error("[AdminPage] toggle popup enabled failed:", error);
      alert("Couldn't update that popup — check your connection and try again.");
      return;
    }
    reload();
  }

  async function handleDelete(slug: string) {
    const { error } = await supabase.from("dashboard_popups").delete().eq("slug", slug);
    if (error) {
      console.error("[AdminPage] delete popup failed:", error);
      alert("Couldn't delete that popup — check your connection and try again.");
      return;
    }
    reload();
  }

  return (
    <div>
      <div style={{ padding: 16, borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, marginBottom: 20 }}>
        <div className="flex items-center justify-between mb-2">
          <p style={{ fontSize: 13, fontWeight: 700, fontFamily: FONT.sans }}>{editSlug ? "Edit popup" : "Create a popup"}</p>
          {editSlug && <button onClick={cancelEdit} style={{ fontSize: 12, color: COLOR.ink3, background: "none", border: "none", cursor: "pointer" }}>Cancel edit</button>}
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-2 mb-2">
          <LabeledField label="Title">
            <input style={inputStyle} value={form.title} onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))} />
          </LabeledField>
          <LabeledField label="Icon (optional)">
            <select style={inputStyle} value={form.icon} onChange={(e) => setForm((f) => ({ ...f, icon: e.target.value as PopupIconKey | "" }))}>
              <option value="">No icon</option>
              {(Object.keys(POPUP_ICONS) as PopupIconKey[]).map((key) => <option key={key} value={key}>{key}</option>)}
            </select>
          </LabeledField>
        </div>
        <LabeledField label="Body" className="mb-2">
          <textarea
            style={{ ...inputStyle, resize: "none" }} rows={2}
            value={form.body} onChange={(e) => setForm((f) => ({ ...f, body: e.target.value }))}
            placeholder="What the student sees below the title"
          />
        </LabeledField>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-2 mb-3">
          <LabeledField label="Show on">
            <select style={inputStyle} value={form.page} onChange={(e) => setForm((f) => ({ ...f, page: e.target.value }))}>
              {POPUP_PAGES.map((p) => <option key={p.value} value={p.value}>{p.label}</option>)}
            </select>
          </LabeledField>
          <LabeledField label="How often">
            <select style={inputStyle} value={form.frequency} onChange={(e) => setForm((f) => ({ ...f, frequency: e.target.value as PopupFrequency }))}>
              {FREQUENCY_OPTIONS.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </LabeledField>
        </div>

        <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, margin: "4px 0" }}>Primary button</p>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-2 mb-2">
          <LabeledField label="Label">
            <input style={inputStyle} value={form.primary_label} onChange={(e) => setForm((f) => ({ ...f, primary_label: e.target.value }))} />
          </LabeledField>
          <LabeledField label="Action">
            <select style={inputStyle} value={form.primary_action} onChange={(e) => setForm((f) => ({ ...f, primary_action: e.target.value as PopupPrimaryAction }))}>
              {PRIMARY_ACTION_OPTIONS.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </LabeledField>
        </div>
        {form.primary_action !== "dismiss" && (
          <LabeledField label={form.primary_action === "internal" ? "App path (e.g. /learn/practice)" : "URL"} className="mb-2">
            <input
              style={inputStyle} value={form.primary_target}
              onChange={(e) => setForm((f) => ({ ...f, primary_target: e.target.value }))}
              placeholder={form.primary_action === "internal" ? "/learn/practice" : "https://…"}
            />
          </LabeledField>
        )}
        <LabeledField label="Secondary button label (leave blank to hide it)" className="mb-3">
          <input style={inputStyle} value={form.secondary_label} onChange={(e) => setForm((f) => ({ ...f, secondary_label: e.target.value }))} />
        </LabeledField>

        <button onClick={handleSave} disabled={saving} style={buttonStyle}>
          {saving ? "Saving…" : editSlug ? "Save changes" : "Create popup"}
        </button>
      </div>

      <div className="space-y-2">
        {popups.map((p) => {
          const pageLabel = POPUP_PAGES.find((pg) => pg.value === p.page)?.label ?? p.page;
          return (
            <div key={p.slug} className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2" style={{ padding: "10px 14px", borderRadius: 9, background: p.enabled ? COLOR.surface : COLOR.bgSoft, border: `1px solid ${COLOR.borderLight}`, opacity: p.enabled ? 1 : 0.6 }}>
              <div style={{ minWidth: 0 }}>
                <p style={{ fontSize: 13, fontWeight: 600, fontFamily: FONT.sans }}>
                  {p.title}
                  {!p.enabled && <span style={{ fontSize: 10, fontWeight: 700, color: COLOR.red, marginLeft: 6 }}>DISABLED</span>}
                </p>
                <p style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans }}>
                  {pageLabel} · {FREQUENCY_OPTIONS.find((o) => o.value === p.frequency)?.label}
                </p>
              </div>
              <div style={{ display: "flex", gap: 12, flexShrink: 0 }}>
                <button onClick={() => startEdit(p.slug)} style={{ fontSize: 12, color: COLOR.ink2, background: "none", border: "none", cursor: "pointer" }}>Edit</button>
                <button onClick={() => toggleEnabled(p.slug, p.enabled)} style={{ fontSize: 12, color: p.enabled ? COLOR.red : COLOR.green, background: "none", border: "none", cursor: "pointer" }}>
                  {p.enabled ? "Disable" : "Enable"}
                </button>
                <button onClick={() => handleDelete(p.slug)} style={{ fontSize: 12, color: COLOR.red, background: "none", border: "none", cursor: "pointer" }}>Delete</button>
              </div>
            </div>
          );
        })}
        {popups.length === 0 && <p style={{ fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>No popups yet.</p>}
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
