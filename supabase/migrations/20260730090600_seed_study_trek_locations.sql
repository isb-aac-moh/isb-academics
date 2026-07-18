-- Each SEED1/2/3 Study Trek section travels to a different place, per
-- Eshan directly (not inferred from the outline PDFs) — appending it to the
-- course name so the three sections read as obviously distinct wherever
-- `courses.name` is shown (Pulse Check cards, dropdowns, Bidding Planner),
-- not just via the professor field.
update public.courses set name = name || ' — Sikkim' where code = 'SEED1';
update public.courses set name = name || ' — Tamil Nadu' where code = 'SEED2';
update public.courses set name = name || ' — Madhya Pradesh' where code = 'SEED3';
