#!/usr/bin/env bash
# Acceptance test for new-project scaffolding.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

"$ROOT/scripts/new-project.sh" "$tmp/demo" "DemoProject" >/dev/null 2>&1
rc=$?
[ $rc -eq 0 ] || { echo "new-project failed rc=$rc"; exit 1; }

for f in \
  "$tmp/demo/CLAUDE.md" "$tmp/demo/AGENTS.md" \
  "$tmp/demo/docs/PRODUCT.md" "$tmp/demo/docs/REQUIREMENTS.md" \
  "$tmp/demo/docs/ARCHITECTURE.md" "$tmp/demo/docs/DECISIONS.md" \
  "$tmp/demo/docs/ROADMAP.md" "$tmp/demo/docs/CURRENT-STATUS.md"; do
  [ -f "$f" ] || { echo "missing $f"; exit 1; }
done

grep -q 'harness-parity: project-adapter v1' "$tmp/demo/CLAUDE.md" || { echo "missing parity marker"; exit 1; }
if grep -q '<Project name>' "$tmp/demo/CLAUDE.md" "$tmp/demo/AGENTS.md"; then
  echo "placeholder remains"
  exit 1
fi

echo "test_new_project: PASS"
