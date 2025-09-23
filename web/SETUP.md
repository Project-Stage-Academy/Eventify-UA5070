# React Frontend Setup Guide

## Quick Start

1. **Install dependencies**:

   ```bash
   npm install
   ```

2. **Start development server**:

   ```bash
   npm run dev
   ```

3. **Open your browser**:
   Navigate to `http://localhost:5173`

## Available Scripts

| Command                | Description                              |
| ---------------------- | ---------------------------------------- |
| `npm run dev`          | Start development server with hot reload |
| `npm run build`        | Build for production                     |
| `npm run preview`      | Preview production build locally         |
| `npm run lint`         | Check code with ESLint                   |
| `npm run lint:fix`     | Auto-fix ESLint issues                   |
| `npm run format`       | Format code with Prettier                |
| `npm run format:check` | Check code formatting                    |

## Project Structure

```
src/
├── components/         # Reusable UI components
│   ├── Button.jsx     # Example button component
│   └── index.js       # Export all components
├── pages/             # Page components for routing
│   └── index.js       # Export all pages
├── services/          # API calls and external services
│   └── index.js       # Export all services
├── context/           # React Context for global state
│   ├── AuthContext.jsx # Authentication context
│   └── index.js       # Export all context
├── styles/            # CSS and styling files
│   └── App.css        # Component-specific styles
├── assets/            # Static assets (images, icons)
└── main.jsx           # Application entry point

__tests__/             # Test files
.vscode/               # VS Code settings
```

## Development Workflow

### 1. Code Quality

- **ESLint** automatically checks your code for errors and best practices
- **Prettier** formats your code consistently
- Both run automatically on save in VS Code

### 2. Adding New Components

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

### 3. Using Tailwind CSS

Tailwind classes are available throughout the project:

```jsx
// Utility classes for styling
<div className='flex items-center justify-between p-4 bg-blue-500 text-white rounded-lg'>
  <h1 className='text-2xl font-bold'>Title</h1>
  <button className='px-4 py-2 bg-white text-blue-500 rounded hover:bg-gray-100'>
    Click me
  </button>
</div>
```

### 4. State Management with Context

```jsx
// Using the AuthContext
import { useAuth } from '../context'

const LoginPage = () => {
  const { login, loading, error } = useAuth()

  const handleSubmit = async e => {
    e.preventDefault()
    await login({ email, password })
  }

  return <form onSubmit={handleSubmit}>{/* form fields */}</form>
}
```

### 5. API Services

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

## Best Practices

### Components

- Use functional components with hooks
- Keep components small and focused
- Extract reusable logic into custom hooks
- Use TypeScript-style JSDoc comments for props

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

### Styling

- Prefer Tailwind utility classes
- Use component composition over complex CSS
- Keep custom CSS minimal in `src/styles/`

### State Management

- Use React Context for global state
- Keep local state with useState when possible
- Use useReducer for complex state logic

## Troubleshooting

### Common Issues

1. **Port already in use**:

   ```bash
   # Kill process using port 5173
   npx kill-port 5173
   ```

2. **ESLint errors**:

   ```bash
   npm run lint:fix
   ```

3. **Prettier formatting**:

   ```bash
   npm run format
   ```

4. **Build issues**:
   ```bash
   # Clear node_modules and reinstall
   rm -rf node_modules package-lock.json
   npm install
   ```

## Production Build

```bash
# Build for production
npm run build

# Preview production build
npm run preview
```

The build files will be in the `dist/` directory, ready for deployment.
