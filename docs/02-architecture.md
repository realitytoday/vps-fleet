# 02 — Architecture

## Stack (settled)

| Layer | Choice | Why |
|---|---|---|
| Language | Go | One static binary, easy cross-compiling, good SSH library |
| TUI | Bubble Tea (Elm architecture), Bubbles, Lip Gloss | Message-driven updates fit "many servers answering whenever they like" |
| SSH | `golang.org/x/crypto/ssh` | No dependency on the system `ssh` binary, works the same on Windows |
| Config | YAML, one file per profile, `gopkg.in/yaml.v3` | Readable and fixable by hand |
| Remote work | Plain shell commands over SSH | Agentless; works without an SFTP subsystem |

## Layout

```
cmd/<binary>/main.go        flags, load profile and settings, start the program
internal/config             config.yaml, profiles/, settings.yaml, paths
internal/vps                server model, SSH client, metrics, process list, host keys
internal/plugins            plugin interface; ssh, systemd, sftp (file manager)
internal/ui                 model, fleet table/cards, dashboard, top, kill dialog,
                            profiles, settings, header, footer, styles
internal/theme              the one user-configurable thing: bar gradient colours
```

## Data flow

A 5-second tick triggers a metrics fetch for every server that has none in flight. Each
fetch is one SSH session running one shell script and returns one message. The model
stores the latest metrics per server plus runtime state keyed by server ID (so it survives
a config reload): last error, last update time, 60 samples of CPU and memory history,
pending-updates count.

- **Health** is derived: offline (last fetch failed), connecting (no data yet), stale (no
  success for 30 seconds), online.
- **Alerts** are derived from the metrics: critical (failed systemd units, disk or memory
  at 90 % or more) and warning (load above core count, reboot required, pending updates).
- **Pending updates** are checked separately, every 10 minutes, because they are slow.
- **The process list** is fetched only while a dashboard or the top view is open, at most
  every 4 seconds, and never while a fetch is in flight.

## One connection per server

Each server has one long-lived SSH connection. Every command opens a new *session* on it,
so concurrent commands (metrics poll, tab completion, a file listing) never block each
other. If opening a session fails the connection is considered dead, closed, and the next
call reconnects. The connection timeout is 5 seconds.

## The metrics script

One shell script prints one prefixed line per metric (`U:`, `M:`, `D:`, `S1:` …) and the
parser reads by prefix, not by position. CPU comes from two `/proc/stat` samples 0.5 s
apart, disk and network throughput from `/proc/diskstats` and `/proc/net/dev` sampled
around the same sleep, using `/proc/uptime` as the clock. Whole disks only (no partitions,
loop or device-mapper), all interfaces except loopback and container bridges. The script is
in `reference/remote/metrics.sh`.

## The process list

`top -b -n 2 -d 0.5 -c -w 512` and keep only the **second** frame; the first frame's CPU is
averaged since process start and misleading. Fall back to `ps` where procps `top` is missing
(busybox); its CPU is a lifetime average and the UI should not pretend otherwise.

## Security model

- **Host keys are verified.** Check `~/.ssh/known_hosts` and the tool's own `known_hosts`.
  First sight of a host: remember it (trust on first use, like `StrictHostKeyChecking=accept-new`).
  Key changed: refuse, with an error that names the file to edit if the change was intended.
- **Credentials.** Key files are the default. A `password` field exists but is plain text in
  the config; the README says so. Config files are written with mode 0600 in a 0700 directory.
- **Shell quoting.** Anything interpolated into a remote command is quoted with a POSIX
  single-quote function (`'` becomes `'\''`) and preceded by `--`. This includes file names
  and unit names that came from the server.
- **No sudo by default.** Only the systemd actions use `sudo`.

## Plugins

A plugin has a name, init, update, view, set-size and a way to say it is in a modal state
(so `esc` closes the filter, not the plugin). Plugins receive the selected server's SSH
client. Keys `s`, `v`, `f` open them from the fleet or dashboard.

## File transfer

Download streams a remote file through `cat -- 'path'`. Upload streams into
`path.part` and renames only on success; a failed upload removes the part file, so an
aborted upload never leaves a truncated file under the real name. A listing is one
`find … -printf` with tab-separated fields. No SFTP subsystem needed.

## Not built, on purpose or not yet

- WireGuard plugin, help overlay, systemd log viewing (planned)
- Full interactive terminal in the runner
- Directory copy in the file manager
- Alerts when the window is closed
