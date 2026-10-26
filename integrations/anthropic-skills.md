# Anthropic Skills — selective use

**Decision:** Deferred. Install only the capability needed for a real document
task.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/anthropics/skills |
| Publisher | Anthropic |
| Licence | Mixed: many skills Apache-2.0; `docx`, `pdf`, `pptx`, `xlsx` are source-available, not open source |
| Install routes | Plugin marketplace: `document-skills` or `example-skills` |
| Verified on | 2026-10-26 |

## Why deferred

The pilot is a Python API service; it has no document-generation requirement.
Installing four heavy document skills globally would add always-on descriptions
and unused surface area. The blueprint's policy is to install the specific
capability needed.

## When to install

Use `document-skills` when a real task requires creating or editing DOCX, PDF,
PPTX, or XLSX files. Use `example-skills` only to inspect patterns, not as a
default workflow.

```bash
claude plugin marketplace add anthropics/skills
claude plugin install document-skills@anthropic-agent-skills
```

Check the plugin's licence and the individual skill before relying on it for
sensitive documents. The document skills are source-available, not open source.

Rollback: `claude plugin uninstall document-skills`.
