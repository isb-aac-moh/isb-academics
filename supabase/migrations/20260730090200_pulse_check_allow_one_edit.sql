-- Relaxes pulse_check_submissions from fully immutable to "editable exactly
-- once" — Eshan's call, made with the original immutability tradeoffs already
-- in view (see docs/DATA_MODEL.md's pulse_check_submissions section). The
-- one-edit cap is enforced here at the RLS layer, not just in the UI: the
-- `edited` flag can only ever flip false -> true, and once true no further
-- update policy matches, so a second edit attempt is denied by Postgres
-- itself, the same way a delete/update was denied entirely before this.

alter table public.pulse_check_submissions
  add column if not exists edited boolean not null default false;

-- Insert must always start unedited — defense in depth, since the column
-- default already guarantees this unless a client explicitly overrides it.
drop policy if exists "own pulse submission insertable before cutoff" on public.pulse_check_submissions;
create policy "own pulse submission insertable before cutoff" on public.pulse_check_submissions
  for insert with check (
    auth.uid() = user_id
    and edited = false
    and now() < (select pulse_check_cutoff from public.app_settings where id = true)
  );

-- `using` gates which existing rows are eligible to update (own row, not
-- already edited, still before cutoff); `with check` gates what the updated
-- row is allowed to look like (still own row, edited flipped to true, still
-- before cutoff). A second update attempt fails `using` because `edited` is
-- already true on the existing row — there is no policy that permits it.
drop policy if exists "own pulse submission editable once before cutoff" on public.pulse_check_submissions;
create policy "own pulse submission editable once before cutoff" on public.pulse_check_submissions
  for update
  using (
    auth.uid() = user_id
    and not edited
    and now() < (select pulse_check_cutoff from public.app_settings where id = true)
  )
  with check (
    auth.uid() = user_id
    and edited = true
    and now() < (select pulse_check_cutoff from public.app_settings where id = true)
  );
