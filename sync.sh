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

# ─── Obsidian vault-to-vault sync (themes + plugins) ──
if [ -d "/Applications/Obsidian.app" ] && command -v jq &>/dev/null; then
  _obsidian_json="$DOTFILES/config/obsidian/obsidian.json"
  if [ -f "$_obsidian_json" ]; then
    declare -a _vault_paths=()
    declare -a _vault_names=()
    while IFS= read -r _vp; do
      [ -z "$_vp" ] && continue
      [ -d "$_vp/.obsidian" ] || continue
      _vault_paths+=("$_vp")
      _vault_names+=("$(basename "$_vp")")
    done < <(jq -r '.vaults | to_entries[] | .value.path' "$_obsidian_json" 2>/dev/null)

    if [ ${#_vault_paths[@]} -ge 2 ]; then
      echo -e "  ${bold}Obsidian vault sync${reset} (themes + plugins)"
      echo -e "  ${dim}─────────────────────────────────${reset}"
      echo ""
      echo -e "  Found ${#_vault_paths[@]} vaults:"
      for i in "${!_vault_names[@]}"; do
        echo -e "    $((i+1))) ${_vault_names[$i]}"
      done
      echo ""
      printf "  Primary vault (themes/plugins source) [1]: "
      read -r _pick
      _pick=${_pick:-1}
      _idx=$((_pick - 1))
      if [ "$_idx" -lt 0 ] || [ "$_idx" -ge "${#_vault_paths[@]}" ]; then
        _idx=0
      fi
      _primary="${_vault_paths[$_idx]}"
      echo ""

      for i in "${!_vault_paths[@]}"; do
        [ "$i" -eq "$_idx" ] && continue
        _target="${_vault_paths[$i]}"
        for _dir in themes plugins; do
          _src="$_primary/.obsidian/$_dir"
          _dst="$_target/.obsidian/$_dir"
          mkdir -p "$_src"
          if [ -L "$_dst" ] && [ "$(readlink "$_dst")" = "$_src" ]; then
            echo -e "  ✓  ${_vault_names[$i]}/$_dir"
          else
            if [ -d "$_dst" ] && [ ! -L "$_dst" ]; then
              mv "$_dst" "${_dst}.bak"
              echo -e "  ${dim}     backed up ${_vault_names[$i]}/$_dir → ${_dir}.bak${reset}"
            elif [ -L "$_dst" ]; then
              rm "$_dst"
            fi
            ln -s "$_src" "$_dst"
            echo -e "  🔗 ${_vault_names[$i]}/$_dir  ${green}→ ${_vault_names[$_idx]}${reset}"
          fi
        done
      done
      echo ""
    fi
  fi
fi
