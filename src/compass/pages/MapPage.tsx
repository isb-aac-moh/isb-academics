import { useEffect, useMemo, useRef } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { coursesOf, inLens, type Concept, type Store } from "../lib/data";
import { coTaught, layered, reach, NODE_H, NODE_W } from "../lib/graph";
import { TOPICS, oneLine, topicById, topicOf } from "../lib/topics";
import { useKnown } from "../lib/known";
import { ideaPath, SectionLabel } from "../components";

const wrap = (t: string): string[] => { const out: string[] = []; let cur = "";
  for (const w of t.split(" ")) { if ((cur + " " + w).trim().length > 27 && cur) { out.push(cur); cur = w; } else cur = (cur + " " + w).trim(); }
  if (cur) out.push(cur); return out.length > 2 ? [out[0], out[1].slice(0, 25) + "…"] : out; };

export default function MapPage({ store, lens }: { store: Store; lens: string }) {
  const [sp, setSp] = useSearchParams(); const [known, toggleKnown] = useKnown(); const box = useRef<HTMLDivElement>(null);
  const all = Object.values(store.data.concepts); const taught = all.filter(c => coursesOf(c).length && inLens(c, lens));
  const counts = Object.fromEntries(TOPICS.map(t => [t.id, taught.filter(c => topicOf(c) === t.id).length]));
  const topicId = topicById(sp.get("topic") || "") ? sp.get("topic")! : TOPICS.reduce((b, t) => (counts[t.id] > counts[b] ? t.id : b), TOPICS[0].id);
  const showAll = sp.get("all") === "1"; const sel = sp.get("node") || "";
  const set = (k: Record<string, string | null>) => { const n = new URLSearchParams(sp); n.set("lens", lens); for (const [a, b] of Object.entries(k)) if (b === null) n.delete(a); else n.set(a, b); setSp(n, { replace: true }); };

  const g = useMemo(() => {
    const pool = (showAll ? all.filter(c => inLens(c, lens)) : taught).filter(c => topicOf(c) === topicId); const ids = pool.map(c => c.id);
    const edges: [string, string][] = []; for (const c of pool) for (const r of c.rel) if (store.data.concepts[r.to]) edges.push([r.to, c.id]);
    return { pool, ...layered(ids, edges) };
  }, [store, lens, topicId, showAll]); // eslint-disable-line react-hooks/exhaustive-deps
  const byId = (id: string) => store.data.concepts[id];
  const selC: Concept | undefined = sel ? byId(sel) : undefined; const inSet = !!selC && g.pool.some(c => c.id === sel);
  const r = inSet ? reach(sel, g.edges) : { up: new Set<string>(), down: new Set<string>() };
  const pos = Object.fromEntries(g.laid.map(n => [n.id, n]));
  useEffect(() => { const n = sel && pos[sel]; if (n && box.current) box.current.scrollTo({ left: Math.max(0, n.x + 24 - 120), top: Math.max(0, n.y + 24 - 160), behavior: "smooth" }); }, [sel]); // eslint-disable-line react-hooks/exhaustive-deps
  const pick = (id: string) => { const c = byId(id); if (c) set({ node: id, topic: topicOf(c) }); };

  const up = selC ? selC.rel.map(x => byId(x.to)).filter(Boolean) : []; const down = selC ? (store.reverse[selC.id] || []).map(byId) : [];
  const together = selC ? Object.entries(coTaught(store)[selC.id] || {}).filter(([, n]) => n >= 2).sort((a, b) => b[1] - a[1]).slice(0, 5).map(([i]) => byId(i)).filter(Boolean) : [];
  const state = (id: string) => (!sel || !inSet ? "" : id === sel ? "sel" : r.up.has(id) ? "up" : r.down.has(id) ? "down" : "dim");
  const edgeState = (a: string, b: string) => (!inSet ? "" : (a === sel || r.up.has(a)) && (b === sel || r.up.has(b)) ? "up" : (a === sel || r.down.has(a)) && (b === sel || r.down.has(b)) ? "down" : "dim");

  return <section><SectionLabel>Map of ideas by topic</SectionLabel>
    <p className="note">Pick a topic, then click any idea. Ideas on the left are what to learn first; ideas on the right are what each one leads to. Click a highlighted idea to keep walking the chain.</p>
    <div className="mapbar" role="tablist" aria-label="Topic">{TOPICS.map(t => <button key={t.id} role="tab" aria-selected={t.id === topicId} className={t.id === topicId ? "on" : ""} onClick={() => set({ topic: t.id, node: null })}>{t.name}<small>{counts[t.id]}</small></button>)}</div>
    <div className="legend"><span><i style={{ borderColor: "var(--hero)" }} />Taught in your courses</span><span><i style={{ borderColor: "var(--amber)", background: "var(--amberT)" }} />Learn first</span><span><i style={{ borderColor: "#2C64C8", background: "#EEF3FD" }} />Leads to</span><span><i style={{ borderColor: "#bfe9d6", background: "var(--greenT)" }} />You know it</span>
      <label style={{ marginLeft: "auto", display: "flex", gap: 6, alignItems: "center", cursor: "pointer" }}><input type="checkbox" checked={showAll} onChange={e => set({ all: e.target.checked ? "1" : null, node: null })} />Include ideas not covered in class yet</label></div>
    <div className="maplay">
      <div className="canvas" ref={box}>
        {g.laid.length > 0 && <svg width={g.width + 32} height={g.height + 32} role="img" aria-label={`Ideas in ${topicById(topicId)?.name}`}><g transform="translate(16,16)">
          {g.edges.map(([a, b], i) => { const p = pos[a], q = pos[b]; if (!p || !q) return null; const x1 = p.x + NODE_W, y1 = p.y + NODE_H / 2, x2 = q.x, y2 = q.y + NODE_H / 2, m = (x1 + x2) / 2;
            return <path key={i} className={"me " + edgeState(a, b)} d={`M${x1},${y1} C${m},${y1} ${m},${y2} ${x2},${y2}`} />; })}
          {g.laid.map(n => { const c = byId(n.id), lines = wrap(c.title); return <g key={n.id} className={`nd ${coursesOf(c).length ? "taught" : ""} ${state(n.id)} ${known.has(n.id) && state(n.id) === "" ? "kn" : ""}`} transform={`translate(${n.x},${n.y})`} tabIndex={0} role="button" aria-label={c.title} onClick={() => pick(n.id)} onKeyDown={e => e.key === "Enter" && pick(n.id)}>
            <rect width={NODE_W} height={NODE_H} rx={10} />{lines.map((l, i) => <text key={i} x={NODE_W / 2} y={lines.length === 1 ? NODE_H / 2 + 4 : 20 + i * 15} textAnchor="middle">{l}</text>)}<title>{c.title}</title></g>; })}
        </g></svg>}
        {g.loose.length > 0 && <div><p className="sl" style={{ padding: "12px 14px 0", margin: 0 }}>{g.laid.length ? "Not linked to other ideas yet" : "Ideas in this topic"}</p>
          <div className="loose">{g.loose.map(id => { const c = byId(id); return <button key={id} className={(sel === id ? "sel " : "") + (coursesOf(c).length ? "taught" : "")} onClick={() => pick(id)}>{c.title}</button>; })}</div></div>}
        {!g.laid.length && !g.loose.length && <div className="empty">Nothing in this topic for the selected view.</div>}
      </div>
      <aside className="side" aria-live="polite">{!selC ? <>
        <h3>{topicById(topicId)?.name}</h3><p>{topicById(topicId)?.blurb}.</p><p>{g.pool.length} ideas shown. Click one to see what it builds on, what it leads to, and where it was taught.</p></> : <>
        <h3>{selC.title}</h3><p>{oneLine(selC)}</p>
        <div className="lbl">Taught in</div>{coursesOf(selC).length ? <div className="chips">{coursesOf(selC).map(code => { const ss = [...new Set(selC.evidence.filter(e => e.course === code && e.session).map(e => e.session))].sort((a, b) => a! - b!); return <Link key={code} className="chip2" to={`/compass/course/${code}?lens=${lens}`}>{code}{ss.length ? ` · S${ss.join(", S")}` : ""}</Link>; })}</div> : <p className="small">Not in your courses yet.</p>}
        {up.length > 0 && <><div className="lbl">Learn first</div><ul>{up.map(c => <li className="u" key={c.id}><button onClick={() => pick(c.id)}>{c.title}{coursesOf(c).length ? "" : <span className="small"> · not covered in class yet</span>}</button></li>)}</ul></>}
        {down.length > 0 && <><div className="lbl">Leads to</div><ul>{down.map(c => <li className="d" key={c.id}><button onClick={() => pick(c.id)}>{c.title}{coursesOf(c).length ? "" : <span className="small"> · not covered in class yet</span>}</button></li>)}</ul></>}
        {together.length > 0 && <><div className="lbl">Often taught together</div><ul>{together.map(c => <li key={c.id}><button onClick={() => pick(c.id)}>{c.title}</button></li>)}</ul></>}
        <div style={{ display: "flex", gap: 8, marginTop: 16, flexWrap: "wrap" }}><Link className="btn primary" to={ideaPath(selC.id, lens)}>Open full page</Link><button className={"btn" + (known.has(selC.id) ? " on" : "")} onClick={() => toggleKnown(selC.id)}>{known.has(selC.id) ? "✓ I know this" : "I know this"}</button></div></>}
      </aside>
    </div></section>;
}
