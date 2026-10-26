# Changelog

## Changelog
## [0.5.1] — 2026-10-26

### Changed
- Hardened `guard-bash.sh` against force-push, hook-skip, and recursive
  delete bypasses, with multiline/extra-space tests.
- `secret-scan.sh` now prints only line numbers, not values, and scans more
  secret patterns.
- Both hooks fail closed when `jq` is missing.
- `make check` and CI lint config/hooks/tests with `shellcheck -S warning`.

## [0.5.0] — 2026-10-26

### Added
- Tiered, multi-project `doctor.sh` (`--all`, `--project`) with tier 1 warning/
  failure exit codes and lockfile drift checks.
- `config/adapters.json` and a generic `--with-adapter <name>` install path.
- `scripts/status.sh` (`make status`) for installed versions and project
  freshness.
- `config/hooks/session-start.sh` for project orientation at session start.
- `scripts/check-changelog.sh` (`make changelog-check`) for config/workflow
  discipline.
- `Dockerfile` and `.dockerignore` for a clean-machine smoke test.
- Additional acceptance tests for install idempotence and uninstall restore.

### Changed
- `doctor.sh` checks adapter drift, CURRENT-STATUS freshness, and uses lock
  comparison by default.
- `scripts/sync-check.sh` now reports both adapter files and their versions.

## [0.4.0] — 2026-10-26

### Added
- MIT `LICENSE`.
- `.github/workflows/check.yml` CI with shellcheck, check-harness, acceptance
  tests, link checking, and a clean-machine install dry run.
- `config/settings.baseline.json` permission and hook baseline.
- `config/hooks/guard-bash.sh` and `config/hooks/secret-scan.sh` enforcement hooks.
- `Makefile` for one-command workflows.
- `scripts/uninstall.sh`, `scripts/restore.sh`, and `scripts/sync-check.sh`.
- `integrations/lock.json` machine-readable tool versions.
- `tests/test_hooks.sh` and `tests/test_new_project.sh`.

### Changed
- `scripts/install.sh` supports `--with-settings`.
- `scripts/check-harness.sh` checks portability, stray artifacts, and no longer
  duplicates those checks.
- `scripts/doctor.sh` checks `jq` availability.
- Removed a stray heredoc `EOF` from `AGENTS.md`.
- Replaced a machine-specific path in the master document with `~/Desktop/...`.

### Fixed
- Uninstall now restores from the newest backup directory.

## [0.3.0] — 2026-10-26

### Added
- `scripts/check-harness.sh` for structural self-tests (required files, script
  syntax, workflow shape, template parity, schema marker, repository hygiene).
- `scripts/new-project.sh` to scaffold a project repository from templates.
- `./scripts/install.sh --with-opencode` to install the OpenCode adapter
  automatically.
- Portable standards directory linked as `~/.claude/config`.
- Parity marker convention for project adapter templates.
- Harness schema version (1) recorded in `projects/README.md`.

### Changed
- `scripts/doctor.sh` now uses `claude plugin list --json`, checks OpenCode,
  portable standards, and reports plugin versions.
- `workflows/opencode.md` converted from pilot-specific adapter text to a
  generic harness workflow.
- Global rules document the installed standards location.

### Fixed
- Pilot-project contamination in `workflows/opencode.md`.

## [0.2.0] — 2026-10-26

### Changed
- Global rules are now auto-loaded by both Claude Code and OpenCode. The OpenCode
  adapter is a symlink from `~/.config/opencode/AGENTS.md` to the single source
  of truth at `config/global-rules.md`.
- `AGENTS.md` now exists in both the harness and pilot repositories (project-level
  adapters) and uses the copied template with project-specific text.
- Global rules gained a "Mandatory workflows (do not skip)" section and OpenCode
  config/tools are documented in `workflows/tool-adapters.md`.
- Re-verification of `doctor.sh` remains 27 ok / 0 warnings; no tool versions
  changed.

### Fixed
- Single-source of truth for instructions: previously the global rules
  (Claude Code only) were not explicitly located for OpenCode.
- OpenCode `instructions` gap. The OpenCode `opencode.jsonc` itself does not need
  an `instructions` key because OpenCode reads `AGENTS.md` by convention.

All notable changes to the harness are recorded here. Dates use ISO 8601.

## [0.1.0] — 2026-10-26

### Added

- Initial harness structure: configuration, workflows, templates, integrations,
  scripts, and a project register.
- Global working agreement at `config/global-rules.md`, installed as
  `~/.claude/CLAUDE.md`.
- Integration register with verified upstream URLs, licences, install methods,
  and adoption decisions for the ten candidate repositories.
- Elephant-Goldfish Model installed as the primary spec workflow.
- Graphify installed as the per-project codebase intelligence tool.
- Matt Pocock engineering skills installed as the implementation support layer.
- Taste Skill installed as the primary UI design skill.
- Installer, doctor, and update scripts.
- Pilot project recorded in `projects/README.md`.

### Verified

- Global rules installed as a symlink and loaded by Claude Code.
- EGM, Matt Pocock Skills, and Taste Skill enabled; plugin metadata validates.
- Graphify `0.9.92` produced a working code graph for the pilot.
- `scripts/install.sh` is idempotent, and `scripts/doctor.sh` reports 26 ok and
  1 stale-graph warning.
- Pilot M1 webhook intake implemented through spec, three review passes, tests,
  and live smoke verification: 161 passed, 4 xfailed; ruff, format, and mypy
  strict pass.

### Known limitations

- The Claude Code model endpoint returned HTTP 402 (billing), so EGM runtime
  commands could not be exercised. Independent reviews used fresh-context
  subagents.
- The Docker image and a clean-machine install were not verified.
- See master document §21 for the full implementation log and residual risks.
