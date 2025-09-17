# Project Structure & Conventions

## Project Structure

```
api/					# Rails API root
├───app/				# Application code
|	├───controllers/    # REST API controllers, organized by resource
|	|	└───api/        # API namespace for versioning
|	|		└───vN/     # Version N of the API (e.g., v1, v2)
|	├───models/         # Business logic, associations, validations
|	├───policies/       # Authorization rules (Pundit/CanCanCan)
|	├───serializers/    # JSON response formatting
|	└───services/       # Service objects (JwtService)
└───spec/           	# RSpec tests
	├───models/			# Model specs
	└───requests/		# Request specs: end-to-end API tests for controllers, routes, and middleware

docs/					# Technical docs

web/					# React front-end root
├───__tests__/      	# Jest/React Testing Library tests
└───src/				# React app source code
	├───assets/			# Static assets (images, fonts, etc.)
	├───components/     # Reusable UI components (EventList, EventForm, Navbar)
	├───context/        # Authentication context (AuthContext)
	├───pages/          # Full pages (LoginPage, EventsPage)
	├───services/       # API calls (axios/fetch)
	└───styles/         # Tailwind config and custom styles
```

---

## Naming & Coding Conventions

### Back-end

- Controllers under `app/controllers/api/v1/` for API versioning.
- Unified error format: `{ errors: { field: ["message"] } }`
- Use strong parameters in controllers.

### Front-end

- Use functional components and React hooks.
- Enforce code style with ESLint and Prettier.

### Shared

- **Use the following format for branches:**  
  ```
  issue-<number>/<short-description>
  ```
  **Examples:**
  - `issue-12/add-event-crud`
  - `issue-45/fix-login-validation`
  - `issue-77/update-readme`

- **Commit messages:** Conventional commits (`feat:`, `fix:`, `test:`, `docs:`)
- **CI/CD stages:** lint → test → build
- **Documentation:** Technical docs under `docs/` (ERD, API spec)

---

**For more details, see the [README.md](../README.md).**
