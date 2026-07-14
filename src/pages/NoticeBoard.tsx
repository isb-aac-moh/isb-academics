/**
 * Notice Board — AAC announcements. Pinned items stay at top; everything
 * else is reverse-chronological. Admin-only preview for now.
 */
import { Pin } from "lucide-react";
import { COLOR, FONT } from "../lib/theme";
import { useNotifications } from "../hooks/useNotifications";
import type { NotificationTag } from "../types";

const TAG_COLOR: Record<NotificationTag, { bg: string; text: string }> = {
  Urgent: { bg: COLOR.redTint, text: COLOR.red },
  Important: { bg: COLOR.amberTint, text: "#8B5E00" },
  Info: { bg: COLOR.navyTint, text: COLOR.navyHero },
  General: { bg: COLOR.bgSoft, text: COLOR.ink2 },
};

export default function NoticeBoard() {
  const { notifications, loading } = useNotifications();

  if (loading) {
    return <div style={{ padding: 40, fontFamily: FONT.sans, color: COLOR.ink2 }}>Loading…</div>;
  }

  return (
    <div className="min-h-screen pb-24" style={{ background: COLOR.bg }}>
      <header className="px-6 md:px-12 pt-10 pb-6">
        <h1 style={{ fontFamily: FONT.serif, fontSize: 26, fontWeight: 500, color: COLOR.ink }}>
          Notice <em>Board</em>
        </h1>
        <p style={{ fontFamily: FONT.sans, fontSize: 13, color: COLOR.ink2, marginTop: 4 }}>
          Latest from AAC — schedule changes, deadlines, and reminders. Pinned items stay at top.
        </p>
      </header>

      <main className="px-6 md:px-12" style={{ maxWidth: 720 }}>
        {notifications.length === 0 ? (
          <p style={{ fontSize: 13, color: COLOR.ink3, fontFamily: FONT.sans }}>No notices posted yet.</p>
        ) : (
          <div className="space-y-3">
            {notifications.map((n) => {
              const c = TAG_COLOR[n.tag];
              return (
                <div
                  key={n.id}
                  style={{
                    padding: "16px 18px", borderRadius: 12, background: COLOR.surface,
                    border: n.pinned ? `1.5px solid ${COLOR.navyHero}` : `1px solid ${COLOR.borderLight}`,
                  }}
                >
                  <div className="flex items-center gap-2 mb-2 flex-wrap">
                    {n.pinned && <Pin size={13} color={COLOR.navyHero} fill={COLOR.navyHero} />}
                    <span style={{ fontSize: 10.5, fontWeight: 700, padding: "2px 9px", borderRadius: 6, background: c.bg, color: c.text, fontFamily: FONT.sans, textTransform: "uppercase", letterSpacing: "0.04em" }}>
                      {n.tag}
                    </span>
                    <span style={{ fontSize: 11.5, color: COLOR.ink3, fontFamily: FONT.sans }}>
                      {new Date(n.created_at).toLocaleDateString(undefined, { month: "short", day: "numeric", year: "numeric" })}
                    </span>
                  </div>
                  <p style={{ fontSize: 15, fontWeight: 700, fontFamily: FONT.sans, color: COLOR.ink, marginBottom: 4 }}>{n.title}</p>
                  <p style={{ fontSize: 13.5, color: COLOR.ink2, fontFamily: FONT.sans, lineHeight: 1.5 }}>{n.body}</p>
                </div>
              );
            })}
          </div>
        )}
      </main>
    </div>
  );
}
