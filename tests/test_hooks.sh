#!/usr/bin/env bash
# Acceptance tests for the harness enforcement hooks.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS="$ROOT/config/hooks"
FAIL=0
pass() { printf '  [ok]   %s\n' "$*"; }
fail() { FAIL=$((FAIL + 1)); printf '  [fail] %s\n' "$*"; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# guard-bash blocks force push
printf '{"tool_input":{"command":"git push --force origin main"}}' | "$HOOKS/guard-bash.sh" >/dev/null 2>&1
[ $? -eq 2 ] && pass "guard blocks force push" || fail "guard did not block force push"

# guard-bash allows ordinary commands
printf '{"tool_input":{"command":"git status"}}' | "$HOOKS/guard-bash.sh" >/dev/null 2>&1
[ $? -eq 0 ] && pass "guard allows ordinary command" || fail "guard blocked ordinary command"

# secret-scan blocks an AWS-style key
secret_file="$tmp/secret.txt"
printf 'AKIA1234567890ABCDEF\n' > "$secret_file"
printf '{"tool_input":{"file_path":"%s"}}' "$secret_file" | "$HOOKS/secret-scan.sh" >/dev/null 2>&1
[ $? -eq 2 ] && pass "secret-scan blocks AWS-style key" || fail "secret-scan did not block AWS-style key"

# secret-scan ignores missing files
printf '{"tool_input":{"file_path":"%s/nope.txt"}}' "$tmp" | "$HOOKS/secret-scan.sh" >/dev/null 2>&1
[ $? -eq 0 ] && pass "secret-scan ignores missing file" || fail "secret-scan failed on missing file"

if [ "$FAIL" -eq 0 ]; then
  echo "test_hooks: PASS"
else
  echo "test_hooks: $FAIL failure(s)"
  exit 1
fi
