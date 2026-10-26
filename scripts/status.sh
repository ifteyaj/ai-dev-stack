#!/usr/bin/env bash
# Print installed harness state and registered project freshness.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

echo "Harness root:   $ROOT"
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "Harness HEAD:   $(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null)"
  if git -C "$ROOT" diff --quiet; then echo "Working tree:   clean"; else echo "Working tree:   dirty"; fi
fi
echo
echo "Installed tools:"
echo "  claude:     $(command -v claude >/dev/null && claude --version 2>/dev/null | head -1 || echo 'MISSING')"
echo "  opencode:   $(command -v opencode >/dev/null && opencode --version 2>/dev/null | head -1 || echo 'MISSING')"
echo "  graphify:   $(command -v graphify >/dev/null && graphify --version 2>/dev/null | head -1 || echo 'MISSING')"
echo "  jq:         $(command -v jq >/dev/null && jq --version 2>/dev/null | head -1 || echo 'MISSING')"
echo "  shellcheck: $(command -v shellcheck >/dev/null && shellcheck --version 2>/dev/null | head -2 | tail -1 || echo 'MISSING')"
echo
echo "Registered projects:"
while IFS= read -r p; do
  [ -z "$p" ] && continue
  expanded="${p/#\~/$HOME}"
  if [ ! -d "$expanded" ]; then
    echo "  - $p  (not found)"
    continue
  fi
  dirty="$(git -C "$expanded" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  status_file="$expanded/docs/CURRENT-STATUS.md"
  if [ -f "$status_file" ]; then
    if command -v stat >/dev/null 2>&1; then
      if stat -c '%Y' "$status_file" >/dev/null 2>&1; then st="$(stat -c '%Y' "$status_file")"; else st="$(stat -f '%m' "$status_file")"; fi
    else st=0; fi
    now="$(date +%s)"
    days="$(((now - st) / 86400))"
    extra="status updated ${days} day(s) ago"
  else
    extra="no CURRENT-STATUS.md"
  fi
  echo "  - $p (dirty=${dirty}, $extra)"
done < <(sed -n 's/.*`\(~\/[^`]*\)`.*/\1/p' "$ROOT/projects/README.md" | sort -u)
echo
echo "Backups:"
ls -1 "$CLAUDE_DIR/backups/harness" 2>/dev/null | tail -5 || echo "  none"
