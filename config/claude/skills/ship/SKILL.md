---
name: ship
description: Stage all changes, propose a spartan commit message, wait for confirmation, then commit and push
user-invocable: true
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*)
---

# /ship

1. Run `git status --short` and `git diff HEAD`. If the tree is clean, say so and stop.

2. Propose a one-line commit message:
   - Imperative mood ("Add X", "Fix Y", "Refactor Z")
   - No type prefix, no scope, no period, no emoji
   - ≤72 characters; captures the *why*, not a file list

   Present as:
   ```
   Commit message:

     <message>

   Ship it? (y to confirm, or edit)
   ```

   **Do not commit until confirmed.** If the user edits the message, use their version verbatim.

3. On confirmation: `git add -A`, `git commit -m "<message>"`, `git push`. If push fails with no upstream, retry with `--set-upstream origin <branch>`.
