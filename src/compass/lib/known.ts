import { useSyncExternalStore } from "react";

const KEY = "compass.known"; const subs = new Set<() => void>(); let snap: string[] | null = null;
const read = (): string[] => { if (snap) return snap; try { snap = JSON.parse(localStorage.getItem(KEY) || "[]"); } catch { snap = []; } return snap!; };
const subscribe = (f: () => void) => { subs.add(f); return () => { subs.delete(f); }; };
/** Ideas the student has ticked as "I know this". Stored in this browser only. */
export function useKnown(): [Set<string>, (id: string) => void] {
  const list = useSyncExternalStore(subscribe, read, read);
  const toggle = (id: string) => {
    const next = list.includes(id) ? list.filter(x => x !== id) : [...list, id]; snap = next;
    try { localStorage.setItem(KEY, JSON.stringify(next)); } catch { /* private mode */ }
    subs.forEach(f => f());
  };
  return [new Set(list), toggle];
}
