#!/usr/bin/env bash
# Scaffold a project repository that uses this harness.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET=""
NAME=""

usage() {
  cat <<'USAGE'
Usage: ./scripts/new-project.sh <target-dir> [project-name]

Creates a minimal project repository outside this harness, copies project
documentation templates, and installs CLAUDE.md / AGENTS.md adapters.
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    *) if [ -z "$TARGET" ]; then TARGET="$1"; elif [ -z "$NAME" ]; then NAME="$1"; else echo "Unexpected argument: $1" >&2; usage; exit 2; fi ;;
  esac
  shift
done

if [ -z "$TARGET" ]; then
  usage
  exit 2
fi
[ -n "$NAME" ] || NAME="$(basename "$TARGET")"

if [ -e "$TARGET" ]; then
  if [ -d "$TARGET" ] && [ -z "$(ls -A "$TARGET")" ]; then
    :
  else
    echo "Target already exists and is not empty: $TARGET" >&2
    exit 1
  fi
else
  mkdir -p "$TARGET"
fi

mkdir -p "$TARGET/docs/designs"

copy_template() {
  local src="$1" dst="$2"
  sed -e "s/<Project name>/$NAME/g" -e "s/<project name>/$NAME/g" \
    "$ROOT/$src" > "$TARGET/$dst"
}

copy_template templates/product-requirements.md docs/PRODUCT.md
copy_template templates/requirements.md docs/REQUIREMENTS.md
copy_template templates/architecture.md docs/ARCHITECTURE.md
copy_template templates/decisions.md docs/DECISIONS.md
copy_template templates/roadmap.md docs/ROADMAP.md
copy_template templates/current-status.md docs/CURRENT-STATUS.md
copy_template templates/project-claude.md CLAUDE.md
copy_template templates/project-opencode-agents.md AGENTS.md

cat <<EOF

Scaffolded: $TARGET

Next steps:
  1. Register the project in $ROOT/projects/README.md.
  2. Fill in CLAUDE.md (stack and exact commands).
  3. Run ./scripts/doctor.sh "$TARGET".
  4. Start the first feature with workflows/brainstorm-and-specify.md.
EOF