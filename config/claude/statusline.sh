#!/usr/bin/env bash

# Read JSON input from Claude
input=$(cat)

# Get current working directory from input
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Truncate directory path (show last 3 components, or from repo root)
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  git_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  if [[ "$cwd" == "$git_root" ]]; then
    dir=$(basename "$cwd")
  else
    rel_path="${cwd#$git_root/}"
    dir="$(basename "$git_root")/$rel_path"
  fi
else
  # Show last 3 components
  dir=$(echo "$cwd" | awk -F'/' '{if(NF<=3) print $0; else print $(NF-2)"/"$(NF-1)"/"$NF}')
fi

output="$dir"

# Git branch (bold purple to match Starship)
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    output="$output $(printf '\033[1;35m%s\033[0m' "$branch")"
  fi

  # Git status (bold red to match Starship) - skip locks for speed
  if [[ -n "$(git -C "$cwd" -c core.useBuiltinFSMonitor=true status --porcelain 2>/dev/null)" ]]; then
    output="$output $(printf '\033[1;31m*\033[0m')"
  fi
fi

echo "$output"
