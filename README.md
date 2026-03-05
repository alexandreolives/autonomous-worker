# Autonomous Worker

A multi-level autonomous agent orchestrator for Claude Code. Combines **compound-engineering** agents for deep analysis/review with **worktrunk** for isolated parallel worktrees.

## Features

- **Iterative Development Cycles** — Analyze → Implement → Review → Loop → Commit
- **Compound-Engineering Integration** — Uses 27 specialized agents for analysis and review
- **Worktrunk Worktrees** — Isolated parallel development via `wt` + tmux
- **Smart Ticket Management** — Auto-generate, triage, and resolve tickets (P0/P1/P2)
- **Dual Ticket System** — Works with both autonomous-worker tickets and compound-engineering todos

## Prerequisites

- [worktrunk](https://github.com/max-sixty/worktrunk) (`wt`) installed and configured
- [tmux](https://github.com/tmux/tmux) for parallel sessions
- [compound-engineering](https://github.com/EveryInc/every-marketplace) plugin enabled
- `gh` CLI for PR operations

## Quick Start

### 1. Analyze & Generate Tickets

```bash
/aw:analyze-improve                    # Find code improvements
/aw:analyze-features                   # Propose new features
```

### 2. Triage Tickets

```bash
/aw:triage                             # Interactive triage (supports both ticket systems)
/aw:triage --source improvements       # Triage improvement tickets
/aw:triage --source todos              # Triage compound-engineering todos
```

### 3. Run Development Cycle

```bash
/aw:cycle "Implement OAuth" --iterations 3              # Basic cycle
/aw:cycle "Implement OAuth" --iterations 3 --worktree   # With isolated worktree
/aw:cycle --iterations 3                                # Work on triaged tickets
```

### 4. Check Status

```bash
/aw:status                             # Full status (cycle, worktrees, tickets, todos)
```

### 5. Resolve Todos via Worktrees

```bash
/resolve                               # Resolve ready todos in parallel worktrees
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      ORCHESTRATOR                           │
│            (Coordinates all phases & agents)                │
└──────────────────────────┬──────────────────────────────────┘
                           │
      ┌────────────────────┼────────────────────────┐
      ▼                    ▼                        ▼
┌───────────────┐  ┌───────────────┐  ┌──────────────────────┐
│   ANALYZE     │  │  IMPLEMENT    │  │       REVIEW         │
│  (Parallel)   │  │ (Sequential)  │  │     (Parallel)       │
├───────────────┤  ├───────────────┤  ├──────────────────────┤
│ explore-      │  │ Code changes  │  │ security-sentinel    │
│   codebase    │  │ Fix tickets   │  │ performance-oracle   │
│ research-     │  │ Add tests     │  │ architecture-strat.  │
│   analyst     │  │               │  │ code-simplicity      │
│ best-         │  │               │  │ pattern-recognition  │
│   practices   │  │               │  │ data-integrity       │
└───────────────┘  └───────────────┘  └──────────────────────┘
                                               │
                           ┌───────────────────┘
                           ▼
                  ┌──────────────────┐     ┌──────────────────┐
                  │  TICKET SYSTEM   │     │  WORKTRUNK       │
                  ├──────────────────┤     ├──────────────────┤
                  │ P0: Critical     │     │ wt switch        │
                  │ P1: Important    │     │ wt merge         │
                  │ P2: Improvement  │     │ wt list          │
                  │ + CE todos       │     │ tmux sessions    │
                  └──────────────────┘     └──────────────────┘
```

## Commands

| Command | Description |
|---------|-------------|
| `/aw:cycle "<task>" --iterations N [--worktree] [--pr]` | Run development cycle |
| `/aw:triage [--source type]` | Triage tickets and todos |
| `/aw:status` | View full system status |
| `/aw:analyze-improve [--scope path] [--focus type]` | Generate improvement tickets |
| `/aw:analyze-features [--context desc]` | Propose new features |

## Integration with Compound-Engineering

This plugin uses compound-engineering agents for analysis and review:

**Analysis Phase**: `explore-codebase`, `repo-research-analyst`, `best-practices-researcher`

**Review Phase**: `security-sentinel`, `performance-oracle`, `architecture-strategist`, `code-simplicity-reviewer`, `pattern-recognition-specialist`

## Integration with Worktrunk

Uses `wt` (worktrunk) instead of raw `git worktree` commands:
- `wt switch --create` — create worktree + branch
- `wt merge` — squash, commit (via Claude), rebase, cleanup
- `wt list` — monitor worktrees and Claude sessions
- tmux post-switch hook — auto-rename windows to `repo(branch)`

## Ticket System

```
.autonomous-worker/
├── generated/              # Auto-generated, needs triage
│   ├── improvements/
│   └── features/
├── tickets/                # Triaged, ready for /aw:cycle
│   ├── P0-critical/
│   ├── P1-important/
│   ├── P2-improvement/
│   └── resolved/
└── rejected/

todos/                      # Compound-engineering todos (also triageable)
├── *-pending-*.md
├── *-ready-*.md
└── *-complete-*.md
```

## License

MIT
