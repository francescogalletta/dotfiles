---
name: project-new
description: User-invoked scaffolder. Runs a discovery conversation, drafts PRD and TASKS for review, then scaffolds `~/projects/<name>/` with git, ADR, per-task files in `tasks/`, and a project-local `.claude/`. Container infra (Dockerfile, compose, Makefile) is built agentically afterwards when needed.
user-invocable: true
disable-model-invocation: true
---

# /project-new

**Do NOT create any files until the user explicitly confirms the PRD and task plan.**

## Phase 1 — Explore

Ask for the project name if not provided (no description arg — let the user explain freely).

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

1. `mkdir -p ~/projects/<name>/tasks`
2. `cd ~/projects/<name> && git init`
3. Write `CLAUDE.md` (see template)
4. Write `PRD.md` — use the approved draft
5. Write `TASKS.md` — use the approved draft
6. Write one `tasks/T###.md` per task (see template)
7. Write `ADR.md` (see template)
8. Write `CLAUDE.local.md` (see template)
9. Write `.gitignore` (see template)
10. Seed `.claude/`: write `.claude/settings.json`, `.claude/README.md`, `.claude/hooks/.gitkeep` (see templates)
11. `git add -A && git commit -m "Initial project scaffold"`

Container infra (Dockerfile, docker-compose.yml, Makefile, app code) is intentionally *not* scaffolded here. After Phase 4, the user describes what they want to build; the agent scaffolds the stack agentically based on real requirements rather than archetype guesswork.

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
- SessionStart hook briefs you on session start; run `/project-resume` for the full picture on demand
- Run `git log --oneline -10` to see recent activity
- Claim tasks in TASKS.md (set status + @owner) before starting
- Mark done + update changelog when completing
- Use `/ship` when committing and pushing work
```

### Template: `tasks/T###.md`

Generate one file per task using details from the conversation:

```markdown
# [T###] <Task title>

**Phase:** Phase 1: <name>
**Status:** `pending`
**Owner:** —
**BlockedBy:** —
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

### Template: `ADR.md`

```markdown
# Architecture Decision Records — <Name>

Reverse-chronological. Newest entry at top. After adding an entry, update PRD.md to reflect the current state.

---

<!-- Format: ## ADR-NNN: Decision title
**Date:** YYYY-MM-DD
**Decision:** What was decided.
**Reason:** Why. What alternatives were rejected.
**Supersedes:** ADR-NNN (if applicable) -->
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
.platform
```

### Template: `.claude/settings.json`

Minimal valid stub. Project-local settings merge with `~/.claude/settings.json`; empty arrays here mean "no project-specific additions yet — extend as needed."

```json
{
  "permissions": {
    "allow": [],
    "deny": []
  },
  "hooks": {}
}
```

### Template: `.claude/README.md`

```markdown
# Project-local Claude Code config

Files here merge with or override `~/.claude/`.

- `settings.json` — project-scoped permissions and hooks. Merged with global.
- `hooks/` — project-local hook scripts referenced from `settings.json`.
- `session-current.md` — gitignored. Project-resume handoff between sessions.
- `settings.local.json` — gitignored. Personal overrides not shared with the team.

## Adding a hook

Drop a script in `hooks/`, then reference it in `settings.json`:

\```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "bash .claude/hooks/lint.sh" }
        ]
      }
    ]
  }
}
\```
```

### Template: `.claude/hooks/.gitkeep`

Empty file so the directory is tracked.

## Phase 4 — Summary

After scaffolding, print:

```
Project created at ~/projects/<name>/

Files:
  CLAUDE.md                    — agent context (@imports PRD + TASKS)
  PRD.md                       — problem, requirements, tech stack
  TASKS.md                     — task index (one line per task)
  tasks/T001.md … T###.md      — per-task detail files
  ADR.md                       — architecture decision log (newest first)
  CLAUDE.local.md              — personal overrides (gitignored)
  .gitignore                   — default ignores
  .claude/settings.json        — project-local Claude Code settings (extend as needed)
  .claude/README.md            — convention doc for .claude/
  .claude/hooks/               — project-local hook scripts (empty by default)

Next:
  cd ~/projects/<name>
  Describe what you want to build — the agent will scaffold the stack
  /project-resume              — full briefing on demand (default is SessionStart hook)
```
