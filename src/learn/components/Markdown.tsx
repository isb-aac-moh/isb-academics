import { Fragment, type ReactNode } from "react";

export interface MarkdownHeading {
  id: string;
  text: string;
  level: 2 | 3;
}

function slugify(text: string): string {
  return text
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
}

/** Pulls ## / ### headings out of markdown text to build a "Jump to" nav, without a full parse. */
export function extractHeadings(text: string): MarkdownHeading[] {
  const headings: MarkdownHeading[] = [];
  for (const line of text.split("\n")) {
    const m = line.match(/^(#{2,3})\s+(.*)$/);
    if (m) {
      const level = m[1].length as 2 | 3;
      const headingText = m[2].trim();
      headings.push({ id: slugify(headingText), text: headingText, level });
    }
  }
  return headings;
}

function renderInline(text: string, keyPrefix: string): ReactNode {
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  return parts.map((part, i) =>
    part.startsWith("**") && part.endsWith("**") ? (
      <strong key={`${keyPrefix}-${i}`}>{part.slice(2, -2)}</strong>
    ) : (
      <Fragment key={`${keyPrefix}-${i}`}>{part}</Fragment>
    ),
  );
}

const CALLOUTS = [
  { match: /^trap:?\s*/i, border: "border-bad/40", bg: "bg-bad-soft", accent: "text-bad" },
  { match: /^worked example:?\s*/i, border: "border-accent/30", bg: "bg-accent/5", accent: "text-accent" },
  { match: /^prof(?:essor)?(?:'s framing)?:?\s*/i, border: "border-good/30", bg: "bg-good-soft", accent: "text-good" },
] as const;

function calloutStyle(text: string) {
  for (const c of CALLOUTS) {
    if (c.match.test(text)) return c;
  }
  return { border: "border-line", bg: "bg-surface-2", accent: "text-ink-soft" };
}

interface ListItem {
  text: string;
  children: string[];
}

/** Consumes a run of "- " (and one level of indented "  - ") lines starting at `start`, returns
    the parsed items and the index of the first line after the list. */
function parseList(lines: string[], start: number): [ListItem[], number] {
  const items: ListItem[] = [];
  let i = start;
  while (i < lines.length) {
    const m = lines[i].match(/^-\s+(.*)$/);
    if (!m) break;
    const children: string[] = [];
    i++;
    while (i < lines.length) {
      const nm = lines[i].match(/^\s+-\s+(.*)$/);
      if (!nm) break;
      children.push(nm[1]);
      i++;
    }
    items.push({ text: m[1], children });
  }
  return [items, i];
}

function renderList(items: ListItem[], keyPrefix: string): ReactNode {
  return (
    <ul className="list-disc pl-5 space-y-1.5">
      {items.map((item, i) => (
        <li key={`${keyPrefix}-${i}`}>
          {renderInline(item.text, `${keyPrefix}-${i}`)}
          {item.children.length > 0 && (
            <ul className="list-[circle] pl-5 mt-1.5 space-y-1.5">
              {item.children.map((child, j) => (
                <li key={`${keyPrefix}-${i}-${j}`}>{renderInline(child, `${keyPrefix}-${i}-${j}`)}</li>
              ))}
            </ul>
          )}
        </li>
      ))}
    </ul>
  );
}

interface Props {
  text: string;
  className?: string;
}

/** Renders the small Markdown subset session summaries / concept notes are authored in: `## `/
    `### ` headers (also what `extractHeadings` reads for the "Jump to" rail), bullet lists with
    one level of nesting, `**bold**`, blank-line-separated paragraphs, and `> Label: ...`
    blockquotes rendered as colored callout boxes (Trap / Worked example / Prof, falling back to
    a neutral quote for an unlabeled `>`). Deliberately not a general Markdown parser — no
    tables, links, or code fences, since none of the content uses them. Plain prose with no
    markup at all (the shape most concept notes are in today) still renders as a single
    paragraph, so this is a drop-in replacement everywhere raw text was rendered before. */
export function Markdown({ text, className }: Props) {
  const lines = text.split("\n");
  const blocks: ReactNode[] = [];
  let paragraphBuf: string[] = [];

  function flushParagraph(key: string) {
    if (paragraphBuf.length === 0) return;
    const joined = paragraphBuf.join(" ");
    blocks.push(
      <p key={key} className="mb-4 last:mb-0">
        {renderInline(joined, key)}
      </p>,
    );
    paragraphBuf = [];
  }

  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    const trimmed = line.trim();

    if (trimmed === "") {
      flushParagraph(`p-${i}`);
      i++;
      continue;
    }

    const heading = trimmed.match(/^(#{2,3})\s+(.*)$/);
    if (heading) {
      flushParagraph(`p-${i}`);
      const level = heading[1].length;
      const headingText = heading[2].trim();
      const id = slugify(headingText);
      blocks.push(
        level === 2 ? (
          <h2 key={`h-${i}`} id={id} className="text-lg font-bold text-ink mt-8 mb-3 first:mt-0 scroll-mt-24">
            {headingText}
          </h2>
        ) : (
          <h3 key={`h-${i}`} id={id} className="text-base font-semibold text-ink mt-6 mb-2 scroll-mt-24">
            {headingText}
          </h3>
        ),
      );
      i++;
      continue;
    }

    if (/^-\s+/.test(trimmed)) {
      flushParagraph(`p-${i}`);
      const [items, next] = parseList(lines.slice(i).map((l) => l.trimEnd()), 0);
      blocks.push(
        <div key={`l-${i}`} className="mb-4">
          {renderList(items, `l-${i}`)}
        </div>,
      );
      i += next;
      continue;
    }

    const quote = trimmed.match(/^>\s*(.*)$/);
    if (quote) {
      flushParagraph(`p-${i}`);
      const quoteLines: string[] = [quote[1]];
      i++;
      while (i < lines.length && lines[i].trim().startsWith(">")) {
        quoteLines.push(lines[i].trim().replace(/^>\s*/, ""));
        i++;
      }
      const quoteText = quoteLines.join(" ");
      const style = calloutStyle(quoteText);
      blocks.push(
        <div
          key={`q-${i}`}
          className={`border-l-4 rounded-r-lg px-4 py-3 mb-4 text-sm ${style.border} ${style.bg}`}
        >
          <span className={style.accent}>{renderInline(quoteText, `q-${i}`)}</span>
        </div>,
      );
      continue;
    }

    paragraphBuf.push(trimmed);
    i++;
  }
  flushParagraph("p-end");

  return <div className={className}>{blocks}</div>;
}
