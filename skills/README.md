# Skills

Third-party skills are installed by their documented plugin or installer
mechanism. They are **not** vendored into this repository.

## Installed globally

| Skill / plugin | Owner | Installed via | Responsibility |
| --- | --- | --- | --- |
| `egm` | Google | Claude plugin marketplace | Spec brainstorm, draft, review, resolve, drift |
| `mattpocock-skills` | Matt Pocock | Official Claude plugin marketplace | Implementation discipline: grilling, TDD, review, diagnosis, codebase design |
| `taste-skill` | Leonxlnx | Claude plugin marketplace | UI art direction and browser-checked design |
| `graphify` | Graphify Labs | `graphify install` | Codebase knowledge graph |

## Local custom skills

Put small, harness-specific skills in `skills/custom/<name>/SKILL.md`. Keep them
narrow. Do not duplicate EGM or an upstream skill.

The installer links each custom skill into `~/.claude/skills/` only when
`--with-custom-skills` is passed.

## Selection policy

- Use EGM for substantial feature specification and independent spec review.
- Use Matt Pocock skills for implementation, diagnosis, and code review.
- Use Taste Skill for UI work; do not enable a second design system by default.
- Use Anthropic document skills only for an actual document task (docx, pdf,
  pptx, xlsx).
- Do not enable Superpowers, Ponytail, Caveman, or another planning framework
  globally while EGM is the primary workflow.

See `integrations/upstream-repositories.md` for decisions and reasons.
