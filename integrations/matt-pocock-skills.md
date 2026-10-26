# Matt Pocock Skills

**Role:** Engineering execution support: TDD, two-axis code review, hard-bug
diagnosis, deep-module codebase design, and domain modelling.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/mattpocock/skills |
| Publisher | Matt Pocock |
| Licence | MIT |
| Distribution | Official Claude plugin marketplace |
| Plugin version tested | `1.3.1` |
| Source commit | `49dd158d1076134a641b33efb035946536778336` |
| Installed | 2026-10-26 |

## Installation (verified)

```bash
claude plugin install mattpocock-skills@claude-plugins-official -y
```

Verify:

```bash
claude plugin list
claude plugin details mattpocock-skills
```

Result: 27 skills, 0 hooks, 0 MCP servers, ~1,169 always-on tokens; enabled.

## Selected skills and boundaries

| Skill | Use | Boundary |
| --- | --- | --- |
| `tdd` | Red-green-refactor for behavioural changes | Does not replace the spec |
| `code-review` | Parallel Standards + Spec review of a diff | Give it the approved spec |
| `diagnosing-bugs` | Hard bugs and performance regressions | Reproduce before editing |
| `codebase-design` | Deep modules, seams, testability | Do not refactor outside scope |
| `domain-modeling` | Glossary and ADRs when the domain model changes | Record durable decisions |

Installed but **not** part of the primary flow:

- `to-spec`, `grill-with-docs`, `implement-spec` — overlapping specification or
  issue-tracker flows. EGM owns specification. These are manual-only; do not
  invoke them for an EGM feature.
- `setup-matt-pocock-skills` — not run; it configures an issue-tracker workflow
  that this harness does not use.
- `pr`, `triage`, `wayfinder`, `teach`, `wizard`, `prototype`, etc. — available
  on demand, not part of the default loop.

## Verification evidence

- `claude plugin details mattpocock-skills` reports the full 27-skill inventory.
- Model-backed invocation was not executed because the Claude endpoint returned
  HTTP 402 (billing). The skill files were inspected; `tdd` and `code-review`
  have the expected contracts.
- Re-test after billing is restored:

```bash
cd <project>
claude -p "Use the tdd skill to add a failing test for <behaviour>." \
  --allowedTools "Read,Grep,Glob,Edit,Write,Bash" \
  --permission-mode acceptEdits
```

## Update and rollback

```bash
claude plugin update mattpocock-skills@claude-plugins-official
```

Rollback: `claude plugin uninstall mattpocock-skills`.
