import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, fetchShared } from "../lib/queryCache";
import type { DashboardPopup } from "../types";

export function loadDashboardPopups(force = false) {
  return fetchShared<DashboardPopup[]>("dashboard_popups", async () => {
    const { data } = await supabase.from("dashboard_popups").select("*").order("updated_at", { ascending: false });
    return (data as DashboardPopup[]) ?? [];
  }, force);
}

// Single source for both the admin CRUD tab (needs every row, including disabled ones) and the
// global popup renderer (filters down to enabled rows matching the current page) — same shape
// as useNavLinks/useNotifications.
export function useDashboardPopups() {
  const hit = cached<DashboardPopup[]>("dashboard_popups");
  const [popups, setPopups] = useState<DashboardPopup[]>(hit ?? []);
  const [loading, setLoading] = useState(!hit);

  const reload = useCallback(async (force = true) => {
    setPopups(await loadDashboardPopups(force));
    setLoading(false);
  }, []);

  useEffect(() => {
    reload(false);
  }, [reload]);

  return { popups, loading, reload };
}
