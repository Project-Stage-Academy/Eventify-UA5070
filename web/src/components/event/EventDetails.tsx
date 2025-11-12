import { formatPrice, type Event } from "../../services/EventService";
import { Button } from "../ui/Button";

type Props = {
  event: Event;
  onBuyClick: () => void;
};

export const formatDate = (dateString: string) =>
  new Date(dateString).toLocaleString("en-GB", {
    day: "2-digit",
    month: "short",
    hour: "2-digit",
    minute: "2-digit",
  });

const getStatusBadge = (status: string) => {
  switch (status) {
    case "published":
      return {
        label: "Verified",
        className: "bg-green-100 text-green-800",
      };
    case "published_unverified":
      return {
        label: "Unverified",
        className: "bg-red-100 text-red-800",
      };
    default:
      return {
        label: status,
        className: "bg-gray-100 text-gray-800",
      };
  }
};

export default function EventDetails({ event, onBuyClick }: Props) {
  const defaultImage = "https://placehold.co/300x300?text=No+Image";
  const imageUrl = event.image_url || defaultImage;

  const badge = getStatusBadge(event.status);

  return (
    <main className="max-w-5xl mx-auto my-10 bg-white rounded-2xl border border-gray-200 p-6 md:p-10">
      <section className="flex flex-col md:flex-row gap-8">
        <div className="w-full md:w-1/3">
          <img
            src={imageUrl}
            alt={event.title}
            className="w-full aspect-square object-cover rounded-xl"
          />
        </div>

        <div className="w-full md:w-2/3 flex flex-col">
          <span
            className={`inline-block ${badge.className} text-xs font-semibold px-3 py-1 rounded-full uppercase tracking-wide mb-3 self-start`}
          >
            {badge.label}
          </span>

          <h1 className="text-3xl md:text-4xl font-bold text-gray-900 mb-2">
            {event.title}
          </h1>

          <p className="text-lg text-gray-600 mb-4">{event.location}</p>

          <div className="text-md text-gray-800 space-y-1 mb-4">
            <p>
              <strong>Start:</strong> {formatDate(event.start_date)}
            </p>
            <p>
              <strong>End:</strong> {formatDate(event.finish_date)}
            </p>
            <p>
              <strong>Maximum attendees:</strong> {event.participant_capacity}
            </p>
          </div>

          <p className="text-2xl font-bold text-gray-900 mt-auto">
            {event.ticket_price === "0.0"
              ? "Price: Free"
              : `Price: ${formatPrice(event.ticket_price)} UAH`}
          </p>
        </div>
      </section>

      <div className="mt-8">
        <Button variant="secondary" className="w-full text-lg py-3" onClick={onBuyClick}>
          Join Event
        </Button>

      </div>

      <section className="mt-10 border-t border-gray-200 pt-8">
        <h2 className="text-2xl font-bold text-gray-900 mb-4">
          About the Event
        </h2>
        <div className="max-w-full text-gray-700 leading-relaxed">
          <p>{event.description}</p>
        </div>
      </section>
    </main>
  );
}
