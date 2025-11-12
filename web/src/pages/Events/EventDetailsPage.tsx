import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { fetchEvent } from "../../services/EventService";
import type { Event } from "../../services/EventService";
import EventDetails from "../../components/event/EventDetails";
import TicketModal from "../../components/event/TicketModal";
import { ErrorPopup } from "@/components/ui/ErrorPopup";
import { LoadingOverlay } from "@/components/ui/LoadingOverlay";

export default function EventDetailsPage() {
  const { id } = useParams<{ id: string }>();
  // TODO: Replace with real auth when login/register is ready
  const token = import.meta.env.VITE_DEV_TOKEN;
  const [event, setEvent] = useState<Event | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [errorPopupOpen, setErrorPopupOpen] = useState(false);


  async function loadEvent() {
      try {
        console.log(token)
        const data = await fetchEvent(id!, token!);
        if (!data) {
          setError("Event not found");
          return;
        }
        setEvent(data);
      } catch (err) {
        const msg = (err as Error).message || "Failed to load event";
        setError(msg);
        setErrorPopupOpen(true);
      } finally {
        setLoading(false);
      }
    }

  useEffect(() => {
    if (!id || !token) {
      setLoading(false);
      return;
    }

    loadEvent();
  }, [id, token]);

  if (!loading && !event && !error) {
    return (
      <main className="flex flex-col items-center justify-center min-h-[60vh] text-slate-600">
        <p className="text-lg font-medium">Event not found</p>
      </main>
    );
  }

  return (
    <main>
      {event && (
        <EventDetails event={event} onBuyClick={() => setIsModalOpen(true)} />
      )}

      {isModalOpen && (
        <TicketModal
          authToken={token}
          event={event!}
          onClose={() => setIsModalOpen(false)}
          onError={(message) => {
            setError(message);
            setErrorPopupOpen(true);
          }}
        />
      )}

      <ErrorPopup
        open={errorPopupOpen}
        onClose={() => setErrorPopupOpen(false)}
        message={error ?? undefined}
      />

      <LoadingOverlay open={loading} message="Loading event..." />
    </main>
  );
}
