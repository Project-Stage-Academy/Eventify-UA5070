# Eventify – Event & Ticketing Platform

**Eventify** is a learning project built with **Ruby on Rails** and **React** that simulates a real-world event management and ticketing system.
It allows organizers to create and publish events (concerts, lectures, meetups), participants to register and receive tickets, and administrators to manage users and content.

## Features

* User roles: **Admin, Organizer, Participant**
* Create, edit, and publish events with date validation
* Ticket generation (unique code / QR)
* Participant registration and enrollment
* Event reviews and ratings
* RESTful JSON API for mobile clients
* React-based frontend with calendar & event list
* MongoDB integration for login and activity logs
* CI/CD pipeline with linting, testing, and deployment

## Tech Stack

* **Backend:** Ruby on Rails, ActiveRecord, PostgreSQL
* **Frontend:** React, TailwindCSS
* **Auth:** JWT-based authentication
* **Database:** PostgreSQL + MongoDB (logs)
* **Tools:** RSpec, Rubocop, GitHub Actions

---

## Contributing

We use **issue-based branching** to keep development organized and traceable.

### Branch Naming

Use the format:

```
issue-<issue-number>/<short-description>
```

**Examples:**

* `issue-12/add-event-crud`
* `issue-45/fix-login-validation`
* `issue-77/update-readme`

### Workflow

1. Make sure there is a GitHub issue for your work.
2. Create a new branch from `main`:

   ```bash
   git checkout -b issue-12/add-event-crud
   ```
3. Commit your changes with clear, descriptive messages.
4. Push the branch and open a Pull Request that links to the issue (e.g., `Closes #12`).
5. Wait for review and approval before merging.
