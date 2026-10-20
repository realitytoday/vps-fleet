# Prompts

Seven briefs to give your coding agent, in order. They describe *what* and *why* and give
*acceptance checks*. They deliberately do not dictate code, so the agent adapts to your setup.

| # | File | Builds |
|---|---|---|
| 00 | [00-project-brief.md](00-project-brief.md) | The drop-in `CLAUDE.md` / `AGENTS.md`: settled decisions, read every session |
| 01 | [01-foundation-and-ssh.md](01-foundation-and-ssh.md) | Module, config and profiles, SSH client with host keys, quoting helper |
| 02 | [02-metrics-and-fleet.md](02-metrics-and-fleet.md) | Metrics script and parser, fleet overview, health, alerts, sorting, filter |
| 03 | [03-dashboard-and-processes.md](03-dashboard-and-processes.md) | Dashboard with trends, process list, top view, kill dialog |
| 04 | [04-ssh-and-systemd.md](04-ssh-and-systemd.md) | Plugin interface, command runner, systemd manager |
| 05 | [05-file-manager.md](05-file-manager.md) | Two-pane file manager with transfers |
| 06 | [06-profiles-settings-release.md](06-profiles-settings-release.md) | Profiles, settings, README, licence, release checklist |

## Placeholders

Replace before use:

- `{{TOOL_NAME}}`: the name of your binary and config directory (mine is `vps-fleet`)
- `{{MODULE}}`: your Go module path
- `{{SERVERS}}`: two or three real test servers (host, user, key path), kept out of the repo
- `{{DISTROS}}`: the Linux distributions your servers run
- `{{GROUPS}}`: server groups you want in the overview (for example `prod`, `home`)

## How to work with an agent on this

1. **One prompt per session.** Start each with the brief (00) loaded.
2. **Ask for a plan first**, then approve it.
3. **Make the agent verify.** Every prompt ends with acceptance checks. Run them yourself
   against a real server, not just in the agent's sandbox.
4. **Log decisions** into a `HISTORY.md` as you go.
5. **Do not skip a slice.** Later prompts assume the earlier ones exist.
6. **Never paste real credentials or host lists into a prompt.** Keep `config.yaml` out of the repo.

## Prompting style that worked

- State constraints as rules with reasons ("quote every remote value: file names come from
  the server and can contain anything").
- Name the failure mode you already know about. Agents repeat known mistakes unless told.
- Say what is out of scope. "No full terminal" prevents an agent from building a terminal emulator.
- Ask for the smallest vertical slice that proves the next layer.
