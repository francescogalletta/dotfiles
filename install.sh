#!/usr/bin/env bash
set -uo pipefail

DOTFILES="$HOME/dotfiles"
LOGFILE="$DOTFILES/.install.log"
> "$LOGFILE"

# ─── Colors & styling ───────────────────────────────────
bold="\033[1m"
dim="\033[2m"
green="\033[0;32m"
red="\033[0;31m"
yellow="\033[0;33m"
cyan="\033[0;36m"
reset="\033[0m"
clear_line="\033[2K"

# ─── Welcome banner ─────────────────────────────────────
echo ""
echo -e "  ${bold}dotfiles installer${reset}"
echo -e "  ${dim}─────────────────────────────────${reset}"
echo -e "  This script sets up a fresh Mac:"
echo ""
echo -e "  📦 Homebrew + Brewfile     CLI tools, Ghostty, Warp, prompt"
echo -e "  🟢 Node.js                 via nvm"
echo -e "  🔗 Symlinks                shell, git, terminal, editor, AI agent"
echo -e "  🔑 Git identity + SSH      name, email, ed25519 key"
echo -e "  🐙 GitHub CLI auth         login via gh"
echo -e "  🍎 macOS defaults          keyboard shortcuts, Spaces"
echo -e "  🦙 Ollama + models         local LLM inference"
echo ""
echo -e "  ${dim}Optional (you'll be asked):${reset}"
echo -e "  🤖 Claude Code             Anthropic's coding agent"
echo -e "  🔥 Forge Code              Tailcall's coding agent"
echo -e "  ☁️  Google Drive            desktop sync client"
echo -e "  🖥️  Editors                 VS Code, Zed, Cursor (via ide.sh)"
echo ""
echo -e "  ${dim}Logs are written to ~/dotfiles/.install.log${reset}"
echo -e "  ${dim}─────────────────────────────────${reset}"
echo ""

# ─── Progress tracking ──────────────────────────────────
SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
SPIN_IDX=0
TOTAL=0
DONE=0
LAST_ERROR=""
declare -a RESULTS=()

count() { TOTAL=$((TOTAL + 1)); }

progress() {
  local label="$1"
  local pct=$(( DONE * 100 / TOTAL ))
  (( pct > 100 )) && pct=100
  local filled=$(( pct / 5 ))
  local empty=$(( 20 - filled ))
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="█"; done
  for ((i=0; i<empty; i++)); do bar+="░"; done
  local spin="${SPINNER_FRAMES[$SPIN_IDX]}"
  SPIN_IDX=$(( (SPIN_IDX + 1) % ${#SPINNER_FRAMES[@]} ))
  printf "\r${clear_line}  ${cyan}%s${reset} ${bold}%s${reset} ${bold}%3d%%${reset}  ${dim}%s${reset}" "$spin" "$bar" "$pct" "$label"
}

advance() {
  DONE=$((DONE + 1))
  progress "$1"
}

pass() { RESULTS+=("  ✅ $1"); }
skip() { RESULTS+=("  ⏭️  $1 ${dim}(already installed)${reset}"); }
fail() {
  local label="$1"
  local err="${2:-}"
  if [ -n "$err" ]; then
    # Indent error lines
    local indented
    indented=$(echo "$err" | sed 's/^/       > /')
    RESULTS+=("  ❌ $label\n$indented")
  else
    RESULTS+=("  ❌ $label")
  fi
}

run_logged() {
  local label="$1"; shift
  local tmp
  tmp=$(mktemp)
  echo "=== [$label] $(date) ===" >> "$LOGFILE"
  if "$@" > "$tmp" 2>&1; then
    cat "$tmp" >> "$LOGFILE"
    rm -f "$tmp"
    return 0
  else
    cat "$tmp" >> "$LOGFILE"
    LAST_ERROR=$(tail -5 "$tmp")
    rm -f "$tmp"
    return 1
  fi
}

# ─── Count core steps ───────────────────────────────────
count  # Homebrew
count  # Brewfile
count  # Node.js
source "$DOTFILES/links.sh"
for entry in "${LINKS[@]}"; do count; done  # symlinks
count  # Git identity
count  # SSH key
count  # GitHub CLI auth
count  # macOS defaults
count  # Ollama models

# ─── 1. 🍺 Homebrew ────────────────────────────────────
advance "🍺 Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  if run_logged "Homebrew" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    pass "🍺 Homebrew"
  else
    fail "🍺 Homebrew" "$LAST_ERROR"
  fi
else
  eval "$(/opt/homebrew/bin/brew shellenv)"
  skip "🍺 Homebrew"
fi

# ─── 2. 📦 Brewfile packages ───────────────────────────
advance "📦 Installing Brewfile packages..."
if run_logged "Brewfile" brew bundle install --file="$DOTFILES/Brewfile"; then
  pass "📦 Brewfile packages"
else
  fail "📦 Brewfile packages" "$LAST_ERROR"
fi

# ─── 3. 🖥️ Warp settings sync ────────────────────────
if [ -d "/Applications/Warp.app" ]; then
  printf "\r${clear_line}"
  echo -e "\n  ${cyan}🖥️  Warp detected${reset} — log in to your Warp account to sync settings.\n"
fi

# ─── 4. 🟢 Node.js via nvm ─────────────────────────────
advance "🟢 Installing Node.js LTS..."
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

if ! command -v node &>/dev/null; then
  if run_logged "Node.js" nvm install --lts; then
    pass "🟢 Node.js $(node --version)"
  else
    fail "🟢 Node.js" "$LAST_ERROR"
  fi
else
  skip "🟢 Node.js $(node --version)"
fi

# ─── 5. 🔗 Symlinks ───────────────────────────────────
link_file() {
  local src="$1" dst="$2" name="$3"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "${dst}.bak"
  fi
  mkdir -p "$(dirname "$dst")"
  if ln -s "$src" "$dst"; then
    pass "🔗 link: $name"
  else
    fail "🔗 link: $name" "symlink failed"
  fi
}

for entry in "${LINKS[@]}"; do
  IFS=: read -r rel dst label <<< "$entry"
  advance "🔗 Linking $label..."
  link_file "$DOTFILES/$rel" "$dst" "$label"
done

# ─── 6. 🔑 Git identity ───────────────────────────────
advance "🔑 Configuring Git identity..."
GIT_LOCAL="$HOME/.gitconfig.local"

git_name="$(git config --file "$GIT_LOCAL" user.name 2>/dev/null)"
git_email="$(git config --file "$GIT_LOCAL" user.email 2>/dev/null)"

if [ -n "$git_name" ] && [ -n "$git_email" ]; then
  # Identity exists — show it, offer to change
  printf "\r${clear_line}"
  echo -e "\n  Current git identity: ${bold}$git_name${reset} <${bold}$git_email${reset}>"
  printf "  Keep this identity? [Y/n] "
  read -r keep_identity
  if [[ "$keep_identity" =~ ^[nN] ]]; then
    read -rp "  Git user name [$git_name]: " new_name
    git_name="${new_name:-$git_name}"
    read -rp "  Git email [$git_email]: " new_email
    git_email="${new_email:-$git_email}"
  fi
else
  # No identity yet — prompt
  printf "\r${clear_line}"
  [ -z "$git_name" ] && read -rp "  Git user name: " git_name
  [ -z "$git_email" ] && read -rp "  Git email: " git_email
fi

git config --file "$GIT_LOCAL" user.name "$git_name"
git config --file "$GIT_LOCAL" user.email "$git_email"
pass "🔑 Git: $git_name <$git_email>"

# ─── 7. 🔐 SSH key ─────────────────────────────────────
advance "🔐 Setting up SSH key..."
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY" ]; then
  if ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f "$SSH_KEY" -N "" >> "$LOGFILE" 2>&1; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
    ssh-add "$SSH_KEY" 2>/dev/null
    pass "🔐 SSH key (ed25519)"
  else
    fail "🔐 SSH key" "ssh-keygen failed"
  fi
else
  skip "🔐 SSH key"
fi

# ─── 8. 🐙 GitHub CLI auth ─────────────────────────────
advance "🐙 Authenticating with GitHub..."
if ! gh auth status &>/dev/null; then
  printf "\r${clear_line}"
  if gh auth login; then
    pass "🐙 GitHub CLI"
  else
    fail "🐙 GitHub CLI" "gh auth login failed"
  fi
else
  skip "🐙 GitHub CLI"
fi

# ─── 9. 🍎 macOS defaults ──────────────────────────────
advance "🍎 Applying macOS defaults..."
# Enable Ctrl+Left/Right to switch Desktops (Spaces)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 '{enabled=1;value={parameters=(65535,123,8650752);type=standard;};}'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 '{enabled=1;value={parameters=(65535,124,8650752);type=standard;};}'
pass "🍎 macOS defaults"

# ─── 10. 🦙 Ollama models ──────────────────────────────
advance "🦙 Pulling Ollama models..."
if command -v ollama &>/dev/null; then
  brew services start ollama >> "$LOGFILE" 2>&1
  sleep 2
  if run_logged "Ollama models" ollama pull gemma4; then
    pass "🦙 Ollama: gemma4"
  else
    fail "🦙 Ollama models" "$LAST_ERROR"
  fi
else
  fail "🦙 Ollama models" "ollama not found — check Brewfile step"
fi

# ─── 11. Optional extras prompt ────────────────────────
printf "\r${clear_line}\n"
echo -e "  ${bold}Optional extras:${reset}\n"

ask_yes_no() {
  local prompt="$1" varname="$2"
  printf "  %s [y/N] " "$prompt"
  read -r answer
  case "$answer" in
    [yY]*) eval "$varname=true" ;;
    *)     eval "$varname=false" ;;
  esac
}

ask_yes_no "🤖 Install Claude Code (Anthropic)?" INSTALL_CLAUDE
ask_yes_no "🔥 Install Forge Code (Tailcall)?"     INSTALL_FORGE
ask_yes_no "☁️  Install Google Drive?"              INSTALL_GDRIVE
echo ""

# Add optional steps to total
if [ "$INSTALL_CLAUDE" = true ]; then count; fi
if [ "$INSTALL_FORGE" = true ]; then count; fi
if [ "$INSTALL_GDRIVE" = true ]; then count; fi

# ─── 12. 🤖 Claude Code (optional) ─────────────────────
if [ "$INSTALL_CLAUDE" = true ]; then
  advance "🤖 Installing Claude Code..."
  if ! command -v claude &>/dev/null; then
    if run_logged "Claude Code" bash -c 'curl -fsSL https://install.claude.sh | bash'; then
      pass "🤖 Claude Code"
    else
      fail "🤖 Claude Code" "$LAST_ERROR"
    fi
  else
    skip "🤖 Claude Code"
  fi
else
  RESULTS+=("  ⏭️  🤖 Claude Code ${dim}(not selected)${reset}")
fi

# ─── 13. 🔥 Forge Code (optional) ──────────────────────
if [ "$INSTALL_FORGE" = true ]; then
  advance "🔥 Installing Forge Code..."
  if ! command -v forge &>/dev/null; then
    if run_logged "Forge Code" bash -c 'curl -fsSL https://forgecode.dev/cli | sh'; then
      pass "🔥 Forge Code"
    else
      fail "🔥 Forge Code" "$LAST_ERROR"
    fi
  else
    skip "🔥 Forge Code"
  fi
else
  RESULTS+=("  ⏭️  🔥 Forge Code ${dim}(not selected)${reset}")
fi

# ─── 14. ☁️ Google Drive (optional) ────────────────────
if [ "$INSTALL_GDRIVE" = true ]; then
  advance "☁️  Installing Google Drive..."
  if ! brew list --cask google-drive &>/dev/null; then
    if run_logged "Google Drive" brew install --cask google-drive; then
      pass "☁️  Google Drive"
    else
      fail "☁️  Google Drive" "$LAST_ERROR"
    fi
  else
    skip "☁️  Google Drive"
  fi
else
  RESULTS+=("  ⏭️  ☁️  Google Drive ${dim}(not selected)${reset}")
fi

# ─── 15. 🖥️ IDE installation (ide.sh) ──────────────────
printf "\r${clear_line}\n"
echo -e "  ${bold}Editor setup:${reset}\n"
if [ -x "$DOTFILES/ide.sh" ]; then
  bash "$DOTFILES/ide.sh"
else
  echo -e "  ${yellow}ide.sh not found — skipping editor setup.${reset}\n"
fi

# ─── 16. 📁 Projects directory ─────────────────────────
mkdir -p "$HOME/projects"

# ─── Summary ──────────────────────────────────────────
printf "\r${clear_line}"
echo ""
echo -e "  ${bold}────────────────────────────────────${reset}"
echo -e "  ${bold}  Summary${reset}"
echo -e "  ${bold}────────────────────────────────────${reset}"

ok_count=0
fail_count=0
skip_count=0

for r in "${RESULTS[@]}"; do
  echo -e "$r"
  if [[ "$r" == *"✅"* ]]; then ((ok_count++)); fi
  if [[ "$r" == *"❌"* ]]; then ((fail_count++)); fi
  if [[ "$r" == *"⏭️"* ]]; then ((skip_count++)); fi
done

echo -e "  ${bold}────────────────────────────────────${reset}"
echo -e "  ${green}${ok_count} installed${reset}  ${dim}${skip_count} skipped${reset}  ${red}${fail_count} failed${reset}"
echo ""

if [ "$fail_count" -gt 0 ]; then
  echo -e "  ${yellow}Some steps failed. Check .install.log for details.${reset}"
  echo -e "  ${yellow}Re-run ./install.sh to retry.${reset}"
  echo ""
  exit 1
else
  echo -e "  ${green}All good!${reset}"
fi
