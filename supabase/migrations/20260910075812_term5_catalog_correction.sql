-- Term 5 elective lineup changed since real_course_data.sql was seeded
-- (20260714130000): Business Process Excellence (BPEX) is no longer in
-- ISB's official Term 5 lineup, and Marketing Strategy (MKTS) was added.
-- Confirmed against two sources: T5_MOH_Pass-Fail Information.xlsx
-- (Course_Outlines Announcements folder, updated 2026-09-07) and the
-- Mohali 2026-27 Core & Elective Lineup page (updated 2026-09-09).
--
-- BPEX has 3 existing bid_plan_entries from students who planned around
-- it before it was dropped -- soft-disabled per the documented is_active
-- convention (DATA_MODEL.md: "false = dropped/hidden from students, but
-- the row and all its history stays"), not hard-deleted.

update public.courses
set is_active = false
where code = 'BPEX' and term = 'Term 5';

insert into public.courses (code, name, professor, term, credits, concentration_areas, industry_specializations)
values
('MKTS', 'Marketing Strategy', 'S Arunachalam', 'Term 5', 1, array['Marketing','Strategy and Leadership'], array[]::text[])
on conflict (code) do nothing;
