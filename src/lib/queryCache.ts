/* In-memory memory for data every student sees the same (courses, settings, nav links, resources…).
   Two jobs:
   - Revisits are instant. A hook starts with whatever was loaded last time and still re-fetches
     (unless the copy is only seconds old), so a page you come back to paints at once and quietly
     corrects itself if something changed.
   - Concurrent asks share one request. The sidebar, a page and a child component asking for the same
     thing at the same moment make one round trip, not three.
   A student's own data goes through remember() instead, and startEarly() below covers the first load. */

const values = new Map<string, { v: unknown; at: number }>();
const FRESH_MS = 10_000;
const running = new Map<string, Promise<unknown>>();

export function cached<T>(key: string): T | undefined {
  return values.get(key)?.v as T | undefined;
}

/** `force` skips both shortcuts (a copy a few seconds old, a request already in flight): after a
    save, either of those may hold the data from before it. */
export function fetchShared<T>(key: string, run: () => Promise<T>, force = false): Promise<T> {
  if (!force) {
    const hit = values.get(key);
    if (hit && Date.now() - hit.at < FRESH_MS) return Promise.resolve(hit.v as T);
    const live = running.get(key);
    if (live) return live as Promise<T>;
  }
  const p = run().then((v) => {
    values.set(key, { v, at: Date.now() });
    return v;
  });
  running.set(key, p);
  const done = () => {
    if (running.get(key) === p) running.delete(key);
  };
  p.then(done, done);
  return p;
}

/** File away the latest copy of something a hook already holds in state, so the next mount starts
    from it. Used for a student's own data: the hook writes every change it makes (including their
    saves) here, so what comes back is what they last saw, then re-checked in the background. */
export function remember(key: string, v: unknown) {
  values.set(key, { v, at: Date.now() });
}

/** Forget one entry, so the next reader waits for fresh data instead of seeing the old copy first. */
export function invalidate(key: string) {
  values.delete(key);
}

/** Sign-out: the next person on this browser must not see the last person's copy, even briefly. */
export function clearCache() {
  values.clear();
  running.clear();
  early.clear();
}

/* A student's own data: the first load can start before the page that needs it exists. At sign-in we
   already know the user id, so the request goes out then, and the first reader takes the result;
   anything later asks fresh. */
const early = new Map<string, { at: number; p: Promise<unknown> }>();
const EARLY_MAX_AGE_MS = 15_000;

export function startEarly<T>(key: string, run: () => Promise<T>) {
  early.set(key, { at: Date.now(), p: run() });
}

export function takeEarly<T>(key: string, run: () => Promise<T>): Promise<T> {
  const hit = early.get(key);
  early.delete(key);
  return hit && Date.now() - hit.at < EARLY_MAX_AGE_MS ? (hit.p as Promise<T>) : run();
}
