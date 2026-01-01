---
name: ticket-management
description: This skill provides knowledge about managing tickets in the autonomous-worker system, including creation, prioritization, resolution workflow, and file format conventions.
triggers:
  - ticket
  - triage
  - priority
  - P0
  - P1
  - P2
  - issue tracking
---

# Ticket Management Skill

The autonomous-worker uses a file-based ticket system inspired by compound-engineering. This skill documents all conventions and workflows.

## Directory Structure

```
.autonomous-worker/
├── tickets/
│   ├── P0-critical/          # Blocking issues - must fix before continuing
│   │   └── 001-sql-injection.md
│   ├── P1-important/         # Should fix - affects quality/security
│   │   └── 002-missing-validation.md
│   ├── P2-improvement/       # Nice to have - polish and optimization
│   │   └── 003-add-logging.md
│   └── resolved/             # Completed tickets (for history)
│       └── 000-initial-setup.md
├── state.json                # Current cycle state
└── cycle-log.md              # Activity log
```

## Priority Levels

### P0 - Critical (Blocking)
- **Security vulnerabilities** (injection, auth bypass)
- **Data corruption risks**
- **Breaking functionality**
- **Failing tests that block deployment**

**Rule:** P0 tickets MUST be resolved before cycle can proceed. If too many P0s, pause for user intervention.

### P1 - Important (Should Fix)
- **Code quality issues** that affect maintainability
- **Missing test coverage** for important code
- **Performance issues** that affect user experience
- **Missing error handling**

**Rule:** P1 tickets should be addressed within the iteration cycle.

### P2 - Improvement (Nice to Have)
- **Minor style issues**
- **Documentation gaps**
- **Small optimizations**
- **Code cleanup opportunities**

**Rule:** P2 tickets are addressed if time permits or in subsequent cycles.

## Ticket File Format

Each ticket is a markdown file with YAML frontmatter:

```markdown
---
id: 001
priority: P0
category: security|quality|tests|performance|docs
title: Short descriptive title
created_at: 2025-01-01T10:00:00Z
created_by: security-reviewer
status: open|in_progress|resolved|wontfix
related_files:
  - src/services/user.py:45
  - src/routes/api.py:120
depends_on: []
blocks: []
---

# Title of the Issue

## Problem Statement
Clear description of what's wrong.

## Location
- File: `path/to/file.py`
- Line: 45
- Function/Class: `function_name()`

## Evidence
<How this was discovered - code snippet, test failure, etc.>

## Impact
- **Severity:** How bad is this?
- **Scope:** How much is affected?
- **Users:** Who is impacted?

## Reproduction Steps (if applicable)
1. Step one
2. Step two
3. Observe issue

## Suggested Fix
```python
# Code suggestion
```

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Tests pass

## Resolution (filled when resolved)
```yaml
resolved_at: 2025-01-01T12:00:00Z
resolved_by: implementer
resolution_summary: |
  Fixed by implementing X.
  Added test Y.
commits:
  - abc123: "fix: resolve SQL injection"
```
```

## Naming Convention

Ticket files follow this pattern:
```
<id>-<short-slug>.md
```

Examples:
- `001-sql-injection-users.md`
- `002-missing-rate-limiting.md`
- `003-add-docstrings.md`

IDs are sequential within each priority folder.

## Workflow

### Creating Tickets (Automated)

Review agents create tickets automatically:

1. Detect issue during review
2. Determine priority (P0/P1/P2)
3. Generate ticket file with all details
4. Place in appropriate priority folder
5. Log creation in cycle-log.md

### Manual Triage

User can manually triage tickets:

```bash
/aw:triage                        # Interactive triage
/aw:triage --priority P0          # View P0 only
/aw:triage --action edit 001      # Edit ticket
/aw:triage --action resolve 001   # Mark resolved
```

Triage options per ticket:
- **Keep** - Maintain current priority
- **Promote** - Move to higher priority (P2→P1, P1→P0)
- **Demote** - Move to lower priority (P0→P1, P1→P2)
- **Edit** - Modify details or add context
- **Delete** - Remove if not relevant
- **Defer** - Move to "deferred" folder for later

### Resolving Tickets

When implementer fixes an issue:

1. Read ticket details
2. Implement the fix
3. Update ticket with resolution info
4. Move to `resolved/` folder
5. Reference in commit message

### Priority Changes

To move a ticket between priorities:

```bash
mv .autonomous-worker/tickets/P1-important/002-issue.md \
   .autonomous-worker/tickets/P0-critical/002-issue.md
```

Update frontmatter `priority` field accordingly.

## Integration with Cycle

### During REVIEW Phase

Each reviewer agent:
1. Analyzes code changes
2. Generates tickets for issues found
3. Places in appropriate folder
4. Reports summary to orchestrator

### During IMPLEMENT Phase

Implementer agent:
1. Reads all P0 tickets first
2. Then P1 tickets
3. Then P2 if time allows
4. Resolves each with proper documentation

### Between Iterations

Orchestrator:
1. Counts remaining tickets by priority
2. Logs to cycle-log.md
3. Decides if another iteration needed
4. Reports to user if P0s remain

## Templates

### Security Ticket Template

```markdown
---
id: XXX
priority: P0
category: security
title: [Vulnerability Type] in [Component]
---

# [Vulnerability Type] in [Component]

## Vulnerability
- **Type:** [OWASP Category]
- **CWE:** [CWE-XXX]
- **Severity:** Critical/High/Medium/Low

## Location
[File and line]

## Description
[What the vulnerability is]

## Exploitation
[How it could be exploited]

## Fix
[How to remediate]
```

### Quality Ticket Template

```markdown
---
id: XXX
priority: P1
category: quality
title: [Issue Type] in [Component]
---

# [Issue Type] in [Component]

## Issue
[Description of code quality issue]

## Location
[File and line]

## Current Code
```python
[problematic code]
```

## Suggested Improvement
```python
[improved code]
```

## Rationale
[Why this matters]
```

## Best Practices

1. **Be specific:** Include exact file paths and line numbers
2. **Show evidence:** Include code snippets that demonstrate the issue
3. **Suggest fixes:** Provide concrete solutions, not just problems
4. **Prioritize correctly:** P0 is for truly blocking issues only
5. **Keep it focused:** One issue per ticket
6. **Reference related:** Link to related tickets if they exist
7. **Track progress:** Update status as work progresses
