---
name: ship
description: Stage all changes, propose a spartan commit message, wait for confirmation, then commit and push
user-invocable: true
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*)
---

# /ship

## Step 1 — Read the diff

Run:
```
git status --short
git diff HEAD
```

If the working tree is clean (nothing to commit), say so and stop.

## Step 2 — Propose a commit message

Write one line. Rules:
- Imperative mood: "Add …", "Fix …", "Refactor …", "Remove …"
- No type prefix, no scope, no period, no emoji
- ≤72 characters
- Captures the key achievement, not a list of files changed

Present it like:

```
Commit message:

  <message>

Ship it? (y to confirm, or tell me what to change)
```

**Wait for response. Do not commit until confirmed.**

## Step 3 — Commit and push

On confirmation (any of: y, yes, ok, ship, lgtm, looks good):
1. `git add -A`
2. `git commit -m "<message>"`
3. `git push`

If the user edits the message instead, use their version verbatim.

If `git push` fails because there is no upstream, run:
`git push --set-upstream origin <branch>` and report the result.

Print the final commit hash and push status on completion.
