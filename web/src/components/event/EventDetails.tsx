import type { Event } from "../../services/EventService";

type Props = {
  event: Event;
};

export default function EventDetails({ event }: Props) {
  const defaultImage = "/images/default-event.jpg"; 
  const imageUrl = event.image_url || defaultImage;
  console.log(event)

  return (
    <div className="max-w-4xl mx-auto px-4 py-10">
      <img
        src={imageUrl}
        alt={event.title}
        className="w-full h-64 object-cover rounded-lg shadow-md mb-6"
      />

      <h1 className="text-3xl font-bold text-gray-800 mb-2">{event.title}</h1>
      <div className="text-gray-500 mb-4">
        <p className="capitalize font-medium">{event.status}</p>
      </div>

      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6">
        <p className="text-gray-700">
          📍 <span className="font-medium">{event.location}</span>
        </p>
        <div className="text-gray-700">
          🗓️{" "}
          <span className="font-medium">
            {new Date(event.start_date).toLocaleDateString()} –{" "}
            {new Date(event.finish_date).toLocaleDateString()}
          </span>
        </div>
      </div>

      <div className="bg-gray-100 rounded-lg p-6 shadow-sm">
        <h2 className="text-xl font-semibold mb-3 text-gray-800">About this event</h2>
        <p className="text-gray-700 leading-relaxed">{event.description}</p>
      </div>

      <div className="mt-8 flex justify-between items-center">
        <p className="text-lg text-gray-800">
          💸 Ticket Price: <span className="font-semibold">{event.ticket_price} UAH</span>
        </p>
        <button className="px-5 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition">
          Join Event
        </button>
      </div>
    </div>
  );
}
