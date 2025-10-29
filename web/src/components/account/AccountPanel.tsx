import React from "react";
import type { UserDTO } from "../../services/AuthService";

type Props = {
  user: UserDTO | null;
  loading: boolean;
  error: string | null;
  onRetry: () => void;
  onClose: () => void;
};

export default class AccountPanel extends React.Component<Props> {
  render() {
    const { user, loading, error, onRetry, onClose } = this.props;

    if (loading) {
      return (
        <div className="grid gap-3">
          <div className="h-5 w-40 bg-zinc-100 rounded" />
          <div className="h-5 w-64 bg-zinc-100 rounded" />
          <div className="h-6 w-24 bg-zinc-100 rounded" />
        </div>
      );
    }

    if (error) {
      return (
        <div className="grid gap-3">
          <div className="rounded-xl border border-red-200 bg-red-50 text-red-700 text-sm px-3 py-2">
            {error}
          </div>
          <button
            onClick={onRetry}
            className="h-9 rounded-xl border px-3 text-sm hover:bg-zinc-100 w-fit"
          >
            Try again
          </button>
        </div>
      );
    }

    if (!user) return null;

    return (
      <div className="grid gap-4">
        <div>
          <div className="text-sm text-zinc-600">Name</div>
          <div className="font-medium">{user.name}</div>
        </div>
        <div>
          <div className="text-sm text-zinc-600">Email</div>
          <div className="font-medium">{user.email}</div>
        </div>
        <div>
          <div className="text-sm text-zinc-600 mb-1">Roles</div>
          <div className="flex flex-wrap gap-2">
            {user.roles?.length ? (
              user.roles.map((r) => (
                <span
                  key={r.id}
                  className="inline-flex items-center rounded-xl border px-2.5 h-7 text-xs"
                >
                  {r.name}
                </span>
              ))
            ) : (
              <span className="text-zinc-500 text-sm">—</span>
            )}
          </div>
        </div>
        <div className="mt-2 flex items-center gap-2">
          <button
            onClick={onClose}
            className="inline-flex h-9 items-center rounded-xl border px-3 text-sm hover:bg-zinc-100"
          >
            Close
          </button>
        </div>
      </div>
    );
  }
}
