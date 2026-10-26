# Changelog

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
