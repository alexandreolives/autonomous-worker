# Autonomous Worker

A multi-level autonomous agent orchestrator for Claude Code. Combines the best patterns from compound-engineering, claude-code-settings, and ralph-wiggum to create a powerful development workflow.

## Features

- **Iterative Development Cycles** - Analyze → Implement → Review → Loop → Commit
- **Parallel Agent Execution** - Multiple specialized agents work simultaneously
- **Smart Ticket Management** - Automatic issue detection and prioritization (P0/P1/P2)
- **Git Worktree Integration** - Isolated parallel development from staging branch
- **Autonomous with Control** - Runs autonomously but respects user decisions

## Installation

```bash
# Clone or copy to your Claude Code plugins directory
cp -r autonomous-worker ~/.claude/plugins/

# Or use as project-local plugin
cp -r autonomous-worker /your/project/.claude-plugins/
```

## Quick Start

### 1. Add Context to Your Project

Copy the template from `templates/CLAUDE-section.md` into your project's `CLAUDE.md`:

```markdown
## Autonomous Worker Context

### Project Overview
**Project:** My Awesome App
**Stack:** Python, FastAPI, PostgreSQL

### Code Conventions
...
```

### 2. Run a Development Cycle

```bash
# Start a 3-iteration development cycle
/aw:cycle "Implement user authentication with OAuth" --iterations 3
```

This will:
1. **Analyze** - 3 parallel agents examine your codebase
2. **Implement** - Write the feature based on analysis
3. **Review** - 4 parallel agents check for issues
4. **Generate Tickets** - Create P0/P1/P2 tickets for issues found
5. **Loop** - Repeat for 3 iterations, fixing tickets each time
6. **Commit** - Auto-commit when complete (no push)

### 3. Check Status

```bash
/aw:status
```

Shows active cycles, pending tickets, and worktree status.

### 4. Triage Tickets

```bash
/aw:triage                    # Interactive triage
/aw:triage --priority P0      # View critical tickets only
/aw:triage --action edit 001  # Edit a specific ticket
```

## Commands

| Command | Description |
|---------|-------------|
| `/aw:cycle "<task>" --iterations N` | Run development cycle with N iterations |
| `/aw:triage` | Manage and prioritize tickets |
| `/aw:status` | View current cycle and ticket status |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      ORCHESTRATOR                           │
│                 (Coordinates all phases)                    │
└─────────────────────────────────┬───────────────────────────┘
                                  │
         ┌────────────────────────┼────────────────────────┐
         ▼                        ▼                        ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    ANALYZE      │    │   IMPLEMENT     │    │     REVIEW      │
│   (Parallel)    │    │   (Sequential)  │    │   (Parallel)    │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Structure     │    │ • Code changes  │    │ • Security      │
│ • Patterns      │    │ • Fix tickets   │    │ • Quality       │
│ • Risks         │    │ • Add tests     │    │ • Tests         │
└─────────────────┘    └─────────────────┘    │ • Performance   │
                                              └─────────────────┘
                                                       │
                                                       ▼
                                              ┌─────────────────┐
                                              │  TICKET SYSTEM  │
                                              ├─────────────────┤
                                              │ P0: Critical    │
                                              │ P1: Important   │
                                              │ P2: Improvement │
                                              └─────────────────┘
```

## Agents

### Analyzers (Phase 1 - Parallel)
- **structure-analyzer** - Codebase architecture and organization
- **pattern-analyzer** - Existing patterns and conventions
- **risk-analyzer** - Potential issues and edge cases

### Implementer (Phase 2 - Sequential)
- **implementer** - Writes code, fixes tickets, adds tests

### Reviewers (Phase 3 - Parallel)
- **security-reviewer** - OWASP vulnerabilities, injection, auth issues
- **quality-reviewer** - Code smells, SOLID, naming, conventions
- **test-reviewer** - Coverage, edge cases, test quality
- **performance-reviewer** - N+1 queries, bottlenecks, memory

## Ticket System

Tickets are stored in `.autonomous-worker/tickets/`:

```
.autonomous-worker/
├── tickets/
│   ├── P0-critical/      # Must fix before continuing
│   ├── P1-important/     # Should fix in this cycle
│   ├── P2-improvement/   # Nice to have
│   └── resolved/         # Completed tickets
├── state.json            # Current cycle state
└── cycle-log.md          # Activity log
```

### Priority Levels

| Priority | Meaning | Action |
|----------|---------|--------|
| **P0** | Critical/Blocking | Must fix immediately |
| **P1** | Important | Fix within cycle |
| **P2** | Improvement | Fix if time permits |

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

- Worktrees enable parallel agent work
- Commit happens automatically (no push)
- Push when you're ready to integrate

## Skills

- **ticket-management** - Ticket creation, prioritization, resolution
- **worktree-parallel** - Git worktree patterns for parallel work

## Hooks

- **Stop** - Continue cycle if iterations remain
- **SubagentStop** - Collect and aggregate agent results
- **PreToolUse** - Log agent spawns
- **PostToolUse** - Track file changes
- **SessionStart** - Load context and show status

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
