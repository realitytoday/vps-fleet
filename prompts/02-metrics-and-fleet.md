# 02 — Metrics and fleet overview

**Context.** Brief (00) loaded, prompt 01 done.

## Prompt

Add the metrics layer and the fleet overview.

**Metrics script.** One shell script, run in one SSH session per poll, printing one prefixed
line per metric: uptime, memory (used,total bytes), root filesystem (used,total bytes via
`df -Pk`, counted from the right), two samples 0.5 s apart of `/proc/stat` for CPU, whole-disk
bytes read and written from `/proc/diskstats`, network bytes in and out from `/proc/net/dev`
(excluding `lo`, `veth*`, `docker*`, `br-*`, `virbr*`), `/proc/uptime` as the clock for both
samples, load averages, core count, number of failed systemd units, whether `/var/run/reboot-required`
exists, and the OS pretty name from `os-release` sourced in a subshell. `reference/remote/metrics.sh`
is the target. Parse by prefix. Counters that go backwards report zero. If the I/O counters
cannot be read, mark the sample as having no I/O instead of failing.

**Update counter.** A second, slow command that counts pending package updates without touching
the network: `apt-get -s upgrade`, `dnf -C check-update`, or `apk -u list`, and `-1` if none of them
exists. See `reference/remote/updates.sh`.

**Model state.** Per server, keyed by ID: last error, last update time, in-flight flag, 60
samples of CPU and memory history, pending updates and when they were checked. A 5-second tick
starts a fetch for every server without one in flight. Updates are fetched every 10 minutes.

**Health and alerts.** Derive health (offline, connecting, stale after 30 s, online) and the
alert lists exactly as the brief says. Critical alerts first.

**Fleet overview.** A table with name, host, status, CPU, MEM, DISK, load, uptime and alerts;
usage as gradient bars with the percentage. A card view as an alternative (`d`). Groups, if any
are configured, appear as sections (alphabetical, ungrouped last). Live filter (`/`) over name,
host and group. Sorting (`o`) cycles config order, name, id, status, CPU, MEM, DISK. Header with
logo, profile, selected server and a summary ("3 servers · 2 online · 1 alerting"). Footer with
key hints. In a terminal wide enough, show a details panel beside the table for the selected server.

**Out of scope.** The dashboard screen itself (prompt 03).

## Acceptance checks

- Table tests for every parser, using captured output from {{DISTROS}}, including a busybox `df`
  and a locale with decimal commas where relevant.
- Against {{SERVERS}}: numbers match `htop`, `df -h` and `free` within a few percent. A powered-off
  server shows offline with the SSH error, and recovers by itself when it is back.
- Block a server's network for 40 seconds: it turns stale, then offline, then online again.
- Alerts: fill a test filesystem past 90 %, stop a unit so it fails, create `/var/run/reboot-required`:
  each alert shows and clears.
- Resize between 80 and 160 columns: no overlapping or truncated headers; the details panel
  appears only when it fits.
