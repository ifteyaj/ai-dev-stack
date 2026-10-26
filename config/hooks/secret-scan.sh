#!/usr/bin/env bash
set -u
f="$(jq -r '.tool_input.file_path // ""')"
[ -f "$f" ] || exit 0
if grep -nE 'AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36}|sk-[A-Za-z0-9]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY-----' "$f" >&2; then
  echo "BLOCKED: possible secret written to $f. Remove it and use .env.example." >&2
  exit 2
fi
exit 0