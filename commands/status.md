---
name: status
description: Display the current status of the autonomous worker - active cycles, worktrees, tickets, and progress.
argument-hint: "[--verbose]"
allowed-tools:
  - Read
  - Glob
  - Bash
---

# Autonomous Worker: Status

Display comprehensive status of the autonomous worker system.

## Information to Display

### 1. Active Cycle Status
Read from `.autonomous-worker/state.json`:
```
📊 CYCLE STATUS
───────────────────────────────────
Task: "Add OAuth authentication"
Progress: Iteration 2/3
Phase: REVIEW (agents running)
Started: 10 minutes ago
Branch: feature/aw-oauth-auth
Worktree: ../aw-oauth-auth
```

### 2. Ticket Summary
Count tickets in `.autonomous-worker/tickets/`:
```
🎫 TICKETS
───────────────────────────────────
P0 Critical:    2 (blocking)
P1 Important:   5
P2 Improvement: 3
Resolved:       8
───────────────────────────────────
Total Open:     10
```

### 3. Git Worktrees
List active worktrees:
```bash
git worktree list
```
```
🌳 WORKTREES
───────────────────────────────────
/project (main)              → main
/project-aw-oauth-auth       → feature/aw-oauth-auth *active*
/project-aw-refactor-api     → feature/aw-refactor-api
```

### 4. Recent Activity
Read from `.autonomous-worker/cycle-log.md`:
```
📜 RECENT ACTIVITY
───────────────────────────────────
[10:05] Iteration 1 - Analyzed codebase structure
[10:08] Iteration 1 - Implemented OAuth provider
[10:12] Iteration 1 - Review found 7 issues
[10:15] Iteration 2 - Fixing P0 tickets...
```

### 5. Branch Status (if --verbose)
```bash
git status --short
git log --oneline -5
```

## Output Format

```
╔══════════════════════════════════════════════════════════╗
║           AUTONOMOUS WORKER STATUS                       ║
╠══════════════════════════════════════════════════════════╣
║ 📊 Cycle: Iteration 2/3 (REVIEW phase)                   ║
║ 🎫 Tickets: 2 P0 | 5 P1 | 3 P2                           ║
║ 🌳 Worktree: ../aw-oauth-auth (feature/aw-oauth-auth)    ║
║ ⏱️  Running: 12 minutes                                   ║
╚══════════════════════════════════════════════════════════╝

Use /aw:triage to manage tickets
Use /aw:cycle to continue or start new cycle
```

## No Active Cycle

If no cycle is running:
```
╔══════════════════════════════════════════════════════════╗
║           AUTONOMOUS WORKER STATUS                       ║
╠══════════════════════════════════════════════════════════╣
║ 💤 No active cycle                                       ║
║ 🎫 Pending tickets: 3 P1 | 2 P2                          ║
║ 🌳 Worktrees: 2 active                                   ║
╚══════════════════════════════════════════════════════════╝

Start a new cycle:
  /aw:cycle "Your task description" --iterations 3
```
