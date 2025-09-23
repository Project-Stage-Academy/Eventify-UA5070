# Development Setup

This project is set up with modern development tools for code quality and consistency.

## Tools Configured

### ESLint

- **Purpose**: Code linting and error detection
- **Config**: `eslint.config.js` with React-specific rules
- **Commands**:
  - `npm run lint` - Check for issues
  - `npm run lint:fix` - Auto-fix issues

### Prettier

- **Purpose**: Code formatting
- **Config**: `.prettierrc` with consistent style rules
- **Commands**:
  - `npm run format` - Format all files
  - `npm run format:check` - Check formatting

### Tailwind CSS

- **Purpose**: Utility-first CSS framework
- **Config**: `tailwind.config.js` and `postcss.config.js`
- **Usage**: Use Tailwind classes directly in JSX

## Project Structure

```
src/
├── components/     # Reusable UI components (EventList, EventForm, Navbar)
├── pages/          # Full pages (LoginPage, EventsPage)
├── services/       # API calls (axios/fetch)
├── context/        # Authentication context (AuthContext)
├── styles/         # Tailwind config and custom styles
└── assets/         # Images, icons, etc.

__tests__/          # Jest/React Testing Library tests
```

## Conventions

- Use functional components + hooks
- Export components as default
- Use descriptive prop names
- Keep components focused and reusable

## Development Workflow

1. **Before committing**:

   ```bash
   npm run lint:fix
   npm run format
   ```

2. **VS Code Integration**:
   - Install recommended extensions:
     - ESLint
     - Prettier - Code formatter
     - Tailwind CSS IntelliSense
   - Files auto-format on save
   - ESLint auto-fixes on save

## Configuration Details

### ESLint Rules

- Enforces React best practices
- Prevents common errors
- Warns about performance issues
- Integrated with Prettier (no conflicts)

### Prettier Settings

- Single quotes
- No semicolons
- 2-space indentation
- Trailing commas where valid

### Tailwind CSS

- Configured for React JSX files
- Includes PostCSS with autoprefixer
- Uses Tailwind CSS v4 with `@tailwindcss/postcss`
- Purges unused styles in production

## Example Usage

### Button Component with Tailwind

```jsx
import { Button } from '../components'

// Usage
;<Button variant='primary' size='lg' onClick={handleClick}>
  Save Event
</Button>
```

### Authentication Context

```jsx
import { AuthProvider, useAuth } from '../context'

// Wrap your app
;<AuthProvider>
  <App />
</AuthProvider>

// Use in components
const { user, login, logout } = useAuth()
```

### Clean Imports with Index Files

```jsx
// Instead of multiple imports
import Button from '../components/Button'
import Modal from '../components/Modal'
import EventList from '../components/EventList'

// Use barrel exports
import { Button, Modal, EventList } from '../components'
```
