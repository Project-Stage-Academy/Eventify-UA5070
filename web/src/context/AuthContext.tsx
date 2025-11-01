import React, { createContext } from "react";
import Cookies from "js-cookie";
import { AuthService, type AuthResponse } from "../services/AuthService";

const CK = {
  access: "access_token",
  refresh: "refresh_token",
  user: "user",
} as const;

function safeParseUser(raw: string | undefined) {
  if (!raw) return null;
  try {
    const u = JSON.parse(raw);
    if (!u || typeof u !== "object") return null;
    if (typeof u.id !== "number") return null;
    if (typeof u.email !== "string") return null;
    return u;
  } catch {
    Cookies.remove(CK.user);
    return null;
  }
}

function readToken(key: string) {
  const v = Cookies.get(key);
  if (!v || v === "undefined" || v === "null") return null;
  return v;
}

export type AuthContextValue = {
  token: string | null;
  user: ReturnType<typeof safeParseUser>;
  authenticate: (auth: AuthResponse) => void;
  logout: () => void;
};

const AuthContext = createContext<AuthContextValue>({
  token: null,
  user: null,
  authenticate: () => {},
  logout: () => {},
});

type Props = React.PropsWithChildren<{ service?: AuthService }>;
type State = { token: string | null; user: ReturnType<typeof safeParseUser> };

export class AuthProvider extends React.Component<Props, State> {
  private service: AuthService;

  constructor(props: Props) {
    super(props);
    this.service = props.service ?? new AuthService();
    const token = readToken(CK.access);
    const user = safeParseUser(Cookies.get(CK.user));
    this.state = { token, user };
    this.authenticate = this.authenticate.bind(this);
    this.logout = this.logout.bind(this);
  }

  authenticate(auth: AuthResponse) {
    const secure = window.location.protocol === "https:";
    Cookies.set(CK.access, auth.access_token, { sameSite: "Lax", secure });
    Cookies.set(CK.refresh, auth.refresh_token, { sameSite: "Lax", secure });
    Cookies.set(CK.user, JSON.stringify(auth.user), {
      sameSite: "Lax",
      secure,
    });
    this.setState({ token: auth.access_token, user: auth.user });
  }

  logout() {
    Cookies.remove(CK.access);
    Cookies.remove(CK.refresh);
    Cookies.remove(CK.user);
    this.setState({ token: null, user: null });
  }

  render() {
    const value: AuthContextValue = {
      token: this.state.token,
      user: this.state.user,
      authenticate: this.authenticate,
      logout: this.logout,
    };
    return (
      <AuthContext.Provider value={value}>
        {this.props.children}
      </AuthContext.Provider>
    );
  }
}

export { AuthContext };
