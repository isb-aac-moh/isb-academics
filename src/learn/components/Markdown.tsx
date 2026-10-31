import { Fragment, Suspense, memo, type ReactNode } from "react";
import { Bone } from "../../components/Skeleton";
import { Math } from "./Math";
import { parseVizProps, VIZ } from "./viz";

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

/**
 * Splits on `**bold**` and `$inline math$`, in one pass so the two can sit side by side.
 *
 * The math delimiters deliberately require a non-space immediately inside each `$`. Content is full
 * of prices — "acquisition cost $400, contribution $250 a year" — and a naive `\$[^$]+\$` swallows
 * the span between two unrelated currency symbols and renders it as an equation. Demanding
 * `$\mu = 21.38$` (tight) while rejecting `$400, contribution $` (space before the closing `$`)
 * separates the two cases without asking authors to escape every price. A span may not contain
 * `**` either, which is what stops `$400 = **$` pairing across "…= $400 = **$850**" — but single
 * `*` stays legal so `$Q^* = \mu + z\sigma$` still works.
 *
 * Authoring rule that falls out of this: never put a currency symbol inside *inline* math, since a
 * literal `$` cannot appear between the delimiters. Use display math (`$$ ... $$`, which does allow
 * `\$`) for any expression that needs one.
 */
const INLINE = /(\*\*[^*]+\*\*|\*[^*\n]+\*|\$(?!\s)(?:(?!\*\*)[^$\n])*?[^\s$]\$)/g;

function renderInline(text: string, keyPrefix: string): ReactNode {
  const parts = text.split(INLINE);
  return parts.map((part, i) => {
    const key = `${keyPrefix}-${i}`;
    // Bold is tested before italic so `**x**` is never read as an empty italic either side of `x`.
    if (part.startsWith("**") && part.endsWith("**")) {
      return <strong key={key}>{part.slice(2, -2)}</strong>;
    }
    if (part.length > 2 && part.startsWith("*") && part.endsWith("*")) {
      return <em key={key}>{part.slice(1, -1)}</em>;
    }
    if (part.length > 2 && part.startsWith("$") && part.endsWith("$")) {
      return <Math key={key} tex={part.slice(1, -1)} />;
    }
    return <Fragment key={key}>{part}</Fragment>;
  });
}

/** Each callout carries its label as a chip rather than inline prose, so a reader skimming for
    "what's the trap here" can find it without reading the sentence first. */
const CALLOUTS = [
  {
    match: /^trap:?\s*/i,
    label: "Trap",
    border: "border-bad/35",
    bg: "bg-bad-soft",
    chip: "bg-bad/12 text-bad",
  },
  {
    match: /^worked example:?\s*/i,
    label: "Worked example",
    border: "border-accent/30",
    bg: "bg-accent/[0.06]",
    chip: "bg-accent/12 text-accent",
  },
  {
    match: /^prof(?:essor)?(?:'s framing)?:?\s*/i,
    label: "In class",
    border: "border-good/30",
    bg: "bg-good-soft",
    chip: "bg-good/12 text-good",
  },
] as const;

function calloutStyle(text: string) {
  for (const c of CALLOUTS) {
    if (c.match.test(text)) {
      return { ...c, body: text.replace(c.match, "") };
    }
  }
  return {
    label: null,
    border: "border-line",
    bg: "bg-surface-2",
    chip: "",
    body: text,
  };
}

interface ListItem {
  text: string;
  children: string[];
}

/** Consumes a run of marker lines (and one level of indented "  - " children) starting at
    `start`, returns the parsed items and the index of the first line after the list. `marker`
    matches the bullet itself, e.g. `/^-\s+(.*)$/` for "- " or `/^\d+\.\s+(.*)$/` for "1. ". */
function parseList(lines: string[], start: number, marker: RegExp): [ListItem[], number] {
  const items: ListItem[] = [];
  let i = start;
  while (i < lines.length) {
    const m = lines[i].match(marker);
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

function renderList(items: ListItem[], keyPrefix: string, ordered: boolean): ReactNode {
  const Tag = ordered ? "ol" : "ul";
  return (
    <Tag className={`${ordered ? "list-decimal" : "list-disc"} pl-5 space-y-2 marker:text-accent/50 leading-[1.65]`}>
      {items.map((item, i) => (
        <li key={`${keyPrefix}-${i}`} className="pl-1">
          {renderInline(item.text, `${keyPrefix}-${i}`)}
          {item.children.length > 0 && (
            <ul className="list-[circle] pl-5 mt-2 space-y-1.5 marker:text-ink-soft/50">
              {item.children.map((child, j) => (
                <li key={`${keyPrefix}-${i}-${j}`}>{renderInline(child, `${keyPrefix}-${i}-${j}`)}</li>
              ))}
            </ul>
          )}
        </li>
      ))}
    </Tag>
  );
}

/** Consumes a run of "| a | b |" lines, dropping the "|---|---|" separator row. */
function parseTable(lines: string[], start: number): [string[][], number] {
  const rows: string[][] = [];
  let i = start;
  while (i < lines.length && lines[i].trim().startsWith("|")) {
    const cells = lines[i]
      .trim()
      .replace(/^\||\|$/g, "")
      .split("|")
      .map((c) => c.trim());
    if (!cells.every((c) => /^:?-{2,}:?$/.test(c))) rows.push(cells);
    i++;
  }
  return [rows, i];
}

function renderTable(rows: string[][], keyPrefix: string): ReactNode {
  const [header, ...body] = rows;
  return (
    <div className="overflow-x-auto mb-4 -mx-1 px-1">
      <table className="w-full text-sm border-collapse">
        <thead>
          <tr>
            {header.map((cell, i) => (
              <th key={`${keyPrefix}-h-${i}`}
                className="text-left font-semibold text-ink border-b-2 border-line py-2 pr-4 last:pr-0 align-bottom">
                {renderInline(cell, `${keyPrefix}-h-${i}`)}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {body.map((row, i) => (
            <tr key={`${keyPrefix}-r-${i}`}>
              {row.map((cell, j) => (
                <td key={`${keyPrefix}-r-${i}-${j}`}
                  className="border-b border-line py-2 pr-4 last:pr-0 text-ink-soft align-top">
                  {renderInline(cell, `${keyPrefix}-r-${i}-${j}`)}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

interface Props {
  text: string;
  className?: string;
}

/** Renders the small Markdown subset session summaries / concept notes are authored in: `## `/
    `### ` headers (also what `extractHeadings` reads for the "Jump to" rail), bullet lists and
    `1. ` numbered lists (each with one level of nested `  - ` children), `**bold**`,
    blank-line-separated paragraphs, and `> Label: ...`
    blockquotes rendered as colored callout boxes (Trap / Worked example / Prof, falling back to
    a neutral quote for an unlabeled `>`), pipe tables, and `:::viz <name> key=value` directives
    that embed an interactive widget from `./viz`. Deliberately not a general Markdown parser — no
    links or code fences, since none of the content uses them. Plain prose with no
    markup at all (the shape most concept notes are in today) still renders as a single
    paragraph, so this is a drop-in replacement everywhere raw text was rendered before.

    Memoised because the parse runs inline on every render and both props are strings. A question
    card re-renders on each answer click, which re-parsed the prompt — and re-mounted any widget
    embedded in it — every time. */
export const Markdown = memo(function Markdown({ text, className }: Props) {
  const lines = text.split("\n");
  const blocks: ReactNode[] = [];
  let paragraphBuf: string[] = [];

  function flushParagraph(key: string) {
    if (paragraphBuf.length === 0) return;
    const joined = paragraphBuf.join(" ");
    blocks.push(
      <p key={key} className="mb-4 last:mb-0 leading-[1.7]">
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
      // Sizes are em-relative so one component serves both the full reading surface and the
      // compact contexts (remediation refresher, formula drawer) that wrap it in text-sm.
      blocks.push(
        level === 2 ? (
          <h2
            key={`h-${i}`}
            id={id}
            className="text-[1.35em] font-bold text-ink tracking-[-0.02em] leading-[1.25]
              mt-10 mb-3 first:mt-0 pt-5 first:pt-0 border-t border-line first:border-0 scroll-mt-24"
          >
            {headingText}
          </h2>
        ) : (
          <h3
            key={`h-${i}`}
            id={id}
            className="text-[1.05em] font-semibold text-ink tracking-[-0.01em] mt-7 mb-2 scroll-mt-24"
          >
            {headingText}
          </h3>
        ),
      );
      i++;
      continue;
    }

    if (/^-\s+/.test(trimmed)) {
      flushParagraph(`p-${i}`);
      const [items, next] = parseList(lines.slice(i).map((l) => l.trimEnd()), 0, /^-\s+(.*)$/);
      blocks.push(
        <div key={`l-${i}`} className="mb-4">
          {renderList(items, `l-${i}`, false)}
        </div>,
      );
      i += next;
      continue;
    }

    if (/^\d+\.\s+/.test(trimmed)) {
      flushParagraph(`p-${i}`);
      const [items, next] = parseList(lines.slice(i).map((l) => l.trimEnd()), 0, /^\d+\.\s+(.*)$/);
      blocks.push(
        <div key={`l-${i}`} className="mb-4">
          {renderList(items, `l-${i}`, true)}
        </div>,
      );
      i += next;
      continue;
    }

    // `:::viz capability mean=21.4 sd=7.7 usl=30` — embeds an interactive widget mid-note. An
    // unknown name renders nothing rather than breaking the surrounding note.
    const viz = trimmed.match(/^:::viz\s+([\w-]+)\s*(.*)$/);
    if (viz) {
      flushParagraph(`p-${i}`);
      const Component = VIZ[viz[1]];
      if (Component) {
        // Widgets are lazy (see ./viz). The note around one must not be held back while its chunk
        // loads, so each gets its own boundary and reserves roughly its own height meanwhile —
        // filling in without shoving the rest of the note down the page.
        blocks.push(
          <Suspense key={`v-${i}`} fallback={<Bone h={220} r={12} />}>
            <Component {...parseVizProps(viz[2])} />
          </Suspense>,
        );
      }
      i++;
      continue;
    }
    if (trimmed === ":::") {
      i++;
      continue;
    }

    // `$$ ... $$` on its own line — a centred display equation. It must start the line: a callout
    // renders as a single <p>, so a block equation cannot live inside one (`> $$...$$` would be
    // invalid HTML as well as unreachable here). Put the equation on its own line after the callout.
    if (trimmed.startsWith("$$")) {
      flushParagraph(`p-${i}`);
      const single = trimmed.match(/^\$\$(.+)\$\$$/);
      if (single) {
        blocks.push(<Math key={`m-${i}`} tex={single[1].trim()} display />);
        i++;
      } else {
        const texLines: string[] = [trimmed.replace(/^\$\$/, "")];
        i++;
        while (i < lines.length && !lines[i].trim().endsWith("$$")) {
          texLines.push(lines[i]);
          i++;
        }
        if (i < lines.length) {
          texLines.push(lines[i].trim().replace(/\$\$$/, ""));
          i++;
        }
        blocks.push(<Math key={`m-${i}`} tex={texLines.join("\n").trim()} display />);
      }
      continue;
    }

    if (trimmed.startsWith("|")) {
      flushParagraph(`p-${i}`);
      const [rows, next] = parseTable(lines, i);
      if (rows.length > 0) blocks.push(<Fragment key={`t-${i}`}>{renderTable(rows, `t-${i}`)}</Fragment>);
      i = next;
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
        <aside
          key={`q-${i}`}
          className={`border-l-[3px] rounded-r-xl pl-4 pr-4 py-3.5 my-5 ${style.border} ${style.bg}`}
        >
          {style.label && (
            <span
              className={`inline-block text-[10px] font-bold uppercase tracking-[0.08em] rounded px-1.5 py-0.5 mb-1.5 ${style.chip}`}
            >
              {style.label}
            </span>
          )}
          <p className="text-[0.9375rem] leading-[1.65] text-ink">
            {renderInline(style.body, `q-${i}`)}
          </p>
        </aside>,
      );
      continue;
    }

    paragraphBuf.push(trimmed);
    i++;
  }
  flushParagraph("p-end");

  return <div className={className}>{blocks}</div>;
});
