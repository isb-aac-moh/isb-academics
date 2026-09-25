import { supabase } from "./supabase";

const CUSTOM_PAGES_BUCKET = "custom-pages";

/** Uploads an admin-picked HTML file to the custom-pages bucket and returns a URL that actually
    renders it. Supabase Storage always serves .html objects as text/plain with a locked-down CSP
    — a permanent anti-phishing rule enforced across the whole *.supabase.co gateway, including a
    dedicated Edge Function re-serving the same bytes with an explicit Content-Type. So the URL
    points at this app's own /api/serve-page (api/serve-page.ts), which fetches the object
    server-side and re-serves it from a domain Supabase's gateway has no say over. */
export async function uploadCustomPage(file: File): Promise<string> {
  const safeName = file.name.replace(/[^a-zA-Z0-9._-]/g, "_");
  const path = `${Date.now()}-${safeName}`;

  const { error } = await supabase.storage
    .from(CUSTOM_PAGES_BUCKET)
    .upload(path, file, { contentType: "text/html", upsert: false });
  if (error) throw error;

  return `${window.location.origin}/api/serve-page?path=${encodeURIComponent(path)}`;
}
