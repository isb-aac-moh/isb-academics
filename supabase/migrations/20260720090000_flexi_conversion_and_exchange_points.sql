-- Two corrections sourced from ISB's official "Programme Structure_2026-27" and
-- "Flexi Core Courses" docs, read directly for the first time in this session:
--
-- 1. Flexi Core courses (Term 2/3) do NOT count toward elective/concentration
--    credit by default. Only if a student picks a 3rd course beyond the
--    required 2 is that extra one mandatorily converted into an elective —
--    that conversion is what counts toward the 18 elective credits (and,
--    separately, may count toward a concentration). completed_term2_flexi /
--    completed_term3_flexi already track *which courses were taken*; these
--    new columns track *which one (if any) was the mandatory conversion*,
--    since that's the only one credit math should count.
--
-- 2. Bid points are one shared 4,500-point pool across regular elective
--    bidding AND International/Inter-Campus Exchange (FAQ Q4, Exchange PPT).
--    Exchange bidding isn't modeled as a full flow yet (ROADMAP), but AAC
--    asked to at least self-report points already spent there so the budget
--    ledger stays accurate — some students have already bid before Term 4
--    bidding opens.

alter table public.student_academic_profiles
  add column if not exists term2_converted_elective text,
  add column if not exists term3_converted_elective text,
  add column if not exists international_exchange_points_used integer,
  add column if not exists inter_campus_exchange_points_used integer;
