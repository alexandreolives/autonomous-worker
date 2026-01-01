---
name: analyze-improve
description: Analyze existing codebase to generate improvement tickets (code quality, patterns, security, performance). Tickets are stored in generated/ folder, separate from triaged tickets.
argument-hint: "[--scope <path>] [--focus security|quality|performance|all]"
allowed-tools:
  - Task
  - Read
  - Write
  - Glob
  - Grep
  - TodoWrite
---

# Autonomous Worker: Analyze for Improvements

You are analyzing an existing codebase to find areas for improvement. This is **independent from the development cycle** - you are generating tickets that will be stored separately and triaged later.

## Output Location

**IMPORTANT**: Generated tickets go to `.autonomous-worker/generated/improvements/`
They are NOT mixed with triaged tickets in `.autonomous-worker/tickets/`

## Arguments Parsing

Parse the user's input:
- `--scope <path>`: Limit analysis to specific directory (default: entire project)
- `--focus <type>`: Focus on specific aspect:
  - `security` - OWASP, vulnerabilities, auth issues
  - `quality` - Code smells, DRY, SOLID, naming
  - `performance` - N+1, bottlenecks, memory
  - `all` - All aspects (default)

Example: `/aw:analyze-improve --scope src/api --focus security`

## Workflow

### Step 1: Initialize

1. Create output directory if not exists:
   ```
   .autonomous-worker/
   └── generated/
       └── improvements/
           ├── security/
           ├── quality/
           ├── performance/
           └── patterns/
   ```

2. Read project structure to understand scope
3. Check for CLAUDE.md context

### Step 2: Parallel Analysis

Launch analysis agents IN PARALLEL based on `--focus`:

**If focus = all (default):**
```
Spawn 4 agents in parallel:
1. autonomous-worker:security - Analyze for security issues
2. autonomous-worker:quality - Analyze for code quality issues
3. autonomous-worker:performance - Analyze for performance issues
4. autonomous-worker:patterns - Analyze for pattern violations
```

**If focus = specific type:**
Only spawn the relevant agent.

Each agent must:
- Examine the codebase (or scoped path)
- Find concrete issues with file:line references
- Assess severity (P0/P1/P2)
- Generate tickets with full context

### Step 3: Ticket Generation

For each finding, create a ticket file in the appropriate folder:

**Ticket Format**: `.autonomous-worker/generated/improvements/{category}/TICKET-{id}.md`

```markdown
---
id: IMP-{timestamp}-{hash}
category: security|quality|performance|patterns
priority: P0|P1|P2
status: generated
file: path/to/file.ext
line: 42
created_at: ISO timestamp
---

# {Short descriptive title}

## Issue
{Clear description of what's wrong}

## Location
- File: `{file_path}`
- Line: {line_number}
- Code:
  ```{lang}
  {relevant code snippet}
  ```

## Impact
{Why this matters - security risk, performance cost, maintainability concern}

## Suggested Fix
{Concrete suggestion for how to fix this}

## References
- {Links to best practices, OWASP, etc. if applicable}
```

### Step 4: Summary Report

After all agents complete, generate a summary:

```markdown
# Improvement Analysis Report

**Scope**: {scope or "entire project"}
**Focus**: {focus type}
**Generated**: {ISO timestamp}

## Findings Summary

| Category    | P0 | P1 | P2 | Total |
|-------------|----|----|----|----- |
| Security    | X  | X  | X  | X     |
| Quality     | X  | X  | X  | X     |
| Performance | X  | X  | X  | X     |
| Patterns    | X  | X  | X  | X     |
| **Total**   | X  | X  | X  | X     |

## Top Priority Issues

1. {P0 issue 1}
2. {P0 issue 2}
...

## Next Steps

Run `/aw:triage` to review and approve tickets for implementation.
Approved tickets will be moved to `.autonomous-worker/tickets/`.
```

Save report to: `.autonomous-worker/generated/improvements/REPORT-{timestamp}.md`

## Agent Instructions

### Security Analyzer Focus
- SQL injection, XSS, CSRF vulnerabilities
- Hardcoded secrets, API keys
- Authentication/authorization flaws
- Input validation gaps
- Dependency vulnerabilities (check package files)

### Quality Analyzer Focus
- Code duplication (DRY violations)
- Long functions/methods (>50 lines)
- Deep nesting (>3 levels)
- Poor naming conventions
- Missing error handling
- Unused code/imports

### Performance Analyzer Focus
- N+1 query patterns
- Unnecessary loops
- Missing indexes (from query patterns)
- Large memory allocations
- Blocking operations in async contexts
- Missing caching opportunities

### Patterns Analyzer Focus
- Inconsistent code style
- Framework convention violations
- Anti-patterns for the tech stack
- Inconsistent API design
- Missing abstractions

## Important Rules

- **NO implementation** - only analyze and generate tickets
- **Tickets are NOT automatically queued** - they need triage first
- Be specific with file:line references
- Provide actionable suggestions
- Don't duplicate existing tickets (check generated/ folder first)
