-- Term 4 Dossier and Term 4 Bidding Q&A were hardcoded sidebar items
-- (Sidebar.tsx). Removed from the rail to fight nav crowding — mirrored here
-- into Platform Directory on Course Resources so they aren't lost, same
-- pattern NavLinksAdmin already uses when an admin-added nav link is removed.
insert into public.resources (title, url, resource_type)
values
  ('Term 4 Dossier', '/term4', 'Platform Directory'),
  ('Term 4 Bidding Q&A', '/term4-bidding-qa', 'Platform Directory');
