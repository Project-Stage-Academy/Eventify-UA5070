import React from "react";
import { AuthContext } from "../../../context/AuthContext";
import { AuthService, type AuthResponse } from "../../../services/AuthService";
import LoginForm from "./LoginForm";

type Props = {
  open: boolean;
  onClose: () => void;
  onSuccess?: (payload: {
    access_token: string;
    refresh_token: string;
  }) => void;
  service?: AuthService;
};

type State = { loading: boolean; error: string | null };

export default class LoginModal extends React.Component<Props, State> {
  static contextType = AuthContext;
  declare context: React.ContextType<typeof AuthContext>;

  private service: AuthService;
  private panelRef = React.createRef<HTMLDivElement>();
  private firstFieldRef = React.createRef<HTMLInputElement>();
  private prevOverflow = "";

  state: State = { loading: false, error: null };

  constructor(props: Props) {
    super(props);
    this.service = props.service ?? new AuthService();
    this.onKey = this.onKey.bind(this);
    this.onOverlayMouseDown = this.onOverlayMouseDown.bind(this);
  }

  componentDidUpdate(prevProps: Props) {
    if (!prevProps.open && this.props.open) {
      this.prevOverflow = document.documentElement.style.overflow;
      document.documentElement.style.overflow = "hidden";
      window.addEventListener("keydown", this.onKey);
      setTimeout(() => this.firstFieldRef.current?.focus(), 0);
    }
    if (prevProps.open && !this.props.open) {
      document.documentElement.style.overflow = this.prevOverflow;
      window.removeEventListener("keydown", this.onKey);
    }
  }

  componentWillUnmount() {
    document.documentElement.style.overflow = this.prevOverflow;
    window.removeEventListener("keydown", this.onKey);
  }

  async handleSubmit(values: { email: string; password: string }) {
    try {
      this.setState({ loading: true, error: null });
      const auth: AuthResponse = await this.service.login(values);
      this.context.authenticate(auth);
      this.props.onSuccess?.({
        access_token: auth.access_token,
        refresh_token: auth.refresh_token,
      });
      this.props.onClose();
    } catch (e) {
      const msg = e instanceof Error ? e.message : "Login failed";
      this.setState({ error: msg });
    } finally {
      this.setState({ loading: false });
    }
  }

  onKey(e: KeyboardEvent) {
    if (e.key === "Escape" && !this.state.loading) this.props.onClose();
  }

  onOverlayMouseDown(e: React.MouseEvent<HTMLDivElement>) {
    if (this.state.loading) return;
    if (
      this.panelRef.current &&
      !this.panelRef.current.contains(e.target as Node)
    )
      this.props.onClose();
  }

  render() {
    if (!this.props.open) return null;

    return (
      <div
        role="dialog"
        aria-modal="true"
        aria-labelledby="login-title"
        className="fixed inset-0 z-50 grid place-items-center bg-black/50 backdrop-blur p-4"
        onMouseDown={this.onOverlayMouseDown}
      >
        <div
          ref={this.panelRef}
          className="w-[min(92vw,520px)] rounded-2xl bg-white shadow-lg p-6"
          onMouseDown={(e) => e.stopPropagation()}
        >
          <div className="mb-4 flex items-start justify-between">
            <h2 id="login-title" className="text-xl font-semibold">
              Login into your account
            </h2>
            <button
              type="button"
              className="rounded-lg p-2 hover:bg-zinc-100"
              onClick={this.props.onClose}
              disabled={this.state.loading}
              aria-label="Close"
            >
              <svg viewBox="0 0 24 24" className="size-5" aria-hidden="true">
                <path
                  d="M6 6l12 12M18 6L6 18"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                />
              </svg>
            </button>
          </div>

          <LoginForm
            firstFieldRef={this.firstFieldRef}
            disabled={this.state.loading}
            error={this.state.error}
            onSubmit={(v) => this.handleSubmit(v)}
          />
        </div>
      </div>
    );
  }
}
