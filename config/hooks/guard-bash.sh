#!/usr/bin/env bash
set -u
cmd="$(jq -r '.tool_input.command // ""')"
block() { echo "BLOCKED by harness: $1" >&2; exit 2; }

case "$cmd" in
  *"git push"*"--force"*|*"git push -f"*) block "force push needs explicit human approval" ;;
  *"--no-verify"*)                         block "do not skip git hooks" ;;
  *"git commit"*"--no-gpg-sign"*)          block "do not bypass signing" ;;
  *"chmod -R 777"*)                        block "world-writable recursive chmod" ;;
esac
exit 0