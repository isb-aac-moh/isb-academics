-- 20260722090000_seed_course_outline_resources.sql seeds ~40 rows with an
-- unconditional insert (no on-conflict guard), the same pattern that already
-- duplicated nav_links once a `supabase db push` re-ran an out-of-sync
-- migration. resources has no unique constraint at all, so a re-run would
-- silently double every course outline. Existing rows were checked first —
-- courses with multiple outline files (different sections/professors) always
-- have distinct urls, so this constraint doesn't collide with legitimate data.
alter table public.resources
  add constraint resources_course_id_url_unique unique (course_id, url);
