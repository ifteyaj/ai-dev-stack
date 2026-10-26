# ai-dev-stack — repository instructions

This repository is the version-controlled source of my global AI coding
harness. It is not a product repository and must not accumulate application
source code.

## Source of truth

- `config/global-rules.md` is symlinked to `~/.claude/CLAUDE.md`.
- `integrations/upstream-repositories.md` records which third-party tools are
  approved, on trial, or rejected, with the exact source and version tested.
- `workflows/` describes the human-facing process.
- `templates/` holds copyable project documentation skeletons.
- `scripts/install.sh` installs only what this repository owns. Third-party
  tools are installed by their documented mechanisms and recorded in the
  integration register.

## Editing rules

- Keep global instructions short. Put project-specific behaviour in a project's
  `CLAUDE.md`, not here.
- Do not add secrets, tokens, credentials, or machine-specific absolute paths.
- When changing a workflow, update the related integration note and `CHANGELOG.md`.
- When verifying a new tool, record the date, exact version or commit, test
  performed, result, and decision.
- Do not copy upstream skill folders into this repository when an upstream
  plugin or installer already exists.
- Preserve upstream files. If a local patch is unavoidable, document it and the
  update procedure.

## Verification for this repository

```bash
./scripts/doctor.sh
./scripts/check-harness.sh
./scripts/install.sh --dry-run
bash -n scripts/*.sh
```

`doctor.sh` reports problems only; it must not silently change the system.

## Project boundaries

The pilot and any product code live outside this repository. `projects/` holds
only a register of projects that use the harness.
