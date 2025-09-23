# Project Structure

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
	├───hooks/          # Custom React hooks (reusable logic)
	├───pages/          # Full pages (LoginPage, EventsPage)
	├───services/       # API calls (axios/fetch)
	├───styles/         # Tailwind config and custom styles
	└───utils/          # Utility functions (constants, helpers, validators)
```

---

---

## Documentation

- **[Frontend Setup](frontend-setup.md)** - Installation, development commands, and workflow
- **[Frontend Conventions](frontend-conventions.md)** - Code style, component patterns, and best practices
- **[README.md](../README.md)** - Project overview and contributing guidelines
