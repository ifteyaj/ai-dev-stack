# Elephant-Goldfish Model (EGM)

**Role:** Primary spec-driven workflow. Owns brainstorming, specification
drafting, independent (Goldfish) review, finding resolution, and drift reports.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/google/elephant-goldfish-model |
| Publisher | Google LLC |
| Licence | Apache-2.0 |
| Documentation | https://egm.dev/ |
| Plugin version tested | `0.1.0` |
| Marketplace commit | `3d0b348` (2026-10-23) |
| Claude Code required | 2.1.271+ for `omitClaudeMd` isolation (we run 2.1.309) |
| Installed | 2026-10-26 |

## Installation (verified)

```bash
claude plugin marketplace add google/elephant-goldfish-model
claude plugin install egm@egm
claude plugin enable egm@egm
```

`install` left the plugin disabled; `enable` was required. Verify:

```bash
claude plugin list
claude plugin details egm
claude plugin validate ~/.claude/plugins/cache/egm/egm/0.1.0
```

## Verification evidence

- `claude plugin list`: `egm@egm`, version `0.1.0`, status enabled.
- `claude plugin details egm`: 7 skills, 1 `PreToolUse` hook, 0 MCP servers;
  ~464 always-on tokens.
- `claude plugin validate`: passed with two non-blocking warnings (marketplace
  description missing, plugin icon missing).
- The manifest declares 9 agent adapters under `.claude-plugin/agents/`
  (`egm-design`, `egm-comprehension`, `egm-structural`, `egm-style`,
  `egm-readiness`, `egm-zoom-out`, `egm-synthesizer`, and bootstrap adapters).
  `claude plugin details` reported “Agents (0)”; the adapter files and manifest
  entries are present. Confirm reviewer registration in a live session before
  relying on automatic dispatch.

## Runtime blocker observed

A headless smoke test on 2026-10-26 could not execute an EGM command:

```text
claude -p "..." -> API 402: Billing verification failed.
```

The configured Anthropic-compatible endpoint (`codecraftapi.com`) returned HTTP
402 for `/v1/messages`. This is an account/billing issue, not an EGM install
failure. The plugin loads and validates, but model-backed EGM commands cannot
run until the endpoint has credit. Re-test with:

```bash
cd <project>
claude -p "/egm:egm-review docs/designs/<feature>.md" \
  --allowedTools "Read,Grep,Glob,Write,Agent" \
  --permission-mode acceptEdits
```

The pilot review was therefore performed with OpenCode fresh-context subagents
using the same separation principle. Record that substitution in the pilot's
review report; do not claim the EGM runtime itself was exercised.

## Usage policy

- EGM owns substantial feature specification and independent spec review.
- Do not run Matt Pocock `to-spec`, `grill-with-docs`, or `implement-spec` for
  the same task; they are alternative spec flows and are manual-only.
- Specs live in `docs/designs/<feature>.md`.
- A review result is evidence, not approval. The human approves.
- Run `/egm:egm-drift-report` after structural changes or on a weekly cadence.

## Update and rollback

```bash
claude plugin update egm@egm
```

Rollback: `claude plugin uninstall egm@egm`, or restore the previous plugin
cache version from `~/.claude/backups/harness/`.

## Official commands

Claude Code namespaces plugin skills:

```text
/egm:egm-brainstorm
/egm:egm-draft
/egm:egm-review
/egm:egm-resolve
/egm:egm-drift-report
/egm:egm-bootstrap
```

Confirm names with the installed version; upstream docs are authoritative.
