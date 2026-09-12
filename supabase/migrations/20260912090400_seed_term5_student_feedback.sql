-- Student feedback on 6 Term 5 electives, synthesized from a WhatsApp thread among
-- Hyderabad-campus students who'd already taken these courses (2026-09-11) plus a
-- voice note transcribed and translated from Hindi/Hinglish. Anecdotal by nature --
-- two students disagree on COBE's professor -- see the column comment on
-- student_feedback. Names are left out deliberately; nothing here claims to be
-- official, unlike `brief`.

update public.course_grading_profiles p
set student_feedback = v.feedback::jsonb
from (values

  ('CDMA2', $j$[
    "Leans more into strategy in general than M&A specifically, and it's a heavy course -- expect a real workload, not something you coast through.",
    "Professor is well-regarded. One student who ranked this third on their bid list, and who'd had the same professor teach Strategy at the Mohali campus, recommends taking it."
  ]$j$),

  ('COBE', $j$[
    "Rated as very chill by most word of mouth -- only two deliverables, and the professor is easygoing. Good 'time pass' course by reputation, though not everyone found it taught them much.",
    "One student who actually took it disagreed and dropped the course, saying the professor wasn't very knowledgeable and rating it low. Worth asking around about which section/professor you'd land in, since this doesn't match the more common chill-and-easy read."
  ]$j$),

  ('MSTC', $j$[
    "Medium difficulty, and the professor is good. Essentially 'Consulting 101' -- what consulting is and how the industry is changing.",
    "Starts light/fluffy (what consulting even is, how it works), so early sessions don't tell you much about the rest of the term.",
    "Includes a live project with a real founder -- could go either way, but sounded fine to the students who'd started it.",
    "Coursework is light: two assignments, one group live project, and a few quizzes.",
    "Some call it a time-pass course, and separately, students who'd taken a past simulation-style course from the same professor came away impressed with their teaching."
  ]$j$),

  ('SMTD', $j$[
    "Enrollment is on the lower side (roughly 30 students), so there's less feedback circulating on it than the more popular electives.",
    "Word of mouth is that it tends to draw students with a CA/CFA background -- worth weighing against your own comfort with the quant side before bidding."
  ]$j$),

  ('STAR', $j$[
    "Enrollment is on the lower side (roughly 30 students), so there's less feedback circulating on it than the more popular electives.",
    "Word of mouth is that it tends to draw students with a CA/CFA background -- worth weighing against your own comfort with the quant side before bidding."
  ]$j$),

  ('PEVF', $j$[
    "Course content is supposed to be good, but the professor isn't well-rated. One student considered bidding for it and skipped it, partly for that reason."
  ]$j$)

) as v(code, feedback)
join public.courses c on c.code = v.code and c.term = 'Term 5'
where p.course_id = c.id;
