import { supabase } from "./supabase";

const CUSTOM_PAGES_BUCKET = "custom-pages";

/** Uploads an admin-picked HTML file to the public custom-pages bucket and returns its URL, to
    be pasted straight into a nav link's href or a resource's url. */
export async function uploadCustomPage(file: File): Promise<string> {
  const safeName = file.name.replace(/[^a-zA-Z0-9._-]/g, "_");
  const path = `${Date.now()}-${safeName}`;

  const { error } = await supabase.storage
    .from(CUSTOM_PAGES_BUCKET)
    .upload(path, file, { contentType: "text/html", upsert: false });
  if (error) throw error;

  return supabase.storage.from(CUSTOM_PAGES_BUCKET).getPublicUrl(path).data.publicUrl;
}
