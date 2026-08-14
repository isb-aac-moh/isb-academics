-- Pulse Check was built for single-course Block Weeks, so one submission per
-- student per term was the right shape (see pulse_check.sql). Now that Term 4
-- (a regular multi-elective term) is live for Pulse Check too, students bid on
-- several courses at once and the per-term cap blocks them from logging more
-- than their first pick. Relax the constraint to one submission per student
-- per course — still only within a single live term, since course_id already
-- implies which term a submission belongs to.

alter table public.pulse_check_submissions
  drop constraint if exists pulse_check_submissions_user_id_term_key;

alter table public.pulse_check_submissions
  add constraint pulse_check_submissions_user_id_course_id_key unique (user_id, course_id);
