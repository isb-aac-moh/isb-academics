-- Bring the ISB Learning Agent (formerly the standalone mktg-rep project) into this database.
--
-- Source snapshot, including the 17 original migrations this schema evolved through:
-- supabase/mktg-rep-dump/. Read that README before changing anything here.
--
-- Four decisions worth knowing:
--
-- 1. Everything is prefixed `learn_`. This database is shared with isb-explorer, and the
--    source project used names like `questions`, `concepts`, and `materials` that are far
--    too generic to sit unqualified in a shared schema. `session_content` would also read
--    as related to the existing campus-life `sessions` table, which it is not.
--
-- 2. Courses are NOT duplicated. The source project had its own `courses` table, but its
--    two rows are the same two courses already here: 'marketing'/MKTG273 is MKTG, and
--    'operations'/OPMG273 is OPMG (both Term 3, is_core). Child tables key on
--    courses(code), which is already unique and already text — so nothing has to convert
--    to uuid. `learn_courses` holds only the three columns that are about practice content
--    rather than the bidding catalogue.
--
-- 3. There is no `learn_students`. XP and streaks hang off the existing users table via
--    learn_profiles; admin rights come from users.is_admin, so the source project's
--    separate is_admin flag is dropped. One person, one row, one admin flag.
--
-- 4. learn_topic_mastery's primary key includes course_code. The source had
--    (student_id, topic), which meant two courses sharing a topic name would silently
--    overwrite one student's progress in the other. Fixed on the way in.
--
-- This migration is additive: it creates new tables and does not alter users, courses, or
-- any existing table.

begin;

-- ---------------------------------------------------------------------------
-- Per-student learning state
-- ---------------------------------------------------------------------------

create table public.learn_profiles (
  user_id          uuid primary key references public.users(id) on delete cascade,
  total_xp         integer not null default 0,
  day_streak       integer not null default 0,
  last_active_date date,
  created_at       timestamptz not null default now()
);

comment on table public.learn_profiles is 'XP, streak and last-active for the practice app. Identity, name and admin rights live on public.users.';

-- ---------------------------------------------------------------------------
-- Course-scoped content
-- ---------------------------------------------------------------------------

create table public.learn_courses (
  course_code    text primary key references public.courses(code) on update cascade on delete cascade,
  total_sessions integer not null default 0,
  enabled        boolean not null default false,
  sort_order     integer not null default 0
);

comment on table public.learn_courses is 'Which courses have practice content, and whether it is live to students. `enabled = false` shows the course as Soon/Preview rather than hiding it.';

create table public.learn_scenarios (
  id          text primary key,
  course_code text    not null references public.courses(code) on update cascade on delete cascade,
  session     integer not null,
  title       text    not null,
  setup       text    not null,
  source      text
);

create table public.learn_questions (
  id             text        primary key,
  course_code    text        not null references public.courses(code) on update cascade,
  type           text        not null,
  topic          text        not null,
  session        integer     not null,
  prompt         text        not null,
  choices        jsonb       not null,
  correct_answer text        not null,
  source         text        not null,
  explanation    text        not null default '',
  hint           text,
  scenario_id    text        references public.learn_scenarios(id) on delete set null,
  scenario_order integer,
  difficulty     integer     not null default 2,
  provenance     text        not null default 'authored',
  created_at     timestamptz not null default now(),
  constraint learn_questions_type_check       check (type = any (array['formula'::text, 'case_fact'::text])),
  constraint learn_questions_difficulty_range check (difficulty between 1 and 3),
  constraint learn_questions_provenance_valid check (provenance in ('prof_verbatim', 'prof_adapted', 'authored'))
);

comment on column public.learn_questions.hint is 'Optional nudge shown on demand during practice, before the answer is revealed.';

create table public.learn_concepts (
  course_code  text not null references public.courses(code) on update cascade,
  topic        text not null,
  title        text not null,
  note         text not null,
  resource_url text,
  primary key (course_code, topic)
);

create table public.learn_session_content (
  course_code   text    not null references public.courses(code) on update cascade,
  session       integer not null,
  title         text,
  summary       text,
  resource_url  text,
  formula_sheet text,
  updated_at    timestamptz not null default now(),
  primary key (course_code, session)
);

comment on column public.learn_session_content.formula_sheet is 'Markdown formula reference for this session, available in a drawer during practice so students apply formulas rather than memorise them.';

create table public.learn_course_content (
  course_code       text primary key references public.courses(code) on update cascade,
  outline           text,
  announcements     text,
  cheatsheet_url    text,
  exam_samples_url  text,
  feedback_form_url text,
  updated_at        timestamptz not null default now()
);

create table public.learn_materials (
  id           uuid        primary key default gen_random_uuid(),
  course_code  text        not null references public.courses(code) on update cascade on delete cascade,
  session      integer,
  title        text        not null,
  kind         text        not null default 'slides',
  storage_path text        not null,
  sort_order   integer     not null default 0,
  created_at   timestamptz not null default now()
);

comment on table  public.learn_materials         is 'Index over the course-materials storage bucket: what each uploaded file is, and where it belongs in the course.';
comment on column public.learn_materials.session is 'Null means the file belongs to the course as a whole rather than one session.';

-- ---------------------------------------------------------------------------
-- Gameplay
-- ---------------------------------------------------------------------------

create table public.learn_attempts (
  id          uuid        primary key default gen_random_uuid(),
  user_id     uuid        not null references public.users(id) on delete cascade,
  question_id text        not null references public.learn_questions(id) on delete cascade,
  correct     boolean     not null,
  created_at  timestamptz not null default now()
);

create table public.learn_topic_mastery (
  user_id             uuid    not null references public.users(id) on delete cascade,
  course_code         text    not null references public.courses(code) on update cascade on delete cascade,
  topic               text    not null,
  level               integer not null default 0,
  consecutive_correct integer not null default 0,
  total_correct       integer not null default 0,
  total_attempts      integer not null default 0,
  last_seen_at        timestamptz,
  primary key (user_id, course_code, topic),
  constraint learn_topic_mastery_level_range check (level between 0 and 4)
);

create index learn_questions_course_idx      on public.learn_questions      (course_code);
create index learn_questions_scenario_idx    on public.learn_questions      (scenario_id, scenario_order);
create index learn_scenarios_course_idx      on public.learn_scenarios      (course_code, session);
create index learn_attempts_user_idx         on public.learn_attempts       (user_id);
create index learn_attempts_question_idx     on public.learn_attempts       (question_id);
create index learn_topic_mastery_user_idx    on public.learn_topic_mastery  (user_id, course_code);
create index learn_materials_course_idx      on public.learn_materials      (course_code, session);

-- ---------------------------------------------------------------------------
-- Row level security. Content is readable by everyone signed in and writable by admins,
-- matching the courses/resources/app_settings convention already used here. Gameplay rows
-- are private to the student they belong to.
-- ---------------------------------------------------------------------------

alter table public.learn_profiles        enable row level security;
alter table public.learn_courses         enable row level security;
alter table public.learn_scenarios       enable row level security;
alter table public.learn_questions       enable row level security;
alter table public.learn_concepts        enable row level security;
alter table public.learn_session_content enable row level security;
alter table public.learn_course_content  enable row level security;
alter table public.learn_materials       enable row level security;
alter table public.learn_attempts        enable row level security;
alter table public.learn_topic_mastery   enable row level security;

create policy "learn courses readable by all"         on public.learn_courses         for select using (true);
create policy "learn scenarios readable by all"       on public.learn_scenarios       for select using (true);
create policy "learn questions readable by all"       on public.learn_questions       for select using (true);
create policy "learn concepts readable by all"        on public.learn_concepts        for select using (true);
create policy "learn session content readable by all" on public.learn_session_content for select using (true);
create policy "learn course content readable by all"  on public.learn_course_content  for select using (true);
create policy "learn materials readable by all"       on public.learn_materials       for select using (true);

create policy "admins can write learn courses"         on public.learn_courses         for all
  using (exists (select 1 from users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.is_admin));
create policy "admins can write learn scenarios"       on public.learn_scenarios       for all
  using (exists (select 1 from users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.is_admin));
create policy "admins can write learn questions"       on public.learn_questions       for all
  using (exists (select 1 from users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.is_admin));
create policy "admins can write learn concepts"        on public.learn_concepts        for all
  using (exists (select 1 from users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.is_admin));
create policy "admins can write learn session content" on public.learn_session_content for all
  using (exists (select 1 from users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.is_admin));
create policy "admins can write learn course content"  on public.learn_course_content  for all
  using (exists (select 1 from users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.is_admin));
create policy "admins can write learn materials"       on public.learn_materials       for all
  using (exists (select 1 from users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from users u where u.id = auth.uid() and u.is_admin));

-- Own-row only. A student never reads another student's XP, attempts or mastery; the
-- cohort-wide numbers admins see come from the aggregate functions below instead.
create policy "students read own learn profile"   on public.learn_profiles for select to authenticated using (user_id = auth.uid());
create policy "students create own learn profile" on public.learn_profiles for insert to authenticated with check (user_id = auth.uid());
create policy "students update own learn profile" on public.learn_profiles for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "students read own learn attempts"   on public.learn_attempts for select to authenticated using (user_id = auth.uid());
create policy "students create own learn attempts" on public.learn_attempts for insert to authenticated with check (user_id = auth.uid());

create policy "students read own learn mastery"  on public.learn_topic_mastery for select to authenticated using (user_id = auth.uid());
create policy "students write own learn mastery" on public.learn_topic_mastery for all    to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- Admin monitoring. Security-definer aggregates rather than blanket read policies, so raw
-- student rows are never exposed to the client — the same approach pulse_check uses here.
-- The revoke/grant pair matters: without it the anon role can call these, leaving the
-- internal admin check as the only guard.
-- ---------------------------------------------------------------------------

create or replace function public.learn_admin_cohort_stats()
returns table(total_students integer, active_today integer, active_this_week integer, total_answered integer, total_correct integer)
language plpgsql security definer set search_path = public stable
as $$
begin
  if not exists (select 1 from users u where u.id = auth.uid() and u.is_admin) then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
    select
      (select count(*) from public.learn_profiles)::integer,
      (select count(*) from public.learn_profiles where last_active_date = current_date)::integer,
      (select count(*) from public.learn_profiles where last_active_date >= current_date - interval '6 days')::integer,
      (select count(*) from public.learn_attempts)::integer,
      (select count(*) from public.learn_attempts where correct)::integer;
end;
$$;

create or replace function public.learn_admin_topic_stats()
returns table(topic text, total integer, accuracy numeric)
language plpgsql security definer set search_path = public stable
as $$
begin
  if not exists (select 1 from users u where u.id = auth.uid() and u.is_admin) then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
    select q.topic, count(*)::integer as total,
           (count(*) filter (where a.correct))::numeric / count(*) as accuracy
    from public.learn_attempts a
    join public.learn_questions q on q.id = a.question_id
    group by q.topic
    having count(*) >= 3
    order by 3 asc;
end;
$$;

create or replace function public.learn_admin_flagged_questions()
returns table(question_id text, prompt text, topic text, session integer, total integer, accuracy numeric)
language plpgsql security definer set search_path = public stable
as $$
begin
  if not exists (select 1 from users u where u.id = auth.uid() and u.is_admin) then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
    select q.id, q.prompt, q.topic, q.session, count(*)::integer as total,
           (count(*) filter (where a.correct))::numeric / count(*) as accuracy
    from public.learn_attempts a
    join public.learn_questions q on q.id = a.question_id
    group by q.id, q.prompt, q.topic, q.session
    having count(*) >= 3
      and ((count(*) filter (where a.correct))::numeric / count(*) < 0.4
        or (count(*) filter (where a.correct))::numeric / count(*) > 0.95)
    order by 6 asc;
end;
$$;

-- Revoking from PUBLIC is not enough on Supabase: default privileges hand `anon` its own
-- explicit execute grant when the function is created, and a PUBLIC revoke leaves that in
-- place. Verified after applying — anon must come back false here.
revoke all on function public.learn_admin_cohort_stats()      from public, anon;
revoke all on function public.learn_admin_topic_stats()       from public, anon;
revoke all on function public.learn_admin_flagged_questions() from public, anon;
grant execute on function public.learn_admin_cohort_stats()      to authenticated;
grant execute on function public.learn_admin_topic_stats()       to authenticated;
grant execute on function public.learn_admin_flagged_questions() to authenticated;

commit;

-- ---------------------------------------------------------------------------
-- Storage: private bucket for course materials. Empty at migration time, but the admin
-- upload flow depends on it existing. Reads go through signed URLs so professors' decks
-- are not on a guessable public path.
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('course-materials', 'course-materials', false, 52428800,
        array['application/pdf','application/vnd.openxmlformats-officedocument.presentationml.presentation',
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'])
on conflict (id) do nothing;

create policy "course materials readable by signed-in students"
  on storage.objects for select to authenticated
  using (bucket_id = 'course-materials');

create policy "course materials writable by admins"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'course-materials' and exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

create policy "course materials updatable by admins"
  on storage.objects for update to authenticated
  using (bucket_id = 'course-materials' and exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

create policy "course materials deletable by admins"
  on storage.objects for delete to authenticated
  using (bucket_id = 'course-materials' and exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));
