import type { CSSProperties, ReactNode } from "react";
import { COLOR, FONT } from "../lib/theme";

/* Grey placeholder shapes shown while the app or a page is loading. Each layout below copies the
   real page's spacing and block sizes, so when the data arrives the content fills in where the
   shapes were instead of the page jumping. Styles live in index.css (.skeleton). */

type BoneProps = { w?: number | string; h?: number | string; r?: number; dark?: boolean; style?: CSSProperties };

export function Bone({ w = "100%", h = 14, r = 6, dark, style }: BoneProps) {
  return <div aria-hidden className={dark ? "skeleton skeleton-dark" : "skeleton"} style={{ width: w, height: h, borderRadius: r, flexShrink: 0, ...style }} />;
}

/** Stacked text lines; the last one is shorter, like the end of a paragraph. */
export function BoneLines({ lines = 3, h = 12, gap = 8 }: { lines?: number; h?: number; gap?: number }) {
  return (
    <div style={{ display: "grid", gap }}>
      {Array.from({ length: lines }, (_, i) => <Bone key={i} h={h} w={i === lines - 1 && lines > 1 ? "60%" : "100%"} />)}
    </div>
  );
}

function Card({ children, style }: { children: ReactNode; style?: CSSProperties }) {
  return <div style={{ padding: "14px 16px", borderRadius: 12, background: COLOR.surface, border: `1px solid ${COLOR.borderLight}`, ...style }}>{children}</div>;
}

function Header({ title = 220, sub = 2, children }: { title?: number; sub?: number; children?: ReactNode }) {
  return (
    <header className="px-6 md:px-12 pt-10 pb-6">
      <Bone w={title} h={28} r={8} />
      <div style={{ marginTop: 12, maxWidth: 560 }}><BoneLines lines={sub} h={13} /></div>
      {children}
    </header>
  );
}

function SectionLabel() {
  return <Bone w={180} h={11} style={{ marginBottom: 12 }} />;
}

export type PageVariant = "dashboard" | "planner" | "cards" | "list";

const GRID = "grid gap-3";

/** Four stat tiles, then a few titled blocks: Credit Tracker, Pulse Check and anything unknown. */
function Dashboard() {
  return (
    <>
      <Header title={200}>
        <div className={`${GRID} grid-cols-2 lg:grid-cols-4 mt-6`} style={{ maxWidth: 920 }}>
          {[0, 1, 2, 3].map((i) => (
            <Card key={i} style={{ height: 88 }}>
              <Bone w="55%" h={11} />
              <Bone w="35%" h={24} r={6} style={{ marginTop: 12 }} />
            </Card>
          ))}
        </div>
      </Header>
      <main className="px-6 md:px-12 space-y-8" style={{ maxWidth: 1000 }}>
        {[3, 2].map((n, s) => (
          <div key={s}>
            <SectionLabel />
            <div className={`${GRID} grid-cols-1 sm:grid-cols-2 lg:grid-cols-3`}>
              {Array.from({ length: n }, (_, i) => <Card key={i} style={{ height: 96 }}><Bone w="50%" h={14} /><Bone w="30%" h={10} style={{ marginTop: 12 }} /><Bone h={5} r={3} style={{ marginTop: 14 }} /></Card>)}
            </div>
          </div>
        ))}
      </main>
    </>
  );
}

/** Step pills and two summary tiles above a content area: Bidding Planner. */
function Planner() {
  return (
    <>
      <Header title={190} sub={0}>
        <div className="flex items-center gap-2 mt-6 flex-wrap">
          {[96, 84, 120, 104].map((w, i) => <Bone key={i} w={w} h={32} r={16} />)}
        </div>
        <div className="flex flex-wrap gap-3 mt-6">
          <Bone w={150} h={34} r={9} />
          <Bone w={190} h={34} r={9} />
        </div>
      </Header>
      <main className="px-6 md:px-12 space-y-3" style={{ maxWidth: 1600 }}>
        {[0, 1, 2].map((i) => <Card key={i} style={{ height: 120, maxWidth: 760 }}><Bone w="40%" h={14} /><div style={{ marginTop: 14, maxWidth: 480 }}><BoneLines lines={2} /></div></Card>)}
      </main>
    </>
  );
}

/** A title, a few figures, tabs and a grid of course cards: the term dossiers. */
function Cards() {
  return (
    <div className="px-5 md:px-8 py-7" style={{ maxWidth: 1200, margin: "0 auto" }}>
      <Bone w={300} h={36} r={8} />
      <div style={{ marginTop: 12, maxWidth: 560 }}><BoneLines lines={2} h={13} /></div>
      <div className="flex flex-wrap gap-3 mt-6 mb-6">
        {[0, 1, 2].map((i) => <Bone key={i} w={150} h={58} r={12} />)}
      </div>
      <div className="flex gap-3 mb-5" style={{ borderBottom: `1px solid ${COLOR.border}`, paddingBottom: 12 }}>
        {[60, 100, 110].map((w, i) => <Bone key={i} w={w} h={14} />)}
      </div>
      <div className={`${GRID} grid-cols-1 md:grid-cols-2 lg:grid-cols-3`}>
        {Array.from({ length: 6 }, (_, i) => (
          <Card key={i} style={{ height: 150, padding: 16 }}>
            <Bone w="25%" h={10} />
            <Bone w="75%" h={16} style={{ marginTop: 12 }} />
            <div style={{ marginTop: 16 }}><BoneLines lines={2} /></div>
          </Card>
        ))}
      </div>
    </div>
  );
}

/** A title, a search box, filter chips and a stack of rows: Course Resources and the Notice Board. */
function List() {
  return (
    <>
      <Header title={210} sub={1}>
        <Bone w="100%" h={44} r={11} style={{ marginTop: 24, maxWidth: 540 }} />
        <div className="flex flex-wrap gap-1.5 mt-4">
          {[72, 56, 56, 56, 64].map((w, i) => <Bone key={i} w={w} h={28} r={14} />)}
        </div>
      </Header>
      <main className="px-6 md:px-12 space-y-3" style={{ maxWidth: 720 }}>
        {[0, 1, 2, 3, 4].map((i) => (
          <Card key={i} style={{ padding: "16px 18px" }}>
            <div className="flex items-center gap-2" style={{ marginBottom: 12 }}><Bone w={52} h={18} r={6} /><Bone w={80} h={11} /></div>
            <Bone w="55%" h={15} />
            <div style={{ marginTop: 10 }}><BoneLines lines={2} h={11} /></div>
          </Card>
        ))}
      </main>
    </>
  );
}

const VARIANTS: Record<PageVariant, () => ReactNode> = { dashboard: Dashboard, planner: Planner, cards: Cards, list: List };

/** The page-sized placeholder: used while a route's code downloads and while its data loads. */
export function PageSkeleton({ variant = "dashboard" }: { variant?: PageVariant }) {
  const Layout = VARIANTS[variant];
  return (
    <div data-skeleton role="status" aria-busy="true" aria-label="Loading" className="min-h-screen pb-24" style={{ background: COLOR.bg }}>
      <Layout />
    </div>
  );
}

function variantForPath(pathname: string): PageVariant {
  if (pathname.startsWith("/planner")) return "planner";
  if (pathname.startsWith("/dossier") || pathname.startsWith("/term") || pathname.startsWith("/compass") || pathname.startsWith("/learn")) return "cards";
  if (pathname.startsWith("/resources") || pathname.startsWith("/notices") || pathname.startsWith("/admin")) return "list";
  return "dashboard";
}

/** The placeholder for whichever page the URL points at, so it matches the page about to appear. */
export function RouteSkeleton({ pathname }: { pathname: string }) {
  return <PageSkeleton variant={variantForPath(pathname)} />;
}

/** The whole app frame (sidebar, mobile top bar, page area) for the first load, before we know who is signed in. */
export function AppShellSkeleton() {
  return (
    <div data-skeleton role="status" aria-busy="true" aria-label="Loading" className="flex flex-col md:flex-row">
      <header className="flex md:hidden items-center justify-between" style={{ position: "sticky", top: 0, background: COLOR.navyHero, padding: "14px 16px", height: 51 }}>
        <div>
          <span style={{ fontFamily: FONT.sans, fontWeight: 800, fontSize: 13, color: "#fff" }}>ISB </span>
          <span style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 13, color: COLOR.mint }}>Academics</span>
        </div>
        <Bone dark w={22} h={16} r={4} />
      </header>
      <aside className="hidden md:flex flex-col justify-between" style={{ width: 220, height: "100vh", position: "sticky", top: 0, background: COLOR.navyHero, flexShrink: 0, padding: "24px 12px" }}>
        <div>
          <div style={{ paddingLeft: 4 }}>
            <p style={{ fontFamily: FONT.sans, fontWeight: 800, fontSize: 14, color: "#fff" }}>ISB</p>
            <p style={{ fontFamily: FONT.sans, fontWeight: 700, fontSize: 12, color: COLOR.mint, marginTop: 1 }}>Academics</p>
          </div>
          <div className="mt-8" style={{ display: "grid", gap: 4 }}>
            {[0, 1, 2, 3, 4, 5].map((i) => <Bone key={i} dark h={34} r={8} />)}
          </div>
        </div>
        <Bone dark w="60%" h={12} />
      </aside>
      <div style={{ flex: 1, minWidth: 0 }} className="pb-[calc(3.25rem+env(safe-area-inset-bottom))] md:pb-0">
        <div className="min-h-screen pb-24" style={{ background: COLOR.bg }}><Dashboard /></div>
      </div>
    </div>
  );
}

/** Learn pages open inside a floating window: a heading, a line of intro and a few tiles. */
export function LearnSkeleton({ tiles = 4 }: { tiles?: number }) {
  return (
    <div data-skeleton role="status" aria-busy="true" aria-label="Loading" className="px-5 py-8 md:px-8 md:py-10 max-w-3xl">
      <Bone w={160} h={28} r={8} />
      <div style={{ margin: "12px 0 28px", maxWidth: 420 }}><BoneLines lines={1} h={13} /></div>
      <LearnTiles tiles={tiles} />
    </div>
  );
}

/** Just the grid of tiles, for places where the heading is already on screen. */
export function LearnTiles({ tiles = 4 }: { tiles?: number }) {
  return (
    <div role="status" aria-busy="true" aria-label="Loading" className="grid gap-3 sm:grid-cols-2">
      {Array.from({ length: tiles }, (_, i) => <Bone key={i} h={84} r={12} />)}
    </div>
  );
}

/** A few lines of text, for small panels (a progress summary, a stats block). */
export function TextSkeleton({ lines = 4 }: { lines?: number }) {
  return (
    <div role="status" aria-busy="true" aria-label="Loading"><BoneLines lines={lines} h={14} gap={12} /></div>
  );
}
