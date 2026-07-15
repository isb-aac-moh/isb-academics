import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { NavLink } from "../types";

export function useNavLinks() {
  const [navLinks, setNavLinks] = useState<NavLink[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from("nav_links").select("*").order("sort_order", { ascending: true });
    setNavLinks((data as NavLink[]) ?? []);
    setLoading(false);
  }, []);

  useEffect(() => {
    reload();
  }, [reload]);

  return { navLinks, loading, reload };
}
