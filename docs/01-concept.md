# 01 — Concept

## The problem

You run a handful of servers: a web box, a database, a VPN gateway, a few hobby VPS.
Checking them means one SSH tab each. Is anything full, overloaded, in need of a reboot,
running a failed service? Answering that takes ten tabs and ten commands. Monitoring stacks
(Prometheus, Grafana, Zabbix) answer it, but they are servers you must run, secure and
keep updated, and they are overkill for five machines.

## The idea

One terminal window shows every server's health at a glance, and the same window is
enough to fix what it shows: look at the live processes, kill the runaway one, restart the
service, move a file. Everything goes over the SSH access you already have.

## Principles

1. **Agentless.** If you can `ssh` into it, it can be managed. Nothing is installed on the
   servers: no daemon, no exporter, no open port. The cost is that every number comes from
   a shell command that runs on each poll, which is why the commands are designed carefully
   (see the architecture doc).
2. **Problems first.** The overview exists to surface trouble: failed units, full disks,
   high load, pending updates, required reboots. Healthy servers stay quiet.
3. **Two keys from overview to root cause.** Overview, dashboard, process list, kill.
4. **Everything you would SSH in for, built in.** Run a command, manage a service, move
   files. Not everything: no editor, no full terminal.
5. **Keyboard only.** One key per action; the footer always shows what is available. No
   mouse support is a feature.

## Screens

- **Fleet overview:** table or card view, optional groups, live filter, sorting, per-server
  health, load, uptime and alerts. In a wide terminal it splits into table plus details.
- **Server dashboard:** CPU, memory and disk gauges with five-minute trend lines, disk and
  network throughput, load average, OS and uptime, and a top-style process list beside it.
- **Top view:** full-screen process list with a summary line; send any signal to any process.
- **SSH runner:** commands with persistent working directory and aliases, history, reverse
  search, tab completion of remote paths.
- **Systemd manager:** list units, start, stop, restart.
- **File manager:** local and remote side by side, upload and download with progress, view,
  delete, chmod/chown/chgrp, filter, jump to a path with completion.
- **Profiles and settings:** separate server lists (work, home, customers), bar colours,
  default kill signal, default sort order.

## What it deliberately does not do

- No history or alerting when the window is closed. It is a cockpit, not a monitoring system.
- No agents, no database, no web UI, no accounts.
- No Windows servers.
- No full terminal emulator; interactive programs do not work in the runner.
- No configuration management or deployment. It looks and nudges, it does not orchestrate.

## Who it is for

Solo operators and small teams with 2 to 30 servers who live in a terminal. With 200
servers you want proper monitoring; with 2 you may not need this.
