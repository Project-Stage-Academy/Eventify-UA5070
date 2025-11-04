import type { InputHTMLAttributes } from 'react'

type InputProps = InputHTMLAttributes<HTMLInputElement> & {
    label?: string;
    helperText?: string;
    error?: string;
}

export function Input({
    label,
    helperText,
    error,
    id,
    className,
    ...rest
}: InputProps) {
    const inputId = id ?? rest.name;

    const baseClasses =
        "block w-full rounded-md border px-3 py-2 text-sm shadow-sm " +
        "border-slate-300 placeholder:text-slate-400 " +
        "focus:outline-none focus:ring-2 focus:ring-slate-500 focus:border-slate-500";

    const errorClasses = error
        ? " border-red-500 focus:ring-red-500 focus:border-red-500"
        : "";

    const mergedClassName = `${baseClasses}${errorClasses}${className ? `${className}` : ""}`;

    return (
        <div className="flex flex-col gap-1">
            { label && (
                <label htmlFor="{inputId}" className="text-sm font-medium text-slate-700">
                    {label}
                </label>
            )}

            <input id={inputId} className={mergedClassName} {...rest} />

            {helperText && !error && (
                <p className="text-xs text-slate-500">{helperText}</p>
            )}

            {error && <p className="text-xs text-red-600">{error}</p>}
        </div>
    );
}