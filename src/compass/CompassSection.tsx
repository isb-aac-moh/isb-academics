import { useEffect, useState } from "react";
import { Link, Route, Routes, useNavigate, useSearchParams } from "react-router-dom";
import { LENSES, loadStore, type Store } from "./lib/data";
import Home from "./pages/Home";
import ConceptPage from "./pages/ConceptPage";
import CoursePage from "./pages/CoursePage";
import LensPage from "./pages/LensPage";
import MapPage from "./pages/MapPage";
import "./compass.css";

export function useLens(): [string, (l: string) => void] {
  const [sp, setSp] = useSearchParams();
  let stored = "all"; try { stored = localStorage.getItem("compass.lens") || "all"; } catch { /* private mode */ }
  const lens = sp.get("lens") || stored;
  return [LENSES.some(l => l.id === lens) ? lens : "all", (l) => { try { localStorage.setItem("compass.lens", l); } catch { /* ignore */ } const n = new URLSearchParams(sp); n.set("lens", l); setSp(n, { replace: true }); }];
}

export default function CompassSection() {
  const [store, setStore] = useState<Store | null>(null); const [err, setErr] = useState(false);
  const [lens, setLens] = useLens(); const [sp] = useSearchParams(); const nav = useNavigate();
  useEffect(() => { loadStore().then(setStore).catch(() => setErr(true)); }, []);
  const q = sp.get("q") || "";
  const go = (v: string) => { const n = new URLSearchParams(); n.set("lens", lens); if (v) n.set("q", v); nav("/compass?" + n.toString(), { replace: !!sp.get("q") }); };
  return (
    <div className="compass"><div className="shell">
      <header className="top">
        <div className="bar">
          <Link to={`/compass?lens=${lens}`} className="brand">Compass<span>where was this taught</span></Link>
          <input className="search" type="search" placeholder="Search any idea, like market sizing or newsvendor" aria-label="Search any idea" value={q} onChange={e => go(e.target.value)} />
        </div>
        <nav className="lenses" aria-label="View for">
          <Link to={`/compass/map?lens=${lens}`} className="chip maplink">Map</Link>
          <span className="viewfor">View for</span>
          {LENSES.map(l => <button key={l.id} className={"chip " + (lens === l.id ? "on" : "")} aria-pressed={lens === l.id} onClick={() => setLens(l.id)}>{l.name}</button>)}
        </nav>
      </header>
      <main>
        {err && <p className="note">Compass could not load its data. Check your connection and sign in again.</p>}
        {!store && !err && <p className="note">Loading…</p>}
        {store && <Routes>
          <Route index element={<Home store={store} lens={lens} />} />
          <Route path="c/:id" element={<ConceptPage store={store} lens={lens} />} />
          <Route path="course/:code" element={<CoursePage store={store} lens={lens} />} />
          <Route path="map" element={<MapPage store={store} lens={lens} />} />
          <Route path="lens/:id" element={<LensPage store={store} />} />
          <Route path="*" element={<p className="note">Page not found. <Link to="/compass">Back to search</Link></p>} />
        </Routes>}
      </main>
      <footer className="foot">Prototype. Built from ISB course material for ISB students. Slides open in Moodle; nothing here is a copy of faculty files.</footer>
    </div></div>
  );
}
