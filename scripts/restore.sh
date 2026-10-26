#!/usr/bin/env bash
# Roll back any harness backup by name (as listed in ~/.claude/backups/harness/).
set -u

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
BACKUP_ROOT="$CLAUDE_DIR/backups/harness"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./scripts/restore.sh <backup-stamp>

Restores the named backup directory from ~/.claude/backups/harness/<stamp>/.
EOF
}

STAMP="${1:-}"
if [ -z "$STAMP" ]; then
  usage
  exit 2
fi

BACKUP_DIR="$BACKUP_ROOT/$STAMP"
if [ ! -d "$BACKUP_DIR" ]; then
  echo "No harness backup found at: $BACKUP_DIR" >&2
  exit 1
fi

if [ "$DRY_RUN" -eq 1 ]; then
  :
fi

for item in CLAUDE.md settings.json known_marketplaces.json skills; do
  if [ -e "$BACKUP_DIR/$item" ] || [ -L "$BACKUP_DIR/$item" ]; then
    cp -RL "$BACKUP_DIR/$item" "$CLAUDE_DIR/" 2>/dev/null || true
    echo "restored $item from $STAMP"
  fi
done

echo "Restore complete: $STAMP"
