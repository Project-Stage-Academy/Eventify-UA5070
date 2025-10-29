import React from "react";
import Navbar from "../../components/layout/Navbar";
import LoginModal from "../../components/auth/login/LoginModal";
import RegisterModal from "../../components/auth/register/RegisterModal";
import {
  withNavigation,
  type WithNavigationProps,
} from "../../app/withNavigation";

type State = { openLogin: boolean; openRegister: boolean };

class HeroPageBase extends React.Component<WithNavigationProps, State> {
  state: State = { openLogin: false, openRegister: false };

  render() {
    return (
      <div className="min-h-dvh flex flex-col bg-zinc-50 text-zinc-900">
        <Navbar
          brandHref="/"
          brandLabel="Eventify"
          logoSrc="/eventify-icon.svg"
          actions={
            <>
              <button
                onClick={() => this.setState({ openRegister: true })}
                className="inline-flex items-center rounded-xl border border-zinc-300 px-4 h-9 text-sm font-medium hover:bg-zinc-100"
              >
                Register
              </button>
              <button
                onClick={() => this.setState({ openLogin: true })}
                className="inline-flex items-center rounded-xl bg-black text-white px-4 h-9 text-sm font-medium hover:opacity-90"
              >
                Login
              </button>
            </>
          }
        />

        <main className="flex-1 mx-auto max-w-6xl px-4 py-8">
          <section className="grid gap-4">
            <h1 className="text-3xl font-bold">Eventify</h1>
            <p className="text-zinc-600">
              Organize events, join events, and enjoy events.
            </p>
          </section>
        </main>

        <RegisterModal
          open={this.state.openRegister}
          onClose={() => this.setState({ openRegister: false })}
          onSuccess={() => {
            this.setState({ openRegister: false });
            this.props.navigate("/app", { replace: true });
          }}
        />
        <LoginModal
          open={this.state.openLogin}
          onClose={() => this.setState({ openLogin: false })}
          onSuccess={() => {
            this.setState({ openLogin: false });
            this.props.navigate("/app", { replace: true });
          }}
        />
      </div>
    );
  }
}

const HeroPage = withNavigation(HeroPageBase);
export default HeroPage;
