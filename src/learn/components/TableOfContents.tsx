import type { MarkdownHeading } from "./Markdown";

interface Props {
  headings: MarkdownHeading[];
}

/** Right-rail "Jump to" nav for a session guide — click-to-scroll only, no scroll-spy active
    state. Only shown once there's real width for a third column (see SessionsPage). */
export function TableOfContents({ headings }: Props) {
  if (headings.length === 0) return null;

  function jumpTo(id: string) {
    document.getElementById(id)?.scrollIntoView({ behavior: "smooth", block: "start" });
  }

  // self-stretch matters: the parent flex row is items-start, which would otherwise shrink this
  // rail to the height of its own links, leaving the sticky child no room to stay put.
  return (
    <nav className="hidden xl:block w-56 shrink-0 self-stretch">
      <div className="sticky top-8">
        <div className="text-xs uppercase tracking-wide text-ink-soft font-semibold mb-3">Jump to</div>
        <ul className="flex flex-col border-l border-line">
          {headings.map((h) => (
            <li key={h.id}>
              <button
                onClick={() => jumpTo(h.id)}
                className={`block w-full text-left text-sm text-ink-soft hover:text-accent transition-colors py-1.5 border-l-2 border-transparent hover:border-accent -ml-px ${
                  h.level === 3 ? "pl-6" : "pl-3"
                }`}
              >
                {h.text}
              </button>
            </li>
          ))}
        </ul>
      </div>
    </nav>
  );
}
