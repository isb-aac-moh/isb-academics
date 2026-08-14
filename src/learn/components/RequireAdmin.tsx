import { Navigate, Outlet } from "react-router-dom";
import type { Student } from "../types";

export function RequireAdmin({ profile }: { profile: Student }) {
  if (!profile.is_admin) return <Navigate to="/learn" replace />;
  return <Outlet />;
}
