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
WITH_OPENCODE=0
WITH_SETTINGS=0

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --dry-run             Print actions without changing anything.
  --backup-only         Back up ~/.claude configuration and exit.
  --with-custom-skills  Link skills/custom/* into ~/.claude/skills/.
  --with-opencode       Link OpenCode AGENTS.md to the shared global rules.
  --with-settings       Merge config/settings.baseline.json into ~/.claude/settings.json
                        (never overwrites; backs up first).
  -h, --help            Show this help.

The installer owns only config/global-rules.md and (optionally) local custom
skills and settings. It never installs third-party plugins or edits settings.json.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --backup-only) BACKUP_ONLY=1 ;;
    --with-custom-skills) WITH_CUSTOM_SKILLS=1 ;;
    --with-opencode) WITH_OPENCODE=1 ;;
    --with-settings) WITH_SETTINGS=1 ;;
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

# Expose the portable standards directory alongside the global rules.
CONFIG_LINK="$CLAUDE_DIR/config"
if [ -L "$CONFIG_LINK" ] && [ "$(readlink "$CONFIG_LINK")" = "$ROOT/config" ]; then
  echo "Harness standards already linked: $CONFIG_LINK -> $ROOT/config"
elif [ -e "$CONFIG_LINK" ] || [ -L "$CONFIG_LINK" ]; then
  echo "Harness standards path already exists, leaving it alone: $CONFIG_LINK" >&2
else
  run ln -s "$ROOT/config" "$CONFIG_LINK"
  printf 'Harness standards linked: %s -> %s\n' "$CONFIG_LINK" "$ROOT/config"
fi

if [ "$WITH_OPENCODE" -eq 1 ]; then
  OPENCODE_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
  run mkdir -p "$OPENCODE_DIR"
  OC_LINK="$OPENCODE_DIR/AGENTS.md"
  if [ -L "$OC_LINK" ] && [ "$(readlink "$OC_LINK")" = "$GLOBAL_RULES" ]; then
    echo "OpenCode instructions already linked: $OC_LINK -> $GLOBAL_RULES"
  else
    if [ -e "$OC_LINK" ] || [ -L "$OC_LINK" ]; then
      run rm -f "$OC_LINK"
    fi
    run ln -s "$GLOBAL_RULES" "$OC_LINK"
    printf 'OpenCode instructions linked: %s -> %s\n' "$OC_LINK" "$GLOBAL_RULES"
  fi
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

if [ "$WITH_SETTINGS" -eq 1 ]; then
  if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required for --with-settings" >&2; exit 1
  fi
  if [ ! -f "$ROOT/config/settings.baseline.json" ]; then
    echo "Missing $ROOT/config/settings.baseline.json" >&2
    exit 1
  fi
  backup_settings() {
    local dir="$BACKUP_ROOT/$STAMP-settings"
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '[dry-run] back up %s to %s\n' "$CLAUDE_DIR/settings.json" "$dir"
      return 0
    fi
    mkdir -p "$dir"
    if [ -e "$CLAUDE_DIR/settings.json" ] || [ -L "$CLAUDE_DIR/settings.json" ]; then
      cp -RL "$CLAUDE_DIR/settings.json" "$dir/" 2>/dev/null || true
    fi
    printf 'Settings backup written: %s\n' "$dir"
  }
  backup_settings
  if [ "$DRY_RUN" -eq 0 ]; then
    if [ -f "$CLAUDE_DIR/settings.json" ]; then
      jq -s '.[0] * .[1]' "$ROOT/config/settings.baseline.json" "$CLAUDE_DIR/settings.json" > "$CLAUDE_DIR/settings.json.tmp"
      mv "$CLAUDE_DIR/settings.json.tmp" "$CLAUDE_DIR/settings.json"
      printf 'Settings merged: config/settings.baseline.json + existing ~/.claude/settings.json\n'
    else
      cp "$ROOT/config/settings.baseline.json" "$CLAUDE_DIR/settings.json"
      printf 'Settings installed: config/settings.baseline.json -> ~/.claude/settings.json\n'
    fi
  fi
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
