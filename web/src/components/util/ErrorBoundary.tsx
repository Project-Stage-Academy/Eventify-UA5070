import React from "react";

type State = { error: Error | null };

export default class ErrorBoundary extends React.Component<
  React.PropsWithChildren,
  State
> {
  state: State = { error: null };
  static getDerivedStateFromError(error: Error) {
    return { error };
  }
  render() {
    if (this.state.error) {
      return (
        <div className="p-6">
          <h1 className="text-lg font-semibold">Something went wrong</h1>
          <pre className="mt-2 whitespace-pre-wrap text-sm text-red-600">
            {this.state.error.message}
          </pre>
        </div>
      );
    }
    return this.props.children;
  }
}
