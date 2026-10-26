# Workflow: feature development

Use this after a spec is approved, or for a small change that does not need EGM.

## 1. Re-read the contract

- Read the approved spec and the acceptance criteria.
- Read the project `CLAUDE.md` and the files named in the spec.
- Confirm the working tree is clean or know exactly what is already modified.
- Create a branch when the change is non-trivial.

## 2. Plan the smallest implementation

- List the files to change and the tests to add.
- Identify existing patterns to reuse.
- If the plan contradicts the spec, stop and update the spec first.
- Do not add dependencies without a stated reason.

## 3. Implement in reviewable steps

- Prefer test-first for behaviour with a clear contract.
- Keep each step runnable.
- Do not mix unrelated refactors or formatting churn into the change.
- Update types, validation, and error handling at trust boundaries.
- Add or update tests with each behaviour.

## 4. Verify

Run the exact project commands. Typical set:

```bash
<lint>
<format check>
<type check>
<tests>
<build>
```

For UI work, also follow `config/design-standards.md` and inspect a real browser.

## 5. Review the diff

- Compare every changed line with the spec.
- Look for accidental deletions, debug output, secrets, and generated files.
- Use a code-review skill or a fresh-context reviewer for substantial changes.
- Resolve findings or record why they are out of scope.

## 6. Close out

- Update `docs/CURRENT-STATUS.md`.
- Add durable decisions to `docs/DECISIONS.md`.
- Update the feature spec if behaviour changed.
- Report run/passed, run/failed, and not run.
- Commit one coherent change.
