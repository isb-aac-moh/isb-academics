-- Extends the pulse-check aggregate from a single median to a 5-number
-- summary (min, P25, median, P75, max). Product feedback: in a second-price
-- auction the number that matters is the shape of the distribution — a
-- median hides exactly the spread a student needs to see (e.g. one bid of
-- 1000 against ten bids of 200 clears near 200, not the average). The same
-- >=5 respondent threshold still gates the whole summary — min/max are
-- always real submitted values regardless of N, so that threshold was never
-- protecting against "order statistics reveal a real number," only against a
-- 1-2 person sample dominating the read. Showing more of the same
-- already-partially-exposed shape at the same N isn't a new exposure.
--
-- CREATE OR REPLACE can't change a function's return columns, so this drops
-- and recreates the function — re-declaring the anon-revoke from the prior
-- fix migration inline this time, since DROP FUNCTION also drops its grants.
drop function if exists public.pulse_check_results_by_term(text);

create function public.pulse_check_results_by_term(p_term text)
returns table(
  course_id uuid,
  respondent_count integer,
  min_points numeric,
  p25_points numeric,
  median_points numeric,
  p75_points numeric,
  max_points numeric
)
language sql
security definer
set search_path = public
stable
as $$
  select
    s.course_id,
    count(*)::integer as respondent_count,
    case when count(*) >= 5 then min(s.bid_points_estimate) else null end as min_points,
    case when count(*) >= 5 then percentile_cont(0.25) within group (order by s.bid_points_estimate) else null end as p25_points,
    case when count(*) >= 5 then percentile_cont(0.5) within group (order by s.bid_points_estimate) else null end as median_points,
    case when count(*) >= 5 then percentile_cont(0.75) within group (order by s.bid_points_estimate) else null end as p75_points,
    case when count(*) >= 5 then max(s.bid_points_estimate) else null end as max_points
  from public.pulse_check_submissions s
  where s.term = p_term
  group by s.course_id;
$$;

revoke all on function public.pulse_check_results_by_term(text) from public;
revoke execute on function public.pulse_check_results_by_term(text) from anon;
grant execute on function public.pulse_check_results_by_term(text) to authenticated;
