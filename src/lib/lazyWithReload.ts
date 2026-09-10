import { lazy, type ComponentType } from "react";

// Vite fingerprints each chunk filename with a content hash. A tab that's had the app open
// since before a deploy still has the OLD hashes baked into its already-loaded JS — navigating
// to a route it hasn't fetched yet asks for a chunk file that no longer exists under the new
// deployment, and the import rejects. Reloading re-fetches the current index.html (with the
// current hashes) and the same navigation then works, so do that reload automatically instead
// of leaving the user stuck on a page that "doesn't load" until they think to hit refresh.
const RELOAD_FLAG = "chunk-reload-attempted";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function lazyWithReload<T extends ComponentType<any>>(factory: () => Promise<{ default: T }>) {
  return lazy(async () => {
    try {
      const mod = await factory();
      // The chunk loaded, so rearm the guard. Without this the flag stays set for the rest of the
      // browser session, and the next deploy the user opens a tab across would skip the reload and
      // fall through to the error boundary. Clearing it makes the guard fire once per deploy.
      sessionStorage.removeItem(RELOAD_FLAG);
      return mod;
    } catch (error) {
      // Retry the import once before the heavy full-page reload. A failed module fetch is not
      // cached, so a second import re-fetches from the network — enough to clear a transient blip
      // (a dropped request, a brief CDN miss) without a reload. A genuinely removed chunk 404s
      // again here and we fall through to the reload.
      try {
        const mod = await factory();
        sessionStorage.removeItem(RELOAD_FLAG);
        return mod;
      } catch {
        if (!sessionStorage.getItem(RELOAD_FLAG)) {
          sessionStorage.setItem(RELOAD_FLAG, "1");
          // reload() keeps the current URL, so the user resumes on the route they asked for
          // rather than the app default once the session restores.
          window.location.reload();
          return new Promise<{ default: T }>(() => {});
        }
        throw error;
      }
    }
  });
}
