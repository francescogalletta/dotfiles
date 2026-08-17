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
pruned=0

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

# ─── Prune orphaned links ─────────────────────────────
# The reconcile loop above and install.sh only ever add or relink; nothing
# removes a link whose links.map row was deleted, and `brew bundle` never
# uninstalls. So retiring a config (tmux, ADR-034) leaves a broken symlink and
# an empty dir behind on every already-provisioned machine. A broken symlink
# pointing *into $DOTFILES* is exactly that fossil, and safe to remove; a broken
# link pointing anywhere else is someone else's, so it is left untouched.
prune_link() {
  local link tgt
  while IFS= read -r link; do
    [ -e "$link" ] && continue          # resolves — not an orphan
    tgt=$(readlink "$link")
    case "$tgt" in
      "$DOTFILES"/*)
        rm "$link"
        echo -e "  🗑  ${link/#$HOME/~}  ${yellow}pruned${reset} ${dim}(source retired)${reset}"
        ((pruned++))
        ;;
    esac
  done < <(find "$1" -maxdepth "$2" -type l 2>/dev/null)
}
prune_link "$HOME" 1                     # top-level dotfiles (~/.aerospace.toml, …)
for _root in .config .warp .codex .claude; do
  [ -d "$HOME/$_root" ] && prune_link "$HOME/$_root" 4
done
# a prune can leave the retired config's own dir empty (~/.config/tmux); drop it
find "$HOME/.config" -mindepth 1 -type d -empty -delete 2>/dev/null || true

echo ""
echo -e "  ${dim}─────────────────────────────────${reset}"
echo -e "  ${green}${ok} ok${reset}  ${yellow}${fixed} fixed${reset}  ${yellow}${pruned} pruned${reset}"
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
          # Already correctly linked (and the link resolves) — nothing to do.
          if [ -L "$_dst" ] && [ "$(readlink "$_dst")" = "$_src" ] && [ -e "$_dst" ]; then
            echo -e "  ✓  ${_vault_names[$i]}/$_dir"
            continue
          fi
          # Attempt → verify → roll back. A cheap `[ -d "$_src" ]` pre-check is
          # not enough: on a Google Drive vault the source dir shows as an
          # online-only placeholder that stats as a directory and even lists
          # entries, yet the symlink to it does not resolve. The old code trusted
          # the pre-check, moved the target's *real* themes/plugins to .bak, and
          # left a dangling link — silent data loss. So make the link, then
          # confirm it resolves; if it does not, undo everything and restore the
          # target untouched. This is robust to cloud lazy-materialization.
          _backed=""
          if [ -d "$_dst" ] && [ ! -L "$_dst" ]; then
            mv "$_dst" "${_dst}.bak"; _backed=1
          elif [ -L "$_dst" ]; then
            rm "$_dst"
          fi
          ln -s "$_src" "$_dst"
          if [ -e "$_dst" ]; then
            [ -n "$_backed" ] && echo -e "  ${dim}     backed up ${_vault_names[$i]}/$_dir → ${_dir}.bak${reset}"
            echo -e "  🔗 ${_vault_names[$i]}/$_dir  ${green}→ ${_vault_names[$_idx]}${reset}"
          else
            rm "$_dst"
            [ -n "$_backed" ] && mv "${_dst}.bak" "$_dst"
            echo -e "  ${yellow}⏭  ${_vault_names[$i]}/$_dir  (source '${_vault_names[$_idx]}' not materialized)${reset}"
          fi
        done
      done
      echo ""
    fi
  fi
fi
