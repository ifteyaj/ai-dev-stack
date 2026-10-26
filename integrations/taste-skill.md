# Taste Skill

**Role:** Primary UI design skill: art direction, reference images, and a
real-browser self-check.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/Leonxlnx/taste-skill |
| Publisher | Leonxlnx / tasteskill.dev |
| Licence | MIT |
| Plugin version tested | `2.1.5` |
| Marketplace commit | `12af471` (2026-10-25) |
| Skill | `design-taste-frontend` |
| Runtime | Node 22+, Chrome/Edge/Chromium, network for reference images |
| Installed | 2026-10-26 |

## Installation (verified)

```bash
claude plugin marketplace add Leonxlnx/taste-skill
claude plugin install taste-skill@taste-skill
claude plugin enable taste-skill@taste-skill
```

`install` left it disabled; `enable` was required.

Verify:

```bash
claude plugin list
claude plugin details taste-skill
```

Result: 1 skill, 0 hooks, 0 MCP servers, ~246 always-on tokens; enabled.

## Selection decision

Taste Skill is the **primary** design skill. UI UX Pro Max is deferred as an
alternative and must not be enabled on the same task (duplicate design systems
cause conflicting advice and longer prompts).

## Verification evidence

- Plugin install, enable, and inventory verification passed.
- The `npx skills` path warns because the machine has Node 22.18 and the CLI
  asks for 22.20+; the Claude plugin path has no such dependency and is the
  documented route used here.
- No UI task was in the pilot's scope (`agentic-cicd` is a backend service), so
  the browser-check workflow was not exercised end to end. Re-test on the first
  frontend task:

```text
Use the Taste Skill to design <screen>. Read the existing tokens and components
first. Produce a visual direction, implement it, then inspect the result in a
real browser at desktop and mobile widths. Report what you checked.
```

## Usage rules

- One design system at a time.
- Read `config/design-standards.md` before starting.
- Reuse existing tokens/components; add missing semantic tokens rather than a
  parallel theme.
- Verify keyboard focus, contrast, responsive layout, and console errors.
- Do not claim browser verification unless the browser was actually inspected.

## Update and rollback

```bash
claude plugin update taste-skill@taste-skill
```

Rollback: `claude plugin uninstall taste-skill`. If a second design skill has
been enabled, disable it first.
