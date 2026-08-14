-- Applied against production separately, after verification showed anon could still execute
-- the three learn_admin_* RPCs despite the revoke in 20260814090000.
--
-- Cause: `revoke all ... from public` does not remove the explicit execute grant that
-- Supabase's default privileges give `anon` at function creation time. The functions did
-- still fail closed — auth.uid() is null for anon, so the admin check raises 42501 — but the
-- point of the revoke is not to depend on that.
--
-- 20260814090000 has since been corrected to revoke from `public, anon` directly, so this
-- file is a no-op on a fresh database and exists to keep the local history matching what was
-- actually run against production. Revokes are idempotent.

revoke all on function public.learn_admin_cohort_stats()      from anon;
revoke all on function public.learn_admin_topic_stats()       from anon;
revoke all on function public.learn_admin_flagged_questions() from anon;
