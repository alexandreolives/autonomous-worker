#!/bin/bash
# PreToolUse hook: Log when Task tool spawns an agent

LOG_FILE="${CLAUDE_PROJECT_DIR}/.autonomous-worker/cycle-log.md"

# Create log file if needed
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

# Read tool input from stdin
input=$(cat)
description=$(echo "$input" | jq -r '.tool_input.description // "unknown"')
subagent_type=$(echo "$input" | jq -r '.tool_input.subagent_type // "unknown"')
timestamp=$(date -Iseconds)

# Log agent spawn
echo "[$timestamp] Spawning agent: $subagent_type - $description" >> "$LOG_FILE"

# Allow the tool to proceed
exit 0
