-- Compass (search + map of what ISB taught): the derived dataset is one JSON file in a private
-- bucket. Signed-in students may read it; nobody can write through the API (it is uploaded with
-- the service key or the CLI). Kept out of git on purpose: it is built from course material.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('compass', 'compass', false, 20971520, array['application/json'])
on conflict (id) do nothing;

create policy "compass dataset readable by signed-in users"
  on storage.objects for select to authenticated
  using (bucket_id = 'compass');
