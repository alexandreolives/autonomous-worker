---
name: status
description: Display status of autonomous worker, worktrunk worktrees, and compound-engineering todos.
argument-hint: "[--verbose]"
allowed-tools:
  - Read
  - Glob
  - Bash
---

# Autonomous Worker: Status

Display comprehensive status combining autonomous-worker, worktrunk, and compound-engineering.

## Information to Display

### 1. Active Cycle
Read from `.autonomous-worker/state.json` if exists:
```
CYCLE STATUS
  Task: {task}
  Progress: Iteration X/N ({phase})
  Branch: {branch}
  Started: {time ago}
```

### 2. Worktrunk Worktrees
```bash
wt list
```

### 3. Generated Tickets (Awaiting Triage)
Count in `.autonomous-worker/generated/`:
```
GENERATED (needs triage)
  Improvements: {X}
  Features: {Y}
```

### 4. Approved Tickets
Count in `.autonomous-worker/tickets/`:
```
APPROVED (ready for cycle)
  P0 Critical:    {X}
  P1 Important:   {Y}
  P2 Improvement: {Z}
  Resolved:       {W}
```

### 5. Compound-Engineering Todos
```bash
ls todos/*-pending-*.md 2>/dev/null | wc -l
ls todos/*-ready-*.md 2>/dev/null | wc -l
ls todos/*-complete-*.md 2>/dev/null | wc -l
```
```
TODOS (compound-engineering)
  Pending:  {X}
  Ready:    {Y}
  Complete: {Z}
```

### 6. Recent Activity
Read last entries from `.autonomous-worker/cycle-log.md` if exists.

## Output Format

```
AUTONOMOUS WORKER STATUS
===========================
Cycle:     {status or "No active cycle"}
Worktrees: {count from wt list}
Generated: {X} awaiting triage
Tickets:   {X} P0 | {Y} P1 | {Z} P2
Todos:     {X} pending | {Y} ready | {Z} complete

Commands:
  /aw:cycle "task"          - Start development cycle
  /aw:analyze-improve       - Find improvements
  /aw:analyze-features      - Propose features
  /aw:triage                - Triage all pending items
  /resolve                  - Resolve ready todos via worktrees
  /workflows:review         - Deep code review (compound-engineering)
```
