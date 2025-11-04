import type {HTMLAttributes} from "react";
import logoIcon from "@/assets/eventify-icon.svg";

type LogoVariant = "default" | "compact"

type LogoProps = HTMLAttributes<HTMLDivElement> & {
    title?: string;
    subtitle?: string;
    variant?: LogoVariant;
    iconSrc?: string;
};

export function Logo({
    title = "Eventify",
    subtitle,
    variant = "default",
    iconSrc,
    className,
    ...rest
}: LogoProps) {
    const isCompact = variant === "compact";
    const src = iconSrc ?? logoIcon;

    return (
        <div className={
            ["inline-flex items-center gap-2 select-none", className,]
            .filter(Boolean)
            .join(" ")}
             {...rest}
        >
            <img src={src} alt={title} className="h-12 w-12 rounded-xl object-contain"/>

            <div className="flex flex-col leading-tight">
                <span className="text-xl font-bold tracking-tight text-slate-900">
                    {title}
                </span>
                {!isCompact && subtitle && (
                    <span className="text-xs text-slate-500">{subtitle}</span>
                )}
            </div>
        </div>
    )
}