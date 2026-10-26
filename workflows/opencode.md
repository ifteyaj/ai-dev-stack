# Project instructions: agentic-cicd (OpenCode)

Keep this short: durable product/architecture data lives in `CLAUDE.md` and
`docs/`. This file exists so OpenCode auto-loads the harness global rules and
the pointers below; it does not duplicate their content.

## Stack and commands (run from `api/`)

```bash
uv sync
uv run pytest -q
uv run ruff check .
uv run ruff format --check .
uv run mypy
uv run uvicorn app.main:app --reload   # bind 127.0.0.1
```

## How to use the harness here

- Read `CLAUDE.md`, `docs/ARCHITECTURE.md`, and the active spec under
  `docs/designs/` before changing code.
- Substantial features: Elephant-Goldfish-style spec (requirements, acceptance
  criteria, assumptions, edge cases), independent fresh-context review, then
  implementation with the verification ladder.
- Independent review runs in a fresh subagent/sessions; record findings in the
  spec with IDs and resolutions.
- Keep `docs/CURRENT-STATUS.md` current at the end of a session.
- Report what was run, what passed, and what was not run. Do not disable
  lint/type checks to make tests pass. Do not claim a workflow ran.
- M1 is single-process: one run works as intended, runs do not survive restart,
  do not add worker flags.

## Additional context

- Product, requirements, decisions, roadmap: `docs/PRODUCT.md`,
  `docs/REQUIREMENTS.md`, `docs/DECISIONS.md`, `docs/ROADMAP.md`
- Specs: `docs/designs/`
- Status: `docs/CURRENT-STATUS.md`

## Do not

- Duplicate global rules, workflows, or templates here — they live in the
  harness and are auto-loaded from `~/.config/opencode/AGENTS.md`.
- Merge without tests for changed behaviour.