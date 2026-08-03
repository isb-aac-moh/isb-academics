-- Credit Tracker: what a student actually ended up enrolled in, separate from
-- bid_plan_entries (their bid intentions). Bidding results can differ from a
-- plan, so this is its own table rather than reusing bid_plan_entries.actual_points.
create table if not exists public.actual_enrollments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  course_id uuid references public.courses(id) on delete set null,
  term text not null,
  points_paid integer not null default 0,
  grade text,
  created_at timestamptz not null default now(),
  unique (user_id, course_id, term)
);

alter table public.actual_enrollments enable row level security;

drop policy if exists "own actual enrollments only" on public.actual_enrollments;
create policy "own actual enrollments only" on public.actual_enrollments
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
