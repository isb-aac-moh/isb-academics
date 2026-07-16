-- Singleton settings row for app-wide config that shouldn't require a code
-- change + redeploy to update. First user: which term(s)/block week(s) are
-- the current bidding round (previously hardcoded LIVE_NOW_TERMS in
-- creditProgress.ts). The boolean PK + check is the standard Postgres
-- singleton-row trick — only `true` is ever a valid id, so there can only
-- ever be one row.
create table if not exists public.app_settings (
  id boolean primary key default true check (id),
  live_bidding_terms text[] not null default '{}',
  updated_at timestamptz not null default now()
);

insert into public.app_settings (id, live_bidding_terms)
values (true, array['Block Week 1', 'Block Week 2'])
on conflict (id) do nothing;

alter table public.app_settings enable row level security;

drop policy if exists "app settings readable by all" on public.app_settings;
create policy "app settings readable by all" on public.app_settings for select using (true);

drop policy if exists "admins can write app settings" on public.app_settings;
create policy "admins can write app settings" on public.app_settings
  for all using (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));
