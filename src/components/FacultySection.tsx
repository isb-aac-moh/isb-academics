import { useState } from "react";
import { ExternalLink, PlayCircle, Star } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { headlineRating, type CourseFacultyEntry } from "../hooks/useFaculty";
import type { Course, FacultyRating } from "../types";

// Under this many responses a score reflects a handful of students, so it's
// flagged wherever it appears rather than hidden.
const FEW_RESPONSES = 5;

// ASA said workload and rating scores were making students drop courses during
// bidding, so the per-professor ratings table stays out of the course popups.
// Flip to true to bring it back.
const SHOW_ASA_RATINGS = false;

const fmt = (n: number | null) => (n === null ? "–" : n.toFixed(2));
const campusShort = (c: FacultyRating["campus"]) => (c === "Mohali" ? "MOH" : c === "Hyderabad" ? "HYD" : null);
const surname = (name: string) => name.trim().split(/\s+/).pop() ?? name;
const isFew = (r: FacultyRating) => r.respondents !== null && r.respondents < FEW_RESPONSES;
const offeringLabel = (r: FacultyRating) =>
  r.course_code ? [r.course_code, r.term_label, r.academic_year].filter(Boolean).join(" · ") : r.offering;

// One chip per professor, each a single real rating labelled with where and when
// it's from. Never averaged across offerings, campuses or scales.
export function RatingBadge({ entries, courseCode }: { entries: CourseFacultyEntry[]; courseCode: string }) {
  const chips = entries.flatMap((e) => {
    const h = headlineRating(e.ratings, courseCode);
    return h ? [{ e, ...h }] : [];
  });
  if (chips.length === 0) return null;
  const named = entries.length > 1;
  const shown = chips.slice(0, 2);
  return (
    <span className="inline-flex flex-wrap items-center gap-1">
      {shown.map(({ e, rating: r, sameCourse }) => {
        const where = sameCourse ? [campusShort(r.campus), r.academic_year?.slice(2)].filter(Boolean).join(" ") : "other course";
        return (
          <span
            key={e.faculty_id}
            title={`${e.faculty.name}: instructor rating ${fmt(r.instructor_rating)}/${r.scale} for ${r.offering}${r.respondents !== null ? ` (${r.respondents} responses)` : ""}`}
            style={{ display: "inline-flex", alignItems: "center", gap: 3, fontSize: 10.5, fontWeight: 700, padding: "2px 7px", borderRadius: 6, background: COLOR.amberTint, color: "#8B5E00", fontFamily: FONT.sans, whiteSpace: "nowrap" }}
          >
            <Star size={10} fill="#8B5E00" /> {named && `${surname(e.faculty.name)} `}{fmt(r.instructor_rating)}/{r.scale}
            <span style={{ fontWeight: 600, opacity: 0.8 }}>· {where}{isFew(r) && ` · n=${r.respondents}`}</span>
          </span>
        );
      })}
      {chips.length > shown.length && <span style={{ fontSize: 10.5, color: COLOR.ink3, fontFamily: FONT.sans }}>+{chips.length - shown.length}</span>}
    </span>
  );
}

export function FacultySection({ course, entries }: { course: Course; entries: CourseFacultyEntry[] }) {
  const hasMeta = course.academic_area || course.academic_associates.length > 0 || course.overview_video_url;
  if (entries.length === 0 && !hasMeta) return null;
  return (
    <div className="space-y-3" style={{ marginBottom: 20 }}>
      {course.overview_video_url && (
        <a href={course.overview_video_url} target="_blank" rel="noreferrer" className="flex items-center gap-2"
          style={{ padding: "10px 14px", borderRadius: 9, background: COLOR.navyHero, color: "#fff", textDecoration: "none", fontFamily: FONT.sans, fontSize: 13, fontWeight: 700 }}>
          <PlayCircle size={16} /> Watch the course overview video
        </a>
      )}
      {entries.map((e) => <FacultyCard key={e.faculty_id} entry={e} courseCode={course.code} />)}
      {(course.academic_area || course.academic_associates.length > 0) && (
        <p style={{ fontSize: 12, color: COLOR.ink2, fontFamily: FONT.sans, lineHeight: 1.5 }}>
          {course.academic_area && <>Academic area: <b>{course.academic_area}</b></>}
          {course.academic_area && course.academic_associates.length > 0 && " · "}
          {course.academic_associates.length > 0 && <>Academic associates: {course.academic_associates.join(", ")}</>}
        </p>
      )}
    </div>
  );
}

function FacultyCard({ entry, courseCode }: { entry: CourseFacultyEntry; courseCode: string }) {
  const { faculty: f, ratings } = entry;
  const [showAll, setShowAll] = useState(false);
  const [photoOk, setPhotoOk] = useState(Boolean(f.photo_url));
  const base = courseCode.replace(/\d+$/, "");
  const thisCourse = ratings.filter((r) => r.course_code?.replace(/\d+$/, "") === base);
  const shown = showAll ? ratings : thisCourse.length > 0 ? thisCourse : ratings.slice(0, 3);
  const scope = showAll ? "all offerings" : thisCourse.length > 0 ? "this course" : "other courses by this professor";
  const affiliation = entry.affiliation ?? f.affiliation;
  const links = [
    { label: "Profile", url: f.profile_url },
    { label: "Bio", url: f.bio_url },
    { label: "Ratings", url: f.ratings_url },
    { label: "Older ratings", url: f.ratings_legacy_url },
  ].filter((l) => l.url);
  const th = { fontWeight: 600, padding: "3px 4px", whiteSpace: "nowrap" as const };

  return (
    <div style={{ padding: "14px 16px", borderRadius: 11, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}` }}>
      <div className="flex items-start gap-3">
        {photoOk && f.photo_url ? (
          <img src={f.photo_url} alt="" onError={() => setPhotoOk(false)} style={{ width: 44, height: 44, borderRadius: "50%", objectFit: "cover", flexShrink: 0 }} />
        ) : (
          <div style={{ width: 44, height: 44, borderRadius: "50%", background: COLOR.navyTint, color: COLOR.navyHero, display: "flex", alignItems: "center", justifyContent: "center", fontFamily: FONT.sans, fontWeight: 700, fontSize: 14, flexShrink: 0 }}>
            {f.name.split(" ").filter(Boolean).slice(0, 2).map((w) => w[0]).join("")}
          </div>
        )}
        <div style={{ minWidth: 0, flex: 1 }}>
          <p style={{ fontSize: 14, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink }}>{f.name}</p>
          {(f.designation || affiliation) && (
            <p style={{ fontSize: 12, color: COLOR.ink2, fontFamily: FONT.sans, marginTop: 1, lineHeight: 1.4 }}>
              {[f.designation, affiliation].filter(Boolean).join(" · ")}
            </p>
          )}
          {(entry.sessions || f.faculty_type) && (
            <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 2 }}>{[entry.sessions, f.faculty_type].filter(Boolean).join(" · ")}</p>
          )}
          {links.length > 0 && (
            <div className="flex flex-wrap gap-3" style={{ marginTop: 6 }}>
              {links.map((l) => (
                <a key={l.label} href={l.url!} target="_blank" rel="noreferrer" style={{ fontSize: 12, fontWeight: 700, color: COLOR.navyHero, fontFamily: FONT.sans, display: "inline-flex", alignItems: "center", gap: 3 }}>
                  {l.label} <ExternalLink size={11} />
                </a>
              ))}
            </div>
          )}
        </div>
      </div>

      {!SHOW_ASA_RATINGS ? null : ratings.length > 0 ? (
        <div style={{ marginTop: 12 }}>
          <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: 0.4, marginBottom: 6 }}>
            ASA ratings · {scope}
          </p>
          <div style={{ overflowX: "auto" }}>
            <table style={{ width: "100%", borderCollapse: "collapse", fontFamily: FONT.sans, fontSize: 12 }}>
              <thead>
                <tr style={{ color: COLOR.ink3, textAlign: "left" }}>
                  <th style={{ ...th, paddingLeft: 0 }}>Offering</th>
                  <th style={th}>Campus</th>
                  <th style={th}>Instructor</th>
                  <th style={th}>Course</th>
                  <th style={th}>Difficulty</th>
                  <th style={th}>Workload</th>
                  <th style={th}>Responses</th>
                </tr>
              </thead>
              <tbody>{shown.map((r) => <RatingRow key={r.id} r={r} />)}</tbody>
            </table>
          </div>
          {ratings.length > shown.length && (
            <button onClick={() => setShowAll(true)} style={{ marginTop: 6, background: "none", border: "none", padding: 0, cursor: "pointer", fontSize: 12, fontWeight: 700, color: COLOR.navyHero, fontFamily: FONT.sans }}>
              Show all {ratings.length} offerings{thisCourse.length > 0 ? ", including other courses" : ""}
            </button>
          )}
          <p style={{ fontSize: 10.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 6, lineHeight: 1.5 }}>
            Each row is one offering as ASA published it. Nothing is averaged. Scores are out of the scale shown: 1-7 before AY 2025-26, 1-5 from 2025-26, so don't compare across the two.
            Difficulty and workload run from 1 (light) to 7 (heavy). Responses are students who rated out of students enrolled; ASA's 2025-26 pages don't publish them. "few" means under {FEW_RESPONSES} responses.
          </p>
        </div>
      ) : (
        <p style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans, marginTop: 10 }}>No ASA ratings since AY 2021-22.</p>
      )}
    </div>
  );
}

function RatingRow({ r }: { r: FacultyRating }) {
  const cell = { padding: "4px", borderTop: `1px solid ${COLOR.borderLight}`, whiteSpace: "nowrap" as const };
  const campus = campusShort(r.campus);
  return (
    <tr>
      <td title={r.offering} style={{ ...cell, paddingLeft: 0, whiteSpace: "normal", color: COLOR.ink2, minWidth: 110 }}>{offeringLabel(r)}</td>
      <td style={cell}>
        {campus ? (
          <span style={{ fontSize: 10.5, fontWeight: 700, padding: "1px 6px", borderRadius: 5, background: campus === "MOH" ? COLOR.navyTint : COLOR.bgSoft, color: campus === "MOH" ? COLOR.navyHero : COLOR.ink2 }}>{campus}</span>
        ) : (
          <span title="ASA's page doesn't say which campus" style={{ color: COLOR.ink3 }}>not stated</span>
        )}
      </td>
      <td style={{ ...cell, fontWeight: 700, color: COLOR.ink }}>{fmt(r.instructor_rating)}<span style={{ color: COLOR.ink3, fontWeight: 500 }}>/{r.scale}</span></td>
      <td style={cell}>{fmt(r.course_rating)}<span style={{ color: COLOR.ink3 }}>/{r.scale}</span></td>
      <td style={cell}>{fmt(r.difficulty)}</td>
      <td style={cell}>{fmt(r.workload)}</td>
      <td style={cell}>
        {r.respondents === null ? (
          <span style={{ color: COLOR.ink3 }}>–</span>
        ) : (
          <>
            {r.respondents}
            {r.enrollments !== null && <span style={{ color: COLOR.ink3 }}> / {r.enrollments}</span>}
            {isFew(r) && <span style={{ marginLeft: 4, fontSize: 10, fontWeight: 700, color: "#8B5E00" }}>few</span>}
          </>
        )}
      </td>
    </tr>
  );
}
