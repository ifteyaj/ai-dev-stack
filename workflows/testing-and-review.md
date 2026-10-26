# Workflow: testing and review

## Verification ladder

Run the cheapest checks first and stop treating a failure as noise:

1. Formatting and lint.
2. Type checking.
3. Unit tests.
4. Integration tests.
5. Build.
6. End-to-end or browser checks for affected journeys.
7. Manual inspection of the diff and user-facing states.

Use the project's own commands. Do not substitute a different test runner or
weaken configuration to get a pass.

## Test quality

- A test should fail for the defect it describes.
- Assert observable behaviour, not private implementation details.
- Cover success, validation failure, and a realistic runtime failure.
- Keep tests deterministic; control time, randomness, and network.
- Do not delete or `xfail` a test merely to make CI green.

## Independent review

For substantial changes, use a reviewer that did not write the code:

- EGM Goldfish review for the specification.
- Matt Pocock `code-review` or a fresh subagent for the diff.
- Human review for security, data, architecture, and anything user-visible.

Give the reviewer the spec, the diff, and the verification commands. Do not give
it the author's reasoning unless the review explicitly needs that context.

## Verification report

Use this shape:

```text
Run and passed:
- <command> — <result>

Run and failed:
- <command> — <failure> — <resolution or why it is out of scope>

Not run:
- <check> — <reason>

Acceptance criteria:
- <criterion> — <evidence>

Residual risk:
- <risk or "none identified">
```

Never claim a check passed because it usually passes or because CI will run it.
