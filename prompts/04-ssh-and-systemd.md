# 04 — SSH runner and systemd manager

**Context.** Brief (00) loaded, prompts 01 to 03 done.

## Prompt

Add the plugin mechanism and the first two plugins.

**Plugin interface.** A plugin has a name, init (returns a command), update, view, set-size,
and a way to say it is in a modal state, so the host can leave `esc` to the plugin while a filter
or prompt is open. Plugins get the selected server's SSH client. `s`, `v` and `f` open them from
the overview or the dashboard; `esc` closes. If the selected server is offline, opening a plugin
shows a message instead.

**SSH runner (`s`).** An input line with a `$ ` prompt and a scrollable output area. Each command
runs in a new session, but the working directory and shell aliases persist:

- Wrap the command in a script that `cd`s to the stored directory, enables alias expansion, replays
  the stored `alias -p`, runs the command, and prints the final `$PWD` and `alias -p` after unique markers.
  Parse the markers off the end of the output; if they are missing (the command called `exit`) keep the
  old state.
- Up and down browse command history, remembering the half-typed line when browsing starts.
- `ctrl+r` starts reverse search; typing narrows, `ctrl+r` again finds the next older match, `enter`
  accepts and runs, `esc` or `ctrl+g` cancels.
- `tab` completes the last word as a remote path using plain `sh` (no `compgen`, so it works on busybox);
  directories get a trailing slash; a single match completes, several complete the common prefix.
- Page up/down scroll the output; every other key goes to the input.
- Say clearly in the empty state that interactive programs are not supported.

**Systemd manager (`v`).** Table of `systemctl list-units --all --no-pager --no-legend --plain`
(unit, load, active, sub, description). `r` reloads the list; `s`, `x`, `t` start, stop, restart the
selected unit with `sudo systemctl <action> -- '<quoted unit>'` and refresh the list. Show errors in a
status line; keep a position indicator ("3 of 41 units").

**Rules.** Every interpolated value is quoted with the shared function and preceded by `--`.

## Acceptance checks

- `cd /var/log` then `pwd` in two separate commands prints `/var/log`. Define `alias ll='ls -l'`, then `ll` works.
- A command that fails shows its output and does not lose the working directory; `exit` does not break
  the next command.
- Reverse search finds a command from ten entries ago with the right number of `ctrl+r` presses.
- Tab completion on a path with a space and on a path that starts with `~`.
- Restart a harmless unit (a test service) and see its state change; try it on a unit whose name contains
  a quote (a crafted test unit file) and confirm nothing else runs.
