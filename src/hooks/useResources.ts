import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import { cached, fetchShared } from "../lib/queryCache";
import type { Resource } from "../types";

function loadResources(force: boolean) {
  return fetchShared<Resource[]>("resources", async () => {
    const { data } = await supabase.from("resources").select("*").order("created_at", { ascending: false });
    return (data as Resource[]) ?? [];
  }, force);
}

export function useResources() {
  const hit = cached<Resource[]>("resources");
  const [resources, setResources] = useState<Resource[]>(hit ?? []);
  const [loading, setLoading] = useState(!hit);

  const reload = useCallback(async (force = true) => {
    setResources(await loadResources(force));
    setLoading(false);
  }, []);

  useEffect(() => {
    reload(false);
  }, [reload]);

  return { resources, loading, reload };
}
