# 01 — Foundation and SSH

**Context.** Project brief (00) is loaded. This builds the skeleton and the SSH layer every
later prompt plugs into. No UI beyond a placeholder yet.

## Prompt

Create the Go module `{{MODULE}}` for `{{TOOL_NAME}}` with the layout from the brief.

**Config.** `~/.config/{{TOOL_NAME}}/config.yaml` holds a list of servers: `id`, `name`, `host`,
`user`, `port` (default 22), `keypath` (supports `~`), optional `password`, optional `group`.
A `profiles/<name>.yaml` directory holds more lists in the same format; `config.yaml` is the
profile `default`. `-p` / `--profile` selects one. A missing default config yields an empty
list and the program creates an example file on first start; a missing named profile is an
error that lists the available ones. Settings (bar colours, default kill signal, default sort
order) live in a separate `settings.yaml` with defaults for every field, so saving settings
never rewrites the server list. Write all files 0600 in directories 0700, and chmod existing files.

**SSH client.** One client per server with a long-lived connection and a mutex. `Run(cmd)`
opens a new session, returns combined output and the error. Connecting happens lazily on
first use. If opening a session fails, close the connection and drop it so the next call
reconnects. Add `Download(path, writer)` using `cat -- <quoted>` with stderr kept separate,
and `Upload(path, reader)` that writes to `<path>.part` and renames only when complete,
removing the part file on failure.

**Host keys.** Implement the verification described in the brief and the architecture doc:
`~/.ssh/known_hosts` plus the tool's own file, trust on first use, refuse changed keys with
a helpful error. Guard it with a mutex because several servers connect at once.

**Quoting.** One exported `ShellQuote` function and a unit test with nasty inputs: embedded
single quotes, `$(...)`, backticks, newlines, leading dashes, empty string.

**Entry point.** Parse flags, load the profile and settings, build the model, run the
program with the alternate screen. A placeholder model that lists server names is enough.

**Out of scope.** Any metrics, any real UI.

## Acceptance checks

- `go build ./...`, `go vet ./...`, `gofmt -l .` are clean; `ShellQuote` tests pass.
- Against a real server: `Run("echo ok")` works; killing the connection (restart sshd or
  drop the network briefly) and calling again reconnects.
- First connection to a new host adds a line to the tool's known_hosts; editing that line to a
  different key makes the next connection fail with the mismatch error; the file is 0600.
- Upload a file, then upload with a failing destination: no `.part` file is left behind.
- `config.yaml` and `settings.yaml` are 0600 after saving, even if they existed with 0644 before.
- `grep -rn InsecureIgnoreHostKey .` finds nothing.
