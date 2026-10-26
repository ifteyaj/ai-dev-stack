#!/usr/bin/env bash
# Report harness problems. This script never changes the system.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
PROJECT="${1:-}"

PASS=0
WARN=0
FAIL=0

ok()   { PASS=$((PASS + 1)); printf '  [ok]   %s\n' "$*"; }
warn() { WARN=$((WARN + 1)); printf '  [warn] %s\n' "$*"; }
bad()  { FAIL=$((FAIL + 1)); printf '  [fail] %s\n' "$*"; }
section() { printf '\n%s\n' "$*"; }

section "Harness repository"
[ -f "$ROOT/config/global-rules.md" ] && ok "config/global-rules.md exists" || bad "config/global-rules.md missing"
[ -f "$ROOT/integrations/upstream-repositories.md" ] && ok "integration register exists" || bad "integration register missing"
for f in "$ROOT"/scripts/*.sh; do
  bash -n "$f" 2>/dev/null && ok "syntax: $(basename "$f")" || bad "syntax error: $(basename "$f")"
done

section "Claude Code"
if command -v claude >/dev/null 2>&1; then
  ok "claude on PATH ($(claude --version 2>/dev/null | head -1))"
else
  bad "claude not found on PATH"
fi
[ -d "$CLAUDE_DIR" ] && ok "$CLAUDE_DIR exists" || bad "$CLAUDE_DIR missing"

if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
  target="$(readlink "$CLAUDE_DIR/CLAUDE.md")"
  if [ "$target" = "$ROOT/config/global-rules.md" ]; then
    ok "global CLAUDE.md links to this repository"
  else
    warn "global CLAUDE.md links elsewhere: $target"
  fi
elif [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  warn "global CLAUDE.md is a regular file, not the harness symlink"
else
  bad "global CLAUDE.md missing"
fi

if [ -f "$CLAUDE_DIR/settings.json" ]; then
  python3 -m json.tool "$CLAUDE_DIR/settings.json" >/dev/null 2>&1 \
    && ok "settings.json is valid JSON" \
    || bad "settings.json is not valid JSON"
else
  warn "settings.json missing"
fi

section "Plugins"
if command -v claude >/dev/null 2>&1; then
  plugin_list="$(claude plugin list 2>/dev/null || true)"
  for plugin in egm mattpocock-skills taste-skill; do
    if printf '%s\n' "$plugin_list" | grep -q "$plugin"; then
      if printf '%s\n' "$plugin_list" | grep -A4 "$plugin" | grep -q "enabled"; then
        ok "plugin enabled: $plugin"
      else
        warn "plugin installed but not enabled: $plugin"
      fi
    else
      bad "plugin not installed: $plugin"
    fi
  done
fi

section "Graphify"
if command -v graphify >/dev/null 2>&1; then
  ok "graphify on PATH ($(graphify --version 2>/dev/null | head -1))"
  [ -f "$CLAUDE_DIR/skills/graphify/SKILL.md" ] \
    && ok "graphify skill installed" \
    || bad "graphify skill missing"
else
  bad "graphify not found on PATH"
fi

section "Repository hygiene"
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  ok "git repository detected"
  if git -C "$ROOT" diff --cached --name-only | grep -Eq '(^|/)\.env$|(^|/)\.env\.(local|production)$|\.pem$|\.key$'; then
    bad "possible secret staged for commit"
  else
    ok "no obvious secret files staged"
  fi
  if git -C "$ROOT" check-ignore -q .DS_Store 2>/dev/null; then
    ok ".DS_Store ignored"
  else
    warn ".DS_Store is not ignored"
  fi
else
  warn "harness is not a git repository"
fi

if [ -n "$PROJECT" ]; then
  section "Project: $PROJECT"
  if [ -d "$PROJECT" ]; then
    [ -f "$PROJECT/CLAUDE.md" ] && ok "project CLAUDE.md exists" || warn "project CLAUDE.md missing"
    for doc in PRODUCT.md REQUIREMENTS.md ARCHITECTURE.md DECISIONS.md CURRENT-STATUS.md; do
      [ -f "$PROJECT/docs/$doc" ] && ok "docs/$doc exists" || warn "docs/$doc missing"
    done
    [ -d "$PROJECT/docs/designs" ] && ok "docs/designs exists" || warn "docs/designs missing"
    if [ -d "$PROJECT/.git" ]; then
      dirty="$(git -C "$PROJECT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
      [ "$dirty" -eq 0 ] && ok "project working tree clean" || warn "project has $dirty uncommitted change(s)"
    fi
    if [ -f "$PROJECT/graphify-out/graph.json" ]; then
      ok "graphify graph exists"
      built="$(sed -n 's/.*Built from commit: `\([0-9a-f]*\)`.*/\1/p' "$PROJECT/graphify-out/GRAPH_REPORT.md" 2>/dev/null | head -1)"
      current="$(git -C "$PROJECT" rev-parse HEAD 2>/dev/null || true)"
      case "$current" in
        "$built"*) ok "graphify graph matches current HEAD (${built:0:8})" ;;
        *) warn "graphify graph may be stale (built ${built:-unknown}, HEAD ${current:0:8}); run: graphify update ." ;;
      esac
    else
      warn "no graphify-out/graph.json; run: graphify extract . --code-only"
    fi
  else
    bad "project path does not exist: $PROJECT"
  fi
fi

printf '\nSummary: %d ok, %d warning(s), %d failure(s)\n' "$PASS" "$WARN" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
