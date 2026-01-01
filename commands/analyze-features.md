---
name: analyze-features
description: Study the project deeply to propose new features and enhancements. Analyzes README, docs, existing features, and patterns to suggest additions. Tickets stored in generated/ folder.
argument-hint: "[--context <description>] [--limit <N>]"
allowed-tools:
  - Task
  - Read
  - Write
  - Glob
  - Grep
  - TodoWrite
  - WebFetch
  - WebSearch
---

# Autonomous Worker: Analyze for New Features

You are studying a project in depth to propose valuable new features. This requires understanding the project's purpose, existing functionality, user needs, and technical patterns.

## Output Location

**IMPORTANT**: Generated tickets go to `.autonomous-worker/generated/features/`
They are NOT mixed with triaged tickets in `.autonomous-worker/tickets/`

## Arguments Parsing

Parse the user's input:
- `--context <description>`: Additional context about project goals or user needs
- `--limit <N>`: Maximum number of feature proposals (default: 10)

Example: `/aw:analyze-features --context "This is an e-commerce platform, we want to improve conversion" --limit 5`

## Workflow

### Step 1: Deep Project Study

**This phase is critical** - you must understand the project before proposing features.

1. **Read all documentation**:
   - README.md
   - CLAUDE.md
   - Any docs/ folder
   - Package manifests (package.json, Gemfile, requirements.txt, etc.)

2. **Understand the tech stack**:
   - Framework(s) used
   - Database type
   - Frontend technology
   - External services/APIs

3. **Map existing features**:
   - Main user flows
   - Core functionality
   - API endpoints
   - UI components

4. **Identify patterns**:
   - How features are structured
   - Common patterns used
   - Testing approach
   - Deployment method

### Step 2: Parallel Analysis

Launch analysis agents IN PARALLEL:

```
1. Feature Gap Analyzer
   - Compare with similar projects in the space
   - Identify missing common features
   - Look for TODO comments and FIXME notes

2. User Experience Analyzer
   - Analyze user-facing code
   - Identify UX improvement opportunities
   - Look for accessibility gaps

3. Technical Enhancement Analyzer
   - Identify modernization opportunities
   - Find areas for better tooling
   - Spot integration possibilities

4. Scalability Analyzer
   - Areas that need future-proofing
   - Performance bottleneck prevention
   - Infrastructure improvements
```

### Step 3: Feature Proposal Generation

For each feature proposal, create a ticket:

**Ticket Format**: `.autonomous-worker/generated/features/FEATURE-{id}.md`

```markdown
---
id: FEAT-{timestamp}-{hash}
category: enhancement|new-feature|integration|ux|infrastructure
priority: P1|P2
status: generated
complexity: small|medium|large|epic
created_at: ISO timestamp
---

# {Feature Title}

## Summary
{One paragraph describing the feature}

## Problem Statement
{What problem does this solve? Why is it needed?}

## Proposed Solution

### Overview
{High-level description of the solution}

### Technical Approach
{How would this be implemented given the existing codebase?}

### Components Affected
- `path/to/file1.ext` - {what changes}
- `path/to/file2.ext` - {what changes}

### New Components Needed
- `path/to/new/file.ext` - {purpose}

## Value Proposition

### For Users
- {Benefit 1}
- {Benefit 2}

### For Development
- {Benefit 1}
- {Benefit 2}

## Complexity Assessment

**Estimated Scope**: {small|medium|large|epic}

**Reasoning**:
- {Factor 1}
- {Factor 2}

## Dependencies
- {External dependency 1}
- {Prerequisite feature}

## Risks
- {Risk 1 and mitigation}
- {Risk 2 and mitigation}

## Alternatives Considered
1. {Alternative 1} - {why not chosen}
2. {Alternative 2} - {why not chosen}

## References
- {Similar implementation in other project}
- {Relevant documentation}
```

### Step 4: Prioritization and Summary

After all agents complete:

1. **Rank features** by:
   - Value to users (high/medium/low)
   - Implementation complexity (inverse)
   - Alignment with project direction
   - Dependencies (fewer is better)

2. **Generate summary report**:

```markdown
# Feature Proposal Report

**Project**: {project name}
**Analyzed**: {ISO timestamp}
**Context**: {user-provided context or "General analysis"}

## Project Understanding

### Tech Stack
- {stack summary}

### Existing Features
- {feature 1}
- {feature 2}
...

## Proposed Features

### High Priority (Quick Wins)
| Feature | Complexity | Value | Ticket |
|---------|------------|-------|--------|
| {name}  | {size}     | High  | FEAT-X |

### Medium Priority
| Feature | Complexity | Value | Ticket |
|---------|------------|-------|--------|
| {name}  | {size}     | Med   | FEAT-X |

### Future Considerations (Epics)
| Feature | Complexity | Value | Ticket |
|---------|------------|-------|--------|
| {name}  | Epic       | High  | FEAT-X |

## Recommended Roadmap

### Phase 1 (Quick Wins)
1. {Feature A} - {why first}
2. {Feature B} - {why second}

### Phase 2 (Core Enhancements)
3. {Feature C}
4. {Feature D}

### Phase 3 (Advanced Features)
5. {Feature E}

## Next Steps

Run `/aw:triage --source features` to review and approve features for implementation.
```

Save report to: `.autonomous-worker/generated/features/REPORT-{timestamp}.md`

## Analysis Guidelines

### What Makes a Good Feature Proposal

- **Concrete**: Specific enough to implement
- **Valuable**: Clear benefit to users or developers
- **Feasible**: Fits the existing architecture
- **Scoped**: Has clear boundaries
- **Independent**: Minimal dependencies on other new features

### Feature Categories

- **enhancement**: Improve existing functionality
- **new-feature**: Add new capability
- **integration**: Connect with external service
- **ux**: User experience improvement
- **infrastructure**: Developer experience, CI/CD, tooling

### Complexity Guidelines

- **small**: 1-2 files, <100 lines, done in one cycle
- **medium**: 3-5 files, <500 lines, 2-3 cycles
- **large**: 5-10 files, significant changes, 4-5 cycles
- **epic**: Multiple components, needs breakdown into smaller features

## Important Rules

- **Study first, propose second** - understand the project deeply
- **Be practical** - proposals should fit the existing architecture
- **Consider maintenance** - features need to be maintainable
- **NO implementation** - only analyze and propose
- **Respect project direction** - proposals should align with apparent goals
- **Quality over quantity** - better to have 5 great proposals than 20 mediocre ones
