#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title CCA
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Dotfiles
# @raycast.argument1 { "type": "text", "placeholder": "project (optional)", "optional": true }

# Documentation:
# @raycast.description Open the Claude Code agent view in a new Ghostty window
# @raycast.author Francesco Galletta

set -uo pipefail

# Where the view opens with no argument. $HOME rather than /: the view lists
# every background agent whatever its cwd, but sessions *dispatched* from it
# inherit this directory, and one rooted at / gets no CLAUDE.md, no repo, and
# the whole filesystem in scope. Change this line to move it.
DEFAULT_DIR="$HOME"

TARGET="${1:-$DEFAULT_DIR}"

if [ ! -d "/Applications/Ghostty.app" ]; then
  echo "Ghostty not installed"
  exit 1
fi

# On macOS Ghostty cannot be launched from the CLI binary; `open -na` is the
# documented route, and --args passes `-e <command>` through to it.
#
# The inner shell is interactive so that ~/.zshrc loads, which is what defines
# `cca`. Reusing the function keeps the permission-mode flag and the zoxide
# lookup in one place instead of duplicating them here. If it is missing (fresh
# machine, zshrc not yet linked) the window would vanish before you could read
# the error, so hold it open long enough to see.
QUOTED_TARGET=$(printf '%q' "$TARGET")
open -na Ghostty --args -e /bin/zsh -ic \
  "cca ${QUOTED_TARGET} || { print -u2 'cca unavailable — check ~/.zshrc is linked'; sleep 5 }"

echo "Agent view opening in ${TARGET}"
