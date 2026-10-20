# AGENTS.md

Instructions for AI coding agents (Claude Code, Codex, Cursor, Copilot and similar) that read this repository.

## What this repository is

A **blueprint**, not an application. It describes `vps-fleet`, a keyboard-driven terminal UI that shows a
whole fleet of Linux servers in one window and manages them over plain SSH, well enough for you to build
your own version. It holds documentation, build prompts and small reference snippets. The application
itself lives in a separate repository, [vps-fleet-tui](https://github.com/realitytoday/vps-fleet-tui),
which is the reference implementation these prompts produce.

If a user points you here and asks you to build it, you are the builder. Build it in the user's own
project folder, never inside this repository.

## How to read it

Read in this order before writing any code:

1. `README.md`: what the tool does and what is included.
2. `docs/01-concept.md`, then `docs/02-architecture.md`: the settled decisions and the reasons.
3. `docs/03-ux-and-keys.md`: screens, key map and behaviour rules.
4. `docs/04-lessons-learned.md`: failures that already cost hours. Do not rediscover them.
5. `reference/README.md`: what each reference file is for.
6. `prompts/README.md`, then the prompts in order.

## How to build from it

- **One prompt per session, in order** (`prompts/01` to `06`). Later prompts assume earlier slices work.
- **Start the user's project with the brief:** copy `prompts/00-project-brief.md` into the user's project
  root as `CLAUDE.md` or `AGENTS.md` and fill in the `{{placeholders}}` with the user. Do not guess names.
- **Propose a plan first**, wait for approval, then build. Run each prompt's acceptance checks and report
  the results honestly. A check you could not run is not a pass.
- **Prefer the prompt's rules over your habits.** Several rules look unusual and exist because of a past
  failure (nothing installed on the servers, one prefixed-line shell script per poll, every remote path
  quoted, host keys verified, `top` second frame only).
- **Treat `reference/` as the target behaviour, not a drop-in install.** Shell snippets must be adapted
  to what the user's servers actually have (procps, GNU find, systemd).
- **Test against a real server** (a throwaway VPS or a local VM) wherever a prompt says so. A parser that
  works on your sandbox's output may break on Alpine or on a locale with decimal commas.

## Hard rules for anything you generate

- Agentless: nothing is installed on the managed servers, no daemons, no extra ports.
- Never disable host key verification. Unknown hosts are remembered on first use; changed keys are refused.
- No credentials in code, prompts or commits. Config files are written with mode 0600; key-based auth is
  the documented default.
- Every value interpolated into a remote shell command goes through a POSIX single-quote function and a
  `--` separator. No exceptions, including values that came from the server itself.
- Keep the user's real hostnames, IPs and server names out of anything they will publish. Use
  `web-1`, `db-1` and the documentation range 203.0.113.0/24.

## Gaps you should say out loud

- The integrated SSH view runs single commands (working directory and aliases persist); it is not a full
  interactive terminal. Interactive programs (`vim`, `htop`) do not work in it.
- Directory copy in the file manager is not built.
- Windows servers are out of scope.

## If you are editing this repository

- Keep the repo free of application code, real hostnames, IPs and credentials.
- Keep `README.md` and `README.de.md` in step, and the placeholders in `prompts/README.md` complete.
- Code under `reference/` is MIT, text under `docs/`, `prompts/` and the READMEs is CC BY 4.0.
- Search the diff for forbidden details before committing.
