# 05 — File manager

**Context.** Brief (00) loaded, prompts 01 to 04 done.

## Prompt

Add a two-pane file manager as a plugin (`f`): local files on the left, the selected server on the right.
It must work on servers without an SFTP subsystem, using shell commands over SSH.

**Listing.** Remote: one `find . -mindepth 1 -maxdepth 1 -printf` with tab-separated type, target type,
size, mode string, modified time, name, link target, owner, group and octal mode. Local: the OS API.
Folders first, then names (case-insensitive). Show size, mode, owner and modified time; symlinks with
their target. Hidden files off by default (`a` toggles). Each pane remembers its own path, starting at
the user's home.

**Navigation.** `tab` switches panes. `enter` or `right` opens a folder or shows a file in a viewer
(first 64 KB, scrollable, `esc` closes). `backspace` or `left` goes up. `~` goes home, `r` refreshes.
`/` filters the current folder as you type. `p` or `.` opens a path input with live tab completion and
jumps there.

**Transfers.** `t` or `f5` copies the selected file to the other pane's folder: local to remote uses
Upload, remote to local uses Download (both from prompt 01). Show a progress bar with bytes and rate;
if the target exists, ask `y/n` before overwriting. Only one transfer at a time; starting another says
to wait. Writing to a temporary `.part` file and renaming on success is part of the contract (for downloads as well as uploads), so a failed
transfer never leaves a truncated file. Copying a folder says "not supported yet".

**Changes.** `x` or `delete` deletes after `y/n` (remote: `rm -f -- <quoted>`; folders only if empty;
non-empty folders are refused on purpose so one key press cannot wipe a tree). `m`, `o`, `g` open an input for chmod, chown and chgrp (server side only; on the local pane
say so) and run `<cmd> -- <quoted value> <quoted path>`. Refresh after each change.

**Rules.** Every remote path and every user-typed value is quoted and preceded by `--`. Typed paths
starting with `~` keep `"$HOME"` outside the quotes. Prompts and filters set the plugin's modal flag.

## Acceptance checks

- Upload a 200 MB file and download it again: checksums match; abort halfway (kill the network) and
  verify no file under the real name exists on the destination, only an eventual leftover part file that
  the next attempt overwrites.
- A remote file named `$(touch pwned).txt` and one named `-rf` can be viewed, copied and deleted without
  side effects.
- Overwrite prompt appears for an existing target and `n` keeps the old file untouched.
- chmod 600 on a remote file shows `-rw-------` after the refresh; `chown` as a non-root user shows the
  shell's error text, without noise prefixes.
- Works on a server with the SFTP subsystem disabled in `sshd_config`.
