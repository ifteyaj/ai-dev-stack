#!/usr/bin/env bash
# Structural checks for the harness. Never changes the system.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAIL=0
ok() { printf '  [ok]   %s\n' "$*"; }
bad() { FAIL=$((FAIL + 1)); printf '  [fail] %s\n' "$*"; }

section() { printf '\n%s\n' "$*"; }

section "Required files"
required_files=(
  "config/global-rules.md"
  "config/coding-standards.md"
  "config/design-standards.md"
  "config/safety.md"
  "AGENTS.md"
  "CLAUDE.md"
  "README.md"
  "workflows/tool-adapters.md"
  "workflows/opencode.md"
  "templates/project-claude.md"
  "templates/project-opencode-agents.md"
  "projects/README.md"
)
for f in "${required_files[@]}"; do
  [ -f "$ROOT/$f" ] && ok "$f exists" || bad "$f missing"
done

section "Script syntax"
for f in "$ROOT"/scripts/*.sh; do
  bash -n "$f" 2>/dev/null && ok "syntax: $(basename "$f")" || bad "syntax error: $(basename "$f")"
done

section "Workflow shape"
head -1 "$ROOT/workflows/opencode.md" | grep -q '^# Workflow:' \
  && ok "workflows/opencode.md is a harness workflow" \
  || bad "workflows/opencode.md is not a harness workflow"
if grep -R "agentic-cicd" "$ROOT/workflows/opencode.md" "$ROOT/templates" "$ROOT/config" "$ROOT/CLAUDE.md" "$ROOT/AGENTS.md" >/dev/null 2>&1; then
  bad "pilot-specific references found in generic adapter docs/config"
else
  ok "no pilot-specific references in generic adapter docs/config"
fi

section "Template parity"
for t in project-claude.md project-opencode-agents.md; do
  grep -q 'harness-parity: project-adapter v1' "$ROOT/templates/$t" \
    && ok "$t has parity marker" \
    || bad "$t missing parity marker"
done

section "Project schema marker"
grep -q 'Harness schema:' "$ROOT/projects/README.md" \
  && ok "projects/README.md declares a harness schema" \
  || bad "projects/README.md missing harness schema marker"

section "Repository hygiene"
if git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  tracked_bad="$(git -C "$ROOT" ls-files | grep -E '(^|/)\.DS_Store$|(^|/)\.env$|(^|/)\.env\.(local|production)$|\.pem$|\.key$' || true)"
  if [ -n "$tracked_bad" ]; then
    bad "tracked secret or OS-noise file: $tracked_bad"
  else
    ok "no tracked .DS_Store or secret-ish files"
  fi
else
  bad "not a git repository"
fi

printf '\ncheck-harness: %d failure(s)\n' "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
