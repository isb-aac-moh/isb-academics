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
  MADM2: {
    course: "MADM2",
    title: "MADM End-Term Revision Guide",
    subtitle:
      "Five field manuals covering Prof. Dutta's half of the course, from activity-based costing through to transfer pricing across borders.",
    sessions: [
      {
        slug: "6",
        label: "Session 6",
        title: "Activity-Based Costing",
        blurb:
          "Why a firm's own cost system misleads it about which products make money — traditional volume-based allocation, the four-level cost hierarchy, cross-subsidy, and when ABC is worth building.",
        file: "/madm-revision/session-06.html",
      },
      {
        slug: "7",
        label: "Session 7",
        title: "Customers, Control and Budgets",
        blurb:
          "ABC pointed at customers rather than products, then the structure that decides who is measured on what: decentralisation, responsibility centres, and the budget as forecast, contract and target at once.",
        file: "/madm-revision/session-07.html",
      },
      {
        slug: "8",
        label: "Session 8",
        title: "Variance Analysis",
        blurb:
          "Separating what the sales team owns from what the plant owns. The flexible budget, the decomposition tree, price versus quantity, and the Buckeye National Bank case.",
        file: "/madm-revision/session-08.html",
      },
      {
        slug: "9",
        label: "Session 9",
        title: "Transfer Pricing I",
        blurb:
          "How an investment centre is scored — ROI, residual income and EVA — and the rule that sets an internal price: incremental cost plus opportunity cost, against the buyer's external alternative.",
        file: "/madm-revision/session-09.html",
      },
      {
        slug: "10",
        label: "Session 10",
        title: "Transfer Pricing II",
        blurb:
          "Which policy to set, what a mandated full-cost formula costs, how negotiations turn into holdup, and how the whole apparatus becomes a tax question once divisions sit in different countries.",
        file: "/madm-revision/session-10.html",
      },
    ],
  },
  SUET: {
    course: "SUET",
    title: "SUET End-Term Exam Tutor",
    subtitle:
      "Sessions 4 to 10 plus the Ant Forest and Coca-Cola cases, taught topic by topic with teaching tapes, flashcards, a question bank, case frameworks and a 90-minute mock exam.",
    sessions: [
      {
        slug: "end-term",
        label: "Exam Tutor",
        title: "Strategy, Supply Chains, Climate Finance, ESG and Ethics",
        blurb:
          "The whole end-term in one interactive tutor: business models and Ant Forest (S4), the plastics recycling chain (S5), climate finance and the greenium (S6), ESG measurement and disclosure (S7), the commons, stakeholders and Coca-Cola Kaladera (S9) and ethical breakdowns (S10).",
        file: "/suet-revision/end-term-exam-tutor.html",
      },
    ],
  },
};

export function getRevisionGuide(course: string | undefined): RevisionGuide | null {
  if (!course) return null;
  return REVISION_GUIDES[course.toUpperCase()] ?? null;
}
