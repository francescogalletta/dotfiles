---
name: project-new
description: Use whenever a user wants to start a brand-new project, app, tool, service, or side project — even if they just say "I want to build X", "let's kick off Y", or "new project: Z". Handles the full workflow: structured discovery conversation, PRD.md + TASKS.md drafts for review, then scaffolds a complete project directory with git, per-task files, and agent-ready config. Trigger on any fresh project start, not just explicit /project-new invocations.
user-invocable: true
disable-model-invocation: true
---

# /project-new

**Do NOT create any files until the user explicitly confirms the PRD and task plan.**

## Phase 1 — Explore

Ask for the project name if not provided (no description arg — let the user explain freely).

Then ask what archetype fits best — show this menu:

```
Which archetype fits best?

  data    — Python + Jupyter + Streamlit (+ optional Postgres)
  web     — FastAPI backend + Next.js frontend
  api     — FastAPI standalone REST API
  cli     — Python + Typer CLI tool
  agent   — Python + Anthropic SDK (AI/agentic workflows)
  none    — skip template, scaffold docs only
```

Wait for the user to pick one.

Then have an open-ended discovery conversation. Ask one or a few questions at a time and wait for answers. Cover:

- What problem does this solve? Who is it for?
- What does success look like? Any hard constraints?
- Must-have requirements vs nice-to-haves; explicit non-goals
- Any additional services, integrations, or external dependencies

Adapt questions to what the user says — don't mechanically run through a fixed list. Probe gaps. When you have a thorough picture, say:

> "I have enough to write the PRD — want me to go ahead?"

**Do NOT proceed until the user says yes.**

## Phase 2 — Crystallise

Show the PRD.md and TASKS.md drafts inline in chat. Then ask: "What would you like to change?" Keep iterating until the user signals they're happy (e.g. "looks good", "go ahead", "ship it").

**Do NOT scaffold until the user confirms.**

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

## Phase 3 — Scaffold

Default location: `~/projects/<name>`. If the user has mentioned a different location during the conversation, use that instead — otherwise proceed with the default.

Create all files in order:

1. `mkdir -p ~/projects/<name>/.claude/agents ~/projects/<name>/.claude/skills ~/projects/<name>/.claude/rules ~/projects/<name>/tasks`
2. **If archetype is not `none`**: copy template files from `~/dotfiles/templates/<archetype>/` into `~/projects/<name>/`. Use `cp -r ~/dotfiles/templates/<archetype>/. ~/projects/<name>/` — this copies all files including hidden ones.
3. `cd ~/projects/<name> && git init`
4. Write `CLAUDE.md` (see template)
5. Write `PRD.md` — use the approved draft
6. Write `TASKS.md` — use the approved draft
7. Write one `tasks/T###.md` per task (see template)
8. Write `DESIGN.md` (see template)
9. Write `CLAUDE.local.md` (see template)
10. If no `.gitignore` exists yet (i.e. archetype was `none`), write the default `.gitignore`
11. `git add -A && git commit -m "Initial project scaffold"`

After scaffolding, ask: "Want me to run `make dev` to verify it starts?" If yes, run `cd ~/projects/<name> && make dev` and confirm it comes up.

### Template: `CLAUDE.md` (≤60 lines)

```markdown
# <Name>

<one-line description>

## Context
@PRD.md
@TASKS.md

## Stack
<archetype> template — see README.md for how to run.

## Session Rules
- Follow global ~/CLAUDE.md as baseline
- Read PRD.md for intent; read TASKS.md for current state
- Run `/project-resume` at session start to orient yourself
- Run `git log --oneline -10` to see recent activity
- Claim tasks in TASKS.md (set status + @owner) before starting
- Mark done + update changelog when completing
- Use `/ship` when committing and pushing work
- Standard Makefile targets: `make dev`, `make test`, `make shell`, `make logs`, `make stop`
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
**Validation:** <what the user needs to approve, or "none — agent can proceed autonomously">

## Goal
What this task achieves and why it matters.

## Acceptance Criteria
- [ ] Specific, verifiable outcome 1
- [ ] Specific, verifiable outcome 2

## Context
Relevant background, constraints, decisions from the PRD.

## Decisions
<!-- Append dated notes when significant choices are made during this task. Never edit prior entries — only append. -->

## Notes
<!-- Append dated notes when context is clarified. Never edit prior entries — only append. -->

## References
- PRD.md — relevant section
```

### Template: `DESIGN.md`

```markdown
# Design — <Name>

Architecture decisions and technical choices. Append-only — never edit past entries.

<!-- Format: ## [T###] Decision title — YYYY-MM-DD
Briefly state: what was decided, why, and what alternatives were rejected. -->
```

### Template: `CLAUDE.local.md`

```markdown
# Local Overrides — <Name>

Personal notes and overrides not committed to the repo.
```

### Template: `.gitignore` (used only when archetype is `none`)

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
.platform
```

## Phase 4 — Summary

After scaffolding, print:

```
Project created at ~/projects/<name>/

Archetype: <archetype>

Files:
  CLAUDE.md                    — agent context (@imports PRD + TASKS)
  PRD.md                       — problem, requirements, tech stack
  TASKS.md                     — task index (one line per task)
  tasks/T001.md … T###.md      — per-task detail files
  DESIGN.md                    — architecture decision log (append-only)
  .claude/agents/              — ready for sub-agent definitions
  .claude/skills/              — ready for project slash commands
  .claude/rules/               — ready for topic-scoped rules
  CLAUDE.local.md              — personal overrides (gitignored)
  <template files>             — docker-compose.yml, Makefile, README.md, etc.

Next:
  cd ~/projects/<name>
  make dev                     — start services
  /project-resume              — orient any agent at session start
  /graduate                    — when ready to deploy
```
