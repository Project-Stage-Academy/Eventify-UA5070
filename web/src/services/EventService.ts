import { env } from "../lib/env";

export type Event = {
  id: string;
  title: string;
  description: string;
  start_date: string;
  finish_date: string;
  location: string;
  ticket_price: string;
  status: string;
  image_url?: string;
};

export async function getEvent(id: string, token: string): Promise<Event> {
  const response = await fetch(`${env.apiUrl}/v1/events/${id}`, {
    method: "GET",
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.message || "Failed to fetch event");
  }

  const json = await response.json();

  return json.data as Event;
}
