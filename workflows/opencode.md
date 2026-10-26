# Workflow: using the harness with OpenCode

OpenCode (https://opencode.ai) is a supported coding environment for this
harness. The harness is not Claude-Code-only: global rules, project docs, and
specs are editor-agnostic. Only the skill installation path differs.

## What transfers unchanged

- Project truth (`docs/`, `CLAUDE.md` or `AGENTS.md`, specs, ADRs).
- The specification workflow and templates.
- The review protocol in `workflows/independent-review.md`.
- `scripts/doctor.sh` and the project register.
- Quality gates (`ruff`, `mypy`, `pytest`, etc., per project).

## What differs

- **Global instructions:** OpenCode reads `AGENTS.md` at the project root and
  `~/.config/opencode/AGENTS.md` for global rules. Symlink or copy
  `config/global-rules.md` there, or keep the Claude Code symlink and also
  symlink that file. Do not maintain two divergent rule sets.
- **Skills:** OpenCode does not load Claude Code plugins. Each approved skill is
  either:
  - re-implemented as a prompt/command under `.opencode/command/`, or
  - invoked through its own CLI (Graphify has one), or
  - run as an independent review subagent, as was done in the pilot.
- **EGM:** the global-rules agreement references EGM command names. Under
  OpenCode the same stages are run as structured LLM tasks using the workflows
  in this directory.
- **Independent review:** OpenCode's subagent capability replaces the separate
  Claude Code sessions used in the pilot. Record the agent calls and the model
  used.

## Recommended mapping

| Claude Code concept | OpenCode equivalent |
| --- | --- |
| `~/.claude/CLAUDE.md` | `~/.config/opencode/AGENTS.md` (or a symlink) |
| project `CLAUDE.md` | `AGENTS.md` at project root (keep `CLAUDE.md` if both tools are used) |
| EGM slash commands | typed workflow stages under `docs/designs/` and `.opencode/command/` |
| Claude plugin skills | CLI tools, prompt commands, or subagents |
| `scripts/doctor.sh` | unchanged |

## Constraints

- Do not translate decision-making between tools. One rule set, two entry points.
- If a skill only exists as a Claude Code plugin and has no CLI, treat it as a
  capability gap and record it rather than assuming it works.
- The OpenCode model endpoint may differ from Claude Code's. Verify model access
  before relying on subagent review. (See the 2026-10-26 billing block in
  master document §21.5.)