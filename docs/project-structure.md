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
	├───pages/          # Full pages (LoginPage, EventsPage)
	├───services/       # API calls (axios/fetch)
	└───styles/         # Tailwind config and custom styles
```

---

**For more details, see the [README.md](../README.md).**
