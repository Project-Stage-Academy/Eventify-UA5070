import { useState } from "react";
import type { Event } from "../../services/EventService";

type Props = {
  event: Event;
  onClose: () => void;
};

export default function TicketModal({ event, onClose }: Props) {
  const [quantity, setQuantity] = useState(1);

  const maxTickets = 10;

  const handleChange = (value: number) => {
    const safeValue = Math.min(Math.max(value, 1), maxTickets);
    setQuantity(safeValue);
  };

  const handlePurchase = () => {
    console.log(`Buying ${quantity} ticket(s) for ${event.title}`);
    onClose();
  };

  return (
    <div
      role="dialog"
      aria-modal="true"
      className="fixed inset-0 z-50 grid place-items-center bg-black/50 backdrop-blur"
      onMouseDown={(e) => {
        if (e.target === e.currentTarget) onClose();
      }}
    >
      <div
        className="w-[min(92vw,560px)] bg-white border border-gray-200 rounded-2xl p-8 relative"
        onMouseDown={(e) => e.stopPropagation()}
      >
        <button
          onClick={onClose}
          aria-label="Close"
          className="absolute top-4 right-4 rounded-lg p-2 hover:bg-gray-100"
        >
          <svg viewBox="0 0 24 24" className="w-5 h-5" aria-hidden="true">
            <path
              d="M6 6l12 12M18 6L6 18"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
            />
          </svg>
        </button>

        <h2 className="text-2xl font-bold text-gray-900 mb-4">
          Buy Tickets for {event.title}
        </h2>

        <p className="text-gray-700 mb-2">
          Price per ticket:{" "}
          <span className="font-semibold">{event.ticket_price} UAH</span>
        </p>

        <label className="block text-gray-800 font-medium mb-2">
          Number of tickets:
        </label>

        <input
          type="number"
          min={1}
          max={maxTickets}
          value={quantity}
          onChange={(e) => handleChange(Number(e.target.value))}
          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-300"
        />

        <p className="text-sm text-gray-500 mt-1 mb-6">
          You can buy up to {maxTickets} tickets.
        </p>

        <div className="flex justify-end gap-3">
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-100 transition"
          >
            Cancel
          </button>
          <button
            onClick={handlePurchase}
            className="px-6 py-2 rounded-lg bg-black text-white font-semibold hover:bg-gray-800 transition"
          >
            Confirm
          </button>
        </div>
      </div>
    </div>
  );
}
