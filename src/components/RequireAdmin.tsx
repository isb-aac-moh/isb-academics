import { Navigate, Outlet } from "react-router-dom";
import type { User } from "../types";

/** Redirects non-admins away from admin-only-preview sections (Resources, Notices, Admin). */
export default function RequireAdmin({ user }: { user: User }) {
  if (!user.is_admin) return <Navigate to="/planner/background" replace />;
  return <Outlet />;
}
