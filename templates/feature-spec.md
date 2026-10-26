# Feature specification: <feature name>

**Status:** Draft | In review | Approved | Implemented | Superseded\
**Owner:** <name>\
**Date:** <YYYY-MM-DD>\
**Review status:** Not reviewed | Findings open | Findings resolved\
**Approved by / date:** <name / date>

## 1. Summary

<What changes, for whom, and why now.>

## 2. Problem statement

<Current behaviour, the gap, and the consequence of leaving it.>

## 3. Goals and non-goals

### Goals

- <observable outcome>

### Non-goals

- <explicit exclusion>

## 4. Users and journeys

- **<user>**: <journey and expected outcome>

## 5. Requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| FR-1 | <observable behaviour> | Must |

## 6. Acceptance criteria

- [ ] Given <precondition>, when <action>, then <observable result>.
- [ ] Given <invalid input>, <action> is blocked and <message> is shown.
- [ ] Automated tests cover <success>, <validation>, and <failure>.

## 7. Edge cases and failure states

| Case | Expected behaviour |
| --- | --- |
| <empty input> | <behaviour> |
| <upstream failure> | <behaviour> |
| <concurrent request> | <behaviour> |

## 8. Data model and validation

- <entity, fields, constraints, ownership>
- <where validation occurs>

## 9. API and integration contracts

| Method / event | Input | Output | Errors |
| --- | --- | --- | --- |
| <POST /path> | <shape> | <shape> | <codes> |

## 10. Architecture and component boundaries

- <component responsibility>
- <what must not be coupled>

## 11. Security, privacy, accessibility, performance

- Security: <authn/authz, input validation, secret handling>
- Privacy: <data collected and retention>
- Accessibility: <keyboard, contrast, labels>
- Performance: <budget and measurement>

## 12. Migration and compatibility

<Schema, API, or data migration; backward compatibility; rollback.>

## 13. Files and modules likely to change

- `<path>` — <why>

## 14. Implementation steps

1. <step with a runnable checkpoint>
2. <step>

## 15. Testing and verification plan

- Unit: <cases>
- Integration: <cases>
- Manual / browser: <journey>
- Commands: <exact commands>

## 16. Observability and operations

<Logs, metrics, alerts, runbook impact.>

## 17. Alternatives and trade-offs

- <alternative> — <why rejected>

## 18. Open questions

- [ ] <question> — owner: <name>

## 19. Review findings and resolution

| ID | Finding | Severity | Decision | Resolution |
| --- | --- | --- | --- | --- |
| R-1 | <finding> | <high/med/low> | Accept / Reject / Defer | <change or rationale> |
