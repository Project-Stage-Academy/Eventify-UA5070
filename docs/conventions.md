# Conventions

This document defines naming, coding, and workflow conventions for Eventify.

## Back-end

- Controllers are versioned under `app/controllers/api/v1/`.
- Unified error format: `{ errors: { field: ["message"] } }`.
- Use strong parameters in controllers.

## Front-end

- Use functional components and React hooks.
- Enforce code style with ESLint and Prettier.

## Shared

- Branch naming:
  ```
  issue-<number>/<short-description>
  ```
  Examples:
  - `issue-12/add-event-crud`
  - `issue-45/fix-login-validation`
  - `issue-77/update-readme`

- Commit messages follow Conventional Commits (`feat:`, `fix:`, `test:`, `docs:`).
- CI/CD stages: lint → test → build.
- Documentation: Technical docs under `docs/` (ERD, API spec).
- Empty directories: 
  - Use `.gitkeep` to keep required empty directories in Git.
  - Remove the `.gitkeep` once real files are added to that directory.

---

**For more details, see the [README.md](../README.md).**