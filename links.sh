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
    zed)   [ -d "/Applications/Zed.app" ] ;;
    claude) _claude_ok ;;
    *)     return 1 ;;  # unknown guard: skip rather than link blindly
  esac
}

# ─── claude guard ──────────────────────────────────────
# Decided once per run (cached in _CLAUDE_OK), first match wins:
#   1. DOTFILES_SKIP_CLAUDE set: 1/true skips, anything else links. No prompt.
#   2. dotfiles.skipClaude in ~/.gitconfig.local (the remembered answer). No prompt.
#   3. Caller opted in (LINKS_PROMPT=1, set by sync.sh/install.sh) and stdin is a
#      terminal: ask once, answer read from /dev/tty.
#   4. Otherwise (CI, test.sh, scripts): link, the historical default.
# The TTY is probed here, before the loop below redirects stdin from links.map.
_LINKS_TTY=0; [ -t 0 ] && _LINKS_TTY=1
_CLAUDE_GITCONFIG="$HOME/.gitconfig.local"

# Reads one answer from stdin; always/never persist it to ~/.gitconfig.local.
_claude_prompt() {
  local a
  while :; do
    printf '  Sync Claude config (CLAUDE.md, skills, statusline, hooks)? [Y/n/always/never] ' >&2
    read -r a || a=""
    case "$(printf '%s' "$a" | tr '[:upper:]' '[:lower:]')" in
      ""|y|yes) return 0 ;;
      n|no)     return 1 ;;
      always)   git config --file "$_CLAUDE_GITCONFIG" dotfiles.skipClaude false; return 0 ;;
      never)    git config --file "$_CLAUDE_GITCONFIG" dotfiles.skipClaude true;  return 1 ;;
      *)        echo "  Answer y, n, always or never." >&2 ;;
    esac
  done
}

_claude_decide() {
  local v
  if [ -n "${DOTFILES_SKIP_CLAUDE:-}" ]; then
    case "$DOTFILES_SKIP_CLAUDE" in 1|true) return 1 ;; *) return 0 ;; esac
  fi
  v=$(git config --file "$_CLAUDE_GITCONFIG" --bool dotfiles.skipClaude 2>/dev/null)
  case "$v" in true) return 1 ;; false) return 0 ;; esac
  if [ "${LINKS_PROMPT:-0}" = 1 ] && [ "$_LINKS_TTY" = 1 ] && { : </dev/tty; } 2>/dev/null; then
    _claude_prompt </dev/tty 2>/dev/tty
    return
  fi
  return 0
}

_claude_ok() {
  if [ -z "${_CLAUDE_OK:-}" ]; then
    if _claude_decide; then _CLAUDE_OK=1; else _CLAUDE_OK=0; fi
  fi
  [ "$_CLAUDE_OK" = 1 ]
}

while IFS='|' read -r _src _label _guard _mac _win; do
  [[ "$_src" =~ ^[[:space:]]*(#|$) ]] && continue
  _src=$(_trim "$_src"); _label=$(_trim "$_label"); _guard=$(_trim "$_guard"); _mac=$(_trim "$_mac")
  [ "$_mac" = "-" ] && continue
  _guard_ok "$_guard" || continue
  LINKS+=("$_src:${_mac/#\~/$HOME}:$_label")
done < "$DOTFILES/links.map"
