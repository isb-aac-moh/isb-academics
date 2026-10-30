-- Term 6 course outline resources, sourced from ISB's official ASA SharePoint site
-- (CourseDetails/.../Course_Outlines/Term 6), same pattern as
-- 20260910075813_seed_term5_course_outline_resources.sql. All 21 Term 6 electives have
-- an outline as of 2026-10-30. Two filenames are irregular upstream: CTFI is uploaded as
-- CTFI_267.pdf and NEGA2 as "NEGA 2_276.pdf"; the links keep them as published.
-- The leftover CMGT_276.pdf is not linked, since CMGT is no longer in the lineup.

insert into public.resources (title, url, description, resource_type, term, course_id)
select c.name || ' — Course Outline', v.url, 'Official ISB course outline, 2026-27.', 'Course Outline', c.term, c.id
from (values
  ('AMCS', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/AMCS_276.pdf'),
  ('ARDA', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/ARDA_276.pdf'),
  ('BPEX', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/BPEX_276.pdf'),
  ('CEOP', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/CEOP_276.pdf'),
  ('COEN', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/COEN_276.pdf'),
  ('CTFI', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/CTFI_267.pdf'),
  ('DMKT', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/DMKT_276.pdf'),
  ('FINB', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/FINB_276.pdf'),
  ('IDTF', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/IDTF_276.pdf'),
  ('MCAP', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/MCAP_276.pdf'),
  ('MKSV', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/MKSV_276.pdf'),
  ('MSDW', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/MSDW_276.pdf'),
  ('NEGA2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/NEGA 2_276.pdf'),
  ('PMGT', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/PMGT_276.pdf'),
  ('RDFV', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/RDFV_276.pdf'),
  ('REMA', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/REMA_276.pdf'),
  ('RMPL', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/RMPL_276.pdf'),
  ('STRI', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/STRI_276.pdf'),
  ('TAAM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/TAAM_276.pdf'),
  ('TATU', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/TATU_276.pdf'),
  ('TSFL', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 6/TSFL_276.pdf')
) as v(code, url)
join public.courses c on c.code = v.code and c.term = 'Term 6'
on conflict (course_id, url) do nothing;

-- Surface the Term 6 Dossier next to the Term 5 one in Platform Directory.
insert into public.resources (title, url, resource_type)
values ('Term 6 Dossier', '/dossier/term-6', 'Platform Directory');
