# Project instructions: ai-dev-stack (harness, OpenCode)

This repository is the harness itself: global rules, workflows, templates,
integrations, and scripts. Application code never lives here; it lives in the
registered project repositories (see `projects/README.md`). Durable behaviour
is documented in `AI_Coding_Harness_Spec_Driven_Engineering_Master_Document.md`.

## Stack and commands

```bash
./scripts/install.sh --dry-run
./scripts/install.sh
./scripts/doctor.sh ~/Desktop/<project-dir>
./scripts/update.sh
```

## How to use the harness

- Read `README.md`, `CLAUDE.md`, and the relevant workflow in `workflows/` before editing.
- `config/global-rules.md` is the single source of truth for global rules; it is
  symlinked into `~/.claude/CLAUDE.md` and `~/.config/opencode/AGENTS.md`.
  Edit it here, nowhere else.
- Substantial harness changes are documented in `DECISIONS.md`/CHANGELOG style
  in `CHANGELOG.md`. Substantial project work goes through the spec workflow
  with independent review (`workflows/independent-review.md`).
- Commit a coherent, reviewable change with a clear message; this repo now has
  Git history (no PR automation).

## Do not

- Duplicate methodology across `CLAUDE.md`, `AGENTS.md`, and `config/`. One
  source, thin adapters (see `workflows/tool-adapters.md`).
- Put product code or project-only instructions here.
- Claim a workflow or tool ran that was not actually executed. Record gaps
  (402, missing binary, unverified deploy) in `CURRENT-STATUS.md` of the
  affected project.
EOF