#!/usr/bin/env bash
# Update installed tools after reviewing upstream changes.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./scripts/update.sh [--dry-run]

Backs up ~/.claude, updates the installed plugins and Graphify, then prints
versions. It does not update Claude Code itself or install new tools.
Review upstream release notes and the integration register first.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] %s\n' "$*"
  else
    printf '+ %s\n' "$*"
    "$@"
  fi
}

run "$ROOT/scripts/install.sh" --backup-only
run claude plugin update egm@egm
run claude plugin update mattpocock-skills@claude-plugins-official
run claude plugin update taste-skill@taste-skill
run uv tool upgrade graphifyy

echo
echo "Installed versions:"
claude plugin list 2>/dev/null || true
graphify --version 2>/dev/null || true
echo
echo "Re-run './scripts/doctor.sh' and test one representative workflow."
echo "Update integrations/upstream-repositories.md with tested versions."
