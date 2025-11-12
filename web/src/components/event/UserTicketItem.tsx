import type { Event } from "@/services/EventService";
import { formatDate } from "./EventDetails";

export function UserTicketItem({ event }: { event: Event }) {
  return (
    <div className="border rounded-lg p-4 flex flex-col gap-2 hover:shadow-md transition-shadow">
      <h2 className="font-semibold text-lg">{event.title}</h2>
      <p className="text-gray-600 text-sm flex items-center gap-1">
         {event.location}
      </p>
      <p className="text-gray-500 text-sm">
        {formatDate(event.start_date)} — {formatDate(event.finish_date)}
      </p>
    </div>
  );
}