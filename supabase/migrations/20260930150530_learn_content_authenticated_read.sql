-- Learn content was readable by anyone holding the public anon key, signed in or not. The original
-- policies used `for select using (true)` with no role, which means {public}. Restrict reads of the
-- seven content tables to signed-in users. Admin write policies and the per-user tables
-- (learn_profiles, learn_attempts, learn_topic_mastery) are already correct and are not touched.
-- Checked before writing: nothing reads these tables while logged out (Login, the homepage demo
-- mode, isb-explorer, mktg-rep, pulse-bot).

drop policy if exists "learn courses readable by all"         on public.learn_courses;
drop policy if exists "learn scenarios readable by all"       on public.learn_scenarios;
drop policy if exists "learn questions readable by all"       on public.learn_questions;
drop policy if exists "learn concepts readable by all"        on public.learn_concepts;
drop policy if exists "learn session content readable by all" on public.learn_session_content;
drop policy if exists "learn course content readable by all"  on public.learn_course_content;
drop policy if exists "learn materials readable by all"       on public.learn_materials;

create policy "learn courses readable by signed-in users"         on public.learn_courses         for select to authenticated using (true);
create policy "learn scenarios readable by signed-in users"       on public.learn_scenarios       for select to authenticated using (true);
create policy "learn questions readable by signed-in users"       on public.learn_questions       for select to authenticated using (true);
create policy "learn concepts readable by signed-in users"        on public.learn_concepts        for select to authenticated using (true);
create policy "learn session content readable by signed-in users" on public.learn_session_content for select to authenticated using (true);
create policy "learn course content readable by signed-in users"  on public.learn_course_content  for select to authenticated using (true);
create policy "learn materials readable by signed-in users"       on public.learn_materials       for select to authenticated using (true);
