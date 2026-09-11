-- Campus and term for each ASA faculty rating, plus course codes the first load
-- missed. ASA's 2025-26 pages give Mohali and Hyderabad separate columns
-- (e.g. ENVC_PGPMOH_2025-26_T7 vs ENVC_PGPHYD_2025-26_T4). Older pages mostly
-- don't say, so those stay null ("not stated") instead of being guessed.

alter table public.faculty_ratings
  add column campus text check (campus in ('Mohali', 'Hyderabad')),
  add column term_label text;

-- A label naming both campuses (e.g. a study trek titled "Hyderabad and Mohali")
-- matches neither branch and stays null.
update public.faculty_ratings set campus = case
  when offering ~* '(PGPMOH|[_ (]MOH\M)' and offering !~* '(PGPHYD|[_ (]HYD\M)' then 'Mohali'
  when offering ~* '(PGPHYD|[_ (]HYD\M)' and offering !~* '(PGPMOH|[_ (]MOH\M)' then 'Hyderabad'
  when offering ~* 'Mohali' and offering !~* 'Hyderabad' then 'Mohali'
  when offering ~* 'Hyderabad' and offering !~* 'Mohali' then 'Hyderabad'
end;

update public.faculty_ratings set term_label = coalesce(
  'BW' || (regexp_match(offering, '(?:_BW|\mBW\s*|Block\s*Week\s*)(\d)', 'i'))[1],
  'T' || (regexp_match(offering, '_T(\d)\M'))[1],
  'T' || (regexp_match(offering, 'Term[\s-]*:?\s*(\d)', 'i'))[1]);

-- Labels ending in a bare course code, e.g. "Term 4 2024-25 ENVC".
update public.faculty_ratings
set course_code = (regexp_match(offering, '\m([A-Z]{4,6}[0-9]?)\s*$'))[1]
where course_code is null and offering ~ '\m[A-Z]{4,6}[0-9]?\s*$';

-- Labels naming the course by title only; filled only when exactly one course matches.
update public.faculty_ratings fr set course_code = m.code
from (
  select fr2.id, min(c.code) as code
  from public.faculty_ratings fr2
  join public.courses c
    on length(split_part(c.name, ' (', 1)) > 12
   and position(lower(split_part(c.name, ' (', 1)) in lower(fr2.offering)) > 0
  where fr2.course_code is null
  group by fr2.id
  having count(distinct c.code) = 1
) m
where fr.id = m.id;
