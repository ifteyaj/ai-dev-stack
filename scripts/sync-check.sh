#!/usr/bin/env bash
# Check that a registered project is on the harness adapter version expected.
# Usage: ./scripts/sync-check.sh <project> [--apply]
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="${1:-}"
APPLY=0
if [ "${2:-}" = "--apply" ]; then
  APPLY=1
fi

if [ -z "$PROJECT" ]; then
  echo "Usage: $0 <project> [--apply]" >&2
  exit 2
fi

if [ ! -f "$PROJECT/CLAUDE.md" ]; then
  echo "project CLAUDE.md missing: $PROJECT/CLAUDE.md" >&2
  exit 1
fi

HARNESS_VERSION="$(grep -oE 'harness-parity: project-adapter v[0-9]+' "$ROOT/templates/project-claude.md" | head -1 | grep -oE 'v[0-9]+')"
if [ -z "$HARNESS_VERSION" ]; then
  echo "could not determine harness adapter version from template" >&2
  exit 1
fi
HARNESS_VERSION="${HARNESS_VERSION#v}"

PROJECT_VERSION="$(grep -oE 'harness-parity: project-adapter v[0-9]+' "$PROJECT/CLAUDE.md" | head -1 | grep -oE 'v[0-9]+' || true)"
if [ -z "$PROJECT_VERSION" ]; then
  echo "no parity marker found in $PROJECT/CLAUDE.md" >&2
  exit 1
fi

if [ "$PROJECT_VERSION" = "$HARNESS_VERSION" ]; then
  echo "[ok] $PROJECT is on adapter $PROJECT_VERSION, harness is on $HARNESS_VERSION"
  exit 0
fi

echo "[warn] $PROJECT is on adapter $PROJECT_VERSION, harness is on $HARNESS_VERSION" >&2

if [ "$APPLY" -eq 1 ]; then
  echo "sync-check --apply: not supported yet for this marker version."
  exit 2
fi

echo "update this project from the harness template and re-check."
exit 1
