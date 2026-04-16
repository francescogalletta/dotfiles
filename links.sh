#!/usr/bin/env bash
# Shared symlink definitions — sourced by install.sh and sync.sh
# Format: "relative_source:destination:label"

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

LINKS=(
  "zshrc:$HOME/.zshrc:zshrc"
  "zprofile:$HOME/.zprofile:zprofile"
  "gitconfig:$HOME/.gitconfig:gitconfig"
  "config/git/ignore:$HOME/.config/git/ignore:git/ignore"
  "config/ghostty/config:$HOME/.config/ghostty/config:ghostty"
  "config/starship.toml:$HOME/.config/starship.toml:starship"
  "config/warp/themes:$HOME/.warp/themes:warp/themes"
  "config/warp/keybindings.yaml:$HOME/.warp/keybindings.yaml:warp/keybindings"
  "CLAUDE.md:$HOME/CLAUDE.md:CLAUDE.md"
  "config/claude/skills:$HOME/.claude/skills:claude/skills"
  "config/claude/settings.json:$HOME/.claude/settings.json:claude/settings"
  "config/claude/statusline.sh:$HOME/.claude/statusline.sh:claude/statusline"
  "config/obsidian/obsidian.json:$HOME/Library/Application Support/obsidian/obsidian.json:obsidian/settings"
)

# Editor configs — only link if the editor is installed
[ -d "/Applications/Cursor.app" ] && LINKS+=(
  "config/cursor/settings.json:$HOME/Library/Application Support/Cursor/User/settings.json:cursor/settings"
  "config/cursor/keybindings.json:$HOME/Library/Application Support/Cursor/User/keybindings.json:cursor/keybindings"
)
[ -d "/Applications/Zed.app" ] && LINKS+=(
  "config/zed/settings.json:$HOME/.config/zed/settings.json:zed/settings"
  "config/zed/keymap.json:$HOME/.config/zed/keymap.json:zed/keymap"
  "config/zed/tasks.json:$HOME/.config/zed/tasks.json:zed/tasks"
)
