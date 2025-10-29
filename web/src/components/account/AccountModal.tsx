import React from "react";
import AccountPanel from "./AccountPanel";
import type { UserDTO } from "../../services/AuthService";

type Props = {
  open: boolean;
  onClose: () => void;
  user: UserDTO | null;
  loading: boolean;
  error: string | null;
  onRetry: () => void;
};

export default class AccountModal extends React.Component<Props> {
  private panelRef = React.createRef<HTMLDivElement>();
  private prevOverflow = "";

  constructor(props: Props) {
    super(props);
    this.onKey = this.onKey.bind(this);
    this.onOverlayMouseDown = this.onOverlayMouseDown.bind(this);
  }

  componentDidUpdate(prevProps: Props) {
    if (!prevProps.open && this.props.open) {
      this.prevOverflow = document.documentElement.style.overflow;
      document.documentElement.style.overflow = "hidden";
      window.addEventListener("keydown", this.onKey);
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

  onKey(e: KeyboardEvent) {
    if (e.key === "Escape") this.props.onClose();
  }

  onOverlayMouseDown(e: React.MouseEvent<HTMLDivElement>) {
    if (
      this.panelRef.current &&
      !this.panelRef.current.contains(e.target as Node)
    )
      this.props.onClose();
  }

  render() {
    const { open, onClose, user, loading, error, onRetry } = this.props;
    if (!open) return null;

    return (
      <div
        role="dialog"
        aria-modal="true"
        aria-labelledby="user-modal-title"
        className="fixed inset-0 z-50 grid place-items-center bg-black/50 backdrop-blur"
        onMouseDown={this.onOverlayMouseDown}
      >
        <div
          ref={this.panelRef}
          className="w-[min(92vw,560px)] rounded-2xl bg-white shadow-lg p-6"
          onMouseDown={(e) => e.stopPropagation()}
        >
          <div className="flex items-start justify-between mb-4">
            <h2 id="user-modal-title" className="text-xl font-semibold">
              Your account
            </h2>
            <button
              className="rounded-lg p-2 hover:bg-zinc-100"
              onClick={onClose}
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
          <AccountPanel
            user={user}
            loading={loading}
            error={error}
            onRetry={onRetry}
            onClose={onClose}
          />
        </div>
      </div>
    );
  }
}
