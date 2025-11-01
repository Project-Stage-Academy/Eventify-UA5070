import React from "react";

export default class HomePage extends React.Component {
  render() {
    return (
      <section className="grid place-items-center min-h-[60svh]">
        <div className="rounded-2xl bg-white shadow p-6">
          <h1 className="text-2xl font-semibold mb-1">Workspace</h1>
          <p className="text-zinc-600">Welcome!</p>
        </div>
      </section>
    );
  }
}
