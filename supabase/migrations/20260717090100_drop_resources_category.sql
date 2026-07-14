-- resources.category is superseded by the new structured resource_type column.
-- Table is empty in production, safe to drop.
alter table public.resources drop column if exists category;
