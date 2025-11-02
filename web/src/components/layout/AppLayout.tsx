import React from "react";
import { Outlet } from "react-router-dom";
import Navbar from "./Navbar";
import AccountModal from "../account/AccountModal";
import { AuthContext } from "../../context/AuthContext";
import { AccountService } from "../../services/AccountService";
import type { UserDTO } from "../../services/AuthService";

type State = {
  modalOpen: boolean;
  loading: boolean;
  error: string | null;
  user: UserDTO | null;
};

export default class AppLayout extends React.Component<unknown, State> {
  static contextType = AuthContext;
  declare context: React.ContextType<typeof AuthContext>;

  private service = new AccountService();

  state: State = { modalOpen: false, loading: false, error: null, user: null };

  async loadUser() {
    try {
      this.setState({ error: null, loading: true });
      const token = this.context.token || "";
      const me = await this.service.me(token);
      this.setState({ user: me });
    } catch (e) {
      const msg = e instanceof Error ? e.message : "Unable to load account";
      this.setState({ user: null, error: msg });
    } finally {
      this.setState({ loading: false });
    }
  }

  render() {
    return (
      <div className="min-h-dvh flex flex-col bg-zinc-50 text-zinc-900">
        <Navbar
          brandHref="/app"
          brandLabel="Eventify"
          logoSrc="/eventify-icon.svg"
          actions={
            <button
              onClick={() =>
                this.setState({ modalOpen: true }, () => this.loadUser())
              }
              className="inline-flex h-9 items-center rounded-xl border px-3 text-sm hover:bg-zinc-100"
            >
              Account
            </button>
          }
        />

        <main className="flex-1 mx-auto min-w-5xl max-w-5xl px-4 py-8">
          <Outlet />
        </main>

        <AccountModal
          open={this.state.modalOpen}
          onClose={() => this.setState({ modalOpen: false })}
          user={this.state.user}
          loading={this.state.loading}
          error={this.state.error}
          onRetry={() => this.loadUser()}
        />
      </div>
    );
  }
}
