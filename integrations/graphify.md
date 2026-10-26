# Graphify

**Role:** Per-project codebase relationship map. Helps answer “where is this
implemented?”, “what depends on this?”, and “what might a change affect?”. It is
not product truth.

## Verified upstream

| Field | Value |
| --- | --- |
| Canonical URL | https://github.com/Graphify-Labs/graphify |
| Publisher | Graphify Labs |
| Licence | Apache-2.0 |
| PyPI package | `graphifyy` (temporary name; CLI is `graphify`) |
| Version tested | `0.9.92` |
| Installer | `uv tool install graphifyy` |
| Runtime | Python 3.10+ (managed by `uv`; system Python is 3.9) |
| Installed | 2026-10-26 |

## Installation (verified)

```bash
uv tool install graphifyy
graphify install --platform claude
graphify --version
```

`graphify install` writes:

- `~/.claude/skills/graphify/SKILL.md` plus `references/`;
- a Graphify section in `~/.claude/CLAUDE.md`.

**Important:** the installer created `~/.claude/CLAUDE.md` before our global
rules were linked. We replaced it with the harness symlink and added the Graphify
trigger to `config/global-rules.md`. Re-running the installer may attempt to
modify `CLAUDE.md`; verify the symlink afterward.

## Verification on the pilot (`agentic-cicd`)

```bash
cd ~/Desktop/agentic-cicd
graphify extract . --code-only --no-cluster
graphify cluster-only . --no-label
graphify query "where is GitHub webhook signature verification" --budget 500
graphify god-nodes --top 5
graphify affected "create_app" --depth 2
```

Result:

- 25 code files scanned; 15 non-code files skipped.
- 53 nodes, 55 edges; 17 communities; 98% EXTRACTED, 2% INFERRED.
- Generated `graphify-out/graph.json`, `GRAPH_REPORT.md`, `graph.html`,
  analysis, manifest, and cache.
- Query correctly surfaced the webhook signature tests and `_sign()` helper.
- One fixture with a deliberate syntax error was partially extracted, as
  expected.
- `--code-only` required no LLM calls, so it worked despite the Claude endpoint
  billing failure.

Useful report sections: God Nodes, Surprising Connections, Import Cycles,
Knowledge Gaps, Suggested Questions.

## Artifact policy

- `graphify-out/` is generated. It is ignored by the harness `.gitignore` and
  should be ignored in product repositories unless the team explicitly wants to
  review the report in Git.
- Commit the *decision* about artifacts, not necessarily the graph.
- Refresh after structural changes: `graphify update .` (local AST, no API
  cost). Use `graphify extract . --code-only` for a fresh local rebuild.
- Use semantic/doc extraction only when needed and an LLM backend is available:
  `graphify extract .` with `--backend`.

## When to use

- Onboarding to an unfamiliar repository.
- Before changing a module with non-obvious callers.
- After a large refactor, to refresh the map.
- Not for requirements, priorities, or decision history.

## Update and rollback

```bash
uv tool upgrade graphifyy
graphify --version
graphify uninstall
```

Rollback: `uv tool uninstall graphifyy` and remove
`~/.claude/skills/graphify/`. Restore `~/.claude/CLAUDE.md` from
`~/.claude/backups/harness/` if the installer changed it.
