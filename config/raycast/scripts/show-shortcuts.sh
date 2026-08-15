#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Show Shortcuts
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ⌨️
# @raycast.packageName Dotfiles
# @raycast.argument1 { "type": "text", "placeholder": "app or search term", "optional": true }

# Documentation:
# @raycast.description Cheatsheet for the frontmost app, or for the app / term you type (aerospace, workspace, resize)
# @raycast.author Francesco Galletta

set -uo pipefail

DOTFILES="${HOME}/dotfiles"
CONFIG="${DOTFILES}/config"
QUERY="${1:-}"

# Sheets live in two places, in this order of preference:
#   config/<tool>/CHEATSHEET.md   — the tool has managed config, sheet sits with it
#   config/raycast/shortcuts/*.md — the tool has no config dir of its own
# Emits "slug<TAB>path" per sheet.
sheets() {
  local f slug
  for f in "$CONFIG"/*/CHEATSHEET.md; do
    [ -f "$f" ] || continue
    slug=$(basename "$(dirname "$f")")
    printf '%s\t%s\n' "$slug" "$f"
  done
  for f in "$CONFIG"/raycast/shortcuts/*.md; do
    [ -f "$f" ] || continue
    printf '%s\t%s\n' "$(basename "$f" .md)" "$f"
  done
}

# Raycast's fullOutput mode is a plain-text view: it renders ANSI colour but not
# markdown, so `| `alt h` | Focus left |` would show up with its pipes and
# backticks intact. Flatten the tables into aligned columns instead. Two passes
# over the file: the first measures the key column and marks header/separator
# rows for removal, the second prints.
render() {
  awk '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    NR == FNR {
      if ($0 ~ /^[ \t]*\|[ \t:|-]+\|[ \t]*$/) { sep[FNR] = 1; hdr[FNR - 1] = 1 }
      else if ($0 ~ /^[ \t]*\|/) {
        line = $0; gsub(/`/, "", line)
        n = split(line, f, "|")
        if (n >= 3) { k = trim(f[2]); if (length(k) > w) w = length(k) }
      }
      next
    }
    sep[FNR] || hdr[FNR] { next }
    /^#+ / {
      t = substr($0, index($0, " ") + 1); gsub(/`/, "", t)
      if (FNR > 1 && !blank) print ""
      printf "\033[1m%s\033[0m\n", ($0 ~ /^# /) ? toupper(t) : t
      blank = 0
      next
    }
    /^[ \t]*\|/ {
      line = $0; gsub(/`/, "", line)
      n = split(line, f, "|")
      v = trim(f[3])
      for (i = 4; i < n; i++) v = v "  " trim(f[i])
      fmt = "  \033[1m%-" w "s\033[0m  %s\n"
      printf fmt, trim(f[2]), v
      blank = 0
      next
    }
    { line = $0; gsub(/`/, "", line); print line; blank = (line ~ /^[ \t]*$/) }
  ' "$1" "$1"
}

list_available() {
  echo "Available cheatsheets:"
  sheets | cut -f1 | sort -u | sed 's/^/  /'
  echo ""
  echo "Pass one as the argument, or a term to search across all of them."
}

path_for_slug() {
  sheets | awk -F'\t' -v s="$1" 'tolower($1) == tolower(s) { print $2; exit }'
}

# Frontmost app name, slugified: "Ghostty" -> ghostty.
frontmost_slug() {
  osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null \
    | tr '[:upper:]' '[:lower:]' | tr -d ' '
}

search_all() {
  local term="$1" slug file hits found=0
  while IFS=$'\t' read -r slug file; do
    hits=$(render "$file" | grep -i -- "$term")
    [ -n "$hits" ] || continue
    found=1
    printf '\033[1m── %s ──\033[0m\n' "$slug"
    echo "$hits"
    echo ""
  done < <(sheets)
  return $(( found ? 0 : 1 ))
}

# No argument: whatever is in front of you.
if [ -z "$QUERY" ]; then
  slug=$(frontmost_slug)
  file=$(path_for_slug "$slug")
  if [ -n "$file" ]; then
    render "$file"
  else
    echo "No cheatsheet for frontmost app: ${slug:-unknown}"
    echo ""
    list_available
  fi
  exit 0
fi

# Argument that names a sheet wins, exact match first, then unique prefix.
file=$(path_for_slug "$QUERY")
if [ -z "$file" ]; then
  matches=$(sheets | awk -F'\t' -v q="$(echo "$QUERY" | tr '[:upper:]' '[:lower:]')" \
    'tolower($1) ~ "^" q { print $2 }')
  [ "$(echo "$matches" | grep -c .)" -eq 1 ] && file="$matches"
fi

if [ -n "$file" ]; then
  render "$file"
  exit 0
fi

# Otherwise treat it as a search term across every sheet.
if ! search_all "$QUERY"; then
  echo "Nothing matching '$QUERY'."
  echo ""
  list_available
fi
