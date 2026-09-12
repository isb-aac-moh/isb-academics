-- Structured group/peer-evaluation/attendance facts for each course, read off the
-- standard "Group Information", "Peer Evaluation Component" and "Attendance &
-- Punctuality" blocks that every ISB course outline carries. These already appear
-- as prose inside `brief`, but the Term Dossier filters on them, and prose can't
-- be filtered. Same template repeats every term, so the extraction repeats too.
--
-- All five are nullable: null means "the outline doesn't say", which is common --
-- 10 of the 17 Term 5 outlines omit group_formation, 5 omit cross_section.
-- Null is never rendered as a claim, only as "not stated".

alter table public.course_grading_profiles
  add column group_size text,
  add column cross_section boolean,
  add column group_formation text,
  add column peer_eval boolean,
  add column attendance text;

comment on column public.course_grading_profiles.group_size is
  'Verbatim group size from the outline, e.g. "4-6", "Up to 3". Free text because outlines phrase it every possible way.';
comment on column public.course_grading_profiles.cross_section is
  'Can groups span sections? null = the outline does not say.';
comment on column public.course_grading_profiles.peer_eval is
  'Does the course run a peer evaluation that moves individual grades? false = no such component in the outline.';

-- Constrained so the dossier filters stay stable as later terms are seeded.
alter table public.course_grading_profiles
  add constraint course_grading_profiles_group_formation_check
    check (group_formation is null or group_formation in ('Self-select', 'Instructor-assigned', 'ASA-assigned')),
  add constraint course_grading_profiles_attendance_check
    check (attendance is null or attendance in ('Not mandatory', 'ISB policy', 'Participation-linked', 'Stricter than ISB policy'));
