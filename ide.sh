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

echo ""
echo -e "  ${green}Default editor: ${bold}Zed${reset}"
echo -e "  Written: ${dim}~/.editor_env${reset}, ${dim}~/.gitconfig.local${reset}"
echo -e "  ${dim}Open a new shell to pick up changes.${reset}"
echo ""
