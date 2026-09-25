-- Self-serve hosting for standalone HTML pages (Eshan's ask): an admin can upload an .html file
-- from the Nav Links or Resources tab and get back a public URL to paste straight into the link
-- field, instead of asking Claude to drop the file into public/ and redeploy. Public (not signed
-- URLs like course-materials) because these are the same kind of link as the app's existing
-- public/ dossiers and revision guides — meant to work indefinitely, shareable outside a login.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('custom-pages', 'custom-pages', true, 52428800, array['text/html'])
on conflict (id) do nothing;

create policy "custom pages writable by admins"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'custom-pages' and exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

create policy "custom pages updatable by admins"
  on storage.objects for update to authenticated
  using (bucket_id = 'custom-pages' and exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

create policy "custom pages deletable by admins"
  on storage.objects for delete to authenticated
  using (bucket_id = 'custom-pages' and exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));
