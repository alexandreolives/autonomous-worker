#!/bin/bash
# Stop hook: Check if cycle should continue or complete
# Returns exit code 2 to block stop (continue cycle)
# Returns exit code 0 to allow stop (cycle complete)

STATE_FILE="${CLAUDE_PROJECT_DIR}/.autonomous-worker/state.json"

# If no state file, allow stop (no active cycle)
if [ ! -f "$STATE_FILE" ]; then
    exit 0
fi

# Read state
current_iteration=$(jq -r '.iteration // 0' "$STATE_FILE")
total_iterations=$(jq -r '.total_iterations // 0' "$STATE_FILE")
phase=$(jq -r '.phase // "unknown"' "$STATE_FILE")
status=$(jq -r '.status // "unknown"' "$STATE_FILE")

# If already complete, allow stop
if [ "$status" = "complete" ]; then
    exit 0
fi

# If phase is "complete", allow stop
if [ "$phase" = "complete" ]; then
    exit 0
fi

# If we haven't completed all iterations, block stop
if [ "$current_iteration" -lt "$total_iterations" ]; then
    # Check for P0 tickets
    p0_count=$(find "${CLAUDE_PROJECT_DIR}/.autonomous-worker/tickets/P0-critical" -name "*.md" 2>/dev/null | wc -l)

    if [ "$p0_count" -gt 5 ]; then
        # Too many P0 tickets, pause for intervention
        echo "{\"decision\": \"allow\", \"reason\": \"Too many P0 tickets ($p0_count). Pausing for manual intervention.\"}" >&2
        exit 0
    fi

    # Continue cycle
    echo "{\"decision\": \"block\", \"reason\": \"Cycle in progress: iteration $current_iteration/$total_iterations, phase: $phase\"}" >&2
    exit 2
fi

# All iterations complete, allow stop
exit 0
