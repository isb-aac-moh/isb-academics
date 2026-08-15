"""Shared helpers for the practice-content generators.

The content generators (opmg-additional-set.py, mktg-expansion.py, opmg-expansion.py,
banm2-expansion.py) all emit SQL migrations from Python source. Authoring in Python rather than
hand-writing SQL buys four mechanical checks that a .sql file cannot give:

  1. SQL quoting                      -- sql()
  2. the Markdown subset the app renders -- check_markdown()
  3. the inline-math pitfall          -- check_inline_math()
  4. answer/choice integrity          -- check_question()

The validators are lifted from supabase/banm2-content.py, which stays the source of truth for the
BANM2 *end-term guide* content. That file predates this module and is deliberately left untouched.

Two rules specific to multiple-choice content:

- `correct_answer` must appear verbatim in `choices`, or the app can never mark the question right.
  check_question() enforces this.
- Choices are rendered in stored order (src/learn/components/QuestionCard.tsx) -- there is no
  shuffling at display time. Source material tends to put the right answer in the same slot (the
  professor's additional set is "B" 11 times out of 12), so shuffle_choices() spreads it
  deterministically, seeded on the question id so regenerating a migration is reproducible.
"""

import hashlib
import random
import re

# Mirrors the INLINE regex in src/learn/components/Markdown.tsx. Anything it matches inside prose
# gets rendered as KaTeX, so a stray price pair like "($5 ... ($30" would silently become an
# equation. Content is checked against it here rather than discovered in the browser.
INLINE = re.compile(r"(\*\*[^*]+\*\*|\*[^*\n]+\*|\$(?!\s)(?:(?!\*\*)[^$\n])*?[^\s$]\$)")


def check_inline_math(label: str, text: str, problems: list) -> None:
    in_display = False
    for n, line in enumerate(text.split("\n"), 1):
        stripped = line.strip()
        if stripped.startswith("$$"):
            # Single-line display math is self-contained; a bare opener toggles a block.
            if not re.match(r"^\$\$.+\$\$$", stripped):
                in_display = not in_display
            continue
        if in_display:
            continue
        for part in INLINE.split(stripped):
            if part.startswith("$") and part.endswith("$") and len(part) > 2:
                inner = part[1:-1]
                # Deliberate TeX has no bare English words in it. Strip the words that legitimately
                # appear -- \text{...} bodies and command names -- and anything lowercase left over
                # means the two `$` belong to two different prices, not to one equation.
                bare = re.sub(r"\\(?:text|mathrm|operatorname)\{[^}]*\}", "", inner)
                bare = re.sub(r"\\[a-zA-Z]+", "", bare)
                if re.search(r"[a-z]{3,}", bare):
                    problems.append(f"{label}: reads as inline math -> {part!r}")


def check_markdown(label: str, text: str, problems: list) -> None:
    for n, line in enumerate(text.split("\n"), 1):
        if re.match(r"^#{4,}\s", line):
            problems.append(f"{label} line {n}: heading deeper than ### is not rendered")
        if re.match(r"^\s*[*+]\s", line):
            problems.append(f"{label} line {n}: list must use '- ', not '*' or '+'")
        if "```" in line:
            problems.append(f"{label} line {n}: code fences are not rendered")
        if re.search(r"\[[^\]]+\]\([^)]+\)", line):
            problems.append(f"{label} line {n}: links are not rendered")


def shuffle_choices(qid: str, choices: list, correct: str) -> list:
    """Deterministic per-question shuffle, so the right answer is not always in the same slot.

    Seeded on the question id rather than a global counter: adding or reordering questions later
    must not churn the stored order of the ones already published.
    """
    seed = int(hashlib.sha256(qid.encode()).hexdigest()[:8], 16)
    out = list(choices)
    random.Random(seed).shuffle(out)
    # A shuffle that happens to leave the answer first every time would defeat the point for a
    # short list, but with 4 options the seeded permutation is uniform -- no correction needed.
    assert correct in out, f"{qid}: correct answer lost in shuffle"
    return out


def check_question(qid: str, q: dict, problems: list, seen_ids: set) -> None:
    """Integrity checks that a bad row would otherwise only reveal in front of a student."""
    if qid in seen_ids:
        problems.append(f"{qid}: duplicate question id")
    seen_ids.add(qid)

    qtype = q["type"]
    choices = q.get("choices") or []
    correct = q["correct_answer"]

    if qtype == "short_answer":
        if choices:
            problems.append(f"{qid}: short_answer must have no choices")
    else:
        if len(choices) < 2:
            problems.append(f"{qid}: {qtype} needs at least 2 choices, has {len(choices)}")
        if len(set(choices)) != len(choices):
            problems.append(f"{qid}: duplicate choice text")
        if correct not in choices:
            problems.append(f"{qid}: correct_answer is not one of the choices -> {correct!r}")

    if not q.get("explanation"):
        problems.append(f"{qid}: empty explanation")
    if q["difficulty"] not in (1, 2, 3):
        problems.append(f"{qid}: difficulty {q['difficulty']} outside 1-3")
    if q["provenance"] not in ("prof_verbatim", "prof_adapted", "authored"):
        problems.append(f"{qid}: bad provenance {q['provenance']!r}")


def sql(value) -> str:
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, int):
        return str(value)
    return "'" + value.replace("'", "''") + "'"


def json_array(values: list) -> str:
    """A jsonb string literal. Goes through sql() so quotes inside choices are escaped once."""
    import json

    return sql(json.dumps(values, ensure_ascii=False)) + "::jsonb"
