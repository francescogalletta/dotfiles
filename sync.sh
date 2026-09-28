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
