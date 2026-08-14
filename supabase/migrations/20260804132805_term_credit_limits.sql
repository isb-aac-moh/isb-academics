-- Makes ISB's per-term elective credit min/max (previously the hardcoded
-- TERM_CREDIT_LIMITS constant in creditProgress.ts) admin-editable, the same
-- way live_bidding_terms already is — these limits come from ISB's own
-- bidding rules and can change term to term without needing a code change
-- + redeploy. Seeded with the exact values the constant already had, so
-- this is a storage change, not a data change.
alter table public.app_settings
  add column if not exists term_credit_limits jsonb not null default '{
    "Term 4": {"min": 3, "max": 4},
    "Term 5": {"min": 3, "max": 5},
    "Term 6": {"min": 3, "max": 4},
    "Term 7": {"min": 3, "max": 5},
    "Block Week 1": {"min": 0, "max": 1},
    "Block Week 2": {"min": 0, "max": 1},
    "Block Week 3": {"min": 0, "max": 1},
    "Block Week 4": {"min": 0, "max": 1}
  }'::jsonb;
