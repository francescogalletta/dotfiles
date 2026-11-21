eval "$(/opt/homebrew/bin/brew shellenv)"

# ~/.local/bin for login shells too (Kontroll, Hermes Agent); zshrc adds it for interactive ones
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac
