#!/usr/bin/env bash
# Check that changes to config/ or workflows/ are accompanied by CHANGELOG.md.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="${1:-HEAD~1}"

if ! git -C "$ROOT" rev-parse --verify "$BASE" >/dev/null 2>&1; then
  echo "base '$BASE' is not available; skipping changelog discipline check."
  exit 0
fi

changed="$(git -C "$ROOT" diff --name-only "$BASE" HEAD)"
if printf '%s\n' "$changed" | grep -qE '^(config|workflows)/'; then
  if printf '%s\n' "$changed" | grep -qx 'CHANGELOG.md'; then
    echo "CHANGELOG updated alongside config/workflows changes."
    exit 0
  else
    echo "config/ or workflows/ changed without updating CHANGELOG.md." >&2
    exit 1
  fi
else
  echo "no config/workflows changes in this range."
fi
