# UI UX Pro Max — deferred alternative

**Decision:** Deferred. Not installed. Taste Skill is the primary design skill.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill |
| Publisher | NextLevelBuilder |
| Licence | MIT |
| Latest release observed | `v2.15.0` |
| Install routes | Claude plugin marketplace, or `ui-ux-pro-max-cli` |
| Verified on | 2026-10-26 |

## Why deferred

- It is a full design-intelligence system with a large style/colour/typography
  catalogue. Enabling it alongside Taste Skill would give two competing design
  authorities on one task.
- Taste Skill was chosen for stronger art direction and real-browser
  self-checking, which matches this harness's verification requirement.
- UI UX Pro Max remains a credible fallback for teams that prefer a
  searchable design-system catalogue over art direction.

## If adopted later

```bash
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill
```

Then disable Taste Skill before using it. Do not run both by default. Update
`config/design-standards.md` and this register if the primary changes.

Rollback: `claude plugin uninstall ui-ux-pro-max`.
