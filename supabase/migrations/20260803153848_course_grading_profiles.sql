-- Per-course grading DNA: grading composition, exam structure, workload profile,
-- and a short "everything about this course" brief — extracted from official ISB
-- course outlines (SharePoint). Designed to outlive Term 4: any course in any term
-- can get a row here as its outline becomes available, admin-editable afterward.

create table public.course_grading_profiles (
  course_id uuid primary key references public.courses(id) on delete cascade,

  -- Grading composition (0-100, should sum to ~100). "Exam" bucket covers all
  -- individual quizzes/midterms/finals; "individual" is non-exam individual work.
  grade_participation_pct numeric not null default 0,
  grade_individual_pct numeric not null default 0,
  grade_group_pct numeric not null default 0,
  grade_exam_pct numeric not null default 0,

  -- Sit-down exam structure, as counted in the Bidding Planner's exam tally.
  exam_midterm_count int not null default 0,
  exam_endterm_count int not null default 0,
  exam_quiz_count int not null default 0,

  -- Workload profile, 0-5 each — a judgment call read off the outline, not a
  -- precise measurement. Admin-editable to correct.
  load_quant numeric not null default 0,
  load_assignments numeric not null default 0,
  load_participation numeric not null default 0,
  load_exam_pressure numeric not null default 0,
  load_group numeric not null default 0,
  load_reading numeric not null default 0,

  -- Labeled bullets, e.g. [{"label": "About", "text": "..."}, ...] — the
  -- "every aspect of a course" brief shown in the planner.
  brief jsonb not null default '[]'::jsonb,

  source_url text, -- the course outline PDF this was extracted from, for traceability
  extracted_at timestamptz, -- null if hand-entered by an admin rather than extracted
  updated_at timestamptz not null default now()
);

alter table public.course_grading_profiles enable row level security;

create policy "grading profiles readable by all" on public.course_grading_profiles
  for select using (true);

create policy "admins can write grading profiles" on public.course_grading_profiles
  for all using (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));
