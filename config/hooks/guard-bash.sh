#!/usr/bin/env bash
# PreToolUse guard for the Bash tool. Exit 2 blocks the call and returns stderr
# to the model. Fails CLOSED: if the hook cannot run, the command is blocked.
# This is a safety net against mistakes, not a security boundary: shell
# variables, encoding, or indirection can still evade string matching.
set -u

block() { echo "BLOCKED by harness: $1" >&2; exit 2; }

command -v jq >/dev/null 2>&1 || block "jq is not installed, so harness hooks cannot run (install jq)"
cmd="$(jq -r '.tool_input.command // ""' 2>/dev/null)" || block "could not parse hook input"

# Normalize: newlines/tabs to spaces, drop quotes, squeeze whitespace. Wrappers such
# as `bash -c "..."` and `sudo` are covered because matching is not anchored.
norm="$(printf '%s' "$cmd" | tr '\n\t' '  ' | tr -d "\"'" | tr -s ' ')"

has() { [[ $norm =~ $1 ]]; }

pre='(^|[^[:alnum:]_./-])'

# 1. Force push: --force, --force-with-lease, short flag cluster containing f, +refspec.
if has "${pre}git +push( |\$)"; then
  has ' --force' && block "force push needs explicit human approval"
  has ' -[a-zA-Z]*f[a-zA-Z]*( |$)' && block "force push (-f) needs explicit human approval"
  has ' \+[^ ]' && block "force push (+refspec) needs explicit human approval"
fi

# 2. Skipping hooks or signing.
has ' --no-verify( |$)' && block "do not skip git hooks"
has ' --no-gpg-sign( |$)' && block "do not bypass commit signing"
if has "${pre}git +commit( |\$)"; then
  has ' -[a-zA-Z]*n[a-zA-Z]*( |$)' && block "git commit -n skips hooks"
fi

# 3. Recursive delete of root or home.
if has "${pre}rm +([^;&|]* )?(-[a-zA-Z]*[rR][a-zA-Z]*|--recursive)( |\\$)"; then
  has ' (/|/\*|~|~/|~/\*|\$HOME|\$\{HOME\}|\$HOME/|\$HOME/\*)( |$|[;&|])' \
    && block "recursive delete of root or home directory"
fi

# 4. Piping a download into a shell, and world-writable permissions.
has '(curl|wget)[^|;&]*\|[[:space:]]*(sudo +)?(ba|z|da)?sh( |$)' && block "do not pipe downloads into a shell"
has 'chmod +-R +[0-7]*777' && block "world-writable recursive chmod"

exit 0
