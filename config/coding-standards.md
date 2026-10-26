# Coding standards

These are defaults, not a replacement for a project's own conventions. A
project `CLAUDE.md`, linter configuration, or existing code always wins.

## General

- Solve the stated problem; do not add speculative abstraction, configuration,
  or features.
- Match the surrounding naming, structure, error handling, and dependency
  choices.
- Keep functions and modules small enough to review. Prefer explicit data flow
  over hidden global state.
- Validate at trust boundaries (HTTP input, webhooks, file input, environment).
  Do not add defensive code for impossible internal states.
- Fail loudly in development and predictably in production. Never swallow an
  exception without a deliberate, documented decision.
- Comments explain *why*, not *what*. Do not rewrite comments you did not need
  to touch.
- Remove imports, variables, and functions made unused by your own change.
  Leave pre-existing dead code alone unless asked.

## Python

- Target the version declared by the project (for example `requires-python`).
- Use type hints on public functions and on non-trivial internals. Keep the
  project's strictness level.
- Prefer the standard library and installed dependencies over new packages.
- Use `pathlib` for paths and explicit encodings for text I/O.
- Tests use the project's framework (usually pytest). One behaviour per test;
  name tests after observable behaviour, not implementation details.
- Run the project's formatter and linter; do not reformat unrelated files.

## TypeScript / JavaScript

- Respect the project's `tsconfig` strictness. Avoid `any` and non-null
  assertions unless the surrounding code already relies on them.
- Prefer existing framework conventions (Next.js, React, Vite) over custom
  plumbing.
- Keep server-only and client-only code separated; never expose secrets to the
  client bundle.
- Handle loading, empty, error, and success states for asynchronous UI.
- Use the project's package manager and lockfile; do not mix npm, pnpm, yarn, or
  bun in one repository.

## Tests

- Every behavioural change gets a test that would fail without the change.
- Cover the success path, validation failures, and a realistic failure state.
- For bug fixes, add a regression test that reproduces the original defect.
- Prefer deterministic tests. Control time, randomness, network, and external
  services.
- Do not weaken assertions or delete tests to make a suite pass.

## Dependencies

- Add a dependency only when it removes more risk or code than it introduces.
- Check licence, maintenance activity, install scripts, and transitive weight.
- Record non-obvious dependency decisions in `docs/DECISIONS.md`.

## Commits

- One coherent change per commit. Do not mix refactors with behaviour changes.
- Message format: imperative summary, then context and verification if useful.
- Never commit secrets, generated credentials, local databases, or large
  generated artifacts unless the project explicitly tracks them.
