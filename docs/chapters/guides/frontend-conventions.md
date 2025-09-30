# Frontend Conventions

## Component Development

### Component Structure
- Use functional components with hooks
- PascalCase file naming (`EventCard.jsx`)
- Default exports for components
- Destructure props with defaults

```jsx
// Component example
const EventCard = ({ title, className = '' }) => (
  <div className={`bg-white rounded-lg shadow p-4 ${className}`}>
    <h3 className='text-lg font-semibold'>{title}</h3>
  </div>
)

export default EventCard
```

### Adding New Components

```jsx
// src/components/MyComponent.jsx
const MyComponent = ({ title, children }) => {
  return (
    <div className='p-4 bg-white rounded-lg shadow'>
      <h2 className='text-xl font-bold'>{title}</h2>
      {children}
    </div>
  )
}

export default MyComponent
```

```js
// src/components/index.js
export { default as MyComponent } from './MyComponent'
```

## State Management

### Local State
- Use `useState` for component-specific state
- Use `useReducer` for complex state logic

### Global State
- **React Context**: For app-wide state (authentication, theme)
- **Custom Hooks**: For reusable logic (API calls, form handling, storage)

```jsx
// Using Context for global state
import { useAuth } from '../context'

const LoginPage = () => {
  const { login, loading, error } = useAuth()

  const handleSubmit = async e => {
    e.preventDefault()
    await login({ email, password })
  }

  return <form onSubmit={handleSubmit}>{/* form fields */}</form>
}

// Using Custom Hooks for reusable logic
import { useApi, useLocalStorage } from '../hooks'

const EventsPage = () => {
  const { data: events, loading, error } = useApi('/api/events')
  const [favorites, setFavorites] = useLocalStorage('favorites', [])

  return <div>{/* render events */}</div>
}
```

## API Integration

### Service Layer
- Centralized API calls in `services/`
- Consistent error handling
- JWT token authentication

```js
// src/services/eventService.js
export const getEvents = async () => {
  const response = await fetch('/api/events')
  return response.json()
}

export const createEvent = async eventData => {
  const response = await fetch('/api/events', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(eventData),
  })
  return response.json()
}
```

### Error Handling
- Backend returns errors in format: `{ errors: { field: ["message"] } }`
- Display field-specific validation errors

## Styling

### Tailwind CSS
- Use utility classes for styling
- Component composition approach
- Mobile-first responsive design

```jsx
// Utility classes example
<div className='flex items-center justify-between p-4 bg-blue-500 text-white rounded-lg'>
  <h1 className='text-2xl font-bold'>Title</h1>
  <button className='px-4 py-2 bg-white text-blue-500 rounded hover:bg-gray-100'>
    Click me
  </button>
</div>
```

### Custom Styles
- Keep custom CSS minimal in `src/styles/`
- Prefer Tailwind utility classes over custom CSS

## Code Quality

### ESLint Configuration
- React best practices
- Prettier integration
- Auto-fix on save

### Prettier Configuration
- Single quotes
- No semicolons
- 2-space indentation
- Trailing commas where valid

## File Organization

### Barrel Exports
Use `index.js` files for clean imports:

```jsx
// ✅ Good - barrel exports
import { EventCard, EventForm, Button } from '../components'
import { AuthProvider, useAuth } from '../context'

// ❌ Avoid - individual imports
import EventCard from '../components/EventCard'
import EventForm from '../components/EventForm'
```

### Best Practices
- Keep components small and focused
- Extract reusable logic into custom hooks
- Use descriptive prop names
- Add JSDoc comments for complex props

```jsx
/**
 * Button component with multiple variants
 * @param {string} variant - Button style variant (primary, secondary, danger)
 * @param {string} size - Button size (sm, md, lg)
 * @param {boolean} disabled - Whether button is disabled
 * @param {ReactNode} children - Button content
 */
const Button = ({ variant = 'primary', size = 'md', disabled, children }) => {
  // component implementation
}
```
