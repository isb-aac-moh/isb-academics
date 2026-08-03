/**
 * Themed replacement for native <select> — a native select can't be styled
 * (cramped, no search, inconsistent across browsers), and the course pickers
 * here have 100+ options across 8 term groups, which a plain select handles badly.
 */
import { useEffect, useRef, useState } from "react";
import { ChevronDown, Search } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";

export interface DropdownOption {
  value: string;
  label: string;
  sublabel?: string;
}

export interface DropdownGroup {
  label: string;
  options: DropdownOption[];
}

interface Props {
  label?: string;
  placeholder?: string;
  value: string;
  onChange: (value: string) => void;
  groups: DropdownGroup[];
  searchable?: boolean;
  disabled?: boolean;
}

export default function Dropdown({ label, placeholder = "Select…", value, onChange, groups, searchable = false, disabled }: Props) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const rootRef = useRef<HTMLDivElement>(null);
  const searchRef = useRef<HTMLInputElement>(null);

  const allOptions = groups.flatMap((g) => g.options);
  const selected = allOptions.find((o) => o.value === value);

  const filteredGroups = query.trim()
    ? groups
        .map((g) => ({ ...g, options: g.options.filter((o) => o.label.toLowerCase().includes(query.trim().toLowerCase())) }))
        .filter((g) => g.options.length > 0)
    : groups;

  useEffect(() => {
    if (!open) return;
    function onClickOutside(e: MouseEvent) {
      if (rootRef.current && !rootRef.current.contains(e.target as Node)) setOpen(false);
    }
    function onEscape(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    document.addEventListener("mousedown", onClickOutside);
    document.addEventListener("keydown", onEscape);
    return () => {
      document.removeEventListener("mousedown", onClickOutside);
      document.removeEventListener("keydown", onEscape);
    };
  }, [open]);

  useEffect(() => {
    if (open && searchable) searchRef.current?.focus();
    if (!open) setQuery("");
  }, [open, searchable]);

  function select(v: string) {
    onChange(v);
    setOpen(false);
  }

  return (
    <div ref={rootRef} style={{ position: "relative", width: "100%" }}>
      {label && (
        <p style={{ fontSize: 11, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", marginBottom: 5 }}>
          {label}
        </p>
      )}
      <button
        type="button"
        disabled={disabled}
        onClick={() => setOpen((o) => !o)}
        aria-haspopup="listbox"
        aria-expanded={open}
        style={{
          width: "100%", display: "flex", alignItems: "center", justifyContent: "space-between", gap: 8,
          padding: "9px 12px", borderRadius: 9, border: `1px solid ${open ? COLOR.navyHero : COLOR.border}`,
          background: disabled ? COLOR.bgSoft : COLOR.surface, cursor: disabled ? "not-allowed" : "pointer",
          fontFamily: FONT.sans, fontSize: 13, color: selected ? COLOR.ink : COLOR.ink3, textAlign: "left",
          transition: "border-color 120ms ease-out",
        }}
      >
        <span style={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
          {selected ? selected.label : placeholder}
        </span>
        <ChevronDown size={15} color={COLOR.ink3} style={{ flexShrink: 0, transition: "transform 150ms ease-out", transform: open ? "rotate(180deg)" : "none" }} />
      </button>

      {open && (
        <div
          className="dropdown-panel-enter"
          role="listbox"
          style={{
            position: "absolute", top: "calc(100% + 6px)", left: 0, right: 0, zIndex: 30,
            background: COLOR.surface, border: `1px solid ${COLOR.border}`, borderRadius: 10,
            boxShadow: "0 8px 28px rgba(0,0,0,0.12)", maxHeight: 320, overflowY: "auto", padding: 6,
          }}
        >
          {searchable && (
            <div style={{ position: "sticky", top: 0, background: COLOR.surface, padding: "2px 2px 6px", zIndex: 1 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 6, padding: "7px 10px", borderRadius: 7, background: COLOR.bgSoft }}>
                <Search size={13} color={COLOR.ink3} />
                <input
                  ref={searchRef}
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder="Search courses…"
                  style={{ border: "none", outline: "none", background: "transparent", fontSize: 12.5, fontFamily: FONT.sans, color: COLOR.ink, width: "100%" }}
                />
              </div>
            </div>
          )}

          {filteredGroups.length === 0 && (
            <p style={{ padding: "10px 12px", fontSize: 12.5, color: COLOR.ink3, fontFamily: FONT.sans }}>No matches.</p>
          )}

          {filteredGroups.map((group) => (
            <div key={group.label} className="mb-1">
              <p style={{ fontSize: 10.5, fontWeight: 700, color: COLOR.ink3, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.05em", padding: "6px 10px 3px" }}>
                {group.label}
              </p>
              {group.options.map((o) => {
                const active = o.value === value;
                return (
                  <button
                    key={o.value}
                    type="button"
                    role="option"
                    aria-selected={active}
                    onClick={() => select(o.value)}
                    style={{
                      width: "100%", display: "flex", alignItems: "center", justifyContent: "space-between", gap: 8,
                      padding: "8px 10px", borderRadius: 7, border: "none", textAlign: "left", cursor: "pointer",
                      background: active ? COLOR.navyTint : "transparent",
                      fontFamily: FONT.sans, fontSize: 13, fontWeight: active ? 700 : 500,
                      color: active ? COLOR.navyHero : COLOR.ink,
                      transition: "background 100ms ease-out",
                    }}
                    onMouseEnter={(e) => { if (!active) e.currentTarget.style.background = COLOR.bgSoft; }}
                    onMouseLeave={(e) => { if (!active) e.currentTarget.style.background = "transparent"; }}
                  >
                    <span style={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{o.label}</span>
                    {o.sublabel && <span style={{ fontSize: 11, color: COLOR.ink3, flexShrink: 0, fontWeight: 500 }}>{o.sublabel}</span>}
                  </button>
                );
              })}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
