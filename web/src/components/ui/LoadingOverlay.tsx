import { Modal } from "@/components/ui/Modal";

type LoadingOverlayProps = {
  open: boolean;
  message?: string;
};

export function LoadingOverlay({ open, message }: LoadingOverlayProps) {
  return (
    <Modal open={open} onClose={() => {}} title={undefined}>
      <div className="flex flex-col items-center gap-3 py-6">
        <div className="h-10 w-10 animate-spin rounded-full border-4 border-slate-300 border-t-slate-600" />
        {message && (
          <p className="text-sm font-medium text-slate-700">{message}</p>
        )}
      </div>
    </Modal>
  );
}
