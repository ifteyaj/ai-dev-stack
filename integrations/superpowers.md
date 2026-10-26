# Superpowers — deferred trial

**Decision:** Deferred. Not installed globally.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/obra/superpowers |
| Publisher | Obra / Prime Radiant |
| Licence | MIT |
| Latest release observed | `v7.0.1` |
| Official marketplace source commit | `bb92a77741419a4ab5f06e711a283343f1ada0c3` |
| Verified on | 2026-10-26 |

## Why deferred

Superpowers is a complete methodology: brainstorming, plan writing,
subagent-driven development, TDD, review, and verification. That is high quality
but overlaps almost every stage of the EGM + Matt Pocock stack:

- EGM already owns brainstorming, spec drafting, and independent review.
- Matt Pocock already supplies TDD, code review, and diagnosis.
- Superpowers' “using-superpowers” instruction is designed to activate at the
  start of a session, which would compete with EGM for process ownership.

Running both would create duplicate planning steps, conflicting skill triggers,
and longer prompts. The blueprint explicitly warns against this.

## When to revisit

Trial Superpowers when:

- EGM's review loop proves too heavy for the project's pace; or
- the project needs autonomous, long-running subagent execution; or
- a different harness (Codex, Cursor) is used where EGM is unavailable.

## Trial procedure (isolated)

```bash
claude plugin install superpowers@claude-plugins-official -y
claude plugin disable superpowers@claude-plugins-official
```

To trial it, disable EGM and the Matt Pocock plugin for the session, run one
representative feature, and record the result. Do not leave both enabled as
defaults.

Rollback: `claude plugin uninstall superpowers`.
