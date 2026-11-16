import { useRef, useState } from "react";
import { Link } from "react-router-dom";
import skill from "../../../skills/compass/SKILL.md?raw";
import { zipOne } from "../lib/skillZip";

// Same address as in skills/compass/SKILL.md and docs/COMPASS.md section 10.
const CONNECTOR_URL = "https://ujnrgvmbahbepdnahtle.supabase.co/functions/v1/compass-mcp";
const CONNECTOR_NAME = "ISB-Acads";
const EXAMPLES = ["/compass how much stock should I order?", "Compass: freemium or free trial?"];

function CopyBox({ text, label }: { text: string; label: string }) {
  const [msg, setMsg] = useState("Copy"); const code = useRef<HTMLElement>(null);
  const copy = async () => {
    try { await navigator.clipboard.writeText(text); setMsg("Copied"); }
    catch { // Some browsers refuse the clipboard. Select the text so the person can copy it by hand.
      const r = document.createRange(); r.selectNodeContents(code.current!); const s = getSelection(); s?.removeAllRanges(); s?.addRange(r); setMsg("Selected, press Ctrl+C");
    }
    setTimeout(() => setMsg("Copy"), 2500);
  };
  return <div className="copybox"><code ref={code}>{text}</code><button className="btn" onClick={copy} aria-label={`Copy ${label}`} aria-live="polite">{msg}</button></div>;
}

function Steps({ children }: { children: React.ReactNode }) { return <ol className="steps">{children}</ol>; }
function Step({ n, title, children }: { n: number; title: string; children: React.ReactNode }) {
  return <li className="phase"><div className="pn">{n}</div><div><b>{title}</b>{children}</div></li>;
}

export default function ClaudePage() {
  const download = () => {
    const url = URL.createObjectURL(zipOne("compass/SKILL.md", skill));
    const a = document.createElement("a"); a.href = url; a.download = "compass.zip"; a.click();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  };
  return <section className="road how">
    <div className="ph" style={{ marginTop: 26 }}><h1>Use Compass <em>in Claude</em></h1>
      <p className="sub">Ask Compass from your own Claude chat. Claude looks up ISB's checked idea cards and replies with the course, the session and a Moodle link. Setup takes a few minutes and you only do it once.</p></div>
    <p className="note" style={{ marginTop: 16 }}><b>Admins only for now.</b> If you sign in with an account that is not an admin, Claude will say Compass is open to admins only. There is nothing to fix on your side.</p>

    <div className="two" style={{ marginTop: 22 }}>
      <div className="panel"><p><b>The connector</b> lets Claude reach Compass. It has one read-only tool, Search Compass. You need this.</p></div>
      <div className="panel"><p><b>The skill</b> adds the <code>/compass</code> command and sets the layout of the answer. It is optional: without it, start your question with "Compass:".</p></div>
    </div>

    <h2>Before you start</h2>
    <ul className="plain">
      <li>An ISB account that is an admin in ISB Academics.</li>
      <li>A Claude account, on claude.ai or in the desktop app.</li>
      <li>On a Free plan you can add one custom connector. On Team and Enterprise plans, an Owner adds the connector for the organisation first, and then each person connects to it.</li>
    </ul>

    <h2>Part 1: add the connector</h2>
    <Steps>
      <Step n={1} title="Open the connector menu">
        <p>In Claude, go to Customize, then Connectors. Click + Add, then Add custom connector. Some versions show this as Add, Custom, Web.</p>
      </Step>
      <Step n={2} title="Name it and paste the address">
        <p>Call it <b>{CONNECTOR_NAME}</b>, because the skill looks for that name. Paste this as the server address:</p>
        <CopyBox text={CONNECTOR_URL} label="connector address" />
      </Step>
      <Step n={3} title="Leave the OAuth settings alone">
        <p>If Claude asks about an OAuth client, choose Register automatically and leave the client ID and secret empty. Claude sets itself up.</p>
      </Step>
      <Step n={4} title="Sign in and approve">
        <p>Click Add. A window opens: sign in with your ISB Microsoft account. The next screen is titled "Connect Claude to Compass". Click Connect Claude. Claude can then search the idea cards. It cannot see your other ISB Academics data, slides or files.</p>
      </Step>
      <Step n={5} title="Switch it on in a chat">
        <p>Open a new chat, click + then Connectors, and turn on {CONNECTOR_NAME}. Connectors are off in each new chat until you do this.</p>
      </Step>
      <Step n={6} title="Optional: skip the permission prompt">
        <p>Under Customize, Connectors, {CONNECTOR_NAME}, set Search Compass, Open a Compass idea and Open an ISB class to Always allow. Otherwise Claude asks before each one.</p>
      </Step>
    </Steps>

    <h2>Part 2: add the skill</h2>
    <Steps>
      <Step n={1} title="Download the skill">
        <p>The file holds one folder, <code>compass</code>, with the instructions inside. Don't unzip it.</p>
        <button className="btn primary" style={{ marginTop: 10 }} onClick={download}>Download compass.zip</button>
      </Step>
      <Step n={2} title="Upload it to Claude">
        <p>Go to Customize, then Skills. Click + and choose Upload a skill, then pick <code>compass.zip</code>. Make sure the skill is switched on.</p>
      </Step>
    </Steps>

    <h2>Try it</h2>
    <p className="lede">In a new chat with {CONNECTOR_NAME} on, send one of these:</p>
    {EXAMPLES.map(t => <CopyBox key={t} text={t} label="example question" />)}
    <p className="lede" style={{ marginTop: 14 }}>A good answer has a section called <b>From ISB coursework</b>. Each idea shows its course, the session number, an Open session link to Moodle, and links to its idea page and map. Anything Claude adds from its own knowledge sits in a separate section called <b>Beyond the course</b>. If an answer is wrong or empty, copy your question and send it to whoever gave you access.</p>

    <h2>Good to know</h2>
    <div className="two">
      <div className="panel"><p><b>Claude writes the words.</b> The cards are checked. Claude's phrasing is not, so confirm anything important in the linked Moodle session. The Ask page in this app shows card text only, so use it when you need the strict version.</p></div>
      <div className="panel"><p><b>The cards enter your Claude account.</b> Your Claude plan's data settings apply to those chats.</p></div>
      <div className="panel"><p><b>Limits.</b> 100 searches in any 24 hours, per person. Moodle links need your ISB login, so one may ask you to sign in.</p></div>
      <div className="panel"><p><b>What Compass logs.</b> Your account, the first 60 characters of each question, and whether it found a match. We use this to find gaps in the cards.</p></div>
    </div>

    <h2>If something goes wrong</h2>
    <details><summary>Claude says Compass is open to admins only</summary><p>Your account is not an admin yet. This is the pilot limit, and the connector setup is fine.</p></details>
    <details><summary>Claude answers without searching Compass</summary><p>The connector is probably off in this chat: click + then Connectors and turn on {CONNECTOR_NAME}. You can also start the message with "Compass:" or "/compass".</p></details>
    <details><summary>/compass does not show up</summary><p>The skill is not uploaded or is switched off. Check Customize, then Skills. Typing "Compass:" before your question works without it.</p></details>
    <details><summary>The approval screen shows an error</summary><p>Start again from Claude: Customize, Connectors, {CONNECTOR_NAME}, then connect. The approval screen only accepts requests that come from Claude, so opening its link by hand won't work. Check that you signed in with an admin account.</p></details>
    <details><summary>Claude won't let me add the connector</summary><p>On a Free plan you can add only one custom connector, so remove the other one first. On Team and Enterprise plans, ask an Owner to add it.</p></details>
    <details><summary>I get a daily limit message</summary><p>You have used 100 searches in the last 24 hours. Try again later.</p></details>
    <details><summary>The skill seems out of date</summary><p>Download it again from Part 2 and upload it over the old one.</p></details>

    <p className="small" style={{ marginTop: 28 }}><Link to="/compass" style={{ color: "var(--hero)", fontWeight: 600 }}>Back to Compass search</Link></p>
  </section>;
}
