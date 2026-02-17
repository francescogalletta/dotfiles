# ---------------------
# Homebrew
# ---------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------------------
# History
# ---------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # share history across terminal tabs
setopt HIST_IGNORE_DUPS       # don't store duplicate consecutive commands
setopt HIST_IGNORE_SPACE      # commands starting with space aren't saved (for secrets)

# ---------------------
# Tab completion
# ---------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select              # arrow-key menu for completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive matching

# ---------------------
# Shell options
# ---------------------
setopt AUTO_CD            # type a directory name to cd into it
setopt CORRECT            # "did you mean?" when you typo a command
setopt INTERACTIVE_COMMENTS  # allow # comments in the terminal

# ---------------------
# Editor
# ---------------------
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# ---------------------
# Starship prompt
# ---------------------
eval "$(starship init zsh)"

# ---------------------
# fzf keybindings + completion
# ---------------------
source <(fzf --zsh)

# ---------------------
# AI coding tool completions
# ---------------------
if command -v claude &>/dev/null; then
  eval "$(claude completion zsh 2>/dev/null)"
fi
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

# Directory shortcuts (conditional on existence)
if [[ -d ~/Google\ Drive/My\ Drive ]]; then
  alias personal_drive="cd ~/Google\ Drive/My\ Drive"
elif [[ -d ~/francesco.paolo.galletta@gmail.com\ -\ Google\ Drive/My\ Drive ]]; then
  alias personal_drive="cd ~/francesco.paolo.galletta@gmail.com\ -\ Google\ Drive/My\ Drive"
fi
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

# fzf directory jumper
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" || return; }

# ---------------------
# Plugins (must be near end of file)
# ---------------------
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

