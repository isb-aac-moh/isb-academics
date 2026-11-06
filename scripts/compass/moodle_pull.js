// Runs inside a browser tab signed in to elearn.isb.edu. Reads teaching material one item a second and hands it to
// moodle_receiver.py. Finished items are skipped on a re-run. Progress: window.__pull. Keep the tab open on Moodle.
(async function (local, token, only) {
  const COURSES = { ABTE: 11049, BANM: 10849, BSNS: 10580, CDMA: 11051, ENTR: 10946, ELP: 10806, FADM: 10515, FCRV: 10577, FRNT: 10581, HCEN: 10887, LSAT: 10518, MGEC: 10519, MKTG: 10845, MKTR: 10953, MKTS: 11056, MVCM: 10506, OPMG: 10846, SWPM: 10955, SMDM: 10520, STRG: 10578, SUET: 10956, SEED: 10900, ASMD: 10852, WACM: 10523 };
  // Tools that run this in an isolated page context can't see Moodle's M object, so fall back to the page source.
  const sesskey = window.M?.cfg?.sesskey || document.documentElement.innerHTML.match(/"sesskey":"([^"]+)"/)[1];
  const FILES = new Set(["resource", "filewithwatermark"]), MAX = 300 * 1024 * 1024;
  const P = window.__pull = { running: true, stopped: null, courses: {} };
  // Paced by the receiver, because Chrome slows timers in background tabs to about one a minute.
  const wait = () => fetch(`${local}/wait?token=${token}`);
  const q = (course, extra = {}) => new URLSearchParams({ token, course, ...extra }).toString();
  const clean = s => s.replace(/[^\w.\- ]+/g, "_").trim().replace(/^[. ]+|[. ]+$/g, "").slice(0, 150) || "file";
  class Ended extends Error {}
  async function get(url) {
    const r = await fetch(url, { credentials: "include" });
    if (new URL(r.url).pathname.startsWith("/login")) throw new Ended();
    if (!r.ok) throw new Error("HTTP " + r.status);
    return r;
  }
  async function store(course, name, r) {
    const blob = await r.blob();
    if (blob.size > MAX) return { skip: "too large" };
    const s = await fetch(`${local}/file?${q(course, { name })}`, { method: "POST", body: blob });
    if (!s.ok) throw new Error("receiver " + s.status);
    return { ...(await s.json()), type: (r.headers.get("content-type") || "").split(";")[0] };
  }
  const fileName = r => { try { return decodeURIComponent(new URL(r.url).pathname.split("/").pop()); } catch { return "file"; } };
  const links = (page, area) => [...new Set([...page.replaceAll("&amp;", "&").replaceAll("\\/", "/").matchAll(/https?:\/\/[^"'\s<>]+\/pluginfile\.php\/[^"'\s<>]+/g)].map(m => m[0].split("?")[0]).filter(u => u.includes(area)))];
  async function oneFile(course, url, prefix, isFileLink = false) {
    const r = await get(url); const kind = r.headers.get("content-type") || "";
    if (/^(video|audio)\//.test(kind)) { r.body?.cancel(); return { skip: "skipped " + kind.split("/")[0] }; }
    if (kind.startsWith("text/html") && !isFileLink) return { html: await r.text() }; // An HTML file behind a file link is the material itself.
    return store(course, `${prefix}_${clean(fileName(r))}`, r);
  }
  async function item(course, cm, prefix) {
    if (FILES.has(cm.module)) {
      let got = await oneFile(course, cm.url, prefix);
      if (got.html !== undefined) {
        const inner = links(got.html, `mod_${cm.module}/`);
        if (!inner.length) return ["no file on page", []];
        await wait(); got = await oneFile(course, inner[0], prefix, true);
      }
      return got.skip ? [got.skip, []] : got.html !== undefined ? ["no file on page", []] : ["ok", [got]];
    }
    if (cm.module === "folder") {
      const page = await (await get(cm.url)).text(); const files = [];
      for (const [i, link] of links(page, "mod_folder/").entries()) { await wait(); const got = await oneFile(course, link, `${prefix}-${String(i).padStart(2, "0")}`, true); if (got.path) files.push(got); }
      return [files.length ? "ok" : "empty folder", files];
    }
    const url = cm.module === "book" ? `/mod/book/tool/print/index.php?id=${cm.id}` : cm.url;
    return ["ok", [await store(course, `${prefix}_${clean(cm.name).slice(0, 60)}.html`, await get(url))]];
  }
  try {
    for (const [code, id] of Object.entries(only ? { [only]: COURSES[only] } : COURSES)) {
      const tally = P.courses[code] = { bytes: 0 };
      const count = k => { tally[k] = (tally[k] || 0) + 1; };
      const res = await fetch(`/lib/ajax/service.php?sesskey=${sesskey}&info=core_courseformat_get_state`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify([{ index: 0, methodname: "core_courseformat_get_state", args: { courseid: id } }]) });
      const d = (await res.json())[0];
      if (d.error) { if (d.exception?.errorcode === "servicerequireslogin") throw new Ended(); count("course failed"); continue; }
      const state = JSON.parse(d.data), sections = Object.fromEntries((state.section || []).map(s => [String(s.id), s]));
      const old = Object.fromEntries((await (await fetch(`${local}/manifest?${q(code)}`)).json()).map(e => [e.cmid, e]));
      const entries = [];
      const save = () => fetch(`${local}/manifest?${q(code)}`, { method: "POST", body: JSON.stringify([...entries, ...Object.values(old).filter(e => !entries.some(x => x.cmid === e.cmid))], null, 1) });
      for (const cm of state.cm || []) {
        if (!FILES.has(cm.module) && !["folder", "page", "book", "url"].includes(cm.module)) continue;
        const cmid = String(cm.id), sec = sections[String(cm.sectionid)] || {};
        const prev = old[cmid];
        if (prev?.status === "ok") { entries.push(prev); count("already had"); tally.bytes += prev.files.reduce((n, f) => n + f.bytes, 0); continue; }
        const entry = { cmid, name: cm.name, module: cm.module, section: sec.number ?? null, section_title: sec.title ?? null, moodle_url: cm.url, files: [] };
        if (cm.module === "url") entry.status = "ok";
        else if (cm.accessible === false || cm.uservisible === false) entry.status = "locked";
        else {
          try { [entry.status, entry.files] = await item(code, cm, `S${String(sec.number ?? 0).padStart(2, "0")}_${cmid}`); }
          catch (e) { if (e instanceof Ended) { entries.push({ ...entry, status: "failed: session ended" }); await save(); throw e; } entry.status = "failed: " + String(e.message || e).slice(0, 40); }
          await wait();
        }
        entries.push(entry); await save();
        count(entry.status.split(":")[0]); tally.bytes += entry.files.reduce((n, f) => n + (f.bytes || 0), 0);
      }
      await wait();
    }
  } catch (e) { P.stopped = e instanceof Ended ? "session ended" : String(e.message || e).slice(0, 80); }
  P.running = false;
})
