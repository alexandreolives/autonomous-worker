#!/bin/bash
# SessionStart hook: Load project context and active cycle state

STATE_FILE="${CLAUDE_PROJECT_DIR}/.autonomous-worker/state.json"
CONTEXT_OUTPUT=""

# Check for active cycle
if [ -f "$STATE_FILE" ]; then
    task=$(jq -r '.current_task // ""' "$STATE_FILE")
    iteration=$(jq -r '.iteration // 0' "$STATE_FILE")
    total=$(jq -r '.total_iterations // 0' "$STATE_FILE")
    phase=$(jq -r '.phase // ""' "$STATE_FILE")

    if [ -n "$task" ] && [ "$phase" != "complete" ]; then
        CONTEXT_OUTPUT="[AUTONOMOUS WORKER] Active cycle detected:
Task: $task
Progress: Iteration $iteration/$total
Phase: $phase

Resume with the cycle command or use /aw:status for details."
    fi
fi

# Count pending tickets
P0_COUNT=$(find "${CLAUDE_PROJECT_DIR}/.autonomous-worker/tickets/P0-critical" -name "*.md" 2>/dev/null | wc -l)
P1_COUNT=$(find "${CLAUDE_PROJECT_DIR}/.autonomous-worker/tickets/P1-important" -name "*.md" 2>/dev/null | wc -l)
P2_COUNT=$(find "${CLAUDE_PROJECT_DIR}/.autonomous-worker/tickets/P2-improvement" -name "*.md" 2>/dev/null | wc -l)

if [ "$P0_COUNT" -gt 0 ] || [ "$P1_COUNT" -gt 0 ] || [ "$P2_COUNT" -gt 0 ]; then
    if [ -n "$CONTEXT_OUTPUT" ]; then
        CONTEXT_OUTPUT="$CONTEXT_OUTPUT

"
    fi
    CONTEXT_OUTPUT="${CONTEXT_OUTPUT}[AUTONOMOUS WORKER] Pending tickets: P0:$P0_COUNT P1:$P1_COUNT P2:$P2_COUNT
Use /aw:triage to manage tickets."
fi

# Output context if any
if [ -n "$CONTEXT_OUTPUT" ]; then
    echo "$CONTEXT_OUTPUT"
fi

exit 0
