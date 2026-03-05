---
name: triage
description: Review and triage tickets from generated/ or todos/. Supports both autonomous-worker tickets and compound-engineering todo files.
argument-hint: "[--source improvements|features|todos] [--priority P0|P1|P2] [--action list|approve|edit|resolve|reject|delete]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash
  - TodoWrite
  - AskUserQuestion
---

# Autonomous Worker: Ticket Triage

Review and approve tickets for processing. Works with both autonomous-worker generated tickets AND compound-engineering todo files.

**NE PAS CODER PENDANT LE TRIAGE !**

## Compatible Sources

1. **autonomous-worker generated tickets**: `.autonomous-worker/generated/{improvements,features}/`
2. **compound-engineering todos**: `todos/*-pending-*.md`
3. **Both**: Auto-detect what's available

## Auto-Detection

On startup, check what exists:
```bash
ls .autonomous-worker/generated/improvements/**/*.md 2>/dev/null | wc -l
ls .autonomous-worker/generated/features/**/*.md 2>/dev/null | wc -l
ls todos/*-pending-*.md 2>/dev/null | wc -l
```

Present summary of all available items.

## Interactive Triage Flow

### Step 1: Show Summary

```
Triage Summary

autonomous-worker generated:
  Improvements: {X} tickets
  Features: {Y} tickets

compound-engineering todos:
  Pending: {Z} todos

Total awaiting triage: {total}

What would you like to triage?
1. Improvements ({X} tickets)
2. Features ({Y} tickets)
3. Compound-engineering todos ({Z} pending)
4. Everything
```

### Step 2: Review Each Item

For each ticket/todo, display:
```
---
Progress: X/Y

#{id}: {Title}

Priority: P0 (CRITICAL) / P1 (IMPORTANT) / P2 (IMPROVEMENT)
Category: {Security/Quality/Performance/etc.}
Location: {file_path:line_number}
Impact: {description}
Suggested Fix: {summary}
Effort: {Small/Medium/Large}

---
[A]pprove | [P]riority change | [E]dit | [R]eject | [S]kip
```

### Step 3: Process Decision

**Approve (autonomous-worker ticket):**
1. Move to `.autonomous-worker/tickets/P{priority}/`
2. Update status to `approved`
3. Confirm

**Approve (compound-engineering todo):**
1. Rename: `{id}-pending-{priority}-{desc}.md` -> `{id}-ready-{priority}-{desc}.md`
2. Update frontmatter: `status: pending` -> `status: ready`
3. Confirm

**Reject:**
1. Move to `.autonomous-worker/rejected/` (with reason) or delete todo file
2. Log reason

**Edit:**
1. Ask what to modify
2. Update
3. Return to approve flow

**Skip:**
- Move to next item

### Step 4: Summary

```
Triage Complete

Total: {X} | Approved: {Y} | Rejected: {Z} | Skipped: {W}

Approved items:
- {ticket/todo 1} (P0)
- {ticket/todo 2} (P1)

Next steps:
1. /aw:cycle - Work on approved aw tickets
2. /resolve - Resolve compound-engineering todos via worktrees
3. Commit the triage results
4. Nothing
```

## Bulk Operations

```
/aw:triage --bulk approve --source improvements --category security
/aw:triage --bulk reject --source features --complexity epic
```

## Important Rules

- **NO CODING** during triage
- Be decisive: approve or reject, don't leave things forever
- P0 = Blocking | P1 = Important | P2 = Nice to have
- Log rejections for future reference
- Works seamlessly with both ticket systems
