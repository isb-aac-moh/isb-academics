-- learn_admin_topic_stats() grouped by q.topic alone, across every course at once.
--
-- Topic names are only unique within a course. learn_questions is keyed on (course_code, topic)
-- and learn_topic_mastery's primary key was widened to include course_code for exactly this
-- reason, but this function threw the course away and grouped on the bare name -- so two courses
-- using the same topic name would report as one merged row, with the cohort accuracy of neither.
--
-- Nothing collides today (MKTG/OPMG use unprefixed names, BANM2 prefixes with bamg_), so this is a
-- correctness fix ahead of the next course rather than a repair of visibly wrong numbers.
--
-- The return type changes, so the function has to be dropped rather than replaced.

begin;

drop function if exists public.learn_admin_topic_stats();

create function public.learn_admin_topic_stats()
returns table(course_code text, topic text, total integer, accuracy numeric)
language plpgsql security definer set search_path = public stable
as $$
begin
  if not exists (select 1 from users u where u.id = auth.uid() and u.is_admin) then
    raise exception 'not authorized' using errcode = '42501';
  end if;

  return query
    select q.course_code, q.topic, count(*)::integer as total,
           (count(*) filter (where a.correct))::numeric / count(*) as accuracy
    from public.learn_attempts a
    join public.learn_questions q on q.id = a.question_id
    group by q.course_code, q.topic
    having count(*) >= 3
    order by 4 asc;
end;
$$;

-- Same grant posture as the original: admins only, and never anon.
revoke all on function public.learn_admin_topic_stats() from public, anon;
grant execute on function public.learn_admin_topic_stats() to authenticated;

commit;
