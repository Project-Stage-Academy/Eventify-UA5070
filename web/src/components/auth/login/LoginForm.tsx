import React from "react";

type Values = { email: string; password: string };
type Props = {
  onSubmit: (values: Values) => void;
  disabled?: boolean;
  error?: string | null;
  firstFieldRef?: React.RefObject<HTMLInputElement>;
};

type State = Values;

export default class LoginForm extends React.Component<Props, State> {
  state: State = { email: "", password: "" };

  render() {
    const { disabled, error, firstFieldRef } = this.props;
    const { email, password } = this.state;

    return (
      <form
        className="grid gap-4"
        noValidate
        onSubmit={(e) => {
          e.preventDefault();
          this.props.onSubmit({ email, password });
        }}
      >
        <label className="grid gap-1">
          <span className="text-sm text-zinc-600">Email</span>
          <input
            ref={firstFieldRef}
            type="email"
            className="h-10 rounded-xl border border-zinc-300 px-3 focus:outline-none focus:ring-2 focus:ring-zinc-950/10"
            placeholder="jane@example.com"
            value={email}
            onChange={(e) => this.setState({ email: e.target.value })}
            disabled={disabled}
            required
          />
        </label>

        <label className="grid gap-1">
          <span className="text-sm text-zinc-600">Password</span>
          <input
            type="password"
            className="h-10 rounded-xl border border-zinc-300 px-3 focus:outline-none focus:ring-2 focus:ring-zinc-950/10"
            placeholder="••••••••"
            value={password}
            onChange={(e) => this.setState({ password: e.target.value })}
            minLength={6}
            disabled={disabled}
            required
          />
        </label>

        {error ? (
          <div className="rounded-xl border border-red-200 bg-red-50 text-red-700 text-sm px-3 py-2">
            {error}
          </div>
        ) : null}

        <button
          type="submit"
          disabled={disabled}
          className="h-10 rounded-xl bg-black text-white font-medium hover:opacity-90 disabled:opacity-50"
          aria-busy={disabled}
        >
          {disabled ? "Logging …" : "Login"}
        </button>
      </form>
    );
  }
}
