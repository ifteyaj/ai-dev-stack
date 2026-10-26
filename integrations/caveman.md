# Caveman — rejected for now

**Decision:** Rejected for now. Not installed. Conflicts with the verification
and reporting style this harness requires.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/Shawnchee/caveman-skill |
| Publisher | Shawnchee |
| Licence | MIT |
| Snapshot | 78 stars, active 2026-10-24 |
| Install route | skill install from `Shawnchee/caveman-skill` |
| Verified on | 2026-10-26 |

## Why rejected

- Caveman optimises for extremely terse output. This harness requires
  evidence-bearing reports: commands run, statuses, residual risks, and review
  findings with resolutions.
- Terse-by-default output would undermine independent review and make the
  verification ladder un-auditable.
- The low star count and narrow scope do not justify the maintenance cost of
  adding it conditionally.

## If adopted later

It may be useful for interactive exploratory work where brevity is preferred.
Enable it only manually, never as a default, and only outside the review and
implementation workflow. Update this register before enabling.

No supported install path is recorded because it is not recommended.