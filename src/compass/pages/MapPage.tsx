import { useCallback, useEffect, useLayoutEffect, useMemo, useRef, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { coursesOf, inLens, type Concept, type Store } from "../lib/data";
import { coTaught, NH, NW, reach, sharedSlide, treeLayout, type Tree } from "../lib/graph";
import { TOPICS, oneLine, topicById, topicOf } from "../lib/topics";
import { useKnown } from "../lib/known";
import { ideaPath } from "../components";

const PAD = 18, HEAD = 42, GAP = 36;
// One soft header colour per topic so a topic reads as one block when everything is on screen.
const COURSE_HUES = ["#E8EEF9", "#FBEFE3", "#EAF5EE", "#F6EAF3", "#E5F1F6", "#EDE9F8", "#FCEBEB", "#F3F0DF"];
const HUES: Record<string, string> = { strategy: "#E8EEF9", marketing: "#FBEFE3", pricing: "#EAF5EE", growth: "#F6EAF3", ops: "#EDEFE3", data: "#E5F1F6", ai: "#EDE9F8", product: "#FCEBEB", finance: "#F3F0DF", people: "#E9F2EC", cases: "#EFEFEF", industries: "#F2EBE4" };

const wrap = (t: string): string[] => { const out: string[] = []; let cur = "";
  for (const w of t.split(" ")) { if ((cur + " " + w).trim().length > 25 && cur) { out.push(cur); cur = w; } else cur = (cur + " " + w).trim(); }
  if (cur) out.push(cur); return out.length > 2 ? [out[0], out[1].slice(0, 23) + "…"] : out; };
interface View { k: number; x: number; y: number }
interface Cluster { topic: string; x: number; y: number; w: number; h: number; tree: Tree }

export default function MapPage({ store, lens }: { store: Store; lens: string }) {
  const [sp, setSp] = useSearchParams(); const [known, toggleKnown] = useKnown(); const box = useRef<HTMLDivElement>(null);
  const by = sp.get("by") === "course" ? "course" : "topic"; const focus = sp.get("focus") === "1"; const showAll = sp.get("all") === "1"; const sel = sp.get("node") || "";
  const groups = useMemo(() => by === "course" ? [...store.data.courses.map(c => ({ id: c.code, name: c.name })), { id: "none", name: "Not covered in class yet" }] : TOPICS.map(t => ({ id: t.id, name: t.name })), [by, store]);
  const gkey = useCallback((c: Concept) => (by === "course" ? coursesOf(c)[0] || "none" : topicOf(c)), [by]);
  const hue = (id: string) => (by === "course" ? COURSE_HUES[Math.max(0, groups.findIndex(x => x.id === id)) % COURSE_HUES.length] : HUES[id]);
  const topicParam = sp.get("topic") || ""; const topicId = groups.some(x => x.id === topicParam) && !focus ? topicParam : "";
  const set = (k: Record<string, string | null>) => { const n = new URLSearchParams(sp); n.set("lens", lens); for (const [a, b] of Object.entries(k)) { if (b === null) n.delete(a); else n.set(a, b); } setSp(n, { replace: true }); };
  const byId = (id: string) => store.data.concepts[id];

  const allPool = useMemo(() => Object.values(store.data.concepts).filter(c => inLens(c, lens) && (showAll || coursesOf(c).length)), [store, lens, showAll]);
  const allEdges = useMemo(() => { const ids = new Set(allPool.map(c => c.id)); const e: [string, string][] = []; for (const c of allPool) for (const r of c.rel) if (ids.has(r.to)) e.push([r.to, c.id]); return e; }, [allPool]);
  const chain = useMemo(() => (focus && sel ? reach(sel, allEdges) : null), [focus, sel, allEdges]);
  const pool = useMemo(() => chain ? allPool.filter(c => c.id === sel || chain.up.has(c.id) || chain.down.has(c.id)) : allPool.filter(c => !topicId || gkey(c) === topicId), [allPool, chain, sel, topicId, gkey]);
  const counts = useMemo(() => Object.fromEntries(groups.map(t => [t.id, allPool.filter(c => gkey(c) === t.id).length])), [groups, allPool, gkey]);
  const g = useMemo(() => {
    const inPool = new Set(pool.map(c => c.id)); const dEdges: [string, string][] = [];
    for (const c of pool) for (const r of c.rel) if (inPool.has(r.to)) dEdges.push([r.to, c.id]);
    const hasD = new Set(dEdges.flat()); const slide = sharedSlide(store); const uEdges: [string, string][] = []; const seen = new Set<string>();
    for (const c of pool) if (!hasD.has(c.id)) for (const n of slide[c.id] || []) if (inPool.has(n)) { const k = [c.id, n].sort().join("|"); if (!seen.has(k)) { seen.add(k); uEdges.push([n, c.id]); } }
    const buckets = groups.map(t => ({ t: t.id, ids: pool.filter(c => gkey(c) === t.id).map(c => c.id) })).filter(x => x.ids.length);
    const perRow = topicId ? 9 : 4; const items = buckets.map(x => { const tree = treeLayout(x.ids, dEdges, uEdges, perRow); return { topic: x.t, tree, w: Math.max(tree.w, 220) + PAD * 2, h: HEAD + tree.h + PAD * 2 }; });
    const area = items.reduce((s, i) => s + i.w * i.h, 0); const target = topicId ? 0 : Math.max(1500, Math.sqrt(area) * 1.55);
    const clusters: Cluster[] = []; let x = 0, y = 0, rowH = 0, W = 0;
    for (const i of items) { if (x > 0 && x + i.w > target) { x = 0; y += rowH + GAP; rowH = 0; } clusters.push({ topic: i.topic, x, y, w: i.w, h: i.h, tree: i.tree }); x += i.w + GAP; rowH = Math.max(rowH, i.h); W = Math.max(W, x - GAP); }
    const H = y + rowH; const abs: Record<string, { x: number; y: number }> = {};
    for (const c of clusters) for (const n of [...c.tree.nodes, ...c.tree.loose]) abs[n.id] = { x: c.x + PAD + (c.w - PAD * 2 - c.tree.w) / 2 + n.x, y: c.y + HEAD + PAD + n.y };
    return { dEdges, uEdges, clusters, abs, W, H };
  }, [pool, store, topicId, groups, gkey]);

  // ---- pan and zoom ----
  const [view, setView] = useState<View>({ k: 1, x: 0, y: 0 }); const [drag, setDrag] = useState(false); const moved = useRef(false); const start = useRef({ x: 0, y: 0, vx: 0, vy: 0 });
  const fit = useCallback(() => { const el = box.current; if (!el || !g.W) return; const k = topicId ? Math.min(1, Math.max(0.4, el.clientWidth / (g.W + 40))) : Math.min(1, Math.max(0.12, Math.min(el.clientWidth / (g.W + 40), el.clientHeight / (g.H + 40))));
    setView({ k, x: (el.clientWidth - g.W * k) / 2, y: topicId ? 16 : Math.max(16, (el.clientHeight - g.H * k) / 2) }); }, [g.W, g.H, topicId]);
  useLayoutEffect(() => { fit(); }, [fit]);
  const zoomAt = (f: number, cx: number, cy: number) => setView(v => { const k = Math.min(2.2, Math.max(0.1, v.k * f)); const r = k / v.k; return { k, x: cx - (cx - v.x) * r, y: cy - (cy - v.y) * r }; });
  const zoomMid = (f: number) => { const el = box.current; if (el) zoomAt(f, el.clientWidth / 2, el.clientHeight / 2); };
  useEffect(() => { const el = box.current; if (!el) return; const onWheel = (e: WheelEvent) => { if (!(e.ctrlKey || e.metaKey)) return; e.preventDefault(); const r = el.getBoundingClientRect(); zoomAt(e.deltaY < 0 ? 1.12 : 0.89, e.clientX - r.left, e.clientY - r.top); };
    el.addEventListener("wheel", onWheel, { passive: false }); return () => el.removeEventListener("wheel", onWheel); }, [g.W]);
  const pdown = (e: React.PointerEvent) => { start.current = { x: e.clientX, y: e.clientY, vx: view.x, vy: view.y }; moved.current = false; };
  const pmove = (e: React.PointerEvent) => { if (!(e.buttons & 1)) return; const dx = e.clientX - start.current.x, dy = e.clientY - start.current.y; if (!moved.current && Math.hypot(dx, dy) < 5) return; moved.current = true; setDrag(true); setView(v => ({ ...v, x: start.current.vx + dx, y: start.current.vy + dy })); };
  const pup = () => setDrag(false);

  const selC: Concept | undefined = sel ? byId(sel) : undefined; const a = sel ? g.abs[sel] : undefined; const inMap = !!selC && !!a;
  const rch = inMap ? reach(sel, allEdges) : { up: new Set<string>(), down: new Set<string>() };
  useEffect(() => { const el = box.current; if (!sel || !a || !el) return; const open = el.clientWidth > 760 ? 340 : 0;
    setView(v => { const k = Math.max(v.k, 0.8); return { k, x: (el.clientWidth - open) / 2 - (a.x + NW / 2) * k, y: el.clientHeight / 2 - (a.y + NH / 2) * k }; }); }, [sel]); // eslint-disable-line react-hooks/exhaustive-deps
  useEffect(() => { const h = (e: KeyboardEvent) => { if (e.key === "Escape" && sel) set({ node: null }); }; window.addEventListener("keydown", h); return () => window.removeEventListener("keydown", h); }); // eslint-disable-line react-hooks/exhaustive-deps
  const pick = (id: string) => { if (moved.current) return; const c = byId(id); if (c) set({ node: id, ...(topicId ? { topic: gkey(c) } : {}) }); };
  const state = (id: string) => (!inMap ? "" : id === sel ? "sel" : rch.up.has(id) ? "up" : rch.down.has(id) ? "down" : "dim");
  const edgeState = (p: string, q: string) => (!inMap ? "" : (p === sel || rch.up.has(p)) && (q === sel || rch.up.has(q)) ? "up" : (p === sel || rch.down.has(p)) && (q === sel || rch.down.has(q)) ? "down" : "dim");
  const curve = (p: { x: number; y: number }, q: { x: number; y: number }) => { const x1 = p.x + NW / 2, y1 = p.y + NH, x2 = q.x + NW / 2, y2 = q.y, d = Math.max(28, Math.abs(y2 - y1) / 2); return `M${x1},${y1} C${x1},${y1 + d} ${x2},${y2 - d} ${x2},${y2}`; };

  const up = selC ? selC.rel.map(x => byId(x.to)).filter(Boolean) : []; const down = selC ? (store.reverse[selC.id] || []).map(byId) : [];
  const together = selC ? Object.entries(coTaught(store)[selC.id] || {}).filter(([, n]) => n >= 2).sort((x, y) => y[1] - x[1]).slice(0, 5).map(([i]) => byId(i)).filter(Boolean) : [];
  const note = (c: Concept) => (coursesOf(c).length ? "" : <span className="small"> · not covered in class yet</span>);
  const auto = (c: Concept, to: string) => c.rel.find(r => r.to === to)?.auto;

  const cross = selC ? new Set([...up, ...down].map(c => topicOf(c)).filter(t => t !== topicOf(selC))).size : 0;
  const tag = (c: Concept) => by === "topic" && selC && topicOf(c) !== topicOf(selC) ? <span className="xt">{topicById(topicOf(c))?.name}</span> : by === "course" && selC && gkey(c) !== gkey(selC) ? gkey(c) === "none" ? null : <span className="xt">{gkey(c)}</span> : null;
  return <section><div className="mapctl"><div className="seg2" role="group" aria-label="Group the map by"><span>Group by</span><button className={by === "topic" ? "on" : ""} onClick={() => set({ by: null, topic: null, node: null, focus: null })}>Topic</button><button className={by === "course" ? "on" : ""} onClick={() => set({ by: "course", topic: null, node: null, focus: null })}>Course</button></div>
      {focus && <button className="btn on" onClick={() => set({ focus: null })}>Showing one chain · show everything</button>}</div>
    <div className="mapbar" role="tablist" aria-label="Group">
      <button role="tab" aria-selected={!topicId && !focus} className={!topicId && !focus ? "on" : ""} onClick={() => set({ topic: null, node: null, focus: null })}>{by === "course" ? "All courses" : "All topics"}<small>{allPool.length}</small></button>
      {groups.filter(t => counts[t.id]).map(t => <button key={t.id} role="tab" aria-selected={t.id === topicId} className={t.id === topicId ? "on" : ""} onClick={() => set({ topic: t.id, node: null, focus: null })}>{t.name}<small>{counts[t.id]}</small></button>)}</div>
    <div className="maptools"><div className="legend"><span><i style={{ borderColor: "var(--hero)" }} />Taught in your courses</span><span><i style={{ borderColor: "var(--hero)", borderWidth: 3 }} />Thick: taught in 2+ courses</span><span><i style={{ borderColor: "var(--amber)", background: "var(--amberT)" }} />Learn first</span><span><i style={{ borderColor: "#2C64C8", background: "#EEF3FD" }} />Leads to</span></div>
      <div className="zoom"><label><input type="checkbox" checked={showAll} onChange={e => set({ all: e.target.checked ? "1" : null, node: null })} /> Include ideas not covered in class</label>
        <button className="btn" onClick={() => zoomMid(0.8)} aria-label="Zoom out">−</button><button className="btn" onClick={() => zoomMid(1.25)} aria-label="Zoom in">+</button><button className="btn" onClick={fit}>Fit</button></div></div>
    <div className="mapwrap">
      <div className={"canvas2" + (drag ? " drag" : "")} ref={box} onPointerDown={pdown} onPointerMove={pmove} onPointerUp={pup} onPointerLeave={pup}>
        <svg width="100%" height="100%" role="img" aria-label="Map of ideas"><g style={{ transform: `translate(${view.x}px,${view.y}px) scale(${view.k})`, transformOrigin: "0 0", transition: drag ? "none" : "transform .3s ease" }}>
          {g.clusters.map(c => <g key={c.topic} transform={`translate(${c.x},${c.y})`}>
            <rect width={c.w} height={c.h} rx={16} fill={hue(c.topic)} stroke="#e5e5e3" />
            <g className={topicId ? "" : "chead"} onClick={() => !topicId && !moved.current && set({ topic: c.topic, node: null })}><rect width={c.w} height={HEAD} rx={16} fill="transparent" /><text x={PAD} y={27} className="ct">{groups.find(x => x.id === c.topic)?.name}</text><text x={c.w - PAD} y={27} textAnchor="end" className="cn2">{c.tree.nodes.length + c.tree.loose.length} ideas{topicId ? "" : " · open ›"}</text></g>
            {c.tree.loose.length > 0 && <text x={PAD} y={HEAD + PAD + c.tree.looseY + 12} className="cn2">Not linked to other ideas yet</text>}</g>)}
          {g.dEdges.map(([p, q], i) => g.abs[p] && g.abs[q] && <path key={"d" + i} className={"me " + edgeState(p, q)} d={curve(g.abs[p], g.abs[q])} />)}
          {g.uEdges.map(([p, q], i) => g.abs[p] && g.abs[q] && <path key={"u" + i} className={"me dash " + edgeState(p, q)} d={curve(g.abs[p], g.abs[q])} />)}
          {[...g.clusters.flatMap(c => [...c.tree.nodes, ...c.tree.loose])].map(n => { const c = byId(n.id), p = g.abs[n.id], lines = wrap(c.title), nc = coursesOf(c).length;
            return <g key={n.id} className={`nd ${nc ? "taught" : ""} ${nc > 1 ? "multi" : ""} ${state(n.id)} ${known.has(n.id) && state(n.id) === "" ? "kn" : ""}`} transform={`translate(${p.x},${p.y})`} tabIndex={0} role="button" aria-label={c.title} onClick={() => pick(n.id)} onKeyDown={e => e.key === "Enter" && pick(n.id)}>
              <rect width={NW} height={NH} rx={9} />{lines.map((l, i) => <text key={i} x={NW / 2} y={lines.length === 1 ? NH / 2 + 4 : 19 + i * 14} textAnchor="middle">{l}</text>)}<title>{c.title}</title></g>; })}
        </g></svg>
        {!pool.length && <div className="empty">Nothing in this view. Switch to All ideas.</div>}
      </div>
      {selC && <aside className="drawer" aria-live="polite"><button className="x" onClick={() => set({ node: null })} aria-label="Close panel">×</button>
        <h3>{selC.title}</h3><p>{oneLine(selC)}</p>
        <p className="small">{coursesOf(selC).length ? `Taught in ${coursesOf(selC).length} ${coursesOf(selC).length === 1 ? "course" : "courses"}` : "Not taught in your courses yet"} · {up.length + down.length} direct links{cross ? ` · reaches ${cross} other ${cross === 1 ? "topic" : "topics"}` : ""}</p>
        <button className={"btn" + (focus ? " on" : "")} onClick={() => set({ focus: focus ? null : "1", topic: null })}>{focus ? "Show everything again" : "Show only this chain"}</button>
        <div className="lbl">Taught in</div>{coursesOf(selC).length ? <div className="chips">{coursesOf(selC).map(code => { const ss = [...new Set(selC.evidence.filter(e => e.course === code && e.session).map(e => e.session))].sort((x, y) => x! - y!); return <Link key={code} className="chip2" to={`/compass/course/${code}?lens=${lens}`}>{code}{ss.length ? ` · S${ss.join(", S")}` : ""}</Link>; })}</div> : <p className="small">Not in your courses yet.</p>}
        {up.length > 0 && <><div className="lbl">Learn first</div><ul>{up.map(c => <li className="u" key={c.id}><button onClick={() => pick(c.id)} title={selC.rel.find(r => r.to === c.id)?.why}>{c.title}{tag(c)}{note(c)}{auto(selC, c.id) ? <span className="small"> · suggested</span> : null}</button></li>)}</ul></>}
        {down.length > 0 && <><div className="lbl">Leads to</div><ul>{down.map(c => <li className="d" key={c.id}><button onClick={() => pick(c.id)} title={c.rel.find(r => r.to === selC.id)?.why}>{c.title}{tag(c)}{note(c)}{auto(c, selC.id) ? <span className="small"> · suggested</span> : null}</button></li>)}</ul></>}
        {together.length > 0 && <><div className="lbl">Often taught together</div><ul>{together.map(c => <li key={c.id}><button onClick={() => pick(c.id)}>{c.title}{tag(c)}</button></li>)}</ul></>}
        <div style={{ display: "flex", gap: 8, marginTop: 16, flexWrap: "wrap" }}><Link className="btn primary" to={ideaPath(selC.id, lens)}>Open full page</Link><button className={"btn" + (known.has(selC.id) ? " on" : "")} onClick={() => toggleKnown(selC.id)}>{known.has(selC.id) ? "✓ I know this" : "I know this"}</button></div></aside>}
    </div>
    <p className="small" style={{ marginTop: 10 }}>Drag to move around. Zoom with the + and − buttons, or hold Ctrl (⌘ on Mac) and scroll. Click an idea to see what it builds on and leads to. Dashed lines join ideas taught on the same slide that have no prerequisite link yet.</p>
  </section>;
}
