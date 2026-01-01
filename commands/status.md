---
name: status
description: Display the current status of the autonomous worker - active cycles, worktrees, generated tickets, approved tickets, and progress.
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

### 2. Generated Tickets (Awaiting Triage)
Count tickets in `.autonomous-worker/generated/`:
```
📝 GENERATED (needs triage)
───────────────────────────────────
Improvements:
  ├── Security:     3
  ├── Quality:      7
  ├── Performance:  2
  └── Patterns:     5
Features:           8
───────────────────────────────────
Total Pending:     25

→ Run /aw:triage to review
```

### 3. Approved Tickets (Ready for Cycle)
Count tickets in `.autonomous-worker/tickets/`:
```
🎫 APPROVED (ready for cycle)
───────────────────────────────────
P0 Critical:    2 (blocking)
P1 Important:   5
P2 Improvement: 3
───────────────────────────────────
Total Open:     10
Resolved:       8

→ Run /aw:cycle to work on these
```

### 4. Rejected Tickets
Count in `.autonomous-worker/rejected/`:
```
❌ REJECTED: 4 tickets
```

### 5. Git Worktrees
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

### 6. Recent Activity
Read from `.autonomous-worker/cycle-log.md`:
```
📜 RECENT ACTIVITY
───────────────────────────────────
[10:05] Iteration 1 - Analyzed codebase structure
[10:08] Iteration 1 - Implemented OAuth provider
[10:12] Iteration 1 - Review validated changes
[10:15] Iteration 2 - Continuing with refinements...
```

### 7. Branch Status (if --verbose)
```bash
git status --short
git log --oneline -5
```

## Output Format

### Active Cycle
```
╔══════════════════════════════════════════════════════════════════╗
║              AUTONOMOUS WORKER STATUS                             ║
╠══════════════════════════════════════════════════════════════════╣
║ 📊 Cycle: Iteration 2/3 (REVIEW phase)                           ║
║ 📝 Generated: 25 pending triage                                   ║
║ 🎫 Approved:  2 P0 | 5 P1 | 3 P2                                  ║
║ 🌳 Worktree:  ../aw-oauth-auth (feature/aw-oauth-auth)            ║
║ ⏱️  Running:  12 minutes                                          ║
╚══════════════════════════════════════════════════════════════════╝

Commands:
  /aw:triage              - Review generated tickets
  /aw:analyze-improve     - Generate improvement tickets
  /aw:analyze-features    - Generate feature proposals
```

### No Active Cycle
```
╔══════════════════════════════════════════════════════════════════╗
║              AUTONOMOUS WORKER STATUS                             ║
╠══════════════════════════════════════════════════════════════════╣
║ 💤 No active cycle                                               ║
║ 📝 Generated: 25 pending triage                                   ║
║ 🎫 Approved:  3 P1 | 2 P2 ready to work                          ║
║ 🌳 Worktrees: 2 active                                           ║
╚══════════════════════════════════════════════════════════════════╝

Commands:
  /aw:cycle "task" --iterations 3  - Start a new cycle
  /aw:triage                       - Review generated tickets
  /aw:analyze-improve              - Analyze for improvements
  /aw:analyze-features             - Propose new features
```

### First Time (No Data)
```
╔══════════════════════════════════════════════════════════════════╗
║              AUTONOMOUS WORKER STATUS                             ║
╠══════════════════════════════════════════════════════════════════╣
║ 🆕 Autonomous Worker not yet initialized                         ║
╚══════════════════════════════════════════════════════════════════╝

Get started:
  /aw:analyze-improve     - Find improvements in existing code
  /aw:analyze-features    - Propose new features
  /aw:triage              - Review and approve tickets
  /aw:cycle               - Execute development cycle
```
