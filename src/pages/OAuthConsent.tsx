import { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { CONSENT_RETURN_KEY, supabase } from "../lib/supabase";
import { COLOR, FONT } from "../lib/theme";
import type { User } from "../types";

// Connector sign-in lets any app register itself, so this is the check that only Claude gets through.
const CLAUDE_CALLBACKS = ["https://claude.ai/api/mcp/auth_callback", "https://claude.com/api/mcp/auth_callback"];

type View = { kind: "loading" } | { kind: "ask" } | { kind: "stop"; message: string };

/** Where Supabase sends someone to approve the Compass connector. */
export default function OAuthConsent({ user }: { user: User }) {
  const [params] = useSearchParams();
  const id = params.get("authorization_id");
  const blocked = !user.is_admin ? "The Compass connector is open to admins only for now."
    : !id ? "This link is incomplete. Start again from Claude's connector settings." : null;
  const [view, setView] = useState<View>(blocked ? { kind: "stop", message: blocked } : { kind: "loading" });
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    try { localStorage.removeItem(CONSENT_RETURN_KEY); } catch { /* Storage blocked: nothing was saved. */ }
    if (blocked || !id) return;
    (async () => {
      const { data, error } = await supabase.auth.oauth.getAuthorizationDetails(id);
      if (error || !data) return setView({ kind: "stop", message: "This request has expired. Start again from Claude's connector settings." });
      if (!("authorization_id" in data)) { window.location.href = data.redirect_url; return; } // Already approved earlier.
      if (!CLAUDE_CALLBACKS.includes(data.redirect_uri)) return setView({ kind: "stop", message: "Only Claude can connect to Compass." });
      setView({ kind: "ask" });
    })().catch(() => setView({ kind: "stop", message: "Something went wrong. Start again from Claude's connector settings." }));
  }, [id, blocked]);

  async function decide(approve: boolean) {
    setBusy(true);
    const { data, error } = await (approve ? supabase.auth.oauth.approveAuthorization(id!) : supabase.auth.oauth.denyAuthorization(id!));
    if (error || !data) { setBusy(false); return setView({ kind: "stop", message: "That didn't go through. Start again from Claude's connector settings." }); }
    window.location.href = data.redirect_url;
  }

  const button = "px-4 py-2.5 rounded-lg text-sm font-semibold disabled:opacity-60 focus-visible:outline-2 focus-visible:outline-offset-2";
  return (
    <main className="min-h-screen flex items-center justify-center px-4" style={{ background: COLOR.navyHero }}>
      <div className="w-full max-w-md rounded-2xl bg-white p-6 md:p-8">
        <h1 style={{ fontFamily: FONT.serif, fontWeight: 700, fontSize: 26, lineHeight: 1.15, color: COLOR.navyHero }}>Connect Claude to Compass</h1>
        {view.kind === "loading" && <p className="mt-4 text-sm" role="status">Checking this request…</p>}
        {view.kind === "stop" && <p className="mt-4 text-sm" role="alert">{view.message}</p>}
        {view.kind === "ask" && <>
          <p className="mt-4 text-sm leading-6">Claude can then search Compass's checked idea cards when you ask it something. It can't read your other ISB Academics data or see slides and files.</p>
          <p className="mt-3 text-sm leading-6">Claude writes the reply itself and your plan's settings apply to those chats, so check important points against the linked Moodle sessions.</p>
          <div className="mt-6 flex flex-wrap gap-3">
            <button className={button} style={{ background: COLOR.navyHero, color: "#fff" }} disabled={busy} onClick={() => decide(true)}>Connect Claude</button>
            <button className={button} style={{ color: COLOR.navyHero, border: `1px solid ${COLOR.navyHero}` }} disabled={busy} onClick={() => decide(false)}>Cancel</button>
          </div>
        </>}
      </div>
    </main>
  );
}
