#!/usr/bin/env bash
# Pre-Bash firewall — blocks dangerous commands before execution
# Exit code 2 = hard block (cannot be overridden by agent instructions)

set -euo pipefail

COMMAND=$(cat | jq -r '.tool_input.command // empty')

BLOCKED_PATTERNS=(
  "rm -rf"
  "git push --force"
  "git push -f"
  "git reset --hard"
  "drop table"
  "DROP TABLE"
  "truncate"
  "TRUNCATE"
  "> /dev/"
  "chmod 777"
  "curl.*| bash"
  "wget.*| bash"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    echo "BLOCKED: Command contains dangerous pattern: $pattern" >&2
    jq -n '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: "Blocked by safety hook: dangerous command pattern detected"
      }
    }'
    exit 2
  fi
done

exit 0
