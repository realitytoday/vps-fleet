# vps-fleet — a blueprint for your own server cockpit

*Deutsche Kurzfassung: [README.de.md](README.de.md)*

**Your whole server fleet in one terminal window.** A fast, keyboard-driven terminal UI
for people who run a handful of VPS and are tired of juggling SSH tabs: live health of
every server, a dashboard with trends and a top-style process list, a command runner, a
systemd manager and a two-pane file manager, all over plain SSH with nothing installed
on the servers.

```
  vps-fleet v0.1.0 · default            web-1 [203.0.113.10]                  2 servers · 2 online
 ─────────────────────────────────────────────────────────────────────────────────────────────────
  NAME              STATUS     CPU         MEM         DISK        LOAD   UPTIME   ALERTS
 ────────────────────────────────────────────────────────────────────────────────────────────
 ▌web-1             ● online   ████░  82%  █████  97%  █░░░░  23%  0.42   6d 4h    mem high    ▐
  db-1              ● online   █░░░░  12%  ██░░░  41%  ███░░  60%  0.05   6h 13m   reboot 12 upd
```

I built it in a few days in September 2026, working with AI coding agents. This repository
is **the prompt**: the idea, the architecture, the rules and the ordered build briefs that
produced it. It is what I would hand to a friend who wanted their own version, tuned to
their own servers. The result of following it is published separately as the reference
implementation: **[vps-fleet-tui](https://github.com/realitytoday/vps-fleet-tui)** (Go, MIT).

- the **idea** and what it deliberately does not do ([docs/01-concept.md](docs/01-concept.md))
- the **architecture** and the reasoning behind it ([docs/02-architecture.md](docs/02-architecture.md))
- the **screens and key map** ([docs/03-ux-and-keys.md](docs/03-ux-and-keys.md))
- the **lessons learned**: every trap in remote-shell parsing and SSH ([docs/04-lessons-learned.md](docs/04-lessons-learned.md))
- the **prompts** to build it with your own coding agent ([prompts/](prompts/README.md))
- **reference material**: the remote shell snippets and an example config ([reference/](reference/README.md))

## Why a blueprint next to the code

The code is on GitHub and you can simply use it. But a tool like this is cheap to generate
and personal to fit: your servers run Debian, Alpine or Rocky, you want Wireguard
management or Docker instead of systemd, you prefer other keys. A precise description of
*what* to build, *why* each decision was made and *where it breaks* transfers better than
code, and your agent can adapt it. The prompts are the actual briefs and constraints I used
and refined.

## How to use this

1. Read the concept and architecture docs (10 minutes).
2. Decide which pieces you want. Everything after prompt 03 (SSH runner, systemd, file
   manager, profiles) is optional.
3. Put [prompts/00-project-brief.md](prompts/00-project-brief.md) into a new repo as
   `CLAUDE.md` / `AGENTS.md` and fill in the placeholders.
4. Work through prompts 01 to 06 in order, one per session, verifying each against its
   acceptance checks on a real server before moving on.
5. Keep a decision log from day one.

## What you need

| | |
|---|---|
| Language | Go (the prompts assume a recent toolchain), a terminal with truecolor |
| Servers | Any Linux box reachable over SSH. Debian and Ubuntu work best; Alpine falls back to simpler output |
| Server tools | `top`/`ps` (procps), GNU `find`, `df`, `free`, `systemctl` for the richer views |
| Skills | Comfortable with a terminal and SSH keys; the agent does the coding |

## Status

Version 0.1, used daily. Some pieces are deliberately unfinished (full interactive
terminal, directory copy, a WireGuard plugin, a help overlay). They are listed in the
architecture doc.

## Licence

Dual licence. Text and prompts (`README`, `docs/`, `prompts/`): [CC BY 4.0](LICENSE-docs.md). Code and configuration under `reference/`: [MIT](LICENSE). Use them, adapt them, tell me what you built.
