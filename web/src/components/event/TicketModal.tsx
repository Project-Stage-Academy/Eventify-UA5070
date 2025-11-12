import { useState } from "react";
import { Button } from "../ui/Button";
import { Input } from "../ui/Input";
import { Modal } from "../ui/Modal";
import { registerEvent, type Event } from "../../services/EventService";
import { parsePrice, formatPrice } from "@/utils/formatters";



type Props = {
  event: Event;
  onClose: () => void;
  authToken: string;
  onError: (error: string) => void
};

export default function TicketModal({ event, onClose, authToken, onError }: Props) {
  const [quantity, setQuantity] = useState(1);
  const [loading, setLoading] = useState(false);
  const maxTickets = 10;

  const handleChange = (value: number) => {
    const safeValue = Math.min(Math.max(value, 1), maxTickets);
    setQuantity(safeValue);
  };

  async function handleRegister() {
    setLoading(true);
    try {
      await registerEvent(event.id, authToken, quantity);
      onClose();
    } catch (err: any) {
      console.error("Registration error:", err);
      onError(err.message || "Failed to register for the event.");
    }
    finally {
      setLoading(false);
    }
  }

  return (
    <Modal open={true} onClose={onClose} title={`Buy Tickets for ${event.title}`}>
      <div className="space-y-4">
        <p className="text-gray-700">
          Price per ticket:{" "}
          <span className="font-semibold">{formatPrice(event.ticket_price)} UAH</span>
        </p>
        <p className="text-gray-700">
          Total price:{" "}
          <span className="font-semibold">
            {formatPrice(parsePrice(event.ticket_price) * quantity)} UAH
          </span>
        </p>

        <Input
          type="number"
          min={1}
          max={maxTickets}
          label="Number of tickets"
          value={quantity}
          onChange={(e) => handleChange(Number(e.target.value))}
          helperText={`You can buy up to ${maxTickets} tickets.`}
        />

        <div className="flex justify-end gap-3">
          <Button variant="ghost" onClick={onClose}>Cancel</Button>
          <Button variant="primary" onClick={handleRegister} loading={loading}>Confirm</Button>
        </div>
      </div>
    </Modal>
  );
}
