#!/usr/bin/env bash
# Shared symlink definitions — sourced by install.sh and sync.sh.
# The map itself is links.map (OS-neutral data, one row per managed config);
# this file is the macOS driver that turns it into the LINKS array
# ("relative_source:destination:label"). windows/links.ps1 reads the same map.

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
LINKS=()

_trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; printf '%s' "${s%"${s##*[![:space:]]}"}"; }

# Guards gate rows on this machine's state; each OS driver evaluates them natively.
_guard_ok() {
  case "$1" in
    -)     return 0 ;;
    codex) command -v codex &>/dev/null ;;
    zed)   [ -d "/Applications/Zed.app" ] ;;
    *)     return 1 ;;  # unknown guard: skip rather than link blindly
  esac
}

while IFS='|' read -r _src _label _guard _mac _win; do
  [[ "$_src" =~ ^[[:space:]]*(#|$) ]] && continue
  _src=$(_trim "$_src"); _label=$(_trim "$_label"); _guard=$(_trim "$_guard"); _mac=$(_trim "$_mac")
  [ "$_mac" = "-" ] && continue
  _guard_ok "$_guard" || continue
  LINKS+=("$_src:${_mac/#\~/$HOME}:$_label")
done < "$DOTFILES/links.map"
