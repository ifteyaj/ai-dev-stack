# Workflow: adapters for multiple coding tools

Use the same harness from both Claude Code and OpenCode without maintaining
two methodologies. Keep one shared source of truth and two thin adapters.

## Shared source of truth

- `config/global-rules.md` — single source; symlinked into both
  `~/.claude/CLAUDE.md` and `~/.config/opencode/AGENTS.md`.
- `config/`, `workflows/`, `templates/`, `integrations/` — portable content,
  copied by adapters only when a tool requires its own format.
- Project `docs/` and specs — always live in the project repository and are
  tool-agnostic.

## Adapters

- Claude Code: `~/.claude/CLAUDE.md` → global rules; plugins enabled via
  `~/.claude/settings.json`.
- OpenCode: `~/.config/opencode/AGENTS.md` → same global rules;
  skills from `~/.config/opencode/skills/`.
- Per project: `CLAUDE.md` for Claude Code, `AGENTS.md` (from
  `templates/project-opencode-agents.md`) for OpenCode. Keep them compatible;
  one is a translation of the other, not a different policy.

## What does not transfer

"Shared skill file" does not mean "same executable capability". A workflow that
depends on Claude-specific plugins, hooks, subagents, or slash commands:

- may need an OpenCode-compatible implementation (subagent, command file, or CLI),
- must be checked for availability when the tool is chosen,
- and must be recorded as unavailable rather than silently assumed.

Examples in this harness:

- Graphify: both Claude and OpenCode skill installs exist and are verified on
  both sides, plus the CLI.
- EGM: Claude Code plugin only; the actual runtime commands are unverified due
  to a billing failure; reviews ran as fresh-context OpenCode subagents.
- Matt Pocock and Taste skills: Claude Code only.
- The independent-review workflow and verification ladder: portable logic,
  invoked explicitly however the session runs.

## Test protocol

After changing shared content or a plugin, open the same small pilot task in
both tools and compare:
specification quality, review findings, regressions, test results, manual
interventions required, and time spent. Gaps become harness defects, not manual
workarounds recorded in yet another file.