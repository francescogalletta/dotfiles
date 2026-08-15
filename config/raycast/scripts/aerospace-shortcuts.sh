#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title AeroSpace Shortcuts
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🪟
# @raycast.packageName Dotfiles

# Documentation:
# @raycast.description Window manager keybindings at a glance
# @raycast.author Francesco Galletta

# A titled wrapper, so typing "aerospace" in Raycast root search finds it.
# AeroSpace is never the frontmost app, so the bare Show Shortcuts command
# can't reach it without an argument.
exec "$(dirname "$0")/show-shortcuts.sh" aerospace
