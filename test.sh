#!/usr/bin/env bash
set -uo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

bold="\033[1m"
dim="\033[2m"
green="\033[0;32m"
red="\033[0;31m"
reset="\033[0m"

pass_count=0
fail_count=0

pass() { echo -e "  ✅  $1"; ((pass_count++)); }
fail() { echo -e "  ❌  $1  ${red}${2}${reset}"; ((fail_count++)); }

check() {
  local label="$1"; shift
  local output
  if output=$("$@" 2>&1); then
    pass "$label"
  else
    fail "$label" "$(echo "$output" | tail -3)"
  fi
}

echo ""
echo -e "  ${bold}dotfiles tests${reset}"
echo -e "  ${dim}─────────────────────────────────${reset}"
echo ""

# ─── Shell syntax ───────────────────────────────────────
check "zsh -n zshrc"       zsh -n "$DOTFILES/zshrc"
check "zsh -n zprofile"    zsh -n "$DOTFILES/zprofile"
check "bash -n install.sh" bash -n "$DOTFILES/install.sh"
check "bash -n ide.sh"     bash -n "$DOTFILES/ide.sh"
check "bash -n sync.sh"    bash -n "$DOTFILES/sync.sh"
check "bash -n links.sh"   bash -n "$DOTFILES/links.sh"

# ─── links.map → LINKS array ────────────────────────────
# The map has 15 unguarded rows; the driver must yield at least those.
check "links.sh builds LINKS from links.map" bash -c \
  "DOTFILES='$DOTFILES' source '$DOTFILES/links.sh' && [ \${#LINKS[@]} -ge 15 ]"
check "links.map rows have 5 columns" bash -c \
  "[ \$(grep -vE '^[[:space:]]*(#|\$)' '$DOTFILES/links.map' | awk -F'|' 'NF != 5' | wc -l) -eq 0 ]"

# ─── Raycast script commands ────────────────────────────
# Raycast silently ignores a script missing its required metadata or the
# executable bit, so both are worth asserting rather than discovering in the UI.
for rc_script in "$DOTFILES"/config/raycast/scripts/*.sh; do
  [ -f "$rc_script" ] || continue
  rc_name=$(basename "$rc_script")
  check "raycast/$rc_name (syntax)" bash -n "$rc_script"
  check "raycast/$rc_name (executable)" test -x "$rc_script"
  check "raycast/$rc_name (metadata)" bash -c "
    for key in schemaVersion title mode; do
      grep -q \"@raycast.\$key\" '$rc_script' || { echo \"missing @raycast.\$key\"; exit 1; }
    done"
done

# Tables must reach fullOutput as aligned columns; fullOutput renders ANSI but
# not markdown, so a leaked pipe, backtick or asterisk means the formatter
# regressed. The alignment check earns its keep because macOS awk measures in
# bytes: add a modifier glyph the renderer's dwidth() doesn't know and every
# column below it silently shifts left.
SHOW_SHORTCUTS="$DOTFILES/config/raycast/scripts/show-shortcuts.sh"
if [ -x "$SHOW_SHORTCUTS" ]; then
  check "raycast/show-shortcuts renders without markdown syntax" bash -c \
    "! '$SHOW_SHORTCUTS' aerospace | grep -qE '\||\`|\*\*'"
  # Kept as a function so the perl stays in one pair of single quotes; nesting it
  # inside check's bash -c means escaping every $ and getting a false failure.
  aligned_columns() {
    "$SHOW_SHORTCUTS" aerospace | perl -CSD -e '
      my ($min, $max, $bad);
      sub close_block {
        $bad++ if defined $min && $min != $max;
        undef $min; undef $max;
      }
      while (my $line = <STDIN>) {
        $line =~ s/\e\[[0-9;]*m//g;
        if ($line =~ /^  (\S.*?)(\s{2,})\S/) {
          my $col = length($1) + length($2);
          $min = $col if !defined $min || $col < $min;
          $max = $col if !defined $max || $col > $max;
        } elsif ($line =~ /^\s*$/) {
          close_block();
        }
      }
      close_block();
      exit($bad ? 1 : 0);
    '
  }
  check "raycast/show-shortcuts aligns each table's key column" aligned_columns
fi

# ─── JSON ───────────────────────────────────────────────
check "claude/settings.json" jq empty "$DOTFILES/config/claude/settings.json"

# ─── Zed JSONC ──────────────────────────────────────────
for zed_file in settings.json keymap.json tasks.json; do
  if [ -f "$DOTFILES/config/zed/$zed_file" ]; then
    check "zed/$zed_file" bash -c "perl -0pe 's|//[^\n]*||g; s/,(\s*[}\]])/\$1/g' \"$DOTFILES/config/zed/$zed_file\" | jq empty"
  fi
done

# ─── Obsidian shared JSON ──────────────────────────────
for obs_file in appearance.json app.json core-plugins.json community-plugins.json hotkeys.json; do
  if [ -f "$DOTFILES/config/obsidian/shared/$obs_file" ]; then
    check "obsidian/shared/$obs_file" jq empty "$DOTFILES/config/obsidian/shared/$obs_file"
  fi
done

# ─── Zed deprecated actions ─────────────────────────────
# Zed auto-migrates deprecated actions by writing through symlinks,
# causing uncommitted changes in the repo. Catch them here.
DEPRECATED_ACTIONS="ActivatePrevItem|ActivatePaneInDirection"
if [ -f "$DOTFILES/config/zed/keymap.json" ]; then
  check "zed/keymap (no deprecated actions)" bash -c \
    "! grep -qE '$DEPRECATED_ACTIONS' '$DOTFILES/config/zed/keymap.json'"
fi

# ─── Ghostty config ─────────────────────────────────────
if command -v ghostty &>/dev/null; then
  check "ghostty config" ghostty +validate-config
else
  echo -e "  ${dim}⏭️   ghostty config  (ghostty not found)${reset}"
fi

# ─── Warp theme YAML ──────────────────────────────────
if command -v yq &>/dev/null; then
  for theme_file in "$DOTFILES"/config/warp/themes/*.yaml; do
    [ -f "$theme_file" ] || continue
    name=$(basename "$theme_file")
    check "warp/themes/$name (syntax)" yq eval '.' "$theme_file"
    # Validate required keys
    check "warp/themes/$name (keys)" bash -c "
      for key in accent background foreground details; do
        val=\$(yq eval \".\$key\" \"$theme_file\")
        if [ \"\$val\" = \"null\" ]; then
          echo \"missing required key: \$key\"
          exit 1
        fi
      done
    "
  done
else
  echo -e "  ${dim}⏭️   warp theme YAML  (yq not found)${reset}"
fi

# ─── Warp keybindings YAML ─────────────────────────────
if command -v yq &>/dev/null; then
  check "warp/keybindings.yaml" yq eval '.' "$DOTFILES/config/warp/keybindings.yaml"
else
  echo -e "  ${dim}⏭️   warp keybindings YAML  (yq not found)${reset}"
fi

# ─── Summary ────────────────────────────────────────────
echo ""
echo -e "  ${dim}─────────────────────────────────${reset}"
echo -e "  ${green}${pass_count} passed${reset}  ${red}${fail_count} failed${reset}"
echo ""

[ "$fail_count" -eq 0 ]
