import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { DashboardPopup } from "../types";

// Single source for both the admin CRUD tab (needs every row, including disabled ones) and the
// global popup renderer (filters down to enabled rows matching the current page) — same shape
// as useNavLinks/useNotifications.
export function useDashboardPopups() {
  const [popups, setPopups] = useState<DashboardPopup[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from("dashboard_popups").select("*").order("updated_at", { ascending: false });
    setPopups((data as DashboardPopup[]) ?? []);
    setLoading(false);
  }, []);

  useEffect(() => {
    reload();
  }, [reload]);

  return { popups, loading, reload };
}
