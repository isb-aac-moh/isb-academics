-- Term 6 catalog and faculty, matched to ASA's Lineup_Mohali_2026-27 page (Term 6:
-- Dec 21 2026 - Jan 31 2027), read on 2026-10-30.
--
-- The page lists 21 electives plus ELP. The database also carried CMGT, DAFN and
-- SIMT, which are not on it (DAFN and SIMT never had a professor). They are
-- soft-disabled, not deleted, same as BPEX was in 20260910075812, so anything
-- attached to them (student bid plans, ratings, the CMGT outline) is kept and the
-- courses can come back from the Courses tab if ASA restores them.

update public.courses set is_active = false
where term = 'Term 6' and code in ('CMGT', 'DAFN', 'SIMT');

-- REMA was added by the September lineup refresh without its academic area.
update public.courses set academic_area = 'OPNS' where code = 'REMA' and academic_area is null;

-- "Course Overview" videos linked from the lineup page.
update public.courses c set overview_video_url = v.url
from (values
  ('AMCS', 'https://isbhydmoh.sharepoint.com/:v:/s/CourseDetails/IQAT01WMLd9TRb7kBUljg2vxAek9SfpzeVpsrzjRJeb3OJ0?e=Zt380Q'),
  ('CEOP', 'https://isbhydmoh.sharepoint.com/:v:/s/CourseDetails/IQB-56acweXQQLiOuGxs9zzAAUR4bfHmLAYpSIBNRYccj54?e=Yvd4ri'),
  ('FINB', 'https://isbhydmoh.sharepoint.com/:v:/s/CourseDetails/IQDmvYbXbuZ8QYdN6N8PWqL3AWr8pYnPQJGsogQCMqyM9LE?e=ehKSw9'),
  ('MSDW', 'https://isbhydmoh.sharepoint.com/:v:/s/CourseDetails/IQAT5cORVtQNQZo8MRKfd4yYAQCcgia0fR-UXMSH3ftVNT0?e=DnvHOn'),
  ('REMA', 'https://isbhydmoh.sharepoint.com/:v:/s/CourseDetails/IQC8OyQXrYEmS7qkGZSosBt1AZlZP6x3_nvlEqPHzHYSLXg?e=fTmVnt'),
  ('STRI', 'https://isbhydmoh.sharepoint.com/:v:/s/CourseDetails/IQCWxeFhM2pESKf67Mu6xRxQAWW0dfIR671cc-ELz8TaVIA?e=hCKHWd'),
  ('TSFL', 'https://isbhydmoh.sharepoint.com/:v:/s/CourseDetails/IQBatef2Wx9nRIeKA_TsEMYZAVa7hFj-SZwuH1wU9Sl0Lo0?e=lW86us')
) as v(code, url)
where c.code = v.code and c.term = 'Term 6';

-- Faculty teaching Term 6 who had no profile yet. Fields come from the Atrium
-- Faculty list (sharepoint_id is the list item). Photo and bio links are the ones
-- ISB publishes there. Sandeep Rath has two list entries; 328 is the complete one.
update public.faculty set
  designation = 'Assistant Professor', faculty_type = 'Resident Faculty',
  academic_area = 'Operations Management', affiliation = 'Indian School of Business',
  bio_url = 'https://www.isb.edu/faculty-and-research/faculty-directory/sandeep-rath',
  ratings_url = 'https://isbhydmoh.sharepoint.com/teams/Atrium2/ASA/FacultyRatings/SitePages/Sandeep-Rath-Ratings.aspx',
  sharepoint_id = 328,
  profile_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/Lists/Faculty/DispForm.aspx?ID=328',
  updated_at = now()
where name = 'Sandeep Rath';

update public.faculty set
  designation = 'Founder & Managing Director', faculty_type = 'Visiting Faculty',
  academic_area = 'Marketing', affiliation = 'GROWTH CATALYSTS',
  bio_url = 'https://www.linkedin.com/in/bretstasiak/',
  photo_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/SiteAssets/BretS.jpg',
  sharepoint_id = 491,
  profile_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/Lists/Faculty/DispForm.aspx?ID=491',
  updated_at = now()
where name = 'Bret Stasiak';

update public.faculty set
  designation = 'Fintech, AI Founder', faculty_type = 'Visiting Faculty',
  academic_area = 'Finance', affiliation = 'G-Square Solutions Pvt Ltd',
  bio_url = 'https://www.linkedin.com/in/gopi-suvanam/',
  photo_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/SiteAssets/GopiK.jpg',
  sharepoint_id = 492,
  profile_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/Lists/Faculty/DispForm.aspx?ID=492',
  updated_at = now()
where name = 'Gopi Krishna Suvanam';

update public.faculty set
  designation = 'Professor', faculty_type = 'Visiting Faculty',
  academic_area = 'Operations Management', affiliation = 'David Eccles School of Business, University of Utah',
  bio_url = 'https://profiles.faculty.utah.edu/u6008135',
  photo_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/SiteAssets/NitinB.jpg',
  ratings_url = 'https://isbhydmoh.sharepoint.com/teams/Atrium2/ASA/FacultyRatings/SitePages/Nitin-Bakshi.aspx',
  sharepoint_id = 493,
  profile_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/Lists/Faculty/DispForm.aspx?ID=493',
  updated_at = now()
where name = 'Nitin Bakshi';

update public.faculty set
  designation = 'Independent Consultant', faculty_type = 'Visiting Faculty',
  academic_area = 'Operations Management', affiliation = 'Aviation | Management Consulting | Optimization & Data Sciences',
  bio_url = 'https://www.linkedin.com/in/dr-ankur-garg/',
  photo_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/SiteAssets/AnkurG.png',
  ratings_url = 'https://isbhydmoh.sharepoint.com/teams/Atrium2/ASA/FacultyRatings/SitePages/Ankur-Garg-Ratings.aspx',
  sharepoint_id = 494,
  profile_url = 'https://isbhydmoh.sharepoint.com/sites/atrium/Lists/Faculty/DispForm.aspx?ID=494',
  updated_at = now()
where name = 'Ankur Garg';

-- Sodhi's ratings link pointed at Manju Puri's page. His list entry has no current
-- ratings page, so clear the link rather than send students to someone else.
update public.faculty set ratings_url = null, updated_at = now()
where name = 'Manmohan S Sodhi' and ratings_url like '%Manju-Puri%';
