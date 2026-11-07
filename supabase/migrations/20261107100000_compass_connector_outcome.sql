-- Miss log: record whether each connector search found a confirmed answer, only the closest cards, or nothing,
-- and how many other phrasings Claude tried. Old rows stay empty. No new table, so the token block needs no change.
alter table public.compass_connector_log
  add column outcome text check (outcome in ('good', 'closest', 'none')),
  add column phrasings int not null default 0;
