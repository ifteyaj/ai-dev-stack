# OpenCode project instructions template
<!-- harness-parity: project-adapter v1 -->

Copy this to `AGENTS.md` at the root of an OpenCode-managed project. Keep it
short: the durable specifics live in `CLAUDE.md` and `docs/`. Use this only when
OpenCode is a supported entry point for the project.

Part of the `ai-dev-stack` harness. See `workflows/opencode.md` for setup.

---

# <project name> — agent instructions (OpenCode)

## What this project is

One paragraph. Technology, purpose, current milestone. Keep in sync with the
first lines of `CLAUDE.md`.

## Stack and commands

```bash
# e.g.
uv sync
uv run pytest -q
uv run ruff check .
uv run ruff format --check .
uv run mypy
```

## How to use the harness here

- Read `CLAUDE.md`, `docs/ARCHITECTURE.md`, and the relevant spec under
  `docs/designs/` before changing code.
- Substantial features use Elephant-Goldfish-style specs: requirements,
  acceptance criteria, assumptions, edge cases, failure states.
- Independent review runs in fresh context. Use an OpenCode subagent or a
  separate session. Record findings in the spec with IDs and resolutions.
- Keep `docs/CURRENT-STATUS.md` current at the end of a session.
- Report what was run, what passed, and what was not run.

## Do not

- Put global rules here; they live in the harness and must match `CLAUDE.md`.
- Disable lint or type checks to make a test pass.
- Claim a workflow ran if the model endpoint or tool could not be exercised.

## Additional context

- Specs: `docs/designs/`
- Decisions: `docs/DECISIONS.md`
- Roadmap: `docs/ROADMAP.md`