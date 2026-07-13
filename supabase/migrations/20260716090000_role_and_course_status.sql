-- Work-ex role (function), separate from domain — "IT/Tech" alone conflates an
-- engineer, a PM, and a category manager, whose relevant courses differ a lot.
alter table public.student_academic_profiles add column if not exists work_ex_role text not null default '';

-- Soft-disable for courses instead of hard delete, so re-adding a dropped
-- course doesn't mean re-entering everything from scratch.
alter table public.courses add column if not exists is_active boolean not null default true;
