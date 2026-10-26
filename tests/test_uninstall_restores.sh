#!/usr/bin/env bash
# Acceptance test: uninstall restores a pre-existing CLAUDE.md.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/.claude"
printf 'original\n' > "$tmp/.claude/CLAUDE.md"
HOME="$tmp" "$ROOT/scripts/install.sh" --with-opencode >/dev/null 2>&1 || { echo "install failed"; exit 1; }
HOME="$tmp" "$ROOT/scripts/uninstall.sh" >/dev/null 2>&1 || { echo "uninstall failed"; exit 1; }

if [ "$(cat "$tmp/.claude/CLAUDE.md" 2>/dev/null)" = "original" ]; then
  echo "test_uninstall_restores: PASS"
else
  echo "test_uninstall_restores: FAIL (got: $(cat "$tmp/.claude/CLAUDE.md" 2>/dev/null))"
  exit 1
fi
