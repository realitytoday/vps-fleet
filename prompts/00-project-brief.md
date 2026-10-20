# Project brief (save as CLAUDE.md or AGENTS.md)

# {{TOOL_NAME}}

A keyboard-driven terminal UI that shows a fleet of Linux servers in one window and
manages them over plain SSH. Overview of health and alerts, a dashboard with trends and a
top-style process list, a command runner, a systemd manager and a two-pane file manager.

This file is project memory: the settled decisions that shape how code gets written. Keep it
short. Open work goes in `docs/TODO.md`; reasons and incidents go in `docs/HISTORY.md`.

## Principles

- **Agentless.** Nothing is installed on the managed servers. No daemon, exporter or open port.
  Everything is a shell command over SSH.
- **Problems first.** The overview exists to surface trouble; healthy servers stay quiet.
- **Keyboard only.** One key per action; the footer always shows what is available.
- **A cockpit, not a monitoring system.** No history when closed, no alerting, no database, no web UI.

## Tech stack (settled)

| Layer | Choice | Why |
|---|---|---|
| Language | Go | One static binary, cross-compiles, good SSH library |
| TUI | Bubble Tea, Bubbles, Lip Gloss | Message-driven updates suit many servers answering asynchronously |
| SSH | `golang.org/x/crypto/ssh` | No dependency on the `ssh` binary |
| Config | YAML (`gopkg.in/yaml.v3`) | Readable, fixable by hand |
| Layout | `cmd/`, `internal/{config,vps,plugins,ui,theme}` | Plugins and UI stay separate from SSH |

## Security rules (not negotiable)

- **Verify host keys.** Check `~/.ssh/known_hosts` and the tool's own `known_hosts`. Unknown
  host: remember it (trust on first use). Changed key: refuse and name the file to edit.
  `InsecureIgnoreHostKey` must never appear in the code.
- **Quote every remote value** with one POSIX single-quote function and put `--` before it.
  This includes file names and unit names that came from the server.
- **Credentials.** Keys are the default; `password` is allowed but documented as plain text.
  Config and settings files are written 0600 in a 0700 directory, and existing files are chmod-ed.
- Nothing from a real server list (names, IPs, key paths) appears in the repo, README or tests.
  Use `web-1`, `db-1`, and the documentation range 203.0.113.0/24.

## Behaviour rules

- **Never block the update loop.** Every SSH call is a command that returns a message.
- **One long-lived SSH connection per server, one session per command.** If a session cannot be
  opened, close the connection; the next call reconnects. Dial timeout 5 seconds.
- **Poll every 5 seconds.** Keep 60 samples of CPU and memory per server. A server with no success
  for 30 seconds is "stale"; a failed fetch is "offline"; before the first result it is "connecting".
- **Alerts:** critical at 90 % disk or memory and on failed systemd units; warning for load above
  core count, reboot required and pending updates. Updates are checked every 10 minutes, offline-safe.
- **One shell script per poll, one prefixed line per metric,** parsed by prefix. Second `top`
  frame only. Counters that go backwards report 0.
- **Runtime state is keyed by server ID** so a config reload keeps it and never leaves dangling pointers.
- Layouts must work at 80, 100, 120 and 160 columns and in a short terminal.

## Out of scope

Windows servers, agents, a database, a web UI, alerting while closed, a full interactive
terminal, configuration management.

## Conventions

- `go build ./...`, `go vet ./...` and `gofmt -l .` clean before every commit.
- Code, comments and commit messages in English.
- Parsing functions are pure and have table tests with captured output from at least two
  distributions ({{DISTROS}}).

## Comments

Default to none. Write one only when the code cannot say it: a non-obvious constraint, a
bug workaround, a reason a naive approach would fail. Never restate the identifier.
