/**
 * Course Resources — the one place to find anything for any course, all year.
 * Single page: search + filters (reflected in the URL as query params, not
 * separate pages per term), a course gallery, and a click-to-open detail panel.
 * Search is simple text matching for now — title, course name/code, professor.
 * (An NLP/AI-assisted version is a planned follow-up, not built yet.)
 */
import { useEffect, useId, useMemo, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { usePostHog } from "@posthog/react";
import { Search, X, ExternalLink, FileText, Pin, ChevronRight } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { PageSkeleton } from "../components/Skeleton";
import { useModalA11y } from "../hooks/useModalA11y";
import { useResources } from "../hooks/useResources";
import { useCourses } from "../hooks/useCourses";
import { useFaculty, type CourseFacultyEntry } from "../hooks/useFaculty";
import { RatingBadge } from "../components/FacultySection";
import { CourseDetailModal, ResourceRow } from "../components/CourseDetailModal";
import { ALL_TERMS, RESOURCE_TABS, buildPopulatedTabs, sortPinned } from "../lib/options";
import { getCurrentTermCode } from "../lib/termCalendar";
import type { Resource, Course } from "../types";

const CARD_TINTS = [COLOR.navyTint, COLOR.amberTint, COLOR.greenTint, COLOR.bgSoft];

export default function CourseResources() {
  const { resources, loading: resourcesLoading } = useResources();
  const { courses, loading: coursesLoading } = useCourses();
  const { byCourse: facultyByCourse } = useFaculty();
  const [params, setParams] = useSearchParams();
  const posthog = usePostHog();

  const q = params.get("q") ?? "";
  const termFilter = params.get("term") ?? "all";
  const typeFilter = params.get("type") ?? "all";
  const kindFilter = params.get("kind") ?? "all"; // all | core | elective
  const activeCourseCode = params.get("course");
  const activeCourse = activeCourseCode ? courses.find((c) => c.code === activeCourseCode) : undefined;
  const isFullScreen = params.get("view") === "full";
  const generalView = params.get("view") === "general";

  function setParam(key: string, value: string | null, opts?: { replace?: boolean }) {
    const next = new URLSearchParams(params);
    if (value === null || value === "" || value === "all") next.delete(key);
    else next.set(key, value);
    setParams(next, opts);
  }

  // First-time UX: default the term filter to whatever term is running right
  // now (per the official academic calendar), so a student doesn't land on an
  // unfiltered wall of every course ISB offers. Only applies on a fresh load —
  // explicitly clearing to "All terms" removes the param and stays cleared
  // until the next fresh visit.
  useEffect(() => {
    if (params.has("term")) return;
    const current = getCurrentTermCode();
    if (current) setParam("term", current, { replace: true });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

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
      if (typeFilter !== "all") {
        const tab = RESOURCE_TABS.find((t) => t.key === typeFilter);
        const typesInTab: readonly string[] = tab?.types ?? [];
        if (!courseResources.some((r) => typesInTab.includes(r.resource_type))) return false;
      }
      if (query) {
        const hay = `${c.name} ${c.code} ${c.professor}`.toLowerCase();
        const resMatch = courseResources.some((r) => r.title.toLowerCase().includes(query));
        if (!hay.includes(query) && !resMatch) return false;
      }
      return true;
    });
  }, [courses, termFilter, kindFilter, typeFilter, q, resourcesByCourse]);

  // Always cohort-wide, never course-scoped — only search narrows it down.
  const platformDirectory = useMemo(() => {
    const query = q.trim().toLowerCase();
    return sortPinned(resources.filter((r) => r.resource_type === "Platform Directory" && (!query || r.title.toLowerCase().includes(query))));
  }, [resources, q]);

  // Everything with no course attached that isn't a Platform Directory link —
  // General-type resources, plus any course-scoped type (Custom GPT, PYQP…)
  // an admin saved without picking a specific course ("term-wide"). Respects
  // the same term/type/search filters as the course grid below it.
  const generalResources = useMemo(() => {
    const query = q.trim().toLowerCase();
    return sortPinned(resources.filter((r) => {
      if (r.course_id || r.resource_type === "Platform Directory") return false;
      if (termFilter !== "all" && r.term !== null && r.term !== termFilter) return false;
      if (typeFilter !== "all") {
        const tab = RESOURCE_TABS.find((t) => t.key === typeFilter);
        const typesInTab: readonly string[] = tab?.types ?? [];
        if (!typesInTab.includes(r.resource_type)) return false;
      }
      if (query && !r.title.toLowerCase().includes(query)) return false;
      return true;
    }));
  }, [resources, termFilter, typeFilter, q]);

  const pinnedGlobal = useMemo(() => resources.filter((r) => r.pinned_global), [resources]);

  const termsPresent = useMemo(() => ALL_TERMS.filter((t) => courses.some((c) => c.term === t)), [courses]);

  if (resourcesLoading || coursesLoading) {
    return <PageSkeleton variant="list" />;
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

        {pinnedGlobal.length > 0 && (
          <div className="flex flex-wrap gap-2 mt-4">
            {pinnedGlobal.map((r) => (
              <a
                key={r.id}
                href={r.url}
                target="_blank"
                rel="noreferrer"
                className="flex items-center gap-1.5"
                style={{ padding: "6px 12px", borderRadius: 20, background: COLOR.navyHero, color: "#fff", textDecoration: "none", fontFamily: FONT.sans, fontSize: 12, fontWeight: 700 }}
              >
                <Pin size={11} fill="#fff" /> {r.title}
              </a>
            ))}
          </div>
        )}

        <div className="relative mt-6" style={{ maxWidth: 540 }}>
          <Search size={16} style={{ position: "absolute", left: 14, top: "50%", transform: "translateY(-50%)" }} color={COLOR.ink3} />
          <input
            value={q}
            onChange={(e) => setParam("q", e.target.value, { replace: true })}
            placeholder="Search courses, professors, outlines, notes…"
            aria-label="Search courses and resources"
            style={{ width: "100%", padding: "12px 38px 12px 40px", borderRadius: 11, border: `1px solid ${COLOR.border}`, fontSize: 14, fontFamily: FONT.sans, background: COLOR.surface, outline: "none" }}
          />
          {q && (
            <button onClick={() => setParam("q", null)} aria-label="Clear search" style={{ position: "absolute", right: 12, top: "50%", transform: "translateY(-50%)", background: "none", border: "none", cursor: "pointer" }}>
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
            aria-label="Filter by resource type"
            style={{ marginLeft: 6, padding: "6px 10px", borderRadius: 7, border: `1px solid ${COLOR.border}`, fontSize: 12, fontFamily: FONT.sans, color: COLOR.ink2, background: COLOR.surface }}
          >
            <option value="all">All resource types</option>
            {RESOURCE_TABS.map((t) => <option key={t.key} value={t.key}>{t.label}</option>)}
          </select>
        </div>
      </header>

      <main className="px-6 md:px-12 space-y-10" style={{ maxWidth: 1100 }}>
        {platformDirectory.length > 0 && (
          <Section title="Platform Directory">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
              {platformDirectory.map((r) => <LinkCard key={r.id} resource={r} />)}
            </div>
          </Section>
        )}

        {generalResources.length > 0 && (
          <Section title="General Resources">
            <div className="space-y-2">
              {generalResources.slice(0, 4).map((r) => <ResourceRow key={r.id} resource={r} />)}
            </div>
            {generalResources.length > 4 && (
              <button
                onClick={() => setParam("view", "general")}
                className="flex items-center gap-1"
                style={{ marginTop: 10, background: "none", border: "none", cursor: "pointer", fontFamily: FONT.sans, fontSize: 12.5, fontWeight: 700, color: COLOR.navyHero, padding: 0 }}
              >
                See all {generalResources.length} <ChevronRight size={14} />
              </button>
            )}
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
                  facultyByCourse={facultyByCourse}
                  tint={CARD_TINTS[i % CARD_TINTS.length]}
                  onClick={() => {
                    setParam("course", c.code);
                    posthog?.capture("course_profile_opened", { course_code: c.code, source: "resources" });
                  }}
                />
              ))}
            </div>
          )}
        </Section>
      </main>

      {activeCourse && (
        <CourseDetailModal
          course={activeCourse}
          resources={resourcesByCourse.get(activeCourse.id) ?? []}
          facultyByCourse={facultyByCourse}
          fullScreen={isFullScreen}
          onToggleFullScreen={() => setParam("view", isFullScreen ? null : "full")}
          onClose={() => {
            const next = new URLSearchParams(params);
            next.delete("course");
            next.delete("view");
            setParams(next);
          }}
        />
      )}

      {generalView && !activeCourse && (
        <GeneralResourcesModal resources={generalResources} onClose={() => setParam("view", null)} />
      )}
    </div>
  );
}

// The per-course lookup lives in the child: doing Map.get() inside the parent's
// JSX makes the React Compiler assume the course objects may be mutated.
function CourseCard({ course, resourceCount, facultyByCourse, tint, onClick }: { course: Course; resourceCount: number; facultyByCourse: Map<string, CourseFacultyEntry[]>; tint: string; onClick: () => void }) {
  const faculty = facultyByCourse.get(course.id) ?? [];
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
      <div className="flex items-center justify-between gap-2" style={{ fontSize: 12, color: COLOR.ink2, fontFamily: FONT.sans, fontWeight: 600 }}>
        <span className="flex items-center gap-1.5"><FileText size={13} /> {resourceCount} resource{resourceCount === 1 ? "" : "s"}</span>
        <RatingBadge entries={faculty} courseCode={course.code} />
      </div>
    </button>
  );
}

/** Full-screen view for "See all" on General Resources — same tabbed layout as a course's detail panel, just not scoped to one course. */
function GeneralResourcesModal({ resources, onClose }: { resources: Resource[]; onClose: () => void }) {
  const populatedTabs = buildPopulatedTabs(resources);
  const [activeTabKey, setActiveTabKey] = useState(populatedTabs[0]?.key);
  const activeTab = populatedTabs.find((t) => t.key === activeTabKey) ?? populatedTabs[0];
  const panelRef = useModalA11y<HTMLDivElement>(onClose);
  const titleId = useId();

  return (
    <div ref={panelRef} role="dialog" aria-modal="true" aria-labelledby={titleId} tabIndex={-1} style={{ position: "fixed", inset: 0, zIndex: 60, background: COLOR.bg }}>
      <div className="flex flex-col" style={{ height: "100%" }}>
        <div className="flex items-start justify-between" style={{ padding: "20px 22px", borderBottom: `1px solid ${COLOR.borderLight}`, flexShrink: 0 }}>
          <div style={{ maxWidth: 700, margin: "0 auto", width: "100%" }}>
            <h2 id={titleId} style={{ fontFamily: FONT.serif, fontSize: 26, fontWeight: 600, color: COLOR.ink }}>General Resources</h2>
            <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>Not tied to a specific course.</p>
          </div>
          <button onClick={onClose} aria-label="Close" style={{ background: "none", border: "none", cursor: "pointer", flexShrink: 0 }}><X size={20} color={COLOR.ink2} /></button>
        </div>

        {populatedTabs.length > 0 && (
          <div className="flex gap-1 flex-wrap" style={{ padding: "12px 22px 0", flexShrink: 0, maxWidth: 700, margin: "0 auto", width: "100%" }}>
            {populatedTabs.map((tab) => (
              <button
                key={tab.key}
                onClick={() => setActiveTabKey(tab.key)}
                aria-pressed={activeTab?.key === tab.key}
                style={{
                  padding: "7px 13px", borderRadius: 8, fontSize: 12.5, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer", border: "none",
                  background: activeTab?.key === tab.key ? COLOR.navyHero : COLOR.bgSoft, color: activeTab?.key === tab.key ? "#fff" : COLOR.ink2,
                }}
              >
                {tab.label} <span style={{ opacity: 0.7 }}>({tab.items.length})</span>
              </button>
            ))}
          </div>
        )}

        <div className="flex-1" style={{ overflowY: "auto", padding: "20px 22px" }}>
          <div style={{ maxWidth: 700, margin: "0 auto" }}>
            {resources.length === 0 ? (
              <div style={{ padding: "24px 16px", textAlign: "center", background: COLOR.surface, borderRadius: 10, border: `1px dashed ${COLOR.border}` }}>
                <FileText size={22} color={COLOR.ink3} style={{ margin: "0 auto 8px" }} />
                <p style={{ fontSize: 13, fontWeight: 600, color: COLOR.ink2, fontFamily: FONT.sans }}>No general resources yet</p>
              </div>
            ) : (
              <div className="space-y-2">{activeTab?.items.map((r) => <ResourceRow key={r.id} resource={r} />)}</div>
            )}
          </div>
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

function LinkCard({ resource }: { resource: Resource }) {
  return (
    <a
      href={resource.url}
      target="_blank"
      rel="noreferrer"
      className="flex items-start justify-between"
      style={{ padding: "13px 16px", borderRadius: 10, background: COLOR.navyTint, border: `1px solid ${COLOR.borderLight}`, textDecoration: "none", gap: 8 }}
    >
      <div style={{ minWidth: 0 }}>
        <span style={{ fontSize: 13.5, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.navyHero, display: "flex", alignItems: "center", gap: 5 }}>
          {resource.pinned && <Pin size={11} color={COLOR.navyHero} fill={COLOR.navyHero} />} {resource.title}
        </span>
        {resource.description && (
          <span style={{ fontSize: 12, fontFamily: FONT.sans, color: COLOR.navyHero, opacity: 0.75, display: "block", marginTop: 2, lineHeight: 1.4 }}>{resource.description}</span>
        )}
      </div>
      <ExternalLink size={14} color={COLOR.navyHero} style={{ flexShrink: 0, marginTop: 2 }} />
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
      aria-pressed={active}
      style={{
        padding: muted ? "5px 12px" : "7px 14px", borderRadius: 8, fontSize: muted ? 11.5 : 12.5, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer",
        border: `1px solid ${active ? COLOR.navyHero : COLOR.border}`, background: active ? COLOR.navyHero : COLOR.surface, color: active ? "#fff" : COLOR.ink2,
      }}
    >
      {label}
    </button>
  );
}
