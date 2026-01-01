# Template: CLAUDE.md Section for Autonomous Worker

Add this section to your project's CLAUDE.md file to provide context for the autonomous worker system.

---

## Autonomous Worker Context

This section contains project-specific information for the autonomous-worker plugin to understand and adapt to your codebase.

### Project Overview

<!-- Brief description of what this project does -->
**Project:** [Project Name]
**Type:** [Web App / API / Library / CLI / etc.]
**Stack:** [Main technologies used]

### Tech Stack Details

<!-- List the main technologies with versions if important -->
- **Language:** [Python 3.11 / Node 20 / Ruby 3.2 / etc.]
- **Framework:** [FastAPI / Express / Rails / etc.]
- **Database:** [PostgreSQL / MongoDB / SQLite / etc.]
- **Testing:** [pytest / jest / rspec / etc.]
- **Build:** [Make / npm scripts / etc.]

### Code Conventions

<!-- Document your project's specific conventions -->

#### Naming
- Files: [snake_case / kebab-case / PascalCase]
- Classes: [PascalCase]
- Functions: [snake_case / camelCase]
- Variables: [snake_case / camelCase]
- Constants: [UPPER_SNAKE_CASE]

#### Structure
```
src/
├── models/          # Data models
├── services/        # Business logic
├── routes/          # API endpoints
├── utils/           # Helpers
└── config/          # Configuration
```

#### Patterns to Follow
- [Pattern 1: e.g., "All services inherit from BaseService"]
- [Pattern 2: e.g., "Use dependency injection for database connections"]
- [Pattern 3: e.g., "Validators are in separate files from models"]

### Critical Files - DO NOT MODIFY

<!-- Files that should never be changed without explicit approval -->
- `config/production.yml` - Production secrets
- `migrations/` - Only add, never modify existing
- `.env.example` - Keep in sync with .env

### Atypical Behaviors

<!-- Document any unusual patterns or workarounds -->

#### [Area 1]
**What:** [Description of unusual behavior]
**Why:** [Reason for this approach]
**How:** [How to work with it]

#### [Area 2]
**What:** [Description]
**Why:** [Reason]
**How:** [Instructions]

### Domain Knowledge

<!-- Important business/domain concepts the AI should understand -->

- **[Concept 1]:** [Definition and how it's used in code]
- **[Concept 2]:** [Definition and how it's used in code]
- **[Concept 3]:** [Definition and how it's used in code]

### Known Issues / Technical Debt

<!-- Things the AI should be aware of but not necessarily fix -->
- [ ] [Issue 1] - Tracked in [link]
- [ ] [Issue 2] - Low priority
- [ ] [Issue 3] - Planned for [milestone]

### Testing Requirements

<!-- What tests are required before committing -->
- **Unit tests:** Required for all new functions
- **Integration tests:** Required for API endpoints
- **Coverage:** Minimum [X]% for new code
- **Run command:** `[npm test / pytest / etc.]`

### Git Workflow

- **Main branch:** `main` (production)
- **Integration branch:** `staging`
- **Feature branches:** `feature/aw-<task-slug>` (from staging)
- **Commit style:** [Conventional commits / etc.]

### Environment Setup

<!-- How to set up the development environment -->
```bash
# Install dependencies
[npm install / pip install -r requirements.txt / bundle install]

# Set up database
[command to setup db]

# Run development server
[npm run dev / python app.py / rails server]

# Run tests
[test command]
```

### API Authentication

<!-- If relevant, how auth works -->
- **Type:** [JWT / API Key / OAuth / etc.]
- **Header:** [Authorization: Bearer <token>]
- **Test credentials:** See `.env.example`

### External Services

<!-- External APIs or services the project uses -->
| Service | Purpose | Docs |
|---------|---------|------|
| [Service 1] | [What it does] | [link] |
| [Service 2] | [What it does] | [link] |

### Personal Preferences

<!-- Your personal working style preferences -->
- **Verbosity:** [Prefer concise / detailed explanations]
- **Comments:** [Minimal / Document everything]
- **Refactoring:** [Only when asked / Proactive improvements]
- **Questions:** [Ask before assuming / Make reasonable assumptions]

---

## Usage

Copy the content above (from `## Autonomous Worker Context`) into your project's `CLAUDE.md` file and fill in the placeholders with your project-specific information.

The autonomous-worker agents will read this section to:
1. Understand your codebase structure
2. Follow your conventions
3. Avoid touching critical files
4. Work around known issues
5. Respect your preferences
