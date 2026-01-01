#!/bin/bash
# SubagentStop hook: Collect results from completed subagent
# Aggregates findings and updates state

RESULTS_DIR="${CLAUDE_PROJECT_DIR}/.autonomous-worker/agent-results"
LOG_FILE="${CLAUDE_PROJECT_DIR}/.autonomous-worker/cycle-log.md"

# Create results directory if needed
mkdir -p "$RESULTS_DIR"

# Read subagent info from stdin
input=$(cat)
agent_type=$(echo "$input" | jq -r '.agent_type // "unknown"')
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
timestamp=$(date -Iseconds)

# Log agent completion
echo "[$timestamp] Agent completed: $agent_type (session: $session_id)" >> "$LOG_FILE"

# Save result for aggregation
result_file="$RESULTS_DIR/${agent_type}-${session_id}.json"
echo "$input" > "$result_file"

# Count completed agents
completed_count=$(ls -1 "$RESULTS_DIR"/*.json 2>/dev/null | wc -l)

# Update state with agent count
STATE_FILE="${CLAUDE_PROJECT_DIR}/.autonomous-worker/state.json"
if [ -f "$STATE_FILE" ]; then
    jq --arg count "$completed_count" '.completed_agents = ($count | tonumber)' "$STATE_FILE" > "$STATE_FILE.tmp"
    mv "$STATE_FILE.tmp" "$STATE_FILE"
fi

exit 0
