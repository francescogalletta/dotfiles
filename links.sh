#!/usr/bin/env bash
# Shared symlink definitions — sourced by install.sh and sync.sh
# Format: "relative_source:destination:label"

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

LINKS=(
  "zshrc:$HOME/.zshrc:zshrc"
  "gitconfig:$HOME/.gitconfig:gitconfig"
  "config/ghostty/config:$HOME/.config/ghostty/config:ghostty"
  "config/starship.toml:$HOME/.config/starship.toml:starship"
  "CLAUDE.md:$HOME/CLAUDE.md:CLAUDE.md"
  "claude/skills:$HOME/.claude/skills:claude/skills"
  "claude/settings.json:$HOME/.claude/settings.json:claude/settings"
  "claude/statusline.sh:$HOME/.claude/statusline.sh:claude/statusline"
)
