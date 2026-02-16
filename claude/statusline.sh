#!/usr/bin/env bash

# Get current directory (shortened)
dir=$(basename "$PWD")

# Get git branch if in a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  branch_info=" • ${branch}"
else
  branch_info=""
fi

# Output format: directory • branch | context • api
echo "${dir}${branch_info}"
