-- Compass connector pilot. Sign-in tokens issued to outside apps (OAuth) carry the user's normal
-- database rights, and their scopes do not limit that. So refuse them everywhere: every public table
-- and all file storage. They can only call the compass-mcp function, which uses its own checks.
-- Normal logins have no client_id claim and are unaffected. Any table added later needs this same policy.
create table public.compass_connector_log (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  at timestamptz not null default now(),
  question text not null check (char_length(question) <= 60),
  cards int not null
);
create index compass_connector_log_user_at on public.compass_connector_log (user_id, at desc);
-- No policies: only the function, using the service role, can read or write this table.
alter table public.compass_connector_log enable row level security;

do $$
declare t text;
begin
  for t in select tablename from pg_tables where schemaname = 'public' loop
    execute format(
      'create policy "no connector tokens" on public.%I as restrictive for all to authenticated using ((select auth.jwt() ->> ''client_id'') is null)', t);
  end loop;
end $$;

create policy "no connector tokens" on storage.objects as restrictive for all to authenticated
  using ((select auth.jwt() ->> 'client_id') is null);
