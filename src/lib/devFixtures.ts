// Dev-only preview data for the Pulse Check range meter. Never reaches the
// production build — Vite statically replaces `import.meta.env.DEV` at build
// time and tree-shakes the branch that imports this file, so it can't leak
// into what real students see. This exists because there's no separate local
// database here (dev and prod both point at the same live Supabase project);
// inserting real test rows would pollute the actual cohort numbers instead.
import type { PulseCheckResult, PulseCheckHistogramBucket } from "../types";

// A few different shapes so you can eyeball a tight cluster, a wide spread,
// and a still-too-few-responses course side by side, rather than one flat
// case. `bucketCounts` must sum to respondent_count — mirrors the real
// width_bucket() binning (5 equal-width buckets over [min, max]).
const SHAPES = [
  { respondent_count: 11, min: 200, p25: 280, median: 350, p75: 420, max: 900, bucketCounts: [4, 3, 2, 1, 1] },
  { respondent_count: 7, min: 100, p25: 150, median: 180, p75: 210, max: 300, bucketCounts: [1, 2, 2, 1, 1] },
  { respondent_count: 14, min: 150, p25: 300, median: 500, p75: 700, max: 1500, bucketCounts: [3, 4, 3, 2, 2] },
];

export function fakePulseResults(courseIds: string[]): PulseCheckResult[] {
  return courseIds.map((course_id, i) => {
    if (i % 4 === 3) {
      // every 4th course previews the "not enough data yet" state
      return { course_id, respondent_count: 2, min_points: null, p25_points: null, median_points: null, p75_points: null, max_points: null };
    }
    const s = SHAPES[i % SHAPES.length];
    return {
      course_id,
      respondent_count: s.respondent_count,
      min_points: s.min,
      p25_points: s.p25,
      median_points: s.median,
      p75_points: s.p75,
      max_points: s.max,
    };
  });
}

export function fakePulseHistograms(courseIds: string[]): PulseCheckHistogramBucket[] {
  return courseIds.flatMap((course_id, i) => {
    if (i % 4 === 3) return []; // matches the "not enough data" course above — no buckets
    const s = SHAPES[i % SHAPES.length];
    const width = (s.max + 1 - s.min) / 5;
    return s.bucketCounts.map((bucket_count, b) => ({
      course_id,
      bucket_index: b + 1,
      bucket_start: s.min + b * width,
      bucket_end: s.min + (b + 1) * width,
      bucket_count,
    }));
  });
}
