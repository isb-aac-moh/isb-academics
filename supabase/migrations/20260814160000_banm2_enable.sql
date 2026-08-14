-- Release BANM2 to students.
--
-- 20260814150100 held it back because the content was in the database before the code that
-- renders it. That code is now on main and live (merge a759bd7), verified on production:
-- the question bank renders, no practice CTAs appear in the course, and Smart Practice
-- leaves it out of the picker.

update public.learn_courses set enabled = true where course_code = 'BANM2';
