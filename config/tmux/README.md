# tmux quick-start

tmux keeps terminal sessions alive after you close the window, and lets you split a single terminal into multiple panes and windows. Ghostty auto-attaches to the `main` session on launch.

## When to use it

| Situation | Why tmux helps |
|---|---|
| Long-running processes (builds, servers, watchers) | Keep them running after closing the terminal |
| SSH sessions | Detach and re-attach without losing your shell state |
| Multiple contexts at once | Switch between windows without losing each one's working directory |
| Anything you'd hate to accidentally close | It persists across Ghostty restarts |

## Key bindings

All commands are prefixed with `Ctrl+B` (the leader key), then the key listed.

### Sessions

| Keys | Action |
|---|---|
| `Ctrl+B d` | Detach — leave session running in background |
| `tmux ls` | List running sessions (from any shell) |
| `tmux attach -t main` | Re-attach to a named session |

### Windows (tabs)

| Keys | Action |
|---|---|
| `Ctrl+B c` | New window (opens in current directory) |
| `Ctrl+B [0-9]` | Jump to window by number |
| `Ctrl+B n / p` | Next / previous window |
| `Ctrl+B ,` | Rename current window |
| `Ctrl+B &` | Close current window |

### Panes (splits)

| Keys | Action |
|---|---|
| `Ctrl+B \|` | Split horizontally |
| `Ctrl+B -` | Split vertically |
| `Ctrl+B h/j/k/l` | Move between panes (vim-style) |
| `Ctrl+B z` | Zoom current pane to full screen (toggle) |
| `Ctrl+B x` | Close current pane |

### Copy mode

| Keys | Action |
|---|---|
| `Ctrl+B [` | Enter copy mode (scroll with arrow keys or `j/k`) |
| `v` | Start selection |
| `y` | Copy selection and exit |
| `q` | Exit copy mode |

### Other

| Keys | Action |
|---|---|
| `Ctrl+B r` | Reload config |
| `Ctrl+B ?` | Show all key bindings |

## Typical workflow

```
# Ghostty opens → already in tmux session "main"

# Start a dev server in one window
Ctrl+B c          # new window
npm run dev

# Open a second window for git/editor work
Ctrl+B c
zed .

# Split the second window for running tests alongside
Ctrl+B -
npm test --watch

# Close Ghostty — session keeps running
# Re-open Ghostty — back exactly where you left off
```
