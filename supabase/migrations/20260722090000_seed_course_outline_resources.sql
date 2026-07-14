-- Course outline resources for Term 1-3 and Block Weeks 1-2, sourced from ISB's
-- official ASA SharePoint site (CourseDetails/.../Course_Outlines), per Eshan's
-- explicit preference for the ASA source over his personal OneDrive mirror.
-- Populates the existing "Course Outline" resource type so the redirect link
-- already built into "Your Plan" (StepPlan.tsx) lights up automatically.
--
-- NOTE: file access was verified via an M365 connector authenticated as Eshan
-- (ASA/Council member). Whether a regular student login can open these same
-- links has not been independently verified — worth a spot-check before
-- treating this as fully trustworthy for the whole cohort (see ROADMAP).

insert into public.resources (title, url, description, resource_type, term, course_id)
select c.name || ' — Course Outline', v.url, 'Official ISB course outline, 2026-27.', 'Course Outline', c.term, c.id
from (values
  -- Term 1 (core)
  ('FADM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 1/FADM_271.pdf'),
  ('LSAT', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 1/LSAT_271.pdf'),
  ('MGEC', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 1/MGEC3_271.pdf'),
  ('MVCM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 1/MVCM_271.pdf'),
  ('SMDM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 1/SMDM3_271.pdf'),
  ('SMDM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 1/SMDM4_271.pdf'),
  ('WACM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 1/WACM_271.pdf'),
  -- Term 2 (core + Flexi Core)
  ('FCRV', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 2/FCRV_272.pdf'),
  ('STRG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 2/STRG3_272.pdf'),
  ('STRG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 2/STRG4_272.pdf'),
  ('BSNS2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 2/BSNS_272.pdf'),
  ('FRNT3', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 2/FRNT_272.pdf'),
  ('NMEU2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 2/NMEU_272.pdf'),
  -- Term 3 (core + Flexi Core)
  ('MKTG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 3/MKTG_273.pdf'),
  ('MKTG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 3/MKTG_273_Course_Outline_Prof_Shubhranshu_Singh.pdf'),
  ('OPMG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 3/OPMG_273.pdf'),
  ('ASMD2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 3/ASMD_273.pdf'),
  ('BACF2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 3/BACF_273.pdf'),
  ('BANM2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 3/BANM_273.pdf'),
  -- Note: BATM (Business Analytics for Technology Management) was discontinued by
  -- ISB mid-build (see drop_batm_course.sql) and no longer exists as a course row.
  ('MADM2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 3/MADM_273.pdf'),
  ('PADM2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Term 3/PADM_273.pdf'),
  -- Block Week 1
  ('CERP', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 1/CERP_BW1.pdf'),
  ('HCEN', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 1/HCEN_BW1.pdf'),
  ('LGTM', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 1/LGTM_BW1.pdf'),
  ('MPSB', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 1/MPSB_BW1.pdf'),
  ('MSDG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 1/MSDG_BW1.pdf'),
  ('MTOG', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 1/MTOG_BW1.pdf'),
  ('PFCA', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 1/PFCA_BW1.pdf'),
  ('TISE', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 1/TISE_BW1.pdf'),
  -- Block Week 2
  ('AIMO', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/AIMO_BW2.pdf'),
  ('DIPP', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/DIPP_BW2.pdf'),
  ('DPI2', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/DPI 2.0_BW2.pdf'),
  ('DTSC', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/DTSC_BW2.pdf'),
  ('FRDI', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/FRDI_BW2.pdf'),
  ('IESB', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/IESB_BW2.pdf'),
  ('LDEL', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/LDEL_BW2.pdf'),
  ('MPAI', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/MPAI_BW2.pdf'),
  ('SEED', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/SEED1_BW2.pdf'),
  ('SEED', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/SEED2_BW2.pdf'),
  ('SEED', 'https://isbhydmoh.sharepoint.com/sites/CourseDetails/Shared Documents/General/PGP_Mohali/2026-2027/Course_Outlines/Block Week 2/SEED3_BW2.pdf')
) as v(code, url)
join public.courses c on c.code = v.code;
