#!/usr/bin/env bash
# Remove symlinks installed by install.sh, then restore the latest backup.
# Never touches files that were not created or backed up by the harness.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
OPENCODE_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
BACKUP_ROOT="$CLAUDE_DIR/backups/harness"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./scripts/uninstall.sh [--dry-run]

Removes only symlinks that point into this repository, and restores the
latest harness backup from ~/.claude/backups/harness/.
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

remove_link() {
  local link="$1" target="$2"
  if [ -L "$link" ]; then
    if [ "$(readlink "$link")" = "$target" ]; then
      if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] rm %s -> %s\n' "$link" "$target"
      else
        rm -f "$link"
        printf 'removed symlink %s\n' "$link"
      fi
    else
      echo "leaving untouched (points elsewhere): $link"
    fi
  fi
}

remove_link "$CLAUDE_DIR/CLAUDE.md" "$ROOT/config/global-rules.md"
remove_link "$CLAUDE_DIR/config" "$ROOT/config"
remove_link "$OPENCODE_DIR/AGENTS.md" "$ROOT/config/global-rules.md"
remove_link "$CLAUDE_DIR/settings.json" "$ROOT/config/settings.baseline.json"

rm_links() {
  local dir="$CLAUDE_DIR/skills"
  if [ -d "$dir" ]; then
    for skill in "$dir"/*; do
      [ -L "$skill" ] || continue
      local target
      target="$(readlink "$skill")"
      case "$target" in
        "$ROOT/skills/custom/"*)
          if [ "$DRY_RUN" -eq 1 ]; then
            printf '[dry-run] rm %s\n' "$skill"
          else
            rm -f "$skill"
            printf 'removed skill link %s\n' "$skill"
          fi
          ;;
      esac
    done
  fi
}
rm_links

LATEST=""; for d in "$BACKUP_ROOT"/*/; do [ -d "$d" ] && LATEST="$d"; done
if [ -n "$LATEST" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] restore backup: %s -> %s\n' "$LATEST" "$CLAUDE_DIR"
  else
    for item in CLAUDE.md settings.json known_marketplaces.json skills; do
      if [ -e "$LATEST/$item" ] || [ -L "$LATEST/$item" ]; then
        cp -RL "$LATEST/$item" "$CLAUDE_DIR/" 2>/dev/null || true
        printf 'restored %s\n' "$item"
      fi
    done
    printf 'Restore applied from %s\n' "$LATEST"
  fi
else
  echo "No harness backup found in $BACKUP_ROOT; nothing to restore."
fi

echo
echo "Uninstall complete. (dry-run: $DRY_RUN)"
