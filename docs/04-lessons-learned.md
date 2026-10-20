# 04 — Lessons learned

The traps that cost hours. Give these to your agent up front.

## Remote shell parsing

- **Parse by prefix, not by position.** One script, one prefixed line per metric. Extra
  output (MOTD fragments, warnings) must not break parsing.
- **Never trust `top`'s first frame.** Its CPU is averaged since process start. Use `-n 2`
  and keep frame two.
- **Do not parse `top`'s summary CPU line for the fleet bar.** Use two `/proc/stat` samples:
  it is the same on every distribution.
- **`df` columns drift.** Use `df -Pk` and count used and size from the right, because the
  filesystem name can contain spaces.
- **Count each disk once.** Whole devices only: `sd*`, `vd*`, `xvd*`, `hd*`, `nvme*n*`,
  `mmcblk*`. Partitions, loop and `dm-*` double-count.
- **Skip virtual interfaces for network throughput:** `lo`, `veth*`, `docker*`, `br-*`, `virbr*`.
- **Counters wrap and reset.** If the second sample is smaller, report 0, not a huge number.
- **Decimal commas.** `top` in some locales prints `45,2`. Replace the comma before parsing.
- **`grep -c` exits 1 on a count of 0.** Treat "has output" as success, not the exit code.
- **Busybox is different.** `ps` options, no `compgen`, simpler `df`. Keep a fallback and
  say that it is less accurate.
- **Update counts must not touch the network.** `apt-get -s upgrade | grep -c '^Inst'`,
  `dnf -C check-update`. And they are slow, so poll them every ten minutes, not every five seconds.

## SSH

- **One connection, many sessions.** Opening a new connection per command is slow and gets
  you rate-limited by `fail2ban`.
- **A dead connection looks like a successful dial.** When opening a session fails, close the
  connection and reconnect on the next call.
- **Non-interactive shells ignore aliases.** Set `expand_aliases` and replay `alias -p`.
- **A new session starts in the login directory.** Capture `$PWD` after every command and
  `cd` to it before the next one. Handle the case where the command called `exit`.
- **Keep stderr out of downloaded data.** Stream stdout into the file and collect stderr
  separately for error messages.
- **Upload to a temporary name and rename.** An interrupted upload must never leave a
  truncated file under the real name.
- **Host key verification is not optional.** An early version used `InsecureIgnoreHostKey`;
  it was the first thing fixed before publishing. Use known_hosts with trust on first use.

## Quoting

- **Quote everything, including names that came from the server.** A file called
  `$(reboot).txt` on a server must not run on your next `rm`. Use one `ShellQuote` function
  and `--` everywhere.
- **Home directory needs special handling.** `~` must stay outside the quotes: `"$HOME"` plus the
  quoted rest.

## TUI

- **Never block the update loop.** Every SSH call is a command that returns a message.
- **Key state per screen.** Filter input, kill dialog and file-manager prompts each swallow
  keys; make "modal" an explicit flag so `esc` closes the right thing.
- **Reloading config must not leave dangling pointers.** Key runtime state by server ID and
  re-resolve the selected server after a reload.
- **Selection must follow navigation in every view,** including the split view; otherwise the
  dashboard shows the previous server.
- **Test layouts at several widths:** 80, 100, 120, 160 columns, and a very short terminal.
- **Truecolor matters.** The gradient bars look wrong on 256-colour terminals.
