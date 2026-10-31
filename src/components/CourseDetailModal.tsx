import { useId, useState } from "react";
import { usePostHog } from "@posthog/react";
import { X, ExternalLink, FileText, Maximize2, Minimize2, Pin } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useModalA11y } from "../hooks/useModalA11y";
import { buildPopulatedTabs } from "../lib/options";
import { FacultySection } from "./FacultySection";
import type { CourseFacultyEntry } from "../hooks/useFaculty";
import type { Course, Resource } from "../types";

// The course profile side panel, shared by Course Resources and the Bidding Planner.
export function CourseDetailModal({
  course, resources, facultyByCourse, fullScreen, onToggleFullScreen, onClose,
}: { course: Course; resources: Resource[]; facultyByCourse: Map<string, CourseFacultyEntry[]>; fullScreen: boolean; onToggleFullScreen: () => void; onClose: () => void }) {
  const faculty = facultyByCourse.get(course.id) ?? [];
  // Only show a tab if this course actually has a resource in it — never an empty tab.
  const populatedTabs = buildPopulatedTabs(resources);

  const [activeTabKey, setActiveTabKey] = useState(populatedTabs[0]?.key);
  const activeTab = populatedTabs.find((t) => t.key === activeTabKey) ?? populatedTabs[0];
  const panelRef = useModalA11y<HTMLDivElement>(onClose);
  const titleId = useId();

  return (
    <div style={{ position: "fixed", inset: 0, zIndex: 60 }}>
      {!fullScreen && <div aria-hidden="true" onClick={onClose} style={{ position: "absolute", inset: 0, background: "rgba(0,0,0,0.4)" }} />}
      <div
        ref={panelRef}
        role="dialog"
        aria-modal="true"
        aria-labelledby={titleId}
        tabIndex={-1}
        className="flex flex-col"
        style={fullScreen
          ? { position: "absolute", inset: 0, background: COLOR.bg }
          : { position: "absolute", top: 0, right: 0, bottom: 0, width: "min(480px, 100%)", background: COLOR.bg, boxShadow: "-8px 0 32px rgba(0,0,0,0.12)" }
        }
      >
        <div className="flex items-start justify-between" style={{ padding: "20px 22px", borderBottom: `1px solid ${COLOR.borderLight}`, flexShrink: 0 }}>
          <div style={{ maxWidth: fullScreen ? 700 : undefined, margin: fullScreen ? "0 auto" : undefined, width: fullScreen ? "100%" : undefined }}>
            {course.is_core && <span style={{ fontSize: 10, fontWeight: 700, padding: "2px 8px", borderRadius: 6, background: COLOR.navyHero, color: "#fff", fontFamily: FONT.sans, textTransform: "uppercase" }}>Core</span>}
            <h2 id={titleId} style={{ fontFamily: FONT.serif, fontSize: fullScreen ? 26 : 19, fontWeight: 600, color: COLOR.ink, marginTop: 6 }}>{course.name}</h2>
            <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>{course.code} · {course.professor} · {course.term}</p>
          </div>
          <div className="flex items-center gap-3" style={{ flexShrink: 0 }}>
            <button onClick={onToggleFullScreen} aria-label={fullScreen ? "Exit full screen" : "Open full screen"} style={{ background: "none", border: "none", cursor: "pointer" }}>
              {fullScreen ? <Minimize2 size={18} color={COLOR.ink2} /> : <Maximize2 size={18} color={COLOR.ink2} />}
            </button>
            <button onClick={onClose} aria-label="Close" style={{ background: "none", border: "none", cursor: "pointer" }}><X size={20} color={COLOR.ink2} /></button>
          </div>
        </div>

        {populatedTabs.length > 0 && (
          <div className="flex gap-1 flex-wrap" style={{ padding: "12px 22px 0", flexShrink: 0, maxWidth: fullScreen ? 700 : undefined, margin: fullScreen ? "0 auto" : undefined, width: fullScreen ? "100%" : undefined }}>
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
          <div style={{ maxWidth: fullScreen ? 700 : undefined, margin: fullScreen ? "0 auto" : undefined }}>
            <FacultySection course={course} entries={faculty} />
            {resources.length === 0 ? (
              <div style={{ padding: "24px 16px", textAlign: "center", background: COLOR.surface, borderRadius: 10, border: `1px dashed ${COLOR.border}` }}>
                <FileText size={22} color={COLOR.ink3} style={{ margin: "0 auto 8px" }} />
                <p style={{ fontSize: 13, fontWeight: 600, color: COLOR.ink2, fontFamily: FONT.sans }}>No resources yet for this course</p>
                <p style={{ fontSize: 12, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>Check back later, or add one from the Admin panel.</p>
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

export function ResourceRow({ resource }: { resource: Resource }) {
  const posthog = usePostHog();
  return (
    <a
      href={resource.url}
      target="_blank"
      rel="noreferrer"
      onClick={() => posthog?.capture("resource_opened", { resource_type: resource.resource_type, pinned: resource.pinned })}
      className="flex items-start justify-between"
      style={{ padding: "11px 14px", borderRadius: 9, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, textDecoration: "none", gap: 8 }}
    >
      <div style={{ minWidth: 0 }}>
        <span style={{ fontSize: 13.5, fontWeight: 600, fontFamily: FONT.sans, color: COLOR.ink, display: "flex", alignItems: "center", gap: 5 }}>
          {resource.pinned && <Pin size={11} color={COLOR.navyHero} fill={COLOR.navyHero} />} {resource.title}
        </span>
        {resource.description && (
          <span style={{ fontSize: 12, fontFamily: FONT.sans, color: COLOR.ink3, display: "block", marginTop: 2, lineHeight: 1.4 }}>{resource.description}</span>
        )}
      </div>
      <ExternalLink size={14} color={COLOR.ink3} style={{ flexShrink: 0, marginTop: 2 }} />
    </a>
  );
}
