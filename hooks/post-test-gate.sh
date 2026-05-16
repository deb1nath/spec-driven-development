#!/usr/bin/env bash
# PreToolUse hook on Bash — blocks git commit if tests are failing
# Exit code 2 = hard block

set -euo pipefail

COMMAND=$(cat | jq -r '.tool_input.command // empty')

# Only trigger on git commit commands
if ! echo "$COMMAND" | grep -q "git commit"; then
  exit 0
fi

# Run tests quietly
if ! ./gradlew test --quiet 2>/dev/null; then
  echo "BLOCKED: Tests are failing. Fix tests before committing." >&2
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Tests must pass before committing. Run ./gradlew test to see failures."
    }
  }'
  exit 2
fi

exit 0
