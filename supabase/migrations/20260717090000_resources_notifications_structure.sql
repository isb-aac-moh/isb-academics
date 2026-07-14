-- Structured resource repository (mirrors the AAC Notion repo's taxonomy:
-- Course Resources, PYQPs & Notes, Platform Directory, Professor Profiles,
-- Session Transcripts) and a proper Noticeboard (tags + pinning).

alter table public.resources add column if not exists resource_type text not null default 'General';
alter table public.resources add column if not exists term text;
alter table public.resources add column if not exists course_id uuid references public.courses(id) on delete set null;

alter table public.notifications add column if not exists tag text not null default 'General';
alter table public.notifications add column if not exists pinned boolean not null default false;

create index if not exists resources_course_id_idx on public.resources(course_id);
create index if not exists resources_type_idx on public.resources(resource_type);
