/** Split-screen login, matching ISB's Tutor Portal (tutor.isb.edu) visual language. */
import { useState } from "react";
import { COLOR, FONT } from "../lib/theme";
import { useAuth } from "../hooks/useAuth";

export default function Login() {
  const { signInWithAzure, sendMagicLink } = useAuth();
  const [email, setEmail] = useState("");
  const [msg, setMsg] = useState<string | null>(null);
  const [sending, setSending] = useState(false);

  async function handleAzure() {
    const err = await signInWithAzure();
    if (err) setMsg(err);
  }

  async function handleMagicLink() {
    setSending(true);
    const err = await sendMagicLink(email);
    setSending(false);
    setMsg(err ?? "Check your @isb.edu inbox for a login link.");
  }

  return (
    <div className="min-h-screen flex flex-col md:flex-row">
      {/* Left — hero panel */}
      <div className="flex-1 px-8 md:px-14 py-14 flex flex-col justify-between" style={{ background: COLOR.navyHero, minHeight: 400 }}>
        <div>
          <p style={{ fontFamily: FONT.sans, fontWeight: 800, fontSize: 15, color: "#fff", letterSpacing: "0.02em" }}>ISB</p>
          <p style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 13, color: COLOR.mint, marginTop: 2, borderBottom: `2px solid ${COLOR.mint}`, display: "inline-block", paddingBottom: 2 }}>
            Academics
          </p>

          <h1 style={{ fontFamily: FONT.serif, fontWeight: 700, fontSize: "clamp(34px, 5vw, 52px)", lineHeight: 1.05, color: "#fff", marginTop: 36 }}>
            Bidding &amp;<br />Academic<br />
            <span style={{ background: COLOR.mint, color: COLOR.navyHero, padding: "0 6px" }}>Planning</span>
          </h1>

          <p style={{ fontFamily: FONT.sans, fontSize: 15, color: "rgba(255,255,255,0.75)", marginTop: 24, maxWidth: 420, lineHeight: 1.6 }}>
            Your background, your goals, and where you stand on concentration and
            specialization credits — one place to plan electives and bidding strategy,
            starting with Term 4.
          </p>
        </div>

        <div style={{ background: COLOR.mint, borderRadius: 10, padding: "16px 18px", maxWidth: 300 }}>
          <p style={{ fontFamily: FONT.sans, fontSize: 11, fontWeight: 700, color: COLOR.navyHero, letterSpacing: "0.08em", textTransform: "uppercase" }}>
            Platform gate
          </p>
          <p style={{ fontFamily: FONT.serif, fontSize: 15, fontWeight: 600, color: COLOR.navyHero, marginTop: 4 }}>
            One sign-in for bidding planning, resources, and Academic Council updates.
          </p>
        </div>
      </div>

      {/* Right — sign-in panel */}
      <div className="flex-1 flex items-center justify-center px-8 py-14" style={{ background: COLOR.bg }}>
        <div className="w-full" style={{ maxWidth: 360 }}>
          <p style={{ fontFamily: FONT.sans, fontSize: 12, fontWeight: 700, color: COLOR.ink3, letterSpacing: "0.12em", textTransform: "uppercase", textAlign: "center" }}>
            Sign in
          </p>
          <h2 style={{ fontFamily: FONT.serif, fontSize: 28, fontWeight: 600, color: COLOR.ink, textAlign: "center", marginTop: 6 }}>
            Microsoft SSO
          </h2>
          <p style={{ fontFamily: FONT.sans, fontSize: 13, color: COLOR.ink2, textAlign: "center", marginTop: 8, marginBottom: 28 }}>
            Sign in with your institutional @isb.edu account.
          </p>

          <button
            onClick={handleAzure}
            style={{
              width: "100%", padding: "13px", borderRadius: 10, background: COLOR.navyHero, color: "#fff",
              border: "none", fontSize: 14, fontWeight: 700, fontFamily: FONT.sans, cursor: "pointer", marginBottom: 16,
            }}
          >
            Sign in with Microsoft SSO
          </button>

          <div style={{ display: "flex", alignItems: "center", gap: 10, margin: "18px 0", color: COLOR.ink3, fontFamily: FONT.sans, fontSize: 12 }}>
            <div style={{ flex: 1, height: 1, background: COLOR.border }} /> or <div style={{ flex: 1, height: 1, background: COLOR.border }} />
          </div>

          <input
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="you@isb.edu"
            style={{ width: "100%", padding: "11px 12px", borderRadius: 9, border: `1px solid ${COLOR.border}`, fontSize: 13, fontFamily: FONT.sans, marginBottom: 10 }}
          />
          <button
            onClick={handleMagicLink}
            disabled={sending}
            style={{ width: "100%", padding: "11px", borderRadius: 9, background: COLOR.surface, color: COLOR.ink, border: `1px solid ${COLOR.border}`, fontSize: 13, fontWeight: 600, fontFamily: FONT.sans, cursor: "pointer" }}
          >
            {sending ? "Sending…" : "Email me a magic link"}
          </button>

          {msg && <p style={{ marginTop: 14, fontSize: 12, color: COLOR.ink2, fontFamily: FONT.sans, textAlign: "center" }}>{msg}</p>}

          <p style={{ marginTop: 28, fontSize: 11, color: COLOR.ink3, fontFamily: FONT.sans, textAlign: "center", lineHeight: 1.6 }}>
            Authorized access only. By continuing, you agree to ISB's Acceptable Use Policies.
          </p>
        </div>
      </div>
    </div>
  );
}
