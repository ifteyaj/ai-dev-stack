# Upstream repository register

Single source of truth for what is approved, on trial, deferred, or rejected.
Re-verify before installing or updating. Star counts and activity are a
snapshot, not an endorsement.

**Last reviewed:** 2026-10-26

## Decision summary

| # | Candidate | Canonical upstream | Licence | Snapshot | Decision |
| --- | --- | --- | --- | --- | --- |
| 1 | Elephant-Goldfish Model | https://github.com/google/elephant-goldfish-model | Apache-2.0 | 1.4k stars, active 2026-10-25 | **Approved** — primary spec workflow |
| 2 | Graphify | https://github.com/Graphify-Labs/graphify | Apache-2.0 | 135.7k stars, active 2026-10-23 | **Approved** — per-project code intelligence |
| 3 | Matt Pocock Skills | https://github.com/mattpocock/skills | MIT | 303.7k stars, active 2026-10-22 | **Approved** — engineering execution |
| 4 | Taste Skill | https://github.com/Leonxlnx/taste-skill | MIT | 102.7k stars, active 2026-10-26 | **Approved** — primary UI design |
| 5 | Superpowers | https://github.com/obra/superpowers | MIT | 305.4k stars, active 2026-10-23 | **Deferred** — overlaps EGM + Matt |
| 6 | UI UX Pro Max | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill | MIT | 140.7k stars, active 2026-10-26 | **Deferred** — alternative design system |
| 7 | Anthropic Skills | https://github.com/anthropics/skills | Mixed / source-available | 183.9k stars, active 2026-10-09 | **Deferred** — install on document task |
| 8 | Karpathy Skills | https://github.com/multica-ai/andrej-karpathy-skills | No licence file found | 224.2k stars, last push 2026-04-20 | **Adopt principles, do not install** |
| 9 | Ponytail | https://github.com/DietrichGebert/ponytail | MIT | 176.6k stars, active 2026-10-18 | **Deferred** — overlaps simplicity/review |
| 10 | Caveman | https://github.com/Shawnchee/caveman-skill | MIT | 78 stars, active 2026-10-24 | **Rejected for now** — conflicts with reporting style |
| 11 | Agent Skills (candidate) | Ambiguous; see note | Varies | — | **Deferred** — identity not resolved |
| 12 | vercel-labs/agent-skills | https://github.com/vercel-labs/agent-skills | No licence file found | 33k stars, active 2026-10-14 | **Not adopted** — installer ecosystem, not a workflow |
| 13 | agentskills/agentskills | https://github.com/agentskills/agentskills | Check upstream | 26.6k stars | **Reference only** — Agent Skills spec |

“No licence file found” means GitHub's licence API returned no SPDX identifier
and no `LICENSE` file at the repository root on the review date. Do not vendor or
redistribute such code without clarification.

## Install methods and tested versions

| Candidate | Install method | Tested version / source | Notes |
| --- | --- | --- | --- |
| EGM | `claude plugin marketplace add google/elephant-goldfish-model` then `claude plugin install egm@egm` | `0.1.0`, commit `3d0b348` | Must `enable` after install |
| Graphify | `uv tool install graphifyy` then `graphify install --platform claude` | `0.9.92` | PyPI name `graphifyy`; skill + `CLAUDE.md` trigger |
| Matt Pocock | `claude plugin install mattpocock-skills@claude-plugins-official -y` | `1.3.1`, source sha `49dd158…` | 27 skills; spec-overlap skills are manual-only |
| Taste Skill | `claude plugin marketplace add Leonxlnx/taste-skill` then `claude plugin install taste-skill@taste-skill` | `2.1.5`, commit `12af471` | Must `enable` after install |
| Superpowers | `claude plugin install superpowers@claude-plugins-official` | official marketplace sha `bb92a77…` | Not installed; deferred |
| UI UX Pro Max | plugin marketplace or `ui-ux-pro-max-cli` | `v2.15.0` observed | Not installed; deferred |
| Anthropic Skills | `claude plugin marketplace add anthropics/skills` | n/a | Not installed; install `document-skills` on demand |
| Karpathy Skills | copy one `CLAUDE.md` | n/a | No licence file; principles folded into global rules instead |
| Ponytail | `claude plugin marketplace add DietrichGebert/ponytail` | n/a | Not installed; deferred |
| Caveman | skill install from `Shawnchee/caveman-skill` | n/a | Not installed; rejected for now |

## Verified installation state (2026-10-26)

```text
egm@egm                               0.1.0   enabled
mattpocock-skills@claude-plugins-official 1.3.1 enabled
taste-skill@taste-skill               2.1.5   enabled
graphify CLI                          0.9.92  on PATH
```

## Ambiguity notes

- **“Agent Skills”** could mean the Agent Skills specification
  (`agentskills/agentskills`), Anthropic's skills collection
  (`anthropics/skills`), or Vercel's installer collection
  (`vercel-labs/agent-skills`). Repository names are not sufficient. No install
  until the intended project is named.
- **Karpathy Skills** is a single `CLAUDE.md`, not a skill package. Its four
  principles (think before coding, simplicity first, surgical changes,
  goal-driven execution) are already reflected in the global rules and coding
  standards. Installing it would duplicate instructions.
- **Ponytail** is an always-on ruleset with lifecycle hooks and review/audit
  commands. It overlaps Matt's `code-review` and the simplicity guidance.
  Revisit only if the current stack proves too verbose.
- **Caveman** optimizes for extremely terse output. It would undermine the
  verification-report style this harness requires. Optional for interactive
  work only.

## Re-verification checklist

For every candidate:

- [ ] Canonical URL and publisher confirmed.
- [ ] Licence confirmed from the repository, not the README badge alone.
- [ ] Recent activity checked.
- [ ] Install script, hooks, and permissions inspected.
- [ ] Version or commit recorded.
- [ ] Core workflow tested in a disposable or pilot repository.
- [ ] Overlap with the current primary workflow assessed.
- [ ] Decision and date recorded here.
