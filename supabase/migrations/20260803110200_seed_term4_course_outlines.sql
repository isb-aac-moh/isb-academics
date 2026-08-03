-- Term 4 course outline resources, sourced from ISB's official ASA SharePoint
-- site (CourseDetails/.../Course_Outlines/Term 4), same source and pattern as
-- 20260722090000_seed_course_outline_resources.sql for Term 1-3.
--
-- SUET (Sustainability and Ethics, core) and CMGT (Change Management) are not
-- included: as of this migration, no outline file exists yet in the official
-- Term 4 folder for either course — only 16 of the 18 Term 4 courses have one
-- uploaded. Add them once ISB publishes those two.
--
-- on conflict guard added per resources_course_id_url_unique (see
-- 20260727090000_resources_course_url_unique.sql) so a re-run doesn't
-- duplicate rows.

insert into public.resources (title, url, description, resource_type, term, course_id)
select c.name || ' — Course Outline', v.url, 'Official ISB course outline, 2026-27.', 'Course Outline', c.term, c.id
from (values
  ('CAMS', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/CAMS_274.pdf'),
  ('CCMA', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/CCMA_274.pdf'),
  ('ENTR', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/ENTR_274.pdf'),
  ('FSAN', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/FSAN_274.pdf'),
  ('GENAI', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/GenAI_274.pdf'),
  ('GPMK', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/GPMK_274.pdf'),
  ('GSMT', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/GSMT_274.pdf'),
  ('INEC', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/INEC_274.pdf'),
  ('INVT', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/INVT_274.pdf'),
  ('LPFW', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/LPFW_274.pdf'),
  ('LSCM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/LSCM_274.pdf'),
  ('MGSP', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/MGSP_274.pdf'),
  ('MKTR', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/MKTR_274.pdf'),
  ('OPFR', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/OPFR_274.pdf'),
  ('PRCG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/PRCG_274.pdf'),
  ('SWPM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 4/SWPM_274.pdf')
) as v(code, url)
join public.courses c on c.code = v.code and c.term = 'Term 4'
on conflict (course_id, url) do nothing;
