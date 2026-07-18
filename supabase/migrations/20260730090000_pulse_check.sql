-- Cohort Bidding Pulse Check: students voluntarily submit which course they're
-- seriously bidding on for a live Block Week, plus an estimated bid-point
-- amount, so peers can see an aggregated (never raw) demand read instead of
-- relying on scattered WhatsApp chatter. Per the design doc, this deliberately
-- accepts a known risk (self-reported bid estimates in a sealed-bid auction
-- can be strategically shaded) in exchange for a richer signal than a plain
-- interest toggle — see docs/ROADMAP.md for why an earlier, similar feature
-- was cut, and why this one proceeds anyway with tighter guardrails:
-- submissions are immutable once made, and the aggregate is only ever
-- readable through a threshold-gated function — never as raw rows.

alter table public.app_settings
  add column if not exists pulse_check_cutoff timestamptz not null default '2026-07-20 08:00:00+05:30'::timestamptz;

create table if not exists public.pulse_check_submissions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  course_id uuid not null references public.courses(id) on delete cascade,
  term text not null, -- denormalized from courses.term at submit time, same pattern as bid_plan_entries.term
  bid_points_estimate integer not null check (bid_points_estimate >= 100 and bid_points_estimate <= 4500),
  created_at timestamptz not null default now(),
  unique (user_id, term) -- one submission per student per Block Week, regardless of which course
);

create index if not exists pulse_check_submissions_term_idx on public.pulse_check_submissions(term);

alter table public.pulse_check_submissions enable row level security;

-- Read-only own rows. No admin-read policy — raw per-student estimates are
-- not meant to be visible to anyone but the student who submitted them; the
-- aggregate function below is the only sanctioned way to read this data back.
drop policy if exists "own pulse submissions readable" on public.pulse_check_submissions;
create policy "own pulse submissions readable" on public.pulse_check_submissions
  for select using (auth.uid() = user_id);

-- Insert-only, time-bound. No update/delete policy exists at all, which is
-- what makes a submission actually immutable once made (not just a disabled
-- button client-side) — Postgres RLS denies any operation with no matching
-- policy once RLS is enabled on the table.
drop policy if exists "own pulse submission insertable before cutoff" on public.pulse_check_submissions;
create policy "own pulse submission insertable before cutoff" on public.pulse_check_submissions
  for insert with check (
    auth.uid() = user_id
    and now() < (select pulse_check_cutoff from public.app_settings where id = true)
  );

-- The only path to the aggregate. security definer bypasses the owner-only
-- RLS select policy above (safe: the function itself never returns raw rows,
-- only a count and, once count >= 5, the median). Without this, the
-- alternative — granting students a direct select policy broad enough to
-- compute the aggregate client-side — would let them read every other
-- student's exact bid-point number, which is worse than the plain interest
-- toggle this feature was chosen over.
create or replace function public.pulse_check_results_by_term(p_term text)
returns table(course_id uuid, respondent_count integer, median_points numeric)
language sql
security definer
set search_path = public
stable
as $$
  select
    s.course_id,
    count(*)::integer as respondent_count,
    case when count(*) >= 5
      then percentile_cont(0.5) within group (order by s.bid_points_estimate)
      else null
    end as median_points
  from public.pulse_check_submissions s
  where s.term = p_term
  group by s.course_id;
$$;

revoke all on function public.pulse_check_results_by_term(text) from public;
grant execute on function public.pulse_check_results_by_term(text) to authenticated;
