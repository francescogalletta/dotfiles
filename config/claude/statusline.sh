#!/usr/bin/env bash

# Claude Code status line — rich session info
# Receives JSON via stdin with model, context, cost, rate limits, and workspace data.

input=$(cat)
jq_get() { echo "$input" | jq -r "$1 // empty"; }

# --- Colors ---
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
CYAN='\033[36m'

# --- Model ---
model=$(jq_get '.model.display_name')

# --- Context window ---
ctx_pct=$(jq_get '.context_window.used_percentage' | cut -d. -f1)
if [[ -n "$ctx_pct" ]]; then
  if   (( ctx_pct >= 80 )); then ctx_color="$RED"
  elif (( ctx_pct >= 50 )); then ctx_color="$YELLOW"
  else                           ctx_color="$GREEN"
  fi
  ctx_str="${ctx_color}${ctx_pct}%${RESET}"
else
  ctx_str="${DIM}—${RESET}"
fi

# --- 5-hour rate limit (Pro/Max) ---
quota_pct=$(jq_get '.rate_limits.five_hour.used_percentage' | cut -d. -f1)
if [[ -n "$quota_pct" ]]; then
  if   (( quota_pct >= 80 )); then q_color="$RED"
  elif (( quota_pct >= 50 )); then q_color="$YELLOW"
  else                             q_color="$GREEN"
  fi
  quota_str="${q_color}${quota_pct}%${RESET}"
else
  quota_str="${DIM}—${RESET}"
fi

# --- Session cost ---
cost=$(jq_get '.cost.total_cost_usd')
if [[ -n "$cost" ]]; then
  cost_str=$(printf '$%.2f' "$cost")
else
  cost_str="${DIM}—${RESET}"
fi

# --- Git (directory + branch + dirty) ---
cwd=$(jq_get '.workspace.current_dir')
git_str=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  git_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  if [[ "$cwd" == "$git_root" ]]; then
    dir=$(basename "$cwd")
  else
    dir="$(basename "$git_root")/${cwd#$git_root/}"
  fi
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  dirty=""
  if [[ -n "$(git -C "$cwd" -c core.useBuiltinFSMonitor=true status --porcelain 2>/dev/null)" ]]; then
    dirty=" ${BOLD}${RED}*${RESET}"
  fi
  git_str="${dir} ${BOLD}${PURPLE}${branch}${RESET}${dirty}"
else
  dir=$(echo "$cwd" | awk -F'/' '{if(NF<=3) print $0; else print $(NF-2)"/"$(NF-1)"/"$NF}')
  git_str="$dir"
fi

# --- Assemble ---
# Line 1: git info
# Line 2: model | context | quota | cost
echo -e "$git_str"
echo -e "${BOLD}${model}${RESET} ${DIM}|${RESET} ctx ${ctx_str} ${DIM}|${RESET} quota ${quota_str} ${DIM}|${RESET} ${cost_str}"
