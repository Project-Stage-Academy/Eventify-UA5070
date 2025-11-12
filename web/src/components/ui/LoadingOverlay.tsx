import { LoadingSpinner } from "@/components/ui/LoadingSpinner";

export function LoadingOverlay({ open, message }: { open: boolean; message?: string }) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-white/60 backdrop-blur-sm">
      <LoadingSpinner message={message} />
    </div>
  );
}
