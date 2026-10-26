#!/usr/bin/env bash
# PostToolUse scan for Edit|Write. Exit 2 reports the problem to the model.
# Fails CLOSED if jq is missing. Never prints the matched secret itself, only
# line numbers, so the secret does not land in the session transcript.
set -u

block() { echo "BLOCKED by harness: $1" >&2; exit 2; }

command -v jq >/dev/null 2>&1 || block "jq is not installed, so harness hooks cannot run (install jq)"
f="$(jq -r '.tool_input.file_path // ""' 2>/dev/null)" || block "could not parse hook input"

[ -n "$f" ] && [ -f "$f" ] || exit 0

pattern='AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{40,}|sk-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----'

lines="$(grep -InE "$pattern" "$f" 2>/dev/null | cut -d: -f1 | paste -sd, -)"
if [ -n "$lines" ]; then
  block "possible secret in $f (line(s): $lines). Remove it, rotate it if it was real, and use .env.example for placeholders."
fi
exit 0
