import { useEffect, useState } from "react";
import { TextSkeleton } from "../../components/Skeleton";
import { useNavigate } from "react-router-dom";
import type { Attempt, Concept, Course, Question, Student } from "../types";
import { fetchAttempts, fetchConcepts, fetchCourses, fetchQuestions } from "../lib/db";
import { useCountUp } from "../lib/useCountUp";
import { StreakFlame } from "../components/StreakFlame";
import { ProfileSummary } from "../components/ProfileSummary";

interface Props {
  profile: Student;
}

const STEPS = [
  {
    title: "Pick where to start",
    body: "Let Smart Practice mix in whatever you're weakest on, or browse by session if you'd rather review a specific topic first.",
  },
  {
    title: "Read, then answer",
    body: "Each new topic opens with a quick concept card before the question — a refresher, not a wall of notes.",
  },
  {
    title: "See it, right or wrong",
    body: "Every answer gets an explanation on the spot, plus XP and streak — so the loop stays quick enough to run daily.",
  },
];

/** The guide that opens by default when you land on the desktop — explains the loop once so the
    icons around it make sense, with a live progress summary alongside it so the window earns its
    width instead of leaving the right side empty. Closeable; reopens via the logo. */
export function HomeGuide({ profile }: Props) {
  const navigate = useNavigate();
  const displayedXp = useCountUp(profile.total_xp);
  const [data, setData] = useState<{
    attempts: Attempt[];
    questions: Question[];
    concepts: Record<string, Concept>;
  } | null>(null);
  const [courses, setCourses] = useState<Course[]>([]);

  useEffect(() => {
    void Promise.all([fetchAttempts(profile.id), fetchQuestions(), fetchConcepts()]).then(
      ([attempts, questions, concepts]) => setData({ attempts, questions, concepts }),
    );
    void fetchCourses().then(setCourses);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Read the live courses rather than naming one: Operations went live alongside Marketing, and
  // hardcoded copy saying otherwise is wrong the moment a course is enabled in admin.
  const liveCourses = courses.filter((c) => c.enabled);
  const liveNames =
    liveCourses.length === 0
      ? null
      : liveCourses.length === 1
        ? `${liveCourses[0].name} is live today`
        : `${liveCourses.slice(0, -1).map((c) => c.name).join(", ")} and ${liveCourses[liveCourses.length - 1].name} are live today`;

  return (
    <div className="px-6 py-8 md:px-10 md:py-10 flex flex-col lg:flex-row gap-10">
      <div className="flex-1 min-w-0">
        <div className="text-sm text-ink-soft mb-1">
          Hey {profile.name.split(" ")[0]} · {displayedXp} XP · {profile.day_streak}d streak{" "}
          <StreakFlame streak={profile.day_streak} />
        </div>
        <h1 className="text-3xl font-bold mb-4 leading-tight">
          Turn <span className="highlight">a few minutes</span> into exam-ready recall
        </h1>
        <p className="text-ink-soft leading-relaxed mb-8 max-w-lg">
          Short, adaptive practice rounds pulled straight from your course material. No long study
          sessions — just enough, often enough, that the answers stop feeling like guesses.
          {liveNames && ` ${liveNames}; more ISB courses are on the way.`}
        </p>

        <div className="flex flex-col sm:flex-row gap-3 mb-10 max-w-md">
          <button onClick={() => navigate("/learn/practice")} className="btn btn-primary flex-1 py-3">
            Start smart practice
          </button>
          {/* One live course goes straight there; more than one goes to the picker, otherwise every
              course after the first has no way in from this screen. */}
          {liveCourses.length > 0 && (
            <button
              onClick={() =>
                navigate(liveCourses.length === 1 ? `/learn/sessions/${liveCourses[0].id}` : "/learn/subjects")
              }
              className="btn btn-ghost border border-line flex-1 py-3"
            >
              {liveCourses.length === 1 ? `Browse ${liveCourses[0].name}` : "Browse courses"}
            </button>
          )}
        </div>

        <h2 className="text-xs uppercase tracking-wide text-ink-soft font-semibold mb-4">How it works</h2>
        <div className="flex flex-col gap-4">
          {STEPS.map((step, i) => (
            <div key={step.title} className="flex gap-3">
              <div className="shrink-0 w-6 h-6 rounded-full bg-accent/10 text-accent text-xs font-bold flex items-center justify-center mt-0.5">
                {i + 1}
              </div>
              <div>
                <div className="text-sm font-semibold mb-0.5">{step.title}</div>
                <p className="text-sm text-ink-soft leading-relaxed">{step.body}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="lg:w-80 xl:w-96 shrink-0">
        <h2 className="text-xs uppercase tracking-wide text-ink-soft font-semibold mb-4">Your progress</h2>
        {!data ? (
          <TextSkeleton lines={5} />
        ) : (
          <ProfileSummary profile={profile} {...data} />
        )}
      </div>
    </div>
  );
}
