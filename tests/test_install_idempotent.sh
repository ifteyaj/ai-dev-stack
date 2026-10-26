#!/usr/bin/env bash
# Acceptance test: install is idempotent in a clean HOME.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

HOME="$tmp" "$ROOT/scripts/install.sh" --with-opencode >/dev/null 2>&1 || { echo "first install failed"; exit 1; }
HOME="$tmp" "$ROOT/scripts/install.sh" --with-opencode >/dev/null 2>&1 || { echo "second install failed"; exit 1; }

if [ "$(readlink "$tmp/.claude/CLAUDE.md" 2>/dev/null)" = "$ROOT/config/global-rules.md" ]; then
  echo "test_install_idempotent: PASS"
else
  echo "test_install_idempotent: FAIL (link missing)"
  exit 1
fi
