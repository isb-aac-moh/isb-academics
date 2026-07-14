-- Mandatory core courses (Term 1-4), from Core_Courses_2026-27.pdf. These carry
-- no concentration/specialization tags, so they're invisible to Bidding Planner's
-- area-matching (core courses aren't bid on and don't count toward the 18 elective
-- credits) — they only exist here for the Course Resources catalog.

alter table public.courses add column if not exists is_core boolean not null default false;

-- credits was integer-only; WACM (0.6) and MVCM (0.4) need fractional credits.
alter table public.courses alter column credits type numeric using credits::numeric;

insert into public.courses (code, name, professor, term, credits, is_core, concentration_areas, industry_specializations) values
('FADM', 'Financial Accounting in Decision Making', 'TBD', 'Term 1', 1, true, array[]::text[], array[]::text[]),
('MGEC', 'Managerial Economics', 'TBD', 'Term 1', 1, true, array[]::text[], array[]::text[]),
('LSAT', 'Leading Self and Teams', 'TBD', 'Term 1', 1, true, array[]::text[], array[]::text[]),
('SMDM', 'Statistical Methods for Business Decision Making', 'TBD', 'Term 1', 1, true, array[]::text[], array[]::text[]),
('WACM', 'Written Analysis and Communication', 'TBD', 'Term 1', 0.6, true, array[]::text[], array[]::text[]),
('MVCM', 'Mastering Verbal Communication', 'TBD', 'Term 1', 0.4, true, array[]::text[], array[]::text[]),
('FCRV', 'Foundations of Finance: Opportunity Cost, Risk and Valuation', 'TBD', 'Term 2', 1, true, array[]::text[], array[]::text[]),
('STRG', 'Strategy', 'TBD', 'Term 2', 1, true, array[]::text[], array[]::text[]),
('MKTG', 'Marketing Management', 'TBD', 'Term 3', 1, true, array[]::text[], array[]::text[]),
('OPMG', 'Operations Management', 'TBD', 'Term 3', 1, true, array[]::text[], array[]::text[]),
('SUET', 'Sustainability and Ethics', 'TBD', 'Term 4', 1, true, array[]::text[], array[]::text[])
on conflict (code) do update set is_core = true;
