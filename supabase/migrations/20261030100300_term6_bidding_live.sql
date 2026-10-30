-- Opens the Term 6 bidding round. This is what the Admin -> Overview "Live bidding
-- round" chips do: it turns on the Planner's "Live now" section and Your Term step and
-- opens Bidding Pulse for Term 6. Term 5 comes off because its round is over (the term
-- started 2026-10-19), which also stops Pulse accepting new Term 5 submissions.
-- Reversible from the same chips.

update public.app_settings
set live_bidding_terms = array['Term 6'], updated_at = now()
where id = true;

insert into public.dashboard_popups
  (slug, enabled, title, body, icon, page, frequency, primary_label, primary_action, primary_target, secondary_label)
values
  ('term6_bidding', true, 'Term 6 bidding is open',
   'Plan your Term 6 bids in the Planner. The Term 6 Dossier has every elective''s grading split, exams, groups, workload and faculty in one place.',
   null, '/tracker', 'once', 'Open the Planner', 'internal', '/planner', 'Later')
on conflict (slug) do update set enabled = excluded.enabled, title = excluded.title, body = excluded.body,
  page = excluded.page, frequency = excluded.frequency, primary_label = excluded.primary_label,
  primary_action = excluded.primary_action, primary_target = excluded.primary_target,
  secondary_label = excluded.secondary_label, updated_at = now();
