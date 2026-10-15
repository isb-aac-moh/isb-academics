-- Compass (search + map of what ISB taught), admin-only pilot. The derived dataset is one JSON file
-- in a private bucket. Only admins can read it through the API; nobody can write through the API
-- (it is uploaded with the CLI). Kept out of git on purpose: it is built from course material.
-- To open Compass to all students later, widen the select policy and the /compass route together.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('compass', 'compass', false, 20971520, array['application/json'])
on conflict (id) do nothing;

create policy "compass dataset readable by admins"
  on storage.objects for select to authenticated
  using (bucket_id = 'compass' and exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));
