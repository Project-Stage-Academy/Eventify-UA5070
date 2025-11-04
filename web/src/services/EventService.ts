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
  participant_capacity: number;
  image_url?: string;
};

export function parsePrice(priceString: string): number {
  return parseFloat(priceString);
}

export function formatPrice(price: string | number): string {
  const numPrice = typeof price === 'string' ? parseFloat(price) : price;
  return numPrice.toFixed(2);
}

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


export async function registerEvent(id: string, token: string , ticketNum: number) {
  const response = await fetch(`${env.apiUrl}/v1/events/${id}/members`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`
    },
    body: JSON.stringify({
      event_member:{
        number_of_tickets: ticketNum
      }
    })
  });

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.message || "Failed to register for event");
  }
  
  return await response.json();

}