import {type ReactNode, useEffect, useState} from "react";
import {createPortal} from "react-dom";

type ErrorPopupProps = {
    open: boolean;
    onClose: () => void;
    title?: string;
    message?: string;
    actions?: ReactNode;
    autoHideDuration?: number | null;
    fadeAnimationDuration?: number;
};

export function ErrorPopup({
    open,
    onClose,
    title = "Error",
    message,
    actions,
    autoHideDuration = 2500,
    fadeAnimationDuration = 500
}: ErrorPopupProps) {
    const [isMounted, setIsMounted] = useState(open);

    useEffect(() => {
        if (open) {
            setIsMounted(true);
            return;
        }

        const timeout = window.setTimeout(() => {
            setIsMounted(false);
        }, fadeAnimationDuration);

        return () => window.clearTimeout(timeout);
    }, [open, fadeAnimationDuration]);

    useEffect(() => {
        if (!open || autoHideDuration == null) return;

        const id = window.setTimeout(() => {
            onClose();
        }, autoHideDuration);

        return () => window.clearTimeout(id);
    }, [open, autoHideDuration, onClose]);

    if (!isMounted) return null;

    const content = (
        <div className="fixed inset-x-0 top-4 z-50 flex justify-center px-4 pointer-events-none">
            <div
                className={[
                    "pointer-events-auto flex w-full max-w-md items-start gap-3 rounded-lg border border-red-200 bg-white px-4 py-3 shadow-lg",
                    "transform transition-all duration-200 ease-out",
                    open
                        ? "opacity-100 translate-y-0"
                        : "opacity-0 -translate-y-2 pointer-events-none",
                ].join(" ")}
                role="alert"
            >
                <div className="mt-0.5 flex h-7 w-7 items-center justify-center rounded-full bg-red-100">
                    <span className="text-sm font-semibold text-red-600">!</span>
                </div>

                <div className="flex-1">
                    <p className="text-sm font-semibold text-red-700">{title}</p>
                    {message && (
                        <p className="mt-1 text-sm text-red-600">{message}</p>
                    )}
                    {actions && <div className="mt-2 text-sm">{actions}</div>}
                </div>

                <button
                    type="button"
                    onClick={onClose}
                    className="ml-2 rounded-md p-1 text-slate-400 hover:bg-slate-100 hover:text-slate-700 focus:outline-none focus:ring-2 focus:ring-red-500"
                    aria-label="Close"
                >
                    ✕
                </button>
            </div>
        </div>
    );

    return createPortal(content, document.body);
}