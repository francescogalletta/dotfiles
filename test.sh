#!/usr/bin/env bash
set -uo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

bold="\033[1m"
dim="\033[2m"
green="\033[0;32m"
red="\033[0;31m"
reset="\033[0m"

pass_count=0
fail_count=0

pass() { echo -e "  ✅  $1"; ((pass_count++)); }
fail() { echo -e "  ❌  $1  ${red}${2}${reset}"; ((fail_count++)); }

check() {
  local label="$1"; shift
  local output
  if output=$("$@" 2>&1); then
    pass "$label"
  else
    fail "$label" "$(echo "$output" | tail -3)"
  fi
}

echo ""
echo -e "  ${bold}dotfiles tests${reset}"
echo -e "  ${dim}─────────────────────────────────${reset}"
echo ""

# ─── Shell syntax ───────────────────────────────────────
check "zsh -n zshrc"      zsh -n "$DOTFILES/zshrc"
check "zsh -n zprofile"   zsh -n "$DOTFILES/zprofile"
check "zsh -n install.sh" zsh -n "$DOTFILES/install.sh"
check "zsh -n sync.sh"    zsh -n "$DOTFILES/sync.sh"
check "zsh -n links.sh"   zsh -n "$DOTFILES/links.sh"

# ─── JSON ───────────────────────────────────────────────
check "claude/settings.json"    jq empty "$DOTFILES/config/claude/settings.json"
check "cursor/settings.json"    jq empty "$DOTFILES/config/cursor/settings.json"
check "cursor/keybindings.json" jq empty "$DOTFILES/config/cursor/keybindings.json"

# ─── Starship TOML ──────────────────────────────────────
if command -v starship &>/dev/null; then
  check "starship.toml" \
    env STARSHIP_CONFIG="$DOTFILES/config/starship.toml" starship print-config
else
  echo -e "  ${dim}⏭️   starship.toml  (starship not found)${reset}"
fi

# ─── Ghostty config ─────────────────────────────────────
if command -v ghostty &>/dev/null; then
  check "ghostty config" ghostty +validate-config
else
  echo -e "  ${dim}⏭️   ghostty config  (ghostty not found)${reset}"
fi

# ─── Summary ────────────────────────────────────────────
echo ""
echo -e "  ${dim}─────────────────────────────────${reset}"
echo -e "  ${green}${pass_count} passed${reset}  ${red}${fail_count} failed${reset}"
echo ""

[ "$fail_count" -eq 0 ]
