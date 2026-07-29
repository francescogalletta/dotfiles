#!/usr/bin/env bash
# SessionStart briefing for managed projects (TASKS.md present).
# Output is consumed by Claude Code as a system-reminder.
set -uo pipefail

if [ ! -f TASKS.md ]; then
  echo "No TASKS.md — not a managed project."
  exit 0
fi

proj=$(basename "$PWD")
branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "(detached)")

if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
  ahead=$(git rev-list --count "$upstream..HEAD" 2>/dev/null || echo 0)
  behind=$(git rev-list --count "HEAD..$upstream" 2>/dev/null || echo 0)
  if   [ "$ahead" = 0 ] && [ "$behind" = 0 ]; then sync_state="up-to-date"
  elif [ "$behind" = 0 ];                    then sync_state="ahead $ahead"
  elif [ "$ahead"  = 0 ];                    then sync_state="behind $behind"
  else                                            sync_state="diverged +$ahead/-$behind"
  fi
else
  sync_state="no remote"
fi

dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$dirty" = 0 ]; then dirty_state="clean"; else dirty_state="$dirty uncommitted"; fi

echo "$proj: $branch, $sync_state, $dirty_state"

if git log -1 >/dev/null 2>&1; then
  echo "Last 3 commits:"
  git log --oneline -3 2>/dev/null | sed 's/^/  /'
fi

next=$(grep -E '^- \[ \] \[T[0-9]+\]' TASKS.md 2>/dev/null | head -3)
if [ -n "$next" ]; then
  echo "Next tasks:"
  printf '%s\n' "$next" | sed -E 's/^- \[ \] /  /; s/ — `[^`]*`.*$//'
fi
