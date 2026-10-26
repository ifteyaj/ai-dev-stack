#!/usr/bin/env bash
# Run the harness acceptance tests.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAIL=0
for f in "$ROOT"/tests/test_*.sh; do
  [ -e "$f" ] || continue
  bash "$f" || FAIL=$((FAIL + 1))
done
[ "$FAIL" -eq 0 ] || { echo "test-harness: $FAIL failure(s)"; exit 1; }
echo "test-harness: all passed"
