import { Navigate } from "react-router-dom";
import { isAuthenticated } from "../lib/auth";

type PrivateRouteProps = {
  children: React.ReactNode;
};

export function PrivateRoute({ children }: PrivateRouteProps) {
  if (!isAuthenticated()) {
    return <Navigate to="/login" replace />;
  }

  return <>{children}</>;
}

