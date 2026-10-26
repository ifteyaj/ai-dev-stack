#!/usr/bin/env bash
# Report harness problems. This script never changes the system.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
OPENCODE_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
PROJECTS=()
ALL=0
LOCK="$ROOT/integrations/lock.json"

usage() {
  cat <<'EOF'
Usage: ./scripts/doctor.sh [options] [project...]

Checks the machine, harness, and project(s). Options:
  --all            Check the projects registered in projects/README.md.
  --project <dir>  Add a project directory to check. May be repeated.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --all|-a) ALL=1 ;;
    --project) shift; [ $# -gt 0 ] && PROJECTS+=("$1") || { echo "missing argument for --project" >&2; exit 2; } ;;
    -h|--help) usage; exit 0 ;;
    --) shift; break ;;
    *) PROJECTS+=("$1") ;;
  esac
  shift
done

if [ "$ALL" -eq 1 ]; then
  while IFS= read -r p; do
    [ -n "$p" ] && PROJECTS+=("$p")
  done < <(sed -n 's/.*`\(~\/[^`]*\)`.*/\1/p' "$ROOT/projects/README.md" | sort -u)
fi

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

plugin_state() {
  printf '%s' "$plugin_json" | python3 -c '
import json, sys
plugins = {p["id"]: p for p in json.load(sys.stdin)}
plugin = plugins.get(sys.argv[1])
if plugin is None:
    print("missing|")
else:
    print(("enabled" if plugin.get("enabled") else "disabled") + "|" + str(plugin.get("version", "")))
' "$1" 2>/dev/null
}

section "Machine"
if command -v claude >/dev/null 2>&1; then
  ok "claude on PATH ($(claude --version 2>/dev/null | head -1))"
else
  bad "claude not found on PATH"
fi
if command -v opencode >/dev/null 2>&1; then
  ok "opencode on PATH ($(opencode --version 2>/dev/null | head -1))"
else
  warn "opencode not found on PATH"
fi
if command -v jq >/dev/null 2>&1; then
  ok "jq on PATH ($(jq --version 2>/dev/null | head -1))"
else
  warn "jq not found on PATH (needed for settings/hooks baseline)"
fi
if command -v uv >/dev/null 2>&1; then
  ok "uv on PATH ($(uv --version 2>/dev/null | head -1))"
else
  warn "uv not found on PATH"
fi
if command -v git >/dev/null 2>&1; then
  ok "git on PATH ($(git --version 2>/dev/null | head -1))"
else
  bad "git not found on PATH"
fi
if command -v graphify >/dev/null 2>&1; then
  ok "graphify on PATH ($(graphify --version 2>/dev/null | head -1))"
else
  bad "graphify not found on PATH"
fi
[ -d "$CLAUDE_DIR" ] && ok "$CLAUDE_DIR exists" || bad "$CLAUDE_DIR missing"

section "Harness"
[ -f "$ROOT/config/global-rules.md" ] && ok "config/global-rules.md exists" || bad "config/global-rules.md missing"
[ -f "$ROOT/integrations/upstream-repositories.md" ] && ok "integration register exists" || bad "integration register missing"
for f in "$ROOT"/scripts/*.sh; do
  bash -n "$f" 2>/dev/null && ok "syntax: $(basename "$f")" || bad "syntax error: $(basename "$f")"
done
[ -f "$ROOT/workflows/opencode.md" ] && head -1 "$ROOT/workflows/opencode.md" | grep -q '^# Workflow:' && ok "workflows/opencode.md is a harness workflow" || bad "workflows/opencode.md is not a harness workflow"

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
plugin_json=""
if command -v claude >/dev/null 2>&1; then
  plugin_json="$(claude plugin list --json 2>/dev/null || true)"
  if [ -z "$plugin_json" ]; then
    bad "claude plugin list returned no JSON"
  else
    for plugin in egm@egm mattpocock-skills@claude-plugins-official taste-skill@taste-skill; do
      meta="$(plugin_state "$plugin")"
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
else
  bad "claude not found on PATH"
fi

section "Lock comparison"
if [ -f "$LOCK" ]; then
  if command -v jq >/dev/null 2>&1; then
    for spec in "egm:egm@egm" "matt:mattpocock-skills@claude-plugins-official" "taste:taste-skill@taste-skill"; do
      key="${spec%%:*}"
      plugin_id="${spec#*:}"
      locked="$(jq -r ".tools.$key.version // empty" "$LOCK" 2>/dev/null)"
      [ -n "$plugin_json" ] || continue
      installed="$(printf '%s' "$plugin_json" | python3 -c 'import json,sys; plugins={p["id"]:p for p in json.load(sys.stdin)}; p=plugins.get(sys.argv[1]); print(p.get("version","") if p else "")' "$plugin_id" 2>/dev/null)"
      if [ -n "$locked" ] && [ -n "$installed" ] && [ "$locked" != "$installed" ]; then
        warn "lock drift: $plugin_id installed $installed, locked $locked"
      fi
    done
    locked_graphify="$(jq -r '.tools.graphify.version // empty' "$LOCK" 2>/dev/null)"
    if [ -n "$locked_graphify" ] && command -v graphify >/dev/null 2>&1; then
      installed_graphify="$(graphify --version 2>/dev/null | sed -n 's/.* \([0-9][0-9.]*\)$/\1/p' | head -1)"
      if [ -n "$installed_graphify" ] && [ "$locked_graphify" != "$installed_graphify" ]; then
        warn "lock drift: graphify installed $installed_graphify, locked $locked_graphify"
      fi
    fi
    ok "lock file present and checked"
  else
    warn "jq not found; skipping lock comparison"
  fi
else
  warn "lock file missing: $LOCK"
fi

section "Graphify"
if command -v graphify >/dev/null 2>&1; then
  [ -f "$CLAUDE_DIR/skills/graphify/SKILL.md" ] \
    && ok "graphify skill installed" \
    || bad "graphify skill missing"
else
  bad "graphify not found on PATH"
fi

section "OpenCode"
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
  [ -x "$ROOT/scripts/check-harness.sh" ] && ok "scripts/check-harness.sh present" || warn "scripts/check-harness.sh missing or not executable"
else
  warn "harness is not a git repository"
fi

check_project() {
  local project="$1"
  if [ ! -d "$project" ]; then
    bad "project path does not exist: $project"
    return
  fi
  [ -f "$project/CLAUDE.md" ] && ok "project CLAUDE.md exists" || warn "project CLAUDE.md missing"
  [ -f "$project/AGENTS.md" ] && ok "project AGENTS.md exists" || warn "project AGENTS.md missing"
  for doc in PRODUCT.md REQUIREMENTS.md ARCHITECTURE.md DECISIONS.md CURRENT-STATUS.md; do
    [ -f "$project/docs/$doc" ] && ok "docs/$doc exists" || warn "docs/$doc missing"
  done
  [ -d "$project/docs/designs" ] && ok "docs/designs exists" || warn "docs/designs missing"
  if [ -d "$project/.git" ]; then
    local dirty
    dirty="$(git -C "$project" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
    [ "$dirty" -eq 0 ] && ok "project working tree clean" || warn "project has $dirty uncommitted change(s)"
    local current_status
    current_status="$project/docs/CURRENT-STATUS.md"
    if [ -f "$current_status" ]; then
      local st_mtime newest_commit
      if stat -c '%Y' "$current_status" >/dev/null 2>&1; then
        st_mtime="$(stat -c '%Y' "$current_status")"
      else
        st_mtime="$(stat -f '%m' "$current_status")"
      fi
      newest_commit="$(git -C "$project" log -1 --format='%ct' 2>/dev/null || true)"
      if [ -n "$newest_commit" ] && [ "$newest_commit" -gt "$((st_mtime + 7 * 86400))" ] 2>/dev/null; then
        warn "CURRENT-STATUS.md is older than the newest commit by more than 7 days"
      fi
    fi
  fi
  if [ -f "$project/graphify-out/graph.json" ]; then
    ok "graphify graph exists"
    local built current
    built="$(sed -n 's/.*Built from commit: `\([0-9a-f]*\)`.*/\1/p' "$project/graphify-out/GRAPH_REPORT.md" 2>/dev/null | head -1)"
    current="$(git -C "$project" rev-parse HEAD 2>/dev/null || true)"
    case "$current" in
      "$built"*) ok "graphify graph matches current HEAD (${built:0:8})" ;;
      *) warn "graphify graph may be stale (built ${built:-unknown}, HEAD ${current:0:8}); run: graphify update ." ;;
    esac
  else
    warn "no graphify-out/graph.json; run: graphify extract . --code-only"
  fi
}

if [ "${#PROJECTS[@]}" -gt 0 ]; then
  section "Project checks"
  for pth in "${PROJECTS[@]}"; do
    printf '\n-- %s\n' "$pth"
    check_project "$pth"
  done
fi

printf '\nSummary: %d ok, %d warning(s), %d failure(s)\n' "$PASS" "$WARN" "$FAIL"
if [ "$FAIL" -gt 0 ]; then
  exit 2
elif [ "$WARN" -gt 0 ]; then
  exit 1
else
  exit 0
fi
