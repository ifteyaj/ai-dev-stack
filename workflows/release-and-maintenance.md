# Workflow: release and maintenance

## Release readiness

- [ ] Approved spec or documented change scope.
- [ ] All project checks run and passing, or failures explicitly accepted.
- [ ] Diff reviewed for secrets and generated files.
- [ ] `docs/CURRENT-STATUS.md` updated.
- [ ] `docs/DECISIONS.md` updated for durable decisions.
- [ ] Feature spec marked implemented or updated.
- [ ] Migration, rollback, and compatibility considered.
- [ ] Human approval for deployment or publishing.

## Versioning

- Tag releases when the project has a consumer-facing version.
- Record the version and date in the changelog.
- Pin third-party actions and images where the project's security posture
  requires it.

## Drift monitoring

Run the EGM drift report periodically or after structural changes:

```text
/egm:egm-drift-report
```

Reconcile every meaningful divergence by updating the spec or the code. Record
which one changed and why.

Refresh Graphify after significant structural changes:

```bash
graphify . --update --wiki
```

## Updating the harness

1. Read upstream release notes and changelogs.
2. Inspect changed hooks, scripts, and permissions.
3. Test the core workflow in a disposable project.
4. Update `integrations/upstream-repositories.md` and the tool-specific note.
5. Keep a rollback path (previous plugin version or a Git revert).
6. Run `./scripts/doctor.sh`.

## Backup and rollback

Before changing `~/.claude/`:

```bash
./scripts/install.sh --backup-only
```

The installer stores timestamped backups under `~/.claude/backups/harness/`.
To roll back, restore the previous `CLAUDE.md` and remove any newly installed
plugin or skill with its documented uninstall command.
