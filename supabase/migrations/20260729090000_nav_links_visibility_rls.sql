-- nav_links SELECT was "using (true)" for everyone, relying entirely on
-- Sidebar.tsx's client-side filter to hide visibility='admin' rows. Any
-- authenticated user querying the table directly (e.g. via devtools) could
-- read admin-only link labels/hrefs. Restrict at the DB layer too.
drop policy if exists "nav links readable by all" on public.nav_links;
create policy "nav links readable by visibility" on public.nav_links
  for select using (
    visibility = 'everyone'
    or exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin)
  );
