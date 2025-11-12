import { useEffect, useState } from "react";
import ReactPaginate from "react-paginate";
import type { Event } from "@/services/EventService";
import { fetchRegEvents, fetchEventTickets, type PaginationMeta } from "@/services/TicketService";
import { ErrorPopup } from "@/components/ui/ErrorPopup";
import { LoadingOverlay } from "@/components/ui/LoadingOverlay";
import { UserTicketItem } from "@/components/event/UserTicketItem";

export default function UserTicketsPage() {
  const [events, setEvents] = useState<Event[]>([]);
  const [pagination, setPagination] = useState<PaginationMeta | null>(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [expandedEventId, setExpandedEventId] = useState<string | null>(null);
  const [tickets, setTickets] = useState<Record<string, any[]>>({});
  const [loadingTickets, setLoadingTickets] = useState<Record<string, boolean>>({});

  const token = import.meta.env.VITE_DEV_TOKEN;
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [errorPopupOpen, setErrorPopupOpen] = useState(false);

  async function loadRegEvents(page = 1) {
    try {
      setLoading(true);
      const data = await fetchRegEvents({ token, page });
      if (!data) throw new Error("Failed to load registered events!");

      setEvents(data.data);
      setPagination(data.pagination);
      setCurrentPage(data.pagination.current_page);
    } catch (err) {
      setError((err as Error).message);
      setErrorPopupOpen(true);
    } finally {
      setLoading(false);
    }
  }

  async function handleEventExpand(event: Event) {
    if (expandedEventId === event.id) {
      setExpandedEventId(null);
      return;
    }

    setExpandedEventId(event.id);

    if (tickets[event.id]) {
      return;
    }

    try {
      setLoadingTickets(prev => ({ ...prev, [event.id]: true }));
      const data = await fetchEventTickets(event.id, token);
      setTickets(prev => ({ ...prev, [event.id]: data.data }));
    } catch (err) {
      setError((err as Error).message);
      setErrorPopupOpen(true);
    } finally {
      setLoadingTickets(prev => ({ ...prev, [event.id]: false }));
    }
  }

  useEffect(() => {
    loadRegEvents(currentPage);
  }, [currentPage]);

  const handlePageChange = (selectedItem: { selected: number }) => {
    const newPage = selectedItem.selected + 1;
    setCurrentPage(newPage);
  };

  return (
    <main className="min-h-screen">
      <div className="max-w-4xl mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-800 mb-2">My tickets</h1>
        </div>

        {events.length === 0 && !loading ? (
          <div className="bg-white rounded-2xl shadow-lg p-12 text-center">
            <p className="text-gray-600 text-lg">You have not yet registered for any events</p>
          </div>
        ) : (
          <div className="space-y-4">
            {events.map(event => (
              <UserTicketItem 
                key={event.id} 
                event={event} 
                onExpand={() => handleEventExpand(event)}
                isExpanded={expandedEventId === event.id}
                tickets={tickets[event.id] || []}
                isLoadingTickets={loadingTickets[event.id] || false}
              />
            ))}
          </div>
        )}

        {pagination && pagination.total_pages > 1 && (
          <div className="flex justify-center mt-8">
            <ReactPaginate
              previousLabel="←"
              nextLabel="→"
              breakLabel="..."
              pageCount={pagination.total_pages}
              forcePage={currentPage - 1}
              onPageChange={handlePageChange}
              containerClassName="flex gap-2"
              pageClassName="px-3 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
              activeClassName="bg-indigo-600 text-white hover:bg-indigo-700 border-indigo-600"
              previousClassName="px-3 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
              nextClassName="px-3 py-2 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
              disabledClassName="opacity-50 cursor-not-allowed"
            />
          </div>
        )}

        <ErrorPopup
          open={errorPopupOpen}
          onClose={() => setErrorPopupOpen(false)}
          message={error ?? undefined}
        />

        <LoadingOverlay open={loading} message="Loading events..." />
      </div>
    </main>
  );
}