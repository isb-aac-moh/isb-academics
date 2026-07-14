-- Elective Bidding FAQ (Q45): "Cross-listed courses may only be counted toward
-- one concentration" — and it's the student's choice which one (DATA_MODEL.md:
-- "the student may include it in the concentration count only for one area").
-- Credit math previously let a course tagged to both of a student's 2 target
-- concentrations count toward both at once. This stores the student's choice,
-- keyed by course code so it covers both a planned bid entry and a converted
-- Flexi elective. Defaults to '{}' — until a choice is made, credit math falls
-- back to the student's first-listed target concentration (see creditProgress.ts).

alter table public.student_academic_profiles
  add column if not exists cross_listed_concentration_choices jsonb not null default '{}'::jsonb;
