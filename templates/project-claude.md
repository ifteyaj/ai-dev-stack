# <Project name> — agent instructions

## What this project is

<One short paragraph: problem, users, and the core behaviour.>

## Stack and commands

- Language / runtime: <version>
- Framework: <framework>
- Package manager: <command>

```bash
# install
<command>

# dev
<command>

# test
<command>

# lint
<command>

# format check
<command>

# type check
<command>

# build
<command>
```

## Repository layout

```text
<path>/        <purpose>
<path>/        <purpose>
```

## Architectural boundaries

- <What belongs in which module/package.>
- <What must not cross a boundary.>
- <Where the source of truth for data lives.>

## Conventions

- <Naming, error handling, state management, styling.>
- <Testing style and where tests live.>
- <How to add a dependency, if there is a rule.>

## Documentation

- Product: `docs/PRODUCT.md`
- Requirements: `docs/REQUIREMENTS.md`
- Architecture: `docs/ARCHITECTURE.md`
- Decisions: `docs/DECISIONS.md`
- Current status: `docs/CURRENT-STATUS.md`
- Feature specs: `docs/designs/`

## Security and deployment

- <Secret handling, auth boundaries, data rules.>
- <Deployment target and approval requirements.>

## Notes for the agent

- Read this file and the relevant docs before changing code.
- Use the project's commands; do not invent a parallel toolchain.
- Keep changes within the approved spec. If the plan must change, update the
  spec first.
