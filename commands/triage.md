---
name: triage
description: Review and approve generated tickets, moving them from generated/ to tickets/ for cycle processing. Also manage existing triaged tickets.
argument-hint: "[--source improvements|features] [--priority P0|P1|P2] [--action list|approve|edit|resolve|delete]"
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

You are helping the user review generated tickets and manage the ticket workflow.

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
│       └── FEATURE-*.md
│
├── tickets/                # Triaged, ready for cycle
│   ├── P0-critical/
│   ├── P1-important/
│   ├── P2-improvement/
│   └── resolved/
│
└── rejected/               # Tickets decided against
    └── *.md
```

**Key Concept**:
- `generated/` = proposals that need human review
- `tickets/` = approved work items for `/aw:cycle`
- `rejected/` = decisions logged for future reference

## Commands

### Triage Generated Tickets (Main Flow)

**Review improvements:**
```
/aw:triage --source improvements
```

**Review features:**
```
/aw:triage --source features
```

For each generated ticket, the user can:
- **Approve** → Move to `tickets/P{priority}/`
- **Edit** → Modify then approve
- **Reject** → Move to `rejected/` with reason
- **Skip** → Leave for later

### List Tickets

Show tickets in different locations:
- `/aw:triage` - Interactive mode, show summary of all
- `/aw:triage --source improvements` - Triage generated improvements
- `/aw:triage --source features` - Triage generated features
- `/aw:triage --priority P0` - Show only critical approved tickets

### Approve Ticket
Move a generated ticket to the approved queue:
- `/aw:triage --action approve IMP-xxx --priority P1`
- `/aw:triage --action approve FEAT-xxx --priority P2`

### Edit Ticket
Open a ticket for modification:
- `/aw:triage --action edit TICKET-ID`

### Resolve Ticket
Mark an approved ticket as done:
- `/aw:triage --action resolve TICKET-ID`

### Reject Ticket
Move to rejected with reason:
- `/aw:triage --action reject TICKET-ID`

### Delete Ticket
Permanently remove (no trace):
- `/aw:triage --action delete TICKET-ID`

## Interactive Triage Mode

When called with `--source`, enter interactive mode:

### Step 1: Show Summary
```
📊 Generated Tickets Summary

Improvements (from /aw:analyze-improve):
├── Security: 3 tickets
├── Quality: 7 tickets
├── Performance: 2 tickets
└── Patterns: 5 tickets

Features (from /aw:analyze-features):
└── Proposals: 8 tickets

Total awaiting triage: 25 tickets

What would you like to triage?
1. Improvements (17 tickets)
2. Features (8 tickets)
3. View approved queue (tickets/)
```

### Step 2: Review Each Ticket

For each ticket, display:
```
─────────────────────────────────────────
📋 IMP-20250101-a3f2 | Security | P1 suggested

SQL Injection in User Search

File: src/services/user.py:45
Impact: High - Database compromise possible

Summary: The findUserByName function uses string
concatenation for SQL queries...

Suggested fix: Use parameterized queries

─────────────────────────────────────────
[A]pprove as P1 | [P]riority change | [E]dit | [R]eject | [S]kip
>
```

### Step 3: Process Decision

**If Approve:**
1. Assign ticket ID (001, 002, etc.)
2. Move to `tickets/P{priority}/`
3. Update ticket status to `approved`

**If Priority Change:**
- Ask for new priority (P0/P1/P2)
- Then approve with that priority

**If Edit:**
1. Open ticket in editor
2. Allow modifications
3. Return to approve flow

**If Reject:**
1. Ask for reason
2. Move to `rejected/` with reason in frontmatter
3. Log for future reference

**If Skip:**
- Move to next ticket

### Step 4: Summary

After triage session:
```
📊 Triage Session Complete

Approved: 12 tickets
├── P0: 2
├── P1: 5
└── P2: 5

Rejected: 3 tickets
Skipped: 2 tickets (still in generated/)

Next steps:
- Run /aw:cycle to work on approved tickets
- Run /aw:triage to continue with remaining
```

## Ticket Statuses

| Status | Location | Meaning |
|--------|----------|---------|
| generated | generated/ | Auto-created, needs review |
| approved | tickets/ | Ready for /aw:cycle |
| in_progress | tickets/ | Currently being worked |
| resolved | tickets/resolved/ | Done |
| rejected | rejected/ | Decided against |

## Bulk Operations

For efficiency with many tickets:

```
/aw:triage --bulk approve --source improvements --category security
```
→ Shows all security improvements, allow batch approve

```
/aw:triage --bulk reject --source features --complexity epic
```
→ Reject all epic-complexity features (too big right now)

## Best Practices

1. **Triage before cycle** - Review generated tickets before running cycle
2. **Be decisive** - Approve or reject, don't leave things in generated/ forever
3. **Prioritize correctly**:
   - P0 = Blocking, must fix before anything else
   - P1 = Important, should be done soon
   - P2 = Nice to have, when time permits
4. **Add context** - When editing, add your knowledge about the codebase
5. **Log rejections** - Future you will appreciate knowing why you said no
