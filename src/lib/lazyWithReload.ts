import { lazy, type ComponentType } from "react";

// Vite fingerprints each chunk filename with a content hash. A tab that's had the app open
// since before a deploy still has the OLD hashes baked into its already-loaded JS — navigating
// to a route it hasn't fetched yet asks for a chunk file that no longer exists under the new
// deployment, and the import rejects. Reloading re-fetches the current index.html (with the
// current hashes) and the same navigation then works, so do that reload automatically instead
// of leaving the user stuck on a page that "doesn't load" until they think to hit refresh.
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function lazyWithReload<T extends ComponentType<any>>(factory: () => Promise<{ default: T }>) {
  return lazy(async () => {
    try {
      return await factory();
    } catch (error) {
      const key = "chunk-reload-attempted";
      if (!sessionStorage.getItem(key)) {
        sessionStorage.setItem(key, "1");
        window.location.reload();
        return new Promise<{ default: T }>(() => {});
      }
      throw error;
    }
  });
}
