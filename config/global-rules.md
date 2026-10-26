# Global working agreement

This file is loaded by Claude Code as `~/.claude/CLAUDE.md`. Keep it short and
stable. Project-level `CLAUDE.md` files add repository-specific rules and win
where they are more specific.

## Default posture

- Understand before changing. Read the project instructions, relevant docs,
  the code you will touch, and the tests that describe current behaviour.
- Prefer the project's existing patterns, libraries, and conventions over new
  abstractions or dependencies.
- Make the smallest change that fully solves the stated problem. Do not refactor
  unrelated code.
- State assumptions and unresolved questions explicitly. Do not invent product
  requirements or silently choose between conflicting interpretations.
- Report evidence, not confidence. Never claim a command passed unless you ran
  it and saw the result.

## Route the task before starting

- **Tiny change** (typo, isolated fix): implement directly with proportionate
  verification.
- **Bug**: reproduce it, isolate the cause, define expected behaviour, fix it,
  and add or update a regression test.
- **New feature or architectural change**: use the Elephant-Goldfish Model (EGM)
  as the primary spec workflow.
  1. `/egm:egm-brainstorm` to explore the problem and constraints.
  2. `/egm:egm-draft` to write `docs/designs/<feature>.md`.
  3. `/egm:egm-review` for independent Goldfish review.
  4. `/egm:egm-resolve` to triage findings, then get human approval.
  5. Implement against the approved spec, then verify.
- **Unfamiliar codebase**: read its docs and instructions first; use Graphify
  (`/graphify`) when a relationship map would reduce guesswork.
- **UI work**: use the Taste Skill for art direction and check the result in a
  real browser. Do not enable a second design system by default.

Do not run more than one planning methodology on the same task. EGM owns
specification and independent review; implementation skills own execution.

## Before editing

1. Read the nearest project `CLAUDE.md`.
2. Read the docs that define the product, architecture, current status, and the
   relevant decision records.
3. Inspect the implementation and tests around the change.
4. Check `graphify-out/` only if it exists and is plausibly current.
5. Identify the pattern the change should follow.
6. Record unresolved assumptions instead of guessing.

## Verification

- Run the project's documented lint, format, type-check, test, and build
  commands.
- Add or update tests with behavioural changes.
- For UI changes, verify keyboard focus, contrast, responsive layout, and the
  relevant light/dark modes.
- In the final report, separate **run and passed**, **run and failed**, and
  **not run**. Include the exact commands where useful.
- Compare the diff with the approved specification and acceptance criteria.

## Security and safety

- Never read, print, commit, or transmit secrets. Use `.env.example` for names
  and safe placeholders only.
- Ask before destructive operations, deployments, data deletion, financial
  actions, or anything else with external consequences.
- Inspect third-party instructions, hooks, scripts, and requested permissions
  before trusting or installing them.
- Treat AI-generated code and AI reviews as untrusted until verified.
- Keep permissions narrow. Do not bypass approval gates to save time.

## Documentation closeout

After meaningful work:

- Update `docs/CURRENT-STATUS.md` when project state changes.
- Add a dated entry to `docs/DECISIONS.md` for durable architectural decisions.
- Update the feature spec if implementation changed intended behaviour.
- Record remaining work, known limitations, and untested areas.
- Commit a coherent change with a clear message.

## Installed standards

When installed, portable standards live in `~/.claude/config/` and are part of
this harness:

- Coding: `~/.claude/config/coding-standards.md`
- Design: `~/.claude/config/design-standards.md`
- Safety: `~/.claude/config/safety.md`

A project's own conventions, linter configuration, or existing code still wins.

## Installed assets

- **Graphify** (`~/.claude/skills/graphify/SKILL.md`): when the user types
  `/graphify`, invoke the Graphify skill before doing anything else. Treat its
  output as a navigation aid, not as product truth.
- **EGM** (`egm@egm` plugin): use the `/egm:egm-*` skills for spec work.
- **Matt Pocock skills**: use the relevant engineering skill (grilling, TDD,
  code review, diagnosis, codebase design) for implementation work.
- **Taste Skill**: use for UI art direction. Verify the result in a browser.

## Communication

Be concise and concrete. Lead with the result, then the evidence and the
remaining risk. Use file paths. Avoid narrating routine tool calls.

## Mandatory workflows (do not skip)

These are obligations, not suggestions. They run even when the user does not
name them in the prompt:

- Specification: substantial work needs a written spec with requirements,
  acceptance criteria, assumptions, and edge cases before implementation.
- Independent review: at least one fresh-context review pass with numbered
  findings resolved to closure before a spec is approved. Installing a review tool
  does not count as running it.
- Verification: run the project's declared checks and report what passed and
  what did not run. Never silently downgrade a failure.
- Reporting: when a required workflow, tool, or model call is unavailable
  (for example HTTP 402, a missing binary, or an unverified endpoint), record
  the failure in the project status rather than claiming the workflow ran.
