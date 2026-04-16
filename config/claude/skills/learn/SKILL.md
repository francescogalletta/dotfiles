---
name: learn
description: Run at the end of a work session or prototype sprint to surface patterns, mistakes, and friction — then propose concrete improvements to CLAUDE.md, templates, and skills. Use when the user says "let's review", "what did we learn", "/learn", or at the end of a significant piece of work.
user-invocable: true
---

# /learn

Self-improving feedback loop. Reviews what was built and proposes targeted updates to make the next session faster.

## Step 1 — Gather evidence

Read the following in order:

1. `git log --oneline -20` — what was shipped
2. `TASKS.md` — what was planned vs done; open questions
3. `ADR.md` — decisions made and why (newest first)
4. `PRD.md` — current project state

If any of these files don't exist, skip them.

## Step 2 — Analyse

Identify:

- **Friction points**: things that took longer than expected, required rework, or caused confusion
- **Recurring patterns**: decisions or code shapes that appeared more than once
- **Surprises**: things that differed from the initial plan and why
- **What worked well**: approaches worth repeating

Present a brief summary (bullet points, no filler):

```
## What we built
- ...

## Friction points
- ...

## Patterns worth encoding
- ...

## What worked well
- ...
```

## Step 3 — Propose improvements

For each finding, propose a concrete action in one of these categories:

| Target | When to update |
|--------|---------------|
| `~/CLAUDE.md` | New global rule or guardrail that should apply to all projects |
| `~/dotfiles/templates/<archetype>/` | Template improvement for this stack |
| A skill prompt | Better instructions for a slash command |
| Memory | Fact worth remembering across sessions |

Format proposals as:

```
### Proposal 1: <short title>
Target: ~/CLAUDE.md (or templates/api/, etc.)
Change: <what to add/modify/remove>
Reason: <what evidence from this session supports it>
```

Ask the user: "Which of these should I apply?" before making any changes.

## Step 4 — Apply approved changes

For each approved proposal:

1. Make the edit (Edit tool)
2. Confirm what changed

If any changes affect dotfiles, prompt: "Want me to `/ship` these?"

## Step 5 — Save memories

Save any facts worth remembering in future sessions using the memory system:
- Preferences revealed during this session
- Stack or tool decisions that are now settled
- Friction that wasn't already recorded
