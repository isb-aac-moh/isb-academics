-- Recovered from supabase_migrations.schema_migrations on 2026-08-14. This ran against the
-- database but was never checked in, which is why `supabase db push` could not see it.
--
-- It is the first run of the Term 4 course-outline seed. 20260803154011 re-ran the same 16
-- courses later the same day; both are idempotent through `on conflict (course_id, url) do
-- nothing`, so this one is effectively superseded and is kept only to complete the history.

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
join public.courses c on c.code = v.code
on conflict (course_id, url) do nothing;
