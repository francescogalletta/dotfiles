---
name: project-new
description: Scaffold a new project with structured planning conversation, docs, and git init
user-invocable: true
argument-hint: "[name] [description]"
disable-model-invocation: true
---

# /project-new [name] [description]

You are guiding the user through creating a new project. **Do NOT create any files until explicitly told to proceed.** Conversation first, files second.

## Input

- `name`: project directory name (kebab-case)
- `description`: one-line project description

If either is missing, ask for it before continuing.

## Phase 1: Gather Context (3 rounds — wait for answers between each)

**Round 1 — Goals:**
- What problem does this solve?
- Who is it for?
- What does "done" look like?

**Round 2 — Requirements:**
- What are the must-have features?
- What are the nice-to-haves?
- Any explicit non-goals?

**Round 3 — Tech Choices:**
- Language / framework preferences?
- Any infrastructure constraints?
- External services or APIs involved?

After each round, wait for the user to respond before asking the next round.

## Phase 2: Confirm

Summarize everything gathered in this format:

```
## Project: <name>
<description>

### Goals
- ...

### Requirements
**Must have:** ...
**Should have:** ...
**Nice to have:** ...

### Non-goals
- ...

### Tech Stack
| Component | Choice | Rationale |
|-----------|--------|-----------|
| ... | ... | ... |

### Phased Plan
- Phase 1: ...
- Phase 2: ...
- Phase 3: ...
```

Ask: "Does this look right? Any changes before I create the project?"

**Do NOT proceed until the user confirms.**

## Phase 3: Scaffold

Only after confirmation, create the project:

1. `mkdir -p ~/projects/<name>/.claude`
2. `cd ~/projects/<name> && git init`
3. Write `.claude/CLAUDE.md` (see template below)
4. Write `PROJECT.md` at project root (see template below)
5. Write `DESIGN.md` at project root (see template below)
6. Write `.gitignore` (see template below)
7. `git add -A && git commit -m "Initial project scaffold"`

### Template: `.claude/CLAUDE.md`

```markdown
# <Name>

<description>

## Session Start

- Read `PROJECT.md` for current state, tasks, and plan
- Read `DESIGN.md` for architecture decisions
- Run `git log --oneline -10` to see recent activity

## Rules

- Follow the global `~/CLAUDE.md` as baseline — this file adds project-specific rules
- Update `PROJECT.md` when the plan changes or tasks are completed
- Add entries to `DESIGN.md` when making architecture or design decisions
- Track task status with checkboxes in PROJECT.md
- Commit frequently with clear messages
```

### Template: `PROJECT.md`

Populate from the conversation. Use this structure:

```markdown
# <Name>

<description>

## Goals
- ...

## Non-Goals
- ...

## Requirements

### Must Have
- ...

### Should Have
- ...

### Nice to Have
- ...

## Tech Stack

| Component | Choice | Rationale |
|-----------|--------|-----------|
| ... | ... | ... |

## Plan

### Phase 1: <name>
- ...

### Phase 2: <name>
- ...

## Tasks

### Phase 1
- [ ] Task 1
- [ ] Task 2

## Open Questions
- ...

## Changelog
- YYYY-MM-DD: Project created
```

### Template: `DESIGN.md`

```markdown
# Design Decisions — <Name>

Architecture Decision Records for the project. Append entries as decisions are made.

---

*No decisions recorded yet.*

<!-- ADR format:
## YYYY-MM-DD: <Title>
**Decision:** What was decided
**Reason:** Why
-->
```

### Template: `.gitignore`

```
node_modules/
.env
.env.*
!.env.example
dist/
build/
*.log
.DS_Store
__pycache__/
*.pyc
.venv/
```

## Phase 4: Summary

After scaffolding, print:

```
Project created at ~/projects/<name>/

Files:
  .claude/CLAUDE.md    — project-specific rules (complements ~/CLAUDE.md)
  PROJECT.md           — goals, plan, and task tracking
  DESIGN.md            — architecture decisions (grows over time)
  .gitignore           — sensible defaults

Next steps:
  cd ~/projects/<name>
  Pick a task from Phase 1 in PROJECT.md
  Use /project-resume to catch up in future sessions
```
