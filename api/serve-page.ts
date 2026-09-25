// Supabase Storage always serves .html objects as text/plain with a locked-down CSP, as a
// permanent anti-phishing measure enforced across the whole *.supabase.co gateway — it overrides
// whatever content-type you set, and even a dedicated Supabase Edge Function re-serving the same
// bytes got the same override (see supabase/migrations/20260925100000_custom_pages_bucket.sql).
// This Vercel function fetches the object from the public custom-pages bucket and re-serves it
// from this app's own domain instead, which Supabase's gateway has no say over.
const SUPABASE_URL = "https://ujnrgvmbahbepdnahtle.supabase.co"; // same project as VITE_SUPABASE_URL
// Matches the sanitization uploadCustomPage() applies before uploading (src/lib/customPages.ts).
const SAFE_PATH = /^[a-zA-Z0-9._-]+$/;

export default async function handler(request: Request): Promise<Response> {
  const path = new URL(request.url).searchParams.get("path");
  if (!path || !SAFE_PATH.test(path)) {
    return new Response("Not found", { status: 404 });
  }

  const upstream = await fetch(`${SUPABASE_URL}/storage/v1/object/public/custom-pages/${path}`);
  if (!upstream.ok) {
    return new Response("Not found", { status: 404 });
  }

  return new Response(await upstream.arrayBuffer(), {
    headers: { "content-type": "text/html; charset=utf-8", "cache-control": "public, max-age=3600" },
  });
}
