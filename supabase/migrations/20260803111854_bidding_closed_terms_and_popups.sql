-- Recovered from supabase_migrations.schema_migrations on 2026-08-14. This ran against the
-- database but was never checked in, which is why `supabase db push` could not see it.

-- Two additions, both about the same real-world problem: the academic
-- calendar's dates (termCalendar.ts) don't reliably track when bidding
-- actually opens/closes or which term is "current" — ISB's real schedule
-- runs a bit asynchronously from the class-date ranges. Both become
-- admin-editable settings instead of derived-from-dates guesses.

alter table public.app_settings
  add column if not exists current_terms text[] not null default '{}';

alter table public.app_settings
  add column if not exists closed_bidding_terms text[] not null default '{}';

-- Which term(s) already had bidding close (results announced) — students with
-- a pending planned bid in one of these terms get prompted to log what they
-- actually got, regardless of whether the term's class dates have started.
comment on column public.app_settings.closed_bidding_terms is
  'Terms whose bidding round has closed — drives the "did you get it?" reconciliation prompt independent of calendar dates.';
comment on column public.app_settings.current_terms is
  'Admin override for "what term is it right now" — falls back to termCalendar.ts date math when empty.';

-- Admin-configurable dashboard popups. Each popup's trigger logic and input
-- form still live in code (they're genuinely different per popup — a bid
-- reconciliation form isn't the same shape as a text announcement), but an
-- admin can switch one on/off and edit its copy without a code change.
create table if not exists public.dashboard_popups (
  slug text primary key,
  enabled boolean not null default true,
  title text not null default '',
  body text not null default '',
  updated_at timestamptz not null default now()
);

insert into public.dashboard_popups (slug, enabled, title, body) values (
  'bidding_reconciliation',
  true,
  'Did you get your course?',
  'Bidding for this round has closed — let us know what you got so your Credit Tracker and bid budget stay accurate.'
) on conflict (slug) do nothing;

alter table public.dashboard_popups enable row level security;

drop policy if exists "dashboard popups readable by all" on public.dashboard_popups;
create policy "dashboard popups readable by all" on public.dashboard_popups for select using (true);

drop policy if exists "admins can write dashboard popups" on public.dashboard_popups;
create policy "admins can write dashboard popups" on public.dashboard_popups
  for all using (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

