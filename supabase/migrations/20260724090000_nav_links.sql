-- Admin-managed "extra" nav links (Eshan's spec): rendered as their own
-- section below the locked core pages in the sidebar (Bidding Planner /
-- Course Resources / Notice Board stay hardcoded). Lets admins spotlight
-- time-sensitive links — like the Custom GPT tool — without a code change.
create table if not exists public.nav_links (
  id uuid primary key default gen_random_uuid(),
  label text not null,
  icon text not null,
  link_type text not null check (link_type in ('internal', 'external')),
  href text not null,
  visibility text not null default 'everyone' check (visibility in ('everyone', 'admin')),
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

alter table public.nav_links enable row level security;

drop policy if exists "nav links readable by all" on public.nav_links;
create policy "nav links readable by all" on public.nav_links for select using (true);

drop policy if exists "admins can write nav links" on public.nav_links;
create policy "admins can write nav links" on public.nav_links
  for all using (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin))
  with check (exists (select 1 from public.users u where u.id = auth.uid() and u.is_admin));

-- Migrate the hardcoded Custom GPT link (Sidebar.tsx) into the new system so
-- it's editable from the admin page immediately.
insert into public.nav_links (label, icon, link_type, href, visibility, sort_order)
values (
  'Custom GPT- Elective Bidding Assistant',
  'Bot',
  'external',
  'https://chatgpt.com/g/g-6a569adeb170819197aa7ee8c12b2c71-isb-elective-bidding-assistant',
  'everyone',
  0
);
