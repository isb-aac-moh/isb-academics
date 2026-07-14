-- Short admin-written blurb per resource so students know what's inside
-- before clicking through — avoids opening every link just to check.
alter table public.resources add column if not exists description text;
