---
name: worktree-parallel
description: Parallel development using worktrunk (wt) for isolated worktrees with tmux integration. Each task gets its own worktree and optional Claude session.
triggers:
  - worktree
  - parallel
  - branch
  - isolation
  - worktrunk
---

# Parallel Development with Worktrunk

The autonomous-worker uses **worktrunk** (`wt`) for parallel agent work in isolated worktrees, with tmux for session management.

## Core Concept

Worktrunk manages git worktrees with a clean CLI:

```bash
# Create worktree + branch + switch to it
wt switch --create feature-name

# Create worktree and launch Claude in it
wt switch --create feature-name -x claude -- "Implement the feature"

# In tmux: create worktree in a new session
tmux new-session -d -s "task-name" "wt switch --create task-name -x claude -- 'Task description'"

# List all worktrees
wt list

# Merge worktree back (squash + commit + cleanup)
wt merge
```

## Parallel Agent Pattern

### Spawning Multiple Agents via tmux

```bash
# Each todo/ticket gets its own worktree + Claude session
tmux new-session -d -s "todo-001" "wt switch --create fix-001-sql-injection -x claude -- 'Fix SQL injection vulnerability. Details: ...'"
tmux new-session -d -s "todo-002" "wt switch --create fix-002-n-plus-one -x claude -- 'Fix N+1 query in orders. Details: ...'"
tmux new-session -d -s "todo-003" "wt switch --create fix-003-auth-bypass -x claude -- 'Fix auth bypass. Details: ...'"
```

### Monitoring Progress

```bash
# Check all worktrees and their Claude session status
wt list

# Attach to a specific session to check
tmux attach -t todo-001
```

### Merging Results

```bash
# For each completed worktree:
wt switch fix-001-sql-injection
wt merge  # squash, commit, rebase, cleanup
```

## Integration with autonomous-worker

The `/aw:cycle` command uses worktrunk when `--worktree` flag is set:

```bash
/aw:cycle "Implement OAuth" --iterations 3 --worktree
```

This creates a worktree via `wt switch --create aw-{slug}` and works in isolation.

## Integration with /resolve

The `/resolve` command spawns one worktree per ready todo:

```bash
/resolve  # reads todos/*-ready-*.md, creates worktrees, launches Claude agents
```

## Configuration

Worktrunk config at `~/.config/worktrunk/config.toml`:
- `post-switch`: renames tmux window to `repo(branch)`
- `post-start`: copies ignored files (.env, DB) to new worktrees
- `commit.generation`: uses Claude for commit messages

## Best Practices

- Max 5 parallel worktrees to avoid overload
- Use `wt list` to monitor, not `git worktree list`
- Use `wt merge` to merge back, not manual git commands
- Each agent works in complete isolation — no file conflicts
- tmux sessions auto-name with the tmux post-switch hook
