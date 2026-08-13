# mktg-rep database snapshot

A complete copy of the `mktg-rep` (ISB Learning Agent) Supabase project, taken **13 Aug 2026**,
so the learning app's schema and data survive the move into isb-academics.

**Source project:** `jkfztsjclbixjqtidhlx` — separate from the isb-academics project
(`ujnrgvmbahbepdnahtle`, shared with isb-explorer).

This exists because **mktg-rep's migrations were never checked into its git repo**. They were
recorded in the database's own `supabase_migrations` table, which is not somewhere you can read
from once the project is gone or the account is switched. If that project were deleted today,
this directory is what would be left.

## Contents

| File | What it is |
|---|---|
| `migrations-original.sql` | The 17 original migrations, verbatim. **Authoritative.** |
| `schema.sql` | Flattened current state: 10 tables, 7 indexes, 4 functions, 21 RLS policies, 4 storage policies. Easier to read in one pass. |
| `data.sql` | 208 INSERT statements, generated mechanically from `data/*.json`. |
| `data/*.json` | The raw rows, one file per table. The source of truth for `data.sql`. |

`schema.sql` was reconstructed from `pg_catalog` before the original migrations were found, and
reconstruction missed three things that the migrations record: the `revoke`/`grant execute` lines
on the three admin RPCs, the four RLS policies on `storage.objects`, and the storage bucket's real
config (50MB limit, MIME allowlist). Those have since been folded into `schema.sql`, but where the
two files disagree, **trust `migrations-original.sql`**.

Worth doing separately: commit `migrations-original.sql` back into the mktg-rep repo too, split
into its 17 numbered files. That repo currently has no record of its own schema history.

208 rows total: 75 questions, 48 attempts, 32 concepts, 28 topic_mastery, 18 session_content,
5 students, 2 courses. `course_content`, `scenarios`, and `materials` were empty.

The private `course-materials` storage bucket existed but held **zero objects**, so there are no
files to copy. `schema.sql` has the one-liner to recreate the bucket.

Both files are a faithful record of what the source project looked like, **not** the migration to
run against isb-academics. Nothing here has been rewritten for the merge — see below.

## How it was taken, and how it was checked

There was no database password available for this project, so this is not a `pg_dump`. The schema
was reconstructed from `pg_catalog` (`pg_constraint`, `pg_indexes`, `pg_policies`, `pg_proc`,
`pg_description`) and the data was pulled two ways:

- **Content tables** (`courses`, `questions`, `concepts`, `session_content`, and the three empty
  ones) have `using (true)` select policies, so they came straight out of the REST API with the
  anon key — no re-typing, no chance of drift.
- **User-scoped tables** (`students`, `attempts`, `topic_mastery`) are readable only by their
  owner under RLS, so they were pulled with service-role SQL and transcribed by hand.

Because that last group was hand-transcribed, it was fingerprinted on both sides and compared:

```
                  rows   md5                                 aggregate
students             5   18249eaf75a10efc7779cf8440280ba3    xp_sum=260
attempts            48   e5930242b7122820ca7f773f029b540c    correct=27
topic_mastery       28   7e23d4ebb4624e97e80da96a0057f149    att_sum=6
```

All three matched the database exactly. (Timestamps are compared truncated to whole seconds, to
avoid `to_char` rounding differences on sub-second digits; full precision is preserved in the JSON.)

`migrations-original.sql` was hand-transcribed too, and checked the same way — the text below its
`---8<---` marker is byte-for-byte identical to the database:

```
migrations   17 sections   20,647 bytes   md5=2ae7cc538d89ebf4adbf42ad29500cb6
```

Separately, all 1,429 string and jsonb values were round-tripped through the SQL literal encoder
and back with 0 mismatches — 133 of them contain apostrophes and 68 span multiple lines, which is
where quoting would break if it were going to.

`data.sql` has **not** been executed anywhere. It is verified against its source, not against a
target database; the real test comes when it is replayed.

## Before this can load into isb-academics

Five things have to change. None are applied here on purpose — this file is the snapshot, the
transforms belong in a numbered migration.

1. **Fold `courses` into the existing table.** Both projects have a `courses` table meaning
   different things, but they describe the *same two courses*: mktg-rep's `marketing` / `MKTG273`
   and `operations` / `OPMG273` are isb-academics' `MKTG` and `OPMG` (Term 3, `is_core`). Rather
   than convert seven child tables from `text` to `uuid` to match isb-academics' `courses.id`,
   re-point them at `courses(code)`, which is already unique and already text. That means
   remapping `'marketing'` → `'MKTG'` and `'operations'` → `'OPMG'` across `questions`,
   `concepts`, `session_content`, `topic_mastery`, and `courses` itself.
2. **Move the three learning-only columns off `courses`.** `total_sessions`, `enabled`, and
   `sort_order` describe practice content, not the bidding catalogue. They belong in a small
   extension table keyed by course code.
3. **Merge `students` into `users`.** Keep `total_xp`, `day_streak`, `last_active_date` as a
   profile extension; drop `students.is_admin` in favour of the existing `users.is_admin`.
4. **Re-key every user row by email.** The two projects have separate `auth.users`, so the same
   person has a different uuid in each. The 5 students, 48 attempts, and 28 mastery rows must be
   re-pointed at isb-academics' auth ids, matched on email. The five accounts are all
   `@isb.edu` addresses and all five already have student rows, so the mapping is 1:1 — but if
   this step is skipped, the XP and streaks land on nobody.
5. **Rewrite the RLS policies and all four functions.** Every one of them checks
   `public.students.is_admin`, which will not exist after step 3.

## Defects found in the source schema

Worth fixing during the merge rather than carrying across:

- **`topic_mastery`'s primary key is `(student_id, topic)` and omits `course_id`.** Two courses
  sharing a topic name would collide on a single student and silently overwrite their progress.
  Not currently triggered — the marketing and operations topic names happen to be distinct (the
  operations ones are prefixed) — but it is one topic-name collision away from losing data.
- **`students.id` has no foreign key to `auth.users`.** It is expected to equal `auth.uid()`, and
  the RLS policies assume it, but nothing enforces it.
- **Inconsistent policy roles.** Older policies target `public`, newer ones (`materials`,
  `scenarios`, `topic_mastery`) target `authenticated`. Worth standardising on `authenticated`.
