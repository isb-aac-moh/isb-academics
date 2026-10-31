import { useEffect, useState } from "react";
import { TextSkeleton } from "../components/Skeleton";
import { Link, NavLink, Route, Routes, useLocation, useSearchParams } from "react-router-dom";
import { LENSES, loadStore, type Store } from "./lib/data";
import Home from "./pages/Home";
import ConceptPage from "./pages/ConceptPage";
import { CoursePage, CoursesPage } from "./pages/CoursePage";
import { TopicPage, TopicsPage } from "./pages/TopicsPage";
import { PrepKitPage, PrepPage } from "./pages/PrepPage";
import MapPage from "./pages/MapPage";
import ComparePage from "./pages/ComparePage";
import RoadmapPage from "./pages/RoadmapPage";
import "./compass.css";

function useLens(): [string, (l: string) => void] {
  const [sp, setSp] = useSearchParams();
  let stored = "all"; try { stored = localStorage.getItem("compass.lens") || "all"; } catch { /* private mode */ }
  const lens = sp.get("lens") || stored;
  return [LENSES.some(l => l.id === lens) ? lens : "all", (l) => { try { localStorage.setItem("compass.lens", l); } catch { /* ignore */ } const n = new URLSearchParams(sp); n.set("lens", l); setSp(n, { replace: true }); }];
}

const TABS = [["", "Search"], ["topics", "Topics"], ["courses", "Courses"], ["prep", "Prep kits"], ["map", "Map"], ["compare", "Across courses"]] as const;

export default function CompassSection() {
  const [store, setStore] = useState<Store | null>(null); const [err, setErr] = useState(false);
  const [lens, setLens] = useLens(); const loc = useLocation();
  useEffect(() => { loadStore().then(setStore).catch(() => setErr(true)); }, []);
  // A new page should open at its top. Only the path triggers this, so picking an idea on the map or
  // switching the view (search params) keeps the reader where they are.
  useEffect(() => { window.scrollTo(0, 0); }, [loc.pathname]);
  const showLens = !/^\/compass\/(prep|roadmap)/.test(loc.pathname);
  return <div className="compass"><div className="wrap">
    <header className="ph"><h1><Link to={`/compass?lens=${lens}`}>ISB <em>Compass</em></Link></h1></header>
    <nav className="nav" aria-label="Compass sections">
      <div className="tabs">{TABS.map(([p, label]) => <NavLink key={p} end={p === ""} to={`/compass${p ? "/" + p : ""}?lens=${lens}`} className={({ isActive }) => "tab" + (isActive ? " on" : "")}>{label}</NavLink>)}</div>
      {showLens && <div className="seg"><span>Show</span><div role="group" aria-label="Show ideas for">{LENSES.map(l => <button key={l.id} className={lens === l.id ? "on" : ""} aria-pressed={lens === l.id} title={l.blurb} onClick={() => setLens(l.id)}>{l.name}</button>)}</div></div>}
    </nav>
    {err && <p className="note" style={{ marginTop: 24 }}>Compass could not load its data. Check your connection and sign in again.</p>}
    {!store && !err && <div style={{ marginTop: 24 }}><TextSkeleton lines={6} /></div>}
    {store && <Routes>
      <Route index element={<Home store={store} lens={lens} />} />
      <Route path="c/:id" element={<ConceptPage store={store} lens={lens} />} />
      <Route path="topics" element={<TopicsPage store={store} lens={lens} />} />
      <Route path="topics/:id" element={<TopicPage store={store} lens={lens} />} />
      <Route path="courses" element={<CoursesPage store={store} lens={lens} />} />
      <Route path="course/:code" element={<CoursePage store={store} lens={lens} />} />
      <Route path="prep" element={<PrepPage store={store} />} />
      <Route path="prep/:id" element={<PrepKitPage store={store} lens={lens} />} />
      <Route path="map" element={<MapPage store={store} lens={lens} />} />
      <Route path="compare" element={<ComparePage store={store} lens={lens} />} />
      {/* Reviewer-only pitch page for the pilot. Not in the tab bar; linked from the landing page. Delete with the note in Home.tsx before production. */}
      <Route path="roadmap" element={<RoadmapPage store={store} lens={lens} />} />
      <Route path="*" element={<p className="note" style={{ marginTop: 24 }}>Page not found. <Link to="/compass">Back to search</Link></p>} />
    </Routes>}
    <p className="small" style={{ marginTop: 48 }}>Prototype. Built from ISB course material for ISB students. Slides open in Moodle; nothing here is a copy of faculty files.</p>
  </div></div>;
}
