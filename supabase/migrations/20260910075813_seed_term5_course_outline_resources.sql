-- Term 5 course outline resources, sourced from ISB's official ASA SharePoint
-- site (CourseDetails/.../Course_Outlines/Term 5), same source and pattern as
-- 20260803154011_seed_term4_course_outlines.sql for Term 4.
--
-- All 17 Term 5 electives have an outline uploaded as of this migration.
-- Depends on 20260910075812_term5_catalog_correction.sql running first
-- (adds the MKTS row this migration joins against).
--
-- on conflict guard added per resources_course_id_url_unique (see
-- 20260727090000_resources_course_url_unique.sql) so a re-run doesn't
-- duplicate rows.

insert into public.resources (title, url, description, resource_type, term, course_id)
select c.name || ' — Course Outline', v.url, 'Official ISB course outline, 2026-27.', 'Course Outline', c.term, c.id
from (values
  ('ABTE', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/ABTE_275.pdf'),
  ('BVFS', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/BVFS_275.pdf'),
  ('CDMA2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/CDMA_275.pdf'),
  ('COBE', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/COBE_275.pdf'),
  ('DTME1', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/DTME_275.pdf'),
  ('ENVC', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/ENVC_275.pdf'),
  ('LOES', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/LOES_275.pdf'),
  ('LWPM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/LWPM_275.pdf'),
  ('MKTS', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/MKTS_275.pdf'),
  ('MSTC', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/MSTC_275.pdf'),
  ('MTCC', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/MTCC_275.pdf'),
  ('NEGA1', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/NEGA_275.pdf'),
  ('NSDL', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/NSDL_275.pdf'),
  ('PEVF', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/PEVF_275.pdf'),
  ('RTLG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/RTLG_275.pdf'),
  ('SMTD', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/SMTD_275.pdf'),
  ('STAR', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 5/STAR_275.pdf')
) as v(code, url)
join public.courses c on c.code = v.code and c.term = 'Term 5'
on conflict (course_id, url) do nothing;
