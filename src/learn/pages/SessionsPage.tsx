import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import type { Concept, Course, CourseContent, Question, SessionContent, Student } from "../types";
import {
  fetchConcepts,
  fetchCourseContent,
  fetchCourses,
  fetchQuestions,
  fetchSessionContent,
  fetchMastery,
} from "../lib/db";
import { groupBySession, type SessionGroup } from "../lib/sessions";
import { MasteryBar } from "../components/MasteryBar";
import { Markdown, extractHeadings } from "../components/Markdown";
import { TableOfContents } from "../components/TableOfContents";
import { ChevronRightIcon, CheckIcon, SearchIcon } from "../components/icons";

interface Props {
  profile: Student;
}

function accentLastWord(title: string) {
  const words = title.split(" ");
  const last = words.pop();
  return (
    <>
      {words.length > 0 ? `${words.join(" ")} ` : ""}
      <span className="highlight">{last}</span>
    </>
  );
}

export function SessionsPage({ profile }: Props) {
  const navigate = useNavigate();
  const params = useParams<{ course: string; session?: string; topic?: string }>();
  const courseId = params.course!;
  const activeSession = params.session ? Number(params.session) : null;
  const activeTopic = params.topic ?? null;

  const [course, setCourse] = useState<Course | null>(null);
  const [groups, setGroups] = useState<SessionGroup[] | null>(null);
  const [concepts, setConcepts] = useState<Record<string, Concept>>({});
  const [questions, setQuestions] = useState<Question[]>([]);
  const [sessionContent, setSessionContent] = useState<Record<number, SessionContent>>({});
  const [courseContent, setCourseContent] = useState<CourseContent | null>(null);
  const [query, setQuery] = useState("");

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseId]);

  async function load() {
    setGroups(null);
    const [courses, qs, cs, mastery, sc, cc] = await Promise.all([
      fetchCourses(),
      fetchQuestions(courseId),
      fetchConcepts(courseId),
      fetchMastery(profile.id),
      fetchSessionContent(courseId),
      fetchCourseContent(courseId),
    ]);
    const thisCourse = courses.find((c) => c.id === courseId) ?? null;
    setCourse(thisCourse);
    setQuestions(qs);
    setConcepts(cs);
    setSessionContent(sc);
    setCourseContent(cc);
    setGroups(groupBySession(qs, cs, mastery, thisCourse?.total_sessions ?? 0, sc));
  }

  if (!groups || !course) {
    return <div className="flex items-center justify-center min-h-[60vh] text-ink-soft">Loading…</div>;
  }

  const currentGroup = groups.find((g) => g.session === activeSession) ?? null;
  const currentConcept = activeTopic ? concepts[activeTopic] : null;
  const currentTopicMeta = currentGroup?.topics.find((t) => t.topic === activeTopic) ?? null;
  const questionsForTopic = activeTopic ? questions.filter((q) => q.topic === activeTopic) : [];

  const q = query.trim().toLowerCase();
  const visibleGroups = q
    ? groups
        .map((g) => ({ ...g, topics: g.topics.filter((t) => t.title.toLowerCase().includes(q)) }))
        .filter((g) => g.title.toLowerCase().includes(q) || g.topics.length > 0)
    : groups;

  // On mobile there's no room for sidebar + content side by side without one hiding the other —
  // drill in instead: list only, then content only, with a back step per level.
  const showSidebarOnMobile = !activeSession;

  return (
    <div className="flex flex-col md:flex-row h-full">
      {/* Session/concept sub-nav */}
      <aside
        className={`${showSidebarOnMobile ? "block" : "hidden"} md:block md:w-64 shrink-0 border-b md:border-b-0 md:border-r border-line px-3 py-4 md:overflow-y-auto`}
      >
        <div className="flex items-center gap-2 bg-base border border-line rounded-lg px-2.5 py-2 mb-4">
          <SearchIcon className="w-3.5 h-3.5 text-ink-soft shrink-0" />
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search sessions..."
            className="bg-transparent text-xs outline-none placeholder:text-ink-soft w-full"
          />
        </div>

        <div className="flex flex-col gap-1">
          {visibleGroups.map((g) => {
            const isOpen = g.session === activeSession;
            return (
              <div key={g.session}>
                <button
                  onClick={() => navigate(`/learn/sessions/${courseId}/${g.session}`)}
                  className={[
                    "w-full text-left flex items-center justify-between gap-2 px-3 py-2.5 rounded-xl text-sm transition-colors",
                    isOpen ? "bg-surface-2 text-ink font-medium" : "text-ink-soft hover:bg-surface-2/60 hover:text-ink",
                  ].join(" ")}
                >
                  <span>
                    Session {g.session}
                    <span className="hidden sm:inline"> — {g.title}</span>
                  </span>
                  <ChevronRightIcon className={`shrink-0 transition-transform ${isOpen ? "rotate-90" : ""}`} />
                </button>
                {isOpen && (
                  <div className="ml-2 pl-3 border-l border-line flex flex-col gap-0.5 py-1">
                    {g.topics.length === 0 ? (
                      <p className="text-xs text-ink-soft px-3 py-2">No practice content here yet.</p>
                    ) : (
                      g.topics.map((t) => {
                        const isActive = t.topic === activeTopic;
                        return (
                          <button
                            key={t.topic}
                            onClick={() => navigate(`/learn/sessions/${courseId}/${g.session}/${t.topic}`)}
                            className={[
                              "flex items-center justify-between gap-2 text-left px-3 py-1.5 rounded-lg text-sm transition-colors",
                              isActive ? "bg-accent/10 text-accent font-medium" : "text-ink-soft hover:text-ink",
                            ].join(" ")}
                          >
                            <span>{t.title}</span>
                            {t.level === 4 ? (
                              <CheckIcon className="w-3.5 h-3.5 text-good shrink-0" />
                            ) : (
                              <span className="w-1.5 h-1.5 rounded-full bg-accent shrink-0" />
                            )}
                          </button>
                        );
                      })
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </aside>

      {/* Detail pane — fills whatever width the window gives it; only flowing paragraph text
          gets its own reading-width cap, everything else (headings, cards, CTAs) uses the space. */}
      <div className="flex-1 min-w-0 px-4 py-6 md:px-8 md:py-8 overflow-y-auto">
        {activeSession && (
          <button
            onClick={() =>
              navigate(activeTopic ? `/learn/sessions/${courseId}/${activeSession}` : `/learn/sessions/${courseId}`)
            }
            className="md:hidden flex items-center gap-1 text-sm text-ink-soft hover:text-ink transition-colors mb-4 -ml-1"
          >
            <ChevronRightIcon className="rotate-180" />
            {activeTopic ? `Session ${activeSession}` : "Sessions"}
          </button>
        )}
        {currentConcept && currentTopicMeta ? (
          <div className="rise-in">
            <div className="text-xs uppercase tracking-wide text-accent font-semibold mb-2">
              Session {activeSession} · {questionsForTopic.length} question
              {questionsForTopic.length === 1 ? "" : "s"}
            </div>
            <h2 className="text-2xl font-bold mb-4">{accentLastWord(currentConcept.title)}</h2>
            <Markdown text={currentConcept.note} className="text-ink-soft leading-relaxed mb-6 max-w-2xl" />

            {currentConcept.resource_url && (
              <a
                href={currentConcept.resource_url}
                target="_blank"
                rel="noreferrer"
                className="text-sm text-accent font-medium hover:underline block mb-4"
              >
                View slides / resource →
              </a>
            )}

            <div className="card p-4 mb-6 max-w-xs">
              <div className="text-xs text-ink-soft mb-2">Your mastery of this concept</div>
              <MasteryBar level={currentTopicMeta.level} />
            </div>

            <button
              onClick={() =>
                navigate(`/learn/practice?course=${courseId}&topic=${encodeURIComponent(currentTopicMeta.topic)}`)
              }
              className="btn btn-primary"
            >
              Start practicing
            </button>
          </div>
        ) : currentGroup ? (
          <div className="rise-in xl:flex xl:items-start xl:gap-10">
            <div className="min-w-0 flex-1">
              <div className="text-xs uppercase tracking-wide text-accent font-semibold mb-2">
                Session {currentGroup.session}
              </div>
              <h2 className="text-2xl font-bold mb-2">{currentGroup.title}</h2>
              {sessionContent[currentGroup.session]?.summary && (
                <Markdown
                  text={sessionContent[currentGroup.session]?.summary ?? ""}
                  className="text-ink-soft mb-4 max-w-2xl"
                />
              )}
              {sessionContent[currentGroup.session]?.resource_url && (
                <a
                  href={sessionContent[currentGroup.session]?.resource_url ?? undefined}
                  target="_blank"
                  rel="noreferrer"
                  className="text-sm text-accent font-medium hover:underline block mb-4"
                >
                  View session slides →
                </a>
              )}
              {currentGroup.topics.length === 0 ? (
                <p className="text-ink-soft max-w-2xl">No practice content for this session yet.</p>
              ) : (
                <>
                  <p className="text-ink-soft mb-6 max-w-2xl">
                    Everything this session covers — read through it, then practice.
                  </p>
                  <button
                    onClick={() => navigate(`/learn/practice?course=${courseId}&session=${currentGroup.session}`)}
                    className="btn btn-primary mb-8"
                  >
                    Practice this session
                  </button>
                  {(() => {
                    const weakest = [...currentGroup.topics]
                      .sort((a, b) => a.level - b.level)
                      .slice(0, 2)
                      .map((t) => t.topic);
                    if (weakest.length < 2) return null;
                    return (
                      <button
                        onClick={() =>
                          navigate(
                            `/learn/practice?course=${courseId}&topics=${weakest.map(encodeURIComponent).join(",")}`,
                          )
                        }
                        className="btn ml-3 mb-8"
                      >
                        Practice your 2 weakest
                      </button>
                    );
                  })()}
                  <div className="flex flex-col divide-y divide-line">
                    {currentGroup.topics.map((t) => {
                      const concept = concepts[t.topic];
                      if (!concept) return null;
                      return (
                        <div key={t.topic} className="py-6 first:pt-0">
                          <h3 className="text-lg font-bold mb-2">{accentLastWord(concept.title)}</h3>
                          <Markdown
                            text={concept.note}
                            className="text-ink-soft leading-relaxed mb-3 max-w-2xl"
                          />
                          <div className="flex items-center gap-5 flex-wrap">
                            <div className="w-full max-w-[220px]">
                              <MasteryBar level={t.level} />
                            </div>
                            <button
                              onClick={() =>
                                navigate(`/learn/practice?course=${courseId}&topic=${encodeURIComponent(t.topic)}`)
                              }
                              className="text-sm text-accent font-medium hover:underline shrink-0"
                            >
                              Practice this concept
                            </button>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </>
              )}
            </div>
            <TableOfContents headings={extractHeadings(sessionContent[currentGroup.session]?.summary ?? "")} />
          </div>
        ) : (
          <div className="rise-in">
            <h2 className="text-2xl font-bold mb-2">{course.name}</h2>
            {courseContent?.announcements && (
              <div className="bg-accent/10 border border-accent/20 rounded-lg px-4 py-3 mb-4 max-w-2xl">
                <div className="text-xs uppercase tracking-wide text-accent font-semibold mb-1">
                  Announcements
                </div>
                <p className="text-sm text-ink leading-relaxed whitespace-pre-line">
                  {courseContent.announcements}
                </p>
              </div>
            )}
            <Markdown
              text={courseContent?.outline || "Choose a session on the left to read what it covers, then practice it."}
              className="text-ink-soft leading-relaxed mb-4 max-w-2xl"
            />
            {(courseContent?.cheatsheet_url ||
              courseContent?.exam_samples_url ||
              courseContent?.feedback_form_url) && (
              <div className="flex flex-col gap-2">
                {courseContent.cheatsheet_url && (
                  <a
                    href={courseContent.cheatsheet_url}
                    target="_blank"
                    rel="noreferrer"
                    className="text-sm text-accent font-medium hover:underline"
                  >
                    View cheatsheet →
                  </a>
                )}
                {courseContent.exam_samples_url && (
                  <a
                    href={courseContent.exam_samples_url}
                    target="_blank"
                    rel="noreferrer"
                    className="text-sm text-accent font-medium hover:underline"
                  >
                    Past / sample exam questions →
                  </a>
                )}
                {courseContent.feedback_form_url && (
                  <a
                    href={courseContent.feedback_form_url}
                    target="_blank"
                    rel="noreferrer"
                    className="text-sm text-accent font-medium hover:underline"
                  >
                    Give feedback →
                  </a>
                )}
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
