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
  "config/warp/themes:$HOME/.warp/themes:warp/themes"
  "config/warp/keybindings.yaml:$HOME/.warp/keybindings.yaml:warp/keybindings"
  "CLAUDE.md:$HOME/CLAUDE.md:CLAUDE.md"
  "config/claude/skills:$HOME/.claude/skills:claude/skills"
  "config/claude/settings.json:$HOME/.claude/settings.json:claude/settings"
  "config/claude/statusline.sh:$HOME/.claude/statusline.sh:claude/statusline"
  "config/obsidian/obsidian.json:$HOME/Library/Application Support/obsidian/obsidian.json:obsidian/settings"
)

# Codex config — only link if Codex is installed
command -v codex &>/dev/null && LINKS+=(
  "config/codex/config.toml:$HOME/.codex/config.toml:codex/config"
  "config/codex/model_catalog.json:$HOME/.codex/model_catalog.json:codex/model_catalog"
)

# Forge config — always link (forge reads ~/.forge/.forge.toml)
LINKS+=(
  "config/forge/forge.toml:$HOME/.forge/.forge.toml:forge/config"
)

# Editor configs — only link if the editor is installed
[ -d "/Applications/Zed.app" ] && LINKS+=(
  "config/zed/settings.json:$HOME/.config/zed/settings.json:zed/settings"
  "config/zed/keymap.json:$HOME/.config/zed/keymap.json:zed/keymap"
  "config/zed/tasks.json:$HOME/.config/zed/tasks.json:zed/tasks"
)
# Obsidian shared config -- link into each vault's .obsidian/ directory
if [ -d "/Applications/Obsidian.app" ] && command -v jq &>/dev/null; then
  _obsidian_json="$DOTFILES/config/obsidian/obsidian.json"
  if [ -f "$_obsidian_json" ]; then
    while IFS= read -r _vault_path; do
      [ -z "$_vault_path" ] && continue
      [ -d "$_vault_path" ] || continue
      _vault_name=$(basename "$_vault_path")
      for _cfg in appearance.json app.json core-plugins.json community-plugins.json hotkeys.json; do
        LINKS+=("config/obsidian/shared/$_cfg:$_vault_path/.obsidian/$_cfg:obsidian/$_cfg ($_vault_name)")
      done
    done < <(jq -r '.vaults | to_entries[] | .value.path' "$_obsidian_json" 2>/dev/null)
  fi
fi
