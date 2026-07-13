-- ISB Academics — Bidding Planner schema
-- Additive only: reuses isb-explorer's existing `users` table (and its is_admin column) for auth.
-- Real course/prerequisite/professor data still needed from Eshan — this seeds placeholders
-- that match the confirmed rules (concentrations, specializations, bidding mechanics).

create table if not exists public.courses (
  id uuid primary key default gen_random_uuid(),
  code text not null,
  name text not null,
  professor text not null default '',
  term text not null, -- 'Term 4' | 'Term 5' | 'Term 6' | 'Term 7' | 'Block Week 1'..'4'
  credits integer not null default 1,
  concentration_areas text[] not null default '{}', -- cross-listed courses can carry more than one; student picks one at bid time
  industry_specializations text[] not null default '{}',
  is_strategy_ob_course boolean not null default false, -- STLD's 2+2+2 split rule
  prerequisite_course_ids uuid[] not null default '{}',
  created_at timestamptz not null default now()
);

-- The five core courses whose F grade blocks a specific concentration
-- (Elective Bidding FAQ, "Implication of Fail Grades on Core Courses").
create table if not exists public.gating_core_courses (
  id text primary key, -- e.g. 'leadership_core', 'fcrv', 'strategy_core', 'marketing_mgmt', 'opmt_core'
  name text not null,
  blocks_concentration text not null
);

insert into public.gating_core_courses (id, name, blocks_concentration) values
  ('leadership_core', 'Leadership (Core)', 'Strategy and Leadership'),
  ('fcrv', 'FCRV', 'Finance'),
  ('strategy_core', 'Strategy (Core)', 'Strategy and Leadership'),
  ('marketing_mgmt', 'Marketing Management', 'Marketing'),
  ('opmt_core', 'OPMT (Core)', 'Operations Management')
on conflict (id) do nothing;

create table if not exists public.student_academic_profiles (
  user_id uuid primary key references public.users(id) on delete cascade,
  undergrad_field text not null default '',
  work_ex_domain text not null default '',
  work_ex_years numeric not null default 0,
  failed_gating_courses text[] not null default '{}', -- ids from gating_core_courses
  target_concentration text, -- one of the 6 areas, or null/'undecided'
  target_specialization text, -- one of the 4 specializations, 'none', or 'undecided'
  updated_at timestamptz not null default now()
);

-- Per-term bid plan: what a student intends/actually bids, so they can track their own
-- 4,500-point budget across terms themselves. Not a recommendation — just their own ledger.
create table if not exists public.bid_plan_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  course_id uuid references public.courses(id) on delete set null,
  term text not null,
  planned_points integer not null default 0,
  actual_points integer, -- filled in after a real bidding phase closes
  created_at timestamptz not null default now()
);

create table if not exists public.resources (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  url text not null,
  category text not null default 'general',
  created_at timestamptz not null default now()
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  created_at timestamptz not null default now()
);

-- Row Level Security: students see/manage only their own profile and bid plan;
-- course/gating/resource/notification data is admin-managed, world-readable.
alter table public.courses enable row level security;
alter table public.gating_core_courses enable row level security;
alter table public.student_academic_profiles enable row level security;
alter table public.bid_plan_entries enable row level security;
alter table public.resources enable row level security;
alter table public.notifications enable row level security;

drop policy if exists "courses readable by all" on public.courses;
create policy "courses readable by all" on public.courses for select using (true);

drop policy if exists "gating courses readable by all" on public.gating_core_courses;
create policy "gating courses readable by all" on public.gating_core_courses for select using (true);

drop policy if exists "resources readable by all" on public.resources;
create policy "resources readable by all" on public.resources for select using (true);

drop policy if exists "notifications readable by all" on public.notifications;
create policy "notifications readable by all" on public.notifications for select using (true);

drop policy if exists "own profile only" on public.student_academic_profiles;
create policy "own profile only" on public.student_academic_profiles
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own bid plan only" on public.bid_plan_entries;
create policy "own bid plan only" on public.bid_plan_entries
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Admin writes: only users.is_admin = true can add/edit/delete courses, gating
-- courses, resources, and notifications. Everyone else gets read-only (above).
create policy "admins can write courses" on public.courses
  for all using (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

create policy "admins can write gating courses" on public.gating_core_courses
  for all using (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

create policy "admins can write resources" on public.resources
  for all using (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

create policy "admins can write notifications" on public.notifications
  for all using (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));
