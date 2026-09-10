-- Turns dashboard_popups (added in 20260803111854_bidding_closed_terms_and_popups.sql but
-- never wired to any UI) into a fully admin-authored popup: which page it shows on, how often,
-- an optional icon, and a primary button whose action (dismiss / go to a page / open a link) is
-- data instead of code. RLS already allows this (read: everyone, write: admins) — no policy changes.

alter table public.dashboard_popups
  add column if not exists icon text,
  add column if not exists page text not null default '',
  add column if not exists frequency text not null default 'always',
  add column if not exists primary_label text not null default 'Got it',
  add column if not exists primary_action text not null default 'dismiss',
  add column if not exists primary_target text,
  add column if not exists secondary_label text;

alter table public.dashboard_popups
  drop constraint if exists dashboard_popups_frequency_check;
alter table public.dashboard_popups
  add constraint dashboard_popups_frequency_check check (frequency in ('always', 'session', 'once'));

alter table public.dashboard_popups
  drop constraint if exists dashboard_popups_primary_action_check;
alter table public.dashboard_popups
  add constraint dashboard_popups_primary_action_check check (primary_action in ('dismiss', 'internal', 'external'));

comment on column public.dashboard_popups.page is
  'Route pathname prefix this popup shows on (e.g. "/tracker"); empty string shows on every page.';
comment on column public.dashboard_popups.frequency is
  'always: shows again every time the page is visited. session: dismissed for the current browser tab (sessionStorage). once: dismissed forever once closed (localStorage).';
comment on column public.dashboard_popups.primary_action is
  'dismiss: primary button just closes it. internal: react-router navigate to primary_target. external: open primary_target in a new tab.';

-- This row was already enabled=true but was never rendered anywhere — a dead row from before
-- the popup mechanism existed. Now that dashboard_popups drives a real global renderer, leaving
-- it enabled with no page/content configured would surface it to every student immediately.
-- Disable it; an admin can build it out properly from the new Popups admin tab when it's ready.
update public.dashboard_popups set enabled = false where slug = 'bidding_reconciliation';

-- Migrates the hardcoded "Check out the Learn tab" popup out of CreditTracker.tsx.
insert into public.dashboard_popups
  (slug, enabled, title, body, icon, page, frequency, primary_label, primary_action, primary_target, secondary_label)
values (
  'learn-tab-promo', true,
  'Check out the Learn tab',
  'Adaptive practice quizzes pulled straight from your course material — a quick way to prep before bidding.',
  'Brain', '/tracker', 'always', 'Attempt a quiz', 'internal', '/learn/practice', 'Maybe later'
)
on conflict (slug) do nothing;
