import React from "react";
import { Link } from "react-router-dom";

type Props = {
  brandHref?: string;
  brandLabel: string;
  logoSrc?: string;
  actions?: React.ReactNode;
};

export default class Navbar extends React.Component<Props> {
  render() {
    const { brandHref = "/", brandLabel, logoSrc, actions } = this.props;
    return (
      <header className="sticky top-0 z-10 border-b bg-white/70 backdrop-blur">
        <nav className="mx-auto max-w-6xl px-4 h-14 flex items-center gap-3">
          <Link
            to={brandHref}
            className="inline-flex items-center gap-1 font-bold tracking-tight"
          >
            {logoSrc ? <img src={logoSrc} alt="" className="h-5 w-5" /> : null}
            <span className="text-[20px]">{brandLabel}</span>
          </Link>
          <div className="ms-auto flex items-center gap-2">{actions}</div>
        </nav>
      </header>
    );
  }
}
