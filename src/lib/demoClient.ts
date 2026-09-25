// A tiny stand-in for the Supabase JS client, used only in demo mode (see demoMode.ts).
// It supports exactly the query shapes this app actually issues — .from().select/.insert/
// .update/.upsert/.delete with .eq/.neq/.order/.single/.maybeSingle, plus .rpc() and a stub
// .storage — against an in-memory table store, so every existing hook and admin page works
// completely unmodified. Nothing here ever touches the network.
type Row = Record<string, unknown>;
type Store = Record<string, Row[]>;
type RpcHandler = (params: Record<string, unknown> | undefined, store: Store) => unknown;

function newId(): string {
  return typeof crypto !== "undefined" && crypto.randomUUID ? crypto.randomUUID() : Math.random().toString(36).slice(2);
}

// Declarative registry for the one PostgREST embedded-resource join this app makes
// (`courses!inner(name, code)` off learn_courses) — see learn/lib/db.ts's fetchCourses.
const EMBEDS: Record<string, Record<string, { table: string; localKey: string; foreignKey: string }>> = {
  learn_courses: { courses: { table: "courses", localKey: "course_code", foreignKey: "code" } },
};

function splitTopLevel(cols: string): string[] {
  const parts: string[] = [];
  let depth = 0;
  let current = "";
  for (const ch of cols) {
    if (ch === "(") depth++;
    if (ch === ")") depth--;
    if (ch === "," && depth === 0) {
      parts.push(current);
      current = "";
    } else {
      current += ch;
    }
  }
  if (current.trim()) parts.push(current);
  return parts;
}

interface ParsedSelect {
  plain: { alias: string; column: string }[];
  embeds: string[];
}

function parseSelect(cols: string | undefined): ParsedSelect | null {
  if (!cols || cols.trim() === "*") return null;
  const plain: ParsedSelect["plain"] = [];
  const embeds: string[] = [];
  for (const raw of splitTopLevel(cols)) {
    const part = raw.trim();
    const embedMatch = part.match(/^(\w+)(!inner)?\(/);
    if (embedMatch) {
      embeds.push(embedMatch[1]);
      continue;
    }
    const aliasMatch = part.match(/^(\w+):(\w+)$/);
    if (aliasMatch) plain.push({ alias: aliasMatch[1], column: aliasMatch[2] });
    else if (part) plain.push({ alias: part, column: part });
  }
  return { plain, embeds };
}

function project(row: Row, table: string, parsed: ParsedSelect | null, store: Store): Row {
  if (!parsed) return { ...row };
  const out: Row = {};
  for (const { alias, column } of parsed.plain) out[alias] = row[column];
  for (const name of parsed.embeds) {
    const embed = EMBEDS[table]?.[name];
    out[name] = embed ? (store[embed.table] ?? []).find((r) => r[embed.foreignKey] === row[embed.localKey]) ?? null : null;
  }
  return out;
}

type Resolver = (value: { data: unknown; error: { code?: string; message: string } | null }) => unknown;

class Awaitable {
  private compute: () => { data: unknown; error: { code?: string; message: string } | null };
  constructor(compute: () => { data: unknown; error: { code?: string; message: string } | null }) {
    this.compute = compute;
  }
  then(onfulfilled?: Resolver | null, onrejected?: ((reason: unknown) => unknown) | null) {
    return Promise.resolve(this.compute()).then(onfulfilled ?? undefined, onrejected ?? undefined);
  }
}

class DemoQueryBuilder extends Awaitable {
  private mode: "select" | "insert" | "update" | "upsert" | "delete" = "select";
  private payload: Row | Row[] | null = null;
  private upsertConflict?: string;
  private filters: { col: string; op: "eq" | "neq"; val: unknown }[] = [];
  private orders: { col: string; ascending: boolean }[] = [];
  private selectCols?: string;
  private wantSingle = false;
  private wantMaybe = false;
  private store: Store;
  private table: string;

  constructor(store: Store, table: string) {
    super(() => this.execute());
    this.store = store;
    this.table = table;
  }

  select(cols?: string) {
    this.selectCols = cols;
    return this;
  }
  eq(col: string, val: unknown) {
    this.filters.push({ col, op: "eq", val });
    return this;
  }
  neq(col: string, val: unknown) {
    this.filters.push({ col, op: "neq", val });
    return this;
  }
  order(col: string, opts?: { ascending?: boolean }) {
    this.orders.push({ col, ascending: opts?.ascending ?? true });
    return this;
  }
  maybeSingle() {
    this.wantMaybe = true;
    return this;
  }
  single() {
    this.wantSingle = true;
    return this;
  }
  insert(obj: Row | Row[]) {
    this.mode = "insert";
    this.payload = obj;
    return this;
  }
  update(obj: Row) {
    this.mode = "update";
    this.payload = obj;
    return this;
  }
  upsert(obj: Row, opts?: { onConflict?: string }) {
    this.mode = "upsert";
    this.payload = obj;
    this.upsertConflict = opts?.onConflict;
    return this;
  }
  delete() {
    this.mode = "delete";
    return this;
  }

  private rows(): Row[] {
    if (!this.store[this.table]) this.store[this.table] = [];
    return this.store[this.table];
  }

  private matches(rows: Row[]) {
    return rows.filter((r) => this.filters.every((f) => (f.op === "eq" ? r[f.col] === f.val : r[f.col] !== f.val)));
  }

  private sorted(rows: Row[]) {
    if (!this.orders.length) return rows;
    return [...rows].sort((a, b) => {
      for (const o of this.orders) {
        const av = a[o.col] as never;
        const bv = b[o.col] as never;
        if (av === bv) continue;
        const cmp = av < bv ? -1 : 1;
        return o.ascending ? cmp : -cmp;
      }
      return 0;
    });
  }

  private project(rows: Row[]) {
    const parsed = parseSelect(this.selectCols);
    return rows.map((r) => project(r, this.table, parsed, this.store));
  }

  private execute(): { data: unknown; error: null } {
    const rows = this.rows();

    if (this.mode === "select") {
      const projected = this.project(this.sorted(this.matches(rows)));
      if (this.wantMaybe) return { data: projected[0] ?? null, error: null };
      if (this.wantSingle) return { data: projected[0] ?? null, error: null };
      return { data: projected, error: null };
    }

    if (this.mode === "insert") {
      const items = Array.isArray(this.payload) ? this.payload : [this.payload as Row];
      const inserted = items.map((item) => {
        const row: Row = { id: newId(), ...item };
        rows.push(row);
        return row;
      });
      const projected = this.project(inserted);
      return this.wantSingle ? { data: projected[0] ?? null, error: null } : { data: projected, error: null };
    }

    if (this.mode === "update") {
      const matched = this.matches(rows);
      matched.forEach((r) => Object.assign(r, this.payload));
      if (!this.selectCols) return { data: null, error: null };
      const projected = this.project(matched);
      return this.wantSingle ? { data: projected[0] ?? null, error: null } : { data: projected, error: null };
    }

    if (this.mode === "upsert") {
      const keys = this.upsertConflict?.split(",").map((k) => k.trim()) ?? ["id"];
      const payloadRow = this.payload as Row;
      const existing = rows.find((r) => keys.every((k) => r[k] === payloadRow[k]));
      if (existing) Object.assign(existing, payloadRow);
      else rows.push({ id: newId(), ...payloadRow });
      return { data: null, error: null };
    }

    // delete
    const toRemove = new Set(this.matches(rows));
    this.store[this.table] = rows.filter((r) => !toRemove.has(r));
    return { data: null, error: null };
  }
}

class DemoRpcBuilder extends Awaitable {
  private result: unknown;
  constructor(result: unknown) {
    super(() => ({ data: this.result, error: null }));
    this.result = result;
  }
  single() {
    this.result = Array.isArray(this.result) ? this.result[0] ?? null : this.result;
    return this;
  }
}

// Callers seed this with concrete domain types (Course[], Faculty[], ...) — accepting `unknown[]`
// here, rather than Store's own Row[], is what lets them do that without a cast at every table.
export function createDemoClient(seed: Record<string, unknown[]>, rpcHandlers: Record<string, RpcHandler>) {
  // Deep-cloned once per page load so mutations during the session never touch the seed
  // constants — a hard refresh re-imports demoData fresh, giving every visit a clean slate.
  const store: Store = JSON.parse(JSON.stringify(seed));

  return {
    from(table: string) {
      return new DemoQueryBuilder(store, table);
    },
    rpc(name: string, params?: Record<string, unknown>) {
      const handler = rpcHandlers[name];
      return new DemoRpcBuilder(handler ? handler(params, store) : null);
    },
    storage: {
      from() {
        return {
          upload: async (path: string) => ({ data: { path }, error: null }),
          remove: async () => ({ error: null }),
          // MaterialsList/AdminMaterials pass this straight to window.open(), which demoLinkGuard.ts
          // intercepts in demo mode and explains instead of opening — so the URL itself is never
          // actually loaded and only needs to be a plausible-looking string.
          createSignedUrl: async (path: string) => ({ data: { signedUrl: `https://storage.isb.edu/course-materials/${path}` }, error: null }),
        };
      },
    },
    // Never exercised in demo mode (useAuth short-circuits before touching this), kept only so
    // an unexpected call fails softly instead of throwing "cannot read property of undefined".
    auth: {
      signInWithOAuth: async () => ({ error: null }),
      signInWithOtp: async () => ({ error: null }),
      signOut: async () => ({ error: null }),
      onAuthStateChange: () => ({ data: { subscription: { unsubscribe() {} } } }),
    },
  };
}
