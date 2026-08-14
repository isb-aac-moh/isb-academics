import { useEffect, useRef, useState } from "react";
import type { Course, Material, MaterialKind } from "../../types";
import { deleteMaterial, fetchMaterials, materialUrl, uploadMaterial } from "../../lib/db";

const KINDS: { id: MaterialKind; label: string }[] = [
  { id: "slides", label: "Slides" },
  { id: "case", label: "Case" },
  { id: "solution", label: "Solutions" },
  { id: "coursepack", label: "Coursepack" },
  { id: "other", label: "Other" },
];

interface Props {
  course: Course;
}

/** Uploads run through the browser as the signed-in admin, because the storage policies check
    students.is_admin against auth.uid() — a server-side script would need a service-role key that
    does not belong in this repo. */
export function AdminMaterials({ course }: Props) {
  const [materials, setMaterials] = useState<Material[]>([]);
  const [session, setSession] = useState<string>("");
  const [title, setTitle] = useState("");
  const [kind, setKind] = useState<MaterialKind>("slides");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [progress, setProgress] = useState("");
  const fileRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [course.id]);

  async function load() {
    try {
      setMaterials(await fetchMaterials(course.id));
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not load materials");
    }
  }

  async function handleUpload() {
    const files = Array.from(fileRef.current?.files ?? []);
    if (files.length === 0) {
      setError("Pick at least one file first.");
      return;
    }
    setBusy(true);
    setError("");
    const sessionNum = session === "" ? null : Number(session);
    let done = 0;
    try {
      for (const file of files) {
        setProgress(`Uploading ${done + 1} of ${files.length}: ${file.name}`);
        // With several files the typed title would be wrong for all but the first, so fall back
        // to the filename and let the admin rename afterwards.
        const name = files.length === 1 && title.trim() ? title.trim() : file.name.replace(/\.[^.]+$/, "");
        await uploadMaterial(file, course.id, sessionNum, name, kind);
        done++;
      }
      setTitle("");
      if (fileRef.current) fileRef.current.value = "";
      await load();
    } catch (err) {
      setError(`${err instanceof Error ? err.message : "Upload failed"} (${done} of ${files.length} uploaded)`);
    } finally {
      setBusy(false);
      setProgress("");
    }
  }

  async function handleOpen(m: Material) {
    try {
      window.open(await materialUrl(m.storage_path), "_blank", "noopener");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not open file");
    }
  }

  async function handleDelete(m: Material) {
    if (!confirm(`Delete "${m.title}"? This removes the file for students too.`)) return;
    try {
      await deleteMaterial(m.id, m.storage_path);
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not delete");
    }
  }

  const sessions = Array.from({ length: course.total_sessions }, (_, i) => i + 1);

  return (
    <div>
      <div className="card p-4 mb-6">
        <div className="font-semibold text-sm mb-3">Upload course material</div>
        <div className="grid gap-3 sm:grid-cols-3 mb-3">
          <label className="block">
            <span className="text-xs text-ink-soft block mb-1">Belongs to</span>
            <select className="input w-full" value={session} onChange={(e) => setSession(e.target.value)}>
              <option value="">Whole course</option>
              {sessions.map((s) => (
                <option key={s} value={s}>
                  Session {s}
                </option>
              ))}
            </select>
          </label>
          <label className="block">
            <span className="text-xs text-ink-soft block mb-1">Type</span>
            <select className="input w-full" value={kind} onChange={(e) => setKind(e.target.value as MaterialKind)}>
              {KINDS.map((k) => (
                <option key={k.id} value={k.id}>
                  {k.label}
                </option>
              ))}
            </select>
          </label>
          <label className="block">
            <span className="text-xs text-ink-soft block mb-1">Title (single file only)</span>
            <input
              className="input w-full"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Defaults to filename"
            />
          </label>
        </div>

        <input ref={fileRef} type="file" multiple accept=".pdf,.pptx,.docx,.xlsx" className="text-sm mb-3 block" />

        <button onClick={() => void handleUpload()} disabled={busy} className="btn btn-primary">
          {busy ? "Uploading…" : "Upload"}
        </button>
        {progress && <p className="text-xs text-ink-soft mt-2">{progress}</p>}
        {error && <p className="text-sm text-bad mt-2">{error}</p>}
      </div>

      <div className="text-xs uppercase tracking-wide text-ink-soft font-bold mb-2">
        {materials.length} file{materials.length === 1 ? "" : "s"} for {course.name}
      </div>
      {materials.length === 0 ? (
        <p className="text-sm text-ink-soft">Nothing uploaded yet.</p>
      ) : (
        <div className="divide-y divide-line border border-line rounded-xl overflow-hidden">
          {materials.map((m) => (
            <div key={m.id} className="flex items-center gap-3 px-4 py-2.5 bg-surface">
              <span className="text-[10px] font-bold uppercase tracking-wide text-ink-soft bg-surface-2 rounded px-1.5 py-0.5 shrink-0 w-24 text-center">
                {m.session === null ? "Course" : `Session ${m.session}`}
              </span>
              <span className="flex-1 min-w-0 truncate text-sm">{m.title}</span>
              <span className="text-xs text-ink-soft shrink-0">{m.kind}</span>
              <button onClick={() => void handleOpen(m)} className="text-xs text-accent font-semibold hover:underline shrink-0">
                Open
              </button>
              <button onClick={() => void handleDelete(m)} className="text-xs text-bad font-semibold hover:underline shrink-0">
                Delete
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
