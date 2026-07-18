-- The "Sustainable Empowerment through Emerging Digitization (Study Trek)"
-- course (code SEED, Block Week 2) was seeded as ONE row with all three
-- faculty jammed into a single professor string: "Ashwini Chhatre /
-- Sabareesh Ramachandran / Debolina Dutta". Per ISB's own bidding rule
-- ("Faculty-Course Combination: each offering is tagged to a specific
-- faculty and course for bidding purposes" — Bidding Session Summary), these
-- are three separately-bid sections, not one course — and the resources
-- table already independently holds three distinct outline PDFs for it
-- (SEED1/SEED2/SEED3_BW2.pdf), confirming ISB itself treats this as three
-- offerings. Collapsing them into one row means Pulse Check submissions for
-- three different sections were blending into a single histogram card.
--
-- This splits the merged row into three real course rows, one per
-- professor, and reassigns each existing outline PDF to its own new row.
--
-- ASSUMPTION WORTH SPOT-CHECKING: the PDF numbering (SEED1/2/3) is mapped
-- to professors in the same left-to-right order as the original combined
-- string (1=Chhatre, 2=Ramachandran, 3=Dutta). That's a reasonable
-- inference, not a verified fact — nothing in the filenames themselves
-- names the professor. Worth opening the three PDFs to confirm before
-- treating this mapping as authoritative.
do $$
declare
  seed2_id uuid;
  seed3_id uuid;
begin
  -- The existing row keeps its id (so anything already referencing it, e.g.
  -- SEED1_BW2.pdf's resource row, stays correctly attached with no update
  -- needed) and becomes section 1.
  update public.courses
  set code = 'SEED1', professor = 'Ashwini Chhatre'
  where id = '1e9a72db-9eae-4398-b284-82f45b446b06';

  insert into public.courses
    (code, name, professor, term, credits, concentration_areas, industry_specializations, is_strategy_ob_course, prerequisite_course_ids, is_active, is_core)
  values
    ('SEED2', 'Sustainable Empowerment through Emerging Digitization (Study Trek)', 'Sabareesh Ramachandran', 'Block Week 2', 1, array['Information Technology Management'], array['Public Policy'], false, array[]::uuid[], true, false)
  returning id into seed2_id;

  insert into public.courses
    (code, name, professor, term, credits, concentration_areas, industry_specializations, is_strategy_ob_course, prerequisite_course_ids, is_active, is_core)
  values
    ('SEED3', 'Sustainable Empowerment through Emerging Digitization (Study Trek)', 'Debolina Dutta', 'Block Week 2', 1, array['Information Technology Management'], array['Public Policy'], false, array[]::uuid[], true, false)
  returning id into seed3_id;

  update public.resources set course_id = seed2_id
  where course_id = '1e9a72db-9eae-4398-b284-82f45b446b06' and url like '%SEED2_BW2.pdf';

  update public.resources set course_id = seed3_id
  where course_id = '1e9a72db-9eae-4398-b284-82f45b446b06' and url like '%SEED3_BW2.pdf';
end $$;
