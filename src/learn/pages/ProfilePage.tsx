import { useEffect, useState } from "react";
import { LearnSkeleton } from "../../components/Skeleton";
import type { Attempt, Concept, Question, Student } from "../types";
import { fetchAttempts, fetchConcepts, fetchQuestions, resetProgress } from "../lib/db";
import { ProfileSummary } from "../components/ProfileSummary";

interface Props {
  profile: Student;
  onSignOut: () => void;
}

export function ProfilePage({ profile, onSignOut }: Props) {
  const [data, setData] = useState<{
    attempts: Attempt[];
    questions: Question[];
    concepts: Record<string, Concept>;
  } | null>(null);
  const [confirmingReset, setConfirmingReset] = useState(false);
  const [resetting, setResetting] = useState(false);

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function load() {
    const [attempts, questions, concepts] = await Promise.all([
      fetchAttempts(profile.id),
      fetchQuestions(),
      fetchConcepts(),
    ]);
    setData({ attempts, questions, concepts });
  }

  async function handleReset() {
    setResetting(true);
    await resetProgress(profile.id);
    setConfirmingReset(false);
    setResetting(false);
    void load();
  }

  if (!data) {
    return <LearnSkeleton />;
  }

  return (
    <div className="px-4 md:px-8 py-10">
      <div className="max-w-md rise-in">
        <h1 className="text-xl font-bold mb-1">{profile.name.split(" ")[0]}'s progress</h1>
        <p className="text-sm text-ink-soft mb-6">{profile.email}</p>
        <ProfileSummary profile={profile} {...data} />

        <div className="border-t border-line mt-8 pt-6 flex flex-col gap-4">
          {!confirmingReset ? (
            <button onClick={() => setConfirmingReset(true)} className="text-xs text-ink-soft hover:text-ink transition-colors text-left">
              Reset progress and start from scratch
            </button>
          ) : (
            <div className="text-sm">
              <p className="text-ink-soft mb-3">
                This clears which topics you're weak on, so Smart Practice treats everything as new
                again. Your XP and streak stay as they are.
              </p>
              <div className="flex gap-2">
                <button onClick={handleReset} disabled={resetting} className="btn btn-danger py-1.5 px-3 text-xs">
                  {resetting ? "Resetting…" : "Yes, reset"}
                </button>
                <button onClick={() => setConfirmingReset(false)} className="btn btn-ghost py-1.5 px-3 text-xs">
                  Cancel
                </button>
              </div>
            </div>
          )}

          <button onClick={onSignOut} className="text-xs text-ink-soft hover:text-ink transition-colors text-left">
            Sign out
          </button>
        </div>
      </div>
    </div>
  );
}
