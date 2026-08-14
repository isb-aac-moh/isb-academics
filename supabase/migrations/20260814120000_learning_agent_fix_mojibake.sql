-- Repair mojibake in the learning content loaded via the Supabase SQL editor.
--
-- The three bulk load files were read as MacRoman rather than UTF-8 somewhere between disk
-- and the editor, so every multi-byte UTF-8 character arrived as one character per byte:
--
--   ₹  (U+20B9, bytes E2 82 B9)  ->  ‚Çπ
--   —  (U+2014, bytes E2 80 94)  ->  ‚Äî
--
-- 15 distinct characters were affected across 970 occurrences — the maths and currency
-- symbols an Operations and Marketing course is naturally full of (σ μ ρ ε × ÷ √ ± ≈ − → ₹ — – ·).
-- Nothing was lost, so this is fully reversible by inverting the byte-to-character mapping.
--
-- Order matters: the two-byte sequences are undone before the three-byte ones, so a repaired
-- character can never be re-matched by a later rule (notably '√', which is both a repair
-- output and the first character of the '×' and '÷' patterns). Idempotent — repaired text
-- contains none of these patterns.
--
-- Verified by md5 against supabase/mktg-rep-dump/data/*.json after applying: questions,
-- concepts and session_content all match the snapshot exactly, and choices (jsonb) is clean.
--
-- If this content is ever reloaded, check the encoding first. `file -I <file>` should say
-- charset=utf-8, and the paste target must not re-interpret it.

create or replace function public.learn_fix_mojibake(t text) returns text
language sql immutable as $$
  select replace(replace(replace(replace(replace(replace(replace(
         replace(replace(replace(replace(replace(replace(replace(replace(
           $1,
           '√ó', '×'), '√∑', '÷'), '¬∑', '·'), '¬±', '±'),
           'œÉ', 'σ'), 'œÅ', 'ρ'), 'Œº', 'μ'), 'Œµ', 'ε'),
           '‚Äî', '—'), '‚Äì', '–'), '‚Üí', '→'), '‚àí', '−'),
           '‚àö', '√'), '‚âà', '≈'), '‚Çπ', '₹')
$$;

begin;

update public.learn_questions set
  prompt         = public.learn_fix_mojibake(prompt),
  explanation    = public.learn_fix_mojibake(explanation),
  correct_answer = public.learn_fix_mojibake(correct_answer),
  topic          = public.learn_fix_mojibake(topic),
  source         = public.learn_fix_mojibake(source),
  hint           = public.learn_fix_mojibake(hint),
  choices        = public.learn_fix_mojibake(choices::text)::jsonb;

update public.learn_concepts set
  title        = public.learn_fix_mojibake(title),
  note         = public.learn_fix_mojibake(note),
  topic        = public.learn_fix_mojibake(topic),
  resource_url = public.learn_fix_mojibake(resource_url);

update public.learn_session_content set
  title         = public.learn_fix_mojibake(title),
  summary       = public.learn_fix_mojibake(summary),
  formula_sheet = public.learn_fix_mojibake(formula_sheet),
  resource_url  = public.learn_fix_mojibake(resource_url);

commit;

drop function public.learn_fix_mojibake(text);
