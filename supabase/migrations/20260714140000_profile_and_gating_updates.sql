-- Support: multi-concentration selection (max 2 per ISB rules), explicit "term"
-- on gating core courses (so the UI can show "Leading Self and Teams (Term 1)"
-- instead of a bare course name), and capturing which Term 2/3 Flexi Core
-- courses a student already completed (these count toward concentration
-- credit and were previously not asked at all).

alter table public.gating_core_courses add column if not exists term text not null default '';
update public.gating_core_courses set term = 'Term 1' where id = 'leadership_core';
update public.gating_core_courses set term = 'Term 2' where id in ('fcrv', 'strategy_core');
update public.gating_core_courses set term = 'Term 3' where id in ('marketing_mgmt', 'opmt_core');

alter table public.student_academic_profiles rename column target_concentration to target_concentrations_old;
alter table public.student_academic_profiles add column target_concentrations text[] not null default '{}';
update public.student_academic_profiles
  set target_concentrations = case
    when target_concentrations_old is null or target_concentrations_old in ('undecided', 'none') then '{}'::text[]
    else array[target_concentrations_old]
  end;
alter table public.student_academic_profiles drop column target_concentrations_old;

alter table public.student_academic_profiles add column if not exists completed_term2_flexi text[] not null default '{}';
alter table public.student_academic_profiles add column if not exists completed_term3_flexi text[] not null default '{}';

-- "Business Analytics for Technology Management" — named in the Flexi Core
-- doc as one of three interchangeable Business Analytics options for Term 3,
-- but no course code was given in any source doc. Code is a placeholder
-- until confirmed against Registro.
insert into public.courses (code, name, professor, term, credits, concentration_areas, industry_specializations)
values ('BATM_TBD', 'Business Analytics for Technology Management (Flexi Core — code unconfirmed)', 'TBD', 'Term 3', 1, array['Information Technology Management'], array[]::text[])
on conflict (code) do nothing;
