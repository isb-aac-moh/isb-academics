-- The Add button on the planner didn't guard against rapid double-clicks,
-- so the same course could be inserted more than once for the same user/term.
-- Keep the oldest row per (user_id, course_id, term) and drop the rest, then
-- add a constraint so a duplicate can't be inserted again.
delete from public.bid_plan_entries a
using public.bid_plan_entries b
where a.user_id = b.user_id
  and a.course_id = b.course_id
  and a.term = b.term
  and a.course_id is not null
  and (a.created_at, a.id) > (b.created_at, b.id);

alter table public.bid_plan_entries
  add constraint bid_plan_entries_user_course_term_unique
  unique (user_id, course_id, term);
