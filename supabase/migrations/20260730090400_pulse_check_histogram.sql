-- Real per-course bid-point histogram (5 adaptive-width buckets, via
-- Postgres's built-in width_bucket()), replacing the range-meter's single
-- summary bar with an actual shape of the distribution. Per product
-- feedback: a card-per-course grid with a small bar chart reads better than
-- one shared range control behind a dropdown.
--
-- This is a coarser aggregate than the 5-number summary this app already
-- ships (min/P25/median/P75/max pinpoint exact values; a 5-bucket count only
-- says "N people fell in this range") — not a new privacy exposure, if
-- anything a safer one. Same >=5 respondent threshold as everywhere else in
-- this feature; anon execute revoked inline this time (see the prior two
-- fix-then-relearn migrations on this table).
create or replace function public.pulse_check_histogram_by_term(p_term text)
returns table(course_id uuid, bucket_index integer, bucket_start numeric, bucket_end numeric, bucket_count integer)
language sql
security definer
set search_path = public
stable
as $$
  with bounds as (
    select
      s.course_id,
      min(s.bid_points_estimate)::numeric as lo,
      max(s.bid_points_estimate)::numeric as hi
    from public.pulse_check_submissions s
    where s.term = p_term
    group by s.course_id
    having count(*) >= 5
  ),
  buckets as (
    select generate_series(1, 5) as bucket_index
  ),
  -- +1 on the upper bound because width_bucket's range is [lo, hi) — without
  -- it, the single row that IS the real max would fall outside all 5 buckets
  -- (width_bucket returns count+1 for operand >= high).
  assigned as (
    select b.course_id, width_bucket(s.bid_points_estimate::numeric, b.lo, b.hi + 1, 5) as bucket_index
    from public.pulse_check_submissions s
    join bounds b on b.course_id = s.course_id
    where s.term = p_term
  )
  select
    b.course_id,
    buckets.bucket_index,
    b.lo + (buckets.bucket_index - 1) * (b.hi + 1 - b.lo) / 5 as bucket_start,
    b.lo + buckets.bucket_index * (b.hi + 1 - b.lo) / 5 as bucket_end,
    coalesce(count(a.bucket_index), 0)::integer as bucket_count
  from bounds b
  cross join buckets
  left join assigned a on a.course_id = b.course_id and a.bucket_index = buckets.bucket_index
  group by b.course_id, buckets.bucket_index, b.lo, b.hi
  order by b.course_id, buckets.bucket_index;
$$;

revoke all on function public.pulse_check_histogram_by_term(text) from public;
revoke execute on function public.pulse_check_histogram_by_term(text) from anon;
grant execute on function public.pulse_check_histogram_by_term(text) to authenticated;
