import { env } from "../lib/env";
import { getAccessToken } from "../lib/auth";

export type EventDTO = {
  id: number;
  title: string;
  description: string;
  location: string;
  start_date: string;
  end_date: string;
  max_participants: number;
  current_participants?: number;
  creator_id: number;
  created_at: string;
  updated_at: string;
};

export type PaginationMeta = {
  current_page: number;
  next_page: number | null;
  prev_page: number | null;
  total_pages: number;
  total_count: number;
  per_page: number;
};

export type EventsResponse = {
  data: EventDTO[];
  pagination: PaginationMeta;
};

export class EventService {
  async getEvents(page: number = 1, perPage: number = 15): Promise<EventsResponse> {
    const token = getAccessToken();
    const params = new URLSearchParams({
      page: page.toString(),
      per_page: perPage.toString(),
    });

    const url = `${env.apiUrl}/v1/events?${params}`;
    console.log('Fetching events:', url);

    const res = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        ...(token && { Authorization: `Bearer ${token}` }),
      },
    });

    if (!res.ok) {
      throw new Error(`Failed to fetch events: ${res.status}`);
    }

    const json = await res.json();
    console.log('Events API response:', json);
    return {
      data: json.data || [],
      pagination: json.pagination || {
        current_page: 1,
        next_page: null,
        prev_page: null,
        total_pages: 1,
        total_count: 0,
        per_page: perPage,
      },
    };
  }

  async getEventById(id: number): Promise<EventDTO> {
    const token = getAccessToken();
    const res = await fetch(`${env.apiUrl}/v1/events/${id}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        ...(token && { Authorization: `Bearer ${token}` }),
      },
    });

    if (!res.ok) {
      throw new Error(`Failed to fetch event: ${res.status}`);
    }

    const json = await res.json();
    return json.data;
  }
}

