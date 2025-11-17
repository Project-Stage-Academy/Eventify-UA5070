import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { EventService, type EventDTO, type PaginationMeta } from "../services/EventService";
import { EventCard } from "../components/EventCard";
import { Pagination } from "../components/Pagination";
import { EventsCounter } from "../components/EventsCounter";
import { Filters } from "../components/Filters";
import { Button } from "../components/ui/Button";
import { clearAuthTokens } from "../lib/auth";

function EventsPage() {
  const navigate = useNavigate();
  const [events, setEvents] = useState<EventDTO[]>([]);
  const [pagination, setPagination] = useState<PaginationMeta | null>(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const eventService = new EventService();

    const fetchEvents = async () => {
      try {
        setLoading(true);
        const response = await eventService.getEvents(currentPage, 15);
        setEvents(Array.isArray(response.data) ? response.data : []);
        setPagination(response.pagination);
        setError(null);
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to load events");
      } finally {
        setLoading(false);
      }
    };

    fetchEvents();
  }, [currentPage]);

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  const handleEventClick = (id: number) => {
    console.log("Navigate to event:", id);
    // TODO: додати роутинг коли буде сторінка деталей
  };

  const handleLogout = () => {
    clearAuthTokens();
    navigate("/login");
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-screen bg-gradient-to-br from-slate-200 via-slate-100 to-red-50">
        <div className="flex flex-col items-center gap-4">
          <div className="w-16 h-16 border-4 border-red-600 border-t-transparent rounded-full animate-spin"></div>
          <div className="text-lg text-slate-900 font-medium">Завантаження подій...</div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex flex-col justify-center items-center min-h-screen gap-6 bg-gradient-to-br from-slate-200 via-slate-100 to-red-100 px-4">
        <div className="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full text-center border border-slate-300">
          <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg className="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <h2 className="text-xl font-bold text-slate-900 mb-2">Помилка завантаження</h2>
          <p className="text-slate-700 mb-6">{error}</p>
          <div className="flex gap-3 justify-center">
            <Button onClick={() => window.location.reload()}>
              Спробувати знову
            </Button>
            <Button variant="secondary" onClick={handleLogout}>
              Вийти
            </Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-200 via-slate-100 to-red-50">
      {/* Content */}
      <div className="container mx-auto px-4 py-8">
        {/* Top controls */}
        <div className="flex justify-between items-center mb-8 gap-4">
          {/* Left: Logo + Add button */}
          <div className="flex items-center gap-4">
            <h1 className="text-2xl font-bold text-slate-900">Eventify</h1>
            <Button
              variant="tertiary"
              onClick={() => console.log('Add new event clicked')}
            >
              Add new event
            </Button>
          </div>

          {/* Right: Filters + Total count */}
          <div className="flex items-center gap-4">
            <Filters onFiltersClick={() => console.log('Filters clicked')} />
            <EventsCounter count={pagination?.total_count || 0} />
          </div>
        </div>

        {/* Events grid */}
        {events.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20">
            <div className="bg-white rounded-2xl shadow-xl p-12 max-w-md w-full text-center border border-slate-300">
              <div className="w-24 h-24 bg-gradient-to-br from-slate-200 to-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg className="w-12 h-12 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <h2 className="text-2xl font-bold text-slate-900 mb-2">Немає подій</h2>
              <p className="text-slate-700">Поки що немає жодної події для відображення</p>
            </div>
          </div>
        ) : (
          <>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 animate-fadeIn">
              {events.map((event, index) => (
                <div
                  key={event.id}
                  style={{
                    animation: `fadeInUp 0.5s ease-out ${index * 0.1}s both`
                  }}
                >
                  <EventCard event={event} onClick={handleEventClick} />
                </div>
              ))}
            </div>

            {/* Pagination */}
            {pagination && <Pagination pagination={pagination} onPageChange={handlePageChange} />}
          </>
        )}
      </div>
    </div>
  );
}

export default EventsPage;

