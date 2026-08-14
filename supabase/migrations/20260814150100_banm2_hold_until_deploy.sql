-- Keep BANM2 out of students' hands until the code that renders it is deployed.
--
-- The content migration before this one loads 68 `short_answer` questions, which have no
-- `choices`. Rendering them needs the question-bank UI and the `has_practice` switch that ship
-- on the same branch; against the currently-deployed code a student would reach a practice card
-- with zero options and no way to answer it.
--
-- `enabled = false` is not "hidden": LearnPage opens a course when `enabled || is_admin`, so
-- admins can still read and check the whole section while students see "coming soon".
--
-- Flip it back with a one-line migration once the branch is live.

update public.learn_courses set enabled = false where course_code = 'BANM2';
