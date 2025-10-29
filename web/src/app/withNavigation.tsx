import React from "react";
import { useNavigate, type NavigateFunction } from "react-router-dom";

export type WithNavigationProps = { navigate: NavigateFunction };

export function withNavigation<P extends object>(
  Component: React.ComponentType<P & WithNavigationProps>,
) {
  return function Wrapped(props: P) {
    const navigate = useNavigate();
    return <Component {...props} navigate={navigate} />;
  };
}
