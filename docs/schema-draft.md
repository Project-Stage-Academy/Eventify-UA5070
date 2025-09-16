# Database Schema Draft

This document describes the comprehensive database schema for the event management system.

## Entity-Relationship Diagram (ERD)
[Open diagram in draw.io ](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=Eventify&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1ib_kXSDhvnz-SHsP0afHkKzuQzrqwK-f%26export%3Ddownload)

---

## Entities

### 1. User
Represents a person who can participate in or organize events.

- **id**: Primary key, unique identifier of the user.  
- **name**: User's full name (required).  
- **email**: User's email address (required, unique).  
- **password_digest**: Hashed password for authentication.  
- **created_at / updated_at**: Timestamps automatically managed by the system.

---

### 2. Role
Defines different permission levels in the system.

- **RoleId**: Primary key, unique identifier of the role.  
- **name**: Role name (required, unique). Possible values: `USER`, `ORGANIZER`, `ADMIN`.  
- **description**: Optional text describing the role permissions.

---

### 3. UserRole
Junction table managing many-to-many relationships between users and roles.

- **UserId**: Foreign key referencing `User.id` (composite primary key).  
- **RoleId**: Foreign key referencing `Role.RoleId` (composite primary key).

---

### 4. Event
Represents an event with comprehensive details and status tracking.

- **id**: Primary key, unique identifier of the event.  
- **title**: Event title (required).  
- **description**: Optional text describing the event.  
- **location**: Event location (required).  
- **start_date**: Event start date and time (required, must be in the future).  
- **finish_date**: Event end date and time (required, must be after start_date).  
- **participant_capacity**: Maximum number of participants (optional).  
- **ticket_price**: Event ticket price (optional, must be non-negative).  
- **status**: Event status (required). Possible values: `PUBLISHED`, `DRAFT`, `CANCELLED`, `COMPLETED`, `IN_REVIEW`, `REJECTED`.

---

### 5. EventParticipant
Junction table managing event registrations and participant status.

- **user_id**: Foreign key referencing `User.id` (composite primary key).  
- **event_id**: Foreign key referencing `Event.id` (composite primary key).  
- **registered_at**: Timestamp of registration (auto-generated).

---

### 6. EventOrganizer
Manages which users can organize specific events.

- **id**: Primary key, unique identifier.  
- **participant_id**: Foreign key referencing `EventParticipant.id`.

---

### 7. Member
Tracks detailed participant information and ratings.

- **id**: Primary key, unique identifier.  
- **participant_id**: Foreign key referencing `EventParticipant.id`.  
- **ticket_qr_code**: QR code for event entry (unique).  
- **rating**: Member rating (integer, must be between 1-5).  
- **comment**: Additional comments (optional).

---

### 8. EventParticipantComments
Stores comments from participants about events.

- **id**: Primary key, unique identifier.  
- **participant_id**: Foreign key referencing `EventParticipant.id`.  
- **comment**: Comment text (required).  
- **created_at**: Comment timestamp (auto-generated).

---

### 9. ReviewSubmission
Manages event review processes.

- **id**: Primary key, unique identifier.  
- **event_id**: Foreign key referencing `Event.id`.  
- **status**: Review status (required). Possible values: `OPEN`, `CLOSED`.  
- **comment**: Review comments (optional).  
- **submitted_at**: Submission timestamp (auto-generated).

---

### 10. Tag
Provides categorization system for events.

- **id**: Primary key, unique identifier.  
- **name**: Tag name (required, unique).

---

### 11. EventTags
Junction table managing many-to-many relationships between events and tags.

- **event_id**: Foreign key referencing `Event.id` (composite primary key).  
- **tag_id**: Foreign key referencing `Tag.id` (composite primary key).

---

## Relationships

### Primary Relationships

- **User ↔ Role** (Many-to-Many via UserRole): Users can have multiple roles, roles can be assigned to multiple users.

- **User ↔ Event** (Many-to-Many via EventParticipant): Users can participate in multiple events, events can have multiple participants.

- **Event ↔ Tag** (Many-to-Many via EventTags): Events can have multiple tags, tags can be applied to multiple events.

- **EventParticipant → EventOrganizer** (One-to-Zero-or-One): Some participants can become organizers.

- **EventParticipant → Member** (One-to-Zero-or-One): Participants can have detailed member profiles with ratings and QR codes.

- **EventParticipant → EventParticipantComments** (One-to-Many): Participants can make multiple comments about events.

- **Event → ReviewSubmission** (One-to-Many): Events can have multiple review submissions during the approval process.