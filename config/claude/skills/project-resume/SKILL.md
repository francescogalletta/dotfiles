---
name: project-resume
description: Resume work on an existing project by reading docs, summarizing state, and picking next task
user-invocable: true
disable-model-invocation: true
---

# /project-resume

You are helping the user resume work on an existing project. **Read first, write only after user confirms direction.**

## Phase 1: Read Project State

**Step 1:** Read project files (note any that are missing):
- `PROJECT.md`
- `DESIGN.md`
- `.claude/CLAUDE.md`

**Step 2:** Check git state with: `git fetch 2>/dev/null; git status`
- Fetch silently updates from remote (no-op if no remote)
- Status shows branch, ahead/behind, and uncommitted changes

**Step 3:** Get recent commits: `git log --oneline -10`

IMPORTANT: Do NOT run file reads and git commands in parallel. Run file reads first, then git commands.

## Phase 2: Present Briefing

Summarize what you found in this format:

```
## Project: <name>
<description>

### Repository
**Branch:** <current branch>
**Remote:** <remote status — ahead/behind/up-to-date/no remote>
**Uncommitted:** <list or "Working tree clean">

### Current Phase
Phase N: <name> — <progress summary>

### Recent Activity
<group last few commits by theme, e.g. "Set up auth (3 commits)", not raw git log>

### Task Status
**Done:** N tasks
**In Progress:** <list any>
**Next Up:** <list top 2-3 unchecked tasks>

### Open Questions
<list from PROJECT.md, or "None">
```

## Phase 3: Suggest Actions & Ask Direction

Before asking what to work on, suggest any git housekeeping:
- If behind remote: suggest pulling
- If ahead of remote: suggest pushing
- If uncommitted changes: note them and ask if they should be committed or stashed
- If no remote: suggest creating one with `gh repo create`

Then suggest the top 2-3 tasks from the next-up list.

Ask: "What do you want to work on?"

Let the user pick a suggested action, a task, or specify something else.

## Phase 4: Update Docs

Only after the user confirms what to work on:
- Mark the chosen task as in-progress in `PROJECT.md` (prefix with `~` or note it)
- Do NOT modify any other docs at this point

Then begin working on the chosen task.
