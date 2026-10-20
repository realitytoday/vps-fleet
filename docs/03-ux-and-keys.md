# 03 — Screens and key map

Layout is three zones: header (logo, active profile, selected server, fleet summary),
body, footer (key hints for the current screen, plus a status line).

## Colours

A small fixed palette: lime for the selected row and title, cyan for headers, green,
yellow and red for state, dark grey for secondary text. Usage bars and trend lines use one
gradient that the user can change (default, greyscale or custom start/end hex). Trend
lines use the same colours as the bars, blended 30 % towards black so they read as secondary.
Colour means state; nothing is decorative.

## Fleet overview

- Columns: name, host, status, CPU, MEM, DISK, load, uptime, alerts. Table or card view
  (`d`). If groups are configured, servers are shown grouped (alphabetical, ungrouped last).
- Sorting (`o`) cycles: config order, name, id, status, CPU, MEM, DISK.
- Filter (`/`) matches name, host and group as you type; `enter` keeps it, `esc` clears it.
- Selecting a server in a terminal wide enough shows a details panel to the right of the
  table (needs room for the table plus at least 30 columns, up to 48).
- Status marker: online, connecting, stale, offline, each with its own colour. Offline rows
  show the SSH error.

## Dashboard (`enter`)

Gauges for CPU, memory and disk with 60-sample trend lines under CPU and memory; disk and
network throughput, load average with core count, OS, uptime, pending updates, last
update age. In a terminal at least 100 columns wide the process list sits to the right.

## Top view (`t`)

Full-screen process list: PID, user, CPU, MEM, RES, time, command. Summary line from `top`.
Sort by CPU or memory. `k` opens the kill dialog: PID and signal. The signal field accepts
a name (`TERM`, `sigkill`) or a number; left and right cycle through common signals
(TERM, HUP, INT, QUIT, KILL, USR1, USR2, STOP, CONT). Default signal is configurable.

## SSH runner (`s`)

Each command runs in a new session, but the working directory and shell aliases are
captured after every command (via markers appended to the script) and replayed before the
next. Up/down browse history, `ctrl+r` searches history (press again for older matches, `enter`
accepts and runs, `esc` cancels), `tab` completes remote paths (directories get a trailing
slash), page keys scroll output. Output is shown as text; interactive programs are not supported.

## Systemd (`v`)

Table of units (`systemctl list-units --all`). `r` reload, `s` start, `x` stop, `t` restart
the selected unit via `sudo systemctl <action> -- '<unit>'`. Result shows in the status line.

## File manager (`f`)

Two panes: local and server. `tab` switches pane, `enter`/`right` opens a folder or a file
viewer (first 64 KB), `backspace`/`left` goes up. `t` or `f5` transfers the selected file to
the other side with a progress bar; existing files ask `y/n` before overwrite. `x` or `delete`
deletes (confirm). `m` chmod, `o` chown, `g` chgrp (server side only), `a` shows hidden files,
`/` filters, `p` or `.` jumps to a path with live tab completion, `~` goes home, `r` refreshes.
Folders sort first. Copying whole folders is not supported yet.

## Global keys

| Key | Action |
|---|---|
| `↑/↓`, `j/k` | select |
| `enter`, `tab` | dashboard |
| `1` | fleet overview |
| `t` | top view |
| `s` `v` `f` | SSH, systemd, files |
| `/` | filter |
| `o` | sort |
| `d` | table or cards |
| `P` | profiles |
| `c` | settings |
| `ctrl+r` | reload config |
| `esc` | back |
| `q`, `ctrl+c` | quit |

## Profiles and settings

Server lists live in `~/.config/<tool>/config.yaml` (profile "default") and
`~/.config/<tool>/profiles/<name>.yaml`. `-p name` starts a profile, `P` switches.
Settings (`c`) are stored separately in `settings.yaml` so that saving them never rewrites
the server list: bar colours, default kill signal, default sort order. Reloading the config
(`ctrl+r`) must not crash or show stale data for a selected server.
