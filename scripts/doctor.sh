#!/usr/bin/env bash
# Report harness problems. This script never changes the system.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
OPENCODE_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
PROJECT="${1:-}"

PASS=0
WARN=0
FAIL=0

ok()   { PASS=$((PASS + 1)); printf '  [ok]   %s\n' "$*"; }
warn() { WARN=$((WARN + 1)); printf '  [warn] %s\n' "$*"; }
bad()  { FAIL=$((FAIL + 1)); printf '  [fail] %s\n' "$*"; }
section() { printf '\n%s\n' "$*"; }

expected_plugin_version() {
  case "$1" in
    egm@egm) printf '%s' "0.1.0" ;;
    mattpocock-skills@claude-plugins-official) printf '%s' "1.3.1" ;;
    taste-skill@taste-skill) printf '%s' "2.1.5" ;;
    *) printf '%s' "" ;;
  esac
}

section "Harness repository"
[ -f "$ROOT/config/global-rules.md" ] && ok "config/global-rules.md exists" || bad "config/global-rules.md missing"
[ -f "$ROOT/integrations/upstream-repositories.md" ] && ok "integration register exists" || bad "integration register missing"
for f in "$ROOT"/scripts/*.sh; do
  bash -n "$f" 2>/dev/null && ok "syntax: $(basename "$f")" || bad "syntax error: $(basename "$f")"
done
[ -f "$ROOT/workflows/opencode.md" ] && head -1 "$ROOT/workflows/opencode.md" | grep -q '^# Workflow:' && ok "workflows/opencode.md is a harness workflow" || bad "workflows/opencode.md is not a harness workflow"

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

if [ -L "$CLAUDE_DIR/config" ]; then
  target="$(readlink "$CLAUDE_DIR/config")"
  if [ "$target" = "$ROOT/config" ]; then
    ok "portable standards link to this repository"
  else
    warn "portable standards link elsewhere: $target"
  fi
elif [ -d "$CLAUDE_DIR/config" ]; then
  warn "portable standards path is a directory, not the harness symlink"
else
  bad "portable standards missing; run ./scripts/install.sh"
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
  plugin_json="$(claude plugin list --json 2>/dev/null || true)"
  if [ -z "$plugin_json" ]; then
    bad "claude plugin list returned no JSON"
  else
    for plugin in egm@egm mattpocock-skills@claude-plugins-official taste-skill@taste-skill; do
      meta="$(printf '%s' "$plugin_json" | python3 -c '
import json, sys
plugins = {p["id"]: p for p in json.load(sys.stdin)}
plugin = plugins.get(sys.argv[1])
if plugin is None:
    print("missing|")
else:
    print(("enabled" if plugin.get("enabled") else "disabled") + "|" + str(plugin.get("version", "")))
' "$plugin" 2>/dev/null)"
      state="${meta%%|*}"
      version="${meta#*|}"
      expected="$(expected_plugin_version "$plugin")"
      if [ "$state" = "enabled" ]; then
        if [ -n "$expected" ] && [ "$version" != "$expected" ]; then
          warn "plugin version changed: $plugin (installed $version, register $expected)"
        else
          ok "plugin enabled: $plugin${version:+ ($version)}"
        fi
      elif [ "$state" = "disabled" ]; then
        bad "plugin installed but not enabled: $plugin"
      else
        bad "plugin not installed: $plugin"
      fi
    done
  fi
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

section "Dependencies"
if command -v jq >/dev/null 2>&1; then
  ok "jq on PATH ($(jq --version 2>/dev/null | head -1))"
else
  warn "jq not found on PATH (needed for settings/hooks baseline)"
fi

section "OpenCode"
if command -v opencode >/dev/null 2>&1; then
  ok "opencode on PATH ($(opencode --version 2>/dev/null | head -1))"
else
  warn "opencode not found on PATH"
fi
if [ -d "$OPENCODE_DIR" ]; then
  if [ -L "$OPENCODE_DIR/AGENTS.md" ]; then
    target="$(readlink "$OPENCODE_DIR/AGENTS.md")"
    if [ "$target" = "$ROOT/config/global-rules.md" ]; then
      ok "OpenCode global AGENTS.md links to this repository"
    else
      warn "OpenCode global AGENTS.md links elsewhere: $target"
    fi
  elif [ -f "$OPENCODE_DIR/AGENTS.md" ]; then
    warn "OpenCode global AGENTS.md is a regular file, not the harness symlink"
  else
    bad "OpenCode global AGENTS.md missing"
  fi
else
  warn "OpenCode config directory not present; run ./scripts/install.sh --with-opencode"
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
  # Custom harness checks are available through scripts/check-harness.sh
  [ -x "$ROOT/scripts/check-harness.sh" ] && ok "scripts/check-harness.sh present" || warn "scripts/check-harness.sh missing or not executable"
else
  warn "harness is not a git repository"
fi

if [ -n "$PROJECT" ]; then
  section "Project: $PROJECT"
  if [ -d "$PROJECT" ]; then
    [ -f "$PROJECT/CLAUDE.md" ] && ok "project CLAUDE.md exists" || warn "project CLAUDE.md missing"
    [ -f "$PROJECT/AGENTS.md" ] && ok "project AGENTS.md exists" || warn "project AGENTS.md missing"
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
