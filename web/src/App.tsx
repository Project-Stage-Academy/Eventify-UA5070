import React from "react";
import {
  BrowserRouter,
  Routes,
  Route,
  Navigate,
  Outlet,
} from "react-router-dom";
import AppLayout from "./components/layout/AppLayout";
import HomePage from "./pages/Home/Home.page";
import HeroPage from "./pages/Hero/Hero.page";
import { AuthContext } from "./context/AuthContext";
import ErrorBoundary from "./components/util/ErrorBoundary";

class RequireAuth extends React.Component {
  static contextType = AuthContext;
  declare context: React.ContextType<typeof AuthContext>;
  render() {
    const { token } = this.context;
    return token ? <Outlet /> : <Navigate to="/" replace />;
  }
}

export default class App extends React.Component {
  render() {
    return (
      <BrowserRouter>
        <ErrorBoundary>
          <Routes>
            <Route path="/" element={<HeroPage />} />
            <Route element={<RequireAuth />}>
              <Route path="/app" element={<AppLayout />}>
                <Route index element={<HomePage />} />
              </Route>
            </Route>
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </ErrorBoundary>
      </BrowserRouter>
    );
  }
}
