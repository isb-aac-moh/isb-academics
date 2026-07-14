/**
 * Course Resources — the one place to find anything for any course, all year.
 * Single page: search + filters (reflected in the URL as query params, not
 * separate pages per term), a course gallery, and a click-to-open detail panel.
 * Search is simple text matching for now — title, course name/code, professor.
 * (An NLP/AI-assisted version is a planned follow-up, not built yet.)
 */
import { useMemo } from "react";
import { useSearchParams } from "react-router-dom";
import { Search, X, ExternalLink, FileText } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useResources } from "../hooks/useResources";
import { useCourses } from "../hooks/useCourses";
import { ALL_TERMS, RESOURCE_TYPES } from "../lib/options";
import type { Resource, Course } from "../types";

const CARD_TINTS = [COLOR.navyTint, COLOR.amberTint, COLOR.greenTint, COLOR.bgSoft];

export default function CourseResources() {
  const { resources, loading: resourcesLoading } = useResources();
  const { courses, loading: coursesLoading } = useCourses();
  const [params, setParams] = useSearchParams();

  const q = params.get("q") ?? "";
  const termFilter = params.get("term") ?? "all";
  const typeFilter = params.get("type") ?? "all";
  const kindFilter = params.get("kind") ?? "all"; // all | core | elective
  const activeCourseCode = params.get("course");
  const activeCourse = activeCourseCode ? courses.find((c) => c.code === activeCourseCode) : undefined;

  function setParam(key: string, value: string | null, opts?: { replace?: boolean }) {
    const next = new URLSearchParams(params);
    if (value === null || value === "" || value === "all") next.delete(key);
    else next.set(key, value);
    setParams(next, opts);
  }

  const hasFilters = q.trim() !== "" || termFilter !== "all" || typeFilter !== "all" || kindFilter !== "all";

  const resourcesByCourse = useMemo(() => {
    const map = new Map<string, Resource[]>();
    resources.forEach((r) => {
      if (!r.course_id) return;
      const list = map.get(r.course_id) ?? [];
      list.push(r);
      map.set(r.course_id, list);
    });
    return map;
  }, [resources]);

  const filteredCourses = useMemo(() => {
    const query = q.trim().toLowerCase();
    return courses.filter((c) => {
      if (termFilter !== "all" && c.term !== termFilter) return false;
      if (kindFilter === "core" && !c.is_core) return false;
      if (kindFilter === "elective" && c.is_core) return false;
      const courseResources = resourcesByCourse.get(c.id) ?? [];
      if (typeFilter !== "all" && !courseResources.some((r) => r.resource_type === typeFilter)) return false;
      if (query) {
        const hay = `${c.name} ${c.code} ${c.professor}`.toLowerCase();
        const resMatch = courseResources.some((r) => r.title.toLowerCase().includes(query));
        if (!hay.includes(query) && !resMatch) return false;
      }
      return true;
    });
  }, [courses, termFilter, kindFilter, typeFilter, q, resourcesByCourse]);

  const platformDirectory = resources.filter((r) => r.resource_type === "Platform Directory");
  const general = resources.filter((r) => r.resource_type === "General");

  const matchingLooseResources = useMemo(() => {
    if (!q.trim()) return [];
    const query = q.trim().toLowerCase();
    return resources.filter((r) => !r.course_id && r.title.toLowerCase().includes(query));
  }, [resources, q]);

  const termsPresent = useMemo(() => ALL_TERMS.filter((t) => courses.some((c) => c.term === t)), [courses]);

  if (resourcesLoading || coursesLoading) {
    return <div style={{ padding: 40, fontFamily: FONT.sans, color: COLOR.ink2 }}>Loading…</div>;
  }

  return (
    <div className="min-h-screen pb-24" style={{ background: COLOR.bg }}>
      <header className="px-6 md:px-12 pt-10 pb-6">
        <h1 style={{ fontFamily: FONT.serif, fontSize: 26, fontWeight: 500, color: COLOR.ink }}>
          Course <em>Resources</em>
        </h1>
        <p style={{ fontFamily: FONT.sans, fontSize: 13, color: COLOR.ink2, marginTop: 4 }}>
          Everything for every course, all year — search or filter to find it.
        </p>

        <div className="relative mt-6" style={{ maxWidth: 540 }}>
          <Search size={16} style={{ position: "absolute", left: 14, top: "50%", transform: "translateY(-50%)" }} color={COLOR.ink3} />
          <input
            value={q}
            onChange={(e) => setParam("q", e.target.value, { replace: true })}
            placeholder="Search courses, professors, outlines, notes…"
            style={{ width: "100%", padding: "12px 38px 12px 40px", borderRadius: 11, border: `1px solid ${COLOR.border}`, fontSize: 14, fontFamily: FONT.sans, background: COLOR.surface, outline: "none" }}
          />
          {q && (
            <button onClick={() => setParam("q", null)} style={{ position: "absolute", right: 12, top: "50%", transform: "translateY(-50%)", background: "none", border: "none", cursor: "pointer" }}>
              <X size={15} color={COLOR.ink3} />
            </button>
          )}
        </div>

        <div className="flex flex-wrap gap-1.5 mt-4">
          <FilterChip active={termFilter === "all"} onClick={() => setParam("term", null)} label="All terms" />
          {termsPresent.map((t) => (
            <FilterChip key={t} active={termFilter === t} onClick={() => setParam("term", t)} label={t} />
          ))}
        </div>
        <div className="flex flex-wrap items-center gap-1.5 mt-2">
          <FilterChip active={kindFilter === "all"} onClick={() => setParam("kind", null)} label="All courses" muted />
          <FilterChip active={kindFilter === "core"} onClick={() => setParam("kind", "core")} label="Core" muted />
          <FilterChip active={kindFilter === "elective"} onClick={() => setParam("kind", "elective")} label="Elective" muted />
          <select
            value={typeFilter}
            onChange={(e) => setParam("type", e.target.value)}
            style={{ marginLeft: 6, padding: "6px 10px", borderRadius: 7, border: `1px solid ${COLOR.border}`, fontSize: 12, fontFamily: FONT.sans, color: COLOR.ink2, background: COLOR.surface }}
          >
            <option value="all">All resource types</option>
            {RESOURCE_TYPES.map((t) => <option key={t} value={t}>{t}</option>)}
          </select>
        </div>
      </header>

      <main className="px-6 md:px-12 space-y-10" style={{ maxWidth: 1100 }}>
        {!hasFilters && platformDirectory.length > 0 && (
          <Section title="Platform Directory">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
              {platformDirectory.map((r) => <LinkCard key={r.id} resource={r} />)}
            </div>
          </Section>
        )}

        {!hasFilters && general.length > 0 && (
          <Section title="General">
            <div className="space-y-2">{general.map((r) => <ResourceRow key={r.id} resource={r} />)}</div>
          </Section>
        )}

        {matchingLooseResources.length > 0 && (
          <Section title="Matching resources">
            <div className="space-y-2">{matchingLooseResources.map((r) => <ResourceRow key={r.id} resource={r} />)}</div>
          </Section>
        )}

        <Section title={hasFilters ? `${filteredCourses.length} course${filteredCourses.length === 1 ? "" : "s"}` : "All courses"}>
          {filteredCourses.length === 0 ? (
            <EmptyState hasFilters={hasFilters} />
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
              {filteredCourses.map((c, i) => (
                <CourseCard
                  key={c.id}
                  course={c}
                  resourceCount={(resourcesByCourse.get(c.id) ?? []).length}
                  tint={CARD_TINTS[i % CARD_TINTS.length]}
                  onClick={() => setParam("course", c.code)}
                />
              ))}
            </div>
          )}
        </Section>
      </main>

      {activeCourse && (
        <CourseDetailModal course={activeCourse} resources={resourcesByCourse.get(activeCourse.id) ?? []} onClose={() => setParam("course", null)} />
      )}
    </div>
  );
}

function CourseCard({ course, resourceCount, tint, onClick }: { course: Course; resourceCount: number; tint: string; onClick: () => void }) {
  const badgeLabel = course.is_core ? "Core" : (course.concentration_areas[0] ?? course.industry_specializations[0] ?? "Elective");
  return (
    <button
      onClick={onClick}
      className="flex flex-col"
      style={{ textAlign: "left", padding: "16px 18px", borderRadius: 14, background: tint, border: `1px solid ${COLOR.borderLight}`, cursor: "pointer", gap: 10, minHeight: 140 }}
    >
      <div className="flex items-center justify-between gap-2">
        <span style={{ fontSize: 10, fontWeight: 700, padding: "2px 8px", borderRadius: 6, background: course.is_core ? COLOR.navyHero : "rgba(255,255,255,0.7)", color: course.is_core ? "#fff" : COLOR.ink2, fontFamily: FONT.sans, textTransform: "uppercase", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
          {badgeLabel}
        </span>
        <span style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, flexShrink: 0 }}>{course.term}</span>
      </div>
      <p style={{ fontSize: 15, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, lineHeight: 1.3, flex: 1 }}>{course.name}</p>
      <p style={{ fontSize: 11.5, color: COLOR.ink2, fontFamily: FONT.sans }}>{course.code} · {course.professor}</p>
      <div className="flex items-center gap-1.5" style={{ fontSize: 12, color: COLOR.ink2, fontFamily: FONT.sans, fontWeight: 600 }}>
        <FileText size={13} /> {resourceCount} resource{resourceCount === 1 ? "" : "s"}
      </div>
    </button>
  );
}

function CourseDetailModal({ course, resources, onClose }: { course: Course; resources: Resource[]; onClose: () => void }) {
  const byType = new Map<string, Resource[]>();
  resources.forEach((r) => {
    const list = byType.get(r.resource_type) ?? [];
    list.push(r);
    byType.set(r.resource_type, list);
  });

  return (
    <div style={{ position: "fixed", inset: 0, zIndex: 60 }}>
      <div onClick={onClose} style={{ position: "absolute", inset: 0, background: "rgba(0,0,0,0.4)" }} />
      <div
        className="flex flex-col"
        style={{ position: "absolute", top: 0, right: 0, bottom: 0, width: "min(480px, 100%)", background: COLOR.bg, boxShadow: "-8px 0 32px rgba(0,0,0,0.12)" }}
      >
        <div className="flex items-start justify-between" style={{ padding: "20px 22px", borderBottom: `1px solid ${COLOR.borderLight}`, flexShrink: 0 }}>
          <div>
            {course.is_core && <span style={{ fontSize: 10, fontWeight: 700, padding: "2px 8px", borderRadius: 6, background: COLOR.navyHero, color: "#fff", fontFamily: FONT.sans, textTransform: "uppercase" }}>Core</span>}
            <h2 style={{ fontFamily: FONT.serif, fontSize: 19, fontWeight: 600, color: COLOR.ink, marginTop: 6 }}>{course.name}</h2>
            <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>{course.code} · {course.professor} · {course.term}</p>
          </div>
          <button onClick={onClose} style={{ background: "none", border: "none", cursor: "pointer", flexShrink: 0 }}><X size={20} color={COLOR.ink2} /></button>
        </div>

        <div className="flex-1" style={{ overflowY: "auto", padding: "20px 22px" }}>
          {resources.length === 0 ? (
            <div style={{ padding: "24px 16px", textAlign: "center", background: COLOR.surface, borderRadius: 10, border: `1px dashed ${COLOR.border}` }}>
              <FileText size={22} color={COLOR.ink3} style={{ margin: "0 auto 8px" }} />
              <p style={{ fontSize: 13, fontWeight: 600, color: COLOR.ink2, fontFamily: FONT.sans }}>No resources yet for this course</p>
              <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>Check back later, or add one from the Admin panel.</p>
            </div>
          ) : (
            <div className="space-y-5">
              {Array.from(byType.entries()).map(([type, items]) => (
                <div key={type}>
                  <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 8 }}>{type}</p>
                  <div className="space-y-2">{items.map((r) => <ResourceRow key={r.id} resource={r} />)}</div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

function EmptyState({ hasFilters }: { hasFilters: boolean }) {
  return (
    <div style={{ padding: "32px 16px", textAlign: "center", background: COLOR.surface, borderRadius: 10, border: `1px dashed ${COLOR.border}` }}>
      <p style={{ fontSize: 13.5, fontWeight: 600, color: COLOR.ink2, fontFamily: FONT.sans }}>
        {hasFilters ? "No courses match your search/filters" : "No courses loaded yet"}
      </p>
      {hasFilters && <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>Try a broader search or clear a filter.</p>}
    </div>
  );
}

function ResourceRow({ resource }: { resource: Resource }) {
  return (
    <a
      href={resource.url}
      target="_blank"
      rel="noreferrer"
      className="flex items-center justify-between"
      style={{ padding: "11px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, textDecoration: "none" }}
    >
      <span style={{ fontSize: 13.5, fontWeight: 600, fontFamily: FONT.sans, color: COLOR.ink, minWidth: 0 }}>{resource.title}</span>
      <ExternalLink size={14} color={COLOR.ink3} style={{ flexShrink: 0, marginLeft: 8 }} />
    </a>
  );
}

function LinkCard({ resource }: { resource: Resource }) {
  return (
    <a
      href={resource.url}
      target="_blank"
      rel="noreferrer"
      className="flex items-center justify-between"
      style={{ padding: "13px 16px", borderRadius: 10, background: COLOR.navyTint, border: `1px solid ${COLOR.borderLight}`, textDecoration: "none" }}
    >
      <span style={{ fontSize: 13.5, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.navyHero }}>{resource.title}</span>
      <ExternalLink size={14} color={COLOR.navyHero} />
    </a>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section>
      <h2 style={{ fontFamily: FONT.serif, fontSize: 18, fontWeight: 500, color: COLOR.ink, marginBottom: 12 }}>{title}</h2>
      {children}
    </section>
  );
}

function FilterChip({ active, onClick, label, muted }: { active: boolean; onClick: () => void; label: string; muted?: boolean }) {
  return (
    <button
      onClick={onClick}
      style={{
        padding: muted ? "5px 12px" : "7px 14px", borderRadius: 8, fontSize: muted ? 11.5 : 12.5, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer",
        border: `1px solid ${active ? COLOR.navyHero : COLOR.border}`, background: active ? COLOR.navyHero : COLOR.surface, color: active ? "#fff" : COLOR.ink2,
      }}
    >
      {label}
    </button>
  );
}
