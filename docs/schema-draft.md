# Database Schema Draft

This document describes the comprehensive database schema for the event management system.

## Entity-Relationship Diagram (ERD)
[Open diagram in draw.io ](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=Eventify&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1ib_kXSDhvnz-SHsP0afHkKzuQzrqwK-f%26export%3Ddownload)

---

## users
- **id (PK)** – unique user identifier.  
- **name** – user’s name (required).  
- **email** – user’s email (required, unique).  
- **password_hashed** – stored password hash.  
- **created_at, updated_at** – managed automatically by ActiveRecord.  

---

## roles
- **id (PK)** – unique role identifier.  
- **name** – role name (e.g., `ADMIN`, `USER`), unique and required.  

---

## user_roles
Join table for **many-to-many** relation between `users` and `roles`.  
- **user_id (FK → users.id)** – user reference.  
- **role_id (FK → roles.id)** – role reference.  
- **composite PK (user_id, role_id)** – ensures uniqueness.  

---

## events
Main table for events.  
- **id (PK)** – unique event identifier.  
- **title** – event title.  
- **description** – event description.  
- **location** – event location.  
- **start_date** – event start timestamp.  
- **finish_date** – event end timestamp.  
- **member_capacity** – maximum allowed participants.  
- **ticket_price** – ticket price.  
- **status** – event status:  
  - `DRAFT`  
  - `PUBLISHED`  
  - `CANCELLED`  
  - `ARCHIVED`  
- **created_at, updated_at** – managed automatically.  

---

## event_organizers
Defines which users are organizers of an event.  
- **user_id (FK → users.id)**  
- **event_id (FK → events.id)**  
- **composite PK (user_id, event_id)** – one user can organize the same event only once.  

---

## event_members
Defines event participation.  
- **id (PK)**  
- **user_id (FK → users.id)** – participant reference.  
- **event_id (FK → events.id)** – event reference.  
- **status** – membership status (TBD: pending, approved, etc.).  
- **ticket_qr_code** – unique ticket identifier.  
- **rating** – smallint, constrained between 1 and 5.  
- **comment** – optional participant comment.  
- **unique_pair(user_id, event_id)** – prevents duplicates.  

---

## event_comments
User comments on events.  
- **id (PK)**  
- **event_id (FK → events.id)** – event reference.  
- **author_id (FK → users.id)** – author of the comment.  
- **message_text** – comment text.  
- **belongs_to (FK → event_comments.author_id, nullable)** – optional reply to another comment.  

---

## tags
- **id (PK)**  
- **name** – unique tag name.  
Used for categorizing events.  

---

## event_tags
Join table for **many-to-many** relation between events and tags.  
- **event_id (FK → events.id)**  
- **tag_id (FK → tags.id)**  
- **composite PK (event_id, tag_id)**  

---

## proposed_events
Moderation workflow for new events or updates to existing events.  
- **id (PK)**  
- **event_id (FK → events.id, nullable)** – `NULL` means new event, otherwise it refers to the event being updated.  
- **title, description, location, start_date, finish_date, member_capacity, ticket_price** – proposed fields.  
- **review_status** – status of review process:  
  - `DRAFT`  
  - `ON_REVIEW`  
  - `APPROVED`  
  - `REJECTED`  
- **review_comment** – moderator’s comment.  

---

# Relationships (Summary)

- One **User** can have many **Roles** (through `user_roles`).  
- One **User** can organize many **Events** (through `event_organizers`).  
- One **User** can participate in many **Events** (through `event_members`).  
- One **User** can post many **Comments**.  
- One **Event** can have many **Members**, **Organizers**, **Comments**, and **Tags**.  
- One **Event** can have zero or one **ProposedEvent**.  
- One **Tag** can be assigned to many **Events** (through `event_tags`).  
