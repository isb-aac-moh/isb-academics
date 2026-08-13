-- The 17 original migrations from the mktg-rep Supabase project (jkfztsjclbixjqtidhlx),
-- recovered verbatim from supabase_migrations.schema_migrations on 13 Aug 2026.
--
-- These were never checked into the mktg-rep git repo — this is the only copy outside
-- that project's database. They are AUTHORITATIVE over ./schema.sql, which is a flattened
-- current-state reconstruction from pg_catalog. Where the two disagree, trust this file.
--
-- Everything below this marker is byte-for-byte as stored, verified by md5 against the
-- database. Do not reformat it — the checksum in README.md is computed over it.
--
-- ---8<--- original migrations below, verbatim ---8<---
-- ===== 20260809144057_initial_schema =====
create table students (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null unique,
  created_at timestamptz not null default now()
);

create table questions (
  id text primary key,
  type text not null check (type in ('formula', 'case_fact')),
  topic text not null,
  session int not null,
  prompt text not null,
  choices jsonb not null,
  correct_answer text not null,
  source text not null,
  created_at timestamptz not null default now()
);

create table attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references students(id) on delete cascade,
  question_id text not null references questions(id) on delete cascade,
  correct boolean not null,
  created_at timestamptz not null default now()
);

create table topic_weight (
  student_id uuid not null references students(id) on delete cascade,
  topic text not null,
  weight numeric not null default 1,
  primary key (student_id, topic)
);

create index attempts_student_idx on attempts(student_id);
create index attempts_question_idx on attempts(question_id);

alter table students enable row level security;
alter table questions enable row level security;
alter table attempts enable row level security;
alter table topic_weight enable row level security;

-- Cohort pilot: trusted-link access, no auth system yet. Anyone with the anon key can read
-- questions and read/write their own gameplay rows. Revisit before any wider release.
create policy "anyone can read questions" on questions for select using (true);
create policy "anyone can read students" on students for select using (true);
create policy "anyone can create a student" on students for insert with check (true);
create policy "anyone can read attempts" on attempts for select using (true);
create policy "anyone can create attempts" on attempts for insert with check (true);
create policy "anyone can read topic_weight" on topic_weight for select using (true);
create policy "anyone can upsert topic_weight" on topic_weight for insert with check (true);
create policy "anyone can update topic_weight" on topic_weight for update using (true);

-- ===== 20260809151536_learning_loop_and_auth =====

-- Concept teaching notes, one per topic
create table concepts (
  topic text primary key,
  title text not null,
  note text not null
);
alter table concepts enable row level security;
create policy "anyone can read concepts" on concepts for select using (true);

-- Explanations shown after every answer
alter table questions add column explanation text not null default '';

-- Drop pre-auth pilot policies before restructuring students
drop policy "anyone can read students" on students;
drop policy "anyone can create a student" on students;
drop policy "anyone can read attempts" on attempts;
drop policy "anyone can create attempts" on attempts;
drop policy "anyone can read topic_weight" on topic_weight;
drop policy "anyone can upsert topic_weight" on topic_weight;
drop policy "anyone can update topic_weight" on topic_weight;

-- Pre-auth test row can't map to a real auth.users id; cascades to its attempts/weights.
delete from students;

-- Auth-linked student profile: id will equal auth.users.id, plus habit/reward tracking
alter table students drop constraint students_pkey cascade;
alter table students alter column id drop default;
alter table students add column total_xp int not null default 0;
alter table students add column day_streak int not null default 0;
alter table students add column last_active_date date;
alter table students add column is_admin boolean not null default false;
alter table students add primary key (id);

alter table attempts add constraint attempts_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table topic_weight add constraint topic_weight_student_id_fkey foreign key (student_id) references students(id) on delete cascade;

create policy "users read own profile" on students for select using (auth.uid() = id);
create policy "users create own profile" on students for insert with check (auth.uid() = id);
create policy "users update own profile" on students for update using (auth.uid() = id);

create policy "users read own attempts" on attempts for select using (auth.uid() = student_id);
create policy "users create own attempts" on attempts for insert with check (auth.uid() = student_id);

create policy "users read own topic_weight" on topic_weight for select using (auth.uid() = student_id);
create policy "users upsert own topic_weight" on topic_weight for insert with check (auth.uid() = student_id);
create policy "users update own topic_weight" on topic_weight for update using (auth.uid() = student_id);


-- ===== 20260809151937_admin_write_policies =====

create policy "admins manage questions" on questions for all
  using (exists (select 1 from students where id = auth.uid() and is_admin = true))
  with check (exists (select 1 from students where id = auth.uid() and is_admin = true));

create policy "admins manage concepts" on concepts for all
  using (exists (select 1 from students where id = auth.uid() and is_admin = true))
  with check (exists (select 1 from students where id = auth.uid() and is_admin = true));


-- ===== 20260810082905_add_concepts_resource_url =====
alter table public.concepts add column resource_url text;

-- ===== 20260810082911_create_session_content =====
create table public.session_content (
  session integer primary key,
  summary text,
  resource_url text,
  updated_at timestamptz not null default now()
);

alter table public.session_content enable row level security;

create policy "anyone can read session_content"
  on public.session_content for select
  using (true);

create policy "admins manage session_content"
  on public.session_content for all
  using (exists (select 1 from public.students where students.id = auth.uid() and students.is_admin = true))
  with check (exists (select 1 from public.students where students.id = auth.uid() and students.is_admin = true));

-- ===== 20260810082917_admin_read_all_for_monitoring =====
create policy "admins read all students"
  on public.students for select
  using (exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin = true));

create policy "admins read all attempts"
  on public.attempts for select
  using (exists (select 1 from public.students where students.id = auth.uid() and students.is_admin = true));

create policy "admins read all topic_weight"
  on public.topic_weight for select
  using (exists (select 1 from public.students where students.id = auth.uid() and students.is_admin = true));

-- ===== 20260810084511_fix_admin_read_students_recursion =====
create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (select 1 from public.students where id = auth.uid() and is_admin = true);
$$;

drop policy "admins read all students" on public.students;

create policy "admins read all students"
  on public.students for select
  using (public.is_admin());

-- ===== 20260810084852_monitoring_via_security_definer_functions =====
-- Replace broad "admins can read every raw row" policies with security-definer
-- aggregate functions, matching the isb-academics pulse_check convention: never
-- expose raw student/attempt rows to the client, only counts and accuracy.
drop policy if exists "admins read all students" on public.students;
drop policy if exists "admins read all attempts" on public.attempts;
drop policy if exists "admins read all topic_weight" on public.topic_weight;

create or replace function public.admin_cohort_stats()
returns table(
  total_students integer,
  active_today integer,
  active_this_week integer,
  total_answered integer,
  total_correct integer
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  if not public.is_admin() then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
    select
      (select count(*) from public.students)::integer,
      (select count(*) from public.students where last_active_date = current_date)::integer,
      (select count(*) from public.students where last_active_date >= current_date - interval '6 days')::integer,
      (select count(*) from public.attempts)::integer,
      (select count(*) from public.attempts where correct)::integer;
end;
$$;

revoke all on function public.admin_cohort_stats() from public;
grant execute on function public.admin_cohort_stats() to authenticated;

create or replace function public.admin_topic_stats()
returns table(topic text, total integer, accuracy numeric)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  if not public.is_admin() then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
    select
      q.topic,
      count(*)::integer as total,
      (count(*) filter (where a.correct))::numeric / count(*) as accuracy
    from public.attempts a
    join public.questions q on q.id = a.question_id
    group by q.topic
    having count(*) >= 3
    order by 3 asc;
end;
$$;

revoke all on function public.admin_topic_stats() from public;
grant execute on function public.admin_topic_stats() to authenticated;

create or replace function public.admin_flagged_questions()
returns table(question_id text, prompt text, topic text, session integer, total integer, accuracy numeric)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  if not public.is_admin() then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
    select
      q.id,
      q.prompt,
      q.topic,
      q.session,
      count(*)::integer as total,
      (count(*) filter (where a.correct))::numeric / count(*) as accuracy
    from public.attempts a
    join public.questions q on q.id = a.question_id
    group by q.id, q.prompt, q.topic, q.session
    having count(*) >= 3
      and ((count(*) filter (where a.correct))::numeric / count(*) < 0.4
        or (count(*) filter (where a.correct))::numeric / count(*) > 0.95)
    order by 6 asc;
end;
$$;

revoke all on function public.admin_flagged_questions() from public;
grant execute on function public.admin_flagged_questions() to authenticated;

-- ===== 20260810093220_create_course_content =====
create table public.course_content (
  id text primary key default 'marketing',
  outline text,
  announcements text,
  cheatsheet_url text,
  exam_samples_url text,
  feedback_form_url text,
  updated_at timestamptz not null default now()
);

alter table public.course_content enable row level security;

create policy "anyone can read course_content"
  on public.course_content for select
  using (true);

create policy "admins manage course_content"
  on public.course_content for all
  using (exists (select 1 from public.students where students.id = auth.uid() and students.is_admin = true))
  with check (exists (select 1 from public.students where students.id = auth.uid() and students.is_admin = true));


-- ===== 20260810100507_add_courses_table =====
create table public.courses (
  id text primary key,
  name text not null,
  code text,
  total_sessions int not null default 0,
  enabled boolean not null default false,
  sort_order int not null default 0
);

alter table public.courses enable row level security;

create policy "anyone can read courses"
  on public.courses for select
  using (true);

create policy "admins manage courses"
  on public.courses for all
  using (exists (select 1 from public.students where students.id = auth.uid() and students.is_admin = true))
  with check (exists (select 1 from public.students where students.id = auth.uid() and students.is_admin = true));

insert into public.courses (id, name, code, total_sessions, enabled, sort_order) values
  ('marketing', 'Marketing', 'MKTG273', 9, true, 0),
  ('operations', 'Operations', null, 0, false, 1);


-- ===== 20260810100527_scope_content_tables_by_course =====
-- questions: add course_id, backfill existing rows to marketing
alter table public.questions add column course_id text references public.courses(id);
update public.questions set course_id = 'marketing';
alter table public.questions alter column course_id set not null;
create index questions_course_id_idx on public.questions(course_id);

-- concepts: add course_id, backfill, and re-key so topic is unique per course, not globally
alter table public.concepts add column course_id text references public.courses(id);
update public.concepts set course_id = 'marketing';
alter table public.concepts alter column course_id set not null;
alter table public.concepts drop constraint concepts_pkey;
alter table public.concepts add primary key (course_id, topic);

-- session_content: add course_id + title (title replaces the old hardcoded SESSION_TITLES map),
-- re-key so session numbers are unique per course. No backfill needed -- table is empty.
alter table public.session_content add column course_id text references public.courses(id);
alter table public.session_content add column title text;
alter table public.session_content alter column course_id set not null;
alter table public.session_content drop constraint session_content_pkey;
alter table public.session_content add primary key (course_id, session);

-- course_content: was a single hardcoded 'marketing' row, now one row per real course
alter table public.course_content rename column id to course_id;
alter table public.course_content alter column course_id drop default;
alter table public.course_content add constraint course_content_course_id_fkey foreign key (course_id) references public.courses(id);


-- ===== 20260810100539_seed_marketing_session_titles =====
insert into public.session_content (course_id, session, title) values
  ('marketing', 1, 'Marketing Fundamentals'),
  ('marketing', 2, 'Segmentation, Targeting & Positioning'),
  ('marketing', 3, 'Marketing Analytics & Break-Even'),
  ('marketing', 4, '5 Cs & Customer Decision-Making'),
  ('marketing', 5, 'Branding & Unilever Brazil'),
  ('marketing', 6, 'Brand Management & CLV'),
  ('marketing', 7, 'Distribution & Economic Value'),
  ('marketing', 8, 'Pricing Strategy'),
  ('marketing', 9, 'Marketing Communications');


-- ===== 20260812100907_add_scenarios_and_question_metadata =====
create table scenarios (
  id         text primary key,
  course_id  text not null references courses(id) on delete cascade,
  session    int  not null,
  title      text not null,
  setup      text not null,
  source     text
);

create index scenarios_course_session_idx on scenarios (course_id, session);

alter table scenarios enable row level security;

create policy "scenarios readable by authenticated"
  on scenarios for select to authenticated using (true);

create policy "scenarios writable by admins"
  on scenarios for all to authenticated
  using (exists (select 1 from students s where s.id = auth.uid() and s.is_admin))
  with check (exists (select 1 from students s where s.id = auth.uid() and s.is_admin));

alter table questions
  add column scenario_id    text references scenarios(id) on delete set null,
  add column scenario_order int,
  add column difficulty     int  not null default 2,
  add column provenance     text not null default 'authored';

alter table questions
  add constraint questions_difficulty_range check (difficulty between 1 and 3),
  add constraint questions_provenance_valid
    check (provenance in ('prof_verbatim', 'prof_adapted', 'authored'));

create index questions_scenario_idx on questions (scenario_id, scenario_order);

-- ===== 20260812101313_add_topic_mastery_replacing_topic_weight =====
create table topic_mastery (
  student_id          uuid not null references students(id) on delete cascade,
  course_id           text not null references courses(id) on delete cascade,
  topic               text not null,
  level               int  not null default 0,
  consecutive_correct int  not null default 0,
  total_correct       int  not null default 0,
  total_attempts      int  not null default 0,
  last_seen_at        timestamptz,
  primary key (student_id, topic),
  constraint topic_mastery_level_range check (level between 0 and 4)
);

create index topic_mastery_student_course_idx on topic_mastery (student_id, course_id);

alter table topic_mastery enable row level security;

create policy "students read own mastery"
  on topic_mastery for select to authenticated using (student_id = auth.uid());

create policy "students write own mastery"
  on topic_mastery for all to authenticated
  using (student_id = auth.uid()) with check (student_id = auth.uid());

-- Migrate. weight > 1 means the topic was missed at some point -> Attempted.
-- weight = 0 means consistently correct -> Familiar. Approximate by design.
insert into topic_mastery (student_id, course_id, topic, level, total_attempts)
select tw.student_id, c.course_id, tw.topic,
       case when tw.weight = 0 then 2 else 1 end,
       0
from topic_weight tw
join concepts c on c.topic = tw.topic
on conflict (student_id, topic) do nothing;

drop table topic_weight;

-- ===== 20260813085825_add_hints_and_formula_sheets =====
alter table questions add column if not exists hint text;
alter table session_content add column if not exists formula_sheet text;
comment on column questions.hint is 'Optional nudge shown on demand during practice, before the answer is revealed.';
comment on column session_content.formula_sheet is 'Markdown formula reference for this session, available in a drawer during practice so students apply formulas rather than memorise them.';

-- ===== 20260813091725_add_course_materials_storage =====
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('course-materials', 'course-materials', false, 52428800,
        array['application/pdf','application/vnd.openxmlformats-officedocument.presentationml.presentation',
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'])
on conflict (id) do nothing;

-- Private bucket: every student read goes through a signed URL, so the professors' decks are not
-- sitting on a guessable public path. Auth is already domain-gated to @isb.edu upstream.
create policy "materials readable by signed-in students"
  on storage.objects for select to authenticated
  using (bucket_id = 'course-materials');

create policy "materials writable by admins"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'course-materials'
    and exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin)
  );

create policy "materials updatable by admins"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'course-materials'
    and exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin)
  );

create policy "materials deletable by admins"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'course-materials'
    and exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin)
  );

-- ===== 20260813091743_add_materials_table =====
create table if not exists public.materials (
  id uuid primary key default gen_random_uuid(),
  course_id text not null references public.courses(id) on delete cascade,
  -- null means the material belongs to the course as a whole (coursepack, outline, sample exams)
  session integer,
  title text not null,
  kind text not null default 'slides',
  storage_path text not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

comment on table public.materials is 'Index over the course-materials storage bucket: what each uploaded file is, and where it belongs in the course.';
comment on column public.materials.session is 'Null means the file belongs to the course as a whole rather than one session.';

create index if not exists materials_course_session_idx on public.materials (course_id, session);

alter table public.materials enable row level security;

create policy "materials index readable by signed-in students"
  on public.materials for select to authenticated using (true);

create policy "materials index writable by admins"
  on public.materials for all to authenticated
  using (exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin))
  with check (exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin));
