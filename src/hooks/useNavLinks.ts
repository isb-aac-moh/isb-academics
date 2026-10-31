import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, fetchShared } from "../lib/queryCache";
import type { NavLink } from "../types";

export function loadNavLinks(force = false) {
  return fetchShared<NavLink[]>("nav_links", async () => {
    const { data } = await supabase.from("nav_links").select("*").order("sort_order", { ascending: true });
    return (data as NavLink[]) ?? [];
  }, force);
}

export function useNavLinks() {
  const hit = cached<NavLink[]>("nav_links");
  const [navLinks, setNavLinks] = useState<NavLink[]>(hit ?? []);
  const [loading, setLoading] = useState(!hit);

  const reload = useCallback(async (force = true) => {
    setNavLinks(await loadNavLinks(force));
    setLoading(false);
  }, []);

  useEffect(() => {
    reload(false);
  }, [reload]);

  return { navLinks, loading, reload };
}
