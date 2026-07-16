-- 20260724090000_nav_links.sql seeds one row with an unconditional insert (no
-- on-conflict guard). It had already been applied by hand once, but Supabase
-- CLI's own migration-tracking table never recorded that, so a later
-- `supabase db push` re-ran it and inserted a duplicate. Add a uniqueness
-- constraint so a stray re-run fails loudly instead of duplicating the row.
alter table public.nav_links
  add constraint nav_links_href_unique unique (href);
