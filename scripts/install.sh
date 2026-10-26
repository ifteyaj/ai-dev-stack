#!/usr/bin/env bash
# Install the parts of the harness that this repository owns.
# Third-party tools use their documented installers (see integrations/).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
GLOBAL_RULES="$ROOT/config/global-rules.md"
BACKUP_ROOT="$CLAUDE_DIR/backups/harness"
STAMP="$(date +%Y%m%dT%H%M%S)"

DRY_RUN=0
BACKUP_ONLY=0
WITH_CUSTOM_SKILLS=0

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --dry-run             Print actions without changing anything.
  --backup-only         Back up ~/.claude configuration and exit.
  --with-custom-skills  Link skills/custom/* into ~/.claude/skills/.
  -h, --help            Show this help.

The installer owns only config/global-rules.md and (optionally) local custom
skills. It never installs third-party plugins or edits settings.json.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --backup-only) BACKUP_ONLY=1 ;;
    --with-custom-skills) WITH_CUSTOM_SKILLS=1 ;;
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

backup() {
  local dir="$BACKUP_ROOT/$STAMP"
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] back up %s to %s\n' "$CLAUDE_DIR" "$dir"
    return 0
  fi
  mkdir -p "$dir"
  for item in settings.json CLAUDE.md known_marketplaces.json skills; do
    if [ -e "$CLAUDE_DIR/$item" ] || [ -L "$CLAUDE_DIR/$item" ]; then
      cp -RL "$CLAUDE_DIR/$item" "$dir/" 2>/dev/null || true
    fi
  done
  printf 'Backup written: %s\n' "$dir"
}

backup
if [ "$BACKUP_ONLY" -eq 1 ]; then
  exit 0
fi

if [ ! -f "$GLOBAL_RULES" ]; then
  echo "Missing $GLOBAL_RULES" >&2
  exit 1
fi

run mkdir -p "$CLAUDE_DIR"
run mkdir -p "$CLAUDE_DIR/skills"

LINK="$CLAUDE_DIR/CLAUDE.md"
if [ -L "$LINK" ] && [ "$(readlink "$LINK")" = "$GLOBAL_RULES" ]; then
  echo "Global instructions already linked: $LINK -> $GLOBAL_RULES"
else
  if [ -e "$LINK" ] || [ -L "$LINK" ]; then
    # The backup above already captured it; remove only the link/file itself.
    run rm -f "$LINK"
  fi
  run ln -s "$GLOBAL_RULES" "$LINK"
  printf 'Global instructions linked: %s -> %s\n' "$LINK" "$GLOBAL_RULES"
fi

if [ "$WITH_CUSTOM_SKILLS" -eq 1 ]; then
  shopt -s nullglob
  for skill_dir in "$ROOT"/skills/custom/*/; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    name="$(basename "$skill_dir")"
    target="$CLAUDE_DIR/skills/$name"
    if [ -e "$target" ] || [ -L "$target" ]; then
      echo "Custom skill already exists, leaving it alone: $target"
      continue
    fi
    run ln -s "${skill_dir%/}" "$target"
    printf 'Custom skill linked: %s -> %s\n' "$target" "${skill_dir%/}"
  done
fi

cat <<EOF

Harness files installed.

Next steps (third-party tools are installed by their own mechanisms):
  1. EGM:      claude plugin marketplace add google/elephant-goldfish-model
               claude plugin install egm@egm
               claude plugin enable egm@egm
  2. Graphify: uv tool install graphifyy && graphify install --platform claude
  3. Matt:     claude plugin install mattpocock-skills@claude-plugins-official -y
  4. Taste:    claude plugin marketplace add Leonxlnx/taste-skill
               claude plugin install taste-skill@taste-skill
               claude plugin enable taste-skill@taste-skill
  5. Verify:   ./scripts/doctor.sh

Then read workflows/new-project.md.
EOF
