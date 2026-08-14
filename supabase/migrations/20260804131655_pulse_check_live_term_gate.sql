-- Replaces the cutoff-based RLS gate with a live-term-based one. The
-- pulse_check_cutoff column required someone to remember a second value in
-- sync with the Live Bidding Round toggle every time a term/Block Week went
-- live — it silently went stale (still pointing at an old round) the moment
-- Term 4 was marked live on 2026-08-03, and Postgres rejected every insert
-- with a 403 as a result, even after the app UI itself was fixed to stop
-- checking it. Submissions are now gated purely on the submission's own
-- `term` being present in app_settings.live_bidding_terms — the same signal
-- the UI already uses to decide which terms to show, so there's nothing
-- left to fall out of sync.

drop policy if exists "own pulse submission insertable before cutoff" on public.pulse_check_submissions;
create policy "own pulse submission insertable while term live" on public.pulse_check_submissions
  for insert with check (
    auth.uid() = user_id
    and edited = false
    and term in (select unnest(live_bidding_terms) from public.app_settings where id = true)
  );

drop policy if exists "own pulse submission editable once before cutoff" on public.pulse_check_submissions;
create policy "own pulse submission editable once while term live" on public.pulse_check_submissions
  for update
  using (
    auth.uid() = user_id
    and not edited
    and term in (select unnest(live_bidding_terms) from public.app_settings where id = true)
  )
  with check (
    auth.uid() = user_id
    and edited = true
    and term in (select unnest(live_bidding_terms) from public.app_settings where id = true)
  );
