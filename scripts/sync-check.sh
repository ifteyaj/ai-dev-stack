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

check_file() {
  local file="$1"
  grep -oE 'harness-parity: project-adapter v[0-9]+' "$file" 2>/dev/null | head -1 | grep -oE 'v[0-9]+$' || true
}

HARNESS_VERSION="$(check_file "$ROOT/templates/project-claude.md")"
if [ -z "$HARNESS_VERSION" ]; then
  echo "could not determine harness adapter version from template" >&2
  exit 1
fi
HARNESS_VERSION="${HARNESS_VERSION#v}"

echo "Harness adapter version: v$HARNESS_VERSION"

status=0
for filename in CLAUDE.md AGENTS.md; do
  if [ -f "$PROJECT/$filename" ]; then
    pv="$(check_file "$PROJECT/$filename")"
    pv="${pv#v}"
    if [ -z "$pv" ]; then
      echo "[warn] $PROJECT/$filename has no parity marker" >&2
      status=1
    elif [ "$pv" = "$HARNESS_VERSION" ]; then
      echo "[ok]  $PROJECT/$filename on v$pv"
    else
      echo "[warn] $PROJECT/$filename on v$pv (harness v$HARNESS_VERSION)" >&2
      status=1
    fi
  fi
done

for filename in CLAUDE.md AGENTS.md; do
  if [ -f "$PROJECT/$filename" ]; then
    PROJECT_VERSION="$(check_file "$PROJECT/$filename")"
    PROJECT_VERSION="${PROJECT_VERSION#v}"
    [ -n "$PROJECT_VERSION" ] || continue
    if [ "$PROJECT_VERSION" != "$HARNESS_VERSION" ]; then
      case "$filename" in
        CLAUDE.md) tpl="project-claude.md" ;;
        AGENTS.md) tpl="project-opencode-agents.md" ;;
        *) tpl="$filename" ;;
      esac
      echo "To update $PROJECT/$filename, compare with $ROOT/templates/$tpl" >&2
    fi
  fi
done

if [ "$APPLY" -eq 1 ]; then
  echo "sync-check --apply currently requires harness markers: supported for explicit blocks only." >&2
  echo "No files changed."
  exit 2
fi

[ "$status" -eq 0 ] || exit 1
exit 0
