# Workflow: debugging

## 1. Reproduce

- Get a deterministic reproduction: command, input, and observed output.
- If it cannot be reproduced, document the conditions and instrument the
  smallest plausible boundary.
- Do not change code before you can explain what is wrong.

## 2. Isolate

- Read the failing test, the call path, and recent changes.
- Use Graphify or a targeted search to find callers and related modules.
- Form one hypothesis at a time and test it with the smallest possible probe.
- Distinguish the root cause from the symptom. Do not paper over an exception.

## 3. Define expected behaviour

- Write down what should happen, including the edge cases.
- If the expected behaviour is ambiguous, ask rather than guess.
- If the bug reveals a missing requirement, update the spec or decision record.

## 4. Fix

- Make the smallest correct change.
- Add a regression test that fails without the fix.
- Check adjacent code for the same defect only when it is plausibly the same
  root cause.

## 5. Verify

- Run the regression test, the full relevant suite, and the project checks.
- Confirm the original reproduction now behaves correctly.
- Report any check that could not be run.

## 6. Record

- Add a short note to `docs/CURRENT-STATUS.md` if the defect affected users.
- Record a durable design lesson in `docs/DECISIONS.md` only when it changes a
  decision, not for every bug.
