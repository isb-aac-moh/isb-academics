-- Learning agent data, part 1-courses-and-profiles.
-- Run the parts in numeric order: later ones reference rows created by earlier ones.
-- Safe to run once only — re-running duplicates learn_attempts, whose keys are generated.

begin;

insert into public.learn_courses (course_code, total_sessions, enabled, sort_order) values ('MKTG', 9, true, 0);
insert into public.learn_courses (course_code, total_sessions, enabled, sort_order) values ('OPMG', 9, true, 1);
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('db0cd900-e1fc-44e5-ada0-fa0360591f7d', 170, 5, '2026-08-13', '2026-08-09T17:36:08.044716+00:00');
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('b85f7426-486b-4726-9884-05598dc76371', 60, 2, '2026-08-10', '2026-08-09T19:16:07.105063+00:00');
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('33664123-77c1-413b-9d3d-618efc1e34c2', 30, 1, '2026-08-10', '2026-08-10T09:07:39.470772+00:00');
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('31f9bd26-85bb-430a-b347-2f3679cb5322', 0, 2, '2026-08-12', '2026-08-11T17:01:28.901421+00:00');
insert into public.learn_profiles (user_id, total_xp, day_streak, last_active_date, created_at) values ('4ade8731-5a77-4bf3-9989-b2e0359c2aba', 0, 1, '2026-08-12', '2026-08-12T12:25:34.864779+00:00');

commit;
