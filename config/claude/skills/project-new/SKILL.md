---
name: project-new
description: Start a new multi-agent project — discover requirements conversationally, draft PRD.md + TASKS.md, then scaffold on confirmation
user-invocable: true
disable-model-invocation: true
---

# /project-new

**Do NOT create any files until the user explicitly confirms the PRD and task plan.** Two phases: Explore, then Crystallise.

## Phase 1 — Explore

Ask for the project name if not provided (no description arg — let the user explain freely).

Then have an open-ended discovery conversation. Ask one or a few questions at a time and wait for answers. Cover:

- What problem does this solve? Who is it for?
- What does success look like? Any hard constraints?
- Must-have requirements vs nice-to-haves; explicit non-goals
- Language / framework preferences; infrastructure or external service constraints

Adapt questions to what the user says — don't mechanically run through a fixed list. Probe gaps. When you have a thorough picture, say:

> "I have enough to write the PRD — want me to go ahead?"

**Do NOT proceed until the user says yes.**

## Phase 2 — Crystallise

Show the PRD.md and TASKS.md drafts inline in chat for review. Iterate until the user approves.

### PRD.md draft format

```markdown
# <Name> — PRD

<one-line description>

## Problem
...

## Audience
...

## Success Criteria
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
```

### TASKS.md draft format

A lightweight index — one line per task, all detail goes in the task file. Derive tasks from the requirements; group into phases; assign IDs starting at T001.

```markdown
# Tasks — <Name>

## In Progress
<!-- agents move tasks here when claiming them -->

## Phase 1: <name>
- [ ] [T001] First task — `pending` → [tasks/T001.md](tasks/T001.md)
- [ ] [T002] Second task — `pending` → [tasks/T002.md](tasks/T002.md)

## Open Questions
- ...

## Changelog
- 2026-03-03: Project created
```

Task line format: `- [ ] [T###] One-line description — \`status\` [@owner] [blockedBy:T###] → [tasks/T###.md](tasks/T###.md)`

Ask: "Does this look right? Any changes before I scaffold the project?"

**Do NOT scaffold until the user confirms.**

## Phase 3 — Scaffold

After confirmation, create all files in order:

1. `mkdir -p ~/projects/<name>/.claude/agents ~/projects/<name>/.claude/skills ~/projects/<name>/.claude/rules ~/projects/<name>/tasks`
2. `cd ~/projects/<name> && git init`
3. Write `CLAUDE.md` (see template)
4. Write `PRD.md` — use the approved draft
5. Write `TASKS.md` — use the approved draft
6. Write one `tasks/T###.md` per task (see template)
7. Write `CLAUDE.local.md` (see template)
8. Write `.gitignore` (see template)
9. `git add -A && git commit -m "Initial project scaffold"`

### Template: `CLAUDE.md` (≤60 lines)

```markdown
# <Name>

<one-line description>

## Context
@PRD.md
@TASKS.md

## Session Rules
- Follow global ~/CLAUDE.md as baseline
- Read PRD.md for intent; read TASKS.md for current state
- Run `git log --oneline -10` to see recent activity
- Claim tasks in TASKS.md (set status + @owner) before starting
- Mark done + update changelog when completing
- Commit frequently with clear messages
```

### Template: `tasks/T###.md`

Generate one file per task using details from the conversation:

```markdown
# [T###] <Task title>

**Phase:** Phase 1: <name>
**Status:** `pending`
**Owner:** —
**BlockedBy:** —
**Blocks:** —

## Goal
What this task achieves and why it matters.

## Acceptance Criteria
- [ ] Specific, verifiable outcome 1
- [ ] Specific, verifiable outcome 2

## Context
Relevant background, constraints, decisions from the PRD.

## Notes
<!-- Agents append dated notes here when context is clarified or decisions are made. Never edit prior notes — only append. -->

## References
- PRD.md — relevant section
```

### Template: `CLAUDE.local.md`

```markdown
# Local Overrides — <Name>

Personal notes and overrides not committed to the repo.
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
CLAUDE.local.md
.claude/session-current.md
```

## Phase 4 — Summary

After scaffolding, print:

```
Project created at ~/projects/<name>/

Files:
  CLAUDE.md                    — agent context (≤60 lines, @imports PRD + TASKS)
  PRD.md                       — problem, requirements, tech stack
  TASKS.md                     — task index (one line per task)
  tasks/T001.md … T###.md      — per-task detail files
  .claude/agents/              — ready for sub-agent definitions
  .claude/skills/              — ready for project slash commands
  .claude/rules/               — ready for topic-scoped rules
  CLAUDE.local.md              — personal overrides (gitignored)
  .gitignore

Next:
  cd ~/projects/<name>
  /project-resume              — to orient any agent (including you) at session start
```
