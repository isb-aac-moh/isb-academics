-- Business Analytics for Technology Management was dropped this year — not enough
-- student interest for the faculty to offer it. Remove the placeholder row and
-- scrub it from any profile that may have already selected it.

update public.student_academic_profiles
set completed_term3_flexi = array_remove(completed_term3_flexi, 'BATM_TBD');

delete from public.courses where code = 'BATM_TBD';
