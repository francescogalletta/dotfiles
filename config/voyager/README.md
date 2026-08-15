# ZSA Voyager

Layout lives in Oryx (id `JmV6W`): https://configure.zsa.io/voyager/layouts/JmV6W/latest/0

Oryx is the editor; this directory versions the layout and documents OS-portability decisions.

## Versioning

`./pull-layout.sh` fetches the latest layout revision from Oryx's GraphQL API into `layout.json`. Run it after saving changes in Oryx, commit the diff. Oryx keeps its own server-side revision history; this snapshot is the copy we own, reviewable in git like every other config.

If the layout ever needs custom QMK (key overrides, `os_detection`), graduate to ZSA's [oryx-with-custom-qmk](https://blog.zsa.io/oryx-custom-qmk-features/) GitHub Actions flow; that repo then becomes the source of truth and this snapshot can retire.

## Kontroll

CLI control of the keyboard via Keymapp's API. Installed by `install.sh` (binary from [zsa/kontroll](https://github.com/zsa/kontroll) releases into `~/.local/bin`); Keymapp itself comes from the Brewfile.

**Resolved (2026-08-08): macOS socket-path bug.** The sandboxed Keymapp build bound its unix socket at `~/Library/Containers/io.zsa.keymapp/.../keymapp.sock` — 105 chars for user `francesco`, over macOS's 104-char socket path limit, so bind failed with `invalid argument` (Keymapp ≤1.3.7 sandboxed; HOME-symlink and de-sandboxing workarounds tried and abandoned 2026-07-31). Fix, per ZSA support (email, 2026-08): install Keymapp directly from [zsa.io/flash](https://www.zsa.io/flash) — that build ships without the sandbox entitlement, so the socket lands at `~/Library/Application Support/.keymapp/keymapp.sock` (63 chars) and the API binds fine. Verified: `kontroll status` reports Keymapp 1.3.7.

Note on brew: the manual install replaced the brew-managed copy, so `brew list --cask keymapp` now says not installed. The cask fetches ZSA's official artifact, so the Brewfile entry stays correct for fresh machines; on this one, `brew install --cask --adopt keymapp` re-adopts the existing app if drift ever bothers `brew bundle`. That adopt needs `sudo` (it chmods the already-installed bundle), so it has to be run by hand; verified 2026-08-15 that the cask URL is ZSA's own CDN (`oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.dmg`), i.e. the same artifact zsa.io/flash serves, so a fresh machine gets the working non-sandboxed build straight from `brew bundle`.

One-time setup: open Keymapp → settings → enable the API, turn on auto-connect, and set Keymapp to launch at login. Verified 2026-08-15: both are already on in this machine's Keymapp config (`api_enabled=1`, `startup_autoconnect=1` in `~/Library/Application Support/.keymapp/keymapp.sqlite3`), and Keymapp was added as a hidden login item so it starts each boot.

**Auto-connect only fires when Keymapp launches**, not on hotplug. Plug the board into an already-running Keymapp and the API answers but reports no keyboard. Use the `kb` shell function (defined in `zshrc`) — it attaches to the first detected board and prints status, and is a no-op when already connected. Manual equivalent: `kontroll connect -i <n>` with the index from `kontroll list`. Then:

```bash
kontroll status            # connected keyboard + current layer
kontroll list              # known keyboards
kontroll set-layer -i 7    # activate PC layer
kontroll set-layer -i 0    # back to Mac base
```

## PC layer (Windows/Linux machines)

Built 2026-08-08 as layer 7 "PC" (firmware revision `XbQP69`). Base layer assumes macOS; layer 7 overrides the keys below and leaves everything else transparent, so Hyper, home-row mods, and layer access fall through. It serves both Windows and Linux (GUI = Win key or Super). The board resets to base on unplug, so each PC machine runs `kontroll set-layer -i 7` at login (`windows/install.ps1` when it lands; on Linux a udev rule can do it per-plug); fallback without kontroll: double-tap toggles on the two top-left Media-layer keys (double-tap second key → PC, double-tap first key → Main).

| Key (current Main assignment) | Mac sends | PC layer sends |
|---|---|---|
| Left thumb Cmd key | LGUI tap/hold | **LCtrl tap/hold** |
| `W` hold | Cmd+W | **Ctrl+W** |
| `Z` hold | Cmd+Z | **Ctrl+Z** |
| `X` hold | Cmd+X | **Ctrl+X** |
| `C` hold | Cmd+C | **Ctrl+C** |
| `V` hold | Cmd+V | **Ctrl+V** |
| `Esc` (no hold today) | — | **hold = LGUI** (deliberate Win key: Win+L, Win+V, snapping) |

Already portable, no changes needed: home-row Hyper on `A`/`;` (Ctrl+Alt+Shift+Win is collision-free on Windows; re-register the same Raycast hotkeys), home-row Ctrl/Alt/Shift on `S`/`D`/`F`/`J`/`K`/`L`, Nav layer arrows + Home/End/PgUp/PgDn, Nav layer Ctrl+Tab / Ctrl+Shift+Tab tab switching.

Known residue (fix in a v2 "PC Nav" layer only if it hurts after a week):

- Nav `Cmd+Tab` / `Cmd+Shift+Tab` (app switcher) arrive as Win+Tab / Win+Shift+Tab on Windows — Task View, usable but not Alt+Tab.
- Nav screenshot keys `Cmd+Shift+3/4/5` arrive as Win+Shift+3/4/5, which launches taskbar apps. Windows wants Win+Shift+S.
- v2 approach: clone Nav as layer 8 with Alt+Tab and Win+Shift+S at those positions, and on the PC layer redefine `N` as tap N / hold MO(8) so the PC base reaches the corrected Nav. Same pattern for Nav Mous (`B` hold) if needed.
