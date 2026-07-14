import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { Notification } from "../types";

export function useNotifications() {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    // Pinned first, then newest first
    const { data } = await supabase
      .from("notifications")
      .select("*")
      .order("pinned", { ascending: false })
      .order("created_at", { ascending: false });
    setNotifications((data as Notification[]) ?? []);
    setLoading(false);
  }, []);

  useEffect(() => {
    reload();
  }, [reload]);

  return { notifications, loading, reload };
}
