/**
 * Course Resources — mirrors the AAC Notion repo's structure: a Platform
 * Directory up top, then resources browsable by Term > Course. Admin-only
 * preview until Eshan opens it up to students (see Sidebar gating).
 */
import { useMemo, useState } from "react";
import { ChevronRight, ExternalLink, FileText } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useResources } from "../hooks/useResources";
import { useCourses } from "../hooks/useCourses";
import type { Resource } from "../types";

type View = { level: "terms" } | { level: "courses"; term: string } | { level: "course"; term: string; courseId: string };

export default function CourseResources() {
  const { resources, loading: resourcesLoading } = useResources();
  const { courses, loading: coursesLoading } = useCourses();
  const [view, setView] = useState<View>({ level: "terms" });

  const platformDirectory = resources.filter((r) => r.resource_type === "Platform Directory");
  const general = resources.filter((r) => r.resource_type === "General");

  const termsWithCourses = useMemo(() => {
    const set = new Set(courses.map((c) => c.term));
    return Array.from(set);
  }, [courses]);

  const resourceCountByCourse = useMemo(() => {
    const map = new Map<string, number>();
    resources.forEach((r) => {
      if (r.course_id) map.set(r.course_id, (map.get(r.course_id) ?? 0) + 1);
    });
    return map;
  }, [resources]);

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
          Outlines, professor profiles, notes, and past papers — organized by term and course.
        </p>
      </header>

      <main className="px-6 md:px-12 space-y-10" style={{ maxWidth: 900 }}>
        {platformDirectory.length > 0 && (
          <Section title="Platform Directory">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
              {platformDirectory.map((r) => <LinkCard key={r.id} resource={r} />)}
            </div>
          </Section>
        )}

        {general.length > 0 && (
          <Section title="General">
            <div className="space-y-2">
              {general.map((r) => <ResourceRow key={r.id} resource={r} />)}
            </div>
          </Section>
        )}

        <Section title="Browse by term">
          {view.level !== "terms" && <Breadcrumbs view={view} onNavigate={setView} courses={courses} />}

          {view.level === "terms" && (
            <div className="flex flex-wrap gap-2">
              {termsWithCourses.length === 0 && (
                <p style={{ fontSize: 13, color: COLOR.ink3, fontFamily: FONT.sans }}>No courses loaded yet.</p>
              )}
              {termsWithCourses.map((t) => (
                <button key={t} onClick={() => setView({ level: "courses", term: t })} style={termPillStyle}>
                  {t}
                </button>
              ))}
            </div>
          )}

          {view.level === "courses" && (
            <div className="space-y-2">
              {courses.filter((c) => c.term === view.term).map((c) => (
                <button
                  key={c.id}
                  onClick={() => setView({ level: "course", term: view.term, courseId: c.id })}
                  className="flex items-center justify-between w-full"
                  style={{ padding: "12px 16px", borderRadius: 10, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, textAlign: "left", cursor: "pointer" }}
                >
                  <div>
                    <p style={{ fontSize: 13.5, fontWeight: 600, fontFamily: FONT.sans, color: COLOR.ink }}>{c.name}</p>
                    <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans }}>{c.code} · {c.professor}</p>
                  </div>
                  <div className="flex items-center gap-2" style={{ flexShrink: 0 }}>
                    <span style={{ fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans }}>
                      {resourceCountByCourse.get(c.id) ?? 0} resource{(resourceCountByCourse.get(c.id) ?? 0) === 1 ? "" : "s"}
                    </span>
                    <ChevronRight size={16} color={COLOR.ink3} />
                  </div>
                </button>
              ))}
            </div>
          )}

          {view.level === "course" && (
            <CourseDetail courseId={view.courseId} resources={resources.filter((r) => r.course_id === view.courseId)} courses={courses} />
          )}
        </Section>
      </main>
    </div>
  );
}

function Breadcrumbs({ view, onNavigate, courses }: { view: Exclude<View, { level: "terms" }>; onNavigate: (v: View) => void; courses: import("../types").Course[] }) {
  const course = view.level === "course" ? courses.find((c) => c.id === view.courseId) : null;
  return (
    <div className="flex items-center flex-wrap gap-1 mb-4" style={{ fontFamily: FONT.sans, fontSize: 12.5 }}>
      <button onClick={() => onNavigate({ level: "terms" })} style={crumbStyle}>Course Resources</button>
      <ChevronRight size={13} color={COLOR.ink3} />
      <button onClick={() => onNavigate({ level: "courses", term: view.term })} style={view.level === "courses" ? { ...crumbStyle, color: COLOR.ink, fontWeight: 700 } : crumbStyle}>
        {view.term}
      </button>
      {view.level === "course" && (
        <>
          <ChevronRight size={13} color={COLOR.ink3} />
          <span style={{ color: COLOR.ink, fontWeight: 700 }}>{course?.name ?? "Course"}</span>
        </>
      )}
    </div>
  );
}

function CourseDetail({ resources }: { courseId: string; resources: Resource[]; courses: import("../types").Course[] }) {
  if (resources.length === 0) {
    return (
      <div style={{ padding: "24px 16px", textAlign: "center", background: COLOR.surface, borderRadius: 10, border: `1px dashed ${COLOR.border}` }}>
        <FileText size={22} color={COLOR.ink3} style={{ margin: "0 auto 8px" }} />
        <p style={{ fontSize: 13, fontWeight: 600, color: COLOR.ink2, fontFamily: FONT.sans }}>No resources yet for this course</p>
        <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>Check back later, or add one from the Admin panel.</p>
      </div>
    );
  }

  const byType = new Map<string, Resource[]>();
  resources.forEach((r) => {
    const list = byType.get(r.resource_type) ?? [];
    list.push(r);
    byType.set(r.resource_type, list);
  });

  return (
    <div className="space-y-5">
      {Array.from(byType.entries()).map(([type, items]) => (
        <div key={type}>
          <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 8 }}>{type}</p>
          <div className="space-y-2">
            {items.map((r) => <ResourceRow key={r.id} resource={r} />)}
          </div>
        </div>
      ))}
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

const termPillStyle: React.CSSProperties = {
  padding: "9px 16px", borderRadius: 9, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer",
  border: `1px solid ${COLOR.border}`, background: COLOR.surface, color: COLOR.ink2,
};

const crumbStyle: React.CSSProperties = {
  background: "none", border: "none", cursor: "pointer", padding: 0, color: COLOR.ink3, fontFamily: FONT.sans, fontSize: 12.5,
};
