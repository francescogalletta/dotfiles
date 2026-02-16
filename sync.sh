#!/usr/bin/env bash
set -uo pipefail

DOTFILES="$HOME/dotfiles"
source "$DOTFILES/links.sh"

bold="\033[1m"
dim="\033[2m"
green="\033[0;32m"
yellow="\033[0;33m"
reset="\033[0m"

ok=0
fixed=0

echo ""
echo -e "  ${bold}dotfiles sync${reset}"
echo -e "  ${dim}─────────────────────────────────${reset}"
echo ""

for entry in "${LINKS[@]}"; do
  IFS=: read -r rel dst label <<< "$entry"
  src="$DOTFILES/$rel"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo -e "  ✓  ${label}"
    ((ok++))
  elif [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "${dst}.bak"
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo -e "  🔗 ${label}  ${yellow}relinked${reset} ${dim}(backup → ${dst}.bak)${reset}"
    ((fixed++))
  else
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo -e "  🔗 ${label}  ${green}linked${reset}"
    ((fixed++))
  fi
done

echo ""
echo -e "  ${dim}─────────────────────────────────${reset}"
echo -e "  ${green}${ok} ok${reset}  ${yellow}${fixed} fixed${reset}"
echo ""
