# Frontend Setup Guide

## Quick Start

1. **Install dependencies**:
   ```bash
   cd web
   npm install
   ```

2. **Start development server**:
   ```bash
   npm run dev
   ```

3. **Open your browser**: Navigate to `http://localhost:5173`

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

## Development Workflow

### Code Quality
- **ESLint** automatically checks your code for errors and best practices
- **Prettier** formats your code consistently
- Both run automatically on save in VS Code

### Before Committing
```bash
npm run lint:fix
npm run format
```

### VS Code Integration
Install these recommended extensions:
- **ESLint** - Code linting
- **Prettier - Code formatter** - Auto-formatting
- **Tailwind CSS IntelliSense** - CSS class autocomplete

## Testing

```bash
# Run tests
npm test

# Run tests in watch mode
npm run test:watch

# Generate coverage report
npm run test:coverage
```

## Production Build

```bash
# Build for production
npm run build

# Preview production build
npm run preview
```

The build files will be in the `dist/` directory, ready for deployment.

## Troubleshooting

### Common Issues

1. **Port already in use**:
   ```bash
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


**For more details, see the [README.md](readme-docs.md).**