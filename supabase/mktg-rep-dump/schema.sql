-- Faithful snapshot of the mktg-rep Supabase project (jkfztsjclbixjqtidhlx), taken 2026-08-13.
--
-- This is a RECORD OF WHAT EXISTS, not the migration to apply to isb-academics. The
-- transforms needed before any of this lands in isb-academics (course key remap,
-- students -> users, RLS rewrite) are listed in README.md and deliberately NOT applied here.
--
-- Reconstructed from pg_catalog (pg_constraint, pg_indexes, pg_policies, pg_proc,
-- pg_description), not from pg_dump — the project's DB password was not available.
--
-- ./migrations-original.sql IS AUTHORITATIVE OVER THIS FILE. mktg-rep's 17 migrations were
-- never checked into its git repo, but they were recorded in supabase_migrations and have
-- been recovered verbatim. This file is the flattened current state, useful for reading the
-- schema in one pass; where the two disagree, trust the migrations.

begin;

-- ---------------------------------------------------------------------------
-- Tables, in dependency order
-- ---------------------------------------------------------------------------

create table public.courses (
  id             text    primary key,
  name           text    not null,
  code           text,
  total_sessions integer not null default 0,
  enabled        boolean not null default false,
  sort_order     integer not null default 0
);

-- NOTE: no foreign key to auth.users. students.id is expected to equal auth.uid(),
-- but nothing in the schema enforces it.
create table public.students (
  id               uuid        primary key,
  name             text        not null,
  email            text        not null unique,
  created_at       timestamptz not null default now(),
  total_xp         integer     not null default 0,
  day_streak       integer     not null default 0,
  last_active_date date,
  is_admin         boolean     not null default false
);

create table public.scenarios (
  id        text    primary key,
  course_id text    not null references public.courses(id) on delete cascade,
  session   integer not null,
  title     text    not null,
  setup     text    not null,
  source    text
);

create table public.questions (
  id             text        primary key,
  type           text        not null,
  topic          text        not null,
  session        integer     not null,
  prompt         text        not null,
  choices        jsonb       not null,
  correct_answer text        not null,
  source         text        not null,
  created_at     timestamptz not null default now(),
  explanation    text        not null default ''::text,
  course_id      text        not null references public.courses(id),
  scenario_id    text        references public.scenarios(id) on delete set null,
  scenario_order integer,
  difficulty     integer     not null default 2,
  provenance     text        not null default 'authored'::text,
  hint           text,
  constraint questions_type_check       check (type = any (array['formula'::text, 'case_fact'::text])),
  constraint questions_difficulty_range check (difficulty >= 1 and difficulty <= 3),
  constraint questions_provenance_valid check (provenance = any (array['prof_verbatim'::text, 'prof_adapted'::text, 'authored'::text]))
);

create table public.concepts (
  topic        text not null,
  title        text not null,
  note         text not null,
  resource_url text,
  course_id    text not null references public.courses(id),
  primary key (course_id, topic)
);

create table public.session_content (
  session       integer     not null,
  summary       text,
  resource_url  text,
  updated_at    timestamptz not null default now(),
  course_id     text        not null references public.courses(id),
  title         text,
  formula_sheet text,
  primary key (course_id, session)
);

create table public.course_content (
  course_id         text primary key references public.courses(id),
  outline           text,
  announcements     text,
  cheatsheet_url    text,
  exam_samples_url  text,
  feedback_form_url text,
  updated_at        timestamptz not null default now()
);

create table public.attempts (
  id          uuid        primary key default gen_random_uuid(),
  student_id  uuid        not null references public.students(id) on delete cascade,
  question_id text        not null references public.questions(id) on delete cascade,
  correct     boolean     not null,
  created_at  timestamptz not null default now()
);

-- NOTE: the primary key is (student_id, topic) and does NOT include course_id, even though
-- course_id is a column and is indexed. Two courses sharing a topic name would collide on
-- one student. Not currently triggered — topic names happen to be distinct across the two
-- courses — but it is a real defect, see README.md.
create table public.topic_mastery (
  student_id         uuid    not null references public.students(id) on delete cascade,
  course_id          text    not null references public.courses(id) on delete cascade,
  topic              text    not null,
  level              integer not null default 0,
  consecutive_correct integer not null default 0,
  total_correct      integer not null default 0,
  total_attempts     integer not null default 0,
  last_seen_at       timestamptz,
  primary key (student_id, topic),
  constraint topic_mastery_level_range check (level >= 0 and level <= 4)
);

create table public.materials (
  id           uuid        primary key default gen_random_uuid(),
  course_id    text        not null references public.courses(id) on delete cascade,
  session      integer,
  title        text        not null,
  kind         text        not null default 'slides'::text,
  storage_path text        not null,
  sort_order   integer     not null default 0,
  created_at   timestamptz not null default now()
);

comment on table  public.materials              is 'Index over the course-materials storage bucket: what each uploaded file is, and where it belongs in the course.';
comment on column public.materials.session      is 'Null means the file belongs to the course as a whole rather than one session.';
comment on column public.questions.hint         is 'Optional nudge shown on demand during practice, before the answer is revealed.';
comment on column public.session_content.formula_sheet is 'Markdown formula reference for this session, available in a drawer during practice so students apply formulas rather than memorise them.';

-- ---------------------------------------------------------------------------
-- Indexes
-- ---------------------------------------------------------------------------

create index attempts_student_idx            on public.attempts      using btree (student_id);
create index attempts_question_idx           on public.attempts      using btree (question_id);
create index questions_course_id_idx         on public.questions     using btree (course_id);
create index questions_scenario_idx          on public.questions     using btree (scenario_id, scenario_order);
create index scenarios_course_session_idx    on public.scenarios     using btree (course_id, session);
create index topic_mastery_student_course_idx on public.topic_mastery using btree (student_id, course_id);
create index materials_course_session_idx    on public.materials     using btree (course_id, session);

-- ---------------------------------------------------------------------------
-- Functions. All four read public.students for the admin check — every one of these
-- needs rewriting against isb-academics' public.users on merge.
-- ---------------------------------------------------------------------------

create or replace function public.is_admin()
 returns boolean
 language sql
 stable security definer
 set search_path to 'public'
as $function$
  select exists (select 1 from public.students where id = auth.uid() and is_admin = true);
$function$;

create or replace function public.admin_topic_stats()
 returns table(topic text, total integer, accuracy numeric)
 language plpgsql
 stable security definer
 set search_path to 'public'
as $function$
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
$function$;

create or replace function public.admin_flagged_questions()
 returns table(question_id text, prompt text, topic text, session integer, total integer, accuracy numeric)
 language plpgsql
 stable security definer
 set search_path to 'public'
as $function$
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
$function$;

create or replace function public.admin_cohort_stats()
 returns table(total_students integer, active_today integer, active_this_week integer, total_answered integer, total_correct integer)
 language plpgsql
 stable security definer
 set search_path to 'public'
as $function$
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
$function$;

-- The three admin RPCs are locked down to signed-in users only. Without these grants the
-- anon role can call them, and the is_admin() check inside is the only thing standing
-- between an anon caller and cohort-wide stats. Carry these across.
revoke all on function public.admin_cohort_stats() from public;
grant execute on function public.admin_cohort_stats() to authenticated;
revoke all on function public.admin_topic_stats() from public;
grant execute on function public.admin_topic_stats() to authenticated;
revoke all on function public.admin_flagged_questions() from public;
grant execute on function public.admin_flagged_questions() to authenticated;

-- ---------------------------------------------------------------------------
-- Row level security. Note the inconsistency in the source project: the older
-- policies target the `public` role, the newer ones (materials, scenarios,
-- topic_mastery) target `authenticated`. Reproduced verbatim.
-- ---------------------------------------------------------------------------

alter table public.courses         enable row level security;
alter table public.students        enable row level security;
alter table public.scenarios       enable row level security;
alter table public.questions       enable row level security;
alter table public.concepts        enable row level security;
alter table public.session_content enable row level security;
alter table public.course_content  enable row level security;
alter table public.attempts        enable row level security;
alter table public.topic_mastery   enable row level security;
alter table public.materials       enable row level security;

create policy "anyone can read courses"  on public.courses for select using (true);
create policy "admins manage courses"    on public.courses for all
  using (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true))
  with check (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true));

create policy "users read own profile"   on public.students for select using (auth.uid() = id);
create policy "users create own profile" on public.students for insert with check (auth.uid() = id);
create policy "users update own profile" on public.students for update using (auth.uid() = id);

create policy "anyone can read questions" on public.questions for select using (true);
create policy "admins manage questions"   on public.questions for all
  using (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true))
  with check (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true));

create policy "anyone can read concepts" on public.concepts for select using (true);
create policy "admins manage concepts"   on public.concepts for all
  using (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true))
  with check (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true));

create policy "anyone can read session_content" on public.session_content for select using (true);
create policy "admins manage session_content"   on public.session_content for all
  using (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true))
  with check (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true));

create policy "anyone can read course_content" on public.course_content for select using (true);
create policy "admins manage course_content"   on public.course_content for all
  using (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true))
  with check (exists (select 1 from students where students.id = auth.uid() and students.is_admin = true));

create policy "users read own attempts"   on public.attempts for select using (auth.uid() = student_id);
create policy "users create own attempts" on public.attempts for insert with check (auth.uid() = student_id);

create policy "students read own mastery"  on public.topic_mastery for select to authenticated using (student_id = auth.uid());
create policy "students write own mastery" on public.topic_mastery for all    to authenticated
  using (student_id = auth.uid()) with check (student_id = auth.uid());

create policy "scenarios readable by authenticated" on public.scenarios for select to authenticated using (true);
create policy "scenarios writable by admins"        on public.scenarios for all    to authenticated
  using (exists (select 1 from students s where s.id = auth.uid() and s.is_admin))
  with check (exists (select 1 from students s where s.id = auth.uid() and s.is_admin));

create policy "materials index readable by signed-in students" on public.materials for select to authenticated using (true);
create policy "materials index writable by admins"             on public.materials for all    to authenticated
  using (exists (select 1 from students s where s.id = auth.uid() and s.is_admin))
  with check (exists (select 1 from students s where s.id = auth.uid() and s.is_admin));

commit;

-- ---------------------------------------------------------------------------
-- Storage
-- ---------------------------------------------------------------------------
-- One private bucket, `course-materials`, containing ZERO objects at snapshot time, so
-- there are no files to copy — but the bucket config and its four object-level policies
-- are real and easy to forget, since they live in the storage schema rather than public.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('course-materials', 'course-materials', false, 52428800,
        array['application/pdf','application/vnd.openxmlformats-officedocument.presentationml.presentation',
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'])
on conflict (id) do nothing;

create policy "materials readable by signed-in students"
  on storage.objects for select to authenticated
  using (bucket_id = 'course-materials');

create policy "materials writable by admins"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'course-materials'
    and exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin));

create policy "materials updatable by admins"
  on storage.objects for update to authenticated
  using (bucket_id = 'course-materials'
    and exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin));

create policy "materials deletable by admins"
  on storage.objects for delete to authenticated
  using (bucket_id = 'course-materials'
    and exists (select 1 from public.students s where s.id = auth.uid() and s.is_admin));

-- No triggers and no edge functions exist in this project.
