---
name: learn
description: Run at the end of a work session or prototype sprint to surface patterns, mistakes, and friction, then propose concrete improvements to CLAUDE.md, templates, and skills. Use when the user says "let's review", "what did we learn", "/learn", or at the end of a significant piece of work.
user-invocable: true
---

# /learn

Self-improving feedback loop. Reviews what was built and proposes targeted updates to make the next session faster.

## Step 1 — Gather evidence

Read in order, skipping any that don't exist:

1. `git log --oneline -20` — what was shipped
2. `TASKS.md` — what was planned vs done; open questions
3. `ADR.md` — decisions and why (newest first)
4. `PRD.md` — current project state

## Step 2 — Analyse

Pick out:

- **Friction**: things that took longer than expected or required rework
- **Patterns**: decisions or code shapes that appeared more than once
- **Surprises**: deviations from the initial plan and why
- **What worked**: approaches worth repeating

## Step 3 — Propose improvements

For each finding, propose one concrete action targeting:

| Target | When to update |
|--------|---------------|
| `~/CLAUDE.md` | Global rule or guardrail for all projects |
| A skill prompt | Better instructions for a slash command |

Format:

```
### Proposal N: <title>
Target: <path>
Change: <what to add/modify/remove>
Reason: <evidence from this session>
```

Ask: "Which of these should I apply?" before making changes.

## Step 4 — Apply approved changes

For each approved proposal: make the edit, confirm what changed. If any affect dotfiles, prompt: "Want me to `/ship` these?"
