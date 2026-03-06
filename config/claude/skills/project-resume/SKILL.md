---
name: project-resume
description: Orient any agent (human or sub-agent) at session start — read VCS + docs, present briefing, propose next actions, wait for confirmation before starting work
user-invocable: true
---

# /project-resume

**Read first. Do NOT begin work or modify any files until the user (or orchestrating agent) confirms a task.**

## Step 1 — Ground truth from VCS

Run sequentially (each informs the next):

```
git log --oneline -10
git status --short
```

Note: branch name, remote tracking status (ahead/behind/no remote), uncommitted files.

## Step 2 — Read project docs

Read in this order (note any that are missing):

1. `CLAUDE.md`
2. `PRD.md`
3. `TASKS.md`
4. `DESIGN.md` (skip silently if absent)

If `TASKS.md` is missing entirely, suggest running `/project-new` to set up the project structure.

## Step 3 — Read handoff note (if present)

Read `.claude/session-current.md` if it exists. Skip gracefully if absent.

## Step 4 — Present briefing

Synthesise everything into this format:

```
## <Project name>
<one-line description from PRD>

### Repository
Branch: <name>
Remote: <ahead N / behind N / up-to-date / no remote>
Uncommitted: <list files, or "clean">

### Tasks
Done: <count of [x] lines in TASKS.md>
In Progress: <[T###] title @owner, or "none">
Next pending: <top 2–3 [T###] titles>

### Open Questions
<from TASKS.md, or "none">

### Key Design Decisions
<1–2 most recent entries from DESIGN.md, or "none recorded">

### Last Session
<summary from .claude/session-current.md, or "no handoff note found">
```

Flag any git housekeeping needed before work begins:
- Behind remote → suggest pull
- Ahead of remote → suggest push
- Uncommitted changes → ask: commit, stash, or ignore?

## Step 5 — Propose next actions

Suggest the top 2–3 concrete next actions by task ID, e.g.:

> Suggested next:
> 1. [T002] Set up database schema
> 2. [T003] Implement auth endpoints
> 3. Pull latest from remote (currently 2 commits behind)

Ask: "What do you want to work on?"

**Wait for selection. Do NOT begin work until confirmed.**

## Step 6 — Claim task and begin

On selection:

1. In `TASKS.md`: move the task line to the **In Progress** section, set status to `` `in_progress` ``, add `@<owner>` (use your agent name or `@claude` if solo)
2. In `tasks/T###.md`: update **Status** and **Owner** fields
3. Begin work

When the task is complete, use `/ship` to commit and push.

### session-current.md convention

At the end of any significant work session, write (overwrite) `.claude/session-current.md`:

```markdown
# Session Note — <date>

## Completed
- [T###] <what was done>

## In Flight
- [T###] <what was started but not finished>

## Blockers / Open Questions
- ...
```

This file is gitignored (local only). `/project-resume` reads it on next session start.
