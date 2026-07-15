-- Two independent pin flags on resources (Eshan's spec):
-- `pinned` sorts a resource first within its own section/tab (a course's
-- "Other" tab, or the General Resources section).
-- `pinned_global` surfaces a resource in a sticky banner at the top of the
-- Course Resources page regardless of whatever filters are active.
alter table resources
  add column pinned boolean not null default false,
  add column pinned_global boolean not null default false;
