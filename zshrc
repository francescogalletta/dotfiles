# ---------------------
# Homebrew (must be first — sets HOMEBREW_PREFIX used by OMZ)
# ---------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------------------
# tmux — auto-attach in Ghostty (full env is ready; $TMUX guard prevents nesting)
# ---------------------
if [[ "$TERM_PROGRAM" == "ghostty" && -z "$TMUX" ]]; then
  exec tmux new-session -A -s main
fi

# ---------------------
# Oh My Zsh
# ---------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Starship handles the prompt

plugins=(git brew extract colored-man-pages history-substring-search)

source "$ZSH/oh-my-zsh.sh"

# history-substring-search keybindings (must come after OMZ loads the plugin)
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down

# Source brew-installed plugins directly (brew ships .zsh, not .plugin.zsh that OMZ expects)
[[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# zsh-syntax-highlighting must be sourced last
[[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ---------------------
# History (must come AFTER source — OMZ's lib/history.zsh sets HISTSIZE=50000)
# ---------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_SPACE      # commands starting with space aren't saved (for secrets)
setopt HIST_FIND_NO_DUPS      # don't show duplicates in history search
setopt HIST_REDUCE_BLANKS     # strip extra whitespace before saving
setopt EXTENDED_HISTORY       # record timestamp with each command

# ---------------------
# Shell options (OMZ sets AUTO_CD, SHARE_HISTORY, HIST_IGNORE_DUPS — these are the rest)
# ---------------------
setopt CORRECT
setopt INTERACTIVE_COMMENTS

# ---------------------
# Tab completion (OMZ calls compinit; these zstyle calls extend its config)
# ---------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ---------------------
# Editor (override via ~/.editor_env, written by ide.sh)
# ---------------------
if [ -f "$HOME/.editor_env" ]; then
  source "$HOME/.editor_env"
else
  export EDITOR="zed --wait"
  export VISUAL="$EDITOR"
fi

# ---------------------
# fzf keybindings + completion (explicit — avoids OMZ fzf plugin version variance)
# ---------------------
source <(fzf --zsh)

# ---------------------
# nvm (lazy-loaded for fast shell startup)
# ---------------------
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  node "$@"
}
npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  npm "$@"
}
npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  npx "$@"
}

# ---------------------
# Ollama
# ---------------------
export OLLAMA_FLASH_ATTENTION=1
export OLLAMA_KV_CACHE_TYPE=q8_0

# ---------------------
# PATH
# ---------------------
export PATH="$HOME/.local/bin:$PATH"

# ---------------------
# Aliases
# ---------------------
alias ls="eza --icons"
alias ll="eza --icons -la"
alias lt="eza --icons --tree --level=2"
alias cat="bat"
alias reload="source ~/.zshrc"

# Directory shortcuts (conditional on existence)
if [[ -d ~/Google\ Drive/My\ Drive ]]; then
  alias personal_drive="cd ~/Google\ Drive/My\ Drive"
elif [[ -d ~/francesco.paolo.galletta@gmail.com\ -\ Google\ Drive/My\ Drive ]]; then
  alias personal_drive="cd ~/francesco.paolo.galletta@gmail.com\ -\ Google\ Drive/My\ Drive"
fi
[[ -d ~/projects/coded ]] && alias coded="cd ~/projects/coded"
[[ -d ~/francescogalletta@monzo.com\ -\ Google\ Drive ]] && alias monzo_drive="cd ~/francescogalletta@monzo.com\ -\ Google\ Drive"
[[ -d ~/src/github.com/monzo/analytics ]] && alias analytics="cd ~/src/github.com/monzo/analytics"
[[ -d ~/src/github.com/monzo/wearedev ]] && alias wearedev="cd ~/src/github.com/monzo/wearedev"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
mkcd() { mkdir -p "$1" && cd "$1"; }

# Finder
alias o="open ."
alias finder="open ."

# Claude Code
alias cc="claude --permission-mode auto"

# Zed (z is reserved for zoxide)
alias ze="zed"

# Git identity — view or change ~/.gitconfig.local identity
gitid() {
  local GIT_LOCAL="$HOME/.gitconfig.local"
  local name email
  name="$(git config --file "$GIT_LOCAL" user.name 2>/dev/null)"
  email="$(git config --file "$GIT_LOCAL" user.email 2>/dev/null)"
  echo "Current: $name <$email>"
  read -r "?New name [$name]: " new_name
  read -r "?New email [$email]: " new_email
  git config --file "$GIT_LOCAL" user.name "${new_name:-$name}"
  git config --file "$GIT_LOCAL" user.email "${new_email:-$email}"
  echo "Updated: $(git config user.name) <$(git config user.email)>"
}

# fzf directory jumper
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" || return; }

# Open a file in the default IDE (derived from $EDITOR)
e() {
  ${EDITOR%% *} "${1:?Usage: e <file>}"
}

# Ctrl+O: fzf-pick a file and open it in the default IDE
_fzf_open_ide() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers {}' 2>/dev/null) || return
  ${EDITOR%% *} "$file"
  zle reset-prompt
}
zle -N _fzf_open_ide
bindkey '^O' _fzf_open_ide

# ---------------------
# Zoxide (frecency-based directory jumping; replaces fcd for common dirs)
# ---------------------
eval "$(zoxide init zsh)"

# ---------------------
# Atuin (enhanced shell history with Ctrl+R)
# ---------------------
eval "$(atuin init zsh --disable-up-arrow)"

# ---------------------
# Bell on slow command completion (>=10s)
# Uses add-zsh-hook to avoid clobbering OMZ's preexec/precmd hooks
# ---------------------
autoload -U add-zsh-hook
typeset -g _cmd_start_time=0
_bell_preexec() { _cmd_start_time=$SECONDS }
_bell_precmd() { (( SECONDS - _cmd_start_time >= 10 )) && print -n "\a"; _cmd_start_time=$SECONDS }
add-zsh-hook preexec _bell_preexec
add-zsh-hook precmd _bell_precmd

# ---------------------
# Starship prompt (must be last — overrides $PROMPT set by OMZ)
# ---------------------
eval "$(starship init zsh)"
