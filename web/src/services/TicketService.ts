import { env } from "@/lib/env";
import type { Event } from "./EventService";

type PropsType = {
  token: string
  page?: number
  perPage?: number 
  sort?: string 
  direction?: "asc" | "desc"
};

export type PaginationMeta = {
  current_page: number;
  total_pages: number;
  total_count: number;
};

export type PaginatedResponse<T> = {
  data: T[];
  pagination: PaginationMeta;
};

export async function fetchRegEvents({
  token, 
  page = 1, 
  perPage = 10, 
  sort = "start_date", 
  direction = "asc"
}: PropsType): Promise<PaginatedResponse<Event>> {
  const response = await fetch(
    `${env.apiUrl}/v1/events/joined?page=${page}&perPage=${perPage}&sort=${sort}&direction=${direction}`,
    {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-type": "application/json",
      },
    })
  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.message || "Failed to fetch events");
  }

  return response.json() as Promise<PaginatedResponse<Event>>;
};


export async function fetchEventTickets(eventId: string, token: string) {
  const response = await fetch(`${env.apiUrl}/v1/events/${eventId}/members`, {
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
  });

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.message || "Failed to fetch tickets");
  }

  return response.json();
}
