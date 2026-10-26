# Workflow: independent review (EGM-compatible)

Use fresh-context review before implementation. Never let the author of a spec
be the only reviewer of it. A solo review produces confirmation bias, not
verification.

## When to use it

- Every substantial feature that goes through the EGM lifecycle.
- Any change that alters a security, data-loss, or compatibility boundary,
  even if small.
- Whenever a spec has been revised after earlier findings — rerun the
  categories that were affected.

## Reviewer mix

Use at least two reviewers in fresh contexts:

1. **Design critic** — assumptions, requirements quality, scope, overlooked
   cases, and the risk of doing the wrong thing well.
2. **Comprehension** — can a second engineer implement and test this without
   asking the author?
3. **Security** — for authenticated, parsing, or externally reachable code,
   attacker modelling, ordering invariants, resource bounds.
4. **Readiness** — is implementation now possible with no further design
   decisions? End-to-end, last gateway before approval.

For a small change, two reviewers is enough. For security-sensitive changes,
keep security as a separate reviewer.

## Reviewer agent prompt

Give every reviewer:

- Exactly the spec files and the supporting project docs named in the spec.
- The current code, tests, and project `CLAUDE.md`/`AGENTS.md` if relevant.
- An explicit instruction not to trust the author and to look for blocking
  issues.
- A required output format: verdict (PASS / BLOCK), numbered blocking issues
  with section references and minimal fixes, non-blocking nits, and ambiguities
  an implementer would face.
- A word cap. Agents that ramble produce less actionable findings.

## Findings record

Maintain a findings table in the spec, with one row per finding:

```
| ID | Finding | Severity | Decision | Resolution |
```

- Severity: Critical, High, Medium, Low.
- Decision: Accept, Reject, or Defer (with reason).
- Resolution: the concrete change made, or the explicit justification for
  not changing.
- Number findings consecutively (`R-01`, …) across rounds; cross-reference
  IDs in implementation commits.

## Readiness gate

Do not approve the spec until a final readiness review returns PASS. A spec
that has passed two rounds of partial review still needs one focused pass
asking: could an engineer implement this correctly and testably now, given no
further decisions? Treat a BLOCK here as a request to revise, not as a minor
nit.

Run the readiness gate again whenever a substantial revision lands, not just
once.

## Fresh context discipline

Reviewers must start with empty context. Do not seed them with prior review
output. They may reuse the raw spec, the project docs, and the code. They
must not reuse the author's notes or the previous findings list, because
that converts independent review into confirmation.

## If the model endpoint is unavailable

If a configured model returns 402 or similar billing error, the review
workflow is unverified even though it installs cleanly. In that case:

- report the error verbatim,
- run the review with an independently available model and fresh context,
- record both facts in the project's `CURRENT-STATUS.md`,
- and mark the harness's EGM-related readiness item open until the endpoint
  works.

Silently bypassing the review and labelling the spec approved is not allowed.