# Autonomous Worker: Multi-Level Architecture

## Overview

The autonomous-worker plugin uses a multi-level agent architecture that intelligently chooses between different execution modes based on the task at hand.

```
┌─────────────────────────────────────────────────────────────┐
│                    Level 1: ORCHESTRATOR                     │
│                   (Main Claude Session)                      │
│                                                              │
│  Responsibilities:                                           │
│  - Parse user commands                                       │
│  - Manage cycle state                                        │
│  - Coordinate agent spawning                                 │
│  - Aggregate results                                         │
│  - Final commit                                              │
└─────────────────────────────────────────────────────────────┘
                              │
           ┌──────────────────┼──────────────────┐
           │                  │                  │
           ▼                  ▼                  ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  ASYNC AGENT    │ │  ASYNC AGENT    │ │  claude -p      │
│  (Same context) │ │  (Same context) │ │  (Isolated)     │
│                 │ │                 │ │                 │
│  - Analyzers    │ │  - Reviewers    │ │  - Worktree     │
│  - Quick tasks  │ │  - Validators   │ │  - Long tasks   │
│  - Shared files │ │  - Checkers     │ │  - Independence │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

## When to Use Each Mode

### Async Agents (Task tool with run_in_background)

**Use for:**
- Parallel analysis that shares context
- Quick validation passes
- Tasks that need frequent synchronization
- Agents that read but don't heavily modify files
- Tasks expected to complete in < 2 minutes

**Examples:**
- Structure, Pattern, Risk analyzers
- Security, Quality, Test, Performance reviewers
- Code search and exploration
- Pattern detection

**Benefits:**
- Fast startup
- Shared context awareness
- Easy result aggregation
- Low overhead

**Spawning pattern:**
```markdown
Use the Task tool to spawn these agents in parallel:

1. Task: structure-analyzer
   Description: "Analyze structure for: {task}"
   run_in_background: true

2. Task: pattern-analyzer
   Description: "Find patterns for: {task}"
   run_in_background: true

Then use TaskOutput to collect results.
```

### claude -p (Headless Subprocess)

**Use for:**
- Worktree-isolated work (separate git context)
- Long-running implementations (> 5 minutes)
- Tasks that heavily modify many files
- Work that should survive session interruption
- True parallelism on different codebases

**Examples:**
- Implementing a feature in a worktree
- Running a full cycle in isolation
- Processing a large ticket queue
- Multi-project coordination

**Benefits:**
- Full isolation
- Survives parent session end
- Own git context (worktree)
- No context pollution

**Spawning pattern:**
```bash
# Create worktree first
git worktree add .worktrees/aw-feature-x -b feature/x staging

# Spawn isolated agent
cd ../aw-feature-x && claude -p "Implement feature X" \
  --output-format json \
  > .autonomous-worker/agent-output.json &
```

## Decision Tree

```
                    ┌─────────────────────┐
                    │   Task to execute   │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  Needs isolation?   │
                    │  (worktree/long)    │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │ Yes                             │ No
              ▼                                 ▼
    ┌─────────────────┐               ┌─────────────────┐
    │   claude -p     │               │  Multiple tasks │
    │   (isolated)    │               │   in parallel?  │
    └─────────────────┘               └────────┬────────┘
                                               │
                                  ┌────────────┼────────────┐
                                  │ Yes                     │ No
                                  ▼                         ▼
                        ┌─────────────────┐       ┌─────────────────┐
                        │  Async Agents   │       │  Direct work    │
                        │  (background)   │       │  (orchestrator) │
                        └─────────────────┘       └─────────────────┘
```

## Level Structure by Use Case

### Simple Cycle (No Worktrees)
```
L1: Orchestrator
    ├── L2: Async Analyzer Agents (parallel)
    ├── L2: [Direct Implementation]
    └── L2: Async Reviewer Agents (parallel)
```

### Complex Cycle (With Worktrees)
```
L1: Orchestrator (main repo)
    ├── L2: claude -p in worktree-1 (isolated)
    │       └── L3: Async agents within worktree
    ├── L2: claude -p in worktree-2 (isolated)
    │       └── L3: Async agents within worktree
    └── L2: Result aggregation (back in main)
```

### Analysis Only
```
L1: Orchestrator
    └── L2: Async Analyzer Agents (parallel)
            ├── Security
            ├── Quality
            ├── Performance
            └── Patterns
```

## State Synchronization

### Between Async Agents
- Use `.autonomous-worker/state.json` as shared state
- Each agent reads before and writes after
- Orchestrator aggregates final results

### Between claude -p Processes
- Each worktree has its own `.autonomous-worker/` folder
- Parent monitors via:
  - Checking `agent-output.json` existence
  - Reading `state.json` in worktree
  - Git branch status
- Final merge back to main worktree

## Resource Considerations

| Mode | CPU | Memory | Startup | Context |
|------|-----|--------|---------|---------|
| Async Agent | Shared | Shared | Fast | Shared |
| claude -p | Own | Own | Slow | Isolated |

**Recommendations:**
- Start with async agents
- Escalate to claude -p only when needed
- Limit concurrent claude -p to 2-3 (resource heavy)
- Always clean up worktrees after use

## Implementation Examples

### Parallel Analysis (Async)
```markdown
Launch 3 analyzers in parallel:

[Task: autonomous-worker:structure]
Analyze the codebase structure for implementing: {task}
run_in_background: true

[Task: autonomous-worker:patterns]
Find existing patterns relevant to: {task}
run_in_background: true

[Task: autonomous-worker:risks]
Identify risks for: {task}
run_in_background: true

Wait for all with TaskOutput, then aggregate.
```

### Worktree Execution (claude -p)
```bash
# Create worktree
git worktree add .worktrees/aw-feature-x -b feature/x staging

# Run isolated agent
cd ../aw-feature-x
claude -p "
You are working in an isolated worktree.
Task: Implement feature X
Rules:
- Commit when done
- Do not push
- Write status to .autonomous-worker/state.json
" --output-format stream-json &

# Monitor from parent
while [ ! -f ../aw-feature-x/.autonomous-worker/complete ]; do
  sleep 10
done

# Collect results
cd -
git worktree remove ../aw-feature-x
```
