import type { ButtonHTMLAttributes, PropsWithChildren } from "react";
import clsx from "clsx";

type ButtonVariant = "primary" | "secondary" | "tertiary" | "ghost"

type ButtonProps = PropsWithChildren<
    ButtonHTMLAttributes<HTMLButtonElement> & {
        variant?: ButtonVariant;
        loading?: boolean;
    }
>;

export function Button({
    children,
    className,
    variant = "primary",
    loading = false,
    disabled,
    ...rest
}: ButtonProps) {
    const base =
        "inline-flex items-center justify-center rounded-md px-4 py-2 text-sm font-medium " +
        "transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2";

    const byVariant: Record<ButtonVariant, string> = {
        primary:
            "bg-red-600 text-white hover:bg-red-700 focus-visible:ring-red-500 disabled:bg-red-300",
        secondary:
            "bg-black text-white hover:bg-neutral-700 focus-visible:ring-black disabled:bg-neutral-600",
        tertiary:
            "bg-transparent text-slate-900 border border-slate-900 hover:border-slate-600 hover:bg-slate-50 hover:text-slate-600" +
            " focus-visible:ring-slate-300 disabled:text-slate-300 disabled:border-slate-200",
        ghost:
            "bg-slate-300 text-slate-900 hover:bg-slate-200 focus-visible:ring-slate-400 disabled:opacity-60"
    };

    return (
        <button
            className={clsx(base, byVariant[variant], className)}
            disabled={disabled || loading}
            {...rest}
        >
            {loading && <span className="mr-2 animate-spin">⏳</span>}
            {children}
        </button>
    );
}