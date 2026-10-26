# Projects using the harness

The harness keeps only a register here. Application code, product docs, specs,
and generated graphs stay in each project repository.

| Project | Path | Stack | Primary spec | Graphify | Status |
| --- | --- | --- | --- | --- | --- |
| agentic-cicd (pilot) | `~/Desktop/agentic-cicd` | Python 3.12, FastAPI, uv, pytest | EGM | Tested: 53 nodes, 55 edges | Pilot — M1 webhook intake implemented; status machine next |

## Registering a project

Copy this row shape and record:

- the canonical repository path;
- the stack and exact verification commands;
- whether Graphify output is committed;
- where feature specs live (`docs/designs/`);
- the current milestone and owner.

A project must have its own `CLAUDE.md` and `docs/` before it is considered
onboarded. See `workflows/new-project.md`.
