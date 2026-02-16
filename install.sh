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
echo -e "  📦 Homebrew + CLI tools    eza, bat, fzf, ripgrep, jq, gh, nvm, uv"
echo -e "  👻 Ghostty terminal        GPU-accelerated terminal emulator"
echo -e "  ⭐ Starship prompt         cross-shell prompt"
echo -e "  🟢 Node.js + Python        via nvm & uv"
echo -e "  🔗 Symlinks                zshrc, gitconfig, app configs"
echo -e "  🔑 Git identity + SSH      name, email, ed25519 key"
echo -e "  🐙 GitHub CLI auth         login via gh"
echo ""
echo -e "  ${dim}Optional (you'll be asked):${reset}"
echo -e "  🤖 Claude Code             Anthropic's coding agent"
echo -e "  ☁️  Google Drive            desktop sync client"
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
PACKAGES=(starship eza bat fzf ripgrep jq gh nvm uv zsh-autosuggestions zsh-syntax-highlighting)

count  # Homebrew
for pkg in "${PACKAGES[@]}"; do count; done
count  # Ghostty
count  # Node.js
count  # Python
count  # link: zshrc
count  # link: gitconfig
count  # link: ghostty
count  # link: starship
count  # link: CLAUDE.md
count  # link: claude/skills
count  # link: claude/settings
count  # Git identity
count  # SSH key
count  # GitHub CLI auth

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

# ─── 2. 📦 Brew packages ───────────────────────────────
for pkg in "${PACKAGES[@]}"; do
  advance "📦 brew install $pkg..."
  if ! brew list "$pkg" &>/dev/null; then
    if run_logged "brew: $pkg" brew install "$pkg"; then
      pass "📦 brew: $pkg"
    else
      fail "📦 brew: $pkg" "$LAST_ERROR"
    fi
  else
    skip "📦 brew: $pkg"
  fi
done

# ─── 3. 👻 Ghostty ─────────────────────────────────────
advance "👻 Installing Ghostty..."
if ! brew list --cask ghostty &>/dev/null; then
  if run_logged "Ghostty" brew install --cask ghostty; then
    pass "👻 Ghostty"
  else
    fail "👻 Ghostty" "$LAST_ERROR"
  fi
else
  skip "👻 Ghostty"
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

# ─── 5. 🐍 Python via uv ──────────────────────────────
advance "🐍 Installing Python..."
if ! uv python list --only-installed 2>/dev/null | grep -q cpython; then
  if run_logged "Python" uv python install; then
    pass "🐍 Python (uv)"
  else
    fail "🐍 Python (uv)" "$LAST_ERROR"
  fi
else
  skip "🐍 Python (uv)"
fi

# ─── 6. 🔗 Symlinks ───────────────────────────────────
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

advance "🔗 Linking zshrc..."
link_file "$DOTFILES/zshrc"                   "$HOME/.zshrc"                  "zshrc"
advance "🔗 Linking gitconfig..."
link_file "$DOTFILES/gitconfig"               "$HOME/.gitconfig"              "gitconfig"
advance "🔗 Linking ghostty config..."
link_file "$DOTFILES/config/ghostty/config"   "$HOME/.config/ghostty/config"  "ghostty"
advance "🔗 Linking starship config..."
link_file "$DOTFILES/config/starship.toml"    "$HOME/.config/starship.toml"   "starship"
advance "🔗 Linking CLAUDE.md..."
link_file "$DOTFILES/CLAUDE.md"               "$HOME/CLAUDE.md"               "CLAUDE.md"
advance "🔗 Linking Claude skills..."
link_file "$DOTFILES/claude/skills"            "$HOME/.claude/skills"          "claude/skills"
advance "🔗 Linking Claude settings..."
link_file "$DOTFILES/claude/settings.json"     "$HOME/.claude/settings.json"   "claude/settings"

# ─── 7. 🔑 Git identity ───────────────────────────────
advance "🔑 Configuring Git identity..."
if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
  printf "\r${clear_line}"
  read -rp "  Git user name: " git_name
  git config --global user.name "$git_name"
fi
if [ -z "$(git config --global user.email 2>/dev/null)" ]; then
  printf "\r${clear_line}"
  read -rp "  Git email: " git_email
  git config --global user.email "$git_email"
fi
pass "🔑 Git: $(git config --global user.name) <$(git config --global user.email)>"

# ─── 8. 🔐 SSH key ────────────────────────────────────
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

# ─── 9. 🐙 GitHub CLI auth ────────────────────────────
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

# ─── 10. Optional extras prompt ───────────────────────
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
ask_yes_no "☁️  Install Google Drive?"              INSTALL_GDRIVE
echo ""

# Add optional steps to total
if [ "$INSTALL_CLAUDE" = true ]; then count; fi
if [ "$INSTALL_GDRIVE" = true ]; then count; fi

# ─── 11. 🤖 Claude Code (optional) ────────────────────
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

# ─── 12. ☁️ Google Drive (optional) ────────────────────
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
  echo -e "  ${green}All good! Open a new Ghostty window to see changes.${reset}"
  echo ""
fi
