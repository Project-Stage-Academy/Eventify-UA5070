import type { PaginationMeta } from "../services/EventService";

type PaginationProps = {
  pagination: PaginationMeta;
  onPageChange: (page: number) => void;
};

export function Pagination({ pagination, onPageChange }: PaginationProps) {
  const { current_page, total_pages, prev_page, next_page } = pagination;

  if (total_pages <= 1) {
    return null;
  }

  const getPageNumbers = () => {
    const pages: (number | string)[] = [];
    const maxVisible = 7;

    if (total_pages <= maxVisible) {
      for (let i = 1; i <= total_pages; i++) {
        pages.push(i);
      }
    } else {
      if (current_page <= 3) {
        for (let i = 1; i <= 5; i++) pages.push(i);
        pages.push("...");
        pages.push(total_pages);
      } else if (current_page >= total_pages - 2) {
        pages.push(1);
        pages.push("...");
        for (let i = total_pages - 4; i <= total_pages; i++) pages.push(i);
      } else {
        pages.push(1);
        pages.push("...");
        for (let i = current_page - 1; i <= current_page + 1; i++) pages.push(i);
        pages.push("...");
        pages.push(total_pages);
      }
    }

    return pages;
  };

  return (
    <div className="flex flex-col items-center gap-4 mt-12 mb-8">
      {/* Page info */}
      <div className="text-sm text-slate-600">
        Сторінка <span className="font-semibold text-slate-900">{current_page}</span> з{" "}
        <span className="font-semibold text-slate-900">{total_pages}</span>
      </div>

      {/* Pagination controls */}
      <div className="flex items-center gap-2">
        {/* Previous Button */}
        <button
          onClick={() => prev_page && onPageChange(prev_page)}
          disabled={!prev_page}
          className={`
            px-5 py-3 rounded-lg font-medium transition-all duration-200 flex items-center gap-2
            ${
              prev_page
                ? "bg-white text-slate-800 hover:bg-red-50 hover:text-red-600 shadow-md hover:shadow-lg border border-slate-300"
                : "bg-slate-100 text-slate-400 cursor-not-allowed border border-slate-300"
            }
          `}
        >
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
          </svg>
          <span className="hidden sm:inline">Попередня</span>
        </button>

        {/* Page Numbers */}
        <div className="flex gap-2">
          {getPageNumbers().map((page, index) =>
            page === "..." ? (
              <span key={`ellipsis-${index}`} className="px-4 py-3 text-slate-400 font-medium">
                ...
              </span>
            ) : (
              <button
                key={page}
                onClick={() => onPageChange(page as number)}
                className={`
                  min-w-[48px] px-4 py-3 rounded-lg font-semibold transition-all duration-200
                  ${
                    current_page === page
                      ? "bg-gradient-to-r from-slate-900 to-red-600 text-white shadow-lg scale-110 ring-2 ring-red-400"
                      : "bg-white text-slate-800 hover:bg-red-50 hover:text-red-600 shadow-md hover:shadow-lg border border-slate-300 hover:scale-105"
                  }
                `}
              >
                {page}
              </button>
            )
          )}
        </div>

        {/* Next Button */}
        <button
          onClick={() => next_page && onPageChange(next_page)}
          disabled={!next_page}
          className={`
            px-5 py-3 rounded-lg font-medium transition-all duration-200 flex items-center gap-2
            ${
              next_page
                ? "bg-white text-slate-800 hover:bg-red-50 hover:text-red-600 shadow-md hover:shadow-lg border border-slate-300"
                : "bg-slate-100 text-slate-400 cursor-not-allowed border border-slate-300"
            }
          `}
        >
          <span className="hidden sm:inline">Наступна</span>
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
          </svg>
        </button>
      </div>
    </div>
  );
}

