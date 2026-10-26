# Workflow: brainstorm and specify (EGM)

EGM is the primary specification workflow. Do not duplicate it with a second
planning system.

## Stage 1 — Brainstorm (Elephant)

```text
/egm:egm-brainstorm <idea>
```

- Explore the user problem, current behaviour, constraints, and alternatives.
- Ask about non-goals and what must not change.
- Identify assumptions that need human confirmation.
- Do not write implementation code in this stage.

Output: a concept brief in the working directory or the configured artifact
directory.

## Stage 2 — Draft

```text
/egm:egm-draft <brief or idea>
```

The draft belongs at `docs/designs/<feature>.md`. Confirm it includes:

- problem, goals, non-goals, users, and journeys;
- observable acceptance criteria;
- edge cases and failure states;
- data, API, and integration contracts;
- architecture and boundaries;
- security, privacy, accessibility, performance;
- files likely to change;
- implementation steps and verification plan;
- alternatives, trade-offs, and open questions;
- review findings and resolution status.

Use `templates/feature-spec.md` as a completeness check, not as a rigid form.

## Stage 3 — Independent review (Goldfish)

```text
/egm:egm-review docs/designs/<feature>.md
```

Reviewers must receive the spec and relevant source, not the design
conversation. If the tool offers a fresh-context or zero-context mode, use it.

Expect findings about ambiguity, missing requirements, unsafe assumptions, and
implementation gaps. A review is evidence, not approval.

## Stage 4 — Resolve and approve

```text
/egm:egm-resolve docs/designs/<feature>.md
```

- Triage every important finding: accept, reject with rationale, or defer.
- Update the spec before implementation when scope or behaviour changes.
- Record material decisions in `docs/DECISIONS.md`.
- Get explicit human approval. Mark the spec `Status: Approved` and date it.

## Stage 5 — Handoff

Give the implementing agent:

- the approved spec path;
- the project `CLAUDE.md`;
- the verification commands;
- the explicit scope boundary.

Then use `workflows/feature-development.md`.
