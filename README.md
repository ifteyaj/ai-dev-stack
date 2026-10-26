# ai-dev-stack

A reusable, version-controlled AI coding harness for macOS with Claude Code and
OpenCode. It takes a project from an initial idea through an independently
reviewed specification, a tested implementation, and maintainable documentation.

The harness is deliberately small. It gives each tool one job and keeps
product-specific truth inside the product repository. One shared rule set drives
both tools; thin adapters live under `~/.claude/` and `~/.config/opencode/`.

## What is installed

| Layer | Tool | Role |
| --- | --- | --- |
| Global instructions | `config/global-rules.md` → `~/.claude/CLAUDE.md` (Claude Code) and `~/.config/opencode/AGENTS.md` (OpenCode) — one source, thin adapters | Working style, routing, safety, closeout, mandatory workflows |
| Spec workflow | [Elephant-Goldfish Model](https://github.com/google/elephant-goldfish-model) | Brainstorm, draft, independent review, resolve, drift |
| Code intelligence | [Graphify](https://github.com/Graphify-Labs/graphify) | Per-project codebase relationship map |
| Engineering skills | [Matt Pocock Skills](https://github.com/mattpocock/skills) | Grilling, TDD, code review, diagnosis, codebase design |
| Design skill | [Taste Skill](https://github.com/Leonxlnx/taste-skill) | Art direction and browser-checked UI |
| Project memory | Markdown templates in `templates/` | Product, requirements, architecture, decisions, status, specs |

Deferred and rejected candidates are recorded with reasons in
`integrations/upstream-repositories.md`.

## Quick start

```bash
# 1. Inspect what would change (no writes)
./scripts/install.sh --dry-run

# 2. Install global instructions (backs up anything it replaces)
./scripts/install.sh

# 2b. Configure OpenCode as well (once per machine)
#     ./scripts/install.sh --with-opencode
#     See workflows/tool-adapters.md

# 3. Install third-party tools using their documented mechanisms
#    (see integrations/ for the exact commands and tested versions)

# 4. Check the environment
./scripts/doctor.sh
./scripts/check-harness.sh

# 5. Start a project
cat workflows/new-project.md
```

## Repository layout

```text
config/         Global rules, coding/design standards, safety
workflows/      Human-facing process for each task type
templates/      Copyable project documentation skeletons
integrations/   Verified upstream register and per-tool notes
scripts/        Installer, doctor, updater
skills/         Notes and local custom skills only
projects/       Register of projects using the harness
```

## Design principles

1. **Global defaults, project truth.** Reusable behaviour lives here; product
   requirements, specs, and decisions live in the product repository.
2. **One primary workflow per responsibility.** EGM owns specification and
   independent review. Do not run a second planning methodology on the same
   task.
3. **Independent review is not approval.** Findings are evidence for a human
   decision.
4. **Verification is evidence.** Report what ran, what passed, what failed, and
   what did not run.
5. **Curate, do not accumulate.** Every tool must have a distinct job and a
   documented install and rollback path.
6. **Keep it reversible.** Back up before modifying global configuration; pin
   versions for critical workflows.

## Status

See `CHANGELOG.md`, `projects/README.md`, and the implementation log at the end
of `AI_Coding_Harness_Spec_Driven_Engineering_Master_Document.md`.

OpenCode adapter (verified this session): global rules auto-load under both
Claude Code and OpenCode; project adapters live in each repository as `AGENTS.md`;
see `workflows/tool-adapters.md`.
