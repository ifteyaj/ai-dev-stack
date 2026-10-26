# Ponytail — deferred alternative

**Decision:** Deferred. Not installed. Overlaps the simplicity and code-review
guidance already in the harness.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/DietrichGebert/ponytail |
| Publisher | DietrichGebert |
| Licence | MIT |
| Snapshot | 176.6k stars, active 2026-10-18 |
| Install route | `claude plugin marketplace add DietrichGebert/ponytail` |
| Verified on | 2026-10-26 |

## Why deferred

- Ponytail is an always-on ruleset with lifecycle hooks and review/audit
  commands. It overlaps Matt Pocock's `code-review` skill and the Karpathy-derived
  simplicity guidance already folded into the global rules.
- Adding a second always-on ruleset would produce duplicate, conflicting
  review output and complicate prompt ownership.
- It has not demonstrated value beyond what the current stack provides.

## If adopted later

1. Install from the marketplace URL above and inspect every lifecycle hook.
2. Run it on a disposable copy of the pilot and compare its findings against
   the existing review workflow.
3. Disable any overlapping rule group that duplicates Matt Pocock or Karpathy
   guidance.
4. Update this register, `config/coding-standards.md`, and §21.2.

Revisit only if the current stack proves too verbose or its review coverage
has a demonstrated gap.

Rollback: `claude plugin uninstall ponytail`.