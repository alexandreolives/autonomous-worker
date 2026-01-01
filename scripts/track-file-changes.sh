#!/bin/bash
# PostToolUse hook: Track file modifications for commit summary

CHANGES_FILE="${CLAUDE_PROJECT_DIR}/.autonomous-worker/file-changes.log"

# Create file if needed
mkdir -p "$(dirname "$CHANGES_FILE")"
touch "$CHANGES_FILE"

# Read tool result from stdin
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.path // "unknown"')
timestamp=$(date -Iseconds)

# Log file change
if [ "$file_path" != "unknown" ] && [ "$file_path" != "null" ]; then
    echo "[$timestamp] $tool_name: $file_path" >> "$CHANGES_FILE"
fi

exit 0
