# Workflow: harness acceptance tests

Use these criteria to decide whether the harness is minimum-ready before running
a real pilot. They are deliberately outcome-based, not tool-count-based.

Each criterion records **how it is exercised**, **the evidence location**, and
**the date it was verified**. A criterion that is not yet exercised stays open;
do not label it done because the supporting tool is installed.

## Criteria

1. Portable project setup
   - Evidence: `python -m pytest` equivalent commands live in each project,
     not in the harness. Global rules and skills load through the supported
     mechanism (`~/.claude/CLAUDE.md` symlink or the configured alternate).
   - Verify: `scripts/doctor.sh <project-dir>` reports no failures.
   - Verified: 2026-10-26 (27 ok, 0 failures on `agentic-cicd`).

2. Specification workflow
   - Evidence: a spec exists with requirements, acceptance criteria,
     assumptions, edge cases, and a change log of revisions.
   - Verify: the project has at least one spec under `docs/designs/`.
   - Verified: 2026-10-26 (`m1-webhook-intake.md`, revision 4, approved).

3. Independent review
   - Evidence: at least one substantial spec has two or more fresh-context
     review passes, each with a findings table and resolutions.
   - Verify: reports live under `docs/designs/reviews/`; findings are numbered
     and resolved.
   - Verified: 2026-10-26 (round 1: 4 reviewers; round 2: 2; readiness:
     1 reviewer; 35 findings, all resolved).
   - Caveat: EGM's model-backed commands were blocked by a billing error; the
     reviews ran via fresh-context OpenCode subagents. Mark this criterion
     partially verified until EGM runs.

4. Codebase understanding
   - Evidence: a tool that inspects structure and relationships runs without
     network access.
   - Verify: Graphify extraction and query succeed on a pilot repository.
   - Verified: 2026-10-26 (53 → 196 nodes after M1 implementation).

5. Implementation and verification
   - Evidence: tests, lint, format, and type checks run through the project's
     documented commands and produce passing results reported in the project
     status.
   - Verified: 2026-10-26 (`agentic-cicd`: 161 passed, 4 xfailed; ruff,
     format, mypy pass).

6. Persistent project context
   - Evidence: `PRODUCT.md`, `REQUIREMENTS.md`, `ARCHITECTURE.md`,
     `DECISIONS.md`, `ROADMAP.md`, `CURRENT-STATUS.md`, and `CLAUDE.md` /
     `AGENTS.md`.
   - Verified: 2026-10-26 (all present in the pilot).

7. Failure handling
   - Evidence: failures (billing, build, test, review) are reported verbatim
     and land in `CURRENT-STATUS.md`, not silently bypassed.
   - Verified: 2026-10-26 (HTTP 402 recorded; Docker build and clean-machine
     install recorded as not verified).

8. Reproducible pilot evidence
   - Evidence: the harness records its configuration, tool usage, results, and
     known limitations in a version-controlled document.
   - Verified: 2026-10-26 (master document §21, pilot `CURRENT-STATUS.md`).

## When all eight are green

Run a second, clearly-scoped task through the harness against the same pilot
and compare specification quality, review findings, regressions, test results,
manual interventions, and time spent. That comparison is the real outcome
measure; the checklist above is only the floor.