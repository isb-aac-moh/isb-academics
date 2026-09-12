-- Term 5 group / peer-evaluation / attendance facts, read off the official
-- 2026-27 course outlines (ISB SharePoint, PGP_Mohali/2026-2027/Course_Outlines/
-- Term 5) on 2026-09-12 -- the same PDFs the grading profiles themselves came from.
--
-- Nulls are deliberate and mean "the outline does not say": group_formation is
-- stated in only 6 of 17 outlines, cross_section in 12, and MSTC/NSDL carry no
-- Group Information table at all. Guessing would make the dossier's filters lie.
--
-- attendance buckets:
--   'Not mandatory'            -- outline explicitly waives attendance
--   'ISB policy'               -- standard policy only (a missed session already
--                                 costs a letter grade under that policy)
--   'Participation-linked'     -- attendance/punctuality directly feeds graded points
--   'Stricter than ISB policy' -- course adds penalties of its own
--
-- Depends on the Term 5 grading profile rows existing (20260911123542). This is an
-- UPDATE, so it is a harmless no-op for any course whose profile isn't seeded yet.

update public.course_grading_profiles g
set group_size = v.group_size,
    cross_section = v.cross_section,
    group_formation = v.group_formation,
    peer_eval = v.peer_eval,
    attendance = v.attendance
from (values
  ('ABTE',  '4-5',                     null::boolean, null,                  false, 'ISB policy'),
  ('BVFS',  'Up to 5',                 false,         'Self-select',         false, 'Not mandatory'),
  ('CDMA2', 'Up to 3',                 false,         'Self-select',         false, 'Not mandatory'),
  ('COBE',  '5',                       false,         null,                  false, 'ISB policy'),
  ('DTME1', '5-6',                     null,          null,                  false, 'ISB policy'),
  ('ENVC',  '4-5',                     null,          'Self-select',         true,  'ISB policy'),
  ('LOES',  '3-5',                     false,         null,                  true,  'Participation-linked'),
  ('LWPM',  'Announced after bidding', false,         'Self-select',         false, 'Participation-linked'),
  ('MKTS',  '5-6',                     false,         'Instructor-assigned', false, 'ISB policy'),
  ('MSTC',  null,                      null,          null,                  false, 'Stricter than ISB policy'),
  ('MTCC',  '5',                       true,          null,                  true,  'ISB policy'),
  ('NEGA1', '5',                       false,         null,                  false, 'Participation-linked'),
  ('NSDL',  null,                      null,          null,                  false, 'ISB policy'),
  ('PEVF',  '3-4',                     false,         'Self-select',         false, 'Participation-linked'),
  ('RTLG',  '5-8',                     null,          null,                  false, 'ISB policy'),
  ('SMTD',  '4-6',                     false,         null,                  true,  'Not mandatory'),
  ('STAR',  '4-6',                     false,         null,                  true,  'Not mandatory')
) as v(code, group_size, cross_section, group_formation, peer_eval, attendance)
join public.courses c on c.code = v.code and c.term = 'Term 5'
where g.course_id = c.id;
