# AeroSpace Cheatsheet

Source of truth: `aerospace.toml`. Update this file when bindings change.

## Focus & move (vim keys: h←  j↓  k↑  l→)

| Keys | Action |
|---|---|
| `alt h/j/k/l` | Focus window left / down / up / right |
| `alt shift h/j/k/l` | Move window (restructures the tree) |

## Workspaces

| Keys | Action |
|---|---|
| `alt 1..9` | Go to workspace |
| `alt shift 1..9` | Send window to workspace (you stay) |
| `alt tab` | Bounce between last two workspaces |
| `alt shift tab` | Move whole workspace to next monitor |

## Layout

| Keys | Action |
|---|---|
| `alt slash` | Flip split horizontal ↔ vertical (tiles) |
| `alt comma` | Accordion layout (windows overlap with peek edges) |
| `alt f` | Fullscreen |
| `alt shift f` | Float / un-float window |
| `alt minus` / `alt equal` | Shrink / grow window by 50px |
| `alt enter` | New Ghostty window (from anywhere) |

## Resize mode — `alt r` to enter

| Keys | Action |
|---|---|
| `h` / `l` | Narrower / wider |
| `k` / `j` | Shorter / taller |
| `b` | Balance all splits evenly |
| `enter` / `esc` | Back to normal |

## Service mode — `alt shift ;` to enter

| Keys | Action |
|---|---|
| `r` | Flatten layout tree (fix a tangled mess) |
| `f` | Float / un-float (same as `alt shift f`) |
| `backspace` | Close all windows except focused |
| `alt shift h/j/k/l` | Join with window in that direction (nest) |
| `esc` | Reload config, back to normal |

## Mental model

Every workspace is a **tree** of splits, not a grid. `alt slash` flips a
split, `alt shift h/j/k/l` moves a leaf through the tree, join-with wraps
two windows into a sub-container. Lost? Flatten (`alt shift ;` then `r`)
and rebuild.
