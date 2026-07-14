import { useEffect, useState, useCallback } from "react";
import { supabase } from "../lib/supabase";
import type { Resource } from "../types";

export function useResources() {
  const [resources, setResources] = useState<Resource[]>([]);
  const [loading, setLoading] = useState(true);

  const reload = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from("resources").select("*").order("created_at", { ascending: false });
    setResources((data as Resource[]) ?? []);
    setLoading(false);
  }, []);

  useEffect(() => {
    reload();
  }, [reload]);

  return { resources, loading, reload };
}
