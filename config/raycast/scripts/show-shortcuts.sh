#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Show Shortcuts
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ⌨️
# @raycast.packageName Dotfiles

# Documentation:
# @raycast.description Show custom keybindings for the frontmost app
# @raycast.author Francesco Galletta

DOTFILES="${HOME}/dotfiles"
SHORTCUTS_DIR="${DOTFILES}/config/raycast/shortcuts"

APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

case "$APP_NAME" in
  "Ghostty")  FILE="ghostty.md" ;;
  "Warp")     FILE="warp.md" ;;
  "Zed")      FILE="zed.md" ;;
  "Cursor")   FILE="cursor.md" ;;
  "Obsidian") FILE="obsidian.md" ;;
  *)          FILE="" ;;
esac

if [ -z "$FILE" ] || [ ! -f "$SHORTCUTS_DIR/$FILE" ]; then
  echo "No shortcuts configured for: $APP_NAME"
  echo ""
  echo "Available apps:"
  for f in "$SHORTCUTS_DIR"/*.md; do
    [ -f "$f" ] && basename "$f" .md
  done
  exit 0
fi

cat "$SHORTCUTS_DIR/$FILE"
