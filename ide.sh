#!/usr/bin/env bash
set -uo pipefail

# ─── Colors & styling ───────────────────────────────────
bold="\033[1m"
dim="\033[2m"
green="\033[0;32m"
red="\033[0;31m"
reset="\033[0m"

echo ""
echo -e "  ${bold}Editor setup${reset}"
echo -e "  ${dim}─────────────────────────────────${reset}"
echo ""

# ─── Install Zed ────────────────────────────────────────
if [ -d "/Applications/Zed.app" ]; then
  echo -e "  ⏭️  Zed ${dim}(already installed)${reset}"
else
  printf "  Installing Zed..."
  if brew install --cask zed >/dev/null 2>&1; then
    printf "\r  ✅ Zed\n"
  else
    printf "\r  ${red}❌ Zed — run 'brew install --cask zed' manually${reset}\n"
  fi
fi

# ─── Write editor config ─────────────────────────────────
cat > "$HOME/.editor_env" << 'EOF'
export EDITOR="zed --wait"
export VISUAL="$EDITOR"
EOF

git config --file "$HOME/.gitconfig.local" core.editor "zed --wait"

# ─── Default app for source files ───────────────────────
# $EDITOR only covers the shell. Double-click and `open` go through
# LaunchServices, where any editor installed since (Cursor did this) can
# claim these types. Re-running ide.sh reclaims them.
DOTFILES="${DOTFILES:-$(cd "$(dirname "$0")" && pwd)}"
ZED_EXTS=(py pyi ipynb js mjs cjs jsx ts tsx json jsonc md markdown toml yaml yml
  go rs sql css scss lua rb swift c h cpp hpp java kt ini conf cfg lock log txt)
if [ -d "/Applications/Zed.app" ] && command -v swift &>/dev/null; then
  if swift "$DOTFILES/config/zed/set-default-app.swift" "${ZED_EXTS[@]}"; then
    echo -e "  ✅ Zed opens ${#ZED_EXTS[@]} source file types"
  else
    echo -e "  ${red}❌ Some file types could not be assigned to Zed${reset}"
  fi
else
  echo -e "  ⏭️  File associations ${dim}(needs Zed.app and swift)${reset}"
fi

echo ""
echo -e "  ${green}Default editor: ${bold}Zed${reset}"
echo -e "  Written: ${dim}~/.editor_env${reset}, ${dim}~/.gitconfig.local${reset}"
echo -e "  ${dim}Open a new shell to pick up changes.${reset}"
echo ""
