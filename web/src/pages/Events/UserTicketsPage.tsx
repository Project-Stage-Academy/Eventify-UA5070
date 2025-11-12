import { useEffect, useState } from "react"
import type { Event } from "@/services/EventService"
import { fetchRegEvents, type PaginationMeta } from "@/services/TicketService"
import { ErrorPopup } from "@/components/ui/ErrorPopup"
import { LoadingOverlay } from "@/components/ui/LoadingOverlay"
import { UserTicketItem } from "@/components/event/UserTicketItem"

export default function UserTicketsPage() {
  const [events , setEvents] = useState<Event[]>([])
  const [pagination, setPagination] = useState<PaginationMeta | null>(null)
  const token = import.meta.env.VITE_DEV_TOKEN;
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [errorPopupOpen, setErrorPopupOpen] = useState(false);

  async function loadRegEvents() {
    try {
      console.log(token)
      const data = await fetchRegEvents({token});
      if(!data){
        setError("Failed to load registered events!")
        return;
      }
      const loadedEvents = data.data;
      const meta = data.pagination;
      setEvents(loadedEvents);
      setPagination(meta);

    } catch (err) {
      const msg = (err as Error).message || "Failed to load registered events";
      setError(msg);
      setErrorPopupOpen(true);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadRegEvents()
  },[])

  return (
    <main>

    <div className="space-y-4">
      {events.map(event => (
        <UserTicketItem key={event.id} event={event} />
      ))}
    </div>

      <ErrorPopup
        open={errorPopupOpen}
        onClose={() => setErrorPopupOpen(false)}
        message={error ?? undefined}
      />
      
      <LoadingOverlay open={loading} message="Loading event..." />
      
    </main>
  );

}