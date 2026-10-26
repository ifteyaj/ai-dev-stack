# Workflow: OpenCode adapter

OpenCode is a supported second entry point for projects that already use this
harness. It must reuse the same methodology without creating a second source of
truth.

## Shared source of truth

- `config/global-rules.md` is installed as both `~/.claude/CLAUDE.md` and
  `~/.config/opencode/AGENTS.md`.
- Project facts live in `CLAUDE.md`, `AGENTS.md`, and `docs/` in the project
  repository.
- See `workflows/tool-adapters.md` for what transfers and what does not.

## Project adapter

Create the project adapter from `templates/project-opencode-agents.md`:

```bash
cp <harness>/templates/project-opencode-agents.md AGENTS.md
```

Keep it short and project-specific. It must not duplicate global rules,
workflows, or templates.

## Setup steps for a maintainer

1. Install or verify OpenCode (`opencode --version`).
2. Run `./scripts/install.sh --with-opencode`.
3. Run `./scripts/doctor.sh <project-dir>`.
4. Confirm `~/.config/opencode/AGENTS.md` resolves to
   `config/global-rules.md`.

## Known differences

- Claude Code plugins such as EGM, Matt Pocock, and Taste Skill are not
  OpenCode plugins. Use OpenCode subagents, command files, or the CLI for
  equivalent workflows.
- Graphify has verified installs on both sides.
- EGM model-backed commands remain unverified until the Claude Code endpoint
  issue is resolved; reviews may run through fresh-context subagents.

## Verification

- Open the same small pilot task in Claude Code and OpenCode.
- Compare specification quality, review findings, regressions, test results,
  manual interventions, and time spent.
- Record tool-specific gaps in `projects/README.md` or the project's
  `CURRENT-STATUS.md`, not as silent workarounds in another file.
