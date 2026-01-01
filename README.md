# Autonomous Worker

A multi-level autonomous agent orchestrator for Claude Code. Combines the best patterns from compound-engineering, claude-code-settings, and ralph-wiggum to create a powerful development workflow.

## Features

- **Independent Ticket Generation** - Analyze code for improvements OR propose new features
- **Iterative Development Cycles** - Analyze → Implement → Review → Loop → Commit
- **Parallel Agent Execution** - Multiple specialized agents work simultaneously
- **Smart Ticket Management** - Human triage before execution (generated ≠ triaged)
- **Git Worktree Integration** - Isolated parallel development from staging branch
- **Autonomous with Control** - Runs autonomously but respects user decisions

## Installation

```bash
# Add via marketplace
claude marketplace add https://github.com/alexandreolives/autonomous-worker
```

## Quick Start

### 1. Analyze Your Codebase

```bash
# Find improvements in existing code
/aw:analyze-improve

# Propose new features
/aw:analyze-features
```

### 2. Triage Generated Tickets

```bash
# Review and approve tickets
/aw:triage --source improvements
/aw:triage --source features
```

### 3. Run a Development Cycle

```bash
# Work on approved tickets
/aw:cycle --iterations 3

# Or execute a direct task
/aw:cycle "Implement user authentication" --iterations 3
```

### 4. Check Status

```bash
/aw:status
```

## Commands

| Command | Description |
|---------|-------------|
| `/aw:analyze-improve` | Generate improvement tickets (security, quality, performance) |
| `/aw:analyze-features` | Study project and propose new features |
| `/aw:triage` | Review, approve, or reject generated tickets |
| `/aw:cycle` | Execute development cycle on approved tickets |
| `/aw:status` | View current status and pending work |

## Workflow

```
┌──────────────────────────────────────────────────────────────────┐
│                        TICKET GENERATION                          │
│                    (Independent from cycle)                       │
├─────────────────────────────┬────────────────────────────────────┤
│  /aw:analyze-improve        │  /aw:analyze-features              │
│  ────────────────────       │  ─────────────────────             │
│  • Security issues          │  • Study project deeply            │
│  • Code quality             │  • Propose new capabilities        │
│  • Performance problems     │  • Integration opportunities       │
│  • Pattern violations       │  • UX improvements                 │
└─────────────────────────────┴────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────┐
│                           TRIAGE                                  │
│                    /aw:triage                                     │
├──────────────────────────────────────────────────────────────────┤
│  • Review each generated ticket                                   │
│  • Approve → moves to tickets/ queue                             │
│  • Reject → logged in rejected/                                  │
│  • Edit → modify before approving                                │
└──────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────┐
│                      DEVELOPMENT CYCLE                            │
│                    /aw:cycle --iterations N                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│   ANALYZE ──→ IMPLEMENT ──→ REVIEW ──→ LOOP ──→ COMMIT           │
│   (parallel)  (execute)    (validate)  (N times)  (no push)      │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

## Folder Structure

```
.autonomous-worker/
├── generated/              # Auto-generated, needs triage
│   ├── improvements/       # From /aw:analyze-improve
│   │   ├── security/
│   │   ├── quality/
│   │   ├── performance/
│   │   └── patterns/
│   └── features/           # From /aw:analyze-features
│
├── tickets/                # Triaged, ready for cycle
│   ├── P0-critical/        # Must fix immediately
│   ├── P1-important/       # Should fix in this cycle
│   ├── P2-improvement/     # Fix if time permits
│   └── resolved/           # Completed
│
├── rejected/               # Decided against (logged)
├── state.json              # Current cycle state
└── cycle-log.md            # Activity log
```

## Architecture

The plugin uses a multi-level architecture:

### Level 1: Orchestrator
- Manages cycle phases
- Coordinates agent spawning
- Aggregates results

### Level 2: Agents (Choose based on task)

**Async Agents (preferred):**
- Fast startup, shared context
- Used for: analyzers, reviewers, quick tasks

**claude -p (when needed):**
- Full isolation, survives session end
- Used for: worktree work, long implementations

See `docs/ARCHITECTURE.md` for full details.

## Agents

### Analyzers (Parallel)
- **structure** - Codebase architecture and organization
- **patterns** - Existing patterns and conventions
- **risks** - Potential issues and edge cases

### Implementer
- Writes code, fixes tickets, adds tests

### Reviewers (Parallel - Validate, not generate)
- **security** - OWASP vulnerabilities, auth issues
- **quality** - Code smells, SOLID, naming
- **tests** - Coverage, edge cases
- **performance** - N+1 queries, bottlenecks

## Git Workflow

All work happens on branches from `staging`:

```
main ──────────────────────────────────────
        │
staging ┼───────────────────────────────────
        │         │
        │  feature/aw-oauth-auth
        │                  │
        │           feature/aw-api-refactor
```

- Worktrees enable parallel isolated work
- Commit happens automatically (no push)
- Push when you're ready to integrate

## Configuration

### CLAUDE.md Context

Add the `## Autonomous Worker Context` section to your CLAUDE.md to provide:
- Project overview and stack
- Code conventions
- Critical files to avoid
- Domain knowledge
- Testing requirements

See `templates/CLAUDE-section.md` for the full template.

## Inspired By

- [compound-engineering](https://github.com/EveryInc/compound-engineering-plugin) - Ticket system, parallel reviews, worktrees
- [claude-code-settings](https://github.com/feiskyer/claude-code-settings) - Agent structure, approval flows
- [ralph-wiggum](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/ralph-wiggum) - Long-running task patterns

## License

MIT

## Contributing

Contributions welcome! Please open an issue or PR.

---

Made with 🤖 by autonomous-worker
