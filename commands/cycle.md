---
name: cycle
description: Execute an iterative development cycle. Analyzes, implements, reviews, loops N times, then commits. Uses worktrunk for parallel worktrees and compound-engineering agents for deep analysis.
argument-hint: "[<task description>] [--iterations <N>] [--worktree] [--pr]"
allowed-tools:
  - Task
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - TodoWrite
  - AskUserQuestion
---

# Autonomous Worker: Development Cycle

Execute an iterative development cycle combining autonomous-worker orchestration with compound-engineering agents and worktrunk worktrees.

## Arguments

- `task_description`: What to implement (or omit to work on triaged tickets from `tickets/`)
- `--iterations N`: Number of cycles (default: 3)
- `--worktree`: Use worktrunk to create an isolated worktree for this cycle
- `--pr`: Create a PR at the end

## Pre-Cycle Setup

1. **Read project context** from CLAUDE.md
2. **Check ticket queue** if no task given:
   ```
   .autonomous-worker/tickets/
   ├── P0-critical/    # Process first
   ├── P1-important/   # Process second
   ├── P2-improvement/ # Process if time
   └── resolved/       # Completed
   ```
3. **If `--worktree`**: Create isolated worktree via worktrunk:
   ```bash
   wt switch --create aw-{task-slug}
   ```
   This creates a branch, a worktree, and switches to it.

4. **Initialize state**:
   ```bash
   mkdir -p .autonomous-worker
   ```
   Write `.autonomous-worker/state.json`:
   ```json
   {
     "current_task": "{task_description}",
     "current_iteration": 1,
     "total_iterations": N,
     "phase": "analyzing",
     "branch": "{current branch}",
     "started_at": "{ISO timestamp}",
     "tickets_resolved": []
   }
   ```

## Iteration Loop

For each iteration (1 to N):

### Phase 1: ANALYZE (Parallel Agents)

Launch agents IN PARALLEL. Use compound-engineering agents when available, fallback to built-in:

**Core analysis (always):**
1. Task explore-codebase("Analyze architecture, file organization, and dependencies relevant to: {task}")
2. Task explore-codebase("Find existing patterns, conventions, and similar implementations for: {task}")
3. Task explore-codebase("Identify risks, edge cases, and potential issues for: {task}")

**Extended analysis (if task is complex, launch additional compound-engineering agents):**
4. Task compound-engineering:security-sentinel("Security analysis for: {task}")
5. Task compound-engineering:performance-oracle("Performance analysis for: {task}")
6. Task compound-engineering:architecture-strategist("Architecture impact analysis for: {task}")

Wait for all agents, aggregate findings into a unified analysis.

### Phase 2: IMPLEMENT

**If direct task (iteration 1):**
- Implement based on analysis findings
- Follow existing patterns identified in Phase 1

**If working tickets:**
- Read tickets from `tickets/P0-critical/` first, then P1, then P2
- Implement fixes for each

**If complex multi-file task and `--worktree` was used:**
- Work directly in the worktree, we're already isolated

### Phase 3: REVIEW (Parallel Agents)

Launch compound-engineering review agents IN PARALLEL:

1. Task compound-engineering:security-sentinel("Validate implementation security for: {task}")
2. Task compound-engineering:code-simplicity-reviewer("Check code simplicity for changes made")
3. Task compound-engineering:pattern-recognition-specialist("Verify patterns and anti-patterns in changes")
4. Task compound-engineering:performance-oracle("Validate performance of implementation")

**If the project has tests:**
5. Run existing tests: `npm test` / `pytest` / `cargo test` / etc.

**Review results handling:**
- Minor issues: Fix immediately in this iteration
- Major issues: Log in cycle-log.md, fix in next iteration
- Critical blockers: Pause and ask user via AskUserQuestion

### Phase 4: Iteration Summary

1. Log to `.autonomous-worker/cycle-log.md`:
   ```markdown
   ## Iteration X/N - {ISO date}
   - Analyzed: {summary}
   - Implemented: {changes made}
   - Reviewed: {validation results}
   - Issues Fixed: {count}
   - Status: {continuing/complete}
   ```
2. Mark resolved tickets (move to `resolved/`)
3. Update `state.json`: increment iteration
4. If more iterations remain, continue to ANALYZE
5. If final iteration, proceed to commit

## Final Phase: Commit & Cleanup

1. Stage changes: `git add -A`
2. Review what's being committed: `git status` and `git diff --staged`
3. Commit with descriptive message
4. **If `--pr`**: Create PR via `gh pr create`
5. **If `--worktree`**: Optionally merge via `wt merge`
6. Update state: `phase: "complete"`

## Completion Report

```markdown
## Cycle Complete

**Task:** {task_description}
**Iterations:** {N}
**Branch:** {branch}

### Changes Made:
- {change 1}
- {change 2}

### Tickets Resolved:
- {ticket 1}
- {ticket 2}

### Review Summary:
- Security: {status}
- Quality: {status}
- Performance: {status}
- Tests: {status}

### Next Steps:
1. Review changes: `git diff main`
2. If worktree: `wt merge` to merge back
3. Push: `git push`
```

## Important Rules

- Be autonomous: skip confirmations unless critical blocker
- Log everything in cycle-log.md
- Use compound-engineering agents for deep analysis
- Use worktrunk (`wt`) for worktree operations, not raw `git worktree`
- NEVER push without explicit user request
- Read CLAUDE.md context before starting
