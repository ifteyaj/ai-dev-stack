#!/usr/bin/env bash
# Session-start hook: orient the model with the project's current status.
set -u

status_file=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -n "$root" ] && [ -f "$root/docs/CURRENT-STATUS.md" ]; then
    status_file="$root/docs/CURRENT-STATUS.md"
  fi
fi
if [ -z "$status_file" ] && [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -f "${CLAUDE_PROJECT_DIR}/docs/CURRENT-STATUS.md" ]; then
  status_file="${CLAUDE_PROJECT_DIR}/docs/CURRENT-STATUS.md"
fi

if [ -n "$status_file" ] && [ -f "$status_file" ]; then
  echo "=== CURRENT-STATUS.md ($status_file) ==="
  sed -n '1,24p' "$status_file"
fi
exit 0
chmod +x config/hooks/session-start.sh