# Events API

The Events API allows clients to create and view events.

---

## Endpoints

### List Events
**GET** `/api/v1/events`

Returns a list of all events.

**Response**
```json
[
  {
    "id": 1,
    "title": "Tech Conference",
    "description": "Annual technology conference with speakers and workshops",
    "location": "Kyiv, Ukraine",
    "start_date": "2025-10-15T09:00:00Z",
    "finish_date": "2025-10-15T18:00:00Z",
    "member_capacity": 200,
    "ticket_price": 49.99,
    "event_status": "scheduled",
    "review_status": "approved",
    "review_comment": "Reviewed by admin, ready to publish"
  }
]
