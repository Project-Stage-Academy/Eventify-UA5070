# Project Structure & Conventions

## Project Structure

```
api/					# Rails API root
	app/				# Application code
		models/         # Business logic, associations, validations
		controllers/    # REST API controllers, organized by resource
			api/        # API namespace for versioning
				vN/     # Version N of the API (e.g., v1, v2)
		services/       # Service objects (JwtService)
		serializers/    # JSON response formatting
		policies/       # Authorization rules (Pundit/CanCanCan)
	db/					# Database-related files
		migrate/		# Database migrations
	spec/           	# RSpec tests
		models/			# Model specs
		requests/		# Request specs: end-to-end API tests for controllers, routes, and middleware

web/					# React front-end root
	src/				# React app source code
		assets/			# Static assets (images, fonts, etc.)
		components/     # Reusable UI components (EventList, EventForm, Navbar)
		pages/          # Full pages (LoginPage, EventsPage)
		services/       # API calls (axios/fetch)
		context/        # Authentication context (AuthContext)
		styles/         # Tailwind config and custom styles
		__tests__/      # Jest/React Testing Library tests

docs/					# Technical docs
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
