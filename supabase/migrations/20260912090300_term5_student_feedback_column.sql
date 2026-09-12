-- Informal feedback from students who've already taken a course, gathered from a
-- WhatsApp thread among Hyderabad-campus students. Deliberately separate from
-- `brief`, which is a description of what the official outline says -- this is
-- word of mouth, can be wrong, and can contradict itself between students.
--
-- Admin-editable from the Courses tab's grading editor, same add/remove pattern as
-- `brief`. Empty array (not null) means "no feedback yet", so callers never need a
-- null check before mapping over it.

alter table public.course_grading_profiles
  add column student_feedback jsonb not null default '[]'::jsonb;

comment on column public.course_grading_profiles.student_feedback is
  'Array of free-text feedback strings from students who took the course. Anecdotal -- not from the official outline.';
