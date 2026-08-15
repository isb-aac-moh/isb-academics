/**
 * End-term revision guides — standalone "field manual" HTML documents that live in public/ and are
 * shown in an iframe, the same way the app already embeds the Term 4 Dossier.
 *
 * They are deliberately not Learn content in the database. A guide is one finished, hand-designed
 * document per session with its own typography, colour scheme and in-page interactions; splitting it
 * into learn_session_content markdown would throw all of that away, and it is a frozen end-term
 * artefact rather than something the admin screens are expected to edit.
 *
 * `course` matches a learn course code, so a guide can be offered next to that course's sessions.
 * `slug` is what appears in the URL (/learn/revision/OPMG/6), and stays stable if the file is
 * renamed — sessions 7 and 8 were taught and revised as one block, hence the single "7-8" entry.
 */
export interface RevisionSession {
  slug: string;
  /** Shown on the card and the tab rail, e.g. "Session 6" or "Sessions 7–8". */
  label: string;
  title: string;
  blurb: string;
  file: string;
}

export interface RevisionGuide {
  course: string;
  title: string;
  subtitle: string;
  sessions: RevisionSession[];
}

export const REVISION_GUIDES: Record<string, RevisionGuide> = {
  OPMG: {
    course: "OPMG",
    title: "OPMG End-Term Revision Guide",
    subtitle:
      "Four field manuals covering everything the end-term examines, from lean operations through to inventory under uncertainty.",
    sessions: [
      {
        slug: "6",
        label: "Session 6",
        title: "Lean Operations",
        blurb:
          "The philosophy and the six tools lean uses to synchronise flow with demand at the lowest possible cost — batch size, pull/JIT, kanban, jidoka, flexible resources and cellular layout.",
        file: "/opmg-revision/session-06.html",
      },
      {
        slug: "7-8",
        label: "Sessions 7–8",
        title: "Process Improvement & Control",
        blurb:
          "Specs and the voice of the customer, process capability, hypothesis testing for real improvement, statistical process control, Type I/II error, and six-sigma robustness to drift.",
        file: "/opmg-revision/session-07-08.html",
      },
      {
        slug: "9",
        label: "Session 9",
        title: "Managing Inventory Under Uncertainty",
        blurb:
          "The newsvendor model for the one-shot ordering decision: Cu/Co, the critical ratio, how demand shape moves Q*, Hotel California and quick response.",
        file: "/opmg-revision/session-09.html",
      },
      {
        slug: "10",
        label: "Session 10",
        title: "Inventory Management",
        blurb:
          "EOQ derived from first principles, reorder points with and without uncertainty, and the two levers — aggregation and colocation — that let real supply chains hold less inventory.",
        file: "/opmg-revision/session-10.html",
      },
    ],
  },
};

export function getRevisionGuide(course: string | undefined): RevisionGuide | null {
  if (!course) return null;
  return REVISION_GUIDES[course.toUpperCase()] ?? null;
}
