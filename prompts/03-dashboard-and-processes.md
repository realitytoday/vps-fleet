# 03 — Dashboard, process list and kill

**Context.** Brief (00) loaded, prompts 01 and 02 done.

## Prompt

Add the server dashboard, the process list and the top view.

**Dashboard (`enter`, `tab`, `2`).** Gauges for CPU, memory and disk (percentage, used and
total), with a trend line under CPU and memory built from the 60-sample history. A trend line
is one row of block characters (`▁▂▃▄▅▆▇`), coloured like the bar above it but blended about
30 % towards black. Also show disk and network throughput (human-readable per-second rates),
load average with core count, OS, uptime, pending updates and how long ago the last update arrived.
`esc` and `1` return to the overview. Moving the selection in the overview or the split view must
update the details immediately.

**Process list.** `top -b -n 2 -d 0.5 -c -w 512 -o <key>` keeping only the second frame, sorted by
CPU or memory; fall back to `ps -eo ... --sort=-<key> | head -n 200` where procps `top` is missing.
Parse PID, user, CPU, MEM, resident size, time and command, and the "Tasks:" summary line. Accept
decimal commas. Fetch only while a dashboard or top view is open, at most every 4 seconds, never
while a fetch is in flight, and record errors so a failing server is not retried in a tight loop.
In a terminal 100 columns or wider, show the list beside the dashboard.

**Top view (`t`).** Full-screen list with an htop-style summary line, sort by CPU or memory,
scrolling, and the selected row highlighted.

**Kill dialog (`k`).** A small modal with a PID field (prefilled with the selected process) and a
signal field (prefilled with the configured default). The signal field accepts a name with or
without `SIG` ("term", "SIGKILL") or a number; left/right cycle TERM, HUP, INT, QUIT, KILL, USR1,
USR2, STOP, CONT. Validate before sending: PID is digits only, signal must resolve. Run
`kill -s <SIG> <pid>`; show errors with the shell noise prefix stripped. Refresh the list afterwards.

**Rules.** The PID is an integer you formatted yourself; never pass raw text into the command.

## Acceptance checks

- Start `yes > /dev/null` on a test server: it appears at the top of the list within two refreshes
  with about 100 % CPU; kill it with the dialog using `TERM`, then again using the number `9`.
- Same process list on Debian and on Alpine (busybox fallback); the UI does not claim accurate CPU
  on the fallback.
- Selecting another server with the arrow keys while the dashboard is open updates every value
  and the process list.
- Typing `k` in the signal field, `-1`, `abc` or an empty PID is rejected with a clear message.
- Table tests for `parseTop` and `parsePS` on captured output, including a locale with decimal commas.
