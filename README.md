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

--

## Eventify Docs Space

For more information, check out our [**Eventify Docs Space**](https://project-stage-academy.github.io/Eventify-UA5070/).

---

## Contributing

We use **issue-based branching** to keep development organized and traceable.

### Project Structure & Conventions

- **Project layout**: [docs/project-structure.md](docs/chapters/guides/project-structure.md)
- **Frontend setup**: [docs/frontend-setup.md](docs/chapters/guides/frontend-setup.md)
- **Frontend conventions**: [docs/frontend-conventions.md](docs/chapters/guides/frontend-conventions.md)
- **General conventions**: [docs/conventions.md](docs/chapters/guides/conventions.md)

### Workflow

1. Make sure there is a GitHub issue for your work.
2. Create a new branch from `develop`: `git checkout -b issue-12/add-event-crud`   
3. Commit your changes with clear, descriptive messages.
4. Push the branch and open a Pull Request that links to the issue (e.g., `Closes #12`).
5. Wait for review and approval before merging.

