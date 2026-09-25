-- SUET (Sustainability and Ethics) end-term revision guide, covering Sessions 1-3 plus the
-- pre-Ant Forest coursepack readings. No interactive session content yet — this only backs the
-- revision guide compass icon on the Learn desktop, so the course also gets a "0 sessions" book
-- icon next to it until real session content is built (accepted trade-off, see revisionGuides.ts).

insert into public.learn_courses (course_code, total_sessions, enabled, sort_order)
values ('SUET', 0, true, 4)
on conflict (course_code) do update
  set total_sessions = excluded.total_sessions, enabled = excluded.enabled, sort_order = excluded.sort_order;
