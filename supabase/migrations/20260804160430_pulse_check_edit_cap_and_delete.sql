-- Two changes to Pulse Check, both Eshan's call:
-- 1. Raise the edit cap from 1 to 3 — students' course preferences shift
--    enough during live bidding that a single edit was too tight. The boolean
--    `edited` flag can't count past one, so it's replaced with an integer
--    `edit_count`, still RLS-enforced the same way (`using` gates which rows
--    are still eligible to update, `with check` gates what the result can
--    look like).
-- 2. Allow removing a submission outright — a student may drop a course from
--    consideration altogether, not just re-estimate its points. No delete
--    policy existed before (Postgres RLS denies any operation with no
--    matching policy), so this is a deliberate loosening from "immutable
--    except one edit" to "removable any time while the term is live".

alter table public.pulse_check_submissions
  add column if not exists edit_count integer not null default 0;

update public.pulse_check_submissions set edit_count = 1 where edited;

alter table public.pulse_check_submissions
  add constraint pulse_check_submissions_edit_count_range check (edit_count >= 0 and edit_count <= 3);

-- Old policies reference `edited` directly, so they must go before the column
-- does — dropping the column first would fail with a dependency error.
drop policy if exists "own pulse submission insertable while term live" on public.pulse_check_submissions;
drop policy if exists "own pulse submission editable once while term live" on public.pulse_check_submissions;

alter table public.pulse_check_submissions
  drop column if exists edited;

create policy "own pulse submission insertable while term live" on public.pulse_check_submissions
  for insert with check (
    auth.uid() = user_id
    and edit_count = 0
    and term in (select unnest(live_bidding_terms) from public.app_settings where id = true)
  );

create policy "own pulse submission editable up to 3x while term live" on public.pulse_check_submissions
  for update
  using (
    auth.uid() = user_id
    and edit_count < 3
    and term in (select unnest(live_bidding_terms) from public.app_settings where id = true)
  )
  with check (
    auth.uid() = user_id
    and edit_count <= 3
    and term in (select unnest(live_bidding_terms) from public.app_settings where id = true)
  );

drop policy if exists "own pulse submission removable while term live" on public.pulse_check_submissions;
create policy "own pulse submission removable while term live" on public.pulse_check_submissions
  for delete using (
    auth.uid() = user_id
    and term in (select unnest(live_bidding_terms) from public.app_settings where id = true)
  );
