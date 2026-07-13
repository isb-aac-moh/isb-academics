-- PLACEHOLDER course data — for UI testing only, until the real 2026-27 course
-- catalog + concentration/specialization mapping arrives. Every row is prefixed
-- "[PLACEHOLDER]" so it's impossible to mistake for real data. Delete this file's
-- effect (or just delete the rows) once real courses are loaded via the admin page.

insert into public.courses (code, name, professor, term, credits, concentration_areas, industry_specializations, is_strategy_ob_course)
values
  ('FIN-X', '[PLACEHOLDER] Advanced Corporate Finance', 'TBD', 'Term 4', 1, array['Finance'], array[]::text[], false),
  ('MKT-X', '[PLACEHOLDER] Digital Marketing Strategy', 'TBD', 'Term 4', 1, array['Marketing'], array[]::text[], false),
  ('OPS-X', '[PLACEHOLDER] Supply Chain Analytics', 'TBD', 'Term 4', 1, array['Operations Management'], array['Manufacturing'], false),
  ('ENTR', '[PLACEHOLDER] Entrepreneurship (mandatory for ENTR concentration)', 'TBD', 'Term 4', 1, array['Entrepreneurship'], array[]::text[], false),
  ('STLD-X', '[PLACEHOLDER] Corporate Strategy and Organization Design', 'TBD', 'Term 5', 1, array['Strategy and Leadership'], array[]::text[], false),
  ('OB-X', '[PLACEHOLDER] Organizational Behavior Elective', 'TBD', 'Term 5', 1, array['Strategy and Leadership'], array[]::text[], true),
  ('ITM-X', '[PLACEHOLDER] IT Strategy for Managers', 'TBD', 'Term 5', 1, array['Information Technology Management'], array[]::text[], false),
  ('HC-X', '[PLACEHOLDER] Healthcare Management Fundamentals', 'TBD', 'Block Week 1', 1, array[]::text[], array['Healthcare'], false),
  ('PP-X', '[PLACEHOLDER] Public Policy and Regulation', 'TBD', 'Block Week 2', 1, array[]::text[], array['Public Policy'], false),
  ('DTME', '[PLACEHOLDER] DTME (2-credit, Manufacturing specialization)', 'TBD', 'Term 4', 2, array[]::text[], array['Manufacturing'], false)
on conflict do nothing;
