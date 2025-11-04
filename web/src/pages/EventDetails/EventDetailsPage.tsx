import { useContext, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { getEvent } from "../../services/EventService";
import type { Event } from "../../services/EventService";
import { AuthContext } from "../../context/AuthContext";
import EventDetails from "../../components/event/EventDetails";
import TicketModal from "../../components/event/TicketModal";

export default function EventDetailsPage() {
  const { id } = useParams<{ id: string }>();
  const { token } = useContext(AuthContext);
  const [event, setEvent] = useState<Event | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);

  useEffect(() => {
    if (!id || !token) return;

    async function load() {
      try {
        const data = await getEvent(id!, token!);
        setEvent(data);
      } catch (err) {
        setError((err as Error).message);
      } finally {
        setLoading(false);
      }
    }

    load();
  }, [id]);

  useEffect(() => {
    if (event) {
      console.log("Event updated:", event);
    }
  }, [event]);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error}</p>;
  if (!event) return <p>No event found.</p>;

  return (
    <main>
      <EventDetails event={event} onBuyClick={() => setIsModalOpen(true)} />

      {isModalOpen && (
        <TicketModal event={event} onClose={() => setIsModalOpen(false)} />
      )}
    </main>
  );
}
