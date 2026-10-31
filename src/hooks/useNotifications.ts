import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, fetchShared } from "../lib/queryCache";
import type { Notification } from "../types";

function loadNotifications(force: boolean) {
  return fetchShared<Notification[]>("notifications", async () => {
    // Pinned first, then newest first
    const { data } = await supabase
      .from("notifications")
      .select("*")
      .order("pinned", { ascending: false })
      .order("created_at", { ascending: false });
    return (data as Notification[]) ?? [];
  }, force);
}

export function useNotifications() {
  const hit = cached<Notification[]>("notifications");
  const [notifications, setNotifications] = useState<Notification[]>(hit ?? []);
  const [loading, setLoading] = useState(!hit);

  const reload = useCallback(async (force = true) => {
    setNotifications(await loadNotifications(force));
    setLoading(false);
  }, []);

  useEffect(() => {
    reload(false);
  }, [reload]);

  return { notifications, loading, reload };
}
