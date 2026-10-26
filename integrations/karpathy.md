# Karpathy Skills — principles adopted, package not installed

**Decision:** Adopt the principles; do not install the repository.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/multica-ai/andrej-karpathy-skills |
| Publisher | multica-ai |
| Licence | No licence file found (SPDX: none) |
| Snapshot | 224.2k stars, last push 2026-04-20 |
| Install route | copy a single `CLAUDE.md` into the project |
| Verified on | 2026-10-26 |

## Why not installed

- The repository is a single `CLAUDE.md` file, not a skill package. There is
  nothing to enable or version; merging it would duplicate instructions.
- No licence file was found, so it cannot be vendored or redistributed safely.
- The last push was 2026-04-20, so it is not being actively maintained.

## What was adopted instead

The four guiding principles are folded into the harness rules directly:

1. Think before coding — stated assumptions, clarification before action,
   explicit trade-offs.
2. Simplicity first — minimum code that solves the problem; no speculative
   abstractions.
3. Surgical changes — touch only what the task requires; clean only your own
   mess.
4. Goal-driven execution — define success criteria and verify against them
   rather than "make it work".

Source of truth for these: `config/global-rules.md` and `config/coding-standards.md`.
They must not be re-imported from the upstream repository.

## Revisit

Only if the upstream publishes a real licence and exposes the principles as
reusable skill files rather than one static `CLAUDE.md`.