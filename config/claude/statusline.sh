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

# Model name (dim cyan)
model=$(echo "$input" | jq -r '.model.display_name // empty')
if [[ -n "$model" ]]; then
  output="$output $(printf '\033[2;36m%s\033[0m' "$model")"
fi

# Context usage percentage (dim yellow; colour shifts to red above 80%)
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [[ -n "$used_pct" ]]; then
  used_int=$(printf '%.0f' "$used_pct")
  if (( used_int >= 80 )); then
    ctx_color='\033[2;31m'
  else
    ctx_color='\033[2;33m'
  fi
  output="$output $(printf "${ctx_color}ctx:${used_int}%%\033[0m")"
fi

# Rate limit indicators (dim magenta; shown only when data is present)
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rate_str=""
if [[ -n "$five_pct" ]]; then
  rate_str="5h:$(printf '%.0f' "$five_pct")%"
fi
if [[ -n "$seven_pct" ]]; then
  [[ -n "$rate_str" ]] && rate_str="$rate_str "
  rate_str="${rate_str}7d:$(printf '%.0f' "$seven_pct")%"
fi
if [[ -n "$rate_str" ]]; then
  output="$output $(printf '\033[2;35m%s\033[0m' "$rate_str")"
fi

echo "$output"
