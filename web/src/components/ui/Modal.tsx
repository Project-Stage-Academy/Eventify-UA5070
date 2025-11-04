import { useEffect } from "react";
import { createPortal } from "react-dom";
import type { ReactNode } from "react";

type ModalProps = {
    open: boolean;
    onClose: () => void;
    title?: string;
    children: ReactNode;
    headerRight?: ReactNode;
};

export function Modal({
    open,
    onClose,
    title,
    children,
    headerRight
}: ModalProps) {
    useEffect(() => {
        const handler = (event: KeyboardEvent) => {
            if (event.key === "Escape") onClose();
        };

        window.addEventListener("keydown", handler);
        return () => window.removeEventListener("keydown", handler);
    }, [onClose]);

    if (!open) return null;

    const content = (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
            <div className="absolute inset-0 bg-black/40" onClick={onClose} aria-hidden="true"/>

            <div role="dialog" aria-modal="true" aria-labelledby={title ? "modal-title" : undefined}
                 className="relative z-10 w-full max-w-lg rounded-xl bg-white p-6 shadow-lg"
            >
                {(title || headerRight) && (
                    <div className="mb-4 flex items-center justify-between gap-3">
                        {title && (
                            <h2 id="modal-title" className="text-lg font-semibold text-slate-900">
                                {title}
                            </h2>
                        )}

                        <div className="flex items-center gap-2">
                            {headerRight}
                            <button
                                type="button"
                                onClick={onClose}
                                className="rounded-md p-1 text-slate-500 hover:bg-slate-100 hover:text-slate-800 focus:outline-none focus:ring-2 focus:ring-slate-500"
                                aria-label="Close"
                            >
                                ✕
                            </button>
                        </div>
                    </div>
                )}

                <div>{children}</div>
            </div>
        </div>
    );

    return createPortal(content, document.body);


}